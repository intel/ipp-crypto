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
//     Internal Definitions and
//     Internal DL (prime) basic Definitions & Function Prototypes
// 
// 
*/

#if !defined(_PCP_DLP_H)
#define _PCP_DLP_H

#include "pcpbn.h"
#include "pcpmontgomery.h"
#include "pcpprimeg.h"
#include "pcpbnresource.h"

/*
// DLP context
*/

//#define MIN_DLP_BITSIZE     (512)
//#define MAX_DLP_BITSIZE    (2048)
//#define DEF_DLP_BITSIZER    (160)

struct _cpDLP {
   IppCtxId          idCtx;      /* DL identifier  */
   Ipp32u            flag;       /* complete flag  */

   int               bitSizeP;   /* DH bitsize (P) */
   int               bitSizeR;   /* DH bitsize (R) */

   int               method;     /* exponentiation method: binary/window */
   gsModEngine*      pMontP0;    /* Montgomery P-engine */
   gsModEngine*      pMontP1;    /* Montgomery P-engine (for multithread version) */
   gsModEngine*      pMontR;     /* Montgomery R-engine */

   IppsBigNumState*  pGenc;      /* P-encoded DL generator    */
   IppsBigNumState*  pX;         /*           private key */
   IppsBigNumState*  pYenc;      /* P-encoded public  key */

   IppsPrimeState*   pPrimeGen;  /* prime generator     */

   BNU_CHUNK_T*      pMeTable;   /* pre-computed multi-exp table */

   BigNumNode*      pBnList;    /* BN  resource */
   #if defined(_USE_WINDOW_EXP_)
   BNU_CHUNK_T*      pBnuList0;  /* BNU resource */
   BNU_CHUNK_T*      pBnuList1;  /* BNU resource (for multithread version) */
   #endif
};

/*
// Exponentiation method
*/
#define BINARY       (0)
#define WINDOW       ((BINARY)+1)

#define BNLISTSIZE   (8)        /* list size */

/*
// Contetx Access Macros
*/
#define DLP_ID(ctx)        ((ctx)->idCtx)
#define DLP_FLAG(ctx)      ((ctx)->flag)
#define DLP_BITSIZEP(ctx)  ((ctx)->bitSizeP)
#define DLP_BITSIZER(ctx)  ((ctx)->bitSizeR)
#define DLP_EXPMETHOD(ctx) ((ctx)->method)

#define DLP_MONTP0(ctx)    ((ctx)->pMontP0)
#define DLP_MONTP1(ctx)    ((ctx)->pMontP1)
#define DLP_MONTR(ctx)     ((ctx)->pMontR)

#define DLP_P(ctx)         (MOD_MODULUS(DLP_MONTP0((ctx))))
#define DLP_R(ctx)         (MOD_MODULUS(DLP_MONTR((ctx))))
#define DLP_GENC(ctx)      ((ctx)->pGenc)
#define DLP_X(ctx)         ((ctx)->pX)
#define DLP_YENC(ctx)      ((ctx)->pYenc)

#define DLP_PRIMEGEN(ctx)  ((ctx)->pPrimeGen)

#define DLP_METBL(ctx)     ((ctx)->pMeTable)
#define DLP_BNCTX(ctx)     ((ctx)->pBnList)
#if defined(_USE_WINDOW_EXP_)
#define DLP_BNUCTX0(ctx)   ((ctx)->pBnuList0)
#define DLP_BNUCTX1(ctx)   ((ctx)->pBnuList1)
#endif

#define DLP_VALID_ID(ctx)  (DLP_ID((ctx))==idCtxDLP)
#define DLP_COMPLETE(ctx)  (DLP_FLAG((ctx))==(IppDLPkeyP|IppDLPkeyR|IppDLPkeyG))

/* alignment */
#define DLP_ALIGNMENT ((int)(sizeof(void*)))

/* pool size for gsModEngine */
#define DLP_MONT_POOL_LENGTH (6)

#define cpPackDLPCtx OWNAPI(cpPackDLPCtx)
   void cpPackDLPCtx(const IppsDLPState* pDLP, Ipp8u* pBuffer);
#define cpUnpackDLPCtx OWNAPI(cpUnpackDLPCtx)
   void cpUnpackDLPCtx(const Ipp8u* pBuffer, IppsDLPState* pDLP);

#endif /* _PCP_DLP_H */
