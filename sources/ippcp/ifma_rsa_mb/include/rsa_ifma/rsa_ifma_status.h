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

/* 
// 
//  Purpose: MB RSA. Public definitions and declarations. Status
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#ifndef IFMA_RSA_STATUS_H
#define IFMA_RSA_STATUS_H

#include "rsa_ifma_defs.h"

typedef int32u ifma_status;

// error statuses and manipulators
#define IFMA_STATUS_OK                 (0)
#define IFMA_STATUS_MISMATCH_PARAM_ERR (1)
#define IFMA_STATUS_NULL_PARAM_ERR     (2)
//#define IFMA_STATUS_OSSL_ERR         (4)

__INLINE ifma_status IFMA_SET_STS(ifma_status stt, int numb, ifma_status sttVal)
{
   stt &= ~(0xF << (numb*4));
   return stt |= (sttVal & 0xF) << (numb*4);
}

__INLINE ifma_status IFMA_GET_STS(ifma_status stt, int numb)
{
   return (stt >>(numb*4)) & 0xF;
}
__INLINE ifma_status IFMA_SET_STS_ALL(ifma_status stsVal)
{
   return (stsVal<<4*7) | (stsVal<<4*6) | (stsVal<<4*5) | (stsVal<<4*4)  | (stsVal<<4*3) | (stsVal<<4*2) | (stsVal<<4*1) | stsVal;
}

__INLINE int IFMA_IS_ANY_OK_STS(ifma_status stt)
{
   int ret = IFMA_STATUS_OK==IFMA_GET_STS(stt, 0)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 1)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 2)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 3)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 4)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 5)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 6)
          || IFMA_STATUS_OK==IFMA_GET_STS(stt, 7);
   return ret;
}

#endif /* IFMA_RSA_STATUS_H */
#endif
