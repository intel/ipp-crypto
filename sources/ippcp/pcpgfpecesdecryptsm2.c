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
//        ippsGFpECESDecrypt_SM2()
//
*/

#include "pcpgfpecessm2.h"
#include "pcpgfpecstuff.h"

/*F*
//    Name: ippsGFpECESDecrypt_SM2
//
// Purpose: Decrypts the given buffer, updates the auth tag
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pInput == NULL / pOutput == NULL / pState == NULL
//    ippStsContextMatchErr      pState invalid context or the algorithm is in an invalid state
//    ippStsSizeErr              dataLen < 0
//    ippStsNoErr                no errors
//
// Parameters:
//    pInput          Pointer to input data
//    pOutput         Pointer to output data
//    dataLen         Size of input and output buffers
//    pState          Pointer to a SM2 algorithm state
//
*F*/
IPPFUN(IppStatus, ippsGFpECESDecrypt_SM2, (const Ipp8u* pInput, Ipp8u* pOutput, int dataLen, IppsECESState_SM2* pState)) {
   IPP_BAD_PTR3_RET(pInput, pOutput, pState);
   IPP_BADARG_RET(pState->idCtx != idxCtxECES_SM2, ippStsContextMatchErr);
   /* a shared secret should be computed and the process should not be finished by getTag */
   IPP_BADARG_RET(pState->state != ECESAlgoProcessing, ippStsIncompleteContextErr);
   IPP_BADARG_RET(dataLen < 0, ippStsSizeErr);

   {
      int i;
      for (i = 0; i < dataLen; ++i) {
         pOutput[i] = pInput[i] ^ cpECES_SM2KdfNextByte(pState);
      }
   }
   ippsHashUpdate_rmf(pOutput, dataLen, pState->pTagHasher);

   return ippStsNoErr;
}