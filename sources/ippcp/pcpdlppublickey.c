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
//     DL over Prime Finite Field (EC Key Generation, Validation and Set Up)
// 
//  Contents:
//        ippsDLPPublicKey()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpdlp.h"

/*F*
// Name: ippsDLPPublicKey
//
// Purpose: Compute DL public key
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pDL
//                               NULL == pPrvKey
//                               NULL == pPubKey
//
//    ippStsContextMatchErr      invalid pDL->idCtx
//                               invalid pPrvKey->idCtx
//                               invalid pPubKey->idCtx
//
//    ippStsIncompleteContextErr
//                               incomplete context
//
//    ippStsIvalidPrivateKey     !(0 < pPrivate < DLP_R())
//
//    ippStsRangeErr             not enough room for pPubKey
//
//    ippStsNoErr                no error
//
// Parameters:
//    pPrvKey  pointer to the private key
//    pPubKey  pointer to the public  key
//    pDL      pointer to the DL context
*F*/
IPPFUN(IppStatus, ippsDLPPublicKey,(const IppsBigNumState* pPrvKey,
                                    IppsBigNumState* pPubKey,
                                    IppsDLPState* pDL))
{
   /* test DL context */
   IPP_BAD_PTR1_RET(pDL);
   pDL =   (IppsDLPState*)( IPP_ALIGNED_PTR(pDL, DLP_ALIGNMENT) );
   IPP_BADARG_RET(!DLP_VALID_ID(pDL), ippStsContextMatchErr);

   /* test flag */
   IPP_BADARG_RET(!DLP_COMPLETE(pDL), ippStsIncompleteContextErr);

   /* test private/public keys */
   IPP_BAD_PTR2_RET(pPrvKey, pPubKey);
   pPrvKey  = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrvKey, BN_ALIGNMENT) );
   pPubKey  = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPubKey, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrvKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pPubKey), ippStsContextMatchErr);

   /* test private key */
   IPP_BADARG_RET((0<=cpBN_cmp(cpBN_OneRef(), pPrvKey))||
                  (0<=cpCmp_BNU(BN_NUMBER(pPrvKey),BN_SIZE(pPrvKey), DLP_R(pDL),BITS_BNU_CHUNK(DLP_BITSIZER(pDL)))), ippStsIvalidPrivateKey);

   /* test public key's room */
   IPP_BADARG_RET(BN_ROOM(pPubKey)<BITS_BNU_CHUNK(DLP_BITSIZEP(pDL)), ippStsRangeErr);

   {
      gsModEngine* pME= DLP_MONTP0(pDL);
    //int nsM = MOD_LEN(pME);

      gsModEngine* pMEorder = DLP_MONTR(pDL);
      int ordLen = MOD_LEN(pMEorder);

      /* expand privKeyA */
      BigNumNode* pList = DLP_BNCTX(pDL);
      IppsBigNumState* pTmpPrivKey = cpBigNumListGet(&pList);
      ZEXPAND_COPY_BNU(BN_NUMBER(pTmpPrivKey), ordLen, BN_NUMBER(pPrvKey), BN_SIZE(pPrvKey));
      BN_SIZE(pTmpPrivKey) = ordLen;

      /* compute public key:  G^prvKey (mod P) */
      cpMontExpBin_BN_sscm(pPubKey, DLP_GENC(pDL), pTmpPrivKey, pME);
      cpMontDec_BN(pPubKey, pPubKey, pME);

      return ippStsNoErr;
   }
}
