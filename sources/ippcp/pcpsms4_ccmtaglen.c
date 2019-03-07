/*******************************************************************************
* Copyright 2017-2019 Intel Corporation
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
//     Cryptography Primitive.
//     SMS4-CCM implementation.
// 
//     Content:
//        ippsSMS4_CCMTagLen()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpsms4authccm.h"
#include "pcptool.h"

/*F*
//    Name: ippsSMS4_CCMTagLen
//
// Purpose: Setup length of the tag.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//    ippStsContextMatchErr   !VALID_SMS4CCM_ID()
//    ippStsLengthErr         MBS_SMS4 < tagLen || tagLen < 4
//                            or odd value of tagLen
//    ippStsNoErr             no errors
//
// Parameters:
//    tagLen      length in bytes of the requested tag
//    pCtx        pointer to the CCM context
//
*F*/
IPPFUN(IppStatus, ippsSMS4_CCMTagLen,(int tagLen, IppsSMS4_CCMState* pCtx))
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   pCtx = (IppsSMS4_CCMState*)( IPP_ALIGNED_PTR(pCtx, SMS4CCM_ALIGNMENT) );
   IPP_BADARG_RET(!VALID_SMS4CCM_ID(pCtx), ippStsContextMatchErr);

   /* test tag length */
   IPP_BADARG_RET(tagLen>MBS_SMS4 || tagLen<4 || tagLen&1, ippStsLengthErr);

   /* init for new message */
   SMS4CCM_TAGLEN(pCtx) = tagLen;

   return ippStsNoErr;
}
