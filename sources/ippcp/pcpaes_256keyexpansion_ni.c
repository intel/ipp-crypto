/*******************************************************************************
* Copyright 2016-2019 Intel Corporation
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
//     Cryptography Primitive. AES keys expansion
// 
//  Contents:
//        aes256_KeyExpansion_NI()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcpaes_keys_ni.h"


#if (_AES_NI_ENABLING_==_FEATURE_ON_) || (_AES_NI_ENABLING_==_FEATURE_TICKTOCK_)

//////////////////////////////////////////////////////////////////////
/*
// AES-256 key expansion
*/
static void aes256_assist_1(__m128i* temp1, __m128i * temp2)
{
   __m128i temp4;
   *temp2 = _mm_shuffle_epi32(*temp2, 0xff);
   temp4 = _mm_slli_si128 (*temp1, 0x4);
   *temp1 = _mm_xor_si128 (*temp1, temp4);
   temp4 = _mm_slli_si128 (temp4, 0x4);
   *temp1 = _mm_xor_si128 (*temp1, temp4);
   temp4 = _mm_slli_si128 (temp4, 0x4);
   *temp1 = _mm_xor_si128 (*temp1, temp4);
   *temp1 = _mm_xor_si128 (*temp1, *temp2);
}

static void aes256_assist_2(__m128i* temp1, __m128i * temp3)
{
   __m128i temp2,temp4;
   temp4 = _mm_aeskeygenassist_si128 (*temp1, 0x0);
   temp2 = _mm_shuffle_epi32(temp4, 0xaa);
   temp4 = _mm_slli_si128 (*temp3, 0x4);
   *temp3 = _mm_xor_si128 (*temp3, temp4);
   temp4 = _mm_slli_si128 (temp4, 0x4);
   *temp3 = _mm_xor_si128 (*temp3, temp4);
   temp4 = _mm_slli_si128 (temp4, 0x4);
   *temp3 = _mm_xor_si128 (*temp3, temp4);
   *temp3 = _mm_xor_si128 (*temp3, temp2);
}

void aes256_KeyExpansion_NI(Ipp8u* keyExp, const Ipp8u* userkey)
{
   __m128i temp1, temp2, temp3;
   __m128i *pKeySchedule = (__m128i*)keyExp;

   temp1 = _mm_loadu_si128((__m128i*)userkey);
   temp3 = _mm_loadu_si128((__m128i*)(userkey+16));
   pKeySchedule[0] = temp1;
   pKeySchedule[1] = temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x01);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[2]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[3]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x02);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[4]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[5]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x04);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[6]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[7]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x08);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[8]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[9]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x10);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[10]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[11]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x20);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[12]=temp1;
   aes256_assist_2(&temp1, &temp3);
   pKeySchedule[13]=temp3;

   temp2 = _mm_aeskeygenassist_si128 (temp3,0x40);
   aes256_assist_1(&temp1, &temp2);
   pKeySchedule[14]=temp1;
}

#endif /* #if (_AES_NI_ENABLING_==_FEATURE_ON_) || (_AES_NI_ENABLING_==_FEATURE_TICKTOCK_) */

