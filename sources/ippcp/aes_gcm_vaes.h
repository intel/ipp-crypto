/*******************************************************************************
* Copyright 2020 Intel Corporation
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
//     AES GCM AVX512-VAES
//     Internal Definitions and Internal Functions Prototypes
// 
*/

#ifndef __AES_GCM_VAES_H_
#define __AES_GCM_VAES_H_

#include "owndefs.h"
#include "owncp.h"


#if(_IPP32E>=_IPP32E_K0)

/* GCM data structures */
#define GCM_BLOCK_LEN   16

/**
 * @brief holds GCM operation context
 */
struct gcm_context_data {
        /* init, update and finalize context data */
        Ipp8u  aad_hash[GCM_BLOCK_LEN];
        Ipp64u aad_length;
        Ipp64u in_length;
        Ipp8u  partial_block_enc_key[GCM_BLOCK_LEN];
        Ipp8u  orig_IV[GCM_BLOCK_LEN];
        Ipp8u  current_counter[GCM_BLOCK_LEN];
        Ipp64u partial_block_length;
};

/* #define GCM_BLOCK_LEN   16 */
#define GCM_ENC_KEY_LEN 16
#define GCM_KEY_SETS    (15) /*exp key + 14 exp round keys*/

/**
 * @brief holds intermediate key data needed to improve performance
 *
 * gcm_key_data hold internal key information used by gcm128, gcm192 and gcm256.
 */
#ifdef __WIN32
__declspec(align(64))
#endif /* WIN32 */
struct gcm_key_data {
        Ipp8u expanded_keys[GCM_ENC_KEY_LEN * GCM_KEY_SETS];
        /*
        * (HashKey<<1 mod poly), (HashKey^2<<1 mod poly), ...,
        * (Hashkey^48<<1 mod poly)
        */
        Ipp8u shifted_hkey[GCM_ENC_KEY_LEN * 48];
}
#ifdef LINUX
__attribute__((aligned(64)));
#else
;
#endif

#define aes_gcm_enc_128_update_vaes_avx512 OWNAPI(aes_gcm_enc_128_update_vaes_avx512)
void aes_gcm_enc_128_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_enc_192_update_vaes_avx512 OWNAPI(aes_gcm_enc_192_update_vaes_avx512)
void aes_gcm_enc_192_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_enc_256_update_vaes_avx512 OWNAPI(aes_gcm_enc_256_update_vaes_avx512)
void aes_gcm_enc_256_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_dec_128_update_vaes_avx512 OWNAPI(aes_gcm_dec_128_update_vaes_avx512)
void aes_gcm_dec_128_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_dec_192_update_vaes_avx512 OWNAPI(aes_gcm_dec_192_update_vaes_avx512)
void aes_gcm_dec_192_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_dec_256_update_vaes_avx512 OWNAPI(aes_gcm_dec_256_update_vaes_avx512)
void aes_gcm_dec_256_update_vaes_avx512(const struct gcm_key_data *key_data,
                                   struct gcm_context_data *context_data,
                                   Ipp8u *out, const Ipp8u *in,
                                   Ipp64u len);

#define aes_gcm_enc_128_finalize_vaes_avx512 OWNAPI(aes_gcm_enc_128_finalize_vaes_avx512)
void aes_gcm_enc_128_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_enc_192_finalize_vaes_avx512 OWNAPI(aes_gcm_enc_192_finalize_vaes_avx512)
void aes_gcm_enc_192_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_enc_256_finalize_vaes_avx512 OWNAPI(aes_gcm_enc_256_finalize_vaes_avx512)
void aes_gcm_enc_256_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_dec_128_finalize_vaes_avx512 OWNAPI(aes_gcm_dec_128_finalize_vaes_avx512)
void aes_gcm_dec_128_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_dec_192_finalize_vaes_avx512 OWNAPI(aes_gcm_dec_192_finalize_vaes_avx512)
void aes_gcm_dec_192_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_dec_256_finalize_vaes_avx512 OWNAPI(aes_gcm_dec_256_finalize_vaes_avx512)
void aes_gcm_dec_256_finalize_vaes_avx512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     Ipp8u *auth_tag, Ipp64u auth_tag_len);

#define aes_gcm_precomp_128_vaes_avx512 OWNAPI(aes_gcm_precomp_128_vaes_avx512)
void aes_gcm_precomp_128_vaes_avx512(struct gcm_key_data *key_data);

#define aes_gcm_precomp_192_vaes_avx512 OWNAPI(aes_gcm_precomp_192_vaes_avx512)
void aes_gcm_precomp_192_vaes_avx512(struct gcm_key_data *key_data);

#define aes_gcm_precomp_256_vaes_avx512 OWNAPI(aes_gcm_precomp_256_vaes_avx512)
void aes_gcm_precomp_256_vaes_avx512(struct gcm_key_data *key_data);

#define aes_keyexp_128_enc_avx2 OWNAPI(aes_keyexp_128_enc_avx2)
void aes_keyexp_128_enc_avx2(const Ipp8u* key, struct gcm_key_data *key_data);

#define aes_keyexp_192_enc_avx2 OWNAPI(aes_keyexp_192_enc_avx2)
void aes_keyexp_192_enc_avx2(const Ipp8u* key, struct gcm_key_data *key_data);

#define aes_keyexp_256_enc_avx2 OWNAPI(aes_keyexp_256_enc_avx2)
void aes_keyexp_256_enc_avx2(const Ipp8u* key, struct gcm_key_data *key_data);

#define aes_gcm_aad_hash_update_vaes512 OWNAPI(aes_gcm_aad_hash_update_vaes512)
void aes_gcm_aad_hash_update_vaes512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     const Ipp8u *aad, const Ipp64u aad_len);

#define aes_gcm_aad_hash_finalize_vaes512 OWNAPI(aes_gcm_aad_hash_finalize_vaes512)
void aes_gcm_aad_hash_finalize_vaes512(const struct gcm_key_data *key_data,
                                       struct gcm_context_data *context_data,
                                       const Ipp8u *aad, const Ipp64u aad_len,
                                       const Ipp64u aad_general_len);

#define aes_gcm_iv_hash_update_vaes512 OWNAPI(aes_gcm_iv_hash_update_vaes512)
void aes_gcm_iv_hash_update_vaes512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     const Ipp8u *iv, const Ipp64u iv_len);

#define aes_gcm_iv_hash_finalize_vaes512 OWNAPI(aes_gcm_iv_hash_finalize_vaes512)
void aes_gcm_iv_hash_finalize_vaes512(const struct gcm_key_data *key_data,
                                     struct gcm_context_data *context_data,
                                     const Ipp8u *iv, const Ipp64u iv_len,
                                     const Ipp64u iv_general_len);

#endif /* #if(_IPP32E>=_IPP32E_K0) */

#endif
