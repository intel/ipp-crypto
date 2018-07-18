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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
//     EC over GF(p^m) definitinons
// 
//     Context:
//        cpGFpECGetSize()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpeccp.h"


int cpGFpECGetSize(int basicDeg, int basicElmBitSize)
{
   int ctxSize = 0;
   int elemLen = basicDeg*BITS_BNU_CHUNK(basicElmBitSize);

   int maxOrderBits = 1+ basicDeg*basicElmBitSize;
   #if defined(_LEGACY_ECCP_SUPPORT_)
   int maxOrderLen = BITS_BNU_CHUNK(maxOrderBits);
   #endif

   int modEngineCtxSize;
   if(ippStsNoErr==gsModEngineGetSize(maxOrderBits, MONT_DEFAULT_POOL_LENGTH, &modEngineCtxSize)) {

      ctxSize = sizeof(IppsGFpECState)
               +elemLen*sizeof(BNU_CHUNK_T)    /* EC coeff    A */
               +elemLen*sizeof(BNU_CHUNK_T)    /* EC coeff    B */
               +elemLen*sizeof(BNU_CHUNK_T)    /* generator G.x */
               +elemLen*sizeof(BNU_CHUNK_T)    /* generator G.y */
               +elemLen*sizeof(BNU_CHUNK_T)    /* generator G.z */
               +modEngineCtxSize               /* mont engine (R) */
               +elemLen*sizeof(BNU_CHUNK_T)    /* cofactor */
               #if defined(_LEGACY_ECCP_SUPPORT_)
               +2*elemLen*3*sizeof(BNU_CHUNK_T)    /* regular and ephemeral public  keys */
               +2*maxOrderLen*sizeof(BNU_CHUNK_T)  /* regular and ephemeral private keys */
               #endif
               +elemLen*sizeof(BNU_CHUNK_T)*3*EC_POOL_SIZE;
   }
   return ctxSize;
}
