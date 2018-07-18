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
//     SMS4 ECB encryption/decryption
// 
//  Contents:
//     cpSMS4_ECB_aesni_x4()
//     cpSMS4_ECB_aesni_x8()
//     cpSMS4_ECB_aesni_x12()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4.h"
#include "pcpsms4ecby8cn.h"

#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)

/*
// (1-3)*MBS_SMS4 processing
*/
static int cpSMS4_ECB_aesni_tail(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey)
{
   __m128i T, K0;
   __m128i K1 = _mm_setzero_si128();
   __m128i K2 = _mm_setzero_si128();
   __m128i K3 = _mm_setzero_si128();

   switch (len) {
   case (3*MBS_SMS4):
      K2 = _mm_shuffle_epi8(_mm_loadu_si128((__m128i*)(pInp+2*MBS_SMS4)), M128(swapBytes));
   case (2*MBS_SMS4):
      K1 = _mm_shuffle_epi8(_mm_loadu_si128((__m128i*)(pInp+1*MBS_SMS4)), M128(swapBytes));
   case (1*MBS_SMS4):
      K0 = _mm_shuffle_epi8(_mm_loadu_si128((__m128i*)(pInp+0*MBS_SMS4)), M128(swapBytes));
      break;
   default: return 0;
   }
   TRANSPOSE_INP(K0,K1,K2,K3, T);

   {
      int itr;
      for(itr=0; itr<8; itr++, pRKey+=4) {
      __m128i key4 = _mm_loadu_si128((__m128i*)pRKey);

         /* initial xors */
         T = _mm_shuffle_epi32(key4, 0x00); /* broadcast(key4[0]) */
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
         T = _mm_shuffle_epi32(key4, 0x55); /* broadcast(key4[1]) */
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
         T = _mm_shuffle_epi32(key4, 0xAA);  /* broadcast(key4[2]) */
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
         T = _mm_shuffle_epi32(key4, 0xFF);  /* broadcast(key4[3]) */
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
   }

   TRANSPOSE_OUT(K0,K1,K2,K3, T);
   K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
   K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
   K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
   K0 = _mm_shuffle_epi8(K0, M128(swapBytes));

   switch (len) {
   case (3*MBS_SMS4):
      _mm_storeu_si128((__m128i*)(pOut+2*MBS_SMS4), K1);
   case (2*MBS_SMS4):
      _mm_storeu_si128((__m128i*)(pOut+1*MBS_SMS4), K2);
   case (1*MBS_SMS4):
      _mm_storeu_si128((__m128i*)(pOut+0*MBS_SMS4), K3);
      break;
   }

   return len;
}

/*
// 4*MBS_SMS4 processing
*/
static
//#define cpSMS4_ECB_aesni_x4 OWNAPI(cpSMS4_ECB_aesni_x4)
int cpSMS4_ECB_aesni_x4(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey)
{
   int processedLen = len & -(4*MBS_SMS4);
   int n;
   for(n=0; n<processedLen; n+=(4*MBS_SMS4), pInp+=(4*MBS_SMS4), pOut+=(4*MBS_SMS4)) {
      int itr;
      __m128i T;
      __m128i K0 = _mm_loadu_si128((__m128i*)(pInp));
      __m128i K1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4));
      __m128i K2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*2));
      __m128i K3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*3));
      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
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
      _mm_storeu_si128((__m128i*)(pOut), K3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4), K2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*2), K1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*3), K0);
   }

   len -= processedLen;
   if(len)
      processedLen += cpSMS4_ECB_aesni_tail(pOut, pInp, len, pRKey);

   return processedLen;
}

