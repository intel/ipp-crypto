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
 *        ippsRSA_MB_Encrypt()
 *
*/

#include "owncp.h"
#include "pcpngrsa_mb.h"

#if(_IPP32E>=_IPP32E_K0)
   #include <crypto_mb/rsa.h>
#endif

/*!
 *  \brief ippsRSA_MB_Encrypt
 * 
 *  Name:         ippsRSA_MB_Encrypt
 * 
 *  Purpose:      Performs RSA Multi Buffer Encryprion
 *  
 *  Parameters:
 *    \param[in]   pPtxts                 Pointer to the array of plaintexts.
 *    \param[out]  pCtxts                 Pointer to the array of ciphertexts.
 *    \param[in]   pKeys                  Pointer to the array of key contexts.
 *    \param[out]  statuses               Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pBuffer                Pointer to the temporary buffer.
 * 
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            Indicates an error condition if any of the specified pointers is NULL.
 *                                        NULL == pPtxts
 *                                        NULL == pCtxts
 *                                        NULL == pKeys
 *                                        NULL == pBuffers
 *                                        NULL == statuses
 *    \return ippStsSizeErr               Indicates an error condition if size of modulus N in one context is  
 *                                        different from sizes of modulus N in oter contexts.
 *    \return ippStsBadArgErr             Indicates an error condition if value or size of exp E in one context is 
 *                                        different from values or sizes of exp E in other contexts.
 *    \return ippStsContextMatchErr       Indicates an error condition if no valid keys were found.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 No error.
 */

IPPFUN(IppStatus, ippsRSA_MB_Encrypt,(const IppsBigNumState* const pPtxts[8],
                                      IppsBigNumState* const pCtxts[8],
                                      const IppsRSAPublicKeyState* const pKeys[8],
                                      IppStatus statuses[8], Ipp8u* pBuffer))
{
   IPP_BAD_PTR1_RET(pKeys);
   IPP_BAD_PTR4_RET(pPtxts, pCtxts, pBuffer, statuses);

   int i, valid_key_id;

   {
      IppStatus consistencyCheckSts = CheckPublicKeysConsistency(pKeys, &valid_key_id);
      if (valid_key_id == -1) {
         return consistencyCheckSts;
      }
   }

   #if(_IPP32E>=_IPP32E_K0)
      const int rsa_bitsize = RSA_PUB_KEY_BITSIZE_N(pKeys[valid_key_id]);
      if (IsFeatureEnabled(ippCPUID_AVX512IFMA) && *(RSA_PUB_KEY_E(pKeys[valid_key_id])) == PUB_EXP_65537 && OPTIMIZED_RSA_SIZE(rsa_bitsize))
      {
         const int rsa_bytesize = rsa_bitsize/8;
         int8u* from_pa[RSA_MB_MAX_BUF_QUANTITY];
         int64u* n_pa[RSA_MB_MAX_BUF_QUANTITY];
         const mbx_RSA_Method* m = mbx_RSA_pub65537_Method(rsa_bitsize);

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
            n_pa[i] = MOD_MODULUS(RSA_PUB_KEY_NMONT(pKeys[i]));
            from_pa[i] = (int8u*)BN_BUFFER(pCtxts[i]);
            ippsGetOctString_BN(from_pa[i], rsa_bytesize, pPtxts[i]);
         }

         mbx_status ifma_sts = mbx_rsa_public_mb8((const int8u* const*)from_pa, from_pa, (const int64u* const*)n_pa, rsa_bitsize, m, pBuffer);

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
            ippsSetOctString_BN(from_pa[i], rsa_bytesize, pCtxts[i]);
         }

         return convert_ifma_to_ipp_sts(ifma_sts, statuses);
      }

      else
   #endif
   {
      for(i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
         statuses[i] = ippsRSA_Encrypt(pPtxts[i], pCtxts[i], pKeys[i], pBuffer);
      }

      for(i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
         if(statuses[i] != ippStsNoErr) {
            return ippStsMbWarning;
         }
      }

      return ippStsNoErr;
   }
}
