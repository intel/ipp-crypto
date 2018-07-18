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
//        ippsGFpECSignSM2()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"

/*F*
//    Name: ippsGFpECSignSM2
//
// Purpose: SM2 Signature Generation.
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
//                               illegal pMsgDigest->idCtx
//                               illegal pRegPrivate->idCtx
//                               illegal pEphPrivate->idCtx
//                               illegal pSignR->idCtx
//                               illegal pSignS->idCtx
//
//    ippStsMessageErr           Msg < 0
//
//    ippStsRangeErr             not enough room for:
//                               signR
//                               signS
//
//    ippStsErr                  (0==signR)
//                               (0==signS)
//
//    ippStsIvalidPrivateKey     (signR + ephPrivate) == order
//                               (1 + regPrivate) == order
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
IPPFUN(IppStatus, ippsGFpECSignSM2,(const IppsBigNumState* pMsgDigest,
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
   IPP_BADARG_RET(BN_NEGATIVE(pMsgDigest), ippStsMessageErr);

   /* test signature */
   IPP_BAD_PTR2_RET(pSignS, pSignR);
   pSignR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignR, ALIGN_VAL) );
   pSignS = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignS, ALIGN_VAL) );
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

      BNU_CHUNK_T* dataR = BN_NUMBER(pSignR);
      BNU_CHUNK_T* dataS = BN_NUMBER(pSignS);
      BNU_CHUNK_T* buffR = BN_BUFFER(pSignR);
      BNU_CHUNK_T* buffS = BN_BUFFER(pSignS);
      BNU_CHUNK_T* buffMsg = BN_BUFFER(pMsgDigest);

      /* test value of private keys: regPrivate<order, ephPrivate<order */
      IPP_BADARG_RET(BN_NEGATIVE(pRegPrivate) ||
                     (0<=cpCmp_BNU(BN_NUMBER(pRegPrivate), BN_SIZE(pRegPrivate), pOrder, orderLen)), ippStsIvalidPrivateKey);
      IPP_BADARG_RET(BN_NEGATIVE(pEphPrivate) ||
                     (0<=cpCmp_BNU(BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate), pOrder, orderLen)), ippStsIvalidPrivateKey);

      /* test value of private key: (regPrivate+1) != order */
      ZEXPAND_COPY_BNU(dataS,orderLen, BN_NUMBER(pRegPrivate),BN_SIZE(pRegPrivate));
      cpInc_BNU(dataS, dataS, orderLen, 1);
      IPP_BADARG_RET(0==cpCmp_BNU(dataS, orderLen, pOrder, orderLen), ippStsIvalidPrivateKey);

      {
         int elmLen = GFP_FELEN(pGFE);
         int ns;

         /* compute ephemeral public key */
         IppsGFpECPoint ephPublic;
         cpEcGFpInitPoint(&ephPublic, cpEcGFpGetPool(1, pEC), 0, pEC);
         gfec_MulBasePoint(&ephPublic,
                           BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate),
                           pEC, pScratchBuffer);

         /* extract X component: ephPublicX = (ephPublic.x) mod order */
         gfec_GetPoint(dataR, NULL, &ephPublic, pEC);
         GFP_METHOD(pGFE)->decode(dataR, dataR, pGFE);
         ns = cpMod_BNU(dataR, elmLen, pOrder, orderLen);
         cpGFpElementPadd(dataR+ns, orderLen-ns, 0);

         cpEcGFpReleasePool(1, pEC);

         /* reduce message: msg = msg mod ordfer */
         COPY_BNU(buffMsg, BN_NUMBER(pMsgDigest), BN_SIZE(pMsgDigest));
         ns = cpMod_BNU(buffMsg, BN_SIZE(pMsgDigest), pOrder, orderLen);
         ZEXPAND_BNU(buffMsg+ns, orderLen-ns, 0);

         /* compute R signature component: r = (msg + ephPublicX) mod order */
         cpModAdd_BNU(dataR, dataR, buffMsg, pOrder, orderLen, buffR);

         /* t = (r+ephPrivate) mod order */
         ZEXPAND_COPY_BNU(buffR,orderLen, BN_NUMBER(pEphPrivate),BN_SIZE(pEphPrivate));
         cpModAdd_BNU(buffR, buffR, dataR, pOrder, orderLen, buffS);

         /* check r!=0 and t!=0 */
         if(GFP_IS_ZERO(dataR, orderLen) || GFP_IS_ZERO(buffR, orderLen)) return ippStsErr;

         /* compute S signature component: S = (1+regPrivate)^1 *(ephPrivate-r*regPrivate) mod order */
         ZEXPAND_COPY_BNU(buffS,orderLen, BN_NUMBER(pRegPrivate),BN_SIZE(pRegPrivate));
         cpMontEnc_BNU_EX(buffR, dataR, orderLen, pMontR);        /* r */
         cpMontMul_BNU(buffR, buffR, buffS,  /* r*=regPrivate */
                       pMontR);
         ZEXPAND_COPY_BNU(buffS,orderLen, BN_NUMBER(pEphPrivate),BN_SIZE(pEphPrivate));
         cpModSub_BNU(buffS, buffS, buffR, pOrder, orderLen, buffR); /* k -=r */

         //cpMontInv_BNU(dataS, dataS, pMontR); /* s = (1+regPrivate)^-1 */
         gs_mont_inv(dataS, dataS, pMontR);           /* s = (1+regPrivate)^-1 */
         cpMontMul_BNU(dataS, dataS, buffS, pMontR);  /* s *= k */

         /* check s!=0 */
         if(GFP_IS_ZERO(dataS, orderLen)) return ippStsErr;

         /* signR */
         ns = orderLen;
         FIX_BNU(dataR, ns);
         BN_SIGN(pSignR) = ippBigNumPOS;
         BN_SIZE(pSignR) = ns;
         /* signS */
         ns = orderLen;
         FIX_BNU(dataS, ns);
         BN_SIGN(pSignS) = ippBigNumPOS;
         BN_SIZE(pSignS) = ns;

         return ippStsNoErr;
      }
   }
}
