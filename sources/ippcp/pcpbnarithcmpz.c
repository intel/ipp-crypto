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
//     ippsCmpZero_BN()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsCmpZero_BN
//
// Purpose: Compare BigNum value with zero.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pBN == NULL
//                            pResult == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pBN)
//    ippStsNoErr             no errors
//
// Parameters:
//    pBN      BigNum ctx
//    pResult  result of comparison
//
*F*/
IPPFUN(IppStatus, ippsCmpZero_BN, (const IppsBigNumState* pBN, Ipp32u* pResult))
{
   IPP_BAD_PTR2_RET(pBN, pResult);

   pBN = (IppsBigNumState*)( IPP_ALIGNED_PTR(pBN, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pBN), ippStsContextMatchErr);

   if(BN_SIZE(pBN)==1 && BN_NUMBER(pBN)[0]==0)
      *pResult = IS_ZERO;
   else if (BN_SIGN(pBN)==ippBigNumPOS)
      *pResult = GREATER_THAN_ZERO;
   else if (BN_SIGN(pBN)==ippBigNumNEG)
      *pResult = LESS_THAN_ZERO;

   return ippStsNoErr;
}
