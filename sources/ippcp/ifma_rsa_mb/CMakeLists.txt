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

cmake_minimum_required(VERSION 3.12)

find_package(Python REQUIRED) # set -DPYTHON_EXECUTABLE:FILEPATH= to use specific python

# LIBRARY
set(LIBRSA_IFMA_TARGET "librsa_ifma")

if(NOT IFMA_IPPCP_BUILD)
    project("ifma_rsa_mb" C)

    if(NOT UNIX OR APPLE)
        message(FATAL_ERROR "The library can be built only on Linux")
    endif()

    set(OPENSSL_USE_STATIC_LIBS TRUE)
    find_package(OpenSSL 1.1.0 REQUIRED) # set -DOPENSSL_INCLUDE_DIR= -DOPENSSL_LIBRARIES= -DOPENSSL_ROOT_DIR= to use patched

    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)
    if("${CMAKE_BUILD_TYPE}" STREQUAL "")
        message(STATUS "CMAKE_BUILD_TYPE is unset, defaulting to Release")
        set(CMAKE_BUILD_TYPE "Release")
    endif()

    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

    include_directories(
        "${CMAKE_CURRENT_SOURCE_DIR}/include/internal"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/rsa_ifma"
    )
else()
    set(LIBRSA_IFMA_TARGET ${LIBRSA_IFMA_TARGET} PARENT_SCOPE)
endif()

# generate ifma source files
include("${CMAKE_CURRENT_SOURCE_DIR}/ifma_sources_generation.cmake")

add_subdirectory(src)
