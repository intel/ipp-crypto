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
//     Cryptography Primitive. AES keys expansion
// 
//  Contents:
//        cpExpandAesKey_NI()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesm.h"

#if !defined (_PCP_AES_KEYS_NI_H)
#define _PCP_AES_KEYS_NI_H

#if (_AES_NI_ENABLING_==_FEATURE_ON_) || (_AES_NI_ENABLING_==_FEATURE_TICKTOCK_)

//////////////////////////////////////////////////////////////////////
#define cpExpandAesKey_NI       OWNAPI(cpExpandAesKey_NI)
void    cpExpandAesKey_NI(const Ipp8u* pSecret, IppsAESSpec* pCtx);
#define aes_DecKeyExpansion_NI  OWNAPI(aes_DecKeyExpansion_NI)
void    aes_DecKeyExpansion_NI(Ipp8u* decKeys, const Ipp8u* encKeys, int nr);
#define aes128_KeyExpansion_NI  OWNAPI(aes128_KeyExpansion_NI)
void    aes128_KeyExpansion_NI(Ipp8u* keyExp, const Ipp8u* userkey);
#define aes192_KeyExpansion_NI  OWNAPI(aes192_KeyExpansion_NI)
void    aes192_KeyExpansion_NI(Ipp8u* keyExp, const Ipp8u* userkey);
#define aes256_KeyExpansion_NI  OWNAPI(aes256_KeyExpansion_NI)
void    aes256_KeyExpansion_NI(Ipp8u* keyExp, const Ipp8u* userkey);

#endif /* #if (_AES_NI_ENABLING_==_FEATURE_ON_) || (_AES_NI_ENABLING_==_FEATURE_TICKTOCK_) */

#endif /* #if !defined (_PCP_AES_KEYS_NI_H) */
