/*******************************************************************************
* Copyright 2015-2018 Intel Corporation
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
//     Message Authentication Algorithm
//     Internal Definitions and Internal Functions Prototypes
// 
// 
*/

#if !defined(_CP_AESAUTH_GCM_H)
#define _CP_AESAUTH_GCM_H

#include "owncp.h"
#include "pcpaesm.h"

#define BLOCK_SIZE (MBS_RIJ128)

/* GCM Hash prototype: GHash = GHash*HKey mod G() */
typedef void (*MulGcm_)(Ipp8u* pGHash, const Ipp8u* pHKey, const void* pParam);

/* GCM Authentication prototype: GHash = (GHash^src[])*HKey mod G() */
typedef void (*Auth_)(Ipp8u* pHash, const Ipp8u* pSrc, int len, const Ipp8u* pHKey, const void* pParam);

/* GCM Encrypt_Authentication prototype */
typedef void (*Encrypt_)(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);

/* GCM Authentication_Decrypt prototype */
typedef void (*Decrypt_)(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);

typedef enum {
   GcmInit,
   GcmIVprocessing,
   GcmAADprocessing,
   GcmTXTprocessing
} GcmState;

struct _cpAES_GCM {
   IppCtxId idCtx;                  /* AES-GCM id                    */
   GcmState state;                  /* GCM state: Init, IV|AAD|TXT proccessing */
   Ipp64u   ivLen;                  /* IV length (bytes)             */
   Ipp64u   aadLen;                 /* header length (bytes)         */
   Ipp64u   txtLen;                 /* text length (bytes)           */

   int      bufLen;                 /* staff buffer length           */
   __ALIGN16                        /* aligned buffers               */
   Ipp8u    counter[BLOCK_SIZE];    /* counter                       */
   Ipp8u    ecounter0[BLOCK_SIZE];  /* encrypted initial counter     */
   Ipp8u    ecounter[BLOCK_SIZE];   /* encrypted counter             */
   Ipp8u    ghash[BLOCK_SIZE];      /* ghash accumulator             */

   MulGcm_  hashFun;                /* AES-GCM mul function          */
   Auth_    authFun;                /* authentication function       */
   Encrypt_ encFun;                 /* encryption & authentication   */
   Decrypt_ decFun;                 /* authentication & decryption   */

   __ALIGN16                        /* aligned AES context           */
   IppsAESSpec cipher;

   __ALIGN16                        /* aligned pre-computed data:    */
   Ipp8u multiplier[BLOCK_SIZE];    /* - (default) hKey                             */
                                    /* - (ase_ni)  hKey*t, (hKey*t)^2, (hKey*t)^4   */
                                    /* - (safe) hKey*(t^i), i=0,...,127             */
};

#define CTR_POS         12

/* alignment */
#define AESGCM_ALIGNMENT   (16)

#define PRECOMP_DATA_SIZE_AES_NI_AESGCM   (BLOCK_SIZE*4)
#define PRECOMP_DATA_SIZE_FAST2K          (BLOCK_SIZE*128)

/*
// Useful macros
*/
#define AESGCM_ID(stt)           ((stt)->idCtx)
#define AESGCM_STATE(stt)        ((stt)->state)

#define AESGCM_IV_LEN(stt)       ((stt)->ivLen)
#define AESGCM_AAD_LEN(stt)      ((stt)->aadLen)
#define AESGCM_TXT_LEN(stt)      ((stt)->txtLen)

#define AESGCM_BUFLEN(stt)       ((stt)->bufLen)
#define AESGCM_COUNTER(stt)      ((stt)->counter)
#define AESGCM_ECOUNTER0(stt)    ((stt)->ecounter0)
#define AESGCM_ECOUNTER(stt)     ((stt)->ecounter)
#define AESGCM_GHASH(stt)        ((stt)->ghash)

#define AESGCM_HASH(stt)         ((stt)->hashFun)
#define AESGCM_AUTH(stt)         ((stt)->authFun)
#define AESGCM_ENC(stt)          ((stt)->encFun)
#define AESGCM_DEC(stt)          ((stt)->decFun)

#define AESGCM_CIPHER(stt)       (IppsAESSpec*)(&((stt)->cipher))

