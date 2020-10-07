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

/*
//
//  Purpose:
//     Cryptography Primitive.
//     RSA Multi Buffer Functions
//
//  Contents:
//        ifma_RSAprv_cipher()
//
*/

#include "owncp.h"

#if(_IPP32E>=_IPP32E_K0)

#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

#include <crypto_mb/rsa.h>

IPP_OWN_DEFN (mbx_status , ifma_RSAprv_cipher, (IppsBigNumState* const pPtxts[8], const IppsBigNumState* const pCtxts[8], const IppsRSAPrivateKeyState* const pKeys[8], const int rsa_bitsize, Ipp8u* pScratchBuffer))
{
    const int rsa_bytesize = rsa_bitsize / 8;
    const mbx_RSA_Method* m = mbx_RSA_private_Method(rsa_bitsize);

    int8u* from_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* n_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* d_pa[RSA_MB_MAX_BUF_QUANTITY];

    for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
        d_pa[i] = RSA_PRV_KEY_D(pKeys[i]);
        n_pa[i] = MOD_MODULUS(RSA_PRV_KEY_NMONT(pKeys[i]));
        from_pa[i] = (int8u*)BN_BUFFER(pPtxts[i]);
        ippsGetOctString_BN(from_pa[i], rsa_bytesize, pCtxts[i]);
    }

    mbx_status ifma_sts = mbx_rsa_private_mb8((const int8u* const*)from_pa, from_pa, (const int64u* const*)d_pa, (const int64u* const*)n_pa, rsa_bitsize, m, pScratchBuffer);

    for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
        ippsSetOctString_BN(from_pa[i], rsa_bytesize, pPtxts[i]);
    }

    return ifma_sts;
}

#endif
