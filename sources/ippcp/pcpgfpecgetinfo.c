/*******************************************************************************
* Copyright 2019 Intel Corporation
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
//        ippsGFpECGetInfo_GF()
//
*/

#include "owncp.h"
#include "pcpeccp.h"


/*F*
// Name: ippsGFpECGetInfo_GF
//
// Purpose: Returns info regarding underlying GF
//
// Returns:                   Reason:
//    ippStsNullPtrErr              NULL == pEC
//                                  NULL == pInfo
//
//    ippStsContextMatchErr         invalid pEC->idCtx
//
//    ippStsNoErr                   no error
//
// Parameters:
//    pInfo      Pointer to the info structure
//    pEC        Pointer to the context of the elliptic curve being initialized.
//
*F*/
IPPFUN(IppStatus, ippsGFpECGetInfo_GF,(IppsGFpInfo* pInfo, const IppsGFpECState* pEC))
{
   IPP_BAD_PTR2_RET(pInfo, pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET( !ECP_TEST_ID(pEC), ippStsContextMatchErr );

   return ippsGFpGetInfo(pInfo, ECP_GFP(pEC));
   #if 0
   {
      IppsGFpState*  pGF = ECP_GFP(pEC);
      gsModEngine* pGFpx = GFP_PMA(pGF);     /* current */
      gsModEngine* pGFp  = cpGFpBasic(pGFpx); /* basic */
      pInfo->parentGFdegree = MOD_EXTDEG(pGFpx);               /* parent extension */
      pInfo->basicGFdegree = cpGFpBasicDegreeExtension(pGFpx); /* total basic extention */
      pInfo->basicElmBitSize = GFP_FEBITLEN(pGFp);             /* basic bitsise */

      return ippStsNoErr;
   }
   #endif
}
