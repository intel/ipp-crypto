/*******************************************************************************
* Copyright 2018 Intel Corporation
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
//     GF(p^d) methods
//
*/
#include "owncp.h"

#include "pcpgfpxstuff.h"
#include "pcpgfpxmethod_com.h"

//tbcd: temporary excluded: #include <assert.h>

BNU_CHUNK_T* cpGFpxSqr_com(BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsEngine* pGFEx)
{
   int extDegree = GFP_EXTDEGREE(pGFEx);

   BNU_CHUNK_T* pGFpolynomial = GFP_MODULUS(pGFEx);
   int degR = extDegree-1;
   int elemLen= GFP_FELEN(pGFEx);

   int degA = degR;
   BNU_CHUNK_T* pTmpProduct = cpGFpGetPool(2, pGFEx);
   BNU_CHUNK_T* pTmpResult = pTmpProduct + GFP_PELEN(pGFEx);

   gsEngine* pGroundGFE = GFP_PARENT(pGFEx);
   BNU_CHUNK_T* r = cpGFpGetPool(1, pGroundGFE);
   int groundElemLen = GFP_FELEN(pGroundGFE);

   const BNU_CHUNK_T* pTmpA = GFPX_IDX_ELEMENT(pA, degA, groundElemLen);

    //tbcd: temporary excluded: assert(NULL!=pTmpProduct && NULL!=r);

   /* clear temporary */
   cpGFpElementPadd(pTmpProduct, elemLen, 0);

   /* R = A * A[degA-1] */
   cpGFpxMul_GFE(pTmpResult, pA, pTmpA, pGFEx);

   for(degA-=1; degA>=0; degA--) {
      /* save R[degR-1] */
      cpGFpElementCopy(r, GFPX_IDX_ELEMENT(pTmpResult, degR, groundElemLen), groundElemLen);

      { /* R = R * x */
         int j;
         for (j=degR; j>=1; j--)
            cpGFpElementCopy(GFPX_IDX_ELEMENT(pTmpResult, j, groundElemLen), GFPX_IDX_ELEMENT(pTmpResult, j-1, groundElemLen), groundElemLen);
         cpGFpElementPadd(pTmpResult, groundElemLen, 0);
      }

      cpGFpxMul_GFE(pTmpProduct, pGFpolynomial, r, pGFEx);
      GFP_METHOD(pGFEx)->sub(pTmpResult, pTmpResult, pTmpProduct, pGFEx);

      /* A[degA-i] */
      pTmpA -= groundElemLen;
      cpGFpxMul_GFE(pTmpProduct, pA, pTmpA, pGFEx);
      GFP_METHOD(pGFEx)->add(pTmpResult, pTmpResult, pTmpProduct, pGFEx);
   }

   /* copy result */
   cpGFpElementCopy(pR, pTmpResult, elemLen);

   /* release pools */
   cpGFpReleasePool(1, pGroundGFE);
   cpGFpReleasePool(2, pGFEx);

   return pR;
}
