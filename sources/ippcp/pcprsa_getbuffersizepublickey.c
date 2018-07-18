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
//        ippsRSA_GetBufferSizePublicKey()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsamethod.h"

#include "pcprsa_getdefmeth_pub.h"

/*F*
// Name: ippsRSA_GetBufferSizePublicKey
//
// Purpose: Returns size of temporary buffer (in bytes) for public key operation
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//                               NULL == pBufferSize
//
//    ippStsContextMatchErr     !RSA_PUB_KEY_VALID_ID()
//
//    ippStsIncompleteContextErr no ippsRSA_SetPublicKey() call
//
//    ippStsNoErr                no error
//
// Parameters:
//    pBufferSize pointer to size of temporary buffer
//    pKey        pointer to the key context
*F*/
IPPFUN(IppStatus, ippsRSA_GetBufferSizePublicKey,(int* pBufferSize, const IppsRSAPublicKeyState* pKey))
{
   IPP_BAD_PTR1_RET(pKey);
   pKey = (IppsRSAPublicKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PUBLIC_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PUB_KEY_VALID_ID(pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(pKey), ippStsIncompleteContextErr);

   IPP_BAD_PTR1_RET(pBufferSize);

   {
      cpSize bitSizeN = RSA_PUB_KEY_BITSIZE_N(pKey);
      cpSize nsN = BITS_BNU_CHUNK(bitSizeN);

      gsMethod_RSA* m = getDefaultMethod_RSA_public(bitSizeN);

      cpSize bufferNum = ((nsN+1)*2)*2          /* (1)2 BN for RSA (enc)/sign schemes */
                        + 1;                    /* BNU_CHUNK_T alignment */
      bufferNum += m->bufferNumFunc(bitSizeN);  /* RSA public key operation */

      *pBufferSize = bufferNum*sizeof(BNU_CHUNK_T);

      return ippStsNoErr;
   }
}
