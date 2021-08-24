#===============================================================================
# Copyright 2019-2021 Intel Corporation
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

# Define defaults for every supported compiler  
set(DEFAULT_GNU_COMPILER_VER 8.2.0)
set(DEFAULT_CLANG_COMPILER_VER 9.0.0)
set(DEFAULT_Intel_COMPILER_VER 19.0.0)

# Check compiler version
if(("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU") AND (CMAKE_C_COMPILER_VERSION VERSION_LESS DEFAULT_GNU_COMPILER_VER))
    message(FATAL_ERROR "GNU C Compiler version must be 8.2 or higher")
endif()
if(("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang") AND (CMAKE_C_COMPILER_VERSION VERSION_LESS DEFAULT_CLANG_COMPILER_VER))
  message(FATAL_ERROR "Clang C Compiler version must be 9.0 or higher")
endif()
if(("${CMAKE_C_COMPILER_ID}" STREQUAL "Intel") AND (CMAKE_C_COMPILER_VERSION VERSION_LESS DEFAULT_Intel_COMPILER_VER))
    message(FATAL_ERROR "Compiler version must be 19.0 or higher")
endif()

include("${CRYPTO_MB_SOURCES_DIR}/cmake/common.cmake")
include(${COMPILER_OPTIONS_FILE}) # Get ${CMAKE_C_FLAGS}, ${CMAKE_CXX_FLAGS} and ${AVX512_CFLAGS}

set(AVX512_LIBRARY_DEFINES "${AVX512_LIBRARY_DEFINES}" "${MB_LIBRARIES_DEFINES}" "USE_AMS_5x" "SIMD_LEN=512")

# Sources
file(GLOB RSA_AVX512_SOURCES    "${CRYPTO_MB_SOURCES_DIR}/rsa/*.c"
                                "${CRYPTO_MB_SOURCES_DIR}/rsa/avx512_primitives/*.c")
file(GLOB COMMON_SOURCES        "${CRYPTO_MB_SOURCES_DIR}/common/*.c")
file(GLOB X25519_SOURCES        "${CRYPTO_MB_SOURCES_DIR}/x25519/*.c")
file(GLOB ECNIST_SOURCES        "${CRYPTO_MB_SOURCES_DIR}/ecnist/*.c")
file(GLOB SM2_SOURCES           "${CRYPTO_MB_SOURCES_DIR}/sm2/*.c")
file(GLOB SM3_SOURCES           "${CRYPTO_MB_SOURCES_DIR}/sm3/*.c")
file(GLOB SM4_SOURCES           "${CRYPTO_MB_SOURCES_DIR}/sm4/*.c")
file(GLOB ED25519_SOURCES       "${CRYPTO_MB_SOURCES_DIR}/ed25519/*.c")
file(GLOB EXP_SOURCES           "${CRYPTO_MB_SOURCES_DIR}/exp/*.c")

# Headers
file(GLOB PUBLIC_HEADERS    "${CRYPTO_MB_INCLUDE_DIR}/crypto_mb/*.h")
file(GLOB PRIVATE_HEADERS   "${CRYPTO_MB_INCLUDE_DIR}/internal/common/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/ecnist/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/rsa/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/sm2/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/sm3/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/sm4/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/ed25519/*.h"
                            "${CRYPTO_MB_INCLUDE_DIR}/internal/exp/*.h")
file(GLOB OPENSSL_HEADERS   "${OPENSSL_INCLUDE_DIR}/openssl/*.h")

set(CRYPTO_MB_SOURCES ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES} ${SM2_SOURCES} ${SM3_SOURCES} ${SM4_SOURCES} ${ED25519_SOURCES} ${EXP_SOURCES})
set(CRYPTO_MB_HEADERS ${PUBLIC_HEADERS} ${PRIVATE_HEADERS} ${OPENSSL_HEADERS})

set(WIN_RESOURCE_FILE ${CRYPTO_MB_SOURCES_DIR}/common/crypto_mb_ver.rc)
set(CPU_FEATURES_FILE ${CRYPTO_MB_SOURCES_DIR}/common/cpu_features.c)

# Disable compiler optimizations for this file, as compiler adds some ISA specific code
# which is unwanted for functions that are aimed to work on any CPU
list(REMOVE_ITEM CRYPTO_MB_SOURCES ${CPU_FEATURES_FILE})
if("${OS_STRING}" STREQUAL "windows")
    set_source_files_properties(${CPU_FEATURES_FILE} PROPERTIES  COMPILE_FLAGS  "${CMAKE_C_FLAGS_SECURITY} /Od")
else()
    set_source_files_properties(${CPU_FEATURES_FILE} PROPERTIES  COMPILE_FLAGS  "${CMAKE_C_FLAGS_SECURITY} -O0")
endif()

if(BN_OPENSSL_PATCH) # Off by default
    list(APPEND AVX512_LIBRARY_DEFINES "BN_OPENSSL_PATCH")
