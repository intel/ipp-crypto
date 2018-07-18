/*******************************************************************************
* Copyright 2017-2018 Intel Corporation
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
//     Message Authentication Algorithm
//     Internal Definitions and Internal Functions Prototypes
// 
// 
*/

#if !defined(_CP_SMS4_CCM_H)
#define _CP_SMS4_CCM_H

#include "pcpsms4.h"

struct _cpSMS4_CCM {
   IppCtxId idCtx;            /* CCM ID               */

   Ipp64u   msgLen;           /* length of message to be processed */
   Ipp64u   lenProcessed;     /* message length has been processed */
   Ipp32u   tagLen;           /* length of authentication tag      */
   Ipp32u   counterVal;       /* currnt couter value */
   Ipp8u   ctr0[MBS_SMS4];    /* counter value */
   Ipp8u     s0[MBS_SMS4];    /* S0 = ENC(CTR0) content */
   Ipp8u     si[MBS_SMS4];    /* Si = ENC(CTRi) content */
   Ipp8u    blk[MBS_SMS4];    /* temporary data container */
   Ipp8u    mac[MBS_SMS4];    /* current MAC value */

   Ipp8u    cipher[sizeof(IppsSMS4Spec)+SMS4_ALIGNMENT-1];
};

/* alignment */
#define SMS4CCM_ALIGNMENT   ((int)(sizeof(void*)))

/*
// access macros
*/
#define SMS4CCM_ID(stt)        ((stt)->idCtx)
#define SMS4CCM_MSGLEN(stt)    ((stt)->msgLen)
#define SMS4CCM_LENPRO(stt)    ((stt)->lenProcessed)
#define SMS4CCM_TAGLEN(stt)    ((stt)->tagLen)
#define SMS4CCM_COUNTER(stt)   ((stt)->counterVal)
#define SMS4CCM_CTR0(stt)      ((stt)->ctr0)
#define SMS4CCM_S0(stt)        ((stt)->s0)
#define SMS4CCM_Si(stt)        ((stt)->si)
#define SMS4CCM_BLK(stt)       ((stt)->blk)
#define SMS4CCM_MAC(stt)       ((stt)->mac)
#define SMS4CCM_CIPHER(stt)          (IppsSMS4Spec*)(&((stt)->cipher))
#define SMS4CCM_CIPHER_ALIGNED(stt)  (IppsSMS4Spec*)( IPP_ALIGNED_PTR( ((stt)->cipher), SMS4_ALIGNMENT ) )

/* valid context ID */
#define VALID_SMS4CCM_ID(ctx)  (SMS4CCM_ID((ctx))==idCtxAESCCM)

static int cpSizeofCtx_SMS4CCM(void)
{
   return sizeof(IppsSMS4_CCMState) + SMS4CCM_ALIGNMENT-1;
}

/* Counter block formatter */
static
Ipp8u* CounterEnc(Ipp32u* pBuffer, int fmt, Ipp64u counter)
{
   #if (IPP_ENDIAN == IPP_LITTLE_ENDIAN)
   pBuffer[0] = ENDIANNESS(HIDWORD(counter));
   pBuffer[1] = ENDIANNESS(LODWORD(counter));
   #else
   pBuffer[0] = HIDWORD(counter);
   pBuffer[1] = LODWORD(counter);
   #endif
   return (Ipp8u*)pBuffer + 8 - fmt;
}

#endif /* _CP_SMS4_CCM_H*/
