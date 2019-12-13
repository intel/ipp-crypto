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

/* 
// 
//  Purpose: MB RSA.
// 
//  Contents: version support
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#include "rsa_ifma_defs.h"

#define IFMA_LIB_VERSION() IFMA_VER_MAJOR,IFMA_VER_MINOR,IFMA_VER_REV
#define IFMA_LIB_BUILD()   __DATE__

#define STR2(x)   #x
#define STR(x)    STR2(x)
#define IFMA_STR_VERSION()  IFMA_LIB_NAME() \
                            " (ver: " STR(IFMA_VER_MAJOR) "." STR(IFMA_VER_MINOR) "." STR(IFMA_VER_REV) \
                            " build: " IFMA_LIB_BUILD()")"

/* version info */
static const ifmaVersion ifmaLibVer = {
   IFMA_LIB_VERSION(),  /* major, minor, revision  */
   IFMA_LIB_NAME(),     /* lib name                */
   IFMA_LIB_BUILD(),    /* build date              */
   IFMA_STR_VERSION()   /* version str             */
};

const ifmaVersion* ifma_getversion(void)
{
    return &ifmaLibVer;
}

#endif
