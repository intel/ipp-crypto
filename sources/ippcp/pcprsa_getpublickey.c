/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
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
//     RSA Functions
// 
//  Contents:
//        ippsRSA_GetPublicKey()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"

/*F*
// Name: ippsRSA_GetPublicKey
//
// Purpose: Extract key component from the key context
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//
//    ippStsContextMatchErr     !RSA_PUB_KEY_VALID_ID()
//                              !BN_VALID_ID(pModulus)
//                              !BN_VALID_ID(pExp)
//
//    ippStsIncompleteContextErr public key is not set up
//
//    ippStsSizeErr              BN_ROOM(pModulus), BN_ROOM(pExp) is not enough
//
//    ippStsNoErr                no error
//
// Parameters:
//    pModulus    (optional) pointer to the modulus (N)
//    pExp        (optional) pointer to the public exponent (E)
//    pKey        pointer to the key context
*F*/
IPPFUN(IppStatus, ippsRSA_GetPublicKey,(IppsBigNumState* pModulus,
                                        IppsBigNumState* pExp,
                                  const IppsRSAPublicKeyState* pKey))
{
   IPP_BAD_PTR1_RET(pKey);
   pKey = (IppsRSAPublicKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PUBLIC_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PUB_KEY_VALID_ID(pKey), ippStsContextMatchErr);

   if(pModulus) {
      pModulus = (IppsBigNumState*)( IPP_ALIGNED_PTR(pModulus, BN_ALIGNMENT) );
      IPP_BADARG_RET(!BN_VALID_ID(pModulus), ippStsContextMatchErr);
      IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(pKey), ippStsIncompleteContextErr);
      IPP_BADARG_RET(BN_ROOM(pModulus)<BITS_BNU_CHUNK(RSA_PUB_KEY_BITSIZE_N(pKey)), ippStsSizeErr);

      BN_Set(MOD_MODULUS(RSA_PUB_KEY_NMONT(pKey)),
             MOD_LEN(RSA_PUB_KEY_NMONT(pKey)),
             pModulus);
   }

   if(pExp) {
      cpSize expLen = BITS_BNU_CHUNK(RSA_PUB_KEY_BITSIZE_E(pKey));
      FIX_BNU(RSA_PUB_KEY_E(pKey), expLen);

      pExp = (IppsBigNumState*)( IPP_ALIGNED_PTR(pExp, BN_ALIGNMENT) );
      IPP_BADARG_RET(!BN_VALID_ID(pExp), ippStsContextMatchErr);
      IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(pKey), ippStsIncompleteContextErr);
      IPP_BADARG_RET(BN_ROOM(pExp) < expLen, ippStsSizeErr);

      BN_Set(RSA_PUB_KEY_E(pKey), expLen, pExp);
   }

   return ippStsNoErr;
}
