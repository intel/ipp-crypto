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

#include <crypto_mb/x25519.h>


extern BN_ULONG* bn_get_words(const BIGNUM* bn);


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
//////////////////////////////////////////////////////////////////////////////////////////

int8u kat_privA1[] =
   "\x77\x07\x6d\x0a\x73\x18\xa5\x7d\x3c\x16\xc1\x72\x51\xb2\x66\x45"
   "\xdf\x4c\x2f\x87\xeb\xc0\x99\x2a\xb1\x77\xfb\xa5\x1d\xb9\x2c\x2a";
int8u kat_pubA1[] = 
   "\x85\x20\xf0\x09\x89\x30\xa7\x54\x74\x8b\x7d\xdc\xb4\x3e\xf7\x5a"
   "\x0d\xbf\x3a\x0d\x26\x38\x1a\xf4\xeb\xa4\xa9\x8e\xaa\x9b\x4e\x6a";

int8u kat_privB1[] =
   "\x5d\xab\x08\x7e\x62\x4a\x8a\x4b\x79\xe1\x7f\x8b\x83\x80\x0e\xe6"
   "\x6f\x3b\xb1\x29\x26\x18\xb6\xfd\x1c\x2f\x8b\x27\xff\x88\xe0\xeb";
int8u kat_pubB1[] = 
   "\xde\x9e\xdb\x7d\x7b\x7d\xc1\xb4\xd3\x5b\x61\xc2\xec\xe4\x35\x37"
   "\x3f\x83\x43\xc8\x5b\x78\x67\x4d\xad\xfc\x7e\x14\x6f\x88\x2b\x4f";

int8u kat_shared1[] =
   "\x4a\x5d\x9d\x5b\xa4\xce\x2d\xe1\x72\x8e\x3b\xf4\x80\x35\x0f\x25"
   "\xe0\x7e\x21\xc9\x47\xd1\x9e\x33\x76\xf0\x9b\x3c\x1e\x16\x17\x42";

/////
int8u kat_priv_GO_1[] = "\xa8\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab"
                        "\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\xab\x6b";
int8u kat_pub_GO_1[] = "\xe3\x71\x2d\x85\x1a\x0e\x5d\x79\xb8\x31\xc5\xe3\x4a\xb2\x2b\x41"
                       "\xa1\x98\x17\x1d\xe2\x09\xb8\xb8\xfa\xca\x23\xa1\x1c\x62\x48\x59";

int8u kat_priv_GO_2[] = "\xc8\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
                        "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\x4d";
int8u kat_pub_GO_2[] = "\xb5\xbe\xa8\x23\xd9\xc9\xff\x57\x60\x91\xc5\x4b\x7c\x59\x6c\x0a"
                       "\xe2\x96\x88\x4f\x0e\x15\x02\x90\xe8\x84\x55\xd7\xfb\xa6\x12\x6f";

///////////////// RFC7748-1
int8u kat_privA2[] =
   "\xa5\x46\xe3\x6b\xf0\x52\x7c\x9d\x3b\x16\x15\x4b\x82\x46\x5e\xdd"
   "\x62\x14\x4c\x0a\xc1\xfc\x5a\x18\x50\x6a\x22\x44\xba\x44\x9a\xc4";

int8u kat_pubB2[] = 
   "\xe6\xdb\x68\x67\x58\x30\x30\xdb\x35\x94\xc1\xa4\x24\xb1\x5f\x7c"
   "\x72\x66\x24\xec\x26\xb3\x35\x3b\x10\xa9\x03\xa6\xd0\xab\x1c\x4c";

int8u kat_shared2[] =
   "\xc3\xda\x55\x37\x9d\xe9\xc6\x90\x8e\x94\xea\x4d\xf2\x8d\x08\x4f"
   "\x32\xec\xcf\x03\x49\x1c\x71\xf7\x54\xb4\x07\x55\x77\xa2\x85\x52";

///////////////// RFC7748-2
int8u kat_privA3[] =
   "\x4b\x66\xe9\xd4\xd1\xb4\x67\x3c\x5a\xd2\x26\x91\x95\x7d\x6a\xf5"
   "\xc1\x1b\x64\x21\xe0\xea\x01\xd4\x2c\xa4\x16\x9e\x79\x18\xba\x0d";

