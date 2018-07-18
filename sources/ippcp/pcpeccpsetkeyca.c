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
//     ippsECCPSetKeyPair()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPSetKeyPair
//
// Purpose: Generate (private,public) Key Pair
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pEC
//                               NULL == pPrivate
//                               NULL == pPublic
//
//    ippStsContextMatchErr      illegal pEC->idCtx
//                               illegal pPrivate->idCtx
//                               illegal pPublic->idCtx
//
//    ippStsNoErr                no errors
//
// Parameters:
//    pPrivate    pointer to the private key
//    pPublic     pointer to the public  key
//    regular     flag regular/ephemeral keys
//    pEC        pointer to the ECCP context
//
*F*/
IPPFUN(IppStatus, ippsECCPSetKeyPair, (const IppsBigNumState* pPrivate, const IppsECCPPointState* pPublic,
                                       IppBool regular,
                                       IppsECCPState* pEC))
{
   /* use aligned EC context */
   IPP_BAD_PTR1_RET(pEC);
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   {
      BNU_CHUNK_T* targetPrivate;
      BNU_CHUNK_T* targetPublic;

      if(regular) {
         targetPrivate = ECP_PRIVAT(pEC);
         targetPublic  = ECP_PUBLIC(pEC);
      }
      else {
         targetPrivate = ECP_PRIVAT_E(pEC);
         targetPublic  = ECP_PUBLIC_E(pEC);
      }

      /* set up private key request */
      if( pPrivate ) {
         pPrivate = (IppsBigNumState*)( IPP_ALIGNED_PTR(pPrivate, ALIGN_VAL) );
         IPP_BADARG_RET(!BN_VALID_ID(pPrivate), ippStsContextMatchErr);
         {
            int privateLen = BITS_BNU_CHUNK(ECP_ORDBITSIZE(pEC));
            cpGFpElementCopyPadd(targetPrivate, privateLen, BN_NUMBER(pPrivate), BN_SIZE(pPrivate));
         }
      }

      /* set up public  key request */
      if( pPublic ) {
         IPP_BADARG_RET( !ECP_POINT_TEST_ID(pPublic), ippStsContextMatchErr );
         {
            BNU_CHUNK_T* targetPublicX = targetPublic;
            BNU_CHUNK_T* targetPublicY = targetPublic+ECP_POINT_FELEN(pPublic);
            gfec_GetPoint(targetPublicX, targetPublicY, pPublic, pEC);
            gfec_SetPoint(targetPublic, targetPublicX, targetPublicY, pEC);

            //cpGFpElementCopy(targetPublic, ECP_POINT_DATA(pPublic), publicLen);
         }
      }

      return ippStsNoErr;
   }
}
