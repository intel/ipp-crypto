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
// p384 = 2^384 - 2^128 - 2^96 + 2^32 - 1
// in 2^52 radix
*/
__ALIGN64 static const int64u p384_mb[P384_LEN52][sizeof(U64)/sizeof(int64u)] = {
   { REP8_DECL(0x00000000ffffffff) },
   { REP8_DECL(0x000ff00000000000) },
   { REP8_DECL(0x000ffffffeffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x00000000000fffff) }
};

/* 2*p384 */
__ALIGN64 static const int64u p384_x2[P384_LEN52][sizeof(U64)/sizeof(int64u)] = {
   { REP8_DECL(0x00000001fffffffe) },
   { REP8_DECL(0x000fe00000000000) },
   { REP8_DECL(0x000ffffffdffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x000fffffffffffff) },
   { REP8_DECL(0x00000000001fffff) }
};


/* k0 = -( (1/p384 mod 2^DIGIT_SIZE) ) mod 2^DIGIT_SIZE */
__ALIGN64 const static int64u p384_k0_mb[sizeof(U64)/sizeof(int64u)] = {
   REP8_DECL(0x0000000100000001)
};

/* to Montgomery conversion constant
// rr = 2^((P384_LEN52*DIGIT_SIZE)*2) mod p384
*/
__ALIGN64 static const int64u p384_rr_mb[P384_LEN52][sizeof(U64)/sizeof(int64u)] = {
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x000fe00000001000) },
   { REP8_DECL(0x0000000000ffffff) },
   { REP8_DECL(0x0000000000000020) },
   { REP8_DECL(0x0000fffffffe0000) },
   { REP8_DECL(0x0000000020000000) },
   { REP8_DECL(0x0000000000000100) },
   { REP8_DECL(0x0000000000000000) }
};
#if 0
/* Montgomery(1)
// r = 2^(P384_LEN52*DIGIT_SIZE) mod p384
*/
__ALIGN64 static const int64u p384_r_mb[P384_LEN52][sizeof(U64)/sizeof(int64u)] = {
   { REP8_DECL(0x0000000100000000) },
   { REP8_DECL(0x000ffffffffff000) },
   { REP8_DECL(0x0000000000ffffff) },
   { REP8_DECL(0x0000000000000010) },
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x0000000000000000) },
   { REP8_DECL(0x0000000000000000) }
};
#endif

/*=====================================================================

 General 384bit operations - sqr & mul

=====================================================================*/

void MB_FUNC_NAME(ifma_amm52x8_)(U64 R[], const U64 inpA[], const U64 inpB[], const U64 inpM[], const int64u* k0_mb)
{
   U64 K = loadu64(k0_mb); /* k0[] */

   U64 res00, res01, res02, res03, res04, res05, res06, res07;
   res00 = res01 = res02 = res03 = res04 = res05 = res06 = res07 = get_zero64();

   int itr;
   for (itr = 0; itr < P384_LEN52; itr++) {
      U64 Yi;
      U64 Bi = loadu64(inpB);
      inpB++;

      res00 = fma52lo(res00, Bi, inpA[0]);
      res01 = fma52lo(res01, Bi, inpA[1]);
      res02 = fma52lo(res02, Bi, inpA[2]);
      res03 = fma52lo(res03, Bi, inpA[3]);
      res04 = fma52lo(res04, Bi, inpA[4]);
      res05 = fma52lo(res05, Bi, inpA[5]);
      res06 = fma52lo(res06, Bi, inpA[6]);
      res07 = fma52lo(res07, Bi, inpA[7]);

      Yi = fma52lo(get_zero64(), res00, K);

      res00 = fma52lo(res00, Yi, inpM[0]);
      res01 = fma52lo(res01, Yi, inpM[1]);
      res02 = fma52lo(res02, Yi, inpM[2]);
      res03 = fma52lo(res03, Yi, inpM[3]);
      res04 = fma52lo(res04, Yi, inpM[4]);
      res05 = fma52lo(res05, Yi, inpM[5]);
      res06 = fma52lo(res06, Yi, inpM[6]);
      res07 = fma52lo(res07, Yi, inpM[7]);

      res00 = srli64(res00, DIGIT_SIZE);
      res01 = add64(res01, res00);

      res00 = fma52hi(res01, Bi, inpA[0]);
      res01 = fma52hi(res02, Bi, inpA[1]);
      res02 = fma52hi(res03, Bi, inpA[2]);
      res03 = fma52hi(res04, Bi, inpA[3]);
      res04 = fma52hi(res05, Bi, inpA[4]);
      res05 = fma52hi(res06, Bi, inpA[5]);
      res06 = fma52hi(res07, Bi, inpA[6]);
      res07 = fma52hi(get_zero64(), Bi, inpA[7]);

      res00 = fma52hi(res00, Yi, inpM[0]);
      res01 = fma52hi(res01, Yi, inpM[1]);
      res02 = fma52hi(res02, Yi, inpM[2]);
      res03 = fma52hi(res03, Yi, inpM[3]);
      res04 = fma52hi(res04, Yi, inpM[4]);
      res05 = fma52hi(res05, Yi, inpM[5]);
      res06 = fma52hi(res06, Yi, inpM[6]);
      res07 = fma52hi(res07, Yi, inpM[7]);
   }

   // normalization
   NORM_LSHIFTR(res0, 0, 1)
   NORM_LSHIFTR(res0, 1, 2)
   NORM_LSHIFTR(res0, 2, 3)
   NORM_LSHIFTR(res0, 3, 4)
   NORM_LSHIFTR(res0, 4, 5)
   NORM_LSHIFTR(res0, 5, 6)
   NORM_LSHIFTR(res0, 6, 7)

   R[0] = res00;
   R[1] = res01;
   R[2] = res02;
   R[3] = res03;
   R[4] = res04;
   R[5] = res05;
   R[6] = res06;
   R[7] = res07;
}

