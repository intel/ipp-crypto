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

cmake_minimum_required(VERSION 3.10)

project("crypto_mb" C)
set(MB_DYN_LIB_TARGET "crypto_mb") # Dynamic library
set(MB_STATIC_LIB_TARGET "crypto_mb_s") # Static library

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    message(STATUS "CMAKE_BUILD_TYPE is unset, defaulting to Release")
    set(CMAKE_BUILD_TYPE "Release")
endif()

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

set(MB_INCLUDE_DIRS   "${MB_INCLUDE_DIRS}"
                      "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
set(PUBLIC_HEADERS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/include/crypto_mb/")

if(NOT OPENSSL_DISABLE)
    if(BN_OPENSSL_PATCH)
        # Link static OpenSSL only for patched version
        set(OPENSSL_USE_STATIC_LIBS TRUE)
    endif()
    find_package(OpenSSL 1.1.0 REQUIRED) # set -DOPENSSL_INCLUDE_DIR= -DOPENSSL_LIBRARIES= -DOPENSSL_ROOT_DIR= to use patched
    list(APPEND MB_INCLUDE_DIRS "${OPENSSL_INCLUDE_DIR}")
endif()

include_directories(
     ${MB_INCLUDE_DIRS}
)

add_subdirectory(src)
