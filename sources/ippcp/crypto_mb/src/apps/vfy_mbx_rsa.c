/*******************************************************************************
* Copyright 2019-2020 Intel Corporation
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

/* 
// 
//  Purpose: verification of MB RSA-1024, RSA-2048, RSA-3072, RSA-4096.
// 
*/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <openssl/rsa.h>
#include <openssl/bn.h>
#include <openssl/rand.h>
#include <openssl/err.h>

#include <crypto_mb/version.h>
#include <crypto_mb/rsa.h>

////////////////////
#define MAX_BITLEN (4096)

RSA* rsa[8];

// data in residual domain
#define NUM_OF_DIGS(bitsize, digsize)   (((bitsize) + (digsize)-1)/(digsize))

#define MAX_LEN8 (NUM_OF_DIGS(MAX_BITLEN, 8))
int8u pt[8][MAX_LEN8];
int8u ct[8][MAX_LEN8];

// pointers to data above
int8u* ptxt[8] = { pt[0], pt[1], pt[2], pt[3], pt[4], pt[5], pt[6], pt[7] };
int8u* ctxt[8] = { ct[0], ct[1], ct[2], ct[3], ct[4], ct[5], ct[6], ct[7] };

// ifma mb8 data
//const BIGNUM* e_mb8[8];
//const BIGNUM* n_mb8[8];
//const BIGNUM* d_mb8[8];
//const BIGNUM* p_mb8[8];
//const BIGNUM* q_mb8[8];
//const BIGNUM* dp_mb8[8];
//const BIGNUM* dq_mb8[8];
//const BIGNUM* invq_mb8[8];

#ifndef BN_OPENSSL_PATCH
#define MAX_LEN64 (NUM_OF_DIGS(MAX_BITLEN, 64))
// ifma rsa mb8 keys buffers
int64u bnu_n[8][MAX_LEN64];
int64u bnu_d[8][MAX_LEN64];
int64u bnu_p[8][MAX_LEN64/2];
int64u bnu_q[8][MAX_LEN64/2];
int64u bnu_dp[8][MAX_LEN64/2];
int64u bnu_dq[8][MAX_LEN64/2];
int64u bnu_iq[8][MAX_LEN64/2];

// ifma rsa mb8 keys ptrs
int64u* bnu_n_mb8[8]     = {bnu_n[0], bnu_n[1], bnu_n[2], bnu_n[3], bnu_n[4], bnu_n[5], bnu_n[6], bnu_n[7]};
int64u* bnu_d_mb8[8]     = {bnu_d[0], bnu_d[1], bnu_d[2], bnu_d[3], bnu_d[4], bnu_d[5], bnu_d[6], bnu_d[7]};
int64u* bnu_p_mb8[8]     = {bnu_p[0], bnu_p[1], bnu_p[2], bnu_p[3], bnu_p[4], bnu_p[5], bnu_p[6], bnu_p[7]};
int64u* bnu_q_mb8[8]     = {bnu_q[0], bnu_q[1], bnu_q[2], bnu_q[3], bnu_q[4], bnu_q[5], bnu_q[6], bnu_q[7]};
int64u* bnu_dp_mb8[8]    = {bnu_dp[0],bnu_dp[1],bnu_dp[2],bnu_dp[3],bnu_dp[4],bnu_dp[5],bnu_dp[6],bnu_dp[7]};
int64u* bnu_dq_mb8[8]    = {bnu_dq[0],bnu_dq[1],bnu_dq[2],bnu_dq[3],bnu_dq[4],bnu_dq[5],bnu_dq[6],bnu_dq[7]};
int64u* bnu_invq_mb8[8]  = {bnu_iq[0],bnu_iq[1],bnu_iq[2],bnu_iq[3],bnu_iq[4],bnu_iq[5],bnu_iq[6],bnu_iq[7]};
#else
int64u* bnu_n_mb8[8];
int64u* bnu_d_mb8[8];
int64u* bnu_p_mb8[8];
int64u* bnu_q_mb8[8];
int64u* bnu_dp_mb8[8];
int64u* bnu_dq_mb8[8];
int64u* bnu_invq_mb8[8];
#endif

int8u* ifma_ptxt_mb8[8];
int8u ifma_encbuf_mb8[8][MAX_LEN8];
int8u ifma_decbuf_mb8[8][MAX_LEN8];
int8u* ifma_enc_mb8[8] = { ifma_encbuf_mb8[0], ifma_encbuf_mb8[1], ifma_encbuf_mb8[2], ifma_encbuf_mb8[3],
                           ifma_encbuf_mb8[4], ifma_encbuf_mb8[5], ifma_encbuf_mb8[6], ifma_encbuf_mb8[7] };
