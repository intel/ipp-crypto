;===============================================================================
; Copyright 2020 Intel Corporation
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;===============================================================================

%ifndef _GCM_API_VAES_AVX512_INC_
%define _GCM_API_VAES_AVX512_INC_

%include "gcm_vaes_avx512.inc"

section .text
default rel

;; Safe param check is disabled as parameters checking is done outside.
%ifdef SAFE_PARAM
%undef SAFE_PARAM
%endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_precomp_128_vaes_avx512 /
;       aes_gcm_precomp_192_vaes_avx512 /
;       aes_gcm_precomp_256_vaes_avx512
;       (struct gcm_key_data *key_data)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM FN_NAME(precomp,_), PUBLIC
;; Parameter is passed through register
%ifdef SAFE_PARAM
        ;; Check key_data != NULL
        cmp     arg1, 0
        jz      .exit_precomp
%endif

        FUNC_SAVE

        vpxor   xmm6, xmm6
        ENCRYPT_SINGLE_BLOCK    arg1, xmm6              ; xmm6 = HashKey

        vpshufb  xmm6, [rel SHUF_MASK]
        ;;;;;;;;;;;;;;;  PRECOMPUTATION of HashKey<<1 mod poly from the HashKey;;;;;;;;;;;;;;;
        vmovdqa  xmm2, xmm6
        vpsllq   xmm6, xmm6, 1
        vpsrlq   xmm2, xmm2, 63
        vmovdqa  xmm1, xmm2
        vpslldq  xmm2, xmm2, 8
        vpsrldq  xmm1, xmm1, 8
        vpor     xmm6, xmm6, xmm2
        ;reduction
        vpshufd  xmm2, xmm1, 00100100b
        vpcmpeqd xmm2, [rel TWOONE]
        vpand    xmm2, xmm2, [rel POLY]
        vpxor    xmm6, xmm6, xmm2                       ; xmm6 holds the HashKey<<1 mod poly
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        vmovdqu  [arg1 + HashKey], xmm6                 ; store HashKey<<1 mod poly


        PRECOMPUTE arg1, xmm6, xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm7, xmm8

        FUNC_RESTORE
.exit_precomp:

        ret

ENDFUNC FN_NAME(precomp,_)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_enc_128_update_vaes_avx512 / aes_gcm_enc_192_update_vaes_avx512 /
;       aes_gcm_enc_256_update_vaes_avx512
;       (const struct gcm_key_data *key_data,
;        struct gcm_context_data *context_data,
;        u8       *out,
;        const u8 *in,
;        u64      plaintext_len);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM FN_NAME(enc,_update_), PUBLIC

        FUNC_SAVE

%ifdef SAFE_PARAM
        ;; Check key_data != NULL
        cmp     arg1, 0
        jz      .exit_update_enc

        ;; Check context_data != NULL
        cmp     arg2, 0
        jz      .exit_update_enc

        ;; Check if plaintext_len == 0
        cmp     arg5, 0
        jz      .exit_update_enc

        ;; Check out != NULL (plaintext_len != 0)
        cmp     arg3, 0
        jz      .exit_update_enc

        ;; Check in != NULL (plaintext_len != 0)
        cmp     arg4, 0
        jz      .exit_update_enc
%endif
        GCM_ENC_DEC arg1, arg2, arg3, arg4, arg5, ENC, multi_call

.exit_update_enc:
        FUNC_RESTORE
        ret

ENDFUNC FN_NAME(enc,_update_)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_dec_128_update_vaes_avx512 / aes_gcm_dec_192_update_vaes_avx512 /
;       aes_gcm_dec_256_update_vaes_avx512
;       (const struct gcm_key_data *key_data,
;        struct gcm_context_data *context_data,
;        u8       *out,
;        const u8 *in,
;        u64      plaintext_len);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM FN_NAME(dec,_update_), PUBLIC
        FUNC_SAVE

%ifdef SAFE_PARAM
        ;; Check key_data != NULL
        cmp     arg1, 0
        jz      .exit_update_dec

        ;; Check context_data != NULL
        cmp     arg2, 0
        jz      .exit_update_dec

        ;; Check if plaintext_len == 0
        cmp     arg5, 0
        jz      .exit_update_dec

        ;; Check out != NULL (plaintext_len != 0)
        cmp     arg3, 0
        jz      .exit_update_dec

        ;; Check in != NULL (plaintext_len != 0)
        cmp     arg4, 0
        jz      .exit_update_dec
%endif

        GCM_ENC_DEC arg1, arg2, arg3, arg4, arg5, DEC, multi_call

.exit_update_dec:
        FUNC_RESTORE
        ret

ENDFUNC FN_NAME(dec,_update_)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_gettag_128_vaes_avx512 / aes_gcm_gettag_192_vaes_avx512 /
;       aes_gcm_gettag_256_vaes_avx512
;       (const struct gcm_key_data *key_data,
;        struct gcm_context_data *context_data,
;        u8       *auth_tag,
;        u64      auth_tag_len);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM FN_NAME(gettag,_), PUBLIC

;; All parameters are passed through registers
%ifdef SAFE_PARAM
        ;; Check key_data != NULL
        cmp     arg1, 0
        jz      .exit_enc_fin

        ;; Check context_data != NULL
        cmp     arg2, 0
        jz      .exit_enc_fin

        ;; Check auth_tag != NULL
        cmp     arg3, 0
        jz      .exit_enc_fin

        ;; Check auth_tag_len == 0 or > 16
        cmp     arg4, 0
        jz      .exit_enc_fin

        cmp     arg4, 16
        ja      .exit_enc_fin
%endif

        FUNC_SAVE
        GCM_COMPLETE    arg1, arg2, arg3, arg4, multi_call, k1, r10, r11, r12

        FUNC_RESTORE

.exit_enc_fin:
        ret

ENDFUNC FN_NAME(gettag,_)

%endif                          ; _GCM_API_VAES_AVX512_INC_
