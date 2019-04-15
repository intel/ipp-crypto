/*******************************************************************************
* Copyright 2017-2019 Intel Corporation
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
//  Purpose:
//     Cryptography Primitive.
//     SMS4-CCM implementation.
// 
//     Content:
//        ippsSMS4_CCMGetTag()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4authccm.h"
#include "pcptool.h"

/*F*
//    Name: ippsSMS4_CCMGetTag
//
// Purpose: Compute message auth tag and return one.
//          Note, that futher encryption/decryption and auth tag update is possible
//
// Returns:                Reason:
//    ippStsNullPtrErr        pTag == NULL
//                            pCtx == NULL
//    ippStsContextMatchErr   !VALID_SMS4CCM_ID()
//    ippStsLengthErr         MBS_SMS4 < tagLen
//                            1 > tagLen
//    ippStsNoErr             no errors
//
// Parameters:
//    pTag        pointer to the output authenticated tag
//    tagLen      requested length of the tag
//    pCtx        pointer to the CCM context
//
*F*/
IPPFUN(IppStatus, ippsSMS4_CCMGetTag,(Ipp8u* pTag, int tagLen, const IppsSMS4_CCMState* pCtx))
{
   /* test pCtx pointer */
   IPP_BAD_PTR1_RET(pCtx);

   /* use aligned context */
   //pCtx = (IppsSMS4_CCMState*)( IPP_ALIGNED_PTR(pCtx, SMS4CCM_ALIGNMENT) );

   /* test state ID */
   IPP_BADARG_RET(!VALID_SMS4CCM_ID(pCtx), ippStsContextMatchErr);

   /* test tag (pointer and length) */
   IPP_BAD_PTR1_RET(pTag);
   IPP_BADARG_RET((Ipp32u)tagLen>SMS4CCM_TAGLEN(pCtx) || tagLen<1, ippStsLengthErr);

   {
      Ipp32u flag = (Ipp32u)( SMS4CCM_LENPRO(pCtx) &(MBS_SMS4-1) );

      Ipp32u MAC[MBS_SMS4/sizeof(Ipp8u)];
      CopyBlock16(SMS4CCM_MAC(pCtx), MAC);

      if(flag) {
         /* SMS4 context */
         IppsSMS4Spec* pSMS4 = SMS4CCM_CIPHER_ALIGNED(pCtx);

         Ipp8u  BLK[MBS_SMS4];
         FillBlock16(0, NULL,BLK, 0);
         CopyBlock(SMS4CCM_BLK(pCtx), BLK, flag);

         XorBlock16(MAC, BLK, MAC);
         cpSMS4_Cipher((Ipp8u*)MAC, (Ipp8u*)MAC, SMS4_RK(pSMS4));
      }

      XorBlock(MAC, SMS4CCM_S0(pCtx), pTag, tagLen);
      return ippStsNoErr;
   }
}
