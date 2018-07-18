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
//     ippsSet_BN()
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"


/*F*
//    Name: ippsSet_BN
//
// Purpose: Set BigNum.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pBN == NULL
//                            pData == NULL
//    ippStsContextMatchErr   !BN_VALID_ID(pBN)
//    ippStsLengthErr         length < 1
//    ippStsOutOfRangeErr     length > BN_ROOM(pBN)
//    ippStsNoErr             no errors
//
// Parameters:
//    sgn      sign
//    length   data size (in Ipp32u chunks)
//    pData    source data pointer
//    pBN      BigNum ctx
//
*F*/
IPPFUN(IppStatus, ippsSet_BN, (IppsBigNumSGN sgn, int length, const Ipp32u* pData,
                               IppsBigNumState* pBN))
{
   IPP_BAD_PTR2_RET(pData, pBN);

   pBN = (IppsBigNumState*)( IPP_ALIGNED_PTR(pBN, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pBN), ippStsContextMatchErr);

   IPP_BADARG_RET(length<1, ippStsLengthErr);

    /* compute real size */
   FIX_BNU(pData, length);

   {
      cpSize len = INTERNAL_BNU_LENGTH(length);
      IPP_BADARG_RET(len > BN_ROOM(pBN), ippStsOutOfRangeErr);

      ZEXPAND_COPY_BNU((Ipp32u*)BN_NUMBER(pBN), BN_ROOM(pBN)*(int)(sizeof(BNU_CHUNK_T)/sizeof(Ipp32u)), pData, length);

      BN_SIZE(pBN) = len;

      if(length==1 && pData[0] == 0)
         sgn = ippBigNumPOS;  /* consider zero value as positive */
      BN_SIGN(pBN) = sgn;

      return ippStsNoErr;
   }
}