int8u kat_pubB3[] = 
   "\xe5\x21\x0f\x12\x78\x68\x11\xd3\xf4\xb7\x95\x9d\x05\x38\xae\x2c"
   "\x31\xdb\xe7\x10\x6f\xc0\x3c\x3e\xfc\x4c\xd5\x49\xc7\x15\xa4\x93";

int8u kat_shared3[] =
   "\x95\xcb\xde\x94\x76\xe8\x90\x7d\x7a\xad\xe4\x5c\xb4\xb8\x73\xf8"
   "\x8b\x59\x5a\x68\x79\x9f\xa1\x52\xe6\xf8\xf7\x64\x7a\xac\x79\x57";

////////////////////
int8u kat_privA4[] =
   "\x77\x07\x6d\x0a\x73\x18\xa5\x7d\x3c\x16\xc1\x72\x51\xb2\x66\x45"
   "\xdf\x4c\x2f\x87\xeb\xc0\x99\x2a\xb1\x77\xfb\xa5\x1d\xb9\x2c\x2a";

int8u kat_pubA4[] =
   "\x85\x20\xf0\x09\x89\x30\xa7\x54\x74\x8b\x7d\xdc\xb4\x3e\xf7\x5a"
   "\x0d\xbf\x3a\x0d\x26\x38\x1a\xf4\xeb\xa4\xa9\x8e\xaa\x9b\x4e\x6a";

int8u kat_privB4[] =
   "\x5d\xab\x08\x7e\x62\x4a\x8a\x4b\x79\xe1\x7f\x8b\x83\x80\x0e\xe6"
   "\x6f\x3b\xb1\x29\x26\x18\xb6\xfd\x1c\x2f\x8b\x27\xff\x88\xe0\xeb";

int8u kat_pubB4[] =
   "\xde\x9e\xdb\x7d\x7b\x7d\xc1\xb4\xd3\x5b\x61\xc2\xec\xe4\x35\x37"
   "\x3f\x83\x43\xc8\x5b\x78\x67\x4d\xad\xfc\x7e\x14\x6f\x88\x2b\x4f";

int8u kat_shared4[] =
   "\x4a\x5d\x9d\x5b\xa4\xce\x2d\xe1\x72\x8e\x3b\xf4\x80\x35\x0f\x25"
   "\xe0\x7e\x21\xc9\x47\xd1\x9e\x33\x76\xf0\x9b\x3c\x1e\x16\x17\x42";
//////////////////////////////////////////////////////////////////////////////////////////

//
// A party keys
//
int8u privateA_key[8][32];
int8u* pa_privA[8] = {
      privateA_key[0], privateA_key[1], privateA_key[2], privateA_key[3],
      privateA_key[4], privateA_key[5], privateA_key[6], privateA_key[7]
};

// computed public keys
int8u publicA_key[8][32];
int8u* pa_pubA[8] = {
      publicA_key[0], publicA_key[1], publicA_key[2], publicA_key[3],
      publicA_key[4], publicA_key[5], publicA_key[6], publicA_key[7]
};

// computed shared secrets
int8u sharedA_key[8][32];
int8u* pa_sharedA[8] = {
      sharedA_key[0], sharedA_key[1], sharedA_key[2], sharedA_key[3],
      sharedA_key[4], sharedA_key[5], sharedA_key[6], sharedA_key[7]
};

//
// B party keys
//
int8u privateB_key[8][32];
int8u* pa_privB[8] = {
      privateB_key[0], privateB_key[1], privateB_key[2], privateB_key[3],
      privateB_key[4], privateB_key[5], privateB_key[6], privateB_key[7]
};

// computed public keys
int8u publicB_key[8][32];
int8u* pa_pubB[8] = {
      publicB_key[0], publicB_key[1], publicB_key[2], publicB_key[3],
      publicB_key[4], publicB_key[5], publicB_key[6], publicB_key[7]
};

