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
//     AES encryption/decryption (CBC mode)
//     AES encryption/decryption (CBC-CS mode)
// 
//  Contents:
//        ippsAESDecryptCBC()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "pcpaes_cbc.h"

#if defined( _OPENMP )
  #include <omp.h>
#endif

/*F*
//    Name: ippsAESDecryptCBC
//
// Purpose: AES-CBC decryption.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pIV  == NULL
//    ippStsContextMatchErr   !VALID_AES_ID()
//    ippStsLengthErr         len <1
//    ippStsUnderRunErr       0!=(dataLen%MBS_RIJ128)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    len         input/output buffer length (in bytes)
//    pCtx        pointer to the AES context
//    pIV         pointer to the initialization vector
//
*F*/
IPPFUN(IppStatus, ippsAESDecryptCBC,(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                                     const IppsAESSpec* pCtx,
                                     const Ipp8u* pIV))
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned AES context */
   pCtx = (IppsAESSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_ID(pCtx), ippStsContextMatchErr);

   /* test source, target buffers and initialization pointers */
   IPP_BAD_PTR3_RET(pSrc, pIV, pDst);
   /* test stream length */
   IPP_BADARG_RET((len<1), ippStsLengthErr);
   /* test stream integrity */
   IPP_BADARG_RET((len&(MBS_RIJ128-1)), ippStsUnderRunErr);

   /* do encryption */
   {
      int nBlocks = len / MBS_RIJ128;

      #if !defined(_OPENMP)
      cpDecryptAES_cbc(pIV, pSrc, pDst, nBlocks, pCtx);

      #else
      int blk_per_thread = AES_NI_ENABLED==RIJ_AESNI(pCtx)? AESNI128_MIN_BLK_PER_THREAD : RIJ128_MIN_BLK_PER_THREAD;
      int nThreads = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/blk_per_thread, 1));

      if(1==nThreads)
         cpDecryptAES_cbc(pIV, pSrc, pDst, nBlocks, pCtx);

      else {
         int blksThreadReg;
         int blksThreadTail;

         Ipp8u locIV[MBS_RIJ128*DEFAULT_CPU_NUM];
         Ipp8u* pLocIV = nThreads>DEFAULT_CPU_NUM? kmp_malloc(nThreads*MBS_RIJ128) : locIV;

         if(pLocIV) {
            #pragma omp parallel IPPCP_OMP_LIMIT_MAX_NUM_THREADS(nThreads)
            {
               #pragma omp master
               {
                  int nt;
                  nThreads = omp_get_num_threads();
                  blksThreadReg = nBlocks / nThreads;
                  blksThreadTail = blksThreadReg + nBlocks % nThreads;

                  CopyBlock16(pIV, pLocIV+0);
                  for(nt=1; nt<nThreads; nt++)
                     CopyBlock16(pSrc+nt*blksThreadReg*MBS_RIJ128-MBS_RIJ128, pLocIV+nt*MBS_RIJ128);
               }
               #pragma omp barrier
               {
                  int id          = omp_get_thread_num();
                  Ipp8u* pThreadIV  = (Ipp8u*)pLocIV +id*MBS_RIJ128;
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*blksThreadReg * MBS_RIJ128;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*blksThreadReg * MBS_RIJ128;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;
                  cpDecryptAES_cbc(pThreadIV, pThreadSrc, pThreadDst, blkThread, pCtx);
               }
            }

            if(pLocIV != locIV)
               kmp_free(pLocIV);
         }
         else
            return ippStsMemAllocErr;
      }
      #endif

      return ippStsNoErr;
   }
}
