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
//        ippsRSA_Encrypt()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsamethod.h"

/*F*
// Name: ippsRSA_Encrypt
//
// Purpose: Performs RSA Encryprion
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//                               NULL == pPtxt
//                               NULL == pCtxt
//                               NULL == pBuffer
//
//    ippStsContextMatchErr     !RSA_PUB_KEY_VALID_ID()
//                              !BN_VALID_ID(pPtxt)
//                              !BN_VALID_ID(pCtxt)
//
//    ippStsIncompleteContextErr public key is not setup
//
//    ippStsOutOfRangeErr        pPtxt >= modulus
//                               pPtxt <0
//
//    ippStsSizeErr              BN_ROOM(pCtxt) is not enough
//
//    ippStsNoErr                no error
//
// Parameters:
//    pPtxt          pointer to the plaintext
//    pCtxt          pointer to the ciphertext
//    pKey           pointer to the key context
//    pScratchBuffer pointer to the temporary buffer
*F*/
IPPFUN(IppStatus, ippsRSA_Encrypt,(const IppsBigNumState* pPtxt,
                                         IppsBigNumState* pCtxt,
                                   const IppsRSAPublicKeyState* pKey,
                                         Ipp8u* pBuffer))
{
   IPP_BAD_PTR2_RET(pKey, pBuffer);
   pKey = (IppsRSAPublicKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PUBLIC_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PUB_KEY_VALID_ID(pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(pKey), ippStsIncompleteContextErr);

   IPP_BAD_PTR1_RET(pPtxt);
   pPtxt = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPtxt, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPtxt), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pPtxt), ippStsOutOfRangeErr);
   IPP_BADARG_RET(0 <= cpCmp_BNU(BN_NUMBER(pPtxt), BN_SIZE(pPtxt),
                                 MOD_MODULUS(RSA_PUB_KEY_NMONT(pKey)), MOD_LEN(RSA_PUB_KEY_NMONT(pKey))), ippStsOutOfRangeErr);

   IPP_BAD_PTR1_RET(pCtxt);
   pCtxt = (IppsBigNumState*)( IPP_ALIGNED_PTR(pCtxt, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pCtxt), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_ROOM(pCtxt) < BITS_BNU_CHUNK(RSA_PUB_KEY_BITSIZE_N(pKey)), ippStsSizeErr);

   {
      BNU_CHUNK_T* pScratchBuffer = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR(pBuffer, (int)sizeof(BNU_CHUNK_T)) );
      gsRSApub_cipher(pCtxt, pPtxt, pKey, pScratchBuffer);
      return ippStsNoErr;
   }
}
