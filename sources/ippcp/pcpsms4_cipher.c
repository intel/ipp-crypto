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
//     SMS4 encryption/decryption
// 
//  Contents:
//        cpSMS4_Cipher()
//
*/

#include "owncp.h"
#include "pcpsms4.h"
#include "pcptool.h"


//#include "owndefs.h"
static void cpSMS4_ECB_gpr_x1(Ipp8u* otxt, const Ipp8u* itxt, const Ipp32u* pRoundKeys)
{
   Ipp32u buff[4+32];
   buff[0] = HSTRING_TO_U32(itxt);
   buff[1] = HSTRING_TO_U32(itxt+sizeof(Ipp32u));
   buff[2] = HSTRING_TO_U32(itxt+sizeof(Ipp32u)*2);
   buff[3] = HSTRING_TO_U32(itxt+sizeof(Ipp32u)*3);
   {
      int nr;
      for(nr=0; nr<32; nr++) {
         buff[4+nr] = buff[nr] ^ cpCipherMix_SMS4(buff[nr+1]^buff[nr+2]^buff[nr+3]^pRoundKeys[nr]);
      }
   }
   U32_TO_HSTRING(otxt,                  buff[4+32-1]);
   U32_TO_HSTRING(otxt+sizeof(Ipp32u),   buff[4+32-2]);
   U32_TO_HSTRING(otxt+sizeof(Ipp32u)*2, buff[4+32-3]);
   U32_TO_HSTRING(otxt+sizeof(Ipp32u)*3, buff[4+32-4]);
}

void cpSMS4_Cipher(Ipp8u* otxt, const Ipp8u* itxt, const Ipp32u* pRoundKeys)
{
   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   if(IsFeatureEnabled(ippCPUID_AES))
      cpSMS4_ECB_aesni_x1(otxt, itxt, pRoundKeys);
   else
   #endif
      cpSMS4_ECB_gpr_x1(otxt, itxt, pRoundKeys);
}
