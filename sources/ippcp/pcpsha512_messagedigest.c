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
//     SHA512 message digest
// 
//  Contents:
//        cpSHA512MessageDigest()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_rmf.h"
#include "pcptool.h"
#include "pcpsha512stuff.h"

IppStatus cpSHA512MessageDigest(DigestSHA512 hash, const Ipp8u* pMsg, int msgLen, const DigestSHA512 IV)
{
   /* test digest pointer */
   IPP_BAD_PTR1_RET(hash);
   /* test message length */
   IPP_BADARG_RET((msgLen<0), ippStsLengthErr);
   /* test message pointer */
   IPP_BADARG_RET((msgLen && !pMsg), ippStsNullPtrErr);

   {
      /* message length in the multiple MBS and the rest */
      int msgLenBlks = msgLen & (-MBS_SHA512);
      int msgLenRest = msgLen - msgLenBlks;

      /* init hash */
      hashInit(hash, IV);

      /* process main part of the message */
      if(msgLenBlks) {
         UpdateSHA512(hash, pMsg, msgLenBlks, sha512_cnt);
         pMsg += msgLenBlks;
      }

      cpFinalizeSHA512(hash, pMsg, msgLenRest, msgLen, 0);
      hash[0] = ENDIANNESS64(hash[0]);
      hash[1] = ENDIANNESS64(hash[1]);
      hash[2] = ENDIANNESS64(hash[2]);
      hash[3] = ENDIANNESS64(hash[3]);
      hash[4] = ENDIANNESS64(hash[4]);
      hash[5] = ENDIANNESS64(hash[5]);
      hash[6] = ENDIANNESS64(hash[6]);
      hash[7] = ENDIANNESS64(hash[7]);

      return ippStsNoErr;
   }
}
