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
 *        ippsRSA_MB_Encrypt()
 *
*/

#include "owncp.h"
#include "pcpngrsa.h"
#include "pcpngrsa_mb.h"

/*!
 *  \brief ippsRSA_MB_Encrypt
 * 
 *  Name:         ippsRSA_MB_Encrypt
 * 
 *  Purpose:      Performs RSA Multi Buffer Encryprion
 *  
 *  Parameters:
 *    \param[in]   pPtxts                 Pointer to the array of plaintexts.
 *    \param[out]  pCtxts                 Pointer to the array of ciphertexts.
 *    \param[in]   pKeys                  Pointer to the array of key contexts.
 *    \param[out]  statuses              Pointer to the array of execution statuses for each performed operation.
 *    \param[in]   pBuffer                Pointer to the temporary buffer.
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
 *    \return ippStsBadArgErr             Indicates an error condition if value or size of exp E in one context is 
 *                                        different from values or sizes of exp E in other contexts.
 *    \return ippStsMbWarning             One or more of performed operation executed with error. Check statuses array for details.
 *    \return ippStsNoErr                 No error.
 */

IPPFUN(IppStatus, ippsRSA_MB_Encrypt,(const IppsBigNumState* const pPtxts[8],
                                      IppsBigNumState* const pCtxts[8],
                                      const IppsRSAPublicKeyState* const pKeys[8],
                                      IppStatus statuses[8], Ipp8u* pBuffer))
{    
   IPP_BAD_PTR1_RET(pKeys);
   IPP_BAD_PTR4_RET(pPtxts, pCtxts, pBuffer, statuses);

   #ifdef _IPP_DEBUG

      for(int i=0; i < RSA_MB_MAX_BUF_QUANTITY-1; i++) {
         if(pKeys[i] && RSA_PUB_KEY_VALID_ID(pKeys[i])) {
            for(int j=i+1; j < RSA_MB_MAX_BUF_QUANTITY; j++) {
               if(pKeys[j] && RSA_PUB_KEY_VALID_ID(pKeys[i])) {
                  IPP_BADARG_RET(RSA_PUB_KEY_BITSIZE_N(pKeys[i]) != RSA_PUB_KEY_BITSIZE_N(pKeys[j]), ippStsSizeErr);
                  IPP_BADARG_RET(cpCmp_BNU(RSA_PUB_KEY_E(pKeys[i]), RSA_PUB_KEY_BITSIZE_E(pKeys[i])/sizeof(BNU_CHUNK_T), 
                                           RSA_PUB_KEY_E(pKeys[j]), RSA_PUB_KEY_BITSIZE_E(pKeys[j])/sizeof(BNU_CHUNK_T)), ippStsBadArgErr);
               }
            }
            break;
         }
      }

   #endif

   for(int i=0; i < RSA_MB_MAX_BUF_QUANTITY; i++) {
      statuses[i] = ippsRSA_Encrypt(pPtxts[i], pCtxts[i], pKeys[i], pBuffer);
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
