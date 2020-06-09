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

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common.cmake")
include(${COMPILER_OPTIONS_FILE}) # Get ${CMAKE_C_FLAGS}, ${CMAKE_CXX_FLAGS} and ${AVX512_CFLAGS}

set(AVX512_LIBRARY_DEFINES "${IFMA_LIBRARYS_DEFINES}" "USE_AMS_5x" "SIMD_LEN=512")
set(AVX512_CFLAGS "${AVX512_CFLAGS} ${IFMA_COMPILE_OPTIONS}")

file(GLOB RSA_AVX512_SOURCES    "${CMAKE_CURRENT_SOURCE_DIR}/rsa/*.c"
                                "${CMAKE_CURRENT_SOURCE_DIR}/rsa/avx512_primitives/*.c")
file(GLOB COMMON_SOURCES        "${CMAKE_CURRENT_SOURCE_DIR}/common/*.c")
file(GLOB ED25519_SOURCES       "${CMAKE_CURRENT_SOURCE_DIR}/ecdh/*.c")

if(BN_OPENSSL_PATCH) # Off by default
    list(APPEND AVX512_LIBRARY_DEFINES "BN_OPENSSL_PATCH")
endif()

set_source_files_properties(${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${ED25519_SOURCES}
                            PROPERTIES COMPILE_DEFINITIONS  "${AVX512_LIBRARY_DEFINES}"
                                       COMPILE_FLAGS        "${AVX512_CFLAGS}")
                                      
# Library
if(IFMA_LIB_OBJ_TARGET)
    add_library(${IFMA_LIB_OBJ_TARGET} OBJECT ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${ED25519_SOURCES})
    add_library(${IFMA_LIB_TARGET} STATIC $<TARGET_OBJECTS:${IFMA_LIB_OBJ_TARGET}>) 
else()
    add_library(${IFMA_LIB_TARGET} STATIC ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${ED25519_SOURCES}) 
endif()

if(NOT BN_OPENSSL_DISABLE)
    target_link_libraries(${IFMA_LIB_TARGET} OpenSSL::Crypto) #to get includes
else()
    set_target_properties(${IFMA_LIB_TARGET} PROPERTIES COMPILE_DEFINITIONS "BN_OPENSSL_DISABLE")
endif()


install(TARGETS ${IFMA_LIB_TARGET} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
install(DIRECTORY ${PUBLIC_HEADERS_DIR}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include/crypto_mb
        FILES_MATCHING PATTERN "*.h*")

# Applications. Building only with OpenSSL 
if(NOT BN_OPENSSL_DISABLE)
    add_subdirectory(apps)
endif()
