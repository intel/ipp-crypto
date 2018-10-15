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
//     AES encryption/decryption (CTR mode)
// 
//  Contents:
//     cpProcessAES_ctr()
//     cpProcessAES_ctr128()
//
*/

#if !defined(_OPENMP)

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*
// AES-CRT processing.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   !VALID_AES_ID()
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        128 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data buffer
//    pDst           pointer to the target data buffer
//    dataLen        input/output buffer length (in bytes)
//    pCtx           pointer to rge AES context
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*/
__INLINE void MaskCounter128(Ipp8u* pMaskIV, int ctrBtSize)
{
   /* construct ctr mask */
   int maskPosition = (MBS_RIJ128*8-ctrBtSize)/8;
   Ipp8u maskValue = (Ipp8u)(0xFF >> (MBS_RIJ128*8-ctrBtSize)%8 );

   Ipp8u maskIV[MBS_RIJ128];
   int n;
   for(n=0; n<MBS_RIJ128; n++) {
      int d = n - maskPosition;
      Ipp8u storedMaskValue = maskValue & ~cpIsMsb_ct(d);
      pMaskIV[n] = storedMaskValue;
      maskValue |= ~cpIsMsb_ct(d);
   }
}

static
IppStatus cpProcessAES_ctr(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen,
                           const IppsAESSpec* pCtx,
                           Ipp8u* pCtrValue, int ctrNumBitSize)
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned AES context */
   pCtx = (IppsAESSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_ID(pCtx), ippStsContextMatchErr);

   /* test source, target and counter block pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pCtrValue);
   /* test stream length */
   IPP_BADARG_RET((dataLen<1), ippStsLengthErr);

   /* test counter block size */
   IPP_BADARG_RET(((MBS_RIJ128*8)<ctrNumBitSize)||(ctrNumBitSize<1), ippStsCTRSizeErr);

   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   /* use pipelined version if possible */
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      /* construct ctr mask */
      #if 0
      int maskPosition = (MBS_RIJ128*8-ctrNumBitSize)/8;
      Ipp8u maskValue = (Ipp8u)(0xFF >> (MBS_RIJ128*8-ctrNumBitSize)%8 );

      Ipp8u maskIV[MBS_RIJ128];
      int n;
      for(n=0; n<maskPosition; n++)
         maskIV[n] = 0;
      maskIV[maskPosition] = maskValue;
      for(n=maskPosition+1; n<MBS_RIJ128; n++)
         maskIV[n] = 0xFF;
      #endif

      Ipp8u maskIV[MBS_RIJ128];
      MaskCounter128(maskIV, ctrNumBitSize); /* const-exe-time version */

      EncryptCTR_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), dataLen, pCtrValue, maskIV);
      return ippStsNoErr;
   }
   else
   #endif
   {
      Ipp32u counter[NB(128)];
      Ipp32u  output[NB(128)];

      /* setup encoder method */
      RijnCipher encoder = RIJ_ENCODER(pCtx);

      /* copy counter */
      CopyBlock16(pCtrValue, counter);

      /*
      // encrypt block-by-block aligned streams
      */
      while(dataLen>= MBS_RIJ128) {
         /* encrypt counter block */
         //encoder(counter, output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pCtx));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         /* compute ciphertext block */
         if( !(IPP_UINT_PTR(pSrc) & 0x3) && !(IPP_UINT_PTR(pDst) & 0x3)) {
            ((Ipp32u*)pDst)[0] = output[0]^((Ipp32u*)pSrc)[0];
            ((Ipp32u*)pDst)[1] = output[1]^((Ipp32u*)pSrc)[1];
            ((Ipp32u*)pDst)[2] = output[2]^((Ipp32u*)pSrc)[2];
            ((Ipp32u*)pDst)[3] = output[3]^((Ipp32u*)pSrc)[3];
         }
         else
            XorBlock16(pSrc, output, pDst);
         /* encrement counter block */
         StdIncrement((Ipp8u*)counter,MBS_RIJ128*8, ctrNumBitSize);

         pSrc += MBS_RIJ128;
         pDst += MBS_RIJ128;
         dataLen -= MBS_RIJ128;
      }
      /*
      // encrypt last data block
      */
      if(dataLen) {
         /* encrypt counter block */
         //encoder(counter, output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pCtx));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)counter, (Ipp8u*)output, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         /* compute ciphertext block */
         XorBlock(pSrc, output, pDst,dataLen);
         /* encrement counter block */
         StdIncrement((Ipp8u*)counter,MBS_RIJ128*8, ctrNumBitSize);
      }

      /* update counter */
      CopyBlock16(counter, pCtrValue);

      return ippStsNoErr;
   }
}

#if (_IPP32E>=_IPP32E_Y8)

/*
// special version: 128-bit counter
*/
static
IppStatus cpProcessAES_ctr128(const Ipp8u* pSrc, Ipp8u* pDst, int dataLen, const IppsAESSpec* pCtx, Ipp8u* pCtrValue)
{
   /* test context */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned AES context */
   pCtx = (IppsAESSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_ID(pCtx), ippStsContextMatchErr);

   /* test source, target and counter block pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pCtrValue);
   /* test stream length */
   IPP_BADARG_RET((dataLen<1), ippStsLengthErr);

   {
      while(dataLen>=MBS_RIJ128) {
         Ipp32u blocks = dataLen>>4; /* number of blocks per loop processing */

         /* low LE 32 bit of counter */
         Ipp32u ctr32 = ((Ipp32u*)(pCtrValue))[3];
         ctr32 = ENDIANNESS32(ctr32);

         /* compute number of locks being processed without ctr32 overflow */
         ctr32 += blocks;
         if(ctr32 < blocks)
            blocks -= ctr32;

         EncryptStreamCTR32_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), blocks*MBS_RIJ128, pCtrValue);

         pSrc += blocks*MBS_RIJ128;
         pDst += blocks*MBS_RIJ128;
         dataLen -= blocks*MBS_RIJ128;
      }

      if(dataLen) {
         EncryptStreamCTR32_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), dataLen, pCtrValue);
      }

      return ippStsNoErr;
   }
}

#endif /* #if (_IPP32E>=_IPP32E_Y8) */

#endif /* #if !defined(_OPENMP) */

