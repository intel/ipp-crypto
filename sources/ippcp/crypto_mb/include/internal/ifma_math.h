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
#else 
    #pragma warning(disable:177)
#endif

#include "immintrin.h"
#include "ifma_internal.h"

#if (SIMD_LEN == 512)
  SIMD_TYPE(512)
  typedef __mmask8 __mb_mask;

  #define SIMD_LEN 512
  #define SIMD_BYTES (SIMD_LEN/8)
  #define MB_WIDTH (SIMD_LEN/64)

  static U64 loadu64(const void *p) {
    return _mm512_loadu_si512((U64*)p);
  }

  static void storeu64(const void *p, U64 v) {
    _mm512_storeu_si512((U64*)p, v);
  }

  #define mask_mov64 _mm512_mask_mov_epi64
  #define set64 _mm512_set1_epi64

  static U64 fma52lo(U64 a, U64 b, U64 c)
  {
      return _mm512_madd52lo_epu64(a, b, c);
  }

  static U64 fma52hi(U64 a, U64 b, U64 c)
  {
      return _mm512_madd52hi_epu64(a, b, c);
  }

  static U64 mul52lo(U64 b, U64 c)
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
  #endif

#define fma52lo_mem(r, a, b, c, o) _mm512_madd52lo_epu64_(r, a, b, c, o) // gres
#define fma52hi_mem(r, a, b, c, o) _mm512_madd52hi_epu64_(r, a, b, c, o) // gres

  static U64 add64(U64 a, U64 b)
  {
      return _mm512_add_epi64(a, b);
  }

  static U64 sub64(U64 a, U64 b)
  {
      return _mm512_sub_epi64(a, b);
  }

  static U64 get_zero64()
  {
      return _mm512_setzero_si512();
  }

  static void set_zero64(U64 *a)
  {
          *a = _mm512_xor_si512(*a, *a); 
  }

  static U64 set1(unsigned long long a)
  {
      return _mm512_set1_epi64((long long)a);
  }

  static U64 srli64(U64 a, int s)
  {
      return _mm512_srli_epi64(a, s);
  }

  #define srai64 _mm512_srai_epi64
  #define slli64 _mm512_slli_epi64

  static U64 and64_const(U64 a, unsigned long long mask)
  {
      return _mm512_and_epi64(a, _mm512_set1_epi64((long long)mask));
  }

  static U64 and64(U64 a, U64 mask)
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
  #define maskz_sub64(m, a, b) _mm512_maskz_sub_epi64(m, a, b)

  #define mask_xor _kxor_mask8
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

#else // SIMD_LEN == 256

  SIMD_TYPE(256)
  typedef __m256i __mb_mask;

  #define SIMD_LEN 256
  #define SIMD_BYTES (SIMD_LEN/8)
  #define MB_WIDTH (SIMD_LEN/64)

  static U64 loadu64(const void *p) {
    return _mm256_loadu_si256((U64*)p);
  }

  static void storeu64(const void *p, U64 v) {
    _mm256_storeu_si256((U64*)p, v);
  }

  // #define mask_mov64 _mm256_mask_mov_epi64
  static __m256i mask_mov64(__m256i a, __mb_mask m, __m256i b) {
    return _mm256_blendv_epi8(a, b, m);
  }

  static U64 set64(unsigned long long int v) {
    return _mm256_set1_epi64x(v);
  }

