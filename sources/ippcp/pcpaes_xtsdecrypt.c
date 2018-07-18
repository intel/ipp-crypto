/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
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
//     AES-XTS Functions (IEEE P1619)
// 
//  Contents:
//        ippsAES_XTSDecrypt()
//
*/

#include "owncp.h"
#include "pcpaesmxts.h"
#include "pcptool.h"
#include "pcpaesmxtsstuff.h"


#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

//
//
static void cpAES_XTS_DecBlock(Ipp8u* ctxt, const Ipp8u* ptxt, const Ipp8u* tweak, const IppsAESSpec* pEncCtx)
{
   /* pre-whitening */
   XorBlock16(ptxt, tweak, ctxt);
   /* encryption */
   ippsAESDecryptECB(ctxt, ctxt, AES_BLK_SIZE, pEncCtx);
   /* post-whitening */
   XorBlock16(ctxt, tweak, ctxt);
}

/*F*
//    Name: ippsAES_XTSDecrypt
//
// Purpose: AES-XTS decryption.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSrc == NULL
//                            pDst == NULL
//                            pTweak ==NULL
//                            pCtx == NULL
//    ippStsLengthErr         bitLen <128
//    ippStsContextMatchErr   !VALID_AES_XTS_ID(pCtx)
//    ippStsBadArgErr         !IsLegalGeometry(startCipherBlkNo,
//                               bitLen, pCtx->duBitsize)
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc              points input buffer
//    pDst              points output buffer
//    bitLen            length of the input buffer in bits
//    startCipherBlkNo  number of the first block for data unit
//    pTweak            points tweak value
//    pCtx              points AES_XTS context
//
*F*/

IPPFUN(IppStatus, ippsAES_XTSDecrypt,(const Ipp8u* pSrc, Ipp8u* pDst, int bitLen,
                                      const IppsAES_XTSSpec* pCtx,
                                      const Ipp8u* pTweak,
                                      int startCipherBlkNo))
{
   /* test pointers */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned AES context */
   pCtx = (IppsAES_XTSSpec*)( IPP_ALIGNED_PTR(pCtx, AES_ALIGNMENT) );
   /* test the context ID */
   IPP_BADARG_RET(!VALID_AES_XTS_ID(pCtx), ippStsContextMatchErr);

   /* test data pointers */
   IPP_BAD_PTR3_RET(pSrc, pDst, pTweak);

   /* test startCipherBlkNo and bitLen */
   IPP_BADARG_RET(bitLen < IPP_AES_BLOCK_BITSIZE, ippStsLengthErr);
   IPP_BADARG_RET(!IsLegalGeometry(startCipherBlkNo, bitLen, pCtx->duBitsize), ippStsBadArgErr);

   {
      __ALIGN16 Ipp8u tweakCT[AES_BLK_SIZE];

      { /* encrypt tweak */
         const IppsAESSpec* ptwkAES = &pCtx->tweakAES;

         RijnCipher encoder = RIJ_ENCODER(ptwkAES);
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder(pTweak, tweakCT, RIJ_NR(ptwkAES), RIJ_EKEYS(ptwkAES), RijEncSbox/*NULL*/);
         #else
         encoder(pTweak, tweakCT, RIJ_NR(ptwkAES), RIJ_EKEYS(ptwkAES), NULL);
         #endif

         /* update tweakCT */
         for(; startCipherBlkNo>0; startCipherBlkNo--)
            gf_mul_by_primitive(tweakCT);
      }

      /* XTS decryption */
      {
         const IppsAESSpec* pdatAES = &pCtx->datumAES;

         int encBlocks = bitLen/IPP_AES_BLOCK_BITSIZE;
         int encBlocklast = bitLen%IPP_AES_BLOCK_BITSIZE;
         if(encBlocklast) encBlocks--;

         /* decrypt data blocks */
         if( encBlocks>0) {
            #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
            /* use Intel(R) AES New Instructions version if possible */
            if(AES_NI_ENABLED==RIJ_AESNI(pdatAES)) {
               cpAESDecryptXTS_AES_NI(pDst, pSrc, encBlocks, RIJ_DKEYS(pdatAES), RIJ_NR(pdatAES), tweakCT);
               pSrc += encBlocks*AES_BLK_SIZE;
               pDst += encBlocks*AES_BLK_SIZE;
            }
            else
            #endif
            {
               for(; encBlocks>0; encBlocks--) {
                  cpAES_XTS_DecBlock(pDst, pSrc, tweakCT, pdatAES);
                  gf_mul_by_primitive(tweakCT);
                  pSrc += AES_BLK_SIZE;
                  pDst += AES_BLK_SIZE;
               }
            }
         }

         /* "stealing" - decrypt last partial block if is */
         if(encBlocklast) {
            int partBlockSize = encBlocklast/BYTESIZE;

            __ALIGN16 Ipp8u cc[AES_BLK_SIZE];
            __ALIGN16 Ipp8u pp[AES_BLK_SIZE];
            CopyBlock16(tweakCT, cc);
            gf_mul_by_primitive(cc);
            cpAES_XTS_DecBlock(pp, pSrc, cc, pdatAES);

            CopyBlock16(pp, cc);
            CopyBlock(pSrc+AES_BLK_SIZE, cc, partBlockSize);

            encBlocklast %= BYTESIZE;
            if(encBlocklast) {
               Ipp8u partBlockMask = (0xFF)<<((BYTESIZE -encBlocklast) %BYTESIZE);
               Ipp8u x = pSrc[AES_BLK_SIZE+partBlockSize];
               Ipp8u y = cc[partBlockSize];
               x = (x & partBlockMask) | (y & ~partBlockMask);
               cc[partBlockSize] = x;
               pp[partBlockSize] &= partBlockMask;
               partBlockSize++;
            }
            cpAES_XTS_DecBlock(pDst, cc, tweakCT, pdatAES);

            CopyBlock(pp, pDst+AES_BLK_SIZE, partBlockSize);
         }
         return ippStsNoErr;
      }
   }
}

