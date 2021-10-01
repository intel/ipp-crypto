/*******************************************************************************
* Copyright 2021 Intel Corporation
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

#if !defined(_SM4_GFNI_MB_H)
#define _SM4_GFNI_MB_H

#include <crypto_mb/defs.h>
#include <crypto_mb/sm4.h>

#include <immintrin.h>

#ifndef M128
#define M128(mem)   (*((__m128i*)(mem)))
#endif
#ifndef M256
#define M256(mem)   (*((__m256i*)(mem)))
#endif
#ifndef M512
#define M512(mem)   (*((__m512i*)(mem)))
#endif

/*
// Constants
*/

static __ALIGN64 const int8u permMask_in[] = {
    0,0x00,0x00,0x00, 4,0x00,0x00,0x00, 8,0x00,0x00,0x00,  12,0x00,0x00,0x00,
    1,0x00,0x00,0x00, 5,0x00,0x00,0x00, 9,0x00,0x00,0x00,  13,0x00,0x00,0x00,
    2,0x00,0x00,0x00, 6,0x00,0x00,0x00, 10,0x00,0x00,0x00, 14,0x00,0x00,0x00,
    3,0x00,0x00,0x00, 7,0x00,0x00,0x00, 11,0x00,0x00,0x00, 15,0x00,0x00,0x00
};

static __ALIGN64 const int8u permMask_out[] = {
    12,0x00,0x00,0x00, 8,0x00,0x00,0x00, 4,0x00,0x00,0x00, 0,0x00,0x00,0x00,
    13,0x00,0x00,0x00, 9,0x00,0x00,0x00, 5,0x00,0x00,0x00, 1,0x00,0x00,0x00,
    14,0x00,0x00,0x00, 10,0x00,0x00,0x00, 6,0x00,0x00,0x00, 2,0x00,0x00,0x00,
    15,0x00,0x00,0x00, 11,0x00,0x00,0x00, 7,0x00,0x00,0x00, 3,0x00,0x00,0x00
};

static __ALIGN64 const int8u affineIn[] = {
    0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34, 0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34,
    0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34, 0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34,
    0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34, 0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34,
    0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34, 0x52,0xBC,0x2D,0x02,0x9E,0x25,0xAC,0x34
};

static __ALIGN64 const int8u affineOut[] = {
    0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7, 0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7,
    0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7, 0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7,
    0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7, 0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7,
    0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7, 0x19,0x8b,0x6c,0x1e,0x51,0x8e,0x2d,0xd7
};
// Constant for swapping the bytes inside the words
static __ALIGN64 const int8u swapBytes[] = { 
    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12,
    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12,
    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12,
    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12 
};
// Constant for swapping the endiannes
static __ALIGN64 const int8u swapEndianness[] = { 
    15,14,13,12, 11,10,9,8, 7,6,5,4, 3,2,1,0,
    15,14,13,12, 11,10,9,8, 7,6,5,4, 3,2,1,0,
    15,14,13,12, 11,10,9,8, 7,6,5,4, 3,2,1,0,
    15,14,13,12, 11,10,9,8, 7,6,5,4, 3,2,1,0 
};
// Constant for swapping the order of words
static __ALIGN64 const int8u swapWordsOrder[] = {
    12,13,14,15, 8,9,10,11, 4,5,6,7, 0,1,2,3,
    12,13,14,15, 8,9,10,11, 4,5,6,7, 0,1,2,3,
    12,13,14,15, 8,9,10,11, 4,5,6,7, 0,1,2,3,
    12,13,14,15, 8,9,10,11, 4,5,6,7, 0,1,2,3 
};

