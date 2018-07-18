/*******************************************************************************
* Copyright 2017-2018 Intel Corporation
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
//     Internal Definitions and
//     Internal ng RSA methods
*/

#if !defined(_CP_NG_RSA_METHOD_H)
#define _CP_NG_RSA_METHOD_H

#include "pcpngmontexpstuff.h"

/*
// declaration of RSA exponentiation
*/
typedef cpSize (*ngBufNum)(int modulusBits);

typedef struct _gsMethod_RSA {
   int loModulusBisize;       // application area (lowew
   int hiModulusBisize;       // and upper)
   ngBufNum  bufferNumFunc;   // pub operation buffer in BNU_CHUNK_T
   ngMontExp expFun;          // exponentiation
} gsMethod_RSA;


/* GPR exponentiation */
#define       gsMethod_RSA_gpr_public  OWNAPI(gsMethod_RSA_gpr_public)
#define       gsMethod_RSA_gpr_private OWNAPI(gsMethod_RSA_gpr_private)
gsMethod_RSA* gsMethod_RSA_gpr_public(void);
gsMethod_RSA* gsMethod_RSA_gpr_private(void);


/* SSE2 exponentiation */
#if (_IPP>=_IPP_W7)
#define       gsMethod_RSA_sse2_public  OWNAPI(gsMethod_RSA_sse2_public)
#define       gsMethod_RSA_sse2_private OWNAPI(gsMethod_RSA_sse2_private)
gsMethod_RSA* gsMethod_RSA_sse2_public(void);
gsMethod_RSA* gsMethod_RSA_sse2_private(void);
#endif /* _IPP_W7 */

/* AVX2 exponentiation */
#if (_IPP32E>=_IPP32E_L9)
#define       gsMethod_RSA_avx2_public  OWNAPI(gsMethod_RSA_avx2_public)
#define       gsMethod_RSA_avx2_private OWNAPI(gsMethod_RSA_avx2_private)
gsMethod_RSA* gsMethod_RSA_avx2_public(void);
gsMethod_RSA* gsMethod_RSA_avx2_private(void);
#endif /* _IPP32E_L9 */

/* AVX512 exponentiation */
#if (_IPP32E>=_IPP32E_K0)
#define       gsMethod_RSA_avx512_public  OWNAPI(gsMethod_RSA_avx512_public)
#define       gsMethod_RSA_avx512_private OWNAPI(gsMethod_RSA_avx512_private)
gsMethod_RSA* gsMethod_RSA_avx512_public(void);
gsMethod_RSA* gsMethod_RSA_avx512_private(void);
#endif /* _IPP32E_K0 */

#endif /* _CP_NG_RSA_METHOD_H */
