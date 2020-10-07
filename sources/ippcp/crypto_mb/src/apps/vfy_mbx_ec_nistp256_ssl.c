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
#include <crypto_mb/ec_nistp256.h>

// EC NIST-P256 parameters
static const int8u p_nistp256[] = "FFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF";
static const int8u a_nistp256[] = "FFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC";
static const int8u b_nistp256[] = "5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B";

static const int8u gx_nistp256[] = "6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296";
static const int8u gy_nistp256[] = "4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5";
static const int8u  n_nistp256[] = "FFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551";
static const int8u  h_nistp256[] = "01";

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

static void new_nistp256(BN_CTX* ctx)
{
   P = BN_new();
   A = BN_new();
   B = BN_new();
   Gx= BN_new();
   Gy= BN_new();
   N = BN_new();

   //EC = EC_GROUP_new( EC_GFp_simple_method() );
   EC = EC_GROUP_new( EC_GFp_mont_method() );
   BN_hex2bn(&P, (char*)p_nistp256);
   BN_hex2bn(&A, (char*)a_nistp256);
   BN_hex2bn(&B, (char*)b_nistp256);
   EC_GROUP_set_curve_GFp(EC, P, A, B, ctx);

   G = EC_POINT_new(EC);
   BN_hex2bn(&Gx, (char*)gx_nistp256);
   BN_hex2bn(&Gy, (char*)gy_nistp256);
   BN_hex2bn( &N,  (char*)n_nistp256);
   EC_POINT_set_affine_coordinates_GFp(EC, G, Gx, Gy, ctx);
   EC_GROUP_set_generator(EC, G, N, BN_value_one());
}

static void release_nistp256(void)
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


#define MAX_TEST_ROUND (100) //(10000)

#define A_COORDS  (0)   // use affine accodinates
#define J_COORDS  (1)   // use Jacobian projective accodinates

static int test_mbx_nistp256_ecpublic_key_ssl(BN_CTX* ctx, int coord_mode)
{
   int res = 1;
   const int num_tests = MAX_TEST_ROUND;

   EC_KEY* keyA = EC_KEY_new();
   EC_KEY_set_group(keyA, EC);

   /* array of private keys */
   BIGNUM* prvA[8] = {0};

   /* array of public keys coordinates */
   BIGNUM* pubAx[8] = {0};
   BIGNUM* pubAy[8] = {0};
   BIGNUM* pubAz[8] = {0};

   /* array of ifma's points Jacobian coordinates */
   BIGNUM* ifma_bnrx[8] = {0};
   BIGNUM* ifma_bnry[8] = {0};
   BIGNUM* ifma_bnrz[8] = {0};

   EC_POINT* publicSSL = EC_POINT_new(EC);
   EC_POINT* publicCMB = EC_POINT_new(EC); // crypto_mb

   for(int n=0; n<num_tests && res; n++) {

      for(int i=0; i<8; i++) {
         // private keys
         prvA[i] = BN_new();

         // public A components
         pubAx[i] = BN_new();
         pubAy[i] = BN_new();
         pubAz[i] = BN_new();

         // ifma's public components
         ifma_bnrx[i] = BN_new();
         ifma_bnry[i] = BN_new();
         ifma_bnrz[i] = BN_new();

         // generate key pairs
         EC_KEY_generate_key(keyA);

         // extract private keys and store
         BN_copy(prvA[i], EC_KEY_get0_private_key(keyA));

         // extract public key and store it projective/affine coordinates
         if(J_COORDS == coord_mode)
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), pubAx[i], pubAy[i], pubAz[i], ctx);
         else
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), pubAx[i], pubAy[i], ctx);
      }

      // ifma pub key
      if(J_COORDS == coord_mode)
         mbx_nistp256_ecpublic_key_ssl_mb8(ifma_bnrx, ifma_bnry, ifma_bnrz, (const BIGNUM **)prvA, 0);
      else
         mbx_nistp256_ecpublic_key_ssl_mb8(ifma_bnrx, ifma_bnry, 0, (const BIGNUM **)prvA, 0);

      // compare results
      if(J_COORDS == coord_mode)
         for(int i=0; i<8 && res; i++) {
            EC_POINT_set_Jprojective_coordinates_GFp(EC, publicSSL, pubAx[i],     pubAy[i],     pubAz[i],     ctx);
            EC_POINT_set_Jprojective_coordinates_GFp(EC, publicCMB, ifma_bnrx[i], ifma_bnry[i], ifma_bnrz[i], ctx);
            res = (0 == EC_POINT_cmp(EC, publicSSL, publicCMB, ctx));
         }
      else
         for(int i=0; i<8 && res; i++) {
            EC_POINT_set_affine_coordinates_GFp(EC, publicSSL, pubAx[i],     pubAy[i],     ctx);
            EC_POINT_set_affine_coordinates_GFp(EC, publicCMB, ifma_bnrx[i], ifma_bnry[i], ctx);
            res = (0 == EC_POINT_cmp(EC, publicSSL, publicCMB, ctx));
         }

      printf("test %03d:", n);
      if(1==res)
         printf("passed\n");
      else
         printf("failed\n");

      // release resources
      for(int i=0; i<8; i++) {
         BN_free(ifma_bnrz[i]);
         BN_free(ifma_bnry[i]);
         BN_free(ifma_bnrx[i]);

         BN_free(pubAz[i]);
         BN_free(pubAy[i]);
         BN_free(pubAx[i]);

         BN_free(prvA[i]);
      }
   }

   EC_KEY_free(keyA);

   return res;
}

