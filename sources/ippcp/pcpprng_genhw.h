/*******************************************************************************
* Copyright 2015-2018 Intel Corporation
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
//     PRNG Functions
// 
//  Contents:
//     HW random generator
// 
// 
*/

#include "owndefs.h"

#include "owncp.h"
#include "pcpbn.h"
#include "pcptool.h"

#if !defined (_PCP_PRN_GEN_HW_H)
#define _PCP_PRN_GEN_HW_H

#if ((_IPP>=_IPP_G9) || (_IPP32E>=_IPP32E_E9))
__INLINE int cpRand_hw_sample(BNU_CHUNK_T* pSample)
{
#define LOCAL_COUNTER (8)
   int n;
   int success = 0;
   for(n=0; n<LOCAL_COUNTER && !success; n++)
      #if (_IPP_ARCH == _IPP_ARCH_IA32)
      success = _rdrand32_step(pSample);
      #elif (_IPP_ARCH == _IPP_ARCH_EM64T)
      success = _rdrand64_step(pSample);
      #else
      #error Unknown CPU arch
      #endif
   return success;
#undef LOCAL_COUNTER
}

#if (_IPP32E>=_IPP32E_E9)
__INLINE int cpRand_hw_sample32(Ipp32u* pSample)
{
#define LOCAL_COUNTER (8)
   int n;
   int success = 0;
   for(n=0; n<LOCAL_COUNTER && !success; n++)
      success = _rdrand32_step(pSample);
   return success;
#undef LOCAL_COUNTER
}
#endif

/*F*
// Name: cpRandHW_buffer
//
// Purpose: Generates a pseudorandom bit sequence
//          based on RDRAND instruction of the specified nBits length.
//
// Returns:                   Reason:
//    1                        no errors
//    0                        random bit sequence can't be generated
//
// Parameters:
//    pBuffer  pointer to the buffer
//    bufLen    buffer length
*F*/

__INLINE int cpRandHW_buffer(Ipp32u* pBuffer, int bufLen)
{
   int nSamples = bufLen/(sizeof(BNU_CHUNK_T)/sizeof(Ipp32u));

   int n;
   /* collect nSamples randoms */
   for(n=0; n<nSamples; n++, pBuffer+=(sizeof(BNU_CHUNK_T)/sizeof(Ipp32u))) {
      if( !cpRand_hw_sample((BNU_CHUNK_T*)pBuffer))
         return 0;
   }

   #if (_IPP32E>=_IPP32E_E9)
   if( bufLen%(sizeof(BNU_CHUNK_T)/sizeof(Ipp32u)) ) {
      if( !cpRand_hw_sample32(pBuffer)) {
         return 0;
      }
   }
   #endif
   return 1;
}
#endif

#endif /* #if !defined (_PCP_PRN_GEN_HW_H) */
