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
//     Internal operations over prime GF(p).
//
//     Context:
//        cpGFpRand
//
*/
#include "owncp.h"

#include "pcpbn.h"
#include "pcpgfpstuff.h"

//tbcd: temporary excluded: #include <assert.h>

BNU_CHUNK_T* cpGFpRand(BNU_CHUNK_T* pR, gsModEngine* pGFE, IppBitSupplier rndFunc, void* pRndParam)
{
   int elemLen = GFP_FELEN(pGFE);
   int reqBitSize = GFP_FEBITLEN(pGFE)+GFP_RAND_ADD_BITS;
   int nsR = (reqBitSize +BITSIZE(BNU_CHUNK_T)-1)/BITSIZE(BNU_CHUNK_T);

   int internal_err;

   BNU_CHUNK_T* pPool = cpGFpGetPool(2, pGFE);
   //tbcd: temporary excluded: assert(pPool!=NULL);

   cpGFpElementPadd(pPool, nsR, 0);

   internal_err = ippStsNoErr != rndFunc((Ipp32u*)pPool, reqBitSize, pRndParam);

   if(!internal_err) {
      nsR = cpMod_BNU(pPool, nsR, GFP_MODULUS(pGFE), elemLen);
      cpGFpElementPadd(pPool+nsR, elemLen-nsR, 0);
      GFP_METHOD(pGFE)->encode(pR, pPool, pGFE);
   }

   cpGFpReleasePool(2, pGFE);
   return internal_err? NULL : pR;
}
