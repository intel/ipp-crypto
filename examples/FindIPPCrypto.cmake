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

#
# Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography library
# detection routine.
#
# If found the following variables will be available:
#       IPPCRYPTO_FOUND
#       IPPCRYPTO_ROOT_DIR
#       IPPCRYPTO_INCLUDE_DIRS
#       IPPCRYPTO_LIBRARIES
#

include(FindPackageHandleStandardArgs)

macro(ippcp_not_found)
  set(IPPCRYPTO_FOUND OFF)
  set(IPPCRYPTO_ROOT_DIR "${IPPCRYPTO_ROOT_DIR}" CACHE PATH "Path to Intel(R) IPP Cryptography root directory")
  return()
endmacro()

# Try to find Intel(R) IPP Cryptography library on the system if root dir is not defined externally
if (NOT IPPCRYPTO_ROOT_DIR OR NOT EXISTS "${IPPCRYPTO_ROOT_DIR}/include/ippcp.h")
  set(ippcp_search_paths
    ${CMAKE_CURRENT_SOURCE_DIR}/../.build
    $ENV{IPPCRYPTOROOT})

  if(WIN32)
    list(APPEND ippcp_search_paths
      $ENV{ProgramFiles\(x86\)}/IntelSWTools/compilers_and_libraries/windows/ippcp)
  endif()

  if(UNIX)
    list(APPEND ippcp_search_paths
      /opt/intel/ippcp
      $ENV{HOME}/intel/ippcp)
  endif()

  find_path(IPPCRYPTO_ROOT_DIR include/ippcp.h PATHS ${ippcp_search_paths})
endif()

set(IPPCRYPTO_INCLUDE_DIRS "${IPPCRYPTO_ROOT_DIR}/include" CACHE PATH "Path to Intel(R) IPP Cryptography library include directory" FORCE)

# Check found directory
if(NOT IPPCRYPTO_ROOT_DIR
    OR NOT EXISTS "${IPPCRYPTO_ROOT_DIR}"
    OR NOT EXISTS "${IPPCRYPTO_INCLUDE_DIRS}"
    OR NOT EXISTS "${IPPCRYPTO_INCLUDE_DIRS}/ippcpdefs.h"
    )
  ippcp_not_found()
endif()

# Determine ARCH
set(IPPCRYPTO_ARCH "ia32")
if(CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
  set(IPPCRYPTO_ARCH "intel64")
endif()
if(CMAKE_SIZEOF_VOID_P)
  set(IPPCRYPTO_ARCH "intel64")
endif()

# Define list of libraries to search
set(ippcp_search_libraries
  ippcp)

# Define library search paths (TODO: to handle nonpic libraries)
set(ippcp_lib_search_paths "")
list(APPEND ippcp_lib_search_paths
  ${IPPCRYPTO_ROOT_DIR}/lib
  ${IPPCRYPTO_ROOT_DIR}/lib/${IPPCRYPTO_ARCH})

# Set preferences to look for static libraries only
if(WIN32)
  list(INSERT CMAKE_FIND_LIBRARY_SUFFIXES 0 .lib .a)
else()
  set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
endif()

foreach(lib ${ippcp_search_libraries})
  find_library(${lib} ${lib} ${ippcp_lib_search_paths})
  if(NOT ${lib})
    ippcp_not_found()
  endif()
  list(APPEND IPPCRYPTO_LIBRARIES ${${lib}})
endforeach()

list(REMOVE_DUPLICATES IPPCRYPTO_LIBRARIES)

message(STATUS "Found Intel(R) IPP Cryptography at: ${IPPCRYPTO_ROOT_DIR}")

set(IPPCRYPTO_FOUND ON)
set(IPPCRYPTO_ROOT_DIR "${IPPCRYPTO_ROOT_DIR}" CACHE PATH "Path to Intel(R) IPP Cryptography root directory")
set(IPPCRYPTO_INCLUDE_DIRS "${IPPCRYPTO_INCLUDE_DIRS}" CACHE PATH "Path to Intel(R) IPP Cryptography include directory")
set(IPPCRYPTO_LIBRARIES "${IPPCRYPTO_LIBRARIES}" CACHE STRING "Intel(R) IPP Cryptography libraries")
