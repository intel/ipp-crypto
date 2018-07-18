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
//     Big Number Operations
// 
//  Contents:
//     ippsSetOctString_BN()
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"


/*F*
//    Name: ippsSetOctString_BN
//
// Purpose: Convert octet string into the BN value.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pOctStr
//                               NULL == pBN
//
//    ippStsContextMatchErr      !BN_VALID_ID(pBN)
//
//    ippStsLengthErr            0 > strLen
//
//    ippStsSizeErr              BN_ROOM(pBN) is enough for keep actual strLen
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pOctStr     pointer to the source octet string
//    strLen      octet string length
//    pBN         pointer to the target BN
//
*F*/
IPPFUN(IppStatus, ippsSetOctString_BN,(const Ipp8u* pOctStr, int strLen,
                                       IppsBigNumState* pBN))
{
   IPP_BAD_PTR2_RET(pOctStr, pBN);

   pBN = (IppsBigNumState*)( IPP_ALIGNED_PTR(pBN, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pBN), ippStsContextMatchErr);

   IPP_BADARG_RET((0>strLen), ippStsLengthErr);

   /* remove leading zeros */
   while(strLen && (0==pOctStr[0])) {
      strLen--;
      pOctStr++;
   }

   /* test BN size */
   IPP_BADARG_RET((int)(sizeof(BNU_CHUNK_T)*BN_ROOM(pBN))<strLen, ippStsSizeErr);
   if(strLen)
      BN_SIZE(pBN) = cpFromOctStr_BNU(BN_NUMBER(pBN), pOctStr, strLen);
   else {
      BN_NUMBER(pBN)[0] = (BNU_CHUNK_T)0;
      BN_SIZE(pBN) = 1;
   }
   BN_SIGN(pBN) = ippBigNumPOS;

   return ippStsNoErr;
}
