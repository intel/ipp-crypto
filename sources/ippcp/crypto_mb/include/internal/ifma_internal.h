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

#if !defined(_IFMA_INTERNAL_H_)
#define _IFMA_INTERNAL_H_

#ifndef BN_OPENSSL_DISABLE
  #include <openssl/bn.h>
#endif

#include "rsa_ifma_defs.h"

typedef int64u int64u_x8[8];        // alias   of 8-term vector of int64u each
typedef int64u (*pint64u_x8) [8];   // pointer to 8-term vector of int64u each

#define IFMA_UINT_PTR( ptr ) ( (int64u)(ptr) )
#define IFMA_BYTES_TO_ALIGN(ptr, align) ((~(IFMA_UINT_PTR(ptr)&((align)-1))+1)&((align)-1))
#define IFMA_ALIGNED_PTR(ptr, align) (void*)( (unsigned char*)(ptr) + (IFMA_BYTES_TO_ALIGN( ptr, align )) )

// basis definition
#define DIGIT_SIZE (52)
#define DIGIT_BASE ((int64u)1<<DIGIT_SIZE)
#define DIGIT_MASK ((int64u)0xFFFFFFFFFFFFF)

// Define SIMD_LEN if not set (Default is 512 bit AVX)
#ifndef SIMD_LEN
  #define SIMD_LEN 512
#endif

// make sure SIMD_LEN eithr 512 or 256
#if (SIMD_LEN != 512) && (SIMD_LEN != 256)
  #error "Incorrect SIMD length"
#endif

// Internal function names
#if (SIMD_LEN == 512)
    #define FUNC_SUFFIX mb8
    #define MB_FUNC_NAME(name) name ## mb8
#else
    #define FUNC_SUFFIX mb4
    #define MB_FUNC_NAME(name) name ## mb4
#endif

#define SIMD_TYPE(LEN) typedef __m ## LEN ## i U64;


#define RSA_1K (1024)
#define RSA_2K (2*RSA_1K)
#define RSA_3K (3*RSA_1K)
#define RSA_4K (4*RSA_1K)

#define NUMBER_OF_DIGITS(bitsize, digsize)   (((bitsize) + (digsize)-1)/(digsize))
#define MS_DIGIT_MASK(bitsize, digsize)      (((int64u)1 <<((bitsize) %digsize)) -1)

#define RSA_SIZE  (RSA_1K)
#define redLen    ((RSA_SIZE+(DIGIT_SIZE-1))/DIGIT_SIZE) //20

#define MULTIPLE_OF(x, factor)   ((x) + (((factor) -((x)%(factor))) %(factor)))

// ============ Multi-Buffer required functions ============

EXTERN_C void ifma_extract_amm52x20_mb8(int64u* out_mb8, const int64u* inpA_mb8, int64u MulTbl[][redLen][8], const int64u Idx[8], const int64u* inpM_mb8, const int64u* k0_mb8);

// Multiplication
EXTERN_C void ifma_amm52x10_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void ifma_amm52x20_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void ifma_amm52x60_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void ifma_amm52x40_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void ifma_amm52x30_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void ifma_amm52x79_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

// 4x Mont Mul
EXTERN_C void ifma_amm52x20_mb4(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);


// Diagonal sqr
EXTERN_C void AMS52x10_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x10_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

EXTERN_C void AMS52x20_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x20_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

EXTERN_C void AMS52x40_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x40_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

EXTERN_C void AMS52x60_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x60_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

EXTERN_C void AMS52x30_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x30_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

EXTERN_C void AMS52x79_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x79_diagonal_mb8(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);

// 4x Diagonal sqr
EXTERN_C void AMS52x20_diagonal_mb4(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
EXTERN_C void AMS5x52x20_diagonal_mb4(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);


// clear/copy mb8 buffer
EXTERN_C void zero_mb8(int64u(*redOut)[8], int len);
EXTERN_C void copy_mb8(int64u out[][8], const int64u inp[][8], int len);

// from 8 buffers regular (radix2^64) to mb8 redundant (radix 2^52) representation
EXTERN_C int8u ifma_BNU_to_mb8(int64u out_mb8[][8], const int64u* const bn[8], int bitLen);
EXTERN_C int8u ifma_HexStr8_to_mb8(int64u out_mb8[][8], const int8u* const pStr[8], int bitLen);
#ifndef BN_OPENSSL_DISABLE
EXTERN_C int8u ifma_BN_to_mb8(int64u res[][8], const BIGNUM* const bn[8], int bitLen);
#endif

// from 8 buffers mb8 redundant (radix 2^52) to regular (radix2^64) representation
EXTERN_C int8u ifma_mb8_to_BNU(int64u* const out_bn[8], const int64u inp_mb8[][8], const int bitLen);
EXTERN_C int8u ifma_mb8_to_HexStr8(int8u* const pStr[8], const int64u inp_mb8[][8], int bitLen);

EXTERN_C int8u ifma_BNU_transpose_copy(int64u out_mb8[][8], const int64u* const inp[8], int bitLen);
#ifndef BN_OPENSSL_DISABLE
EXTERN_C int8u ifma_BN_transpose_copy(int64u out_mb8[][8], const BIGNUM* const inp[8], int bitLen);
#endif /* BN_OPENSSL_DISABLE */

// other 2^52 radix arith functions
EXTERN_C void ifma_montFactor52_mb8(int64u k0_mb8[8], const int64u m0_mb8[8]);

EXTERN_C void ifma_modsub52x10_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8], const int64u inpM[][8]);
EXTERN_C void ifma_modsub52x20_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8], const int64u inpM[][8]);
EXTERN_C void ifma_modsub52x30_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8], const int64u inpM[][8]);
EXTERN_C void ifma_modsub52x40_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8], const int64u inpM[][8]);

EXTERN_C void ifma_addmul52x10_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8]);
EXTERN_C void ifma_addmul52x20_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8]);
EXTERN_C void ifma_addmul52x30_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8]);
EXTERN_C void ifma_addmul52x40_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8]);

EXTERN_C void ifma_amred52x10_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpM[][8], const int64u k0[8]);
EXTERN_C void ifma_amred52x20_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpM[][8], const int64u k0[8]);
EXTERN_C void ifma_amred52x30_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpM[][8], const int64u k0[8]);
EXTERN_C void ifma_amred52x40_mb8(int64u res[][8], const int64u inpA[][8], const int64u inpM[][8], const int64u k0[8]);

EXTERN_C void ifma_mreduce52x_mb8(int64u pX[][8], int nsX, int64u pM[][8], int nsM);
EXTERN_C void ifma_montRR52x_mb8(int64u pRR[][8], int64u pM[][8], int convBitLen);


// exponentiations
EXTERN_C void EXP52x10_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

EXTERN_C void EXP52x20_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

EXTERN_C void EXP52x40_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

EXTERN_C void EXP52x60_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

EXTERN_C void EXP52x30_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

EXTERN_C void EXP52x79_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8],
                     int64u work_buffer[][8]);

// exponentiations (fixed short exponent ==65537)
EXTERN_C void EXP52x20_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8],
                              int64u work_buffer[][8]);


EXTERN_C void EXP52x40_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8],
                              int64u work_buffer[][8]);

EXTERN_C void EXP52x60_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8],
                              int64u work_buffer[][8]);

EXTERN_C void EXP52x79_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8],
                              int64u work_buffer[][8]);
#endif /* _IFMA_INTERNAL_H_ */
