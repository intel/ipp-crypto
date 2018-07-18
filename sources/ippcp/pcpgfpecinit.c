/*******************************************************************************
* Copyright 2010-2018 Intel Corporation
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
//     EC over GF(p^m) definitinons
// 
//     Context:
//        ippsGFpECInit()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpeccp.h"

/*F*
// Name: ippsGFpECInit
//
// Purpose: Initializes the context of an elliptic curve over a finite field.
//
// Returns:                   Reason:
//    ippStsNullPtrErr              NULL == pEC
//                                  NULL == pA
//                                  NULL == pB
//
//    ippStsContextMatchErr         invalid pEC->idCtx
//                                  invalid pA->idCtx
//                                  invalid pB->idCtx
//
//    ippStsOutOfRangeErr           GFPE_ROOM(pA)!=GFP_FELEN(pGFE)
//                                  GFPE_ROOM(pB)!=GFP_FELEN(pGFE)
//
//    ippStsNoErr                   no error
//
// Parameters:
//    pGFp      Pointer to the IppsGFpState context of the underlying finite field
//    pA        Pointer to the coefficient A of the equation defining the elliptic curve
//    pB        Pointer to the coefficient B of the equation defining the elliptic curve
//    pEC       Pointer to the context of the elliptic curve being initialized
//
*F*/

IPPFUN(IppStatus, ippsGFpECInit,(const IppsGFpState* pGFp,
                                 const IppsGFpElement* pA, const IppsGFpElement* pB,
                                 IppsGFpECState* pEC))
{
   IPP_BAD_PTR2_RET(pGFp, pEC);

   pGFp = (IppsGFpState*)( IPP_ALIGNED_PTR(pGFp, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGFp), ippStsContextMatchErr );

   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );

   {
      Ipp8u* ptr = (Ipp8u*)pEC;

      gsModEngine* pGFE = GFP_PMA(pGFp);
      int elemLen = GFP_FELEN(pGFE);

      int maxOrderBits = 1+ cpGFpBasicDegreeExtension(pGFE) * GFP_FEBITLEN(cpGFpBasic(pGFE)); /* Hasse's theorem */
      #if defined(_LEGACY_ECCP_SUPPORT_)
      int maxOrdLen = BITS_BNU_CHUNK(maxOrderBits);
      #endif

      int modEngineCtxSize;
      gsModEngineGetSize(maxOrderBits, MONT_DEFAULT_POOL_LENGTH, &modEngineCtxSize);

      ECP_ID(pEC) = idCtxGFPEC;
      ECP_GFP(pEC) = (IppsGFpState*)(IPP_ALIGNED_PTR(pGFp, GFP_ALIGNMENT));
      ECP_SUBGROUP(pEC) = 0;
      ECP_POINTLEN(pEC) = elemLen*3;
      ECP_ORDBITSIZE(pEC) = maxOrderBits;
      ECP_SPECIFIC(pEC) = ECP_ARB;

      ptr += sizeof(IppsGFpECState);
      ECP_A(pEC) = (BNU_CHUNK_T*)(ptr);  ptr += elemLen*sizeof(BNU_CHUNK_T);
      ECP_B(pEC) = (BNU_CHUNK_T*)(ptr);  ptr += elemLen*sizeof(BNU_CHUNK_T);
      ECP_G(pEC) = (BNU_CHUNK_T*)(ptr);  ptr += ECP_POINTLEN(pEC)*sizeof(BNU_CHUNK_T);
      ECP_PREMULBP(pEC) = (cpPrecompAP*)NULL;
      ECP_MONT_R(pEC) = (gsModEngine*)( IPP_ALIGNED_PTR((ptr), (MONT_ALIGNMENT)) ); ptr += modEngineCtxSize;
      ECP_COFACTOR(pEC) = (BNU_CHUNK_T*)(ptr); ptr += elemLen*sizeof(BNU_CHUNK_T);
      #if defined(_LEGACY_ECCP_SUPPORT_)
      ECP_PUBLIC(pEC)   = (BNU_CHUNK_T*)(ptr); ptr += 3*elemLen*sizeof(BNU_CHUNK_T);
      ECP_PUBLIC_E(pEC) = (BNU_CHUNK_T*)(ptr); ptr += 3*elemLen*sizeof(BNU_CHUNK_T);
      ECP_PRIVAT(pEC)   = (BNU_CHUNK_T*)(ptr); ptr += maxOrdLen*sizeof(BNU_CHUNK_T);
      ECP_PRIVAT_E(pEC) = (BNU_CHUNK_T*)(ptr); ptr += maxOrdLen*sizeof(BNU_CHUNK_T);
      ECP_SBUFFER(pEC) = (BNU_CHUNK_T*)0;
      #endif
      ECP_POOL(pEC) = (BNU_CHUNK_T*)(ptr);  //ptr += ECP_POINTLEN(pEC)*sizeof(BNU_CHUNK_T)*EC_POOL_SIZE;

      cpGFpElementPadd(ECP_A(pEC), elemLen, 0);
      cpGFpElementPadd(ECP_B(pEC), elemLen, 0);
      cpGFpElementPadd(ECP_G(pEC), elemLen*3, 0);
      //gsModEngineInit(ECP_MONT_R(pEC), NULL, maxOrderBits, MONT_DEFAULT_POOL_LENGTH, gsModArithMont());
      gsModEngineInit(ECP_MONT_R(pEC), NULL, maxOrderBits, MONT_DEFAULT_POOL_LENGTH, NULL);

      cpGFpElementPadd(ECP_COFACTOR(pEC), elemLen, 0);

      cpGFpElementPadd(ECP_POOL(pEC), elemLen*3*EC_POOL_SIZE, 0);

      /* set up EC if possible */
      if(pA && pB)
         return ippsGFpECSet(pA,pB, pEC);
      else
         return ippStsNoErr;
   }
}
