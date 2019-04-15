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
//
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     EC over GF(p) Operations
//
//     Context:
//        ippsGFpECESGetBuffersSize_SM2()
//
*/

#include "pcpgfpecessm2.h"
#include "pcpgfpecstuff.h"

/*F*
//    Name: ippsGFpECESGetBuffersSize_SM2
//
// Purpose: Returns sizes of used buffers
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pState == NULL if pPublicKeySize != NULL or all the pointers are NULLs
//    ippStsContextMatchErr      pState invalid context if pPublicKeySize != NULL
//    ippStsNoErr                no errors
//
// Parameters:
//    pPublicKeySize   Pointer to write public (x||y) key length in bytes
//    pMaximumTagSize  Pointer to write maximum tag size in bytes
//    pState           Pointer to a state to get pPublicKeySize from
//
*F*/
IPPFUN(IppStatus, ippsGFpECESGetBuffersSize_SM2, (int* pPublicKeySize,
   int* pMaximumTagSize, const IppsECESState_SM2* pState)) {
   IPP_BADARG_RET(pPublicKeySize == NULL && pMaximumTagSize == NULL && pState == NULL, ippStsNullPtrErr);

   if (pMaximumTagSize)
      *pMaximumTagSize = IPP_SM3_DIGEST_BITSIZE / BYTESIZE;
   if (pPublicKeySize) {
      IPP_BAD_PTR1_RET(pState);
      IPP_BADARG_RET(pState->idCtx != idxCtxECES_SM2, ippStsContextMatchErr);
      *pPublicKeySize = pState->sharedSecretLen;
   }

   return ippStsNoErr;
}