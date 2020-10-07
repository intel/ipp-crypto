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
//     Internal Definitions
// 
// 
*/

#if !defined(_CP_NG_RSA_MB_H)
#define _CP_NG_RSA_MB_H

#define RSA_MB_MAX_BUF_QUANTITY (8)

#if RSA_MB_MAX_BUF_QUANTITY != 8
   #error RSA_MB_MAX_BUF_QUANTITY must be equal 8
#endif

#define OPTIMIZED_RSA_SIZE(x) ((x) == 1024 || (x) == 2048 || (x) == 3072 || (x) == 4096)
#define PUB_EXP_65537 (65537)

#include "owndefs.h"
#include "pcpngrsa.h"

__INLINE IppStatus CheckPrivateKeysConsistency(const IppsRSAPrivateKeyState* const pKeys[RSA_MB_MAX_BUF_QUANTITY], int* valid_key_id)
{
   *valid_key_id = -1;
   for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
      if (pKeys[i] && RSA_PRV_KEY_VALID_ID(pKeys[i])) {
         for (int j = i + 1; j < RSA_MB_MAX_BUF_QUANTITY; j++) {
            if (pKeys[j] && RSA_PRV_KEY_VALID_ID(pKeys[j])) {
               IPP_BADARG_RET(RSA_PRV_KEY_BITSIZE_N(pKeys[i]) != RSA_PRV_KEY_BITSIZE_N(pKeys[j]), ippStsSizeErr);
               IPP_BADARG_RET(RSA_PRV_KEY1_VALID_ID(pKeys[i]) != RSA_PRV_KEY1_VALID_ID(pKeys[j]), ippStsBadArgErr);
            }
         }

         *valid_key_id = i;
         return ippStsNoErr;
      }
   }

   return ippStsContextMatchErr; // no valid keys found
}

__INLINE IppStatus CheckPublicKeysConsistency(const IppsRSAPublicKeyState* const pKeys[RSA_MB_MAX_BUF_QUANTITY], int* valid_key_id)
{
   *valid_key_id = -1;
   for (int i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
      if (pKeys[i] && RSA_PUB_KEY_VALID_ID(pKeys[i])) {
         for (int j = i + 1; j < RSA_MB_MAX_BUF_QUANTITY; j++) {
            if (pKeys[j] && RSA_PUB_KEY_VALID_ID(pKeys[j])) {
               IPP_BADARG_RET(RSA_PUB_KEY_BITSIZE_N(pKeys[i]) != RSA_PUB_KEY_BITSIZE_N(pKeys[j]), ippStsSizeErr);
               IPP_BADARG_RET(cpCmp_BNU(RSA_PUB_KEY_E(pKeys[i]), RSA_PUB_KEY_BITSIZE_E(pKeys[i]) / (Ipp32s)sizeof(BNU_CHUNK_T),
                  RSA_PUB_KEY_E(pKeys[j]), RSA_PUB_KEY_BITSIZE_E(pKeys[j]) / (Ipp32s)sizeof(BNU_CHUNK_T)), ippStsBadArgErr);
            }
         }

         *valid_key_id = i;
         return ippStsNoErr;
      }
   }

   return ippStsContextMatchErr; // no valid keys found
}

#if (_IPP32E>=_IPP32E_K0)
    #include <crypto_mb/status.h>

    #define ifma_RSAprv_cipher OWNAPI(ifma_RSAprv_cipher)
        IPP_OWN_DECL (mbx_status, ifma_RSAprv_cipher, (IppsBigNumState* const pPtxts[8], const IppsBigNumState* const pCtxts[8], const IppsRSAPrivateKeyState* const pKeys[8], const int rsa_bitsize, Ipp8u* pScratchBuffer))
    #define ifma_RSAprv_cipher_crt OWNAPI(ifma_RSAprv_cipher_crt)
        IPP_OWN_DECL (mbx_status, ifma_RSAprv_cipher_crt, (IppsBigNumState* const pPtxts[8], const IppsBigNumState* const pCtxts[8], const IppsRSAPrivateKeyState* const pKeys[8], const int rsa_bitsize, Ipp8u* pScratchBuffer))

    static IppStatus convert_ifma_to_ipp_sts(mbx_status ifma_sts, IppStatus statuses[8])
    {
        int all_ok_sts = 1;
        for (int i = 0; i < 8; i++) {
            switch (MBX_GET_STS(ifma_sts, i)) {
            case 0:
                statuses[i] = ippStsNoErr;
                break;
            case 1:
                statuses[i] = ippStsBadArgErr;
                all_ok_sts = 0;
                break;
            case 2:
                statuses[i] = ippStsNullPtrErr;
                all_ok_sts = 0;
                break;
            }
        }

        if (all_ok_sts)
            return ippStsNoErr;

        return ippStsMbWarning;
    }

#endif
#endif /* _CP_NG_RSA_MB_H */
