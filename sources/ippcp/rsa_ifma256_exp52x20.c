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

#include "pcpbnumisc.h"
#include "rsa_ifma256.h"

#define BITSIZE_MODULUS (1024)
#define LEN64           (NUMBER_OF_DIGITS(BITSIZE_MODULUS,64))  // 16

#define EXP_WIN_SIZE (5U) //(4)
#define EXP_WIN_MASK ((1U<<EXP_WIN_SIZE) - 1)

#define AMM52x20 AMM52x20_v4_256
#define AMS52x20 AMS52x20_v4_256

// Secure table lookup (256bit specific code)
// FIXME: decouple load from xor operation
__INLINE void extract_multiplier(int64u *red_Y, const int64u red_table[1U << EXP_WIN_SIZE][LEN52_20], int red_table_idx)
{
    U64 idx = set64(red_table_idx);
    U64 cur_idx = set64(0);

    U64 t0, t1, t2, t3, t4;
    t0 = t1 = t2 = t3 = t4 = get_zero64();

    for (int t = 0; t < (1U << EXP_WIN_SIZE); ++t, cur_idx = add64(cur_idx, set64(1))) {
        __mmask8 m = _mm256_cmp_epi64_mask(idx, cur_idx, _MM_CMPINT_EQ);

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

/// Expo in Montgomery domain
IPP_OWN_DEFN (void, EXP52x20, (int64u *out,
                         const int64u *base,
                         const int64u *exp,
                         const int64u *modulus,
                         const int64u *toMont,
                         const int64u k0))
{
   /* allocate stack for red(undant) result Y and multiplier X */
   __ALIGN64 int64u red_Y[LEN52_20];
   __ALIGN64 int64u red_X[LEN52_20];

   /* allocate expanded exponent */
   __ALIGN64 int64u expz[LEN64 + 1];

   /* pre-computed table of base powers */
   __ALIGN64 int64u red_table[1U << EXP_WIN_SIZE][LEN52_20];

   /* zero all temp buffers (due to zero padding) */
   ZEXPAND_BNU(red_Y, 0, LEN52_20);
   ZEXPAND_BNU((int64u*)red_table, 0, LEN52_20 * (1U << EXP_WIN_SIZE));

   int idx;

   /*
   // compute table of powers base^i, i=0, ..., (2^EXP_WIN_SIZE) -1
   */
   ZEXPAND_BNU(red_X, 0, LEN52_20); /* table[0] = mont(x^0) = mont(1) */
   red_X[IFMA_PAD_L] = 1ULL;
   AMM52x20(red_table[0], red_X, toMont, modulus, k0);
   AMM52x20(red_table[1], base, toMont, modulus, k0);

   for (idx = 1; idx < (1U << EXP_WIN_SIZE)/2; idx++) {
      AMS52x20(red_table[2*idx],   red_table[idx],  modulus, k0);
      AMM52x20(red_table[2*idx+1], red_table[2*idx],red_table[1], modulus, k0);
   }

   /* copy and expand exponents */
   ZEXPAND_COPY_BNU(expz, LEN64+1, exp, LEN64);

   /* exponentiation */
   {
      int rem = BITSIZE_MODULUS % EXP_WIN_SIZE;
      int delta = rem ? rem : EXP_WIN_SIZE;
      int64u table_idx_mask = EXP_WIN_MASK;

      int exp_bit_no = BITSIZE_MODULUS - delta;
      int exp_chunk_no = exp_bit_no / 64;
      int exp_chunk_shift = exp_bit_no % 64;

      /* process 1-st exp window - just init result */
      int64u red_table_idx = expz[exp_chunk_no];
      red_table_idx = red_table_idx >> exp_chunk_shift;

      extract_multiplier(red_Y, (const int64u(*)[LEN52_20])red_table, (int)red_table_idx);

      /* process other exp windows */
      for (exp_bit_no -= EXP_WIN_SIZE; exp_bit_no >= 0; exp_bit_no -= EXP_WIN_SIZE) {
         /* series of squaring */
         #if EXP_WIN_SIZE==5
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         #else
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         AMS52x20(red_Y, red_Y, modulus, k0);
         #endif

         /* extract pre-computed multiplier from the table */
         {
            int64u T;
            exp_chunk_no = exp_bit_no / 64;
            exp_chunk_shift = exp_bit_no % 64;

            red_table_idx = expz[exp_chunk_no];
            T = expz[exp_chunk_no+1];

            red_table_idx = red_table_idx >> exp_chunk_shift;
            // TODO: Check if we need branchless code here
            T = exp_chunk_shift == 0 ? 0 : T << (64 - exp_chunk_shift);
            red_table_idx = (red_table_idx ^ T) & table_idx_mask;

            extract_multiplier(red_X, (const int64u(*)[LEN52_20])red_table, (int)red_table_idx);
            AMM52x20(red_Y, red_Y, red_X, modulus, k0);
         }
      }
   }

   /* clear exponents */
   ZEXPAND_BNU(expz, 0, LEN64);

   /* convert result back in regular 2^52 domain */
   ZEXPAND_BNU(red_X, 0, LEN52_20);
   red_X[IFMA_PAD_L] = 1ULL;
   AMM52x20(out, red_Y, red_X, modulus, k0);
}

#endif
