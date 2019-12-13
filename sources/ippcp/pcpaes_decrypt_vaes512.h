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
//  Purpose:
//     Cryptography Primitive.
//     AES decryption (VAES-512 kernels)
//
//  Contents:
//      cpAESDecrypt1_VAES_NI
//      cpAESDecrypt2_VAES_NI
//      cpAESDecrypt3_VAES_NI
//      cpAESDecrypt4_VAES_NI
//
*/

#include "owncp.h"
#include "pcpaesm.h"

#if(_IPP32E>=_IPP32E_K0)
#if defined(_MSC_VER) && !defined(__INTEL_COMPILER)
#pragma warning(disable: 4305) // zmmintrin.h bug: conversion from int to _mmask8
#endif
////////////////////////////////////////////////////////////////////////////////

static void cpAESDecrypt1_VAES_NI(__m512i* blk0,
                                  const __m128i* pRkey,
                                  int cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   rKey0      = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr < cipherRounds; nr += 2, pRkey -= 2) {
      b0    = _mm512_aesdec_epi128(b0, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);
      b0    = _mm512_aesdec_epi128(b0, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }

   b0    = _mm512_aesdec_epi128(b0, rKey1);
   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void cpAESDecrypt2_VAES_NI(__m512i* blk0,
                                  __m512i* blk1,
                                  const __m128i* pRkey,
                                  int cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   rKey0      = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr < cipherRounds; nr += 2, pRkey -= 2) {
      b0    = _mm512_aesdec_epi128(b0, rKey1);
      b1    = _mm512_aesdec_epi128(b1, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0    = _mm512_aesdec_epi128(b0, rKey0);
      b1    = _mm512_aesdec_epi128(b1, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }
   b0 = _mm512_aesdec_epi128(b0, rKey1);
   b1 = _mm512_aesdec_epi128(b1, rKey1);

   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesdeclast_epi128(b1, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void cpAESDecrypt3_VAES_NI(__m512i* blk0,
                                  __m512i* blk1,
                                  __m512i* blk2,
                                  const __m128i* pRkey,
                                  int cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   rKey0      = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr < cipherRounds; nr += 2, pRkey -= 2) {
      b0    = _mm512_aesdec_epi128(b0, rKey1);
      b1    = _mm512_aesdec_epi128(b1, rKey1);
      b2    = _mm512_aesdec_epi128(b2, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0    = _mm512_aesdec_epi128(b0, rKey0);
      b1    = _mm512_aesdec_epi128(b1, rKey0);
      b2    = _mm512_aesdec_epi128(b2, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }
   b0 = _mm512_aesdec_epi128(b0, rKey1);
   b1 = _mm512_aesdec_epi128(b1, rKey1);
   b2 = _mm512_aesdec_epi128(b2, rKey1);

   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesdeclast_epi128(b1, rKey0);
   *blk2 = _mm512_aesdeclast_epi128(b2, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void cpAESDecrypt4_VAES_NI(__m512i* blk0,
                                  __m512i* blk1,
                                  __m512i* blk2,
                                  __m512i* blk3,
                                  const __m128i* pRkey,
                                  int cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   __m512i b3 = _mm512_xor_si512(*blk3, rKey0);

   rKey0 = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr < cipherRounds; nr += 2, pRkey -= 2) {
      b0    = _mm512_aesdec_epi128(b0, rKey1);
      b1    = _mm512_aesdec_epi128(b1, rKey1);
      b2    = _mm512_aesdec_epi128(b2, rKey1);
      b3    = _mm512_aesdec_epi128(b3, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0    = _mm512_aesdec_epi128(b0, rKey0);
      b1    = _mm512_aesdec_epi128(b1, rKey0);
      b2    = _mm512_aesdec_epi128(b2, rKey0);
      b3    = _mm512_aesdec_epi128(b3, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }

   b0 = _mm512_aesdec_epi128(b0, rKey1);
   b1 = _mm512_aesdec_epi128(b1, rKey1);
   b2 = _mm512_aesdec_epi128(b2, rKey1);
   b3 = _mm512_aesdec_epi128(b3, rKey1);

   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesdeclast_epi128(b1, rKey0);
   *blk2 = _mm512_aesdeclast_epi128(b2, rKey0);
   *blk3 = _mm512_aesdeclast_epi128(b3, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

#endif /* _IPP32E>=_IPP32E_K0 */
