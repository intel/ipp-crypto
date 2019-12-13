#===============================================================================
# Copyright 2019 Intel Corporation
# All Rights Reserved.
#
# If this  software was obtained  under the  Intel Simplified  Software License,
# the following terms apply:
#
# The source code,  information  and material  ("Material") contained  herein is
# owned by Intel Corporation or its  suppliers or licensors,  and  title to such
# Material remains with Intel  Corporation or its  suppliers or  licensors.  The
# Material  contains  proprietary  information  of  Intel or  its suppliers  and
# licensors.  The Material is protected by  worldwide copyright  laws and treaty
# provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
# modified, published,  uploaded, posted, transmitted,  distributed or disclosed
# in any way without Intel's prior express written permission.  No license under
# any patent,  copyright or other  intellectual property rights  in the Material
# is granted to  or  conferred  upon  you,  either   expressly,  by implication,
# inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
# property rights must be express and approved by Intel in writing.
#
# Unless otherwise agreed by Intel in writing,  you may not remove or alter this
# notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
# suppliers or licensors in any way.
#
#
# If this  software  was obtained  under the  Apache License,  Version  2.0 (the
# "License"), the following terms apply:
#
# You may  not use this  file except  in compliance  with  the License.  You may
# obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
#
# Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
# distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the   License  for the   specific  language   governing   permissions  and
# limitations under the License.
#===============================================================================

# COMMON KEYS
set(COMPILE_OPTIONS
    "-mavx512dq"
    "-mavx512ifma"
    "-mavx512f"
    "-mavx512vbmi2"
    "-mavx512cd"
    "-mavx512bw"
    "-mbmi2"
    "-falign-functions=32"
    "-falign-loops=32"
    "-Wno-pointer-to-int-cast"
)
set(DEFINES
    # Any -D
)
if (BN_OPENSSL_PATCH)
    list(APPEND DEFINES "-DBN_OPENSSL_PATCH")
endif()

# LIBRARY
set(LIBRSA_IFMA_TARGET "librsa_ifma")

file(GLOB SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.c"
    "${CMAKE_BINARY_DIR}/src/gen/*.c" # python generated
)

add_library(${LIBRSA_IFMA_TARGET} STATIC ${SOURCES})  # the library
target_link_libraries(${LIBRSA_IFMA_TARGET} OpenSSL::Crypto) # to get includes
target_compile_options(${LIBRSA_IFMA_TARGET} PRIVATE ${COMPILE_OPTIONS} ${DEFINES})

# APPS (algo tests)
set(VFY_IFMA_RSA_MB_TARGET "vfy_ifma_rsa_mb")

add_executable(${VFY_IFMA_RSA_MB_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/apps/vfy_ifma_rsa_mb.c")
target_compile_options(${VFY_IFMA_RSA_MB_TARGET} PRIVATE ${COMPILE_OPTIONS} ${DEFINES} "-Wl,-no-pie")
target_link_libraries(${VFY_IFMA_RSA_MB_TARGET} "${LIBRSA_IFMA_TARGET}")
target_link_libraries(${VFY_IFMA_RSA_MB_TARGET} OpenSSL::Crypto)
target_link_libraries(${VFY_IFMA_RSA_MB_TARGET} "dl")
target_link_libraries(${VFY_IFMA_RSA_MB_TARGET} "pthread")

set(VFY_IFMA_CP_RSA_MB_TARGET "vfy_ifma_cp_rsa_mb")

add_executable(${VFY_IFMA_CP_RSA_MB_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/apps/vfy_ifma_cp_rsa_mb.c")
target_compile_options(${VFY_IFMA_CP_RSA_MB_TARGET} PRIVATE ${COMPILE_OPTIONS} ${DEFINES} "-Wl,-no-pie")
target_link_libraries(${VFY_IFMA_CP_RSA_MB_TARGET} "${LIBRSA_IFMA_TARGET}")
target_link_libraries(${VFY_IFMA_CP_RSA_MB_TARGET} OpenSSL::Crypto)
target_link_libraries(${VFY_IFMA_CP_RSA_MB_TARGET} "dl")
target_link_libraries(${VFY_IFMA_CP_RSA_MB_TARGET} "pthread")
