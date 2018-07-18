/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
*/

#ifndef __OWNCP_H__
#define __OWNCP_H__

#ifndef __OWNDEFS_H__
  #include "owndefs.h"
#endif

#ifndef IPPCP_H__

#define ippcpGetLibVersion           OWNAPI(ippcpGetLibVersion)
#define ippsDESGetSize               OWNAPI(ippsDESGetSize)
#define ippsDESInit                  OWNAPI(ippsDESInit)
#define ippsDESPack                  OWNAPI(ippsDESPack)
#define ippsDESUnpack                OWNAPI(ippsDESUnpack)
#define ippsTDESEncryptECB           OWNAPI(ippsTDESEncryptECB)
#define ippsTDESDecryptECB           OWNAPI(ippsTDESDecryptECB)
#define ippsTDESEncryptCBC           OWNAPI(ippsTDESEncryptCBC)
#define ippsTDESDecryptCBC           OWNAPI(ippsTDESDecryptCBC)
#define ippsTDESEncryptCFB           OWNAPI(ippsTDESEncryptCFB)
#define ippsTDESDecryptCFB           OWNAPI(ippsTDESDecryptCFB)
#define ippsTDESEncryptOFB           OWNAPI(ippsTDESEncryptOFB)
#define ippsTDESDecryptOFB           OWNAPI(ippsTDESDecryptOFB)
#define ippsTDESEncryptCTR           OWNAPI(ippsTDESEncryptCTR)
#define ippsTDESDecryptCTR           OWNAPI(ippsTDESDecryptCTR)
#define ippsAESGetSize               OWNAPI(ippsAESGetSize)
#define ippsAESInit                  OWNAPI(ippsAESInit)
#define ippsAESSetKey                OWNAPI(ippsAESSetKey)
#define ippsAESPack                  OWNAPI(ippsAESPack)
#define ippsAESUnpack                OWNAPI(ippsAESUnpack)
#define ippsAESEncryptECB            OWNAPI(ippsAESEncryptECB)
#define ippsAESDecryptECB            OWNAPI(ippsAESDecryptECB)
#define ippsAESEncryptCBC            OWNAPI(ippsAESEncryptCBC)
#define ippsAESEncryptCBC_CS1        OWNAPI(ippsAESEncryptCBC_CS1)
#define ippsAESEncryptCBC_CS2        OWNAPI(ippsAESEncryptCBC_CS2)
#define ippsAESEncryptCBC_CS3        OWNAPI(ippsAESEncryptCBC_CS3)
#define ippsAESDecryptCBC            OWNAPI(ippsAESDecryptCBC)
#define ippsAESDecryptCBC_CS1        OWNAPI(ippsAESDecryptCBC_CS1)
#define ippsAESDecryptCBC_CS2        OWNAPI(ippsAESDecryptCBC_CS2)
#define ippsAESDecryptCBC_CS3        OWNAPI(ippsAESDecryptCBC_CS3)
#define ippsAESEncryptCFB            OWNAPI(ippsAESEncryptCFB)
#define ippsAESDecryptCFB            OWNAPI(ippsAESDecryptCFB)
#define ippsAESEncryptOFB            OWNAPI(ippsAESEncryptOFB)
#define ippsAESDecryptOFB            OWNAPI(ippsAESDecryptOFB)
#define ippsAESEncryptCTR            OWNAPI(ippsAESEncryptCTR)
#define ippsAESDecryptCTR            OWNAPI(ippsAESDecryptCTR)
#define ippsAESEncryptXTS_Direct     OWNAPI(ippsAESEncryptXTS_Direct)
#define ippsAESDecryptXTS_Direct     OWNAPI(ippsAESDecryptXTS_Direct)
#define ippsSMS4GetSize              OWNAPI(ippsSMS4GetSize)
#define ippsSMS4Init                 OWNAPI(ippsSMS4Init)
#define ippsSMS4SetKey               OWNAPI(ippsSMS4SetKey)
#define ippsSMS4EncryptECB           OWNAPI(ippsSMS4EncryptECB)
#define ippsSMS4DecryptECB           OWNAPI(ippsSMS4DecryptECB)
#define ippsSMS4EncryptCBC           OWNAPI(ippsSMS4EncryptCBC)
#define ippsSMS4EncryptCBC_CS1       OWNAPI(ippsSMS4EncryptCBC_CS1)
#define ippsSMS4EncryptCBC_CS2       OWNAPI(ippsSMS4EncryptCBC_CS2)
#define ippsSMS4EncryptCBC_CS3       OWNAPI(ippsSMS4EncryptCBC_CS3)
#define ippsSMS4DecryptCBC           OWNAPI(ippsSMS4DecryptCBC)
#define ippsSMS4DecryptCBC_CS1       OWNAPI(ippsSMS4DecryptCBC_CS1)
#define ippsSMS4DecryptCBC_CS2       OWNAPI(ippsSMS4DecryptCBC_CS2)
#define ippsSMS4DecryptCBC_CS3       OWNAPI(ippsSMS4DecryptCBC_CS3)
#define ippsSMS4EncryptCFB           OWNAPI(ippsSMS4EncryptCFB)
#define ippsSMS4DecryptCFB           OWNAPI(ippsSMS4DecryptCFB)
#define ippsSMS4EncryptOFB           OWNAPI(ippsSMS4EncryptOFB)
#define ippsSMS4DecryptOFB           OWNAPI(ippsSMS4DecryptOFB)
#define ippsSMS4EncryptCTR           OWNAPI(ippsSMS4EncryptCTR)
#define ippsSMS4DecryptCTR           OWNAPI(ippsSMS4DecryptCTR)
#define ippsSMS4_CCMGetSize          OWNAPI(ippsSMS4_CCMGetSize)
#define ippsSMS4_CCMInit             OWNAPI(ippsSMS4_CCMInit)
#define ippsSMS4_CCMMessageLen       OWNAPI(ippsSMS4_CCMMessageLen)
#define ippsSMS4_CCMTagLen           OWNAPI(ippsSMS4_CCMTagLen)
#define ippsSMS4_CCMStart            OWNAPI(ippsSMS4_CCMStart)
#define ippsSMS4_CCMEncrypt          OWNAPI(ippsSMS4_CCMEncrypt)
#define ippsSMS4_CCMDecrypt          OWNAPI(ippsSMS4_CCMDecrypt)
#define ippsSMS4_CCMGetTag           OWNAPI(ippsSMS4_CCMGetTag)
#define ippsAES_CCMGetSize           OWNAPI(ippsAES_CCMGetSize)
#define ippsAES_CCMInit              OWNAPI(ippsAES_CCMInit)
#define ippsAES_CCMMessageLen        OWNAPI(ippsAES_CCMMessageLen)
#define ippsAES_CCMTagLen            OWNAPI(ippsAES_CCMTagLen)
#define ippsAES_CCMStart             OWNAPI(ippsAES_CCMStart)
#define ippsAES_CCMEncrypt           OWNAPI(ippsAES_CCMEncrypt)
#define ippsAES_CCMDecrypt           OWNAPI(ippsAES_CCMDecrypt)
#define ippsAES_CCMGetTag            OWNAPI(ippsAES_CCMGetTag)
#define ippsAES_GCMGetSize           OWNAPI(ippsAES_GCMGetSize)
#define ippsAES_GCMInit              OWNAPI(ippsAES_GCMInit)
#define ippsAES_GCMReset             OWNAPI(ippsAES_GCMReset)
#define ippsAES_GCMProcessIV         OWNAPI(ippsAES_GCMProcessIV)
#define ippsAES_GCMProcessAAD        OWNAPI(ippsAES_GCMProcessAAD)
#define ippsAES_GCMStart             OWNAPI(ippsAES_GCMStart)
#define ippsAES_GCMEncrypt           OWNAPI(ippsAES_GCMEncrypt)
#define ippsAES_GCMDecrypt           OWNAPI(ippsAES_GCMDecrypt)
#define ippsAES_GCMGetTag            OWNAPI(ippsAES_GCMGetTag)
#define ippsAES_XTSGetSize           OWNAPI(ippsAES_XTSGetSize)
#define ippsAES_XTSInit              OWNAPI(ippsAES_XTSInit)
#define ippsAES_XTSEncrypt           OWNAPI(ippsAES_XTSEncrypt)
#define ippsAES_XTSDecrypt           OWNAPI(ippsAES_XTSDecrypt)
#define ippsAES_S2V_CMAC             OWNAPI(ippsAES_S2V_CMAC)
#define ippsAES_SIVEncrypt           OWNAPI(ippsAES_SIVEncrypt)
#define ippsAES_SIVDecrypt           OWNAPI(ippsAES_SIVDecrypt)
#define ippsAES_CMACGetSize          OWNAPI(ippsAES_CMACGetSize)
#define ippsAES_CMACInit             OWNAPI(ippsAES_CMACInit)
#define ippsAES_CMACUpdate           OWNAPI(ippsAES_CMACUpdate)
#define ippsAES_CMACFinal            OWNAPI(ippsAES_CMACFinal)
#define ippsAES_CMACGetTag           OWNAPI(ippsAES_CMACGetTag)
#define ippsARCFourCheckKey          OWNAPI(ippsARCFourCheckKey)
#define ippsARCFourGetSize           OWNAPI(ippsARCFourGetSize)
#define ippsARCFourInit              OWNAPI(ippsARCFourInit)
#define ippsARCFourReset             OWNAPI(ippsARCFourReset)
#define ippsARCFourPack              OWNAPI(ippsARCFourPack)
#define ippsARCFourUnpack            OWNAPI(ippsARCFourUnpack)
#define ippsARCFourEncrypt           OWNAPI(ippsARCFourEncrypt)
#define ippsARCFourDecrypt           OWNAPI(ippsARCFourDecrypt)
#define ippsSHA1GetSize              OWNAPI(ippsSHA1GetSize)
#define ippsSHA1Init                 OWNAPI(ippsSHA1Init)
#define ippsSHA1Duplicate            OWNAPI(ippsSHA1Duplicate)
#define ippsSHA1Pack                 OWNAPI(ippsSHA1Pack)
#define ippsSHA1Unpack               OWNAPI(ippsSHA1Unpack)
#define ippsSHA1Update               OWNAPI(ippsSHA1Update)
#define ippsSHA1GetTag               OWNAPI(ippsSHA1GetTag)
#define ippsSHA1Final                OWNAPI(ippsSHA1Final)
#define ippsSHA1MessageDigest        OWNAPI(ippsSHA1MessageDigest)
#define ippsSHA224GetSize            OWNAPI(ippsSHA224GetSize)
#define ippsSHA224Init               OWNAPI(ippsSHA224Init)
#define ippsSHA224Duplicate          OWNAPI(ippsSHA224Duplicate)
#define ippsSHA224Pack               OWNAPI(ippsSHA224Pack)
#define ippsSHA224Unpack             OWNAPI(ippsSHA224Unpack)
#define ippsSHA224Update             OWNAPI(ippsSHA224Update)
#define ippsSHA224GetTag             OWNAPI(ippsSHA224GetTag)
#define ippsSHA224Final              OWNAPI(ippsSHA224Final)
#define ippsSHA224MessageDigest      OWNAPI(ippsSHA224MessageDigest)
#define ippsSHA256GetSize            OWNAPI(ippsSHA256GetSize)
#define ippsSHA256Init               OWNAPI(ippsSHA256Init)
#define ippsSHA256Duplicate          OWNAPI(ippsSHA256Duplicate)
#define ippsSHA256Pack               OWNAPI(ippsSHA256Pack)
#define ippsSHA256Unpack             OWNAPI(ippsSHA256Unpack)
#define ippsSHA256Update             OWNAPI(ippsSHA256Update)
#define ippsSHA256GetTag             OWNAPI(ippsSHA256GetTag)
#define ippsSHA256Final              OWNAPI(ippsSHA256Final)
#define ippsSHA256MessageDigest      OWNAPI(ippsSHA256MessageDigest)
#define ippsSHA384GetSize            OWNAPI(ippsSHA384GetSize)
#define ippsSHA384Init               OWNAPI(ippsSHA384Init)
#define ippsSHA384Duplicate          OWNAPI(ippsSHA384Duplicate)
#define ippsSHA384Pack               OWNAPI(ippsSHA384Pack)
#define ippsSHA384Unpack             OWNAPI(ippsSHA384Unpack)
#define ippsSHA384Update             OWNAPI(ippsSHA384Update)
#define ippsSHA384GetTag             OWNAPI(ippsSHA384GetTag)
#define ippsSHA384Final              OWNAPI(ippsSHA384Final)
#define ippsSHA384MessageDigest      OWNAPI(ippsSHA384MessageDigest)
#define ippsSHA512GetSize            OWNAPI(ippsSHA512GetSize)
#define ippsSHA512Init               OWNAPI(ippsSHA512Init)
#define ippsSHA512Duplicate          OWNAPI(ippsSHA512Duplicate)
#define ippsSHA512Pack               OWNAPI(ippsSHA512Pack)
#define ippsSHA512Unpack             OWNAPI(ippsSHA512Unpack)
#define ippsSHA512Update             OWNAPI(ippsSHA512Update)
#define ippsSHA512GetTag             OWNAPI(ippsSHA512GetTag)
#define ippsSHA512Final              OWNAPI(ippsSHA512Final)
#define ippsSHA512MessageDigest      OWNAPI(ippsSHA512MessageDigest)
#define ippsMD5GetSize               OWNAPI(ippsMD5GetSize)
#define ippsMD5Init                  OWNAPI(ippsMD5Init)
#define ippsMD5Duplicate             OWNAPI(ippsMD5Duplicate)
#define ippsMD5Pack                  OWNAPI(ippsMD5Pack)
#define ippsMD5Unpack                OWNAPI(ippsMD5Unpack)
#define ippsMD5Update                OWNAPI(ippsMD5Update)
#define ippsMD5GetTag                OWNAPI(ippsMD5GetTag)
#define ippsMD5Final                 OWNAPI(ippsMD5Final)
#define ippsMD5MessageDigest         OWNAPI(ippsMD5MessageDigest)
#define ippsSM3GetSize               OWNAPI(ippsSM3GetSize)
#define ippsSM3Init                  OWNAPI(ippsSM3Init)
#define ippsSM3Duplicate             OWNAPI(ippsSM3Duplicate)
#define ippsSM3Pack                  OWNAPI(ippsSM3Pack)
#define ippsSM3Unpack                OWNAPI(ippsSM3Unpack)
#define ippsSM3Update                OWNAPI(ippsSM3Update)
#define ippsSM3GetTag                OWNAPI(ippsSM3GetTag)
#define ippsSM3Final                 OWNAPI(ippsSM3Final)
#define ippsSM3MessageDigest         OWNAPI(ippsSM3MessageDigest)
#define ippsHashGetSize              OWNAPI(ippsHashGetSize)
#define ippsHashInit                 OWNAPI(ippsHashInit)
#define ippsHashPack                 OWNAPI(ippsHashPack)
#define ippsHashUnpack               OWNAPI(ippsHashUnpack)
#define ippsHashDuplicate            OWNAPI(ippsHashDuplicate)
#define ippsHashUpdate               OWNAPI(ippsHashUpdate)
#define ippsHashGetTag               OWNAPI(ippsHashGetTag)
#define ippsHashFinal                OWNAPI(ippsHashFinal)
#define ippsHashMessage              OWNAPI(ippsHashMessage)
#define ippsHashMethod_MD5           OWNAPI(ippsHashMethod_MD5)
#define ippsHashMethod_SM3           OWNAPI(ippsHashMethod_SM3)
#define ippsHashMethod_SHA1          OWNAPI(ippsHashMethod_SHA1)
#define ippsHashMethod_SHA1_NI       OWNAPI(ippsHashMethod_SHA1_NI)
#define ippsHashMethod_SHA1_TT       OWNAPI(ippsHashMethod_SHA1_TT)
#define ippsHashMethod_SHA256        OWNAPI(ippsHashMethod_SHA256)
#define ippsHashMethod_SHA256_NI     OWNAPI(ippsHashMethod_SHA256_NI)
#define ippsHashMethod_SHA256_TT     OWNAPI(ippsHashMethod_SHA256_TT)
#define ippsHashMethod_SHA224        OWNAPI(ippsHashMethod_SHA224)
#define ippsHashMethod_SHA224_NI     OWNAPI(ippsHashMethod_SHA224_NI)
#define ippsHashMethod_SHA224_TT     OWNAPI(ippsHashMethod_SHA224_TT)
#define ippsHashMethod_SHA512        OWNAPI(ippsHashMethod_SHA512)
#define ippsHashMethod_SHA384        OWNAPI(ippsHashMethod_SHA384)
#define ippsHashMethod_SHA512_256    OWNAPI(ippsHashMethod_SHA512_256)
#define ippsHashMethod_SHA512_224    OWNAPI(ippsHashMethod_SHA512_224)
#define ippsHashGetSize_rmf          OWNAPI(ippsHashGetSize_rmf)
#define ippsHashInit_rmf             OWNAPI(ippsHashInit_rmf)
#define ippsHashPack_rmf             OWNAPI(ippsHashPack_rmf)
#define ippsHashUnpack_rmf           OWNAPI(ippsHashUnpack_rmf)
#define ippsHashDuplicate_rmf        OWNAPI(ippsHashDuplicate_rmf)
#define ippsHashUpdate_rmf           OWNAPI(ippsHashUpdate_rmf)
#define ippsHashGetTag_rmf           OWNAPI(ippsHashGetTag_rmf)
#define ippsHashFinal_rmf            OWNAPI(ippsHashFinal_rmf)
#define ippsHashMessage_rmf          OWNAPI(ippsHashMessage_rmf)
#define ippsMGF                      OWNAPI(ippsMGF)
#define ippsMGF1_rmf                 OWNAPI(ippsMGF1_rmf)
#define ippsMGF2_rmf                 OWNAPI(ippsMGF2_rmf)
#define ippsHMAC_GetSize             OWNAPI(ippsHMAC_GetSize)
#define ippsHMAC_Init                OWNAPI(ippsHMAC_Init)
#define ippsHMAC_Pack                OWNAPI(ippsHMAC_Pack)
#define ippsHMAC_Unpack              OWNAPI(ippsHMAC_Unpack)
#define ippsHMAC_Duplicate           OWNAPI(ippsHMAC_Duplicate)
#define ippsHMAC_Update              OWNAPI(ippsHMAC_Update)
#define ippsHMAC_Final               OWNAPI(ippsHMAC_Final)
#define ippsHMAC_GetTag              OWNAPI(ippsHMAC_GetTag)
#define ippsHMAC_Message             OWNAPI(ippsHMAC_Message)
#define ippsHMACGetSize_rmf          OWNAPI(ippsHMACGetSize_rmf)
#define ippsHMACInit_rmf             OWNAPI(ippsHMACInit_rmf)
#define ippsHMACPack_rmf             OWNAPI(ippsHMACPack_rmf)
#define ippsHMACUnpack_rmf           OWNAPI(ippsHMACUnpack_rmf)
#define ippsHMACDuplicate_rmf        OWNAPI(ippsHMACDuplicate_rmf)
#define ippsHMACUpdate_rmf           OWNAPI(ippsHMACUpdate_rmf)
#define ippsHMACFinal_rmf            OWNAPI(ippsHMACFinal_rmf)
#define ippsHMACGetTag_rmf           OWNAPI(ippsHMACGetTag_rmf)
#define ippsHMACMessage_rmf          OWNAPI(ippsHMACMessage_rmf)
#define ippsBigNumGetSize            OWNAPI(ippsBigNumGetSize)
#define ippsBigNumInit               OWNAPI(ippsBigNumInit)
#define ippsCmpZero_BN               OWNAPI(ippsCmpZero_BN)
#define ippsCmp_BN                   OWNAPI(ippsCmp_BN)
#define ippsGetSize_BN               OWNAPI(ippsGetSize_BN)
#define ippsSet_BN                   OWNAPI(ippsSet_BN)
#define ippsGet_BN                   OWNAPI(ippsGet_BN)
#define ippsRef_BN                   OWNAPI(ippsRef_BN)
#define ippsExtGet_BN                OWNAPI(ippsExtGet_BN)
#define ippsAdd_BN                   OWNAPI(ippsAdd_BN)
#define ippsSub_BN                   OWNAPI(ippsSub_BN)
#define ippsMul_BN                   OWNAPI(ippsMul_BN)
#define ippsMAC_BN_I                 OWNAPI(ippsMAC_BN_I)
#define ippsDiv_BN                   OWNAPI(ippsDiv_BN)
#define ippsMod_BN                   OWNAPI(ippsMod_BN)
#define ippsGcd_BN                   OWNAPI(ippsGcd_BN)
#define ippsModInv_BN                OWNAPI(ippsModInv_BN)
#define ippsSetOctString_BN          OWNAPI(ippsSetOctString_BN)
#define ippsGetOctString_BN          OWNAPI(ippsGetOctString_BN)
#define ippsMontGetSize              OWNAPI(ippsMontGetSize)
#define ippsMontInit                 OWNAPI(ippsMontInit)
#define ippsMontSet                  OWNAPI(ippsMontSet)
#define ippsMontGet                  OWNAPI(ippsMontGet)
#define ippsMontForm                 OWNAPI(ippsMontForm)
#define ippsMontMul                  OWNAPI(ippsMontMul)
#define ippsMontExp                  OWNAPI(ippsMontExp)
#define ippsPRNGGetSize              OWNAPI(ippsPRNGGetSize)
#define ippsPRNGInit                 OWNAPI(ippsPRNGInit)
#define ippsPRNGSetModulus           OWNAPI(ippsPRNGSetModulus)
#define ippsPRNGSetH0                OWNAPI(ippsPRNGSetH0)
#define ippsPRNGSetAugment           OWNAPI(ippsPRNGSetAugment)
#define ippsPRNGSetSeed              OWNAPI(ippsPRNGSetSeed)
#define ippsPRNGGetSeed              OWNAPI(ippsPRNGGetSeed)
#define ippsPRNGen                   OWNAPI(ippsPRNGen)
#define ippsPRNGen_BN                OWNAPI(ippsPRNGen_BN)
#define ippsPRNGenRDRAND             OWNAPI(ippsPRNGenRDRAND)
#define ippsPRNGenRDRAND_BN          OWNAPI(ippsPRNGenRDRAND_BN)
#define ippsTRNGenRDSEED             OWNAPI(ippsTRNGenRDSEED)
#define ippsTRNGenRDSEED_BN          OWNAPI(ippsTRNGenRDSEED_BN)
#define ippsPrimeGetSize             OWNAPI(ippsPrimeGetSize)
#define ippsPrimeInit                OWNAPI(ippsPrimeInit)
#define ippsPrimeGen                 OWNAPI(ippsPrimeGen)
#define ippsPrimeTest                OWNAPI(ippsPrimeTest)
#define ippsPrimeGen_BN              OWNAPI(ippsPrimeGen_BN)
#define ippsPrimeTest_BN             OWNAPI(ippsPrimeTest_BN)
#define ippsPrimeGet                 OWNAPI(ippsPrimeGet)
#define ippsPrimeGet_BN              OWNAPI(ippsPrimeGet_BN)
#define ippsPrimeSet                 OWNAPI(ippsPrimeSet)
#define ippsPrimeSet_BN              OWNAPI(ippsPrimeSet_BN)
#define ippsRSA_GetSizePublicKey     OWNAPI(ippsRSA_GetSizePublicKey)
#define ippsRSA_InitPublicKey        OWNAPI(ippsRSA_InitPublicKey)
#define ippsRSA_SetPublicKey         OWNAPI(ippsRSA_SetPublicKey)
#define ippsRSA_GetPublicKey         OWNAPI(ippsRSA_GetPublicKey)
#define ippsRSA_GetSizePrivateKeyType1   OWNAPI(ippsRSA_GetSizePrivateKeyType1)
#define ippsRSA_InitPrivateKeyType1      OWNAPI(ippsRSA_InitPrivateKeyType1)
#define ippsRSA_SetPrivateKeyType1       OWNAPI(ippsRSA_SetPrivateKeyType1)
#define ippsRSA_GetPrivateKeyType1       OWNAPI(ippsRSA_GetPrivateKeyType1)
#define ippsRSA_GetSizePrivateKeyType2   OWNAPI(ippsRSA_GetSizePrivateKeyType2)
#define ippsRSA_InitPrivateKeyType2      OWNAPI(ippsRSA_InitPrivateKeyType2)
#define ippsRSA_SetPrivateKeyType2       OWNAPI(ippsRSA_SetPrivateKeyType2)
#define ippsRSA_GetPrivateKeyType2       OWNAPI(ippsRSA_GetPrivateKeyType2)
#define ippsRSA_GetBufferSizePublicKey   OWNAPI(ippsRSA_GetBufferSizePublicKey)
#define ippsRSA_GetBufferSizePrivateKey  OWNAPI(ippsRSA_GetBufferSizePrivateKey)
#define ippsRSA_Encrypt              OWNAPI(ippsRSA_Encrypt)
#define ippsRSA_Decrypt              OWNAPI(ippsRSA_Decrypt)
#define ippsRSA_GenerateKeys         OWNAPI(ippsRSA_GenerateKeys)
#define ippsRSA_ValidateKeys         OWNAPI(ippsRSA_ValidateKeys)
#define ippsRSAEncrypt_OAEP          OWNAPI(ippsRSAEncrypt_OAEP)
#define ippsRSADecrypt_OAEP          OWNAPI(ippsRSADecrypt_OAEP)
#define ippsRSAEncrypt_OAEP_rmf      OWNAPI(ippsRSAEncrypt_OAEP_rmf)
#define ippsRSADecrypt_OAEP_rmf      OWNAPI(ippsRSADecrypt_OAEP_rmf)
#define ippsRSAEncrypt_PKCSv15       OWNAPI(ippsRSAEncrypt_PKCSv15)
#define ippsRSADecrypt_PKCSv15       OWNAPI(ippsRSADecrypt_PKCSv15)
#define ippsRSASign_PSS              OWNAPI(ippsRSASign_PSS)
#define ippsRSAVerify_PSS            OWNAPI(ippsRSAVerify_PSS)
#define ippsRSASign_PSS_rmf          OWNAPI(ippsRSASign_PSS_rmf)
#define ippsRSAVerify_PSS_rmf        OWNAPI(ippsRSAVerify_PSS_rmf)
#define ippsRSASign_PKCS1v15         OWNAPI(ippsRSASign_PKCS1v15)
#define ippsRSAVerify_PKCS1v15       OWNAPI(ippsRSAVerify_PKCS1v15)
#define ippsRSASign_PKCS1v15_rmf     OWNAPI(ippsRSASign_PKCS1v15_rmf)
#define ippsRSAVerify_PKCS1v15_rmf   OWNAPI(ippsRSAVerify_PKCS1v15_rmf)
#define ippsDLGetResultString        OWNAPI(ippsDLGetResultString)
#define ippsDLPGetSize               OWNAPI(ippsDLPGetSize)
#define ippsDLPInit                  OWNAPI(ippsDLPInit)
#define ippsDLPPack                  OWNAPI(ippsDLPPack)
#define ippsDLPUnpack                OWNAPI(ippsDLPUnpack)
#define ippsDLPSet                   OWNAPI(ippsDLPSet)
#define ippsDLPGet                   OWNAPI(ippsDLPGet)
#define ippsDLPSetDP                 OWNAPI(ippsDLPSetDP)
#define ippsDLPGetDP                 OWNAPI(ippsDLPGetDP)
#define ippsDLPGenKeyPair            OWNAPI(ippsDLPGenKeyPair)
#define ippsDLPPublicKey             OWNAPI(ippsDLPPublicKey)
#define ippsDLPValidateKeyPair       OWNAPI(ippsDLPValidateKeyPair)
#define ippsDLPSetKeyPair            OWNAPI(ippsDLPSetKeyPair)
#define ippsDLPSignDSA               OWNAPI(ippsDLPSignDSA)
#define ippsDLPVerifyDSA             OWNAPI(ippsDLPVerifyDSA)
#define ippsDLPSharedSecretDH        OWNAPI(ippsDLPSharedSecretDH)
#define ippsDLPGenerateDSA           OWNAPI(ippsDLPGenerateDSA)
#define ippsDLPValidateDSA           OWNAPI(ippsDLPValidateDSA)
#define ippsDLPGenerateDH            OWNAPI(ippsDLPGenerateDH)
#define ippsDLPValidateDH            OWNAPI(ippsDLPValidateDH)
#define ippsECCGetResultString       OWNAPI(ippsECCGetResultString)
#define ippsECCPGetSize              OWNAPI(ippsECCPGetSize)
#define ippsECCPGetSizeStd128r1      OWNAPI(ippsECCPGetSizeStd128r1)
#define ippsECCPGetSizeStd128r2      OWNAPI(ippsECCPGetSizeStd128r2)
#define ippsECCPGetSizeStd192r1      OWNAPI(ippsECCPGetSizeStd192r1)
#define ippsECCPGetSizeStd224r1      OWNAPI(ippsECCPGetSizeStd224r1)
#define ippsECCPGetSizeStd256r1      OWNAPI(ippsECCPGetSizeStd256r1)
#define ippsECCPGetSizeStd384r1      OWNAPI(ippsECCPGetSizeStd384r1)
#define ippsECCPGetSizeStd521r1      OWNAPI(ippsECCPGetSizeStd521r1)
#define ippsECCPGetSizeStdSM2        OWNAPI(ippsECCPGetSizeStdSM2)
#define ippsECCPInit                 OWNAPI(ippsECCPInit)
#define ippsECCPInitStd128r1         OWNAPI(ippsECCPInitStd128r1)
#define ippsECCPInitStd128r2         OWNAPI(ippsECCPInitStd128r2)
#define ippsECCPInitStd192r1         OWNAPI(ippsECCPInitStd192r1)
#define ippsECCPInitStd224r1         OWNAPI(ippsECCPInitStd224r1)
#define ippsECCPInitStd256r1         OWNAPI(ippsECCPInitStd256r1)
#define ippsECCPInitStd384r1         OWNAPI(ippsECCPInitStd384r1)
#define ippsECCPInitStd521r1         OWNAPI(ippsECCPInitStd521r1)
#define ippsECCPInitStdSM2           OWNAPI(ippsECCPInitStdSM2)
#define ippsECCPSet                  OWNAPI(ippsECCPSet)
#define ippsECCPSetStd               OWNAPI(ippsECCPSetStd)
#define ippsECCPSetStd128r1          OWNAPI(ippsECCPSetStd128r1)
#define ippsECCPSetStd128r2          OWNAPI(ippsECCPSetStd128r2)
#define ippsECCPSetStd192r1          OWNAPI(ippsECCPSetStd192r1)
#define ippsECCPSetStd224r1          OWNAPI(ippsECCPSetStd224r1)
#define ippsECCPSetStd256r1          OWNAPI(ippsECCPSetStd256r1)
#define ippsECCPSetStd384r1          OWNAPI(ippsECCPSetStd384r1)
#define ippsECCPSetStd521r1          OWNAPI(ippsECCPSetStd521r1)
#define ippsECCPSetStdSM2            OWNAPI(ippsECCPSetStdSM2)
#define ippsECCPBindGxyTblStd192r1   OWNAPI(ippsECCPBindGxyTblStd192r1)
#define ippsECCPBindGxyTblStd224r1   OWNAPI(ippsECCPBindGxyTblStd224r1)
#define ippsECCPBindGxyTblStd256r1   OWNAPI(ippsECCPBindGxyTblStd256r1)
#define ippsECCPBindGxyTblStd384r1   OWNAPI(ippsECCPBindGxyTblStd384r1)
#define ippsECCPBindGxyTblStd521r1   OWNAPI(ippsECCPBindGxyTblStd521r1)
#define ippsECCPBindGxyTblStdSM2     OWNAPI(ippsECCPBindGxyTblStdSM2)
#define ippsECCPGet                  OWNAPI(ippsECCPGet)
#define ippsECCPGetOrderBitSize      OWNAPI(ippsECCPGetOrderBitSize)
#define ippsECCPValidate             OWNAPI(ippsECCPValidate)
#define ippsECCPPointGetSize         OWNAPI(ippsECCPPointGetSize)
#define ippsECCPPointInit            OWNAPI(ippsECCPPointInit)
#define ippsECCPSetPoint             OWNAPI(ippsECCPSetPoint)
#define ippsECCPSetPointAtInfinity   OWNAPI(ippsECCPSetPointAtInfinity)
#define ippsECCPGetPoint             OWNAPI(ippsECCPGetPoint)
#define ippsECCPCheckPoint           OWNAPI(ippsECCPCheckPoint)
#define ippsECCPComparePoint         OWNAPI(ippsECCPComparePoint)
#define ippsECCPNegativePoint        OWNAPI(ippsECCPNegativePoint)
#define ippsECCPAddPoint             OWNAPI(ippsECCPAddPoint)
#define ippsECCPMulPointScalar       OWNAPI(ippsECCPMulPointScalar)
#define ippsECCPGenKeyPair           OWNAPI(ippsECCPGenKeyPair)
#define ippsECCPPublicKey            OWNAPI(ippsECCPPublicKey)
#define ippsECCPValidateKeyPair      OWNAPI(ippsECCPValidateKeyPair)
#define ippsECCPSetKeyPair           OWNAPI(ippsECCPSetKeyPair)
#define ippsECCPSharedSecretDH       OWNAPI(ippsECCPSharedSecretDH)
#define ippsECCPSharedSecretDHC      OWNAPI(ippsECCPSharedSecretDHC)
#define ippsECCPSignDSA              OWNAPI(ippsECCPSignDSA)
#define ippsECCPVerifyDSA            OWNAPI(ippsECCPVerifyDSA)
#define ippsECCPSignNR               OWNAPI(ippsECCPSignNR)
#define ippsECCPVerifyNR             OWNAPI(ippsECCPVerifyNR)
#define ippsECCPSignSM2              OWNAPI(ippsECCPSignSM2)
#define ippsECCPVerifySM2            OWNAPI(ippsECCPVerifySM2)
#define ippsGFpGetSize               OWNAPI(ippsGFpGetSize)
#define ippsGFpInitArbitrary         OWNAPI(ippsGFpInitArbitrary)
#define ippsGFpInitFixed             OWNAPI(ippsGFpInitFixed)
#define ippsGFpInit                  OWNAPI(ippsGFpInit)
#define ippsGFpMethod_p192r1         OWNAPI(ippsGFpMethod_p192r1)
#define ippsGFpMethod_p224r1         OWNAPI(ippsGFpMethod_p224r1)
#define ippsGFpMethod_p256r1         OWNAPI(ippsGFpMethod_p256r1)
#define ippsGFpMethod_p384r1         OWNAPI(ippsGFpMethod_p384r1)
#define ippsGFpMethod_p521r1         OWNAPI(ippsGFpMethod_p521r1)
#define ippsGFpMethod_p256sm2        OWNAPI(ippsGFpMethod_p256sm2)
#define ippsGFpMethod_p256bn         OWNAPI(ippsGFpMethod_p256bn)
#define ippsGFpMethod_p256           OWNAPI(ippsGFpMethod_p256)
#define ippsGFpMethod_pArb           OWNAPI(ippsGFpMethod_pArb)
#define ippsGFpxGetSize              OWNAPI(ippsGFpxGetSize)
#define ippsGFpxInit                 OWNAPI(ippsGFpxInit)
#define ippsGFpxInitBinomial         OWNAPI(ippsGFpxInitBinomial)
#define ippsGFpxMethod_binom2_epid2  OWNAPI(ippsGFpxMethod_binom2_epid2)
#define ippsGFpxMethod_binom3_epid2  OWNAPI(ippsGFpxMethod_binom3_epid2)
#define ippsGFpxMethod_binom2        OWNAPI(ippsGFpxMethod_binom2)
#define ippsGFpxMethod_binom3        OWNAPI(ippsGFpxMethod_binom3)
#define ippsGFpxMethod_binom         OWNAPI(ippsGFpxMethod_binom)
#define ippsGFpxMethod_com           OWNAPI(ippsGFpxMethod_com)
#define ippsGFpScratchBufferSize     OWNAPI(ippsGFpScratchBufferSize)
#define ippsGFpElementGetSize        OWNAPI(ippsGFpElementGetSize)
#define ippsGFpElementInit           OWNAPI(ippsGFpElementInit)
#define ippsGFpSetElement            OWNAPI(ippsGFpSetElement)
#define ippsGFpSetElementRegular     OWNAPI(ippsGFpSetElementRegular)
#define ippsGFpSetElementOctString   OWNAPI(ippsGFpSetElementOctString)
#define ippsGFpSetElementRandom      OWNAPI(ippsGFpSetElementRandom)
#define ippsGFpSetElementHash        OWNAPI(ippsGFpSetElementHash)
#define ippsGFpSetElementHash_rmf    OWNAPI(ippsGFpSetElementHash_rmf)
#define ippsGFpCpyElement            OWNAPI(ippsGFpCpyElement)
#define ippsGFpGetElement            OWNAPI(ippsGFpGetElement)
#define ippsGFpGetElementOctString   OWNAPI(ippsGFpGetElementOctString)
#define ippsGFpCmpElement            OWNAPI(ippsGFpCmpElement)
#define ippsGFpIsZeroElement         OWNAPI(ippsGFpIsZeroElement)
#define ippsGFpIsUnityElement        OWNAPI(ippsGFpIsUnityElement)
#define ippsGFpConj                  OWNAPI(ippsGFpConj)
#define ippsGFpNeg                   OWNAPI(ippsGFpNeg)
#define ippsGFpInv                   OWNAPI(ippsGFpInv)
#define ippsGFpSqrt                  OWNAPI(ippsGFpSqrt)
#define ippsGFpSqr                   OWNAPI(ippsGFpSqr)
#define ippsGFpAdd                   OWNAPI(ippsGFpAdd)
#define ippsGFpSub                   OWNAPI(ippsGFpSub)
#define ippsGFpMul                   OWNAPI(ippsGFpMul)
#define ippsGFpExp                   OWNAPI(ippsGFpExp)
#define ippsGFpMultiExp              OWNAPI(ippsGFpMultiExp)
#define ippsGFpAdd_PE                OWNAPI(ippsGFpAdd_PE)
#define ippsGFpSub_PE                OWNAPI(ippsGFpSub_PE)
#define ippsGFpMul_PE                OWNAPI(ippsGFpMul_PE)
#define ippsGFpECGetSize             OWNAPI(ippsGFpECGetSize)
#define ippsGFpECInit                OWNAPI(ippsGFpECInit)
#define ippsGFpECSet                 OWNAPI(ippsGFpECSet)
#define ippsGFpECSetSubgroup         OWNAPI(ippsGFpECSetSubgroup)
#define ippsGFpECInitStd128r1        OWNAPI(ippsGFpECInitStd128r1)
#define ippsGFpECInitStd128r2        OWNAPI(ippsGFpECInitStd128r2)
#define ippsGFpECInitStd192r1        OWNAPI(ippsGFpECInitStd192r1)
#define ippsGFpECInitStd224r1        OWNAPI(ippsGFpECInitStd224r1)
#define ippsGFpECInitStd256r1        OWNAPI(ippsGFpECInitStd256r1)
#define ippsGFpECInitStd384r1        OWNAPI(ippsGFpECInitStd384r1)
#define ippsGFpECInitStd521r1        OWNAPI(ippsGFpECInitStd521r1)
#define ippsGFpECInitStdSM2          OWNAPI(ippsGFpECInitStdSM2)
#define ippsGFpECInitStdBN256        OWNAPI(ippsGFpECInitStdBN256)
#define ippsGFpECBindGxyTblStd192r1  OWNAPI(ippsGFpECBindGxyTblStd192r1)
#define ippsGFpECBindGxyTblStd224r1  OWNAPI(ippsGFpECBindGxyTblStd224r1)
#define ippsGFpECBindGxyTblStd256r1  OWNAPI(ippsGFpECBindGxyTblStd256r1)
#define ippsGFpECBindGxyTblStd384r1  OWNAPI(ippsGFpECBindGxyTblStd384r1)
#define ippsGFpECBindGxyTblStd521r1  OWNAPI(ippsGFpECBindGxyTblStd521r1)
#define ippsGFpECBindGxyTblStdSM2    OWNAPI(ippsGFpECBindGxyTblStdSM2)
#define ippsGFpECGet                 OWNAPI(ippsGFpECGet)
#define ippsGFpECGetSubgroup         OWNAPI(ippsGFpECGetSubgroup)
#define ippsGFpECScratchBufferSize   OWNAPI(ippsGFpECScratchBufferSize)
#define ippsGFpECVerify              OWNAPI(ippsGFpECVerify)
#define ippsGFpECPointGetSize        OWNAPI(ippsGFpECPointGetSize)
#define ippsGFpECPointInit           OWNAPI(ippsGFpECPointInit)
#define ippsGFpECSetPointAtInfinity  OWNAPI(ippsGFpECSetPointAtInfinity)
#define ippsGFpECSetPoint            OWNAPI(ippsGFpECSetPoint)
#define ippsGFpECSetPointRegular     OWNAPI(ippsGFpECSetPointRegular)
#define ippsGFpECSetPointRandom      OWNAPI(ippsGFpECSetPointRandom)
#define ippsGFpECMakePoint           OWNAPI(ippsGFpECMakePoint)
#define ippsGFpECSetPointHash        OWNAPI(ippsGFpECSetPointHash)
#define ippsGFpECSetPointHash_rmf    OWNAPI(ippsGFpECSetPointHash_rmf)
#define ippsGFpECGetPoint            OWNAPI(ippsGFpECGetPoint)
#define ippsGFpECGetPointRegular     OWNAPI(ippsGFpECGetPointRegular)
#define ippsGFpECTstPoint            OWNAPI(ippsGFpECTstPoint)
#define ippsGFpECTstPointInSubgroup  OWNAPI(ippsGFpECTstPointInSubgroup)
#define ippsGFpECCpyPoint            OWNAPI(ippsGFpECCpyPoint)
#define ippsGFpECCmpPoint            OWNAPI(ippsGFpECCmpPoint)
#define ippsGFpECNegPoint            OWNAPI(ippsGFpECNegPoint)
#define ippsGFpECAddPoint            OWNAPI(ippsGFpECAddPoint)
#define ippsGFpECMulPoint            OWNAPI(ippsGFpECMulPoint)
#define ippsGFpECPrivateKey          OWNAPI(ippsGFpECPrivateKey)
#define ippsGFpECPublicKey           OWNAPI(ippsGFpECPublicKey)
#define ippsGFpECTstKeyPair          OWNAPI(ippsGFpECTstKeyPair)
#define ippsGFpECSharedSecretDH      OWNAPI(ippsGFpECSharedSecretDH)
#define ippsGFpECSharedSecretDHC     OWNAPI(ippsGFpECSharedSecretDHC)
#define ippsGFpECSignDSA             OWNAPI(ippsGFpECSignDSA)
#define ippsGFpECVerifyDSA           OWNAPI(ippsGFpECVerifyDSA)
#define ippsGFpECSignNR              OWNAPI(ippsGFpECSignNR)
#define ippsGFpECVerifyNR            OWNAPI(ippsGFpECVerifyNR)
#define ippsGFpECSignSM2             OWNAPI(ippsGFpECSignSM2)
#define ippsGFpECVerifySM2           OWNAPI(ippsGFpECVerifySM2)

  #include "ippcp.h"
