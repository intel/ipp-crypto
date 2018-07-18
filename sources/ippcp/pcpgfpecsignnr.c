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
//        ippsGFpECSignNR()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"

/*F*
//    Name: ippsGFpECSignNR
//
// Purpose: NR Signature Generation.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pEC
//                               NULL == pMsgDigest
//                               NULL == pRegPrivate
//                               NULL == pEphPrivate
//                               NULL == pSignR
//                               NULL == pSignS
//                               NULL == pScratchBuffer
//
//    ippStsContextMatchErr      illegal pEC->idCtx
//                               pEC->subgroup == NULL
//                               illegal pMsgDigest->idCtx
//                               illegal pRegPrivate->idCtx
//                               illegal pEphPrivate->idCtx
//                               illegal pSignR->idCtx
//                               illegal pSignS->idCtx
//
//    ippStsMessageErr           Msg < 0, Msg >= order
//
//    ippStsRangeErr             not enough room for:
//                               signC
//                               signD
//
//    ippStsErr                  (0==signR) || (0==signS)
//
//    ippStsNotSupportedModeErr  1<GFP_EXTDEGREE(pGFE)
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsgDigest     pointer to the message representative to be signed
//    pRegPrivate    pointer to the regular private key
//    pEphPrivate    pointer to the ephemeral private key
//    pSignR,pSignS  pointer to the signature
//    pEC            pointer to the EC context
//    pScratchBuffer pointer to buffer (1 mul_point operation)
//
*F*/
IPPFUN(IppStatus, ippsGFpECSignNR,(const IppsBigNumState* pMsgDigest,
                                   const IppsBigNumState* pRegPrivate,
                                   const IppsBigNumState* pEphPrivate,
                                   IppsBigNumState* pSignR, IppsBigNumState* pSignS,
                                   IppsGFpECState* pEC,
                                   Ipp8u* pScratchBuffer))
{
   IppsGFpState*  pGF;
   gsModEngine* pGFE;

   /* EC context and buffer */
   IPP_BAD_PTR2_RET(pEC, pScratchBuffer);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);
   IPP_BADARG_RET(!ECP_SUBGROUP(pEC), ippStsContextMatchErr);

   pGF = ECP_GFP(pEC);
   pGFE = GFP_PMA(pGF);
   IPP_BADARG_RET(1<GFP_EXTDEGREE(pGFE), ippStsNotSupportedModeErr);

   /* test message representative */
   IPP_BAD_PTR1_RET(pMsgDigest);
   pMsgDigest = (IppsBigNumState*)( IPP_ALIGNED_PTR(pMsgDigest, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pMsgDigest), ippStsContextMatchErr);

   /* test signature */
   IPP_BAD_PTR2_RET(pSignR, pSignS);
   pSignR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignR, BN_ALIGNMENT) );
   pSignS = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignS, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pSignR), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pSignS), ippStsContextMatchErr);
   IPP_BADARG_RET((BN_ROOM(pSignR)*BITSIZE(BNU_CHUNK_T)<ECP_ORDBITSIZE(pEC)), ippStsRangeErr);
   IPP_BADARG_RET((BN_ROOM(pSignS)*BITSIZE(BNU_CHUNK_T)<ECP_ORDBITSIZE(pEC)), ippStsRangeErr);

   /* test private keys */
   IPP_BAD_PTR2_RET(pRegPrivate, pEphPrivate);
   pRegPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pRegPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pRegPrivate), ippStsContextMatchErr);
   pEphPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pEphPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pEphPrivate), ippStsContextMatchErr);

   {
      gsModEngine* pMontR = ECP_MONT_R(pEC);
      BNU_CHUNK_T* pOrder = MOD_MODULUS(pMontR);
      int orderLen = MOD_LEN(pMontR);

      BNU_CHUNK_T* dataC = BN_NUMBER(pSignR);
      BNU_CHUNK_T* dataD = BN_NUMBER(pSignS);
      BNU_CHUNK_T* buffD = BN_BUFFER(pSignS);

      /* test value of private keys: regPrivate<order, ephPrivate<order */
      IPP_BADARG_RET(BN_NEGATIVE(pRegPrivate) ||
                     (0<=cpCmp_BNU(BN_NUMBER(pRegPrivate), BN_SIZE(pRegPrivate), pOrder, orderLen)), ippStsIvalidPrivateKey);
      IPP_BADARG_RET(BN_NEGATIVE(pEphPrivate) ||
                     (0<=cpCmp_BNU(BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate), pOrder, orderLen)), ippStsIvalidPrivateKey);
      /* test mesage: 0<msg<order */
      IPP_BADARG_RET(BN_NEGATIVE(pMsgDigest) ||
                     (0<=cpCmp_BNU(BN_NUMBER(pMsgDigest), BN_SIZE(pMsgDigest), pOrder, orderLen)), ippStsMessageErr);

      {
         int elmLen = GFP_FELEN(pGFE);
         int ns;

         /* compute ephemeral public key */
         IppsGFpECPoint ephPublic;
         cpEcGFpInitPoint(&ephPublic, cpEcGFpGetPool(1, pEC), 0, pEC);
         gfec_MulBasePoint(&ephPublic,
                           BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate),
                           pEC, pScratchBuffer);

         /* x = (ephPublic.x) mod order */
         gfec_GetPoint(dataC, NULL, &ephPublic, pEC);
         GFP_METHOD(pGFE)->decode(dataC, dataC, pGFE);
         ns = cpMod_BNU(dataC, elmLen, pOrder, orderLen);
         cpGFpElementPadd(dataC+ns, orderLen-ns, 0);

         cpEcGFpReleasePool(1, pEC);

         /* C = (ephPublic.x + msg) mod order */
         ZEXPAND_COPY_BNU(dataD, orderLen, BN_NUMBER(pMsgDigest), BN_SIZE(pMsgDigest));
         cpModAdd_BNU(dataC, dataC, dataD, pOrder, orderLen, dataD);

         /* check c!=0 */
         if(GFP_IS_ZERO(dataC, orderLen)) return ippStsErr;

         /* D = (ephPrivate - regPrivate*C) mod order */
         ZEXPAND_COPY_BNU(buffD, orderLen, BN_NUMBER(pRegPrivate),BN_SIZE(pRegPrivate));
         cpMontEnc_BNU_EX(dataD, buffD, orderLen, pMontR);
         cpMontMul_BNU(buffD, dataD, dataC, pMontR);
         ZEXPAND_COPY_BNU(dataD, orderLen, BN_NUMBER(pEphPrivate),BN_SIZE(pEphPrivate));
         cpModSub_BNU(dataD, dataD, buffD, pOrder, orderLen, buffD);

         /* signC */
         ns = orderLen;
         FIX_BNU(dataC, ns);
         BN_SIGN(pSignR) = ippBigNumPOS;
         BN_SIZE(pSignR) = ns;
         /* signD */
         ns = orderLen;
         FIX_BNU(dataD, ns);
         BN_SIGN(pSignS) = ippBigNumPOS;
         BN_SIZE(pSignS) = ns;

         return ippStsNoErr;
      }
   }
}
