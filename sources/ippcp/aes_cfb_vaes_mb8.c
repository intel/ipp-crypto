/*******************************************************************************
* Copyright 2020 Intel Corporation
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

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "aes_cfb_vaes_mb.h"

#if(_IPP32E>=_IPP32E_K0)

// Disable optimization for MSVC
#if defined(_MSC_VER)
    #pragma optimize( "", off )
#endif

static inline void aes_encrypt_vaes_mb8(__m512i blk[2], __m512i pRkey[15][2], int cipherRounds)
{
    int nr;
    __m512i b0[2];

    b0[0] = _mm512_xor_si512(blk[0], pRkey[0][0]);
    b0[1] = _mm512_xor_si512(blk[1], pRkey[0][1]);

    for (nr = 1; nr < cipherRounds; nr += 1) {
        b0[0] = _mm512_aesenc_epi128(b0[0], pRkey[nr][0]);
        b0[1] = _mm512_aesenc_epi128(b0[1], pRkey[nr][1]);
    }

    blk[0] = _mm512_aesenclast_epi128(b0[0], pRkey[nr][0]);
    blk[1] = _mm512_aesenclast_epi128(b0[1], pRkey[nr][1]);
}

#if defined(_MSC_VER)
    #pragma optimize( "", on )
#endif


void aes_cfb16_enc_vaes_mb8(const Ipp8u* const source_pa[8], Ipp8u* const dst_pa[8],
    const int arr_len[8], const int cipherRounds,
    const Ipp32u* enc_keys[8], const Ipp8u* pIV[8])
{
    int i, j;
    __m512i iv512[2];
    __m512i blk[2];

    int maxLen = 0;
    __mmask8 mbMask[8] = { 0x03, 0x0C, 0x30, 0xC0, 0x03, 0x0C, 0x30, 0xC0 };

    for (i = 0; i < 8; i++) {
        // The case of the empty input buffer
        if (arr_len[i] == 0)
        {
            mbMask[i] = 0;
            continue;
        }

        if (arr_len[i] > maxLen)
            maxLen = arr_len[i];
    }

    // Load the necessary number of 128-bit IV
    iv512[0] = _mm512_setzero_si512();
    iv512[0] = _mm512_mask_expandloadu_epi64(iv512[0], mbMask[0], pIV[0]);
    iv512[0] = _mm512_mask_expandloadu_epi64(iv512[0], mbMask[1], pIV[1]);
    iv512[0] = _mm512_mask_expandloadu_epi64(iv512[0], mbMask[2], pIV[2]);
    iv512[0] = _mm512_mask_expandloadu_epi64(iv512[0], mbMask[3], pIV[3]);

    iv512[1] = _mm512_setzero_si512();
    iv512[1] = _mm512_mask_expandloadu_epi64(iv512[1], mbMask[4], pIV[4]);
    iv512[1] = _mm512_mask_expandloadu_epi64(iv512[1], mbMask[5], pIV[5]);
    iv512[1] = _mm512_mask_expandloadu_epi64(iv512[1], mbMask[6], pIV[6]);
    iv512[1] = _mm512_mask_expandloadu_epi64(iv512[1], mbMask[7], pIV[7]);


    // Temporary block to left IV unchanged to use it on the next round 
    blk[0] = iv512[0];
    blk[1] = iv512[1];

    // Prepare array with key schedule
    __m512i keySchedule[15][2];
    __m512i tmpKeyMb = _mm512_setzero_si512();

    for (i = 0; i <= cipherRounds; i++)
    {
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[0], (const void *)(enc_keys[0] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[1], (const void *)(enc_keys[1] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[2], (const void *)(enc_keys[2] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[3], (const void *)(enc_keys[3] + (Ipp32u)i * sizeof(Ipp32u)));

        keySchedule[i][0] = _mm512_loadu_si512(&tmpKeyMb);

        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[4], (const void *)(enc_keys[4] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[5], (const void *)(enc_keys[5] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[6], (const void *)(enc_keys[6] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[7], (const void *)(enc_keys[7] + (Ipp32u)i * sizeof(Ipp32u)));

        keySchedule[i][1] = _mm512_loadu_si512(&tmpKeyMb);

    }

    for (int blocks = 0; blocks < maxLen / CFB16_BLOCK_SIZE; blocks += 1)
    {
        // Load 8 * 128 bit of plain text from the different buffers into the four 512-bit registers
        __m512i ptxt[2];

        for (j = 0; j < 2; j++) {
            ptxt[j] = _mm512_setzero_si512();

            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[0 + 4 * j], (const void *)(source_pa[0 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[1 + 4 * j], (const void *)(source_pa[1 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[2 + 4 * j], (const void *)(source_pa[2 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[3 + 4 * j], (const void *)(source_pa[3 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
        }

        aes_encrypt_vaes_mb8(blk, keySchedule, cipherRounds);

        for (j = 0; j < 2; j++) {
            blk[j] = _mm512_xor_si512(blk[j], ptxt[j]);

            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[0 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[0 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[1 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[1 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[2 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[2 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[3 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[3 + 4 * j], blk[j]);
        }

        iv512[0] = blk[0];
        iv512[1] = blk[1];

        for (i = 0; i < 8; i++) {
            if (arr_len[i] - CFB16_BLOCK_SIZE * (blocks + 1) == 0)
                mbMask[i] = 0;
        }
    }
}

#endif
