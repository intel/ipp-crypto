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
//        gfec_MulBasePoint()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "gsscramble.h"

IppsGFpECPoint* gfec_MulBasePoint(IppsGFpECPoint* pR,
                            const BNU_CHUNK_T* pScalar, int scalarLen,
                            IppsGFpECState* pEC, Ipp8u* pScratchBuffer)
{
   FIX_BNU(pScalar, scalarLen);
   {
      gsModEngine* pGForder = ECP_MONT_R(pEC);

      BNU_CHUNK_T* pTmpScalar = cpGFpGetPool(1, pGForder); /* length of scalar does not exceed length of order */
      int orderBits = MOD_BITSIZE(pGForder);
      int orderLen  = MOD_LEN(pGForder);
      cpGFpElementCopyPadd(pTmpScalar,orderLen+1, pScalar,scalarLen);

      if(ECP_PREMULBP(pEC))
         gfec_base_point_mul(ECP_POINT_X(pR),
                             (Ipp8u*)pTmpScalar, orderBits,
                             pEC);
      else
         gfec_point_mul(ECP_POINT_X(pR), ECP_G(pEC),
                        (Ipp8u*)pTmpScalar, orderBits,
                        pEC, pScratchBuffer);
      cpGFpReleasePool(1, pGForder);

      ECP_POINT_FLAGS(pR) = gfec_IsPointAtInfinity(pR)? 0 : ECP_FINITE_POINT;
      return pR;
   }
}
