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
//     AES GCM AVX2
//     Internal Functions Implementations
// 
*/

#ifndef __AES_GCM_AVX2_H_
#define __AES_GCM_AVX2_H_

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcptool.h"

#if (_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9)

#define MAX_NK 15 //the largest possible number of keys

#define SHUFD_MASK 78 // 01001110b
#define STEP_SIZE 64 // 4*BLOCK_SIZE, due to block size is always 16 for AES
#define HALF_STEP_SIZE 32 // 2*BLOCK_SIZE, due to block size is always 16 for AES

//is used to increment two 128-bit words in a 256-bit register
#define IncrementRegister256(t_block, t_incr, t_shuffle_mask) \
   t_block = _mm256_shuffle_epi8(t_block, t_shuffle_mask); \
   t_block = _mm256_add_epi32(t_block, t_incr);            \
   t_block = _mm256_shuffle_epi8(t_block, t_shuffle_mask)

// these constants are used to increment two 128-bit words in a 256-bit register
__ALIGN32 static const Ipp32u _increment2[] = {0, 0, 0, 2, 0, 0, 0, 2};
__ALIGN32 static const Ipp32u _increment4[] = {0, 0, 0, 4, 0, 0, 0, 4};
__ALIGN32 static const Ipp8u swapBytes256[] = {
   16, 17, 18, 19, 20, 21, 22, 23,
   24, 25, 26, 27, 31, 30, 29, 28,
   0, 1, 2, 3, 4, 5, 6, 7,
   8, 9, 10, 11, 15, 14, 13, 12
};

// shuffle masks
__ALIGN32 static const Ipp8u _shuff_mask_128[] = {15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};
__ALIGN32 static const Ipp8u _shuff_mask_256[] = {15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0};

