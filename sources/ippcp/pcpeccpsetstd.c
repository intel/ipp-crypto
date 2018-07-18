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
//        ippsECCPSetStd()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpeccp.h"

/*F*
//    Name: ippsECCPSetStd
//
// Purpose: Set Standard ECC Domain Parameter.
//
// Returns:                Reason:
//    ippStsNullPtrErr        NULL == pEC
//
//    ippStsContextMatchErr   illegal pEC->idCtx
//
//    ippStsECCInvalidFlagErr invalid flag
//
//    ippStsNoErr             no errors
//
// Parameters:
//    flag     specify standard ECC parameter(s) to be setup
//    pEC     pointer to the ECC context
//
*F*/
IPPFUN(IppStatus, ippsECCPSetStd, (IppECCType flag, IppsECCPState* pEC))
{
   /* test pEC */
   IPP_BAD_PTR1_RET(pEC);
   /* use aligned EC context */
   pEC = (IppsGFpECState*)( IPP_ALIGNED_PTR(pEC, ECGFP_ALIGNMENT) );

   switch(flag) {
      case IppECCPStd112r1:
         return ECCPSetDP(ippsGFpMethod_pArb(),
                  BITS_BNU_CHUNK(112), secp112r1_p,
                  BITS_BNU_CHUNK(112), secp112r1_a,
                  BITS_BNU_CHUNK(112), secp112r1_b,
                  BITS_BNU_CHUNK(112), secp112r1_gx,
                  BITS_BNU_CHUNK(112), secp112r1_gy,
                  BITS_BNU_CHUNK(112), secp112r1_r,
                  secp112r1_h, pEC);

      case IppECCPStd112r2:
         return ECCPSetDP(ippsGFpMethod_pArb(),
                  BITS_BNU_CHUNK(112), secp112r2_p,
                  BITS_BNU_CHUNK(112), secp112r2_a,
                  BITS_BNU_CHUNK(112), secp112r2_b,
                  BITS_BNU_CHUNK(112), secp112r2_gx,
                  BITS_BNU_CHUNK(112), secp112r2_gy,
                  BITS_BNU_CHUNK(112), secp112r2_r,
                  secp112r2_h, pEC);

      case IppECCPStd128r1: return ippsECCPSetStd128r1(pEC);

      case IppECCPStd128r2: return ippsECCPSetStd128r2(pEC);

      case IppECCPStd160r1:
         return ECCPSetDP(ippsGFpMethod_pArb(),
                  BITS_BNU_CHUNK(160), secp160r1_p,
                  BITS_BNU_CHUNK(160), secp160r1_a,
                  BITS_BNU_CHUNK(160), secp160r1_b,
                  BITS_BNU_CHUNK(160), secp160r1_gx,
                  BITS_BNU_CHUNK(160), secp160r1_gy,
                  BITS_BNU_CHUNK(161), secp160r1_r,
                  secp160r1_h, pEC);

      case IppECCPStd160r2:
         return ECCPSetDP(ippsGFpMethod_pArb(),
               BITS_BNU_CHUNK(160), secp160r2_p,
               BITS_BNU_CHUNK(160), secp160r2_a,
               BITS_BNU_CHUNK(160), secp160r2_b,
               BITS_BNU_CHUNK(160), secp160r2_gx,
               BITS_BNU_CHUNK(160), secp160r2_gy,
               BITS_BNU_CHUNK(161), secp160r2_r,
               secp160r2_h, pEC);

      case IppECCPStd192r1: return ippsECCPSetStd192r1(pEC);

      case IppECCPStd224r1: return ippsECCPSetStd224r1(pEC);

      case IppECCPStd256r1: return ippsECCPSetStd256r1(pEC);

      case IppECCPStd384r1: return ippsECCPSetStd384r1(pEC);

      case IppECCPStd521r1: return ippsECCPSetStd521r1(pEC);

      case ippEC_TPM_BN_P256:
         return ECCPSetDP(ippsGFpMethod_pArb(),
                  BITS_BNU_CHUNK(256), tpmBN_p256p_p,
                  BITS_BNU_CHUNK(32),  tpmBN_p256p_a,
                  BITS_BNU_CHUNK(32),  tpmBN_p256p_b,
                  BITS_BNU_CHUNK(32),  tpmBN_p256p_gx,
                  BITS_BNU_CHUNK(32),  tpmBN_p256p_gy,
                  BITS_BNU_CHUNK(256), tpmBN_p256p_r,
                  tpmBN_p256p_h, pEC);

      case ippECPstdSM2: return ippsECCPSetStdSM2(pEC);

      default:
         return ippStsECCInvalidFlagErr;
   }
}
