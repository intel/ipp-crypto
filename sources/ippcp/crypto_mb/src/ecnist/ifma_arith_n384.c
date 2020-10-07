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

#include <internal/ecnist/ifma_arith_p384.h>

/* Constants */

/*
// // EC NIST-P384 prime base point order
// in 2^52 radix
*/
__ALIGN64 static const int64u n384_mb[P384_LEN52][8] = {
   { REP8_DECL(0x000c196accc52973) },
   { REP8_DECL(0x000b248b0a77aece) },
   { REP8_DECL(0x0004372ddf581a0d) },
   { REP8_DECL(0x000ffffc7634d81f) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x00000000000fffff) }
};

/* 2*n384 */
__ALIGN64 static const int64u n384_x2[P384_LEN52][sizeof(U64)/sizeof(int64u)] = {
   { REP8_DECL(0x000832d5998a52e6) },
   { REP8_DECL(0x0006491614ef5d9d) },
   { REP8_DECL(0x00086e5bbeb0341b) },
   { REP8_DECL(0x000ffff8ec69b03e) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x00000000001fffff) }
};
/* k0 = -( (1/n384 mod 2^DIGIT_SIZE) ) mod 2^DIGIT_SIZE */
__ALIGN64 static const int64u n384_k0_mb[8] = {
   REP8_DECL(0x00046089e88fdc45)
};

/* to Montgomery conversion constant
// rr = 2^((P384_LEN52*DIGIT_SIZE)*2) mod n384
*/
__ALIGN64 static const int64u n384_rr_mb[P384_LEN52][8] = {

   { REP8_DECL(0x00034124f50ddb2d) },
   { REP8_DECL(0x000c974971bd0d8d) },
   { REP8_DECL(0x0002118942bfd3cc) },
   { REP8_DECL(0x0009f43be8072178) },
   { REP8_DECL(0x0005bf030606de60) },
   { REP8_DECL(0x0000d49174aab1cc) },
   { REP8_DECL(0x000b7a28266895d4) },
   { REP8_DECL(0x000000000003fb05) }
};

/* ifma_tomont52_n384_(1) */
__ALIGN64 static const int64u n384_r_mb[P384_LEN52][8] = {

   { REP8_DECL(0x000ad68d00000000) },
   { REP8_DECL(0x000851313e695333) },
   { REP8_DECL(0x0007e5f24db74f58) },
   { REP8_DECL(0x000b27e0bc8d220a) },
   { REP8_DECL(0x000000000000389c) },
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x0000000000000000) }
};


/*=====================================================================

 Specialized single operations in n384 - sqr & mul

=====================================================================*/
void MB_FUNC_NAME(ifma_ams52_n384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52x8_)(r, a, a, (U64*)n384_mb, n384_k0_mb);
}

void MB_FUNC_NAME(ifma_amm52_n384_)(U64 r[], const U64 a[], const U64 b[])
{
   MB_FUNC_NAME(ifma_amm52x8_)(r, a, b, (U64*)n384_mb, n384_k0_mb);
}

void MB_FUNC_NAME(ifma_tomont52_n384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52_n384_)(r, a, (U64*)n384_rr_mb);
}

void MB_FUNC_NAME(ifma_frommont52_n384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52_n384_)(r, a, (U64*)ones);
}

/*
// computes r = 1/z = z^(n384-2) mod n384
//
// note: z in in Montgomery domain (as soon mul() and sqr() below are amm-functions
//       r in Montgomery domain too
*/
#define fe52_sqr    MB_FUNC_NAME(ifma_ams52_n384_)
#define fe52_mul    MB_FUNC_NAME(ifma_amm52_n384_)

/* r = base^(2^n) */
__INLINE void fe52_sqr_pwr(U64 r[], const U64 base[], int n)
{
   if(r!=base) {
      fe52_sqr(r,base);
      n--;
   }
   for(; n>0; n--)
      fe52_sqr(r,r);
}

