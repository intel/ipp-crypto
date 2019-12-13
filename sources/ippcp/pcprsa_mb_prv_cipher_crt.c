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

/*
//
//  Purpose:
//     Cryptography Primitive.
//     RSA Multi Buffer Functions
//
//  Contents:
//        ifma_RSAprv_cipher_crt()
//
*/

#include "owncp.h"

#if(_IPP32E>=_IPP32E_K0)

#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"
#include "rsa_ifma_status.h"
#include "ifma_method.h"
#include "rsa_ifma_cp.h"

ifma_status  ifma_RSAprv_cipher_crt(IppsBigNumState* const pPtxts[8],
                                    const IppsBigNumState* const pCtxts[8],
                                    const IppsRSAPrivateKeyState* const pKeys[8],
                                    const int rsa_bitsize,
                                    Ipp8u* pScratchBuffer)
{
    const int rsa_bytesize = rsa_bitsize / 8;
    const ifma_RSA_Method* m = ifma_cp_RSA_private_ctr_Method(rsa_bitsize);

    int8u* from_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* p_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* q_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* dp_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* dq_pa[RSA_MB_MAX_BUF_QUANTITY];
    int64u* iq_pa[RSA_MB_MAX_BUF_QUANTITY];

    for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
        p_pa[i] = MOD_MODULUS(RSA_PRV_KEY_PMONT(pKeys[i]));
        q_pa[i] = MOD_MODULUS(RSA_PRV_KEY_QMONT(pKeys[i]));
        dp_pa[i] = RSA_PRV_KEY_DP(pKeys[i]);
        dq_pa[i] = RSA_PRV_KEY_DQ(pKeys[i]);
        iq_pa[i] = RSA_PRV_KEY_INVQ(pKeys[i]);
        from_pa[i] = (int8u*)BN_BUFFER(pPtxts[i]);
        ippsGetOctString_BN(from_pa[i], rsa_bytesize, pCtxts[i]);
    }

    ifma_status ifma_sts = ifma_cp_rsa52_private_ctr_mb8((const int8u* const*)from_pa, from_pa, (const int64u* const*)p_pa, (const int64u* const*)q_pa, (const int64u* const*)dp_pa, (const int64u* const*)dq_pa, (const int64u* const*)iq_pa, rsa_bitsize, m, pScratchBuffer);

    for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
        ippsSetOctString_BN(from_pa[i], rsa_bytesize, pPtxts[i]);
    }

    return ifma_sts;
}

#endif
