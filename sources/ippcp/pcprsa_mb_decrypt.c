/*******************************************************************************
* Copyright 2019 Intel Corporation
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

/*!
 * \file
 * 
 *  Purpose:
 *     Cryptography Primitive.
 *     RSA Multi Buffer Functions
 * 
 *  Contents:
 *        ippsRSA_MB_Decrypt()
 *
*/

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

/*!
 *  \brief ippsRSA_MB_Decrypt
 * 
 *  Name:         ippsRSA_MB_Decrypt
 * 
 *  Purpose:      Performs RSA Multi Buffer Decryprion
 *  
 *  Parameters:
 *    \param[in]   pCtxts                 Pointer to the array of ciphertexts.
 *    \param[out]  pPtxts                 Pointer to the array of plaintexts.
 *    \param[in]   pKeys                  Pointer to the array of key contexts.
 *    \param[out]  statuses              Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pBuffer                Pointer to temporary buffer.
 * 
 *  Returns:                          Reason:
 *    \return ippStsNullPtrErr            Indicates an error condition if any of the specified pointers is NULL.
 *                                        NULL == pPtxts
 *                                        NULL == pCtxts
 *                                        NULL == pKeys
 *                                        NULL == pBuffers
 *                                        NULL == statuses
 *    \return ippStsSizeErr               Indicates an error condition if size of modulus N in one context is  
 *                                        different from sizes of modulus N in oter contexts.
 *    \return ippStsBadArgErr             Indicates an error condition if types of private keys is different 
 *                                        from each other.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 No error.                        
 */

IPPFUN(IppStatus, ippsRSA_MB_Decrypt,(const IppsBigNumState* const pCtxts[8],
                                      IppsBigNumState* const pPtxts[8],
                                      const IppsRSAPrivateKeyState* const pKeys[8],
                                      IppStatus statuses[8], Ipp8u* pBuffer))
{    
   IPP_BAD_PTR1_RET(pKeys);
   IPP_BAD_PTR4_RET(pPtxts, pCtxts, pBuffer, statuses);

   #ifdef _IPP_DEBUG
   
      for(int i=0; i < RSA_MB_MAX_BUF_QUANTITY-1; i++) {
         if(pKeys[i] && RSA_PRV_KEY_VALID_ID(pKeys[i])) {
            for(int j=i+1; j < RSA_MB_MAX_BUF_QUANTITY; j++) {
               if(pKeys[j] && RSA_PRV_KEY_VALID_ID(pKeys[j])) {
                  IPP_BADARG_RET(RSA_PRV_KEY_BITSIZE_N(pKeys[i]) != RSA_PRV_KEY_BITSIZE_N(pKeys[j]), ippStsSizeErr);
                  IPP_BADARG_RET(RSA_PRV_KEY1_VALID_ID(pKeys[i]) != RSA_PRV_KEY1_VALID_ID(pKeys[j]), ippStsBadArgErr);
               }
            }
            break;
         }
      }

   #endif

   for(int i=0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
      statuses[i] = ippsRSA_Decrypt(pCtxts[i], pPtxts[i], pKeys[i], pBuffer);
   }

   #ifdef _IPP_DEBUG

      for(int i=0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
         if(statuses[i] != ippStsNoErr) {
            return ippStsMbWarning;
         }
      }

   #endif

   return ippStsNoErr;
}
