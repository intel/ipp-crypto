/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//     Digesting message according to SHA256
// 
//  Contents:
//        cpSHA256MessageDigest()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_rmf.h"
#include "pcptool.h"
#include "pcpsha256stuff.h"

IppStatus cpSHA256MessageDigest(DigestSHA256 hash, const Ipp8u* pMsg, int msgLen, const DigestSHA256 IV)
{
   /* test digest pointer */
   IPP_BAD_PTR1_RET(hash);
   /* test message length */
   IPP_BADARG_RET((msgLen<0), ippStsLengthErr);
   /* test message pointer */
   IPP_BADARG_RET((msgLen && !pMsg), ippStsNullPtrErr);

   {
      /* select processing function */
      #if (_SHA_NI_ENABLING_==_FEATURE_ON_)
      cpHashProc updateFunc = UpdateSHA256ni;
      #elif (_SHA_NI_ENABLING_==_FEATURE_TICKTOCK_)
      cpHashProc updateFunc = IsFeatureEnabled(ippCPUID_SHA)? UpdateSHA256ni : UpdateSHA256;
      #else
      cpHashProc updateFunc = UpdateSHA256;
      #endif

      /* message length in the multiple MBS and the rest */
      int msgLenBlks = msgLen & (-MBS_SHA256);
      int msgLenRest = msgLen - msgLenBlks;

      /* init hash */
      hash[0] = IV[0];
      hash[1] = IV[1];
      hash[2] = IV[2];
      hash[3] = IV[3];
      hash[4] = IV[4];
      hash[5] = IV[5];
      hash[6] = IV[6];
      hash[7] = IV[7];

      /* process main part of the message */
      if(msgLenBlks) {
         updateFunc(hash, pMsg, msgLenBlks, sha256_cnt);
         pMsg += msgLenBlks;
      }

      cpFinalizeSHA256(hash, pMsg, msgLenRest, msgLen);
      hash[0] = ENDIANNESS32(hash[0]);
      hash[1] = ENDIANNESS32(hash[1]);
      hash[2] = ENDIANNESS32(hash[2]);
      hash[3] = ENDIANNESS32(hash[3]);
      hash[4] = ENDIANNESS32(hash[4]);
      hash[5] = ENDIANNESS32(hash[5]);
      hash[6] = ENDIANNESS32(hash[6]);
      hash[7] = ENDIANNESS32(hash[7]);

      return ippStsNoErr;
   }
}
