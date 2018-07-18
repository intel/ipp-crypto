/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
* All Rights Reserved.
*
* If this  software was obtained  under the  Intel Simplified  Software License,
* the following terms apply:
*
* The source code,  information  and material  ("Material") contained  herein is
* owned by Intel Corporation or its  suppliers or licensors,  and  title to such
* Material remains with Intel  Corporation or its  suppliers or  licensors.  The
* Material  contains  proprietary  information  of  Intel or  its suppliers  and
* licensors.  The Material is protected by  worldwide copyright  laws and treaty
* provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
* modified, published,  uploaded, posted, transmitted,  distributed or disclosed
* in any way without Intel's prior express written permission.  No license under
* any patent,  copyright or other  intellectual property rights  in the Material
* is granted to  or  conferred  upon  you,  either   expressly,  by implication,
* inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
* property rights must be express and approved by Intel in writing.
*
* Unless otherwise agreed by Intel in writing,  you may not remove or alter this
* notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
* suppliers or licensors in any way.
*
*
* If this  software  was obtained  under the  Apache License,  Version  2.0 (the
* "License"), the following terms apply:
*
* You may  not use this  file except  in compliance  with  the License.  You may
* obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
*
*
* Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
* distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
* See the   License  for the   specific  language   governing   permissions  and
* limitations under the License.
*******************************************************************************/

#include "owncp.h"

#if (_IPP32E>=_IPP32E_K0)

#include "pcpbnuimpl.h"
#include "pcpbnumisc.h"

#include "pcpngmontexpstuff.h"
#include "pcpngmontexpstuff_avx512.h"
#include "gsscramble.h"


/*
   converts regular (base = 2^64) representation
   into "redundant" (base = 2^DIGIT_SIZE) represenrartion
*/

/* pair of 52-bit digits occupys 13 bytes (the fact is using in implementation beloow) */
__INLINE Ipp64u getDig52(const Ipp8u* pStr, int strLen)
{
   Ipp64u digit = 0;
   for(; strLen>0; strLen--) {
      digit <<= 8;
      digit += (Ipp64u)(pStr[strLen-1]);
   }
   return digit;
}

/* regular => redundant conversion */
static void regular_dig52(Ipp64u* out, const Ipp64u* in, int inBitSize)
{
   Ipp8u* inStr = (Ipp8u*)in;
   /* expected out length */
   int outLen = numofVariableBuff_avx512(cpDigitNum_avx512(inBitSize, EXP_DIGIT_SIZE_AVX512));

   for(; inBitSize>=(2*EXP_DIGIT_SIZE_AVX512); inBitSize-=(2*EXP_DIGIT_SIZE_AVX512), out+=2) {
      out[0] = (*(Ipp64u*)inStr) & EXP_DIGIT_MASK_AVX512;
      inStr += 6;
      out[1] = ((*(Ipp64u*)inStr) >> 4) & EXP_DIGIT_MASK_AVX512;
      inStr += 7;
      outLen -= 2;
   }
   if(inBitSize>EXP_DIGIT_SIZE_AVX512) {
      Ipp64u digit = getDig52(inStr, 7);
      out[0] = digit & EXP_DIGIT_MASK_AVX512;
      inStr += 6;
      inBitSize -= EXP_DIGIT_MASK_AVX512;
      digit = getDig52(inStr, BITS2WORD8_SIZE(inBitSize));
      out[1] = digit>>4;
      out += 2;
      outLen -= 2;
   }
   else if(inBitSize>0) {
      out[0] = getDig52(inStr, BITS2WORD8_SIZE(inBitSize));
      out++;
      outLen--;
   }
   for(; outLen>0; outLen--,out++) out[0] = 0;
}

/*
   converts "redundant" (base = 2^DIGIT_SIZE) representation
   into regular (base = 2^64)
*/
__INLINE void putDig52(Ipp8u* pStr, int strLen, Ipp64u digit)
{
   for(; strLen>0; strLen--) {
      *pStr++ = (Ipp8u)(digit&0xFF);
      digit >>= 8;
   }
}

