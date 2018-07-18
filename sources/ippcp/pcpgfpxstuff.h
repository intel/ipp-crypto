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
//               Intel(R) Integrated Performance Primitives
//               Cryptographic Primitives (ippCP)
//               GF(p) extension internal
// 
*/

#if !defined(_PCP_GFPEXT_H_)
#define _PCP_GFPEXT_H_

#include "pcpgfpstuff.h"


/* GF(p^d) pool */
#define GFPX_PESIZE(pGF)   GFP_FELEN((pGF))
#define GFPX_POOL_SIZE     (14) //(8)   /* Number of temporary variables in pool */

/* address of ground field element inside expanded field element */
#define GFPX_IDX_ELEMENT(pxe, idx, eleSize) ((pxe)+(eleSize)*(idx))


__INLINE int degree(const BNU_CHUNK_T* pE, const gsModEngine* pGFEx)
{
    int groundElemLen = GFP_FELEN(GFP_PARENT(pGFEx));
    int deg;
    for(deg=GFP_EXTDEGREE(pGFEx)-1; deg>=0; deg-- ) {
        if(!GFP_IS_ZERO(pE+groundElemLen*deg, groundElemLen)) break;
    }
    return deg;
}

__INLINE gsModEngine* cpGFpBasic(const gsModEngine* pGFEx)
{
   while( !GFP_IS_BASIC(pGFEx) ) {
      pGFEx = GFP_PARENT(pGFEx);
   }
   return (gsModEngine*)pGFEx;
}
__INLINE int cpGFpBasicDegreeExtension(const gsModEngine* pGFEx)
{
   int degree = GFP_EXTDEGREE(pGFEx);
   while( !GFP_IS_BASIC(pGFEx) ) {
      pGFEx = GFP_PARENT(pGFEx);
      degree *= GFP_EXTDEGREE(pGFEx);
   }
   return degree;
}

/* convert external data (Ipp32u) => internal element (BNU_CHUNK_T) representation
   returns length of element (in BNU_CHUNK_T)
*/
__INLINE int cpGFpxCopyToChunk(BNU_CHUNK_T* pElm, const Ipp32u* pA, int nsA, const gsModEngine* pGFEx)
{
   gsModEngine* pBasicGFE = cpGFpBasic(pGFEx);
   int basicExtension = cpGFpBasicDegreeExtension(pGFEx);
   int basicElmLen32 = GFP_FELEN32(pBasicGFE);
   int basicElmLen = GFP_FELEN(pBasicGFE);
   int deg;
   for(deg=0; deg<basicExtension && nsA>0; deg++, nsA -= basicElmLen32) {
      int srcLen = IPP_MIN(nsA, basicElmLen32);
      ZEXPAND_COPY_BNU((Ipp32u*)pElm, basicElmLen*(int)(sizeof(BNU_CHUNK_T)/sizeof(Ipp32u)), pA,srcLen);
      pElm += basicElmLen;
      pA += basicElmLen32;
   }
   return basicElmLen*deg;
}

/* convert internal element (BNU_CHUNK_T) => external data (Ipp32u) representation
   returns length of data (in Ipp32u)
*/
__INLINE int cpGFpxCopyFromChunk(Ipp32u* pA, const BNU_CHUNK_T* pElm, const gsModEngine* pGFEx)
{
   gsModEngine* pBasicGFE = cpGFpBasic(pGFEx);
   int basicExtension = cpGFpBasicDegreeExtension(pGFEx);
   int basicElmLen32 = GFP_FELEN32(pBasicGFE);
   int basicElmLen = GFP_FELEN(pBasicGFE);
   int deg;
   for(deg=0; deg<basicExtension; deg++) {
      COPY_BNU(pA, (Ipp32u*)pElm, basicElmLen32);
      pA += basicElmLen32;
      pElm += basicElmLen;
   }
   return basicElmLen32*deg;
}


#define      cpGFpxRand OWNAPI(cpGFpxRand)
BNU_CHUNK_T* cpGFpxRand(BNU_CHUNK_T* pR, gsModEngine* pGFEx, IppBitSupplier rndFunc, void* pRndParam);

