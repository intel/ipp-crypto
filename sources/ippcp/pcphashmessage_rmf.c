/*******************************************************************************
* Copyright 2016-2018 Intel Corporation
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
//     Security Hash Standard
//     Generalized Functionality
// 
//  Contents:
//        ippsHashMessage_rmf()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash_rmf.h"
#include "pcptool.h"

/*F*
//    Name: ippsHashMessage_rmf
//
// Purpose: Hash of the whole message.
//
// Returns:                Reason:
//    ippStsNullPtrErr           pMD == NULL
//                               pMsg == NULL but len!=0
//    ippStsLengthErr            len <0
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsg        pointer to the input message
//    len         input message length
//    pMD         address of the output digest
//    pMethod     hash methods
//
*F*/
IPPFUN(IppStatus, ippsHashMessage_rmf,(const Ipp8u* pMsg, int len, Ipp8u* pMD, const IppsHashMethod* pMethod))
{
   /* test method pointer */
   IPP_BAD_PTR1_RET(pMethod);
   /* test digest pointer */
   IPP_BAD_PTR1_RET(pMD);
   /* test message length */
   IPP_BADARG_RET(0>len, ippStsLengthErr);
   IPP_BADARG_RET((len && !pMsg), ippStsNullPtrErr);

   {
      /* message length in the multiple MBS and the rest */
      int msgLenBlks = len &(-pMethod->msgBlkSize);
      int msgLenRest = len - msgLenBlks;

      /* init hash */
      DigestSHA512 hash;
      pMethod->hashInit(hash);

      /* process main part of the message */
      if(msgLenBlks) {
         pMethod->hashUpdate(hash, pMsg, msgLenBlks);
         pMsg += msgLenBlks;
      }
      cpFinalize_rmf(hash,
                     pMsg, msgLenRest,
                     len, 0,
                     pMethod);

      pMethod->hashOctStr(pMD, hash);

      return ippStsNoErr;
   }
}
