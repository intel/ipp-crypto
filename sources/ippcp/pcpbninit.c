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
//     ippsBigNumGetSize()
//     ippsBigNumInit()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"

/*F*
//    Name: ippsBigNumInit
//
// Purpose: Init BigNum spec for future usage.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pBN == NULL
//    ippStsLengthErr         length<1
//                            length > BITS2WORD32_SIZE(BN_MAXBITSIZE)
//    ippStsNoErr             no errors
//
// Parameters:
//    length    max BN length (32-bits segments)
//    pBN      BigNum ctx
//
*F*/
IPPFUN(IppStatus, ippsBigNumInit, (int length, IppsBigNumState* pBN))
{
    IPP_BADARG_RET(length<1 || length>BITS2WORD32_SIZE(BN_MAXBITSIZE), ippStsLengthErr);
    IPP_BAD_PTR1_RET(pBN);
    pBN = (IppsBigNumState*)(IPP_ALIGNED_PTR(pBN, BN_ALIGNMENT));

    {
        Ipp8u* ptr = (Ipp8u*)pBN;

        /* convert length to the number of BNU_CHUNK_T */
        cpSize len = INTERNAL_BNU_LENGTH(length);

        BN_ID(pBN) = idCtxUnknown;
        BN_SIGN(pBN) = ippBigNumPOS;
        BN_SIZE(pBN) = 1;     /* initial valie is zero */
        BN_ROOM(pBN) = len;   /* close to what has been passed by user */

                              /* reserve one BNU_CHUNK_T more for cpDiv_BNU,
                              mul, mont exp operations */
        len++;

        /* allocate buffers */
        BN_NUMBER(pBN) = (BNU_CHUNK_T*)(ptr += sizeof(IppsBigNumState));
        BN_BUFFER(pBN) = (BNU_CHUNK_T*)(ptr += len * sizeof(BNU_CHUNK_T)); /* use expanded length here */

                                                                           /* set BN value and buffer to zero */
        ZEXPAND_BNU(BN_NUMBER(pBN), 0, len);
        ZEXPAND_BNU(BN_BUFFER(pBN), 0, len);

        BN_ID(pBN) = idCtxBigNum;
        return ippStsNoErr;
    }
}