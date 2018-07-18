/*******************************************************************************
* Copyright 2014-2018 Intel Corporation
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
//     SMS4 CTR decryption
// 
//  Contents:
//     cpSMS4_CTR_aesni_x4()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4.h"

#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)

static __ALIGN16 Ipp8u inpMaskLO[] = {0x65,0x41,0xfd,0xd9,0x0a,0x2e,0x92,0xb6,0x0f,0x2b,0x97,0xb3,0x60,0x44,0xf8,0xdc};
static __ALIGN16 Ipp8u inpMaskHI[] = {0x00,0xc9,0x67,0xae,0x80,0x49,0xe7,0x2e,0x4a,0x83,0x2d,0xe4,0xca,0x03,0xad,0x64};
static __ALIGN16 Ipp8u outMaskLO[] = {0xd3,0x59,0x38,0xb2,0xcc,0x46,0x27,0xad,0x36,0xbc,0xdd,0x57,0x29,0xa3,0xc2,0x48};
static __ALIGN16 Ipp8u outMaskHI[] = {0x00,0x50,0x14,0x44,0x89,0xd9,0x9d,0xcd,0xde,0x8e,0xca,0x9a,0x57,0x07,0x43,0x13};

static __ALIGN16 Ipp8u encKey[]    = {0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63,0x63};
static __ALIGN16 Ipp8u maskSrows[] = {0x00,0x0d,0x0a,0x07,0x04,0x01,0x0e,0x0b,0x08,0x05,0x02,0x0f,0x0c,0x09,0x06,0x03};

static __ALIGN16 Ipp8u lowBits4[]  = {0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f,0x0f};

static __ALIGN16 Ipp8u one128[] = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static __ALIGN16 Ipp8u endiannes[] = {15,14,13,12, 11,10,9,8, 7,6,5,4, 3,2,1,0};
static __ALIGN16 Ipp8u swapBytes[] = {3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12};
static __ALIGN16 Ipp8u endiannes_swap[] = {12,13,14,15, 8,9,10,11, 4,5,6,7, 0,1,2,3};

#define M128(mem)    (*((__m128i*)((Ipp8u*)(mem))))


__INLINE __m128i affine(__m128i x, __m128i maskLO, __m128i maskHI)
{
   __m128i T1 = _mm_and_si128(_mm_srli_epi64(x, 4), M128(lowBits4));
   __m128i T0 = _mm_and_si128(x, M128(lowBits4));
   T0 = _mm_shuffle_epi8(maskLO, T0);
   T1 = _mm_shuffle_epi8(maskHI, T1);
   return _mm_xor_si128(T0, T1);
}

__INLINE __m128i L(__m128i x)
{
   __m128i T = _mm_slli_epi32(x, 2);
   T = _mm_xor_si128(T, _mm_srli_epi32 (x,30));

   T = _mm_xor_si128(T, _mm_slli_epi32 (x,10));
   T = _mm_xor_si128(T, _mm_srli_epi32 (x,22));

   T = _mm_xor_si128(T, _mm_slli_epi32 (x,18));
   T = _mm_xor_si128(T, _mm_srli_epi32 (x,14));

   T = _mm_xor_si128(T, _mm_slli_epi32 (x,24));
   T = _mm_xor_si128(T, _mm_srli_epi32 (x, 8));
   return T;
}


#define TRANSPOSE_INP(K0,K1,K2,K3, T) \
   T  = _mm_unpacklo_epi32(K0, K1); \
   K1 = _mm_unpackhi_epi32(K0, K1); \
   K0 = _mm_unpacklo_epi32(K2, K3); \
   K3 = _mm_unpackhi_epi32(K2, K3); \
   \
   K2 = _mm_unpacklo_epi64(K1, K3); \
   K3 = _mm_unpackhi_epi64(K1, K3); \
   K1 = _mm_unpackhi_epi64(T,  K0); \
   K0 = _mm_unpacklo_epi64(T,  K0)

#define TRANSPOSE_OUT(K0,K1,K2,K3, T) \
   T  = _mm_unpacklo_epi32(K1, K0); \
   K0 = _mm_unpackhi_epi32(K1, K0); \
   K1 = _mm_unpacklo_epi32(K3, K2); \
   K3 = _mm_unpackhi_epi32(K3, K2); \
   \
   K2 = _mm_unpackhi_epi64(K1,  T); \
   T  = _mm_unpacklo_epi64(K1,  T); \
   K1 = _mm_unpacklo_epi64(K3, K0); \
   K0 = _mm_unpackhi_epi64(K3, K0); \
   K3 = T

__INLINE __m128i inc128(__m128i x)
{
   __m128i t = _mm_add_epi64(x,  M128(one128));
   x = _mm_cmpeq_epi64(t,  _mm_setzero_si128());
   t = _mm_sub_epi64(t, _mm_slli_si128(x, sizeof(Ipp64u)));
   return t;
}

#if (_IPP>=_IPP_H9) || (_IPP32E>=_IPP32E_L9)
int cpSMS4_CTR_aesni_x4(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey, const Ipp8u* pCtrMask, Ipp8u* pCtr)
#else
int cpSMS4_CTR_aesni(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey, const Ipp8u* pCtrMask, Ipp8u* pCtr)
#endif
{
   int processedLen = len & -(4*MBS_SMS4);
   int n;

   __m128i ctrUnchanged;
   __m128i ctrMask = _mm_loadu_si128((__m128i*)pCtrMask);
   __m128i ctr = _mm_loadu_si128((__m128i*)pCtr);

   ctrMask = _mm_shuffle_epi8(ctrMask, M128(endiannes));
   ctr = _mm_shuffle_epi8(ctr, M128(endiannes));
   ctrUnchanged = _mm_andnot_si128(ctrMask, ctr);

   for(n=0; n<processedLen; n+=(4*MBS_SMS4), pInp+=(4*MBS_SMS4), pOut+=(4*MBS_SMS4)) {
      int itr;
      __m128i T;
      __m128i K0 = ctr;
      __m128i K1 = inc128(K0);
      __m128i K2 = inc128(K1);
      __m128i K3 = inc128(K2);
      ctr = inc128(K3);

      K0 = _mm_xor_si128(ctrUnchanged, _mm_and_si128(K0, ctrMask));
      K1 = _mm_xor_si128(ctrUnchanged, _mm_and_si128(K1, ctrMask));
      K2 = _mm_xor_si128(ctrUnchanged, _mm_and_si128(K2, ctrMask));
      K3 = _mm_xor_si128(ctrUnchanged, _mm_and_si128(K3, ctrMask));

      K0 = _mm_shuffle_epi8(K0, M128(endiannes_swap));
      K1 = _mm_shuffle_epi8(K1, M128(endiannes_swap));
      K2 = _mm_shuffle_epi8(K2, M128(endiannes_swap));
      K3 = _mm_shuffle_epi8(K3, M128(endiannes_swap));
      TRANSPOSE_INP(K0,K1,K2,K3, T);

      for(itr=0; itr<8; itr++, pRKey+=4) {
         /* initial xors */
         T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[0]), 0);
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K0 = _mm_xor_si128(_mm_xor_si128(K0, T), L(T));

         /* initial xors */
         T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[1]), 0);
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K1 = _mm_xor_si128(_mm_xor_si128(K1, T), L(T));

         /* initial xors */
         T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[2]), 0);
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K2 = _mm_xor_si128(_mm_xor_si128(K2, T), L(T));

         /* initial xors */
         T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[3]), 0);
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K3 = _mm_xor_si128(_mm_xor_si128(K3, T), L(T));
      }

      pRKey -= 32;

      TRANSPOSE_OUT(K0,K1,K2,K3, T);
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut),           _mm_xor_si128(K3, _mm_loadu_si128((__m128i*)(pInp))));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4),  _mm_xor_si128(K2, _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4))));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*2),_mm_xor_si128(K1, _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*2))));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*3),_mm_xor_si128(K0, _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*3))));
   }

   ctr = _mm_xor_si128(ctrUnchanged, _mm_and_si128(ctr, ctrMask));
   ctr = _mm_shuffle_epi8(ctr, M128(endiannes));
   _mm_storeu_si128((__m128i*)pCtr, ctr);

   return processedLen;
}

#endif /* _IPP_P8, _IPP32E_Y8 */
