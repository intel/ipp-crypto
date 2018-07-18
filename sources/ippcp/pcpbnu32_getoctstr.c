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
//     Unsigned internal BNU32 misc functionality
// 
//  Contents:
//     cpToOctStr_BNU32()
// 
*/

#include "owncp.h"
#include "pcpbnuimpl.h"
#include "pcpbnumisc.h"
#include "pcpbnu32misc.h"

/*F*
//    Name: cpToOctStr_BNU32
//
// Purpose: Convert BNU into HexString representation.
//
// Returns:
//       length of the string or 0 if no success
//
// Parameters:
//    pBNU        pointer to the source BN
//    bnuSize     size of BN
//    pStr        pointer to the target octet string
//    strLen      octet string length
*F*/

cpSize cpToOctStr_BNU32(Ipp8u* pStr, cpSize strLen, const Ipp32u* pBNU, cpSize bnuSize)
{
   FIX_BNU(pBNU, bnuSize);
   {
      int bnuBitSize = BITSIZE_BNU32(pBNU, bnuSize);
      if(bnuBitSize <= strLen*BYTESIZE) {
         Ipp32u x = pBNU[bnuSize-1];

         ZEXPAND_BNU(pStr, 0, strLen);
         pStr += strLen - BITS2WORD8_SIZE(bnuBitSize);

         if(x) {
            int nb;
            for(nb=cpNLZ_BNU32(x)/BYTESIZE; nb<4; nb++)
               *pStr++ = EBYTE(x,3-nb);

            for(--bnuSize; bnuSize>0; bnuSize--) {
               x = pBNU[bnuSize-1];
               *pStr++ = EBYTE(x,3);
               *pStr++ = EBYTE(x,2);
               *pStr++ = EBYTE(x,1);
               *pStr++ = EBYTE(x,0);
            }
         }
         return strLen;
      }
      else
         return 0;
   }
}
