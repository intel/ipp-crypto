/*******************************************************************************
* Copyright 2007-2018 Intel Corporation
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
//     Internal Safe Rijndael Encrypt, Decrypt
// 
// 
*/

#if !defined(_PCP_RIJ_SAFE_H)
#define _PCP_RIJ_SAFE_H

#include "owncp.h"
#include "pcprijtables.h"
#include "pcpbnuimpl.h"

#if defined _PCP_RIJ_SAFE_OLD
/* old version */
#define TransformByte OWNAPI(TransformByte)
Ipp8u   TransformByte(Ipp8u x, const Ipp8u Transformation[]);

#define TransformNative2Composite OWNAPI(TransformNative2Composite)
#define TransformComposite2Native OWNAPI(TransformComposite2Native)

void TransformNative2Composite(Ipp8u out[16], const Ipp8u inp[16]);
void TransformComposite2Native(Ipp8u out[16], const Ipp8u inp[16]);

#define InverseComposite OWNAPI(InverseComposite)
Ipp8u   InverseComposite(Ipp8u x);

#define AddRoundKey OWNAPI(AddRoundKey)
void    AddRoundKey(Ipp8u out[], const Ipp8u inp[], const Ipp8u pKey[]);
#endif


#if !defined _PCP_RIJ_SAFE_OLD
/* new version */
#define TransformNative2Composite OWNAPI(TransformNative2Composite)
#define TransformComposite2Native OWNAPI(TransformComposite2Native)

void TransformNative2Composite(Ipp8u out[16], const Ipp8u inp[16]);
void TransformComposite2Native(Ipp8u out[16], const Ipp8u inp[16]);

/* add round key operation */
__INLINE void AddRoundKey(Ipp8u out[16], const Ipp8u inp[16], const Ipp8u rkey[16])
{
   ((Ipp64u*)out)[0] = ((Ipp64u*)inp)[0] ^ ((Ipp64u*)rkey)[0];
   ((Ipp64u*)out)[1] = ((Ipp64u*)inp)[1] ^ ((Ipp64u*)rkey)[1];
}

/* add logs of GF(2^4) elements
// the exp table has been build matched for that implementation
*/
__INLINE Ipp8u AddLogGF16(Ipp8u loga, Ipp8u logb)
{
   //Ipp8u s = loga+logb;
   //return (s>2*14)? 15 : (s>14)? s-15 : s;
   Ipp8u s = loga+logb;
   Ipp8u delta = ((0xF-1)-s)>>7;
   s -= delta;
   s |= 0-(s>>7);
   return s & (0xF);
}
#endif

#define SELECTION_BITS  ((sizeof(BNU_CHUNK_T)/sizeof(Ipp8u)) -1)

#if defined(__INTEL_COMPILER)
__INLINE Ipp8u getSboxValue(Ipp8u x)
{
  BNU_CHUNK_T selection = 0;
  const BNU_CHUNK_T* SboxEntry = (BNU_CHUNK_T*)RijEncSbox;

  BNU_CHUNK_T i_sel = x / sizeof(BNU_CHUNK_T);  /* selection index */
  BNU_CHUNK_T i;
  for (i = 0; i<sizeof(RijEncSbox) / sizeof(BNU_CHUNK_T); i++) {
    BNU_CHUNK_T mask = (i == i_sel) ? (BNU_CHUNK_T)(-1) : 0;  /* ipp and IPP build specific avoid jump instruction here */
    selection |= SboxEntry[i] & mask;
  }
  selection >>= (x & SELECTION_BITS) * 8;
  return (Ipp8u)(selection & 0xFF);
}

#else
#include "pcpmask_ct.h"
__INLINE Ipp8u getSboxValue(Ipp8u x)
{
  BNU_CHUNK_T selection = 0;
  const BNU_CHUNK_T* SboxEntry = (BNU_CHUNK_T*)RijEncSbox;

  Ipp32u _x = x / sizeof(BNU_CHUNK_T);
  Ipp32u i;
  for (i = 0; i<sizeof(RijEncSbox) / sizeof(BNU_CHUNK_T); i++) {
    BNS_CHUNK_T mask = cpIsEqu_ct(_x, i);
    selection |= SboxEntry[i] & mask;
  }
  selection >>= (x & SELECTION_BITS) * 8;
  return (Ipp8u)(selection & 0xFF);
}
#endif

#endif /* _PCP_RIJ_SAFE_H */