// masks for operations with intrinsics 
__ALIGN32 static const Ipp8u _mask_lo_256[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0};
__ALIGN32 static const Ipp8u _mask_hi_256[] = {0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

/*
// sse_clmul_gcm performs clmul with 128-bit registers; is used in the combine hash step
// input:
//    const __m128i *HK - containts hashed keys
// input/output:
//    __m128i *GH - contains GHASH. Will be overwritten in this function
*/
__INLINE void sse_clmul_gcm(__m128i *GH, const __m128i *HK) {
   __m128i tmpX0, tmpX1, tmpX2, tmpX3;
   tmpX2 = _mm_shuffle_epi32 (*GH, SHUFD_MASK); //tmpX2 = {GH0:GH1}
   tmpX0 = _mm_shuffle_epi32 (*HK, SHUFD_MASK); //tmpX0 = {HK0:HK1}
   tmpX2 = _mm_xor_si128(tmpX2, *GH); //tmpX2 = {GH0+GH1:GH1+GH0}
   tmpX0 = _mm_xor_si128(tmpX0, *HK); //tmpX0 = {HK0+HK1:HK1+HK0}
   tmpX2 = _mm_clmulepi64_si128 (tmpX2, tmpX0, 0x00); //tmpX2 = (a1+a0)*(b1+b0);  tmpX2 = (GH1+GH0)*(HK1+HK0)
   tmpX1 = *GH;
   *GH = _mm_clmulepi64_si128 (*GH, *HK, 0x00); //GH = a0*b0;  GH = GH0*HK0
   tmpX0 = _mm_xor_si128(tmpX0, tmpX0);
   tmpX1 = _mm_clmulepi64_si128 (tmpX1, *HK, 0x11); //tmpX1 = a1*b1;   tmpX1 = GH1*HK1
   tmpX2 = _mm_xor_si128(tmpX2, *GH); //tmpX2 = (GH1+GH0)*(HK1+HK0) + GH0*HK0
   tmpX2 = _mm_xor_si128(tmpX2, tmpX1); //tmpX2 = a0*b1+a1*b0;    tmpX2 = (GH1+GH0)*(HK1+HK0) + GH0*HK0 + GH1*HK1 = GH0*HK1+GH1*HK0
   tmpX0 = _mm_alignr_epi8 (tmpX0, tmpX2, 8); //tmpX0 = {Zeros : HI(a0*b1+a1*b0)}
   tmpX2 = _mm_slli_si128 (tmpX2, 8); //tmpX2 = {LO(HI(a0*b1+a1*b0)) : Zeros}
   tmpX1 = _mm_xor_si128(tmpX1, tmpX0); //<tmpX1:GH> holds the result of the carry-less multiplication of GH by HK
   *GH = _mm_xor_si128(*GH, tmpX2);

   //first phase of the reduction
   tmpX0 = *GH; //copy GH into tmpX0, tmpX2, tmpX3
   tmpX2 = *GH;
   tmpX3 = *GH;
   tmpX0 = _mm_slli_epi64 (tmpX0, 63); //packed left shifting << 63
   tmpX2 = _mm_slli_epi64 (tmpX2, 62); //packed left shifting shift << 62
   tmpX3 = _mm_slli_epi64 (tmpX3, 57); //packed left shifting shift << 57
   tmpX0 = _mm_xor_si128(tmpX0, tmpX2); //xor the shifted versions
   tmpX0 = _mm_xor_si128(tmpX0, tmpX3);
   tmpX2 = tmpX0;
   tmpX2 = _mm_slli_si128 (tmpX2, 8); //shift-L tmpX2 2 DWs
   tmpX0 = _mm_srli_si128 (tmpX0, 8); //shift-R xmm2 2 DWs
   *GH = _mm_xor_si128(*GH, tmpX2); //first phase of the reduction complete
   tmpX1 = _mm_xor_si128(tmpX1, tmpX0); //save the lost MS 1-2-7 bits from first phase

   //second phase of the reduction
   tmpX2 = *GH;
   tmpX2 = _mm_srli_epi64(tmpX2, 5); //packed right shifting >> 5
   tmpX2 = _mm_xor_si128(tmpX2, *GH); //xor shifted versions
   tmpX2 = _mm_srli_epi64(tmpX2, 1); //packed right shifting >> 1
   tmpX2 = _mm_xor_si128(tmpX2, *GH); //xor shifted versions
   tmpX2 = _mm_srli_epi64(tmpX2, 1); //packed right shifting >> 1
   *GH = _mm_xor_si128(*GH, tmpX2); //second phase of the reduction complete
   *GH = _mm_xor_si128(*GH, tmpX1); //the result is in GH
}

/*
// avx2_clmul_gcm performs clmul with 256-bit registers; is used in the hash calculation step
// input:
//    const __m128i *HK - containts hashed keys
//    const __m256i *HKeyKaratsuba - countains temporary data for Karatsuba method
//    const __m256i *mask_lo - contains mask for taking lower bits
//    const __m256i *mask_hi - contains mask for taking higher bits
// input/output:
//    __m128i *GH - contains GHASH. Will be overwritten in this function
*/
__INLINE void avx2_clmul_gcm(__m256i *GH, const __m256i *HK, const __m256i *HKeyKaratsuba, const __m256i *mask_lo, const __m256i *mask_hi) {
   __m256i tmpX0, tmpX1, tmpX2;
   
   tmpX2 = _mm256_shuffle_epi32 (*GH, SHUFD_MASK);
   // Karatsuba Method
   tmpX1 = *GH;
   tmpX2 = _mm256_xor_si256(tmpX2, *GH);
   *GH = _mm256_clmulepi64_epi128(*GH, *HK, 0x00);
   // Karatsuba Method

   tmpX1 = _mm256_clmulepi64_epi128(tmpX1, *HK, 0x11);
   tmpX2 = _mm256_clmulepi64_epi128(tmpX2, *HKeyKaratsuba, 0x00);
   tmpX2 = _mm256_xor_si256(tmpX2, *GH);
   tmpX2 = _mm256_xor_si256(tmpX2, tmpX1);
   tmpX0 = _mm256_shuffle_epi32 (tmpX2, SHUFD_MASK);
   tmpX2 = tmpX0;
   tmpX0 = _mm256_and_si256(tmpX0, *mask_hi);
   tmpX2 = _mm256_and_si256(tmpX2, *mask_lo);
   *GH = _mm256_xor_si256(*GH, tmpX0);
   tmpX1 = _mm256_xor_si256(tmpX1, tmpX2);

   // first phase of the reduction
   tmpX0 = *GH;
   *GH = _mm256_slli_epi64 (*GH, 1);
   *GH = _mm256_xor_si256(*GH, tmpX0);
   *GH = _mm256_slli_epi64 (*GH, 5);
   *GH = _mm256_xor_si256(*GH, tmpX0);
   *GH = _mm256_slli_epi64 (*GH, 57);
   tmpX2 = _mm256_shuffle_epi32(*GH, SHUFD_MASK);
   *GH = tmpX2;
   tmpX2 = _mm256_and_si256(tmpX2, *mask_lo);
   *GH = _mm256_and_si256(*GH, *mask_hi);
   *GH = _mm256_xor_si256(*GH, tmpX0);
   tmpX1 = _mm256_xor_si256(tmpX1, tmpX2);

   // second phase of the reduction
   tmpX2 = *GH;
   *GH = _mm256_srli_epi64(*GH, 5);
   *GH = _mm256_xor_si256(*GH, tmpX2);
   *GH = _mm256_srli_epi64(*GH, 1);
   *GH = _mm256_xor_si256(*GH, tmpX2);
   *GH = _mm256_srli_epi64(*GH, 1);
   *GH = _mm256_xor_si256(*GH, tmpX2);
   *GH = _mm256_xor_si256(*GH, tmpX1);
}

/*
// aes_encoder_avx2vaes_sb is used for single block encryption
// input:
//    const Ipp8u *in - contains data for encryprion
//    const int Nr - contains number of the rounds 
//    const __m256i* keys - contains keys
// output:
//    Ipp8u *out - stores encrypted data.
*/
__INLINE void aes_encoder_avx2vaes_sb(const Ipp8u *in, Ipp8u *out, const int Nr, const __m256i* keys) {
   __m128i lo = _mm_loadu_si128((void*)in);
   __m128i hi = _mm_setzero_si128();
   __m256i block = _mm256_setr_m128i(lo, hi);
   block = _mm256_xor_si256(block, *keys);
   for(int round = 1; round < Nr; round++) {
      keys++;
      block = _mm256_aesenc_epi128(block, *keys);
   }
   keys++;
   block = _mm256_aesenclast_epi128(block, *keys);
   _mm_storeu_si128((void*)out, _mm256_castsi256_si128(block));
}

#endif /* #if(_IPP==_IPP_H9) || (_IPP32E==_IPP32E_L9) */

#endif /* __AES_GCM_AVX2_H_ */
