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
//  Purpose: bad arg test of MB RSA-1024, RSA-2048, RSA-3072, RSA-4096.
// 
*/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <crypto_mb/version.h>
#include <crypto_mb/rsa.h>

////////////////////
#define MAX_BITLEN (4096)

// data in residual domain
#define NUM_OF_DIGS(bitsize, digsize)   (((bitsize) + (digsize)-1)/(digsize))

#define MAX_LEN8 (NUM_OF_DIGS(MAX_BITLEN, 8))
int8u pt[8][MAX_LEN8];
int8u ct[8][MAX_LEN8];

// pointers to data above
int8u* ptxt[8] = { pt[0], pt[1], pt[2], pt[3], pt[4], pt[5], pt[6], pt[7] };
int8u* ctxt[8] = { ct[0], ct[1], ct[2], ct[3], ct[4], ct[5], ct[6], ct[7] };

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
////////////////////////////////////////////////////////////////////

static int check_status(mbx_status exp_status, mbx_status status)
{
   int res = exp_status==status;
   if(0==res) {
      printf("expected: %08x\n", exp_status);
      printf("returned: %08x\n", status);
   }
   return res;
}

static int ba_mbx_rsa_public_mb8(int rsaBitsize)
{
   /* "right" and "wrong" methods depending on rsaBitsize */
   mbx_RSA_Method* meth = NULL;
   mbx_RSA_Method* incorrect_meth = NULL;
   switch(rsaBitsize) {
   case 1024:
      meth = (mbx_RSA_Method*)mbx_RSA1K_pub65537_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA4K_pub65537_Method();
      break;
   case 2048:
      meth = (mbx_RSA_Method*)mbx_RSA2K_pub65537_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA3K_pub65537_Method();
      break;
   case 3072:
      meth = (mbx_RSA_Method*)mbx_RSA3K_pub65537_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA2K_pub65537_Method();
      break;
   case 4096:
      meth = (mbx_RSA_Method*)mbx_RSA4K_pub65537_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA1K_pub65537_Method();
      break;
   }

   typedef struct  {
      mbx_status    sts;
      int8u**  from_pa;
      int8u**  to_pa;
      int64u** n_pa;
      int rsaBitsize;
      mbx_RSA_Method* meth;
      int8u* pBuffer;
   } Parameters;
   Parameters parList[] = {
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     NULL, ctxt, bnu_n_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ptxt, NULL, bnu_n_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ptxt, ctxt,      NULL, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ptxt, ctxt, bnu_n_mb8, rsaBitsize-1, meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ptxt, ctxt, bnu_n_mb8, rsaBitsize,   incorrect_meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ptxt, ctxt, bnu_n_mb8, rsaBitsize,   (mbx_RSA_Method*)mbx_RSA_private_Method(rsaBitsize), NULL},
   };

   int result = 1;
   int n;
   for(n=0; n<sizeof(parList)/sizeof(parList[0]) && result==1; n++) {
      Parameters prm = parList[n];

      mbx_status sts = mbx_rsa_public_mb8((const int8u**)prm.from_pa,
                                           prm.to_pa,
                                           (const int64u**)prm.n_pa,
                                           prm.rsaBitsize,
                                           prm.meth,
                                           prm.pBuffer);
      result = check_status(prm.sts, sts);
   }

   if(1==result) {
      mbx_status sts_extecped = MBX_SET_STS( MBX_SET_STS_ALL(MBX_STATUS_OK), 0, MBX_STATUS_NULL_PARAM_ERR);
      mbx_status sts;

      int8u* pt0 = ptxt[0];
      ptxt[0] = NULL;
      sts = mbx_rsa_public_mb8((const int8u**)ptxt,
                                ctxt,
                                (const int64u**)bnu_n_mb8,
                                rsaBitsize,
                                meth,
                                NULL);
      ptxt[0] = pt0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* ct0 = ctxt[0];
      ctxt[0] = NULL;
      sts = mbx_rsa_public_mb8((const int8u**)ptxt,
                                ctxt,
                                (const int64u**)bnu_n_mb8,
                                rsaBitsize,
                                meth,
                                NULL);
      ctxt[0] = ct0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* n0 = bnu_n_mb8[0];
      bnu_n_mb8[0] = NULL;
      sts = mbx_rsa_public_mb8((const int8u**)ptxt,
                                ctxt,
                                (const int64u**)bnu_n_mb8,
                                rsaBitsize,
                                meth,
                                NULL);
      bnu_n_mb8[0] = n0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;
   }

   err:
   return result;
}
//////////////////////////////////////////////////////////////////////////////////