static void dig52_regular(Ipp64u* out, const Ipp64u* in, int outBitSize)
{
   int i;
   int outLen = BITS2WORD64_SIZE(outBitSize);
   for(i=0; i<outLen; i++) out[i] = 0;

   {
      Ipp8u* outStr = (Ipp8u*)out;
      for(; outBitSize>=(2*EXP_DIGIT_SIZE_AVX512); outBitSize-=(2*EXP_DIGIT_SIZE_AVX512), in+=2) {
         (*(Ipp64u*)outStr) = in[0];
         outStr+=6;
         (*(Ipp64u*)outStr) ^= in[1] << 4;
         outStr+=7;
      }
      if(outBitSize>EXP_DIGIT_SIZE_AVX512) {
         putDig52(outStr, 7, in[0]);
         outStr+=6;
         outBitSize -= EXP_DIGIT_SIZE_AVX512;
         putDig52(outStr, BITS2WORD8_SIZE(outBitSize), (in[1]<<4 | in[0]>>48));
      }
      else if(outBitSize) {
         putDig52(outStr, BITS2WORD8_SIZE(outBitSize), in[0]);
      }
   }
}

static void AMM52(Ipp64u* out, const Ipp64u* a, const Ipp64u* b, const Ipp64u* m, Ipp64u k0, int len, Ipp64u* res)
{
   #define NUM64  (sizeof(__m512i)/sizeof(Ipp64u))

   __mmask8 k1 = _mm512_kmov(0x02);   /* mask of the 2-nd elment */

   __m512i zero = _mm512_setzero_si512(); /* zeros */

   int n;
   int tail = len & (NUM64 -1);
   int expLen = len;
   if(tail) expLen += (NUM64 - tail);

   /* make sure not inplace operation */
   //tbcd: temporary excluded: assert(res!=a);
   //tbcd: temporary excluded: assert(res!=b);

   /* set result to zero */
   for(n=0; n<expLen; n+=NUM64)
      _mm512_storeu_si512(res+n, zero);

   /*
   // do Almost Montgomery Multiplication
   */
   for(n=0; n<len; n++) {
      /* compute and broadcast y = (r[0]+a[0]*b[0])*k0 */
      Ipp64u y = ((res[0] + a[0]*b[n]) * k0) & EXP_DIGIT_MASK_AVX512;
      __m512i yn = _mm512_set1_epi64(y);

      /* broadcast b[n] digit */
      __m512i bn = _mm512_set1_epi64(b[n]);

      int i;
      __m512i rp, ap, mp, d;

      /* r[0] += a[0]*b + m[0]*y */
      __m512i ri = _mm512_loadu_si512(res);  /* r[0] */
      __m512i ai = _mm512_loadu_si512(a);    /* a[0] */
      __m512i mi = _mm512_loadu_si512(m);    /* m[0] */
      ri = _mm512_madd52lo_epu64(ri, ai, bn);
      ri = _mm512_madd52lo_epu64(ri, mi, yn);

      /* shift r[0] by 1 digit */
      d = _mm512_srli_epi64(ri, EXP_DIGIT_SIZE_AVX512);
      d = _mm512_shuffle_epi32(d, 0x44);
      d = _mm512_mask_add_epi64(ri, k1, ri, d);

      for(i=8; i<expLen; i+=8) {
         //rp = ri;
         ri = _mm512_loadu_si512(res+i);
         ap = ai;
         ai = _mm512_loadu_si512(a+i);
         mp = mi;
         mi = _mm512_loadu_si512(m+i);

         /* r[] += lo(a[]*b + m[]*y) */
         ri = _mm512_madd52lo_epu64(ri, ai, bn);
         ri = _mm512_madd52lo_epu64(ri, mi, yn);

         /* shift r[] by 1 digit */
         rp = _mm512_alignr_epi64(ri, d, 1);
         d = ri;

         /* r[] += hi(a[]*b + m[]*y) */
         rp = _mm512_madd52hi_epu64(rp, ap, bn);
         rp = _mm512_madd52hi_epu64(rp, mp, yn);
         _mm512_storeu_si512(res+i-NUM64, rp);
      }
      ri = _mm512_alignr_epi64(zero, d, 1);
      ri = _mm512_madd52hi_epu64(ri, ai, bn);
      ri = _mm512_madd52hi_epu64(ri, mi, yn);
      _mm512_storeu_si512(res+i-NUM64, ri);
   }

   /* normalization */
   {
      Ipp64u acc = 0;
      for(n=0; n<len; n++) {
         acc += res[n];
         out[n] = acc & EXP_DIGIT_MASK_AVX512;
         acc >>= EXP_DIGIT_SIZE_AVX512;
      }
   }
}


