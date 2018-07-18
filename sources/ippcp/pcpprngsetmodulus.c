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
//        ippsPRNGSetModulus()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcpprng.h"

/*F*
// Name: ippsPRNGSetModulus
//
// Purpose: Sets 160-bit modulus Q.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pCtx
//                               NULL == pMod
//
//    ippStsContextMatchErr      illegal pCtx->idCtx
//                               illegal pMod->idCtx
//
//    ippStsBadArgErr            160 != bitsize(pMod)
//
//    ippStsNoErr                no error
//
// Parameters:
//    pMod     pointer to the 160-bit modulus
//    pCtx     pointer to the context
*F*/
IPPFUN(IppStatus, ippsPRNGSetModulus, (const IppsBigNumState* pMod, IppsPRNGState* pCtx))
{
   /* test PRNG context */
   IPP_BAD_PTR1_RET(pCtx);
   pCtx = (IppsPRNGState*)( IPP_ALIGNED_PTR(pCtx, PRNG_ALIGNMENT) );
   IPP_BADARG_RET(!RAND_VALID_ID(pCtx), ippStsContextMatchErr);

   /* test modulus */
   IPP_BAD_PTR1_RET(pMod);
   pMod = (IppsBigNumState*)( IPP_ALIGNED_PTR(pMod, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pMod), ippStsContextMatchErr);
   IPP_BADARG_RET(160 != BITSIZE_BNU(BN_NUMBER(pMod),BN_SIZE(pMod)), ippStsBadArgErr);

   ZEXPAND_COPY_BNU(RAND_Q(pCtx), (int)(sizeof(RAND_Q(pCtx))/sizeof(BNU_CHUNK_T)), BN_NUMBER(pMod),  BN_SIZE(pMod));
   return ippStsNoErr;
}
