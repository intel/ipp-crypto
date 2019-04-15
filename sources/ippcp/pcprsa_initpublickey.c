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
//        ippsRSA_InitPublicKey()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"

#include "pcprsa_sizeof_pubkey.h"
/*F*
// Name: ippsRSA_InitPublicKey
//
// Purpose: Init RSA public key context
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pKey
//
//    ippStsNotSupportedModeErr  MIN_RSA_SIZE > rsaModulusBitSize
//                               MAX_RSA_SIZE < rsaModulusBitSize
//
//    ippStsBadArgErr            0 >= publicExpBitSize
//                               publicExpBitSize > rsaModulusBitSize
//
//    ippStsMemAllocErr          keyCtxSize is not enough for operation
//
//    ippStsNoErr                no error
//
// Parameters:
//    rsaModulusBitSize    bitsize of RSA modulus (bitsize of N)
//    publicExpBitSize     bitsize of public exponent (bitsize of E)
//    pKey                 pointer to the key context
//    keyCtxSize           size of memmory accosizted with key comtext
*F*/
IPPFUN(IppStatus, ippsRSA_InitPublicKey,(int rsaModulusBitSize, int publicExpBitSize,
                                         IppsRSAPublicKeyState* pKey, int keyCtxSize))
{
   IPP_BAD_PTR1_RET(pKey);
   pKey = (IppsRSAPublicKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PUBLIC_KEY_ALIGNMENT) );

   IPP_BADARG_RET((MIN_RSA_SIZE>rsaModulusBitSize) || (rsaModulusBitSize>MAX_RSA_SIZE), ippStsNotSupportedModeErr);
   IPP_BADARG_RET(!((0<publicExpBitSize) && (publicExpBitSize<=rsaModulusBitSize)), ippStsBadArgErr);

   /* test available size of context buffer */
   IPP_BADARG_RET(keyCtxSize<cpSizeof_RSA_publicKey(rsaModulusBitSize, publicExpBitSize), ippStsMemAllocErr);

   RSA_PUB_KEY_ID(pKey) = idCtxRSA_PubKey;
   RSA_PUB_KEY_MAXSIZE_N(pKey) = rsaModulusBitSize;
   RSA_PUB_KEY_MAXSIZE_E(pKey) = publicExpBitSize;
   RSA_PUB_KEY_BITSIZE_N(pKey) = 0;
   RSA_PUB_KEY_BITSIZE_E(pKey) = 0;

   {
      Ipp8u* ptr = (Ipp8u*)pKey;

      int pubExpLen = BITS_BNU_CHUNK(publicExpBitSize);
      int modulusLen32 = BITS2WORD32_SIZE(rsaModulusBitSize);
      int montNsize;
      rsaMontExpGetSize(modulusLen32, &montNsize);

      /* allocate internal contexts */
      ptr += sizeof(IppsRSAPublicKeyState);

      RSA_PUB_KEY_E(pKey) = (BNU_CHUNK_T*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(BNU_CHUNK_T)) );
      ptr += pubExpLen*sizeof(BNU_CHUNK_T);

      RSA_PUB_KEY_NMONT(pKey) = (gsModEngine*)( IPP_ALIGNED_PTR((ptr), (MONT_ALIGNMENT)) );
      ptr += montNsize;

      ZEXPAND_BNU(RSA_PUB_KEY_E(pKey), 0, pubExpLen);
      gsModEngineInit(RSA_PUB_KEY_NMONT(pKey), 0, rsaModulusBitSize, MOD_ENGINE_RSA_POOL_SIZE, gsModArithRSA());

      return ippStsNoErr;
   }
}
