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
//        ippsGFpECBindGxyTblStd192r1()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpecstuff.h"
#include "pcpeccp.h"



static IppStatus cpGFpECBindGxyTbl(const BNU_CHUNK_T* pPrime,
                                   const cpPrecompAP* preComp,
                                   IppsGFpECState* pEC)
{
   IPP_BAD_PTR1_RET(pEC);
   /* use aligned EC context */
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   {
      IppsGFpState* pGF = ECP_GFP(pEC);
      gsModEngine* pGFE = GFP_PMA(pGF);
      Ipp32u elemLen = GFP_FELEN(pGFE);

      /* test if GF is prime GF */
      IPP_BADARG_RET(!GFP_IS_BASIC(pGFE), ippStsBadArgErr);
      /* test underlying prime value*/
      IPP_BADARG_RET(cpCmp_BNU(pPrime, elemLen, GFP_MODULUS(pGFE), elemLen), ippStsBadArgErr);

      {
         BNU_CHUNK_T* pbp_ec = ECP_G(pEC);
         int cmpFlag;
         BNU_CHUNK_T* pbp_tbl = cpEcGFpGetPool(1, pEC);

         selectAP select_affine_point = preComp->select_affine_point;
         const BNU_CHUNK_T* pTbl = preComp->pTbl;
         select_affine_point(pbp_tbl, pTbl, 1);

         /* check if EC's and G-table's Base Point is the same */
         cmpFlag = cpCmp_BNU(pbp_ec, elemLen*2, pbp_tbl, elemLen*2);

         cpEcGFpReleasePool(1, pEC);

         return cmpFlag? ippStsBadArgErr : ippStsNoErr;
      }
   }
}

/*F*
// Name: ippsGFpECBindGxyTblStd192r1
//
// Purpose: Enables the use of base point-based pre-computed tables of EC192r1
//
// Returns:                   Reason:
//    ippStsNullPtrErr              NULL == pEC
//
//    ippStsContextMatchErr         invalid pEC->idCtx
//
//    ippStsBadArgErr               pEC is not EC192r1
//
//    ippStsNoErr                   no error
//
// Parameters:
//    pEC        Pointer to the context of the elliptic curve
//
*F*/

IPPFUN(IppStatus, ippsGFpECBindGxyTblStd192r1,(IppsGFpECState* pEC))
{
   IppStatus sts = cpGFpECBindGxyTbl(secp192r1_p, gfpec_precom_nistP192r1_fun(), pEC);

   /* setup pre-computed g-table and point access function */
   if(ippStsNoErr==sts)
      ECP_PREMULBP(pEC) = gfpec_precom_nistP192r1_fun();

   return sts;
}
