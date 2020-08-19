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

static inline void aes_encrypt_vaes_mb4(__m512i* blk, __m512i pRkey[14], int cipherRounds)
{
    int nr;
    __m512i b0 = _mm512_xor_si512(*blk, pRkey[0]);

    for (nr = 1; nr < cipherRounds; nr += 1)
        b0 = _mm512_aesenc_epi128(b0, pRkey[nr]);

    *blk = _mm512_aesenclast_epi128(b0, pRkey[nr]);
}

void aes_cfb16_enc_vaes_mb4(const Ipp8u* const source_pa[4], Ipp8u* const dst_pa[4],
    const int arr_len[4], const int cipherRounds,
    const Ipp32u* enc_keys[4], const Ipp8u* pIV[4])

{
    int i;
    int maxLen = 0;

    __mmask8 mbMask[4] = { 0x03, 0x0C, 0x30, 0xC0 };

    for (i = 0; i < 4; i++) {
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
    __m512i iv512 = _mm512_setzero_si512();
    iv512 = _mm512_mask_expandloadu_epi64(iv512, mbMask[0], pIV[0]); //  0   0   0  IV1
    iv512 = _mm512_mask_expandloadu_epi64(iv512, mbMask[1], pIV[1]); //  0   0  IV2  0
    iv512 = _mm512_mask_expandloadu_epi64(iv512, mbMask[2], pIV[2]); //  0  IV3  0   0
    iv512 = _mm512_mask_expandloadu_epi64(iv512, mbMask[3], pIV[3]); // IV4  0   0   0

    // Temporary block to left IV unchanged to use it on the next round 
    __m512i blk = iv512;

    // Prepare array with key schedule
    __m512i keySchedule[15];
    __m512i tmpKeyMb = _mm512_setzero_si512();
    for (i = 0; i <= cipherRounds; i++)
    {
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[0], (const void *)(enc_keys[0] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[1], (const void *)(enc_keys[1] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[2], (const void *)(enc_keys[2] + (Ipp32u)i * sizeof(Ipp32u)));
        tmpKeyMb = _mm512_mask_expandloadu_epi64(tmpKeyMb, mbMask[3], (const void *)(enc_keys[3] + (Ipp32u)i * sizeof(Ipp32u)));

        keySchedule[i] = _mm512_loadu_si512(&tmpKeyMb);
    }

    for (int blocks = 0; blocks < maxLen / CFB16_BLOCK_SIZE; blocks += 1) {
        // Load 4 * 128 bit of plain text from the different buffers into the one 512-bit register
        __m512i ptxt = _mm512_setzero_si512();

        ptxt = _mm512_mask_expandloadu_epi64(ptxt, mbMask[0], (const void *)(source_pa[0] + CFB16_BLOCK_SIZE * blocks));
        ptxt = _mm512_mask_expandloadu_epi64(ptxt, mbMask[1], (const void *)(source_pa[1] + CFB16_BLOCK_SIZE * blocks));
        ptxt = _mm512_mask_expandloadu_epi64(ptxt, mbMask[2], (const void *)(source_pa[2] + CFB16_BLOCK_SIZE * blocks));
        ptxt = _mm512_mask_expandloadu_epi64(ptxt, mbMask[3], (const void *)(source_pa[3] + CFB16_BLOCK_SIZE * blocks));

        aes_encrypt_vaes_mb4(&blk, keySchedule, cipherRounds);

        blk = _mm512_xor_si512(blk, ptxt);

        _mm512_mask_compressstoreu_epi64((void *)(dst_pa[0] + CFB16_BLOCK_SIZE * blocks), mbMask[0], blk);
        _mm512_mask_compressstoreu_epi64((void *)(dst_pa[1] + CFB16_BLOCK_SIZE * blocks), mbMask[1], blk);
        _mm512_mask_compressstoreu_epi64((void *)(dst_pa[2] + CFB16_BLOCK_SIZE * blocks), mbMask[2], blk);
        _mm512_mask_compressstoreu_epi64((void *)(dst_pa[3] + CFB16_BLOCK_SIZE * blocks), mbMask[3], blk);

        iv512 = blk;

        for (i = 0; i < 4; i++) {
            if (arr_len[i] - CFB16_BLOCK_SIZE * (blocks + 1) == 0)
                mbMask[i] = 0;
        }
    }
}

#endif
