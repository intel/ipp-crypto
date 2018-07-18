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
//        ippsMontForm()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcpmontgomery.h"
#include "pcptool.h"

/*F*
// Name: ippsMontForm
//
// Purpose: Converts input into Montgomery domain.
//
// Returns:                   Reason:
//      ippStsNullPtrErr         pCtx==NULL
//                               pA==NULL
//                               pR==NULL
//      ippStsContextMatchErr    !MNT_VALID_ID(pCtx)
//                               !BN_VALID_ID(pA)
//                               !BN_VALID_ID(pR)
//      ippStsBadArgErr          A < 0.
//      ippStsScaleRangeErr      A >= Modulus.
//      ippStsOutOfRangeErr      R can't hold result
//      ippStsNoErr              no errors
//
// Parameters:
//    pA    pointer to the input [0, modulus-1]
//    pCtx  Montgomery context
//    pR    pointer to the output (A*R mod modulus)
*F*/
IPPFUN(IppStatus, ippsMontForm,(const IppsBigNumState* pA, IppsMontState* pCtx, IppsBigNumState* pR))
{
   IPP_BAD_PTR3_RET(pCtx, pA, pR);

   pCtx = (IppsMontState*)(IPP_ALIGNED_PTR((pCtx), MONT_ALIGNMENT));
   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, BN_ALIGNMENT) );
   pR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pR, BN_ALIGNMENT) );

   IPP_BADARG_RET(!MNT_VALID_ID(pCtx), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pR), ippStsContextMatchErr);

   IPP_BADARG_RET(BN_SIGN(pA) != ippBigNumPOS, ippStsBadArgErr);
   IPP_BADARG_RET(cpCmp_BNU(BN_NUMBER(pA), BN_SIZE(pA), MOD_MODULUS( MNT_ENGINE(pCtx) ), MOD_LEN( MNT_ENGINE(pCtx) )) >= 0, ippStsScaleRangeErr);
   IPP_BADARG_RET(BN_ROOM(pR) < MOD_LEN( MNT_ENGINE(pCtx) ), ippStsOutOfRangeErr);

   {
      const int usedPoolLen = 1;
      cpSize nsM = MOD_LEN( MNT_ENGINE(pCtx) );
      BNU_CHUNK_T* pDataA  = gsModPoolAlloc(MNT_ENGINE(pCtx), usedPoolLen);
      //tbcd: temporary excluded: assert(NULL!=pDataA);

      ZEXPAND_COPY_BNU(pDataA, nsM, BN_NUMBER(pA), BN_SIZE(pA));

      MOD_METHOD( MNT_ENGINE(pCtx) )->encode(BN_NUMBER(pR), pDataA, MNT_ENGINE(pCtx));

      FIX_BNU(BN_NUMBER(pR), nsM);
      BN_SIZE(pR) = nsM;
      BN_SIGN(pR) = ippBigNumPOS;

      gsModPoolFree(MNT_ENGINE(pCtx), usedPoolLen);
   }

   return ippStsNoErr;
}