static __ALIGN64 const int64u idx_0_3[] = {
    0x0000000000000000, 0x0000000000000000, 0x0000000100000001, 0x0000000100000001,
    0x0000000200000002, 0x0000000200000002, 0x0000000300000003, 0x0000000300000003
};
static __ALIGN64 const int64u idx_4_7[] = {
    0x0000000400000004, 0x0000000400000004, 0x0000000500000005, 0x0000000500000005,
    0x0000000600000006, 0x0000000600000006, 0x0000000700000007, 0x0000000700000007
};
static __ALIGN64 const int64u idx_8_b[] = {
    0x0000000800000008, 0x0000000800000008, 0x0000000900000009, 0x0000000900000009,
    0x0000000a0000000a, 0x0000000a0000000a, 0x0000000b0000000b, 0x0000000b0000000b
};
static __ALIGN64 const int64u idx_c_f[] = {
    0x0000000c0000000c, 0x0000000c0000000c, 0x0000000d0000000d, 0x0000000d0000000d,
    0x0000000e0000000e, 0x0000000e0000000e, 0x0000000f0000000f, 0x0000000f0000000f
};


static __ALIGN64 const int8u  firstInc[] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
};

static __ALIGN64 const int8u  nextInc[] = { 
    4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
};

#define SM4_ONE_ROUND(X0, X1, X2, X3, TMP, RK) {    \
    /* (Xi+1 ^ Xi+2 ^ Xi+3 ^ rki) */                \
    TMP = _mm512_xor_epi32(_mm512_xor_epi32(_mm512_xor_epi32(X1, X2), X3), _mm512_loadu_si512(RK)); \
    /* T(Xi+1 ^ Xi+2 ^ Xi+3 ^ rki) */               \
    TMP = sBox512(TMP);                             \
    TMP = _mm512_xor_epi32(TMP, Lblock512(TMP));    \
    /* Xi+4 = Xi ^ T(Xi+1 ^ Xi+2 ^ Xi+3 ^ rki) */   \
    X0 = _mm512_xor_epi32(X0, TMP);                 \
}

#define SM4_FOUR_ROUNDS(X0, X1, X2, X3, TMP, RK, sign) {           \
    SM4_ONE_ROUND(X0, X1, X2, X3, TMP, RK);                  \
    SM4_ONE_ROUND(X1, X2, X3, X0, TMP, (RK + sign * 1));     \
    SM4_ONE_ROUND(X2, X3, X0, X1, TMP, (RK + sign * 2));     \
    SM4_ONE_ROUND(X3, X0, X1, X2, TMP, (RK + sign * 3));     \
}

#define EXPAND_ONE_RKEY(X, p_rk) { \
   X[0] = _mm512_permutexvar_epi32(M512(idx_0_3), _mm512_loadu_si512(p_rk)); \
   X[1] = _mm512_permutexvar_epi32(M512(idx_4_7), _mm512_loadu_si512(p_rk)); \
   X[2] = _mm512_permutexvar_epi32(M512(idx_8_b), _mm512_loadu_si512(p_rk)); \
   X[3] = _mm512_permutexvar_epi32(M512(idx_c_f), _mm512_loadu_si512(p_rk)); \
}

#define ENDIANNESS_16x32(x)     _mm512_shuffle_epi8((x), M512(swapBytes));
#define CHANGE_ORDER_BLOCKS(x)  _mm512_shuffle_epi8((x), M512(swapEndianness));

/* Workaround for gcc91, got the error: implicit declaration of function ‘_mm512_div_epi32’ */
#if defined(__GNUC__) && !defined(__INTEL_COMPILER)
    #define GET_NUM_BLOCKS(X,Y,Z)  for(int i=0;i<SM4_LINES;i++) \
                                    *((int32u*)&X+i) = Y[i]/Z;
#else
    #define GET_NUM_BLOCKS(X,Y,Z)  X = _mm512_div_epi32(_mm512_loadu_si512(Y), _mm512_set1_epi32(Z))                  
#endif

#define UPDATE_STREAM_MASK_16(MASK, p_len) \
            MASK = *p_len < (16) ? (*p_len <= 0 ? 0 : ((int64u)1 << *p_len) - 1) : (__mmask64)(0xFFFF); p_len++;
