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
//        ippsPrimeSet()
//
*/

#include "owncp.h"
#include "pcpprimeg.h"

/*F*
// Name: ippsPrimeSet
//
// Purpose: Sets a trial BNU for further testing
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pCtx
//                               NULL == pPrime
//    ippStsContextMatchErr      illegal pCtx->idCtx
//    ippStsLengthErr            1 > nBits
//    ippStsOutOfRangeErr        nBits > PRIME_MAXBITSIZE(pCtx)
//    ippStsNoErr                no error
//
// Parameters:
//    pPrime   pointer to the number to be set
//    nBits    bitlength of input number bitlength
//    pCtx     pointer to the context
//
*F*/
IPPFUN(IppStatus, ippsPrimeSet, (const Ipp32u* pPrime, int nBits, IppsPrimeState* pCtx))
{
   IPP_BAD_PTR2_RET(pCtx, pPrime);
   IPP_BADARG_RET(nBits<1, ippStsLengthErr);

   /* use aligned context */
   pCtx = (IppsPrimeState*)( IPP_ALIGNED_PTR(pCtx, PRIME_ALIGNMENT) );
   IPP_BADARG_RET(!PRIME_VALID_ID(pCtx), ippStsContextMatchErr);

   IPP_BADARG_RET(nBits > PRIME_MAXBITSIZE(pCtx), ippStsOutOfRangeErr);

   /* clear prime container */
   ZEXPAND_BNU(PRIME_NUMBER(pCtx), 0, BITS_BNU_CHUNK(PRIME_MAXBITSIZE(pCtx)));

   {
      cpSize len32 = BITS2WORD32_SIZE(nBits);
      Ipp32u mask = MAKEMASK32(nBits);
      Ipp32u* pPrime = (Ipp32u*)PRIME_NUMBER(pCtx);

      FIX_BNU(pPrime, len32);
      ZEXPAND_COPY_BNU(pPrime, BITS2WORD32_SIZE(PRIME_MAXBITSIZE(pCtx)), pPrime, len32);
      pPrime[len32-1] &= mask;

      return ippStsNoErr;
   }
}
