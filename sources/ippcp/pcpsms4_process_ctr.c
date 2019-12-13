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
//     SMS4 encryption/decryption
// 
//  Contents:
//        cpProcessSMS4_ctr()
//
*/

#include "owncp.h"
#include "pcpsms4.h"
#include "pcptool.h"

/*
// SMS4-CTR processing.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   !VALID_SMS4_ID()
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        128 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data buffer
//    pDst           pointer to the target data buffer
//    dataLen        input/output buffer length (in bytes)
//    pCtx           pointer to rge SMS4 context
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*/
#define cpProcessSMS4_ctr OWNAPI(cpProcessSMS4_ctr)
IppStatus cpProcessSMS4_ctr(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen,
                            const IppsSMS4Spec* pCtx,
                            Ipp8u* pCtrValue, int ctrNumBitSize)
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned SMS4 context */
   pCtx = (IppsSMS4Spec*)( IPP_ALIGNED_PTR(pCtx, SMS4_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_SMS4_ID(pCtx), ippStsContextMatchErr);

   /* test source, target and counter block pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pCtrValue);
   /* test stream length */
   IPP_BADARG_RET((dataLen<1), ippStsLengthErr);

   /* test counter block size */
   IPP_BADARG_RET(((MBS_SMS4*8)<ctrNumBitSize)||(ctrNumBitSize<1), ippStsCTRSizeErr);

   {
      __ALIGN16 Ipp8u TMP[2*MBS_SMS4+1];

      /*
         maskIV    size = MBS_SMS4
         output    size = MBS_SMS4
         counter   size = MBS_SMS4
         maskValue size = 1
      */

      Ipp8u* output    = TMP;
      Ipp8u* counter   = TMP + MBS_SMS4;

      /* copy counter */
      CopyBlock16(pCtrValue, counter);

      /* do CTR processing */
      #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)

      Ipp8u* maskIV    = TMP;
      /* output is not used together with maskIV, so this is why buffer for both values is the same */
      Ipp8u* maskValue = TMP + 2*MBS_SMS4;

      if(IsFeatureEnabled(ippCPUID_AES)) {
         if(dataLen>=4*MBS_SMS4) {
            /* construct ctr mask */
            int n;
            int maskPosition = (MBS_SMS4*8-ctrNumBitSize)/8;
            *maskValue = (Ipp8u)(0xFF >> (MBS_SMS4*8-ctrNumBitSize)%8 );

            for(n=0; n<maskPosition; n++)
               maskIV[n] = 0;
            maskIV[maskPosition] = *maskValue;
            for(n=maskPosition+1; n < MBS_SMS4; n++)
               maskIV[n] = 0xFF;

            n = cpSMS4_CTR_aesni(pDst, pSrc, dataLen, SMS4_RK(pCtx), maskIV, counter);
            pSrc += n;
            pDst += n;
            dataLen -= n;

         }
      }
      #endif

      {

         /* block-by-block processing */
         while(dataLen>= MBS_SMS4) {
            /* encrypt counter block */
            cpSMS4_Cipher((Ipp8u*)output, (Ipp8u*)counter,  SMS4_RK(pCtx));
            /* compute ciphertext block */
            XorBlock16(pSrc, output, pDst);
            /* increment counter block */
            StdIncrement(counter,MBS_SMS4*8, ctrNumBitSize);

            pSrc += MBS_SMS4;
            pDst += MBS_SMS4;
            dataLen -= MBS_SMS4;
         }

         /* last data block processing */
         if(dataLen) {
            /* encrypt counter block */
            cpSMS4_Cipher((Ipp8u*)output, (Ipp8u*)counter, SMS4_RK(pCtx));
            /* compute ciphertext block */
            XorBlock(pSrc, output, pDst,dataLen);
            /* increment counter block */
            StdIncrement((Ipp8u*)counter,MBS_SMS4*8, ctrNumBitSize);
         }

      }

      /* update counter */
      CopyBlock16(counter, pCtrValue);

      /* clear secret data */
      PurgeBlock(TMP, sizeof(TMP));
      
      return ippStsNoErr;
   }
}
