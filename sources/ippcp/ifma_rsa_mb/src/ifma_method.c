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
//  Contents: method's declaration
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#include "ifma_internal.h"
#include "ifma_internal_method.h"

/*
// rsa public key methods
*/
const ifma_RSA_Method* ifma_cp_RSA1K_pub65537_Method(void)
{
   #define RSA_BITLEN (RSA_1K)
   #define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PUB_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64+(8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8)*sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      EXP52x20_pub65537_mb8,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
   #undef RSA_BITLEN
   #undef LEN52
}

const ifma_RSA_Method* ifma_cp_RSA2K_pub65537_Method(void)
{
#define RSA_BITLEN (RSA_2K)
#define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PUB_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)* 8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      EXP52x40_pub65537_mb8,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
#undef RSA_BITLEN
#undef LEN52
}

const ifma_RSA_Method* ifma_cp_RSA3K_pub65537_Method(void)
{
#define RSA_BITLEN (RSA_3K)
#define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PUB_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      EXP52x60_pub65537_mb8,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
#undef RSA_BITLEN
#undef LEN52
}

const ifma_RSA_Method* ifma_cp_RSA4K_pub65537_Method(void)
{
#define RSA_BITLEN (RSA_4K)
#define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PUB_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      EXP52x79_pub65537_mb8,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
#undef RSA_BITLEN
#undef LEN52
}

const ifma_RSA_Method* ifma_cp_RSA_pub65537_Method(int rsaBitsize)
{
   switch (rsaBitsize) {
   case RSA_1K: return ifma_cp_RSA1K_pub65537_Method();
   case RSA_2K: return ifma_cp_RSA2K_pub65537_Method();
   case RSA_3K: return ifma_cp_RSA3K_pub65537_Method();
   case RSA_4K: return ifma_cp_RSA4K_pub65537_Method();
   default: return NULL;
   }
}


/*
// rsa private key methods
*/
const ifma_RSA_Method* ifma_cp_RSA1K_private_Method(void)
{
   #define RSA_BITLEN (RSA_1K)
   #define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(RSA_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV2_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN64*8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x20_mb8,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
   #undef RSA_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA2K_private_Method(void)
{
   #define RSA_BITLEN (RSA_2K)
   #define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(RSA_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV2_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN64*8 + LEN52 *8+ LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x40_mb8,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
   #undef RSA_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA3K_private_Method(void)
{
   #define RSA_BITLEN (RSA_3K)
   #define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(RSA_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV2_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN64*8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x60_mb8,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
   #undef RSA_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA4K_private_Method(void)
{
   #define RSA_BITLEN (RSA_4K)
   #define LEN52      (NUMBER_OF_DIGITS(RSA_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(RSA_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV2_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN64*8 + LEN52*8 + LEN52*8 + MULTIPLE_OF(LEN52,10)*8) * sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x79_mb8,
      NULL,
      NULL,
      NULL,
      NULL
   };
   return &m;
   #undef RSA_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA_private_Method(int rsaBitsize)
{
   switch (rsaBitsize) {
   case RSA_1K: return ifma_cp_RSA1K_private_Method();
   case RSA_2K: return ifma_cp_RSA2K_private_Method();
   case RSA_3K: return ifma_cp_RSA3K_private_Method();
   case RSA_4K: return ifma_cp_RSA4K_private_Method();
   default: return NULL;
   }
}


/*
// rsa private key methods (ctr)
*/
const ifma_RSA_Method* ifma_cp_RSA1K_private_ctr_Method(void)
{
   #define RSA_BITLEN (RSA_1K)
   #define FACTOR_BITLEN (RSA_BITLEN/2)
   #define LEN52      (NUMBER_OF_DIGITS(FACTOR_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(FACTOR_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV5_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + LEN64*8 + LEN52*8 + LEN52*8 + LEN52*8 + 2*LEN52*8) *sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x10_mb8,
      ifma_amred52x10_mb8,
      ifma_amm52x10_mb8,
      ifma_modsub52x10_mb8,
      ifma_addmul52x10_mb8
   };
   return &m;
   #undef RSA_BITLEN
   #undef FACTOR_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA2K_private_ctr_Method(void)
{
   #define RSA_BITLEN (RSA_2K)
   #define FACTOR_BITLEN (RSA_BITLEN/2)
   #define LEN52      (NUMBER_OF_DIGITS(FACTOR_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(FACTOR_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV5_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + LEN64*8 + LEN52*8 + LEN52*8 + LEN52*8 + 2*LEN52*8) *sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x20_mb8,
      ifma_amred52x20_mb8,
      ifma_amm52x20_mb8,
      ifma_modsub52x20_mb8,
      ifma_addmul52x20_mb8
   };
   return &m;
   #undef RSA_BITLEN
   #undef FACTOR_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA3K_private_ctr_Method(void)
{
   #define RSA_BITLEN (RSA_3K)
   #define FACTOR_BITLEN (RSA_BITLEN/2)
   #define LEN52      (NUMBER_OF_DIGITS(FACTOR_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(FACTOR_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV5_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + LEN64*8 + LEN52*8 + LEN52*8 + LEN52*8 + 2*LEN52*8) *sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x30_mb8,
      ifma_amred52x30_mb8,
      ifma_amm52x30_mb8,
      ifma_modsub52x30_mb8,
      ifma_addmul52x30_mb8
   };
   return &m;
   #undef RSA_BITLEN
   #undef FACTOR_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA4K_private_ctr_Method(void)
{
   #define RSA_BITLEN (RSA_4K)
   #define FACTOR_BITLEN (RSA_BITLEN/2)
   #define LEN52      (NUMBER_OF_DIGITS(FACTOR_BITLEN, DIGIT_SIZE))
   #define LEN64      (NUMBER_OF_DIGITS(FACTOR_BITLEN, 64))
   static ifma_RSA_Method m = {
      RSA_ID(RSA_PRV5_KEY,RSA_BITLEN),
      RSA_BITLEN,
      64 + (8 + LEN52*8 + LEN52*8 + LEN64*8 + LEN52*8 + LEN52*8 + LEN52*8 + 2*LEN52*8) *sizeof(int64u), /* buffer */
      //ifma_BNU_to_mb8,
      //NULL,
      NULL,
      EXP52x40_mb8,
      ifma_amred52x40_mb8,
      ifma_amm52x40_mb8,
      ifma_modsub52x40_mb8,
      ifma_addmul52x40_mb8
   };
   return &m;
   #undef RSA_BITLEN
   #undef FACTOR_BITLEN
   #undef LEN52
   #undef LEN64
}

const ifma_RSA_Method* ifma_cp_RSA_private_ctr_Method(int rsaBitsize)
{
   switch (rsaBitsize) {
   case RSA_1K: return ifma_cp_RSA1K_private_ctr_Method();
   case RSA_2K: return ifma_cp_RSA2K_private_ctr_Method();
   case RSA_3K: return ifma_cp_RSA3K_private_ctr_Method();
   case RSA_4K: return ifma_cp_RSA4K_private_ctr_Method();
   default: return NULL;
   }
}

/* size of scratch bufer */
int ifma_RSA_Method_BufSize(const ifma_RSA_Method* m)
{
   return m? m->buffSize : 0;
}

#endif
