/*******************************************************************************
* Copyright (C) 2023 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the 'License');
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an 'AS IS' BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions
* and limitations under the License.
* 
*******************************************************************************/

/*
//
//  Purpose:
//     Cryptography Primitive.
//     Initialization functions for internal methods and pointers
//     AES cipher context
//     AES-GCM context
//
*/

#include "pcpaesminit_internal.h"
#include "aes_gcm_avx512.h"
#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if (_IPP32E >= _IPP32E_K0)
#include "pcpaesauthgcm_avx512.h"
#else
#include "pcpaesauthgcm.h"
#endif /* #if(_IPP32E>=_IPP32E_K0) */

/*
 * This function set up pointers to encryption and decryption key schedules,
 * dispatches to the right internal methods and sets pointers to them inside the AES state.
 */
IPP_OWN_DEFN(void, cpAes_setup_ptrs_and_methods, (IppsAESSpec * pCtx))
{
   int nExpKeys = rij128nKeys[rij_index(RIJ_NK(pCtx))];

   RIJ_EKEYS(pCtx) = (Ipp8u *)(IPP_ALIGNED_PTR(RIJ_KEYS_BUFFER(pCtx), AES_ALIGNMENT));
   RIJ_DKEYS(pCtx) = (Ipp8u *)((Ipp32u *)RIJ_EKEYS(pCtx) + nExpKeys);

#if (_AES_NI_ENABLING_ == _FEATURE_ON_)
   RIJ_AESNI(pCtx)   = AES_NI_ENABLED;
   RIJ_ENCODER(pCtx) = Encrypt_RIJ128_AES_NI; /* AES_NI based encoder */
   RIJ_DECODER(pCtx) = Decrypt_RIJ128_AES_NI; /* AES_NI based decoder */
#else
#if (_AES_NI_ENABLING_ == _FEATURE_TICKTOCK_)
   if (IsFeatureEnabled(ippCPUID_AES) || IsFeatureEnabled(ippCPUID_AVX2VAES)) {
      RIJ_AESNI(pCtx)   = AES_NI_ENABLED;
      RIJ_ENCODER(pCtx) = Encrypt_RIJ128_AES_NI; /* AES_NI based encoder */
      RIJ_DECODER(pCtx) = Decrypt_RIJ128_AES_NI; /* AES_NI based decoder */
   } else
#endif
   {
#if (_ALG_AES_SAFE_ == _ALG_AES_SAFE_COMPOSITE_GF_)
      {
         RIJ_ENCODER(pCtx) = SafeEncrypt_RIJ128; /* safe encoder (composite GF) */
         RIJ_DECODER(pCtx) = SafeDecrypt_RIJ128; /* safe decoder (composite GF)*/
      }
#else
      {
         RIJ_ENCODER(pCtx) = Safe2Encrypt_RIJ128; /* safe encoder (compact Sbox)) */
         RIJ_DECODER(pCtx) = Safe2Decrypt_RIJ128; /* safe decoder (compact Sbox)) */
      }
#endif
   }
#endif
}

/*
 * This function dispatches to the right internal methods and sets pointers to them inside the AES-GCM state.
 */
IPP_OWN_DEFN(void, cpAesGCM_setup_ptrs_and_methods, (IppsAES_GCMState * pState, Ipp64u keyByteLen))
{
#if (_IPP32E >= _IPP32E_K0)
   if (IsFeatureEnabled(ippCPUID_AVX512VAES) && IsFeatureEnabled(ippCPUID_AVX512VCLMUL)) {
      switch (keyByteLen) {
      case 16:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_128_update_vaes_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_128_update_vaes_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_128_vaes_avx512;
         break;
      case 24:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_192_update_vaes_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_192_update_vaes_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_192_vaes_avx512;
         break;
      case 32:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_256_update_vaes_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_256_update_vaes_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_256_vaes_avx512;
         break;
      }

      AES_GCM_IV_UPDATE(pState)   = aes_gcm_iv_hash_update_vaes512;
      AES_GCM_IV_FINALIZE(pState) = aes_gcm_iv_hash_finalize_vaes512;
      AES_GCM_AAD_UPDATE(pState)  = aes_gcm_aad_hash_update_vaes512;
      AES_GCM_GMUL(pState)        = aes_gcm_gmult_vaes512;
   } else {
      switch (keyByteLen) {
      case 16:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_128_update_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_128_update_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_128_avx512;
         break;
      case 24:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_192_update_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_192_update_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_192_avx512;
         break;
      case 32:
         AES_GCM_ENCRYPT_UPDATE(pState) = aes_gcm_enc_256_update_avx512;
         AES_GCM_DECRYPT_UPDATE(pState) = aes_gcm_dec_256_update_avx512;
         AES_GCM_GET_TAG(pState)        = aes_gcm_gettag_256_avx512;
         break;
      }

      AES_GCM_IV_UPDATE(pState)   = aes_gcm_iv_hash_update_avx512;
      AES_GCM_IV_FINALIZE(pState) = aes_gcm_iv_hash_finalize_avx512;
      AES_GCM_AAD_UPDATE(pState)  = aes_gcm_aad_hash_update_avx512;
      AES_GCM_GMUL(pState)        = aes_gcm_gmult_avx512;
   }
#else
   IPP_UNREFERENCED_PARAMETER(keyByteLen);

   /* set up:
   // - ghash function
   // - authentication function
   */
   AESGCM_HASH(pState) = AesGcmMulGcm_table2K_ct; // AesGcmMulGcm_table2K;
   AESGCM_AUTH(pState) = AesGcmAuth_table2K_ct;   // AesGcmAuth_table2K;
   AESGCM_ENC(pState)  = wrpAesGcmEnc_table2K;
   AESGCM_DEC(pState)  = wrpAesGcmDec_table2K;

#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
// the dead code that currently is unused
//#if (_IPP32E >= _IPP32E_K0)
//   if (IsFeatureEnabled(ippCPUID_AVX512VAES)) {
//      AESGCM_HASH(pState) = AesGcmMulGcm_vaes;
//      AESGCM_AUTH(pState) = AesGcmAuth_vaes;
//      AESGCM_ENC(pState)  = AesGcmEnc_vaes;
//      AESGCM_DEC(pState)  = AesGcmDec_vaes;
//   } else
//#endif /* #if(_IPP32E>=_IPP32E_K0) */
      if (IsFeatureEnabled(ippCPUID_AES | ippCPUID_CLMUL)) {
         AESGCM_HASH(pState) = AesGcmMulGcm_avx;
         AESGCM_AUTH(pState) = AesGcmAuth_avx;
         AESGCM_ENC(pState)  = wrpAesGcmEnc_avx;
         AESGCM_DEC(pState)  = wrpAesGcmDec_avx;
      }
#if (_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9)
      if (IsFeatureEnabled(ippCPUID_AVX2VAES | ippCPUID_AVX2VCLMUL)) {
         AESGCM_HASH(pState) = AesGcmMulGcm_avx;
         AESGCM_AUTH(pState) = AesGcmAuth_avx;
         AESGCM_ENC(pState)  =  AesGcmEnc_vaes_avx2;
         AESGCM_DEC(pState)  = AesGcmDec_vaes_avx2;
      }
#endif /* #if(_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9) */
#endif /* #if(_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8) */

#endif /* #if(_IPP32E>=_IPP32E_K0) */
}