#endif

/*
// modes of the CPU feature
*/
#define _FEATURE_OFF_      (0)   /* feature is OFF a priori */
#define _FEATURE_ON_       (1)   /* feature is ON  a priori */
#define _FEATURE_TICKTOCK_ (2)   /* dectect is feature OFF/ON */

#include "pcpvariant.h"

#pragma warning( disable : 4996 4324 4206)

/* ippCP length */
typedef int cpSize;

/*
// Common ippCP Macros
*/

/* size of cache line (bytes) */
#if (_IPP==_IPP_M5)
#define CACHE_LINE_SIZE      (16)
#define LOG_CACHE_LINE_SIZE   (4)
#else
#define CACHE_LINE_SIZE      (64)
#define LOG_CACHE_LINE_SIZE   (6)
#endif

/* swap data & pointers */
#define SWAP_PTR(ATYPE, pX,pY)   { ATYPE* aPtr=(pX); (pX)=(pY); (pY)=aPtr; }
#define SWAP(x,y)                {(x)^=(y); (y)^=(x); (x)^=(y);}

/* alignment value */
#define ALIGN_VAL ((int)sizeof(void*))

/* bitsize */
#define BYTESIZE     (8)
#define BITSIZE(x)   ((int)(sizeof(x)*BYTESIZE))

