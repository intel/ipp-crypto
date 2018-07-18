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
//     EC over Prime Finite Field (EC Key Generation)
// 
//  Contents:
//     ippsECCPGenKeyPair()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPGenKeyPair
//
// Purpose: Generate (private,public) Key Pair
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pEC
//                            NULL == pPrivate
//                            NULL == pPublic
//
//    ippStsContextMatchErr   illegal pEC->idCtx
//                            illegal pPrivate->idCtx
//                            illegal pPublic->idCtx
//
//    ippStsNoErr             no errors
//
// Parameters:
//    pPrivate    pointer to the resultant private key
//    pPublic     pointer to the resultant public  key
//    pEC        pointer to the ECCP context
//    rndFunc     Specified Random Generator.
//    pRndParam   Pointer to the Random Generator context.
//
*F*/
IPPFUN(IppStatus, ippsECCPGenKeyPair, (IppsBigNumState* pPrivate, IppsECCPPointState* pPublic,
                                       IppsECCPState* pEC,
                                       IppBitSupplier rndFunc, void* pRndParam))
{
   IPP_BAD_PTR2_RET(pEC, rndFunc);

   /* use aligned EC context */
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   /* test private/public keys */
   IPP_BAD_PTR2_RET(pPrivate,pPublic);
   pPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrivate, ALIGN_VAL) );
   IPP_BADARG_RET(!BN_VALID_ID(pPrivate), ippStsContextMatchErr);
   IPP_BADARG_RET((BN_ROOM(pPrivate)*BITSIZE(BNU_CHUNK_T)<ECP_ORDBITSIZE(pEC)), ippStsSizeErr);

   IPP_BADARG_RET( !ECP_POINT_TEST_ID(pPublic), ippStsContextMatchErr );
   IPP_BADARG_RET(ECP_POINT_FELEN(pPublic)<GFP_FELEN(GFP_PMA(ECP_GFP(pEC))), ippStsRangeErr);

   {
      /* generate random private key X:  0 < X < R */
      gsModEngine* pModEngine =ECP_MONT_R(pEC);
      BNU_CHUNK_T* pOrder = MOD_MODULUS(pModEngine);
      int orderBitLen = ECP_ORDBITSIZE(pEC);
      int orderLen = BITS_BNU_CHUNK(orderBitLen);

      BNU_CHUNK_T* pX = BN_NUMBER(pPrivate);
      int nsX = BITS_BNU_CHUNK(orderBitLen);
      BNU_CHUNK_T xMask = MASK_BNU_CHUNK(orderBitLen);

      IppStatus sts;
      do {
         sts = rndFunc((Ipp32u*)pX, orderBitLen, pRndParam);
         if(ippStsNoErr != sts)
            break;
         pX[nsX-1] &= xMask;
      } while( (1 == cpEqu_BNU_CHUNK(pX, nsX, 0)) ||
               (0 <= cpCmp_BNU(pX, nsX, pOrder, orderLen)) );

      if(ippStsNoErr != sts)
         return ippStsErr;

      /* set up private */
      BN_SIGN(pPrivate) = ippBigNumPOS;
      FIX_BNU(pX, nsX);
      BN_SIZE(pPrivate) = nsX;

      /* calculate public key */
      gfec_MulBasePoint(pPublic, pX, nsX, pEC, (Ipp8u*)ECP_SBUFFER(pEC));

      return ippStsNoErr;
   }
}