static int test_mbx_nistp256_ecdh_ssl(BN_CTX* ctx, int coord_mode)
{
   int res = 1;
   const int num_tests = MAX_TEST_ROUND;

   EC_KEY* keyA = EC_KEY_new();
   EC_KEY* keyB = EC_KEY_new();
   EC_KEY_set_group(keyA, EC);
   EC_KEY_set_group(keyB, EC);

   /* array of private keys */
   BIGNUM* prvA[8] = {0};
   BIGNUM* prvB[8] = {0};

   /* array of public keys coordinates */
   BIGNUM* pubAx[8] = {0};
   BIGNUM* pubAy[8] = {0};
   BIGNUM* pubAz[8] = {0};

   BIGNUM* pubBx[8] = {0};
   BIGNUM* pubBy[8] = {0};
   BIGNUM* pubBz[8] = {0};

   /* shared keys */
   int8u sharedAB[8][32];
   int8u sharedBA[8][32];

   /* ifma params */
   BIGNUM* pa_ephA[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_ephB[] = {0,0,0,0,0,0,0,0};

   BIGNUM* pa_pubAx[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_pubAy[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_pubAz[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_pubBx[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_pubBy[] = {0,0,0,0,0,0,0,0};
   BIGNUM* pa_pubBz[] = {0,0,0,0,0,0,0,0};

   /* array of ifma's points affine coordinates */
   int8u ifma_sharedAB[8][32];
   int8u ifma_sharedBA[8][32];
   int8u* pa_ifma_sharedAB[8] = {ifma_sharedAB[0],ifma_sharedAB[1],ifma_sharedAB[2],ifma_sharedAB[3],
                                 ifma_sharedAB[4],ifma_sharedAB[5],ifma_sharedAB[6],ifma_sharedAB[7]};
   int8u* pa_ifma_sharedBA[8] = {ifma_sharedBA[0],ifma_sharedBA[1],ifma_sharedBA[2],ifma_sharedBA[3],
                                 ifma_sharedBA[4],ifma_sharedBA[5],ifma_sharedBA[6],ifma_sharedBA[7]};

   for(int n=0; n<num_tests && res; n++) {
      memset(sharedAB, 0, sizeof(sharedAB));
      memset(sharedBA, 0, sizeof(sharedBA));

      memset(ifma_sharedAB, 0, sizeof(ifma_sharedAB));
      memset(ifma_sharedBA, 0, sizeof(ifma_sharedBA));

      for(int i=0; i<8; i++) {
         // private A & B keys
         prvA[i] = BN_new();
         prvB[i] = BN_new();

         // public A & B components
         pubAx[i] = BN_new();
         pubAy[i] = BN_new();
         pubAz[i] = BN_new();
         pubBx[i] = BN_new();
         pubBy[i] = BN_new();
         pubBz[i] = BN_new();

         // generate key pairs
         EC_KEY_generate_key(keyA);
         EC_KEY_generate_key(keyB);

         // extract private keys and store pa_ephA[], pa_ephB[]
         BN_copy(prvA[i], EC_KEY_get0_private_key(keyA));
         BN_copy(prvB[i], EC_KEY_get0_private_key(keyB));
         pa_ephA[i] = prvA[i];
         pa_ephB[i] = prvB[i];

         // extract public key and store it projective/affine coordinates
         if(J_COORDS == coord_mode) {
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), pubAx[i], pubAy[i], pubAz[i], ctx);
            pa_pubAx[i] = pubAx[i];
            pa_pubAy[i] = pubAy[i];
            pa_pubAz[i] = pubAz[i];
            EC_POINT_get_Jprojective_coordinates_GFp(EC, EC_KEY_get0_public_key(keyB), pubBx[i], pubBy[i], pubBz[i], ctx);
            pa_pubBx[i] = pubBx[i];
            pa_pubBy[i] = pubBy[i];
            pa_pubBz[i] = pubBz[i];
         }
         else {
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyA), pubAx[i], pubAy[i], ctx);
            pa_pubAx[i] = pubAx[i];
            pa_pubAy[i] = pubAy[i];
            EC_POINT_get_affine_coordinates_GFp(EC, EC_KEY_get0_public_key(keyB), pubBx[i], pubBy[i], ctx);
            pa_pubBx[i] = pubBx[i];
            pa_pubBy[i] = pubBy[i];
         }

         // A-B shared
         ECDH_compute_key(sharedAB[i], 32, EC_KEY_get0_public_key(keyB), keyA, NULL);
         ECDH_compute_key(sharedBA[i], 32, EC_KEY_get0_public_key(keyA), keyB, NULL);
      }

      // ifma shared key
      if(J_COORDS == coord_mode) {
         mbx_nistp256_ecdh_ssl_mb8(pa_ifma_sharedAB, (const BIGNUM**)pa_ephA, (const BIGNUM**)pa_pubBx, (const BIGNUM**)pa_pubBy, (const BIGNUM**)pa_pubBz, 0);
         mbx_nistp256_ecdh_ssl_mb8(pa_ifma_sharedBA, (const BIGNUM**)pa_ephB, (const BIGNUM**)pa_pubAx, (const BIGNUM**)pa_pubAy, (const BIGNUM**)pa_pubAz, 0);
      }
      else {
         mbx_nistp256_ecdh_ssl_mb8(pa_ifma_sharedAB, (const BIGNUM**)pa_ephA, (const BIGNUM**)pa_pubBx, (const BIGNUM**)pa_pubBy, NULL, 0);
         mbx_nistp256_ecdh_ssl_mb8(pa_ifma_sharedBA, (const BIGNUM**)pa_ephB, (const BIGNUM**)pa_pubAx, (const BIGNUM**)pa_pubAy, NULL, 0);
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

      // release resources
      for(int i=0; i<8; i++) {
         BN_free(pubBz[i]);
         BN_free(pubBy[i]);
         BN_free(pubBx[i]);

         BN_free(pubAz[i]);
         BN_free(pubAy[i]);
         BN_free(pubAx[i]);

         BN_free(prvB[i]);
         BN_free(prvA[i]);
      }
   }

   EC_KEY_free(keyB);
   EC_KEY_free(keyA);

   return res;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

static int test_mbx_nistp256_ecdsa_sign_ssl(BN_CTX* ctx)
{
   // get order
   BIGNUM *order = BN_new();
   EC_GROUP_get_order(EC, order, 0);

   // messages & kat signatures
   int8u msg[8][256/8];
   int8u sign_r_kat[8][256/8];
   int8u sign_s_kat[8][256/8];

   // OpenSSL's regular key pairs
   EC_KEY* regKeyPair[8] ={0,0,0,0,0,0,0,0};
   // OpenSSL's regular & ephemeral private keys
   BIGNUM* bn_regk[8] = {0,0,0,0,0,0,0,0};
   BIGNUM* bn_k[8] = {0,0,0,0,0,0,0,0};

   // ifma's signatures
   int8u sign_r[8][256/8];
   int8u sign_s[8][256/8];
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
            BN_rand(bn_msg, 256, -1, 0);  // top and bottom bits could be zero
         BN_bn2bin(bn_msg, msg[i]+sizeof(msg[0])-BN_num_bytes(bn_msg));

         // generate regular key pair
         regKeyPair[i] = EC_KEY_new();
         EC_KEY_set_group(regKeyPair[i], EC);
         EC_KEY_generate_key(regKeyPair[i]);
         // get regerence to  regular private key
         bn_regk[i] = (BIGNUM*)( EC_KEY_get0_private_key(regKeyPair[i]) );

         // setup kinv and rp
         BIGNUM* bn_kinv = 0;
         BIGNUM* bn_rp = 0;
         ECDSA_sign_setup(regKeyPair[i], 0, &bn_kinv, &bn_rp);
         // restore k
         bn_k[i] = BN_new();
         BN_mod_inverse(bn_k[i], bn_kinv, order, ctx);

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

         // and convert to string
         BN_bn2bin(signR, sign_r_kat[i]+sizeof(sign_r_kat[0]) -BN_num_bytes(signR));
         BN_bn2bin(signS, sign_s_kat[i]+sizeof(sign_s_kat[0]) -BN_num_bytes(signS));

         BN_free(bn_kinv);
         BN_free(bn_rp);
      }

      // ifma_nistp256_ecdsa_sign_mb8
      memset(sign_r, 0, sizeof(sign_r));
      memset(sign_s, 0, sizeof(sign_s));

      mbx_nistp256_ecdsa_sign_ssl_mb8(pa_sign_r, pa_sign_s,
                                      (const int8u**)pa_msg,
                                      (const BIGNUM**)bn_k,
                                      (const BIGNUM**)bn_regk,
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
         BN_free(bn_k[i]);
         EC_KEY_free(regKeyPair[i]);
      }
   }

   BN_free(bn_add);
   BN_free(bn_msg);
   BN_free(order);

   return res;
}

static int test_mbx_nistp256_ecdsa_sign2_ssl(BN_CTX* ctx)
{
   // get order
   BIGNUM *order = BN_new();
   EC_GROUP_get_order(EC, order, 0);

   // messages & kat signatures
   int8u msg[8][256/8];
   int8u sign_r_kat[8][256/8];
   int8u sign_s_kat[8][256/8];

   // OpenSSL's regular key pairs
   EC_KEY* regKeyPair[8] ={0,0,0,0,0,0,0,0};
   // OpenSSL's regular and ephemeral private keys
   BIGNUM* bn_regk[8] = {0,0,0,0,0,0,0,0};
   BIGNUM* bn_k[8] = {0,0,0,0,0,0,0,0};

   // ifma's signatures
   int8u sign_r[8][256/8];
   int8u sign_s[8][256/8];
   int8u* pa_sign_r[8] = {sign_r[0], sign_r[1], sign_r[2], sign_r[3],
                          sign_r[4], sign_r[5], sign_r[6], sign_r[7]};
   int8u* pa_sign_s[8] = {sign_s[0], sign_s[1], sign_s[2], sign_s[3],
                          sign_s[4], sign_s[5], sign_s[6], sign_s[7]};
   int8u* pa_msg[8]    = {msg[0], msg[1], msg[2], msg[3],
                          msg[4], msg[5], msg[6], msg[7]};

   BIGNUM* bn_msg = BN_new();

   const int num_tests = MAX_TEST_ROUND;
   int res = 1;

   for(int n=0; n<num_tests && res; n++) {
      memset(msg, 0, sizeof(msg));
      memset(sign_r_kat, 0, sizeof(sign_r_kat));
      memset(sign_s_kat, 0, sizeof(sign_s_kat));

      printf("test %3d: ", n);

      for(int i=0; i<8; i++) {
         /* random message */
         if(n==0)
            BN_rand(bn_msg, 128, -1, 0);  // short message
         else
            BN_rand(bn_msg, 256, -1, 0);  // top and bottom bits could be zero
         BN_bn2bin(bn_msg, msg[i]+sizeof(msg[0])-BN_num_bytes(bn_msg));

         // generate regular key pair
         regKeyPair[i] = EC_KEY_new();
         EC_KEY_set_group(regKeyPair[i], EC);
         EC_KEY_generate_key(regKeyPair[i]);
         // get regerence to  regular private key
         bn_regk[i] = (BIGNUM*)( EC_KEY_get0_private_key(regKeyPair[i]) );

         // setup kinv and rp
         BIGNUM* bn_kinv = 0;
         BIGNUM* bn_rp = 0;
         ECDSA_sign_setup(regKeyPair[i], 0, &bn_kinv, &bn_rp);
         // restore k
         bn_k[i] = BN_new();
         BN_mod_inverse(bn_k[i], bn_kinv, order, ctx);

         // generate sign
         ECDSA_SIG* sign = 0;
         sign = ECDSA_do_sign_ex(msg[i], sizeof(msg[0]), bn_kinv, bn_rp, regKeyPair[i]);

         // reference to sign' components
         const BIGNUM* signR;
         const BIGNUM* signS;
         #if OPENSSL_VERSION_NUMBER < 0x10101000L
         ECDSA_SIG_get0(&signR, &signS, sign);
         #else
         ECDSA_SIG_get0(sign, &signR, &signS);
         #endif

         // and convert to string
         BN_bn2bin(signR, sign_r_kat[i]+sizeof(sign_r_kat[0]) -BN_num_bytes(signR));
         BN_bn2bin(signS, sign_s_kat[i]+sizeof(sign_s_kat[0]) -BN_num_bytes(signS));

         BN_free(bn_kinv);
         BN_free(bn_rp);
      }

      // ifma_nistp256_ecdsa_sign_setup_mb8(), ifma_nistp256_ecdsa_sign_complete_mb8()
      BIGNUM* pabn_inv_eph_key[8] = {0,0,0,0,0,0,0,0};
      BIGNUM* pabn_sign_rp[8]     = {0,0,0,0,0,0,0,0};
      mbx_nistp256_ecdsa_sign_setup_ssl_mb8(pabn_inv_eph_key,
                                            pabn_sign_rp,
                                            (const BIGNUM**)bn_k,
                                            0);
      memset(sign_r, 0, sizeof(sign_r));
      memset(sign_s, 0, sizeof(sign_s));
      mbx_nistp256_ecdsa_sign_complete_ssl_mb8(pa_sign_r, pa_sign_s,
                                               (const int8u**)pa_msg,
                                               (const BIGNUM**)pabn_sign_rp,
                                               (const BIGNUM**)pabn_inv_eph_key,
                                               (const BIGNUM**)bn_regk,
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
         BN_free(pabn_sign_rp[i]);     //pabn_sign_rp[i] = 0;
         BN_free(pabn_inv_eph_key[i]); //pabn_inv_eph_key[i] = 0;

         BN_free(bn_k[i]);
         EC_KEY_free(regKeyPair[i]);
      }
   }

   BN_free(bn_msg);
   BN_free(order);

   return res;
}

int main(void)
{
   char seed_info[] = "tests_of_mbx_ec_nistp256 ...";
   RAND_seed(seed_info, sizeof(seed_info));

   // vesrsion
   printf("%s\n", mbx_getversion()->strVersion);

   // set up parameters
   BN_CTX* ctx = BN_CTX_new();
   new_nistp256(ctx);
   ////////////////////////////

   printf("mbx_nistp256_ecpublic_key_ssl_mb8(projective_coordinates): \n");
   if(1 != test_mbx_nistp256_ecpublic_key_ssl(ctx, J_COORDS)) goto err;
   printf("mbx_nistp256_ecpublic_key_ssl_mb8(affine_coordinates): \n");
   if(1 != test_mbx_nistp256_ecpublic_key_ssl(ctx, A_COORDS)) goto err;

   printf("mbx_nistp256_ecdh_ssl_mb8(projective_coordinates): \n");
   if(1 != test_mbx_nistp256_ecdh_ssl(ctx, J_COORDS)) goto err;
   printf("mbx_nistp256_ecdh_ssl_mb8(affine_coordinates): \n");
   if(1 != test_mbx_nistp256_ecdh_ssl(ctx, A_COORDS)) goto err;

   printf("mbx_nistp256_ecdsa_sign_ssl_mb8(): \n");
   if(1 != test_mbx_nistp256_ecdsa_sign_ssl(ctx)) goto err;

   printf("mbx_nistp256_ecdsa_sign_setup/complete_ssl_mb8(): \n");
   if(1 != test_mbx_nistp256_ecdsa_sign2_ssl(ctx)) goto err;

err:
   release_nistp256();
   BN_CTX_free(ctx);

   return 0;
}
