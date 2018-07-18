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
//        ippsHashUpdate()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcptool.h"


/*F*
//    Name: ippsHashUpdate
//
// Purpose: Updates intermediate hash value based on input stream.
//
// Returns:                   Reason:
//    ippStsNullPtrErr           pState == NULL
//                               pSrc==0 but len!=0
//    ippStsContextMatchErr      pState->idCtx != idCtxHash
//    ippStsLengthErr            len <0
//    ippStsNoErr                no errors
//
// Parameters:
//    pSrc     pointer to the input stream
//    len      input stream length
//    pState   pointer to the Hash context
//
*F*/
__INLINE int IsExceedMsgLen(Ipp64u maxLo, Ipp64u maxHi, Ipp64u lenLo, Ipp64u lenHi)
{
   int isExceed = lenLo > maxLo;
   isExceed = (lenHi+isExceed) > maxHi;
   return isExceed;
}

IPPFUN(IppStatus, ippsHashUpdate,(const Ipp8u* pSrc, int len, IppsHashState* pState))
{
   /* test state pointer and ID */
   IPP_BAD_PTR1_RET(pState);
   /* test the context */
   IPP_BADARG_RET(!HASH_VALID_ID(pState), ippStsContextMatchErr);
   /* test input length */
   IPP_BADARG_RET((len<0 && pSrc), ippStsLengthErr);
   /* test source pointer */
   IPP_BADARG_RET((len && !pSrc), ippStsNullPtrErr);

   /* handle non empty input */
   if(len) {
      const cpHashAttr* pAttr = &cpHashAlgAttr[HASH_ALG_ID(pState)];

      /* test if size of message is being processed not exceeded yet */
      Ipp64u lenLo = HASH_LENLO(pState);
      Ipp64u lenHi = HASH_LENHI(pState);
      lenLo += len;
      if(lenLo < HASH_LENLO(pState)) lenHi++;
      if(IsExceedMsgLen(pAttr->msgLenMax[0],pAttr->msgLenMax[1], lenLo,lenHi))
         IPP_ERROR_RET(ippStsLengthErr);

      else {
         cpHashProc hashFunc = HASH_FUNC(pState);    /* processing function */
         const void* pParam = HASH_FUNC_PAR(pState); /* and it's addition params */
         int mbs = pAttr->msgBlkSize;              /* data block size */

         /*
         // processing
         */
         {
            int procLen;

            /* test if internal buffer is not empty */
            int n = HAHS_BUFFIDX(pState);
            if(n) {
               procLen = IPP_MIN(len, (mbs-n));
               CopyBlock(pSrc, HASH_BUFF(pState)+n, procLen);
               HAHS_BUFFIDX(pState) = n += procLen;

               /* block processing */
               if(mbs==n) {
                  hashFunc(HASH_VALUE(pState), HASH_BUFF(pState), mbs, pParam);
                  HAHS_BUFFIDX(pState) = 0;
               }

               /* update message pointer and length */
               pSrc += procLen;
               len  -= procLen;
            }

            /* main processing part */
            procLen = len & ~(mbs-1);
            if(procLen) {
               hashFunc(HASH_VALUE(pState), pSrc, procLen, pParam);
               pSrc += procLen;
               len  -= procLen;
            }

            /* rest of input message */
            if(len) {
               CopyBlock(pSrc, HASH_BUFF(pState), len);
               HAHS_BUFFIDX(pState) += len;
            }
         }

         /* update length of processed message */
         HASH_LENLO(pState) = lenLo;
         HASH_LENHI(pState) = lenHi;

         return ippStsNoErr;
      }
   }

   return ippStsNoErr;
}
