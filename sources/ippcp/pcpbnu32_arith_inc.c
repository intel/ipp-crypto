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
//     Internal BNU32 arithmetic.
// 
//  Contents:
//     cpInc_BNU32()
// 
*/

#include "owncp.h"
#include "pcpbnumisc.h"
#include "pcpbnu32misc.h"
#include "pcpbnu32arith.h"


/*F*
//    Name: cpInc_BNU32
//
// Purpose: BNU32 increment.
//
// Returns:
//    carry
//
// Parameters:
//    pA    source
//    pR    result
//    ns    size
//    v     borrow
//
*F*/

Ipp32u cpInc_BNU32(Ipp32u* pR, const Ipp32u* pA, cpSize ns, Ipp32u v)
{
   Ipp32u carry = v;
   cpSize i;
   for(i=0; i<ns && carry; i++) {
      Ipp64u t = (Ipp64u)carry +pA[i];
      pR[i] = LODWORD(t);
      carry = HIDWORD(t);
   }
   return carry;
}
