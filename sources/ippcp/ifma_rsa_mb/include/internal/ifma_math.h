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
//  Purpose: MB RSA. Internal definitions and declarations
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#ifndef IFMA_MATH_H
#define IFMA_MATH_H

#if defined(_MSC_VER) && !defined(__INTEL_COMPILER)
#pragma warning(disable: 4310) // cast truncates constant value in MSVC
#endif

#include "immintrin.h"


// Typedef
typedef __m512i U64;


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
    // memory ops intrinsict - force load from original buffer
    #define _mm512_madd52lo_epu64_(r, a, b, c, o) \
    { \
        r=a; \
        __asm__ ( "vpmadd52luq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
    }
    #define _mm512_madd52hi_epu64_(r, a, b, c, o) \
    { \
        r=a; \
        __asm__ ( "vpmadd52huq " #o "(%2), %1, %0" : "+x" (r): "x" (b), "r" (c) ); \
    }
#else
    // Use IFMA instrinsics for all other compilers
    #pragma message ("Possibly non optimal solution")
    #define _mm512_madd52lo_epu64_(r, a, b, c, o) \
    { \
        r=fma52lo(a, b, _mm512_loadu_si512((U64*)(((char*)c)+o))); \
    }
    #define _mm512_madd52hi_epu64_(r, a, b, c, o) \
    { \
        r=fma52hi(a, b, _mm512_loadu_si512((U64*)(((char*)c)+o))); \
    }
#endif

static U64 add64(U64 a, U64 b)
{
    return _mm512_add_epi64(a, b);
}

static U64 get_zero64()
{
    return _mm512_setzero_si512();
}

static void set_zero64(U64 *a)
{
        *a = _mm512_xor_si512(*a, *a); 
}

static U64 srli64(U64 a, int s)
{
    return _mm512_srli_epi64(a, s);
}

static U64 and64_const(U64 a, unsigned long long mask)
{
    return _mm512_and_epi64(a, _mm512_set1_epi64(mask));
}

static U64 and64(U64 a, U64 mask)
{
    return _mm512_and_epi64(a, mask);
}

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
   /*__m512i*/ X4567L = _mm512_shuffle_i64x2(X45L, X67L, 0b01000100 ); \
   X0_ = _mm512_mask_shuffle_i64x2(X01L, 0b11111100, X23L, X4567L, 0b10000000 ); \
   X2_ = _mm512_mask_shuffle_i64x2(X23L, 0b11110011, X01L, X4567L, 0b11010001 ); \
   \
   /*__m512i*/ X0123L = _mm512_shuffle_i64x2(X01L, X23L, 0b11101110 ); \
   X4_ = _mm512_mask_shuffle_i64x2(X45L, 0b11001111, X0123L, X67L, 0b10001000 ); \
   X6_ = _mm512_mask_shuffle_i64x2(X67L, 0b00111111, X0123L, X45L, 0b10111101 ); \
   \
   /*__m512i*/ X4567H = _mm512_shuffle_i64x2(X45H, X67H, 0b01000100 ); \
   X1_ = _mm512_mask_shuffle_i64x2(X01H, 0b11111100, X23H, X4567H, 0b10000000 ); \
   X3_ = _mm512_mask_shuffle_i64x2(X23H, 0b11110011, X01H, X4567H, 0b11010001 ); \
   \
   /*__m512i*/ X0123H = _mm512_shuffle_i64x2(X01H, X23H, 0b11101110 ); \
   X5_ = _mm512_mask_shuffle_i64x2(X45H, 0b11001111, X0123H, X67H, 0b10001000 ); \
   X7_ = _mm512_mask_shuffle_i64x2(X67H, 0b00111111, X0123H, X45H, 0b10111101 ); }

#endif
#endif
