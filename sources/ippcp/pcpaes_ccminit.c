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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
// 
//     Context:
//        ippsAES_CCMInit()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthccm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*F*
//    Name: ippsAES_CCMInit
//
// Purpose: Init AES-CCM state.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//    ippStsMemAllocErr       size of buffer is not match fro operation
//    ippStsLengthErr         keyLen != 16 &&
//                                   != 24 &&
//                                   != 32
//    ippStsNoErr             no errors
//
// Parameters:
//    pKey        pointer to the secret key
//    keyLen      length of secret key (in bytes)
//    pState      pointer to initialized as CCM context
//    ctxSize     available size (in bytes) of buffer above
//
*F*/
IPPFUN(IppStatus, ippsAES_CCMInit,(const Ipp8u* pKey, int keyLen,
                                   IppsAES_CCMState* pState, int ctxSize))
{
   /* test pState pointer */
   IPP_BAD_PTR1_RET(pState);

   /* test available size of context buffer */
   IPP_BADARG_RET(ctxSize<cpSizeofCtx_AESCCM(), ippStsMemAllocErr);

   /* use aligned context */
   pState = (IppsAES_CCMState*)( IPP_ALIGNED_PTR(pState, AESCCM_ALIGNMENT) );

   /* set state ID */
   AESCCM_ID(pState) = idCtxAESCCM;

   /* init AES by the secret key */
   return ippsAESInit(pKey, keyLen, AESCCM_CIPHER(pState), cpSizeofCtx_AES());
}
