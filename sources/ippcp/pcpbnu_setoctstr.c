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
//     cpFromOctStr_BNU()
// 
*/

#include "owncp.h"
#include "pcpbnumisc.h"

/*F*
//    Name: cpFromOctStr_BNU
//
// Purpose: Convert Oct String into BNU representation.
//
// Returns:                 
//          size of BNU in BNU_CHUNK_T chunks
//
// Parameters:
//    pStr        pointer to the source octet string
//    strLen      octet string length
//    pA          pointer to the target BN
//
*F*/

cpSize cpFromOctStr_BNU(BNU_CHUNK_T* pA, const Ipp8u* pStr, cpSize strLen)
{
   int nsA =0;

   /* start from the end of string */
   for(; strLen>=(int)sizeof(BNU_CHUNK_T); nsA++,strLen-=(int)(sizeof(BNU_CHUNK_T))) {
      /* pack sizeof(BNU_CHUNK_T) bytes into single BNU_CHUNK_T value*/
      *pA++ =
         #if (BNU_CHUNK_BITS==BNU_CHUNK_64BIT)
         +( (BNU_CHUNK_T)pStr[strLen-8]<<(8*7) )
         +( (BNU_CHUNK_T)pStr[strLen-7]<<(8*6) )
         +( (BNU_CHUNK_T)pStr[strLen-6]<<(8*5) )
         +( (BNU_CHUNK_T)pStr[strLen-5]<<(8*4) )
         #endif
         +( (BNU_CHUNK_T)pStr[strLen-4]<<(8*3) )
         +( (BNU_CHUNK_T)pStr[strLen-3]<<(8*2) )
         +( (BNU_CHUNK_T)pStr[strLen-2]<<(8*1) )
         +  (BNU_CHUNK_T)pStr[strLen-1];
   }

   /* convert the beginning of the string */
   if(strLen) {
      BNU_CHUNK_T x = 0;
      for(x=0; strLen>0; strLen--) {
         BNU_CHUNK_T d = *pStr++;
         x = (x<<8) + d;
       }
       *pA++ = x;
       nsA++;
   }

   return nsA;
}
