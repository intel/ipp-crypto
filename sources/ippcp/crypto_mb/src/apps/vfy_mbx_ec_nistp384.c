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

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <openssl/bn.h>
#include <openssl/rand.h>
#include <openssl/ec.h>
#include <openssl/obj_mac.h>

#include <crypto_mb/version.h>
#include <crypto_mb/cpu_features.h>
#include <crypto_mb/ec_nistp384.h>

// EC NIST-P384 parameters
static const int8u p_nistp384[] = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFF";
static const int8u a_nistp384[] = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFF0000000000000000FFFFFFFC";
static const int8u b_nistp384[] = "B3312FA7E23EE7E4988E056BE3F82D19181D9C6EFE8141120314088F5013875AC656398D8A2ED19D2A85C8EDD3EC2AEF";

static const int8u gx_nistp384[] = "AA87CA22BE8B05378EB1C71EF320AD746E1D3B628BA79B9859F741E082542A385502F25DBF55296C3A545E3872760AB7";
static const int8u gy_nistp384[] = "3617DE4A96262C6F5D9E98BF9292DC29F8F41DBD289A147CE9DA3113B5F0B8C00A60B1CE1D7E819D7A431D7C90EA0E5F";
static const int8u  n_nistp384[] = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC7634D81F4372DDF581A0DB248B0A77AECEC196ACCC52973";
static const int8u  h_nistp384[] = "01";

// globals (group)
BIGNUM* P = 0;
BIGNUM* A = 0;
BIGNUM* B = 0;
EC_GROUP* EC = 0;

// globals (sub-group)
BIGNUM*  Gx = 0;
BIGNUM*  Gy = 0;
BIGNUM*   N = 0;
EC_POINT* G = 0;

static void new_nistp384(BN_CTX* ctx)
{
   P = BN_new();
   A = BN_new();
   B = BN_new();
   Gx= BN_new();
   Gy= BN_new();
   N = BN_new();

   //EC = EC_GROUP_new( EC_GFp_simple_method() );
   EC = EC_GROUP_new( EC_GFp_mont_method() );
   BN_hex2bn(&P, (char*)p_nistp384);
   BN_hex2bn(&A, (char*)a_nistp384);
   BN_hex2bn(&B, (char*)b_nistp384);
   EC_GROUP_set_curve_GFp(EC, P, A, B, ctx);

   G = EC_POINT_new(EC);
   BN_hex2bn(&Gx, (char*)gx_nistp384);
   BN_hex2bn(&Gy, (char*)gy_nistp384);
   BN_hex2bn( &N,  (char*)n_nistp384);
   EC_POINT_set_affine_coordinates_GFp(EC, G, Gx, Gy, ctx);
   EC_GROUP_set_generator(EC, G, N, BN_value_one());
}

static void release_nistp384(void)
{
   EC_POINT_free(G);
   EC_GROUP_free(EC);
   BN_free(N);
   BN_free(Gx);
   BN_free(Gy);
   BN_free(B);
   BN_free(A);
   BN_free(P);
}

#define NUM_OF_DIGS(bitsize, digsize)   (((bitsize) + (digsize)-1)/(digsize))
#define GF384_BITLEN (384)

// data in residual (2^64) domain
#define LEN64 (NUM_OF_DIGS(GF384_BITLEN, 64))
#define LEN8  (NUM_OF_DIGS(GF384_BITLEN, 8))