#define UPDATE_STREAM_MASK_64(MASK, p_len) MASK = *p_len < (4 * 16) ? (*p_len <= 0 ? 0 : ((int64u)1 << *p_len) - 1) : (__mmask64)(-1); p_len++;

#define SM4_ENC (1)
#define SM4_DEC (2)

/*
// Internal functions 
*/

EXTERN_C void sm4_ecb_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], __mmask16 mb_mask, int operation);
EXTERN_C void sm4_cbc_enc_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], __mmask16 mb_mask, const int8u* pa_iv[SM4_LINES]);
EXTERN_C void sm4_cbc_dec_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], __mmask16 mb_mask, const int8u* pa_iv[SM4_LINES]);
EXTERN_C void sm4_ctr128_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], __mmask16 mb_mask, int8u* pa_ctr[SM4_LINES]);
EXTERN_C void sm4_ofb128_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], __mmask16 mb_mask, int8u* pa_iv[SM4_LINES]);
EXTERN_C void sm4_cfb128_enc_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], const int8u* pa_iv[SM4_LINES], __mmask16 mb_mask);
EXTERN_C void sm4_cfb128_dec_kernel_mb16(int8u* pa_out[SM4_LINES], const int8u* pa_inp[SM4_LINES], const int len[SM4_LINES], const int32u* key_sched[SM4_ROUNDS], const int8u* pa_iv[SM4_LINES], __mmask16 mb_mask);

__INLINE __m512i sBox512(__m512i block)
{
    block = _mm512_gf2p8affine_epi64_epi8(block, M512(affineIn), 0x65);
    block = _mm512_gf2p8affineinv_epi64_epi8(block, M512(affineOut), 0xd3);
    return block;
}

__INLINE __m512i Lblock512(__m512i x)
{
    return _mm512_ternarylogic_epi32(_mm512_xor_si512(_mm512_rol_epi32(x, 2), _mm512_rol_epi32(x, 10)), _mm512_rol_epi32(x, 18), _mm512_rol_epi32(x, 24), 0x96);
}

__INLINE __m512i Lkey512(__m512i x)
{
    return _mm512_xor_epi32(_mm512_rol_epi32(x, 13), _mm512_rol_epi32(x, 23));
}

__INLINE __m512i IncBlock512(__m512i x, const int8u* increment)
{
    __m512i t = _mm512_add_epi64(x, M512(increment));
    __mmask8 carryMask = _mm512_cmplt_epu64_mask(t, x);
    carryMask = (__mmask8)(carryMask << 1);
    t = _mm512_add_epi64(t, _mm512_mask_set1_epi64(_mm512_setzero_si512(), carryMask, 1));

    return t;
}

/*
// Transpose functions
*/

#define TRANSPOSE_INP_512(K0,K1,K2,K3, T0,T1,T2,T3) \
   K0 = _mm512_unpacklo_epi32(T0, T1); \
   K1 = _mm512_unpacklo_epi32(T2, T3); \
   K2 = _mm512_unpackhi_epi32(T0, T1); \
   K3 = _mm512_unpackhi_epi32(T2, T3); \
   \
   T0 = _mm512_unpacklo_epi64(K0, K1); \
   T1 = _mm512_unpacklo_epi64(K2, K3); \
   T2 = _mm512_unpackhi_epi64(K0, K1); \
   T3 = _mm512_unpackhi_epi64(K2, K3); \
   \
   K2 = _mm512_permutexvar_epi32(M512(permMask_in), T1); \
   K1 = _mm512_permutexvar_epi32(M512(permMask_in), T2); \
   K3 = _mm512_permutexvar_epi32(M512(permMask_in), T3); \
   K0 = _mm512_permutexvar_epi32(M512(permMask_in), T0)

