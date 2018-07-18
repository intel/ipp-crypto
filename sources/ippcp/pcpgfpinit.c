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
//        ippsGFpInit
// 
// 
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/*F*
// Name: ippsGFpInit
//
// Purpose: initializes prime finite field GF(p)
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pGFpMethod
//                               NULL == pGFp
//
//    ippStsSizeErr              !(IPP_MIN_GF_BITSIZE <= primeBitSize <=IPP_MAX_GF_BITSIZE
//
//    ippStsContextMatchErr      invalid pPrime->idCtx
//
//    ippStsBadArgErr            pGFpMethod != ippsGFpMethod_pXXX() or != ippsGFpMethod_pArb()
//                               prime != pGFpMethod->modulus
//                               prime <0
//                               bitsize(prime) != primeBitSize
//                               prime <IPP_MIN_GF_CHAR
//                               prime is even
//
//    ippStsNoErr                no error
//
// Parameters:
//    pPrimeBN       pointer to the data representation Finite Field element
//    primeBitSize   length of Finite Field data representation array
//    pGFpMethod     pointer to Finite Field Element context
//    pGFp           pointer to Finite Field context is being initialized
*F*/
IPPFUN(IppStatus, ippsGFpInit,(const IppsBigNumState* pPrimeBN, int primeBitSize, const IppsGFpMethod* pGFpMethod, IppsGFpState* pGFp))
{
   IPP_BADARG_RET(!pPrimeBN && !pGFpMethod, ippStsNullPtrErr);

   IPP_BADARG_RET((primeBitSize< IPP_MIN_GF_BITSIZE) || (primeBitSize> IPP_MAX_GF_BITSIZE), ippStsSizeErr);

   /* use ippsGFpInitFixed() if NULL==pPrimeBN */
   if(!pPrimeBN)
      return ippsGFpInitFixed(primeBitSize, pGFpMethod, pGFp);

   /* use ippsGFpInitArbitrary() if NULL==pGFpMethod */
   if(!pGFpMethod)
      return ippsGFpInitArbitrary(pPrimeBN, primeBitSize, pGFp);

   /* test parameters if both pPrimeBN and method are defined */
   else {
      IppStatus sts;

      /* test input prime */
      pPrimeBN = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrimeBN, BN_ALIGNMENT) );
      IPP_BADARG_RET(!BN_VALID_ID(pPrimeBN), ippStsContextMatchErr);
      IPP_BADARG_RET(BN_SIGN(pPrimeBN)!= IppsBigNumPOS, ippStsBadArgErr);                                   /* prime is negative */
      IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pPrimeBN),BN_SIZE(pPrimeBN)) != primeBitSize, ippStsBadArgErr);  /* primeBitSize == bitsize(prime) */
      IPP_BADARG_RET((BN_SIZE(pPrimeBN)==1) && (BN_NUMBER(pPrimeBN)[0]<IPP_MIN_GF_CHAR), ippStsBadArgErr);  /* prime < 3 */
      IPP_BADARG_RET(0==(BN_NUMBER(pPrimeBN)[0] & 1), ippStsBadArgErr);                                     /* prime is even */

      /* test if method is prime based */
      IPP_BADARG_RET(cpID_Prime!=(pGFpMethod->modulusID & cpID_Prime), ippStsBadArgErr);

      /* test if size of the prime is matched to method's prime  */
      IPP_BADARG_RET(pGFpMethod->modulusBitDeg && (primeBitSize!=pGFpMethod->modulusBitDeg), ippStsBadArgErr);

      /* if method assumes fixed prime value */
      if(pGFpMethod->modulus) {
         int primeLen = BITS_BNU_CHUNK(primeBitSize);
         IPP_BADARG_RET(cpCmp_BNU(BN_NUMBER(pPrimeBN), primeLen, pGFpMethod->modulus, primeLen), ippStsBadArgErr);
      }

      /* init GF */
      sts = cpGFpInitGFp(primeBitSize, pGFp);

      /* set up GF  and find quadratic nonresidue */
      if(ippStsNoErr==sts) {
         cpGFpSetGFp(BN_NUMBER(pPrimeBN), primeBitSize, pGFpMethod, pGFp);
      }

      return sts;
   }
}
