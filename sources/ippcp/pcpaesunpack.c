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
//     Initialization of AES
// 
//  Contents:
//        ippsAESUnpack()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcprij128safe.h"
#include "pcptool.h"

/*F*
//    Name: ippsAESUnpack
//
// Purpose: De-serialize buffer into the AES context.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pBuffer== NULL
//                            pCtx == NULL
//    ippStsLengthErr         avaliable size of buffer is not enough for operation
//    ippStsNoErr             no errors
//
// Parameters:
//    pBuffer     pointer to the fuffer
//    pCtx        pointer AES context
//    ctxSize     available size (in bytes) of AES context above
//
*F*/
IPPFUN(IppStatus, ippsAESUnpack,(const Ipp8u* pBuffer, IppsAESSpec* pCtx, int ctxSize))
{
   /* test pointers */
   IPP_BAD_PTR2_RET(pCtx, pBuffer);

   /* test available size of destination buffer */
   IPP_BADARG_RET(ctxSize<cpSizeofCtx_AES(), ippStsLengthErr);

   /* use aligned Rijndael context */
   pCtx = (IppsAESSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );

   CopyBlock(pBuffer, pCtx, sizeof(IppsAESSpec));

   RIJ_ENC_SBOX(pCtx) = NULL;
   RIJ_DEC_SBOX(pCtx) = NULL;

   #if (_AES_NI_ENABLING_==_FEATURE_ON_)
      RIJ_AESNI(pCtx) = AES_NI_ENABLED;
      RIJ_ENCODER(pCtx) = Encrypt_RIJ128_AES_NI; /* AES_NI based encoder */
      RIJ_DECODER(pCtx) = Decrypt_RIJ128_AES_NI; /* AES_NI based decoder */

   #else
      #if (_AES_NI_ENABLING_==_FEATURE_TICKTOCK_)
      if(AES_NI_ENABLED == RIJ_AESNI(pCtx)) {
         RIJ_ENCODER(pCtx) = Encrypt_RIJ128_AES_NI; /* AES_NI based encoder */
         RIJ_DECODER(pCtx) = Decrypt_RIJ128_AES_NI; /* AES_NI based decoder */
      }
      else {
         RIJ_ENCODER(pCtx) = SafeEncrypt_RIJ128; /* safe encoder */
         RIJ_DECODER(pCtx) = SafeDecrypt_RIJ128; /* safe decoder */
      }
      #endif
   #endif

   return ippStsNoErr;
}