#define TRANSPOSE_OUT_512(T0,T1,T2,T3, K0,K1,K2,K3) \
   T0 = _mm512_shuffle_i32x4(K0, K1, 0x44); \
   T1 = _mm512_shuffle_i32x4(K0, K1, 0xee); \
   T2 = _mm512_shuffle_i32x4(K2, K3, 0x44); \
   T3 = _mm512_shuffle_i32x4(K2, K3, 0xee); \
   \
   K0 = _mm512_shuffle_i32x4(T0, T2, 0x88); \
   K1 = _mm512_shuffle_i32x4(T0, T2, 0xdd); \
   K2 = _mm512_shuffle_i32x4(T1, T3, 0x88); \
   K3 = _mm512_shuffle_i32x4(T1, T3, 0xdd); \
   \
   K0 = _mm512_permutexvar_epi32(M512(permMask_out), K0);\
   K1 = _mm512_permutexvar_epi32(M512(permMask_out), K1);\
   K2 = _mm512_permutexvar_epi32(M512(permMask_out), K2);\
   K3 = _mm512_permutexvar_epi32(M512(permMask_out), K3);\
   \
   T0=K0,T1=K1,T2=K2,T3=K3

__INLINE void TRANSPOSE_16x4_I32_EPI32(__m512i* t0, __m512i* t1, __m512i* t2, __m512i* t3, const int8u* p_inp[16], __mmask16 mb_mask) {
    __mmask16 loc_mb_mask = mb_mask;
    
    // L0 - L3
    __m512i z0 = _mm512_maskz_loadu_epi32(0x000F * (0x1&loc_mb_mask), p_inp[0]);  loc_mb_mask >>= 1;
    __m512i z1 = _mm512_maskz_loadu_epi32(0x000F * (0x1&loc_mb_mask), p_inp[1]);  loc_mb_mask >>= 1;
    __m512i z2 = _mm512_maskz_loadu_epi32(0x000F * (0x1&loc_mb_mask), p_inp[2]);  loc_mb_mask >>= 1;
    __m512i z3 = _mm512_maskz_loadu_epi32(0x000F * (0x1&loc_mb_mask), p_inp[3]);  loc_mb_mask >>= 1;

    // L4 - L7
    z0 = _mm512_mask_loadu_epi32(z0, 0x00F0 * (0x1&loc_mb_mask), (__m128i*)p_inp[4] - 1); loc_mb_mask >>= 1;
    z1 = _mm512_mask_loadu_epi32(z1, 0x00F0 * (0x1&loc_mb_mask), (__m128i*)p_inp[5] - 1); loc_mb_mask >>= 1;
    z2 = _mm512_mask_loadu_epi32(z2, 0x00F0 * (0x1&loc_mb_mask), (__m128i*)p_inp[6] - 1); loc_mb_mask >>= 1;
    z3 = _mm512_mask_loadu_epi32(z3, 0x00F0 * (0x1&loc_mb_mask), (__m128i*)p_inp[7] - 1); loc_mb_mask >>= 1;

    // L8 - Lb
    z0 = _mm512_mask_loadu_epi32(z0, 0x0F00 * (0x1&loc_mb_mask), (__m128i*)p_inp[8]  - 2);   loc_mb_mask >>= 1;
    z1 = _mm512_mask_loadu_epi32(z1, 0x0F00 * (0x1&loc_mb_mask), (__m128i*)p_inp[9]  - 2);   loc_mb_mask >>= 1;
    z2 = _mm512_mask_loadu_epi32(z2, 0x0F00 * (0x1&loc_mb_mask), (__m128i*)p_inp[10] - 2);   loc_mb_mask >>= 1;
    z3 = _mm512_mask_loadu_epi32(z3, 0x0F00 * (0x1&loc_mb_mask), (__m128i*)p_inp[11] - 2);   loc_mb_mask >>= 1;

    // Lc - Lf
    *t0 = ENDIANNESS_16x32(_mm512_mask_loadu_epi32(z0, 0xF000 * (0x1&loc_mb_mask), (__m128i*)p_inp[12] - 3));   loc_mb_mask >>= 1;
    *t1 = ENDIANNESS_16x32(_mm512_mask_loadu_epi32(z1, 0xF000 * (0x1&loc_mb_mask), (__m128i*)p_inp[13] - 3));   loc_mb_mask >>= 1;
    *t2 = ENDIANNESS_16x32(_mm512_mask_loadu_epi32(z2, 0xF000 * (0x1&loc_mb_mask), (__m128i*)p_inp[14] - 3));   loc_mb_mask >>= 1;
    *t3 = ENDIANNESS_16x32(_mm512_mask_loadu_epi32(z3, 0xF000 * (0x1&loc_mb_mask), (__m128i*)p_inp[15] - 3));   loc_mb_mask >>= 1;

    z0 = _mm512_unpacklo_epi32(*t0, *t1);
    z1 = _mm512_unpackhi_epi32(*t0, *t1);
    z2 = _mm512_unpacklo_epi32(*t2, *t3);
    z3 = _mm512_unpackhi_epi32(*t2, *t3);

    *t0 = _mm512_unpacklo_epi64(z0, z2);
    *t1 = _mm512_unpackhi_epi64(z0, z2);
    *t2 = _mm512_unpacklo_epi64(z1, z3);
    *t3 = _mm512_unpackhi_epi64(z1, z3);
}

