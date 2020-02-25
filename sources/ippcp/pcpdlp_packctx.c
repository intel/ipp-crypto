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
//        cpPackDLPCtx()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"
#include "pcptool.h"

void cpPackDLPCtx(const IppsDLPState* pDLP, Ipp8u* pBuffer)
{
   IppsDLPState* pAlignedBuffer = (IppsDLPState*)( IPP_ALIGNED_PTR(pBuffer, DLP_ALIGNMENT) );

   CopyBlock(pDLP, pAlignedBuffer, sizeof(IppsDLPState));
   DLP_MONTP0(pAlignedBuffer) = (gsModEngine*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_MONTP0(pDLP))-IPP_UINT_PTR(pDLP));
   DLP_MONTP1(pAlignedBuffer)  = NULL;
   DLP_MONTR(pAlignedBuffer)   =   (gsModEngine*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_MONTR(pDLP))   -IPP_UINT_PTR(pDLP));

   DLP_GENC(pAlignedBuffer)    = (IppsBigNumState*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_GENC(pDLP))    -IPP_UINT_PTR(pDLP));
   DLP_X(pAlignedBuffer)       = (IppsBigNumState*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_X(pDLP))       -IPP_UINT_PTR(pDLP));
   DLP_YENC(pAlignedBuffer)    = (IppsBigNumState*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_YENC(pDLP))    -IPP_UINT_PTR(pDLP));

   DLP_PRIMEGEN(pAlignedBuffer)=  (IppsPrimeState*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_PRIMEGEN(pDLP))-IPP_UINT_PTR(pDLP));

   DLP_METBL(pAlignedBuffer)   = (BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_METBL(pDLP)) -IPP_UINT_PTR(pDLP));

   DLP_BNCTX(pAlignedBuffer)   =  (BigNumNode*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_BNCTX(pDLP))   -IPP_UINT_PTR(pDLP));
   #if defined(_USE_WINDOW_EXP_)
   DLP_BNUCTX0(pAlignedBuffer) = (WINDOW==DLP_EXPMETHOD(pDLP))?(BNU_CHUNK_T*)((Ipp8u*)NULL + IPP_UINT_PTR(DLP_BNUCTX0(pDLP))-IPP_UINT_PTR(pDLP)) : NULL;
   DLP_BNUCTX1(pAlignedBuffer) = NULL;
   #endif

   gsPackModEngineCtx(DLP_MONTP0(pDLP),    (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTP0(pAlignedBuffer)));
   gsPackModEngineCtx(DLP_MONTR(pDLP),     (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTR(pAlignedBuffer)));

   cpPackBigNumCtx(DLP_GENC(pDLP),    (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_GENC(pAlignedBuffer)));
   cpPackBigNumCtx(DLP_X(pDLP),       (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_X(pAlignedBuffer)));
   cpPackBigNumCtx(DLP_YENC(pDLP),    (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_YENC(pAlignedBuffer)));

   cpPackPrimeCtx(DLP_PRIMEGEN(pDLP), (Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_PRIMEGEN(pAlignedBuffer)));
}
