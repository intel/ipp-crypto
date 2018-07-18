/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Internal Unsigned arithmetic
// 
//  Contents:
//     cpSqrAdc_BNU_school()
// 
*/

#include "owncp.h"
#include "pcpbnuarith.h"
#include "pcpbnumisc.h"


/*F*
//    Name: cpSqrAdc_BNU_school
//
// Purpose: Square BigNums.
//
// Returns:
//    extension of result of square BigNum
//
// Parameters:
//    pA    source BigNum
//    pR    resultant BigNum
//    nsA   size of A
//
*F*/
#if defined(_USE_C_cpSqrAdc_BNU_school_)
#pragma message ("C version of cpSqrAdc_BNU_school: ON")
#else
#pragma message ("C version of cpSqrAdc_BNU_school: OFF")
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
      defined(_USE_C_cpSqrAdc_BNU_school_)
BNU_CHUNK_T cpSqrAdc_BNU_school(BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, cpSize nsA)
{
   cpSize i;

   BNU_CHUNK_T extension;
   BNU_CHUNK_T rH, rL;

   /* init result */
   pR[0] = 0;
   for(i=1, extension=0; i<nsA; i++) {
      MUL_AB(rH, rL, pA[i], pA[0]);
      ADD_AB(extension, pR[i], rL, extension);
      extension += rH;
   }
   pR[i] = extension;

   /* add other a[i]*a[j] */
   for(i=1; i<nsA-1; i++) {
      BNU_CHUNK_T a = pA[i];
      cpSize j;
      for(j=i+1, extension=0; j<nsA; j++) {
         MUL_AB(rH, rL, pA[j], a);
         ADD_ABC(extension, pR[i+j], rL, pR[i+j], extension);
         extension += rH;
      }
      pR[i+j] = extension;
   }

   /* double a[i]*a[j] */
   for(i=1, extension=0; i<(2*nsA-1); i++) {
      ADD_ABC(extension, pR[i], pR[i], pR[i], extension);
   }
   pR[i] = extension;

   /* add a[i]^2 */
   for(i=0, extension=0; i<nsA; i++) {
      MUL_AB(rH, rL, pA[i], pA[i]);
      ADD_ABC(extension, pR[2*i], pR[2*i], rL, extension);
      ADD_ABC(extension, pR[2*i+1], pR[2*i+1], rH, extension);
   }
   return pR[2*nsA-1];
}
#endif
