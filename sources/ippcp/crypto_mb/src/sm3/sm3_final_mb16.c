/*******************************************************************************
* Copyright 2020-2021 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

#include <crypto_mb/status.h>
#include <crypto_mb/sm3.h>

#include <internal/sm3/sm3_mb16.h>
#include <internal/common/ifma_defs.h>

DLL_PUBLIC
mbx_status16 mbx_sm3_final_mb16(int8u* hash_pa[16], 
                         SM3_CTX_mb16* p_state)
{
    int i;
    mbx_status16 status = 0;

    /* test input pointers */
    if(NULL==hash_pa || NULL==p_state) {
        status = MBX_SET_STS16_ALL(MBX_STATUS_NULL_PARAM_ERR);
        return status;
    }

    int input_len[SM3_NUM_BUFFERS];
    int buffer_len[SM3_NUM_BUFFERS];
    int64u sum_msg_len[SM3_NUM_BUFFERS];

    /* allocate local buffer */
    __ALIGN64 int8u loc_buffer[SM3_NUM_BUFFERS][SM3_MSG_BLOCK_SIZE*2];
    int8u* buffer_pa[SM3_NUM_BUFFERS] = { loc_buffer[0],  loc_buffer[1],  loc_buffer[2],  loc_buffer[3], 
                                          loc_buffer[4],  loc_buffer[5],  loc_buffer[6],  loc_buffer[7],
                                          loc_buffer[8],  loc_buffer[9],  loc_buffer[10], loc_buffer[11],
                                          loc_buffer[12], loc_buffer[13], loc_buffer[14], loc_buffer[15] };

    __m512i zero_buffer = _mm512_setzero_si512();

    /* 
    // create  __mmask8 and __mmask16 based on input hash_pa 
    // corresponding element in mask = 0 if hash_pa[i] = 0 
    */
    __mmask8 mb_mask8[2];
    mb_mask8[0] = _mm512_cmp_epi64_mask(_mm512_loadu_si512(hash_pa), zero_buffer, _MM_CMPINT_NE);
    mb_mask8[1] = _mm512_cmp_epi64_mask(_mm512_loadu_si512(hash_pa + 8), zero_buffer, _MM_CMPINT_NE);
    __mmask16 mb_mask16 = *(__mmask16*)mb_mask8;

    M512(sum_msg_len) = _mm512_maskz_loadu_epi64(mb_mask8[0], MSG_LEN(p_state));
    M512(sum_msg_len + 8) = _mm512_maskz_loadu_epi64(mb_mask8[1], MSG_LEN(p_state) + 8);
    
    /* put processed message length in bits */
    M512(sum_msg_len) = _mm512_rol_epi64(M512(sum_msg_len), 3);
    M512(sum_msg_len + 8) = _mm512_rol_epi64(M512(sum_msg_len+8), 3);
    M512(sum_msg_len) = _mm512_shuffle_epi8(M512(sum_msg_len), M512(swapBytes));
    M512(sum_msg_len +8) = _mm512_shuffle_epi8(M512(sum_msg_len +8), M512(swapBytes));

    M512(input_len) = _mm512_maskz_loadu_epi32(mb_mask16, HAHS_BUFFIDX(p_state));

    __mmask16 tmp_mask = _mm512_cmplt_epi32_mask(M512(input_len), _mm512_set1_epi32(SM3_MSG_BLOCK_SIZE - (int)SM3_MSG_LEN_REPR));
    M512(buffer_len) = _mm512_mask_set1_epi32(_mm512_set1_epi32(SM3_MSG_BLOCK_SIZE * 2), tmp_mask, SM3_MSG_BLOCK_SIZE);
    M512(buffer_len) = _mm512_mask_set1_epi32(M512(buffer_len), ~mb_mask16, 0);

    M512(buffer_len) = _mm512_mask_set1_epi32(M512(buffer_len), ~mb_mask16, 0);
   
    __mmask64 mb_mask64;
    for (i = 0; i < SM3_NUM_BUFFERS; i++) {
        /* Copy rest of message into internal buffer */
        mb_mask64 = ~(0xFFFFFFFFFFFFFFFF << input_len[i]);
        M512(loc_buffer[i]) = _mm512_maskz_loadu_epi8(mb_mask64, HASH_BUFF(p_state)[i]);

        /* Padd message */
        loc_buffer[i][input_len[i]++] = 0x80;
        pad_block(0, loc_buffer[i] + input_len[i], (int)(buffer_len[i] - input_len[i] - (int)SM3_MSG_LEN_REPR));
        ((int64u*)(loc_buffer[i] + buffer_len[i]))[-1] = sum_msg_len[i];
    }

    /* Copmplete hash computation */
    sm3_avx512_mb16((int32u**)HASH_VALUE(p_state), (const int8u**)buffer_pa, buffer_len);
    
    /* Convert hash into big endian */
    __m512i T[8];
    int32u* p_T[8] = { (int32u*)&T[0], (int32u*)&T[1], (int32u*)&T[2], (int32u*)&T[3], (int32u*)&T[4], (int32u*)&T[5], (int32u*)&T[6], (int32u*)&T[7] };

    T[0]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[0]));
    T[1]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[1]));
    T[2]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[2]));
    T[3]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[3]));
    T[4]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[4]));
    T[5]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[5]));
    T[6]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[6]));
    T[7]  = SIMD_ENDIANNESS32(_mm512_loadu_si512(HASH_VALUE(p_state)[7]));

    /* Transpose hash and store in array with pointers to hash values */
    TRANSPOSE_8X16_I32((int32u**)hash_pa, (const int32u**)p_T, mb_mask16);

    /* re-init hash value using mb masks */
    _mm512_storeu_si512(MSG_LEN(p_state), _mm512_mask_set1_epi64(_mm512_loadu_si512(MSG_LEN(p_state)), mb_mask8[0], 0));
    _mm512_storeu_si512(MSG_LEN(p_state)+8, _mm512_mask_set1_epi64(_mm512_loadu_si512(MSG_LEN(p_state)+8), mb_mask8[1], 0));
    _mm512_storeu_si512(HAHS_BUFFIDX(p_state), _mm512_mask_set1_epi32(_mm512_loadu_si512(HAHS_BUFFIDX(p_state)), mb_mask16, 0));

    sm3_mask_init_mb16(p_state, mb_mask16);
    
    return status;
}