__INLINE void TRANSPOSE_4x16_I32_EPI32(__m512i* t0, __m512i* t1, __m512i* t2, __m512i* t3, int8u* p_out[16], __mmask16 mb_mask) {

    #define STORE_RESULT(OUT, store_mask, loc_mb_mask, Ti)                              \
            _mm512_mask_storeu_epi32(OUT, store_mask * (0x1&loc_mb_mask), Ti);    \
            loc_mb_mask >>= 1;

    __mmask16 loc_mb_mask = mb_mask;

    __m512i z0 = _mm512_unpacklo_epi32(*t0, *t1);
    __m512i z1 = _mm512_unpackhi_epi32(*t0, *t1);
    __m512i z2 = _mm512_unpacklo_epi32(*t2, *t3);
    __m512i z3 = _mm512_unpackhi_epi32(*t2, *t3);

    /* Get the right endiannes and do (Y0, Y1, Y2, Y3) = R(X32, X33, X34, X35) = (X35, X34, X33, X32) */
    *t0 = CHANGE_ORDER_BLOCKS(_mm512_unpacklo_epi64(z0, z2));
    *t1 = CHANGE_ORDER_BLOCKS(_mm512_unpackhi_epi64(z0, z2));
    *t2 = CHANGE_ORDER_BLOCKS(_mm512_unpacklo_epi64(z1, z3));
    *t3 = CHANGE_ORDER_BLOCKS(_mm512_unpackhi_epi64(z1, z3));

    // L0 - L3
    STORE_RESULT(p_out[0], 0x000F, loc_mb_mask, *t0);
    STORE_RESULT(p_out[1], 0x000F, loc_mb_mask, *t1);
    STORE_RESULT(p_out[2], 0x000F, loc_mb_mask, *t2);
    STORE_RESULT(p_out[3], 0x000F, loc_mb_mask, *t3);

    // L4 - L7
    STORE_RESULT((__m128i*)p_out[4] - 1, 0x00F0, loc_mb_mask, *t0);
    STORE_RESULT((__m128i*)p_out[5] - 1, 0x00F0, loc_mb_mask, *t1);
    STORE_RESULT((__m128i*)p_out[6] - 1, 0x00F0, loc_mb_mask, *t2);
    STORE_RESULT((__m128i*)p_out[7] - 1, 0x00F0, loc_mb_mask, *t3);

    // L8 - Lb
    STORE_RESULT((__m128i*)p_out[8] - 2, 0x0F00, loc_mb_mask, *t0);
    STORE_RESULT((__m128i*)p_out[9] - 2, 0x0F00, loc_mb_mask, *t1);
    STORE_RESULT((__m128i*)p_out[10] - 2, 0x0F00, loc_mb_mask, *t2);
    STORE_RESULT((__m128i*)p_out[11] - 2, 0x0F00, loc_mb_mask, *t3);

    // Lc - Lf
    STORE_RESULT((__m128i*)p_out[12] - 3, 0xF000, loc_mb_mask, *t0);
    STORE_RESULT((__m128i*)p_out[13] - 3, 0xF000, loc_mb_mask, *t1);
    STORE_RESULT((__m128i*)p_out[14] - 3, 0xF000, loc_mb_mask, *t2);
    STORE_RESULT((__m128i*)p_out[15] - 3, 0xF000, loc_mb_mask, *t3);
    
}

