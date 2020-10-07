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
 *        ippsRSA_MB_Decrypt()
 *
*/

#include "owncp.h"
#include "pcpngrsa_mb.h"

#if(_IPP32E>=_IPP32E_K0)
   #include <crypto_mb/rsa.h>
#endif

/*!
 *  \brief ippsRSA_MB_Decrypt
 * 
 *  Name:         ippsRSA_MB_Decrypt
 * 
 *  Purpose:      Performs RSA Multi Buffer Decryprion
 *  
 *  Parameters:
 *    \param[in]   pCtxts                 Pointer to the array of ciphertexts.
 *    \param[out]  pPtxts                 Pointer to the array of plaintexts.
 *    \param[in]   pKeys                  Pointer to the array of key contexts.
 *    \param[out]  statuses               Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pBuffer                Pointer to temporary buffer.
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
 *    \return ippStsBadArgErr             Indicates an error condition if types of private keys is different 
 *                                        from each other.
 *    \return ippStsContextMatchErr       Indicates an error condition if no valid keys were found.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 No error.                        
 */

IPPFUN(IppStatus, ippsRSA_MB_Decrypt,(const IppsBigNumState* const pCtxts[8],
                                      IppsBigNumState* const pPtxts[8],
                                      const IppsRSAPrivateKeyState* const pKeys[8],
                                      IppStatus statuses[8], Ipp8u* pBuffer))
{
   IPP_BAD_PTR1_RET(pKeys);
   IPP_BAD_PTR4_RET(pPtxts, pCtxts, pBuffer, statuses);

   int i, valid_key_id;

   {
      IppStatus consistencyCheckSts = CheckPrivateKeysConsistency(pKeys, &valid_key_id);
      if (valid_key_id == -1) {
        return consistencyCheckSts;
      }
   }

   #if(_IPP32E>=_IPP32E_K0)
      const int rsa_bitsize = RSA_PRV_KEY_BITSIZE_N(pKeys[valid_key_id]);
      if (IsFeatureEnabled(ippCPUID_AVX512IFMA) && OPTIMIZED_RSA_SIZE(rsa_bitsize)) {
         mbx_status ifma_sts;
         if (RSA_PRV_KEY1_VALID_ID(pKeys[valid_key_id]))
            ifma_sts = ifma_RSAprv_cipher(pPtxts, pCtxts, pKeys, rsa_bitsize, pBuffer);
         else
            ifma_sts = ifma_RSAprv_cipher_crt(pPtxts, pCtxts, pKeys, rsa_bitsize, pBuffer);

         return convert_ifma_to_ipp_sts(ifma_sts, statuses);
      }
      else
   #endif

   {
      for(i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
         statuses[i] = ippsRSA_Decrypt(pCtxts[i], pPtxts[i], pKeys[i], pBuffer);
      }

      for(i = 0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
         if(statuses[i] != ippStsNoErr) {
            return ippStsMbWarning;
         }
      }

      return ippStsNoErr;
   }
}
