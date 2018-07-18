/*******************************************************************************
* Copyright 2004-2018 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
//                    Prime Number Primitives.
// 
// 
*/


#if !defined(_CP_PRIME_H)
#define _CP_PRIME_H

#include "pcpbn.h"
#include "pcpmontgomery.h"


/*
// Prime context
*/
struct _cpPrime {
   IppCtxId          idCtx;      /* Prime context identifier */
   cpSize            maxBitSize; /* max bit length             */
   BNU_CHUNK_T*      pPrime;     /* prime value   */
   BNU_CHUNK_T*      pT1;        /* temporary BNU */
   BNU_CHUNK_T*      pT2;        /* temporary BNU */
   BNU_CHUNK_T*      pT3;        /* temporary BNU */
   gsModEngine*      pMont;      /* montgomery engine        */
};

/* alignment */
#define PRIME_ALIGNMENT ((int)sizeof(void*))

/* Prime accessory macros */
#define PRIME_ID(ctx)         ((ctx)->idCtx)
#define PRIME_MAXBITSIZE(ctx) ((ctx)->maxBitSize)
#define PRIME_NUMBER(ctx)     ((ctx)->pPrime)
#define PRIME_TEMP1(ctx)      ((ctx)->pT1)
#define PRIME_TEMP2(ctx)      ((ctx)->pT2)
#define PRIME_TEMP3(ctx)      ((ctx)->pT3)
#define PRIME_MONT(ctx)       ((ctx)->pMont)

#define PRIME_VALID_ID(ctx)   (PRIME_ID((ctx))==idCtxPrimeNumber)

/*
// Number of Miller-Rabin rounds for an error rate of less than 1/2^80 for random 'b'-bit input, b >= 100.
// (see Table 4.4, Handbook of Applied Cryptography [Menezes, van Oorschot, Vanstone; CRC Press 1996]
*/
#define MR_rounds_p80(b) ((b) >= 1300 ?  2 : \
                          (b) >=  850 ?  3 : \
                          (b) >=  650 ?  4 : \
                          (b) >=  550 ?  5 : \
                          (b) >=  450 ?  6 : \
                          (b) >=  400 ?  7 : \
                          (b) >=  350 ?  8 : \
                          (b) >=  300 ?  9 : \
                          (b) >=  250 ? 12 : \
                          (b) >=  200 ? 15 : \
                          (b) >=  150 ? 18 : \
                        /*(b) >=  100*/ 27)

/* easy prime test */
#define cpMimimalPrimeTest OWNAPI(cpMimimalPrimeTest)
int cpMimimalPrimeTest(const Ipp32u* pPrime, cpSize ns);

/* prime test */
#define cpPrimeTest OWNAPI(cpPrimeTest)
int cpPrimeTest(const BNU_CHUNK_T* pPrime, cpSize primeLen,
                cpSize nTrials,
                IppsPrimeState* pCtx,
                IppBitSupplier rndFunc, void* pRndParam);

#define cpPackPrimeCtx OWNAPI(cpPackPrimeCtx)
void cpPackPrimeCtx(const IppsPrimeState* pCtx, Ipp8u* pBuffer);
#define cpUnpackPrimeCtx OWNAPI(cpUnpackPrimeCtx)
void cpUnpackPrimeCtx(const Ipp8u* pBuffer, IppsPrimeState* pCtx);

#endif /* _CP_PRIME_H */
