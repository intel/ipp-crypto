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
//     AES-XTS VAES512 Functions (IEEE P1619)
// 
//  Contents:
//        cpAESEncryptXTS_VAES()
//        cpAESDecryptXTS_VAES()
//
*/

#include "owncp.h"
#include "pcpaesmxts.h"
#include "pcptool.h"
#include "pcpaesmxtsstuff.h"

#include "pcpaes_encrypt_vaes512.h"
#include "pcpaes_decrypt_vaes512.h"

#if (_IPP32E>=_IPP32E_K0)

__INLINE __m512i produceInitial512Tweaks(Ipp8u* pTweak) {
   __ALIGN64 Ipp8u tempTweakBuffer[AES_BLK_SIZE * 4]; // 512 bit
   cpXTSwhitening(tempTweakBuffer, 4 /*512bit*/, pTweak);
   return _mm512_load_epi64(tempTweakBuffer);
}

__INLINE __m512i nextTweaks(__m512i tweak128x4, __m512i polyXor) {
   __m512i swapTweaks = _mm512_shuffle_epi32(tweak128x4, _MM_PERM_BADC);

    __m512i highBits = _mm512_srai_epi64(swapTweaks, 63);
   highBits = _mm512_and_epi64(polyXor, highBits);
   tweak128x4 = _mm512_slli_epi64(tweak128x4, 1);
   swapTweaks = _mm512_slli_epi64(swapTweaks, 1);
   tweak128x4 = _mm512_xor_epi64(tweak128x4, highBits);

   highBits = _mm512_srai_epi64(swapTweaks, 63);
   highBits = _mm512_and_epi64(polyXor, highBits);
   tweak128x4 = _mm512_slli_epi64(tweak128x4, 1);
   swapTweaks = _mm512_slli_epi64(swapTweaks, 1);
   tweak128x4 = _mm512_xor_epi64(tweak128x4, highBits);

   highBits = _mm512_srai_epi64(swapTweaks, 63);
   highBits = _mm512_and_epi64(polyXor, highBits);
   tweak128x4 = _mm512_slli_epi64(tweak128x4, 1);
   swapTweaks = _mm512_slli_epi64(swapTweaks, 1);
   tweak128x4 = _mm512_xor_epi64(tweak128x4, highBits);

   highBits = _mm512_srai_epi64(swapTweaks, 63);
   highBits = _mm512_and_epi64(polyXor, highBits);
   tweak128x4 = _mm512_slli_epi64(tweak128x4, 1);
   tweak128x4 = _mm512_xor_epi64(tweak128x4, highBits);

   return tweak128x4;
}

void cpAESEncryptXTS_VAES(Ipp8u* outBlk, const Ipp8u* inpBlk, int nBlks, const Ipp8u* pRKey, int nr, Ipp8u* pTweak) {
   int cipherRounds = nr - 1;

   __m128i* pRkey = (__m128i*)pRKey;
   __m512i* pInp512 = (__m512i*)inpBlk;
   __m512i* pOut512 = (__m512i*)outBlk;

   const __m512i polyXor = _mm512_set_epi64(1, 0x87, 1, 0x87, 1, 0x87, 1, 0x87);
   __m512i iniTweak = produceInitial512Tweaks(pTweak);
   Ipp8u useIniTweaks = 1;

   int blocks;
   for (blocks = nBlks; blocks >= (4 * 4); blocks -= (4 * 4)) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);
      __m512i blk3 = _mm512_loadu_si512(pInp512 + 3);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);
      __m512i tweakBlk2 = nextTweaks(tweakBlk1, polyXor);
      __m512i tweakBlk3 = nextTweaks(tweakBlk2, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);
      blk3 = _mm512_xor_epi64(tweakBlk3, blk3);

      cpAESEncrypt4_VAES_NI(&blk0, &blk1, &blk2, &blk3, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);
      blk3 = _mm512_xor_epi64(tweakBlk3, blk3);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      _mm512_storeu_si512(pOut512 + 3, blk3);

      pInp512 += 4;
      pOut512 += 4;
      iniTweak = tweakBlk3;
      useIniTweaks = 0;
   }

   if ((3 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);
      __m512i tweakBlk2 = nextTweaks(tweakBlk1, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);

      cpAESEncrypt3_VAES_NI(&blk0, &blk1, &blk2, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);

      pInp512 += 3;
      pOut512 += 3;
      blocks -= (3 * 4);
      iniTweak = tweakBlk2;
      useIniTweaks = 0;
   }
   else if ((2 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);

      cpAESEncrypt2_VAES_NI(&blk0, &blk1, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);

      pInp512 += 2;
      pOut512 += 2;
      blocks -= (2 * 4);
      iniTweak = tweakBlk1;
      useIniTweaks = 0;
   }
   else if ((1 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);

      cpAESEncrypt1_VAES_NI(&blk0, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);

      _mm512_storeu_si512(pOut512, blk0);

      pInp512 += 1;
      pOut512 += 1;
      blocks -= (1 * 4);
      iniTweak = tweakBlk0;
      useIniTweaks = 0;
   }

   if (blocks) {
      __mmask8 k = (1 << (blocks + blocks)) - 1;
      __m512i blk0 = _mm512_maskz_loadu_epi64(k, pInp512);

      iniTweak = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);

      blk0 = _mm512_xor_epi64(iniTweak, blk0);

      cpAESEncrypt1_VAES_NI(&blk0, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(iniTweak, blk0);

      _mm512_mask_storeu_epi64(pOut512, k, blk0);
   }
}

