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
//
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Internal EC over GF(p^m) basic Definitions & Function Prototypes
//
//     Context:
//        gfec_BasePointProduct()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "gsscramble.h"


IppsGFpECPoint* gfec_BasePointProduct(IppsGFpECPoint* pR,
                        const BNU_CHUNK_T* pScalarG, int scalarGlen,
                        const IppsGFpECPoint* pP, const BNU_CHUNK_T* pScalarP, int scalarPlen,
                        IppsGFpECState* pEC, Ipp8u* pScratchBuffer)
{
   FIX_BNU(pScalarG, scalarGlen);
   FIX_BNU(pScalarP, scalarPlen);

   {
      gsModEngine* pGForder = ECP_MONT_R(pEC);
      int orderBits = MOD_BITSIZE(pGForder);
      int orderLen  = MOD_LEN(pGForder);
      BNU_CHUNK_T* tmpScalarG = cpGFpGetPool(2, pGForder);
      BNU_CHUNK_T* tmpScalarP = tmpScalarG+orderLen+1;

      cpGFpElementCopyPadd(tmpScalarG, orderLen+1, pScalarG,scalarGlen);
      cpGFpElementCopyPadd(tmpScalarP, orderLen+1, pScalarP,scalarPlen);

      if(ECP_PREMULBP(pEC)) {
         BNU_CHUNK_T* productG = cpEcGFpGetPool(2, pEC);
         BNU_CHUNK_T* productP = productG+ECP_POINTLEN(pEC);

         gfec_base_point_mul(productG, (Ipp8u*)tmpScalarG, orderBits, pEC);
         gfec_point_mul(productP, ECP_POINT_X(pP), (Ipp8u*)tmpScalarP, orderBits, pEC, pScratchBuffer);
         gfec_point_add(ECP_POINT_X(pR), productG, productP, pEC);

         cpEcGFpReleasePool(2, pEC);
      }

      else {
         gfec_point_prod(ECP_POINT_X(pR),
                         ECP_G(pEC), (Ipp8u*)tmpScalarG,
                         ECP_POINT_X(pP), (Ipp8u*)tmpScalarP,
                         orderBits,
                         pEC, pScratchBuffer);
      }

      cpGFpReleasePool(2, pGForder);
   }

   ECP_POINT_FLAGS(pR) = gfec_IsPointAtInfinity(pR)? 0 : ECP_FINITE_POINT;
   return pR;
}
