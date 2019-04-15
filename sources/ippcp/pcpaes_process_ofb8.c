/*******************************************************************************
* Copyright 2013-2019 Intel Corporation
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
//     AES encryption/decryption (OFB mode)
// 
//  Contents:
//        cpProcessAES_ofb8()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "pcpaes_ofb.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif


/*
// AES-OFB ecnryption/decryption
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    dataLen     input/output buffer length (in bytes)
//    ofbBlkSize  ofb block size (in bytes)
//    pCtx        pointer to the AES context
//    pIV         pointer to the initialization vector
*/
void cpProcessAES_ofb8(const Ipp8u *pSrc, Ipp8u *pDst, int dataLen, int ofbBlkSize,
                       const IppsAESSpec* pCtx,
                       Ipp8u* pIV)
{
   /* setup encoder method */
   RijnCipher encoder = RIJ_ENCODER(pCtx);

   Ipp32u tmpInpOut[2*NB(128)];

   CopyBlock16(pIV, tmpInpOut);

   while(dataLen>=ofbBlkSize) {
      /* block-by-block processing */
      //encoder(tmpInpOut, tmpInpOut+NB(128), RIJ_NR(pCtx), RIJ_EKEYS(pCtx), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pCtx));
      #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
      encoder((Ipp8u*)tmpInpOut, (Ipp8u*)(tmpInpOut+NB(128)), RIJ_NR(pCtx), RIJ_EKEYS(pCtx), RijEncSbox/*NULL*/);
      #else
      encoder((Ipp8u*)tmpInpOut, (Ipp8u*)(tmpInpOut+NB(128)), RIJ_NR(pCtx), RIJ_EKEYS(pCtx), NULL);
      #endif

      /* store output and shift inpBuffer for the next OFB operation */
      if(ofbBlkSize==MBS_RIJ128) {
         ((Ipp32u*)pDst)[0] = tmpInpOut[0+NB(128)]^((Ipp32u*)pSrc)[0];
         ((Ipp32u*)pDst)[1] = tmpInpOut[1+NB(128)]^((Ipp32u*)pSrc)[1];
         ((Ipp32u*)pDst)[2] = tmpInpOut[2+NB(128)]^((Ipp32u*)pSrc)[2];
         ((Ipp32u*)pDst)[3] = tmpInpOut[3+NB(128)]^((Ipp32u*)pSrc)[3];
         tmpInpOut[0] = tmpInpOut[0+NB(128)];
         tmpInpOut[1] = tmpInpOut[1+NB(128)];
         tmpInpOut[2] = tmpInpOut[2+NB(128)];
         tmpInpOut[3] = tmpInpOut[3+NB(128)];
      }
      else {
         XorBlock(pSrc, tmpInpOut+NB(128), pDst, ofbBlkSize);
         CopyBlock16((Ipp8u*)tmpInpOut+ofbBlkSize, tmpInpOut);
      }

      pSrc += ofbBlkSize;
      pDst += ofbBlkSize;
      dataLen -= ofbBlkSize;
   }

   /* update pIV */
   CopyBlock16((Ipp8u*)tmpInpOut, pIV);
}
