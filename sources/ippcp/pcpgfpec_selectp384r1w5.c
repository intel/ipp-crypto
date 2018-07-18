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
// 
//  Purpose:
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     Internal EC over GF(p^m) basic Definitions & Function Prototypes
// 
//     Context:
//        p384r1_select_ap_w5()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpmask_ct.h"

/*
// select affine point
*/
#if (_IPP32E < _IPP32E_M7)
void p384r1_select_ap_w5(BNU_CHUNK_T* pVal, const BNU_CHUNK_T* pTbl, int idx)
{
   #define OPERAND_BITSIZE (384)
   #define LEN_P384        (BITS_BNU_CHUNK(OPERAND_BITSIZE))
   #define LEN_P384_APOINT (2*LEN_P384)

   const int tblLen = 16;
   int i;
   unsigned int n;

   /* clear output affine point */
   for(n=0; n<LEN_P384_APOINT; n++)
      pVal[n] = 0;

   /* select poiint */
   for(i=1; i<=tblLen; i++) {
      BNU_CHUNK_T mask = cpIsEqu_ct(i, idx);
      for(n=0; n<LEN_P384_APOINT; n++)
         pVal[n] |= (pTbl[n] & mask);
      pTbl += LEN_P384_APOINT;
   }

   #undef OPERAND_BITSIZE
   #undef LEN_P384
   #undef LEN_P384_APOINT
}
#endif
