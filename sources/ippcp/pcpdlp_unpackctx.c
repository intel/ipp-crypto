/*******************************************************************************
* Copyright 2005-2019 Intel Corporation
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
   #if defined(_OPENMP)
   DLP_MONTP1(pDLP) =   (gsModEngine*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_MONTP1(pAlignedBuffer)));
   #else
   DLP_MONTP1(pDLP) = NULL;
   #endif
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
   #if defined(_OPENMP)
   DLP_BNUCTX1(pDLP) = (WINDOW==DLP_EXPMETHOD(pDLP))?(BNU_CHUNK_T*)((Ipp8u*)pDLP+ IPP_UINT_PTR(DLP_BNUCTX1(pAlignedBuffer))) : NULL;
   #endif
   #endif

   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTP0(pAlignedBuffer)), DLP_MONTP0(pDLP));
   #if defined(_OPENMP)
   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTP1(pAlignedBuffer)), DLP_MONTP1(pDLP));
   #endif
   gsUnpackModEngineCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_MONTR(pAlignedBuffer)),    DLP_MONTR(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_GENC(pAlignedBuffer)),   DLP_GENC(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_X(pAlignedBuffer)),      DLP_X(pDLP));
   cpUnpackBigNumCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_YENC(pAlignedBuffer)),   DLP_YENC(pDLP));
   cpUnpackPrimeCtx((Ipp8u*)pAlignedBuffer+IPP_UINT_PTR(DLP_PRIMEGEN(pAlignedBuffer)),DLP_PRIMEGEN(pDLP));
   cpBigNumListInit(DLP_BITSIZEP(pDLP)+1, BNLISTSIZE, DLP_BNCTX(pDLP));
}
