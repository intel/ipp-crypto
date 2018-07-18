/*******************************************************************************
* Copyright 2010-2018 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
// 
*/

#include "owncp.h"
#include "pcpbnuarith.h"


#if defined(_USE_C_cpMontRedAdc_BNU_)
#pragma message ("C version of cpMontRedAdc_BNU: ON")
#else
#pragma message ("C version of cpMontRedAdc_BNU: OFF")
#endif

#if !((_IPP==_IPP_W7) || \
      (_IPP==_IPP_T7) || \
      (_IPP==_IPP_V8) || \
      (_IPP==_IPP_P8) || \
      (_IPP>=_IPP_G9) || \
      (_IPP==_IPP_S8) || \
      (_IPP32E==_IPP32E_M7) || \
      (_IPP32E==_IPP32E_U8) || \
      (_IPP32E==_IPP32E_Y8) || \
      (_IPP32E>=_IPP32E_E9) || \
      (_IPP32E==_IPP32E_N8)) || \
      defined(_USE_C_cpMontRedAdc_BNU_)
#define cpMontRedAdc_BNU OWNAPI(cpMontRedAdc_BNU)
void cpMontRedAdc_BNU(BNU_CHUNK_T* pR,
                      BNU_CHUNK_T* pProduct,
                const BNU_CHUNK_T* pModulus, cpSize nsM, BNU_CHUNK_T m0)
{
   BNU_CHUNK_T carry;
   BNU_CHUNK_T extension;

   cpSize n;
   for(n=0, carry = 0; n<(nsM-1); n++) {
      BNU_CHUNK_T u = pProduct[n]*m0;
      BNU_CHUNK_T t = pProduct[nsM +n +1] + carry;

      extension = cpAddMulDgt_BNU(pProduct+n, pModulus, nsM, u);
      ADD_AB(carry, pProduct[nsM+n], pProduct[nsM+n], extension);
      t += carry;

      carry = t<pProduct[nsM+n+1];
      pProduct[nsM+n+1] = t;
   }

   m0 *= pProduct[nsM-1];
   extension = cpAddMulDgt_BNU(pProduct+nsM-1, pModulus, nsM, m0);
   ADD_AB(extension, pProduct[2*nsM-1], pProduct[2*nsM-1], extension);

   carry |= extension;
   carry -= cpSub_BNU(pR, pProduct+nsM, pModulus, nsM);
   /* condition copy: R = carry? Product+mSize : R */
   MASKED_COPY_BNU(pR, carry, pProduct+nsM, pR, nsM);
}
#endif