/* bit length -> byte/word length conversion */
#define BITS2WORD8_SIZE(x)  (((x)+ 7)>>3)
#define BITS2WORD16_SIZE(x) (((x)+15)>>4)
#define BITS2WORD32_SIZE(x) (((x)+31)>>5)
#define BITS2WORD64_SIZE(x) (((x)+63)>>6)

/* WORD and DWORD manipulators */
#define LODWORD(x)    ((Ipp32u)(x))
#define HIDWORD(x)    ((Ipp32u)(((Ipp64u)(x) >>32) & 0xFFFFFFFF))

#define MAKEHWORD(bLo,bHi) ((Ipp16u)(((Ipp8u)(bLo))  | ((Ipp16u)((Ipp8u)(bHi))) << 8))
#define MAKEWORD(hLo,hHi)  ((Ipp32u)(((Ipp16u)(hLo)) | ((Ipp32u)((Ipp16u)(hHi))) << 16))
#define MAKEDWORD(wLo,wHi) ((Ipp64u)(((Ipp32u)(wLo)) | ((Ipp64u)((Ipp32u)(wHi))) << 32))

/* extract byte */
#define EBYTE(w,n) ((Ipp8u)((w) >> (8 * (n))))

/* hexString <-> Ipp32u conversion */
#define HSTRING_TO_U32(ptrByte)  \
         (((ptrByte)[0]) <<24)   \
        +(((ptrByte)[1]) <<16)   \
        +(((ptrByte)[2]) <<8)    \
        +((ptrByte)[3])
