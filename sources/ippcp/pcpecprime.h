/*******************************************************************************
* Copyright 2017-2018 Intel Corporation
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
//     Fixed EC primes
// 
// 
*/

#if !defined(_PCP_ECPRIME_H)
#define _PCP_ECPRIME_H

#include "owndefs.h"
#include "pcpbnuimpl.h"


/*
// Recommended (NIST's) underlying EC Primes
*/
extern const BNU_CHUNK_T secp112r1_p[]; // (2^128 -3)/76439
extern const BNU_CHUNK_T secp112r2_p[]; // (2^128 -3)/76439
extern const BNU_CHUNK_T secp128r1_p[]; // 2^128 -2^97 -1
extern const BNU_CHUNK_T secp128r2_p[]; // 2^128 -2^97 -1
extern const BNU_CHUNK_T secp160r1_p[]; // 2^160 -2^31 -1
extern const BNU_CHUNK_T secp160r2_p[]; // 2^160 -2^32 -2^14 -2^12 -2^9 -2^8 -2^7 -2^2 -1
extern const BNU_CHUNK_T secp192r1_p[]; // 2^192 -2^64 -1
extern const BNU_CHUNK_T secp224r1_p[]; // 2^224 -2^96 +1
extern const BNU_CHUNK_T secp256r1_p[]; // 2^256 -2^224 +2^192 +2^96 -1
extern const BNU_CHUNK_T secp384r1_p[]; // 2^384 -2^128 -2^96 +2^32 -1
extern const BNU_CHUNK_T secp521r1_p[]; // 2^521 -1

extern const BNU_CHUNK_T tpmBN_p256p_p[]; // TPM BN_P256

/*
// Recommended (SM2) underlying EC Prime
*/
extern const BNU_CHUNK_T tpmSM2_p256_p[]; // TPM SM2_P256

#endif /* _PCP_ECPRIME_H */
