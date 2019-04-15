/*******************************************************************************
* Copyright 2005-2019 Intel Corporation
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
//     RC4 implementation
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcparcfour.h"
#include "pcptool.h"

/*F*
//    Name: ippsARCFourInit
//
// Purpose: Init ARCFOUR spec for future usage.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pCtx == NULL
//    ippStsLengthErr         1 > keyLen
//                            keyLen > IPP_ARCFOUR_KEYMAX_SIZE
//    ippStsNoErr             no errors
//
// Parameters:
//    key         security key
//    keyLen      length of key (bytes)
//    pCtx        pointer to the ARCFOUR context
//
*F*/
IPPFUN(IppStatus, ippsARCFourInit, (const Ipp8u *pKey, int keyLen, IppsARCFourState *pCtx))
{
   /* test context pointer */
   IPP_BAD_PTR1_RET(pCtx);
   /* use aligned context */
   pCtx = (IppsARCFourState*)( IPP_ALIGNED_PTR(pCtx, RC4_ALIGNMENT) );

   /* test key */
   IPP_BAD_PTR1_RET(pKey);
   IPP_BADARG_RET(((1>keyLen)||(IPP_ARCFOUR_KEYMAX_SIZE< keyLen)), ippStsLengthErr);

   {
      int i;
      Ipp8u kblk[256], j, tmp;

      /* init RC4 context */
      RC4_ID(pCtx) = idCtxARCFOUR;

      for(i=0; i<256; i++) {
         pCtx->Sbox0[i] = (Ipp8u)i;
         kblk[i] = pKey[i%keyLen];
      }
      j=0;
      for(i=0; i<256; i++) {
         j += pCtx->Sbox0[i] + kblk[i];
         tmp = pCtx->Sbox0[j];
         pCtx->Sbox0[j] = pCtx->Sbox0[i];
         pCtx->Sbox0[i] = tmp;
      }

      return ippsARCFourReset(pCtx);
   }
}
