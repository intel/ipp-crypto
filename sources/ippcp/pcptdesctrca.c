/*******************************************************************************
* Copyright 2004-2019 Intel Corporation
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
//     Encrypt/Decrypt byte data stream according to TDES (CTR mode)
// 
//  Contents:
//     ippsTDESEncryptCTR()
//     ippsTDESDecryptCTR()
// 
// 
*/

#include "owndefs.h"

#include "owncp.h"
#include "pcpdes.h"
#include "pcptool.h"

static
IppStatus TDES_CTR(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                   const IppsDESSpec* pCtx1,
                   const IppsDESSpec* pCtx2,
                   const IppsDESSpec* pCtx3,
                   Ipp8u* pCtrValue, int ctrNumBitSize)
{
   Ipp64u counter;
   Ipp64u  output;

   /* test contexts */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   /* use aligned DES contexts */
   pCtx1 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT) );
   pCtx2 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT) );
   pCtx3 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT) );

   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);
   /* test source, target and counter block pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pCtrValue);
   /* test stream length */
   IPP_BADARG_RET((len<1), ippStsLengthErr);
   /* test counter block size */
   IPP_BADARG_RET(((MBS_DES*8)<ctrNumBitSize)||(ctrNumBitSize<1), ippStsCTRSizeErr);

   /* copy counter */
   CopyBlock8(pCtrValue, &counter);

   /*
   // encrypt block-by-block aligned streams
   */
   while(len >= MBS_DES) {
      /* encrypt counter block */
      output = Cipher_DES(counter, DES_EKEYS(pCtx1), DESspbox);
      output = Cipher_DES(output,  DES_DKEYS(pCtx2), DESspbox);
      output = Cipher_DES(output,  DES_EKEYS(pCtx3), DESspbox);
      /* compute ciphertext block */
      XorBlock8(pSrc, &output, pDst);
      /* encrement counter block */
      StdIncrement((Ipp8u*)&counter,MBS_DES*8, ctrNumBitSize);

      pSrc += MBS_DES;
      pDst += MBS_DES;
      len  -= MBS_DES;
   }
   /*
   // encrypt last data block
   */
   if(len) {
      /* encrypt counter block */
      output = Cipher_DES(counter, DES_EKEYS(pCtx1), DESspbox);
      output = Cipher_DES(output,  DES_DKEYS(pCtx2), DESspbox);
      output = Cipher_DES(output,  DES_EKEYS(pCtx3), DESspbox);
      /* compute ciphertext block */
      XorBlock(pSrc, &output, pDst,len);
      /* encrement counter block */
      StdIncrement((Ipp8u*)&counter,MBS_DES*8, ctrNumBitSize);
   }

   /* update counter */
   CopyBlock8(&counter, pCtrValue);

   return ippStsNoErr;
}

/*F*
//    Name: ippsTDESEncryptCTR
//
// Purpose: Encrypt byte data stream according to TDES in CTR mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx1 == NULL
//                            pCtx2 == NULL
//                            pCtx3 == NULL
//                            pSrc  == NULL
//                            pDst  == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   pCtx1->idCtx != idCtxDES
//                            pCtx2->idCtx != idCtxDES
//                            pCtx3->idCtx != idCtxDES
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        64 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data stream
//    pDst           pointer to the target data stream
//    len            plaintext stream length (bytes)
//    pCtx1-pCtx3    DES contexts
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*F*/

IPPFUN(IppStatus, ippsTDESEncryptCTR,(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                                      const IppsDESSpec* pCtx1,
                                      const IppsDESSpec* pCtx2,
                                      const IppsDESSpec* pCtx3,
                                      Ipp8u* pCtrValue, int ctrNumBitSize))
{
   return TDES_CTR(pSrc,pDst,len, pCtx1,pCtx2,pCtx3, pCtrValue,ctrNumBitSize);
}

/*F*
//    Name: ippsTDESDecryptCTR
//
// Purpose: Decrypt byte data stream according to TDES in CTR mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx1 == NULL
//                            pCtx2 == NULL
//                            pCtx3 == NULL
//                            pSrc  == NULL
//                            pDst  == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   pCtx1->idCtx != idCtxDES
//                            pCtx2->idCtx != idCtxDES
//                            pCtx3->idCtx != idCtxDES
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        64 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data stream
//    pDst           pointer to the target data stream
//    len            plaintext stream length (bytes)
//    pCtx1-pCtx3    DES contexts
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*F*/

IPPFUN(IppStatus, ippsTDESDecryptCTR,(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                                      const IppsDESSpec* pCtx1,
                                      const IppsDESSpec* pCtx2,
                                      const IppsDESSpec* pCtx3,
                                      Ipp8u* pCtrValue, int ctrNumBitSize))
{
   return TDES_CTR(pSrc,pDst,len, pCtx1,pCtx2,pCtx3, pCtrValue,ctrNumBitSize);
}