int8u* ifma_dec_mb8[8] = { ifma_decbuf_mb8[0], ifma_decbuf_mb8[1], ifma_decbuf_mb8[2], ifma_decbuf_mb8[3],
                           ifma_decbuf_mb8[4], ifma_decbuf_mb8[5], ifma_decbuf_mb8[6], ifma_decbuf_mb8[7] };

int8u wbuffer[MAX_LEN8];

int err_buf_no;
////////////////////////////////////////////////////////////////////

static void hstr_dump(const char* note, const int8u* pStr, int len)
{
   if (note)
      printf("%s", note);
   {
      int n;
      for (n = 0; n < len; n++) {
         int8u x = pStr[n];
         printf("\\x%02x", x);
         if ((0 == ((n + 1) % 32)) && ((n + 1) < len))
            printf("\n");
      }
      if (0 == (len % 32))
         printf("\n");
   }
}

static int mb8_diff(int8u* pKAT[], int8u* pTST[], int len)
{
   int diff = 0;
   int slot;

   err_buf_no = -1;

   for(slot=0; slot<8 && !diff; slot++) {
      const int8u* kat = pKAT[slot];
      const int8u* tst = pTST[slot];
      diff = memcmp(kat, tst, len);

      if (diff) {
         printf("diff at [%d][]\n", slot);
         hstr_dump("expected\n", kat, len);
         hstr_dump("computed\n", tst, len);
         err_buf_no = slot;
      }
   }
   return diff;
}
////////////////////////////////////////////////////////////

#ifndef BN_OPENSSL_PATCH
static int8u* wsp_str(int8u* tofrom, int len)
{
   int i;
   for(i=0; i<len/2; i++) {
      int8u x = tofrom[i];
      tofrom[i] = tofrom[len-1-i];
      tofrom[len-1-i] = x;
   }
   return tofrom;
}
#endif
////////////////////////////////////////////////////////////

#define RSA_ENC   (1)
#define RSA_DEC2  (2)
#define RSA_DEC5  (4)

#if BN_OPENSSL_PATCH
extern BN_ULONG* bn_get_words(const BIGNUM* bn);
#endif

