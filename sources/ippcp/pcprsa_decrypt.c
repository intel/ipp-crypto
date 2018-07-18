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
//        ippsRSA_Decrypt()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsamethod.h"

/*F*
// Name: ippsRSA_Decrypt
//
// Purpose: Performs RSA Decryprion
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//                               NULL == pCtxt
//                               NULL == pPtxt
//                               NULL == pBuffer
//
//    ippStsContextMatchErr     !RSA_PUB_KEY_VALID_ID()
//                              !BN_VALID_ID(pCtxt)
//                              !BN_VALID_ID(pPtxt)
//
//    ippStsIncompleteContextErr private key is not set up
//
//    ippStsOutOfRangeErr        pCtxt >= modulus
//                               pCtxt <0
//
//    ippStsSizeErr              BN_ROOM(pPtxt) is not enough
//
//    ippStsNoErr                no error
//
// Parameters:
//    pCtxt          pointer to the ciphertext
//    pPtxt          pointer to the plaintext
//    pKey           pointer to the key context
//    pScratchBuffer pointer to the temporary buffer
*F*/
IPPFUN(IppStatus, ippsRSA_Decrypt,(const IppsBigNumState* pCtxt,
                                         IppsBigNumState* pPtxt,
                                   const IppsRSAPrivateKeyState* pKey,
                                         Ipp8u* pBuffer))
{
   IPP_BAD_PTR2_RET(pKey, pBuffer);
   pKey = (IppsRSAPrivateKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PRIVATE_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PRV_KEY_VALID_ID(pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PRV_KEY_IS_SET(pKey), ippStsIncompleteContextErr);

   IPP_BAD_PTR1_RET(pCtxt);
   pCtxt = (IppsBigNumState*)( IPP_ALIGNED_PTR(pCtxt, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pCtxt), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pCtxt), ippStsOutOfRangeErr);
   IPP_BADARG_RET(0 <= cpCmp_BNU(BN_NUMBER(pCtxt), BN_SIZE(pCtxt),
                                 MOD_MODULUS(RSA_PRV_KEY_NMONT(pKey)), MOD_LEN(RSA_PRV_KEY_NMONT(pKey))), ippStsOutOfRangeErr);

   IPP_BAD_PTR1_RET(pPtxt);
   pPtxt = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPtxt, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPtxt), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_ROOM(pPtxt) < BITS_BNU_CHUNK(RSA_PRV_KEY_BITSIZE_N(pKey)), ippStsSizeErr);

   {
      BNU_CHUNK_T* pScratchBuffer = (BNU_CHUNK_T*)( IPP_ALIGNED_PTR(pBuffer, (int)sizeof(BNU_CHUNK_T)) );

      if(RSA_PRV_KEY1_VALID_ID(pKey))
         gsRSAprv_cipher(pPtxt, pCtxt, pKey, pScratchBuffer);
      else
         gsRSAprv_cipher_crt(pPtxt, pCtxt, pKey, pScratchBuffer);

      return ippStsNoErr;
   }
}
