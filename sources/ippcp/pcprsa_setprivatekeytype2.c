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
//     RSA Functions
// 
//  Contents:
//        ippsRSA_SetPrivateKeyType2()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"

/*F*
// Name: ippsRSA_SetPrivateKeyType2
//
// Purpose: Set up the RSA private key
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pFactorP, NULL == pFactorQ
//                               NULL == pCrtExpP, NULL == pCrtExpQ
//                               NULL == pInverseQ
//                               NULL == pKey
//
//    ippStsContextMatchErr     !BN_VALID_ID(pFactorP), !BN_VALID_ID(pFactorQ)
//                              !BN_VALID_ID(pCrtExpP), !BN_VALID_ID(pCrtExpQ)
//                              !BN_VALID_ID(pInverseQ)
//                              !RSA_PRV_KEY_VALID_ID()
//
//    ippStsOutOfRangeErr        0 >= pFactorP, 0 >= pFactorQ
//                               0 >= pCrtExpP, 0 >= pCrtExpQ
//                               0 >= pInverseQ
//
//    ippStsSizeErr              bitsize(pFactorP) exceeds requested value
//                               bitsize(pFactorQ) exceeds requested value
//                               bitsize(pCrtExpP) > bitsize(pFactorP)
//                               bitsize(pCrtExpQ) > bitsize(pFactorQ)
//                               bitsize(pInverseQ) > bitsize(pFactorP)
//
//    ippStsNoErr                no error
//
// Parameters:
//    pFactorP, pFactorQ   pointer to the RSA modulus (N) prime factors
//    pCrtExpP, pCrtExpQ   pointer to CTR's exponent
//    pInverseQ            1/Q mod P
//    pKey                 pointer to the key context
*F*/
IPPFUN(IppStatus, ippsRSA_SetPrivateKeyType2,(const IppsBigNumState* pFactorP,
                                              const IppsBigNumState* pFactorQ,
                                              const IppsBigNumState* pCrtExpP,
                                              const IppsBigNumState* pCrtExpQ,
                                              const IppsBigNumState* pInverseQ,
                                              IppsRSAPrivateKeyState* pKey))
{
   IPP_BAD_PTR1_RET(pKey);
   pKey = (IppsRSAPrivateKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PRIVATE_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PRV_KEY2_VALID_ID(pKey), ippStsContextMatchErr);

   IPP_BAD_PTR1_RET(pFactorP);
   pFactorP = (IppsBigNumState*)( IPP_ALIGNED_PTR(pFactorP, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pFactorP), ippStsContextMatchErr);
   IPP_BADARG_RET(!(0 < cpBN_tst(pFactorP)), ippStsOutOfRangeErr);
   IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pFactorP), BN_SIZE(pFactorP)) > RSA_PRV_KEY_BITSIZE_P(pKey), ippStsSizeErr);

   IPP_BAD_PTR1_RET(pFactorQ);
   pFactorQ = (IppsBigNumState*)( IPP_ALIGNED_PTR(pFactorQ, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pFactorQ), ippStsContextMatchErr);
   IPP_BADARG_RET(!(0 < cpBN_tst(pFactorQ)), ippStsOutOfRangeErr);
   IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pFactorQ), BN_SIZE(pFactorQ)) > RSA_PRV_KEY_BITSIZE_Q(pKey), ippStsSizeErr);

   /* let P>Q */
   //IPP_BADARG_RET(0>=cpBN_cmp(pFactorP,pFactorQ), ippStsBadArgErr);

   IPP_BAD_PTR1_RET(pCrtExpP);
   pCrtExpP = (IppsBigNumState*)( IPP_ALIGNED_PTR(pCrtExpP, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pCrtExpP), ippStsContextMatchErr);
   IPP_BADARG_RET(!(0 < cpBN_tst(pCrtExpP)), ippStsOutOfRangeErr);
   IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pCrtExpP), BN_SIZE(pCrtExpP)) > RSA_PRV_KEY_BITSIZE_P(pKey), ippStsSizeErr);

   IPP_BAD_PTR1_RET(pCrtExpQ);
   pCrtExpQ = (IppsBigNumState*)( IPP_ALIGNED_PTR(pCrtExpQ, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pCrtExpQ), ippStsContextMatchErr);
   IPP_BADARG_RET(!(0 < cpBN_tst(pCrtExpQ)), ippStsOutOfRangeErr);
   IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pCrtExpQ), BN_SIZE(pCrtExpQ)) > RSA_PRV_KEY_BITSIZE_Q(pKey), ippStsSizeErr);

   IPP_BAD_PTR1_RET(pInverseQ);
   pInverseQ = (IppsBigNumState*)( IPP_ALIGNED_PTR(pInverseQ, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pInverseQ), ippStsContextMatchErr);
   IPP_BADARG_RET(!(0 < cpBN_tst(pInverseQ)), ippStsOutOfRangeErr);
   IPP_BADARG_RET(BITSIZE_BNU(BN_NUMBER(pInverseQ), BN_SIZE(pInverseQ)) > RSA_PRV_KEY_BITSIZE_P(pKey), ippStsSizeErr);

   /* set bitsize(N) = 0, so the key contex is not ready */
   RSA_PRV_KEY_BITSIZE_N(pKey) = 0;
   RSA_PRV_KEY_BITSIZE_D(pKey) = 0;

   /* setup montgomery engine P */
   gsModEngineInit(RSA_PRV_KEY_PMONT(pKey), (Ipp32u*)BN_NUMBER(pFactorP), cpBN_bitsize(pFactorP), MOD_ENGINE_RSA_POOL_SIZE, gsModArithRSA());
   /* setup montgomery engine Q */
   gsModEngineInit(RSA_PRV_KEY_QMONT(pKey), (Ipp32u*)BN_NUMBER(pFactorQ), cpBN_bitsize(pFactorQ), MOD_ENGINE_RSA_POOL_SIZE, gsModArithRSA());

   /* actual size of key components */
   RSA_PRV_KEY_BITSIZE_P(pKey) = cpBN_bitsize(pFactorP);
   RSA_PRV_KEY_BITSIZE_Q(pKey) = cpBN_bitsize(pFactorQ);

   /* store CTR's exp dp */
   ZEXPAND_COPY_BNU(RSA_PRV_KEY_DP(pKey), BITS_BNU_CHUNK(RSA_PRV_KEY_BITSIZE_P(pKey)), BN_NUMBER(pCrtExpP), BN_SIZE(pCrtExpP));
   /* store CTR's exp dq */
   ZEXPAND_COPY_BNU(RSA_PRV_KEY_DQ(pKey), BITS_BNU_CHUNK(RSA_PRV_KEY_BITSIZE_Q(pKey)), BN_NUMBER(pCrtExpQ), BN_SIZE(pCrtExpQ));
   /* store mont encoded CTR's coeff qinv */
   {
      gsModEngine* pMontP = RSA_PRV_KEY_PMONT(pKey);
      cpSize modLen       = MOD_LEN(pMontP);
      BNU_CHUNK_T* pInverseQEx = MOD_MODULUS(RSA_PRV_KEY_NMONT(pKey)); /* we have (3 * modLen * sizeof(BNU_CHUNK_T)) */

      ZEXPAND_COPY_BNU(pInverseQEx, modLen, BN_NUMBER(pInverseQ), BN_SIZE(pInverseQ) );

      MOD_METHOD( pMontP )->mul(RSA_PRV_KEY_INVQ(pKey), pInverseQEx, MOD_MNT_R2(pMontP), pMontP);
   }

   /* setup montgomery engine N = P*Q */
   {
      BNU_CHUNK_T* pN = MOD_MODULUS(RSA_PRV_KEY_NMONT(pKey));
      cpSize nsN = BITS_BNU_CHUNK(RSA_PRV_KEY_BITSIZE_P(pKey) + RSA_PRV_KEY_BITSIZE_Q(pKey));

      cpMul_BNU_school(pN,
                       BN_NUMBER(pFactorP), BN_SIZE(pFactorP),
                       BN_NUMBER(pFactorQ), BN_SIZE(pFactorQ));

      gsModEngineInit(RSA_PRV_KEY_NMONT(pKey), (Ipp32u*)MOD_MODULUS(RSA_PRV_KEY_NMONT(pKey)),
         RSA_PRV_KEY_BITSIZE_P(pKey) + RSA_PRV_KEY_BITSIZE_Q(pKey), MOD_ENGINE_RSA_POOL_SIZE, gsModArithRSA());

      FIX_BNU(pN, nsN);
      RSA_PRV_KEY_BITSIZE_N(pKey) = BITSIZE_BNU(pN, nsN);
   }

   return ippStsNoErr;
}