__INLINE void TRANSPOSE_4x16_I32_EPI8(__m512i t0, __m512i t1, __m512i t2, __m512i t3, int8u* p_out[16], int* p_loc_len, __mmask16 mb_mask) {

    #define STORE_RESULT_EPI8(OUT, store_mask, loc_mb_mask, Ti)                              \
            _mm512_mask_storeu_epi8(OUT, store_mask * (0x1&loc_mb_mask), Ti);    \
            loc_mb_mask >>= 1;

    __mmask16 loc_mb_mask = mb_mask;
    /* Mask for data loading */
    __mmask64 stream_mask;

    __m512i z0 = _mm512_unpacklo_epi32(t0, t1);
    __m512i z1 = _mm512_unpackhi_epi32(t0, t1);
    __m512i z2 = _mm512_unpacklo_epi32(t2, t3);
    __m512i z3 = _mm512_unpackhi_epi32(t2, t3);

    /* Get the right endiannes */
    t0 = ENDIANNESS_16x32(_mm512_unpacklo_epi64(z0, z2));
    t1 = ENDIANNESS_16x32(_mm512_unpackhi_epi64(z0, z2));
    t2 = ENDIANNESS_16x32(_mm512_unpacklo_epi64(z1, z3));
    t3 = ENDIANNESS_16x32(_mm512_unpackhi_epi64(z1, z3));

    // L0 - L3
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8(p_out[0], stream_mask, loc_mb_mask, t0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8(p_out[1], stream_mask, loc_mb_mask, t1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8(p_out[2], stream_mask, loc_mb_mask, t2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8(p_out[3], stream_mask, loc_mb_mask, t3);

    // L4 - L7
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[4] - 1, stream_mask << 16, loc_mb_mask, t0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[5] - 1, stream_mask << 16, loc_mb_mask, t1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[6] - 1, stream_mask << 16, loc_mb_mask, t2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[7] - 1, stream_mask << 16, loc_mb_mask, t3);

    // L8 - Lb
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[8] - 2, stream_mask << 32, loc_mb_mask, t0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[9] - 2, stream_mask << 32, loc_mb_mask, t1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[10] - 2, stream_mask << 32, loc_mb_mask, t2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[11] - 2, stream_mask << 32, loc_mb_mask, t3);

    // Lc - Lf
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[12] - 3, stream_mask << 48, loc_mb_mask, t0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[13] - 3, stream_mask << 48, loc_mb_mask, t1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[14] - 3, stream_mask << 48, loc_mb_mask, t2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    STORE_RESULT_EPI8((__m128i*)p_out[15] - 3, stream_mask << 48, loc_mb_mask, t3);
}

__INLINE void TRANSPOSE_AND_XOR_4x16_I32_EPI32(__m512i* t0, __m512i* t1, __m512i* t2, __m512i* t3, int8u* p_out[16], const int8u* p_iv[16], __mmask16 mb_mask) {
    
    #define XOR_AND_STORE_RESULT(OUT, store_mask, loc_mb_mask, Ti, IV, TMP)                              \
            TMP = _mm512_maskz_loadu_epi32(store_mask * (0x1&loc_mb_mask), IV);                       \
            _mm512_mask_storeu_epi32(OUT, store_mask * (0x1&loc_mb_mask), _mm512_xor_epi32(Ti, TMP)); \
            loc_mb_mask >>= 1;
   
    __m512i z0 = _mm512_setzero_si512();
    __m512i z1 = _mm512_setzero_si512();
    __m512i z2 = _mm512_setzero_si512();
    __m512i z3 = _mm512_setzero_si512();

    __mmask16 loc_mb_mask = mb_mask;

    z0 = _mm512_unpacklo_epi32(*t0, *t1);
    z1 = _mm512_unpackhi_epi32(*t0, *t1);
    z2 = _mm512_unpacklo_epi32(*t2, *t3);
    z3 = _mm512_unpackhi_epi32(*t2, *t3);

    /* Get the right endiannes and do (Y0, Y1, Y2, Y3) = R(X32, X33, X34, X35) = (X35, X34, X33, X32) */
    *t0 = CHANGE_ORDER_BLOCKS(_mm512_unpacklo_epi64(z0, z2));
    *t1 = CHANGE_ORDER_BLOCKS(_mm512_unpackhi_epi64(z0, z2));
    *t2 = CHANGE_ORDER_BLOCKS(_mm512_unpacklo_epi64(z1, z3));
    *t3 = CHANGE_ORDER_BLOCKS(_mm512_unpackhi_epi64(z1, z3));

    // L0 - L3
    XOR_AND_STORE_RESULT(p_out[0], 0x000F, loc_mb_mask, *t0, p_iv[0], z0);
    XOR_AND_STORE_RESULT(p_out[1], 0x000F, loc_mb_mask, *t1, p_iv[1], z1);
    XOR_AND_STORE_RESULT(p_out[2], 0x000F, loc_mb_mask, *t2, p_iv[2], z2);
    XOR_AND_STORE_RESULT(p_out[3], 0x000F, loc_mb_mask, *t3, p_iv[3], z3);

    // L4 - L7
    XOR_AND_STORE_RESULT((__m128i*)p_out[4] - 1, 0x00F0, loc_mb_mask, *t0, (__m128i*)p_iv[4] - 1, z0);
    XOR_AND_STORE_RESULT((__m128i*)p_out[5] - 1, 0x00F0, loc_mb_mask, *t1, (__m128i*)p_iv[5] - 1, z1);
    XOR_AND_STORE_RESULT((__m128i*)p_out[6] - 1, 0x00F0, loc_mb_mask, *t2, (__m128i*)p_iv[6] - 1, z2);
    XOR_AND_STORE_RESULT((__m128i*)p_out[7] - 1, 0x00F0, loc_mb_mask, *t3, (__m128i*)p_iv[7] - 1, z3);

    // L8 - Lb
    XOR_AND_STORE_RESULT((__m128i*)p_out[8]  - 2, 0x0F00, loc_mb_mask, *t0, (__m128i*)p_iv[8]  - 2, z0);
    XOR_AND_STORE_RESULT((__m128i*)p_out[9]  - 2, 0x0F00, loc_mb_mask, *t1, (__m128i*)p_iv[9]  - 2, z1);
    XOR_AND_STORE_RESULT((__m128i*)p_out[10] - 2, 0x0F00, loc_mb_mask, *t2, (__m128i*)p_iv[10] - 2, z2);
    XOR_AND_STORE_RESULT((__m128i*)p_out[11] - 2, 0x0F00, loc_mb_mask, *t3, (__m128i*)p_iv[11] - 2, z3);

    // Lc - Lf
    XOR_AND_STORE_RESULT((__m128i*)p_out[12] - 3, 0xF000, loc_mb_mask, *t0, (__m128i*)p_iv[12] - 3, z0);
    XOR_AND_STORE_RESULT((__m128i*)p_out[13] - 3, 0xF000, loc_mb_mask, *t1, (__m128i*)p_iv[13] - 3, z1);
    XOR_AND_STORE_RESULT((__m128i*)p_out[14] - 3, 0xF000, loc_mb_mask, *t2, (__m128i*)p_iv[14] - 3, z2);
    XOR_AND_STORE_RESULT((__m128i*)p_out[15] - 3, 0xF000, loc_mb_mask, *t3, (__m128i*)p_iv[15] - 3, z3);
}

__INLINE void TRANSPOSE_AND_XOR_4x16_I32_EPI8(__m512i t0, __m512i t1, __m512i t2, __m512i t3, int8u* p_out[16], const int8u* p_iv[16], int* p_loc_len, __mmask16 mb_mask) {

    #define XOR_AND_STORE_RESULT_EPI8(OUT, store_mask, loc_mb_mask, Ti, IV, TMP)                            \
            TMP = _mm512_maskz_loadu_epi8(store_mask * (0x1&loc_mb_mask), IV);                       \
            _mm512_mask_storeu_epi8(OUT, store_mask * (0x1&loc_mb_mask), _mm512_xor_epi32(Ti, TMP)); \
            loc_mb_mask >>= 1;

    __m512i z0 = _mm512_setzero_si512();
    __m512i z1 = _mm512_setzero_si512();
    __m512i z2 = _mm512_setzero_si512();
    __m512i z3 = _mm512_setzero_si512();

    __mmask16 loc_mb_mask = mb_mask;
    /* Mask for data loading */
    __mmask64 stream_mask;

    z0 = _mm512_unpacklo_epi32(t0, t1);
    z1 = _mm512_unpackhi_epi32(t0, t1);
    z2 = _mm512_unpacklo_epi32(t2, t3);
    z3 = _mm512_unpackhi_epi32(t2, t3);

    /* Get the right endianness */
    t0 = ENDIANNESS_16x32(_mm512_unpacklo_epi64(z0, z2));
    t1 = ENDIANNESS_16x32(_mm512_unpackhi_epi64(z0, z2));
    t2 = ENDIANNESS_16x32(_mm512_unpacklo_epi64(z1, z3));
    t3 = ENDIANNESS_16x32(_mm512_unpackhi_epi64(z1, z3));

    // L0 - L3
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8(p_out[0], stream_mask, loc_mb_mask, t0, p_iv[0], z0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8(p_out[1], stream_mask, loc_mb_mask, t1, p_iv[1], z1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8(p_out[2], stream_mask, loc_mb_mask, t2, p_iv[2], z2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8(p_out[3], stream_mask, loc_mb_mask, t3, p_iv[3], z3);

    // L4 - L7
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[4] - 1, stream_mask << 16, loc_mb_mask, t0, (__m128i*)p_iv[4] - 1, z0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[5] - 1, stream_mask << 16, loc_mb_mask, t1, (__m128i*)p_iv[5] - 1, z1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[6] - 1, stream_mask << 16, loc_mb_mask, t2, (__m128i*)p_iv[6] - 1, z2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[7] - 1, stream_mask << 16, loc_mb_mask, t3, (__m128i*)p_iv[7] - 1, z3);

    // L8 - Lb
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[8] - 2, stream_mask << 32, loc_mb_mask, t0, (__m128i*)p_iv[8] - 2, z0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[9] - 2, stream_mask << 32, loc_mb_mask, t1, (__m128i*)p_iv[9] - 2, z1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[10] - 2, stream_mask << 32, loc_mb_mask, t2, (__m128i*)p_iv[10] - 2, z2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[11] - 2, stream_mask << 32, loc_mb_mask, t3, (__m128i*)p_iv[11] - 2, z3);

    // Lc - Lf
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[12] - 3, stream_mask << 48, loc_mb_mask, t0, (__m128i*)p_iv[12] - 3, z0);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[13] - 3, stream_mask << 48, loc_mb_mask, t1, (__m128i*)p_iv[13] - 3, z1);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[14] - 3, stream_mask << 48, loc_mb_mask, t2, (__m128i*)p_iv[14] - 3, z2);
    UPDATE_STREAM_MASK_16(stream_mask, p_loc_len)
    XOR_AND_STORE_RESULT_EPI8((__m128i*)p_out[15] - 3, stream_mask << 48, loc_mb_mask, t3, (__m128i*)p_iv[15] - 3, z3);
}
#endif /* _SM4_GFNI_MB_H */
