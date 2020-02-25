/*******************************************************************************
* Copyright 2002-2020 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
// 
//  Contents:
//     cpUnpackBigNumCtx()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: cpUnpackBigNumCtx
//
// Purpose: Deserialize bigNum context
//
// Parameters:
//    pBN     BigNum
//    pBuffer buffer
*F*/


void cpUnpackBigNumCtx(const Ipp8u* pBuffer, IppsBigNumState* pBN)
{
   IppsBigNumState* pAlignedBuffer = (IppsBigNumState*)(IPP_ALIGNED_PTR((pBuffer), BN_ALIGNMENT));
   CopyBlock(pBuffer, pBN, sizeof(IppsBigNumState));
   BN_NUMBER(pBN) = (BNU_CHUNK_T*)((Ipp8u*)pBN + IPP_UINT_PTR(BN_NUMBER(pAlignedBuffer)));
   BN_BUFFER(pBN) = (BNU_CHUNK_T*)((Ipp8u*)pBN + IPP_UINT_PTR(BN_BUFFER(pAlignedBuffer)));
   CopyBlock((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(BN_NUMBER(pAlignedBuffer)), BN_NUMBER(pBN), BN_ROOM(pBN)*(Ipp32s)sizeof(BNU_CHUNK_T));
   CopyBlock((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(BN_BUFFER(pAlignedBuffer)), BN_BUFFER(pBN), BN_ROOM(pBN)*(Ipp32s)sizeof(BNU_CHUNK_T));
}
