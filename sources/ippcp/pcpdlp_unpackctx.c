/*******************************************************************************
* Copyright 2005-2020 Intel Corporation
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
//     DL over Prime Field (initialization)
// 
//  Contents:
//        cpUnpackDLPCtx()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"
#include "pcptool.h"

void cpUnpackDLPCtx(const Ipp8u* pBuffer, IppsDLPState* pDLP)
{
   IppsDLPState* pAlignedBuffer = (IppsDLPState*)( IPP_ALIGNED_PTR(pBuffer, DLP_ALIGNMENT) );

   CopyBlock(pAlignedBuffer, pDLP, sizeof(IppsDLPState));
   DLP_MONTP0(pDLP) =   (gsModEngine*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_MONTP0(pAlignedBuffer)));
   DLP_MONTP1(pDLP) = NULL;
   DLP_MONTR(pDLP)   =   (gsModEngine*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_MONTR(pAlignedBuffer)));

   DLP_GENC(pDLP)    = (IppsBigNumState*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_GENC(pAlignedBuffer)));
   DLP_X(pDLP)       = (IppsBigNumState*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_X(pAlignedBuffer)));
   DLP_YENC(pDLP)    = (IppsBigNumState*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_YENC(pAlignedBuffer)));

   DLP_PRIMEGEN(pDLP)=  (IppsPrimeState*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_PRIMEGEN(pAlignedBuffer)));

   DLP_METBL(pDLP)   = (BNU_CHUNK_T*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_METBL(pAlignedBuffer)));
   DLP_BNCTX(pDLP)   =      (BigNumNode*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_BNCTX(pAlignedBuffer)));
   #if defined(_USE_WINDOW_EXP_)
   DLP_BNUCTX0(pDLP) = (WINDOW==DLP_EXPMETHOD(pDLP))?(BNU_CHUNK_T*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_BNUCTX0(pAlignedBuffer))) : NULL;
   DLP_BNUCTX1(pDLP) = NULL;
   #endif

   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTP0(pAlignedBuffer)), DLP_MONTP0(pDLP));
   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTR(pAlignedBuffer)),    DLP_MONTR(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_GENC(pAlignedBuffer)),   DLP_GENC(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_X(pAlignedBuffer)),      DLP_X(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_YENC(pAlignedBuffer)),   DLP_YENC(pDLP));
   cpUnpackPrimeCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_PRIMEGEN(pAlignedBuffer)),DLP_PRIMEGEN(pDLP));
   cpBigNumListInit(DLP_BITSIZEP(pDLP)+1, BNLISTSIZE, DLP_BNCTX(pDLP));
}
