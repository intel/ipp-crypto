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
//        cpPackPrimeCtx()
//
*/

#include "owncp.h"
#include "pcpprimeg.h"
#include "pcptool.h"

/*F*
//    Name: cpPackPrimeCtx
//
// Purpose: Serialize prime context
//
// Parameters:
//    pCtx    context
//    pBuffer buffer
*F*/

void cpPackPrimeCtx(const IppsPrimeState* pCtx, Ipp8u* pBuffer)
{
   IppsPrimeState* pAlignedBuffer = (IppsPrimeState*)( IPP_ALIGNED_PTR(pBuffer, PRIME_ALIGNMENT) );

   /* max length of prime */
   cpSize nsPrime = BITS_BNU_CHUNK(PRIME_MAXBITSIZE(pCtx));

   CopyBlock(pCtx, pAlignedBuffer, sizeof(IppsPrimeState));
   PRIME_NUMBER(pAlignedBuffer)=  (BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(PRIME_NUMBER(pCtx))-IPP_UINT_PTR(pCtx));
   PRIME_TEMP1(pAlignedBuffer) =  (BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(PRIME_TEMP1(pCtx))-IPP_UINT_PTR(pCtx));
   PRIME_TEMP2(pAlignedBuffer) =  (BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(PRIME_TEMP2(pCtx))-IPP_UINT_PTR(pCtx));
   PRIME_TEMP3(pAlignedBuffer) =  (BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(PRIME_TEMP3(pCtx))-IPP_UINT_PTR(pCtx));
   PRIME_MONT(pAlignedBuffer)  =  (gsModEngine*)((Ipp8u*)NULL + IPP_UINT_PTR(PRIME_MONT(pCtx))-IPP_UINT_PTR(pCtx));

   CopyBlock(PRIME_NUMBER(pCtx), (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(PRIME_NUMBER(pAlignedBuffer)), nsPrime*(Ipp32s)sizeof(BNU_CHUNK_T));
   gsPackModEngineCtx(PRIME_MONT(pCtx), (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(PRIME_MONT(pAlignedBuffer)));
}