#define U32_TO_HSTRING(ptrByte, x)  \
   (ptrByte)[0] = (Ipp8u)((x)>>24); \
   (ptrByte)[1] = (Ipp8u)((x)>>16); \
   (ptrByte)[2] = (Ipp8u)((x)>>8);  \
   (ptrByte)[3] = (Ipp8u)(x)

/* 32- and 64-bit masks for MSB of nbits-sequence */
#define MAKEMASK32(nbits) (0xFFFFFFFF >>((32 - ((nbits)&0x1F)) &0x1F))
#define MAKEMASK64(nbits) (0xFFFFFFFFFFFFFFFF >>((64 - ((nbits)&0x3F)) &0x3F))

/* Logical Shifts (right and left) of WORD */
#define LSR32(x,nBits)  ((x)>>(nBits))
#define LSL32(x,nBits)  ((x)<<(nBits))

/* Rorate (right and left) of WORD */
#if defined(_MSC_VER) && !defined( __ICL )
#  include <stdlib.h>
#  define ROR32(x, nBits)  _lrotr((x),(nBits))
#  define ROL32(x, nBits)  _lrotl((x),(nBits))
#else
#  define ROR32(x, nBits) (LSR32((x),(nBits)) | LSL32((x),32-(nBits)))
#  define ROL32(x, nBits) ROR32((x),(32-(nBits)))
#endif

