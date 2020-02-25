/*******************************************************************************
* Copyright 2013-2020 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

/*
//
//  Purpose:
//     Cryptography Primitive.
//     AES-GCM
//
//  Contents:
//        ippsAES_GCMInit()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  include "pcprijtables.h"
#endif

/*F*
//    Name: ippsAES_GCMInit
//
// Purpose: Init AES_GCM context for future usage.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//    ippStsMemAllocErr       size of buffer is not match fro operation
//    ippStsLengthErr         keyLen != 16 &&
//                                   != 24 &&
//                                   != 32
//    ippStsNoErr             no errors
//
// Parameters:
//    pKey        pointer to the secret key
//    keyLen      length of secret key
//    pState      pointer to the AES-GCM context
//    ctxSize     available size (in bytes) of buffer above
//
*F*/
IPPFUN(IppStatus, ippsAES_GCMInit,(const Ipp8u* pKey, int keyLen, IppsAES_GCMState* pState, int ctxSize))
{
   /* test pCtx pointer */
   IPP_BAD_PTR1_RET(pState);

   /* test available size of context buffer */
   IPP_BADARG_RET(ctxSize<cpSizeofCtx_AESGCM(), ippStsMemAllocErr);

   /* use aligned context */
   pState = (IppsAES_GCMState*)( IPP_ALIGNED_PTR(pState, AESGCM_ALIGNMENT) );

   /* set and clear GCM context */
   AESGCM_ID(pState) = idCtxAESGCM;
   ippsAES_GCMReset(pState);

   /* init cipher */
   {
      IppStatus sts = ippsAESInit(pKey, keyLen, AESGCM_CIPHER(pState), cpSizeofCtx_AES());
      if(ippStsNoErr!=sts)
         return sts;
   }

   /* set up:
   // - ghash function
   // - authentication function
   */
   AESGCM_HASH(pState) = AesGcmMulGcm_table2K_ct;//AesGcmMulGcm_table2K;
   AESGCM_AUTH(pState) = AesGcmAuth_table2K_ct; //AesGcmAuth_table2K;
   AESGCM_ENC(pState)  = wrpAesGcmEnc_table2K;
   AESGCM_DEC(pState)  = wrpAesGcmDec_table2K;

   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   #if(_IPP32E>=_IPP32E_K0)
   if (IsFeatureEnabled(ippCPUID_AVX512VAES)) {
      AESGCM_HASH(pState) = AesGcmMulGcm_vaes;
      AESGCM_AUTH(pState) = AesGcmAuth_vaes;
      AESGCM_ENC(pState) = AesGcmEnc_vaes;
      AESGCM_DEC(pState) = AesGcmDec_vaes;
   }
   else
   #endif /* #if(_IPP32E>=_IPP32E_K0) */
   if( IsFeatureEnabled(ippCPUID_AES|ippCPUID_CLMUL) ) {
      AESGCM_HASH(pState) = AesGcmMulGcm_avx;
      AESGCM_AUTH(pState) = AesGcmAuth_avx;
      AESGCM_ENC(pState) = wrpAesGcmEnc_avx;
      AESGCM_DEC(pState) = wrpAesGcmDec_avx;
   }
   #endif

   /* precomputations (for constant multiplier(s)) */
   {
      IppsAESSpec* pAES = AESGCM_CIPHER(pState);
      RijnCipher encoder = RIJ_ENCODER(pAES);

      /* multiplier c = Enc({0}) */
      PadBlock(0, AESGCM_HKEY(pState), BLOCK_SIZE);
      //encoder((Ipp32u*)AESGCM_HKEY(pState), (Ipp32u*)AESGCM_HKEY(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pAES));
      #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
      encoder(AESGCM_HKEY(pState), AESGCM_HKEY(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
      #else
      encoder(AESGCM_HKEY(pState), AESGCM_HKEY(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
      #endif
   }

   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   #if(_IPP32E>=_IPP32E_K0)
   if (IsFeatureEnabled(ippCPUID_AVX512VAES)) {
      /* pre-compute hKey<<1, (hKey<<1)^2, (hKey<<1)^3, ... , (hKey<<1)^15 and corresponding
         Karatsuba constant multipliers for aggregated reduction */
      AesGcmPrecompute_vaes(AESGCM_CPWR(pState), AESGCM_HKEY(pState));
   }
   else
   #endif /* #if(_IPP32E>=_IPP32E_K0) */
   if( IsFeatureEnabled(ippCPUID_AES|ippCPUID_CLMUL) ) {
      /* pre-compute reflect(hkey) and hKey<<1, (hKey<<1)^2 and (hKey<<1)^4 powers of hKey */
      AesGcmPrecompute_avx(AESGCM_CPWR(pState), AESGCM_HKEY(pState));
   }
   else
   #endif
      AesGcmPrecompute_table2K(AES_GCM_MTBL(pState), AESGCM_HKEY(pState));

   return ippStsNoErr;
}
