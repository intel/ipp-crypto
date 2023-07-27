/*******************************************************************************
* Copyright (C) 2023 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the 'License');
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an 'AS IS' BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions
* and limitations under the License.
* 
*******************************************************************************/

/*
//
//  Purpose:
//     Cryptography Primitive.
//     AES decryption (GCM mode)
//
*/

#include "pcpaes_avx2_vaes.h"

#if (_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9)

IPP_OWN_DEFN (void, AesGcmDec_vaes_avx2, (Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pState))
{
   const int nloop = len / STEP_SIZE;
   IppsRijndael128Spec* pAES = AESGCM_CIPHER(pState);
   Ipp8u* pCounter = AESGCM_COUNTER(pState);
   Ipp8u* pECounter = AESGCM_ECOUNTER(pState);
   __m256i pCounter256, pCounter256_1, pECounter256, pECounter256_1;
   __m256i block, block1, cipherText, cipherText_1, plainText, plainText_1;

   // setting temporary data for incremention
   const __m256i increment2    = _mm256_loadu_si256((void*)_increment2); // increment by 2
   const __m256i increment4   = _mm256_loadu_si256((void*)_increment4); // increment by 4
   const __m256i shuffle_mask = _mm256_loadu_si256((void*)swapBytes256);

   // loading keys from memory
   __m256i rkeys[MAX_NK];
   __m128i tmp_keys_128;
   for (int i = 0; i < RIJ_NR(pAES) + 1; i++) {
      tmp_keys_128 = _mm_loadu_si128((void*)(RIJ_EKEYS(pAES)+i*16));
      rkeys[i] = _mm256_setr_m128i(tmp_keys_128, tmp_keys_128);
   }

   // skip extra calculations if plaintext less than 4 blocks
   if (nloop) {
      // loading counters from memory
      __m128i lo, hi;
      lo = _mm_loadu_si128((void*)pCounter);
      IncrementCounter32(pCounter);
      hi = _mm_loadu_si128((void*)pCounter);
      pCounter256_1 = _mm256_setr_m128i(lo, hi);
      pCounter256 = pCounter256_1;
      IncrementRegister256(pCounter256_1, increment2, shuffle_mask);

      // setting some masks
      const __m128i shuff_mask_128 = _mm_loadu_si128((void*)_shuff_mask_128);
      const __m256i shuff_mask_256 = _mm256_loadu_si256((void*)_shuff_mask_256);
      const __m256i mask_lo_256 = _mm256_loadu_si256((void*)_mask_lo_256);
      const __m256i mask_hi_256 = _mm256_loadu_si256((void*)_mask_hi_256);
      
      lo = _mm_loadu_si128((void*)AESGCM_GHASH(pState));
      hi = _mm_setzero_si128();
      __m256i rpHash0 = _mm256_setr_m128i(_mm_shuffle_epi8(lo, shuff_mask_128), hi);
      __m256i rpHash1 = _mm256_setzero_si256();

      // setting pre-calculated data for hash combining
      Ipp8u *pkeys = AESGCM_HKEY(pState);
      __m128i HashKey0 = _mm_loadu_si128((void*)pkeys);
      pkeys += 16;
      __m128i HashKey2 = _mm_loadu_si128((void*)pkeys);
      pkeys += 16;
      __m128i HashKey4 = _mm_loadu_si128((void*)pkeys);

      // setting pre-calculated data in correct order for Karatsuba method
      __m256i HKey = _mm256_setr_m128i(HashKey4, HashKey4);
      __m256i HKeyKaratsuba = _mm256_shuffle_epi32(HKey, SHUFD_MASK);
      HKeyKaratsuba = _mm256_xor_si256(HKey, HKeyKaratsuba);
      do {
         // decrypt stage
         block = _mm256_xor_si256(pCounter256, *rkeys);
         block1 = _mm256_xor_si256(pCounter256_1, *rkeys);
         block = _mm256_aesenc_epi128(block, *(rkeys+1));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+1));
         block = _mm256_aesenc_epi128(block, *(rkeys+2));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+2));
         block = _mm256_aesenc_epi128(block, *(rkeys+3));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+3));
         IncrementRegister256(pCounter256, increment4, shuffle_mask);
         block = _mm256_aesenc_epi128(block, *(rkeys+4));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+4));
         block = _mm256_aesenc_epi128(block, *(rkeys+5));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+5));
         block = _mm256_aesenc_epi128(block, *(rkeys+6));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+6));
         block = _mm256_aesenc_epi128(block, *(rkeys+7));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+7));
         block = _mm256_aesenc_epi128(block, *(rkeys+8));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+8));
         block = _mm256_aesenc_epi128(block, *(rkeys+9));
         block1 = _mm256_aesenc_epi128(block1, *(rkeys+9));
         IncrementRegister256(pCounter256_1, increment4, shuffle_mask);
         if (RIJ_NR(pAES) >= 12) {
            block = _mm256_aesenc_epi128(block, *(rkeys+10));
            block1 = _mm256_aesenc_epi128(block1, *(rkeys+10));
            block = _mm256_aesenc_epi128(block, *(rkeys+11));
            block1 = _mm256_aesenc_epi128(block1, *(rkeys+11));
            if (RIJ_NR(pAES) >= 14) {
               block = _mm256_aesenc_epi128(block, *(rkeys+12));
               block1 = _mm256_aesenc_epi128(block1, *(rkeys+12));
               block = _mm256_aesenc_epi128(block, *(rkeys+13));
               block1 = _mm256_aesenc_epi128(block1, *(rkeys+13));
            }
         }
         pECounter256 = _mm256_aesenclast_epi128(block, *(rkeys+RIJ_NR(pAES)));
         pECounter256_1 = _mm256_aesenclast_epi128(block1, *(rkeys+RIJ_NR(pAES)));

         // set ciphertext 
         plainText = _mm256_loadu_si256((void*)pSrc);
         cipherText = _mm256_xor_si256(plainText, pECounter256);
         pSrc += HALF_STEP_SIZE;
         plainText_1 = _mm256_loadu_si256((void*)pSrc);
         cipherText_1 = _mm256_xor_si256(plainText_1, pECounter256_1);
         pSrc += HALF_STEP_SIZE;

         // hash calculation stage
         rpHash0 = _mm256_xor_si256(rpHash0, _mm256_shuffle_epi8(plainText, shuff_mask_256));
         _mm256_storeu_si256((void*)pDst, cipherText);
         pDst += HALF_STEP_SIZE;
         _mm256_storeu_si256((void*)pDst, cipherText_1);
         pDst += HALF_STEP_SIZE;
         rpHash1 = _mm256_xor_si256(rpHash1, _mm256_shuffle_epi8(plainText_1, shuff_mask_256));
         len -= STEP_SIZE;
         if (len >= STEP_SIZE) {
            avx2_clmul_gcm(&rpHash0, &HKey, &HKeyKaratsuba, &mask_lo_256, &mask_hi_256);
            avx2_clmul_gcm(&rpHash1, &HKey, &HKeyKaratsuba, &mask_lo_256, &mask_hi_256);
         }
      } while(len >= STEP_SIZE);

      // loading temporary data to memory
      _mm_storeu_si128((void*)pECounter, _mm256_extractf128_si256(pECounter256, 1));
      _mm_storeu_si128((void*)pCounter, _mm256_castsi256_si128(pCounter256));

      // combine hash
      __m128i GHash0 = _mm256_extractf128_si256(rpHash0, 0);
      __m128i GHash1 = _mm256_extractf128_si256(rpHash0, 1);
      __m128i GHash2 = _mm256_extractf128_si256(rpHash1, 0);
      __m128i GHash3 = _mm256_extractf128_si256(rpHash1, 1);
      
      sse_clmul_gcm(&GHash0, &HashKey4); //GHash0 = GHash0 * (HashKey^4)<<1 mod poly
      sse_clmul_gcm(&GHash1, &HashKey2); //GHash1 = GHash1 * (HashKey^2)<<1 mod poly
      sse_clmul_gcm(&GHash2, &HashKey0); //GHash2 = GHash2 * (HashKey^1)<<1 mod poly
      GHash3 = _mm_xor_si128(GHash3, GHash1);
      GHash3 = _mm_xor_si128(GHash3, GHash2);
      
      sse_clmul_gcm(&GHash3, &HashKey0); //GHash3 = GHash3 * (HashKey)<<1 mod poly
      GHash3 = _mm_xor_si128(GHash3, GHash0);
      GHash3 = _mm_shuffle_epi8(GHash3, shuff_mask_128);
      _mm_storeu_si128((void*)(AESGCM_GHASH(pState)), GHash3);
   }

   const Ipp8u* pHashedData = pSrc;
   int hashedDataLen = len;

   // decryption for the tail (1-3 blocks)
   while(len >= BLOCK_SIZE) {
      aes_encoder_avx2vaes_sb(pCounter, pECounter, RIJ_NR(pAES), rkeys);
      XorBlock16(pSrc, pECounter, pDst);
      pSrc += BLOCK_SIZE;
      pDst += BLOCK_SIZE;
      len -= BLOCK_SIZE;
      IncrementCounter32(pCounter);
   }
   aes_encoder_avx2vaes_sb(pCounter, pECounter, RIJ_NR(pAES), rkeys);

   // hash calculation for the tail (1-3 blocks)
   if (hashedDataLen >= BLOCK_SIZE)
      AesGcmAuth_avx(AESGCM_GHASH(pState), pHashedData, hashedDataLen, AESGCM_HKEY(pState), AesGcmConst_table);
}

#endif /* #if (_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9) */
