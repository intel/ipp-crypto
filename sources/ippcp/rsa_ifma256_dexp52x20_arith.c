 /*******************************************************************************
 * Copyright 2019-2020 Intel Corporation
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

#include "owncp.h"

#if(_IPP32E>=_IPP32E_K0)

#include "rsa_ifma256_arith.h"

#define NORMALIZE(X,Y,Z) { \
   __m256i T1   = _mm256_srli_epi64(X, DIGIT_SIZE); \
   __m256i T1h  = _mm256_srli_epi64(X ## h, DIGIT_SIZE); \
   __m256i T2   = _mm256_srli_epi64(Y, DIGIT_SIZE); \
   __m256i T2h  = _mm256_srli_epi64(Y ## h, DIGIT_SIZE); \
   __m256i T3   = _mm256_srli_epi64(Z, DIGIT_SIZE); \
   /* __m256i T3h  = _mm256_srli_epi64(Z ## h, DIGIT_SIZE); */ \
   __m256i MASK = _mm256_set1_epi64x(DIGIT_MASK); \
   Ipp16u k1, k2, k3; \
   Ipp16u k1h, k2h, k3h; \
   \
   X = _mm256_and_si256(X, MASK); \
   Y = _mm256_and_si256(Y, MASK); \
   Z = _mm256_and_si256(Z, MASK); \
   X ## h = _mm256_and_si256(X ## h, MASK); \
   Y ## h = _mm256_and_si256(Y ## h, MASK); \
   /* Z ## h = _mm256_and_si256(Z ## h, MASK); */ \
   \
   /* T3h = _mm256_alignr_epi64(T3h, T3, 7); */ \
   T3  = _mm256_alignr_epi64(T3, T2h, 3); \
   T2h = _mm256_alignr_epi64(T2h, T2, 3); \
   T2  = _mm256_alignr_epi64(T2, T1h, 3); \
   T1h = _mm256_alignr_epi64(T1h, T1, 3); \
   T1  = _mm256_alignr_epi64(T1, _mm256_setzero_si256(), 3); \
   \
   X = _mm256_add_epi64(X, T1); \
   Y = _mm256_add_epi64(Y, T2); \
   Z = _mm256_add_epi64(Z, T3); \
   X ## h = _mm256_add_epi64(X ## h, T1h); \
   Y ## h = _mm256_add_epi64(Y ## h, T2h); \
   /*Z ## h = _mm256_add_epi64(Z ## h, T3h);*/ \
   { \
      Ipp16u k4  = _mm256_cmp_epu64_mask(MASK, X, _MM_CMPINT_EQ); \
      Ipp16u k5  = _mm256_cmp_epu64_mask(MASK, Y, _MM_CMPINT_EQ); \
      Ipp16u k6  = _mm256_cmp_epu64_mask(MASK, Z, _MM_CMPINT_EQ); \
      Ipp16u k4h = _mm256_cmp_epu64_mask(MASK, X ## h, _MM_CMPINT_EQ); \
      Ipp16u k5h = _mm256_cmp_epu64_mask(MASK, Y ## h, _MM_CMPINT_EQ); \
      /*Ipp16u k6h = _mm256_cmp_epu64_mask(MASK, Z ## h, _MM_CMPINT_EQ);*/ \
      \
      k1 = _mm256_cmp_epu64_mask(MASK, X, _MM_CMPINT_LT); \
      k2 = _mm256_cmp_epu64_mask(MASK, Y, _MM_CMPINT_LT); \
      k3 = _mm256_cmp_epu64_mask(MASK, Z, _MM_CMPINT_LT); \
      k1h = _mm256_cmp_epu64_mask(MASK, X ## h, _MM_CMPINT_LT); \
      k2h = _mm256_cmp_epu64_mask(MASK, Y ## h, _MM_CMPINT_LT); \
      /*k3h = _mm256_cmp_epu64_mask(MASK, Z ## h, _MM_CMPINT_LT);*/ \
      \
      k4 += 2*k1; \
      k5 += 2*k2; \
      k6 += 2*k3; \
      k4h += 2*k1h; \
      k5h += 2*k2h; \
      /*k6h += 2*k3h;*/ \
      \
      k1 ^= k4; \
      k2 ^= k5; \
      k3 ^= k6; \
      k1h ^= k4h; \
      k2h ^= k5h; \
      /*k3h ^= k6h;*/ \
   } \
   \
   X = _mm256_mask_sub_epi64(X, (__mmask8)k1, X, MASK); \
   Y = _mm256_mask_sub_epi64(Y, (__mmask8)k2, Y, MASK); \
   Z = _mm256_mask_sub_epi64(Z, (__mmask8)k3, Z, MASK); \
   X ## h = _mm256_mask_sub_epi64(X ## h, (__mmask8)k1h, X ## h, MASK); \
   Y ## h = _mm256_mask_sub_epi64(Y ## h, (__mmask8)k2h, Y ## h, MASK); \
   /*Z ## h = _mm256_mask_sub_epi64(Z ## h, k3h, Z ## h, MASK);*/ \
   X      = _mm256_and_si256(X,      MASK); \
   Y      = _mm256_and_si256(Y,      MASK); \
   Z      = _mm256_and_si256(Z,      MASK); \
   X ## h = _mm256_and_si256(X ## h, MASK); \
   Y ## h = _mm256_and_si256(Y ## h, MASK); \
   /*Z ## h = _mm256_and_si256(Z ## h, MASK);*/ \
}

#define ADD104(rh, rl, ih, il) { \
   rl += il; \
   rh += ih; \
   rh += (rl<il)? 1 : 0; \
}

#define SHRD52(rh, rl)  ((rl>>52U) | rh<<(64U-52U))

// FIXME: remove R2_*h declaration
IPP_OWN_DEFN(void, AMM2x52x20_S_256, (int64u out[2][LEN52_20],
                                const int64u a  [2][LEN52_20],
                                const int64u b  [2][LEN52_20],
                                const int64u m  [2][LEN52_20],
                                const int64u k0 [2]))
{
    const int64u *a_0 = a[0] + IFMA_PAD_L;
    const int64u *b_0 = b[0] + IFMA_PAD_L;
    const int64u *m_0 = m[0] + IFMA_PAD_L;
    int64u m0_0 = m_0[0];
    int64u a0_0 = a_0[0];
    int64u acc0_0 = 0;
    U64 R0_0, R1_0, R2_0, R0_0h, R1_0h, R2_0h;
    R0_0 = R1_0 = R2_0 = R0_0h = R1_0h = R2_0h = get_zero64();

    const int64u *a_1 = a[1] + IFMA_PAD_L;
    const int64u *b_1 = b[1] + IFMA_PAD_L;
    const int64u *m_1 = m[1] + IFMA_PAD_L;
    int64u m0_1 = m_1[0];
    int64u a0_1 = a_1[0];
    int64u acc0_1 = 0;
    U64 R0_1, R1_1, R2_1, R0_1h, R1_1h, R2_1h;
    R0_1 = R1_1 = R2_1 = R0_1h = R1_1h = R2_1h = get_zero64();

    int i;
    for (i=0; i<20; i++) {
        {
            int64u t0, t1, t2, yi;
            U64 Bi = set64((long long)b_0[i]);             /* broadcast(b[i]) */
            /* compute yi */
            t0 = _mulx_u64(a0_0, b_0[i], &t2);  /* (t2:t0) = acc0 + a[0]*b[i] */
            ADD104(t2, acc0_0, 0, t0)
            yi = (acc0_0 * k0[0])  & DIGIT_MASK; /* yi = acc0*k0 */
            U64 Yi = set64((long long)yi);

            t0 = _mulx_u64(m0_0, yi, &t1);      /* (t1:t0)   = m0*yi     */
            ADD104(t2, acc0_0, t1, t0)          /* (t2:acc0) += (t1:t0)  */
            acc0_0 = SHRD52(t2, acc0_0);

            fma52x8lo_mem(R0_0, R0_0, Bi, a_0, 64*0)
            fma52x8lo_mem(R1_0, R1_0, Bi, a_0, 64*1)
            fma52x8lo_mem_len(R2_0, R2_0, Bi, a_0, 64*2, 4)
            fma52x8lo_mem(R0_0, R0_0, Yi, m_0, 64*0)
            fma52x8lo_mem(R1_0, R1_0, Yi, m_0, 64*1)
            fma52x8lo_mem_len(R2_0, R2_0, Yi, m_0, 64*2, 4)

            shift64_imm(R0_0, R0_0h, 1)
            shift64_imm(R0_0h, R1_0, 1)
            shift64_imm(R1_0, R1_0h, 1)
            shift64_imm(R1_0h, R2_0, 1)
            shift64_imm(R2_0, get_zero64(), 1)

            /* "shift" R */
            t0 = get64(R0_0, 0);
            acc0_0 += t0;

            /* U = A*Bi (hi) */
            fma52x8hi_mem(R0_0, R0_0, Bi, a_0, 64*0)
            fma52x8hi_mem(R1_0, R1_0, Bi, a_0, 64*1)
            fma52x8hi_mem_len(R2_0, R2_0, Bi, a_0, 64*2, 4)
            /* R += M*Yi (hi) */
            fma52x8hi_mem(R0_0, R0_0, Yi, m_0, 64*0)
            fma52x8hi_mem(R1_0, R1_0, Yi, m_0, 64*1)
            fma52x8hi_mem_len(R2_0, R2_0, Yi, m_0, 64*2, 4)
        }
        {
            int64u t0, t1, t2, yi;
            U64 Bi = set64((long long)b_1[i]);             /* broadcast(b[i]) */
            /* compute yi */
            t0 = _mulx_u64(a0_1, b_1[i], &t2);  /* (t2:t0) = acc0 + a[0]*b[i] */
            ADD104(t2, acc0_1, 0, t0)
            yi = (acc0_1 * k0[1])  & DIGIT_MASK; /* yi = acc0*k0 */
            U64 Yi = set64((long long)yi);

            t0 = _mulx_u64(m0_1, yi, &t1);      /* (t1:t0)   = m0*yi     */
            ADD104(t2, acc0_1, t1, t0)          /* (t2:acc0) += (t1:t0)  */
            acc0_1 = SHRD52(t2, acc0_1);

            fma52x8lo_mem(R0_1, R0_1, Bi, a_1, 64*0)
            fma52x8lo_mem(R1_1, R1_1, Bi, a_1, 64*1)
            fma52x8lo_mem_len(R2_1, R2_1, Bi, a_1, 64*2, 4)
            fma52x8lo_mem(R0_1, R0_1, Yi, m_1, 64*0)
            fma52x8lo_mem(R1_1, R1_1, Yi, m_1, 64*1)
            fma52x8lo_mem_len(R2_1, R2_1, Yi, m_1, 64*2, 4)

            shift64_imm(R0_1, R0_1h, 1)
            shift64_imm(R0_1h, R1_1, 1)
            shift64_imm(R1_1, R1_1h, 1)
            shift64_imm(R1_1h, R2_1, 1)
            shift64_imm(R2_1, get_zero64(), 1)

            /* "shift" R */
            t0 = get64(R0_1, 0);
            acc0_1 += t0;

            /* U = A*Bi (hi) */
            fma52x8hi_mem(R0_1, R0_1, Bi, a_1, 64*0)
            fma52x8hi_mem(R1_1, R1_1, Bi, a_1, 64*1)
            fma52x8hi_mem_len(R2_1, R2_1, Bi, a_1, 64*2, 4)
            /* R += M*Yi (hi) */
            fma52x8hi_mem(R0_1, R0_1, Yi, m_1, 64*0)
            fma52x8hi_mem(R1_1, R1_1, Yi, m_1, 64*1)
            fma52x8hi_mem_len(R2_1, R2_1, Yi, m_1, 64*2, 4)
        }
    }
    {
        // Normalize and store idx=0
        /* Set R0.0 == acc0 */
        // TODO: add new func -  set with idx ?
        U64 Bi = set64((long long)acc0_0);
        R0_0 = blend64(R0_0, Bi, 1);
        NORMALIZE(R0_0, R1_0, R2_0)
        storeu64(out[0] + IFMA_PAD_L + 0*4, R0_0);
        storeu64(out[0] + IFMA_PAD_L + 1*4, R0_0h);
        storeu64(out[0] + IFMA_PAD_L + 2*4, R1_0);
        storeu64(out[0] + IFMA_PAD_L + 3*4, R1_0h);
        storeu64(out[0] + IFMA_PAD_L + 4*4, R2_0);
    }
    {
        // Normalize and store idx=1
        /* Set R0.0 == acc0 */
        // TODO: add new func -  set with idx ?
        U64 Bi = set64((long long)acc0_1);
        R0_1 = blend64(R0_1, Bi, 1);
        NORMALIZE(R0_1, R1_1, R2_1)
        storeu64(out[1] + IFMA_PAD_L + 0*4, R0_1);
        storeu64(out[1] + IFMA_PAD_L + 1*4, R0_1h);
        storeu64(out[1] + IFMA_PAD_L + 2*4, R1_1);
        storeu64(out[1] + IFMA_PAD_L + 3*4, R1_1h);
        storeu64(out[1] + IFMA_PAD_L + 4*4, R2_1);
    }
}

IPP_OWN_DEFN(void, AMS2x52x20_v4_256, (int64u out[2][LEN52_20],
                                 const int64u a[2][LEN52_20],
                                 const int64u m[2][LEN52_20], const int64u k0[2]))
{
    AMM2x52x20_S_256(out, a, a, m, k0);
}

IPP_OWN_DEFN(void, AMS5x2x52x20_v4_256, (int64u out[2][LEN52_20],
                                   const int64u a[2][LEN52_20],
                                   const int64u m[2][LEN52_20],
                                   const int64u k0[2]))
{
    AMM2x52x20_S_256(out, a, a, m, k0);
    for (int i = 0; i < 4; ++i) {
        AMM2x52x20_S_256(out, (const int64u(*)[LEN52_20])out, (const int64u(*)[LEN52_20])out, m, k0);
    }
}

__INLINE void extract_multiplier_idx(int64u *red_Y,
                               const int64u red_table[1U << 5U][LEN52_20],
                               U64 *cur_idx, U64 idx, int start, int end)
{
    U64 t0, t1, t2, t3, t4;
    t0 = loadu64(&red_Y[IFMA_PAD_L + 4*0]);
    t1 = loadu64(&red_Y[IFMA_PAD_L + 4*1]);
    t2 = loadu64(&red_Y[IFMA_PAD_L + 4*2]);
    t3 = loadu64(&red_Y[IFMA_PAD_L + 4*3]);
    t4 = loadu64(&red_Y[IFMA_PAD_L + 4*4]);

    for (int t = start; t < end; ++t, *cur_idx = add64(*cur_idx, set64(1))) {

        __mmask8 m = _mm256_cmp_epi64_mask(*cur_idx, idx, _MM_CMPINT_EQ);

        t0 = _mm256_mask_xor_epi64(t0, m, t0, loadu64(&red_table[t][IFMA_PAD_L + 4*0]));
        t1 = _mm256_mask_xor_epi64(t1, m, t1, loadu64(&red_table[t][IFMA_PAD_L + 4*1]));
        t2 = _mm256_mask_xor_epi64(t2, m, t2, loadu64(&red_table[t][IFMA_PAD_L + 4*2]));
        t3 = _mm256_mask_xor_epi64(t3, m, t3, loadu64(&red_table[t][IFMA_PAD_L + 4*3]));
        t4 = _mm256_mask_xor_epi64(t4, m, t4, loadu64(&red_table[t][IFMA_PAD_L + 4*4]));
    }

    storeu64(&red_Y[IFMA_PAD_L + 4*0], t0);
    storeu64(&red_Y[IFMA_PAD_L + 4*1], t1);
    storeu64(&red_Y[IFMA_PAD_L + 4*2], t2);
    storeu64(&red_Y[IFMA_PAD_L + 4*3], t3);
    storeu64(&red_Y[IFMA_PAD_L + 4*4], t4);
}

IPP_OWN_DEFN(void, AMS5x2x52x20_Select_256, (
                         // Mont multiplication parameters
                               int64u out[2][LEN52_20],
                         const int64u a  [2][LEN52_20],
                         const int64u m  [2][LEN52_20],
                         const int64u k0 [2],
                         // Table select parameters
                               int64u red_Y        [2][LEN52_20],
                         const int64u red_table    [2][1U << 5U][LEN52_20],
                               int    red_table_idx[2]))
{
    U64 cur_idx[2] = {set64(0), set64(0)};
    U64 idx[2] = {set64(red_table_idx[0]), set64(red_table_idx[1])};

    for (int i = 0; i < 2 * (LEN52_20 / 4); ++i)
        storeu64(((int64u *)red_Y) + i * 4, get_zero64());

    AMM2x52x20_S_256(out, a, a, m, k0);
    for (int i = 0; i < 4; ++i) {
        extract_multiplier_idx(red_Y[0], red_table[0], &cur_idx[0], idx[0], i*8, (i+1)*8);
        extract_multiplier_idx(red_Y[1], red_table[1], &cur_idx[1], idx[1], i*8, (i+1)*8);
        AMM2x52x20_S_256(out, (const int64u(*)[LEN52_20])out, (const int64u(*)[LEN52_20])out, m, k0);
    }
}

#endif
