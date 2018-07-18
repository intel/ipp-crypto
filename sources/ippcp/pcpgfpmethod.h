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
//  Purpose:
//     Intel(R) Integrated Performance Primitives
//     Cryptographic Primitives
//     Internal GF(p) basic Definitions & Function Prototypes
//
*/
#if !defined(_CP_GFP_METHOD_H)
#define _CP_GFP_METHOD_H

#include "owncp.h"

#include "pcpbnuimpl.h"
#include "gsmodmethod.h"

/* modulus ID */
typedef enum {
   cpID_Prime        = 0x1000,
   cpID_PrimeP192r1  = cpID_Prime+6,
   cpID_PrimeP224r1  = cpID_Prime+7,
   cpID_PrimeP256r1  = cpID_Prime+8,
   cpID_PrimeP384r1  = cpID_Prime+9,
   cpID_PrimeP521r1  = cpID_Prime+10,
   cpID_PrimeTPM_SM2 = cpID_Prime+11,
   cpID_PrimeTPM_BN  = cpID_Prime+12,

   cpID_Poly  = 0x10000000, /* id=0x10000000: general polynomial */
   cpID_Binom = 0x01000000, /* id=0x11000000: x^d+a */

   cpID_Binom2_epid20  = cpID_Binom|0x220000, /* 0x11220000 */
   cpID_Binom3_epid20  = cpID_Binom|0x230000  /* 0x11230000 */

} cpModulusID;

typedef struct _cpGFpMethod {
   cpModulusID  modulusID;
   int          modulusBitDeg;
   const BNU_CHUNK_T* modulus;
   const gsModMethod* arith;
} cpGFpMethod;

/* common GF arith methods */
#define      gsArithGFp OWNAPI(gsArithGFp)
gsModMethod* gsArithGFp(void);

#endif /* _CP_GFP_METHOD_H */