/* ======= degugging section =========================================*/
//#define _EXP_AVX512_DEBUG_
#ifdef _EXP_AVX512_DEBUG_
#include "pcpmontred.h"
void debugToConvMontDomain(BNU_CHUNK_T* pR,
                     const BNU_CHUNK_T* redInp, const BNU_CHUNK_T* redM, int almMM_bitsize,
                     const BNU_CHUNK_T* pM, const BNU_CHUNK_T* pRR, int nsM, BNU_CHUNK_T k0,
                     BNU_CHUNK_T* pBuffer)
{
   Ipp64u one[32] = {
      1,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0
   };
   Ipp64u redT[32];
   int redLen = cpDigitNum_avx512(almMM_bitsize, EXP_DIGIT_SIZE_AVX512);
   AMM52(redT, redInp, one, redM, k0, redLen, pBuffer);
   dig52_regular(pR, redT, almMM_bitsize);

   //cpMontMul_BNU(pR,              should be changed
   //              redT, nsM,
   //              pRR,  nsM,
   //              pM,   nsM, k0,
   //              pBuffer, 0);
   cpMul_BNU(pBuffer, pR,nsM, pRR,nsM, 0);
   cpMontRed_BNU_opt(pR, pBuffer, pM, nsM, k0);
}
#endif
/* ===================================================================*/

cpSize gsMontExpBinBuffer_avx512(int modulusBits)
{
   cpSize redNum = numofVariable_avx512(modulusBits);       /* "sizeof" variable */
   cpSize redBufferNum = numofVariableBuff_avx512(redNum);  /* "sizeof" variable  buffer */
   return redBufferNum *7;
}

#if defined(_USE_WINDOW_EXP_)
cpSize gsMontExpWinBuffer_avx512(int modulusBits)
{
   cpSize w = gsMontExp_WinSize(modulusBits);

   cpSize redNum = numofVariable_avx512(modulusBits);       /* "sizeof" variable */
   cpSize redBufferNum = numofVariableBuff_avx512(redNum);  /* "sizeof" variable  buffer */

   cpSize bufferNum = CACHE_LINE_SIZE/sizeof(BNU_CHUNK_T)
                    + gsGetScrambleBufferSize(redNum, w) /* pre-computed table */
                    + redBufferNum *7;                   /* addition 7 variables */
   return bufferNum;
}
#endif /* _USE_WINDOW_EXP_ */


