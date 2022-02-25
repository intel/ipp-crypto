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

%ifndef _GCM_IPPCP_API_VAES_AVX512_INC_
%define _GCM_IPPCP_API_VAES_AVX512_INC_

%include "gcm_vaes_avx512.inc"

section .text
default rel

%ifdef GCM128_MODE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_iv_hash_update_vaes512(
;        const struct gcm_key_data *key_data,
;        struct       gcm_context_data *context_data,
;        const u8    *iv,
;        const u64    iv_len);
;
; NB: |iv_len| shall be multiple of 16 bytes (block size). This restriction is handled outside.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM aes_gcm_iv_hash_update_vaes512, PUBLIC
        FUNC_SAVE

        vmovdqu64       xmm8, [arg2 + OrigIV]   ; load current hash

        ;; Calculate GHASH of this segment
        CALC_AAD_HASH arg3, arg4, xmm8, arg1, zmm1, zmm2, zmm3, zmm4, zmm5, \
                      zmm6, zmm7, zmm9, zmm10, zmm11, zmm12, zmm13, zmm15, \
                      zmm16, zmm17, zmm18, zmm19, zmm20, r10, r11, r12, k1

        vmovdqu64       [arg2 + OrigIV], xmm8   ; store updated hash

        FUNC_RESTORE

        ret
ENDFUNC aes_gcm_iv_hash_update_vaes512

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_iv_hash_finalize_vaes512(
;        const struct gcm_key_data *key_data,
;        struct       gcm_context_data *context_data,
;        const u8    *iv,
;        const u64    iv_len,
;        const u64    iv_general_len);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM aes_gcm_iv_hash_finalize_vaes512, PUBLIC
        FUNC_SAVE

        cmp     arg5, 12
        jnz     .Liv_is_not_12_bytes

        ;; read 12 IV bytes and pad with 0x00000001
        vmovdqa64       xmm2, [rel ONEf]
        mov             r11, arg3
        mov             DWORD(r10), 0x0000_0fff
        kmovd           k1, DWORD(r10)
        vmovdqu8        xmm2{k1}, [r11]      ; ctr = IV | 0x1

        jmp .Liv_compute_done

.Liv_is_not_12_bytes:
        vmovdqu         xmm2, [arg2 + OrigIV]

        ;; prepare IV
        CALC_J0 arg1, arg3, arg4, xmm2, \
                zmm1, zmm11, zmm3, zmm4, zmm5, zmm6, zmm7, zmm8, zmm9, zmm10, \
                zmm12, zmm13, zmm15, zmm16, zmm17, zmm18, zmm19, zmm20, \
                r10, r11, r12, k1, arg5

.Liv_compute_done:
        vmovdqu64       [arg2 + OrigIV], xmm2    ; ctx.orig_IV = iv
        vpshufb         xmm2, [rel SHUF_MASK]
        vmovdqu64       [arg2 + CurCount], xmm2 ; ctx.current_counter = iv (LE format)

        FUNC_RESTORE

        ret
ENDFUNC aes_gcm_iv_hash_finalize_vaes512

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_aad_hash_update_vaes512(
;        const struct gcm_key_data *key_data,
;        struct       gcm_context_data *context_data,
;        const u8    *aad,
;        const u64    aad_len);
;
; NB: This function is always called with |aad_len| that is multiple of 16 bytes (block size).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM aes_gcm_aad_hash_update_vaes512, PUBLIC
        FUNC_SAVE

        vmovdqu64       xmm14, [arg2 + AadHash]   ; load current hash

        ;; Calculate GHASH of this segment
        CALC_AAD_HASH arg3, arg4, xmm14, arg1, zmm1, zmm2, zmm3, zmm4, zmm5, \
                      zmm6, zmm7, zmm9, zmm10, zmm11, zmm12, zmm13, zmm15, \
                      zmm16, zmm17, zmm18, zmm19, zmm20, r10, r11, r12, k1

        vmovdqu64       [arg2 + AadHash], xmm14   ; store updated hash

        FUNC_RESTORE

        ret
ENDFUNC aes_gcm_aad_hash_update_vaes512

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void   aes_gcm_gmult_vaes512(
;        struct       gcm_context_data *context_data,
;        u8    *ghash)
;
; Function updates |ghash| value by multiplying it on H^1 key.
; Leaf function.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IPPASM aes_gcm_gmult_vaes512, PUBLIC

        vmovdqu64         xmm1, [arg2]
        vmovdqu64         xmm2, [arg1 + HashKey_1]

        GHASH_MUL xmm1, xmm2, xmm3, xmm4, xmm5, xmm16, xmm17

        vmovdqu64         [arg2], xmm1

        ret
ENDFUNC aes_gcm_gmult_vaes512

%endif                          ; GCM128_MODE

%endif                          ; _GCM_IPPCP_API_VAES_AVX512_INC_