#define AESGCM_HKEY(stt)         ((stt)->multiplier)
#define AESGCM_CPWR(stt)         ((stt)->multiplier)
#define AES_GCM_MTBL(stt)        ((stt)->multiplier)

#define AESGCM_VALID_ID(stt)     (AESGCM_ID((stt))==idCtxAESGCM)


__INLINE void IncrementCounter32(Ipp8u* pCtr)
{
   int i;
   for(i=BLOCK_SIZE-1; i>=CTR_POS && 0==(Ipp8u)(++pCtr[i]); i--) ;
}


#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
#define AesGcmPrecompute_avx OWNAPI(AesGcmPrecompute_avx)
   void AesGcmPrecompute_avx(Ipp8u* pPrecomputeData, const Ipp8u* pHKey);
#define AesGcmMulGcm_avx OWNAPI(AesGcmMulGcm_avx)
   void AesGcmMulGcm_avx(Ipp8u* pGhash, const Ipp8u* pHkey, const void* pParam);
#define AesGcmAuth_avx OWNAPI(AesGcmAuth_avx)
   void AesGcmAuth_avx(Ipp8u* pGhash, const Ipp8u* pSrc, int len, const Ipp8u* pHkey, const void* pParam);
#define wrpAesGcmEnc_avx OWNAPI(wrpAesGcmEnc_avx)
   void wrpAesGcmEnc_avx(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);
#define wrpAesGcmDec_avx OWNAPI(wrpAesGcmDec_avx)
   void wrpAesGcmDec_avx(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);
#define AesGcmEnc_avx OWNAPI(AesGcmEnc_avx)
   void AesGcmEnc_avx(Ipp8u* pDst, const Ipp8u* pSrc, int len,
                      RijnCipher cipher, int nr, const Ipp8u* pKeys,
                     Ipp8u* pGhash, Ipp8u* pCnt, Ipp8u* pECnt, const Ipp8u* pMuls);
#define AesGcmDec_avx OWNAPI(AesGcmDec_avx)
   void AesGcmDec_avx(Ipp8u* pDst, const Ipp8u* pSrc, int len,
                     RijnCipher cipher, int nr, const Ipp8u* pKeys,
                     Ipp8u* pGhash, Ipp8u* pCnt, Ipp8u* pECnt, const Ipp8u* pMuls);
#endif

#define AesGcmPrecompute_table2K OWNAPI(AesGcmPrecompute_table2K)
   void AesGcmPrecompute_table2K(Ipp8u* pPrecomputeData, const Ipp8u* pHKey);
#define AesGcmMulGcm_table2K OWNAPI(AesGcmMulGcm_table2K)
   void AesGcmMulGcm_table2K(Ipp8u* pGhash, const Ipp8u* pHkey, const void* pParam);
#define AesGcmAuth_table2K OWNAPI(AesGcmAuth_table2K)
   void AesGcmAuth_table2K(Ipp8u* pGhash, const Ipp8u* pSrc, int len, const Ipp8u* pHkey, const void* pParam);
#define wrpAesGcmEnc_table2K OWNAPI(wrpAesGcmEnc_table2K)
   void wrpAesGcmEnc_table2K(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);
#define wrpAesGcmDec_table2K OWNAPI(wrpAesGcmDec_table2K)
   void wrpAesGcmDec_table2K(Ipp8u* pDst, const Ipp8u* pSrc, int len, IppsAES_GCMState* pCtx);

extern const Ipp16u AesGcmConst_table[256];            /* precomputed reduction table */

static int cpSizeofCtx_AESGCM(void)
{
   int precomp_size;

   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   if( IsFeatureEnabled(ippCPUID_AES|ippCPUID_CLMUL) )
      precomp_size = PRECOMP_DATA_SIZE_AES_NI_AESGCM;
   else
   #endif
      precomp_size = PRECOMP_DATA_SIZE_FAST2K;

   /* decrease precomp_size as soon as BLOCK_SIZE bytes already reserved in context */
   precomp_size -= BLOCK_SIZE;

   return sizeof(IppsAES_GCMState)
         +precomp_size
         +AESGCM_ALIGNMENT-1;
}

#endif /* _CP_AESAUTH_GCM_H*/
