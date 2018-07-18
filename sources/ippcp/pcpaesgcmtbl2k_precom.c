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
//      AesGcmPrecompute_table2K()
// 
*/


#include "owndefs.h"
#include "owncp.h"

#include "pcpaesauthgcm.h"
#include "pcptool.h"

/*
// AES-GCM precomputations.
*/
static void RightShiftBlock16(Ipp8u* pBlock)
{
   Ipp8u v0 = 0;
   int i;
   for(i=0; i<16; i++) {
      Ipp8u v1 = pBlock[i];
      Ipp8u tmp = (Ipp8u)( (v1>>1) | (v0<<7) );
      pBlock[i] = tmp;
      v0 = v1;
   }
}

void AesGcmPrecompute_table2K(Ipp8u* pPrecomputeData, const Ipp8u* pHKey)
{
   Ipp8u t[BLOCK_SIZE];
   int n;

   CopyBlock16(pHKey, t);

   for(n=0; n<128-24; n++) {
      /* get msb */
      int hBit = t[15]&1;

      int k = n%32;
      if(k<4) {
         CopyBlock16(t, pPrecomputeData +1024 +(n/32)*256 +(Ipp32u)(1<<(7-k)));
      }
      else if(k<8) {
         CopyBlock16(t, pPrecomputeData +(n/32)*256 +(Ipp32u)(1<<(11-k)));
      }

      /* shift */
      RightShiftBlock16(t);
      /* xor if msb=1 */
      if(hBit)
         t[0] ^= 0xe1;
   }

   for(n=0; n<4; n++) {
      int m, k;
      XorBlock16(pPrecomputeData +n*256, pPrecomputeData +n*256, pPrecomputeData +n*256);
      XorBlock16(pPrecomputeData +1024 +n*256, pPrecomputeData +1024 +n*256, pPrecomputeData +1024 +n*256);
      for(m=2; m<=8; m*=2)
         for(k=1; k<m; k++) {
            XorBlock16(pPrecomputeData +n*256+m*16, pPrecomputeData +n*256+k*16, pPrecomputeData +n*256 +(m+k)*16);
            XorBlock16(pPrecomputeData +1024 +n*256+m*16, pPrecomputeData +1024 +n*256+k*16, pPrecomputeData +1024 +n*256 +(m+k)*16);
         }
   }
}
