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
//     AES-CMAC Functions
// 
//  Contents:
//        ippsAES_CMACInit()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpcmac.h"
#include "pcpaesm.h"
#include "pcptool.h"
#include "pcpaes_cmac_stuff.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif


static void LogicalLeftSift16(const Ipp8u* pSrc, Ipp8u* pDst)
{
   Ipp32u carry = 0;
   int n;
   for(n=0; n<16; n++) {
      Ipp32u x = pSrc[16-1-n] + pSrc[16-1-n] + carry;
      pDst[16-1-n] = (Ipp8u)x;
      carry = (x>>8) & 0xFF;
   }
}


/*F*
//    Name: ippsAES_CMACInit
//
// Purpose: Init AES-CMAC context.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//    ippStsMemAllocErr       size of buffer is not match fro operation
//    ippStsLengthErr         keyLen != 16
//                            keyLen != 24
//                            keyLen != 32
//    ippStsNoErr             no errors
//
// Parameters:
//    pKey     pointer to the secret key
//    keyLen   length of secret key
//    pState   pointer to the CMAC context
//    ctxSize  available size (in bytes) of buffer above
//
*F*/
IPPFUN(IppStatus, ippsAES_CMACInit,(const Ipp8u* pKey, int keyLen, IppsAES_CMACState* pState, int ctxSize))
{
   /* test pState pointer */
   IPP_BAD_PTR1_RET(pState);

   /* test available size of context buffer */
   IPP_BADARG_RET(ctxSize<cpSizeofCtx_AESCMAC(), ippStsMemAllocErr);

   /* use aligned context */
   pState = (IppsAES_CMACState*)( IPP_ALIGNED_PTR(pState, AESCMAC_ALIGNMENT) );

   {
      IppStatus sts;

      /* set context ID */
      CMAC_ID(pState) = idCtxCMAC;
      /* init internal buffer and DAC */
      init(pState);

      /* init AES cipher */
      sts = ippsAESInit(pKey, keyLen, &CMAC_CIPHER(pState), cpSizeofCtx_AES());

      if(ippStsNoErr==sts) {
         const IppsAESSpec* pAES = &CMAC_CIPHER(pState);

         /* setup encoder method */
         RijnCipher encoder = RIJ_ENCODER(pAES);

         int msb;
         /* precompute k1 subkey */
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder(CMAC_MAC(pState), CMAC_K1(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
         #else
         encoder(CMAC_MAC(pState), CMAC_K1(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
         #endif

         msb = (CMAC_K1(pState))[0];
         LogicalLeftSift16(CMAC_K1(pState),CMAC_K1(pState));
         (CMAC_K1(pState))[MBS_RIJ128-1] ^= (Ipp8u)((0-(msb>>7)) & 0x87); /* ^ Rb changed for constant time execution */
         /* precompute k2 subkey */
         msb = (CMAC_K1(pState))[0];
         LogicalLeftSift16(CMAC_K1(pState),CMAC_K2(pState));
         (CMAC_K2(pState))[MBS_RIJ128-1] ^= (Ipp8u)((0-(msb>>7)) & 0x87); /* ^ Rb changed for constant time execution */
      }

      return sts;
   }
}