static int test_mbx_rsa_cp(int rsaBitsize, int flag)
{
   #define NUM_OF_TESTS (100) //(1000)
   int ret = 1;
   int slot, ntest;
   int len8 = NUM_OF_DIGS(rsaBitsize, 8);

   BIGNUM* bn_e;
   int64u   e = 65537;
   bn_e = BN_new();
   BN_set_word(bn_e, e);

   //int64u* bnu_n_mb8[8];
   //int64u* bnu_d_mb8[8];
   //int64u* bnu_p_mb8[8];
   //int64u* bnu_q_mb8[8];
   //int64u* bnu_dp_mb8[8];
   //int64u* bnu_dq_mb8[8];
   //int64u* bnu_invq_mb8[8];

   for(ntest=0; ntest<NUM_OF_TESTS && ret; ntest++) {
      /* rsa key stuff */
      const BIGNUM* bn_n;
      const BIGNUM* bn_d;
      const BIGNUM* bn_p;
      const BIGNUM* bn_q;
      const BIGNUM* bn_dp;
      const BIGNUM* bn_dq;
      const BIGNUM* bn_qinvp;

      memset(pt, 0, sizeof(pt));
      memset(ct, 0, sizeof(ct));

      memset(ifma_encbuf_mb8, 0, sizeof(ifma_encbuf_mb8));
      memset(ifma_decbuf_mb8, 0, sizeof(ifma_decbuf_mb8));

      #ifndef BN_OPENSSL_PATCH
      memset(bnu_n, 0, sizeof(bnu_n));
      memset(bnu_d, 0, sizeof(bnu_d));
      memset(bnu_p, 0, sizeof(bnu_p));
      memset(bnu_q, 0, sizeof(bnu_q));
      memset(bnu_dp,0, sizeof(bnu_dp));
      memset(bnu_dq,0, sizeof(bnu_dq));
      memset(bnu_iq,0, sizeof(bnu_iq));
      #endif

      for(slot=0; slot<8 && ret; slot++) {
         /* generate rsa[] */
         rsa[slot] = RSA_new();
         ret = RSA_generate_key_ex(rsa[slot], rsaBitsize, bn_e, NULL);

         if (ret) {
            //int num;

            RSA_get0_key(rsa[slot], &bn_n, NULL, NULL);
            /* extract private expd D */
            RSA_get0_key(rsa[slot], NULL, NULL, &bn_d);

            RSA_get0_factors(rsa[slot], &bn_p, NULL);
            RSA_get0_factors(rsa[slot], NULL, &bn_q);
            RSA_get0_crt_params(rsa[slot], &bn_dp, NULL, NULL);
            RSA_get0_crt_params(rsa[slot], NULL, &bn_dq, NULL);
            RSA_get0_crt_params(rsa[slot], NULL, NULL, &bn_qinvp);

            /* generate random p-txt of len8 length exactly*/
            BIGNUM* bn_pt = BN_new();
            do {
               BN_pseudo_rand_range(bn_pt, bn_n);
            } while(len8 != BN_num_bytes(bn_pt));

            /* convert it in bytes */
            BN_bn2bin(bn_pt, ptxt[slot]);
            BN_free(bn_pt);

            /* openssl rsa */
            ret = (len8 == RSA_public_encrypt(len8, ptxt[slot], ctxt[slot], rsa[slot], RSA_NO_PADDING));
            if(!ret)
               printf("ssl plain encryption\n");

            #if BN_OPENSSL_PATCH
            bnu_n_mb8[slot] = (int64u*)(bn_get_words(bn_n));
            bnu_d_mb8[slot] = (int64u*)(bn_get_words(bn_d));
            bnu_p_mb8[slot] = (int64u*)(bn_get_words(bn_p));
            bnu_q_mb8[slot] = (int64u*)(bn_get_words(bn_q));
            bnu_dp_mb8[slot] = (int64u*)(bn_get_words(bn_dp));
            bnu_dq_mb8[slot] = (int64u*)(bn_get_words(bn_dq));
            bnu_invq_mb8[slot] = (int64u*)(bn_get_words(bn_qinvp));
            #else
            BN_bn2bin(bn_n, (int8u*)(bnu_n_mb8[slot]));
            BN_bn2bin(bn_d, (int8u*)(bnu_d_mb8[slot]));
            BN_bn2bin(bn_p, (int8u*)(bnu_p_mb8[slot]));
            BN_bn2bin(bn_q, (int8u*)(bnu_q_mb8[slot]));
            BN_bn2bin(bn_dp, (int8u*)(bnu_dp_mb8[slot]));
            BN_bn2bin(bn_dq, (int8u*)(bnu_dq_mb8[slot]));
            BN_bn2bin(bn_qinvp, (int8u*)(bnu_invq_mb8[slot]));
            /* and swap */
            wsp_str((int8u*)(bnu_n_mb8[slot]), BN_num_bytes(bn_n));
            wsp_str((int8u*)(bnu_d_mb8[slot]), BN_num_bytes(bn_d));
            wsp_str((int8u*)(bnu_p_mb8[slot]), BN_num_bytes(bn_p));
            wsp_str((int8u*)(bnu_q_mb8[slot]), BN_num_bytes(bn_q));
            wsp_str((int8u*)(bnu_dp_mb8[slot]), BN_num_bytes(bn_dp));
            wsp_str((int8u*)(bnu_dq_mb8[slot]), BN_num_bytes(bn_dq));
            wsp_str((int8u*)(bnu_invq_mb8[slot]), BN_num_bytes(bn_qinvp));
            #endif

            ifma_ptxt_mb8[slot] = ptxt[slot];
         }
         else
            printf("some problem in openssl operation above at %d slot\n", slot);
      }
      
      // encryption
      if(ret) {
         // ifma cp rsa
         memset(ifma_encbuf_mb8, 0, sizeof(ifma_encbuf_mb8));
         mbx_rsa_public_mb8((const int8u **)ifma_ptxt_mb8, ifma_enc_mb8,
                            (const int64u **)bnu_n_mb8,
                             rsaBitsize,
                             NULL, NULL);
         // comparison
         ret = (0 == mb8_diff(ctxt, ifma_enc_mb8, len8));
         if(ret) printf("enc  %d passed\n", ntest);
         else {
            int len;
            RSA_get0_key(rsa[err_buf_no], &bn_n, NULL, NULL);

            printf("== enc  test: %d buf: %d failed ==\n", ntest, err_buf_no);
            len = BN_bn2bin(bn_n, wbuffer);
            hstr_dump("n:\n", wbuffer, len);
            hstr_dump("ptxt:\n", ifma_ptxt_mb8[err_buf_no], rsaBitsize / 8);
         }
      }

      // decryption (key pair)
      if (ret && (flag & RSA_DEC2)) {
         memset(ifma_decbuf_mb8, 0, sizeof(ifma_decbuf_mb8));
         mbx_rsa_private_mb8((const int8u **)ifma_enc_mb8, ifma_dec_mb8,
                             (const int64u **)bnu_d_mb8,
                             (const int64u **)bnu_n_mb8,
                              rsaBitsize,
                              NULL, NULL);
         // comparison
         ret = (0 == mb8_diff(ptxt, ifma_dec_mb8, len8));
         if (ret) printf("dec2 %d passed\n", ntest);
         else {
            int len;
            RSA_get0_key(rsa[err_buf_no], &bn_n, NULL, NULL);
            RSA_get0_key(rsa[err_buf_no], NULL, NULL, &bn_d);

            printf("== dec2 %d buf: %d failed ==\n", ntest, err_buf_no);
            len = BN_bn2bin(bn_n, wbuffer);
            hstr_dump("n:\n", wbuffer, len);
            len = BN_bn2bin(bn_d, wbuffer);
            hstr_dump("d:\n", wbuffer, len);
            hstr_dump("ctxt:\n", ifma_enc_mb8[err_buf_no], rsaBitsize/8);
         }
      }

      // decryption (key quantiple)
      if (ret && (flag & RSA_DEC5)) {
         memset(ifma_decbuf_mb8, 0, sizeof(ifma_decbuf_mb8));
         mbx_rsa_private_crt_mb8((const int8u **)ifma_enc_mb8, ifma_dec_mb8,
                                 (const int64u **)bnu_p_mb8, (const int64u **)bnu_q_mb8,
                                 (const int64u **)bnu_dp_mb8, (const int64u **)bnu_dq_mb8, (const int64u **)bnu_invq_mb8,
                                 rsaBitsize,
                                 NULL, NULL);
         // comparison
         ret = (0 == mb8_diff(ptxt, ifma_dec_mb8, len8));
         if (ret) printf("dec5 %d passed\n", ntest);
         else {
            int len;
            RSA_get0_factors(rsa[err_buf_no], &bn_p, NULL);
            RSA_get0_factors(rsa[err_buf_no], NULL, &bn_q);
            RSA_get0_crt_params(rsa[err_buf_no], &bn_dp, NULL, NULL);
            RSA_get0_crt_params(rsa[err_buf_no], NULL, &bn_dq, NULL);
            RSA_get0_crt_params(rsa[err_buf_no], NULL, NULL, &bn_qinvp);

            printf("== dec5 %d buf: %d failed ==\n", ntest, err_buf_no);
            len = BN_bn2bin(bn_p, wbuffer);
            hstr_dump("p:\n", wbuffer, len);
            len = BN_bn2bin(bn_q, wbuffer);
            hstr_dump("q:\n", wbuffer, len);
            len = BN_bn2bin(bn_dp, wbuffer);
            hstr_dump("dp:\n", wbuffer, len);
            len = BN_bn2bin(bn_dq, wbuffer);
            hstr_dump("dq:\n", wbuffer, len);
            len = BN_bn2bin(bn_qinvp, wbuffer);
            hstr_dump("invq:\n", wbuffer, len);
            hstr_dump("ctxt:\n", ifma_enc_mb8[err_buf_no], rsaBitsize / 8);
         }
      }

      // release rsa
      for (slot = 0; slot < 8 && ret; slot++)
         if(rsa[slot]) RSA_free(rsa[slot]);

      if(ret) printf("-- test -- %d passed\n", ntest);
   }

   return ret;
}
//////////////////////////////////////////////////////////////////////////////////

int main(void)
{
   char seed_info[] = "tests_of_mbx_cp_rsa ...";
   RAND_seed(seed_info, sizeof(seed_info));

   // vesrsion
   printf("%s\n", mbx_getversion()->strVersion);

   printf("mbx_rsa_mb8(1024):\n");
   if (0 == test_mbx_rsa_cp(1024, RSA_ENC|RSA_DEC2|RSA_DEC5)) printf("failed\n");
   else printf("passed\n");

   printf("mbx_rsa_mb8(2048):\n");
   if (0 == test_mbx_rsa_cp(2048, RSA_ENC|RSA_DEC2|RSA_DEC5)) printf("failed\n");
   else printf("passed\n");

   printf("mbx_rsa_mb8(3072):\n");
   if (0 == test_mbx_rsa_cp(3072, RSA_ENC|RSA_DEC2|RSA_DEC5)) printf("failed\n");
   else printf("passed\n");

   printf("mbx_rsa_mb8(4096):\n");
   if (0 == test_mbx_rsa_cp(4096, RSA_ENC|RSA_DEC2|RSA_DEC5)) printf("failed\n");
   else printf("passed\n");

   return 0;
}
