/*******************************************************************************
* Copyright 2013-2019 Intel Corporation
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
//     AES-GCM
// 
//  Contents:
//        ippsAES_GCMGetTag()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcpaesm.h"
#include "pcptool.h"

/*F*
//    Name: ippsAES_GCMGetTag
//
// Purpose: Generates authentication tag in the GCM mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pDstTag == NULL
//                            pState == NULL
//    ippStsLengthErr         tagLen<=0 || tagLen>16
//    ippStsContextMatchErr  !AESGCM_VALID_ID()
//    ippStsNoErr             no errors
//
// Parameters:
//    pDstTag     pointer to the authentication tag.
//    tagLen      length of the authentication tag *pDstTag in bytes
//    pState      pointer to the context
//
*F*/
IPPFUN(IppStatus, ippsAES_GCMGetTag,(Ipp8u* pDstTag, int tagLen, const IppsAES_GCMState* pState))
{
   /* test State pointer */
   IPP_BAD_PTR1_RET(pState);
   /* use aligned context */
   pState = (IppsAES_GCMState*)( IPP_ALIGNED_PTR(pState, AESGCM_ALIGNMENT) );
   /* test state ID */
   IPP_BADARG_RET(!AESGCM_VALID_ID(pState), ippStsContextMatchErr);

   /* test tag pointer and length */
   IPP_BAD_PTR1_RET(pDstTag);
   IPP_BADARG_RET(tagLen<=0 || tagLen>BLOCK_SIZE, ippStsLengthErr);


   {
      /* get method */
      MulGcm_ hashFunc = AESGCM_HASH(pState);

      __ALIGN16 Ipp8u tmpHash[BLOCK_SIZE];
      Ipp8u tmpCntr[BLOCK_SIZE];

      /* local copy of AAD and text counters (in bits) */
      Ipp64u aadBitLen = AESGCM_AAD_LEN(pState)*BYTESIZE;
      Ipp64u txtBitLen = AESGCM_TXT_LEN(pState)*BYTESIZE;

      /* do local copy of ghash */
      CopyBlock16(AESGCM_GHASH(pState), tmpHash);

      /* complete text processing */
      if(AESGCM_BUFLEN(pState)) {
         hashFunc(tmpHash, AESGCM_HKEY(pState), AesGcmConst_table);
      }

      /* process lengths of AAD and text */
      U32_TO_HSTRING(tmpCntr,   IPP_HIDWORD(aadBitLen));
      U32_TO_HSTRING(tmpCntr+4, IPP_LODWORD(aadBitLen));
      U32_TO_HSTRING(tmpCntr+8, IPP_HIDWORD(txtBitLen));
      U32_TO_HSTRING(tmpCntr+12,IPP_LODWORD(txtBitLen));

      XorBlock16(tmpHash, tmpCntr, tmpHash);
      hashFunc(tmpHash, AESGCM_HKEY(pState), AesGcmConst_table);

      /* add encrypted initial counter */
      XorBlock16(tmpHash, AESGCM_ECOUNTER0(pState), tmpHash);

      /* return tag of required lenth */
      CopyBlock(tmpHash, pDstTag, tagLen);

      return ippStsNoErr;
   }
}
