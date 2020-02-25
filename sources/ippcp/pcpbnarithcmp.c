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
//     ippsCmp_BN()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsCmp_BN
//
// Purpose: Compare two BigNums.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pA == NULL
//                            pB == NULL
//                            pResult == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pA)
//                            !BN_VALID_ID(pB)
//    ippStsNoErr             no errors
//
// Parameters:
//    pA       BigNum ctx
//    pB       BigNum ctx
//    pResult  result of comparison
//
*F*/
IPPFUN(IppStatus, ippsCmp_BN,(const IppsBigNumState* pA, const IppsBigNumState* pB, Ipp32u *pResult))
{
   IPP_BAD_PTR3_RET(pA, pB, pResult);

   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   pB = (IppsBigNumState*)( IPP_ALIGNED_PTR(pB, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pB), ippStsContextMatchErr);

   {
      int res;
      if(BN_SIGN(pA)==BN_SIGN(pB)) {
         res = cpCmp_BNU(BN_NUMBER(pA), BN_SIZE(pA), BN_NUMBER(pB), BN_SIZE(pB));
         if(ippBigNumNEG==BN_SIGN(pA))
            res = -res;
      }
      else
         res = (ippBigNumPOS==BN_SIGN(pA))? 1 :-1;

      *pResult = (1==res)? IPP_IS_GT : (-1==res)? IPP_IS_LT : IPP_IS_EQ;

      return ippStsNoErr;
   }
}
