/*******************************************************************************
* Copyright 2006-2019 Intel Corporation
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
//     Encrypt byte data stream according to TDES (OFB mode)
// 
//  Contents:
//     ippsTDESEncryptOCB(), ippsTDESDecryptOCB()
// 
// 
*/

#include "owndefs.h"

#include "owncp.h"
#include "pcpdes.h"
#include "pcptool.h"
static
void cpTDES_OFB8(const Ipp8u *pSrc, Ipp8u *pDst, int len, int ofbBlkSize,
                  const IppsDESSpec* pCtx1,
                  const IppsDESSpec* pCtx2,
                  const IppsDESSpec* pCtx3,
                        Ipp8u* pIV)
{
   Ipp64u inpBuffer;
   Ipp64u outBuffer;

   CopyBlock8(pIV, &inpBuffer);

   while(len>=ofbBlkSize) {
      /* block-by-block processing */
      outBuffer = Cipher_DES(inpBuffer, DES_EKEYS(pCtx1), DESspbox);
      outBuffer = Cipher_DES(outBuffer, DES_DKEYS(pCtx2), DESspbox);
      outBuffer = Cipher_DES(outBuffer, DES_EKEYS(pCtx3), DESspbox);

      /* store output */
      XorBlock(pSrc, &outBuffer, pDst, ofbBlkSize);

      /* shift inpBuffer for the next OFB operation */
      if(MBS_DES==ofbBlkSize)
         inpBuffer = outBuffer;
      else
         #if (IPP_ENDIAN == IPP_BIG_ENDIAN)
         inpBuffer = LSL64(inpBuffer, ofbBlkSize*8)
                    |LSR64(outBuffer, 64-ofbBlkSize*8);
         #else
         inpBuffer = LSR64(inpBuffer, ofbBlkSize*8)
                    |LSL64(outBuffer, 64-ofbBlkSize*8);
         #endif

      pSrc += ofbBlkSize;
      pDst += ofbBlkSize;
      len  -= ofbBlkSize;
   }

   /* update pIV */
   CopyBlock8(&inpBuffer, pIV);
}


/*F*
//    Name: ippsTDESEncryptOFB
//
// Purpose: Encrypts byte data stream according to TDES in OFB mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx1== NULL
//                            pCtx2== NULL
//                            pCtx3== NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pIV  == NULL
//    ippStsContextMatchErr   pCtx->idCtx != idCtxRijndael
//    ippStsLengthErr         len <1
//    ippStsOFBSizeErr        (1>ofbBlkSize || ofbBlkSize>MBS_DES)
//    ippStsUnderRunErr       (len%ofbBlkSize)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the source data stream
//    pDst        pointer to the target data stream
//    len         plaintext stream length (bytes)
//    ofbBlkSize  OFB block size (bytes)
//    pCtx1,..    DES contexts
//    pIV         pointer to the initialization vector
//
*F*/
IPPFUN(IppStatus, ippsTDESEncryptOFB,(const Ipp8u* pSrc, Ipp8u* pDst, int len, int ofbBlkSize,
                                      const IppsDESSpec* pCtx1,
                                      const IppsDESSpec* pCtx2,
                                      const IppsDESSpec* pCtx3,
                                            Ipp8u* pIV))
{
   /* test contexts */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   /* use aligned DES contexts */
   pCtx1 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT) );
   pCtx2 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT) );
   pCtx3 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT) );

   /* test context validity */
   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);

   /* test source and destination pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pIV);
   /* test stream length */
   IPP_BADARG_RET((len<1), ippStsLengthErr);
   /* test OFB value */
   IPP_BADARG_RET(((1>ofbBlkSize) || (MBS_DES<ofbBlkSize)), ippStsOFBSizeErr);
   /* test stream integrity */
   IPP_BADARG_RET((len % ofbBlkSize), ippStsUnderRunErr);

   cpTDES_OFB8(pSrc, pDst, len, ofbBlkSize, pCtx1,pCtx2,pCtx3, pIV);
   return ippStsNoErr;
}

/*F*
//    Name: ippsTDESDecryptOFB
//
// Purpose: Decrypts byte data stream according to TDES in OFB mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx1== NULL
//                            pCtx2== NULL
//                            pCtx3== NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pIV  == NULL
//    ippStsContextMatchErr   pCtx->idCtx != idCtxRijndael
//    ippStsLengthErr         len <1
//    ippStsOFBSizeErr        (1>ofbBlkSize || ofbBlkSize>MBS_DES)
//    ippStsUnderRunErr       (len%ofbBlkSize)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the source data stream
//    pDst        pointer to the target data stream
//    len         plaintext stream length (bytes)
//    ofbBlkSize  OFB block size (bytes)
//    pCtx1,..    DES contexts
//    pIV         pointer to the initialization vector
//
*F*/

IPPFUN(IppStatus, ippsTDESDecryptOFB,(const Ipp8u* pSrc, Ipp8u* pDst, int len, int ofbBlkSize,
                                      const IppsDESSpec* pCtx1,
                                      const IppsDESSpec* pCtx2,
                                      const IppsDESSpec* pCtx3,
                                            Ipp8u* pIV))
{
   /* test contexts */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   /* use aligned DES contexts */
   pCtx1 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT) );
   pCtx2 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT) );
   pCtx3 = (IppsDESSpec*)( IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT) );

   /* test context validity */
   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);

   /* test source and destination pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pIV);
   /* test stream length */
   IPP_BADARG_RET((len<1), ippStsLengthErr);
   /* test OFB value */
   IPP_BADARG_RET(((1>ofbBlkSize) || (MBS_DES<ofbBlkSize)), ippStsOFBSizeErr);
   /* test stream integrity */
   IPP_BADARG_RET((len % ofbBlkSize), ippStsUnderRunErr);

   cpTDES_OFB8(pSrc, pDst, len, ofbBlkSize, pCtx1,pCtx2,pCtx3, pIV);
   return ippStsNoErr;
}
