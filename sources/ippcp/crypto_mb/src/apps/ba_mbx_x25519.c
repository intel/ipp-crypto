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
//  Purpose: bad arg test of X25519.
// 
*/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <crypto_mb/version.h>
#include <crypto_mb/x25519.h>

////////////////////
#define MAX_BITLEN (256)

// data in residual domain
#define NUM_OF_DIGS(bitsize, digsize)   (((bitsize) + (digsize)-1)/(digsize))

#define MAX_LEN8 (NUM_OF_DIGS(MAX_BITLEN, 8))
int8u prv_key[8][MAX_LEN8];
int8u pub_key[8][MAX_LEN8];
int8u shr_key[8][MAX_LEN8];

// pointers to data above
int8u* prv_pa[8] = { prv_key[0], prv_key[1], prv_key[2], prv_key[3], prv_key[4], prv_key[5], prv_key[6], prv_key[7] };
int8u* pub_pa[8] = { pub_key[0], pub_key[1], pub_key[2], pub_key[3], pub_key[4], pub_key[5], pub_key[6], pub_key[7] };
int8u* shr_pa[8] = { shr_key[0], shr_key[1], shr_key[2], shr_key[3], shr_key[4], shr_key[5], shr_key[6], shr_key[7] };
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

static int ba_mbx_x25519_public_key_mb8(void)
{
   typedef struct  {
      mbx_status    sts;
      int8u**  pub_key_pa;
      int8u**  prv_key_pa;
   } Parameters;
   Parameters parList[] = {
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),   NULL, pub_pa},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR), prv_pa,   NULL},
   };

   int result = 1;
   int n;
   for(n=0; n<sizeof(parList)/sizeof(parList[0]) && result==1; n++) {
      Parameters prm = parList[n];

      mbx_status sts = mbx_x25519_public_key_mb8(prm.pub_key_pa,
                                              (const int8u**)prm.prv_key_pa);
      result = check_status(prm.sts, sts);
   }

   if(1==result) {
      mbx_status sts_extecped = MBX_SET_STS( MBX_SET_STS_ALL(MBX_STATUS_OK), 0, MBX_STATUS_NULL_PARAM_ERR);
      mbx_status sts;

      int8u* pub0 = pub_pa[0];
      pub_pa[0] = NULL;
      sts = mbx_x25519_public_key_mb8(pub_pa,
                                  (const int8u**)prv_pa);
      pub_pa[0] = pub0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* prv0 = prv_pa[0];
      prv_pa[0] = NULL;
      sts = mbx_x25519_public_key_mb8(pub_pa,
                                  (const int8u**)prv_pa);
      prv_pa[0] = prv0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;
   }

   err:
   return result;
}
//////////////////////////////////////////////////////////////////////////////////

static int ba_mbx_x25519_mb8(void)
{
   typedef struct  {
      mbx_status    sts;
      int8u**  shr_key_pa;
      int8u**  prv_key_pa;
      int8u**  pub_key_pa;
   } Parameters;
   Parameters parList[] = {
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR),   NULL, shr_pa, pub_pa},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR), prv_pa,   NULL, pub_pa},
      {MBX_SET_STS_ALL(MBX_STATUS_NULL_PARAM_ERR), prv_pa, shr_pa,   NULL},
   };

   int result = 1;
   int n;
   for(n=0; n<sizeof(parList)/sizeof(parList[0]) && result==1; n++) {
      Parameters prm = parList[n];

      mbx_status sts = mbx_x25519_mb8(prm.shr_key_pa,
                                   (const int8u**)prm.prv_key_pa,
                                   (const int8u**)prm.pub_key_pa);
      result = check_status(prm.sts, sts);
   }

   if(1==result) {
      /* masked runtime status MBX_STATUS_LOW_ORDER_ERR */
      mbx_status mask_order_err = MBX_SET_STS_ALL((mbx_status)(~MBX_STATUS_LOW_ORDER_ERR & 0xF));
      mbx_status sts_extecped = MBX_SET_STS( MBX_SET_STS_ALL(MBX_STATUS_OK), 0, MBX_STATUS_NULL_PARAM_ERR);
      mbx_status sts;

      int8u* shr0 = shr_pa[0];
      shr_pa[0] = NULL;
      sts = mbx_x25519_mb8(shr_pa,
                       (const int8u**)prv_pa,
                       (const int8u**)pub_pa);
      sts &= mask_order_err;
      shr_pa[0] = shr0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* prv0 = prv_pa[0];
      prv_pa[0] = NULL;
      sts = mbx_x25519_mb8(shr_pa,
                       (const int8u**)prv_pa,
                       (const int8u**)pub_pa);
      sts &= mask_order_err;
      prv_pa[0] = prv0;
      if(0 == (result = check_status(sts_extecped, sts))) goto err;

      int8u* pub0 = pub_pa[0];
      pub_pa[0] = NULL;
      sts = mbx_x25519_mb8(shr_pa,
                       (const int8u**)prv_pa,
                       (const int8u**)pub_pa);
      sts &= mask_order_err;
      pub_pa[0] = pub0;
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

   int res;

   ///
   // mbx_x25519_public_key_mb8
   //
   res = 1;
   printf("mbx_x25519_public_key_mb8:\n");

   res = ba_mbx_x25519_public_key_mb8();

   if(res) printf("passed\n");
   else    printf("failed\n");

   ///
   // mbx_x25519_mb8
   //
   res = 1;
   printf("mbx_x25519_mb8:\n");

   res = ba_mbx_x25519_mb8();

   if(res) printf("passed\n");
   else    printf("failed\n");

   return 0;
}
