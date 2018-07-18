/*******************************************************************************
* Copyright 2007-2018 Intel Corporation
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
//     Ciper-based Message Authentication Code (CMAC) see SP800-38B
//     Internal Definitions and Internal Functions Prototypes
//
*/

#if !defined(_PCP_CMAC_H)
#define _PCP_CMAC_H

#include "pcprij.h"


/*
// Rijndael128 based CMAC context
*/
struct _cpAES_CMAC {
   IppCtxId idCtx;              /* CMAC  identifier              */
   int      index;              /* internal buffer entry (free)  */
   int      dummy[2];           /* align-16                      */
   Ipp8u    k1[MBS_RIJ128];     /* k1 subkey                     */
   Ipp8u    k2[MBS_RIJ128];     /* k2 subkey                     */
   Ipp8u    mBuffer[MBS_RIJ128];/* buffer                        */
   Ipp8u    mMAC[MBS_RIJ128];   /* intermediate digest           */
   __ALIGN16                    /* aligned AES context           */
   IppsRijndael128Spec mCipherCtx;
};

/* alignment */
//#define CMACRIJ_ALIGNMENT (RIJ_ALIGNMENT)
#define AESCMAC_ALIGNMENT  (RIJ_ALIGNMENT)

/*
// Useful macros
*/
#define CMAC_ID(stt)      ((stt)->idCtx)
#define CMAC_INDX(stt)    ((stt)->index)
#define CMAC_K1(stt)      ((stt)->k1)
#define CMAC_K2(stt)      ((stt)->k2)
#define CMAC_BUFF(stt)    ((stt)->mBuffer)
#define CMAC_MAC(stt)     ((stt)->mMAC)
#define CMAC_CIPHER(stt)  ((stt)->mCipherCtx)

/* valid context ID */
#define VALID_AESCMAC_ID(ctx) (CMAC_ID((ctx))==idCtxCMAC)

#endif /* _PCP_CMAC_H */
