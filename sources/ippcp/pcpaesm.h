/*******************************************************************************
* Copyright 2013-2020 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

/* 
// 
//  Purpose:
//     Cryptography Primitive.
//     Internal Definitions and
//     Internal AES Function Prototypes
// 
// 
*/

#if !defined(_PCP_AES_H)
#define _PCP_AES_H

#include "pcprij.h"

/* Intel(R) AES New Instructions (Intel(R) AES-NI) flag */
#define AES_NI_ENABLED        (ippCPUID_AES)

/* alignment of AES context */
#define AES_ALIGNMENT   (RIJ_ALIGNMENT)

/* valid AES context ID */
#define VALID_AES_ID(ctx)   (RIJ_ID((ctx))==idCtxRijndael)

/* size of AES context */
__INLINE int cpSizeofCtx_AES(void)
{
   return sizeof(IppsAESSpec)
        + AES_ALIGNMENT;
}

#endif /* _PCP_AES_H */
