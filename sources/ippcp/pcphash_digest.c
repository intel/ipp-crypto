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
//        cpComputeDigest()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcptool.h"


void cpComputeDigest(Ipp8u* pHashTag, int hashTagLen, const IppsHashState* pCtx)
{
   /* hash alg and parameters */
   cpHashProc hashFunc = HASH_FUNC(pCtx);    /* processing function */
   const void* pParam = HASH_FUNC_PAR(pCtx); /* and it's addition params */

   /* attributes */
   const cpHashAttr* pAttr = &cpHashAlgAttr[HASH_ALG_ID(pCtx)];
   int mbs = pAttr->msgBlkSize;              /* data block size */
   int ivSize = pAttr->ivSize;               /* size of hash's IV */
   int msgLenRepSize = pAttr->msgLenRepSize; /* length of the message representation */

   /* number of bytes in context buffer */
   int n = HAHS_BUFFIDX(pCtx);
   /* buffer and it actual length */
   Ipp8u buffer[MBS_HASH_MAX*2];
   int bufferLen = n < (mbs-msgLenRepSize)? mbs : mbs*2;

   /* copy current hash value */
   cpHash hash;
   CopyBlock(HASH_VALUE(pCtx), hash, ivSize);

   /* copy of state's buffer */
   CopyBlock(HASH_BUFF(pCtx), buffer, n);
   /* end of message bit */
   buffer[n++] = 0x80;
   /* padd buffer */
   PaddBlock(0, buffer+n, bufferLen-n-msgLenRepSize);

   /* message length representation in bits (remember about big endian) */
   {
      /* convert processed message length bytes ->bits */
      Ipp64u lo = HASH_LENLO(pCtx);
      Ipp64u hi = HASH_LENHI(pCtx);
      hi = LSL64(hi,3) | LSR64(lo,63-3);
      lo = LSL64(lo,3);

      if(msgLenRepSize>(int)(sizeof(Ipp64u))) {
      #if (IPP_ENDIAN == IPP_BIG_ENDIAN)
         ((Ipp64u*)(buffer+bufferLen))[-2] = hi;
      #else
         ((Ipp64u*)(buffer+bufferLen))[-2] = ENDIANNESS64(hi);
      #endif
      }

      /* recall about MD5 specific */
      if(ippHashAlg_MD5!=HASH_ALG_ID(pCtx)) {
         #if (IPP_ENDIAN == IPP_BIG_ENDIAN)
         ((Ipp64u*)(buffer+bufferLen))[-1] = lo;
         #else
         ((Ipp64u*)(buffer+bufferLen))[-1] = ENDIANNESS64(lo);
         #endif
      }
      else {
         #if (IPP_ENDIAN == IPP_BIG_ENDIAN)
         ((Ipp64u*)(buffer+bufferLen))[-1] = ENDIANNESS64(lo);
         #else
         ((Ipp64u*)(buffer+bufferLen))[-1] = lo;
         #endif
      }
   }

   /* copmplete hash computation */
   hashFunc(hash, buffer, bufferLen, pParam);

   /* store digest into the user buffer (remember digest in big endian) */
   if(msgLenRepSize>(int)(sizeof(Ipp64u))) {
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
   else if(ippHashAlg_MD5!=HASH_ALG_ID(pCtx)) {
      ((Ipp32u*)hash)[0] = ENDIANNESS32(((Ipp32u*)hash)[0]);
      ((Ipp32u*)hash)[1] = ENDIANNESS32(((Ipp32u*)hash)[1]);
      ((Ipp32u*)hash)[2] = ENDIANNESS32(((Ipp32u*)hash)[2]);
      ((Ipp32u*)hash)[3] = ENDIANNESS32(((Ipp32u*)hash)[3]);
      ((Ipp32u*)hash)[4] = ENDIANNESS32(((Ipp32u*)hash)[4]);
      if(ippHashAlg_SHA1!=HASH_ALG_ID(pCtx)) {
         ((Ipp32u*)hash)[5] = ENDIANNESS32(((Ipp32u*)hash)[5]);
         ((Ipp32u*)hash)[6] = ENDIANNESS32(((Ipp32u*)hash)[6]);
         ((Ipp32u*)hash)[7] = ENDIANNESS32(((Ipp32u*)hash)[7]);
      }
   }
   CopyBlock(hash, pHashTag, hashTagLen);
}
