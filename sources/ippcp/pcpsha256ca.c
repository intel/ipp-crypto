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
//     cpFinalizeSHA256()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcphash.h"
#include "pcphash_rmf.h"
#include "pcptool.h"
#include "pcpsha256stuff.h"

void cpFinalizeSHA256(DigestSHA256 pHash, const Ipp8u* inpBuffer, int inpLen, Ipp64u processedMsgLen)
{
   /* select processing  function */
   #if (_SHA_NI_ENABLING_==_FEATURE_ON_)
   cpHashProc updateFunc = UpdateSHA256ni;
   #elif (_SHA_NI_ENABLING_==_FEATURE_TICKTOCK_)
   cpHashProc updateFunc = IsFeatureEnabled(ippCPUID_SHA)? UpdateSHA256ni : UpdateSHA256;
   #else
   cpHashProc updateFunc = UpdateSHA256;
   #endif

   /* local buffer and it length */
   Ipp8u buffer[MBS_SHA256*2];
   int bufferLen = inpLen < (MBS_SHA256-(int)MLR_SHA256)? MBS_SHA256 : MBS_SHA256*2; 

   /* copy rest of message into internal buffer */
   CopyBlock(inpBuffer, buffer, inpLen);

   /* padd message */
   buffer[inpLen++] = 0x80;
   PaddBlock(0, buffer+inpLen, bufferLen-inpLen-MLR_SHA256);

   /* put processed message length in bits */
   processedMsgLen = ENDIANNESS64(processedMsgLen<<3);
   ((Ipp64u*)(buffer+bufferLen))[-1] = processedMsgLen;

   /* copmplete hash computation */
   updateFunc(pHash, buffer, bufferLen, sha256_cnt);
}