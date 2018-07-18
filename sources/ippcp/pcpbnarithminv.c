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
//     ippsModInv_BN()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsModInv_BN
//
// Purpose: Multiplicative Inversion BigNum.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pA  == NULL
//                            pM  == NULL
//                            pInv  == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pA)
//                            !BN_VALID_ID(pM)
//                            !BN_VALID_ID(pInv)
//    ippStsBadArgErr         A<=0
//    ippStsBadModulusErr     M<=0
//    ippStsScaleRangeErr     A>=M
//    ippStsOutOfRangeErr     pInv can not hold result
//    ippStsNoErr             no errors
//    ippStsBadModulusErr     inversion not found
//
// Parameters:
//    pA    source (value) BigNum
//    pM    source (modulus) BigNum
//    pInv  result BigNum
//
*F*/
IPPFUN(IppStatus, ippsModInv_BN, (IppsBigNumState* pA, IppsBigNumState* pM, IppsBigNumState* pInv) )
{
   IPP_BAD_PTR3_RET(pA, pM, pInv);

   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   pM = (IppsBigNumState*)( IPP_ALIGNED_PTR(pM, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pM), ippStsContextMatchErr);
   pInv = (IppsBigNumState*)( IPP_ALIGNED_PTR(pInv, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pInv), ippStsContextMatchErr);

    IPP_BADARG_RET(BN_ROOM(pInv) < BN_SIZE(pM), ippStsOutOfRangeErr);
    IPP_BADARG_RET(BN_NEGATIVE(pA) || (BN_SIZE(pA)==1 && BN_NUMBER(pA)[0]==0), ippStsBadArgErr);
    IPP_BADARG_RET(BN_NEGATIVE(pM) || (BN_SIZE(pM)==1 && BN_NUMBER(pM)[0]==0), ippStsBadModulusErr);
    IPP_BADARG_RET(cpCmp_BNU(BN_NUMBER(pA), BN_SIZE(pA), BN_NUMBER(pM), BN_SIZE(pM)) >= 0, ippStsScaleRangeErr);

   {
      cpSize nsR = cpModInv_BNU(BN_NUMBER(pInv),
                                BN_NUMBER(pA), BN_SIZE(pA),
                                BN_NUMBER(pM), BN_SIZE(pM),
                                BN_BUFFER(pInv), BN_BUFFER(pA), BN_BUFFER(pM));
      if(nsR) {
         BN_SIGN(pInv) = ippBigNumPOS;
         BN_SIZE(pInv) = nsR;
         return ippStsNoErr;
      }
      else
         return ippStsBadModulusErr;
    }
}
