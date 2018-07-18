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
//     Operations over GF(p) ectension.
// 
//     Context:
//        pcpgfpec_initgfpxctx.c()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/* the "static" specificator removed because of incorrect result under Linux-32, p8
   what's wrong? not know maybe compiler (icl 2017)
   need to check after switchng on icl 2018
   */
/*static*/ 
void InitGFpxCtx(const IppsGFpState* pGroundGF, int extDeg, const IppsGFpMethod* method, IppsGFpState* pGFpx)
{
   gsModEngine* pGFEp = GFP_PMA(pGroundGF);
   int elemLen = extDeg * GFP_FELEN(pGFEp);
   int elemLen32 = extDeg * GFP_FELEN32(pGFEp);

   Ipp8u* ptr = (Ipp8u*)pGFpx + sizeof(IppsGFpState);

   /* context identifier */
   GFP_ID(pGFpx) = idCtxGFP;
   GFP_PMA(pGFpx) = (gsModEngine*)ptr;
   {
      gsModEngine* pGFEx = GFP_PMA(pGFpx);

      /* clear whole context */
      PaddBlock(0, ptr, sizeof(gsModEngine));
      ptr += sizeof(gsModEngine);

      GFP_PARENT(pGFEx)    = pGFEp;
      GFP_EXTDEGREE(pGFEx) = extDeg;
      GFP_FEBITLEN(pGFEx)  = 0;//elemBitLen;
      GFP_FELEN(pGFEx)     = elemLen;
      GFP_FELEN32(pGFEx)   = elemLen32;
      GFP_PELEN(pGFEx)     = elemLen;
      GFP_METHOD(pGFEx)    = method->arith;
      GFP_MODULUS(pGFEx)   = (BNU_CHUNK_T*)(ptr);  ptr += elemLen * sizeof(BNU_CHUNK_T);  /* field polynomial */
      GFP_POOL(pGFEx)      = (BNU_CHUNK_T*)(ptr);                                         /* pool */
      GFP_MAXPOOL(pGFEx)   = GFPX_POOL_SIZE;
      GFP_USEDPOOL(pGFEx)  = 0;

      cpGFpElementPadd(GFP_MODULUS(pGFEx), elemLen, 0);
   }
}