/*=====================================================================

 Specialized operations in p384 - sqr & mul

=====================================================================*/
void MB_FUNC_NAME(ifma_amm52_p384_)(U64 r[], const U64 a[], const U64 b[])
{
   MB_FUNC_NAME(ifma_amm52x8_)(r, a, b, (U64*)p384_mb, p384_k0_mb);
}

void MB_FUNC_NAME(ifma_ams52_p384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52x8_)(r, a, a, (U64*)p384_mb, p384_k0_mb);
}

void MB_FUNC_NAME(ifma_tomont52_p384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52_p384_)(r, a, (U64*)p384_rr_mb);
}

void MB_FUNC_NAME(ifma_frommont52_p384_)(U64 r[], const U64 a[])
{
   MB_FUNC_NAME(ifma_amm52_p384_)(r, a, (U64*)ones);
}

/*
// computes r = 1/z = z^(p384-2) mod p384
//       => r = z^(0xFFFFFFFFFFFFFFFF FFFFFFFFFFFFFFFF FFFFFFFFFFFFFFFF FFFFFFFFFFFFFFFE FFFFFFFF00000000 00000000FFFFFFFD)
//
// note: z in in Montgomery domain (as soon mul() and sqr() below are amm-functions
//       r in Montgomery domain too
*/
#define fe52_sqr  MB_FUNC_NAME(ifma_ams52_p384_)
#define fe52_mul  MB_FUNC_NAME(ifma_amm52_p384_)

/* r = base^(2^n) */
__INLINE void fe52_sqr_pwr(U64 r[], const U64 base[], int n)
{
   if(r!=base)
      MB_FUNC_NAME(mov_FE384_)(r, base);
   for(; n>0; n--)
      fe52_sqr(r,r);
}