/*
// "fast" binary montgomery exponentiation
//
// scratch buffer structure:
//    redX[redBufferLen]
//    redT[redBufferLen]
//    redY[redBufferLen]
//    redM[redBufferLen]
//    redBuffer[redBufferLen*3]
*/
cpSize gsMontExpBin_BNU_avx512(BNU_CHUNK_T* dataY,
                         const BNU_CHUNK_T* dataX, cpSize nsX,
                         const BNU_CHUNK_T* dataE, cpSize bitsizeE,
                               gsModEngine* pMont,
                               BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataM = MOD_MODULUS(pMont);
   const BNU_CHUNK_T* dataRR= MOD_MNT_R2(pMont);
   cpSize nsM = MOD_LEN(pMont);
   BNU_CHUNK_T k0 = MOD_MNT_FACTOR(pMont);

   cpSize nsE = BITS_BNU_CHUNK(bitsizeE);

   int modulusBitSize = BITSIZE_BNU(dataM, nsM);
   int cnvMM_bitsize = cpDigitNum_avx512(modulusBitSize, BITSIZE(BNU_CHUNK_T)) * BITSIZE(BNU_CHUNK_T);
   int almMM_bitsize = cnvMM_bitsize+2;
   int redLen = cpDigitNum_avx512(almMM_bitsize, EXP_DIGIT_SIZE_AVX512);
   int redBufferLen = numofVariableBuff_avx512(redLen);

   /* allocate buffers */
   BNU_CHUNK_T* redX = pBuffer;
   BNU_CHUNK_T* redT = redX+redBufferLen;
   BNU_CHUNK_T* redY = redT+redBufferLen;
   BNU_CHUNK_T* redM = redY+redBufferLen;
   BNU_CHUNK_T* redBuffer = redM+redBufferLen;

   /* convert modulus into reduced domain */
   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataM, nsM);
   regular_dig52(redM, redBuffer, almMM_bitsize);

   /* compute taget domain Montgomery converter RR' */
   ZEXPAND_BNU(redBuffer, 0, redBufferLen);
   SET_BIT(redBuffer, (4*redLen*EXP_DIGIT_SIZE_AVX512- 4*cnvMM_bitsize));
   regular_dig52(redY, redBuffer, almMM_bitsize);

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataRR, nsM);
   regular_dig52(redT, redBuffer, almMM_bitsize);
   AMM52(redT, redT, redT, redM, k0, redLen, redBuffer);
   AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);

   /* convert base to Montgomery domain */
   ZEXPAND_COPY_BNU(redY, nsX+1, dataX, nsX);
   regular_dig52(redX, redY,  almMM_bitsize);
   AMM52(redX, redX, redT, redM, k0, redLen, redBuffer);

   /* init result */
   COPY_BNU(redY, redX, redLen);

   FIX_BNU(dataE, nsE);
   {
      /* execute most significant part pE */
      BNU_CHUNK_T eValue = dataE[nsE-1];
      int n = cpNLZ_BNU(eValue)+1;

      eValue <<= n;
      for(; n<BNU_CHUNK_BITS; n++, eValue<<=1) {
         /* squaring/multiplication: Y = Y*Y */
         AMM52(redY, redY, redY, redM, k0, redLen, redBuffer);

         /* and multiply Y = Y*X */
         if(eValue & ((BNU_CHUNK_T)1<<(BNU_CHUNK_BITS-1)))
            AMM52(redY, redY, redX, redM, k0, redLen, redBuffer);
      }

      /* execute rest bits of E */
      for(--nsE; nsE>0; nsE--) {
         eValue = dataE[nsE-1];

         for(n=0; n<BNU_CHUNK_BITS; n++, eValue<<=1) {
            /* squaring: Y = Y*Y */
            AMM52(redY, redY, redY, redM, k0, redLen, redBuffer);

            /* and multiply: Y = Y*X */
            if(eValue & ((BNU_CHUNK_T)1<<(BNU_CHUNK_BITS-1)))
               AMM52(redY, redY, redX, redM, k0, redLen, redBuffer);
         }
      }
   }

   /* convert result back to regular domain */
   ZEXPAND_BNU(redT, 0, redBufferLen);
   redT[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   dig52_regular(dataY, redY, cnvMM_bitsize);

   return nsM;
}

