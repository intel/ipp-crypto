typedef int to_avoid_translation_unit_is_empty_warning;

#ifndef BN_OPENSSL_DISABLE
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
//  Purpose: MB RSA-1024, RSA-2048, RSA-3072, RSA-4096.
// 
//  Contents: private key (pair form) operation
//
*/

#include <memory.h>

#include <openssl/bn.h>

#include "ifma_internal.h"
#include "ifma_internal_ssl_layer.h"
#include "rsa_ifma.h"


// y = x^d mod n
ifma_status ifma_rsa52_private_mb8(const int8u* const from_pa[8],
                                         int8u* const to_pa[8],
                                  const BIGNUM* const d_pa[8],
                                  const BIGNUM* const n_pa[8],
                                  int expected_rsa_bitsize)
{
   ifma_status stt = 0;
   int buf_no;

   /* test input pointers */
   if(NULL==from_pa || NULL==to_pa || NULL==d_pa || NULL==n_pa) {
      stt = IFMA_SET_STS_ALL(IFMA_STATUS_NULL_PARAM_ERR);
      return stt;
   }
   /* test rsa modulus size */
   if(RSA_1K != expected_rsa_bitsize && RSA_2K != expected_rsa_bitsize &&
      RSA_3K != expected_rsa_bitsize && RSA_4K != expected_rsa_bitsize) {
      stt = IFMA_SET_STS_ALL(IFMA_STATUS_MISMATCH_PARAM_ERR);
      return stt;
   }

   /* check pointers and values */
   for(buf_no=0; buf_no<8; buf_no++) {
      const int8u* inp = from_pa[buf_no];
            int8u* out = to_pa[buf_no];
      const BIGNUM* d = d_pa[buf_no];
      const BIGNUM* n = n_pa[buf_no];

      /* if any of pointer NULL set error status */
      if(NULL==inp || NULL==out || NULL==d || NULL==n) {
         stt = IFMA_SET_STS(stt, buf_no, IFMA_STATUS_NULL_PARAM_ERR);
         continue;
      }

      /* check rsa size */
      if(expected_rsa_bitsize != BN_num_bits(n)) {
         stt = IFMA_SET_STS(stt, buf_no, IFMA_STATUS_MISMATCH_PARAM_ERR);
         continue;
      }
   }

   /* continue processing if there are correct parameters */
   if( IFMA_IS_ANY_OK_STS(stt) ) {
      /* select exponentiation */
      switch (expected_rsa_bitsize) {
      case RSA_1K: ifma_ssl_rsa1K_prv2_layer_mb8(from_pa, to_pa, d_pa, n_pa); break;
      case RSA_2K: ifma_ssl_rsa2K_prv2_layer_mb8(from_pa, to_pa, d_pa, n_pa); break;
      case RSA_3K: ifma_ssl_rsa3K_prv2_layer_mb8(from_pa, to_pa, d_pa, n_pa); break;
      case RSA_4K: ifma_ssl_rsa4K_prv2_layer_mb8(from_pa, to_pa, d_pa, n_pa); break;
      }
   }

   return stt;
}

#endif /* BN_OPENSSL_DISABLE */
