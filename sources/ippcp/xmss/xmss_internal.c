/*************************************************************************
* Copyright (C) 2023 Intel Corporation
*
* Licensed under the Apache License,  Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* 	http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law  or agreed  to  in  writing,  software
* distributed under  the License  is  distributed  on  an  "AS IS"  BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the  specific  language  governing  permissions  and
* limitations under the License.
*************************************************************************/

#include "owndefs.h"
#include "xmss_internal/xmss.h"

/*
 * Does the randomized hashing in the tree
 *
 * Input parameters:
 *    left        left  half of the hash function input (n-byte array)
 *    right       right half of the hash function input (n-byte array)
 *    seed        key for the prf function (n-byte array)
 *    adrs        address ADRS of the hash function call
 *    temp_buf    temporary memory (size is 6 * n bytes at least)
 *    params      WOTS parameters (w, log2_w, n, len, len_1, hash_method)
 *
 * Output parameters:
 *    out         resulted n-byte array that contains hash
 */

IPP_OWN_DEFN(IppStatus, rand_hash, (Ipp8u* left, Ipp8u* right, Ipp8u* seed,
            Ipp8u* adrs, Ipp8u* out, Ipp8u* temp_buf, cpWOTSParams* params)){
    IppStatus retCode = ippStsNoErr;
    Ipp8u* pMsg = temp_buf;
    Ipp8u* pKey = temp_buf + 2 * params->n;
    Ipp8u* temp = temp_buf + 3 * params->n;

    adrs[set_adrs_1_byte(7)] = /*key bitmask*/ 0;
    retCode = prf(seed, adrs, pKey, temp, params);
    IPP_BADARG_RET((ippStsNoErr != retCode), retCode)

    adrs[set_adrs_1_byte(7)] = /*left bitmask*/ 1;
    retCode = prf(seed, adrs, pMsg, temp, params);
    IPP_BADARG_RET((ippStsNoErr != retCode), retCode)

    adrs[set_adrs_1_byte(7)] = /*right bitmask*/ 2;
    retCode = prf(seed, adrs, pMsg + params->n, temp, params);
    IPP_BADARG_RET((ippStsNoErr != retCode), retCode)

    // null adrs
    adrs[set_adrs_1_byte(7)] = 0;

    // (LEFT XOR BM_0) || (RIGHT XOR BM_1)
    for (Ipp32s i = 0; i < params->n; ++i) {
        pMsg[i]             = left[i]  ^ pMsg[i];
        pMsg[i + params->n] = right[i] ^ pMsg[i + params->n];
    }

    //H(KEY, pMsg);
    retCode = do_xmss_hash(/*H padding id*/ 1, pKey, pMsg, 2 * params->n, out, temp, params);
    return retCode;
}

/*
 * Compute the leaves of the binary hash tree, a so-called L-tree.
 * An L-tree is an unbalanced binary hash tree, distinct but
 * similar to the main XMSS binary hash tree. The function takes as input a
 * WOTS+ public key pk and compresses it to a single n-byte value pk[0].
 * It also takes as input an L-tree address adrs that encodes the address
 * of the L-tree and seed
 *
 * temp_buf size is 6 * n bytes at least.
 *
 */

IPP_OWN_DEFN(IppStatus, ltree, (Ipp8u* pk, Ipp8u* seed, Ipp8u* adrs, Ipp8u* temp_buf, cpWOTSParams* params)) {
    IppStatus retCode = ippStsNoErr;
    Ipp32s len_ = params->len;
    Ipp32s n_ = params->n;

    // tree height is 0 for now
    adrs[set_adrs_1_byte(5)] = 0;

    while (len_ > 1) {
        for (Ipp32s i = 0; i < len_ / 2; i++) {
            adrs[set_adrs_1_byte(6)] = /*tree index*/ (Ipp8u) i;

            retCode = rand_hash(pk + (2 * i * n_), pk + ((2 * i * n_) + n_), seed, adrs, pk + (i * n_), temp_buf, params);
            IPP_BADARG_RET((ippStsNoErr != retCode), retCode)
        }
        if ((len_ & 1) == 1) {
            CopyBlock(pk + (n_ * (len_ - 1)), pk + (n_ * (len_ / 2)), n_);
            len_ = (len_ >> 1) + 1;
        }
        else {
            len_ = len_ >> 1;
        }
        // increase the tree height
        adrs[set_adrs_1_byte(5)] += 1;
    }

    // null tree height and tree index
    adrs[set_adrs_1_byte(5)] = 0;
    adrs[set_adrs_1_byte(6)] = 0;
    return retCode;
}
