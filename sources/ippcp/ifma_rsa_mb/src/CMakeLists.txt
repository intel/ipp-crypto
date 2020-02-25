#===============================================================================
# Copyright 2019-2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#===============================================================================

file(GLOB IFMA_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/*.c"
    "${IFMA_GEN_SRC_DIR}/*.c" # python generated
)

if(IFMA_IPPCP_BUILD)
    file(GLOB IFMA_HEADERS
        ${IPP_CRYPTO_SOURCES_DIR}/ifma_rsa_mb/include/rsa_ifma/*.h
        ${IPP_CRYPTO_SOURCES_DIR}/ifma_rsa_mb/include/internal/*.h
    )

    set(IFMA_DEFINES
        "IFMA_IPPCP_BUILD"
        "BN_OPENSSL_DISABLE"
        "_K0"
    )
    
    set_source_files_properties(${IFMA_SOURCES} PROPERTIES INCLUDE_DIRECTORIES "${C_INCLUDE_DIRECTORIES}")
    add_library(${LIBRSA_IFMA_TARGET} OBJECT ${IFMA_SOURCES} ${IFMA_HEADERS})  # the library
    set_target_properties(${LIBRSA_IFMA_TARGET} PROPERTIES COMPILE_FLAGS "${k0_opt}")
    target_compile_definitions(${LIBRSA_IFMA_TARGET} PRIVATE ${IFMA_DEFINES})    
    
else()
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

    add_library(${LIBRSA_IFMA_TARGET} STATIC ${IFMA_SOURCES})  # the library
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
endif()