/* Logical Shifts (right and left) of DWORD */
#define LSR64(x,nBits)  ((x)>>(nBits))
#define LSL64(x,nBits)  ((x)<<(nBits))

/* Rorate (right and left) of DWORD */
#define ROR64(x, nBits) (LSR64((x),(nBits)) | LSL64((x),64-(nBits)))
#define ROL64(x, nBits) ROR64((x),(64-(nBits)))

/* change endian */
#if defined(_MSC_VER)
#  define ENDIANNESS(x)   _byteswap_ulong((x))
#  define ENDIANNESS32(x)  ENDIANNESS((x))
#  define ENDIANNESS64(x) _byteswap_uint64((x))
#elif defined(__ICL)
#  define ENDIANNESS(x)   _bswap((x))
#  define ENDIANNESS32(x)  ENDIANNESS((x))
#  define ENDIANNESS64(x) _bswap64((x))
#else
#  define ENDIANNESS(x) ((ROR32((x), 24) & 0x00ff00ff) | (ROR32((x), 8) & 0xff00ff00))
#  define ENDIANNESS32(x) ENDIANNESS((x))
#  define ENDIANNESS64(x) MAKEDWORD(ENDIANNESS(HIDWORD((x))), ENDIANNESS(LODWORD((x))))
#endif

