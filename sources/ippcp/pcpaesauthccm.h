/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
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

#if !defined(_CP_AES_CCM_H)
#define _CP_AES_CCM_H

#include "pcprij.h"
#include "pcpaesm.h"

struct _cpAES_CCM {
   IppCtxId idCtx;            /* CCM ID               */

   Ipp64u   msgLen;           /* length of message to be processed */
   Ipp64u   lenProcessed;     /* message length has been processed */
   Ipp32u   tagLen;           /* length of authentication tag      */
   Ipp32u   counterVal;       /* currnt couter value */
   Ipp8u   ctr0[MBS_RIJ128];  /* counter value */
   Ipp8u     s0[MBS_RIJ128];  /* S0 = ENC(CTR0) content */
   Ipp8u     si[MBS_RIJ128];  /* Si = ENC(CTRi) content */
   Ipp8u    blk[MBS_RIJ128];  /* temporary data container */
   Ipp8u    mac[MBS_RIJ128];  /* current MAC value */

   Ipp8u    cipher[sizeof(IppsAESSpec)+AES_ALIGNMENT-1];
};

/* alignment */
#define AESCCM_ALIGNMENT   ((int)(sizeof(void*)))

/*
// access macros
*/
#define AESCCM_ID(stt)        ((stt)->idCtx)
#define AESCCM_MSGLEN(stt)    ((stt)->msgLen)
#define AESCCM_LENPRO(stt)    ((stt)->lenProcessed)
#define AESCCM_TAGLEN(stt)    ((stt)->tagLen)
#define AESCCM_COUNTER(stt)   ((stt)->counterVal)
#define AESCCM_CTR0(stt)      ((stt)->ctr0)
#define AESCCM_S0(stt)        ((stt)->s0)
#define AESCCM_Si(stt)        ((stt)->si)
#define AESCCM_BLK(stt)       ((stt)->blk)
#define AESCCM_MAC(stt)       ((stt)->mac)
#define AESCCM_CIPHER(stt)          (IppsAESSpec*)(&((stt)->cipher))
#define AESCCM_CIPHER_ALIGNED(stt)  (IppsAESSpec*)( IPP_ALIGNED_PTR( ((stt)->cipher), AES_ALIGNMENT ) )

/* valid context ID */
#define VALID_AESCCM_ID(ctx)  (AESCCM_ID((ctx))==idCtxAESCCM)

/*
// Internal functions
*/
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
#define AuthEncrypt_RIJ128_AES_NI OWNAPI(AuthEncrypt_RIJ128_AES_NI)
   void AuthEncrypt_RIJ128_AES_NI(const Ipp8u* inpBlk, Ipp8u* outBlk, int nr, const void* pRKey, Ipp32u len, void* pLocalCtx);
#define DecryptAuth_RIJ128_AES_NI OWNAPI(DecryptAuth_RIJ128_AES_NI)
   void DecryptAuth_RIJ128_AES_NI(const Ipp8u* inpBlk, Ipp8u* outBlk, int nr, const void* pRKey, Ipp32u len, void* pLocalCtx);
#endif

/* Counter block formatter */
static Ipp8u* CounterEnc(Ipp32u* pBuffer, int fmt, Ipp64u counter)
{
   #if (IPP_ENDIAN == IPP_LITTLE_ENDIAN)
   pBuffer[0] = ENDIANNESS(HIDWORD(counter));
   pBuffer[1] = ENDIANNESS(LODWORD(counter));
   #else
   pBuffer[0] = HIDWORD(counter);
   pBuffer[1] = LODWORD(counter);
   #endif
   return (Ipp8u*)pBuffer + 8 - fmt;
}

static int cpSizeofCtx_AESCCM(void)
{
   return sizeof(IppsAES_CCMState) + AESCCM_ALIGNMENT-1;
}

#endif /* _CP_AES_CCM_H*/
