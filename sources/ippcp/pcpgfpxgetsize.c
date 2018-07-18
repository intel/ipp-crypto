/*******************************************************************************
* Copyright 2010-2018 Intel Corporation
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
//     Operations over GF(p) ectension.
// 
//     Context:
//        pcpgfpxgetsize.c()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"

/* Get context size */
static int cpGFExGetSize(int elemLen, int pelmLen, int numpe)
{
   int ctxSize = 0;

   /* size of GFp engine */
   ctxSize = sizeof(gsModEngine)
            + elemLen*sizeof(BNU_CHUNK_T)    /* modulus  */
            + pelmLen*sizeof(BNU_CHUNK_T)*numpe; /* pool */

   ctxSize = sizeof(IppsGFpState)   /* size of IppsGFPState*/
           + ctxSize;               /* GFpx engine */
   return ctxSize;
}

/*F*
// Name: ippsGFpxGetSize
//
// Purpose: Gets the size of the context of a GF(p^d) field.
//
// Returns:                   Reason:
//     ippStsNullPtrErr        pSize == NULL.
//     ippStsContextMatchErr   !GFP_TEST_ID(pGroundGF)
//     ippStsBadArgErr         degree is greater than or equal to 9 or is less than 2.
//     ippStsNoErr             no error
//
// Parameters:
//     pGroundGF      Pointer to the context of the finite field GF(p) being extended.
//     degree         Degree of the extension.
//     pSize          Pointer to the buffer size, in bytes, needed for the IppsGFpState
//                    context.//
*F*/

IPPFUN(IppStatus, ippsGFpxGetSize, (const IppsGFpState* pGroundGF, int degree, int* pSize))
{
   IPP_BAD_PTR2_RET(pGroundGF, pSize);
   IPP_BADARG_RET( degree<IPP_MIN_GF_EXTDEG || degree >IPP_MAX_GF_EXTDEG, ippStsBadArgErr);
   pGroundGF = (IppsGFpState*)( IPP_ALIGNED_PTR(pGroundGF, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGroundGF), ippStsContextMatchErr );

   #define MAX_GFx_SIZE     (1<<15)  /* max size (bytes) of GF element (32KB) */
   {
      int groundElmLen = GFP_FELEN(GFP_PMA(pGroundGF));
      Ipp64u elmLen64 = (Ipp64u)(groundElmLen) *sizeof(BNU_CHUNK_T) *degree;
      int elemLen = (int)LODWORD(elmLen64);
      *pSize = 0;
      IPP_BADARG_RET(elmLen64> MAX_GFx_SIZE, ippStsBadArgErr);

      *pSize = cpGFExGetSize(elemLen, elemLen, GFPX_POOL_SIZE)
             + GFP_ALIGNMENT;
      return ippStsNoErr;
   }
   #undef MAX_GFx_SIZE
}
