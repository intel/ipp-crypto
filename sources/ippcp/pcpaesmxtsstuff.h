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
// 
//  Purpose:
//     Cryptography Primitive.
//     AES-XTS Internal Functions
// 
// 
*/

#if !defined(_PCP_AES_XTS_STUFF_H)
#define _PCP_AES_XTS_STUFF_H

#include "owncp.h"
#include "pcpaesm.h"

/*
   multiplication by primirive element alpha (==2)
   over P=x^128 +x^7 +x^2 +x +1

   LE version
*/

#if (_IPP_ARCH ==_IPP_ARCH_EM64T)
#pragma message ("_IPP_ARCH_EM64T")
#define GF_MASK   (0x8000000000000000)
#define GF_POLY   (0x0000000000000087)

__INLINE void gf_mul_by_primitive(void* x)
{
#if 0
   Ipp64u* x64 = (Ipp64u*)x;
   Ipp64u xorL = ((Ipp64s)x64[1] >> (BITSIZE(Ipp64u)-1)) & GF_POLY;
   x64[1] = (x64[1]+x64[1]) | (x64[0] >>(BITSIZE(Ipp64u)-1));
   x64[0] = (x64[0]+x64[0]) ^ xorL;
#endif
   Ipp64u* x64 = (Ipp64u*)x;
   Ipp64u xorL = (0>(Ipp64s)x64[1])? GF_POLY : 0;
   Ipp64u addH = (0>(Ipp64s)x64[0])? 1 : 0;
   x64[0] = (x64[0]+x64[0]) ^ xorL;
   x64[1] = (x64[1]+x64[1]) + addH;
}

//#elif (_IPP_ARCH ==_IPP_ARCH_IA32)
#else
#pragma message ("_IPP_ARCH_IA32")
#define GF_MASK   (0x80000000)
#define GF_POLY   (0x00000087)

__INLINE void gf_mul_by_primitive(void* x)
{
   Ipp32u* x32 = (Ipp32u*)x;
   Ipp32u xorL = ((Ipp32s)(x32[3]&GF_MASK) >> (BITSIZE(Ipp32u)-1)) & GF_POLY;
   x32[3] = (x32[3]<<1) | (x32[2] >>(BITSIZE(Ipp32u)-1));
   x32[2] = (x32[2]<<1) | (x32[1] >>(BITSIZE(Ipp32u)-1));
   x32[1] = (x32[1]<<1) | (x32[0] >>(BITSIZE(Ipp32u)-1));
   x32[0] = (x32[0]<<1) ^ xorL;
}
#endif

/*
   the following are especially for multi-block processing
*/
static void cpXTSwhitening(Ipp8u* buffer, int nblk, Ipp8u* ptwk)
{
   Ipp64u* pbuf64 = (Ipp64u*)buffer;
   Ipp64u* ptwk64 = (Ipp64u*)ptwk;

   pbuf64[0] = ptwk64[0];
   pbuf64[1] = ptwk64[1];

   for(nblk--, pbuf64+=2; nblk>0; nblk--, pbuf64+=2) {
      gf_mul_by_primitive(ptwk64);
      pbuf64[0] = ptwk64[0];
      pbuf64[1] = ptwk64[1];
   }
   gf_mul_by_primitive(ptwk64);
}

static void cpXTSxor16(Ipp8u* pDst, const Ipp8u* pSrc1, const Ipp8u* pSrc2, int nblk)
{
   Ipp64u* pdst64 = (Ipp64u*)pDst;
   const Ipp64u* ps1_64 = (const Ipp64u*)pSrc1;
   const Ipp64u* ps2_64 = (const Ipp64u*)pSrc2;
   for(; nblk>0; nblk--, pdst64+=2, ps1_64+=2, ps2_64+=2) {
      pdst64[0] = ps1_64[0] ^ ps2_64[0];
      pdst64[1] = ps1_64[1] ^ ps2_64[1];
   }
}
///////////////////////////////


#endif /* _PCP_AES_XTS_STUFF_H */
