/*******************************************************************************
* Copyright 2019-2020 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

/*!
 * \file
 *
 *  Purpose:
 *     Cryptography Primitive.
 *     RSA Multi Buffer Functions
 *
 *  Contents:
 *        ippsRSA_MB_GetBufferSizePublicKey()
 *
*/

/*!
 *  \brief ippsRSA_MB_GetBufferSizePublicKey
 *
 *  Name:         ippsRSA_MB_GetBufferSizePublicKey
 *
 *  Purpose:      Returns size of temporary buffer (in bytes) for multi buffer public key operation
 *
 *  Parameters:
 *    \param[out]  pBufferSize            Pointer to size of temporary buffer.
 *    \param[in]   pKeys                  Pointer to the array of key contexts.
 *
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            NULL == pKeys
 *                                        NULL == pBufferSize
 *
 *    \return ippStsContextMatchErr       No keys with valid ID.
 *
 *    \return ippStsIncompleteContextErr  no ippsRSA_SetPublicKey() call for any key context
 *
 *    \return ippStsSizeErr               Indicates an error condition if size of modulus N in one context is
 *                                        different from sizes of modulus N in oter contexts.
 *    \return ippStsBadArgErr             Indicates an error condition if value or size of exp E in one context is
 *                                        different from values or sizes of exp E in other contexts.
 *
 *    \return ippStsNoErr                 No error.
 */

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

#include "pcprsa_getdefmeth_pub.h"

#if(_IPP32E>=_IPP32E_K0)
   #include <crypto_mb/rsa.h>
#endif

IPPFUN(IppStatus, ippsRSA_MB_GetBufferSizePublicKey, (int* pBufferSize, const IppsRSAPublicKeyState* const pKeys[8]))
{
    IPP_BAD_PTR2_RET(pKeys, pBufferSize);
    int valid_key_id;

    {
        IppStatus consistencyCheckSts = CheckPublicKeysConsistency(pKeys, &valid_key_id);
        if (valid_key_id == -1) {
            return consistencyCheckSts;
        }

        // pKeys passed the CheckPublicKeysConsistency(), so if any key is not set up, then the pKeys[valid_key_id] is also not set up
        IPP_BADARG_RET(!RSA_PUB_KEY_IS_SET(pKeys[valid_key_id]), ippStsIncompleteContextErr);
    }

    const cpSize bitSizeN = RSA_PUB_KEY_BITSIZE_N(pKeys[valid_key_id]);
    const cpSize rsaChunksSize = BITS_BNU_CHUNK(bitSizeN);
    const cpSize singleBnSize = (rsaChunksSize + 1) * 2;

    // 16 BNs for verification scheme + BNU_CHUNK_T alignment
    cpSize bufferNum = singleBnSize * 16 + 1;

    #if (_IPP32E >= _IPP32E_K0)
        if (IsFeatureEnabled(ippCPUID_AVX512IFMA) && OPTIMIZED_RSA_SIZE(bitSizeN))
        {
            *pBufferSize = bufferNum * (Ipp32s)sizeof(BNU_CHUNK_T);
            const mbx_RSA_Method* m = mbx_RSA_pub65537_Method(bitSizeN);
            *pBufferSize += mbx_RSA_Method_BufSize(m);
        }

        else
    #endif
    {
        // for reference MB implementation
        const gsMethod_RSA* m = getDefaultMethod_RSA_public(bitSizeN);
        bufferNum += m->bufferNumFunc(bitSizeN);

        *pBufferSize = bufferNum * (Ipp32s)sizeof(BNU_CHUNK_T);
    }

    return ippStsNoErr;
}