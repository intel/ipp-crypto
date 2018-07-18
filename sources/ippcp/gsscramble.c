/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
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
//     Fixed window exponentiation scramble/unscramble
// 
//  Contents:
//     gsScramblePut()
//     gsScrambleGet()
//     gsScrambleGet_sscm()
// 
*/
#include "owncp.h"
#include "gsscramble.h"
#include "pcpmask_ct.h"

int gsGetScrambleBufferSize(int modulusLen, int w)
{
   /* size of resource to store 2^w values of modulusLen*sizeof(BNU_CHUNK_T) each */
   int size = (1<<w) * modulusLen * sizeof(BNU_CHUNK_T);
   /* padd it up to CACHE_LINE_SIZE */
   size += (CACHE_LINE_SIZE - (size % CACHE_LINE_SIZE)) %CACHE_LINE_SIZE;
   return size/sizeof(BNU_CHUNK_T);
}

void gsScramblePut(BNU_CHUNK_T* tbl, int idx, const BNU_CHUNK_T* val, int vLen, int w)
{
   int width = 1 << w;
   int i, j;
   for(i=0, j=idx; i<vLen; i++, j+= width) {
      tbl[j] = val[i];
   }
}

void gsScrambleGet(BNU_CHUNK_T* val, int vLen, const BNU_CHUNK_T* tbl, int idx, int w)
{
   int width = 1 << w;
   int i, j;
   for(i=0, j=idx; i<vLen; i++, j+= width) {
      val[i] = tbl[j];
   }
}

void gsScrambleGet_sscm(BNU_CHUNK_T* val, int vLen, const BNU_CHUNK_T* tbl, int idx, int w)
{
   BNU_CHUNK_T mask[1<<MAX_W];

   int width = 1 << w;

   int n, i;
   switch (w) {
   case 6:
      for(n=0; n<(1<<6); n++)
         mask[n] = cpIsEqu_ct(n, idx);
      break;
   case 5:
      for(n=0; n<(1<<5); n++)
         mask[n] = cpIsEqu_ct(n, idx);
      break;
   case 4:
      for(n=0; n<(1<<4); n++)
         mask[n] = cpIsEqu_ct(n, idx);
      break;
   case 3:
      for(n=0; n<(1<<3); n++)
         mask[n] = cpIsEqu_ct(n, idx);
      break;
   case 2:
      for(n=0; n<(1<<2); n++)
         mask[n] = cpIsEqu_ct(n, idx);
      break;
   default:
      mask[0] = cpIsEqu_ct(0, idx);
      mask[1] = cpIsEqu_ct(1, idx);
      break;
   }

   for(i=0; i<vLen; i++, tbl += width) {
      BNU_CHUNK_T acc = 0;

      switch (w) {
      case 6:
         for(n=0; n<(1<<6); n++)
            acc |= tbl[n] & mask[n];
         break;
      case 5:
         for(n=0; n<(1<<5); n++)
            acc |= tbl[n] & mask[n];
         break;
      case 4:
         for(n=0; n<(1<<4); n++)
            acc |= tbl[n] & mask[n];
         break;
      case 3:
         for(n=0; n<(1<<3); n++)
            acc |= tbl[n] & mask[n];
         break;
      case 2:
         for(n=0; n<(1<<2); n++)
            acc |= tbl[n] & mask[n];
         break;
      default:
         acc |= tbl[0] & mask[0];
         acc |= tbl[1] & mask[1];
         break;
      }

      val[i] = acc;
   }
}
