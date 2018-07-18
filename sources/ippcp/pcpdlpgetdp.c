/*******************************************************************************
* Copyright 2005-2018 Intel Corporation
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
//     DL over Prime Finite Field (setup/retrieve domain parameters)
// 
//  Contents:
//        ippsDLPGetDP()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"

/*F*
//    Name: ippsDLPGetDP
//
// Purpose: Get tagged DL Domain Parameter.
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pDP
//                            NULL == pDL
//
//    ippStsContextMatchErr   illegal pDP->idCtx
//                            illegal pDL->idCtx
//
//    ippStsIncompleteContextErr requested parameter hasn't set up
//
//    ippStsOutOfRangeErr        BN_ROOM(pDP) < BN_ROOM(DLP_{P|R|G}(pDL))
//
//    ippStsBadArgErr         invalid key tag
//
//    errors produced by      ippsSet_BN()
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pDP      pointer to the DL domain parameter
//    tag      DLP key component tag
//    pDL      pointer to the DL context
//
*F*/
IPPFUN(IppStatus, ippsDLPGetDP,(IppsBigNumState* pDP, IppDLPKeyTag tag, const IppsDLPState* pDL))
{
   /* test DL context */
   IPP_BAD_PTR1_RET(pDL);
   pDL =   (IppsDLPState*)( IPP_ALIGNED_PTR(pDL, DLP_ALIGNMENT) );
   IPP_BADARG_RET(!DLP_VALID_ID(pDL), ippStsContextMatchErr);

   /* test DL parameter to be set */
   IPP_BAD_PTR1_RET(pDP);
   pDP  = (IppsBigNumState*)( IPP_ALIGNED_PTR(pDP, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pDP), ippStsContextMatchErr);

   {
      IppStatus sts = ippStsNoErr;

      switch(tag) {
         case ippDLPkeyP:
            if(DLP_FLAG(pDL)&ippDLPkeyP)
               sts = ippsSet_BN(ippBigNumPOS, BITS2WORD32_SIZE(DLP_BITSIZEP(pDL)), (Ipp32u*)DLP_P(pDL), pDP);
            else
               sts = ippStsIncompleteContextErr;
            break;
         case ippDLPkeyR:
            if(DLP_FLAG(pDL)&ippDLPkeyR)
               sts = ippsSet_BN(ippBigNumPOS, BITS2WORD32_SIZE(DLP_BITSIZER(pDL)), (Ipp32u*)DLP_R(pDL), pDP);
            else
               sts = ippStsIncompleteContextErr;
            break;
         case ippDLPkeyG:
            if(DLP_FLAG(pDL)&ippDLPkeyG) {
               cpMontDec_BN(pDP, DLP_GENC(pDL), DLP_MONTP0(pDL));
            }
            else
               sts = ippStsIncompleteContextErr;
            break;
         default:
            sts = ippStsBadArgErr;
      }

      return sts;
   }
}
