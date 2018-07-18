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
//     Intel(R) Integrated Performance Primitives. Cryptography Primitives.
// 
//     Context:
//        ippsAES_CCMStart()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpaesauthccm.h"
#include "pcptool.h"

#if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPOSITE_GF_)
#  pragma message("_ALG_AES_SAFE_COMPOSITE_GF_ enabled")
#elif (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
#  pragma message("_ALG_AES_SAFE_COMPACT_SBOX_ enabled")
#  include "pcprijtables.h"
#else
#  pragma message("_ALG_AES_SAFE_ disabled")
#endif

/*F*
//    Name: ippsAES_CCMStart
//
// Purpose: Start the process (encryption+generation) or (decryption+veryfication).
//
// Returns:                Reason:
//    ippStsNullPtrErr        pState == NULL
//                            pIV == NULL
//                            pAD == NULL
//    ippStsContextMatchErr   !VALID_AESCCM_ID()
//    ippStsLengthErr         13 < ivLen < 7
//    ippStsNoErr             no errors
//
// Parameters:
//    pIV      pointer to the IV (nonce)
//    ivLen    length of the IV (in bytes)
//    pAD      pointer to the Associated Data (header)
//    adLen    length of the AD (in bytes)
//    pState   pointer to the AES-CCM state
//
*F*/
IPPFUN(IppStatus, ippsAES_CCMStart,(const Ipp8u* pIV, int ivLen,
                                    const Ipp8u* pAD, int adLen,
                                    IppsAES_CCMState* pState))
{
   /* test pState pointer */
   IPP_BAD_PTR1_RET(pState);
   pState = (IppsAES_CCMState*)( IPP_ALIGNED_PTR(pState, AESCCM_ALIGNMENT) );
   IPP_BADARG_RET(!VALID_AESCCM_ID(pState), ippStsContextMatchErr);

   /* test IV (or nonce) */
   IPP_BAD_PTR1_RET(pIV);
   IPP_BADARG_RET((ivLen<7)||(ivLen>13), ippStsLengthErr);

   /* test AAD pointer if defined */
   IPP_BADARG_RET(adLen<0, ippStsLengthErr);
   if(adLen)
      IPP_BAD_PTR1_RET(pAD);

   /* init for new message */
   AESCCM_LENPRO(pState) = 0;
   AESCCM_COUNTER(pState) = 0;

   {
      /* setup encoder method */
      IppsAESSpec* pAES = AESCCM_CIPHER_ALIGNED(pState);
      RijnCipher encoder = RIJ_ENCODER(pAES);

      Ipp32u MAC[NB(128)];
      Ipp32u CTR[NB(128)];
      Ipp32u block[2*NB(128)];

      /*
      // prepare the 1-st input block B0 and encode
      */
      Ipp32u qLen = (Ipp32u)( (MBS_RIJ128-1) - ivLen);
      Ipp32u qLenEnc = qLen-1;

      Ipp32u tagLenEnc = (AESCCM_TAGLEN(pState)-2)>>1;

      Ipp64u payloadLen = AESCCM_MSGLEN(pState);

      ((Ipp8u*)MAC)[0] = (Ipp8u)( ((adLen!=0) <<6) + (tagLenEnc<<3) + qLenEnc); /* flags */
      #if (IPP_ENDIAN == IPP_LITTLE_ENDIAN)
      MAC[2] = ENDIANNESS(HIDWORD(payloadLen));
      MAC[3] = ENDIANNESS(LODWORD(payloadLen));
      #else
      MAC[2] = HIDWORD(payloadLen);
      MAC[3] = LODWORD(payloadLen);
      #endif
      CopyBlock(pIV, ((Ipp8u*)MAC)+1, ivLen);

      /* setup CTR0 */
      FillBlock16(0, NULL,CTR, 0);
      ((Ipp8u*)CTR)[0] = (Ipp8u)qLenEnc; /* flags */
      CopyBlock(pIV, ((Ipp8u*)CTR)+1, ivLen);
      CopyBlock16(CTR, AESCCM_CTR0(pState));

      /* compute and store S0=ENC(CTR0) */
      #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
      encoder((Ipp8u*)CTR, AESCCM_S0(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
      #else
      encoder((Ipp8u*)CTR, AESCCM_S0(pState), RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
      #endif

      /* init MAC value MAC = ENC(MAC) */
      #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
      encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
      #else
      encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
      #endif


      /*
      // update MAC by the AD
      */
      if(adLen) {
         /* encode length of associated data */
         Ipp32u adLenEnc[3];
         Ipp8u* adLenEncPtr;
         int    adLenEncSize;

         #if (IPP_ENDIAN == IPP_LITTLE_ENDIAN)
         adLenEnc[1] = ENDIANNESS(HIDWORD(adLen));
         adLenEnc[2] = ENDIANNESS(LODWORD(adLen));
         #else
         adLenEnc[1] = HIDWORD(adLen);
         adLenEnc[2] = LODWORD(adLen);
         #endif

         if(adLen >= 0xFF00) {
            adLenEncSize = 6;
            #if (IPP_ENDIAN == IPP_LITTLE_ENDIAN)
            adLenEnc[1] = 0xFEFFFFFF;
            #else
            adLenEnc[1] = 0xFFFFFFFE;
            #endif
         }
         else {
            adLenEncSize= 2;
         }
         adLenEncPtr = (Ipp8u*)adLenEnc+3*sizeof(Ipp32u)-adLenEncSize;

         /* prepare first formatted block of Header */
         CopyBlock(adLenEncPtr, block, adLenEncSize);
         FillBlock16(0,pAD, (Ipp8u*)block+adLenEncSize, IPP_MIN((MBS_RIJ128-adLenEncSize), adLen));

         /* and update MAC */
         MAC[0] ^= block[0];
         MAC[1] ^= block[1];
         MAC[2] ^= block[2];
         MAC[3] ^= block[3];
         //encoder(MAC, MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pAES));
         #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
         encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
         #else
         encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
         #endif

         /* update MAC the by rest of addition data */
         if( (adLen+adLenEncSize) > MBS_RIJ128 )  {
            pAD += (MBS_RIJ128-adLenEncSize);
            adLen -= (MBS_RIJ128-adLenEncSize);
            while(adLen >= MBS_RIJ128) {
               CopyBlock16(pAD, block);
               MAC[0] ^= block[0];
               MAC[1] ^= block[1];
               MAC[2] ^= block[2];
               MAC[3] ^= block[3];
               //encoder(MAC, MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), (const Ipp32u (*)[256])RIJ_ENC_SBOX(pAES));
               #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
               encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
               #else
               encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
               #endif

               pAD += MBS_RIJ128;
               adLen -= MBS_RIJ128;
            }

            if(adLen) {
               FillBlock16(0, pAD, block, (int)adLen);
               MAC[0] ^= block[0];
               MAC[1] ^= block[1];
               MAC[2] ^= block[2];
               MAC[3] ^= block[3];
               #if (_ALG_AES_SAFE_==_ALG_AES_SAFE_COMPACT_SBOX_)
               encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), RijEncSbox/*NULL*/);
               #else
               encoder((Ipp8u*)MAC, (Ipp8u*)MAC, RIJ_NR(pAES), RIJ_EKEYS(pAES), NULL);
               #endif
            }
         }
      }

      AESCCM_COUNTER(pState) = 0;
      CopyBlock16(MAC, AESCCM_MAC(pState));

      return ippStsNoErr;
   }
}
