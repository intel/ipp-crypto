/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//      ippsTDESDecryptCFB
// 
//  Purpose:
//      Cryptography Primitives.
//      Decrypt byte data stream according to TDES.
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
//     ippsTDESDecryptCFB
//
// Purpose:
//     Decrypt byte data stream according to DES in CFB mode using OpenMP API.
//
// Returns:
//     ippStsNoErr              No errors, it's OK
//     ippStsNullPtrErr       ( pCtx1 == NULL ) || ( pCtx2 == NULL ) ||
//                            ( pCtx3 == NULL ) || ( pSrc  == NULL ) ||
//                            ( pDst ==  NULL ) || ( pIV   == NULL )
//     ippStsLengthErr          srcLen < 1
//     ippStsCFBSizeErr         1 > cfbBlkSize > 8
//     ippStsContextMatchErr  ( pCtx1->idCtx != idCtxDES ) ||
//                            ( pCtx2->idCtx != idCtxDES ) ||
//                            ( pCtx3->idCtx != idCtxDES )
//     ippStsUnderRunErr      ( srcLen % cfBlkSize ) != 0
//
// Parameters:
//     pSrc                     Pointer to the input ciphertext data stream.
//     pDst                     Pointer to the resulting plaintext data stream.
//     srcLen                   Plaintext data stream length.
//     cfbBlkSize               Plaintext data stream size in bytes.
//     pCtx                     Pointer to the IppsDESSpec context.
//     pIV                      Pointer to the initilization vector.
//     padding                  Padding scheme indicator.
//
// Notes:
//     An encryption function is used to decrypt a cipher text,
//     i.e. an encryption key schedule is utilized.
*F*/
static
void TDES_CFB_processing(const Ipp8u* pIV,
                         const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks, int cfbBlkSize,
                         const IppsDESSpec* pCtx1,
                         const IppsDESSpec* pCtx2,
                         const IppsDESSpec* pCtx3)
{
   Ipp64u tmpInp[2];
   Ipp64u tmpOut;

   /* copy IV */
   CopyBlock8(pIV, tmpInp);

   /* decrypt data block-by-block of cfbLen each */
   while(nBlocks) {
      int n;

      /* decryption */
      tmpOut = Cipher_DES(tmpInp[0], DES_EKEYS(pCtx1), DESspbox);
      tmpOut = Cipher_DES(tmpOut,    DES_DKEYS(pCtx2), DESspbox);
      tmpOut = Cipher_DES(tmpOut,    DES_EKEYS(pCtx3), DESspbox);

      /* store output and put feedback into the input buffer (tmpInp) */
      for(n=0; n<cfbBlkSize; n++) {
         ((Ipp8u*)(tmpInp+1))[n] = pSrc[n];
         pDst[n] = (Ipp8u)( ((Ipp8u*)&tmpOut)[n] ^ pSrc[n] );
      }

      /* shift input buffer (tmpInp) for the next CFB operation */
      if(MBS_DES==cfbBlkSize)
         tmpInp[0] = tmpInp[1];
      else
         #if (IPP_ENDIAN == IPP_BIG_ENDIAN)
         tmpInp[0] = LSL64(tmpInp[0], cfbBlkSize*8)
                    |LSR64(tmpInp[1], 64-cfbBlkSize*8);
         #else
         tmpInp[0] = LSR64(tmpInp[0], cfbBlkSize*8)
                    |LSL64(tmpInp[1], 64-cfbBlkSize*8);
         #endif

      pSrc += cfbBlkSize;
      pDst += cfbBlkSize;
      nBlocks--;
   }
}

IPPFUN(IppStatus, ippsTDESDecryptCFB,(const Ipp8u* pSrc, Ipp8u* pDst, int srcLen, int cfbBlkSize,
                                      const IppsDESSpec* pCtx1,
                                      const IppsDESSpec* pCtx2,
                                      const IppsDESSpec* pCtx3,
                                      const Ipp8u* pIV,
                                      IppsPadding padding))
{
   /* test context */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   /* use aligned DES context */
   pCtx1 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT));
   pCtx2 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT));
   pCtx3 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT));

   IPP_BAD_PTR3_RET(pSrc, pDst, pIV);

   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);

   /* test stream length */
   IPP_BADARG_RET((srcLen<1), ippStsLengthErr);
   /* test CFB value */
   IPP_BADARG_RET(((1>cfbBlkSize) || (MBS_DES<cfbBlkSize)), ippStsCFBSizeErr);
   /* test stream integrity */
   IPP_BADARG_RET((srcLen%cfbBlkSize), ippStsUnderRunErr);

   UNREFERENCED_PARAMETER(padding);

   {
      int nBlocks = srcLen / cfbBlkSize;
      int nThreads  = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/TDES_MIN_BLK_PER_THREAD, 1));

      if(1==nThreads)
         TDES_CFB_processing(pIV, pSrc, pDst, nBlocks, cfbBlkSize, pCtx1, pCtx2, pCtx3);

      else {
         int blksThreadReg;
         int blksThreadTail;
         int srcBlkSize;
         int ivBlkSize;

         Ipp8u locIV[MBS_DES*DEFAULT_CPU_NUM];
#if defined(__INTEL_COMPILER)
         Ipp8u* pLocIV = nThreads>DEFAULT_CPU_NUM? kmp_malloc(nThreads*MBS_DES) : locIV;
#else
         Ipp8u* pLocIV = nThreads>DEFAULT_CPU_NUM ? malloc(nThreads*MBS_DES) : locIV;
#endif

         if(pLocIV) {
            #pragma omp parallel IPPCP_OMP_LIMIT_MAX_NUM_THREADS(nThreads)
            {
               #pragma omp master
               {
                  int nt;
                  nThreads = omp_get_num_threads();
                  blksThreadReg = nBlocks / nThreads;
                  blksThreadTail = blksThreadReg + nBlocks % nThreads;

                  srcBlkSize = blksThreadReg*cfbBlkSize;
                  ivBlkSize  = IPP_MIN(MBS_DES,srcBlkSize);

                  CopyBlock8(pIV, pLocIV+0);
                  for(nt=1; nt<nThreads; nt++)
                     CopyBlock(pSrc+nt*srcBlkSize-ivBlkSize, pLocIV+MBS_DES+(nt-1)*ivBlkSize, ivBlkSize);
               }
               #pragma omp barrier
               {
                  int id = omp_get_thread_num();
                  Ipp8u* pThreadIV  = pLocIV + id*ivBlkSize;
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*srcBlkSize;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*srcBlkSize;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;
                  TDES_CFB_processing(pThreadIV, pThreadSrc, pThreadDst, blkThread, cfbBlkSize, pCtx1, pCtx2, pCtx3);
               }
            }

            if(pLocIV != locIV)
#if defined(__INTEL_COMPILER)
              kmp_free(pLocIV);
#else
              free(pLocIV);
#endif
         }
         else
            return ippStsMemAllocErr;
      }

      return ippStsNoErr;
   }
}

#endif /* #ifdef _OPENMP */
