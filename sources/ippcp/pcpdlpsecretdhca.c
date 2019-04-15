/*******************************************************************************
* Copyright 2005-2019 Intel Corporation
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
//     (DL) DH implementation
// 
//  Contents:
//     ippsDLPSharedSecret()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"


/*F*
//    Name: ippsDLPSharedSecretDH
//
// Purpose: Shared Secret Value Derivation (Diffie-Hellman version)
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pDL
//                            NULL == pPubKey
//                            NULL == pSecret
//
//    ippStsContextMatchErr   illegal pDH->idCtx
//                            illegal pPubKey->idCtx
//                            illegal pSecret->idCtx
//
//    ippStsIncompleteContextErr
//                            incomplete context
//
//    ippStsRangeErr          no room for pSecret
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pPrvKeyA  pointer to the own private key
//    pPubKeyB  pointer to the partner's public key
//    pSecret   pointer to the secret value
//    pDL       pointer to the DL context
*F*/
IPPFUN(IppStatus, ippsDLPSharedSecretDH,(const IppsBigNumState* pPrvKeyA,
                                         const IppsBigNumState* pPubKeyB,
                                               IppsBigNumState* pSecret,
                                         IppsDLPState* pDL))
{
   /* test DL context */
   IPP_BAD_PTR1_RET(pDL);
   pDL = (IppsDLPState*)( IPP_ALIGNED_PTR(pDL, DLP_ALIGNMENT) );
   IPP_BADARG_RET(!DLP_VALID_ID(pDL), ippStsContextMatchErr);

   /* test flag */
   IPP_BADARG_RET(!DLP_COMPLETE(pDL), ippStsIncompleteContextErr);

   /* test public key */
   IPP_BAD_PTR1_RET(pPrvKeyA);
   pPrvKeyA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrvKeyA, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrvKeyA), ippStsContextMatchErr);

   /* test public key */
   IPP_BAD_PTR1_RET(pPubKeyB);
   pPubKeyB = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPubKeyB, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPubKeyB), ippStsContextMatchErr);

   /* test secret */
   IPP_BAD_PTR1_RET(pSecret);
   pSecret = (IppsBigNumState*)( IPP_ALIGNED_PTR(pSecret, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pSecret), ippStsContextMatchErr);
   IPP_BADARG_RET(BITS_BNU_CHUNK(DLP_BITSIZEP(pDL))>BN_ROOM(pSecret), ippStsRangeErr);

   cpMontEnc_BN(pSecret, pPubKeyB, DLP_MONTP0(pDL));

   {
      gsModEngine* pMEorder = DLP_MONTR(pDL);
      int ordLen = MOD_LEN(pMEorder);

      /* expand privKeyA */
      BigNumNode* pList = DLP_BNCTX(pDL);
      IppsBigNumState* pTmpPrivKey = cpBigNumListGet(&pList);
      ZEXPAND_COPY_BNU(BN_NUMBER(pTmpPrivKey), ordLen, BN_NUMBER(pPrvKeyA), BN_SIZE(pPrvKeyA));
      BN_SIZE(pTmpPrivKey) = ordLen;

      #if !defined(_USE_WINDOW_EXP_)
      cpMontExpBin_BN_sscm(pSecret, pSecret, pTmpPrivKey, DLP_MONTP0(pDL));
      #else
      (DLP_EXPMETHOD(pDL)==BINARY) || (1==cpMontExp_WinSize(BITSIZE_BNU(BN_NUMBER(pTmpPrivKey), BN_SIZE(pTmpPrivKey))))?
         cpMontExpBin_BN_sscm(pSecret, pSecret, pTmpPrivKey, DLP_MONTP0(pDL)) :
         cpMontExpWin_BN_sscm(pSecret, pSecret, pTmpPrivKey, DLP_MONTP0(pDL), DLP_BNUCTX0(pDL));
      #endif

      cpMontDec_BN(pSecret, pSecret, DLP_MONTP0(pDL));
   }

   return ippStsNoErr;
}