// coordinates of 8 OpenSSL's points A's keys (prvA, pubAx, pubAy, pubAz)
__ALIGN64 int64u pubAx[8][LEN64];
__ALIGN64 int64u pubAy[8][LEN64];
__ALIGN64 int64u pubAz[8][LEN64];
__ALIGN64 int64u prvA[8][LEN64];
__ALIGN64 int64u* pa_pubAx[8] = {pubAx[0],pubAx[1],pubAx[2],pubAx[3],pubAx[4],pubAx[5],pubAx[6],pubAx[7]};
__ALIGN64 int64u* pa_pubAy[8] = {pubAy[0],pubAy[1],pubAy[2],pubAy[3],pubAy[4],pubAy[5],pubAy[6],pubAy[7]};
__ALIGN64 int64u* pa_pubAz[8] = {pubAz[0],pubAz[1],pubAz[2],pubAz[3],pubAz[4],pubAz[5],pubAz[6],pubAz[7]};
__ALIGN64 int64u* pa_prvA[8]  = { prvA[0], prvA[1], prvA[2], prvA[3], prvA[4], prvA[5], prvA[6], prvA[7]};

// coordinates of 8 OpenSSL's points B's keys (prvB, pubBx, pubBy, pubBz)
__ALIGN64 int64u pubBx[8][LEN64];
__ALIGN64 int64u pubBy[8][LEN64];
__ALIGN64 int64u pubBz[8][LEN64];
__ALIGN64 int64u prvB[8][LEN64];
__ALIGN64 int64u* pa_pubBx[8] = {pubBx[0],pubBx[1],pubBx[2],pubBx[3],pubBx[4],pubBx[5],pubBx[6],pubBx[7]};
__ALIGN64 int64u* pa_pubBy[8] = {pubBy[0],pubBy[1],pubBy[2],pubBy[3],pubBy[4],pubBy[5],pubBy[6],pubBy[7]};
__ALIGN64 int64u* pa_pubBz[8] = {pubBz[0],pubBz[1],pubBz[2],pubBz[3],pubBz[4],pubBz[5],pubBz[6],pubBz[7]};
__ALIGN64 int64u* pa_prvB[8]  = { prvB[0], prvB[1], prvB[2], prvB[3], prvB[4], prvB[5], prvB[6], prvB[7]};

// shared keys
int8u sharedAB[8][LEN8];
int8u sharedBA[8][LEN8];
////////////////////////////////////////////////////////////

__ALIGN64 int64u ifma_pubAx[8][LEN64];
__ALIGN64 int64u ifma_pubAy[8][LEN64];
__ALIGN64 int64u ifma_pubAz[8][LEN64];
__ALIGN64 int64u* pa_ifma_pubAx[8] = {ifma_pubAx[0],ifma_pubAx[1],ifma_pubAx[2],ifma_pubAx[3],ifma_pubAx[4],ifma_pubAx[5],ifma_pubAx[6],ifma_pubAx[7]};
__ALIGN64 int64u* pa_ifma_pubAy[8] = {ifma_pubAy[0],ifma_pubAy[1],ifma_pubAy[2],ifma_pubAy[3],ifma_pubAy[4],ifma_pubAy[5],ifma_pubAy[6],ifma_pubAy[7]};
__ALIGN64 int64u* pa_ifma_pubAz[8] = {ifma_pubAz[0],ifma_pubAz[1],ifma_pubAz[2],ifma_pubAz[3],ifma_pubAz[4],ifma_pubAz[5],ifma_pubAz[6],ifma_pubAz[7]};

// crypto-mb scalar and points
   int8u ifma_sharedAB[8][LEN8];
   int8u ifma_sharedBA[8][LEN8];
   int8u* pa_ifma_sharedAB[8] = {ifma_sharedAB[0],ifma_sharedAB[1],ifma_sharedAB[2],ifma_sharedAB[3],
                                 ifma_sharedAB[4],ifma_sharedAB[5],ifma_sharedAB[6],ifma_sharedAB[7]};
   int8u* pa_ifma_sharedBA[8] = {ifma_sharedBA[0],ifma_sharedBA[1],ifma_sharedBA[2],ifma_sharedBA[3],
                                 ifma_sharedBA[4],ifma_sharedBA[5],ifma_sharedBA[6],ifma_sharedBA[7]};
////////////////////////////////////////////////////////////

