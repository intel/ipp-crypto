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
//  Contents: 104- by 520 bit vector division
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#include "ifma_internal.h"
#include "immintrin.h"

#define ALIGNSPEC __ALIGN64

#define  DUP2_DECL(a)   a, a
#define  DUP4_DECL(a)   DUP2_DECL(a), DUP2_DECL(a)
#define  DUP8_DECL(a)   DUP4_DECL(a), DUP4_DECL(a)


//gres: typedef unsigned __int64 UINT64;
typedef int64u UINT64;


#define VUINT64 __m512i
#define VINT64  VUINT64
#define VDOUBLE __m512d
#define VMASK_L __mmask8

#define L2D(x)  _mm512_castsi512_pd(x)
#define D2L(x)  _mm512_castpd_si512(x)

// Load int constant
#define VLOAD_L(addr)  _mm512_load_epi64((__m512i const*)&(addr)[0]);
// Load DP constant
#define VLOAD_D(addr)  _mm512_load_pd((const double*)&(addr)[0]);
#define VSTORE_L(addr, x)  _mm512_store_epi64(((__m512i*)&(addr)[0]), (x));


#define VSHL_L(x, n)  _mm512_slli_epi64((x), (n));
#define VSAR_L(x, n)  _mm512_srai_epi64((x), (n));
#define VAND_L(a, b)  _mm512_and_epi64((a), (b));
#define VADD_L(a, b)  _mm512_add_epi64((a), (b));
#define VSUB_L(a, b)  _mm512_sub_epi64((a), (b));
#define VMSUB_L(mask, a, b)  _mm512_mask_sub_epi64((a), mask, (a), (b));
#define VMADD_L(mask, a, b)  _mm512_mask_add_epi64((a), mask, (a), (b));
#define VCMPU_GT_L(a, b)  _mm512_cmpgt_epu64_mask((a), (b));
#define VCMP_GE_L(a, b)  _mm512_cmpge_epi64_mask((a), (b));


// conversion unsigned 64-bit -> double
#define VCVT_L2D(x)   _mm512_cvtepu64_pd(x)
// conversion double -> signed 64-bit
#define VCVT_D2L(x)   _mm512_cvtpd_epi64(x)

#define VADD_D(a, b)      _mm512_add_pd(a, b)
#define VMUL_D(a, b)      _mm512_mul_pd(a, b)
#define VMUL_RZ_D(a, b)   _mm512_mul_round_pd(a, b, _MM_FROUND_TO_ZERO | _MM_FROUND_NO_EXC)
#define VMUL_RU_D(a, b)   _mm512_mul_round_pd(a, b, _MM_FROUND_TO_POS_INF | _MM_FROUND_NO_EXC)
#define VDIV_RZ_D(a, b)   _mm512_div_round_pd(a, b, _MM_FROUND_TO_ZERO | _MM_FROUND_NO_EXC)
#define VDIV_RU_D(a, b)   _mm512_div_round_pd(a, b, _MM_FROUND_TO_POS_INF | _MM_FROUND_NO_EXC)
#define VROUND_RZ_D(a)    _mm512_roundscale_pd(a, 3)
#define VQFMR_D(a, b, c)  _mm512_fnmadd_pd(a, b, c)

#endif
