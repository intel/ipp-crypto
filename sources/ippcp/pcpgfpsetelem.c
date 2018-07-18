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
//        ippsGFpSetElement()
// 
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"

//tbcd: temporary excluded: #include <assert.h>

/*F*
// Name: ippsGFpSetElement
//
// Purpose: Set GF Element
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pGFp
//                               NULL == pR
//                               NULL == pA && lenA>0
//
//    ippStsContextMatchErr      invalid pGFp->idCtx
//                               invalid pR->idCtx
//
//    ippStsSizeErr              pA && !(0<=lenA && lenA<GFP_FELEN32())
//
//    ippStsOutOfRangeErr        GFPE_ROOM() != GFP_FELEN()
//                               BNU representation of pA[i]..pA[i+GFP_FELEN32()-1] >= modulus
//
//    ippStsNoErr                no error
//
// Parameters:
//    pA          pointer to the data representation Finite Field element
//    lenA        length of Finite Field data representation array
//    pR          pointer to Finite Field Element context
//    pGFp        pointer to Finite Field context
*F*/
IPPFUN(IppStatus, ippsGFpSetElement,(const Ipp32u* pA, int lenA, IppsGFpElement* pR, IppsGFpState* pGFp))
{
   IPP_BAD_PTR2_RET(pR, pGFp);
   pGFp = (IppsGFpState*)( IPP_ALIGNED_PTR(pGFp, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGFp), ippStsContextMatchErr );
   IPP_BADARG_RET( !GFPE_TEST_ID(pR), ippStsContextMatchErr );

   IPP_BADARG_RET( !pA && (0<lenA), ippStsNullPtrErr);
   IPP_BADARG_RET( pA && !(0<=lenA && lenA<=GFP_FELEN32(GFP_PMA(pGFp))), ippStsSizeErr );
   IPP_BADARG_RET( GFPE_ROOM(pR)!=GFP_FELEN(GFP_PMA(pGFp)), ippStsOutOfRangeErr );

   {
      IppStatus sts = ippStsNoErr;

      gsModEngine* pGFE = GFP_PMA(pGFp);
      int elemLen = GFP_FELEN(pGFE);
      BNU_CHUNK_T* pTmp = cpGFpGetPool(1, pGFE);
      //tbcd: temporary excluded: assert(NULL!=pTmp);

      ZEXPAND_BNU(pTmp, 0, elemLen);
      if(pA && lenA)
         cpGFpxCopyToChunk(pTmp, pA, lenA, pGFE);

      if(!cpGFpxSet(GFPE_DATA(pR), pTmp, elemLen, pGFE))
         sts = ippStsOutOfRangeErr;

      cpGFpReleasePool(1, pGFE);
      return sts;
   }
}
