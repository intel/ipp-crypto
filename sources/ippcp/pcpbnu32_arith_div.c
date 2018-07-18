/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Internal BNU32 arithmetic.
// 
//  Contents:
//     cpDiv_BNU32()
// 
*/

#include "owncp.h"
#include "pcpbnumisc.h"
#include "pcpbnu32misc.h"
#include "pcpbnu32arith.h"


/*F*
//    Name: cpDiv_BNU32
//
// Purpose: BNU32 division.
//
// Returns:
//    size of result 
//
// Parameters:
//    pX     source X
//    pY     source Y
//    pQ     source quotient
//    sizeQ  pointer to max size of Q
//    sizeX  size of A
//    sizeY  size of B
//
*F*/

#if !((_IPP32E==_IPP32E_M7) || \
      (_IPP32E==_IPP32E_U8) || \
      (_IPP32E==_IPP32E_Y8) || \
      (_IPP32E>=_IPP32E_E9) || \
      (_IPP32E==_IPP32E_N8))
int cpDiv_BNU32(Ipp32u* pQ, cpSize* sizeQ,
                 Ipp32u* pX, cpSize sizeX,
                 Ipp32u* pY, cpSize sizeY)
{
   FIX_BNU(pY,sizeY);
   FIX_BNU(pX,sizeX);

   /* special case */
   if(sizeX < sizeY) {

      if(pQ) {
         pQ[0] = 0;
         *sizeQ = 1;
      }

      return sizeX;
   }

   /* special case */
   if(1 == sizeY) {
      int i;
      Ipp32u r = 0;
      for(i=(int)sizeX-1; i>=0; i--) {
         Ipp64u tmp = MAKEDWORD(pX[i],r);
         Ipp32u q = LODWORD(tmp / pY[0]);
         r = LODWORD(tmp - q*pY[0]);
         if(pQ) pQ[i] = q;
      }

      pX[0] = r;

      if(pQ) {
         FIX_BNU(pQ,sizeX);
         *sizeQ = sizeX;
      }

      return 1;
   }


   /* common case */
   {
      cpSize qs = sizeX-sizeY+1;

      cpSize nlz = cpNLZ_BNU32(pY[sizeY-1]);

      /* normalization */
      pX[sizeX] = 0;
      if(nlz) {
         cpSize ni;

         pX[sizeX] = pX[sizeX-1] >> (32-nlz);
         for(ni=sizeX-1; ni>0; ni--)
            pX[ni] = (pX[ni]<<nlz) | (pX[ni-1]>>(32-nlz));
         pX[0] <<= nlz;

         for(ni=sizeY-1; ni>0; ni--)
            pY[ni] = (pY[ni]<<nlz) | (pY[ni-1]>>(32-nlz));
         pY[0] <<= nlz;
      }

      /*
      // division
      */
      {
         Ipp32u yHi = pY[sizeY-1];

         int i;
         for(i=(int)qs-1; i>=0; i--) {
            Ipp32u extend;

            /* estimate digit of quotient */
            Ipp64u tmp = MAKEDWORD(pX[i+sizeY-1], pX[i+sizeY]);
            Ipp64u q = tmp / yHi;
            Ipp64u r = tmp - q*yHi;

            /* tune estimation above */
            //for(; (q>=CONST_64(0x100000000)) || (Ipp64u)q*pY[sizeY-2] > MAKEDWORD(pX[i+sizeY-2],r); ) {
            for(; HIDWORD(q) || (Ipp64u)q*pY[sizeY-2] > MAKEDWORD(pX[i+sizeY-2],r); ) {
               q -= 1;
               r += yHi;
               if( HIDWORD(r) )
                  break;
            }

            /* multiply and subtract */
            extend = cpSubMulDgt_BNU32(pX+i, pY, sizeY, (Ipp32u)q);
            extend = (pX[i+sizeY] -= extend);

            if(extend) { /* subtracted too much */
               q -= 1;
               extend = cpAdd_BNU32(pX+i, pY, pX+i, sizeY);
               pX[i+sizeY] += extend;
            }

            /* store quotation digit */
            if(pQ) pQ[i] = LODWORD(q);
         }
      }

      /* de-normalization */
      if(nlz) {
         cpSize ni;
         for(ni=0; ni<sizeX; ni++)
            pX[ni] = (pX[ni]>>nlz) | (pX[ni+1]<<(32-nlz));
         for(ni=0; ni<sizeY-1; ni++)
            pY[ni] = (pY[ni]>>nlz) | (pY[ni+1]<<(32-nlz));
         pY[sizeY-1] >>= nlz;
      }

      FIX_BNU(pX,sizeX);

      if(pQ) {
         FIX_BNU(pQ,qs);
         *sizeQ = qs;
      }

      return sizeX;
   }
}
#endif
