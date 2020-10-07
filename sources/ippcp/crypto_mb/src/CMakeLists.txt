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

set(CRYPTO_MB_SOURCES_DIR ${CMAKE_CURRENT_SOURCE_DIR})

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common.cmake")
include(${COMPILER_OPTIONS_FILE}) # Get ${CMAKE_C_FLAGS}, ${CMAKE_CXX_FLAGS} and ${AVX512_CFLAGS}

set(AVX512_LIBRARY_DEFINES "${AVX512_LIBRARY_DEFINES}" "${MB_LIBRARIES_DEFINES}" "USE_AMS_5x" "SIMD_LEN=512")

file(GLOB RSA_AVX512_SOURCES    "${CMAKE_CURRENT_SOURCE_DIR}/rsa/*.c"
                                "${CMAKE_CURRENT_SOURCE_DIR}/rsa/avx512_primitives/*.c")
file(GLOB COMMON_SOURCES        "${CMAKE_CURRENT_SOURCE_DIR}/common/*.c")
file(GLOB X25519_SOURCES        "${CMAKE_CURRENT_SOURCE_DIR}/x25519/*.c")
file(GLOB ECNIST_SOURCES        "${CMAKE_CURRENT_SOURCE_DIR}/ecnist/*.c")

if(BN_OPENSSL_PATCH) # Off by default
    list(APPEND AVX512_LIBRARY_DEFINES "BN_OPENSSL_PATCH")
endif()

if(OPENSSL_DISABLE) # Remove all OpenSSL dependencies
    list(APPEND AVX512_LIBRARY_DEFINES "BN_OPENSSL_DISABLE")
endif()
                                      
# Build static library in standalone crypto_mb build only, otherwise generate just object files
if(NOT MB_LIB_OBJ_TARGET)
    set(MB_LIB_TARGET ${MB_DYN_LIB_TARGET})
    set(AVX512_CFLAGS "${AVX512_CFLAGS} ${CMAKE_C_FLAGS_SECURITY}") # Add SDL necessary compilation options

    set_source_files_properties(${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES}
                                PROPERTIES COMPILE_DEFINITIONS  "${AVX512_LIBRARY_DEFINES}"
                                           COMPILE_FLAGS        "${AVX512_CFLAGS}")
    # Create shared library
    add_library(${MB_DYN_LIB_TARGET} SHARED ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES})

    set_target_properties(${MB_DYN_LIB_TARGET} PROPERTIES C_VISIBILITY_PRESET hidden)
    set_target_properties(${MB_DYN_LIB_TARGET} PROPERTIES VISIBILITY_INLINES_HIDDEN ON)
    set_target_properties(${MB_DYN_LIB_TARGET} PROPERTIES LINK_FLAGS "${LINK_FLAGS_DYNAMIC} ${LINK_FLAG_SECURITY}")

    if(NOT OPENSSL_DISABLE)
        target_link_libraries(${MB_DYN_LIB_TARGET} OpenSSL::Crypto) # to get includes
    endif()

    # Installation of the shared library by default 
    install(TARGETS ${MB_DYN_LIB_TARGET} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

    # Optionally create and install static library
    if(CMAKE_STATIC_ENABLE)
        set(MB_LIB_TARGET ${MB_STATIC_LIB_TARGET})
        add_library(${MB_STATIC_LIB_TARGET} STATIC ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES}) 

        set_target_properties(${MB_STATIC_LIB_TARGET} PROPERTIES C_VISIBILITY_PRESET hidden)
        set_target_properties(${MB_STATIC_LIB_TARGET} PROPERTIES VISIBILITY_INLINES_HIDDEN ON)

        if(NOT OPENSSL_DISABLE)
            target_link_libraries(${MB_STATIC_LIB_TARGET} OpenSSL::Crypto) # to get includes
        endif()

        install(TARGETS ${MB_STATIC_LIB_TARGET} DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
    endif()

    # Public headers installation
    install(DIRECTORY ${PUBLIC_HEADERS_DIR}
            DESTINATION ${CMAKE_INSTALL_PREFIX}/include/crypto_mb
            FILES_MATCHING PATTERN "*.h*")
else()
    set(MB_LIB_TARGET ${MB_LIB_OBJ_TARGET})
    set(AVX512_CFLAGS "${AVX512_CFLAGS} ${MB_COMPILE_OPTIONS}")

    set_source_files_properties(${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES}
                                PROPERTIES COMPILE_DEFINITIONS  "${AVX512_LIBRARY_DEFINES}"
                                           COMPILE_FLAGS        "${AVX512_CFLAGS}")

    add_library(${MB_LIB_OBJ_TARGET} OBJECT ${RSA_AVX512_SOURCES} ${COMMON_SOURCES} ${X25519_SOURCES} ${ECNIST_SOURCES})
endif()

# Applications.
add_subdirectory(apps)
