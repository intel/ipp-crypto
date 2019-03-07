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
//  Purpose:
//     Cryptography Primitive.
//     AES encryption/decryption (CTR mode)
// 
//  Contents:
//     ippsAESEncryptCTR()
//     ippsAESDecryptCTR()
// 
// 
*/

#include "owndefs.h"

#if defined(_OPENMP)

#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "omp.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*
// AES-CTR processing.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   !VALID_AES_ID()
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        128 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data buffer
//    pDst           pointer to the target data buffer
//    dataLen        input/output buffer length (in bytes)
//    pCtx           pointer to rge AES context
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*/
static
void AES_CTR_processing(const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks,
                        const IppsAESSpec* pCtx,
                        Ipp8u* pCtrValue, int ctrNumBitSize)
{
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   /* use pipelined version if possible */
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      /* construct ctr mask */
      Ipp8u maskIV[MBS_RIJ128];
      int n;
      int maskPosition = (MBS_RIJ128*8-ctrNumBitSize)/8;
      Ipp8u maskValue = (Ipp8u)(0xFF >> (MBS_RIJ128*8-ctrNumBitSize)%8 );

      for(n=0; n<maskPosition; n++)
         maskIV[n] = 0;
      maskIV[maskPosition] = maskValue;
      for(n=maskPosition+1; n<16; n++)
         maskIV[n] = 0xFF;

      EncryptCTR_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), nBlocks*MBS_RIJ128, pCtrValue, (Ipp8u*)maskIV);
   }
   else
#endif
   {
      /* setup encoder method */
      RijnCipher encoder = RIJ_ENCODER(pCtx);

      Ipp32u  output[NB(128)];

      /* copy counter value */
      Ipp32u ctr[NB(128)];
      CopyBlock16(pCtrValue, ctr );

      /*
      // block-by-block processing
      */
      while(nBlocks) {
         /* encrypt counter block */
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)ctr, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)ctr, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         /* compute ciphertext block */
         XorBlock16(pSrc, output, pDst);
         /* encrement counter block */
         StdIncrement((Ipp8u*)ctr,MBS_RIJ128*8, ctrNumBitSize);

         pSrc += MBS_RIJ128;
         pDst += MBS_RIJ128;
         nBlocks--;
      }

      /* copy counter back */
      CopyBlock16(ctr, pCtrValue);
   }
}

static
IppStatus AES_ctr(const Ipp8u* pSrc, Ipp8u* pDst, int srcLen,
                  const IppsAESSpec* pCtx,
                  Ipp8u* pCtrValue, int ctrNumBitSize)
{
   /* test the pointers */
   IPP_BAD_PTR4_RET(pSrc, pDst, pCtx, pCtrValue);
   /* align the context */
   pCtx = (IppsAESSpec*)(IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT));
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_ID( pCtx ), ippStsContextMatchErr);

   /* test the data stream length */
   IPP_BADARG_RET((srcLen<1), ippStsLengthErr);

   /* test the counter block size */
   IPP_BADARG_RET((128<ctrNumBitSize) || (ctrNumBitSize<1), ippStsCTRSizeErr);

   {
      int nBlocks = srcLen / MBS_RIJ128;

      if(nBlocks) {
         int blk_per_thread = AES_NI_ENABLED==RIJ_AESNI(pCtx)? AESNI128_MIN_BLK_PER_THREAD : RIJ128_MIN_BLK_PER_THREAD;
         int nThreads = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/blk_per_thread, 1));

         if(1==nThreads) {
            AES_CTR_processing(pSrc, pDst, nBlocks, pCtx, pCtrValue, ctrNumBitSize);
            goto ctr_tail;
            return ippStsNoErr;
         }

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
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*blksThreadReg * MBS_RIJ128;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*blksThreadReg * MBS_RIJ128;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;

                  /* compute thread conter */
                  Ipp8u thread_counter[MBS_RIJ128];
                  ompStdIncrement128(pCtrValue, thread_counter, ctrNumBitSize, id*blksThreadReg);

                  AES_CTR_processing(pThreadSrc, pThreadDst, blkThread, pCtx, thread_counter, ctrNumBitSize);
               }
            }

            /* update counter */
            ompStdIncrement128(pCtrValue, pCtrValue, ctrNumBitSize, nBlocks);
         }
      }
ctr_tail:
      /* process the rest of data block if any */
      srcLen &= MBS_RIJ128-1;
      if(srcLen) {
         Ipp32u counter[NB(128)];
         Ipp32u  output[NB(128)];

         /* setup encoder method */
         RijnCipher encoder = RIJ_ENCODER(pCtx);

         /* copy counter */
         CopyBlock16(pCtrValue, counter);

         pSrc += nBlocks*MBS_RIJ128;
         pDst += nBlocks*MBS_RIJ128;
         /* encrypt counter block */
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         /* compute ciphertext block */
         XorBlock(pSrc, output, pDst, srcLen);
         /* encrement counter block */
         StdIncrement((Ipp8u*)counter, MBS_RIJ128*8, ctrNumBitSize);

         /* copy counter back */
         CopyBlock16(counter, pCtrValue);
      }

      return ippStsNoErr;
   }
}


IPPFUN(IppStatus, ippsAESEncryptCTR,(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen,
                                     const IppsAESSpec* pCtx,
                                     Ipp8u* pCtrValue, int ctrNumBitSize ))
{
   return AES_ctr(pSrc, pDst, dataLen, pCtx, pCtrValue, ctrNumBitSize);
}


IPPFUN(IppStatus, ippsAESDecryptCTR,(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen,
                                     const IppsAESSpec* pCtx,
                                     Ipp8u* pCtrValue, int ctrNumBitSize ))
{
   return AES_ctr(pSrc, pDst, dataLen, pCtx, pCtrValue, ctrNumBitSize);
}

#endif /* _OPENMP */