#define      cpGFpxSet OWNAPI(cpGFpxSet)
BNU_CHUNK_T* cpGFpxSet (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pDataA, int nsA, gsModEngine* pGFEx);

#define      cpGFpxGet OWNAPI(cpGFpxGet)
BNU_CHUNK_T* cpGFpxGet (BNU_CHUNK_T* pDataA, int nsA, const BNU_CHUNK_T* pR, gsModEngine* pGFEx);

#define      cpGFpxSetPolyTerm OWNAPI(cpGFpxSetPolyTerm)
BNU_CHUNK_T* cpGFpxSetPolyTerm (BNU_CHUNK_T* pR, int deg, const BNU_CHUNK_T* pDataA, int nsA, gsModEngine* pGFEx);

#define      cpGFpxGetPolyTerm OWNAPI(cpGFpxGetPolyTerm)
BNU_CHUNK_T* cpGFpxGetPolyTerm (BNU_CHUNK_T* pDataA, int nsA, const BNU_CHUNK_T* pR, int deg, gsModEngine* pGFEx);

#define      cpGFpxAdd OWNAPI(cpGFpxAdd)
BNU_CHUNK_T* cpGFpxAdd     (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pB, gsModEngine* pGFEx);

#define      cpGFpxSub OWNAPI(cpGFpxSub)
BNU_CHUNK_T* cpGFpxSub     (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pB, gsModEngine* pGFEx);

#define      cpGFpxMul OWNAPI(cpGFpxMul)
BNU_CHUNK_T* cpGFpxMul     (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pB, gsModEngine* pGFEx);

#define      cpGFpxSqr OWNAPI(cpGFpxSqr)
BNU_CHUNK_T* cpGFpxSqr     (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsModEngine* pGFEx);

#define      cpGFpxAdd_GFE OWNAPI(cpGFpxAdd_GFE)
BNU_CHUNK_T* cpGFpxAdd_GFE (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pGroundB, gsModEngine* pGFEx);

#define      cpGFpxSub_GFE OWNAPI(cpGFpxSub_GFE)
BNU_CHUNK_T* cpGFpxSub_GFE (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pGroundB, gsModEngine* pGFEx);

#define      cpGFpxMul_GFE OWNAPI(cpGFpxMul_GFE)
BNU_CHUNK_T* cpGFpxMul_GFE (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pGroundB, gsModEngine* pGFEx);

#define cpGFpGetOptimalWinSize OWNAPI(cpGFpGetOptimalWinSize)
int     cpGFpGetOptimalWinSize(int bitsize);

#define      cpGFpxExp OWNAPI(cpGFpxExp)
BNU_CHUNK_T* cpGFpxExp     (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, const BNU_CHUNK_T* pE, int nsE, gsModEngine* pGFEx, Ipp8u* pScratchBuffer);

#define      cpGFpxMultiExp OWNAPI(cpGFpxMultiExp)
BNU_CHUNK_T* cpGFpxMultiExp(BNU_CHUNK_T* pR, const BNU_CHUNK_T* ppA[], const BNU_CHUNK_T* ppE[], int nsE[], int nItems,
                          gsModEngine* pGFEx, Ipp8u* pScratchBuffer);

#define      cpGFpxConj OWNAPI(cpGFpxConj)
BNU_CHUNK_T* cpGFpxConj(BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsModEngine* pGFEx);

#define      cpGFpxNeg OWNAPI(cpGFpxNeg)
BNU_CHUNK_T* cpGFpxNeg (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsModEngine* pGFEx);

#define      cpGFpxInv OWNAPI(cpGFpxInv)
BNU_CHUNK_T* cpGFpxInv (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsModEngine* pGFEx);

#define      cpGFpxHalve OWNAPI(cpGFpxHalve)
BNU_CHUNK_T* cpGFpxHalve (BNU_CHUNK_T* pR, const BNU_CHUNK_T* pA, gsModEngine* pGFEx);

#define InitGFpxCtx OWNAPI(InitGFpxCtx)
void InitGFpxCtx(const IppsGFpState* pGroundGF, int extDeg, const IppsGFpMethod* method, IppsGFpState* pGFpx);

#endif /* _PCP_GFPEXT_H_ */
