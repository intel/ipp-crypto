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
#if !defined(_PCP_HASH_METHOD_RMF_H)
#define _PCP_HASH_METHOD_RMF_H

/* hash alg methods */
typedef void (*hashInitF)(void* pHash);
typedef void (*hashUpdateF)(void* pHash, const Ipp8u* pMsg, int msgLen);
typedef void (*hashOctStrF)(Ipp8u* pDst, void* pHash);
typedef void (*msgLenRepF)(Ipp8u* pDst, Ipp64u lenLo, Ipp64u lenHi);

typedef struct _cpHashMethod_rmf {
   IppHashAlgId   hashAlgId;     /* algorithm ID */
   int            hashLen;       /* hash length in bytes */
   int            msgBlkSize;    /* message blkock size in bytes */
   int            msgLenRepSize; /* length of processed msg length representation in bytes */
   hashInitF      hashInit;      /* set initial hash value */
   hashUpdateF    hashUpdate;    /* hash compressor */
   hashOctStrF    hashOctStr;    /* convert hash into oct string */
   msgLenRepF     msgLenRep;     /* processed mgs length representation */
} cpHashMethod_rmf;

#endif /* _PCP_HASH_METHOD_RMF_H */
