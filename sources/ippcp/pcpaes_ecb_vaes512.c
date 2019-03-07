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
//     AES encryption/decryption (ECB mode)
// 
//  Contents:
//     vaesni_ecb_dec()
// 
// 
*/

#include "owncp.h"
#include "pcpaesm.h"

#if 0 // gres: temporary switched off

#if (_IPP32E>=_IPP32E_K0)

static void aesni_enc_mm128_1(__m128i* blk,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   __m128i b0 = _mm_xor_si128(*blk, pRkey[0]);

   pRkey += cipherRounds - (NR128_128 - 1) + 1;
   switch (cipherRounds) {
   case (14 - 1):
      b0 = _mm_aesenc_si128(b0, pRkey[-4]);
      b0 = _mm_aesenc_si128(b0, pRkey[-3]);
   case (12 - 1):
      b0 = _mm_aesenc_si128(b0, pRkey[-2]);
      b0 = _mm_aesenc_si128(b0, pRkey[-1]);
   default:
      b0 = _mm_aesenc_si128(b0, pRkey[0]);
      b0 = _mm_aesenc_si128(b0, pRkey[1]);
      b0 = _mm_aesenc_si128(b0, pRkey[2]);
      b0 = _mm_aesenc_si128(b0, pRkey[3]);
      b0 = _mm_aesenc_si128(b0, pRkey[4]);
      b0 = _mm_aesenc_si128(b0, pRkey[5]);
      b0 = _mm_aesenc_si128(b0, pRkey[6]);
      b0 = _mm_aesenc_si128(b0, pRkey[7]);
      b0 = _mm_aesenc_si128(b0, pRkey[8]);
      *blk = _mm_aesenclast_si128(b0, pRkey[9]);
      break;
   }
}

