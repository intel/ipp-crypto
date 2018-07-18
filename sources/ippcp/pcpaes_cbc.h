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
//     AES encryption/decryption (CBC mode)
//     AES encryption/decryption (CBC-CS mode)
// 
//  Contents:
//     ippsAESDecryptCBC()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"

#if !defined(_PCP_AES_CBC_H_)
#define _PCP_AES_CBC_H_

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*
// AES-CBC decryption
//
// Parameters:
//    pIV         pointer to the initialization vector
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    nBlocks     number of decrypted data blocks
//    pCtx        pointer to the AES context
*/
static
void cpDecryptAES_cbc(const Ipp8u* pIV,
                      const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks,
                      const IppsAESSpec* pCtx)
{
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   /* use pipelined version is possible */
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      DecryptCBC_RIJ128pipe_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), nBlocks*MBS_RIJ128, pIV);
   }
   else
#endif
   {
      /* setup decoder method */
      RijnCipher decoder = RIJ_DECODER(pCtx);

      /* copy IV */
      Ipp32u iv[NB(128)];
      CopyBlock16(pIV, iv);

      /* not inplace block-by-block decryption */
      if(pSrc != pDst) {
         while(nBlocks) {
            //decoder((const Ipp32u*)pSrc, (Ipp32u*)pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), (const Ipp32u (*)[256])RIJ_DEC_SBOX(pCtx));
            #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
            decoder(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijDecSbox/*NULL*/);
            #else
            decoder(pSrc, pDst, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), NULL);
            #endif

            ((Ipp32u*)pDst)[0] ^= iv[0];
            ((Ipp32u*)pDst)[1] ^= iv[1];
            ((Ipp32u*)pDst)[2] ^= iv[2];
            ((Ipp32u*)pDst)[3] ^= iv[3];

            iv[0] = ((Ipp32u*)pSrc)[0];
            iv[1] = ((Ipp32u*)pSrc)[1];
            iv[2] = ((Ipp32u*)pSrc)[2];
            iv[3] = ((Ipp32u*)pSrc)[3];

            pSrc += MBS_RIJ128;
            pDst += MBS_RIJ128;
            nBlocks--;
         }
      }

      /* inplace block-by-block decryption */
      else {
         Ipp32u tmpInp[NB(128)];
         Ipp32u tmpOut[NB(128)];

         while(nBlocks) {
            CopyBlock16(pSrc, tmpInp);
            //decoder(tmpInp, tmpOut, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), (const Ipp32u (*)[256])RIJ_DEC_SBOX(pCtx));
            #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
            decoder((Ipp8u*)tmpInp, (Ipp8u*)tmpOut, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijDecSbox/*NULL*/);
            #else
            decoder((Ipp8u*)tmpInp, (Ipp8u*)tmpOut, RIJ_NR(pCtx), RIJ_DKEYS(pCtx), NULL);
            #endif

            tmpOut[0] ^= iv[0];
            tmpOut[1] ^= iv[1];
            tmpOut[2] ^= iv[2];
            tmpOut[3] ^= iv[3];

            CopyBlock16(tmpOut, pDst);

            iv[0] = tmpInp[0];
            iv[1] = tmpInp[1];
            iv[2] = tmpInp[2];
            iv[3] = tmpInp[3];

            pSrc += MBS_RIJ128;
            pDst += MBS_RIJ128;
            nBlocks--;
         }
      }
   }
}


/*
// AES-CBC ecnryption
//
// Parameters:
//    pIV         pointer to the initialization vector
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    nBlocks     number of ecnrypted data blocks
//    pCtx        pointer to the AES context
*/
static
void cpEncryptAES_cbc(const Ipp8u* pIV,
                      const Ipp8u* pSrc, Ipp8u* pDst, int nBlocks, const IppsAESSpec* pCtx)
{
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   if(AES_NI_ENABLED==RIJ_AESNI(pCtx)) {
      EncryptCBC_RIJ128_AES_NI(pSrc, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), nBlocks*MBS_RIJ128, pIV);
   }
   else
#endif
   {
      /* setup encoder method */
      RijnCipher encoder = RIJ_ENCODER(pCtx);

      /* read IV */
      Ipp32u iv[NB(128)];
      CopyBlock16(pIV, iv);

      /* block-by-block encryption */
      while(nBlocks) {
         iv[0] ^= ((Ipp32u*)pSrc)[0];
         iv[1] ^= ((Ipp32u*)pSrc)[1];
         iv[2] ^= ((Ipp32u*)pSrc)[2];
         iv[3] ^= ((Ipp32u*)pSrc)[3];

         //encoder(iv, (Ipp32u*)pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pCtx));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)iv, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)iv, pDst, RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
         #endif

         iv[0] = ((Ipp32u*)pDst)[0];
         iv[1] = ((Ipp32u*)pDst)[1];
         iv[2] = ((Ipp32u*)pDst)[2];
         iv[3] = ((Ipp32u*)pDst)[3];

         pSrc += MBS_RIJ128;
         pDst += MBS_RIJ128;
         nBlocks--;
      }
   }
}

#endif /* #if !defined(_PCP_AES_CBC_H_) */
