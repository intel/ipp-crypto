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
//     AES encryption/decryption (ECB mode)
// 
//  Contents:
//        ippsAESDecryptECB()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if defined( _OPENMP )
  #include <omp.h>
#endif

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif


/*
// AES-ECB denryption
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    nBlocks     number of decrypted data blocks
//    pCtx        pointer to the AES context
*/
static
void cpDecryptAES_ecb(const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks, const IppsAESSpec* pCtx)
{
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   /* use pipelined version is possible */
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      DecryptECB_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), nBlocks*MBS_RIJ128);
   }
   else
#endif
   {
      /* block-by-block decryption */
      RijnCipher decoder = RIJ_DECODER(pCtx);

      while(nBlocks) {
         //decoder((const Ipp32u*)pSrc, (Ipp32u*)pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), (const Ipp32u (*)[256])RIJ_DEC_SBOX(pCtx));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         decoder(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijDecSbox/*NULL*/);
         #else
         decoder(pSrc, pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), NULL);
         #endif

         pSrc += MBS_RIJ128;
         pDst += MBS_RIJ128;
         nBlocks--;
      }
   }
}

/*F*
//    Name: ippsAESDecryptECB
//
// Purpose: AES-ECB decryption.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//    ippStsContextMatchErr   !VALID_AES_ID()
//    ippStsLengthErr         dataLen <1
//    ippStsUnderRunErr       0!=(dataLen%MBS_RIJ128)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    len         input/output buffer length (in bytes)
//    pCtx        pointer to the AES context
//
*F*/
IPPFUN(IppStatus, ippsAESDecryptECB,(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                                     const IppsAESSpec* pCtx))
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned AES context */
   pCtx = (IppsAESSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_ID(pCtx), ippStsContextMatchErr);

   /* test source and target buffer pointers */
   IPP_BAD_PTR2_RET(pSrc, pDst);
   /* test stream length */
   IPP_BADARG_RET((len<1), ippStsLengthErr);
   /* test stream integrity */
   IPP_BADARG_RET((len&(MBS_RIJ128-1)), ippStsUnderRunErr);

   /* do encryption */
   {
      int nBlocks = len / MBS_RIJ128;

      #if !defined(_OPENMP)

      #if 0 // gres: temporary switched off
      #if(_IPP32E>=_IPP32E_K0)
      if (IsFeatureEnabled(ippCPUID_AVX512VAES))
         vaes_ecb_dec(pSrc, pDst, len, pCtx);
      else
      #endif
      #endif // gres
      cpDecryptAES_ecb(pSrc, pDst, nBlocks, pCtx);

      #else
      int blk_per_thread = AES_NI_ENABLED==RIJ_AESNI(pCtx)? AESNI128_MIN_BLK_PER_THREAD : RIJ128_MIN_BLK_PER_THREAD;
      int nThreads = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/blk_per_thread, 1));

      if(1==nThreads)
         cpDecryptAES_ecb(pSrc, pDst, nBlocks, pCtx);

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
               int id = omp_get_thread_num();
               Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*blksThreadReg * MBS_RIJ128;
               Ipp8u* pThreadDst = (Ipp8u*)pDst + id*blksThreadReg * MBS_RIJ128;
               int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;
               cpDecryptAES_ecb(pThreadSrc, pThreadDst, blkThread, pCtx);
            }
         }
      }
      #endif /* _OPENMP version */

      return ippStsNoErr;
   }
}
