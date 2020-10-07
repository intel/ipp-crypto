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
 *        ippsRSA_MB_Sign_PSS_rmf()
 *
*/

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

#include "pcprsa_pss_preproc.h"
#include "internal_hashmessage_mb.h"
#include "pcptool.h"

/*!
 *  \brief ippsRSA_MB_Sign_PSS_rmf
 *
 *  Name:         ippsRSA_MB_Sign_PSS_rmf
 *
 *  Purpose:      Performs RSA Multi Buffer signing using PSS scheme
 *
 *  Parameters:
 *    \param[in]   pMsgs                  Pointer to the array of messages to be signed.
 *    \param[in]   msgLens                Pointer to the array of messages lengths.
 *    \param[in]   pSalts                 Pointer to the array of random octet salt strings.
 *    \param[in]   saltLens               Pointer to the array of salts lengths.
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

IPPFUN(IppStatus, ippsRSA_MB_Sign_PSS_rmf, (const Ipp8u* const pMsgs[8], const int msgLens[8],
                                             const Ipp8u* const pSalts[8], const int saltLens[8],
                                                   Ipp8u* const pSignts[8],
                                             const IppsRSAPrivateKeyState* const pPrvKeys[8],
                                             const IppsRSAPublicKeyState* const pPubKeys[8],
                                             const IppsHashMethod* pMethod,
                                             IppStatus statuses[8], Ipp8u* pBuffer))
{
   int errorEncountered = 0;

   IPP_BAD_PTR2_RET(pMsgs, msgLens);
   IPP_BAD_PTR2_RET(pSalts, saltLens);
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
         const IppStatus badargsStatus = SingleSignPssRmfPreproc(pMsgs[i], msgLens[i], pSalts[i], saltLens[i],
            pSignts[i], (const IppsRSAPrivateKeyState**)&pPrvKeys[i], (const IppsRSAPublicKeyState**)&pPubKeys[i], pMethod, pBuffer);
         if (ippStsNoErr != badargsStatus) {
            statuses[i] = badargsStatus;
            errorEncountered = 1;
         }
      }
   }

   {
      int i;

      IppStatus rsaStatuses[RSA_MB_MAX_BUF_QUANTITY]; // to use with MB RSA operations

      const cpSize rsaBytesSize = BITS2WORD8_SIZE(rsaBits);
      const cpSize rsaChunksSize = BITS_BNU_CHUNK(rsaBits);

      // temporary BNs
      __ALIGN8 IppsBigNumState signatureAsBn[RSA_MB_MAX_BUF_QUANTITY];
      __ALIGN8 IppsBigNumState encryptedSignatures[RSA_MB_MAX_BUF_QUANTITY];
      IppsBigNumState* signatureAsBnPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
      IppsBigNumState* encryptedSignaturesPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };

      // message presentative size
      const int emBits = rsaBits - 1;
      const int emLen = BITS2WORD8_SIZE(emBits);

      BNU_CHUNK_T* pAlignedBuffer = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR((pBuffer), (int)sizeof(BNU_CHUNK_T)));
      {
         Ipp8u* generateHashesTo[RSA_MB_MAX_BUF_QUANTITY] = { NULL };

         /* construct message M'
         // M' = (00 00 00 00 00 00 00 00) || mHash || salt
         // where:
         //    mHash = HASH(pMsg)
         */
         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i]) {
               continue; // some checks were failed
            }

            // size of padding string (PS)
            const int psLen = emLen - pMethod->hashLen - saltLens[i] - 2;

            // test size consistence
            if (0 > psLen) {
               statuses[i] = ippStsLengthErr;
               errorEncountered = 1;
               continue;
            }

            signatureAsBnPtrs[i] = &signatureAsBn[i];
            encryptedSignaturesPtrs[i] = &encryptedSignatures[i];

            BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, signatureAsBnPtrs[i]);
            pAlignedBuffer += (rsaChunksSize + 1) * 2;
            BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, encryptedSignaturesPtrs[i]);
            pAlignedBuffer += (rsaChunksSize + 1) * 2;

            Ipp8u* tmpBuffer = (Ipp8u*)BN_NUMBER(signatureAsBnPtrs[i]);

            PadBlock(0, tmpBuffer, 8);
            generateHashesTo[i] = tmpBuffer + 8;
            CopyBlock(pSalts[i], tmpBuffer + 8 + pMethod->hashLen, saltLens[i]);
         }

         // the function will not change outputs for NULLed generateHashesTo elements
         cpHashMessage_MB8_rmf(pMsgs, msgLens, generateHashesTo, pMethod);

         /* construct EM
         // EM = maskedDB || H || 0xBC
         // where:
         //    H = HASH(M')
         //    maskedDB = DB ^ MGF(H)
         //    where:
         //       DB = PS || 0x01 || salt
         //
         // by other words
         // EM = (dbMask ^ (PS || 0x01 || salt)) || HASH(M) || 0xBC
         */
         {
            const int dbLen = emLen - pMethod->hashLen - 1;
            Ipp8u* generateHashesFrom[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
            int sourceDataLengts[RSA_MB_MAX_BUF_QUANTITY] = { 0 };
            int targetDataLengts[RSA_MB_MAX_BUF_QUANTITY] = { 0 };

            for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
               if (ippStsNoErr != statuses[i]) {
                  continue; // some checks were failed
               }

               pSignts[i][emLen - 1] = 0xBC; // tail octet
               generateHashesFrom[i] = (Ipp8u*)BN_NUMBER(signatureAsBnPtrs[i]);
               generateHashesTo[i] = pSignts[i] + dbLen;
               sourceDataLengts[i] = 8 + pMethod->hashLen + saltLens[i];
            }

            // the cast is needed because C std does not allow to automatically add `const` at many levels
            cpHashMessage_MB8_rmf((const Ipp8u* const *)generateHashesFrom, sourceDataLengts, generateHashesTo, pMethod);

            for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
               generateHashesFrom[i] = generateHashesTo[i];
               generateHashesTo[i] = pSignts[i];
               targetDataLengts[i] = dbLen;
               sourceDataLengts[i] = pMethod->hashLen;
            }

            cpMGF1_MB8_rmf((const Ipp8u* const *)generateHashesFrom, sourceDataLengts, generateHashesTo, targetDataLengts, pMethod);

            for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
               if (ippStsNoErr != statuses[i]) {
                  continue; // some checks were failed
               }

               // size of padding string (PS)
               const int psLen = emLen - pMethod->hashLen - saltLens[i] - 2;

               XorBlock(pSignts[i] + psLen + 1, pSalts[i], pSignts[i] + psLen + 1, saltLens[i]);
               pSignts[i][psLen] ^= 0x01;

               // make sure that top 8*emLen-emBits bits are clear
               pSignts[i][0] &= MAKEMASK32(8 - 8 * emLen + emBits);
            }
         }
      }

      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         ippsSetOctString_BN(pSignts[i], emLen, signatureAsBnPtrs[i]);
      }

      ippsRSA_MB_Decrypt((const IppsBigNumState* const *)signatureAsBnPtrs, encryptedSignaturesPtrs,
         pPrvKeys, rsaStatuses, (Ipp8u*)pAlignedBuffer);
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         if (ippStsNoErr != rsaStatuses[i]) {
            statuses[i] = rsaStatuses[i]; // do not override != ippStsNoErr statuses
            errorEncountered = 1;
         } else {
            ippsGetOctString_BN(pSignts[i], rsaBytesSize, encryptedSignaturesPtrs[i]);
         }
      }

      ippsRSA_MB_Encrypt((const IppsBigNumState* const *)encryptedSignaturesPtrs, encryptedSignaturesPtrs,
         pPubKeys, rsaStatuses, (Ipp8u*)pAlignedBuffer);
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         if (0 != cpBN_cmp(signatureAsBnPtrs[i], encryptedSignaturesPtrs[i])) {
            PadBlock(0x0, pSignts[i], rsaBytesSize); // erase the created signature
            statuses[i] = ippStsErr;
            errorEncountered = 1;
         }
      }
   }


   return errorEncountered ? ippStsMbWarning : ippStsNoErr;
}
