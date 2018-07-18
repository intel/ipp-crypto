/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
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
//     EC over Prime Finite Field (Sign, SM2 version)
// 
//  Contents:
//     ippsECCPSignSM2()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPSignSM2
//
// Purpose: Signing of message representative.
//          (SM2 version).
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pEC
//                               NULL == pMsgDigest
//                               NULL == pRegPrivate
//                               NULL == pEphPrivate
//                               NULL == pSignR
//                               NULL == pSignS
//
//    ippStsContextMatchErr      illegal pEC->idCtx
//                               illegal pMsgDigest->idCtx
//                               illegal pRegPrivate->idCtx
//                               illegal pEphPrivate->idCtx
//                               illegal pSignR->idCtx
//                               illegal pSignS->idCtx
//
//    ippStsMessageErr           MsgDigest >= order
//
//    ippStsRangeErr             not enough room for:
//                               signR
//                               signS
//
//    ippECInvalidSignature      (0==signR)
//                               (0==signS)
//                               (signR + ephPrivate) == order
//                               (1 + regPrivate) == order
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsgDigest     pointer to the message representative to be signed
//    pRegPrivate    pointer to the regular private key
//    pEphPrivate    pointer to the ephemeral private key
//    pSignR,pSignS  pointer to the signature
//    pEC           pointer to the ECCP context
//
// Note:
//    ephemeral key computes inside ippsECCPSignSM2 in contrast with ippsECCPSignDSA,
//    where ephemeral key pair computed before call and setup in context
//
*F*/
IPPFUN(IppStatus, ippsECCPSignSM2,(const IppsBigNumState* pMsgDigest,
                                   const IppsBigNumState* pRegPrivate,
                                   const IppsBigNumState* pEphPrivate,
                                   IppsBigNumState* pSignR, IppsBigNumState* pSignS,
                                   IppsECCPState* pEC))
{
   /* use aligned EC context */
   IPP_BAD_PTR1_RET(pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   /* test private keys */
   IPP_BAD_PTR2_RET(pRegPrivate, pEphPrivate);
   pRegPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pRegPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pRegPrivate), ippStsContextMatchErr);
   pEphPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pEphPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pEphPrivate), ippStsContextMatchErr);

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

   {
      IppStatus sts = ippStsErr;

      gsModEngine* pMonEngine = ECP_MONT_R(pEC);
      BNU_CHUNK_T* pOrder = MOD_MODULUS(pMonEngine);
      int orderLen = MOD_LEN(pMonEngine);
      int ns;

      IppsGFpState* pGF = ECP_GFP(pEC);
      gsModEngine* pGFE = GFP_PMA(pGF);
      int elmLen = GFP_FELEN(pGFE);

      BNU_CHUNK_T* dataR = BN_NUMBER(pSignR);
      BNU_CHUNK_T* dataS = BN_NUMBER(pSignS);
      BNU_CHUNK_T* buffR = BN_BUFFER(pSignR);
      BNU_CHUNK_T* buffS = BN_BUFFER(pSignS);

      BNU_CHUNK_T* pMsgData = BN_NUMBER(pMsgDigest);
      BNU_CHUNK_T* pMsgBuff = BN_BUFFER(pMsgDigest);
      int msgLen = BN_SIZE(pMsgDigest);

      /* reduce message */
      COPY_BNU(pMsgBuff, pMsgData, msgLen);
      ns = cpMod_BNU(pMsgBuff, msgLen, pOrder, orderLen);
      cpGFpElementPadd(pMsgBuff+ns, orderLen-ns, 0);

      /* signS = (1+regPrivate)^-1 mod Order*/
      {
         __ALIGN8 IppsBigNumState R;
         BNU_CHUNK_T* buffer = ECP_SBUFFER(pEC);
         /* BN(order) */
         BN_Make(buffer, buffer+orderLen+1, orderLen, &R);
         BN_Set(pOrder, orderLen, &R);

         ippsAdd_BN((IppsBigNumState*)pRegPrivate, cpBN_OneRef(), pSignR);
         if(ippStsNoErr != ippsModInv_BN(pSignR, &R, pSignS))
            return sts;
         cpGFpElementPadd(dataS+BN_SIZE(pSignS), orderLen-BN_SIZE(pSignS), 0);
      }

      /* set up ephemeral public key */
      {
         IppsGFpECPoint  ephPublic;
         cpEcGFpInitPoint(&ephPublic, ECP_PUBLIC_E(pEC), 0, pEC);
         gfec_MulBasePoint(&ephPublic,
                           BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate),
                           pEC, (Ipp8u*)ECP_SBUFFER(pEC));

         /* r = (ephPublic.x) mod order */
         gfec_GetPoint(dataR, NULL, &ephPublic, pEC);
         GFP_METHOD(pGFE)->decode(dataR, dataR, pGFE);
         ns = cpMod_BNU(dataR, elmLen, pOrder, orderLen);
         cpGFpElementPadd(dataR+ns, orderLen-ns, 0);
      }

      /*
      // r sign component: r = (msg+ephPublic.x) mod order
      */
      cpModAdd_BNU(dataR, dataR, pMsgBuff, pOrder, orderLen, pMsgBuff);
      /* t = (r+ephPrivate) mod order */
      cpModAdd_BNU(buffR, dataR, ECP_PRIVAT_E(pEC), pOrder, orderLen, pMsgBuff);

      /*
      // s sign component: s = (1+regPrivate)^1 *(ephPrivate-r*regPrivate) mod order
      */
      if(!GFP_IS_ZERO(dataR, orderLen) && !GFP_IS_ZERO(buffR, orderLen)) {
         /* t = (ephPrivate-r*regPrivate) mod order */
         cpMontEnc_BNU_EX(buffR, dataR, orderLen, pMonEngine); /* r */
         cpGFpElementCopyPadd(buffS, orderLen, BN_NUMBER(pRegPrivate), BN_SIZE(pRegPrivate)); /* regPrivate */
         cpMontMul_BNU(buffR, buffR, buffS, pMonEngine);
         cpGFpElementCopyPadd(buffS, orderLen, BN_NUMBER(pEphPrivate), BN_SIZE(pEphPrivate)); /* ephPrivate */
         cpModSub_BNU(buffS, buffS, buffR, pOrder, orderLen, buffR);

         cpMontEnc_BNU_EX(buffS, buffS, orderLen, pMonEngine); /* t */

         /* s = s * t mod order */
         cpMontMul_BNU(dataS, dataS, buffS, pMonEngine);

         if(!GFP_IS_ZERO(dataS, orderLen)) {
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

            sts = ippStsNoErr;
         }
      }

      return sts;
   }
}
