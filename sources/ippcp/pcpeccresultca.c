/*******************************************************************************
* Copyright 2003-2018 Intel Corporation
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
//     ECC operation results
// 
//  Contents:
//     ippsECCGetResultString()
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"

/*F*
//    Name: ippsECCGetResultString
//
// Purpose: Returns the string corresponding to code 
//          that represents the result of validation
//
// Parameters:
//    code       The code of the validation result
//
*F*/

IPPFUN( const char*, ippsECCGetResultString, (IppECResult code))
{
   switch(code) {
   case ippECValid:           return "Validation pass successfully";
   case ippECCompositeBase:   return "Finite Field produced by Composite";
   case ippECComplicatedBase: return "Too much non-zero terms in the polynomial";
   case ippECIsZeroDiscriminant: return "Zero discriminamt";
   case ippECCompositeOrder:     return "Composite Base Point order";
   case ippECInvalidOrder:       return "Invalid Base Point order";
   case ippECIsWeakMOV:          return "EC cover by MOV Reduction Test";
   case ippECIsWeakSSSA:         return "EC cover by SS-SA Reduction Test";
   case ippECIsSupersingular:    return "EC is supersingular curve";
   case ippECInvalidPrivateKey:  return "Invalid Private Key";
   case ippECInvalidPublicKey:   return "Invalid Public Key";
   case ippECInvalidKeyPair:     return "Invalid Key Pair";
   case ippECPointOutOfGroup:    return "Point is out of group";
   case ippECPointIsAtInfinite:  return "Point at Infinity";
   case ippECPointIsNotValid:    return "Invalid EC Point";
   case ippECPointIsEqual:       return "Points are equal";
   case ippECPointIsNotEqual:    return "Points are different";
   case ippECInvalidSignature:   return "Invalid Signature";
   default:                      return "Unknown ECC result";
   }
}