#if BN_OPENSSL_PATCH
extern BN_ULONG* bn_get_words(const BIGNUM* bn);
#endif

static int8u* reverse_bytes(int8u* out, const int8u* inp, int len)
{
   int i;
   if(out==inp) { // inplace
      for(int i=0; i<len/2; i++) {
         int8u a = inp[i];
         out[i] = inp[len-1-i];
         out[len-1-i] = a;
      }
   }
   else { // not inplace
      for(int i=0; i<len; i++) {
         out[i] = inp[len-1-i];
      }
   }
   return out;
}

static int64u* get_BN_data(int64u x[], const BIGNUM* bn)
{
   // clear buffer
   memset(x, 0, sizeof(int64u) * LEN64);
   int num_bytes  = BN_num_bytes(bn);

   #if BN_OPENSSL_PATCH
   memcpy(x, bn_get_words(bn), num_bytes);
   #else
   BN_bn2bin(bn, (int8u*)x);
   reverse_bytes((int8u*)x, (int8u*)x, num_bytes);
   #endif

   return x;
}

static BIGNUM* set_BN_data(BIGNUM* bn, const int64u x[])
{
   int8u tmp[LEN8];
   reverse_bytes(tmp, (int8u*)x, sizeof(tmp));
   BN_bin2bn(tmp, sizeof(tmp),  bn);
   return bn;
}


#define MAX_TEST_ROUND (100) //(10000)

#define A_COORDS  (0)   // use affine accodinates
#define J_COORDS  (1)   // use Jacobian projective accodinates

static int test_mbx_nistp384_ecpublic_key(BN_CTX* ctx, int coord_mode)
{
   int res = 1;
   const int num_tests = MAX_TEST_ROUND;

   EC_KEY* keyA = EC_KEY_new();
   EC_KEY_set_group(keyA, EC);

   /* array of private keys */
   BIGNUM* prv = BN_new();

   /* array of public keys coordinates */
   BIGNUM* X = BN_new();
   BIGNUM* Y = BN_new();
   BIGNUM* Z = BN_new();

   EC_POINT* publicSSL = EC_POINT_new(EC);
   EC_POINT* publicCMB = EC_POINT_new(EC); // crypto_mb

   for(int n=0; n<num_tests && res; n++) {

      memset(prvA, 0, sizeof(prvA));

      memset(pubAx, 0, sizeof(pubAx));
      memset(pubAy, 0, sizeof(pubAy));
      memset(pubAz, 0, sizeof(pubAz));

      memset(ifma_pubAx, 0, sizeof(ifma_pubAx));
      memset(ifma_pubAy, 0, sizeof(ifma_pubAy));
      memset(ifma_pubAz, 0, sizeof(ifma_pubAz));

      for(int i=0; i<8; i++) {
         // generate key pairs
         EC_KEY_generate_key(keyA);

         // extract private keys and store
         get_BN_data(prvA[i], EC_KEY_get0_private_key(keyA));

         // extract public key and store it projective/affine coordinates
         if(J_COORDS == coord_mode) {
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), X, Y, Z, ctx);
            get_BN_data(pubAx[i], X);
            get_BN_data(pubAy[i], Y);
            get_BN_data(pubAz[i], Z);
         }
         else {
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), X, Y, ctx);
            get_BN_data(pubAx[i], X);
            get_BN_data(pubAy[i], Y);
         }
      }

      // ifma pub key
      if(J_COORDS == coord_mode)
         mbx_nistp384_ecpublic_key_mb8((int64u**)pa_ifma_pubAx, (int64u**)pa_ifma_pubAy, (int64u**)pa_ifma_pubAz, (const int64u**)pa_prvA, 0);
      else
         mbx_nistp384_ecpublic_key_mb8((int64u**)pa_ifma_pubAx, (int64u**)pa_ifma_pubAy, 0, (const int64u**)pa_prvA, 0);

      // compare results in projective coords */
      if(J_COORDS == coord_mode)
         for(int i=0; i<8 && res; i++) {
            set_BN_data(X, pubAx[i]);
            set_BN_data(Y, pubAy[i]);
            set_BN_data(Z, pubAz[i]);
            EC_POINT_set_Jprojective_coordinates_GFp(EC, publicSSL, X, Y, Z, ctx);

            set_BN_data(X, pa_ifma_pubAx[i]);
            set_BN_data(Y, pa_ifma_pubAy[i]);
            set_BN_data(Z, pa_ifma_pubAz[i]);
            EC_POINT_set_Jprojective_coordinates_GFp(EC, publicCMB, X, Y, Z, ctx);
            res = (0 == EC_POINT_cmp(EC, publicSSL, publicCMB, ctx));
         }
      else {
         for(int i=0; i<8 && res; i++) {
            set_BN_data(X, pubAx[i]);
            set_BN_data(Y, pubAy[i]);
            EC_POINT_set_affine_coordinates_GFp(EC, publicSSL, X, Y, ctx);

            set_BN_data(X, pa_ifma_pubAx[i]);
            set_BN_data(Y, pa_ifma_pubAy[i]);
            EC_POINT_set_affine_coordinates_GFp(EC, publicCMB, X, Y, ctx);
            res = (0 == EC_POINT_cmp(EC, publicSSL, publicCMB, ctx));
         }
      }

      printf("test %03d:", n);
      if(1==res)
         printf("passed\n");
      else
         printf("failed\n");
   }

   // release resources
   BN_free(Z);
   BN_free(Y);
   BN_free(X);
   BN_free(prv);

   EC_KEY_free(keyA);

   return res;
}

