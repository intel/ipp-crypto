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
//    Name: cpFromOctStr_BNU32
//
// Purpose: Convert Oct String into BNU representation.
//
// Returns:
//          size of BNU in BNU_CHUNK_T chunks
//
// Parameters:
//    pOctStr     pointer to the source octet string
//    strLen      octet string length
//    pBNU        pointer to the target BN
//
*F*/

cpSize cpFromOctStr_BNU32(Ipp32u* pBNU, const Ipp8u* pOctStr, cpSize strLen)
{
   cpSize bnuSize=0;
   *pBNU = 0;

   /* start from the end of string */
   for(; strLen>=4; bnuSize++,strLen-=4) {
      /* pack 4 bytes into single Ipp32u value*/
      *pBNU++ = ( pOctStr[strLen-4]<<(8*3) )
               +( pOctStr[strLen-3]<<(8*2) )
               +( pOctStr[strLen-2]<<(8*1) )
               +  pOctStr[strLen-1];
   }

   /* convert the beginning of the string */
   if(strLen) {
      Ipp32u x;
      for(x=0; strLen>0; strLen--) {
         Ipp32u d = *pOctStr++;
         x = x*256 + d;
       }
       *pBNU++ = x;
       bnuSize++;
   }

   return bnuSize? bnuSize : 1;
}