static int ba_mbx_rsa_private_mb8(int rsaBitsize)
{
   /* "right" and "wrong" methods depending on rsaBitsize */
   mbx_RSA_Method* meth = NULL;
   mbx_RSA_Method* incorrect_meth = NULL;
   switch(rsaBitsize) {
   case 1024:
      meth = (mbx_RSA_Method*)mbx_RSA1K_private_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA4K_private_Method();
      break;
   case 2048:
      meth = (mbx_RSA_Method*)mbx_RSA2K_private_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA3K_private_Method();
      break;
   case 3072:
      meth = (mbx_RSA_Method*)mbx_RSA3K_private_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA2K_private_Method();
      break;
   case 4096:
      meth = (mbx_RSA_Method*)mbx_RSA4K_private_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA1K_private_Method();
      break;
   }

   typedef struct  {
      mbx_status sts;
      int8u**  from_pa;
      int8u**  to_pa;
      int64u** d_pa;
      int64u** n_pa;
      int rsaBitsize;
      mbx_RSA_Method* meth;
      int8u* pBuffer;
   } Parameters;
   Parameters parList[] = {
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     NULL, ptxt, bnu_d_mb8, bnu_n_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, NULL, bnu_d_mb8, bnu_n_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt,      NULL, bnu_n_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt, bnu_d_mb8,      NULL, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_d_mb8, bnu_n_mb8, rsaBitsize-1, meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_d_mb8, bnu_n_mb8, rsaBitsize,   incorrect_meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_d_mb8, bnu_n_mb8, rsaBitsize,   (mbx_RSA_Method*)mbx_RSA_pub65537_Method(rsaBitsize), NULL},
   };

   int result = 1;
   int n;

   for(n=0; n<sizeof(parList)/sizeof(parList[0]) && result==1; n++) {
      Parameters prm = parList[n];

      mbx_status sts = mbx_rsa_private_mb8((const int8u**)prm.from_pa,
                                            prm.to_pa,
                                            (const int64u**)prm.d_pa,
                                            (const int64u**)prm.n_pa,
                                            prm.rsaBitsize,
                                            prm.meth,
                                            prm.pBuffer);
      result = check_status(prm.sts, sts);
   }

   if(1==result) {
      mbx_status sts_extecped = MBX_SET_STS( MBX_SET_STS_ALL(MBX_STATUS_OK), 0, MBX_STATUS_NULL_PARAM_ERR);
      mbx_status sts;

      int8u* ct0= ctxt[0];
      ctxt[0] = NULL;
      sts = mbx_rsa_private_mb8((const int8u**)ctxt,
                                 ptxt,
                                 (const int64u**)bnu_d_mb8,
                                 (const int64u**)bnu_n_mb8,
                                 rsaBitsize,
                                 meth,
                                 NULL);
      ctxt[0] = ct0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* pt0 = ptxt[0];
      ptxt[0] = NULL;
      sts = mbx_rsa_private_mb8((const int8u**)ctxt,
                                 ptxt,
                                 (const int64u**)bnu_d_mb8,
                                 (const int64u**)bnu_n_mb8,
                                 rsaBitsize,
                                 meth,
                                 NULL);
      ptxt[0] = pt0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* d0 = bnu_d_mb8[0];
      bnu_d_mb8[0] = NULL;
      sts = mbx_rsa_private_mb8((const int8u**)ctxt,
                                 ptxt,
                                 (const int64u**)bnu_d_mb8,
                                 (const int64u**)bnu_n_mb8,
                                 rsaBitsize,
                                 meth,
                                 NULL);
      bnu_d_mb8[0] = d0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* n0 = bnu_n_mb8[0];
      bnu_n_mb8[0] = NULL;
      sts = mbx_rsa_private_mb8((const int8u**)ctxt,
                                 ptxt,
                                 (const int64u**)bnu_d_mb8,
                                 (const int64u**)bnu_n_mb8,
                                 rsaBitsize,
                                 meth,
                                 NULL);
      bnu_n_mb8[0] = n0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;
   }

   err:
   return result;
}
//////////////////////////////////////////////////////////////////////////////////