// #define USE_FMA
// FIXME: DO NOT PUT IT INTO RELEASE
#warning Remove FMA codepath from release!!!!
#ifndef USE_FMA

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

  static U64 fma52lo(U64 a, U64 b, U64 c)
  {
    __asm__ ( "vfmadd231ps %2, %1, %0" : "+x" (a): "x" (b), "x" (c) );
    return a;
  }

  static U64 fma52hi(U64 a, U64 b, U64 c)
  {
    __asm__ ( "vfmadd231ps %2, %1, %0" : "+x" (a): "x" (b), "x" (c) );
    return a;
  }

  #define _mm_madd52lo_epu64_(r, a, b, c, o) \
  { \
      r=a; \
      __asm__ ( "vfmadd231ps " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
  }

  #define _mm_madd52hi_epu64_(r, a, b, c, o) \
  { \
      r=a; \
      __asm__ ( "vfmadd231ps " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
  }

#endif

  static U64 mul52lo(U64 b, U64 c)
  {
      return fma52lo(_mm256_setzero_si256(), b, c);
  }

  #define fma52lo_mem(r, a, b, c, o) _mm_madd52lo_epu64_(r, a, b, c, o)
  #define fma52hi_mem(r, a, b, c, o) _mm_madd52hi_epu64_(r, a, b, c, o)

  static U64 add64(U64 a, U64 b)
  {
      return _mm256_add_epi64(a, b);
  }

  static U64 sub64(U64 a, U64 b)
  {
      return _mm256_sub_epi64(a, b);
  }

  static U64 get_zero64()
  {
      return _mm256_setzero_si256();
  }

  static void set_zero64(U64 *a)
  {
          *a = _mm256_xor_si256(*a, *a); 
  }

  static U64 set1(unsigned long long a)
  {
      return _mm256_set1_epi64x(a);
  }

  static U64 srli64(U64 a, int s)
  {
      return _mm256_srli_epi64(a, s);
  }

  // Arithmetic 64bit right shift doesn't exist in AVX2
  //  use emulation sequence for it
  // #define srai64 _mm256_srli_epi64
  static __m256i srai64(__m256i a, int s) {
    __m256i sign = _mm256_cmpgt_epi64(_mm256_setzero_si256(), a);           // sign exp
    a = _mm256_srli_epi64(a, 52);                                           // logical shift
    sign = _mm256_and_si256(sign, _mm256_set1_epi64x(0xFFFFFFFFFFFFF000));  // clear low 12 bits sign
    a = _mm256_or_si256(a, sign);                                           // signed result
  }

  #define slli64 _mm256_slli_epi64

  static U64 and64_const(U64 a, unsigned long long mask)
  {
      return _mm256_and_si256(a, _mm256_set1_epi64x(mask));
  }

  static U64 and64(U64 a, U64 mask)
  {
      return _mm256_and_si256(a, mask);
  }

  #define or64 _mm256_or_si256
  #define xor64 _mm256_xor_si256

  // _mm256_cmp_epi64_mask backport to AVX2
  // TODO: Implement add compare modes (or throw compilation error)
  static __mb_mask cmp64_mask(U64 a, U64 b, int m) {
    if (m == 4)       // _MM_CMPINT_NE
      return _mm256_xor_si256(_mm256_cmpeq_epi64(a, b), _mm256_set1_epi8(0xFF));
    else if (m == 1)  // _MM_CMPINT_LT
      return _mm256_or_si256(_mm256_cmpeq_epi64(a, b), _mm256_cmpgt_epi64(b, a));
    else /* not supported */ 
      return _mm256_setzero_si256();
  }

  static __mb_mask cmpeq16_mask(U64 a, U64 b) {
    return _mm256_cmpeq_epi16(a, b);
  }

  static __mb_mask cmpeq64_mask(U64 a, U64 b) {
    return _mm256_cmpeq_epi64(a, b);
  }

  static U64 mask_blend64(__mb_mask k, U64 a, U64 b) {
    return _mm256_blendv_epi8(a, b, k);
  }

  static U64 maskz_sub64(__mb_mask m, U64 a, U64 b) {
    U64 s = _mm256_sub_epi64(a, b);
    return mask_blend64(m, _mm256_setzero_si256(), s);
  }


  static __mb_mask mask_xor(__mb_mask a, __mb_mask b) {
    return _mm256_xor_si256(a, b);
  }

  static __mb_mask get_mask(char a) {
    return _mm256_set1_epi8(a);
  }

  // FIXME: remove every odd bit to get correct word mask (rename to WORD mask?)
  static unsigned int get_mask_value(__mb_mask m) {
    return _mm256_movemask_epi8(m);
  }

#endif  // SIMD_LEN

#endif  // IFMA_MATH_H
