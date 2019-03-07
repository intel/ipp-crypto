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
//     AES-GCM
// 
//  Contents:
//        ippsAES_GCMStart()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthgcm.h"
#include "pcpaesm.h"
#include "pcptool.h"

/*F*
//    Name: ippsAES_GCMStart
//
// Purpose: Start the process of encryption or decryption and authentication tag generation.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//                            pIV == NULL, ivLen>0
//                            pAAD == NULL, aadLen>0
//    ippStsContextMatchErr   !AESGCM_VALID_ID()
//    ippStsLengthErr         ivLen < 0
//                            aadLen < 0
//    ippStsNoErr             no errors
//
// Parameters:
//    pIV         pointer to the IV (nonce)
//    ivLen       length of the IV in bytes
//    pAAD        pointer to the Addition Authenticated Data (header)
//    aadLen      length of the AAD in bytes
//    pState      pointer to the AES-GCM state
//
*F*/
IPPFUN(IppStatus, ippsAES_GCMStart,(const Ipp8u* pIV,  int ivLen,
                                    const Ipp8u* pAAD, int aadLen,
                                    IppsAES_GCMState* pState))
{
   IppStatus sts = ippsAES_GCMReset(pState);
   if(ippStsNoErr==sts)
      sts = ippsAES_GCMProcessIV(pIV, ivLen, pState);
   if(ippStsNoErr==sts)
      sts = ippsAES_GCMProcessAAD(pAAD, aadLen, pState);
   return sts;
}
