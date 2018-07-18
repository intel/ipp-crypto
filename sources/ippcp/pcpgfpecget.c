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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     EC over GF(p^m) definitinons
// 
//     Context:
//        ippsGFpECGet()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpeccp.h"

/*F*
// Name: ippsGFpECGet
//
// Purpose: Extracts the parameters of an elliptic curve
//
// Returns:                   Reason:
//    ippStsNullPtrErr              NULL == pEC
//
//    ippStsContextMatchErr         invalid pEC->idCtx
//                                  invalid pA->idCtx
//                                  invalid pB->idCtx
//
//    ippStsOutOfRangeErr           GFPE_ROOM(pA)!=GFP_FELEN(pGFE)
//                                  GFPE_ROOM(pB)!=GFP_FELEN(pGFE)
//
//    ippStsNoErr                   no error
//
// Parameters:
//    ppGFp      Pointer to the pointer to the context of underlying finite field
//    pA         Pointer to a copy of the coefficient A of the equation defining the elliptic curve
//    pB         Pointer to a copy of the coefficient B of the equation defining the elliptic curve
//    pEC        Pointer to the context of the elliptic curve
//
*F*/

IPPFUN(IppStatus, ippsGFpECGet,(IppsGFpState** const ppGFp,
                                IppsGFpElement* pA, IppsGFpElement* pB,
                                const IppsGFpECState* pEC))
{
   IPP_BAD_PTR1_RET(pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET( !ECP_TEST_ID(pEC), ippStsContextMatchErr );

   {
      const IppsGFpState* pGF = ECP_GFP(pEC);
      gsModEngine* pGFE = GFP_PMA(pGF);
      Ipp32u elementSize = GFP_FELEN(pGFE);

      if(ppGFp) {
         *ppGFp = (IppsGFpState*)pGF;
      }

      if(pA) {
         IPP_BADARG_RET( !GFPE_TEST_ID(pA), ippStsContextMatchErr );
         IPP_BADARG_RET( GFPE_ROOM(pA)!=GFP_FELEN(pGFE), ippStsOutOfRangeErr);
         cpGFpElementCopy(GFPE_DATA(pA), ECP_A(pEC), elementSize);
      }
      if(pB) {
         IPP_BADARG_RET( !GFPE_TEST_ID(pB), ippStsContextMatchErr );
         IPP_BADARG_RET( GFPE_ROOM(pB)!=GFP_FELEN(pGFE), ippStsOutOfRangeErr);
         cpGFpElementCopy(GFPE_DATA(pB), ECP_B(pEC), elementSize);
      }

      return ippStsNoErr;
   }
}
