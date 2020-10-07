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
 *        ippsRSA_MB_Verify_PSS_rmf()
 *
*/

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

#include "pcprsa_pss_preproc.h"
#include "internal_hashmessage_mb.h"
#include "pcptool.h"

/*!
 *  \brief ippsRSA_MB_Verify_PSS_rmf
 *
 *  Name:         ippsRSA_MB_Verify_PSS_rmf
 *
 *  Purpose:      Performs RSA Multi Buffer signature verifying using PSS scheme
 *
 *  Parameters:
 *    \param[in]   pMsgs                  Pointer to the array of messages that have been signed.
 *    \param[in]   msgLens                Pointer to the array of messages lengths.
 *    \param[in]   pSignts                Pointer to the array of signatures to be verified.
 *    \param[out]  pIsValid               Pointer to the array of verification results.
 *    \param[in]   pPubKeys               Pointer to the array of preliminary initialized IppsRSAPublicKeyState contexts.
 *    \param[out]  statuses               Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pMethod                Pointer to the hash method. For details, see HashMethod functions
 *    \param[in]   pBuffer                Pointer to the temporary buffer. The size of the buffer shall be not less than the value returned by RSA_MB_GetBufferSizePublicKey function.
 *
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            Any of the input parameters is a NULL pointer.
 *    \return ippStsSizeErr               Mismatch between modulus n sizes in the input contexts.
 *    \return ippStsBadArgErr             Mismatch between exponents e in public keys.
 *    \return ippStsContextMatchErr       No valid keys were found.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 Indicates no error. All single operations are executed without errors. Any other value indicates an error or warning.
 */

