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
//     Internal Unsigned BNU misc functionality
// 
//  Contents:
//     cpNLZ_BNU()
// 
*/

#include "owncp.h"
#include "pcpbnumisc.h"


/*F*
//    Name: cpNLZ_BNU
//
// Purpose: Returns number of leading zeros of the BNU.
//
// Returns:
//       number of leading zeros of the BNU
//
// Parameters:
//    x         BigNum x
//
*F*/

cpSize cpNLZ_BNU(BNU_CHUNK_T x)
{
   cpSize nlz = BNU_CHUNK_BITS;
   if(x) {
      nlz = 0;
      #if (BNU_CHUNK_BITS == BNU_CHUNK_64BIT)
      if( 0==(x & 0xFFFFFFFF00000000) ) { nlz +=32; x<<=32; }
      if( 0==(x & 0xFFFF000000000000) ) { nlz +=16; x<<=16; }
      if( 0==(x & 0xFF00000000000000) ) { nlz += 8; x<<= 8; }
      if( 0==(x & 0xF000000000000000) ) { nlz += 4; x<<= 4; }
      if( 0==(x & 0xC000000000000000) ) { nlz += 2; x<<= 2; }
      if( 0==(x & 0x8000000000000000) ) { nlz++; }
      #else
      if( 0==(x & 0xFFFF0000) ) { nlz +=16; x<<=16; }
      if( 0==(x & 0xFF000000) ) { nlz += 8; x<<= 8; }
      if( 0==(x & 0xF0000000) ) { nlz += 4; x<<= 4; }
      if( 0==(x & 0xC0000000) ) { nlz += 2; x<<= 2; }
      if( 0==(x & 0x80000000) ) { nlz++; }
      #endif
   }
   return nlz;
}
