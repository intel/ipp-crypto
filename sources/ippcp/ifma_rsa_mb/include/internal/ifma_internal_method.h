/*******************************************************************************
* Copyright 2019 Intel Corporation
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
//  Purpose: MB RSA.
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#if !defined(_IFMA_INTERNAL_METHOD_H_)
#define _IFMA_INTERNAL_METHOD_H_

#include "rsa_ifma_defs.h"


/* exponentiations */
typedef void(*EXP52x_65537_mb8)(int64u out[][8],
   const int64u base[][8],
   const int64u modulus[][8],
   const int64u toMont[][8],
   const int64u  k0[8]);
typedef void(*EXP52x_mb8)(int64u out[][8],
   const int64u base[][8],
   const int64u exponent[][8],
   const int64u modulus[][8],
   const int64u toMont[][8],
   const int64u k0_mb8[8]);

/* convert non-contiguos BigNumber to 2^52 radix and store into mb8 */
//typedef int8u (*cvt52BN_to_mb8)(int64u res[][8], const void* const bn[8], int bitLen);
/* copy non-contiguos BigNumber into mb8 */
//typedef int8u (*tcopyBN_to_mb8)(int64u res[][8], const void* const bn[8], int bitLen);

/*
// auxiliary mb8 arithmethic
*/
/* Mont reduction */
typedef void (*amred52x_mb8)(int64u res[][8], const int64u inpA[][8], const int64u inpM[][8], const int64u k0[8]);
/* Mont multiplication */
typedef void   (*ammul52x_mb8)(int64u* out_mb8, const int64u* inpA_mb8, const int64u* inpB_mb8, const int64u* inpM_mb8, const int64u* k0_mb8);
/* modular subtraction */
typedef void (*modsub52x_mb8)(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8], const int64u inpM[][8]);
/* multiply and add */
typedef void (*addmul52x_mb8)(int64u res[][8], const int64u inpA[][8], const int64u inpB[][8]);

/* RSA operation */
typedef enum {
   RSA_PUB_KEY  = (0x01<<16),
   RSA_PRV2_KEY = (0x20<<16),
   RSA_PRV5_KEY = (0x50<<16),
} RSA_OP_ID;

/* RSA size */
typedef enum {
   RSA1024 = 1024,
   RSA2048 = 2048,
   RSA3072 = 3072,
   RSA4096 = 4096,
} RSA_BITSIZE_ID;

/* RSA ID */
#define RSA_ID(OP,BITSIZE) ((OP) | (BITSIZE))
#define OP_RSA_ID(ID)      ((ID) & (0xFF<<16))
#define BISIZE_RSA_ID(ID)  ((ID) & 0xFFFF)

typedef struct _ifma_rsa_method_rsa {
   int          id;             /* exponentiation's id (=1/2/5 -- public(fixed)/private/private_crt */
   int          rsaBitsize;     /* size of rsa modulus (bits) */
   int          buffSize;       /* size of scratch buffer */
   //cvt52BN_to_mb8   cvt52;      /* convert non-contiguos BN to radix 2^52 and strore in mb8 forman */
   //tcopyBN_to_mb8   tcopy;      /* copy non-contiguos BN into mb8 format */
   EXP52x_65537_mb8 expfunc65537;   /* "exp52x_fix_mb8" fixed exponentiation */
   EXP52x_mb8       expfun;         /* "exp52x_arb_mb8" exponentiation */
   amred52x_mb8  amred52x;          /* reduction */
   ammul52x_mb8  ammul52x;          /* multiplication */
   modsub52x_mb8 modsub52x;         /* subtration */
   addmul52x_mb8 mla52x;            /* multiply & add */
} ifma_RSA_Method;

#endif /* _IFMA_INTERNAL_METHOD_H_ */

#endif
