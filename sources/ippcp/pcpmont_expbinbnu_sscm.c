/*******************************************************************************
* Copyright 2003-2018 Intel Corporation
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
//     Modular Exponentiation (binary version)
// 
//  Contents:
//        cpMontExpBin_BNU_sscm()
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbn.h"
#include "pcpmontgomery.h"

//tbcd: temporary excluded: #include <assert.h>


#if defined(_USE_IPP_OWN_CBA_MITIGATION_)
/*
// The reason was to mitigate "cache monitoring" attack on RSA
//
// This is improved version of modular exponentiation.
// Current version provide both either mitigation and perrformance.
// This version in comparison with previous (Intel(R) Integrated Performance Primitives (Intel(R) IPP) 4.1.3) one ~30-40% faster,
// i.e the the performance stayed as was for pre-mitigated version
//
*/

/*F*
// Name: cpMontExpBin_BNU_sscm
//
// Purpose: computes the Montgomery exponentiation with exponent
//          BNU_CHUNK_T *dataE to the given big number integer of Montgomery form
//          BNU_CHUNK_T *dataX with respect to the modulus gsModEngine *pModEngine.
//
// Returns:
//      Length of modulus
//
//
// Parameters:
//      dataX        big number integer of Montgomery form within the
//                      range [0,m-1]
//      dataE        big number exponent
//      pMont        Montgomery modulus of IppsMontState.
/       dataY        the Montgomery exponentation result.
//
*F*/

cpSize cpMontExpBin_BNU_sscm(BNU_CHUNK_T* dataY,
                       const BNU_CHUNK_T* dataX, cpSize nsX,
                       const BNU_CHUNK_T* dataE, cpSize nsE,
                             gsModEngine* pMont)
{
   cpSize nsM = MOD_LEN(pMont);

   /*
   // test for special cases:
   //    x^0 = 1
   //    0^e = 0
   */
   if( cpEqu_BNU_CHUNK(dataE, nsE, 0) ) {
      COPY_BNU(dataY, MOD_MNT_R(pMont), nsM);
   }
      else if( cpEqu_BNU_CHUNK(dataX, nsX, 0) ) {
      ZEXPAND_BNU(dataY, 0, nsM);
   }

   /* general case */
   else {
      /* Montgomery engine buffers */
      const int usedPoolLen = 2;
      BNU_CHUNK_T* dataT      = gsModPoolAlloc(pMont, usedPoolLen);
      BNU_CHUNK_T* sscmBuffer = dataT + nsM;
      //tbcd: temporary excluded: assert(NULL!=dataT);

      int back_step = 0;

      /* copy base */
      ZEXPAND_COPY_BNU(dataT, nsM, dataX, nsX);
      /* init result, Y=1 */
      COPY_BNU(dataY, MOD_MNT_R(pMont), nsM);

     /* execute bits of E */
     for(; nsE>0; nsE--) {
         BNU_CHUNK_T eValue = dataE[nsE-1];

         int j;
         for(j=BNU_CHUNK_BITS-1; j>=0; j--) {
            BNU_CHUNK_T mask_pattern = (BNU_CHUNK_T)(back_step-1);

            /* safeBuffer = (Y[] and mask_pattern) or (X[] and ~mask_pattern) */
            int i;
            for(i=0; i<nsM; i++)
               sscmBuffer[i] = (dataY[i] & mask_pattern) | (dataT[i] & ~mask_pattern);

            /* squaring/multiplication: R = R*T mod Modulus */
            cpMontMul_BNU(dataY, dataY, sscmBuffer, pMont);

            /* update back_step and j */
            back_step = ((eValue>>j) & 0x1) & (back_step^1);
            j += back_step;
         }
      }

      gsModPoolFree(pMont, usedPoolLen);
   }

   return nsM;
}
#endif /* _USE_IPP_OWN_CBA_MITIGATION_ */
