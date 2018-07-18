/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
// 
//  Contents:
//     ippsSub_BN()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsSub_BN
//
// Purpose: Subtract BigNums.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pA  == NULL
//                            pB  == NULL
//                            pR  == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pA)
//                            !BN_VALID_ID(pB)
//                            !BN_VALID_ID(pR)
//    ippStsOutOfRangeErr     pR can not hold result
//    ippStsNoErr             no errors
//
// Parameters:
//    pA    source BigNum
//    pB    source BigNum
//    pR    resultant BigNum
//
*F*/
IPPFUN(IppStatus, ippsSub_BN, (IppsBigNumState* pA, IppsBigNumState* pB, IppsBigNumState* pR))
{
   IPP_BAD_PTR3_RET(pA, pB, pR);

   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   pB = (IppsBigNumState*)( IPP_ALIGNED_PTR(pB, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pB), ippStsContextMatchErr);
   pR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pR, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pR), ippStsContextMatchErr);

   {
      cpSize nsA = BN_SIZE(pA);
      cpSize nsB = BN_SIZE(pB);
      cpSize nsR = BN_ROOM(pR);
      IPP_BADARG_RET(nsR < IPP_MAX(nsA, nsB), ippStsOutOfRangeErr);

      {
         BNU_CHUNK_T* pDataR = BN_NUMBER(pR);

         IppsBigNumSGN sgnA = BN_SIGN(pA);
         IppsBigNumSGN sgnB = BN_SIGN(pB);
         BNU_CHUNK_T* pDataA = BN_NUMBER(pA);
         BNU_CHUNK_T* pDataB = BN_NUMBER(pB);

         BNU_CHUNK_T carry;

         if(sgnA!=sgnB) {
            if(nsA < nsB) {
               SWAP(nsA, nsB);
               SWAP_PTR(BNU_CHUNK_T, pDataA, pDataB);
            }

            carry = cpAdd_BNU(pDataR, pDataA, pDataB, nsB);
            if(nsA>nsB)
               carry = cpInc_BNU(pDataR+nsB, pDataA+nsB, nsA-nsB, carry);
            if(carry) {
               if(nsR > nsA)
                  pDataR[nsA++] = carry;
               else
                  IPP_ERROR_RET(ippStsOutOfRangeErr);
            }
            BN_SIGN(pR) = sgnA;
         }

         else {
            int cmpRes= cpCmp_BNU(pDataA, nsA, pDataB, nsB);

            if(0==cmpRes) {
               ZEXPAND_BNU(pDataR,0, nsR);
               BN_SIZE(pR) = 1;
               BN_SIGN(pR) = ippBigNumPOS;
               return ippStsNoErr;
            }

            if(0>cmpRes) {
               SWAP(nsA, nsB);
               SWAP_PTR(BNU_CHUNK_T, pDataA, pDataB);
            }

            carry = cpSub_BNU(pDataR, pDataA, pDataB, nsB);
            if(nsA>nsB)
               cpDec_BNU(pDataR+nsB, pDataA+nsB, nsA-nsB, carry);

            BN_SIGN(pR) = cmpRes>0? sgnA : INVERSE_SIGN(sgnA);
         }

         FIX_BNU(pDataR, nsA);
         BN_SIZE(pR) = nsA;

         return ippStsNoErr;
      }
   }
}