static int ba_mbx_rsa_private_crt_mb8(int rsaBitsize)
{
   /* "right" and "wrong" methods depending on rsaBitsize */
   mbx_RSA_Method* meth = NULL;
   mbx_RSA_Method* incorrect_meth = NULL;
   switch(rsaBitsize) {
   case 1024:
      meth = (mbx_RSA_Method*)mbx_RSA1K_private_crt_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA4K_private_crt_Method();
      break;
   case 2048:
      meth = (mbx_RSA_Method*)mbx_RSA2K_private_crt_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA3K_private_crt_Method();
      break;
   case 3072:
      meth = (mbx_RSA_Method*)mbx_RSA3K_private_crt_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA2K_private_crt_Method();
      break;
   case 4096:
      meth = (mbx_RSA_Method*)mbx_RSA4K_private_crt_Method();
      incorrect_meth = (mbx_RSA_Method*)mbx_RSA1K_private_crt_Method();
      break;
   }

   typedef struct  {
      mbx_status sts;
      int8u**  from_pa;
      int8u**  to_pa;
      int64u** p_pa;
      int64u** q_pa;
      int64u** dp_pa;
      int64u** dq_pa;
      int64u** iq_pa;
      int rsaBitsize;
      mbx_RSA_Method* meth;
      int8u* pBuffer;
   } Parameters;
   Parameters parList[] = {
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     NULL, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, NULL, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt,      NULL, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt, bnu_p_mb8,      NULL, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt, bnu_p_mb8, bnu_q_mb8,       NULL, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8,       NULL, bnu_invq_mb8, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),     ctxt, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8,         NULL, rsaBitsize,   meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize-1, meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   incorrect_meth, NULL},
      {MBX_SET_STS_ALL(MBX_STATUS_MISMATCH_PARAM_ERR), ctxt, ptxt, bnu_p_mb8, bnu_q_mb8, bnu_dp_mb8, bnu_dq_mb8, bnu_invq_mb8, rsaBitsize,   (mbx_RSA_Method*)mbx_RSA_pub65537_Method(rsaBitsize), NULL},
   };

   int result = 1;
   int n;
   
   for(n=0; n<sizeof(parList)/sizeof(parList[0]) && result==1; n++) {
      Parameters prm = parList[n];

      mbx_status sts = mbx_rsa_private_crt_mb8((const int8u**)prm.from_pa,
                                                prm.to_pa,
                                                (const int64u**)prm.p_pa,
                                                (const int64u**)prm.q_pa,
                                                (const int64u**)prm.dp_pa,
                                                (const int64u**)prm.dq_pa,
                                                (const int64u**)prm.iq_pa,
                                                prm.rsaBitsize,
                                                prm.meth,
                                                prm.pBuffer);
      result = check_status(prm.sts, sts);
   }

   if(1==result) {
      mbx_status sts_extecped = MBX_SET_STS( MBX_SET_STS_ALL(MBX_STATUS_OK), 0, MBX_STATUS_NULL_PARAM_ERR);
      mbx_status sts;

      int8u* ct0 = ctxt[0];
      ctxt[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      ctxt[0] = ct0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* pt0 = ptxt[0];
      ptxt[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      ptxt[0] = pt0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* p0 = bnu_p_mb8[0];
      bnu_p_mb8[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      bnu_p_mb8[0] = p0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* q0 = bnu_q_mb8[0];
      bnu_q_mb8[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      bnu_q_mb8[0] = q0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* dp0 = bnu_dp_mb8[0];
      bnu_dp_mb8[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      bnu_dp_mb8[0] = dp0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* dq0 = bnu_dq_mb8[0];
      bnu_dq_mb8[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      bnu_dq_mb8[0] = dq0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int64u* iq0 = bnu_invq_mb8[0];
      bnu_invq_mb8[0] = NULL;
      sts = mbx_rsa_private_crt_mb8((const int8u**)ctxt,
                                     ptxt,
                                     (const int64u**)bnu_p_mb8,
                                     (const int64u**)bnu_q_mb8,
                                     (const int64u**)bnu_dp_mb8,
                                     (const int64u**)bnu_dq_mb8,
                                     (const int64u**)bnu_invq_mb8,
                                     rsaBitsize,
                                     meth,
                                     NULL);
      bnu_invq_mb8[0] = iq0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;
   }

   err:
   return result;
}
//////////////////////////////////////////////////////////////////////////////////

int main(void)
{
   // vesrsion
   printf("%s\n", mbx_getversion()->strVersion);

   int rsa_bit_size[] = {1024,2048,3072,4096};

   int res, n;

   ///
   // mbx_cp_rsa52_public_mb8
   //
   res = 1;
   for(n=0; n<sizeof(rsa_bit_size)/sizeof(rsa_bit_size[0]) && (1==res); n++) {
      int rsa_size = rsa_bit_size[n];
      printf("mbx_rsa_public_mb8(%d):\n", rsa_size);

      res = ba_mbx_rsa_public_mb8(rsa_size);

      if(res) printf("passed\n");
      else    printf("failed\n");
   }

   ///
   // mbx_cp_rsa52_private_mb8
   //
   res = 1;
   for(n=0; n<sizeof(rsa_bit_size)/sizeof(rsa_bit_size[0]) && (1==res); n++) {
      int rsa_size = rsa_bit_size[n];
      printf("mbx_rsa_private_mb8(%d):\n", rsa_size);

      res = ba_mbx_rsa_private_mb8(rsa_size);

      if(res) printf("passed\n");
      else    printf("failed\n");
   }

   ///
   // mbx_cp_rsa52_private_ctr_mb8
   //
   res = 1;
   for(n=0; n<sizeof(rsa_bit_size)/sizeof(rsa_bit_size[0]) && (1==res); n++) {
      int rsa_size = rsa_bit_size[n];
      printf("mbx_rsa_private_crt_mb8(%d):\n", rsa_size);

      res = ba_mbx_rsa_private_crt_mb8(rsa_size);

      if(res) printf("passed\n");
      else    printf("failed\n");
   }

   return 0;
}
