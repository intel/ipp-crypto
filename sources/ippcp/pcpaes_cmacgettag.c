/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
* All Rights Reserved.
*
* If this  software was obtained  under the  Intel Simplified  Software License,
* the following terms apply:
*
* The source code,  information  and material  ("Material") contained  herein is
* owned by Intel Corporation or its  suppliers or licensors,  and  title to such
* Material remains with Intel  Corporation or its  suppliers or  licensors.  The
* Material  contains  proprietary  information  of  Intel or  its suppliers  and
* licensors.  The Material is protected by  worldwide copyright  laws and treaty
* provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
* modified, published,  uploaded, posted, transmitted,  distributed or disclosed
* in any way without Intel's prior express written permission.  No license under
* any patent,  copyright or other  intellectual property rights  in the Material
* is granted to  or  conferred  upon  you,  either   expressly,  by implication,
* inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
* property rights must be express and approved by Intel in writing.
*
* Unless otherwise agreed by Intel in writing,  you may not remove or alter this
* notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
* suppliers or licensors in any way.
*
*
* If this  software  was obtained  under the  Apache License,  Version  2.0 (the
* "License"), the following terms apply:
*
* You may  not use this  file except  in compliance  with  the License.  You may
* obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
*
*
* Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
* distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
* See the   License  for the   specific  language   governing   permissions  and
* limitations under the License.
*******************************************************************************/

/*
// 
//  Purpose:
//     Cryptography Primitive.
//     AES-CMAC Functions
// 
//  Contents:
//        ippsAES_CMACGetTag()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpcmac.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*F*
//    Name: ippsAES_CMACGetTag
//
// Purpose: computes MD value and could contunue process.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pMD == NULL
//                            pState == NULL
//    ippStsContextMatchErr   !VALID_AESCMAC_ID()
//    ippStsLengthErr         MBS_RIJ128 < mdLen <1
//    ippStsNoErr             no errors
//
// Parameters:
//    pMD      pointer to the output message digest
//    mdLen    requested length of the message digest
//    pState   pointer to the CMAC context
//
*F*/
IPPFUN(IppStatus, ippsAES_CMACGetTag,(Ipp8u* pMD, int mdLen, const IppsAES_CMACState* pState))
{
   /* test context pointer and ID */
   IPP_BAD_PTR1_RET(pState);
   /* use aligned context */
   pState = (IppsAES_CMACState*)( IPP_ALIGNED_PTR(pState, AESCMAC_ALIGNMENT) );

   IPP_BADARG_RET(!VALID_AESCMAC_ID(pState), ippStsContextMatchErr);
   /* test DAC pointer */
   IPP_BAD_PTR1_RET(pMD);
   IPP_BADARG_RET((mdLen<1)||(MBS_RIJ128<mdLen), ippStsLengthErr);

   {
      const IppsAESSpec* pAES = &CMAC_CIPHER(pState);
      /* setup encoder method */
      RijnCipher encoder = RIJ_ENCODER(pAES);

      Ipp8u locBuffer[MBS_RIJ128];
      Ipp8u locMac[MBS_RIJ128];
      CopyBlock16(CMAC_BUFF(pState), locBuffer);
      CopyBlock16(CMAC_MAC(pState), locMac);

      /* message length is divided by MBS_RIJ128 */
      if(MBS_RIJ128==CMAC_INDX(pState)) {
         XorBlock16(locBuffer, CMAC_K1(pState), locBuffer);
      }
      /* message length isn't divided by MBS_RIJ128 */
      else {
         PaddBlock(0, locBuffer+CMAC_INDX(pState), MBS_RIJ128-CMAC_INDX(pState));
         locBuffer[CMAC_INDX(pState)] = 0x80;
         XorBlock16(locBuffer, CMAC_K2(pState), locBuffer);
      }

      XorBlock16(locBuffer, locMac, locMac);

      #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
      encoder(locMac, locMac, RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
      #else
      encoder(locMac, locMac, RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
      #endif

      /* return truncated DAC */
      CopyBlock(locMac, pMD, mdLen);

      return ippStsNoErr;
   }
}
