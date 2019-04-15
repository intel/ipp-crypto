/*******************************************************************************
* Copyright 2015-2019 Intel Corporation
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
//     AES-SIV Functions (RFC 5297)
// 
//  Contents:
//        ippsAES_S2V_CMAC()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpcmac.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "pcpaes_sivstuff.h"

/*F*
//    Name: ippsAES_S2V_CMAC
//
// Purpose: Converts strings to vector  -
//          performs S2V operation as defined RFC 5297.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pV == NULL
//                            pAD== NULL
//                            pADlen==NULL
//                            pADlen[i]!=0 && pAD[i]==0
//    ippStsLengthErr         keyLen != 16
//                            keyLen != 24
//                            keyLen != 32
//                            pADlen[i]<0
//                            0 > numAD
//    ippStsNoErr             no errors
//
// Parameters:
//    pKey     pointer to the secret key
//    keyLen   length of secret key
//    pAD[]    array of pointers to input strings
//    pADlen[] array of input string lengths
//    numAD    number of pAD[] and pADlen[] terms
//    pV       pointer to output vector
//
*F*/
IPPFUN(IppStatus, ippsAES_S2V_CMAC,(const Ipp8u* pKey, int keyLen,
                                    const Ipp8u* pAD[], const int pADlen[], int numAD,
                                          Ipp8u  V[MBS_RIJ128]))
{
   /* test output vector */
   IPP_BAD_PTR1_RET(V);

   /* make sure that number of input string is legal */
   IPP_BADARG_RET(0>numAD, ippStsLengthErr);

   /* test arrays of input */
   IPP_BAD_PTR2_RET(pAD, pADlen);
   #ifdef _IPP_DEBUG
   {
      int n;
      for(n=0; n<numAD; n++) {
         /* test input message and it's length */
         IPP_BADARG_RET((pADlen[n]<0), ippStsLengthErr);
         /* test source pointer */
         IPP_BADARG_RET((pADlen[n] && !pAD[n]), ippStsNullPtrErr);
      }
   }
   #endif

   {
      Ipp8u ctxBlob[sizeof(IppsAES_CMACState) + AESCMAC_ALIGNMENT];
      IppsAES_CMACState* pCtx = (IppsAES_CMACState*)ctxBlob;
      IppStatus sts = cpAES_S2V_init(V, pKey, keyLen, pCtx, sizeof(ctxBlob));

      if(ippStsNoErr==sts) {
         if(0==numAD) {
            PaddBlock(0, V, MBS_RIJ128);
            V[MBS_RIJ128-1] = 0x1;
            cpAES_CMAC(V, V, MBS_RIJ128, pCtx);
         }

         else {
            int n;
            for(n=0, numAD--; n<numAD; n++)
               cpAES_S2V_update(V, pAD[n], pADlen[n], pCtx);
             cpAES_S2V_final(V, pAD[numAD], pADlen[numAD], pCtx);
         }
      }

      PurgeBlock(&ctxBlob, sizeof(ctxBlob));
      return sts;
   }
}
