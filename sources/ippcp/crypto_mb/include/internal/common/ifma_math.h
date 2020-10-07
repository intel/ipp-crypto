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

#ifndef IFMA_MATH_H
#define IFMA_MATH_H

#if defined(_MSC_VER) && !defined(__INTEL_COMPILER) // for MSVC
    #pragma warning(disable:4101)
#elif defined (__INTEL_COMPILER)
    #pragma warning(disable:177)
#endif
#include <immintrin.h>
#include <internal/common/ifma_defs.h>

#if (SIMD_LEN == 512)
  SIMD_TYPE(512)
  typedef __mmask8 __mb_mask;

  #define SIMD_LEN 512
  #define SIMD_BYTES (SIMD_LEN/8)
  #define MB_WIDTH (SIMD_LEN/64)

  __INLINE U64 loadu64(const void *p) {
    return _mm512_loadu_si512((U64*)p);
  }

  __INLINE void storeu64(const void *p, U64 v) {
    _mm512_storeu_si512((U64*)p, v);
  }

  #define mask_mov64 _mm512_mask_mov_epi64
  #define set64 _mm512_set1_epi64

  __INLINE U64 fma52lo(U64 a, U64 b, U64 c)
  {
      return _mm512_madd52lo_epu64(a, b, c);
  }

  __INLINE U64 fma52hi(U64 a, U64 b, U64 c)
  {
      return _mm512_madd52hi_epu64(a, b, c);
  }

  __INLINE U64 mul52lo(U64 b, U64 c)
  {
      return _mm512_madd52lo_epu64(_mm512_setzero_si512(), b, c);
  }

  #ifdef __GNUC__
      // memory ops intrinsics - force load from original buffer
      #define _mm512_madd52lo_epu64_(r, a, b, c, o) \
      { \
          r=a; \
          __asm__ ( "vpmadd52luq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
      }
      //gres: #define fma52lo_mem(r, a, b, c, o) _mm512_madd52lo_epu64_(r, a, b, c, o)

      #define _mm512_madd52hi_epu64_(r, a, b, c, o) \
      { \
          r=a; \
          __asm__ ( "vpmadd52huq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
      }
      //gres: #define fma52hi_mem(r, a, b, c, o) _mm512_madd52hi_epu64_(r, a, b, c, o)

      __INLINE U64 select64(__mb_mask k, U64 v, U64 *d) {
          __asm__("vmovdqu64 %2, %%zmm0 \n"
                  "vpblendmq %%zmm0, %0, %0 %{%1%} \n"
          : "+v"(v)
          : "Yk"(k), "m"(*d)
          : "zmm0");
          return v;
      }
  #else
      // Use IFMA instrinsics for all other compilers
      #define _mm512_madd52lo_epu64_(r, a, b, c, o) \
      { \
          r=fma52lo(a, b, _mm512_loadu_si512((U64*)(((char*)c)+o))); \
      }

      #define _mm512_madd52hi_epu64_(r, a, b, c, o) \
      { \
          r=fma52hi(a, b, _mm512_loadu_si512((U64*)(((char*)c)+o))); \
      }

      #pragma optimize("", off)
      __INLINE U64 select64(__mb_mask k, U64 v, U64 *d) {
         return _mm512_mask_blend_epi64(k, v, _mm512_load_si512(d));
      }
      #pragma optimize("", on)
  #endif

#define fma52lo_mem(r, a, b, c, o) _mm512_madd52lo_epu64_(r, a, b, c, o) // gres
#define fma52hi_mem(r, a, b, c, o) _mm512_madd52hi_epu64_(r, a, b, c, o) // gres

  __INLINE U64 add64(U64 a, U64 b)
  {
      return _mm512_add_epi64(a, b);
  }

  __INLINE U64 sub64(U64 a, U64 b)
  {
      return _mm512_sub_epi64(a, b);
  }

  __INLINE U64 get_zero64()
  {
      return _mm512_setzero_si512();
  }

  __INLINE void set_zero64(U64 *a)
  {
          *a = _mm512_xor_si512(*a, *a);
  }

  __INLINE U64 set1(unsigned long long a)
  {
      return _mm512_set1_epi64((long long)a);
  }

  __INLINE U64 srli64(U64 a, int s)
  {
      return _mm512_srli_epi64(a, s);
  }

  #define srai64 _mm512_srai_epi64
  #define slli64 _mm512_slli_epi64

  __INLINE U64 and64_const(U64 a, unsigned long long mask)
  {
      return _mm512_and_epi64(a, _mm512_set1_epi64((long long)mask));
  }

  __INLINE U64 and64(U64 a, U64 mask)
  {
      return _mm512_and_epi64(a, mask);
  }

  #define or64 _mm512_or_epi64
  #define xor64 _mm512_xor_epi64

  #define cmp64_mask _mm512_cmp_epi64_mask
  #define cmpeq16_mask _mm512_cmpeq_epi16_mask
  #define cmpeq64_mask _mm512_cmpeq_epi64_mask

  /// Mask operations

  #define mask_blend64 _mm512_mask_blend_epi64
  #define mask_add64   _mm512_mask_add_epi64
  #define mask_sub64   _mm512_mask_sub_epi64
  #define maskz_sub64  _mm512_maskz_sub_epi64

#if defined(_MSC_VER) && !defined(__INTEL_COMPILER) // for MSVC
  #define mask_xor(m1,m2) (__mb_mask)(_mm512_kxor((m1),(m2)))
#else
  #define mask_xor _kxor_mask8
#endif
  #define get_mask(a) (a)
  #define get_mask_value(a) (a)

  #define TRANSPOSE_8xI64x8(X0_, X1_ ,X2_ ,X3_ ,X4_ ,X5_ ,X6_ ,X7_) {\
     __m512i X01L = _mm512_unpacklo_epi64(X0_, X1_); \
     __m512i X23L = _mm512_unpacklo_epi64(X2_, X3_); \
     __m512i X45L = _mm512_unpacklo_epi64(X4_, X5_); \
     __m512i X67L = _mm512_unpacklo_epi64(X6_, X7_); \
     \
     __m512i X01H = _mm512_unpackhi_epi64(X0_, X1_); \
     __m512i X23H = _mm512_unpackhi_epi64(X2_, X3_); \
     __m512i X45H = _mm512_unpackhi_epi64(X4_, X5_); \
     __m512i X67H = _mm512_unpackhi_epi64(X6_, X7_); \
     \
     __m512i X4567L, X0123L, X4567H, X0123H; \
     X4567L = _mm512_shuffle_i64x2(X45L, X67L, 0b01000100 ); \
     X0_ = _mm512_mask_shuffle_i64x2(X01L, 0b11111100, X23L, X4567L, 0b10000000 ); \
     X2_ = _mm512_mask_shuffle_i64x2(X23L, 0b11110011, X01L, X4567L, 0b11010001 ); \
     \
     X0123L = _mm512_shuffle_i64x2(X01L, X23L, 0b11101110 ); \
     X4_ = _mm512_mask_shuffle_i64x2(X45L, 0b11001111, X0123L, X67L, 0b10001000 ); \
     X6_ = _mm512_mask_shuffle_i64x2(X67L, 0b00111111, X0123L, X45L, 0b10111101 ); \
     \
     X4567H = _mm512_shuffle_i64x2(X45H, X67H, 0b01000100 ); \
     X1_ = _mm512_mask_shuffle_i64x2(X01H, 0b11111100, X23H, X4567H, 0b10000000 ); \
     X3_ = _mm512_mask_shuffle_i64x2(X23H, 0b11110011, X01H, X4567H, 0b11010001 ); \
     \
     X0123H = _mm512_shuffle_i64x2(X01H, X23H, 0b11101110 ); \
     X5_ = _mm512_mask_shuffle_i64x2(X45H, 0b11001111, X0123H, X67H, 0b10001000 ); \
     X7_ = _mm512_mask_shuffle_i64x2(X67H, 0b00111111, X0123H, X45H, 0b10111101 ); }

#elif (SIMD_LEN == 256)
  SIMD_TYPE(256)
  typedef __m256i __mb_mask;

  #define SIMD_LEN 256
  #define SIMD_BYTES (SIMD_LEN/8)
  #define MB_WIDTH (SIMD_LEN/64)

  __INLINE U64 loadu64(const void *p) {
    return _mm256_loadu_si256((U64*)p);
  }

  __INLINE void storeu64(const void *p, U64 v) {
    _mm256_storeu_si256((U64*)p, v);
  }

  // #define mask_mov64 _mm256_mask_mov_epi64
  __INLINE __m256i mask_mov64(__m256i a, __mb_mask m, __m256i b) {
    return _mm256_blendv_epi8(a, b, m);
  }

  #define set64 _mm256_set1_epi64x

  #ifdef __GNUC__
      static U64 fma52lo(U64 a, U64 b, U64 c)
      {
        __asm__ ( "vpmadd52luq %2, %1, %0" : "+x" (a): "x" (b), "x" (c) );
        return a;
      }

      static U64 fma52hi(U64 a, U64 b, U64 c)
      {
        __asm__ ( "vpmadd52huq %2, %1, %0" : "+x" (a): "x" (b), "x" (c) );
        return a;
      }

      #define _mm_madd52lo_epu64_(r, a, b, c, o) \
      { \
          r=a; \
          __asm__ ( "vpmadd52luq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
      }

      #define _mm_madd52hi_epu64_(r, a, b, c, o) \
      { \
          r=a; \
          __asm__ ( "vpmadd52huq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
      }
  #else
      // Use IFMA instrinsics for all other compilers
      static U64 fma52lo(U64 a, U64 b, U64 c)
      {
        return _mm256_madd52lo_epu64(a, b, c);
      }

      static U64 fma52hi(U64 a, U64 b, U64 c)
      {
        return _mm256_madd52hi_epu64(a, b, c);
      }

      #define _mm_madd52lo_epu64_(r, a, b, c, o) \
      { \
          r=fma52lo(a, b, loadu64((U64*)(((char*)c)+o))); \
      }

      #define _mm_madd52hi_epu64_(r, a, b, c, o) \
      { \
          r=fma52hi(a, b, loadu64((U64*)(((char*)c)+o))); \
      }
  #endif

  __INLINE U64 mul52lo(U64 b, U64 c)
  {
    return fma52lo(_mm256_setzero_si256(), b, c);
  }

  #define fma52lo_mem(r, a, b, c, o) _mm_madd52lo_epu64_(r, a, b, c, o)
  #define fma52hi_mem(r, a, b, c, o) _mm_madd52hi_epu64_(r, a, b, c, o)

  __INLINE U64 add64(U64 a, U64 b)
  {
    return _mm256_add_epi64(a, b);
  }

  __INLINE U64 sub64(U64 a, U64 b)
  {
    return _mm256_sub_epi64(a, b);
  }

  __INLINE U64 get_zero64()
  {
    return _mm256_setzero_si256();
  }

  __INLINE void set_zero64(U64 *a)
  {
    *a = _mm256_xor_si256(*a, *a);
  }

  __INLINE U64 set1(unsigned long long a)
  {
    return _mm256_set1_epi64x((long long)a);
  }

  __INLINE U64 srli64(U64 a, int s)
  {
    return _mm256_srli_epi64(a, s);
  }

   #if 0
  // Arithmetic 64bit right shift doesn't exist in AVX2, so use emulation sequence for it
  // #define srai64 _mm256_srli_epi64
  __INLINE __m256i srai64(__m256i a, int s) {
      __m256i sign = _mm256_cmpgt_epi64(_mm256_setzero_si256(), a);           // sign exp
      a = _mm256_srli_epi64(a, 52);                                           // logical shift
      //sign = _mm256_and_si256(sign, _mm256_set1_epi64x(0xFFFFFFFFFFFFF000LL));  // clear low 12 bits sign
      sign = _mm256_and_si256(sign, _mm256_set1_epi64x(-4096));  // clear low 12 bits sign
      a = _mm256_or_si256(a, sign);                                           // signed result
      return a;
  }
  #endif

  #define slli64 _mm256_slli_epi64

  __INLINE U64 and64_const(U64 a, unsigned long long mask)
  {
    return _mm256_and_si256(a, _mm256_set1_epi64x((long long)mask));
  }

  __INLINE U64 and64(U64 a, U64 mask)
  {
    return _mm256_and_si256(a, mask);
  }

  #define or64 _mm256_or_si256
  #define xor64 _mm256_xor_si256

  // _mm256_cmp_epi64_mask backport to AVX2
  // TODO: Implement add compare modes (or throw compilation error)
  __INLINE __mb_mask cmp64_mask(U64 a, U64 b, int m) {
    if (m == 4)       // _MM_CMPINT_NE
      return _mm256_xor_si256(_mm256_cmpeq_epi64(a, b), _mm256_set1_epi8((char)0xFF));
    else if (m == 1)  // _MM_CMPINT_LT
      return _mm256_or_si256(_mm256_cmpeq_epi64(a, b), _mm256_cmpgt_epi64(b, a));
    else /* not supported */
      return _mm256_setzero_si256();
  }

  __INLINE __mb_mask cmpeq16_mask(U64 a, U64 b) {
    return _mm256_cmpeq_epi16(a, b);
  }

  __INLINE __mb_mask cmpeq64_mask(U64 a, U64 b) {
    return _mm256_cmpeq_epi64(a, b);
  }

  __INLINE U64 mask_blend64(__mb_mask k, U64 a, U64 b) {
    return _mm256_blendv_epi8(a, b, k);
  }

  __INLINE U64 maskz_sub64(__mb_mask m, U64 a, U64 b) {
    U64 s = _mm256_sub_epi64(a, b);
    return mask_blend64(m, _mm256_setzero_si256(), s);
  }


  __INLINE __mb_mask mask_xor(__mb_mask a, __mb_mask b) {
    return _mm256_xor_si256(a, b);
  }

  __INLINE __mb_mask get_mask(char a) {
    return _mm256_set1_epi8(a);
  }

  static int64u get64(U64 v, int idx) {
    long long int res;
    switch (idx) {
      case 1: res = _mm256_extract_epi64(v, 1); break;
      case 2: res = _mm256_extract_epi64(v, 2); break;
      case 3: res = _mm256_extract_epi64(v, 3); break;
      default: res = _mm256_extract_epi64(v, 0);
    }
    return (int64u)res;
  }

  /* ---------------------------------------------------------------------------------- */
  #define fma52x8lo_mem(r, a, b, c, o)             \
      fma52lo_mem(r, a, b, c, o);                  \
      fma52lo_mem(r ## h, a ## h, b, c, (o) + 32);

  #define fma52x8hi_mem(r, a, b, c, o)             \
      fma52hi_mem(r, a, b, c, o);                  \
      fma52hi_mem(r ## h, a ## h, b, c, (o) + 32);

  #define fma52x8lo_mem_len(r, a, b, c, o, l) \
      fma52lo_mem(r, a, b, c, o);             \
      if (l > 4) { fma52lo_mem(r ## h, a ## h, b, c, (o) + 32); }

  #define fma52x8hi_mem_len(r, a, b, c, o, l) \
      fma52hi_mem(r, a, b, c, o);             \
      if (l > 4) { fma52hi_mem(r ## h, a ## h, b, c, (o) + 32); }

  #define fma52x8lo_mask_mem(r, m, a, b, c, o)     \
      fma52lo_mem(r, a, b, c, o);                  \
      fma52lo_mem(r ## h, a ## h, b, c, (o) + 32);

  #define fma52x8hi_mask_mem(r, m, a, b, c, o)     \
      fma52hi_mem(r, a, b, c, o);                  \
      fma52hi_mem(r ## h, a ## h, b, c, (o) + 32);
  /* ---------------------------------------------------------------------------------- */

  #define shift64(R0, R1) { \
      R0 = R0 ## h;         \
      R0 ## h = R1; }

  #define shift64_imm(R0, R1, imm) \
      R0 = _mm256_alignr_epi64(R1, R0, imm);

  static U64 blend64(U64 a, U64 b, int m) {
      // FIXME: Double every bit
      if(m == 1)
          return _mm256_blend_epi32(a, b, 0b00000011);
      else // FIXME: Not implemented
          return a;
  }
#else
  #error "Incorrect SIMD length"
#endif  // SIMD_LEN

#endif  // IFMA_MATH_H