#if !defined(_USE_WINDOW_EXP_)
/*
// "safe" binary montgomery exponentiation
//
// scratch buffer structure:
//    redX[redBufferLen]
//    redT[redBufferLen]
//    redY[redBufferLen]
//    redM[redBufferLen]
//    redBuffer[redBufferLen*3]
*/
cpSize gsMontExpBin_BNU_sscm_avx512(BNU_CHUNK_T* dataY,
                              const BNU_CHUNK_T* dataX, cpSize nsX,
                              const BNU_CHUNK_T* dataE, cpSize bitsizeE,
                                    gsModEngine* pMont,
                                    BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataM = MOD_MODULUS(pMont);
   const BNU_CHUNK_T* dataRR= MOD_MNT_R2(pMont);
   cpSize nsM = MOD_LEN(pMont);
   cpSize nsE = BITS_BNU_CHUNK(bitsizeE);
   BNU_CHUNK_T k0 = MOD_MNT_FACTOR(pMont);

   int modulusBitSize = BITSIZE_BNU(dataM, nsM);
   int cnvMM_bitsize = cpDigitNum_avx512(modulusBitSize, BITSIZE(BNU_CHUNK_T)) * BITSIZE(BNU_CHUNK_T);
   int almMM_bitsize = cnvMM_bitsize+2;
   int redLen = cpDigitNum_avx512(almMM_bitsize, EXP_DIGIT_SIZE_AVX512);
   int redBufferLen = numofVariableBuff_avx512(redLen);

   /* allocate buffers */
   BNU_CHUNK_T* redX = pBuffer;
   BNU_CHUNK_T* redT = redX+redBufferLen;
   BNU_CHUNK_T* redY = redT+redBufferLen;
   BNU_CHUNK_T* redM = redY+redBufferLen;
   BNU_CHUNK_T* redBuffer = redM+redBufferLen;

   /* convert modulus into reduced domain */
   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataM, nsM);
   regular_dig52(redM, redBuffer, almMM_bitsize);

   /* compute taget domain Montgomery converter RR' */
   ZEXPAND_BNU(redBuffer, 0, redBufferLen);
   SET_BIT(redBuffer, (4*redLen*EXP_DIGIT_SIZE_AVX512- 4*cnvMM_bitsize));
   regular_dig52(redY, redBuffer, almMM_bitsize);

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataRR, nsM);
   regular_dig52(redT, redBuffer, almMM_bitsize);
   AMM52(redT, redT, redT, redM, k0, redLen, redBuffer);
   AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);

   /* convert base to Montgomery domain */
   ZEXPAND_COPY_BNU(redY, nsX+1, dataX, nsX);
   regular_dig52(redX, redY,  almMM_bitsize);
   AMM52(redX, redX, redT, redM, k0, redLen, redBuffer);

   /* init result */
   ZEXPAND_BNU(redY, 0, redBufferLen);
   redY[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);

   {
      int back_step = 0;

      /* execute bits of E */
      for(--nsE; nsE>0; nsE--) {
         BNU_CHUNK_T eValue = dataE[nsE-1];

         int j;
         for(j=BNU_CHUNK_BITS-1; j>=0; j--) {
            BNU_CHUNK_T mask_pattern = (BNU_CHUNK_T)(back_step-1);

            /* T = (Y & mask_pattern) or (X & ~mask_pattern) */
            int i;
            for(i=0; i<redLen; i++)
               redT[i] = (redY[i] & mask_pattern) | (redX[i] & ~mask_pattern);

            /* squaring/multiplication: Y = Y*T */
            AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);

            /* update back_step and j */
            back_step = ((eValue>>j) & 0x1) & (back_step^1);
            j += back_step;
         }
      }
   }

   /* convert result back to regular domain */
   ZEXPAND_BNU(redT, 0, redBufferLen);
   redT[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   dig52_regular(dataY, redY, cnvMM_bitsize);

   return nsM;
}
#endif /* !_USE_WINDOW_EXP_ */


