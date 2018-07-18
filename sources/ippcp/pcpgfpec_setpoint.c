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
//        gfec_SetPoint()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "gsscramble.h"

static int gfec_IsAffinePointAtInfinity(int ecInfinity,
                           const BNU_CHUNK_T* pX, const BNU_CHUNK_T* pY,
                           const IppsGFpState* pGF)
{
   gsModEngine* pGFE = GFP_PMA(pGF);
   int elmLen = GFP_FELEN(pGFE);

   int atInfinity = GFP_IS_ZERO(pX,elmLen);

   BNU_CHUNK_T* tmpY = cpGFpGetPool(1, pGFE);

   /* set tmpY either:
   // 0,       if ec.b !=0
   // mont(1)  if ec.b ==0
   */
   cpGFpElementPadd(tmpY, elmLen, 0);
   if(ecInfinity) {
      gsModEngine* pBasicGFE = cpGFpBasic(pGFE);
      int basicElmLen = GFP_FELEN(pBasicGFE);
      BNU_CHUNK_T* mont1 = GFP_MNT_R(pBasicGFE);
      cpGFpElementCopyPadd(tmpY, elmLen, mont1, basicElmLen);
   }

   /* check if (x,y) represents point at infinity */
   atInfinity &= GFP_EQ(pY, tmpY, elmLen);

   cpGFpReleasePool(1, pGFE);
   return atInfinity;
}

/* returns: 1/0 if set up finite/infinite point */
int gfec_SetPoint(BNU_CHUNK_T* pPointData,
            const BNU_CHUNK_T* pX, const BNU_CHUNK_T* pY,
                  IppsGFpECState* pEC)
{
   IppsGFpState* pGF = ECP_GFP(pEC);
   gsModEngine* pGFE = GFP_PMA(pGF);
   int elmLen = GFP_FELEN(pGFE);

   int finite_point= !gfec_IsAffinePointAtInfinity(ECP_INFINITY(pEC), pX, pY, pGF);
   if(finite_point) {
      gsModEngine* pBasicGFE = cpGFpBasic(pGFE);
      cpGFpElementCopy(pPointData, pX, elmLen);
      cpGFpElementCopy(pPointData+elmLen, pY, elmLen);
      cpGFpElementCopyPadd(pPointData+elmLen*2, elmLen, GFP_MNT_R(pBasicGFE), GFP_FELEN(pBasicGFE));
   }
   else
      cpGFpElementPadd(pPointData, 3*elmLen, 0);

   return finite_point;
}
