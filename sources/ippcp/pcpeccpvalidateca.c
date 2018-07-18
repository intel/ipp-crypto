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
//     EC over Prime Finite Field (validate domain parameters)
// 
//  Contents:
//     ippsECCPValidate()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"


/*F*
//    Name: ippsECCPValidate
//
// Purpose: Validate ECC Domain Parameters.
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pEC
//                            NULL == c
//                            NULL == pSeed
//                            NULL == pResult
//
//    ippStsContextMatchErr   illegal pEC->idCtx
//                            illegal c->idCtx
//
//    ippStsBadArgErr         nTrials <=0
//                            BN_SIZE(c)<5
//
//    ippStsNoErr             no errors
//
// Parameters:
//    nTrials     number of trials of primality test
//    pResult     pointer to the validation result
//    pEC        pointer to the ECC context
//    rndFunc     Specified Random Generator.
//    pRndParam   Pointer to Random Generator context.
//
// Note
//    Validation Domain Parameters folowing by P1363 recommendation
//    (reference A.16.8)
//
*F*/

#define _DISABLE_TEST_PRIMALITY_
// validation has been reduced in comparison with legacy version:
// - no primality test of underlying prime
// - no primality test of base point order
// - no MOV test

IPPFUN(IppStatus, ippsECCPValidate, (int nTrials, IppECResult* pResult, IppsECCPState* pEC,
                                     IppBitSupplier rndFunc, void* pRndParam))
{
   #if defined(_DISABLE_TEST_PRIMALITY_)
   UNREFERENCED_PARAMETER(nTrials);
   UNREFERENCED_PARAMETER(rndFunc);
   UNREFERENCED_PARAMETER(pRndParam);
   #else
   /* test number of trials for primality check */
   IPP_BADARG_RET(nTrials<=0, ippStsBadArgErr);
   IPP_BAD_PTR2_RET(rndFunc, pRndParam);
   #endif

   IPP_BAD_PTR2_RET(pResult, pEC);

   /* use aligned EC context */
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );
   IPP_BADARG_RET(!ECP_TEST_ID(pEC), ippStsContextMatchErr);

   return ippsGFpECVerify(pResult, pEC, (Ipp8u*)ECP_SBUFFER(pEC));
}