#if defined(_USE_WINDOW_EXP_)
/*
// "fast" fixed-size window montgomery exponentiation
//
// scratch buffer structure:
//    precomuted table of multipliers[(1<<w)*redLen]
//    redM[redBufferLen]
//    redY[redBufferLen]
//    redT[redBufferLen]
//    redE[redBufferLen]
//    redBuffer[redBufferLen*3]
*/
cpSize gsMontExpWin_BNU_avx512(BNU_CHUNK_T* dataY,
                         const BNU_CHUNK_T* dataX, cpSize nsX,
                         const BNU_CHUNK_T* dataE, cpSize bitsizeE,
                               gsModEngine* pMont,
                               BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataM = MOD_MODULUS(pMont);
   const BNU_CHUNK_T* dataRR= MOD_MNT_R2(pMont);
   cpSize nsM = MOD_LEN(pMont);
   BNU_CHUNK_T k0 = MOD_MNT_FACTOR(pMont);

   cpSize nsE = BITS_BNU_CHUNK(bitsizeE);

   int modulusBitSize = BITSIZE_BNU(dataM, nsM);
   int cnvMM_bitsize = cpDigitNum_avx512(modulusBitSize, BITSIZE(BNU_CHUNK_T)) * BITSIZE(BNU_CHUNK_T);
   int almMM_bitsize = cnvMM_bitsize+2;
   int redLen = cpDigitNum_avx512(almMM_bitsize, EXP_DIGIT_SIZE_AVX512);
   int redBufferLen = numofVariableBuff_avx512(redLen);

   cpSize window = gsMontExp_WinSize(bitsizeE);
   BNU_CHUNK_T wmask = (1<<window) -1;
   cpSize nPrecomute= 1<<window;
   int n;

   BNU_CHUNK_T* redE = pBuffer;
   BNU_CHUNK_T* redM = redE+redBufferLen;
   BNU_CHUNK_T* redY = redM+redBufferLen;
   BNU_CHUNK_T* redT = redY+redBufferLen;
   BNU_CHUNK_T* redBuffer = redT+redBufferLen;
   BNU_CHUNK_T* redTable = redBuffer+redBufferLen*3;

   /* convert modulus into reduced domain */
   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataM, nsM);
   regular_dig52(redM, redBuffer, almMM_bitsize);

   /* compute taget domain Montgomery converter RR' */
   ZEXPAND_BNU(redBuffer, 0, redBufferLen);
   SET_BIT(redBuffer, (4*redLen*EXP_DIGIT_SIZE_AVX512- 4*cnvMM_bitsize));
   regular_dig52(redY, redBuffer, almMM_bitsize);

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataRR, nsM);
   regular_dig52(redT, redBuffer, almMM_bitsize);
   AMM52(redT, redT, redT, redM, k0, redLen, redBuffer);
   AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);

   /*
      pre-compute T[i] = X^i, i=0,.., 2^w-1
   */
   ZEXPAND_BNU(redY, 0, redBufferLen);
   redY[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   COPY_BNU(redTable+0, redY, redLen);

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataX, nsX);
   regular_dig52(redY, redBuffer, almMM_bitsize);
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   COPY_BNU(redTable+redLen, redY, redLen);

   AMM52(redT, redY, redY, redM, k0, redLen, redBuffer);
   COPY_BNU(redTable+redLen*2, redT, redLen);

   for(n=3; n<nPrecomute; n++) {
      AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);
      COPY_BNU(redTable+redLen*n, redT, redLen);
   }

   /* expand exponent */
   ZEXPAND_COPY_BNU(redE, nsE+1, dataE, nsE);
   bitsizeE = ((bitsizeE+window-1)/window) *window;

   /* exponentiation */
   {
      /* position of the 1-st (left) window */
      int eBit = bitsizeE - window;

      /* extract 1-st window value */
      Ipp32u eChunk = *((Ipp32u*)((Ipp16u*)redE+ eBit/BITSIZE(Ipp16u)));
      int shift = eBit & 0xF;
      cpSize windowVal = (eChunk>>shift) &wmask;

      /* initialize result */
      ZEXPAND_COPY_BNU(redY, redBufferLen, redTable+windowVal*redLen, redLen);

      for(eBit-=window; eBit>=0; eBit-=window) {
         /* do squaring window-times */
         for(n=0; n<window; n++) {
            AMM52(redY, redY, redY, redM, k0, redLen, redBuffer);
         }

         /* extract next window value */
         eChunk = *((Ipp32u*)((Ipp16u*)redE+ eBit/BITSIZE(Ipp16u)));
         shift = eBit & 0xF;
         windowVal = (eChunk>>shift) &wmask;

         /* exptact precomputed value and muptiply */
         if(windowVal) {
            AMM52(redY, redY, redTable+windowVal*redLen, redM, k0, redLen, redBuffer);
         }
      }
   }

   /* convert result back */
   ZEXPAND_BNU(redT, 0, redBufferLen);
   redT[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   dig52_regular(dataY, redY, cnvMM_bitsize);

   return nsM;
}

