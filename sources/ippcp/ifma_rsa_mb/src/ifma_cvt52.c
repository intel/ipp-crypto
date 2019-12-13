/*******************************************************************************
* Copyright 2019 Intel Corporation
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
//  Purpose: MB RSA.
// 
//  Contents: radix conversion
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#include "ifma_internal.h"
#include "immintrin.h"
#include "ifma_math.h"

#include <assert.h>

void zero_mb8(int64u (*out)[8], int len)
{
   __m512i T = _mm512_setzero_si512();
   int i;
   for(i=0; i<len; i++)
      _mm512_store_si512(out[i], T);
}

void copy_mb8(int64u out[][8], const int64u inp[][8], int len)
{
   int i;
   for(i=0; i<len; i++)
      _mm512_store_si512(out[i], _mm512_load_si512(inp[i]));
}

#ifndef BN_OPENSSL_DISABLE
   #if BN_OPENSSL_PATCH
   extern BN_ULONG* bn_get_words(const BIGNUM* bn);
   #endif
#endif /* BN_OPENSSL_DISABLE */

#define MIN(a, b) ( ((a) < (b)) ? a : b )

// Create 64bit load mask
//    L - input stream length
//    P - current position
#define READ_MASK(L,P) ( ( ((L)-(P)) > 0 ) ? (__mmask64)0xFFFFFFFFFFFFFFFFUL >> (64 - MIN(64, (L) - (P))) : (__mmask64)0x0 )