#define IPP_MAKE_MULTIPLE_OF_8(x) ((x) = ((x)+7)&(~7))
#define IPP_MAKE_MULTIPLE_OF_16(x) ((x) = ((x)+15)&(~15))

/* define 64-bit constant */
#if !defined(__GNUC__)
   #define CONST_64(x)  (x) /*(x##i64)*/
#else
   #define CONST_64(x)  (x##LL)
#endif

/* define 64-bit constant or pair of 32-bit dependding on architecture */
#if ((_IPP_ARCH == _IPP_ARCH_EM64T) || (_IPP_ARCH == _IPP_ARCH_LP64) || (_IPP_ARCH == _IPP_ARCH_LRB) || (_IPP_ARCH == _IPP_ARCH_LRB2))
#define LL(lo,hi) ((Ipp64u)(((Ipp32u)(lo)) | ((Ipp64u)((Ipp32u)(hi))) << 32))
#define L_(lo)    ((Ipp64u)(lo))
#else
#define LL(lo,hi) (lo),(hi)
#define L_(lo)    (lo)
#endif


/* test if library's feature is ON */
int cpGetFeature( Ipp64u Feature );
/* test CPU crypto features */
__INLINE Ipp32u IsFeatureEnabled(Ipp64u niMmask)
{
   return cpGetFeature(niMmask);
}

#define IPPCP_GET_NUM_THREADS() ( ippcpGetEnabledNumThreads() )
#define IPPCP_OMP_NUM_THREADS() num_threads( IPPCP_GET_NUM_THREADS() )
#define IPPCP_OMP_LIMIT_MAX_NUM_THREADS(n)  num_threads( IPP_MIN(IPPCP_GET_NUM_THREADS(),(n)))

/* copy under mask */
#define MASKED_COPY_BNU(dst, mask, src1, src2, len) { \
   cpSize i; \
   for(i=0; i<(len); i++) (dst)[i] = ((mask) & (src1)[i]) | (~(mask) & (src2)[i]); \
}

#endif /* __OWNCP_H__ */
