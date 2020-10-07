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
 *        ippsRSA_MB_Sign_PKCS1v15_rmf()
 *
*/

#include "owncp.h"
#include "pcpngrsa_mb.h"

#include "pcprsa_pkcs1c15_data.h"
#include "pcprsa_pkcs1v15_preproc.h"
#include "pcprsa_emsa_pkcs1v15.h"
#include "internal_hashmessage_mb.h"

/*!
 *  \brief ippsRSA_MB_Sign_PKCS1v15_rmf
 *
 *  Name:         ippsRSA_MB_Sign_PKCS1v15_rmf
 *
 *  Purpose:      Performs RSA Multi Buffer signing using PKCS1v1.5 scheme
 *
 *  Parameters:
 *    \param[in]   pMsgs                  Pointer to the array of messages to be signed.
 *    \param[in]   msgLens                Pointer to the array of messages lengths.
 *    \param[out]  pSignts                Pointer to the array of output signatures.
 *    \param[in]   pPrvKeys               Pointer to the array of preliminary initialized IppsRSAPrivateKeyState contexts.
 *    \param[in]   pPubKeys               Pointer to the array of preliminary initialized IppsRSAPublicKeyState optional contexts.
 *    \param[out]  statuses               Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pMethod                Pointer to the hashing method to be used. For details, see HashMethod functions.
 *    \param[in]   pBuffer                Pointer to the temporary buffer. The size of the buffer shall not be less than the value returned by RSA_MB_GetBufferSizePrivateKey and RSA_MB_GetBufferSizePublicKeyKey functions.
 *
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            Any of the input parameters is a NULL pointer.
 *    \return ippStsSizeErr               Mismatch between modulus n sizes in the input contexts.
 *    \return ippStsBadArgErr             Mismatch between types of private keys or exponents e in public keys.
 *    \return ippStsContextMatchErr       No valid keys were found.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 Indicates no error. All single operations are executed without errors. Any other value indicates an error or warning.
 */

IPPFUN(IppStatus, ippsRSA_MB_Sign_PKCS1v15_rmf, (const Ipp8u* const pMsgs[8], const int msgLens[8],
                                                       Ipp8u* const pSignts[8],
                                                 const IppsRSAPrivateKeyState* const pPrvKeys[8],
                                                 const IppsRSAPublicKeyState* const pPubKeys[8],
                                                 const IppsHashMethod* pMethod,
                                                 IppStatus statuses[8], Ipp8u* pBuffer))
{
   int errorEncountered = 0;

   IPP_BAD_PTR2_RET(pMsgs, msgLens);
   IPP_BAD_PTR2_RET(pSignts, statuses);
   IPP_BAD_PTR2_RET(pPrvKeys, pPubKeys);
   IPP_BAD_PTR1_RET(pMethod);
   IPP_BAD_PTR1_RET(pBuffer);

   cpSize rsaBits = 0;
   { // Check that all the valid keys are consistent
      int validKeyId;
      IppStatus consistencyCheckSts = CheckPrivateKeysConsistency(pPrvKeys, &validKeyId);
      if (-1 == validKeyId) {
         return consistencyCheckSts;
      }
      rsaBits = RSA_PRV_KEY_BITSIZE_N(pPrvKeys[validKeyId]);
      consistencyCheckSts = CheckPublicKeysConsistency(pPubKeys, &validKeyId);
      if (-1 == validKeyId) {
         return consistencyCheckSts;
      }
   }

   { // Check every ith set of parameters for badargs
      int i;
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         const IppStatus badargsStatus = SingleSignPkcs1v15RmfPreproc(pMsgs[i], msgLens[i], pSignts[i],
            (const IppsRSAPrivateKeyState**)&pPrvKeys[i], (const IppsRSAPublicKeyState**)&pPubKeys[i], pMethod, pBuffer);
         if (ippStsNoErr != badargsStatus) {
            statuses[i] = badargsStatus;
            errorEncountered = 1;
            continue;
         }
      }
   }

   {
      int i;

      IppStatus rsaStatuses[RSA_MB_MAX_BUF_QUANTITY]; // to use with MB RSA operations

      const cpSize rsaBytesSize = BITS2WORD8_SIZE(rsaBits);
      const cpSize rsaChunksSize = BITS_BNU_CHUNK(rsaBits);

      BNU_CHUNK_T* pAlignedBuffer = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR((pBuffer), (int)sizeof(BNU_CHUNK_T)));
      {
         const Ipp8u* const pSalt = pksc15_salt[pMethod->hashAlgId].pSalt;
         const int saltLen = pksc15_salt[pMethod->hashAlgId].saltLen;

         Ipp8u* generateHashesTo[8] = { NULL };

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i]) {
               continue; // some checks were failed
            }

            // the call with NULL as message will format the signature and left space for futher filling with msg
            if (!EMSA_PKCSv15(NULL, pMethod->hashLen, pSalt, saltLen, pSignts[i], rsaBytesSize)) {
               // EMSA_PKCSv15 encoded message len is larger than the provided signature buffers
               statuses[i] = ippStsSizeErr;
               errorEncountered = 1;
               continue;
            }

            generateHashesTo[i] = pSignts[i] + rsaBytesSize - pMethod->hashLen;
         }

         // the function will not change outputs for NULLed generateHashesTo elements
         cpHashMessage_MB8_rmf(pMsgs, msgLens, generateHashesTo, pMethod); // write into pSignts
      }

      // temporary BNs
      __ALIGN8 IppsBigNumState signatureAsBn[RSA_MB_MAX_BUF_QUANTITY];
      __ALIGN8 IppsBigNumState encryptedSignatures[RSA_MB_MAX_BUF_QUANTITY];
      const IppsBigNumState* signatureAsBnPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
      IppsBigNumState* encryptedSignaturesPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };

      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, &signatureAsBn[i]);
         pAlignedBuffer += (rsaChunksSize + 1) * 2;
         BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, &encryptedSignatures[i]);
         pAlignedBuffer += (rsaChunksSize + 1) * 2;

         ippsSetOctString_BN(pSignts[i], rsaBytesSize, &signatureAsBn[i]);
         signatureAsBnPtrs[i] = &signatureAsBn[i];
         encryptedSignaturesPtrs[i] = &encryptedSignatures[i];
      }

      // the cast is needed because C std does not allow to automatically add `const` at many levels
      ippsRSA_MB_Decrypt((const IppsBigNumState* const *)signatureAsBnPtrs, encryptedSignaturesPtrs, pPrvKeys, rsaStatuses, (Ipp8u*)pAlignedBuffer);
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         if (ippStsNoErr != rsaStatuses[i]) {
            statuses[i] = rsaStatuses[i]; // do not override != ippStsNoErr statuses
            errorEncountered = 1;
         } else {
            ippsGetOctString_BN(pSignts[i], rsaBytesSize, &encryptedSignatures[i]);
         }
      }

      ippsRSA_MB_Encrypt((const IppsBigNumState* const *)encryptedSignaturesPtrs, encryptedSignaturesPtrs, pPubKeys, rsaStatuses, (Ipp8u*)pAlignedBuffer);
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         if (0 != cpBN_cmp(&signatureAsBn[i], &encryptedSignatures[i])) {
            PadBlock(0x0, pSignts[i], rsaBytesSize); // erase the created signature
            statuses[i] = ippStsSizeErr;
            errorEncountered = 1;
         }
      }
   }

   return errorEncountered ? ippStsMbWarning : ippStsNoErr;
}
