/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
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
//     Internal Definitions of SSE Montgomery Exp
//
*/
#include "owncp.h"

#if (_IPP>=_IPP_W7)

#include "pcpbnuimpl.h"
#include "pcpngmontexpstuff.h"

#define RSA_SSE2_MIN_BITSIZE  (256)
#define RSA_SSE2_MAX_BITSIZE  (13*1024)

#define NORM_DIGSIZE_SSE2 (BITSIZE(Ipp32u))
#define NORM_BASE_SSE2   ((Ipp64u)1<<NORM_DIGSIZE_SSE2)
#define NORM_MASK_SSE2 (NORM_BASE_SSE2-1)

#define EXP_DIGIT_SIZE_SSE2   (27)
#define EXP_DIGIT_BASE_SSE2   (1<<EXP_DIGIT_SIZE_SSE2)
#define EXP_DIGIT_MASK_SSE2   (EXP_DIGIT_BASE_SSE2-1)


/* number of "diSize" chunks in "bitSize" bit string */
__INLINE int cpDigitNum_sse2(int bitSize, int digSize)
{ return (bitSize + digSize-1)/digSize; }

/* number of "RSA_SSE2_DIGIT_SIZE" chunks in "bitSize" bit string matched for AMM */
__INLINE cpSize numofVariable_sse2(int modulusBits)
{
   cpSize ammBitSize = 2 + cpDigitNum_sse2(modulusBits, BITSIZE(BNU_CHUNK_T)) * BITSIZE(BNU_CHUNK_T);
   cpSize redNum = cpDigitNum_sse2(ammBitSize, EXP_DIGIT_SIZE_SSE2);
   return redNum;
}

/* buffer corresponding to numofVariable_sse2() */
__INLINE cpSize numofVariableBuff_sse2(int numV)
{
   return numV +4 +(numV&1);
}

/* exponentiation buffer size */
#define gsMontExpBinBuffer_sse2 OWNAPI(gsMontExpBinBuffer_sse2)
#define gsMontExpWinBuffer_sse2 OWNAPI(gsMontExpWinBuffer_sse2)
cpSize  gsMontExpBinBuffer_sse2(int modulusBits);
cpSize  gsMontExpWinBuffer_sse2(int modulusBits);

/* exponentiations */
#define gsMontExpBin_BNU_sse2 OWNAPI(gsMontExpBin_BNU_sse2)
cpSize  gsMontExpBin_BNU_sse2(BNU_CHUNK_T* dataY,
                        const BNU_CHUNK_T* dataX, cpSize nsX,
                        const BNU_CHUNK_T* dataE, cpSize nsE,
                              gsModEngine* pMont,
                              BNU_CHUNK_T* pBufferT);

#define gsMontExpBin_BNU_sscm_sse2 OWNAPI(gsMontExpBin_BNU_sscm_sse2)
cpSize  gsMontExpBin_BNU_sscm_sse2(BNU_CHUNK_T* dataY,
                        const BNU_CHUNK_T* dataX, cpSize nsX,
                        const BNU_CHUNK_T* dataE, cpSize nsE,
                              gsModEngine* pMont,
                              BNU_CHUNK_T* pBufferT);

#define gsMontExpWin_BNU_sse2 OWNAPI(gsMontExpWin_BNU_sse2)
cpSize  gsMontExpWin_BNU_sse2(BNU_CHUNK_T* dataY,
                             const BNU_CHUNK_T* dataX, cpSize nsX,
                             const BNU_CHUNK_T* dataE, cpSize nsE,
                                   gsModEngine* pMont,
                                   BNU_CHUNK_T* pBufferT);

#define gsMontExpWin_BNU_sscm_sse2 OWNAPI(gsMontExpWin_BNU_sscm_sse2)
cpSize  gsMontExpWin_BNU_sscm_sse2(BNU_CHUNK_T* dataY,
                             const BNU_CHUNK_T* dataX, cpSize nsX,
                             const BNU_CHUNK_T* dataE, cpSize nsE,
                                   gsModEngine* pMont,
                                   BNU_CHUNK_T* pBuffer);

#endif /* _IPP_W7 */
