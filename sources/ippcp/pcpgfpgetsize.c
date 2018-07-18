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
//        ippsGFpGetSize()
// 
*/
#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"
#include "pcpgfpxstuff.h"
#include "pcptool.h"


/*F*
// Name: ippsGFpGetSize
//
// Purpose: Gets the size of the context of a GF(q) field
//
// Returns:                   Reason:               
//     ippStsNullPtrErr        pSize == NULL.                   
//     ippStsSizeErr           bitSize is less than 2 or greater than 1024.
//     ippStsNoErr             no error
//
// Parameters:
//     feBitSize        Size, in bytes, of the odd prime number q (modulus of GF(q)).
//     pSize            Pointer to the buffer size, in bytes, needed for the IppsGFpState
//                      context.//     
*F*/

IPPFUN(IppStatus, ippsGFpGetSize,(int feBitSize, int* pSize))
{
   IPP_BAD_PTR1_RET(pSize);
   IPP_BADARG_RET((feBitSize < 2) || (feBitSize > GFP_MAX_BITSIZE), ippStsSizeErr);

   *pSize = cpGFpGetSize(feBitSize, feBitSize+BITSIZE(BNU_CHUNK_T), GFP_POOL_SIZE)
          + GFP_ALIGNMENT;
   return ippStsNoErr;
}
