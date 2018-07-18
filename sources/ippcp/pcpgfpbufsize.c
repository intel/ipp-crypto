/*******************************************************************************
* Copyright 2018 Intel Corporation
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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Operations over GF(p).
//
//     Context:
//        ippsGFpScratchBufferSize
//
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/*F*
// Name: ippsGFpScratchBufferSize
//
// Purpose: Gets the size of the scratch buffer.
//
// Returns:                   Reason:
//    ippStsNullPtrErr          pGFp == NULL
//                              pBufferSize == NULL
//    ippStsContextMatchErr     incorrect pGFp's context id
//    ippStsBadArgErr           0>=nExponents
//                              nExponents>6
//    ippStsNoErr               no error
//
// Parameters:
//    nExponents      Number of exponents.
//    ExpBitSize      Maximum bit size of the exponents.
//    pGFp            Pointer to the context of the finite field.
//    pBufferSize     Pointer to the calculated buffer size in bytes.
//
*F*/

IPPFUN(IppStatus, ippsGFpScratchBufferSize,(int nExponents, int ExpBitSize, const IppsGFpState* pGFp, int* pBufferSize))
{
   IPP_BAD_PTR2_RET(pGFp, pBufferSize);
   pGFp = (IppsGFpState*)( IPP_ALIGNED_PTR(pGFp, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGFp), ippStsContextMatchErr );

   IPP_BADARG_RET( 0>=nExponents ||nExponents>IPP_MAX_EXPONENT_NUM, ippStsBadArgErr);
   IPP_BADARG_RET( 0>=ExpBitSize, ippStsBadArgErr);

   {
      int elmDataSize = GFP_FELEN(GFP_PMA(pGFp))*sizeof(BNU_CHUNK_T);

      /* get window_size */
      int w = (nExponents==1)? cpGFpGetOptimalWinSize(ExpBitSize) : /* use optimal window size, if single-scalar operation */
                               nExponents;                          /* or pseudo-oprimal if multi-scalar operation */

      /* number of table entries */
      int nPrecomputed = 1<<w;

      *pBufferSize = elmDataSize*nPrecomputed + (CACHE_LINE_SIZE-1);

      return ippStsNoErr;
   }
}
