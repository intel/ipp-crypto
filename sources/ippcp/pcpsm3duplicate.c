/*******************************************************************************
* Copyright 2013-2020 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

/* 
// 
//  Purpose:
//     Cryptography Primitive.
//     Digesting message according to SM3
// 
//  Contents:
//        ippsSM3Duplicate()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_rmf.h"
#include "pcptool.h"

/*F*
//    Name: ippsSM3Duplicate
//
// Purpose: Clone SM3 state.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSrcState == NULL
//                            pDstState == NULL
//    ippStsContextMatchErr   pSrcState->idCtx != idCtxSM3
//                            pDstState->idCtx != idCtxSM3
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrcState   pointer to the source SM3 state
//    pDstState   pointer to the target SM3 state
//
// Note:
//    pDstState may to be uninitialized by ippsSM3Init()
//
*F*/
IPPFUN(IppStatus, ippsSM3Duplicate,(const IppsSM3State* pSrcState, IppsSM3State* pDstState))
{
   /* test state pointers */
   IPP_BAD_PTR2_RET(pSrcState, pDstState);
   pSrcState = (IppsSM3State*)( IPP_ALIGNED_PTR(pSrcState, SM3_ALIGNMENT) );
   pDstState = (IppsSM3State*)( IPP_ALIGNED_PTR(pDstState, SM3_ALIGNMENT) );
   IPP_BADARG_RET(idCtxSM3 !=HASH_CTX_ID(pSrcState), ippStsContextMatchErr);

   /* copy state */
   CopyBlock(pSrcState, pDstState, sizeof(IppsSM3State));

   return ippStsNoErr;
}
