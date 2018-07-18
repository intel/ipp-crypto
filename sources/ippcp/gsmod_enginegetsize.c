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
//     Cryptography Primitive. Modular Arithmetic Engine. General Functionality
// 
//  Contents:
//        gsModEngineGetSize()
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbnumisc.h"
#include "pcpbnuarith.h"
#include "gsmodstuff.h"
#include "pcptool.h"

/*F*
// Name: gsModEngineGetSize
//
// Purpose: Specifies size of size of ModEngine context (Montgomery).
//
// Returns:                Reason:
//      ippStsLengthErr     modulusBitSize < 1
//                          numpe < MOD_ENGINE_MIN_POOL_SIZE
//      ippStsNoErr         no errors
//
// Parameters:
//      numpe           length of pool
//      modulusBitSize  max modulus length (in bits)
//      pSize           pointer to size
//
*F*/

IppStatus gsModEngineGetSize(int modulusBitSize, int numpe, int* pSize)
{
   int modLen  = BITS_BNU_CHUNK(modulusBitSize);
   int pelmLen = BITS_BNU_CHUNK(modulusBitSize);

   IPP_BADARG_RET(modulusBitSize<1, ippStsLengthErr);
   IPP_BADARG_RET(numpe<MOD_ENGINE_MIN_POOL_SIZE, ippStsLengthErr);

   /* allocates mimimal necessary to Montgomery based methods */
   *pSize = sizeof(gsModEngine)
           + modLen*sizeof(BNU_CHUNK_T)         /* modulus  */
           + modLen*sizeof(BNU_CHUNK_T)         /* mont_R   */
           + modLen*sizeof(BNU_CHUNK_T)         /* mont_R^2 */
           + pelmLen*sizeof(BNU_CHUNK_T)*numpe; /* buffers  */

   return ippStsNoErr;
}
