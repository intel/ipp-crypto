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
//     SMS4 encryption/decryption
// 
//  Contents:
//        cpProcessSMS4_ofb8()
//
*/

#include "owncp.h"
#include "pcpsms4.h"
#include "pcptool.h"

#if !defined _PCP_SMS4_PROCESS_OFB8_H
#define _PCP_SMS4_PROCESS_OFB8_H

/*
// SMS4-OFB ecnryption/decryption
//
// Parameters:
//    pSrc        pointer to the source data buffer
//    pDst        pointer to the target data buffer
//    dataLen     input/output buffer length (in bytes)
//    ofbBlkSize  ofb block size (in bytes)
//    pCtx        pointer to the AES context
//    pIV         pointer to the initialization vector
*/
static void cpProcessSMS4_ofb8(const Ipp8u *pSrc, Ipp8u *pDst, int dataLen, int ofbBlkSize,
                        const IppsSMS4Spec* pCtx,
                        Ipp8u* pIV)
{
   Ipp32u tmpInpOut[2*MBS_SMS4/sizeof(Ipp32u)];

   CopyBlock16(pIV, tmpInpOut);

   while(dataLen>=ofbBlkSize) {
      /* block-by-block processing */
      cpSMS4_Cipher((Ipp8u*)tmpInpOut+MBS_SMS4, (Ipp8u*)tmpInpOut, SMS4_RK(pCtx));

      /* store output and shift inpBuffer for the next OFB operation */
      if(ofbBlkSize==MBS_SMS4) {
         ((Ipp32u*)pDst)[0] = tmpInpOut[0+MBS_SMS4/sizeof(Ipp32u)]^((Ipp32u*)pSrc)[0];
         ((Ipp32u*)pDst)[1] = tmpInpOut[1+MBS_SMS4/sizeof(Ipp32u)]^((Ipp32u*)pSrc)[1];
         ((Ipp32u*)pDst)[2] = tmpInpOut[2+MBS_SMS4/sizeof(Ipp32u)]^((Ipp32u*)pSrc)[2];
         ((Ipp32u*)pDst)[3] = tmpInpOut[3+MBS_SMS4/sizeof(Ipp32u)]^((Ipp32u*)pSrc)[3];
         tmpInpOut[0] = tmpInpOut[0+MBS_SMS4/sizeof(Ipp32u)];
         tmpInpOut[1] = tmpInpOut[1+MBS_SMS4/sizeof(Ipp32u)];
         tmpInpOut[2] = tmpInpOut[2+MBS_SMS4/sizeof(Ipp32u)];
         tmpInpOut[3] = tmpInpOut[3+MBS_SMS4/sizeof(Ipp32u)];
      }
      else {
         XorBlock(pSrc, tmpInpOut+MBS_SMS4/sizeof(Ipp32u), pDst, ofbBlkSize);
         CopyBlock16((Ipp8u*)tmpInpOut+ofbBlkSize, tmpInpOut);
      }

      pSrc += ofbBlkSize;
      pDst += ofbBlkSize;
      dataLen -= ofbBlkSize;
   }

   /* update pIV */
   CopyBlock16((Ipp8u*)tmpInpOut, pIV);
}

#endif /* #if !defined _PCP_SMS4_PROCESS_OFB8_H */
