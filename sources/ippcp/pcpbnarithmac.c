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
//     ippsMAC_BN_I()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsMAC_BN_I
//
// Purpose: Multiply and Accumulate BigNums.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pA  == NULL
//                            pB  == NULL
//                            pR  == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pA)
//                            !BN_VALID_ID(pB)
//                            !BN_VALID_ID(pR)
//    ippStsOutOfRangeErr     pR can not fit result
//    ippStsNoErr             no errors
//
// Parameters:
//    pA    source BigNum
//    pB    source BigNum
//    pR    resultant BigNum
//
*F*/
IPPFUN(IppStatus, ippsMAC_BN_I, (IppsBigNumState* pA, IppsBigNumState* pB, IppsBigNumState* pR))
{
   IPP_BAD_PTR3_RET(pA, pB, pR);

   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   pB = (IppsBigNumState*)( IPP_ALIGNED_PTR(pB, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pB), ippStsContextMatchErr);
   pR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pR, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pR), ippStsContextMatchErr);

   {
      BNU_CHUNK_T* pDataA = BN_NUMBER(pA);
      BNU_CHUNK_T* pDataB = BN_NUMBER(pB);

      cpSize nsA = BN_SIZE(pA);
      cpSize nsB = BN_SIZE(pB);

      cpSize bitSizeA = BITSIZE_BNU(pDataA, nsA);
      cpSize bitSizeB = BITSIZE_BNU(pDataB, nsB);
      /* size of temporary pruduct */
      cpSize nsP = BITS_BNU_CHUNK(bitSizeA+bitSizeB);

      /* test if multiplicant/multiplier is zero */
      if(!bitSizeA || !bitSizeB) return ippStsNoErr;
      /* test if product can't fit to the result */
      IPP_BADARG_RET(BN_ROOM(pR)<nsP, ippStsOutOfRangeErr);

      {
         BNU_CHUNK_T* pDataR  = BN_NUMBER(pR);
         IppsBigNumSGN sgnR = BN_SIGN(pR);
         cpSize nsR = BN_SIZE(pR);
         cpSize room = BN_ROOM(pR);

         /* temporary product */
         BNU_CHUNK_T* pDataP = BN_BUFFER(pR);
         IppsBigNumSGN sgnP = BN_SIGN(pA)==BN_SIGN(pB)? ippBigNumPOS : ippBigNumNEG;

         /* clear the rest of R data buffer */
         ZEXPAND_BNU(pDataR, nsR, room);

         /* temporary product */
         if(pA==pB)
            cpSqr_BNU_school(pDataP, pDataA, nsA);
         else
            cpMul_BNU_school(pDataP, pDataA, nsA, pDataB, nsB);
         /* clear the rest of rpoduct */
         ZEXPAND_BNU(pDataP, nsP, room);

         if(sgnR==sgnP) {
            BNU_CHUNK_T carry = cpAdd_BNU(pDataR, pDataR, pDataP, room);
            if(carry) {
               BN_SIZE(pR) = room;
               IPP_ERROR_RET(ippStsOutOfRangeErr);
            }
         }

         else {
            BNU_CHUNK_T* pTmp = pDataR;
            int cmpRes = cpCmp_BNU(pDataR, room, pDataP, room);
            if(0>cmpRes) {
               SWAP_PTR(BNU_CHUNK_T, pTmp, pDataP);
            }
            cpSub_BNU(pDataR, pTmp, pDataP, room);

            BN_SIGN(pR) = cmpRes>0? sgnR : INVERSE_SIGN(sgnR);
         }

         FIX_BNU(pDataR, room);
         BN_SIZE(pR) = room;

         return ippStsNoErr;
      }
   }
}
