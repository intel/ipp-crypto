/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
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
//     Cryptography Primitive.
//     Security Hash Standard
//     Generalized Functionality
// 
//  Contents:
//        ippsHashGetTag_rmf()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash_rmf.h"
#include "pcptool.h"


/*F*
//    Name: ippsHashGetTag_rmf
//
// Purpose: Compute digest based on current state.
//          Note, that futher digest update is possible
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pTag == NULL
//                               pState == NULL
//    ippStsContextMatchErr      pState->idCtx != idCtxHash
//    ippStsLengthErr            hashSize < tagLen <1
//    ippStsNoErr                no errors
//
// Parameters:
//    pTag     address of the output digest
//    tagLen   length of digest
//    pState   pointer to the SHS state
//
*F*/
IPPFUN(IppStatus, ippsHashGetTag_rmf,(Ipp8u* pTag, int tagLen, const IppsHashState_rmf* pState))
{
   /* test state pointer and ID */
   IPP_BAD_PTR1_RET(pState);
   pState = (IppsHashState_rmf*)( IPP_ALIGNED_PTR(pState, HASH_ALIGNMENT) );
   IPP_BADARG_RET(idCtxHash !=HASH_CTX_ID(pState), ippStsContextMatchErr);

   /* test digest pointer */
   IPP_BAD_PTR1_RET(pTag);
   IPP_BADARG_RET((tagLen <1) || HASH_METHOD(pState)->hashLen<tagLen, ippStsLengthErr);

   { /* TBD: consider implementation without copy of internal buffer content */
      DigestSHA512 hash;
      const IppsHashMethod* method = HASH_METHOD(pState);
      CopyBlock(HASH_VALUE(pState), hash, sizeof(DigestSHA512));
      cpFinalize_rmf(hash,
                  HASH_BUFF(pState), HAHS_BUFFIDX(pState),
                  HASH_LENLO(pState), HASH_LENHI(pState),
                  method);
      method->hashOctStr(pTag, hash);

      return ippStsNoErr;
   }
}
