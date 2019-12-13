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
//  Purpose: MB RSA. Definitions and declarations
//
*/

#ifdef IFMA_IPPCP_BUILD
#include "owndefs.h"
#endif /* IFMA_IPPCP_BUILD */

#if !defined(IFMA_IPPCP_BUILD) || (_IPP32E>=_IPP32E_K0)

#ifndef IFMA_RSA_DEFS_H
#define IFMA_RSA_DEFS_H

/* data types */
typedef unsigned char int8u;
typedef unsigned int  int32u;
typedef unsigned long long int64u;

#ifndef NULL
   #define NULL ((void *)0)
#endif

/* alignment */
#if defined(linux)
#if !defined(__ALIGN64)
   #define __ALIGN64 __attribute__((aligned(64)))
#endif
#if !defined(__INLINE)
   #define __INLINE static __inline__
#endif
#else
#if !defined(__ALIGN64)
   #define __ALIGN64 __declspec (align(64))
#endif
#if !defined(__INLINE)
   #define __INLINE static __inline
#endif
#endif

/* externals */
#undef EXTERN_C

#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C
#endif

/* ifma name & version */
#define IFMA_LIB_NAME()    "ifma_rsa_mb8"
#define IFMA_VER_MAJOR  0
#define IFMA_VER_MINOR  5
#define IFMA_VER_REV    2

typedef struct {
   int    major;          /* e.g. 1               */
   int    minor;          /* e.g. 2               */
   int    revision;       /* e.g. 3               */
   const char* name;      /* e,g. "ifma_rsa_mb8"  */
   const char* buildDate; /* e.g. "Oct 28 2019"   */
   const char* strVersion;/* e.g. "ifma_rsa_mb8 (ver 1.2.3 Oct 28 2019" */
} ifmaVersion;

EXTERN_C const ifmaVersion* ifma_getversion(void);

#endif /* IFMA_RSA_DEFS_H */

#endif