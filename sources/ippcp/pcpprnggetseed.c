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
//        ippsPRNGGetSeed()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcpprng.h"

/*F*
// Name: ippsPRNGGetSeed
//
// Purpose: Get current SEED value from the state
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pCtx
//                               NULL == pSeed
//
//    ippStsContextMatchErr      illegal pCtx->idCtx
//                               illegal pSeed->idCtx
//    ippStsOutOfRangeErr        length of the actual SEED > length SEED destination
//
//    ippStsNoErr                no error
//
// Parameters:
//    pCtx     pointer to the context
//    pSeed    pointer to the SEED
*F*/
IPPFUN(IppStatus, ippsPRNGGetSeed, (const IppsPRNGState* pCtx, IppsBigNumState* pSeed))
{
   /* test PRNG context */
   IPP_BAD_PTR1_RET(pCtx);
   pCtx = (IppsPRNGState*)( IPP_ALIGNED_PTR(pCtx, PRNG_ALIGNMENT) );
   IPP_BADARG_RET(!RAND_VALID_ID(pCtx), ippStsContextMatchErr);

   /* test seed */
   IPP_BAD_PTR1_RET(pSeed);
   pSeed = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSeed, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pSeed), ippStsContextMatchErr);

   return ippsSet_BN(ippBigNumPOS,
                     BITS2WORD32_SIZE(RAND_SEEDBITS(pCtx)),
                     (Ipp32u*)RAND_XKEY(pCtx),
                     pSeed);
}
