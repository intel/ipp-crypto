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
//     AES-GCM
// 
//  Contents:
//        ippsAES_GCMProcessIV()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcpaesm.h"
#include "pcptool.h"

/*F*
//    Name: ippsAES_GCMProcessIV
//
// Purpose: IV processing.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//                            pIV ==NULL && ivLen>0
//    ippStsContextMatchErr   !AESGCM_VALID_ID()
//    ippStsLengthErr         ivLen <0
//    ippStsBadArgErr         illegal sequence call
//    ippStsNoErr             no errors
//
// Parameters:
//    pIV         pointer to the IV
//    ivLen       length of IV (it could be 0)
//    pState      pointer to the context
//
*F*/
IPPFUN(IppStatus, ippsAES_GCMProcessIV,(const Ipp8u* pIV, int ivLen, IppsAES_GCMState* pState))
{
   /* test pState pointer */
   IPP_BAD_PTR1_RET(pState);

   /* test IV pointer and length */
   IPP_BADARG_RET(ivLen && !pIV, ippStsNullPtrErr);
   IPP_BADARG_RET(ivLen<0, ippStsLengthErr);

   /* use aligned context */
   pState = (IppsAES_GCMState*)( IPP_ALIGNED_PTR(pState, AESGCM_ALIGNMENT) );
   /* test context validity */
   IPP_BADARG_RET(!AESGCM_VALID_ID(pState), ippStsContextMatchErr);

   IPP_BADARG_RET(!(GcmInit==AESGCM_STATE(pState) || GcmIVprocessing==AESGCM_STATE(pState)), ippStsBadArgErr);

   /* switch IVprocessing on */
   AESGCM_STATE(pState) = GcmIVprocessing;

   /* test if buffer is not empty */
   if(AESGCM_BUFLEN(pState)) {
      int locLen = IPP_MIN(ivLen, BLOCK_SIZE-AESGCM_BUFLEN(pState));
      XorBlock(pIV, AESGCM_COUNTER(pState)+AESGCM_BUFLEN(pState), AESGCM_COUNTER(pState)+AESGCM_BUFLEN(pState), locLen);
      AESGCM_BUFLEN(pState) += locLen;

      /* if buffer full */
      if(BLOCK_SIZE==AESGCM_BUFLEN(pState)) {
         MulGcm_ ghashFunc = AESGCM_HASH(pState);
         ghashFunc(AESGCM_COUNTER(pState), AESGCM_HKEY(pState), AesGcmConst_table);
         AESGCM_BUFLEN(pState) = 0;
      }

      AESGCM_IV_LEN(pState) += locLen;
      pIV += locLen;
      ivLen -= locLen;
   }

   /* process main part of IV */
   {
      int lenBlks = ivLen & (-BLOCK_SIZE);
      if(lenBlks) {
         Auth_ authFunc = AESGCM_AUTH(pState);

         authFunc(AESGCM_COUNTER(pState), pIV, lenBlks, AESGCM_HKEY(pState), AesGcmConst_table);

         AESGCM_IV_LEN(pState) += lenBlks;
         pIV += lenBlks;
         ivLen -= lenBlks;
      }
   }

   /* copy the rest of IV into the buffer */
   if(ivLen) {
      XorBlock(pIV, AESGCM_COUNTER(pState), AESGCM_COUNTER(pState), ivLen);
      AESGCM_IV_LEN(pState) += ivLen;
      AESGCM_BUFLEN(pState) += ivLen;
   }

   return ippStsNoErr;
}
