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
//  Purpose:
//     Cryptography Primitive.
//     Security Hash Standard
//     Internal Definitions and Internal Functions Prototypes
//
*/

#if !defined(_CP_HASH_RMF_H)
#define _CP_HASH_RMF_H

#include "pcphash.h"
#include "pcphashmethod_rmf.h"

struct _cpHashCtx_rmf {
   IppCtxId    idCtx;                     /* hash identifier   */
   const cpHashMethod_rmf* pMethod;       /* hash methods      */
   int         msgBuffIdx;                /* buffer index      */
   Ipp8u       msgBuffer[MBS_HASH_MAX];   /* buffer            */
   Ipp64u      msgLenLo;                  /* processed message */
   Ipp64u      msgLenHi;                  /* length (bytes)    */
   cpHash      msgHash;                    /* hash value        */
};

/* accessors */
#define HASH_CTX_ID(stt)   ((stt)->idCtx)
#define HASH_METHOD(stt)   ((stt)->pMethod)
#define HAHS_BUFFIDX(stt)  ((stt)->msgBuffIdx)
#define HASH_BUFF(stt)     ((stt)->msgBuffer)
#define HASH_LENLO(stt)    ((stt)->msgLenLo)
#define HASH_LENHI(stt)    ((stt)->msgLenHi)
#define HASH_VALUE(stt)    ((stt)->msgHash)

#define cpFinalize_rmf OWNAPI(cpFinalize_rmf)
void cpFinalize_rmf(DigestSHA512 pHash, const Ipp8u* inpBuffer, int inpLen, Ipp64u lenLo, Ipp64u lenHi, const IppsHashMethod* method);

#endif /* _CP_HASH_RMF_H */