void MB_FUNC_NAME(ifma_aminv52_n384_)(U64 r[], const U64 z[])
{
   int i;

   // pwr_z_Tbl[i][] = z^i, i=0,..,15
   __ALIGN64 U64 pwr_z_Tbl[16][P384_LEN52];
   __ALIGN64 U64  lexp[P384_LEN52];

   MB_FUNC_NAME(mov_FE384_)(pwr_z_Tbl[0], (U64*)n384_r_mb);
   MB_FUNC_NAME(mov_FE384_)(pwr_z_Tbl[1], z);

   for(i=2; i<16; i+=2) {
      fe52_sqr(pwr_z_Tbl[i], pwr_z_Tbl[i/2]);
      fe52_mul(pwr_z_Tbl[i+1], pwr_z_Tbl[i], z);
   }

   // pwr = (n384-2) in big endian
   int8u pwr[] = "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
                 "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
                 "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
                 "\xC7\x63\x4D\x81\xF4\x37\x2D\xDF"
                 "\x58\x1A\x0D\xB2\x48\xB0\xA7\x7A"
                 "\xEC\xEC\x19\x6A\xCC\xC5\x29\x71";

   /*
   // process low part of the exponent: "0xc7634d81f4372ddf 0x581a0db248b0a77a 0xecec196accc52973"
   */
   /* init result */
   MB_FUNC_NAME(mov_FE384_)(lexp, (U64*)n384_r_mb);

   for(i=24; i<sizeof(pwr)-1; i++) {
      int v = pwr[i];
      int hi = (v>>4) &0xF;
      int lo = v & 0xF;

      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      if(hi)
         fe52_mul(lexp, lexp, pwr_z_Tbl[hi]);
      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      fe52_sqr(lexp, lexp);
      if(lo)
         fe52_mul(lexp, lexp, pwr_z_Tbl[lo]);
   }

   /*
   // process high part of the exponent: "0xffffffffffffffff 0xffffffffffffffff 0xffffffffffffffff"
   */
   __ALIGN64 U64  u[P384_LEN52];
   __ALIGN64 U64  v[P384_LEN52];

   fe52_sqr(v, z);            /* v = z^2 */
   fe52_mul(u, v, z);         /* u = z^2 * z     = z^3  */

   fe52_sqr_pwr(v, u, 2);     /* v= (z^3)^(2^2) = z^12 */
   fe52_mul(u, v, u);         /* u = z^12 * z^3 = z^15 = z^(0xF) */

   fe52_sqr_pwr(v, u, 4);     /* v= (z^0xF)^(2^4) = z^(0xF0) */
   fe52_mul(u, v, u);         /* u = z^0xF0 * z^(0xF) = z^(0xFF) */

   fe52_sqr_pwr(v, u, 8);     /* v= (z^0xFF)^(2^8) = z^(0xFF00) */
   fe52_mul(u, v, u);         /* u = z^0xFF00 * z^(0xFF) = z^(0xFFFF) */

   fe52_sqr_pwr(v, u, 16);    /* v= (z^0xFFFF)^(2^16) = z^(0xFFFF0000) */
   fe52_mul(u, v, u);         /* u = z^0xFFFF0000 * z^(0xFFFF) = z^(0xFFFFFFFF) */

   fe52_sqr_pwr(v, u, 32);    /* v= (z^0xFFFFFFFF)^(2^32) = z^(0xFFFFFFFF00000000) */
   fe52_mul(u, v, u);         /* u = z^0xFFFFFFFF00000000 * z^(0xFFFFFFFF) = z^(0xFFFFFFFFFFFFFFFF) */

   fe52_sqr_pwr(v, u, 64);
   fe52_mul(v, v, u);         /* v = z^(0xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF) */

   fe52_sqr_pwr(v, v, 64);
   fe52_mul(v, v, u);         /* v = z^(0xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF) */

   /* combine low and high results */
   fe52_sqr_pwr(v, v, 64*3);  /* u = z^(0xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.0000000000000000.0000000000000000.0000000000000000) */
   fe52_mul(r, v, lexp);      /* r = z^(0xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.c7634d81f4372ddf.581a0db248b0a77a.ecec196accc52973) */
}

/*=====================================================================

 Specialized single operations in n384 - add, sub & neg

=====================================================================*/
static __mb_mask MB_FUNC_NAME(lt_mbx_digit_)(const U64 a, const U64 b, const __mb_mask lt_mask)
{
   U64 d = mask_sub64(sub64(a, b), lt_mask, sub64(a, b), set1(1));
   return cmp64_mask(d, get_zero64(), _MM_CMPINT_LT);
}

