/*******************************************************************************
* Copyright 2010-2018 Intel Corporation
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

/*
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Internal operations over GF(p) extension.
// 
//     Context:
//        cpGFpxExp()
//
*/

#include "owncp.h"
#include "pcpbnumisc.h"
#include "pcpgfpxstuff.h"
#include "gsscramble.h"

//tbcd: temporary excluded: #include <assert.h>

static int div_upper(int a, int d)
{ return (a+d-1)/d; }


#if defined(_IPP_OWN_DBG_)

#include <stdio.h>
//#define _IPP_OWN_DBG_
static void printBNU(const char* note, Ipp64u* pData, int len, int nt)
{
   int n, k;

   if(note)
      printf("%s", note);

   for(n=0, k=0; n<len; n++) {
      Ipp64u x = pData[n];
      printf("%016I64x ", x);
      k++;
      if(k==nt) {
         printf("\n");
         k = 0;
      }
   }
   printf("\n");
}

#endif /* #if defined(_IPP_OWN_DBG_) */


/* sscm version */
BNU_CHUNK_T* cpGFpxExp(BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pE, int nsE,
                     gsModEngine* pGFEx, Ipp8u* pScratchBuffer)
{
   gsModEngine* pBasicGFE = cpGFpBasic(pGFEx);

   /* remove leding zeros */
   FIX_BNU(pE, nsE);

   {
      mod_mul mulF = GFP_METHOD(pGFEx)->mul;  /* mul and sqr methods */
      mod_sqr sqrF = GFP_METHOD(pGFEx)->sqr;

      BNU_CHUNK_T* pScratchAligned; /* aligned scratch buffer */
      int nAllocation = 0;    /* points from the pool */

      /* size of element */
      int elmLen = GFP_FELEN(pGFEx);

      /* exponent bitsize */
      int expBitSize = BITSIZE_BNU(pE, nsE);
      /* optimal size of window */
      int w = (NULL==pScratchBuffer)? 1 : cpGFpGetOptimalWinSize(expBitSize);
      /* number of table entries */
      int nPrecomputed = 1<<w;

      int poolElmLen = GFP_PELEN(pGFEx);
      BNU_CHUNK_T* pExpandedE = cpGFpGetPool(1, pGFEx);
      BNU_CHUNK_T* pTmp = cpGFpGetPool(1, pGFEx);
      //tbcd: temporary excluded: assert(NULL!=pExpandedE && NULL!=pTmp);

      if(NULL==pScratchBuffer) {
         nAllocation = 2 + div_upper(CACHE_LINE_SIZE, poolElmLen*sizeof(BNU_CHUNK_T));
         pScratchBuffer = (Ipp8u*)cpGFpGetPool(nAllocation, pGFEx);
         //tbcd: temporary excluded: assert(NULL!=pScratchBuffer);
      }
      pScratchAligned = (BNU_CHUNK_T*)( IPP_ALIGNED_PTR(pScratchBuffer, CACHE_LINE_SIZE) );

      #if defined(_IPP_OWN_DBG_)
      printf("precom tbl:\n");
      #endif
      /* pre-compute auxiliary table t[] = {A^0, A^1, A^2, ..., A^(2^w-1)} */
      cpGFpElementCopyPadd(pTmp, elmLen, GFP_MNT_R(pBasicGFE), GFP_FELEN(pBasicGFE));
      //cpScramblePut(pScratchAligned+0, nPrecomputed, (Ipp8u*)pTmp, elmDataSize);
      gsScramblePut(pScratchAligned, 0, pTmp, elmLen, w);
      #if defined(_IPP_OWN_DBG_)
      printBNU("precom tbl:\n", pTmp, 48, 6);
      #endif

      { /* pre compute multiplication table */
         int n;
         for(n=1; n<nPrecomputed; n++) {
            mulF(pTmp, pTmp, pA, pGFEx);
            //cpScramblePut(pScratchAligned+n, nPrecomputed, (Ipp8u*)pTmp, elmDataSize);
            gsScramblePut(pScratchAligned, n, pTmp, elmLen, w);
            #if defined(_IPP_OWN_DBG_)
            printBNU("precom tbl:\n", pTmp, 48, 6);
            #endif
         }
      }

      {
         /* copy exponent value */
         cpGFpElementCopy(pExpandedE, pE, nsE);

         /* expand exponent value */
         ((Ipp32u*)pExpandedE)[BITS2WORD32_SIZE(expBitSize)] = 0;
         expBitSize = ((expBitSize+w-1)/w)*w;

         #if defined(_IPP_OWN_DBG_)
         printf("\nexponentiation:\n");
         #endif
         /*
         // exponentiation
         */
         {
            /* digit mask */
            BNU_CHUNK_T dmask = nPrecomputed-1;

            /* position (bit number) of the leftmost window */
            int wPosition = expBitSize-w;

            /* extract leftmost window value */
            Ipp32u eChunk = *((Ipp32u*)((Ipp16u*)pExpandedE+ wPosition/BITSIZE(Ipp16u)));
            int shift = wPosition & 0xF;
            Ipp32u windowVal = (eChunk>>shift) & dmask;

            /* initialize result */
            //cpScrambleGet((Ipp8u*)pR, elmDataSize, pScratchAligned+windowVal, nPrecomputed);
            gsScrambleGet_sscm(pR, elmLen, pScratchAligned, windowVal, w);
            #if defined(_IPP_OWN_DBG_)
            printBNU("init result:\n", pR, 48, 6);
            #endif

            for(wPosition-=w; wPosition>=0; wPosition-=w) {
               int k;
               #if defined(_IPP_OWN_DBG_)
               printf("\nwPosition=%d\n", wPosition);
               #endif
               /* w times squaring */
               for(k=0; k<w; k++) {
                  sqrF(pR, pR, pGFEx);
                  #if defined(_IPP_OWN_DBG_)
                  printBNU("sqr:\n", pR, 48, 6);
                  #endif
               }

               /* extract next window value */
               eChunk = *((Ipp32u*)((Ipp16u*)pExpandedE+ wPosition/BITSIZE(Ipp16u)));
               shift = wPosition & 0xF;
               windowVal = (eChunk>>shift) & dmask;

               /* extract value from the pre-computed table */
               //cpScrambleGet((Ipp8u*)pTmp, elmDataSize, pScratchAligned+windowVal, nPrecomputed);
               gsScrambleGet_sscm(pTmp, elmLen, pScratchAligned, windowVal, w);

               /* and multiply */
               mulF(pR, pR, pTmp, pGFEx);
               #if defined(_IPP_OWN_DBG_)
               printBNU("mul:\n", pR, 48, 6);
               #endif
            }
         }

      }

      cpGFpReleasePool(nAllocation+2, pGFEx);

      return pR;
   }
}
