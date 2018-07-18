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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
// 
//     Context:
//        ippsGFpECTstKeyPair()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"



/*F*
//    Name: ippsGFpECTstKeyPair
//
// Purpose: Test Key Pair
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pEC
//                            NULL == pPrivate
//                            NULL == pPublic
//                            NULL == pResult
//                            NULL == pScratchBuffer
//
//    ippStsContextMatchErr   illegal pEC->idCtx
//                            pEC->subgroup == NULL
//                            illegal pPrivate->idCtx
//                            illegal pPublic->idCtx
//
//    ippStsRangeErr          ECP_POINT_FELEN(pPublic)<GFP_FELEN()
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pPrivate       pointer to the private key
//    pPublic        pointer to the public  key
//    pResult        pointer to the result:
//                   ippECValid/ippECInvalidPrivateKey/ippECPointIsAtInfinite/ippECInvalidPublicKey
//    pEC            pointer to the EC context
//    pScratchBuffer pointer to buffer (1 mul_point operation)
//
*F*/
IPPFUN(IppStatus, ippsGFpECTstKeyPair, (const IppsBigNumState* pPrivate, const IppsGFpECPoint* pPublic, IppECResult* pResult,
                                        IppsGFpECState* pEC, Ipp8u* pScratchBuffer))
{
   /* EC context and buffer */
   IPP_BAD_PTR2_RET(pEC, pScratchBuffer);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);
   IPP_BADARG_RET(!ECP_SUBGROUP(pEC), ippStsContextMatchErr);

   /* test result */
   IPP_BAD_PTR1_RET(pResult);
   *pResult = ippECValid;

   /* private key validation request */
   if( pPrivate ) {
      pPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrivate, ALIGN_VAL) );
      IPP_BADARG_RET(!BN_VALID_ID(pPrivate), ippStsContextMatchErr);

      {
         BNU_CHUNK_T* pS = BN_NUMBER(pPrivate);
         int nsS = BN_SIZE(pPrivate);

         BNU_CHUNK_T* pOrder = MOD_MODULUS(ECP_MONT_R(pEC));
         int orderLen = BITS_BNU_CHUNK(ECP_ORDBITSIZE(pEC));

         /* check private key */
         if(cpEqu_BNU_CHUNK(pS, nsS, 0) || 0<=cpCmp_BNU(pS, nsS, pOrder, orderLen)) {
            *pResult = ippECInvalidPrivateKey;
            return ippStsNoErr;
         }
      }
   }

   /* public key validation request */
   if( pPublic ) {
      IPP_BADARG_RET( !ECP_POINT_TEST_ID(pPublic), ippStsContextMatchErr );
      IPP_BADARG_RET(ECP_POINT_FELEN(pPublic)<GFP_FELEN(GFP_PMA(ECP_GFP(pEC))), ippStsRangeErr);

      {
         IppsGFpECPoint T;
         cpEcGFpInitPoint(&T, cpEcGFpGetPool(1, pEC),0, pEC);

         do {
            /* public != point_at_Infinity */
            if( gfec_IsPointAtInfinity(pPublic) ) {
               *pResult = ippECPointIsAtInfinite;
               break;
            }
            /* order*public == point_at_Infinity */
            gfec_MulPoint(&T, pPublic, MOD_MODULUS(ECP_MONT_R(pEC)), BITS_BNU_CHUNK(ECP_ORDBITSIZE(pEC)), /*0,*/ pEC, pScratchBuffer);
            if( !gfec_IsPointAtInfinity(&T) ) {
               *pResult = ippECInvalidPublicKey;
               break;
            }
            /* addition test: private*BasePoint == public */
            if(pPrivate) {
               gfec_MulBasePoint(&T, BN_NUMBER(pPrivate), BN_SIZE(pPrivate), pEC, pScratchBuffer);
               if(!gfec_ComparePoint(&T, pPublic, pEC))
                  *pResult = ippECInvalidKeyPair;
            }
         } while(0);

         cpEcGFpReleasePool(1, pEC);
      }
   }

   return ippStsNoErr;
}
