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
// 
//  Purpose:
//     Cryptography Primitive.
//     PRNG Functions
// 
//  Contents:
//        ippsPRNGen_BN()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcphash.h"
#include "pcpprng.h"
#include "pcptool.h"

/*F*
// Name: ippsPRNGen_BN
//
// Purpose: Generates a pseudorandom big number of the specified nBits length.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pCtx
//                               NULL == pRand
//
//    ippStsContextMatchErr      illegal pCtx->idCtx
//                               illegal pRand->idCtx
//
//    ippStsLengthErr            1 > nBits
//                               nBits > BN_ROOM(pRand)
//
//    ippStsNoErr                no error
//
// Parameters:
//    pRand    pointer to the BN random
//    nBits    number of bits be requested
//    pCtx     pointer to the context
*F*/
IPPFUN(IppStatus, ippsPRNGen_BN,(IppsBigNumState* pRand, int nBits, void* pCtx))
{
   IppsPRNGState* pRndCtx;

   /* test PRNG context */
   IPP_BAD_PTR1_RET(pCtx);
   pRndCtx = (IppsPRNGState*)( IPP_ALIGNED_PTR(pCtx, PRNG_ALIGNMENT) );
   IPP_BADARG_RET(!RAND_VALID_ID(pRndCtx), ippStsContextMatchErr);

   /* test random BN */
   IPP_BAD_PTR1_RET(pRand);
   pRand = (IppsBigNumState*)( IPP_ALIGNED_PTR(pRand, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pRand), ippStsContextMatchErr);

   /* test sizes */
   IPP_BADARG_RET(nBits< 1, ippStsLengthErr);
   IPP_BADARG_RET(nBits> BN_ROOM(pRand)*BNU_CHUNK_BITS, ippStsLengthErr);


   {
      BNU_CHUNK_T* pRandBN = BN_NUMBER(pRand);
      cpSize rndSize = BITS_BNU_CHUNK(nBits);
      BNU_CHUNK_T rndMask = MASK_BNU_CHUNK(nBits);

      cpPRNGen((Ipp32u*)pRandBN, nBits, pRndCtx);
      pRandBN[rndSize-1] &= rndMask;

      FIX_BNU(pRandBN, rndSize);
      BN_SIZE(pRand) = rndSize;
      BN_SIGN(pRand) = ippBigNumPOS;

      return ippStsNoErr;
   }
}
