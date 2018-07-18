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
//     cpToOctStr_BNU()
// 
*/

#include "owncp.h"
#include "pcpbnumisc.h"


/*
// Convert BNU into HexString representation
//
// Returns length of the string or 0 if no success
*/

/*F*
//    Name: cpToOctStr_BNU
//
// Purpose: Convert BNU into HexString representation.
//
// Returns:  
//       length of the string or 0 if no success
//
// Parameters:
//    pA          pointer to the source BN A
//    nsA         size of A
//    pStr        pointer to the target octet string
//    strLen      octet string length
*F*/

cpSize cpToOctStr_BNU(Ipp8u* pStr, cpSize strLen, const BNU_CHUNK_T* pA, cpSize nsA)
{
   FIX_BNU(pA, nsA);
   {
      cpSize bnuBitSize = BITSIZE_BNU(pA, nsA);
      if(bnuBitSize <= strLen*BYTESIZE) {
         int cnvLen = 0;
         BNU_CHUNK_T x = pA[nsA-1];

         ZEXPAND_BNU(pStr, 0, strLen);
         pStr += strLen - BITS2WORD8_SIZE(bnuBitSize);

         if(x) {
            //int nb;
            cpSize nb;
            for(nb=cpNLZ_BNU(x)/BYTESIZE; nb<(cpSize)(sizeof(BNU_CHUNK_T)); cnvLen++, nb++)
               *pStr++ = EBYTE(x, sizeof(BNU_CHUNK_T)-1-nb);

            for(--nsA; nsA>0; cnvLen+=sizeof(BNU_CHUNK_T), nsA--) {
               x = pA[nsA-1];
               #if (BNU_CHUNK_BITS==BNU_CHUNK_64BIT)
               *pStr++ = EBYTE(x,7);
               *pStr++ = EBYTE(x,6);
               *pStr++ = EBYTE(x,5);
               *pStr++ = EBYTE(x,4);
               #endif
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