static int test_mbx_nistp384_ecdh(BN_CTX* ctx, int coord_mode)
{
   int res = 1;
   const int num_tests = MAX_TEST_ROUND;

   EC_KEY* keyA = EC_KEY_new();
   EC_KEY* keyB = EC_KEY_new();
   EC_KEY_set_group(keyA, EC);
   EC_KEY_set_group(keyB, EC);

   /* array of public keys coordinates */
   BIGNUM* X = BN_new();
   BIGNUM* Y = BN_new();
   BIGNUM* Z = BN_new();

   for(int n=0; n<num_tests && res; n++) {
      memset(sharedAB, 0, sizeof(sharedAB));
      memset(sharedBA, 0, sizeof(sharedBA));

      memset(ifma_sharedAB, 0, sizeof(ifma_sharedAB));
      memset(ifma_sharedBA, 0, sizeof(ifma_sharedBA));

      for(int i=0; i<8; i++) {
         // generate key pairs
         EC_KEY_generate_key(keyA);
         EC_KEY_generate_key(keyB);

         // extract private keys and store
         get_BN_data(prvA[i], EC_KEY_get0_private_key(keyA));
         get_BN_data(prvB[i], EC_KEY_get0_private_key(keyB));

         // extract public key and store it projective/affine coordinates
         if(J_COORDS == coord_mode) {
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), X, Y, Z, ctx);
            get_BN_data(pubAx[i], X);
            get_BN_data(pubAy[i], Y);
            get_BN_data(pubAz[i], Z);
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyB), X, Y, Z, ctx);
            get_BN_data(pubBx[i], X);
            get_BN_data(pubBy[i], Y);
            get_BN_data(pubBz[i], Z);
         }
         else {
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), X, Y, ctx);
            get_BN_data(pubAx[i], X);
            get_BN_data(pubAy[i], Y);
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyB), X, Y, ctx);
            get_BN_data(pubBx[i], X);
            get_BN_data(pubBy[i], Y);
         }

         // A-B shared
         ECDH_compute_key(sharedAB[i], LEN8, EC_KEY_get0_public_key(keyB), keyA, NULL);
         ECDH_compute_key(sharedBA[i], LEN8, EC_KEY_get0_public_key(keyA), keyB, NULL);
      }

      // ifma shared key
      if(J_COORDS == coord_mode) {
         mbx_nistp384_ecdh_mb8(pa_ifma_sharedAB, (const int64u**)pa_prvA, (const int64u**)pa_pubBx, (const int64u**)pa_pubBy, (const int64u**)pa_pubBz, 0);
         mbx_nistp384_ecdh_mb8(pa_ifma_sharedBA, (const int64u**)pa_prvB, (const int64u**)pa_pubAx, (const int64u**)pa_pubAy, (const int64u**)pa_pubAz, 0);
      }
      else {
         mbx_nistp384_ecdh_mb8(pa_ifma_sharedAB, (const int64u**)pa_prvA, (const int64u**)pa_pubBx, (const int64u**)pa_pubBy, NULL, 0);
         mbx_nistp384_ecdh_mb8(pa_ifma_sharedBA, (const int64u**)pa_prvB, (const int64u**)pa_pubAx, (const int64u**)pa_pubAy, NULL, 0);
      }

      // compare results
      int resAB = (0 == memcmp(sharedAB, ifma_sharedAB, sizeof(sharedAB)));
      int resBA = (0 == memcmp(sharedBA, ifma_sharedBA, sizeof(sharedBA)));
      res = resAB && resBA;
      printf("test %03d:", n);
      if(1==res)
         printf("passed\n");
      else
         printf("failed\n");
   }

   // release resources
   BN_free(Z);
   BN_free(Y);
   BN_free(X);

   EC_KEY_free(keyB);
   EC_KEY_free(keyA);

   return res;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static int test_mbx_nistp384_ecdsa_sign(BN_CTX* ctx)
{
   // get order
   BIGNUM *order = BN_new();
   EC_GROUP_get_order(EC, order, 0);

   // messages & kat signatures
   int8u msg[8][LEN8];
   int8u sign_r_kat[8][LEN8];
   int8u sign_s_kat[8][LEN8];

   // OpenSSL's regular key pairs
   EC_KEY* regKeyPair[8] ={0,0,0,0,0,0,0,0};

   // ifma's ephemeral and regular keys
   int64u eph_skey[8][LEN64];
   int64u reg_skey[8][LEN64];
   int64u* pa_eph_skey[8] = {eph_skey[0], eph_skey[1], eph_skey[2], eph_skey[3],
                             eph_skey[4], eph_skey[5], eph_skey[6], eph_skey[7]};
   int64u* pa_reg_skey[8] = {reg_skey[0], reg_skey[1], reg_skey[2], reg_skey[3],
                             reg_skey[4], reg_skey[5], reg_skey[6], reg_skey[7]};

   // ifma's signatures
   int8u sign_r[8][LEN8];
   int8u sign_s[8][LEN8];
   int8u* pa_sign_r[8] = {sign_r[0], sign_r[1], sign_r[2], sign_r[3],
                          sign_r[4], sign_r[5], sign_r[6], sign_r[7]};
   int8u* pa_sign_s[8] = {sign_s[0], sign_s[1], sign_s[2], sign_s[3],
                          sign_s[4], sign_s[5], sign_s[6], sign_s[7]};
   int8u* pa_msg[8]    = {msg[0], msg[1], msg[2], msg[3],
                          msg[4], msg[5], msg[6], msg[7]};

   BIGNUM* bn_msg = BN_new();
   BIGNUM* bn_add = BN_new();

   const int num_tests = MAX_TEST_ROUND;
   int res = 1;

   for(int n=0; n<num_tests && res; n++) {
      memset(msg, 0, sizeof(msg));
      memset(sign_r_kat, 0, sizeof(sign_r_kat));
      memset(sign_s_kat, 0, sizeof(sign_s_kat));

      printf("test %3d: ", n);

      for(int i=0; i<8; i++) {
         BN_set_word(bn_add, (8*n+i+1));
         /* random message */
         if(n==0)
            BN_rand(bn_msg, 128, -1, 0);   // short message
         else if(n==1)
            BN_add(bn_msg, order, bn_add); // message = order + (8*n+i+1)
         else
            BN_rand(bn_msg, GF384_BITLEN, -1, 0);  // top and bottom bits could be zero
         BN_bn2bin(bn_msg, msg[i]+sizeof(msg[0])-BN_num_bytes(bn_msg));

         // generate regular key pair
         regKeyPair[i] = EC_KEY_new();
         EC_KEY_set_group(regKeyPair[i], EC);
         EC_KEY_generate_key(regKeyPair[i]);

         // setup kinv and rp
         BIGNUM* bn_kinv = 0;
         BIGNUM* bn_rp = 0;
         ECDSA_sign_setup(regKeyPair[i], 0, &bn_kinv, &bn_rp);

         // generate sign
         ECDSA_SIG* sign = 0;
         sign = ECDSA_do_sign_ex(msg[i], sizeof(msg[0]), bn_kinv, bn_rp, regKeyPair[i]);

         // reference to sign' components
         const BIGNUM* signR = 0;
         const BIGNUM* signS = 0;
         #if OPENSSL_VERSION_NUMBER < 0x10101000L
         ECDSA_SIG_get0(&signR, &signS, sign);
         #else
         ECDSA_SIG_get0(sign, &signR, &signS);
         #endif

         // restore k and store
         BIGNUM* bn_k = BN_new();
         BN_mod_inverse(bn_k, bn_kinv, order, ctx);
         get_BN_data(eph_skey[i], bn_k);

         // get regerence to  regular private key and store
         BIGNUM* bn_regk = (BIGNUM*)( EC_KEY_get0_private_key(regKeyPair[i]) );
         get_BN_data(reg_skey[i], bn_regk);

         // store kat signature
         BN_bn2bin(signR, sign_r_kat[i]+sizeof(sign_r_kat[0]) -BN_num_bytes(signR));
         BN_bn2bin(signS, sign_s_kat[i]+sizeof(sign_s_kat[0]) -BN_num_bytes(signS));

         BN_free(bn_k);
         BN_free(bn_kinv);
         BN_free(bn_rp);
      }

      // mbx_nistp384_ecdsa_sign_mb8
      memset(sign_r, 0, sizeof(sign_r));
      memset(sign_s, 0, sizeof(sign_s));

      mbx_nistp384_ecdsa_sign_mb8(pa_sign_r, pa_sign_s,
                                  (const int8u**)pa_msg,
                                  (const int64u**)pa_eph_skey,
                                  (const int64u**)pa_reg_skey,
                                  0);
      // compare
      int res_r = (0==memcmp(sign_r_kat, sign_r, sizeof(sign_r_kat)));
      int res_s = (0==memcmp(sign_s_kat, sign_s, sizeof(sign_s_kat)));
      res = res_r && res_s;
      if(res)
         printf("passed\n");
      else
         printf("failed\n");

      // release resources
      for(int i=0; i<8; i++) {
         EC_KEY_free(regKeyPair[i]);
      }
   }

   BN_free(bn_add);
   BN_free(bn_msg);
   BN_free(order);

   return res;
}