void MB_FUNC_NAME(ifma_aminv52_p384_)(U64 r[], const U64 z[])
{
   __ALIGN64 U64  u[P384_LEN52];
   __ALIGN64 U64  v[P384_LEN52];
   __ALIGN64 U64 zD[P384_LEN52];
   __ALIGN64 U64 zE[P384_LEN52];
   __ALIGN64 U64 zF[P384_LEN52];

   fe52_sqr(u, z);              /* u = z^2 */
   fe52_mul(v, u, z);           /* v = z^2 * z     = z^3  */
   fe52_sqr_pwr(zF, v, 2);      /* zF= (z^3)^(2^2) = z^12 */

   fe52_mul(zD, zF, z);         /* zD = z^12 * z    = z^xD */
   fe52_mul(zE, zF, u);         /* zE = z^12 * z^2  = z^xE */
   fe52_mul(zF, zF, v);         /* zF = z^12 * z^3  = z^xF */

   fe52_sqr_pwr(u, zF, 4);      /* u  = (z^xF)^(2^4)  = z^xF0 */
   fe52_mul(zD, u, zD);         /* zD = z^xF0 * z^xD  = z^xFD */
   fe52_mul(zE, u, zE);         /* zE = z^xF0 * z^xE  = z^xFE */
   fe52_mul(zF, u, zF);         /* zF = z^xF0 * z^xF  = z^xFF */

   fe52_sqr_pwr(u, zF, 8);      /* u = (z^xFF)^(2^8)    = z^xFF00 */
   fe52_mul(zD, u, zD);         /* zD = z^xFF00 * z^xFD = z^xFFFD */
   fe52_mul(zE, u, zE);         /* zE = z^xFF00 * z^xFE = z^xFFFE */
   fe52_mul(zF, u, zF);         /* zF = z^xFF00 * z^xFF = z^xFFFF */

   fe52_sqr_pwr(u, zF, 16);     /* u = (z^xFFFF)^(2^16)       = z^xFFFF0000 */
   fe52_mul(zD, u, zD);         /* zD = z^xFFFF0000 * z^xFFFD = z^xFFFFFFFD */
   fe52_mul(zE, u, zE);         /* zE = z^xFFFF0000 * z^xFFFE = z^xFFFFFFFE */
   fe52_mul(zF, u, zF);         /* zF = z^xFFFF0000 * z^xFFFF = z^xFFFFFFFF */

   fe52_sqr_pwr(u, zF, 32);     /* u = (z^xFFFFFFFF)^(2^32)               = z^xFFFFFFFF00000000 */
   fe52_mul(zE, u, zE);         /* zE = z^xFFFFFFFF00000000 * z^xFFFFFFFE = z^xFFFFFFFFFFFFFFFE */
   fe52_mul(zF, u, zF);         /* zF = z^xFFFFFFFF00000000 * z^xFFFFFFFF = z^xFFFFFFFFFFFFFFFF */

   /* v =  z^xFFFFFFFFFFFFFFFF.0000000000000000 * z^xFFFFFFFFFFFFFFFF
        = z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF */
   fe52_sqr_pwr(v, zF, 64);
   fe52_mul(v, v, zF);
   /* v =  z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.0000000000000000 * z^xFFFFFFFFFFFFFFFF
          = z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFFF */
   fe52_sqr_pwr(v, v, 64);
   fe52_mul(v, v, zF);
   /* v =  z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.0000000000000000 * z^xFFFFFFFFFFFFFFFE
        = z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFE */
   fe52_sqr_pwr(v, v, 64);
   fe52_mul(v, v, zE);
   /* v =  z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFE.0000000000000000 * z^xFFFFFFFF00000000
        = z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFE.FFFFFFFF00000000 */
   fe52_sqr_pwr(v, v, 64);
   fe52_mul(v, v, u);
   /* r =  z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFE.FFFFFFFF00000000.0000000000000000 * z^xFFFFFFFD
        = z^xFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFFF.FFFFFFFFFFFFFFFE.FFFFFFFF00000000.00000000FFFFFFFD */
   fe52_sqr_pwr(v, v, 64);
   fe52_mul(r, v, zD);
}

/*=====================================================================

 Specialized single operations in n384 - add, sub & neg

=====================================================================*/
static __mb_mask MB_FUNC_NAME(lt_mbx_digit_)(const U64 a, const U64 b, const __mb_mask lt_mask)
{
   U64 d = mask_sub64(sub64(a, b), lt_mask, sub64(a, b), set1(1));
   return cmp64_mask(d, get_zero64(), _MM_CMPINT_LT);
}
#if 0
static __mb_mask MB_FUNC_NAME(eq_mbx_digit_)(const U64 a, const U64 b)
{
   return cmp64_mask(a, b, _MM_CMPINT_EQ);
}

static __mb_mask MB_FUNC_NAME(ne_mbx_digit_)(const U64 a, const U64 b)
{
   return ~ cmp64_mask(a, b, _MM_CMPINT_EQ);
}
#endif
void MB_FUNC_NAME(ifma_add52_p384_)(U64 R[], const U64 A[], const U64 B[])
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

   /* lt = {r0 - r7} < 2*p */
   __mb_mask
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r0, ((U64*)(p384_x2))[0], 0);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r1, ((U64*)(p384_x2))[1], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r2, ((U64*)(p384_x2))[2], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r3, ((U64*)(p384_x2))[3], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r4, ((U64*)(p384_x2))[4], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r5, ((U64*)(p384_x2))[5], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r6, ((U64*)(p384_x2))[6], lt);
   lt = MB_FUNC_NAME(lt_mbx_digit_)( r7, ((U64*)(p384_x2))[7], lt);

   /* {r0 - r7} -= 2*p */
   r0 = mask_sub64(r0, ~lt, r0, ((U64*)(p384_x2))[0]);
   r1 = mask_sub64(r1, ~lt, r1, ((U64*)(p384_x2))[1]);
   r2 = mask_sub64(r2, ~lt, r2, ((U64*)(p384_x2))[2]);
   r3 = mask_sub64(r3, ~lt, r3, ((U64*)(p384_x2))[3]);
   r4 = mask_sub64(r4, ~lt, r4, ((U64*)(p384_x2))[4]);
   r5 = mask_sub64(r5, ~lt, r5, ((U64*)(p384_x2))[5]);
   r6 = mask_sub64(r6, ~lt, r6, ((U64*)(p384_x2))[6]);
   r7 = mask_sub64(r7, ~lt, r7, ((U64*)(p384_x2))[7]);

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

