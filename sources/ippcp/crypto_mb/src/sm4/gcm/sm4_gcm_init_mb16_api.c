/*******************************************************************************
 * Copyright (C) 2022 Intel Corporation
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

#include <internal/common/ifma_defs.h>
#include <internal/sm4/sm4_gcm_mb.h>

DLL_PUBLIC
mbx_status16 mbx_sm4_gcm_init_mb16(const sm4_key *const pa_key[SM4_LINES],
                                   const int8u *const pa_iv[SM4_LINES],
                                   const int iv_len[SM4_LINES],
                                   SM4_GCM_CTX_mb16 *p_context)
{
   int buf_no;
   mbx_status16 status          = 0;
   __mmask16 mb_mask            = 0xFFFF;
   __mmask16 mb_mask_rearranged = 0xFFFF;

   /* Test input pointers */
   if (NULL == pa_key || NULL == pa_iv || NULL == iv_len || NULL == p_context) {
      status = MBX_SET_STS16_ALL(MBX_STATUS_NULL_PARAM_ERR);
      return status;
   }

   /* Don't process buffers with input pointers equal to zero and set bad status for IV with zero length */
   for (buf_no = 0; buf_no < SM4_LINES; buf_no++) {
      if (pa_key[buf_no] == NULL) {
         status = MBX_SET_STS16(status, buf_no, MBX_STATUS_NULL_PARAM_ERR);
         mb_mask &= ~(0x1 << buf_no);
      }
      if (pa_iv[buf_no] == NULL) {
         status = MBX_SET_STS16(status, buf_no, MBX_STATUS_NULL_PARAM_ERR);
         mb_mask_rearranged &= ~(0x1 << rearrangeOrder[buf_no]);
      }
      if (iv_len[buf_no] <= 0) {
         status = MBX_SET_STS16(status, buf_no, MBX_STATUS_MISMATCH_PARAM_ERR);
         mb_mask_rearranged &= ~(0x1 << rearrangeOrder[buf_no]);
      }
   }

   if (MBX_IS_ANY_OK_STS16(status)) {

      /* Clear buffers */

      SM4_GCM_CLEAR_BUFFER((SM4_GCM_CONTEXT_BUFFER_SLOT_TYPE *)SM4_GCM_CONTEXT_J0(p_context));
      SM4_GCM_CLEAR_BUFFER((SM4_GCM_CONTEXT_BUFFER_SLOT_TYPE *)SM4_GCM_CONTEXT_GHASH(p_context));


      SM4_GCM_CLEAR_LEN(BUFFER_REG_NUM(SM4_GCM_CONTEXT_LEN(p_context), 0));
      SM4_GCM_CLEAR_LEN(BUFFER_REG_NUM(SM4_GCM_CONTEXT_LEN(p_context), 1));
      SM4_GCM_CLEAR_LEN(BUFFER_REG_NUM(SM4_GCM_CONTEXT_LEN(p_context), 2));
      SM4_GCM_CLEAR_LEN(BUFFER_REG_NUM(SM4_GCM_CONTEXT_LEN(p_context), 3));

      /*
      // Compute SM4 keys
      // initialize int32u mbx_sm4_key_schedule[SM4_ROUNDS][SM4_LINES] buffer in context
      // keys layout for each round:
      // key0 key4 key8 key12 key1 key5 key9 key13 key2 key6 key10 key14 key3 key7 key11 key15
      */

      sm4_set_round_keys_mb16((int32u **)SM4_GCM_CONTEXT_KEY(p_context), (const int8u **)pa_key, mb_mask);

      /*
      // Compute hashkeys
      // initialize __m128i hashkey[SM4_GCM_HASHKEY_PWR_NUM][SM4_LINES] buffer in context
      // hashkeys layout for each hashkey power:
      // hashkey0 hashkey4 hashkey8 hashkey12 hashkey1 hashkey5 hashkey9 hashkey13 hashkey2 hashkey6 hashkey10 hashkey14 hashkey3 hashkey7 hashkey11
      hashkey15
      */
      sm4_gcm_precompute_hashkey_mb16((const mbx_sm4_key_schedule *)SM4_GCM_CONTEXT_KEY(p_context), p_context);

      /* Process IV */
      __mmask16 overflow_mask = sm4_gcm_update_iv_mb16(pa_iv, iv_len, mb_mask_rearranged, p_context);

      /* Set bad status for buffers with overflowed lengths */
      for (buf_no = 0; buf_no < SM4_LINES; buf_no++) {
         if (overflow_mask >> buf_no & 1) {
            status = MBX_SET_STS16(status, buf_no, MBX_STATUS_MISMATCH_PARAM_ERR);
         }
      }
   }

   return status;
}