static int test_mbx_nistp384_ecdsa_sign2(BN_CTX* ctx)
{
   // get order
   BIGNUM *order = BN_new();
   EC_GROUP_get_order(EC, order, 0);

   // messages & kat signatures
   int8u msg[8][LEN8];
   int8u sign_r_kat[8][LEN8];
   int8u sign_s_kat[8][LEN8];

   // OpenSSL's regular key pairs
   EC_KEY* regKeyPair[8] ={0,0,0,0,0,0,0,0};

   // ifma's ephemeral and regular keys
   int64u eph_skey[8][LEN64];
   int64u reg_skey[8][LEN64];
   int64u* pa_eph_skey[8] = {eph_skey[0], eph_skey[1], eph_skey[2], eph_skey[3],
                             eph_skey[4], eph_skey[5], eph_skey[6], eph_skey[7]};
   int64u* pa_reg_skey[8] = {reg_skey[0], reg_skey[1], reg_skey[2], reg_skey[3],
                             reg_skey[4], reg_skey[5], reg_skey[6], reg_skey[7]};
   // ifma's inversion of ephemeral keys
   int64u inv_eph_skey[8][LEN64];
   int64u* pa_inv_eph_skey[8] = {inv_eph_skey[0], inv_eph_skey[1], inv_eph_skey[2], inv_eph_skey[3],
                                 inv_eph_skey[4], inv_eph_skey[5], inv_eph_skey[6], inv_eph_skey[7]};
   // ifma's pre-computes sign_r
   int64u sign_rp[8][LEN64];
   int64u* pa_sign_rp[8] = {sign_rp[0], sign_rp[1], sign_rp[2], sign_rp[3],
                            sign_rp[4], sign_rp[5], sign_rp[6], sign_rp[7]};

   // ifma's signatures
   int8u sign_r[8][LEN8];
   int8u sign_s[8][LEN8];
   int8u* pa_sign_r[8] = {sign_r[0], sign_r[1], sign_r[2], sign_r[3],
                          sign_r[4], sign_r[5], sign_r[6], sign_r[7]};
   int8u* pa_sign_s[8] = {sign_s[0], sign_s[1], sign_s[2], sign_s[3],
                          sign_s[4], sign_s[5], sign_s[6], sign_s[7]};
   int8u* pa_msg[8]    = {msg[0], msg[1], msg[2], msg[3],
                          msg[4], msg[5], msg[6], msg[7]};

   BIGNUM* bn_msg = BN_new();
   BIGNUM* bn_add = BN_new();

   const int num_tests = MAX_TEST_ROUND;
   int res = 1;

   for(int n=0; n<num_tests && res; n++) {
      memset(msg, 0, sizeof(msg));
      memset(sign_r_kat, 0, sizeof(sign_r_kat));
      memset(sign_s_kat, 0, sizeof(sign_s_kat));

      printf("test %3d: ", n);

      for(int i=0; i<8; i++) {
         BN_set_word(bn_add, (8*n+i+1));
         /* random message */
         if(n==0)
            BN_rand(bn_msg, 128, -1, 0);   // short message
         else if(n==1)
            BN_add(bn_msg, order, bn_add); // message = order + (8*n+i+1)
         else
            BN_rand(bn_msg, GF384_BITLEN, -1, 0);  // top and bottom bits could be zero
         BN_bn2bin(bn_msg, msg[i]+sizeof(msg[0])-BN_num_bytes(bn_msg));

         // generate regular key pair
         regKeyPair[i] = EC_KEY_new();
         EC_KEY_set_group(regKeyPair[i], EC);
         EC_KEY_generate_key(regKeyPair[i]);

         // setup kinv and rp
         BIGNUM* bn_kinv = 0;
         BIGNUM* bn_rp = 0;
         ECDSA_sign_setup(regKeyPair[i], 0, &bn_kinv, &bn_rp);

         // generate sign
         ECDSA_SIG* sign = 0;
         sign = ECDSA_do_sign_ex(msg[i], sizeof(msg[0]), bn_kinv, bn_rp, regKeyPair[i]);

         // reference to sign' components
         const BIGNUM* signR = 0;
         const BIGNUM* signS = 0;
         #if OPENSSL_VERSION_NUMBER < 0x10101000L
         ECDSA_SIG_get0(&signR, &signS, sign);
         #else
         ECDSA_SIG_get0(sign, &signR, &signS);
         #endif

         // restore k and store
         BIGNUM* bn_k = BN_new();
         BN_mod_inverse(bn_k, bn_kinv, order, ctx);
         get_BN_data(eph_skey[i], bn_k);

         // get regerence to  regular private key and store
         BIGNUM* bn_regk = (BIGNUM*)( EC_KEY_get0_private_key(regKeyPair[i]) );
         get_BN_data(reg_skey[i], bn_regk);

         // store kat signature
         BN_bn2bin(signR, sign_r_kat[i]+sizeof(sign_r_kat[0]) -BN_num_bytes(signR));
         BN_bn2bin(signS, sign_s_kat[i]+sizeof(sign_s_kat[0]) -BN_num_bytes(signS));

         BN_free(bn_k);
         BN_free(bn_kinv);
         BN_free(bn_rp);
      }

      // ifma_nistp384_ecdsa_sign_mb8
      memset(sign_r, 0, sizeof(sign_r));
      memset(sign_s, 0, sizeof(sign_s));
      mbx_nistp384_ecdsa_sign_setup_mb8(pa_inv_eph_skey,
                                        pa_sign_rp,
                                        (const int64u**)pa_eph_skey,
                                        0);
      mbx_nistp384_ecdsa_sign_complete_mb8(pa_sign_r, pa_sign_s,
                                           (const int8u**)pa_msg,
                                           (const int64u**)pa_sign_rp,
                                           (const int64u**)pa_inv_eph_skey,
                                           (const int64u**)pa_reg_skey,
                                           0);
      // compare
      int res_r = (0==memcmp(sign_r_kat, sign_r, sizeof(sign_r_kat)));
      int res_s = (0==memcmp(sign_s_kat, sign_s, sizeof(sign_s_kat)));
      res = res_r && res_s;
      if(res)
         printf("passed\n");
      else
         printf("failed\n");

      // release resources
      for(int i=0; i<8; i++) {
         EC_KEY_free(regKeyPair[i]);
      }
   }

   BN_free(bn_add);
   BN_free(bn_msg);
   BN_free(order);

   return res;
}


