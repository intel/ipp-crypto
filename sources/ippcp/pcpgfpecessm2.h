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
//     ES encryption/decryption API
//
//
*/

#if !defined(_CP_GFP_ES_SM2_H)
#define _CP_GFP_ES_SM2_H

#include "owncp.h"

typedef enum {
   ECESAlgoInit,
   ECESAlgoKeySet,
   ECESAlgoProcessing,
   ECESAlgoFinished
} ECESAlgoState;

struct _cpStateECES_SM2 {
   IppCtxId idCtx;
   Ipp8u* pSharedSecret;
   Ipp32s sharedSecretLen;

   ECESAlgoState state;

   Ipp32u kdfCounter;
   Ipp8u pKdfWindow[IPP_SM3_DIGEST_BITSIZE / BYTESIZE];
   Ipp8u wasNonZero;
   Ipp8u kdfIndex;

   IppsHashState_rmf* pKdfHasher;
   IppsHashState_rmf* pTagHasher;
};

/* get a byte, update 0-kdf status */
__INLINE Ipp8u cpECES_SM2KdfNextByte(IppsECESState_SM2* pState) {
   if (pState->kdfIndex == IPP_SM3_DIGEST_BITSIZE / BYTESIZE) {
      ++pState->kdfCounter;
      pState->kdfIndex = 0;

      {
         Ipp8u ctnStr[sizeof(Ipp32u)];
         ippsHashUpdate_rmf(pState->pSharedSecret, pState->sharedSecretLen, pState->pKdfHasher);
         U32_TO_HSTRING(ctnStr, pState->kdfCounter);
         ippsHashUpdate_rmf(ctnStr, sizeof(Ipp32u), pState->pKdfHasher);
         ippsHashFinal_rmf(pState->pKdfWindow, pState->pKdfHasher);
      }
   }

   pState->wasNonZero |= pState->pKdfWindow[pState->kdfIndex];

   return pState->pKdfWindow[pState->kdfIndex++];
}

#endif