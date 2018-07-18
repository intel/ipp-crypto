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
//        gfec_IsPointOnCurve()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "gsscramble.h"


#if ( ECP_PROJECTIVE_COORD == JACOBIAN )
int gfec_IsPointOnCurve(const IppsGFpECPoint* pPoint, IppsGFpECState* pEC)
{
   /* point at infinity does not belong curve */
   if( !IS_ECP_FINITE_POINT(pPoint) )
      //return 1;
      return 0;

   /* test that 0 == R = (Y^2) - (X^3 + A*X*(Z^4) + B*(Z^6)) */
   else {
      int isOnCurve = 0;

      IppsGFpState* pGF = ECP_GFP(pEC);
      gsModEngine* pGFE = GFP_PMA(pGF);

      mod_mul mulF = GFP_METHOD(pGFE)->mul;
      mod_sqr sqrF = GFP_METHOD(pGFE)->sqr;
      mod_sub subF = GFP_METHOD(pGFE)->sub;

      BNU_CHUNK_T* pX = ECP_POINT_X(pPoint);
      BNU_CHUNK_T* pY = ECP_POINT_Y(pPoint);
      BNU_CHUNK_T* pZ = ECP_POINT_Z(pPoint);

      BNU_CHUNK_T* pR = cpGFpGetPool(1, pGFE);
      BNU_CHUNK_T* pT = cpGFpGetPool(1, pGFE);

      sqrF(pR, pY, pGFE);       /* R = Y^2 */
      sqrF(pT, pX, pGFE);       /* T = X^3 */
      mulF(pT, pX, pT, pGFE);
      subF(pR, pR, pT, pGFE);   /* R -= T */

      if( IS_ECP_AFFINE_POINT(pPoint) ) {
         mulF(pT, pX, ECP_A(pEC), pGFE);   /* T = A*X */
         subF(pR, pR, pT, pGFE);               /* R -= T */
         subF(pR, pR, ECP_B(pEC), pGFE);       /* R -= B */
      }
      else {
         BNU_CHUNK_T* pZ4 = cpGFpGetPool(1, pGFE);
         BNU_CHUNK_T* pZ6 = cpGFpGetPool(1, pGFE);

         sqrF(pZ6, pZ, pGFE);         /* Z^2 */
         sqrF(pZ4, pZ6, pGFE);        /* Z^4 */
         mulF(pZ6, pZ6, pZ4, pGFE);   /* Z^6 */

         mulF(pZ4, pZ4, pX, pGFE);         /* X*(Z^4) */
         mulF(pZ4, pZ4, ECP_A(pEC), pGFE); /* A*X*(Z^4) */
         mulF(pZ6, pZ6, ECP_B(pEC), pGFE); /* B*(Z^4) */

         subF(pR, pR, pZ4, pGFE);           /* R -= A*X*(Z^4) */
         subF(pR, pR, pZ6, pGFE);           /* R -= B*(Z^6)   */

         cpGFpReleasePool(2, pGFE);
      }

      isOnCurve = GFP_IS_ZERO(pR, GFP_FELEN(pGFE));
      cpGFpReleasePool(2, pGFE);
      return isOnCurve;
   }
}
#endif
