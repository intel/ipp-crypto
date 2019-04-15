/*******************************************************************************
* Copyright 2013-2019 Intel Corporation
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
//     AES-GCM
// 
//  Contents:
//        wrpAesGcmDec_avx()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif


#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)

/*F*
//    Name: ippsAES_GCMDecrypt
//
// Purpose: Decrypts a data buffer in the GCM mode.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSrc == NULL
//                            pDst == NULL
//                            pState == NULL
//    ippStsContextMatchErr  !AESGCM_VALID_ID()
//    ippStsLengthErr         txtLen<0
//    ippStsNoErr              no errors
//
// Parameters:
//    pSrc        Pointer to ciphertext.
//    pDst        Pointer to plaintext.
//    len         Length of the plaintext and ciphertext in bytes
//    pState      pointer to the context
//
*F*/
void wrpAesGcmDec_avx(Ipp8u* pDst, const Ipp8u* pSrc, int lenBlks, IppsAES_GCMState* pState)
{
   IppsAESSpec* pAES = AESGCM_CIPHER(pState);
   RijnCipher encoder = RIJ_ENCODER(pAES);

   AesGcmDec_avx(pDst, pSrc, lenBlks,
                 encoder, RIJ_NR(pAES), RIJ_EKEYS(pAES),
                 AESGCM_GHASH(pState),
                 AESGCM_COUNTER(pState),
                 AESGCM_ECOUNTER(pState),
                 AESGCM_HKEY(pState));
}

#endif /* #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8) */