__INLINE void transform_8sb_to_mb8(int64u out_mb8[][8], int bitLen, int64u *d[8], int byteLens[8], int reverse) {
   const __m512i MASK = _mm512_set1_epi64(DIGIT_MASK);
   const __m512i bswap_mask = _mm512_set_epi64(
                     0x0001020304050607, 0x08090a0b0c0d0e0f,
                     0x0001020304050607, 0x08090a0b0c0d0e0f,
                     0x0001020304050607, 0x08090a0b0c0d0e0f,
                     0x0001020304050607, 0x08090a0b0c0d0e0f);

   int i, sr, idx, n, QwLen;
   __m512i dgt_lo, dgt_hi;
   __m512i T = _mm512_setzero_si512();
   __m512i* mb8 = (__m512i*)out_mb8;
   __ALIGN64 __m512i X[8]; // Temp transpose
   __m512i X0, X1, X2, X3, X4, X5, X6, X7;

   // Transpose BIGNUM into mb8 buffer
   idx = sr = n = 0;
   QwLen = (bitLen+63)/64;
   dgt_lo = _mm512_setzero_si512();
   for (i = 0; i < QwLen; i += 8) {
      int li = reverse ? QwLen - 8 - i : i;

      X0 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[0], i*8), (__m512i*)&d[0][li]);
      X1 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[1], i*8), (__m512i*)&d[1][li]);
      X2 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[2], i*8), (__m512i*)&d[2][li]);
      X3 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[3], i*8), (__m512i*)&d[3][li]);
      X4 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[4], i*8), (__m512i*)&d[4][li]);
      X5 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[5], i*8), (__m512i*)&d[5][li]);
      X6 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[6], i*8), (__m512i*)&d[6][li]);
      X7 = _mm512_maskz_loadu_epi8(READ_MASK(byteLens[7], i*8), (__m512i*)&d[7][li]);

      if (reverse) {
         X0 = _mm512_shuffle_epi8 (X0, bswap_mask);
         X0 = _mm512_shuffle_i64x2(X0, X0, 0x1b);
         X1 = _mm512_shuffle_epi8 (X1, bswap_mask);
         X1 = _mm512_shuffle_i64x2(X1, X1, 0x1b);
         X2 = _mm512_shuffle_epi8 (X2, bswap_mask);
         X2 = _mm512_shuffle_i64x2(X2, X2, 0x1b);
         X3 = _mm512_shuffle_epi8 (X3, bswap_mask);
         X3 = _mm512_shuffle_i64x2(X3, X3, 0x1b);
         X4 = _mm512_shuffle_epi8 (X4, bswap_mask);
         X4 = _mm512_shuffle_i64x2(X4, X4, 0x1b);
         X5 = _mm512_shuffle_epi8 (X5, bswap_mask);
         X5 = _mm512_shuffle_i64x2(X5, X5, 0x1b);
         X6 = _mm512_shuffle_epi8 (X6, bswap_mask);
         X6 = _mm512_shuffle_i64x2(X6, X6, 0x1b);
         X7 = _mm512_shuffle_epi8 (X7, bswap_mask);
         X7 = _mm512_shuffle_i64x2(X7, X7, 0x1b);
      }

      // Transpose 8 digits at a time
      TRANSPOSE_8xI64x8(X0, X1, X2, X3, X4, X5, X6, X7);

      // Store transposed matrix to temp storage
      _mm512_store_si512(&X[0], X0);
      _mm512_store_si512(&X[1], X1);
      _mm512_store_si512(&X[2], X2);
      _mm512_store_si512(&X[3], X3);
      _mm512_store_si512(&X[4], X4);
      _mm512_store_si512(&X[5], X5);
      _mm512_store_si512(&X[6], X6);
      _mm512_store_si512(&X[7], X7);

      if (0 == i) {
         // Set initial transposed data
         dgt_lo = X0;
         dgt_hi = X1;
      }
      else {
         // X0 is always the next digit after matrix transpose
         dgt_hi = X0;
      }

      // Unpack currently transposed matrix
      while ((n+1)*52 < (i+8)*64)
      {
         // Concatinate left and right parts for 52bit digit.

         #if defined(IFMA_IPPCP_BUILD) // VBMI2 instructions removed from IPP implementation
            __m512i dgt_lo_ = _mm512_srlv_epi64(dgt_lo, _mm512_set1_epi64(sr));
            __m512i dgt_hi_ = _mm512_sllv_epi64(dgt_hi, _mm512_set1_epi64(64 - sr));
            T = _mm512_and_si512(_mm512_or_si512(dgt_lo_, dgt_hi_), MASK);
         #else
            T = _mm512_and_si512(
               _mm512_shrdv_epi64(dgt_lo, dgt_hi, _mm512_set1_epi64(sr))
               , MASK);
         #endif /*_MSC_VER*/

         _mm512_store_si512(&mb8[n++], T);

         // Move to next digit
         sr = (sr + 52) % 64;
         if (sr < 52) {
            idx++;
            dgt_lo = dgt_hi;
            if (idx+1 < i+8) { // No need to go to next digit, need to transpose next matrix
               assert((idx % 8 + 1) < 8);
               dgt_hi = _mm512_load_epi64(&X[idx % 8 + 1]);
            }
         }
      }
   }

   // Write last digit if needed
   if ((bitLen+51)/52 != n) {
      #if defined(IFMA_IPPCP_BUILD) // VBMI2 instructions removed from IPP implementation
         __m512i dgt_lo_ = _mm512_srlv_epi64(dgt_lo, _mm512_set1_epi64(sr));
         T = _mm512_and_si512(_mm512_or_si512(dgt_lo_, _mm512_setzero_si512()), MASK);
      #else
         T = _mm512_and_si512(
            _mm512_shrdv_epi64(dgt_lo, _mm512_setzero_si512(), _mm512_set1_epi64(sr))
            , MASK);
      #endif /*_MSC_VER*/
   }

   
   _mm512_store_si512(&mb8[n++], T);
}

