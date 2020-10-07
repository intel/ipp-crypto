/*******************************************************************************
* Copyright 2002-2020 Intel Corporation
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

#include <internal/ecnist/ifma_arith_p256.h>

/* Constants */
#define LEN52    NUMBER_OF_DIGITS(256,DIGIT_SIZE)

/*
// EC NIST-P256 prime base point order
// in 2^52 radix
*/
__ALIGN64 static const int64u n256_mb[LEN52][8] = {
   {0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551, 0x9cac2fc632551},
   {0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b, 0xada7179e84f3b},
   {0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa, 0xfffffffbce6fa},
   {0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff, 0x0000fffffffff},
   {0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000, 0x0ffffffff0000}
};

/* k0 = -( (1/n256 mod 2^DIGIT_SIZE) ) mod 2^DIGIT_SIZE */
__ALIGN64 static const int64u n256_k0_mb[8] = {
   0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f, 0x1c8aaee00bc4f
};

/* to Montgomery conversion constant
// rr = 2^((LEN52*DIGIT_SIZE)*2) mod n256
*/
__ALIGN64 static const int64u n256_rr_mb[LEN52][8] = {
   {0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba,0x0005cc0dea6dc3ba},
   {0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084,0x000192a067d8a084},
   {0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb,0x000bec59615571bb},
   {0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6,0x0001fc245b2392b6},
   {0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956,0x0000e12d9559d956}
};


/*=====================================================================

 Specialized single operations in n256 - sqr & mul

=====================================================================*/
EXTERN_C U64* MB_FUNC_NAME(ifma_n256_)(void)
{
   return (U64*)n256_mb;
}

void MB_FUNC_NAME(ifma_ams52_n256_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_ams52x5_)(r, a, (U64*)n256_mb, n256_k0_mb);
}

void MB_FUNC_NAME(ifma_amm52_n256_)(U64 r[], const U64 a[], const U64 b[])
{
   MB_FUNC_NAME(ifma_amm52x5_)(r, a, b, (U64*)n256_mb, n256_k0_mb);
}

void MB_FUNC_NAME(ifma_tomont52_n256_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52x5_)(r, a, (U64*)n256_rr_mb, (U64*)n256_mb, n256_k0_mb);
}

void MB_FUNC_NAME(ifma_frommont52_n256_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52_n256_)(r, a, (U64*)ones);
}

/*
// computes r = 1/z = z^(n256-2) mod n256
//
// note: z in in Montgomery domain (as soon mul() and sqr() below are amm-functions
//       r in Montgomery domain too
*/
#define sqr_n256    MB_FUNC_NAME(ifma_ams52_n256_)
#define mul_n256    MB_FUNC_NAME(ifma_amm52_n256_)

void MB_FUNC_NAME(ifma_aminv52_n256_)(U64 r[], const U64 z[])
{
   int i;

   // pwr_z_Tbl[i][] = z^i, i=0,..,15
   __ALIGN64 U64 pwr_z_Tbl[16][LEN52];

   MB_FUNC_NAME(ifma_tomont52_n256_)(pwr_z_Tbl[0], (U64*)ones);
   MB_FUNC_NAME(mov_FE256_)(pwr_z_Tbl[1], z);

   for(i=2; i<16; i+=2) {
      sqr_n256(pwr_z_Tbl[i], pwr_z_Tbl[i/2]);
      mul_n256(pwr_z_Tbl[i+1], pwr_z_Tbl[i], z);
   }

   // pwr = (n256-2) in big endian
   int8u pwr[] = "\xFF\xFF\xFF\xFF\x00\x00\x00\x00"
                 "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
                 "\xBC\xE6\xFA\xAD\xA7\x17\x9E\x84"
                 "\xF3\xB9\xCA\xC2\xFC\x63\x25\x4F";
   // init r = 1
   MB_FUNC_NAME(mov_FE256_)(r, pwr_z_Tbl[0]);

   for(i=0; i<32; i++) {
      int v = pwr[i];
      int hi = (v>>4) &0xF;
      int lo = v & 0xF;

      sqr_n256(r, r);
      sqr_n256(r, r);
      sqr_n256(r, r);
      sqr_n256(r, r);
      if(hi)
         mul_n256(r, r, pwr_z_Tbl[hi]);
      sqr_n256(r, r);
      sqr_n256(r, r);
      sqr_n256(r, r);
      sqr_n256(r, r);
      if(lo)
         mul_n256(r, r, pwr_z_Tbl[lo]);
   }
}

/*=====================================================================

 Specialized single operations in n256 - add, sub & neg

=====================================================================*/

void MB_FUNC_NAME(ifma_add52_n256_)(U64 r[], const U64 a[], const U64 b[])
{
   MB_FUNC_NAME(ifma_add52x5_)(r, a, b, (U64*)n256_mb);
}

void MB_FUNC_NAME(ifma_sub52_n256_)(U64 r[], const U64 a[], const U64 b[])
{
   MB_FUNC_NAME(ifma_sub52x5_)(r, a, b, (U64*)n256_mb);
}

void MB_FUNC_NAME(ifma_neg52_n256_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_neg52x5_)(r, a, (U64*)n256_mb);
}
