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
//        ippsGFpECPointGetSize()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcphash.h"
#include "pcphash_rmf.h"

/*F*
// Name: ippsGFpECPointGetSize
//
// Purpose: Gets the size of the IppsGFpECPoint context
//
// Returns:                   Reason:
//    ippStsNullPtrErr          pEC == NULL
//                              pSize == NULL
//
//    ippStsContextMatchErr     invalid pEC->idCtx
//
//    ippStsNoErr               no error
//
// Parameters:
//    pEC             Pointer to the context of the elliptic curve
//    pSize           Pointer to the buffer size
//
*F*/

IPPFUN(IppStatus, ippsGFpECPointGetSize,(const IppsGFpECState* pEC, int* pSize))
{
   IPP_BAD_PTR2_RET(pEC, pSize);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET( !ECP_TEST_ID(pEC), ippStsContextMatchErr );

   {
      int elemLen = GFP_FELEN(GFP_PMA(ECP_GFP(pEC)));
      *pSize = sizeof(IppsGFpECPoint)
                     +elemLen*sizeof(BNU_CHUNK_T) /* X */
                     +elemLen*sizeof(BNU_CHUNK_T) /* Y */
                     +elemLen*sizeof(BNU_CHUNK_T);/* Z */
      return ippStsNoErr;
   }
}

/*F*
// Name: ippsGFpECPointInit
//
// Purpose: Initializes the context of a point on an elliptic curve
//
// Returns:                   Reason:
//    ippStsNullPtrErr          pPoint == NULL
//                              pEC == NULL
//
//    ippStsContextMatchErr     invalid pEC->idCtx
//
//    ippStsNoErr               no error
//
// Parameters:
//    pX, pY    Pointers to the X and Y coordinates of a point on the elliptic curve
//    pPoint    Pointer to the IppsGFpECPoint context being initialized
//    pEC       Pointer to the context of the elliptic curve
//
*F*/

IPPFUN(IppStatus, ippsGFpECPointInit,(const IppsGFpElement* pX, const IppsGFpElement* pY,
                                      IppsGFpECPoint* pPoint, IppsGFpECState* pEC))
{
   IPP_BAD_PTR2_RET(pPoint, pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET( !ECP_TEST_ID(pEC), ippStsContextMatchErr );

   {
      Ipp8u* ptr = (Ipp8u*)pPoint;
      int elemLen = GFP_FELEN(GFP_PMA(ECP_GFP(pEC)));

      ECP_POINT_ID(pPoint) = idCtxGFPPoint;
      ECP_POINT_FLAGS(pPoint) = 0;
      ECP_POINT_FELEN(pPoint) = elemLen;
      ptr += sizeof(IppsGFpECPoint);
      ECP_POINT_DATA(pPoint) = (BNU_CHUNK_T*)(ptr);

      if(pX && pY)
         return ippsGFpECSetPoint(pX, pY, pPoint, pEC);
      else {
         gfec_SetPointAtInfinity(pPoint);
         return ippStsNoErr;
      }
   }
}
