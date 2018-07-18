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
//     Internal Definitions and
//     Internal SMS4 Function Prototypes
// 
// 
*/

#if !defined(_PCP_SMS4_H)
#define _PCP_SMS4_H

#include "owncp.h"

struct _cpSMS4 {
   IppCtxId    idCtx;         /* SMS4 spec identifier      */
   Ipp32u      enc_rkeys[32]; /* enc round keys */
   Ipp32u      dec_rkeys[32]; /* enc round keys */
};

/*
// access macros
*/
#define SMS4_ID(ctx)       ((ctx)->idCtx)
#define SMS4_RK(ctx)       ((ctx)->enc_rkeys)
#define SMS4_ERK(ctx)      ((ctx)->enc_rkeys)
#define SMS4_DRK(ctx)      ((ctx)->dec_rkeys)

/* SMS4 data block size (bytes) */
#define MBS_SMS4  (16)

/* valid SMS4 context ID */
#define VALID_SMS4_ID(ctx)   (SMS4_ID((ctx))==idCtxSMS4)

/* alignment of AES context */
#define SMS4_ALIGNMENT   (4)

/* size of SMS4 context */
__INLINE int cpSizeofCtx_SMS4(void)
{
   return sizeof(IppsSMS4Spec) +(SMS4_ALIGNMENT-1);
}

/* SMS4 constants */
extern const __ALIGN64 Ipp8u  SMS4_Sbox[16*16];
extern const Ipp32u SMS4_FK[4];
extern const Ipp32u SMS4_CK[32];

//////////////////////////////////////////////////////////////////////////////////////////////////////
/* S-box substitution (endian dependent!) */

#include "pcpbnuimpl.h"
#define SELECTION_BITS  ((sizeof(BNU_CHUNK_T)/sizeof(Ipp8u)) -1)

#if defined(__INTEL_COMPILER)
__INLINE Ipp8u getSboxValue(Ipp8u x)
{
   BNU_CHUNK_T selection = 0;
   const BNU_CHUNK_T* SboxEntry = (BNU_CHUNK_T*)SMS4_Sbox;

   BNU_CHUNK_T i_sel = x/sizeof(BNU_CHUNK_T);  /* selection index */
   BNU_CHUNK_T i;
   for(i=0; i<sizeof(SMS4_Sbox)/sizeof(BNU_CHUNK_T); i++) {
      BNU_CHUNK_T mask = (i==i_sel)? (BNU_CHUNK_T)(-1) : 0;  /* ipp and IPP build specific avoid jump instruction here */
      selection |= SboxEntry[i] & mask;
   }
   selection >>= (x & SELECTION_BITS)*8;
   return (Ipp8u)(selection & 0xFF);
}
#else
#include "pcpmask_ct.h"
__INLINE Ipp8u getSboxValue(Ipp8u x)
{
   BNU_CHUNK_T selection = 0;
   const BNU_CHUNK_T* SboxEntry = (BNU_CHUNK_T*)SMS4_Sbox;

   Ipp32u _x = x/sizeof(BNU_CHUNK_T);
   Ipp32u i;
   for(i=0; i<sizeof(SMS4_Sbox)/sizeof(BNU_CHUNK_T); i++) {
      BNS_CHUNK_T mask = cpIsEqu_ct(_x, i);
      selection |= SboxEntry[i] & mask;
   }
   selection >>= (x & SELECTION_BITS)*8;
   return (Ipp8u)(selection & 0xFF);
}
#endif

__INLINE Ipp32u cpSboxT_SMS4(Ipp32u x)
{
   Ipp32u y = getSboxValue(x & 0xFF);
   y |= getSboxValue((x>> 8) & 0xFF) <<8;
   y |= getSboxValue((x>>16) & 0xFF) <<16;
   y |= getSboxValue((x>>24) & 0xFF) <<24;
   return y;
}

/* key expansion transformation:
   - linear Lilear
   - mixer Mix
*/
__INLINE Ipp32u cpExpKeyLinear_SMS4(Ipp32u x)
{
   return x^ROL32(x,13)^ROL32(x,23);
}

__INLINE Ipp32u cpExpKeyMix_SMS4(Ipp32u x)
{
   return cpExpKeyLinear_SMS4( cpSboxT_SMS4(x) );
}

/* cipher transformations:
   - linear Lilear
   - mixer Mix
*/
__INLINE Ipp32u cpCipherLinear_SMS4(Ipp32u x)
{
   return x^ROL32(x,2)^ROL32(x,10)^ROL32(x,18)^ROL32(x,24);
}

__INLINE Ipp32u cpCipherMix_SMS4(Ipp32u x)
{
   return cpCipherLinear_SMS4( cpSboxT_SMS4(x) );
}
//////////////////////////////////////////////////////////////////////////////////////////////


#define cpSMS4_Cipher OWNAPI(cpSMS4_Cipher)
void    cpSMS4_Cipher(Ipp8u* otxt, const Ipp8u* itxt, const Ipp32u* pRoundKeys);

#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
#define cpSMS4_SetRoundKeys_aesni OWNAPI(cpSMS4_SetRoundKeys_aesni)
void    cpSMS4_SetRoundKeys_aesni(Ipp32u* pRounKey, const Ipp8u* pSecretKey);

#define cpSMS4_ECB_aesni_x1 OWNAPI(cpSMS4_ECB_aesni_x1)
   void cpSMS4_ECB_aesni_x1(Ipp8u* pOut, const Ipp8u* pInp, const Ipp32u* pRKey);
#define cpSMS4_ECB_aesni OWNAPI(cpSMS4_ECB_aesni)
int     cpSMS4_ECB_aesni(Ipp8u* pDst, const Ipp8u* pSrc, int nLen, const Ipp32u* pRKey);
#define cpSMS4_CBC_dec_aesni OWNAPI(cpSMS4_CBC_dec_aesni)
int     cpSMS4_CBC_dec_aesni(Ipp8u* pDst, const Ipp8u* pSrc, int nLen, const Ipp32u* pRKey, Ipp8u* pIV);
#define cpSMS4_CTR_aesni OWNAPI(cpSMS4_CTR_aesni)
int     cpSMS4_CTR_aesni(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey, const Ipp8u* pCtrMask, Ipp8u* pCtr);

#if (_IPP>=_IPP_H9) || (_IPP32E>=_IPP32E_L9)
#define cpSMS4_ECB_aesni_x12 OWNAPI(cpSMS4_ECB_aesni_x12)
    int cpSMS4_ECB_aesni_x12(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey);
#define cpSMS4_CBC_dec_aesni_x12 OWNAPI(cpSMS4_CBC_dec_aesni_x12)
    int cpSMS4_CBC_dec_aesni_x12(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey, Ipp8u* pIV);
#define cpSMS4_CTR_aesni_x4 OWNAPI(cpSMS4_CTR_aesni_x4)
    int cpSMS4_CTR_aesni_x4(Ipp8u* pOut, const Ipp8u* pInp, int len, const Ipp32u* pRKey, const Ipp8u* pCtrMask, Ipp8u* pCtr);
#endif

#endif

#define cpProcessSMS4_ctr OWNAPI(cpProcessSMS4_ctr)
IppStatus cpProcessSMS4_ctr(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen, const IppsSMS4Spec* pCtx, Ipp8u* pCtrValue, int ctrNumBitSize);

#define cpSMS4_SetRoundKeys OWNAPI(cpSMS4_SetRoundKeys)
void cpSMS4_SetRoundKeys(Ipp32u* pRounKey, const Ipp8u* pKey);

#endif /* _PCP_SMS4_H */
