/*******************************************************************************
* Copyright 2021 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

#include "pcptool.h"

#if defined(_NEW_XOR16_)
IPP_OWN_DEFN(void, XorBlock16, (const void* pSrc1, const void* pSrc2, void* pDst))
{
#if (_IPP_ARCH ==_IPP_ARCH_EM64T)
   ((Ipp64u*)pDst)[0] = ((Ipp64u*)pSrc1)[0] ^ ((Ipp64u*)pSrc2)[0];
   ((Ipp64u*)pDst)[1] = ((Ipp64u*)pSrc1)[1] ^ ((Ipp64u*)pSrc2)[1];
#else
   ((Ipp32u*)pDst)[0] = ((Ipp32u*)pSrc1)[0] ^ ((Ipp32u*)pSrc2)[0];
   ((Ipp32u*)pDst)[1] = ((Ipp32u*)pSrc1)[1] ^ ((Ipp32u*)pSrc2)[1];
   ((Ipp32u*)pDst)[2] = ((Ipp32u*)pSrc1)[2] ^ ((Ipp32u*)pSrc2)[2];
   ((Ipp32u*)pDst)[3] = ((Ipp32u*)pSrc1)[3] ^ ((Ipp32u*)pSrc2)[3];
#endif
}
#else
IPP_OWN_DEFN(void, XorBlock16, (const void* pSrc1, const void* pSrc2, void* pDst))
{
   const Ipp8u* p1 = (const Ipp8u*)pSrc1;
   const Ipp8u* p2 = (const Ipp8u*)pSrc2;
   Ipp8u* d  = (Ipp8u*)pDst;
   int k;
   for(k=0; k<16; k++ )
      d[k] = (Ipp8u)(p1[k] ^p2[k]);
}
#endif