/*
// 8*MBS_SMS4 processing
*/
static
//#define cpSMS4_ECB_aesni_x8 OWNAPI(cpSMS4_ECB_aesni_x8)
int cpSMS4_ECB_aesni_x8(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey)
{
   int processedLen = len & -(8*MBS_SMS4);
   int n;
   for(n=0; n<processedLen; n+=(8*MBS_SMS4), pInp+=(8*MBS_SMS4), pOut+=(8*MBS_SMS4)) {
      int itr;
      __m128i T, U;
      __m128i K0 = _mm_loadu_si128((__m128i*)(pInp));
      __m128i K1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4));
      __m128i K2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*2));
      __m128i K3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*3));

      __m128i P0 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*4));
      __m128i P1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*5));
      __m128i P2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*6));
      __m128i P3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*7));

      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
      TRANSPOSE_INP(K0,K1,K2,K3, T);

      P0 = _mm_shuffle_epi8(P0, M128(swapBytes));
      P1 = _mm_shuffle_epi8(P1, M128(swapBytes));
      P2 = _mm_shuffle_epi8(P2, M128(swapBytes));
      P3 = _mm_shuffle_epi8(P3, M128(swapBytes));
      TRANSPOSE_INP(P0,P1,P2,P3, T);

      for(itr=0; itr<8; itr++, pRKey+=4) {
         /* initial xors */
         U = T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[0]), 0);
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         U = _mm_xor_si128(U, P1);
         U = _mm_xor_si128(U, P2);
         U = _mm_xor_si128(U, P3);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K0 = _mm_xor_si128(_mm_xor_si128(K0, T), L(T));
         P0 = _mm_xor_si128(_mm_xor_si128(P0, U), L(U));

         /* initial xors */
         U = T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[1]), 0);
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         U = _mm_xor_si128(U, P2);
         U = _mm_xor_si128(U, P3);
         U = _mm_xor_si128(U, P0);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K1 = _mm_xor_si128(_mm_xor_si128(K1, T), L(T));
         P1 = _mm_xor_si128(_mm_xor_si128(P1, U), L(U));

         /* initial xors */
         U = T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[2]), 0);
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         U = _mm_xor_si128(U, P3);
         U = _mm_xor_si128(U, P0);
         U = _mm_xor_si128(U, P1);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K2 = _mm_xor_si128(_mm_xor_si128(K2, T), L(T));
         P2 = _mm_xor_si128(_mm_xor_si128(P2, U), L(U));

         /* initial xors */
         U = T = _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[3]), 0);
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         U = _mm_xor_si128(U, P0);
         U = _mm_xor_si128(U, P1);
         U = _mm_xor_si128(U, P2);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K3 = _mm_xor_si128(_mm_xor_si128(K3, T), L(T));
         P3 = _mm_xor_si128(_mm_xor_si128(P3, U), L(U));
      }

      pRKey -= 32;

      TRANSPOSE_OUT(K0,K1,K2,K3, T);
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut), K3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4), K2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*2), K1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*3), K0);

      TRANSPOSE_OUT(P0,P1,P2,P3, T);
      P3 = _mm_shuffle_epi8(P3, M128(swapBytes));
      P2 = _mm_shuffle_epi8(P2, M128(swapBytes));
      P1 = _mm_shuffle_epi8(P1, M128(swapBytes));
      P0 = _mm_shuffle_epi8(P0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*4), P3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*5), P2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*6), P1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*7), P0);
   }


   len -= processedLen;
   if(len)
      processedLen += cpSMS4_ECB_aesni_x4(pOut, pInp, len, pRKey);

   return processedLen;
}

