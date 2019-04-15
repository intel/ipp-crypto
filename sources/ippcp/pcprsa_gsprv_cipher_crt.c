/*******************************************************************************
* Copyright 2013-2019 Intel Corporation
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
//     RSA Functions
// 
//  Contents:
//        gsRSAprv_cipher_crt()
//
*/

#include "owncp.h"
#include "pcpbn.h"
#include "pcpngrsa.h"
#include "pcpngrsamethod.h"

#include "pcprsa_getdefmeth_priv.h"

void gsRSAprv_cipher_crt(IppsBigNumState* pY,
               const IppsBigNumState* pX,
               const IppsRSAPrivateKeyState* pKey,
                     BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataX = BN_NUMBER(pX);
   cpSize nsX = BN_SIZE(pX);
   BNU_CHUNK_T* dataXp = BN_NUMBER(pY);
   BNU_CHUNK_T* dataXq = BN_BUFFER(pY);

   /* P- and Q- montgometry engines */
   gsModEngine* pMontP = RSA_PRV_KEY_PMONT(pKey);
   gsModEngine* pMontQ = RSA_PRV_KEY_QMONT(pKey);
   cpSize nsP = MOD_LEN(pMontP);
   cpSize nsQ = MOD_LEN(pMontQ);
   cpSize bitSizeDP = MOD_BITSIZE(pMontP);
   cpSize bitSizeDQ = MOD_BITSIZE(pMontQ);

   gsMethod_RSA* m;

   /* compute xq = x^dQ mod Q */
   COPY_BNU(dataXq, dataX, nsX);
   cpMod_BNU(dataXq, nsX, MOD_MODULUS(pMontQ), nsQ);

   m = getDefaultMethod_RSA_private(bitSizeDQ);
   m->expFun(dataXq, dataXq, nsQ, RSA_PRV_KEY_DQ(pKey), bitSizeDQ, pMontQ, pBuffer);

   /* compute xp = x^dP mod P */
   COPY_BNU(dataXp, dataX, nsX);
   cpMod_BNU(dataXp, nsX, MOD_MODULUS(pMontP), nsP);

   m = getDefaultMethod_RSA_private(bitSizeDP);
   m->expFun(dataXp, dataXp, nsP, RSA_PRV_KEY_DP(pKey), bitSizeDP, pMontP, pBuffer);

   /*
   // recombination
   */
   {
      cpSize nsQP;
      BNU_CHUNK_T* dataXqp = pBuffer+nsP+nsQ;
      /* compute xp = x^dP mod P */
      COPY_BNU(dataXqp, dataXq, nsQ);
      nsQP = cpMod_BNU(dataXqp, nsQ, MOD_MODULUS(pMontP), nsP);

      {
         /* xp -= xq */
         BNU_CHUNK_T cf = cpSub_BNU(dataXp, dataXp, dataXqp, nsQP);
         if(nsP-nsQP)
            cf = cpDec_BNU(dataXp+nsQP, dataXp+nsQP, (nsP-nsQP), cf);
         if(cf)
            cpAdd_BNU(dataXp, dataXp, MOD_MODULUS(pMontP), nsP);

         /* xp = xp*qInv mod P */
         MOD_METHOD( pMontP )->mul(dataXp, dataXp, RSA_PRV_KEY_INVQ(pKey), pMontP);

         /* Y = xq + xp*Q */
         cpMul_BNU_school(pBuffer,
                    dataXp, nsP,
                    MOD_MODULUS(pMontQ), nsQ);
         cf = cpAdd_BNU(BN_NUMBER(pY), pBuffer, dataXq, nsQ);
         cpInc_BNU(BN_NUMBER(pY)+nsQ, pBuffer+nsQ, nsP, cf);
      }
   }

   nsX = nsP+nsQ;
   FIX_BNU(BN_NUMBER(pY), nsX);
   BN_SIZE(pY) = nsX;
   BN_SIGN(pY) = ippBigNumPOS;
}
