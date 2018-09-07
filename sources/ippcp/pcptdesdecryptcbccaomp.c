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
//      ippsTDESDecryptCBC
// 
//  Purpose:
//      Cryptography Primitives.
//      Decrypt a byte data stream according to TDES.
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
//     ippsTDESDecryptCBC
//
// Purpose:
//     Decrypt byte data stream according to DES in EBC mode using OpenMP API.
//
// Returns:
//     ippStsNoErr              No errors, it's OK
//     ippStsNullPtrErr       ( pCtx1 == NULL ) || ( pCtx2 == NULL ) ||
//                            ( pCtx3 == NULL ) || ( pSrc  == NULL ) ||
//                            ( pDst ==  NULL ) || ( pIV   == NULL )
//     ippStsLengthErr          srcLen < 1
//     ippStsContextMatchErr  ( pCtx1->idCtx != idCtxDES ) ||
//                            ( pCtx2->idCtx != idCtxDES ) ||
//                            ( pCtx3->idCtx != idCtxDES )
//     ippStsUnderRunErr      ( srcLen % 8 ) != 0
//
// Parameters:
//     pSrc                     Pointer to the input ciphertext data stream.
//     pDst                     Pointer to the resulting plaintext data stream.
//     srcLen                   Ciphertext data stream length in bytes.
//     pCtx                     DES context.
//     pIV                      Pointers to the IppsDESSpec contexts.
//     padding                  Padding scheme indicator.
//
// Notes:
//
*F*/
static
void TDES_CBC_processing(const Ipp8u* pIV,
                         const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks,
                         const RoundKeyDES* pRKey[3])
{
   /* copy IV */
   Ipp64u iv;
   CopyBlock8(pIV, &iv);

   /*
   // decrypt block-by-block aligned streams
   */
   if( !(IPP_UINT_PTR(pSrc) & 0x7) && !(IPP_UINT_PTR(pDst) & 0x7) && pSrc!=pDst) {
      DecryptCBC_TDES((const Ipp64u*)pSrc, (Ipp64u*)pDst, nBlocks, pRKey, iv, DESspbox);
   }

   /*
   // decrypt block-by-block misaligned streams
   */
   else {
      Ipp64u tmpInp;
      Ipp64u tmpOut;

      while(nBlocks) {
         CopyBlock8(pSrc, &tmpInp);

         tmpOut = Cipher_DES(tmpInp, pRKey[0], DESspbox);
         tmpOut = Cipher_DES(tmpOut, pRKey[1], DESspbox);
         tmpOut = iv ^ Cipher_DES(tmpOut, pRKey[2], DESspbox);

         CopyBlock8(&tmpOut, pDst);

         iv = tmpInp;

         pSrc += MBS_DES;
         pDst += MBS_DES;
         nBlocks--;
      }
   }
}

IPPFUN( IppStatus, ippsTDESDecryptCBC,(const Ipp8u* pSrc, Ipp8u* pDst, int srcLen,
                                       const IppsDESSpec* pCtx1,
                                       const IppsDESSpec* pCtx2,
                                       const IppsDESSpec* pCtx3,
                                       const Ipp8u* pIV,
                                       IppsPadding padding))
{
   /* test the pointers */
   IPP_BAD_PTR3_RET(pCtx1, pCtx2, pCtx3);
   IPP_BAD_PTR3_RET(pSrc, pIV, pDst);

   /* align the context */
   pCtx1 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx1, DES_ALIGNMENT));
   pCtx2 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx2, DES_ALIGNMENT));
   pCtx3 = (IppsDESSpec*)(IPP_ALIGNED_PTR(pCtx3, DES_ALIGNMENT));

   /* test the context */
   IPP_BADARG_RET(!DES_ID_TEST(pCtx1), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx2), ippStsContextMatchErr);
   IPP_BADARG_RET(!DES_ID_TEST(pCtx3), ippStsContextMatchErr);

   /* test the data stream length */
   IPP_BADARG_RET((srcLen<1), ippStsLengthErr);

   /* Test data stream integrity. */
   IPP_BADARG_RET((srcLen&(MBS_DES-1)), ippStsUnderRunErr);

   UNREFERENCED_PARAMETER(padding);

   {
      int nBlocks = srcLen / MBS_DES;
      int nThreads  = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/TDES_MIN_BLK_PER_THREAD, 1));

      const RoundKeyDES* pRKey[3];
      pRKey[0] = DES_DKEYS(pCtx3);
      pRKey[1] = DES_EKEYS(pCtx2);
      pRKey[2] = DES_DKEYS(pCtx1);

      if(1==nThreads)
         TDES_CBC_processing(pIV, pSrc, pDst, nBlocks, pRKey);

      else {
         int blksThreadReg;
         int blksThreadTail;

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

                  CopyBlock8(pIV, pLocIV+0);
                  for(nt=1; nt<nThreads; nt++)
                     CopyBlock8(pSrc+nt*blksThreadReg*MBS_DES-MBS_DES, pLocIV+nt*MBS_DES);
               }
               #pragma omp barrier
               {
                  int id = omp_get_thread_num();
                  Ipp8u* pThreadIV  = (Ipp8u*)pLocIV +id*MBS_DES;
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*blksThreadReg*MBS_DES;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*blksThreadReg*MBS_DES;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;
                  TDES_CBC_processing(pThreadIV, pThreadSrc, pThreadDst, blkThread, pRKey);
               }
            }

            if (pLocIV != locIV)
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

#endif
