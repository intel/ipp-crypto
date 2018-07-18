/*******************************************************************************
* Copyright 2005-2018 Intel Corporation
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
//     DL over Prime Finite Field (Sign, DSA version)
// 
//  Contents:
//     ippsDLPSignDSA()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"


/*F*
//    Name: ippsDLSignDSA
//
// Purpose: Signing of message representative
//          (DSA version).
//
// Returns:                      Reason:
//    ippStsNullPtrErr              NULL == pDL
//                                  NULL == pPrvKey
//                                  NULL == pMsgDigest
//                                  NULL == pSignR
//                                  NULL == pSignS
//
//    ippStsContextMatchErr         illegal pDL->idCtx
//                                  illegal pPrvKey->idCtx
//                                  illegal pMsgDigest->idCtx
//                                  illegal pSignR->idCtx
//                                  illegal pSignS->idCtx
//
//    ippStsIncompleteContextErr
//                                  incomplete context
//
//    ippStsMessageErr              MsgDigest < 0
//
//    ippStsIvalidPrivateKey        !(0 < PrvKey < DLP_R())
//
//    ippStsRangeErr                not enough room for:
//                                  signR
//                                  signS
//
//    ippStsNoErr                   no errors
//
// Parameters:
//    pMsgDigest     pointer to the message representative to be signed
//    pPevKey        pointer to the (signatory's) regular private key
//    pSignR,pSignS  pointer to the signature
//    pDL            pointer to the DL context
//
// Primitive sequence call:
//    1) set up domain parameters
//    2) generate (signatory's) ephemeral key pair
//    3) set up (signatory's) ephemeral key pair
//    4) use primitive with (signatory's) private key
*F*/
IPPFUN(IppStatus, ippsDLPSignDSA,(const IppsBigNumState* pMsgDigest,
                                  const IppsBigNumState* pPrvKey,
                                        IppsBigNumState* pSignR,
                                        IppsBigNumState* pSignS,
                                  IppsDLPState *pDL))
{
   /* test DL context */
   IPP_BAD_PTR1_RET(pDL);
   pDL = (IppsDLPState*)( IPP_ALIGNED_PTR(pDL, DLP_ALIGNMENT) );
   IPP_BADARG_RET(!DLP_VALID_ID(pDL), ippStsContextMatchErr);

   /* test flag */
   IPP_BADARG_RET(!DLP_COMPLETE(pDL), ippStsIncompleteContextErr);

   /* test message representative */
   IPP_BAD_PTR1_RET(pMsgDigest);
   pMsgDigest = (IppsBigNumState*)( IPP_ALIGNED_PTR(pMsgDigest, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pMsgDigest), ippStsContextMatchErr);
   IPP_BADARG_RET((0<cpBN_cmp(cpBN_OneRef(), pMsgDigest)), ippStsMessageErr);

   /* test regular private key */
   IPP_BAD_PTR1_RET(pPrvKey);
   pPrvKey = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrvKey, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrvKey), ippStsContextMatchErr);
   IPP_BADARG_RET(0<cpBN_cmp(cpBN_OneRef(), pPrvKey)||
                  0<=cpCmp_BNU(BN_NUMBER(pPrvKey),BN_SIZE(pPrvKey), DLP_R(pDL), BITS_BNU_CHUNK(DLP_BITSIZER(pDL))), ippStsIvalidPrivateKey);

   /* test signature */
   IPP_BAD_PTR2_RET(pSignR,pSignS);
   pSignR = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignR, BN_ALIGNMENT) );
   pSignS = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSignS, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pSignR), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pSignS), ippStsContextMatchErr);
   IPP_BADARG_RET(BITSIZE(BNU_CHUNK_T)*BN_ROOM(pSignR)<DLP_BITSIZER(pDL), ippStsRangeErr);
   IPP_BADARG_RET(BITSIZE(BNU_CHUNK_T)*BN_ROOM(pSignS)<DLP_BITSIZER(pDL), ippStsRangeErr);

   {
      /* allocate BN resources */
      BigNumNode* pList = DLP_BNCTX(pDL);
      IppsBigNumState* pT = cpBigNumListGet(&pList);
      IppsBigNumState* pU = cpBigNumListGet(&pList);
      IppsBigNumState* pW = cpBigNumListGet(&pList);

      IppsBigNumState* pOrder = cpBigNumListGet(&pList);
      ippsSet_BN(ippBigNumPOS, BITS2WORD32_SIZE(DLP_BITSIZER(pDL)), (Ipp32u*)DLP_R(pDL), pOrder);

      /* reduct pMsgDigest if necessary */
      if(0 < cpBN_cmp(pMsgDigest, pOrder))
         ippsMod_BN((IppsBigNumState*)pMsgDigest, pOrder, pW);
      else
         cpBN_copy(pW, pMsgDigest);

      /*
      // compute  component of signature:
      // signR = (G^eX (mod P)) (mod R), eX = ephemeral private key
      // or
      // signR = eY (mod R), eY = ephemeral public key (already set up)
      */
      cpMontDec_BN(pT, DLP_YENC(pDL), DLP_MONTP0(pDL));
      BN_SIZE(pT) = cpMod_BNU(BN_NUMBER(pT), BN_SIZE(pT),
                              BN_NUMBER(pOrder), BN_SIZE(pOrder));
      cpBN_copy(pSignR, pT);

      /*
      // compute signS component of signature:
      // signS = ((1/eX)*(MsgDigest + X*signR)) (mod R)
      */
      /* compute T = enc( 1/eX mod(R) ) */
      ippsModInv_BN(DLP_X(pDL), pOrder, pT);
      cpMontEnc_BN(pT, pT, DLP_MONTR(pDL));

      cpMontMul_BN(pSignS, pT, pW, DLP_MONTR(pDL));

      cpMontEnc_BN(pU, pPrvKey, DLP_MONTR(pDL));
      cpMontMul_BN(pT, pU, pT, DLP_MONTR(pDL));
      cpMontMul_BN(pT, pSignR, pT, DLP_MONTR(pDL));

      ippsAdd_BN(pT, pSignS, pT);
      if(0 <= cpBN_cmp(pT, pOrder))
         ippsSub_BN(pT, pOrder, pT);
      cpBN_copy(pSignS, pT);

      return ippStsNoErr;
   }
}
