/*******************************************************************************
* Copyright 2019 Intel Corporation
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

#include "owncp.h"
#include "pcphash_rmf.h"

// Check all the ippsRSASign_PSS_rmf parameters and align pPrvKey, pPubKey pointers
__INLINE IppStatus SingleSignPssRmfPreproc(const Ipp8u* pMsg, int msgLen,
   const Ipp8u* pSalt, int saltLen,
   Ipp8u* pSign,
   const IppsRSAPrivateKeyState** pPrvKey,
   const IppsRSAPublicKeyState**  pPubKey,
   const IppsHashMethod* pMethod,
   Ipp8u* pScratchBuffer)
{
   /* test message length */
   IPP_BADARG_RET((msgLen < 0), ippStsLengthErr);
   /* test message pointer */
   IPP_BADARG_RET((msgLen && !pMsg), ippStsNullPtrErr);

   /* test data pointer */
   IPP_BAD_PTR2_RET(pSign, pMethod);

   /* test salt length and salt pointer */
   IPP_BADARG_RET(saltLen < 0, ippStsLengthErr);
   IPP_BADARG_RET((saltLen && !pSalt), ippStsNullPtrErr);

   /* test private key context */
   IPP_BAD_PTR2_RET(*pPrvKey, pScratchBuffer);
   *pPrvKey = (IppsRSAPrivateKeyState*)(IPP_ALIGNED_PTR(*pPrvKey, RSA_PRIVATE_KEY_ALIGNMENT));
   IPP_BADARG_RET(!RSA_PRV_KEY_VALID_ID(*pPrvKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PRV_KEY_IS_SET(*pPrvKey), ippStsIncompleteContextErr);

   /* use aligned public key context if defined */
   if (*pPubKey) {
      *pPubKey = (IppsRSAPublicKeyState*)(IPP_ALIGNED_PTR(*pPubKey, RSA_PUBLIC_KEY_ALIGNMENT));
      IPP_BADARG_RET(!RSA_PUB_KEY_VALID_ID(*pPubKey), ippStsContextMatchErr);
      IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(*pPubKey), ippStsIncompleteContextErr);
   }

   return ippStsNoErr;
}

// Check all the ippsRSAVerify_PSS_rmf parameters, set valid=0, align pKey pointer
__INLINE IppStatus SingleVerifyPssRmfPreproc(const Ipp8u* pMsg, int msgLen,
   const Ipp8u* pSign,
   int* pIsValid,
   const IppsRSAPublicKeyState**  pKey,
   const IppsHashMethod* pMethod,
   Ipp8u* pScratchBuffer)
{
   /* test message length */
   IPP_BADARG_RET((msgLen < 0), ippStsLengthErr);
   /* test message pointer */
   IPP_BADARG_RET((msgLen && !pMsg), ippStsNullPtrErr);

   /* test data pointer */
   IPP_BAD_PTR3_RET(pSign, pIsValid, pMethod);

   /* test public key context */
   IPP_BAD_PTR2_RET(*pKey, pScratchBuffer);
   *pKey = (IppsRSAPublicKeyState*)(IPP_ALIGNED_PTR(*pKey, RSA_PUBLIC_KEY_ALIGNMENT));
   IPP_BADARG_RET(!RSA_PUB_KEY_VALID_ID(*pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(*pKey), ippStsIncompleteContextErr);

   *pIsValid = 0;

   return ippStsNoErr;
}