void MB_FUNC_NAME(ifma_sub52_p384_)(U64 R[], const U64 A[], const U64 B[])
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

   r0 = mask_add64(r0, lt, r0, ((U64*)(p384_x2))[0]);
   r1 = mask_add64(r1, lt, r1, ((U64*)(p384_x2))[1]);
   r2 = mask_add64(r2, lt, r2, ((U64*)(p384_x2))[2]);
   r3 = mask_add64(r3, lt, r3, ((U64*)(p384_x2))[3]);
   r4 = mask_add64(r4, lt, r4, ((U64*)(p384_x2))[4]);
   r5 = mask_add64(r5, lt, r5, ((U64*)(p384_x2))[5]);
   r6 = mask_add64(r6, lt, r6, ((U64*)(p384_x2))[6]);
   r7 = mask_add64(r7, lt, r7, ((U64*)(p384_x2))[7]);

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

void MB_FUNC_NAME(ifma_neg52_p384_)(U64 R[], const U64 A[])
{
   __mb_mask nz_mask = ~MB_FUNC_NAME(is_zero_FE384_)(A);

   /* {r0 - r7} = 2*p - A */
   U64 r0 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[0], A[0] );
   U64 r1 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[1], A[1] );
   U64 r2 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[2], A[2] );
   U64 r3 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[3], A[3] );
   U64 r4 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[4], A[4] );
   U64 r5 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[5], A[5] );
   U64 r6 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[6], A[6] );
   U64 r7 = mask_sub64( A[0], nz_mask, ((U64*)(p384_x2))[7], A[7] );

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

void MB_FUNC_NAME(ifma_double52_p384_)(U64 R[], const U64 A[])
{
   MB_FUNC_NAME(ifma_add52_p384_)(R, A, A);
}

void MB_FUNC_NAME(ifma_tripple52_p384_)(U64 R[], const U64 A[])
{
   U64 T[P384_LEN52];
   MB_FUNC_NAME(ifma_add52_p384_)(T, A, A);
   MB_FUNC_NAME(ifma_add52_p384_)(R, T, A);
}

void MB_FUNC_NAME(ifma_half52_p384_)(U64 R[], const U64 A[])
{
   U64 one = set1(1);
   U64 base = set1(DIGIT_BASE);

   /* res = a + is_odd(a)? p384 : 0 */
   U64 mask = sub64(get_zero64(), and64(A[0], one));
   U64 t0 = add64(A[0], and64(((U64*)p384_mb)[0], mask));
   U64 t1 = add64(A[1], and64(((U64*)p384_mb)[1], mask));
   U64 t2 = add64(A[2], and64(((U64*)p384_mb)[2], mask));
   U64 t3 = add64(A[3], and64(((U64*)p384_mb)[3], mask));
   U64 t4 = add64(A[4], and64(((U64*)p384_mb)[4], mask));
   U64 t5 = add64(A[5], and64(((U64*)p384_mb)[5], mask));
   U64 t6 = add64(A[6], and64(((U64*)p384_mb)[6], mask));
   U64 t7 = add64(A[7], and64(((U64*)p384_mb)[7], mask));

   /* t =>> 1 */
   mask = sub64(get_zero64(), and64(t1, one));
   t0 = add64(t0, and64(base, mask));
   t0 = srli64(t0, 1);

   mask = sub64(get_zero64(), and64(t2, one));
   t1 = add64(t1, and64(base, mask));
   t1 = srli64(t1, 1);

   mask = sub64(get_zero64(), and64(t3, one));
   t2 = add64(t2, and64(base, mask));
   t2 = srli64(t2, 1);

   mask = sub64(get_zero64(), and64(t4, one));
   t3 = add64(t3, and64(base, mask));
   t3 = srli64(t3, 1);

   mask = sub64(get_zero64(), and64(t5, one));
   t4 = add64(t4, and64(base, mask));
   t4 = srli64(t4, 1);

   mask = sub64(get_zero64(), and64(t6, one));
   t5 = add64(t5, and64(base, mask));
   t5 = srli64(t5, 1);

   mask = sub64(get_zero64(), and64(t7, one));
   t6 = add64(t6, and64(base, mask));
   t6 = srli64(t6, 1);

   t7 = srli64(t7, 1);

   /* normalize t0, t1, t2, t3, t4 */
   NORM_LSHIFTR(t, 0,1)
   NORM_LSHIFTR(t, 1,2)
   NORM_LSHIFTR(t, 2,3)
   NORM_LSHIFTR(t, 3,4)
   NORM_LSHIFTR(t, 4,5)
   NORM_LSHIFTR(t, 5,6)
   NORM_LSHIFTR(t, 6,7)

   R[0] = t0;
   R[1] = t1;
   R[2] = t2;
   R[3] = t3;
   R[4] = t4;
   R[5] = t5;
   R[6] = t6;
   R[7] = t7;
}