#ifndef BN_OPENSSL_DISABLE
// Convert BIGNUM into MB8(Radix=2^52) format
// Returns bitmask of succesfully converted values
// Accepts NULLs as BIGNUM inputs
//    Null or wrong length
int8u ifma_BN_to_mb8(int64u out_mb8[][8], const BIGNUM* const bn[8], int bitLen)
{
   int64u *d[8];
   int byteLens[8];
   int i;

   // Check input parameters
   assert(bitLen % 512 == 0);
   for (i = 0; i < 8; ++i) {
      if(NULL != bn[i]) {
         byteLens[i] = BN_num_bytes(bn[i]);
         assert(byteLens[i] * 8 <= bitLen);
#if BN_OPENSSL_PATCH
         d[i] = (int64u*)bn_get_words(bn[i]);
#else
         d[i] = (int64u*)malloc((bitLen+7)/8);  // Allocate buffer (TODO: make single buffer)
         if( (NULL == d[i]) || ((bitLen + 7)/8 < BN_bn2lebinpad(bn[i], (int8u*)d[i], (bitLen + 7)/8)) )
            byteLens[i] = 0;
#endif
      }
      else {
         // No input in that bucket
         d[i] = NULL;
         byteLens[i] = 0;
      }
   }

   transform_8sb_to_mb8(out_mb8, bitLen, d, byteLens, 0);

#ifndef BN_OPENSSL_PATCH
   for (i = 0; i < 8; i++) if (d[i] != 0x0) free(d[i]);
#endif

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&bn), _mm512_setzero_si512());
}
#endif /* BN_OPENSSL_DISABLE */

// Simlilar to ifma_BN_to_mb8(), but converts array of int64u instead of BIGNUM
// Assumed that each converted values has bitLen length
int8u ifma_BNU_to_mb8(int64u out_mb8[][8], const int64u* const bn[8], int bitLen)
{
   int byteLens[8];
   int i;

   // Check input parameters
   assert(bitLen % 512 == 0);
   for (i = 0; i < 8; ++i) {
      byteLens[i] = 0;
      if (NULL != bn[i]) {
         byteLens[i] = bitLen/8;
      }
   }

   transform_8sb_to_mb8(out_mb8, bitLen, (int64u**)bn, byteLens, 0);

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&bn), _mm512_setzero_si512());
}


/* transpose regular (2^64) input and convert to redundant (2^52) output */
void regular13_red16_mb8(int64u (*redOut)[8], const int64u* const pRegInp[8], int bitLen)
{
   //__ALIGN64 int64u X[8][16];
   //__m512i index0 = _mm512_setr_epi64(0*16, 1*16, 2*16, 3*16, 4*16, 5*16, 6*16, 7*16);
   //__m512i index_step = _mm512_set1_epi64(1);
   __m512i MASK = _mm512_set1_epi64(DIGIT_MASK);

   int n;
   for(n=0; bitLen>0; n+=13, bitLen-=13*64) {
      int cvtBits = (bitLen>=(13*64))? (13*64) : bitLen;
      int inpLen = (cvtBits + 64-1)/64;
      int outLen = (cvtBits + DIGIT_SIZE-1)/DIGIT_SIZE;

      __m512i X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15, T;
      //__m512i index = index0;

      /* read input and store in continuos buffer */
      __mmask8 k1 = inpLen>=8? 0xff : (1<<inpLen) -1;
      __mmask8 k2 = inpLen>=8? (1<<(inpLen-8)) -1 : 0;

      X0 = _mm512_maskz_loadu_epi64(k1, pRegInp[0]+n);
      X1 = _mm512_maskz_loadu_epi64(k1, pRegInp[1]+n);
      X2 = _mm512_maskz_loadu_epi64(k1, pRegInp[2]+n);
      X3 = _mm512_maskz_loadu_epi64(k1, pRegInp[3]+n);
      X4 = _mm512_maskz_loadu_epi64(k1, pRegInp[4]+n);
      X5 = _mm512_maskz_loadu_epi64(k1, pRegInp[5]+n);
      X6 = _mm512_maskz_loadu_epi64(k1, pRegInp[6]+n);
      X7 = _mm512_maskz_loadu_epi64(k1, pRegInp[7]+n);
      TRANSPOSE_8xI64x8(X0, X1, X2, X3, X4, X5, X6, X7)

      X8  = _mm512_maskz_loadu_epi64(k2, pRegInp[0]+n+8);
      X9  = _mm512_maskz_loadu_epi64(k2, pRegInp[1]+n+8);
      X10 = _mm512_maskz_loadu_epi64(k2, pRegInp[2]+n+8);
      X11 = _mm512_maskz_loadu_epi64(k2, pRegInp[3]+n+8);
      X12 = _mm512_maskz_loadu_epi64(k2, pRegInp[4]+n+8);
      X13 = _mm512_maskz_loadu_epi64(k2, pRegInp[5]+n+8);
      X14 = _mm512_maskz_loadu_epi64(k2, pRegInp[6]+n+8);
      X15 = _mm512_maskz_loadu_epi64(k2, pRegInp[7]+n+8);
      TRANSPOSE_8xI64x8(X8, X9, X10, X11, X12, X13, X14, X15)

      /* radix conversion */
      T = _mm512_and_si512(X0, MASK);
      _mm512_store_si512(redOut[0], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X0, 52), _mm512_slli_epi64(X1, 12)), MASK);
      _mm512_store_si512(redOut[1], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X1, 40), _mm512_slli_epi64(X2, 24)), MASK);
      _mm512_store_si512(redOut[2], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X2, 28), _mm512_slli_epi64(X3, 36)), MASK);
      _mm512_store_si512(redOut[3], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X3, 16), _mm512_slli_epi64(X4, 48)), MASK);
      _mm512_store_si512(redOut[4], T);
      if(!--outLen) break;

      T = _mm512_and_si512(_mm512_srli_epi64(X4, 4), MASK);
      _mm512_store_si512(redOut[5], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X4, 56), _mm512_slli_epi64(X5, 8)), MASK);
      _mm512_store_si512(redOut[6], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X5, 44), _mm512_slli_epi64(X6, 20)), MASK);
      _mm512_store_si512(redOut[7], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X6, 32), _mm512_slli_epi64(X7, 32)), MASK);
      _mm512_store_si512(redOut[8], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X7, 20), _mm512_slli_epi64(X8, 44)), MASK);
      _mm512_store_si512(redOut[9], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_srli_epi64(X8, 8), MASK);
      _mm512_store_si512(redOut[10], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X8, 60), _mm512_slli_epi64(X9,  4)), MASK);
      _mm512_store_si512(redOut[11], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X9, 48), _mm512_slli_epi64(X10,16)), MASK);
      _mm512_store_si512(redOut[12], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X10,36), _mm512_slli_epi64(X11,28)), MASK);
      _mm512_store_si512(redOut[13], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_xor_si512(_mm512_srli_epi64(X11,24), _mm512_slli_epi64(X12,40)), MASK);
      _mm512_store_si512(redOut[14], T);
      if(!--outLen) break;

      T = _mm512_and_si512( _mm512_srli_epi64(X12, 12), MASK);
      _mm512_store_si512(redOut[15], T);
      redOut +=16;
   }
}

