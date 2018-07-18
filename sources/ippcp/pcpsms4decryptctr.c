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
//        ippsSMS4DecryptCTR()
//
*/

#include "owncp.h"
#include "pcpsms4.h"
#include "pcptool.h"

/*F*
//    Name: ippsSMS4DecryptCTR
//
// Purpose: SMS4-CRT encryption.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//                            pSrc == NULL
//                            pDst == NULL
//                            pCtrValue ==NULL
//    ippStsContextMatchErr   !VALID_SMS4_ID()
//    ippStsLengthErr         len <1
//    ippStsCTRSizeErr        128 < ctrNumBitSize < 1
//    ippStsNoErr             no errors
//
// Parameters:
//    pSrc           pointer to the source data buffer
//    pDst           pointer to the target data buffer
//    len        input/output buffer length (in bytes)
//    pCtx           pointer to rge SMS4 context
//    pCtrValue      pointer to the counter block
//    ctrNumBitSize  counter block size (bits)
//
// Note:
//    counter will updated on return
//
*F*/

IPPFUN(IppStatus, ippsSMS4DecryptCTR,(const Ipp8u* pSrc, Ipp8u* pDst, int len,
                                      const IppsSMS4Spec* pCtx,
                                      Ipp8u* pCtrValue, int ctrNumBitSize))
{
   return cpProcessSMS4_ctr(pSrc, pDst, len, pCtx, pCtrValue, ctrNumBitSize);
}