void cpAESDecryptXTS_VAES(Ipp8u* outBlk, const Ipp8u* inpBlk, int nBlks, const Ipp8u* pRKey, int nr, Ipp8u* pTweak) {
   int cipherRounds = nr - 1;

   __m128i* pRkey = (__m128i*)pRKey + cipherRounds + 1;
   __m512i* pInp512 = (__m512i*)inpBlk;
   __m512i* pOut512 = (__m512i*)outBlk;

   const __m512i polyXor = _mm512_set_epi64(1, 0x87, 1, 0x87, 1, 0x87, 1, 0x87);
   __m512i iniTweak = produceInitial512Tweaks(pTweak);
   Ipp8u useIniTweaks = 1;

   int blocks;
   for (blocks = nBlks; blocks >= (4 * 4); blocks -= (4 * 4)) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);
      __m512i blk3 = _mm512_loadu_si512(pInp512 + 3);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);
      __m512i tweakBlk2 = nextTweaks(tweakBlk1, polyXor);
      __m512i tweakBlk3 = nextTweaks(tweakBlk2, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);
      blk3 = _mm512_xor_epi64(tweakBlk3, blk3);

      cpAESDecrypt4_VAES_NI(&blk0, &blk1, &blk2, &blk3, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);
      blk3 = _mm512_xor_epi64(tweakBlk3, blk3);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);
      _mm512_storeu_si512(pOut512 + 3, blk3);

      pInp512 += 4;
      pOut512 += 4;
      iniTweak = tweakBlk3;
      useIniTweaks = 0;
   }

   if ((3 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);
      __m512i blk2 = _mm512_loadu_si512(pInp512 + 2);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);
      __m512i tweakBlk2 = nextTweaks(tweakBlk1, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);

      cpAESDecrypt3_VAES_NI(&blk0, &blk1, &blk2, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);
      blk2 = _mm512_xor_epi64(tweakBlk2, blk2);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);
      _mm512_storeu_si512(pOut512 + 2, blk2);

      pInp512 += 3;
      pOut512 += 3;
      blocks -= (3 * 4);
      iniTweak = tweakBlk2;
      useIniTweaks = 0;
   }
   else if ((2 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);
      __m512i blk1 = _mm512_loadu_si512(pInp512 + 1);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);
      __m512i tweakBlk1 = nextTweaks(tweakBlk0, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);

      cpAESDecrypt2_VAES_NI(&blk0, &blk1, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);
      blk1 = _mm512_xor_epi64(tweakBlk1, blk1);

      _mm512_storeu_si512(pOut512, blk0);
      _mm512_storeu_si512(pOut512 + 1, blk1);

      pInp512 += 2;
      pOut512 += 2;
      blocks -= (2 * 4);
      iniTweak = tweakBlk1;
      useIniTweaks = 0;
   }
   else if ((1 * 4) <= blocks) {
      __m512i blk0 = _mm512_loadu_si512(pInp512);

      __m512i tweakBlk0 = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);

      cpAESDecrypt1_VAES_NI(&blk0, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(tweakBlk0, blk0);

      _mm512_storeu_si512(pOut512, blk0);

      pInp512 += 1;
      pOut512 += 1;
      blocks -= (1 * 4);
      iniTweak = tweakBlk0;
      useIniTweaks = 0;
   }

   if (blocks) {
      __mmask8 k = (1 << (blocks + blocks)) - 1;
      __m512i blk0 = _mm512_maskz_loadu_epi64(k, pInp512);

      iniTweak = useIniTweaks ? iniTweak : nextTweaks(iniTweak, polyXor);

      blk0 = _mm512_xor_epi64(iniTweak, blk0);

      cpAESDecrypt1_VAES_NI(&blk0, pRkey, cipherRounds);

      blk0 = _mm512_xor_epi64(iniTweak, blk0);

      _mm512_mask_storeu_epi64(pOut512, k, blk0);
   }
}

#endif /* (_IPP32E>=_IPP32E_K0) */
