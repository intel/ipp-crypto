/*******************************************************************************
* Copyright 2012-2018 Intel Corporation
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
//     Intel(R) Integrated Performance Primitives.
//     Internal BNU32 arithmetic
// 
// 
*/

#if !defined(_CP_BNU32_ARITH_H)
#define _CP_BNU32_ARITH_H

#define cpAdd_BNU32 OWNAPI(cpAdd_BNU32)
Ipp32u  cpAdd_BNU32(Ipp32u* pR, const Ipp32u* pA, const Ipp32u* pB, int ns);
#define cpSub_BNU32 OWNAPI(cpSub_BNU32)
Ipp32u  cpSub_BNU32(Ipp32u* pR, const Ipp32u* pA, const Ipp32u* pB, int ns);
#define cpInc_BNU32 OWNAPI(cpInc_BNU32)
Ipp32u  cpInc_BNU32(Ipp32u* pR, const Ipp32u* pA, cpSize ns, Ipp32u val);
#define cpDec_BNU32 OWNAPI(cpDec_BNU32)
Ipp32u  cpDec_BNU32(Ipp32u* pR, const Ipp32u* pA, cpSize ns, Ipp32u val);

#define cpMulDgt_BNU32 OWNAPI(cpMulDgt_BNU32)
Ipp32u  cpMulDgt_BNU32(Ipp32u* pR, const Ipp32u* pA, int ns, Ipp32u val);
#define cpSubMulDgt_BNU32 OWNAPI(cpSubMulDgt_BNU32)
Ipp32u  cpSubMulDgt_BNU32(Ipp32u* pR, const Ipp32u* pA, int nsA, Ipp32u val);

#define cpDiv_BNU32 OWNAPI(cpDiv_BNU32)
int     cpDiv_BNU32(Ipp32u* pQ, int* nsQ, Ipp32u* pX, int nsX, Ipp32u* pY, int nsY);
#define cpMod_BNU32(pX,sizeX, pM,sizeM) cpDiv_BNU32(NULL,NULL, (pX),(sizeX), (pM),(sizeM))

#define cpFromOS_BNU32 OWNAPI(cpFromOS_BNU32)
int     cpFromOS_BNU32(Ipp32u* pBNU, const Ipp8u* pOctStr, int strLen);
#define cpToOS_BNU32 OWNAPI(cpToOS_BNU32)
int     cpToOS_BNU32(Ipp8u* pStr, int strLen, const Ipp32u* pBNU, int bnuSize);

#endif /* _CP_BNU32_ARITH_H */
