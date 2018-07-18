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
//        gfec_MakePoint()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "gsscramble.h"

int gfec_MakePoint(IppsGFpECPoint* pPoint, const BNU_CHUNK_T* pElm, IppsGFpECState* pEC)
{
   IppsGFpState* pGF = ECP_GFP(pEC);
   gsModEngine* pGFE = GFP_PMA(pGF);
   int elemLen = GFP_FELEN(pGFE);

   mod_mul mulF = GFP_METHOD(pGFE)->mul;
   mod_sqr sqrF = GFP_METHOD(pGFE)->sqr;
   mod_add addF = GFP_METHOD(pGFE)->add;

   BNU_CHUNK_T* pX = ECP_POINT_X(pPoint);
   BNU_CHUNK_T* pY = ECP_POINT_Y(pPoint);
   BNU_CHUNK_T* pZ = ECP_POINT_Z(pPoint);

   /* set x-coordinate */
   cpGFpElementCopy(pX, pElm, elemLen);

   /* T = X^3 + A*X + B */
   sqrF(pY, pX, pGFE);
   mulF(pY, pY, pX, pGFE);
   if(ECP_SPECIFIC(pEC)!=ECP_EPID2) {
      mulF(pZ, ECP_A(pEC), pX, pGFE);
      addF(pY, pY, pZ, pGFE);
   }
   addF(pY, pY, ECP_B(pEC), pGFE);

   /* set z-coordinate =1 */
   cpGFpElementCopyPadd(pZ, elemLen, GFP_MNT_R(pGFE), elemLen);

   /* Y = sqrt(Y) */
   if( cpGFpSqrt(pY, pY, pGFE) ) {
      ECP_POINT_FLAGS(pPoint) = ECP_AFFINE_POINT | ECP_FINITE_POINT;
      return 1;
   }
   else {
      gfec_SetPointAtInfinity(pPoint);
      return 0;
   }
}
