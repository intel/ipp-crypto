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

/* CTE versoin of CRT based RSA decrypt */
void gsRSAprv_cipher_crt(IppsBigNumState* pY,
                   const IppsBigNumState* pX,
                   const IppsRSAPrivateKeyState* pKey,
                         BNU_CHUNK_T* pBuffer)
{
   const BNU_CHUNK_T* dataX = BN_NUMBER(pX);
   cpSize nsX = BN_SIZE(pX);

   BNU_CHUNK_T* dataY = BN_NUMBER(pY);

   BNU_CHUNK_T* dataXp = BN_NUMBER(pY);
   BNU_CHUNK_T* dataXq = BN_BUFFER(pY);

   /* P- and Q- montgometry engines */
   gsModEngine* pMontP = RSA_PRV_KEY_PMONT(pKey);
   gsModEngine* pMontQ = RSA_PRV_KEY_QMONT(pKey);
   cpSize nsP = MOD_LEN(pMontP);
   cpSize nsQ = MOD_LEN(pMontQ);
   cpSize bitSizeP = RSA_PRV_KEY_BITSIZE_P(pKey);
   cpSize bitSizeQ = RSA_PRV_KEY_BITSIZE_Q(pKey);
   cpSize bitSizeDP = bitSizeP; //BITSIZE_BNU(RSA_PRV_KEY_DP(pKey), nsP); /* bitsize of dP exp */
   cpSize bitSizeDQ = bitSizeQ; //BITSIZE_BNU(RSA_PRV_KEY_DQ(pKey), nsQ); /* bitsize of dQ exp */

   gsMethod_RSA* m;

   /* compute xq = x^dQ mod Q */
   if (bitSizeP== bitSizeQ) { /* believe it's enough conditions for correct Mont application */
      ZEXPAND_COPY_BNU(pBuffer, nsQ+nsQ, dataX, nsX);
      MOD_METHOD(pMontQ)->red(dataXq, pBuffer, pMontQ);
      MOD_METHOD(pMontQ)->mul(dataXq, dataXq, MOD_MNT_R2(pMontQ), pMontQ);
   }
   else {
      COPY_BNU(dataXq, dataX, nsX);
      cpMod_BNU(dataXq, nsX, MOD_MODULUS(pMontQ), nsQ);
   }

   m = getDefaultMethod_RSA_private(bitSizeDQ);
   m->expFun(dataXq, dataXq, nsQ, RSA_PRV_KEY_DQ(pKey), bitSizeDQ, pMontQ, pBuffer);

   /* compute xp = x^dP mod P */
   if (bitSizeP== bitSizeQ) { /* believe it's enough conditions for correct Mont application */
      ZEXPAND_COPY_BNU(pBuffer, nsP+nsP, dataX, nsX);
      MOD_METHOD(pMontP)->red(dataXp, pBuffer, pMontP);
      MOD_METHOD(pMontP)->mul(dataXp, dataXp, MOD_MNT_R2(pMontP), pMontP);
   }
   else {
      COPY_BNU(dataXp, dataX, nsX);
      cpMod_BNU(dataXp, nsX, MOD_MODULUS(pMontP), nsP);
   }

   m = getDefaultMethod_RSA_private(bitSizeDP);
   m->expFun(dataXp, dataXp, nsP, RSA_PRV_KEY_DP(pKey), bitSizeDP, pMontP, pBuffer);

   /*
   // recombination
   */
   /* xq = xq mod P
      must be sure that xq in the same residue domain as xp
      because of following (xp-xq) mod P operation
   */
   if (bitSizeP == bitSizeQ) { /* believe it's enough conditions for correct Mont application */
      ZEXPAND_COPY_BNU(pBuffer, nsP+nsP, dataXq, nsQ);
      //MOD_METHOD(pMontP)->red(pBuffer, pBuffer, pMontP);
      //MOD_METHOD(pMontP)->mul(pBuffer, pBuffer, MOD_MNT_R2(pMontP), pMontP);
      MOD_METHOD(pMontP)->sub(pBuffer, pBuffer, MOD_MODULUS(pMontP), pMontP);
      /* xp = (xp - xq) mod P */
      MOD_METHOD(pMontP)->sub(dataXp, dataXp, pBuffer, pMontP);
   }
   else {
      COPY_BNU(pBuffer, dataXq, nsQ);
      {
         cpSize nsQP = cpMod_BNU(pBuffer, nsQ, MOD_MODULUS(pMontP), nsP);
         BNU_CHUNK_T cf = cpSub_BNU(dataXp, dataXp, pBuffer, nsQP);
         if(nsP-nsQP)
            cf = cpDec_BNU(dataXp+nsQP, dataXp + nsQP, (nsP-nsQP), cf);
         if (cf)
            cpAdd_BNU(dataXp, dataXp, MOD_MODULUS(pMontP), nsP);
      }
   }

   /* xp = xp*qInv mod P */
   /* convert invQ into Montgomery domain */
   MOD_METHOD(pMontP)->encode(pBuffer, RSA_PRV_KEY_INVQ(pKey), (gsModEngine*)pMontP);
   /* and multiply xp *= mont(invQ) mod P */
   MOD_METHOD(pMontP)->mul(dataXp, dataXp, pBuffer, pMontP);

   /* Y = xq + xp*Q */
   cpMul_BNU_school(pBuffer, dataXp, nsP, MOD_MODULUS(pMontQ), nsQ);
   {
      BNU_CHUNK_T cf = cpAdd_BNU(dataY, pBuffer, dataXq, nsQ);
      cpInc_BNU(dataY + nsQ, pBuffer + nsQ, nsP, cf);
   }

   nsX = nsP + nsQ;
   FIX_BNU(dataY, nsX);
   BN_SIZE(pY) = nsX;
   BN_SIGN(pY) = ippBigNumPOS;
}
