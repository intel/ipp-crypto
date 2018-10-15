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
//        ippsGFpECESGetSize_SM2()
//
*/

#include "pcpgfpecessm2.h"
#include "pcpgfpecstuff.h"

/*F*
//    Name: ippsGFpECESGetSize_SM2
//
// Purpose: Computes space required to allocate a SM2 algorithm state
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pSize == NULL / pEC == NULL
//    ippStsContextMatchErr      pEC invalid context
//    ippStsNotSupportedModeErr  pGFE->extdegree > 1
//    ippStsNoErr                no errors
//
// Parameters:
//    pEC             Pointer to an EC to calculate a shared secret size
//    pSize           Pointer to write a SM2 algorithm state size
//
*F*/
IPPFUN(IppStatus, ippsGFpECESGetSize_SM2, (const IppsGFpECState* pEC, int* pSize)) {
   IPP_BAD_PTR2_RET(pEC, pSize);
   IPP_BADARG_RET(pEC->idCtx != idCtxGFPEC, ippStsContextMatchErr);
   IPP_BADARG_RET(!pEC->subgroup, ippStsContextMatchErr);
   IPP_BADARG_RET(1 < pEC->pGF->pGFE->extdegree, ippStsNotSupportedModeErr);

   {
      int sm3size;
      ippsHashGetSize_rmf(&sm3size);

      *pSize = sizeof(IppsECESState_SM2) + sm3size * 2 + BITS2WORD8_SIZE(pEC->pGF->pGFE->modBitLen) * 2;
   }

   return ippStsNoErr;
}