static void vaesni_enc_1(__m512i* blk0,  //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[2]);

   for (nr = 1, pRkey++; nr<cipherRounds; nr += 2, pRkey += 2) {
      b0 = _mm512_aesenc_epi128(b0, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[2]);
      b0 = _mm512_aesenc_epi128(b0, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[3]);
   }
   b0 = _mm512_aesenc_epi128(b0, rKey1);
   *blk0 = _mm512_aesenclast_epi128(b0, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void vaesni_enc_2(__m512i* blk0, __m512i* blk1,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[2]);

   for (nr = 1, pRkey++; nr<cipherRounds; nr += 2, pRkey += 2) {
      b0 = _mm512_aesenc_epi128(b0, rKey1);
      b1 = _mm512_aesenc_epi128(b1, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[2]);

      b0 = _mm512_aesenc_epi128(b0, rKey0);
      b1 = _mm512_aesenc_epi128(b1, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[3]);
   }
   b0 = _mm512_aesenc_epi128(b0, rKey1);
   b1 = _mm512_aesenc_epi128(b1, rKey1);

   *blk0 = _mm512_aesenclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesenclast_epi128(b1, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void vaesni_enc_3(__m512i* blk0, __m512i* blk1, __m512i* blk2,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[2]);

   for (nr = 1, pRkey++; nr<cipherRounds; nr += 2, pRkey += 2) {
      b0 = _mm512_aesenc_epi128(b0, rKey1);
      b1 = _mm512_aesenc_epi128(b1, rKey1);
      b2 = _mm512_aesenc_epi128(b2, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[2]);

      b0 = _mm512_aesenc_epi128(b0, rKey0);
      b1 = _mm512_aesenc_epi128(b1, rKey0);
      b2 = _mm512_aesenc_epi128(b2, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[3]);
   }
   b0 = _mm512_aesenc_epi128(b0, rKey1);
   b1 = _mm512_aesenc_epi128(b1, rKey1);
   b2 = _mm512_aesenc_epi128(b2, rKey1);

   *blk0 = _mm512_aesenclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesenclast_epi128(b1, rKey0);
   *blk2 = _mm512_aesenclast_epi128(b2, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void vaesni_enc_4(__m512i* blk0, __m512i* blk1, __m512i* blk2, __m512i* blk3,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   __m512i b3 = _mm512_xor_si512(*blk3, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[2]);

   for (nr = 1, pRkey++; nr<cipherRounds; nr += 2, pRkey += 2) {
      b0 = _mm512_aesenc_epi128(b0, rKey1);
      b1 = _mm512_aesenc_epi128(b1, rKey1);
      b2 = _mm512_aesenc_epi128(b2, rKey1);
      b3 = _mm512_aesenc_epi128(b3, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[2]);

      b0 = _mm512_aesenc_epi128(b0, rKey0);
      b1 = _mm512_aesenc_epi128(b1, rKey0);
      b2 = _mm512_aesenc_epi128(b2, rKey0);
      b3 = _mm512_aesenc_epi128(b3, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[3]);
   }
   b0 = _mm512_aesenc_epi128(b0, rKey1);
   b1 = _mm512_aesenc_epi128(b1, rKey1);
   b2 = _mm512_aesenc_epi128(b2, rKey1);
   b3 = _mm512_aesenc_epi128(b3, rKey1);

   *blk0 = _mm512_aesenclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesenclast_epi128(b1, rKey0);
   *blk2 = _mm512_aesenclast_epi128(b2, rKey0);
   *blk3 = _mm512_aesenclast_epi128(b3, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

void vaes_ecb_enc(const Ipp8u* inp,        //pointer to the PLAINTEXT
   Ipp8u* out,        //pointer to the CIPHERTEXT buffer
   int   len,         //text length in bytes
   const IppsAESSpec* pAES) //pointer to the context
{
   int cipherRounds = RIJ_NR(pAES) - 1;

   __m128i* pRkey = (__m128i*)RIJ_EKEYS(pAES);
   __m512i* pInp512 = (__m512i*)inp;
   __m512i* pOut512 = (__m512i*)out;

   int blocks;
   for (blocks = len / MBS_RIJ128; blocks >= (4 * 4); blocks -= (4 * 4)) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);
      __m512i blk3 = _mm512_loadu_si512(pInp512 + 3);

      vaesni_enc_4(&blk0, &blk1, &blk2, &blk3, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      _mm512_storeu_si512(pOut512 + 3, blk3);
      pInp512 += 4;
      pOut512 += 4;
   }

   if ((3 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);

      vaesni_enc_3(&blk0, &blk1, &blk2, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      pInp512 += 3;
      pOut512 += 3;
      blocks -= (3 * 4);
   }
   if ((4 * 2) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);

      vaesni_enc_2(&blk0, &blk1, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      pInp512 += 2;
      pOut512 += 2;
      blocks -= (2 * 4);
   }
   for (; blocks >= 4; blocks -= 4) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);

      vaesni_enc_1(&blk0, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      pInp512 += 1;
      pOut512 += 1;
   }
   if (blocks) {
      __mmask8 k = (1 << (blocks + blocks)) - 1;
      __m512i blk0 = _mm512_maskz_loadu_epi64(k, pInp512);
      vaesni_enc_1(&blk0, pRkey, cipherRounds);
      _mm512_mask_storeu_epi64(pOut512, k, blk0);
   }
}
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

static void aesni_dec_mm128_1(__m128i* blk,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   __m128i b0 = _mm_xor_si128(*blk, pRkey[0]);

   pRkey -= cipherRounds - (NR128_128 - 1) + 1;
   switch (cipherRounds) {
   case (14 - 1):
      b0 = _mm_aesdec_si128(b0, pRkey[4]);
      b0 = _mm_aesdec_si128(b0, pRkey[3]);
   case (12 - 1):
      b0 = _mm_aesdec_si128(b0, pRkey[2]);
      b0 = _mm_aesdec_si128(b0, pRkey[1]);
   default:
      b0 = _mm_aesdec_si128(b0, pRkey[0]);
      b0 = _mm_aesdec_si128(b0, pRkey[-1]);
      b0 = _mm_aesdec_si128(b0, pRkey[-2]);
      b0 = _mm_aesdec_si128(b0, pRkey[-3]);
      b0 = _mm_aesdec_si128(b0, pRkey[-4]);
      b0 = _mm_aesdec_si128(b0, pRkey[-5]);
      b0 = _mm_aesdec_si128(b0, pRkey[-6]);
      b0 = _mm_aesdec_si128(b0, pRkey[-7]);
      b0 = _mm_aesdec_si128(b0, pRkey[-8]);
      *blk = _mm_aesdeclast_si128(b0, pRkey[-9]);
      break;
   }
}

static void vaesni_dec_1(__m512i* blk0,  //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr<cipherRounds; nr += 2, pRkey -= 2) {
      b0 = _mm512_aesdec_epi128(b0, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);
      b0 = _mm512_aesdec_epi128(b0, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }
   b0 = _mm512_aesdec_epi128(b0, rKey1);
   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void vaesni_dec_2(__m512i* blk0, __m512i* blk1,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr<cipherRounds; nr += 2, pRkey -= 2) {
      b0 = _mm512_aesdec_epi128(b0, rKey1);
      b1 = _mm512_aesdec_epi128(b1, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0 = _mm512_aesdec_epi128(b0, rKey0);
      b1 = _mm512_aesdec_epi128(b1, rKey0);
      rKey0 = _mm512_broadcast_i64x2(pRkey[-3]);
   }
   b0 = _mm512_aesdec_epi128(b0, rKey1);
   b1 = _mm512_aesdec_epi128(b1, rKey1);

   *blk0 = _mm512_aesdeclast_epi128(b0, rKey0);
   *blk1 = _mm512_aesdeclast_epi128(b1, rKey0);

   rKey0 = _mm512_setzero_si512();
   rKey1 = _mm512_setzero_si512();
}

static void vaesni_dec_3(__m512i* blk0, __m512i* blk1, __m512i* blk2,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr<cipherRounds; nr += 2, pRkey -= 2) {
      b0 = _mm512_aesdec_epi128(b0, rKey1);
      b1 = _mm512_aesdec_epi128(b1, rKey1);
      b2 = _mm512_aesdec_epi128(b2, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0 = _mm512_aesdec_epi128(b0, rKey0);
      b1 = _mm512_aesdec_epi128(b1, rKey0);
      b2 = _mm512_aesdec_epi128(b2, rKey0);
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

static void vaesni_dec_4(__m512i* blk0, __m512i* blk1, __m512i* blk2, __m512i* blk3,   //pointer to the PLAINTEXT/CIPHERTEXT
   const __m128i* pRkey, //pointer to the context
   int   cipherRounds)
{
   int nr;

   __m512i rKey0 = _mm512_broadcast_i64x2(pRkey[0]);
   __m512i rKey1 = _mm512_broadcast_i64x2(pRkey[-1]);

   __m512i b0 = _mm512_xor_si512(*blk0, rKey0);
   __m512i b1 = _mm512_xor_si512(*blk1, rKey0);
   __m512i b2 = _mm512_xor_si512(*blk2, rKey0);
   __m512i b3 = _mm512_xor_si512(*blk3, rKey0);
   rKey0 = _mm512_broadcast_i64x2(pRkey[-2]);

   for (nr = 1, pRkey--; nr<cipherRounds; nr += 2, pRkey -= 2) {
      b0 = _mm512_aesdec_epi128(b0, rKey1);
      b1 = _mm512_aesdec_epi128(b1, rKey1);
      b2 = _mm512_aesdec_epi128(b2, rKey1);
      b3 = _mm512_aesdec_epi128(b3, rKey1);
      rKey1 = _mm512_broadcast_i64x2(pRkey[-2]);

      b0 = _mm512_aesdec_epi128(b0, rKey0);
      b1 = _mm512_aesdec_epi128(b1, rKey0);
      b2 = _mm512_aesdec_epi128(b2, rKey0);
      b3 = _mm512_aesdec_epi128(b3, rKey0);
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

void vaes_ecb_dec(const Ipp8u* inp,           //pointer to the PLAINTEXT
   Ipp8u* out,           //pointer to the CIPHERTEXT buffer
   int   len,            //text length in bytes
   const IppsAESSpec* pAES)   //pointer to the context
{
   int cipherRounds = RIJ_NR(pAES) - 1;

   __m128i* pRkey = (__m128i*)RIJ_DKEYS(pAES) + cipherRounds + 1;
   __m512i* pInp512 = (__m512i*)inp;
   __m512i* pOut512 = (__m512i*)out;

   int blocks;
   for (blocks = len / MBS_RIJ128; blocks >= (4 * 4); blocks -= (4 * 4)) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);
      __m512i blk3 = _mm512_loadu_si512(pInp512 + 3);

      vaesni_dec_4(&blk0, &blk1, &blk2, &blk3, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      _mm512_storeu_si512(pOut512 + 3, blk3);
      pInp512 += 4;
      pOut512 += 4;
   }

   if ((3 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);

      vaesni_dec_3(&blk0, &blk1, &blk2, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      pInp512 += 3;
      pOut512 += 3;
      blocks -= (3 * 4);
   }
   if ((4 * 2) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);

      vaesni_dec_2(&blk0, &blk1, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      pInp512 += 2;
      pOut512 += 2;
      blocks -= (2 * 4);
   }
   for (; blocks >= 4; blocks -= 4) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);

      vaesni_dec_1(&blk0, pRkey, cipherRounds);

      _mm512_storeu_si512(pOut512, blk0);
      pInp512 += 1;
      pOut512 += 1;
   }
   if (blocks) {
      __mmask8 k = (1 << (blocks + blocks)) - 1;
      __m512i blk0 = _mm512_maskz_loadu_epi64(k, pInp512);
      vaesni_dec_1(&blk0, pRkey, cipherRounds);
      _mm512_mask_storeu_epi64(pOut512, k, blk0);
   }
}

#endif /* _IPP32E>=_IPP32E_K0 */

#endif // gres
