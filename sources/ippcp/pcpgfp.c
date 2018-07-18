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
//     Operations over GF(p).
// 
//     Context:
//        cpGFpGetSize()
//        cpGFpInitGFp()
// 
// 
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/*
// size of GFp engine context (Montgomery)
*/
int cpGFpGetSize(int feBitSize, int peBitSize, int numpe)
{
   int ctxSize = 0;
   int elemLen = BITS_BNU_CHUNK(feBitSize);
   int pelmLen = BITS_BNU_CHUNK(peBitSize);
   
   /* size of GFp engine */
   ctxSize = sizeof(gsModEngine)
            + elemLen*sizeof(BNU_CHUNK_T)    /* modulus  */
            + elemLen*sizeof(BNU_CHUNK_T)    /* mont_R   */
            + elemLen*sizeof(BNU_CHUNK_T)    /* mont_R^2 */
            + elemLen*sizeof(BNU_CHUNK_T)    /* half of modulus */
            + elemLen*sizeof(BNU_CHUNK_T)    /* quadratic non-residue */
            + pelmLen*sizeof(BNU_CHUNK_T)*numpe; /* pool */

   ctxSize += sizeof(IppsGFpState);   /* size of IppsGFPState */
   return ctxSize;
}

/*
// init GFp engine context (Montgomery)
*/
static void cpGFEInit(gsModEngine* pGFE, int modulusBitSize, int peBitSize, int numpe)
{
   int modLen  = BITS_BNU_CHUNK(modulusBitSize);
   int pelmLen = BITS_BNU_CHUNK(peBitSize);

   Ipp8u* ptr = (Ipp8u*)pGFE;

   /* clear whole context */
   PaddBlock(0, ptr, sizeof(gsModEngine));
   ptr += sizeof(gsModEngine);

   GFP_PARENT(pGFE)    = NULL;
   GFP_EXTDEGREE(pGFE) = 1;
   GFP_FEBITLEN(pGFE)  = modulusBitSize;
   GFP_FELEN(pGFE)     = modLen;
   GFP_FELEN32(pGFE)   = BITS2WORD32_SIZE(modulusBitSize);
   GFP_PELEN(pGFE)     = pelmLen;
 //GFP_METHOD(pGFE)    = method;
   GFP_MODULUS(pGFE)   = (BNU_CHUNK_T*)(ptr);   ptr += modLen*sizeof(BNU_CHUNK_T);
   GFP_MNT_R(pGFE)     = (BNU_CHUNK_T*)(ptr);   ptr += modLen*sizeof(BNU_CHUNK_T);
   GFP_MNT_RR(pGFE)    = (BNU_CHUNK_T*)(ptr);   ptr += modLen*sizeof(BNU_CHUNK_T);
   GFP_HMODULUS(pGFE)  = (BNU_CHUNK_T*)(ptr);   ptr += modLen*sizeof(BNU_CHUNK_T);
   GFP_QNR(pGFE)       = (BNU_CHUNK_T*)(ptr);   ptr += modLen*sizeof(BNU_CHUNK_T);
   GFP_POOL(pGFE)      = (BNU_CHUNK_T*)(ptr);/* ptr += modLen*sizeof(BNU_CHUNK_T);*/
   GFP_MAXPOOL(pGFE)   = numpe;
   GFP_USEDPOOL(pGFE)  = 0;

   cpGFpElementPadd(GFP_MODULUS(pGFE), modLen, 0);
   cpGFpElementPadd(GFP_MNT_R(pGFE), modLen, 0);
   cpGFpElementPadd(GFP_MNT_RR(pGFE), modLen, 0);
   cpGFpElementPadd(GFP_HMODULUS(pGFE), modLen, 0);
   cpGFpElementPadd(GFP_QNR(pGFE), modLen, 0);
}

IppStatus cpGFpInitGFp(int primeBitSize, IppsGFpState* pGF)
{
   IPP_BADARG_RET((primeBitSize< IPP_MIN_GF_BITSIZE) || (primeBitSize> IPP_MAX_GF_BITSIZE), ippStsSizeErr);
   IPP_BAD_PTR1_RET(pGF);
   pGF = (IppsGFpState*)( IPP_ALIGNED_PTR(pGF, GFP_ALIGNMENT) );

   {
      Ipp8u* ptr = (Ipp8u*)pGF;

      GFP_ID(pGF)      = idCtxGFP;
      GFP_PMA(pGF) = (gsModEngine*)(ptr+sizeof(IppsGFpState));
      cpGFEInit(GFP_PMA(pGF), primeBitSize, primeBitSize+BITSIZE(BNU_CHUNK_T), GFP_POOL_SIZE);

      return ippStsNoErr;
   }
}
