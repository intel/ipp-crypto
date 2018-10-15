/*******************************************************************************
* Copyright 2010-2018 Intel Corporation
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
//     Encrypt/Decrypt byte data stream according to Rijndael128 (GCM mode)
// 
//     "fast" stuff
// 
//  Contents:
//      AesGcmMulGcm_table2K()
// 
*/


#include "owndefs.h"
#include "owncp.h"

#include "pcpaesauthgcm.h"
#include "pcptool.h"
#include "pcpmask_ct.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif


typedef struct{
      Ipp8u b[16];
} AesGcmPrecompute_GF;


#if !((_IPP==_IPP_V8) || (_IPP==_IPP_P8) || \
      (_IPP==_IPP_S8) || (_IPP>=_IPP_G9) || \
      (_IPP32E==_IPP32E_U8) || (_IPP32E==_IPP32E_Y8) || \
      (_IPP32E==_IPP32E_N8) || (_IPP32E>=_IPP32E_E9))
/*
// AesGcmMulGcm_def|safe(Ipp8u* pGhash, const Ipp8u* pHKey)
//
// Ghash = Ghash * HKey mod G()
*/
__INLINE Ipp16u getAesGcmConst_table_ct(int idx)
{
   #define TBL_SLOTS_REP_READ  (sizeof(BNU_CHUNK_T)/sizeof(AesGcmConst_table[0]))
   const BNU_CHUNK_T* TblEntry = (BNU_CHUNK_T*)AesGcmConst_table;

   BNU_CHUNK_T idx_sel = idx / TBL_SLOTS_REP_READ;  /* selection index */
   BNU_CHUNK_T i;
   BNU_CHUNK_T selection = 0;
   for (i = 0; i<sizeof(AesGcmConst_table) / sizeof(BNU_CHUNK_T); i++) {
      BNU_CHUNK_T mask = cpIsEqu_ct(i, idx_sel);
      selection |= TblEntry[i] & mask;
   }
   selection >>= (idx & (TBL_SLOTS_REP_READ-1)) * sizeof(Ipp16u)*8;
   return (Ipp16u)(selection & 0xFFffFF);
   #undef TBL_SLOTS_REP_READ
}

void AesGcmMulGcm_table2K(Ipp8u* pGhash, const Ipp8u* pPrecomputeData, const void* pParam)
{
   __ALIGN16 Ipp8u t5[BLOCK_SIZE];
   __ALIGN16 Ipp8u t4[BLOCK_SIZE];
   __ALIGN16 Ipp8u t3[BLOCK_SIZE];
   __ALIGN16 Ipp8u t2[BLOCK_SIZE];

   int nw;
   Ipp32u a;

   UNREFERENCED_PARAMETER(pParam);

   #if 0
   XorBlock16(t5, t5, t5);
   XorBlock16(t4, t4, t4);
   XorBlock16(t3, t3, t3);
   XorBlock16(t2, t2, t2);
   #endif
   PaddBlock(0, t5, sizeof(t5));
   PaddBlock(0, t4, sizeof(t4));
   PaddBlock(0, t3, sizeof(t3));
   PaddBlock(0, t2, sizeof(t2));

   for(nw=0; nw<4; nw++) {
      Ipp32u hashdw = ((Ipp32u*)pGhash)[nw];

      a = hashdw & 0xf0f0f0f0;
      XorBlock16(t5, pPrecomputeData+1024+EBYTE(a,1)+256*nw, t5);
      XorBlock16(t4, pPrecomputeData+1024+EBYTE(a,0)+256*nw, t4);
      XorBlock16(t3, pPrecomputeData+1024+EBYTE(a,3)+256*nw, t3);
      XorBlock16(t2, pPrecomputeData+1024+EBYTE(a,2)+256*nw, t2);

      a = (hashdw<<4) & 0xf0f0f0f0;
      XorBlock16(t5, pPrecomputeData+EBYTE(a,1)+256*nw, t5);
      XorBlock16(t4, pPrecomputeData+EBYTE(a,0)+256*nw, t4);
      XorBlock16(t3, pPrecomputeData+EBYTE(a,3)+256*nw, t3);
      XorBlock16(t2, pPrecomputeData+EBYTE(a,2)+256*nw, t2);
   }

   XorBlock(t2+1, t3, t2+1, BLOCK_SIZE-1);
   XorBlock(t5+1, t2, t5+1, BLOCK_SIZE-1);
   XorBlock(t4+1, t5, t4+1, BLOCK_SIZE-1);

   nw = t3[BLOCK_SIZE-1];
   //a = (Ipp32u)AesGcmConst_table[nw];
   a = (Ipp32u)getAesGcmConst_table_ct(nw);
   a <<= 8;
   nw = t2[BLOCK_SIZE-1];
   //a ^= (Ipp32u)AesGcmConst_table[nw];
   a ^= (Ipp32u)getAesGcmConst_table_ct(nw);
   a <<= 8;
   nw = t5[BLOCK_SIZE-1];
   //a ^= (Ipp32u)AesGcmConst_table[nw];
   a ^= (Ipp32u)getAesGcmConst_table_ct(nw);

   XorBlock(t4, &a, t4, sizeof(Ipp32u));
   CopyBlock16(t4, pGhash);
}
#endif

