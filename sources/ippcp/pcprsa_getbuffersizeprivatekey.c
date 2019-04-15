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
//     RSA Functions
// 
//  Contents:
//        ippsRSA_GetBufferSizePrivateKey()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsamethod.h"

#include "pcprsa_getdefmeth_priv.h"

/*F*
// Name: ippsRSA_GetBufferSizePrivateKey
//
// Purpose: Returns size of temporary buffer (in bytes) for private key operation
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//                               NULL == pBufferSize
//
//    ippStsContextMatchErr     !RSA_PRV_KEY_VALID_ID()
//
//    ippStsIncompleteContextErr (type1) private key is not set up
//
//    ippStsNoErr                no error
//
// Parameters:
//    pBufferSize pointer to size of temporary buffer
//    pKey        pointer to the key context
*F*/
IPPFUN(IppStatus, ippsRSA_GetBufferSizePrivateKey,(int* pBufferSize, const IppsRSAPrivateKeyState* pKey))
{
   IPP_BAD_PTR1_RET(pKey);
   pKey = (IppsRSAPrivateKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PUBLIC_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PRV_KEY_VALID_ID(pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(RSA_PRV_KEY1_VALID_ID(pKey) && !RSA_PRV_KEY_IS_SET(pKey), ippStsIncompleteContextErr);

   IPP_BAD_PTR1_RET(pBufferSize);

   {
      cpSize modulusBits = (RSA_PRV_KEY1_VALID_ID(pKey))? RSA_PRV_KEY_BITSIZE_N(pKey) :
                                                  IPP_MAX(RSA_PRV_KEY_BITSIZE_P(pKey), RSA_PRV_KEY_BITSIZE_Q(pKey));
      gsMethod_RSA* m = getDefaultMethod_RSA_private(modulusBits);

      cpSize bitSizeN = (RSA_PRV_KEY1_VALID_ID(pKey))? modulusBits : modulusBits*2;
      cpSize nsN = BITS_BNU_CHUNK(bitSizeN);

      cpSize bn_scheme = (nsN+1)*2;    /* BN for RSA schemes */
      cpSize bn3_gen = (RSA_PRV_KEY2_VALID_ID(pKey))? (nsN+1)*2*3 : 0; /* 3 BN for generation/validation */

      cpSize bufferNum = bn_scheme*2               /* (1)2 BN for RSA (enc)/sign schemes */
                       + 1;                        /* BNU_CHUNK_T alignment */
      bufferNum += m->bufferNumFunc(modulusBits);  /* RSA private key operation */

      bufferNum = IPP_MAX(bufferNum, bn3_gen); /* generation/validation resource overlaps RSA resource  */

      *pBufferSize = bufferNum*sizeof(BNU_CHUNK_T);

      #if defined(_USE_WINDOW_EXP_)
      /* pre-computed table should be CACHE_LINE aligned*/
      *pBufferSize += CACHE_LINE_SIZE;
      #endif

      return ippStsNoErr;
   }
}
