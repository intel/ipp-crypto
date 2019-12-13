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

/*!
 * \file
 *
 *  Purpose:
 *     Cryptography Primitive.
 *     RSA Multi Buffer Functions
 *
 *  Contents:
 *        ippsRSA_MB_GetBufferSizePrivateKey()
 *
*/

/*!
 *  \brief ippsRSA_MB_GetBufferSizePrivateKey
 *
 *  Name:         ippsRSA_MB_GetBufferSizePrivateKey
 *
 *  Purpose:      Returns size of temporary buffer (in bytes) for multi buffer public key operation
 *
 *  Parameters:
 *    \param[out]  pBufferSize            Pointer to size of temporary buffer.
 *    \param[in]   pKey                   Pointer to the array of key contexts.
 *
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            NULL == pKey
 *                                        NULL == pBufferSize
 *
 *    \return ippStsContextMatchErr       No keys with valid ID.
 *
 *    \return ippStsIncompleteContextErr  No one (type1) private key is set up
 *
 *    \return ippStsSizeErr               Indicates an error condition if size of modulus N in one context is
 *                                        different from sizes of modulus N in oter contexts.
 *    \return ippStsBadArgErr             Indicates an error condition if types of private keys is different
 *                                        from each other.
 *
 *    \return ippStsNoErr                 No error.
 */

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

#include "pcprsa_getdefmeth_priv.h"

#if(_IPP32E>=_IPP32E_K0)
    #include "rsa_ifma_cp.h"
    #include "rsa_ifma_defs.h"
    #include "ifma_method.h"
#endif

IPPFUN(IppStatus, ippsRSA_MB_GetBufferSizePrivateKey, (int* pBufferSize, const IppsRSAPrivateKeyState* const pKeys[8]))
{
    IPP_BAD_PTR2_RET(pKeys, pBufferSize);
    int valid_key_id;

    {
        IppStatus consistencyCheckSts = CheckPrivateKeysConsistency(pKeys, &valid_key_id);
        if (valid_key_id == -1) {
            return consistencyCheckSts;
        }

        // pKeys passed the CheckPrivateKeysConsistency(), so if pKeys[valid_key_id] is not set up, then the rest are also not set up
        IPP_BADARG_RET(!RSA_PRV_KEY_IS_SET(pKeys[valid_key_id]), ippStsIncompleteContextErr);
    }
   
    const cpSize modulusBits = (RSA_PRV_KEY1_VALID_ID(pKeys[valid_key_id])) ? RSA_PRV_KEY_BITSIZE_N(pKeys[valid_key_id]) :
        IPP_MAX(RSA_PRV_KEY_BITSIZE_P(pKeys[valid_key_id]), RSA_PRV_KEY_BITSIZE_Q(pKeys[valid_key_id]));

    const cpSize bitSizeN = (RSA_PRV_KEY1_VALID_ID(pKeys[valid_key_id])) ? modulusBits : modulusBits * 2;
    const cpSize rsaChunksSize = BITS_BNU_CHUNK(bitSizeN);

    const cpSize singleBnSize = (rsaChunksSize + 1) * 2;

    // NB: No bn3_gen here, because keys generation use a single buffer version

    // 16 BNs for signature scheme + BNU_CHUNK_T alignment
    cpSize bufferNum = singleBnSize * 16 + 1;

    #if (_IPP32E >= _IPP32E_K0)
        const int rsa_bitsize = RSA_PRV_KEY_BITSIZE_N(pKeys[valid_key_id]);
        if (IsFeatureEnabled(ippCPUID_AVX512IFMA) && OPTIMIZED_RSA_SIZE(rsa_bitsize))
        {
            *pBufferSize = bufferNum * sizeof(BNU_CHUNK_T);
            const ifma_RSA_Method* m = (RSA_PRV_KEY1_VALID_ID(pKeys[valid_key_id])) ? ifma_cp_RSA_private_Method(rsa_bitsize) : ifma_cp_RSA_private_ctr_Method(rsa_bitsize);
            *pBufferSize += ifma_RSA_Method_BufSize(m);
        }

        else
    #endif
        {
            // for reference MB implementation
            const gsMethod_RSA* m = getDefaultMethod_RSA_private(modulusBits);
            bufferNum += m->bufferNumFunc(modulusBits);

            *pBufferSize = bufferNum * sizeof(BNU_CHUNK_T);
            #if defined(_USE_WINDOW_EXP_)
                    // pre-computed table should be CACHE_LINE aligned
                    *pBufferSize += CACHE_LINE_SIZE;
            #endif
        }

    return ippStsNoErr;
}