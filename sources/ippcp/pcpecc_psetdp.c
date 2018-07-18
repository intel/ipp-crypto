/*******************************************************************************
* Copyright 2003-2018 Intel Corporation
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
//     EC over Prime Finite Field (setup/retrieve domain parameters)
// 
//  Contents:
//        ECCPSetDP()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"

/*F*
//    Name: ippsECCPSet
//
// Purpose: Set EC Domain Parameters.
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pPrime
//                            NULL == pA
//                            NULL == pB
//                            NULL == pGX
//                            NULL == pGY
//                            NULL == pOrder
//                            NULL == pECC
//
//    ippStsContextMatchErr   illegal pPrime->idCtx
//                            illegal pA->idCtx
//                            illegal pB->idCtx
//                            illegal pGX->idCtx
//                            illegal pGY->idCtx
//                            illegal pOrder->idCtx
//                            illegal pECC->idCtx
//
//    ippStsRangeErr          not enough room for:
//                            pPrime
//                            pA, pB,
//                            pGX,pGY
//                            pOrder
//
//    ippStsRangeErr          0>= cofactor
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pPrime   pointer to the prime (specify FG(p))
//    pA       pointer to the A coefficient of EC equation
//    pB       pointer to the B coefficient of EC equation
//    pGX,pGY  pointer to the Base Point (x and y coordinates) of EC
//    pOrder   pointer to the Base Point order
//    cofactor cofactor value
//    pECC     pointer to the ECC context
//
*F*/
IppStatus ECCPSetDP(const IppsGFpMethod* method,
                        int pLen, const BNU_CHUNK_T* pP,
                        int aLen, const BNU_CHUNK_T* pA,
                        int bLen, const BNU_CHUNK_T* pB,
                        int xLen, const BNU_CHUNK_T* pX,
                        int yLen, const BNU_CHUNK_T* pY,
                        int rLen, const BNU_CHUNK_T* pR,
                        BNU_CHUNK_T h,
                        IppsGFpECState* pEC)
{
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   {
      IppsGFpState *   pGF = ECP_GFP(pEC);

      IppStatus sts = ippStsNoErr;
      IppsBigNumState P, H;
      int primeBitSize = BITSIZE_BNU(pP, pLen);
      //cpConstructBN(&P, pLen, (BNU_CHUNK_T*)pP, NULL);
      //sts = cpGFpSetGFp(&P, primeBitSize, method, pGF);
      cpGFpSetGFp(pP, primeBitSize, method, pGF);

      if(ippStsNoErr==sts) {
         gsModEngine* pGFE = GFP_PMA(pGF);

         do {
            int elemLen = GFP_FELEN(pGFE);
            IppsGFpElement elmA, elmB;

            /* convert A ans B coeffs into GF elements */
            cpGFpElementConstruct(&elmA, cpGFpGetPool(1, pGFE), elemLen);
            cpGFpElementConstruct(&elmB, cpGFpGetPool(1, pGFE), elemLen);
            sts = ippsGFpSetElement((Ipp32u*)pA, BITS2WORD32_SIZE(BITSIZE_BNU(pA,aLen)), &elmA, pGF);
            if(ippStsNoErr!=sts) break;
            sts = ippsGFpSetElement((Ipp32u*)pB, BITS2WORD32_SIZE(BITSIZE_BNU(pB,bLen)), &elmB, pGF);
            if(ippStsNoErr!=sts) break;
            /* and set EC */
            sts = ippsGFpECSet(&elmA, &elmB, pEC);
            if(ippStsNoErr!=sts) break;

            /* convert GX ans GY coeffs into GF elements */
            cpConstructBN(&P, rLen, (BNU_CHUNK_T*)pR, NULL);
            cpConstructBN(&H, 1, &h, NULL);
            sts = ippsGFpSetElement((Ipp32u*)pX, BITS2WORD32_SIZE(BITSIZE_BNU(pX,xLen)), &elmA, pGF);
            if(ippStsNoErr!=sts) break;
            sts = ippsGFpSetElement((Ipp32u*)pY, BITS2WORD32_SIZE(BITSIZE_BNU(pY,yLen)), &elmB, pGF);
            if(ippStsNoErr!=sts) break;
            /* and init EC subgroup */
            sts = ippsGFpECSetSubgroup(&elmA, &elmB, &P, &H, pEC);
         } while(0);

         cpGFpReleasePool(2, pGFE);
      }

      return sts;
   }
}
