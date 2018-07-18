/*******************************************************************************
* Copyright 2018 Intel Corporation
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
//     Operations over GF(p).
// 
//     Context:
//        ippsGFpSetElementOctString()
// 
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/*F*
// Name: ippsGFpSetElementOctString
//
// Purpose: Set GF Element from the input octet string
//
// Returns:                   Reason:
//    ippStsNullPtrErr           NULL == pGFp
//                               NULL == pR
//                               NULL == pStr && strSize>0
//
//    ippStsContextMatchErr      invalid pGFp->idCtx
//                               invalid pR->idCtx
//
//    ippStsSizeErr              !(0<strSize && strSize<=(int)(GFP_FELEN32()*sizeof(Ipp32u)))
//
//    ippStsOutOfRangeErr        GFPE_ROOM() != GFP_FELEN()
//                               BNU representation of pStr[] >= modulus
//
//    ippStsNoErr                no error
//
// Parameters:
//    pStr        Pointer to the octet string
//    strSize     Size of the octet string buffer in bytes.
//    pR          pointer to Finite Field Element context
//    pGFp         pointer to Finite Field context
*F*/
IPPFUN(IppStatus, ippsGFpSetElementOctString,(const Ipp8u* pStr, int strSize, IppsGFpElement* pR, IppsGFpState* pGFp))
{
   IPP_BAD_PTR2_RET(pR, pGFp);
   pGFp = (IppsGFpState*)( IPP_ALIGNED_PTR(pGFp, GFP_ALIGNMENT) );
   IPP_BADARG_RET( !GFP_TEST_ID(pGFp), ippStsContextMatchErr );
   IPP_BADARG_RET( !GFPE_TEST_ID(pR), ippStsContextMatchErr );

   IPP_BADARG_RET( (!pStr && 0<strSize), ippStsNullPtrErr);
   IPP_BADARG_RET(!(0<strSize && strSize<=(int)(GFP_FELEN32(GFP_PMA(pGFp))*sizeof(Ipp32u))), ippStsSizeErr );

   IPP_BADARG_RET( GFPE_ROOM(pR)!=GFP_FELEN(GFP_PMA(pGFp)), ippStsOutOfRangeErr);

   {
      gsModEngine* pGFE = GFP_PMA(pGFp);
      gsModEngine* pBasicGFE = cpGFpBasic(pGFE);
      int basicDeg = cpGFpBasicDegreeExtension(pGFE);
      int basicElemLen = GFP_FELEN(pBasicGFE);
      int basicSize = BITS2WORD8_SIZE(BITSIZE_BNU(GFP_MODULUS(pBasicGFE),GFP_FELEN(pBasicGFE)));

      BNU_CHUNK_T* pDataElm = GFPE_DATA(pR);

      int deg, error;
      /* set element to zero */
      cpGFpElementPadd(pDataElm, GFP_FELEN(pGFE), 0);

      /* convert oct string to element (from low to high) */
      for(deg=0, error=0; deg<basicDeg && !error; deg++) {
         int size = IPP_MIN(strSize, basicSize);
         error = NULL == cpGFpSetOctString(pDataElm, pStr, size, pBasicGFE);

         pDataElm += basicElemLen;
         strSize -= size;
         pStr += size;
      }

      return error? ippStsOutOfRangeErr : ippStsNoErr;
   }
}
