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
//     Internal Miscellaneous BNU 32 bit Definitions & Function Prototypes
// 
// 
*/

#if !defined(_CP_BNU32_MISC_H)
#define _CP_BNU32_MISC_H


/* bit operations */
#define BITSIZE_BNU32(p,ns)  ((ns)*BNU_CHUNK_32BIT-cpNLZ_BNU32((p)[(ns)-1]))

/* number of leading/trailing zeros */
#define cpNLZ_BNU32 OWNAPI(cpNLZ_BNU32)
cpSize  cpNLZ_BNU32(Ipp32u x);

/* most significant BNU bit */
__INLINE int cpMSBit_BNU32(const Ipp32u* pA, cpSize nsA)
{
   FIX_BNU(pA, nsA);
   return nsA*BITSIZE(Ipp32u) - cpNLZ_BNU32(pA[nsA-1]) -1;
}


__INLINE int cpCmp_BNU32(const Ipp32u* pA, cpSize nsA, const Ipp32u* pB, cpSize nsB)
{
   if(nsA!=nsB)
      return nsA>nsB? 1 : -1;
   else {
      for(; nsA>0; nsA--) {
         if(pA[nsA-1] > pB[nsA-1])
            return 1;
         else if(pA[nsA-1] < pB[nsA-1])
            return -1;
      }
      return 0;
   }
}

/* to/from oct string conversion */
#define cpToOctStr_BNU32 OWNAPI(cpToOctStr_BNU32)
cpSize  cpToOctStr_BNU32(Ipp8u* pStr, cpSize strLen, const Ipp32u* pBNU, cpSize bnuSize);
#define cpFromOctStr_BNU32 OWNAPI(cpFromOctStr_BNU32)
cpSize  cpFromOctStr_BNU32(Ipp32u* pBNU, const Ipp8u* pOctStr, cpSize strLen);

#endif /* _CP_BNU32_MISC_H */
