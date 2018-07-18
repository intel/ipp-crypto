/*******************************************************************************
* Copyright 2005-2018 Intel Corporation
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
//     RC4 Internal Definitions and Function Prototypes
//
*/

#if !defined(_ARCFOUR_H)
#define _ARCFOUR_H
#define _ARCFOUR_H

#if ((_IPP==_IPP_W7) || (_IPP==_IPP_T7))
   #define rc4word   Ipp8u
   #pragma message("Sbox: byte")


#elif ((_IPP>=_IPP_V8) || (_IPP32E>=_IPP32E_M7))
   #define rc4word   Ipp32u
   #pragma message("Sbox: dword")

#else
   #define rc4word   Ipp8u
   #pragma message("Sbox: byte")
#endif

/*
// ARCFOUR context
*/
struct _cpARCfour {
   IppCtxId    idCtx;      /* RC4 identifier  */

   Ipp32u      cntX;       /* algorithm's counter x  */
   Ipp32u      cntY;       /* algorithm's counter y  */
   rc4word     Sbox[256];  /* current state block.*/
   Ipp8u       Sbox0[256]; /* initial state block */
};

/* alignment */
#define RC4_ALIGNMENT ((int)(sizeof(Ipp32u)))

/*
// Useful macros
*/
#define RC4_ID(ctx)        ((ctx)->idCtx)
#define RC4_CNTX(ctx)      ((ctx)->cntX)
#define RC4_CNTY(ctx)      ((ctx)->cntY)
#define RC4_SBOX(ctx)      ((ctx)->Sbox)
#define RC4_SBOX0(ctx)     ((ctx)->Sbox0)

#define RC4_VALID_ID(ctx)  (RC4_ID((ctx))==idCtxARCFOUR)

/*
// internal functions
*/
#define ARCFourProcessData OWNAPI(ARCFourProcessData)
   void ARCFourProcessData(const Ipp8u *pSrc, Ipp8u *pDst, int length, IppsARCFourState *pCtx);

#endif /* _ARCFOUR_H */
