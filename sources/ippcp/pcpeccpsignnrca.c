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
//     EC over Prime Finite Field (Sign, NR version)
// 
//  Contents:
//     ippsECCPSignNR()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPSignNR
//
// Purpose: Signing of message representative.
//          (NR version).
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pEC
//                               NULL == pMsgDigest
//                               NULL == pPrivate
//                               NULL == pSignX
//                               NULL == pSignY
//
//    ippStsContextMatchErr      illegal pEC->idCtx
//                               illegal pMsgDigest->idCtx
//                               illegal pPrivate->idCtx
//                               illegal pSignX->idCtx
//                               illegal pSignY->idCtx
//
//    ippStsIvalidPrivateKey     0 >= Private
//                               Private >= order
//
//    ippStsMessageErr           MsgDigest >= order
//                               MsgDigest <  0
//
//    ippStsRangeErr             not enough room for:
//                               signX
//                               signY
//
//    ippStsEphemeralKeyErr      (0==signX) || (0==signY)
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsgDigest     pointer to the message representative to be signed
//    pPrivate       pointer to the regular private key
//    pSignX,pSignY  pointer to the signature
//    pEC            pointer to the ECCP context
//
// Note:
//    - ephemeral key pair extracted from pEC and
//      must be generated and before ippsECCPNRSign() usage
//    - ephemeral key pair destroy before exit
//
*F*/
IPPFUN(IppStatus, ippsECCPSignNR,(const IppsBigNumState* pMsgDigest,
                                  const IppsBigNumState* pPrivate,
                                  IppsBigNumState* pSignX, IppsBigNumState* pSignY,
                                  IppsECCPState* pEC))
{
   /* use aligned EC context */
   IPP_BAD_PTR1_RET(pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   /* test private key*/
   IPP_BAD_PTR1_RET(pPrivate);
   pPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrivate), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pPrivate), ippStsIvalidPrivateKey);

   /* test message representative */
   IPP_BAD_PTR1_RET(pMsgDigest);
   pMsgDigest = (IppsBigNumState*)( IPP_ALIGNED_PTR(pMsgDigest, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pMsgDigest), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pMsgDigest), ippStsMessageErr);

   /* test signature */
   IPP_BAD_PTR2_RET(pSignX,pSignY);
   pSignX = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignX, ALIGN_VAL) );
   pSignY = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignY, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pSignX), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pSignY), ippStsContextMatchErr);
   IPP_BADARG_RET((BN_ROOM(pSignX)*BITSIZE(BNU_CHUNK_T)<ECP_ORDBITSIZE(pEC)), ippStsRangeErr);
   IPP_BADARG_RET((BN_ROOM(pSignY)*BITSIZE(BNU_CHUNK_T)<ECP_ORDBITSIZE(pEC)), ippStsRangeErr);

   {
      gsModEngine* pMontR = ECP_MONT_R(pEC);
      BNU_CHUNK_T* pOrder = MOD_MODULUS(pMontR);
      int ordLen = MOD_LEN(pMontR);

      BNU_CHUNK_T* pPriData = BN_NUMBER(pPrivate);
      int priLen = BN_SIZE(pPrivate);

      BNU_CHUNK_T* pMsgData = BN_NUMBER(pMsgDigest);
      int msgLen = BN_SIZE(pMsgDigest);

      /* make sure regular 0 < private < order */
      IPP_BADARG_RET(cpEqu_BNU_CHUNK(pPriData, priLen, 0) ||
                  0<=cpCmp_BNU(pPriData, priLen, pOrder, ordLen), ippStsIvalidPrivateKey);
      /* make sure msg <order */
      IPP_BADARG_RET(0<=cpCmp_BNU(pMsgData, msgLen, pOrder, ordLen), ippStsMessageErr);

      {
         IppsGFpState* pGF = ECP_GFP(pEC);
         gsModEngine* pMontP = GFP_PMA(pGF);
         int elmLen = GFP_FELEN(pMontP);

         BNU_CHUNK_T* dataC = BN_NUMBER(pSignX);
         BNU_CHUNK_T* dataD = BN_NUMBER(pSignY);
         BNU_CHUNK_T* buffF = BN_BUFFER(pSignX);
         int ns;

         /* ephemeral public */
         IppsGFpECPoint  ephPublic;
         cpEcGFpInitPoint(&ephPublic, ECP_PUBLIC_E(pEC), ECP_FINITE_POINT|ECP_AFFINE_POINT, pEC);

         /* ephPublic.x (mod order) */
         {
            BNU_CHUNK_T* buffer = gsModPoolAlloc(pMontP, 1);
            gfec_GetPoint(buffer, NULL, &ephPublic, pEC);
            GFP_METHOD(pMontP)->decode(buffer, buffer, pMontP);
            ns = cpMod_BNU(buffer, elmLen, pOrder, ordLen);
            cpGFpElementCopyPadd(dataC, ordLen, buffer, ns);
            gsModPoolFree(pMontP, 1);
         }

         /* signX = (pMsgDigest + C) (mod order) */
         ZEXPAND_COPY_BNU(buffF, ordLen, pMsgData, msgLen);
         cpModAdd_BNU(dataC, dataC, buffF, pOrder, ordLen, dataD);

         if(!GFP_IS_ZERO(dataC, ordLen)) {

            /* signY = (eph_private - private*signX) (mod order) */
            ZEXPAND_COPY_BNU(dataD, ordLen, pPriData, priLen);
            GFP_METHOD(pMontR)->encode(dataD, dataD, pMontR);
            GFP_METHOD(pMontR)->mul(dataD, dataD, dataC, pMontR);
            cpModSub_BNU(dataD, ECP_PRIVAT_E(pEC), dataD, pOrder, ordLen, buffF);

            /* signX */
            ns = ordLen;
            FIX_BNU(dataC, ns);
            BN_SIGN(pSignX) = ippBigNumPOS;
            BN_SIZE(pSignX) = ns;

            /* signY */
            ns = ordLen;
            FIX_BNU(dataD, ns);
            BN_SIGN(pSignY) = ippBigNumPOS;
            BN_SIZE(pSignY) = ns;

            return ippStsNoErr;
         }

         return ippStsEphemeralKeyErr;
      }
   }
}