/*
// 12*MBS_SMS4 processing
*/
#if (_IPP>=_IPP_H9) || (_IPP32E>=_IPP32E_L9)
#define cpSMS4_ECB_aesni_x12 OWNAPI(cpSMS4_ECB_aesni_x12)
int cpSMS4_ECB_aesni_x12(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey)
#else
#define cpSMS4_ECB_aesni OWNAPI(cpSMS4_ECB_aesni)
int cpSMS4_ECB_aesni(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey)
#endif
{
   int processedLen = len -(len % (12*MBS_SMS4));
   int n;
   for(n=0; n<processedLen; n+=(12*MBS_SMS4), pInp+=(12*MBS_SMS4), pOut+=(12*MBS_SMS4)) {
      int itr;
      __m128i T;

      __m128i K0 = _mm_loadu_si128((__m128i*)(pInp));
      __m128i K1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4));
      __m128i K2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*2));
      __m128i K3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*3));

      __m128i P0 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*4));
      __m128i P1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*5));
      __m128i P2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*6));
      __m128i P3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*7));

      __m128i Q0 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*8));
      __m128i Q1 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*9));
      __m128i Q2 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*10));
      __m128i Q3 = _mm_loadu_si128((__m128i*)(pInp+MBS_SMS4*11));

      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
      TRANSPOSE_INP(K0,K1,K2,K3, T);

      P0 = _mm_shuffle_epi8(P0, M128(swapBytes));
      P1 = _mm_shuffle_epi8(P1, M128(swapBytes));
      P2 = _mm_shuffle_epi8(P2, M128(swapBytes));
      P3 = _mm_shuffle_epi8(P3, M128(swapBytes));
      TRANSPOSE_INP(P0,P1,P2,P3, T);

      Q0 = _mm_shuffle_epi8(Q0, M128(swapBytes));
      Q1 = _mm_shuffle_epi8(Q1, M128(swapBytes));
      Q2 = _mm_shuffle_epi8(Q2, M128(swapBytes));
      Q3 = _mm_shuffle_epi8(Q3, M128(swapBytes));
      TRANSPOSE_INP(Q0,Q1,Q2,Q3, T);

      for(itr=0; itr<8; itr++, pRKey+=4) {
         /* initial xors */
         __m128i U =  _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[0]), 0);
         __m128i V = U;
         T = U;
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         U = _mm_xor_si128(U, P1);
         U = _mm_xor_si128(U, P2);
         U = _mm_xor_si128(U, P3);
         V = _mm_xor_si128(V, Q1);
         V = _mm_xor_si128(V, Q2);
         V = _mm_xor_si128(V, Q3);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         V = affine(V, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         V = _mm_aesenclast_si128(V, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         V = _mm_shuffle_epi8(V, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         V = affine(V, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K0 = _mm_xor_si128(_mm_xor_si128(K0, T), L(T));
         P0 = _mm_xor_si128(_mm_xor_si128(P0, U), L(U));
         Q0 = _mm_xor_si128(_mm_xor_si128(Q0, V), L(V));

         /* initial xors */
         U =  _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[1]), 0);
         V = U;
         T = U;
         T = _mm_xor_si128(T, K2);
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         U = _mm_xor_si128(U, P2);
         U = _mm_xor_si128(U, P3);
         U = _mm_xor_si128(U, P0);
         V = _mm_xor_si128(V, Q2);
         V = _mm_xor_si128(V, Q3);
         V = _mm_xor_si128(V, Q0);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         V = affine(V, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         V = _mm_aesenclast_si128(V, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         V = _mm_shuffle_epi8(V, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         V = affine(V, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K1 = _mm_xor_si128(_mm_xor_si128(K1, T), L(T));
         P1 = _mm_xor_si128(_mm_xor_si128(P1, U), L(U));
         Q1 = _mm_xor_si128(_mm_xor_si128(Q1, V), L(V));

         /* initial xors */
         U =  _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[2]), 0);
         V = U;
         T = U;
         T = _mm_xor_si128(T, K3);
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         U = _mm_xor_si128(U, P3);
         U = _mm_xor_si128(U, P0);
         U = _mm_xor_si128(U, P1);
         V = _mm_xor_si128(V, Q3);
         V = _mm_xor_si128(V, Q0);
         V = _mm_xor_si128(V, Q1);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         V = affine(V, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         V = _mm_aesenclast_si128(V, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         V = _mm_shuffle_epi8(V, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         V = affine(V, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K2 = _mm_xor_si128(_mm_xor_si128(K2, T), L(T));
         P2 = _mm_xor_si128(_mm_xor_si128(P2, U), L(U));
         Q2 = _mm_xor_si128(_mm_xor_si128(Q2, V), L(V));

         /* initial xors */
         U =  _mm_shuffle_epi32(_mm_cvtsi32_si128(pRKey[3]), 0);
         V = U;
         T = U;
         T = _mm_xor_si128(T, K0);
         T = _mm_xor_si128(T, K1);
         T = _mm_xor_si128(T, K2);
         U = _mm_xor_si128(U, P0);
         U = _mm_xor_si128(U, P1);
         U = _mm_xor_si128(U, P2);
         V = _mm_xor_si128(V, Q0);
         V = _mm_xor_si128(V, Q1);
         V = _mm_xor_si128(V, Q2);
         /* Sbox */
         T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
         U = affine(U, M128(inpMaskLO), M128(inpMaskHI));
         V = affine(V, M128(inpMaskLO), M128(inpMaskHI));
         T = _mm_aesenclast_si128(T, M128(encKey));
         U = _mm_aesenclast_si128(U, M128(encKey));
         V = _mm_aesenclast_si128(V, M128(encKey));
         T = _mm_shuffle_epi8(T, M128(maskSrows));
         U = _mm_shuffle_epi8(U, M128(maskSrows));
         V = _mm_shuffle_epi8(V, M128(maskSrows));
         T = affine(T, M128(outMaskLO), M128(outMaskHI));
         U = affine(U, M128(outMaskLO), M128(outMaskHI));
         V = affine(V, M128(outMaskLO), M128(outMaskHI));
         /* Sbox done, now L */
         K3 = _mm_xor_si128(_mm_xor_si128(K3, T), L(T));
         P3 = _mm_xor_si128(_mm_xor_si128(P3, U), L(U));
         Q3 = _mm_xor_si128(_mm_xor_si128(Q3, V), L(V));
      }

      pRKey -= 32;

      TRANSPOSE_OUT(K0,K1,K2,K3, T);
      K3 = _mm_shuffle_epi8(K3, M128(swapBytes));
      K2 = _mm_shuffle_epi8(K2, M128(swapBytes));
      K1 = _mm_shuffle_epi8(K1, M128(swapBytes));
      K0 = _mm_shuffle_epi8(K0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut), K3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4), K2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*2), K1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*3), K0);

      TRANSPOSE_OUT(P0,P1,P2,P3, T);
      P3 = _mm_shuffle_epi8(P3, M128(swapBytes));
      P2 = _mm_shuffle_epi8(P2, M128(swapBytes));
      P1 = _mm_shuffle_epi8(P1, M128(swapBytes));
      P0 = _mm_shuffle_epi8(P0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*4), P3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*5), P2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*6), P1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*7), P0);

      TRANSPOSE_OUT(Q0,Q1,Q2,Q3, T);
      Q3 = _mm_shuffle_epi8(Q3, M128(swapBytes));
      Q2 = _mm_shuffle_epi8(Q2, M128(swapBytes));
      Q1 = _mm_shuffle_epi8(Q1, M128(swapBytes));
      Q0 = _mm_shuffle_epi8(Q0, M128(swapBytes));
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*8), Q3);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*9), Q2);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*10), Q1);
      _mm_storeu_si128((__m128i*)(pOut+MBS_SMS4*11), Q0);
   }

   len -= processedLen;
   if(len)
      processedLen += cpSMS4_ECB_aesni_x8(pOut, pInp, len, pRKey);

   return processedLen;
}

#endif /* _IPP_P8, _IPP32E_Y8 */
