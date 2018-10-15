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
//
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     EC over GF(p) Operations
//
//     Context:
//        ippsGFpECGetPointOctString()
//
*/
#include "pcpgfpecessm2.h"
#include "pcpgfpecstuff.h"

/*F*
//    Name: ippsGFpECGetPointOctString
//
// Purpose: Converts a point on EC into x||y octstring
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pPoint == NULL / pEC == NULL / pStr == NULL
//    ippStsContextMatchErr      pEC, pPoint invalid context
//    ippStsNotSupportedModeErr  pGFE->extdegree > 1
//    ippStsSizeErr              strLen is not equal to double GFp element
//    ippStsOutOfRangeErr        the point does not belong to the EC
//    ippStsPointAtInfinity      a point on infinity cannot be converted to a string
//    ippStsNoErr                no errors
//
// Parameters:
//    pStr     pointer to the string to read from
//    strLen   length of the string
//    pPoint   pointer to output point
//    pEC      EC ctx
//
*F*/
IPPFUN(IppStatus, ippsGFpECGetPointOctString, (const IppsGFpECPoint* pPoint,
   Ipp8u* pStr, int strLen, IppsGFpECState* pEC)) {
   IPP_BAD_PTR3_RET(pPoint, pEC, pStr);
   IPP_BADARG_RET(pPoint->idCtx != idCtxGFPPoint, ippStsContextMatchErr);
   IPP_BADARG_RET(pEC->idCtx != idCtxGFPEC, ippStsContextMatchErr);
   IPP_BADARG_RET(!pEC->subgroup, ippStsContextMatchErr);
   IPP_BADARG_RET(1 < pEC->pGF->pGFE->extdegree, ippStsNotSupportedModeErr);

   {
      gsModEngine* pGFE = pEC->pGF->pGFE;
      int elemLen = BITS2WORD8_SIZE(pGFE->modBitLen);
      IPP_BADARG_RET(strLen != elemLen * 2, ippStsSizeErr);
      IPP_BADARG_RET(pPoint->elementSize != pGFE->modLen, ippStsOutOfRangeErr);

      {
         int finitePoint;
         IppsGFpElement ptX, ptY;

         cpGFpElementConstruct(&ptX, cpGFpGetPool(1, pGFE), pGFE->modLen);
         cpGFpElementConstruct(&ptY, cpGFpGetPool(1, pGFE), pGFE->modLen);
         finitePoint = gfec_GetPoint(ptX.pData, ptY.pData, pPoint, pEC);
         if (finitePoint) {
            ippsGFpGetElementOctString(&ptX, pStr, elemLen, pEC->pGF);
            pStr += elemLen;
            ippsGFpGetElementOctString(&ptY, pStr, elemLen, pEC->pGF);
         }

         cpGFpReleasePool(2, pGFE); /* release ptX and ptY from the pool */

         return finitePoint ? ippStsNoErr : ippStsPointAtInfinity;
      }
   }
}
