/*******************************************************************************
* Copyright 2014-2018 Intel Corporation
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
//     General Functionality
// 
//  Contents:
//        ippsHashMessage()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_func.h"
#include "pcptool.h"

/*F*
//    Name: ippsHashMessage
//
// Purpose: Hash of the whole message.
//
// Returns:                Reason:
//    ippStsNullPtrErr           pMD == NULL
//                               pMsg == NULL but len!=0
//    ippStsLengthErr            len <0
//    ippStsNotSupportedModeErr  if hashAlg is not match to supported hash alg
//    ippStsNoErr                no errors
//
// Parameters:
//    pMsg        pointer to the input message
//    len         input message length
//    pMD         address of the output digest
//    hashAlg     hash alg ID
//
*F*/
IPPFUN(IppStatus, ippsHashMessage,(const Ipp8u* pMsg, int len, Ipp8u* pMD, IppHashAlgId hashAlg))
{
   /* get algorithm id */
   hashAlg = cpValidHashAlg(hashAlg);
   /* test hash alg */
   IPP_BADARG_RET(ippHashAlg_Unknown==hashAlg, ippStsNotSupportedModeErr);

   /* test digest pointer */
   IPP_BAD_PTR1_RET(pMD);
   /* test message length */
   IPP_BADARG_RET((len<0), ippStsLengthErr);
   /* test message pointer */
   IPP_BADARG_RET((len && !pMsg), ippStsNullPtrErr);

   {
      /* processing function and parameter */
      cpHashProc hashFunc = cpHashProcFunc[hashAlg];
      const void* pParam = cpHashProcFuncOpt[hashAlg];

      /* attributes */
      const cpHashAttr* pAttr = &cpHashAlgAttr[hashAlg];
      int mbs = pAttr->msgBlkSize;              /* data block size */
      int ivSize = pAttr->ivSize;               /* size of hash's IV */
      int hashSize = pAttr->hashSize;           /* hash size */
      int msgLenRepSize = pAttr->msgLenRepSize; /* length of the message representation */

      /* message bitlength representation */
      Ipp64u msgLenBits = (Ipp64u)len*8;
      /* length of main message part */
      int msgLenBlks = len & (-mbs);
      /* rest of message length */
      int msgLenRest = len - msgLenBlks;

      /* end of message buffer */
      Ipp8u buffer[MBS_HASH_MAX*2];
      int bufferLen = (msgLenRest < (mbs-msgLenRepSize))? mbs : mbs*2;

      /* init hash */
      cpHash hash;
      const Ipp8u* iv = cpHashIV[hashAlg];
      CopyBlock(iv, hash, ivSize);

      /*construct last messge block(s) */
      #define MSG_LEN_REP  (sizeof(Ipp64u))

      /* copy end of message */
      CopyBlock(pMsg+len-msgLenRest, buffer, msgLenRest);
      /* end of message bit */
      buffer[msgLenRest++] = 0x80;
      /* padd buffer */
      PaddBlock(0, buffer+msgLenRest, bufferLen-msgLenRest-MSG_LEN_REP);
      /* copy message bitlength representation */
      if(ippHashAlg_MD5!=hashAlg)
         msgLenBits = ENDIANNESS64(msgLenBits);
      ((Ipp64u*)(buffer+bufferLen))[-1] = msgLenBits;

      #undef MSG_LEN_REP

      /* message processing */
      if(msgLenBlks)
         hashFunc(hash, pMsg, msgLenBlks, pParam);
      hashFunc(hash, buffer, bufferLen, pParam);

      /* store digest into the user buffer (remember digest in big endian) */
      if(msgLenRepSize > (int)(sizeof(Ipp64u))) {
         /* ippHashAlg_SHA384, ippHashAlg_SHA512, ippHashAlg_SHA512_224 and ippHashAlg_SHA512_256 */
         hash[0] = ENDIANNESS64(hash[0]);
         hash[1] = ENDIANNESS64(hash[1]);
         hash[2] = ENDIANNESS64(hash[2]);
         hash[3] = ENDIANNESS64(hash[3]);
         hash[4] = ENDIANNESS64(hash[4]);
         hash[5] = ENDIANNESS64(hash[5]);
         hash[6] = ENDIANNESS64(hash[6]);
         hash[7] = ENDIANNESS64(hash[7]);
      }
      else if(ippHashAlg_MD5!=hashAlg) {
         /* ippHashAlg_SHA1, ippHashAlg_SHA224, ippHashAlg_SHA256 and ippHashAlg_SM3 */
         ((Ipp32u*)hash)[0] = ENDIANNESS32(((Ipp32u*)hash)[0]);
         ((Ipp32u*)hash)[1] = ENDIANNESS32(((Ipp32u*)hash)[1]);
         ((Ipp32u*)hash)[2] = ENDIANNESS32(((Ipp32u*)hash)[2]);
         ((Ipp32u*)hash)[3] = ENDIANNESS32(((Ipp32u*)hash)[3]);
         ((Ipp32u*)hash)[4] = ENDIANNESS32(((Ipp32u*)hash)[4]);
         ((Ipp32u*)hash)[5] = ENDIANNESS32(((Ipp32u*)hash)[5]);
         ((Ipp32u*)hash)[6] = ENDIANNESS32(((Ipp32u*)hash)[6]);
         ((Ipp32u*)hash)[7] = ENDIANNESS32(((Ipp32u*)hash)[7]);
      }
      CopyBlock(hash, pMD, hashSize);

      return ippStsNoErr;
   }
}
