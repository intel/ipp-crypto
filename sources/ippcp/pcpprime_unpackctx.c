/*******************************************************************************
* Copyright 2004-2020 Intel Corporation
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
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptographic Primitives (ippcp)
//     Prime Number Primitives.
// 
//  Contents:
//        cpUnpackPrimeCtx()
//
*/

#include "owncp.h"
#include "pcpprimeg.h"
#include "pcptool.h"

/*F*
//    Name: cpUnpackPrimeCtx
//
// Purpose: Deserialize prime context
//
// Parameters:
//    pCtx    context
//    pBuffer buffer
*F*/

void cpUnpackPrimeCtx(const Ipp8u* pBuffer, IppsPrimeState* pCtx)
{
   IppsPrimeState* pAlignedBuffer = (IppsPrimeState*)( IPP_ALIGNED_PTR(pBuffer, PRIME_ALIGNMENT) );

   /* max length of prime */
   cpSize nsPrime = BITS_BNU_CHUNK(PRIME_MAXBITSIZE(pAlignedBuffer));

   CopyBlock(pAlignedBuffer, pCtx, sizeof(IppsPrimeState));
   PRIME_NUMBER(pCtx)=   (BNU_CHUNK_T*)((Ipp8u*)pCtx+ IPP_UINT_PTR(PRIME_NUMBER(pAlignedBuffer)));
   PRIME_TEMP1(pCtx) =   (BNU_CHUNK_T*)((Ipp8u*)pCtx+ IPP_UINT_PTR(PRIME_TEMP1(pAlignedBuffer)));
   PRIME_TEMP2(pCtx) =   (BNU_CHUNK_T*)((Ipp8u*)pCtx+ IPP_UINT_PTR(PRIME_TEMP2(pAlignedBuffer)));
   PRIME_TEMP3(pCtx) =   (BNU_CHUNK_T*)((Ipp8u*)pCtx+ IPP_UINT_PTR(PRIME_TEMP3(pAlignedBuffer)));
   PRIME_MONT(pCtx)  =   (gsModEngine*)((Ipp8u*)pCtx+ IPP_UINT_PTR(PRIME_MONT(pAlignedBuffer)));

   CopyBlock((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(PRIME_NUMBER(pAlignedBuffer)), PRIME_NUMBER(pCtx), nsPrime*(Ipp32s)sizeof(BNU_CHUNK_T));
   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(PRIME_MONT(pAlignedBuffer)), PRIME_MONT(pCtx));
}