// computed shared secrets
int8u sharedB_key[8][32];
int8u* pa_sharedB[8] = {
      sharedB_key[0], sharedB_key[1], sharedB_key[2], sharedB_key[3],
      sharedB_key[4], sharedB_key[5], sharedB_key[6], sharedB_key[7]
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct {
   int8u* name;
   int8u* secret;
   int8u* public;
} kat_x25519_public;

kat_x25519_public vector_public[] = {
   {"vec1", kat_privA1, kat_pubA1},
   {"vec2", kat_privB1, kat_pubB1},
   {"NACL vec1", kat_privA4, kat_pubA4},
   {"NACL vec2", kat_privB4, kat_pubB4},
   {"GO vec1", kat_priv_GO_1, kat_pub_GO_1},
   {"GO vec2", kat_priv_GO_2, kat_pub_GO_2},
};

int test_mbx_x25519_public_key_mb8(kat_x25519_public* kat)
{
   if(kat->name)
      printf("%s: ", kat->name);

   int i, resflag;

   // set up secret if defined and computes public
   memset(privateA_key, 0, sizeof(privateA_key));
   for(i=0; i<8; i++)
      memcpy(pa_privA[i], kat->secret, 32);

   mbx_x25519_public_key_mb8(pa_pubA, (const int8u* const*)pa_privA);

   // compare with kat
   resflag = 1;
   for(i=0; i<8 && resflag; i++) {
      resflag = 0==memcmp(pa_pubA[i], kat->public, 32);
      if(1!=resflag)
         printf("public key error at [%d] entry\n", i);
   }

   if(1==resflag)
      printf("passed\n");

   return resflag;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct {
   int8u* name;
   int8u* own_secret;
   int8u* party_public;
   int8u* shared;
} kat_x25519_shared;

kat_x25519_shared vector_shared[] = {
   {"vec1", kat_privA1, kat_pubB1, kat_shared1},
   {"vec2", kat_privB1, kat_pubA1, kat_shared1},
   {"RFC7748-1", kat_privA2, kat_pubB2, kat_shared2},
   {"RFC7748-2", kat_privA3, kat_pubB3, kat_shared3},
   {"NACL vec1", kat_privA4, kat_pubB4, kat_shared4},
   {"NACL vec2", kat_privB4, kat_pubA4, kat_shared4},
};

int test_mbx_x25519_mb8(kat_x25519_shared* kat)
{
   if(kat->name)
      printf("%s: ", kat->name);

   int i, resflag;

   // set up own secret
   memset(privateA_key, 0, sizeof(privateA_key));
   memset(publicB_key, 0, sizeof(publicB_key));
   memset(sharedA_key, 0, sizeof(sharedA_key));
   for(i=0; i<8; i++) {
      memcpy(pa_privA[i], kat->own_secret, 32);
      memcpy(pa_pubB[i], kat->party_public, 32);
   }

   mbx_x25519_mb8(pa_sharedA, (const int8u* const*)pa_privA, (const int8u* const*)pa_pubB);

   // compare with kat
   resflag = 1;
   for(i=0; i<8 && resflag; i++) {
      resflag = 0==memcmp(pa_sharedA[i], kat->shared, 32);
      if(1!=resflag)
         printf("shared key error at [%d] entry\n", i);
   }

   if(1==resflag)
      printf("passed\n");

   return resflag;
}


int reps_mbx_x25519_mb8(int n, int8u* kat)
{
   memset(privateA_key, 0, sizeof(privateA_key));
   memset(publicB_key, 0, sizeof(publicB_key));
   int i;
   for(i=0; i<8; i++) {
      pa_privA[i][0] = 9;
      pa_pubB[i][0] = 9;
   }

   for(i=0; i<n; i++) {
      mbx_x25519_mb8(pa_sharedA, (const int8u* const*)pa_privA, (const int8u* const*)pa_pubB);
      memcpy(publicB_key, privateA_key, sizeof(privateA_key));
      memcpy(privateA_key, sharedA_key, sizeof(sharedA_key));
   }
   
   int resflag = 1;
   for(i=0; i<8 && resflag; i++) {
      resflag = 0==memcmp(pa_sharedA[i], kat, 32);
      if(1!=resflag)
         printf("shared key error at [%d] entry\n", i);
   }

   if(1==resflag)
      printf("passed\n");

   return resflag;
}

static int8u* rand_32_bytes(int8u* data)
{
   int i;
   for(i=0; i<32; i++)
      data[i] = (int8u)rand();
   return data;
}

int rand_mbx_x25519_mb8(int n)
{
   int resflag;
   int i;
   for(i=0, resflag=1; i<n && resflag; i++) {
      memset(privateA_key, 0, sizeof(privateA_key));
      memset(privateB_key, 0, sizeof(privateB_key));

      memset(publicA_key, 0, sizeof(publicA_key));
      memset(publicB_key, 0, sizeof(publicB_key));

      memset(sharedA_key, 0, sizeof(sharedA_key));
      memset(sharedB_key, 0, sizeof(sharedB_key));

      // random secret
      int8u buff[32];
      int buf_no;
      for(buf_no=0; buf_no<8; buf_no++) {
         rand_32_bytes(buff);
         memcpy(pa_privA[buf_no], buff, 32);

         rand_32_bytes(buff);
         memcpy(pa_pubB[buf_no], buff, 32);
      }

      // A's public
      mbx_x25519_public_key_mb8(pa_pubA, (const int8u* const*)pa_privA);
      // B's public
      mbx_x25519_public_key_mb8(pa_pubB, (const int8u* const*)pa_privB);

      // A's shared
      mbx_x25519_mb8(pa_sharedA, (const int8u* const*)pa_privA, (const int8u* const*)pa_pubB);
      // B's shared
      mbx_x25519_mb8(pa_sharedB, (const int8u* const*)pa_privB, (const int8u* const*)pa_pubA);

      // make sure shared are the same
      for(buf_no=0; buf_no<8 && resflag; buf_no++) {
         resflag = 0==memcmp(pa_sharedA[buf_no], pa_sharedB[buf_no], 32);
         if(1!=resflag)
            printf("shared key error at [%d] entry\n", buf_no);
      }
   }

   if(1==resflag)
      printf("passed\n");

   return resflag;
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////

int main(void)
{
   char seed_info[] = "tests_of_mbx_x25519 ...";
   RAND_seed(seed_info, sizeof(seed_info));

   printf("\n=== test mbx_x25519_public_key_mb8()) ===\n");
   test_mbx_x25519_public_key_mb8(&vector_public[0]);
   test_mbx_x25519_public_key_mb8(&vector_public[1]);
   test_mbx_x25519_public_key_mb8(&vector_public[2]);
   test_mbx_x25519_public_key_mb8(&vector_public[3]);
   test_mbx_x25519_public_key_mb8(&vector_public[4]);
   test_mbx_x25519_public_key_mb8(&vector_public[5]);

   printf("\n=== test mbx_x25519_mb8() ===\n");
   test_mbx_x25519_mb8(&vector_shared[0]);
   test_mbx_x25519_mb8(&vector_shared[1]);
   test_mbx_x25519_mb8(&vector_shared[2]);
   test_mbx_x25519_mb8(&vector_shared[3]);
   test_mbx_x25519_mb8(&vector_shared[4]);
   test_mbx_x25519_mb8(&vector_shared[5]);

   printf("\n=== test repetition_1 mbx_x25519_mb8() ===\n");
   int8u res_1_times[] = "\x42\x2c\x8e\x7a\x62\x27\xd7\xbc\xa1\x35\x0b\x3e\x2b\xb7\x27\x9f"
                         "\x78\x97\xb8\x7b\xb6\x85\x4b\x78\x3c\x60\xe8\x03\x11\xae\x30\x79";
   reps_mbx_x25519_mb8(1, res_1_times);

   printf("\n=== test repetition_1000 mbx_x25519_mb8() ===\n");
   int8u res_1000_times[] = "\x68\x4c\xf5\x9b\xa8\x33\x09\x55\x28\x00\xef\x56\x6f\x2f\x4d\x3c"
                            "\x1c\x38\x87\xc4\x93\x60\xe3\x87\x5f\x2e\xb9\x4d\x99\x53\x2c\x51";
   reps_mbx_x25519_mb8(1000, res_1000_times);

   printf("\n=== test repetition_1000000 mbx_x25519_mb8() ===\n");
   int8u res_1000000_times[] = "\x7c\x39\x11\xe0\xab\x25\x86\xfd\x86\x44\x97\x29\x7e\x57\x5e\x6f"
                               "\x3b\xc6\x01\xc0\x88\x3c\x30\xdf\x5f\x4d\xd2\xd2\x4f\x66\x54\x24";
   reps_mbx_x25519_mb8(1000000, res_1000000_times);

   // random tests
   printf("\n=== test 100 random {mbx_x25519_public_key_mb8() and mbx_x25519_mb8()} ===\n");
   rand_mbx_x25519_mb8(100);

   return 0;
}