void red16_regular13_mb8(int64u* const pRegOut[8], int64u (*redInp)[8], int bitLen)
{
   __ALIGN64 int64u X[8][16];
   __m512i index0 = _mm512_setr_epi64(0*16, 1*16, 2*16, 3*16, 4*16, 5*16, 6*16, 7*16);
   __m512i index_step = _mm512_set1_epi64(1);

   int n;
   for(n=0; bitLen>0; n+=13, bitLen-=16*DIGIT_SIZE) {
      int cvtBits = (bitLen>=(16*DIGIT_SIZE))? (16*DIGIT_SIZE) : bitLen;
      int inplen = (cvtBits + DIGIT_SIZE-1)/DIGIT_SIZE;
      int outLen = (cvtBits + 64-1)/64;

      __m512i T, X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12, X13, X14, X15;
      __m512i index = index0;

      /* read input */
      X0=X1=X2=X3=X4=X5=X6=X7=X8=X9=X10=X11=X12=X13=X14=X15=_mm512_setzero_si512();
      do {
         X0 = _mm512_load_epi64(redInp[0]);  if(!--inplen) break;
         X1 = _mm512_load_epi64(redInp[1]);  if(!--inplen) break;
         X2 = _mm512_load_epi64(redInp[2]);  if(!--inplen) break;
         X3 = _mm512_load_epi64(redInp[3]);  if(!--inplen) break;
         X4 = _mm512_load_epi64(redInp[4]);  if(!--inplen) break;
         X5 = _mm512_load_epi64(redInp[5]);  if(!--inplen) break;
         X6 = _mm512_load_epi64(redInp[6]);  if(!--inplen) break;
         X7 = _mm512_load_epi64(redInp[7]);  if(!--inplen) break;
         X8 = _mm512_load_epi64(redInp[8]);  if(!--inplen) break;
         X9 = _mm512_load_epi64(redInp[9]);  if(!--inplen) break;
         X10 =_mm512_load_epi64(redInp[10]); if(!--inplen) break;
         X11 =_mm512_load_epi64(redInp[11]); if(!--inplen) break;
         X12 =_mm512_load_epi64(redInp[12]); if(!--inplen) break;
         X13 =_mm512_load_epi64(redInp[13]); if(!--inplen) break;
         X14 =_mm512_load_epi64(redInp[14]); if(!--inplen) break;
         X15 =_mm512_load_epi64(redInp[15]);
      } while(0);
      redInp += 16;

      /* convert radix and store transposed */
      T = _mm512_xor_si512(X0, _mm512_slli_epi64(X1, 52));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X1, 12), _mm512_slli_epi64(X2, 40));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X2, 24), _mm512_slli_epi64(X3, 28));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X3, 36), _mm512_slli_epi64(X4, 16));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X4, 48), _mm512_slli_epi64(X5, 4));
      T = _mm512_xor_si512(T, _mm512_slli_epi64(X6, 56));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X6,  8), _mm512_slli_epi64(X7, 44));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X7, 20), _mm512_slli_epi64(X8, 32));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X8, 32), _mm512_slli_epi64(X9, 20));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X9, 44), _mm512_slli_epi64(X10, 8));
      T = _mm512_xor_si512(T, _mm512_slli_epi64(X11,60));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X11, 4), _mm512_slli_epi64(X12,48));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X12,16), _mm512_slli_epi64(X13,36));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X13,28), _mm512_slli_epi64(X14,24));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      T = _mm512_xor_si512(_mm512_srli_epi64(X14,40), _mm512_slli_epi64(X15,12));
      _mm512_i64scatter_epi64(X, index, T, sizeof(int64u));
      index = _mm512_add_epi64(index, index_step);

      /* store result */
      {
         __mmask8 k1 = outLen>=8? 0xff : (1<<outLen) -1;
         __mmask8 k2 = outLen>=8? (1<<(outLen-8)) -1 : 0;

         _mm512_mask_storeu_epi64(pRegOut[0]+n,   k1, _mm512_maskz_load_epi64(k1, X[0]));
         _mm512_mask_storeu_epi64(pRegOut[0]+n+8, k2, _mm512_maskz_load_epi64(k2, X[0]+8));

         _mm512_mask_storeu_epi64(pRegOut[1]+n,   k1, _mm512_maskz_load_epi64(k1, X[1]));
         _mm512_mask_storeu_epi64(pRegOut[1]+n+8, k2, _mm512_maskz_load_epi64(k2, X[1]+8));

         _mm512_mask_storeu_epi64(pRegOut[2]+n,   k1, _mm512_maskz_load_epi64(k1, X[2]));
         _mm512_mask_storeu_epi64(pRegOut[2]+n+8, k2, _mm512_maskz_load_epi64(k2, X[2]+8));

         _mm512_mask_storeu_epi64(pRegOut[3]+n,   k1, _mm512_maskz_load_epi64(k1, X[3]));
         _mm512_mask_storeu_epi64(pRegOut[3]+n+8, k2, _mm512_maskz_load_epi64(k2, X[3]+8));

         _mm512_mask_storeu_epi64(pRegOut[4]+n,   k1, _mm512_maskz_load_epi64(k1, X[4]));
         _mm512_mask_storeu_epi64(pRegOut[4]+n+8, k2, _mm512_maskz_load_epi64(k2, X[4]+8));

         _mm512_mask_storeu_epi64(pRegOut[5]+n,   k1, _mm512_maskz_load_epi64(k1, X[5]));
         _mm512_mask_storeu_epi64(pRegOut[5]+n+8, k2, _mm512_maskz_load_epi64(k2, X[5]+8));

         _mm512_mask_storeu_epi64(pRegOut[6]+n,   k1, _mm512_maskz_load_epi64(k1, X[6]));
         _mm512_mask_storeu_epi64(pRegOut[6]+n+8, k2, _mm512_maskz_load_epi64(k2, X[6]+8));

         _mm512_mask_storeu_epi64(pRegOut[7]+n,   k1, _mm512_maskz_load_epi64(k1, X[7]));
         _mm512_mask_storeu_epi64(pRegOut[7]+n+8, k2, _mm512_maskz_load_epi64(k2, X[7]+8));
      }
   }
}


