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

IPP_OWN_DEFN(void, AMM52x20_v4_256, (int64u out[LEN52_20],
                               const int64u a  [LEN52_20],
                               const int64u b  [LEN52_20],
                               const int64u m  [LEN52_20],
                                     int64u k0))
{
   a += IFMA_PAD_L;
   b += IFMA_PAD_L;
   m += IFMA_PAD_L;

   /* R0, R1, R2 holds result */
   U64 R0 = get_zero64();
   U64 R1 = get_zero64();
   U64 R2 = get_zero64();

   // High part of 512bit result in 256bit mode
   U64 R0h = get_zero64();
   U64 R1h = get_zero64();
   U64 R2h = get_zero64();

   U64 Bi, Yi;

   int64u m0 = m[0];
   int64u a0 = a[0];
   int64u acc0 = 0;

   int i;
   for(i=0; i<20; i+=4) {
      int64u t0, t1, t2, yi;

      /* ===================================*/
      Bi = set64((long long)b[i]);  /* broadcast(b[i]) */
      /* compute yi */
      t0 = _mulx_u64(a0, b[i], &t2);         /* (t2:t0) = acc0 + a[0]*b[i] */
      ADD104(t2,acc0, 0,t0)
      yi = (acc0 * k0)  & DIGIT_MASK;        /* yi = acc0*k0     */
      Yi = set64((long long)yi);

      t0 = _mulx_u64(m0, yi, &t1);           /* (t1:t0)   = m0*yi     */
      ADD104(t2,acc0, t1,t0)                 /* (t2:acc0) += (t1:t0)  */
      acc0 = SHRD52(t2, acc0);

      fma52x8lo_mem(R0, R0, Bi, a,64*0-8*0)
      fma52x8lo_mem(R1, R1, Bi, a,64*1-8*0)
      fma52x8lo_mem_len(R2, R2, Bi, a,64*2-8*0, 4)
      fma52x8lo_mem(R0, R0, Yi, m,64*0-8*0)
      fma52x8lo_mem(R1, R1, Yi, m,64*1-8*0)
      fma52x8lo_mem_len(R2, R2, Yi, m,64*2-8*0, 4)

      /* "shift" R */
      t0 = get64(R0, 1);
      acc0 += t0;

      fma52x8hi_mem(R0, R0, Bi, a,64*0-8*1)      /* U = A*Bi (hi) */
      fma52x8hi_mem(R1, R1, Bi, a,64*1-8*1)
      fma52x8hi_mem(R2, R2, Bi, a,64*2-8*1)
      fma52x8hi_mem(R0, R0, Yi, m,64*0-8*1)      /* R += M*Yi (hi) */
      fma52x8hi_mem(R1, R1, Yi, m,64*1-8*1)
      fma52x8hi_mem(R2, R2, Yi, m,64*2-8*1)

      /* ===================================*/
      Bi = set64((long long)b[i+1]);        /* broadcast(b[i+1]) */
      /* compute yi */
      t0 = _mulx_u64(a0, b[i+1], &t2);       /* (t2:t0) = acc0 + a[0]*b[i+1] */
      ADD104(t2,acc0, 0,t0)
      yi = (acc0 * k0)  & DIGIT_MASK;        /* yi = acc0*k0     */
      Yi = set64((long long)yi);

      t0 = _mulx_u64(m0, yi, &t1);           /* (t1:t0)   = m0*yi     */
      ADD104(t2,acc0, t1,t0)                 /* (t2:acc0) += (t1:t0)  */
      acc0 = SHRD52(t2, acc0);

      fma52x8lo_mem(R0, R0, Bi, a,64*0-8*1)
      fma52x8lo_mem(R1, R1, Bi, a,64*1-8*1)
      fma52x8lo_mem(R2, R2, Bi, a,64*2-8*1)
      fma52x8lo_mem(R0, R0, Yi, m,64*0-8*1)
      fma52x8lo_mem(R1, R1, Yi, m,64*1-8*1)
      fma52x8lo_mem(R2, R2, Yi, m,64*2-8*1)

      /* "shift" R */
      t0 = get64(R0, 2);
      acc0 += t0;

      fma52x8hi_mem(R0, R0, Bi, a,64*0-8*2)      /* U = A*Bi (hi) */
      fma52x8hi_mem(R1, R1, Bi, a,64*1-8*2)
      fma52x8hi_mem(R2, R2, Bi, a,64*2-8*2)
      fma52x8hi_mem(R0, R0, Yi, m,64*0-8*2)      /* R += M*Yi (hi) */
      fma52x8hi_mem(R1, R1, Yi, m,64*1-8*2)
      fma52x8hi_mem(R2, R2, Yi, m,64*2-8*2)

      /* ===================================*/
      Bi = set64((long long)b[i+2]);        /* broadcast(b[i+2]) */
      /* compute yi */
      t0 = _mulx_u64(a0, b[i+2], &t2);       /* (t2:t0) = acc0 + a[0]*b[i+2] */
      ADD104(t2,acc0, 0,t0)
      yi = (acc0 * k0)  & DIGIT_MASK;        /* yi = acc0*k0     */
      Yi = set64((long long)yi);

      t0 = _mulx_u64(m0, yi, &t1);           /* (t1:t0)   = m0*yi     */
      ADD104(t2,acc0, t1,t0)                 /* (t2:acc0) += (t1:t0)  */
      acc0 = SHRD52(t2, acc0);

      fma52x8lo_mem(R0, R0, Bi, a,64*0-8*2)
      fma52x8lo_mem(R1, R1, Bi, a,64*1-8*2)
      fma52x8lo_mem(R2, R2, Bi, a,64*2-8*2)
      fma52x8lo_mem(R0, R0, Yi, m,64*0-8*2)
      fma52x8lo_mem(R1, R1, Yi, m,64*1-8*2)
      fma52x8lo_mem(R2, R2, Yi, m,64*2-8*2)

      /* "shift" R */
      t0 = get64(R0, 3);
      acc0 += t0;

      fma52x8hi_mem(R0, R0, Bi, a,64*0-8*3)      /* U = A*Bi (hi) */
      fma52x8hi_mem(R1, R1, Bi, a,64*1-8*3)
      fma52x8hi_mem(R2, R2, Bi, a,64*2-8*3)
      fma52x8hi_mem(R0, R0, Yi, m,64*0-8*3)      /* R += M*Yi (hi) */
      fma52x8hi_mem(R1, R1, Yi, m,64*1-8*3)
      fma52x8hi_mem(R2, R2, Yi, m,64*2-8*3)

      /* ===================================*/
      Bi = set64((long long)b[i+3]);        /* broadcast(b[i+3]) */
      /* compute yi */
      t0 = _mulx_u64(a0, b[i+3], &t2);       /* (t2:t0) = acc0 + a[0]*b[i+3] */
      ADD104(t2,acc0, 0,t0)
      yi = (acc0 * k0)  & DIGIT_MASK;        /* yi = acc0*k0     */
      Yi = set64((long long)yi);

      t0 = _mulx_u64(m0, yi, &t1);           /* (t1:t0)   = m0*yi     */
      ADD104(t2,acc0, t1,t0)                 /* (t2:acc0) += (t1:t0)  */
      acc0 = SHRD52(t2, acc0);

      fma52x8lo_mem(R0, R0, Bi, a,64*0-8*3)
      fma52x8lo_mem(R1, R1, Bi, a,64*1-8*3)
      fma52x8lo_mem(R2, R2, Bi, a,64*2-8*3)
      fma52x8lo_mem(R0, R0, Yi, m,64*0-8*3)
      fma52x8lo_mem(R1, R1, Yi, m,64*1-8*3)
      fma52x8lo_mem(R2, R2, Yi, m,64*2-8*3)

      /* shift R */
      shift64(R0, R1)
      shift64(R1, R2)
      shift64(R2, get_zero64())

      t0 = get64(R0, 0);
      acc0 += t0;

      fma52x8hi_mem(R0, R0, Bi, a,64*0-8*0)      /* U = A*Bi (hi) */
      fma52x8hi_mem(R1, R1, Bi, a,64*1-8*0)
      fma52x8hi_mem_len(R2, R2, Bi, a,64*2-8*0, 4)
      fma52x8hi_mem(R0, R0, Yi, m,64*0-8*0)      /* R += M*Yi (hi) */
      fma52x8hi_mem(R1, R1, Yi, m,64*1-8*0)
      fma52x8hi_mem_len(R2, R2, Yi, m,64*2-8*0, 4)
   }

   /* set up R0.0 == acc0 */
   // TODO: add new func -  set with idx ?
   Bi = set64((long long)acc0);
   R0 = blend64(R0, Bi, 1);

   NORMALIZE(R0, R1, R2)

   storeu64(out + IFMA_PAD_L + 0*4, R0);
   storeu64(out + IFMA_PAD_L + 1*4, R0h);
   storeu64(out + IFMA_PAD_L + 2*4, R1);
   storeu64(out + IFMA_PAD_L + 3*4, R1h);
   storeu64(out + IFMA_PAD_L + 4*4, R2);
   storeu64(out + IFMA_PAD_L + 5*4, R2h);
}

IPP_OWN_DEFN(void, AMS52x20_v4_256, (int64u out[LEN52_20], const int64u a[LEN52_20], const int64u m[LEN52_20], int64u k0))
{
    AMM52x20_v4_256(out, a, a, m, k0);
}

#endif
