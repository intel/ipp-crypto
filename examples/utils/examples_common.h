/*******************************************************************************
* Copyright 2019 Intel Corporation
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

/* Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography */

/*!
  *
  * \file
  * \brief Common header for Intel(R) IPP Cryptography examples
  *
  */

#ifndef EXAMPLES_COMMON_H_
#define EXAMPLES_COMMON_H_

#include <stdio.h>

/*! Macro that prints status message depending on condition */
#define PRINT_EXAMPLE_STATUS(function_name, description, success_condition)       \
    printf("+--------------------------------------------------------------|\n"); \
    printf(" Function: %s\n", function_name);                                     \
    printf(" Description: %s\n", description);                                    \
    if (success_condition) {                                                      \
        printf(" Status: OK!\n");                                                 \
    } else {                                                                      \
        printf(" Status: FAIL!\n");                                               \
    }                                                                             \
    printf("+--------------------------------------------------------------|\n");

/*!
 * Helper function to compare expected and actual function return statuses and display
 * an error mesage if those are different.
 *
 * \param[in] Function name to display
 * \param[in] Expected status
 * \param[in] Actual status
 *
 * \return zero if statuses are not equal, otherwise - non-zero value
 */
static int checkStatus(const char* funcName, IppStatus expectedStatus, IppStatus status)
{
   if (expectedStatus != status) {
      printf("%s: unexpected return status\n", funcName);
      printf("Expected: %s\n", ippcpGetStatusString(expectedStatus));
      printf("Received: %s\n", ippcpGetStatusString(status));
      return 0;
   }
   return 1;
}

/*!
 * Helper function to convert bit size into byte size.
 *
 * \param[in] Size in bits
 *
 * \return size in bytes
 */
static int bitSizeInBytes(int nBits)
{
   return (nBits + 7) >> 3;
}

#endif /* #ifndef EXAMPLES_COMMON_H_ */
