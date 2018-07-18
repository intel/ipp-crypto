/*******************************************************************************
* Copyright 2017-2018 Intel Corporation
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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
// 
//     Context:
//        ippsSMS4_CCMEncrypt()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4authccm.h"
#include "pcptool.h"

/*F*
//    Name: ippsSMS4_CCMEncrypt
//
// Purpose: Encrypts data and updates authentication tag.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx== NULL
//                            pSrc == NULL
//                            pDst == NULL
//    ippStsContextMatchErr   !VALID_SMS4CCM_ID()
//    ippStsLengthErr         if exceed overall length of message is being processed
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the plane text beffer
//    pDst        pointer to the cipher text bubber
//    len         length of the buffer
//    pCtx        pointer to the CCM context
//
*F*/
IPPFUN(IppStatus, ippsSMS4_CCMEncrypt,(const Ipp8u* pSrc, Ipp8u* pDst, int len, IppsSMS4_CCMState* pCtx))
{
   /* test pCtx pointer */
   IPP_BAD_PTR1_RET(pCtx);
   pCtx = (IppsSMS4_CCMState*)( IPP_ALIGNED_PTR(pCtx, SMS4CCM_ALIGNMENT) );
   IPP_BADARG_RET(!VALID_SMS4CCM_ID(pCtx), ippStsContextMatchErr);

   /* test source/destination data */
   IPP_BAD_PTR2_RET(pSrc, pDst);

   /* test message length */
   IPP_BADARG_RET(len<0 || SMS4CCM_LENPRO(pCtx)+len >SMS4CCM_MSGLEN(pCtx), ippStsLengthErr);

   /*
   // enctypt payload and update MAC
   */
   if(len) {
      /* SMS4 context */
      IppsSMS4Spec* pSMS4 = SMS4CCM_CIPHER_ALIGNED(pCtx);

      Ipp32u flag = (Ipp32u)( SMS4CCM_LENPRO(pCtx) &(MBS_SMS4-1) );

      Ipp32u qLen;
      Ipp32u counterVal;

      Ipp32u MAC[MBS_SMS4/sizeof(Ipp8u)];
      Ipp32u CTR[MBS_SMS4/sizeof(Ipp8u)];
      Ipp32u   S[MBS_SMS4/sizeof(Ipp8u)];
      /* extract from the state */
      CopyBlock16(SMS4CCM_MAC(pCtx), MAC);
      CopyBlock16(SMS4CCM_CTR0(pCtx), CTR);
      CopyBlock16(SMS4CCM_Si(pCtx), S);
      counterVal = SMS4CCM_COUNTER(pCtx);

      /* extract qLen */
      qLen = (((Ipp8u*)CTR)[0] &0x7) +1; /* &0x7 just to fix KW issue */

      if(flag) {
         int tmpLen = IPP_MIN(len, MBS_SMS4-1);

         /* copy as much input as possible into the internal buffer*/
         CopyBlock(pSrc, SMS4CCM_BLK(pCtx)+flag, tmpLen);

         XorBlock(pSrc, (Ipp8u*)S+flag, pDst, tmpLen);

         /* update MAC */
         if(flag+tmpLen == MBS_SMS4) {
            XorBlock16(MAC, SMS4CCM_BLK(pCtx), MAC);
            cpSMS4_Cipher((Ipp8u*)MAC, (Ipp8u*)MAC, SMS4_RK(pSMS4));
         }

         SMS4CCM_LENPRO(pCtx) += (Ipp32u)tmpLen;
         pSrc += tmpLen;
         pDst += tmpLen;
         len  -= tmpLen;
      }

      while(len >= MBS_SMS4) {
         Ipp32u counterEnc[2];

         /* update MAC */
         XorBlock16(MAC, pSrc, MAC);
         cpSMS4_Cipher((Ipp8u*)MAC, (Ipp8u*)MAC, SMS4_RK(pSMS4));

         /* increment counter and format counter block */
         counterVal++;
         CopyBlock(CounterEnc(counterEnc, qLen, counterVal), ((Ipp8u*)CTR)+MBS_SMS4-qLen, qLen);
         /* encode counter block */
         cpSMS4_Cipher((Ipp8u*)S, (Ipp8u*)CTR, SMS4_RK(pSMS4));

         /* store cipher text */
         XorBlock16(pSrc, S, pDst);

         SMS4CCM_LENPRO(pCtx) += MBS_SMS4;
         pSrc += MBS_SMS4;
         pDst += MBS_SMS4;
         len  -= MBS_SMS4;
      }

      if(len) {
         Ipp32u counterEnc[2];

         /* store partial data block */
         CopyBlock(pSrc, SMS4CCM_BLK(pCtx), len);

         /* increment counter and format counter block */
         counterVal++;
         CopyBlock(CounterEnc(counterEnc, qLen, counterVal), ((Ipp8u*)CTR)+MBS_SMS4-qLen, qLen);
         /* encode counter block */
         cpSMS4_Cipher((Ipp8u*)S, (Ipp8u*)CTR, SMS4_RK(pSMS4));

         /* store cipher text */
         XorBlock(pSrc, S, pDst, len);

         SMS4CCM_LENPRO(pCtx) += len;
      }

      /* update state */
      CopyBlock16(MAC, SMS4CCM_MAC(pCtx));
      CopyBlock16(S, SMS4CCM_Si(pCtx));
      SMS4CCM_COUNTER(pCtx) = counterVal;
   }

   return ippStsNoErr;
}
