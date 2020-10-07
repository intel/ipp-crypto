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
//  Purpose: CPU features
// 
*/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

#include <crypto_mb/cpu_features.h>


int main(void)
{
   int64u cpu_features = mbx_get_cpu_features();
   printf(" mb cpu features: 0x%016llx\n\n", cpu_features);

   int64u m;

   printf("cpu features details:\n");
   m = cpu_features & mbcpCPUID_MMX;               printf("  mbcpCPUID_MMX             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSE;               printf("  mbcpCPUID_SSE             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSE2;              printf("  mbcpCPUID_SSE2            = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSE3;              printf("  mbcpCPUID_SSE3            = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSSE3;             printf("  mbcpCPUID_SSS3E           = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_MOVBE;             printf("  mbcpCPUID_MOVBE           = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSE41;             printf("  mbcpCPUID_SSE41           = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SSE42;             printf("  mbcpCPUID_SSE41           = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX;               printf("  mbcpCPUID_AVX             = %d\n", (m!=0));
   m = cpu_features & mbcpAVX_ENABLEDBYOS;         printf("  mbcpAVX_ENABLEDBYOS       = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AES;               printf("  mbcpCPUID_AES             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_CLMUL;             printf("  mbcpCPUID_CLMUL           = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_ABR;               printf("  mbcpCPUID_ABR             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_RDRAND;            printf("  mbcpCPUID_RDRAND          = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_F16C;              printf("  mbcpCPUID_F16C            = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX2;              printf("  mbcpCPUID_AVX2            = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_ADX;               printf("  mbcpCPUID_ADX             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_RDSEED;            printf("  mbcpCPUID_RDSEED          = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_PREFETCHW;         printf("  mbcpCPUID_PREFETCHW       = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_SHA;               printf("  mbcpCPUID_SHA             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512F;           printf("  mbcpCPUID_VAX512F         = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512CD;          printf("  mbcpCPUID_VAX512CD        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512ER;          printf("  mbcpCPUID_VAX512ER        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512PF;          printf("  mbcpCPUID_VAX512PF        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512BW;          printf("  mbcpCPUID_VAX512BW        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512DQ;          printf("  mbcpCPUID_VAX512DQ        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512VL;          printf("  mbcpCPUID_VAX512VL        = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512VBMI;        printf("  mbcpCPUID_VAX512VBMI      = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_MPX;               printf("  mbcpCPUID_MPX             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512_4FMADDPS;   printf("  mbcpCPUID_VAX512_4FMADDPS = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512_4VNNIW;     printf("  mbcpCPUID_VAX512_4VNNIW   = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_KNC;               printf("  mbcpCPUID_KNC             = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512IFMA;        printf("  mbcpCPUID_VAX512IFMA      = %d\n", (m!=0));
   m = cpu_features & mbcpAVX512_ENABLEDBYOS;      printf("  mbcpAX512_ENABLEDBYOS     = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512GFNI;        printf("  mbcpCPUID_VAX512GFNI      = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512VAES;        printf("  mbcpCPUID_VAX512VAES      = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512VCLMUL;      printf("  mbcpCPUID_VAX512VCLMUL    = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_AVX512VBMI2;       printf("  mbcpCPUID_VAX512VBMI2     = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_BMI1;              printf("  mbcpCPUID_BMI1            = %d\n", (m!=0));
   m = cpu_features & mbcpCPUID_BMI2;              printf("  mbcpCPUID_BMI2            = %d\n", (m!=0));

   printf("use detected features:\n");
   printf("mb cpu features: 0x%016llx crypto_mb is ", cpu_features);
   if(mbx_is_crypto_mb_applicable(cpu_features))
      printf("applicable\n");
   else
      printf("not applicable\n");

   int64u flip_feature[] = {
      mbcpCPUID_BMI2,
      mbcpCPUID_AVX512F,
      mbcpCPUID_AVX512DQ,
      mbcpCPUID_AVX512BW,
      mbcpCPUID_AVX512IFMA,
      mbcpCPUID_AVX512VBMI2,
      mbcpAVX512_ENABLEDBYOS,
      mbcpCPUID_SHA
   };
   printf("flip cpu feature:\n");
   int n;

   for(n=0; n<sizeof(flip_feature)/sizeof(int64u); n++) {
      int64u features = cpu_features^flip_feature[n];
      printf(" mb modified cpu features: 0x%016llx crypto_mb is ", features);
      if(mbx_is_crypto_mb_applicable(features))
         printf("applicable\n");
      else
         printf("not applicable\n");
   }

   printf("uniniialized cpu feature:\n");
   printf("crypto_mb is ");
   if( mbx_is_crypto_mb_applicable(0))
      printf("applicable\n");
   else
      printf("not applicable\n");

   return 0;
}
