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
//     cpSMS4_SetRoundKeys_aesni()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4.h"
#include "pcpsms4ecby8cn.h"

#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)

/*
// compute round keys
*/
#define cpSMS4_SetRoundKeys_aesni OWNAPI(cpSMS4_SetRoundKeys_aesni)
void cpSMS4_SetRoundKeys_aesni(Ipp32u* pRoundKey, const Ipp8u* pSecretKey)
{
   __m128i K0 = _mm_cvtsi32_si128(ENDIANNESS32(((Ipp32u*)pSecretKey)[0]) ^ SMS4_FK[0]);
   __m128i K1 = _mm_cvtsi32_si128(ENDIANNESS32(((Ipp32u*)pSecretKey)[1]) ^ SMS4_FK[1]);
   __m128i K2 = _mm_cvtsi32_si128(ENDIANNESS32(((Ipp32u*)pSecretKey)[2]) ^ SMS4_FK[2]);
   __m128i K3 = _mm_cvtsi32_si128(ENDIANNESS32(((Ipp32u*)pSecretKey)[3]) ^ SMS4_FK[3]);

   const Ipp32u* pCK = SMS4_CK;

   int itr;
   for(itr=0; itr<8; itr++) {
      __m128i
      /* initial xors */
      T = _mm_cvtsi32_si128(pCK[0]);
      T = _mm_xor_si128(T, K1);
      T = _mm_xor_si128(T, K2);
      T = _mm_xor_si128(T, K3);
      /* Sbox */
      T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
      T = _mm_aesenclast_si128(T, M128(encKey));
      T = _mm_shuffle_epi8(T, M128(maskSrows));
      T = affine(T, M128(outMaskLO), M128(outMaskHI));
      /* Sbox done, now Ltag */
      K0 = _mm_xor_si128(_mm_xor_si128(K0, T), Ltag(T));
      pRoundKey[0] = _mm_cvtsi128_si32(K0);

      /* initial xors */
      T = _mm_cvtsi32_si128(pCK[1]);
      T = _mm_xor_si128(T, K2);
      T = _mm_xor_si128(T, K3);
      T = _mm_xor_si128(T, K0);
      /* Sbox */
      T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
      T = _mm_aesenclast_si128(T, M128(encKey));
      T = _mm_shuffle_epi8(T, M128(maskSrows));
      T = affine(T, M128(outMaskLO), M128(outMaskHI));
      /* Sbox done, now Ltag */
      K1 = _mm_xor_si128(_mm_xor_si128(K1, T), Ltag(T));
      pRoundKey[1] = _mm_cvtsi128_si32(K1);

      /* initial xors */
      T = _mm_cvtsi32_si128(pCK[2]);
      T = _mm_xor_si128(T, K3);
      T = _mm_xor_si128(T, K0);
      T = _mm_xor_si128(T, K1);
      /* Sbox */
      T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
      T = _mm_aesenclast_si128(T, M128(encKey));
      T = _mm_shuffle_epi8(T, M128(maskSrows));
      T = affine(T, M128(outMaskLO), M128(outMaskHI));
      /* Sbox done, now Ltag */
      K2 = _mm_xor_si128(_mm_xor_si128(K2, T), Ltag(T));
      pRoundKey[2] = _mm_cvtsi128_si32(K2);

      /* initial xors */
      T = _mm_cvtsi32_si128(pCK[3]);
      T = _mm_xor_si128(T, K0);
      T = _mm_xor_si128(T, K1);
      T = _mm_xor_si128(T, K2);
      /* Sbox */
      T = affine(T, M128(inpMaskLO), M128(inpMaskHI));
      T = _mm_aesenclast_si128(T, M128(encKey));
      T = _mm_shuffle_epi8(T, M128(maskSrows));
      T = affine(T, M128(outMaskLO), M128(outMaskHI));
      /* Sbox done, now Ltag */
      K3 = _mm_xor_si128(_mm_xor_si128(K3, T), Ltag(T));
      pRoundKey[3] = _mm_cvtsi128_si32(K3);

      pCK += 4;
      pRoundKey += 4;
   }
}

#endif /* _IPP_P8, _IPP32E_Y8 */
