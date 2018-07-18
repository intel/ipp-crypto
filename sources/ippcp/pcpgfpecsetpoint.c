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
//     EC over GF(p) Operations
//
//     Context:
//        ippsGFpECSetPoint()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcphash.h"
#include "pcphash_rmf.h"

/*F*
// Name: ippsGFpECSetPoint
//
// Purpose: Sets a point on an elliptic curve
//
// Returns:                   Reason:
//    ippStsNullPtrErr          pPoint == NULL
//                              pEC == NULL
//                              pX == NULL
//                              pY == NULL
//
//    ippStsContextMatchErr     invalid pEC->idCtx
//                              invalid pPoint->idCtx
//                              invalid pX->idCtx
//                              invalid pY->idCtx
//
//    ippStsOutOfRangeErr       ECP_POINT_FELEN(pX)!=GFP_FELEN()
//                              ECP_POINT_FELEN(pY)!=GFP_FELEN()
//                              ECP_POINT_FELEN(pPoint)!=GFP_FELEN()
//
//    ippStsNoErr               no error
//
// Parameters:
//    pX, pY    Pointers to the X and Y coordinates of a point on the elliptic curve
//    pPoint    Pointer to the IppsGFpECPoint context
//    pEC       Pointer to the context of the elliptic curve
//
*F*/

IPPFUN(IppStatus, ippsGFpECSetPoint,(const IppsGFpElement* pX, const IppsGFpElement* pY,
                                           IppsGFpECPoint* pPoint,
                                           IppsGFpECState* pEC))
{
   IPP_BAD_PTR2_RET(pPoint, pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET( !ECP_TEST_ID(pEC), ippStsContextMatchErr );
   IPP_BADARG_RET( !ECP_POINT_TEST_ID(pPoint), ippStsContextMatchErr );

   IPP_BAD_PTR2_RET(pX, pY);
   IPP_BADARG_RET( !GFPE_TEST_ID(pX), ippStsContextMatchErr );
   IPP_BADARG_RET( !GFPE_TEST_ID(pY), ippStsContextMatchErr );

   IPP_BADARG_RET( GFPE_ROOM(pX)!=GFP_FELEN(GFP_PMA(ECP_GFP(pEC))), ippStsOutOfRangeErr);
   IPP_BADARG_RET( GFPE_ROOM(pY)!=GFP_FELEN(GFP_PMA(ECP_GFP(pEC))), ippStsOutOfRangeErr);
   IPP_BADARG_RET( ECP_POINT_FELEN(pPoint)!=GFP_FELEN(GFP_PMA(ECP_GFP(pEC))), ippStsOutOfRangeErr);

   if(gfec_SetPoint(ECP_POINT_DATA(pPoint), GFPE_DATA(pX), GFPE_DATA(pY), pEC))
      ECP_POINT_FLAGS(pPoint) = ECP_AFFINE_POINT | ECP_FINITE_POINT;
   else
      ECP_POINT_FLAGS(pPoint) = 0;
   return ippStsNoErr;
}