int8u ifma_HexStr8_to_mb8(int64u out_mb8[][8], const int8u* const pStr[8], int bitLen)
{
   int byteLens[8];
   int i;
   //int idx, sl, sr, n;

   // check input parameters
   assert(bitLen % 512 == 0);
   for (i=0; i<8; i++) {
      const int8u* ptr = pStr[i];
      byteLens[i] = (NULL != ptr) ? (bitLen+7)/8 : 0;
   }

   transform_8sb_to_mb8(out_mb8, bitLen, (int64u**)pStr, byteLens, 1);

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&pStr), _mm512_setzero_si512());
}

#if defined(_MSC_VER)
#  include <stdlib.h>
#  define ENDIANNESS64(x) _byteswap_uint64((x))
#else
#  define ENDIANNESS64(x) _bswap64((x))
#endif

static int ifmaBNU_OctStr(unsigned char* pStr, const int64u* pA, int nsA)
{
   int strLen = 0;
   for (; nsA > 0; nsA--, strLen += sizeof(int64u)) {
      int64u x = pA[nsA - 1];
      *((int64u*)pStr) = /*__bswap_64(x)*/ENDIANNESS64(x);
      pStr += 8;
   }
   return strLen;
}

int8u ifma_mb8_to_HexStr8(int8u* const pStr[8], int64u inp_mb8[][8], int bitLen)
{
    #if defined(_MSC_VER) && !defined(__INTEL_COMPILER)
    #pragma warning(push)
    #pragma warning(disable : 4221) // for MSVC, nonstandard extension used: cannot be initialized using address of automatic variable 'tmp_out'
    #endif
   __ALIGN64 int64u tmp_out[8][(RSA_4K) / 64];
   int64u* pa_tmp_out[8] = {tmp_out[0], tmp_out[1], tmp_out[2], tmp_out[3], tmp_out[4], tmp_out[5], tmp_out[6], tmp_out[7]};
   #if defined(_MSC_VER) && !defined(__INTEL_COMPILER)
   #pragma warning(pop)
   #endif

   int numwords = (bitLen + 8*sizeof(int64u)-1)/(8*sizeof(int64u));
   int n;

   /* convert result from ifma fmt */
   red16_regular13_mb8(pa_tmp_out, inp_mb8, bitLen);

   /* convert results to hex strings */
   for(n=0; n<8; n++)
      if (NULL != pStr[n])
         ifmaBNU_OctStr(pStr[n], tmp_out[n], numwords);

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&pStr), _mm512_setzero_si512());
}

