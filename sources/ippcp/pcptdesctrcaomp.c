/*******************************************************************************
* Copyright 2002-2019 Intel Corporation
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
//  Name:
//      ippsTDESEncryptCRT
//      ippsTDESDecryptCRT
// 
//  Purpose:
//      Cryptography Primitives.
//      Encrypt/Decrypt byte data stream according to DES
// 
// 
*/

#include "owndefs.h"

#if defined ( _OPENMP )

#include "owncp.h"
#include "pcpdes.h"
#include "pcptool.h"
#include "omp.h"

/*F*
// Name:
//     ippsTDESEncryptCRT
//     ippsTDESDecryptCRT
//
// Purpose:
//     Encrypt/Decrypt variable length data stream according to TDES
//     in CRT mode using OpenMP API.
//
// Returns:
//     ippStsNoErr              No errors, it's OK
//     ippStsNullPtrErr       ( pCtx1 == NULL ) || ( pCtx2 == NULL ) ||
//                            ( pCtx3 == NULL ) || ( pSrc  == NULL ) ||
//                            ( pDst  == NULL ) || ( pCrtValue == NULL )
//     ippStsLengthErr          srcLen < 1
//     ippStsCRTSizeErr         1 > ctrNumBitSize > 64
//     ippStsContextMatchErr  ( pCtx1->idCtx != idCtxDES ) ||
//                            ( pCtx2->idCtx != idCtxDES ) ||
//                            ( pCtx3->idCtx != idCtxDES )
//
// Parameters:
//     pSrc                     Pointer to the source byte data stream.
//     pDst                     Pointer to the target byte data stream.
//     srcLen                   The source data stream length in bytes.
//     pCtx1                    Pointer to the IppsDESSpec context.
//     pCtx2                    Pointer to the IppsDESSpec context.
//     pCtx3                    Pointer to the IppsDESSpec context.
//     pCtrValue                Pointer to the counter data block.
//     ctrNumBitSize            The counter block size in bits.
//
// Notes:
//     Counter is updated on return.
//
*F*/
static
void TDES_CTR_processing(const Ipp8u* pSrc, Ipp8u* pDst, int srcBlocks,
                         const IppsDESSpec* pCtx1,
                         const IppsDESSpec* pCtx2,
                         const IppsDESSpec* pCtx3,
                         const Ipp8u* pCtrValue, int ctrNumBitSize)
{
   Ipp64u  output;

   /* copy counter value */
   Ipp64u ctr;
   CopyBlock8(pCtrValue, &ctr);

   /*
   // block-by-block processing
   */
   while(srcBlocks) {
      /* encrypt counter block */
      output = Cipher_DES(ctr,    DES_EKEYS(pCtx1), DESspbox);
      output = Cipher_DES(output, DES_DKEYS(pCtx2), DESspbox);
      output = Cipher_DES(output, DES_EKEYS(pCtx3), DESspbox);
      /* compute ciphertext block */
      XorBlock8(pSrc, &output, pDst);
      /* encrement counter block */
      StdIncrement((Ipp8u*)&ctr, MBS_DES*8, ctrNumBitSize);

      pSrc += MBS_DES;
      pDst += MBS_DES;
      srcBlocks--;
   }
}

static IppStatus TDES_CTR(const Ipp8u* pSrc, Ipp8u* pDst, int srcLen,
                          const IppsDESSpec* pCtx1,
                          const IppsDESSpec* pCtx2,
                          const IppsDESSpec* pCtx3,
                          Ipp8u* pCtrValue,
                          int ctrNumBitSize)
{
   Ipp64u counter;
   Ipp64u  output;

   /* test the pointers */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   IPP_BAD_PTR3_RET(pSrc, pDst, pCtrValue);

   /* test the data stream length */
   IPP_BADARG_RET((srcLen<1), ippStsLengthErr);

   /* align the context */
   pCtx1 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT));
   pCtx2 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT));
   pCtx3 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT));

   /* test the counter block size */
   IPP_BADARG_RET(((MBS_DES*8)<ctrNumBitSize ) || (ctrNumBitSize<1), ippStsCTRSizeErr);

   /* test the context */
   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);

   /* copy counter */
   CopyBlock8(pCtrValue, &counter);

   {
      int nBlocks = srcLen / MBS_DES;

      if(nBlocks) {
         int nThreads  = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/TDES_MIN_BLK_PER_THREAD, 1));

         if(1==nThreads)
            TDES_CTR_processing(pSrc, pDst, nBlocks, pCtx1, pCtx2, pCtx3, pCtrValue, ctrNumBitSize);

         else {
            int blksThreadReg;
            int blksThreadTail;

            #pragma omp parallel IPPCP_OMP_LIMIT_MAX_NUM_THREADS(nThreads)
            {
               #pragma omp master
               {
                  nThreads = omp_get_num_threads();
                  blksThreadReg = nBlocks / nThreads;
                  blksThreadTail = blksThreadReg + nBlocks % nThreads;
               }
               #pragma omp barrier
               {
                  int id          = omp_get_thread_num();
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*blksThreadReg * MBS_DES;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*blksThreadReg * MBS_DES;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;

                  /* compute thread conter */
                  Ipp8u thread_counter[MBS_DES];
                  ompStdIncrement64(pCtrValue, thread_counter, ctrNumBitSize, id*blksThreadReg);

                  TDES_CTR_processing(pThreadSrc, pThreadDst, blkThread, pCtx1, pCtx2, pCtx3, thread_counter, ctrNumBitSize);
               }
            }
         }

         /* update counter */
         ompStdIncrement64(pCtrValue, &counter, ctrNumBitSize, nBlocks);
      }

      /* process the rest of data block if any */
      srcLen &= MBS_DES-1;
      if(srcLen) {
         pSrc += nBlocks*MBS_DES;
         pDst += nBlocks*MBS_DES;
         /* encrypt counter block */
         output = Cipher_DES(counter, DES_EKEYS(pCtx1), DESspbox);
         output = Cipher_DES(output,  DES_DKEYS(pCtx2), DESspbox);
         output = Cipher_DES(output,  DES_EKEYS(pCtx3), DESspbox);
         /* compute ciphertext block */
         XorBlock(pSrc, &output, pDst, srcLen);
         /* encrement counter block */
         StdIncrement((Ipp8u*)&counter, MBS_DES*8, ctrNumBitSize);
      }

      /* update counter */
      CopyBlock8(&counter, pCtrValue);

      return ippStsNoErr;
   }
}


IPPFUN( IppStatus, ippsTDESEncryptCTR, ( const Ipp8u* pSrc, Ipp8u* pDst,
       int srcLen, const IppsDESSpec* pCtx1, const IppsDESSpec* pCtx2,
       const IppsDESSpec* pCtx3, Ipp8u* pCtrValue, int ctrNumBitSize ) )
{
   return TDES_CTR( pSrc, pDst, srcLen, pCtx1, pCtx2, pCtx3,
       pCtrValue, ctrNumBitSize );
}

IPPFUN( IppStatus, ippsTDESDecryptCTR, ( const Ipp8u* pSrc, Ipp8u* pDst,
       int srcLen, const IppsDESSpec* pCtx1, const IppsDESSpec* pCtx2,
       const IppsDESSpec* pCtx3, Ipp8u* pCtrValue, int ctrNumBitSize ) )
{
   return TDES_CTR( pSrc, pDst, srcLen, pCtx1, pCtx2, pCtx3,
       pCtrValue, ctrNumBitSize );
}

#endif /* #ifdef _OPENMP */
