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
//     AES encryption/decryption (CFB mode)
// 
//  Contents:
//        ippsAESDecryptCFB()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if defined(_OPENMP)
#  include "omp.h"
#endif

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif



/*F*
//    Name: ippsAESDecryptCFB
//
// Purpose: AES-CFB decryption.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pIV  == NULL
//    ippStsContextMatchErr   !VALID_AES_ID()
//    ippStsLengthErr         len <1
//    ippStsCFBSizeErr        (1>cfbBlkSize || cfbBlkSize>MBS_RIJ128)
//    ippStsUnderRunErr       0!=(dataLen%cfbBlkSize)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    len         output buffer length (in bytes)
//    cfbBlkSize  CFB block size (in bytes)
//    pCtx        pointer to the AES context
//    pIV         pointer to the initialization vector
//
*F*/
static
void cpDecryptAES_cfb(const Ipp8u* pIV,
                      const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks, int cfbBlkSize,
                      const IppsAESSpec* pCtx)
{
#if(_IPP32E>=_IPP32E_K0)
   if (IsFeatureEnabled(ippCPUID_AVX512VAES)) {
      if(cfbBlkSize==MBS_RIJ128)
         DecryptCFB128_RIJ128pipe_VAES_NI(pSrc, pDst, nBlocks*cfbBlkSize, pCtx, pIV);
      else if (8 == cfbBlkSize)
         DecryptCFB64_RIJ128pipe_VAES_NI(pSrc, pDst, nBlocks*cfbBlkSize, pCtx, pIV);
      else
      // NB: excluded VBMI2 version of VAES optimization from MSVC build until compiler supports VBMI2
      #if defined (_MSC_VER) && !defined (__INTEL_COMPILER)
         goto msvc_fallback;
      #else
         DecryptCFB_RIJ128pipe_VAES_NI(pSrc, pDst, nBlocks*cfbBlkSize, cfbBlkSize, pCtx, pIV);
      #endif
   }
   else
#endif
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   /* use pipelined version is possible */
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      #if defined (_MSC_VER) && !defined (__INTEL_COMPILER)
msvc_fallback:
      #endif
      if(cfbBlkSize==MBS_RIJ128)
         DecryptCFB128_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), nBlocks*cfbBlkSize, pIV);
      else if(0==(cfbBlkSize&3))
         DecryptCFB32_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), nBlocks, cfbBlkSize, pIV);
      else
         DecryptCFB_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), nBlocks, cfbBlkSize, pIV);
   }
   else
#endif
   {
      Ipp32u tmpInp[2*NB(128)];
      Ipp32u tmpOut[  NB(128)];

      /* setup encoder method */
      RijnCipher encoder = RIJ_ENCODER(pCtx);

      /* read IV */
      CopyBlock16(pIV, tmpInp);

      /* decrypt data block-by-block of cfbLen each */
      while(nBlocks) {
         /* decryption */
         //encoder(tmpInp, tmpOut, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pCtx));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)tmpInp, (Ipp8u*)tmpOut, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)tmpInp, (Ipp8u*)tmpOut, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         /* store output and put feedback into the input buffer (tmpInp) */
         if( cfbBlkSize==MBS_RIJ128 && pSrc!=pDst) {
            ((Ipp32u*)pDst)[0] = tmpOut[0]^((Ipp32u*)pSrc)[0];
            ((Ipp32u*)pDst)[1] = tmpOut[1]^((Ipp32u*)pSrc)[1];
            ((Ipp32u*)pDst)[2] = tmpOut[2]^((Ipp32u*)pSrc)[2];
            ((Ipp32u*)pDst)[3] = tmpOut[3]^((Ipp32u*)pSrc)[3];

            tmpInp[0] = ((Ipp32u*)pSrc)[0];
            tmpInp[1] = ((Ipp32u*)pSrc)[1];
            tmpInp[2] = ((Ipp32u*)pSrc)[2];
            tmpInp[3] = ((Ipp32u*)pSrc)[3];
         }
         else {
            int n;
            for(n=0; n<cfbBlkSize; n++) {
               ((Ipp8u*)tmpInp)[MBS_RIJ128+n] = pSrc[n];
               pDst[n] = (Ipp8u)( ((Ipp8u*)tmpOut)[n] ^ pSrc[n] );
            }

            /* shift input buffer (tmpInp) for the next CFB operation */
            CopyBlock16((Ipp8u*)tmpInp+cfbBlkSize, tmpInp);
         }

         pSrc += cfbBlkSize;
         pDst += cfbBlkSize;
         nBlocks--;
      }
   }
}

IPPFUN(IppStatus, ippsAESDecryptCFB,(const Ipp8u* pSrc, Ipp8u* pDst, int len, int cfbBlkSize,
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
   /* test CFB value */
   IPP_BADARG_RET(((1>cfbBlkSize) || (MBS_RIJ128<cfbBlkSize)), ippStsCFBSizeErr);

   /* test stream integrity */
   IPP_BADARG_RET((len%cfbBlkSize), ippStsUnderRunErr);

   /* do encryption */
   {
      int nBlocks = len / cfbBlkSize;

      #if !defined(_OPENMP)
      cpDecryptAES_cfb(pIV, pSrc, pDst, nBlocks, cfbBlkSize, pCtx);

      #else
      int blk_per_thread = AES_NI_ENABLED==RIJ_AESNI(pCtx)? AESNI128_MIN_BLK_PER_THREAD : RIJ128_MIN_BLK_PER_THREAD;
      int nThreads = IPP_MIN(IPPCP_GET_NUM_THREADS(), IPP_MAX(nBlocks/blk_per_thread, 1));

      if(1==nThreads)
         cpDecryptAES_cfb(pIV, pSrc, pDst, nBlocks, cfbBlkSize, pCtx);

      else {
         int blksThreadReg;
         int blksThreadTail;
         int srcBlkSize;
         int ivBlkSize;

         Ipp8u locIV[MBS_RIJ128*DEFAULT_CPU_NUM];
#if defined (__INTEL_COMPILER)
         Ipp8u* pLocIV = nThreads>DEFAULT_CPU_NUM? kmp_malloc(nThreads*MBS_RIJ128) : locIV;
#else
         Ipp8u* pLocIV = nThreads>DEFAULT_CPU_NUM ? malloc(nThreads*MBS_RIJ128) : locIV;
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
                  ivBlkSize  = IPP_MIN(MBS_RIJ128,srcBlkSize);

                  CopyBlock16(pIV, pLocIV+0);
                  for(nt=1; nt<nThreads; nt++)
                     CopyBlock(pSrc+nt*srcBlkSize-ivBlkSize, pLocIV+MBS_RIJ128+(nt-1)*ivBlkSize, ivBlkSize);
               }
               #pragma omp barrier
               {
                  int id = omp_get_thread_num();
                  Ipp8u* pThreadIV  = pLocIV + id*ivBlkSize;
                  Ipp8u* pThreadSrc = (Ipp8u*)pSrc + id*srcBlkSize;
                  Ipp8u* pThreadDst = (Ipp8u*)pDst + id*srcBlkSize;
                  int blkThread = (id==(nThreads-1))? blksThreadTail : blksThreadReg;
                  cpDecryptAES_cfb(pThreadIV, pThreadSrc, pThreadDst, blkThread, cfbBlkSize, pCtx);
               }
            }

            if(pLocIV != locIV)
#if defined (__INTEL_COMPILER)
              kmp_free(pLocIV);
#else
              free(pLocIV);
#endif
         }
         else
            return ippStsMemAllocErr;

      }
      #endif

      return ippStsNoErr;
   }
}
