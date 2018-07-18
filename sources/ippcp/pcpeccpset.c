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
//     EC over Prime Finite Field (setup/retrieve domain parameters)
// 
//  Contents:
//        ippsECCPSet()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"

/*F*
//    Name: ippsECCPInitStdSM2
//
// Purpose: Sets up the elliptic curve domain parameters 
//          over a prime finite field GF(p)
//
// Returns:                   Reason:
//    ippStsNullPtrErr        NULL == pPrime
//                            NULL == pA
//                            NULL == pB
//                            NULL == pGX
//                            NULL == pGY
//                            NULL == pOrder
//                            NULL == cofactor
//                            NULL == pEC
//
//    ippStsContextMatchErr   illegal pPrime->idCtx
//                            illegal pA->idCtx
//                            illegal pB->idCtx
//                            illegal pGX->idCtx
//                            illegal pGY->idCtx
//                            illegal pOrder->idCtx
//                            illegal pEC->idCtx
//
//    ippStsRangeErr          not enough room for:
//                            pPrime
//                            pA, pB,
//                            pGX, pGY
//                            pOrder
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pPrime   pointer to the retrieval prime (specify FG(p))
//    pA       pointer to the retrieval A coefficient of EC equation
//    pB       pointer to the retrieval B coefficient of EC equation
//    pGX,pGY  pointer to the retrieval Base Point (x and y coordinates) of EC
//    pOrder   pointer to the retrieval Base Point order
//    cofactor pointer to the retrieval cofactor value
//    pEC     pointer to the ECC context
//
*F*/

IPPFUN(IppStatus, ippsECCPSet, (const IppsBigNumState* pPrime,
                                const IppsBigNumState* pA, const IppsBigNumState* pB,
                                const IppsBigNumState* pGX,const IppsBigNumState* pGY,
                                const IppsBigNumState* pOrder, int cofactor,
                                IppsECCPState* pEC))
{
   /* test pEC */
   IPP_BAD_PTR1_RET(pEC);
   /* use aligned EC context */
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   /* test pPrime */
   IPP_BAD_PTR1_RET(pPrime);
   pPrime = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrime, BN_ALIGNMENT) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrime), ippStsContextMatchErr);
   IPP_BADARG_RET((cpBN_bitsize(pPrime)>GFP_FEBITLEN(GFP_PMA(ECP_GFP(pEC)))), ippStsRangeErr);

   /* test pA and pB */
   IPP_BAD_PTR2_RET(pA,pB);
   pA = (IppsBigNumState*)( IPP_ALIGNED_PTR(pA, ALIGN_VAL) );
   pB = (IppsBigNumState*)( IPP_ALIGNED_PTR(pB, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pA), ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pB), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pA) || 0<=cpBN_cmp(pA,pPrime), ippStsRangeErr);
   IPP_BADARG_RET(BN_NEGATIVE(pB) || 0<=cpBN_cmp(pB,pPrime), ippStsRangeErr);

   /* test pG and pGorder pointers */
   IPP_BAD_PTR3_RET(pGX,pGY, pOrder);
   pGX    = (IppsBigNumState*)( IPP_ALIGNED_PTR(pGX,    ALIGN_VAL) );
   pGY    = (IppsBigNumState*)( IPP_ALIGNED_PTR(pGY,    ALIGN_VAL) );
   pOrder = (IppsBigNumState*)( IPP_ALIGNED_PTR(pOrder, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pGX),    ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pGY),    ippStsContextMatchErr);
   IPP_BADARG_RET(!BN_VALID_ID(pOrder), ippStsContextMatchErr);
   IPP_BADARG_RET(BN_NEGATIVE(pGX) || 0<=cpBN_cmp(pGX,pPrime), ippStsRangeErr);
   IPP_BADARG_RET(BN_NEGATIVE(pGY) || 0<=cpBN_cmp(pGY,pPrime), ippStsRangeErr);
   IPP_BADARG_RET((cpBN_bitsize(pOrder)>ECP_ORDBITSIZE(pEC)), ippStsRangeErr);

   /* test cofactor */
   IPP_BADARG_RET(!(0<cofactor), ippStsRangeErr);

   return ECCPSetDP(ippsGFpMethod_pArb(),
                        BN_SIZE(pPrime), BN_NUMBER(pPrime),
                        BN_SIZE(pA), BN_NUMBER(pA),
                        BN_SIZE(pB), BN_NUMBER(pB),
                        BN_SIZE(pGX), BN_NUMBER(pGX),
                        BN_SIZE(pGY), BN_NUMBER(pGY),
                        BN_SIZE(pOrder), BN_NUMBER(pOrder),
                        (BNU_CHUNK_T)cofactor,
                        pEC);
}