void MB_FUNC_NAME(ifma_add52_n384_)(U64 R[], const U64 A[], const U64 B[])
{
   /* r = a + b */
   U64 r0 = add64(A[0], B[0]);
   U64 r1 = add64(A[1], B[1]);
   U64 r2 = add64(A[2], B[2]);
   U64 r3 = add64(A[3], B[3]);
   U64 r4 = add64(A[4], B[4]);
   U64 r5 = add64(A[5], B[5]);
   U64 r6 = add64(A[6], B[6]);
   U64 r7 = add64(A[7], B[7]);

   /* lt = {r0 - r7} < 2*n */
   __mb_mask
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r0, ((U64*)(n384_x2))[0], 0);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r1, ((U64*)(n384_x2))[1], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r2, ((U64*)(n384_x2))[2], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r3, ((U64*)(n384_x2))[3], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r4, ((U64*)(n384_x2))[4], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r5, ((U64*)(n384_x2))[5], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r6, ((U64*)(n384_x2))[6], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r7, ((U64*)(n384_x2))[7], lt);

   /* {r0 - r7} -= 2*p */
   r0 = mask_sub64(r0, ~lt, r0, ((U64*)(n384_x2))[0]);
   r1 = mask_sub64(r1, ~lt, r1, ((U64*)(n384_x2))[1]);
   r2 = mask_sub64(r2, ~lt, r2, ((U64*)(n384_x2))[2]);
   r3 = mask_sub64(r3, ~lt, r3, ((U64*)(n384_x2))[3]);
   r4 = mask_sub64(r4, ~lt, r4, ((U64*)(n384_x2))[4]);
   r5 = mask_sub64(r5, ~lt, r5, ((U64*)(n384_x2))[5]);
   r6 = mask_sub64(r6, ~lt, r6, ((U64*)(n384_x2))[6]);
   r7 = mask_sub64(r7, ~lt, r7, ((U64*)(n384_x2))[7]);

   /* normalize r0 - r7 */
   NORM_ASHIFTR(r, 0,1)
   NORM_ASHIFTR(r, 1,2)
   NORM_ASHIFTR(r, 2,3)
   NORM_ASHIFTR(r, 3,4)
   NORM_ASHIFTR(r, 4,5)
   NORM_ASHIFTR(r, 5,6)
   NORM_ASHIFTR(r, 6,7)

   R[0] = r0;
   R[1] = r1;
   R[2] = r2;
   R[3] = r3;
   R[4] = r4;
   R[5] = r5;
   R[6] = r6;
   R[7] = r7;
}

void MB_FUNC_NAME(ifma_sub52_n384_)(U64 R[], const U64 A[], const U64 B[])
{
   /* r = a - b */
   U64 r0 = sub64(A[0], B[0]);
   U64 r1 = sub64(A[1], B[1]);
   U64 r2 = sub64(A[2], B[2]);
   U64 r3 = sub64(A[3], B[3]);
   U64 r4 = sub64(A[4], B[4]);
   U64 r5 = sub64(A[5], B[5]);
   U64 r6 = sub64(A[6], B[6]);
   U64 r7 = sub64(A[7], B[7]);

   /* lt = {r0 - r7} < 0 */
   __mb_mask
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r0, get_zero64(), 0);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r1, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r2, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r3, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r4, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r5, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r6, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r7, get_zero64(), lt);

   r0 = mask_add64(r0, lt, r0, ((U64*)(n384_x2))[0]);
   r1 = mask_add64(r1, lt, r1, ((U64*)(n384_x2))[1]);
   r2 = mask_add64(r2, lt, r2, ((U64*)(n384_x2))[2]);
   r3 = mask_add64(r3, lt, r3, ((U64*)(n384_x2))[3]);
   r4 = mask_add64(r4, lt, r4, ((U64*)(n384_x2))[4]);
   r5 = mask_add64(r5, lt, r5, ((U64*)(n384_x2))[5]);
   r6 = mask_add64(r6, lt, r6, ((U64*)(n384_x2))[6]);
   r7 = mask_add64(r7, lt, r7, ((U64*)(n384_x2))[7]);

   /* normalize r0 - r7 */
   NORM_ASHIFTR(r, 0,1)
   NORM_ASHIFTR(r, 1,2)
   NORM_ASHIFTR(r, 2,3)
   NORM_ASHIFTR(r, 3,4)
   NORM_ASHIFTR(r, 4,5)
   NORM_ASHIFTR(r, 5,6)
   NORM_ASHIFTR(r, 6,7)

   R[0] = r0;
   R[1] = r1;
   R[2] = r2;
   R[3] = r3;
   R[4] = r4;
   R[5] = r5;
   R[6] = r6;
   R[7] = r7;
}

