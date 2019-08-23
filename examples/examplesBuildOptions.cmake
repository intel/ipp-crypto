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

macro(ippcp_extend_variable target added_value)
  set("${target}" "${${target}} ${added_value}")
endmacro()

include_directories(
  ${IPP_CRYPTO_INCLUDE_DIR}/
  ${CMAKE_CURRENT_SOURCE_DIR}/utils/
  ${CMAKE_SYSTEM_INCLUDE_PATH}
  $<$<CXX_COMPILER_ID:Intel>:$ENV{ROOT}/compiler/include
  $ENV{ROOT}/compiler/include/icc>
  # $<$<BOOL:${MSVC_IDE}>:$ENV{INCLUDE}>
  )

# Windows
if(WIN32)
  set(LINK_LIB_STATIC_RELEASE_VS2013 libcmt.lib libcpmt.lib kernel32.lib user32.lib gdi32.lib uuid.lib advapi32.lib vfw32.lib shell32.lib)
  set(LINK_LIB_STATIC_DEBUG_VS2013 libcmtd.lib libcpmtd.lib kernel32.lib user32.lib gdi32.lib uuid.lib advapi32.lib vfw32.lib shell32.lib)

  set(LINK_LIB_STATIC_RELEASE_VS2015 ${LINK_LIB_STATIC_RELEASE_VS2013} libucrt.lib libvcruntime.lib)
  set(LINK_LIB_STATIC_DEBUG_VS2015 ${LINK_LIB_STATIC_DEBUG_VS2013} libucrtd.lib libvcruntime.lib)

  if (MSVC14)
    set(LINK_LIB_STATIC_RELEASE  ${LINK_LIB_STATIC_RELEASE_VS2015})
    set(LINK_LIB_STATIC_DEBUG  ${LINK_LIB_STATIC_DEBUG_VS2015})
  elseif(MSVC12)
    set(LINK_LIB_STATIC_RELEASE  ${LINK_LIB_STATIC_RELEASE_VS2013})
    set(LINK_LIB_STATIC_DEBUG  ${LINK_LIB_STATIC_DEBUG_VS2013})
  endif()

  set(LINK_FLAG_S_ST_WINDOWS "/nologo /NODEFAULTLIB /VERBOSE:SAFESEH /INCREMENTAL:NO /NXCOMPAT /DYNAMICBASE /SUBSYSTEM:CONSOLE")
  if(${ARCH} MATCHES "ia32")
    ippcp_extend_variable(LINK_FLAG_S_ST_WINDOWS "/MACHINE:X86")
  else()
    ippcp_extend_variable(LINK_FLAG_S_ST_WINDOWS "/MACHINE:X64")
  endif()

  ippcp_extend_variable(CMAKE_CXX_FLAGS "/TP /nologo /W3 /EHa /Zm512 /wd4996 /GS")
  # Intel compiler-specific option
  if(${CMAKE_CXX_COMPILER_ID} STREQUAL "Intel")
    ippcp_extend_variable(CMAKE_CXX_FLAGS "-nologo -Qfp-speculation:safe -Qfreestanding")
  endif()

  set(CMAKE_CXX_FLAGS_DEBUG "/MTd /Zi")
  set(CMAKE_CXX_FLAGS_RELEASE "/MT /Zl")

  set(OPT_FLAG "/Od")
endif(WIN32)

if(UNIX)
  # Common for Linux and macOS
  set(OPT_FLAG "-O2")
  if ((${ARCH} MATCHES "ia32") OR (NOT NONPIC_LIB))
    ippcp_extend_variable(CMAKE_CXX_FLAGS "-fstack-protector")
  endif()

  # Linux
  if(NOT APPLE)
    set(LINK_FLAG_S_ST_LINUX "-Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
    if(NOT NONPIC_LIB)
      ippcp_extend_variable(LINK_FLAG_S_ST_LINUX "-fpie")
    endif()

    ippcp_extend_variable(CMAKE_CXX_FLAGS "-D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -fpie -fPIE")

    if(${ARCH} MATCHES "ia32")
      ippcp_extend_variable(LINK_FLAG_S_ST_LINUX "-m32")
      ippcp_extend_variable(CMAKE_CXX_FLAGS "-m32")
    endif()
  else()
    # macOS
    set(LINK_FLAG_S_ST_MACOSX "-Wl,-macosx_version_min,10.8")

    ippcp_extend_variable(CMAKE_CXX_FLAGS "-fpic")
    if(${ARCH} MATCHES "ia32")
      ippcp_extend_variable(CMAKE_CXX_FLAGS "-arch i386")
    else()
      ippcp_extend_variable(CMAKE_CXX_FLAGS "-arch x86_64")
    endif()
  endif()
endif()

macro(ippcp_example_set_build_options target link_libraries)
  if(${CMAKE_C_COMPILER_ID} STREQUAL "GNU")
    target_link_libraries(${target} -static-libgcc -static-libstdc++)
  endif()
  target_link_libraries(${target} ${link_libraries})
  set_target_properties(${target} PROPERTIES COMPILE_FLAGS ${OPT_FLAG})
  if(WIN32)
    foreach(link ${LINK_LIB_STATIC_DEBUG})
      target_link_libraries(${target} debug ${link})
    endforeach()
    foreach(link ${LINK_LIB_STATIC_RELEASE})
      target_link_libraries(${target} optimized ${link})
    endforeach()
    set_target_properties(${target} PROPERTIES LINK_FLAGS ${LINK_FLAG_S_ST_WINDOWS})
  else()
    if(NOT APPLE)
      set_target_properties(${target} PROPERTIES LINK_FLAGS "${LINK_FLAG_S_ST_LINUX}")
      target_link_libraries(${target} pthread)
    else()
      set_target_properties(${target} PROPERTIES LINK_FLAGS ${LINK_FLAG_S_ST_MACOSX})
    endif()
    if(CODE_COVERAGE)
      target_link_libraries(${target} ipgo)
    endif()
  endif()
endmacro()