endif()
                                      
set(MB_LIB_TARGET ${MB_DYN_LIB_TARGET})

set_source_files_properties(${CRYPTO_MB_SOURCES} PROPERTIES COMPILE_DEFINITIONS  "${AVX512_LIBRARY_DEFINES}"
                                                            COMPILE_FLAGS        "${AVX512_CFLAGS} ${CMAKE_ASM_FLAGS} ${CMAKE_C_FLAGS_SECURITY}")

# Don't specify architectural flags for the assembler for this sources, because of the bug in Intel® C Compiler under MacOS: error: invalid instruction mnemonic 'vkmovb'
# The bug has been fixed since version 2021.3. This is a workaround to support older versions of Intel® C Compiler.
if(CMAKE_C_COMPILER_VERSION VERSION_LESS 20.2.3)
    set_source_files_properties(${X25519_SOURCES} PROPERTIES    COMPILE_DEFINITIONS  "${AVX512_LIBRARY_DEFINES}"
                                                                COMPILE_FLAGS        "${AVX512_CFLAGS} ${CMAKE_C_FLAGS_SECURITY}")
endif()

# Create shared library
if(DYNAMIC_LIB OR MB_STANDALONE)
    if(WIN32)
        add_library(${MB_DYN_LIB_TARGET} SHARED ${CRYPTO_MB_HEADERS} ${CRYPTO_MB_SOURCES} ${CPU_FEATURES_FILE} ${WIN_RESOURCE_FILE})
    else()
        add_library(${MB_DYN_LIB_TARGET} SHARED ${CRYPTO_MB_HEADERS} ${CRYPTO_MB_SOURCES} ${CPU_FEATURES_FILE})
    endif()

    set_target_properties(${MB_DYN_LIB_TARGET} PROPERTIES C_VISIBILITY_PRESET hidden
                                                          VISIBILITY_INLINES_HIDDEN ON
                                                          LINK_FLAGS "${LINK_FLAGS_DYNAMIC} ${LINK_FLAG_SECURITY}"
                                                          PUBLIC_HEADER "${PUBLIC_HEADERS}"
                                                          )

    if(UNIX)
        set_target_properties(${MB_DYN_LIB_TARGET} PROPERTIES  VERSION   ${MBX_INTERFACE_VERSION}
                                                               SOVERSION ${MBX_INTERFACE_VERSION_MAJOR})
    endif()

    target_link_libraries(${MB_DYN_LIB_TARGET} OpenSSL::Crypto)
endif(DYNAMIC_LIB OR MB_STANDALONE)

# Installation of the shared library
if (MB_STANDALONE) # standalone crypto_mb's cmake run
    install(TARGETS ${MB_DYN_LIB_TARGET}
            LIBRARY DESTINATION "lib"
            RUNTIME DESTINATION "lib"
            PUBLIC_HEADER DESTINATION "include/crypto_mb")
elseif (DYNAMIC_LIB) # build from ippcp's cmake
    install(TARGETS ${MB_DYN_LIB_TARGET}
            LIBRARY DESTINATION "lib/intel64"
            RUNTIME DESTINATION "lib/intel64"
            PUBLIC_HEADER DESTINATION "include/crypto_mb")
endif()

# Static library
if(WIN32)
    add_library(${MB_STATIC_LIB_TARGET} STATIC ${CRYPTO_MB_HEADERS} ${CRYPTO_MB_SOURCES} ${CPU_FEATURES_FILE} ${WIN_RESOURCE_FILE})
else()
    add_library(${MB_STATIC_LIB_TARGET} STATIC ${CRYPTO_MB_HEADERS} ${CRYPTO_MB_SOURCES} ${CPU_FEATURES_FILE})
endif()

set_target_properties(${MB_STATIC_LIB_TARGET} PROPERTIES C_VISIBILITY_PRESET hidden
                                                         VISIBILITY_INLINES_HIDDEN ON
                                                         PUBLIC_HEADER "${PUBLIC_HEADERS}")

target_link_libraries(${MB_STATIC_LIB_TARGET} OpenSSL::Crypto)
if(WIN32)
    set_target_properties(${MB_STATIC_LIB_TARGET} PROPERTIES OUTPUT_NAME "${MB_LIB_TARGET}mt")
else()
    set_target_properties(${MB_STATIC_LIB_TARGET} PROPERTIES OUTPUT_NAME "${MB_LIB_TARGET}")
endif()

# Static lib installation
if(MB_STANDALONE)
    install(TARGETS ${MB_STATIC_LIB_TARGET}
            ARCHIVE DESTINATION "lib"
            PUBLIC_HEADER DESTINATION "include/crypto_mb")
else()
    install(TARGETS ${MB_STATIC_LIB_TARGET}
            ARCHIVE DESTINATION "lib/intel64"
            PUBLIC_HEADER DESTINATION "include/crypto_mb")
endif()
