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
// 
//  Purpose:
//     Cryptography Primitive.
//     Digesting message according to SHA256
// 
//  Contents:
//        ippsSHA256Final()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_rmf.h"
#include "pcptool.h"
#include "pcpsha256stuff.h"


/*F*
//    Name: ippsSHA256Final
//
// Purpose: Stop message digesting and return digest.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pMD == NULL
//                            pState == NULL
//    ippStsContextMatchErr   pState->idCtx != idCtxSHA256
//    ippStsNoErr             no errors
//
// Parameters:
//    pMD         address of the output digest
//    pState      pointer to the SHA256 state
//
*F*/
IPPFUN(IppStatus, ippsSHA256Final,(Ipp8u* pMD, IppsSHA256State* pState))
{
   /* test state pointer and ID */
   IPP_BAD_PTR1_RET(pState);
   pState = (IppsSHA256State*)( IPP_ALIGNED_PTR(pState, SHA256_ALIGNMENT) );
   IPP_BADARG_RET(idCtxSHA256 !=HASH_CTX_ID(pState), ippStsContextMatchErr);

   /* test digest pointer */
   IPP_BAD_PTR1_RET(pMD);

   cpFinalizeSHA256(HASH_VALUE(pState), HASH_BUFF(pState), HAHS_BUFFIDX(pState), HASH_LENLO(pState));
   /* convert hash into big endian */
   ((Ipp32u*)pMD)[0] = ENDIANNESS32(HASH_VALUE(pState)[0]);
   ((Ipp32u*)pMD)[1] = ENDIANNESS32(HASH_VALUE(pState)[1]);
   ((Ipp32u*)pMD)[2] = ENDIANNESS32(HASH_VALUE(pState)[2]);
   ((Ipp32u*)pMD)[3] = ENDIANNESS32(HASH_VALUE(pState)[3]);
   ((Ipp32u*)pMD)[4] = ENDIANNESS32(HASH_VALUE(pState)[4]);
   ((Ipp32u*)pMD)[5] = ENDIANNESS32(HASH_VALUE(pState)[5]);
   ((Ipp32u*)pMD)[6] = ENDIANNESS32(HASH_VALUE(pState)[6]);
   ((Ipp32u*)pMD)[7] = ENDIANNESS32(HASH_VALUE(pState)[7]);

   /* re-init hash value */
   HAHS_BUFFIDX(pState) = 0;
   HASH_LENLO(pState) = 0;
   sha256_hashInit(HASH_VALUE(pState));

   return ippStsNoErr;
}