int8u ifma_BNU_transpose_copy(int64u out_mb8[][8], const int64u* const bn[8], int bitLen)
{
   __mmask8 kbn[8];

   for (int i = 0; i < 8; ++i)
      if (NULL == bn[i])
         kbn[i] = 0;
      else
         kbn[i] = 0xFF;

   int len = (bitLen+63)/64;
   int n, rest;

   for(n=0, rest=len; n<len; n+=8, rest-=8) {
      __mmask8 k = (rest>=8)? 0xFF : (1<<rest) -1;

      __m512i X0 = _mm512_maskz_loadu_epi64(k & kbn[0], bn[0]+n);
      __m512i X1 = _mm512_maskz_loadu_epi64(k & kbn[1], bn[1]+n);
      __m512i X2 = _mm512_maskz_loadu_epi64(k & kbn[2], bn[2]+n);
      __m512i X3 = _mm512_maskz_loadu_epi64(k & kbn[3], bn[3]+n);
      __m512i X4 = _mm512_maskz_loadu_epi64(k & kbn[4], bn[4]+n);
      __m512i X5 = _mm512_maskz_loadu_epi64(k & kbn[5], bn[5]+n);
      __m512i X6 = _mm512_maskz_loadu_epi64(k & kbn[6], bn[6]+n);
      __m512i X7 = _mm512_maskz_loadu_epi64(k & kbn[7], bn[7]+n);

      TRANSPOSE_8xI64x8(X0, X1, X2, X3, X4, X5, X6, X7);

      _mm512_mask_storeu_epi64(out_mb8[0], k, X0);
      _mm512_mask_storeu_epi64(out_mb8[1], k, X1);
      _mm512_mask_storeu_epi64(out_mb8[2], k, X2);
      _mm512_mask_storeu_epi64(out_mb8[3], k, X3);
      _mm512_mask_storeu_epi64(out_mb8[4], k, X4);
      _mm512_mask_storeu_epi64(out_mb8[5], k, X5);
      _mm512_mask_storeu_epi64(out_mb8[6], k, X6);
      _mm512_mask_storeu_epi64(out_mb8[7], k, X7);
      out_mb8 += 8;
   }

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&bn), _mm512_setzero_si512());
}