IPPFUN(IppStatus, ippsRSA_MB_Verify_PSS_rmf, (const Ipp8u* const pMsgs[8], const int msgLens[8],
                                                const Ipp8u* const pSignts[8],
                                                int pIsValid[8],
                                                const IppsRSAPublicKeyState* const pPubKeys[8],
                                                const IppsHashMethod* pMethod,
                                                IppStatus statuses[8], Ipp8u* pBuffer))
{
   int errorEncountered = 0;

   IPP_BAD_PTR3_RET(pMsgs, msgLens, pSignts);
   IPP_BAD_PTR2_RET(pIsValid, statuses);
   IPP_BAD_PTR1_RET(pPubKeys);
   IPP_BAD_PTR1_RET(pMethod);
   IPP_BAD_PTR1_RET(pBuffer);

   cpSize rsaBits = 0;
   { // Check that all the valid keys are consistent
      int validKeyId;
      IppStatus consistencyCheckSts = CheckPublicKeysConsistency(pPubKeys, &validKeyId);
      if (-1 == validKeyId) {
         return consistencyCheckSts;
      }
      rsaBits = RSA_PUB_KEY_BITSIZE_N(pPubKeys[validKeyId]);
   }

   { // Check every ith set of parameters for badargs
      int i;
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         const IppStatus badargsStatus = SingleVerifyPssRmfPreproc(pMsgs[i], msgLens[i], pSignts[i], &pIsValid[i],
            (const IppsRSAPublicKeyState**)&pPubKeys[i], pMethod, pBuffer);
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
      __ALIGN8 IppsBigNumState decryptedSignatures[RSA_MB_MAX_BUF_QUANTITY];
      IppsBigNumState* signatureAsBnPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
      IppsBigNumState* decryptedSignaturesPtrs[RSA_MB_MAX_BUF_QUANTITY] = { NULL };

      // message presentative size
      const int emBits = rsaBits - 1;
      const int emLen = BITS2WORD8_SIZE(emBits);

      BNU_CHUNK_T* pAlignedBuffer = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR((pBuffer), (int)sizeof(BNU_CHUNK_T)));

      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         // test size consistence
         if (rsaBytesSize <= pMethod->hashLen + 2) {
            statuses[i] = ippStsLengthErr;
            errorEncountered = 1;
            continue;
         }

         signatureAsBnPtrs[i] = &signatureAsBn[i];
         decryptedSignaturesPtrs[i] = &decryptedSignatures[i];

         BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, signatureAsBnPtrs[i]);
         pAlignedBuffer += (rsaChunksSize + 1) * 2;
         BN_Make(pAlignedBuffer, pAlignedBuffer + rsaChunksSize + 1, rsaChunksSize, decryptedSignaturesPtrs[i]);
         pAlignedBuffer += (rsaChunksSize + 1) * 2;

         ippsSetOctString_BN(pSignts[i], rsaBytesSize, signatureAsBnPtrs[i]);
      }

      // will not process NULLed signatureAsBnPtrs
      // the cast is needed because C std does not allow to automatically add `const` at many levels
      ippsRSA_MB_Encrypt((const IppsBigNumState* const *)signatureAsBnPtrs, decryptedSignaturesPtrs,
         pPubKeys, rsaStatuses, (Ipp8u*)pAlignedBuffer);
      for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
         if (ippStsNoErr != statuses[i]) {
            continue; // some checks were failed
         }

         if (ippStsNoErr != rsaStatuses[i]) {
            statuses[i] = rsaStatuses[i];
            errorEncountered = 1;
         }
      }

      {
         const int dbLen = emLen - pMethod->hashLen - 1;

         Ipp8u* generateHashesFrom[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
         Ipp8u* generateHashesTo[RSA_MB_MAX_BUF_QUANTITY] = { NULL };
         int sourceDataLengts[RSA_MB_MAX_BUF_QUANTITY] = { 0 };
         int targetDataLengts[RSA_MB_MAX_BUF_QUANTITY] = { 0 };

         const int VALIDITY_STATUS_UNKNOWN = 2;

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i]) {
               continue; // some checks were failed
            }

            Ipp8u* pEM = (Ipp8u*)BN_BUFFER(decryptedSignaturesPtrs[i]);
            // convert the BN to oct string using its internal buffer as a scratch buffer
            ippsGetOctString_BN(pEM, emLen, decryptedSignaturesPtrs[i]);

            // test last byte and top of (8*emLen-emBits) bits
            if (0xBC != pEM[emLen - 1] || 0x00 != (pEM[0] >> (8 - (8 * emLen - emBits)))) {
               // pIsValid[i] = 0 in preproc
               continue;
            }

            pIsValid[i] = VALIDITY_STATUS_UNKNOWN;
            generateHashesFrom[i] = pEM + dbLen;
            generateHashesTo[i] = (Ipp8u*)BN_NUMBER(decryptedSignaturesPtrs[i]);
            sourceDataLengts[i] = pMethod->hashLen;
            targetDataLengts[i] = dbLen;
         }

         // recover DB = maskedDB ^ MGF(H)
         cpMGF1_MB8_rmf((const Ipp8u* const *)generateHashesFrom, sourceDataLengts, generateHashesTo, targetDataLengts, pMethod);

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i] || pIsValid[i] != VALIDITY_STATUS_UNKNOWN) {
               continue; // some checks were failed
            }

            generateHashesTo[i] = (Ipp8u*)BN_BUFFER(signatureAsBnPtrs[i]);
         }

         cpHashMessage_MB8_rmf(pMsgs, msgLens, generateHashesTo, pMethod);

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i] || pIsValid[i] != VALIDITY_STATUS_UNKNOWN) {
               continue; // some checks were failed
            }

            Ipp8u* pM = (Ipp8u*)BN_NUMBER(decryptedSignaturesPtrs[i]);
            Ipp8u* pEM = (Ipp8u*)BN_BUFFER(decryptedSignaturesPtrs[i]);
            XorBlock(pEM, pM, pEM, dbLen);

            // make sure that top 8*emLen-emBits bits are clear
            pEM[0] &= MAKEMASK32(8 - 8 * emLen + emBits);

            // skip over padding sring (PS)
            int psLen;
            for (psLen = 0; psLen < dbLen; psLen++)
               if (pEM[psLen])
                  break;

            // test non-zero octet
            if (psLen >= dbLen || 0x01 != pEM[psLen]) {
               pIsValid[i] = 0;
               continue;
            }

            int saltLen = dbLen - 1 - psLen;

            /* construct message M'
            // M' = (00 00 00 00 00 00 00 00) || mHash || salt
            // where:
            //    mHash = HASH(pMsg)
            */
            PadBlock(0, pM, 8);
            CopyBlock((Ipp8u*)BN_BUFFER(signatureAsBnPtrs[i]), pM + 8, pMethod->hashLen);
            CopyBlock(pEM + psLen + 1, pM + 8 + pMethod->hashLen, saltLen);

            generateHashesFrom[i] = pM;
            sourceDataLengts[i] = 8 + pMethod->hashLen + saltLen;
            generateHashesTo[i] = pM;
         }

         // H' = HASH(M')
         cpHashMessage_MB8_rmf((const Ipp8u* const *)generateHashesFrom, sourceDataLengts, generateHashesTo, pMethod);

         for (i = 0; i < RSA_MB_MAX_BUF_QUANTITY; ++i) {
            if (ippStsNoErr != statuses[i] || pIsValid[i] != VALIDITY_STATUS_UNKNOWN) {
               continue; // some checks were failed
            }

            // compare H ~ H'
            pIsValid[i] = 1 == EquBlock((Ipp8u*)BN_NUMBER(decryptedSignaturesPtrs[i]),
               (Ipp8u*)(BN_BUFFER(decryptedSignaturesPtrs[i])) + dbLen, pMethod->hashLen);
         }
      }
   }

   return errorEncountered ? ippStsMbWarning : ippStsNoErr;
}
