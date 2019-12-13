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

#if !defined(_IFMA_INTERNAL_H_)
#define _IFMA_INTERNAL_H_

#include "rsa_ifma_defs.h"

#define IFMA_UINT_PTR( ptr ) ( (int64u)(ptr) )
#define IFMA_BYTES_TO_ALIGN(ptr, align) ((~(IFMA_UINT_PTR(ptr)&((align)-1))+1)&((align)-1))
#define IFMA_ALIGNED_PTR(ptr, align) (void*)( (unsigned char*)(ptr) + (IFMA_BYTES_TO_ALIGN( ptr, align )) )

// basis definition
#define DIGIT_SIZE (52)
#define DIGIT_BASE ((int64u)1<<DIGIT_SIZE)
#define DIGIT_MASK ((int64u)0xFFFFFFFFFFFFF)

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

// clear/copy mb8 buffer
EXTERN_C void zero_mb8(int64u(*redOut)[8], int len);
EXTERN_C void copy_mb8(int64u out[][8], const int64u inp[][8], int len);

// to/from regular/redundant 2^64 <-> 2^52 representation
EXTERN_C void regular13_red16_mb8(int64u(*redOut)[8], const int64u* const pRegInp[8], int bitLen);
EXTERN_C void red16_regular13_mb8(int64u* const pRegOut[8], int64u(*redInp)[8], int bitLen);
EXTERN_C int8u ifma_HexStr8_to_mb8(int64u res[][8], const int8u* const pStr[8], int bitLen);
EXTERN_C int8u ifma_mb8_to_HexStr8(int8u* const pStr[8], int64u res[][8], int bitLen);
EXTERN_C int8u ifma_BNU_to_mb8(int64u res[][8], const int64u* const bn[8], int bitLen);
EXTERN_C int8u ifma_BNU_transpose_copy(int64u out_mb8[][8], const int64u* const inp[8], int bitLen);
#ifndef BN_OPENSSL_DISABLE
#include <openssl/bn.h>
EXTERN_C int8u ifma_BN_to_mb8 (int64u res[][8], const BIGNUM* const bn[8], int bitLen);
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
                     const int64u k0_mb8[8]);

EXTERN_C void EXP52x20_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8]);

EXTERN_C void EXP52x40_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8]);

EXTERN_C void EXP52x60_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8]);

EXTERN_C void EXP52x30_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8]);

EXTERN_C void EXP52x79_mb8(int64u out[][8],
                     const int64u base[][8],
                     const int64u exponent[][8],
                     const int64u modulus[][8],
                     const int64u toMont[][8],
                     const int64u k0_mb8[8]);

// exponentiations (fixed short exponent ==65537)
EXTERN_C void EXP52x20_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8]);


EXTERN_C void EXP52x40_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8]);

EXTERN_C void EXP52x60_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8]);

EXTERN_C void EXP52x79_pub65537_mb8(int64u out[][8],
                              const int64u base[][8],
                              const int64u modulus[][8],
                              const int64u toMont[][8],
                              const int64u  k0[8]);
#endif /* _IFMA_INTERNAL_H_ */

#endif
