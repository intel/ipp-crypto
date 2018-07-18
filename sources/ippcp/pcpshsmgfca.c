/*******************************************************************************
* Copyright 2005-2018 Intel Corporation
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
//     HASH based Mask Generation Functions
// 
//  Contents:
//     ippsMGF_SHA1()
//     ippsMGF_SHA224()
//     ippsMGF_SHA256()
//     ippsMGF_SHA384()
//     ippsMGF_SHA512()
//     ippsMGF_MD5()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcptool.h"


/*F*
//    Name: ippsMGF_SHA1
//          ippsMGF_SHA224
//          ippsMGF_SHA256
//          ippsMGF_SHA384
//          ippsMGF_SHA512
//          ippsMGF_MD5
//
// Purpose: Mask Generation Functions.
//
// Returns:                Reason:
//    ippStsNullPtrErr           pMask == NULL
//    ippStsLengthErr            seedLen <0
//                               maskLen <0
//    ippStsNotSupportedModeErr  if algID is not match to supported hash alg
//    ippStsNoErr                no errors
//
// Parameters:
//    pSeed       pointer to the input stream
//    seedLen     input stream length (bytes)
//    pMask       pointer to the ouput mask
//    maskLen     desired length of mask (bytes)
//    hashAlg     identifier of the hash algorithm
//
*F*/
IPPFUN(IppStatus, ippsMGF,(const Ipp8u* pSeed, int seedLen, Ipp8u* pMask, int maskLen, IppHashAlgId hashAlg))
{
   /* get algorithm id */
   hashAlg = cpValidHashAlg(hashAlg);
   /* test hash alg */
   IPP_BADARG_RET(ippHashAlg_Unknown==hashAlg, ippStsNotSupportedModeErr);

   IPP_BAD_PTR1_RET(pMask);
   IPP_BADARG_RET((seedLen<0)||(maskLen<0), ippStsLengthErr);

   {
      /* hash specific */
      int hashSize = cpHashSize(hashAlg);

      int i, outLen;

      IppsHashState hashCtx;
      ippsHashInit(&hashCtx, hashAlg);

      if(!pSeed)
         seedLen = 0;

      for(i=0,outLen=0; outLen<maskLen; i++) {
         Ipp8u cnt[4];
         cnt[0] = (Ipp8u)((i>>24) & 0xFF);
         cnt[1] = (Ipp8u)((i>>16) & 0xFF);
         cnt[2] = (Ipp8u)((i>>8)  & 0xFF);
         cnt[3] = (Ipp8u)(i & 0xFF);

         cpReInitHash(&hashCtx, hashAlg);
         ippsHashUpdate(pSeed, seedLen, &hashCtx);
         ippsHashUpdate(cnt,   4,       &hashCtx);

         if((outLen + hashSize) <= maskLen) {
            ippsHashFinal(pMask+outLen, &hashCtx);
            outLen += hashSize;
         }
         else {
            Ipp8u md[MAX_HASH_SIZE];
            ippsHashFinal(md, &hashCtx);
            CopyBlock(md, pMask+outLen, maskLen-outLen);
            outLen = maskLen;
         }
      }

      return ippStsNoErr;
   }
}