#ifndef BN_OPENSSL_DISABLE
int8u ifma_BN_transpose_copy(int64u out_mb8[][8], const BIGNUM* const bn[8], int bitLen)
{
   __mmask8 kbn[8];
   int64u* inp[8];

#ifndef BN_OPENSSL_PATCH
   int byteLen = (bitLen+7)/8;
   int64u *inp_buf = (int64u*)malloc(8*byteLen);
   if (NULL == inp_buf)
      return 0;
#endif

   for (int i = 0; i < 8; ++i)
   {
      if (NULL == bn[i]) {
         kbn[i] = 0;
         inp[i] = NULL;
      }
      else {
         kbn[i] = 0xFF;
#if BN_OPENSSL_PATCH
         inp[i] = (int64u*)bn_get_words(bn[i]);
#else
         inp[i] = (int64u*)((int8u*)inp_buf + byteLen * i);
         BN_bn2lebinpad(bn[i], (unsigned char *)inp[i], byteLen);
#endif
      }
   }

   int len = (bitLen+63)/64;
   int n, rest;

   for(n=0, rest=len; n<len; n+=8, rest-=8) {
      __mmask8 k = (rest>=8)? 0xFF : (1<<rest) -1;

      __m512i X0 = _mm512_maskz_loadu_epi64(k & kbn[0], inp[0]+n);
      __m512i X1 = _mm512_maskz_loadu_epi64(k & kbn[1], inp[1]+n);
      __m512i X2 = _mm512_maskz_loadu_epi64(k & kbn[2], inp[2]+n);
      __m512i X3 = _mm512_maskz_loadu_epi64(k & kbn[3], inp[3]+n);
      __m512i X4 = _mm512_maskz_loadu_epi64(k & kbn[4], inp[4]+n);
      __m512i X5 = _mm512_maskz_loadu_epi64(k & kbn[5], inp[5]+n);
      __m512i X6 = _mm512_maskz_loadu_epi64(k & kbn[6], inp[6]+n);
      __m512i X7 = _mm512_maskz_loadu_epi64(k & kbn[7], inp[7]+n);

      TRANSPOSE_8xI64x8(X0, X1, X2, X3, X4, X5, X6, X7);

      _mm512_mask_storeu_epi64(out_mb8[0], k, X0);
      _mm512_mask_storeu_epi64(out_mb8[1], k, X1);
      _mm512_mask_storeu_epi64(out_mb8[2], k, X2);
      _mm512_mask_storeu_epi64(out_mb8[3], k, X3);
      _mm512_mask_storeu_epi64(out_mb8[4], k, X4);
      _mm512_mask_storeu_epi64(out_mb8[5], k, X5);
      _mm512_mask_storeu_epi64(out_mb8[6], k, X6);
      _mm512_mask_storeu_epi64(out_mb8[7], k, X7);
      out_mb8 += 8;
   }

#ifndef BN_OPENSSL_PATCH
   free(inp_buf);
#endif

   return _mm512_cmpneq_epi64_mask(_mm512_loadu_si512((__m512i*)&bn), _mm512_setzero_si512());
}
#endif /* BN_OPENSSL_DISABLE */
#endif
