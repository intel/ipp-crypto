/*******************************************************************************
* Copyright 2004-2018 Intel Corporation
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
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptographic Primitives (ippcp)
//     Prime Number Primitives.
// 
//  Contents:
//        ippsPrimeTest()
//
*/

#include "owncp.h"
#include "pcpprimeg.h"
#include "pcpprng.h"
#include "pcptool.h"

/*F*
// Name: ippsPrimeTest
//
// Purpose: Test a number for being a probable prime.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pCtx
//                               NULL == rndFunc
//                               NULL == pResult
//    ippStsContextMatchErr      !PRIME_VALID_ID()
//    ippStsBadArgErr            1 > nTrials
//    ippStsNoErr                no error
//
// Parameters:
//    pResult     result of test
//    nTrials     parameter for the Miller-Rabin probable primality test
//    pCtx        pointer to the context
//    rndFunc     external PRNG
//    pRndParam   pointer to the external PRNG parameters
*F*/

IPPFUN(IppStatus, ippsPrimeTest, (int nTrials,
                                  Ipp32u* pResult, IppsPrimeState* pCtx,
                                  IppBitSupplier rndFunc, void* pRndParam))
{
   IPP_BAD_PTR3_RET(pResult, pCtx, rndFunc);
   IPP_BADARG_RET(nTrials<1, ippStsBadArgErr);

   /* use aligned Prime context */
   pCtx = (IppsPrimeState*)( IPP_ALIGNED_PTR(pCtx, PRIME_ALIGNMENT) );
   IPP_BADARG_RET(!PRIME_VALID_ID(pCtx), ippStsContextMatchErr);

   {
      BNU_CHUNK_T* pPrime = PRIME_NUMBER(pCtx);
      cpSize ns = BITS_BNU_CHUNK(PRIME_MAXBITSIZE(pCtx));
      FIX_BNU(pPrime, ns);

      {
         int ret = cpPrimeTest(pPrime, ns, nTrials, pCtx, rndFunc, pRndParam);
         if(-1 == ret)
            return ippStsErr;
         else {
            *pResult = ret? IPP_IS_PRIME : IPP_IS_COMPOSITE;
            return ippStsNoErr;
         }
      }
   }
}
