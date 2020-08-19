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

static inline void aes_encrypt_vaes_mb16(__m512i blk[4], __m512i pRkey[15][4], int cipherRounds)
{
    int nr;
    __m512i b0[4];

    b0[0] = _mm512_xor_si512(blk[0], pRkey[0][0]);
    b0[1] = _mm512_xor_si512(blk[1], pRkey[0][1]);
    b0[2] = _mm512_xor_si512(blk[2], pRkey[0][2]);
    b0[3] = _mm512_xor_si512(blk[3], pRkey[0][3]);

    for (nr = 1; nr < cipherRounds; nr += 1) {
        b0[0] = _mm512_aesenc_epi128(b0[0], pRkey[nr][0]);
        b0[1] = _mm512_aesenc_epi128(b0[1], pRkey[nr][1]);
        b0[2] = _mm512_aesenc_epi128(b0[2], pRkey[nr][2]);
        b0[3] = _mm512_aesenc_epi128(b0[3], pRkey[nr][3]);
    }

    blk[0] = _mm512_aesenclast_epi128(b0[0], pRkey[nr][0]);
    blk[1] = _mm512_aesenclast_epi128(b0[1], pRkey[nr][1]);
    blk[2] = _mm512_aesenclast_epi128(b0[2], pRkey[nr][2]);
    blk[3] = _mm512_aesenclast_epi128(b0[3], pRkey[nr][3]);
}

#if defined(_MSC_VER)
    #pragma optimize( "", on )
#endif

void aes_cfb16_enc_vaes_mb16(const Ipp8u* const source_pa[16], Ipp8u* const dst_pa[16],
    const int arr_len[16], const int cipherRounds,
    const Ipp32u* enc_keys[16], const Ipp8u* pIV[16])
{
    int i, j;
    __m512i iv512[4];
    __m512i blk[4];

    __mmask8 mbMask128[4] = { 0x03, 0x0C, 0x30, 0xC0 };

    // Load the necessary number of 128-bit IV
    j = -1;
    for (i = 0; i < 16; i++) {
        if (i % 4 == 0) {
            j += 1;
            iv512[j] = _mm512_setzero_si512();
        }
        if (arr_len[i] != 0)
            iv512[j] = _mm512_mask_expandloadu_epi64(iv512[j], mbMask128[i % 4], pIV[i]);
    }

    // Temporary block to left IV unchanged to use it on the next round
    blk[0] = iv512[0];
    blk[1] = iv512[1];
    blk[2] = iv512[2];
    blk[3] = iv512[3];

    // Prepare array with key schedule
    __m512i keySchedule[15][4];
    __m512i tmpKeyMb = _mm512_setzero_si512();
    for (i = 0; i <= cipherRounds; i++)
    {
        for (j = 0; j < 16; j++) {
            if (arr_len[j] != 0)
                tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask128[j % 4], (const void *)(enc_keys[j] + (Ipp32u)i * sizeof(Ipp32u)));

            if ((j + 1) % 4 == 0)
                keySchedule[i][(j + 1) / 4 - 1] = _mm512_loadu_si512(&tmpKeyMb);
        }
    }

    __mmask8 mbMask[16] = { 0x03, 0x0C, 0x30, 0xC0, 0x03, 0x0C, 0x30, 0xC0, 0x03, 0x0C, 0x30, 0xC0, 0x03, 0x0C, 0x30, 0xC0 };
    int maxLen = 0;

    for (i = 0; i < 16; i++) {
        // The case of the empty input buffer
        if (arr_len[i] == 0)
        {
            mbMask[i] = 0;
            continue;
        }

        if (arr_len[i] > maxLen)
            maxLen = arr_len[i];
    }

    for (int blocks = 0; blocks < maxLen / CFB16_BLOCK_SIZE; blocks += 1)
    {
        // Load 16 * 128 bit of plain text from the different buffers into the four 512-bit register
        __m512i ptxt[4];

        for (j = 0; j < 4; j++) {
            ptxt[j] = _mm512_setzero_si512();

            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[0 + 4 * j], (const void *)(source_pa[0 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[1 + 4 * j], (const void *)(source_pa[1 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[2 + 4 * j], (const void *)(source_pa[2 + 4 * j] + CFB16_BLOCK_SIZE * blocks));
            ptxt[j] = _mm512_mask_expandloadu_epi64(ptxt[j], mbMask[3 + 4 * j], (const void *)(source_pa[3 + 4 * j] + CFB16_BLOCK_SIZE * blocks));

        }

        aes_encrypt_vaes_mb16(blk, keySchedule, cipherRounds);

        for (j = 0; j < 4; j++) {
            blk[j] = _mm512_xor_si512(blk[j], ptxt[j]);

            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[0 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[0 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[1 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[1 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[2 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[2 + 4 * j], blk[j]);
            _mm512_mask_compressstoreu_epi64((void *)(dst_pa[3 + 4 * j] + CFB16_BLOCK_SIZE * blocks), mbMask[3 + 4 * j], blk[j]);
        }

        iv512[0] = blk[0];
        iv512[1] = blk[1];
        iv512[2] = blk[2];
        iv512[3] = blk[3];

        for (i = 0; i < 16; i++) {
            if (arr_len[i] - CFB16_BLOCK_SIZE * (blocks + 1) == 0)
                mbMask[i] = 0;
        }
    }
}

#endif