int main(void)
{
   char seed_info[] = "tests_of_mbx_ec_nistp384 ...";
   RAND_seed(seed_info, sizeof(seed_info));

   // vesrsion
   printf("%s\n", mbx_getversion()->strVersion);

   printf("ECDHE NIST-P384: %lld\n", mbx_get_algo_info(MBX_ALGO_ECDHE_NIST_P384));
   printf("ECDSA NIST-P384: %lld\n", mbx_get_algo_info(MBX_ALGO_ECDSA_NIST_P384));

   // set up parameters
   BN_CTX* ctx = BN_CTX_new();
   new_nistp384(ctx);
   ////////////////////////////

   printf("mbx_nistp384_ecpublic_key_mb8(projective_coordinates): \n");
   if(1 != test_mbx_nistp384_ecpublic_key(ctx, J_COORDS)) goto err;
   printf("mbx_nistp384_ecpublic_key_mb8(affine_coordinates): \n");
   if(1 != test_mbx_nistp384_ecpublic_key(ctx, A_COORDS)) goto err;

   printf("mbx_nistp384_ecdh_mb8(projective_coordinates): \n");
   if(1 != test_mbx_nistp384_ecdh(ctx, J_COORDS)) goto err;
   printf("mbx_nistp384_ecdh_mb8(affine_coordinates): \n");
   if(1 != test_mbx_nistp384_ecdh(ctx, A_COORDS)) goto err;

   printf("mbx_nistp384_ecdsa_sign_mb8(): \n");
   if(1 != test_mbx_nistp384_ecdsa_sign(ctx)) goto err;

   printf("mbx_nistp384_ecdsa_sign_setup/complete_mb8(): \n");
   if(1 != test_mbx_nistp384_ecdsa_sign2(ctx)) goto err;

err:
   release_nistp384();
   BN_CTX_free(ctx);

   return 0;
}
