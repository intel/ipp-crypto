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
//        ippsGFpECInitStd521r1()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpeccp.h"




static void cpGFpECSetStd(int aLen, const BNU_CHUNK_T* pA,
                          int bLen, const BNU_CHUNK_T* pB,
                          int xLen, const BNU_CHUNK_T* pX,
                          int yLen, const BNU_CHUNK_T* pY,
                          int rLen, const BNU_CHUNK_T* pR,
                          BNU_CHUNK_T h,
                          IppsGFpECState* pEC)
{
   IppsGFpState* pGF = ECP_GFP(pEC);
   gsModEngine* pGFE = GFP_PMA(pGF);
   int elemLen = GFP_FELEN(pGFE);

   IppsGFpElement elmA, elmB;
   IppsBigNumState R, H;

   /* convert A ans B coeffs into GF elements */
   cpGFpElementConstruct(&elmA, cpGFpGetPool(1, pGFE), elemLen);
   cpGFpElementConstruct(&elmB, cpGFpGetPool(1, pGFE), elemLen);
   ippsGFpSetElement((Ipp32u*)pA, BITS2WORD32_SIZE(BITSIZE_BNU(pA,aLen)), &elmA, pGF);
   ippsGFpSetElement((Ipp32u*)pB, BITS2WORD32_SIZE(BITSIZE_BNU(pB,bLen)), &elmB, pGF);
   /* and set EC */
   ippsGFpECSet(&elmA, &elmB, pEC);

   /* construct R and H */
   cpConstructBN(&R, rLen, (BNU_CHUNK_T*)pR, NULL);
   cpConstructBN(&H, 1, &h, NULL);
   /* convert GX ans GY coeffs into GF elements */
   ippsGFpSetElement((Ipp32u*)pX, BITS2WORD32_SIZE(BITSIZE_BNU(pX,xLen)), &elmA, pGF);
   ippsGFpSetElement((Ipp32u*)pY, BITS2WORD32_SIZE(BITSIZE_BNU(pY,yLen)), &elmB, pGF);
   /* and init EC subgroup */
   ippsGFpECSetSubgroup(&elmA, &elmB, &R, &H, pEC);
}

/*F*
// Name: ippsGFpECInitStd521r1
//
// Purpose: Initializes the context of EC521r1
//
// Returns:                   Reason:
//    ippStsNullPtrErr              NULL == pEC
//                                  NULL == pGFp
//
//    ippStsContextMatchErr         invalid pGFp->idCtx
//
//    ippStsBadArgErr               pGFp does not specify the finite field over which the given
//                                  standard elliptic curve is defined
//
//    ippStsNoErr                   no error
//
// Parameters:
//    pGFp       Pointer to the IppsGFpState context of the underlying finite field
//    pEC        Pointer to the context of the elliptic curve being initialized.
//
*F*/

IPPFUN(IppStatus, ippsGFpECInitStd521r1,(const IppsGFpState* pGF, IppsGFpECState* pEC))
{
   IPP_BAD_PTR2_RET(pGF, pEC);

   pGF = (IppsGFpState*)( IPP_ALIGNED_PTR(pGF, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGF), ippStsContextMatchErr );

   {
      gsModEngine* pGFE = GFP_PMA(pGF);

      /* test if GF is prime GF */
      IPP_BADARG_RET(!GFP_IS_BASIC(pGFE), ippStsBadArgErr);
      /* test underlying prime value*/
      IPP_BADARG_RET(cpCmp_BNU(secp521r1_p, BITS_BNU_CHUNK(521), GFP_MODULUS(pGFE), BITS_BNU_CHUNK(521)), ippStsBadArgErr);

      pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );

      ippsGFpECInit(pGF, NULL, NULL, pEC);
      cpGFpECSetStd(BITS_BNU_CHUNK(521), secp521r1_a,
                    BITS_BNU_CHUNK(521), secp521r1_b,
                    BITS_BNU_CHUNK(521), secp521r1_gx,
                    BITS_BNU_CHUNK(521), secp521r1_gy,
                    BITS_BNU_CHUNK(521), secp521r1_r,
                    secp521r1_h,
                    pEC);

      return ippStsNoErr;
   }
}
