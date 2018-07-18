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
//     Internal Definitions and
//     Internal Pseudo Random Generator Function Prototypes
// 
*/

#if !defined(_CP_PRNG_H)
#define _CP_PRNG_H

/*
// Pseudo-random generation context
*/

#define MAX_XKEY_SIZE       512
#define DEFAULT_XKEY_SIZE   512 /* must be >=160 || <=512 */

struct _cpPRNG {
   IppCtxId    idCtx;                                 /* PRNG identifier            */
   cpSize      seedBits;                              /* secret seed-key bitsize    */
   BNU_CHUNK_T Q[BITS_BNU_CHUNK(160)];                /* modulus                    */
   BNU_CHUNK_T T[BITS_BNU_CHUNK(160)];                /* parameter of SHA_G() funct */
   BNU_CHUNK_T xAug[BITS_BNU_CHUNK(MAX_XKEY_SIZE)];   /* optional entropy augment   */
   BNU_CHUNK_T xKey[BITS_BNU_CHUNK(MAX_XKEY_SIZE)];   /* secret seed-key            */
};

/* alignment */
#define PRNG_ALIGNMENT ((int)(sizeof(void*)))

#define RAND_ID(ctx)       ((ctx)->idCtx)
#define RAND_SEEDBITS(ctx) ((ctx)->seedBits)
#define RAND_Q(ctx)        ((ctx)->Q)
#define RAND_T(ctx)        ((ctx)->T)
#define RAND_XAUGMENT(ctx) ((ctx)->xAug)
#define RAND_XKEY(ctx)     ((ctx)->xKey)

#define RAND_VALID_ID(ctx)  (RAND_ID((ctx))==idCtxPRNG)

#define cpPRNGen OWNAPI(cpPRNGen)
int cpPRNGen(Ipp32u* pBuffer, cpSize bitLen, IppsPRNGState* pCtx);

#define cpPRNGenPattern OWNAPI(cpPRNGenPattern)
int cpPRNGenPattern(BNU_CHUNK_T* pRand, int bitSize,
                    BNU_CHUNK_T botPattern, BNU_CHUNK_T topPattern,
                    IppBitSupplier rndFunc, void* pRndParam);

#define cpPRNGenRange OWNAPI(cpPRNGenRange)
int cpPRNGenRange(BNU_CHUNK_T* pRand,
            const BNU_CHUNK_T* pLo, cpSize loLen,
            const BNU_CHUNK_T* pHi, cpSize hiLen,
                  IppBitSupplier rndFunc, void* pRndParam);

#endif /* _CP_PRNG_H */