void MB_FUNC_NAME(ifma_neg52_n384_)(U64 R[], const U64 A[])
{
   __mb_mask nz_mask = ~MB_FUNC_NAME(is_zero_FE384_)(A);

   /* {r0 - r7} = 2*n - A */
   U64 r0 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[0], A[0] );
   U64 r1 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[1], A[1] );
   U64 r2 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[2], A[2] );
   U64 r3 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[3], A[3] );
   U64 r4 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[4], A[4] );
   U64 r5 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[5], A[5] );
   U64 r6 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[6], A[6] );
   U64 r7 = mask_sub64( A[0], nz_mask, ((U64*)(n384_x2))[7], A[7] );

   /* normalize r0 - r7 */
   NORM_ASHIFTR(r, 0,1)
   NORM_ASHIFTR(r, 1,2)
   NORM_ASHIFTR(r, 2,3)
   NORM_ASHIFTR(r, 3,4)
   NORM_ASHIFTR(r, 4,5)
   NORM_ASHIFTR(r, 5,6)
   NORM_ASHIFTR(r, 6,7)

   R[0] = r0;
   R[1] = r1;
   R[2] = r2;
   R[3] = r3;
   R[4] = r4;
   R[5] = r5;
   R[6] = r6;
   R[7] = r7;
}


/* r = (a>=n384)? a-n384 : a */
void MB_FUNC_NAME(ifma_fastred52_pn384_)(U64 R[], const U64 A[])
{
   /* r = a - b */
   U64 r0 = sub64(A[0], ((U64*)(n384_mb))[0]);
   U64 r1 = sub64(A[1], ((U64*)(n384_mb))[1]);
   U64 r2 = sub64(A[2], ((U64*)(n384_mb))[2]);
   U64 r3 = sub64(A[3], ((U64*)(n384_mb))[3]);
   U64 r4 = sub64(A[4], ((U64*)(n384_mb))[4]);
   U64 r5 = sub64(A[5], ((U64*)(n384_mb))[5]);
   U64 r6 = sub64(A[6], ((U64*)(n384_mb))[6]);
   U64 r7 = sub64(A[7], ((U64*)(n384_mb))[7]);

   /* lt = {r0 - r7} < 0 */
   __mb_mask
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r0, get_zero64(), 0);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r1, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r2, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r3, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r4, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r5, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r6, get_zero64(), lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)(r7, get_zero64(), lt);

   r0 = mask_mov64(A[0], ~lt, r0);
   r1 = mask_mov64(A[1], ~lt, r1);
   r2 = mask_mov64(A[2], ~lt, r2);
   r3 = mask_mov64(A[3], ~lt, r3);
   r4 = mask_mov64(A[4], ~lt, r4);
   r5 = mask_mov64(A[5], ~lt, r5);
   r6 = mask_mov64(A[6], ~lt, r6);
   r7 = mask_mov64(A[7], ~lt, r7);

   /* normalize r0 - r7 */
   NORM_ASHIFTR(r, 0,1)
   NORM_ASHIFTR(r, 1,2)
   NORM_ASHIFTR(r, 2,3)
   NORM_ASHIFTR(r, 3,4)
   NORM_ASHIFTR(r, 4,5)
   NORM_ASHIFTR(r, 5,6)
   NORM_ASHIFTR(r, 6,7)

   R[0] = r0;
   R[1] = r1;
   R[2] = r2;
   R[3] = r3;
   R[4] = r4;
   R[5] = r5;
   R[6] = r6;
   R[7] = r7;
}
