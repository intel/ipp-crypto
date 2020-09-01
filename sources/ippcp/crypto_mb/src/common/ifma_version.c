/*******************************************************************************
* Copyright 2019-2020 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

#include <internal/common/ifma_defs.h>

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

DLL_PUBLIC
const ifmaVersion* mbx_getversion(void)
{
    return &ifmaLibVer;
}
