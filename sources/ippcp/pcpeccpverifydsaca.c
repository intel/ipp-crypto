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
//  Purpose:
//     Cryptography Primitive.
//     EC over Prime Finite Field (Verify Signature, DSA version)
//
//  Contents:
//     ippsECCPVerifyDSA()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPVerifyDSA
//
// Purpose: Verify Signature (DSA version).
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pEC
//                               NULL == pMsgDigest
//                               NULL == pSignX
//                               NULL == pSignY
//                               NULL == pResult
//
//    ippStsContextMatchErr      illegal pEC->idCtx
//                               illegal pMsgDigest->idCtx
//                               illegal pSignX->idCtx
//                               illegal pSignY->idCtx
//
//    ippStsMessageErr           MsgDigest >= order
//                               MsgDigest <  0
//
//    ippStsRangeErr             SignX < 0 or SignY < 0
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsgDigest     pointer to the message representative to be signed
//    pSignX,pSignY  pointer to the signature
//    pResult        pointer to the result: ippECValid/ippECInvalidSignature
//    pEC           pointer to the ECCP context
//
// Note:
//    - signer's key must be set up in ECCP context
//      before ippsECCPVerifyDSA() usage
//
*F*/
IPPFUN(IppStatus, ippsECCPVerifyDSA,(const IppsBigNumState* pMsgDigest,
                                     const IppsBigNumState* pSignX, const IppsBigNumState* pSignY,
                                     IppECResult* pResult,
                                     IppsECCPState* pEC))
{
   /* use aligned EC context */
   IPP_BAD_PTR1_RET(pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   /* test message representative */
   IPP_BAD_PTR1_RET(pMsgDigest);
   pMsgDigest = (IppsBigNumState*)( IPP_ALIGNED_PTR(pMsgDigest, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pMsgDigest), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pMsgDigest), ippStsMessageErr);

   /* test result */
   IPP_BAD_PTR1_RET(pResult);

   /* test signature */
   IPP_BAD_PTR2_RET(pSignX,pSignY);
   pSignX = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignX, BN_ALIGNMENT) );
   pSignY = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignY, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pSignX), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pSignY), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pSignX), ippStsRangeErr);
   IPP_BADARG_RET(BN_NEGATIVE(pSignY), ippStsRangeErr);

   {
      IppECResult vResult = ippECInvalidSignature;

      gsModEngine* pModEngine = ECP_MONT_R(pEC);
      BNU_CHUNK_T* pOrder = MOD_MODULUS(pModEngine);
      int orderLen = MOD_LEN(pModEngine);

      /* test input message value */
      IPP_BADARG_RET(0<=cpCmp_BNU(BN_NUMBER(pMsgDigest), BN_SIZE(pMsgDigest), pOrder, orderLen), ippStsMessageErr);

      /* test signature value */
      if(!cpEqu_BNU_CHUNK(BN_NUMBER(pSignX), BN_SIZE(pSignX), 0) &&
         !cpEqu_BNU_CHUNK(BN_NUMBER(pSignY), BN_SIZE(pSignY), 0) &&
         0>cpCmp_BNU(BN_NUMBER(pSignX), BN_SIZE(pSignX), pOrder, orderLen) &&
         0>cpCmp_BNU(BN_NUMBER(pSignY), BN_SIZE(pSignY), pOrder, orderLen)) {

         IppsGFpState* pGF = ECP_GFP(pEC);
         gsModEngine* pGFE = GFP_PMA(pGF);

         int elmLen = GFP_FELEN(pGFE);
         int pelmLen = GFP_PELEN(pGFE);

         BNU_CHUNK_T* h1 = cpGFpGetPool(2, pGFE);
         BNU_CHUNK_T* h2 = h1+pelmLen;

         IppsGFpECPoint P, G, Public;

         /* Y = 1/signY mod order */
         __ALIGN8 IppsBigNumState Y;
         __ALIGN8 IppsBigNumState R;
         BNU_CHUNK_T* buffer = ECP_SBUFFER(pEC);
         BN_Make(buffer,                buffer+orderLen+1,     orderLen, &Y);
         BN_Make(buffer+(orderLen+1)*2, buffer+(orderLen+1)*3, orderLen, &R);
         /* BN(order) */
         BN_Set(pOrder, orderLen, &R);
         ippsModInv_BN((IppsBigNumState*)pSignY, &R, &Y);
         /* h1 = 1/signY mod order */
         cpGFpElementCopyPadd(h1, orderLen, BN_NUMBER(&Y), BN_SIZE(&Y));
         cpMontEnc_BNU_EX(h1, h1, orderLen, pModEngine);

         /* validate signature */
         cpEcGFpInitPoint(&P, cpEcGFpGetPool(1, pEC),0, pEC);
         cpEcGFpInitPoint(&G, ECP_G(pEC), ECP_AFFINE_POINT|ECP_FINITE_POINT, pEC);
         cpEcGFpInitPoint(&Public, ECP_PUBLIC(pEC), ECP_FINITE_POINT, pEC);

         /* h2 = pSignX * h1 (mod order) */
         cpMontMul_BNU_EX(h2,
                          h1,orderLen, BN_NUMBER(pSignX), BN_SIZE(pSignX),
                          pModEngine);
         /* h1 = pMsgDigest * h1 (mod order) */
         cpMontMul_BNU_EX(h1,
                          h1,orderLen, BN_NUMBER(pMsgDigest), BN_SIZE(pMsgDigest),
                          pModEngine);

         /* compute h1*BasePoint + h2*publicKey */
         gfec_BasePointProduct(&P,
                               h1, orderLen, &Public, h2, orderLen,
                               pEC, (Ipp8u*)ECP_SBUFFER(pEC));

         /* get P.X */
         if(gfec_GetPoint(h1, NULL, &P, pEC)) {
            /* C' = int(P.x) mod order */
            GFP_METHOD(pGFE)->decode(h1, h1, pGFE);
            elmLen = cpMod_BNU(h1, elmLen, pOrder, orderLen);
            cpGFpElementPadd(h1+elmLen, orderLen-elmLen, 0);

            /* and make sure signX==P.X */
            cpGFpElementCopyPadd(h2, orderLen, BN_NUMBER(pSignX), BN_SIZE(pSignX));
            if(GFP_EQ(h1, h2, orderLen))
               vResult = ippECValid;
         }

         cpEcGFpReleasePool(1, pEC);
         cpGFpReleasePool(2, pGFE);
      }

      *pResult = vResult;
      return ippStsNoErr;
   }
}
