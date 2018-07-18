/*******************************************************************************
* Copyright 2004-2018 Intel Corporation
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
//     PRNG Functions
// 
//  Contents:
//        cpPRNGenRange()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcphash.h"
#include "pcpprng.h"
#include "pcptool.h"

/* generates random string of specified bitSize length
   within specified ragnge lo < r < Hi
   returns:
      0 random bit string not generated
      1 random bit string generated
     -1 detected internal error (ippStsNoErr != rndFunc())
*/
int cpPRNGenRange(BNU_CHUNK_T* pRand,
            const BNU_CHUNK_T* pLo, cpSize loLen,
            const BNU_CHUNK_T* pHi, cpSize hiLen,
                  IppBitSupplier rndFunc, void* pRndParam)
{
   int bitSize = BITSIZE_BNU(pHi,hiLen);
   BNU_CHUNK_T topMask = MASK_BNU_CHUNK(bitSize);

   #define MAX_COUNT (1000)
   int n;
   for(n=0; n<MAX_COUNT; n++) {
      cpSize randLen;
      IppStatus sts = rndFunc((Ipp32u*)pRand, bitSize, pRndParam);
      if(ippStsNoErr!=sts) return -1;

      pRand[hiLen-1] &= topMask;
      randLen = cpFix_BNU(pRand, hiLen);
      if((0 < cpCmp_BNU(pRand, randLen, pLo, loLen)) && (0 < cpCmp_BNU(pHi, hiLen, pRand, randLen)))
         return 1;
   }
   #undef MAX_COUNT

   return 0; /* no random matched to (Lo,Hi) */
}
