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
//     RSA-PKCS1-v1_5 Encryption Scheme
// 
//  Contents:
//        ippsRSADecrypt_PKCSv15()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpngrsa.h"
#include "pcptool.h"


static Ipp32u NonZeroBlockLen(const Ipp8u* pData, int dataLen)
{
   int i;
   for(i=0; i<dataLen && pData[i]; i++) ;
   return i;
}


static int DecodeEME_PKCSv15(const Ipp8u* pEM, int emLen,
                                   Ipp8u* pMsg, int* pMsgLen)
{
   int psLen = NonZeroBlockLen(pEM+2, emLen-2);
   int msgLen = IPP_MAX(0, (emLen-3-psLen) );
   int errDecodeFlag = (psLen < 8) || ((psLen+3) > emLen);

   /*
   // decoded message format:
   //    EM = 00 || 02 || PS || 00 || Msg
   //    len(PS) >= 8
   */
   errDecodeFlag |= (0x00 != pEM[0]);
   errDecodeFlag |= (0x02 != pEM[1]);
   errDecodeFlag |= (0x00 != pEM[3+psLen-1]);
   CopyBlock(pEM+3+psLen, pMsg, msgLen);
   *pMsgLen = msgLen;
   return !errDecodeFlag;
}


/*
// returns 0 decription error
/          1 OK
*/
static int Decryption(const Ipp8u* pCipherTxt,
                            Ipp8u* pMsg, int* pMsgLen,
                      const IppsRSAPrivateKeyState* pKey,
                            BNU_CHUNK_T* pBuffer)
{
   /* size of RSA modulus in bytes and chunks */
   int k = BITS2WORD8_SIZE(RSA_PRV_KEY_BITSIZE_N(pKey));
   cpSize nsN = BITS_BNU_CHUNK(RSA_PRV_KEY_BITSIZE_N(pKey));

   /* temporary BN */
   __ALIGN8 IppsBigNumState tmpBN;
   BN_Make(pBuffer, pBuffer+nsN+1, nsN, &tmpBN);

   /* update buffer pointer */
   pBuffer += (nsN+1)*2;

   /*
   // private-key operation
   */
   ippsSetOctString_BN(pCipherTxt, k, &tmpBN);
   if( 0 <= cpCmp_BNU(BN_NUMBER(&tmpBN), BN_SIZE(&tmpBN),
                      MOD_MODULUS(RSA_PRV_KEY_NMONT(pKey)), nsN) )
      return 0;

   if(RSA_PRV_KEY1_VALID_ID(pKey))
      gsRSAprv_cipher(&tmpBN, &tmpBN, pKey, pBuffer);
   else
      gsRSAprv_cipher_crt(&tmpBN, &tmpBN, pKey, pBuffer);

   ippsGetOctString_BN((Ipp8u*)(BN_BUFFER(&tmpBN)), k, &tmpBN);

   /* EME-PKCS-v1_5 decoding */
   return DecodeEME_PKCSv15((Ipp8u*)(BN_BUFFER(&tmpBN)), k, pMsg, pMsgLen);
}

/*F*
// Name: ippsRSADecrypt_PKCSv15
//
// Purpose: Performs Decrption according to RSA-ES-PKCS1_v1.5
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pSrc
//                               NULL == pDst
//                               NULL == pDstLen
//                               NULL == pKey
//                               NULL == pBuffer
//
//    ippStsContextMatchErr      !RSA_PRV_KEY_VALID_ID()
//
//    ippStsIncompleteContextErr private key is not set up
//
//    ippStsSizeErr              RSA modulus size too short (k < 11, see PKCS#1) !! runtime error
//    ippStsPaddingErr           pSrc > size of RSA modulus  !! runtime error
//                               DecodeEME_PKCS_v1_5 error
//    ippStsNoErr                no error
//
// Parameters:
//    pSrc        pointer to the ciphertext
//    pDst        pointer to the plaintext
//    pDstLen     pointer to the length (bytes) of decrypted plaintext
//    pKey        pointer to the RSA private key context
//    pBuffer     pointer to scratch buffer
*F*/
IPPFUN(IppStatus, ippsRSADecrypt_PKCSv15,(const Ipp8u* pSrc,
                                                Ipp8u* pDst, int* pDstLen,
                                          const IppsRSAPrivateKeyState* pKey,
                                                Ipp8u* pScratchBuffer))
{
   /* use aligned key context */
   IPP_BAD_PTR2_RET(pKey, pScratchBuffer);
   pKey = (IppsRSAPrivateKeyState*)( IPP_ALIGNED_PTR(pKey, RSA_PRIVATE_KEY_ALIGNMENT) );
   IPP_BADARG_RET(!RSA_PRV_KEY_VALID_ID(pKey), ippStsContextMatchErr);
   IPP_BADARG_RET(!RSA_PRV_KEY_IS_SET(pKey), ippStsIncompleteContextErr);

   /* test data pointer */
   IPP_BAD_PTR3_RET(pSrc, pDst, pDstLen);

   if(RSA_PRV_KEY_BITSIZE_N(pKey) < 11*BYTESIZE)
      return ippStsSizeErr;

   {
      BNU_CHUNK_T* pBuffer = (BNU_CHUNK_T*)(IPP_ALIGNED_PTR((pScratchBuffer), (int)sizeof(BNU_CHUNK_T)));
      return Decryption(pSrc, pDst, pDstLen,
                        pKey,
                        pBuffer)? ippStsNoErr : ippStsPaddingErr;
   }
}