/*
// "safe" fixed-size window montgomery exponentiation
//
// scratch buffer structure:
//    precomuted table of multipliers[(1<<w)*redLen]
//    redM[redBufferLen]
//    redY[redBufferLen]
//    redT[redBufferLen]
//    redBuffer[redBufferLen*3]
//    redE[redBufferLen]
*/
cpSize gsMontExpWin_BNU_sscm_avx512(BNU_CHUNK_T* dataY,
                              const BNU_CHUNK_T* dataX, cpSize nsX,
                              const BNU_CHUNK_T* dataE, cpSize bitsizeE,
                                    gsModEngine* pMont,
                                    BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataM = MOD_MODULUS(pMont);
   const BNU_CHUNK_T* dataRR= MOD_MNT_R2(pMont);
   cpSize nsM = MOD_LEN(pMont);
   BNU_CHUNK_T k0 = MOD_MNT_FACTOR(pMont);

   cpSize nsE = BITS_BNU_CHUNK(bitsizeE);

   int modulusBitSize = MOD_BITSIZE(pMont);
   int cnvMM_bitsize = cpDigitNum_avx512(modulusBitSize, BITSIZE(BNU_CHUNK_T)) * BITSIZE(BNU_CHUNK_T);
   int almMM_bitsize = cnvMM_bitsize+2;
   int redLen = cpDigitNum_avx512(almMM_bitsize, EXP_DIGIT_SIZE_AVX512);
   int redBufferLen = numofVariableBuff_avx512(redLen);

   cpSize window = gsMontExp_WinSize(bitsizeE);
   cpSize nPrecomute= 1<<window;
   BNU_CHUNK_T wmask = nPrecomute -1;
   int n;

   #ifdef _EXP_AVX512_DEBUG_
   BNU_CHUNK_T dbgValue[32];
   #endif

   BNU_CHUNK_T* redTable = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR(pBuffer, CACHE_LINE_SIZE));
   BNU_CHUNK_T* redM = redTable + gsGetScrambleBufferSize(redLen, window);
   BNU_CHUNK_T* redY = redM + redBufferLen;
   BNU_CHUNK_T* redT = redY + redBufferLen;
   BNU_CHUNK_T* redBuffer = redT + redBufferLen;
   BNU_CHUNK_T* redE = redBuffer + redBufferLen*3;

   /* convert modulus into reduced domain */
   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataM, nsM);
   regular_dig52(redM, redBuffer, almMM_bitsize);

   /* compute taget domain Montgomery converter RR' */
   ZEXPAND_BNU(redBuffer, 0, redBufferLen);
   SET_BIT(redBuffer, (4*redLen*EXP_DIGIT_SIZE_AVX512- 4*cnvMM_bitsize));
   regular_dig52(redY, redBuffer, almMM_bitsize);

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataRR, nsM);
   regular_dig52(redT, redBuffer, almMM_bitsize);
   AMM52(redT, redT, redT, redM, k0, redLen, redBuffer);
   AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);

   /*
      pre-compute T[i] = X^i, i=0,.., 2^w-1
   */
   ZEXPAND_BNU(redY, 0, redBufferLen);
   redY[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   gsScramblePut(redTable, 0, redY, redLen, window);
   #ifdef _EXP_AVX512_DEBUG_
   debugToConvMontDomain(dbgValue, redY, redM, almMM_bitsize, dataM, dataRR, nsM, k0, redBuffer);
   #endif

   ZEXPAND_COPY_BNU(redBuffer, redBufferLen, dataX, nsX);
   regular_dig52(redY, redBuffer, almMM_bitsize);
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   gsScramblePut(redTable, 1, redY, redLen, window);
   #ifdef _EXP_AVX512_DEBUG_
   debugToConvMontDomain(dbgValue, redY, redM, almMM_bitsize, dataM, dataRR, nsM, k0, redBuffer);
   #endif

   AMM52(redT, redY, redY, redM, k0, redLen, redBuffer);
   gsScramblePut(redTable, 2, redT, redLen, window);
   #ifdef _EXP_AVX512_DEBUG_
   debugToConvMontDomain(dbgValue, redT, redM, almMM_bitsize, dataM, dataRR, nsM, k0, redBuffer);
   #endif

   for(n=3; n<nPrecomute; n++) {
      AMM52(redT, redT, redY, redM, k0, redLen, redBuffer);
      gsScramblePut(redTable, n, redT, redLen, window);
      #ifdef _EXP_AVX512_DEBUG_
      debugToConvMontDomain(dbgValue, redT, redM, almMM_bitsize, dataM, dataRR, nsM, k0, redBuffer);
      #endif
   }

   /* expand exponent */
   ZEXPAND_COPY_BNU(redE, nsM+1, dataE, nsE);
   bitsizeE = ((bitsizeE+window-1)/window) *window;

   /* exponentiation */
   {
      /* position of the 1-st (left) window */
      int eBit = bitsizeE - window;

      /* extract 1-st window value */
      Ipp32u eChunk = *((Ipp32u*)((Ipp16u*)redE+ eBit/BITSIZE(Ipp16u)));
      int shift = eBit & 0xF;
      cpSize windowVal = (eChunk>>shift) &wmask;

      /* initialize result */
      gsScrambleGet_sscm(redY, redLen, redTable, windowVal, window);
      #ifdef _EXP_AVX512_DEBUG_
      debugToConvMontDomain(dbgValue, redY, redM, almMM_bitsize, dataM, dataRR, nsM, k0, redBuffer);
      #endif

      for(eBit-=window; eBit>=0; eBit-=window) {
         /* do squaring window-times */
         for(n=0; n<window; n++) {
            AMM52(redY, redY, redY, redM, k0, redLen, redBuffer);
         }

         /* extract next window value */
         eChunk = *((Ipp32u*)((Ipp16u*)redE+ eBit/BITSIZE(Ipp16u)));
         shift = eBit & 0xF;
         windowVal = (eChunk>>shift) &wmask;

         /* exptact precomputed value and muptiply */
         gsScrambleGet_sscm(redT, redLen, redTable, windowVal, window);
         /* muptiply */
         AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
      }
   }

   /* convert result back */
   ZEXPAND_BNU(redT, 0, redBufferLen);
   redT[0] = 1;
   AMM52(redY, redY, redT, redM, k0, redLen, redBuffer);
   dig52_regular(dataY, redY, cnvMM_bitsize);

   return nsM;
}
#endif /* _USE_WINDOW_EXP_ */

#endif /* _IPP32E_K0 */
