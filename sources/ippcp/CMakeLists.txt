#===============================================================================
# Copyright 2017-2018 Intel Corporation
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
# Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography
#

include (GenerateExportHeader)

set(TARGET_NAME ${LIB_NAME})

#Set platform list
if (NOT MERGED_BLD)
  if(${ARCH} MATCHES "ia32")
    set(BASE_PLATFORM_LIST px)
  else()
    set(BASE_PLATFORM_LIST mx)
  endif()
endif()
if(WIN32)
  if(${ARCH} MATCHES "ia32")
    set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} w7 s8 p8 g9 h9)
  else()
    set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} m7 n8 y8 e9 l9 k0)
  endif()
endif(WIN32)
if(UNIX)
  if(APPLE)
    if(${ARCH} MATCHES "ia32")
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} s8 p8 g9 h9)
    else()
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} n8 y8 e9 l9 k0)
    endif(${ARCH} MATCHES "ia32")
  elseif(ANDROID)
    if(${ARCH} MATCHES "ia32")
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} s8 p8 g9 h9)
    else()
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} n8 y8 e9 l9)
    endif(${ARCH} MATCHES "ia32")
  else()
    if (${ARCH} MATCHES "ia32")
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} w7 s8 p8 g9 h9)
    else()
      set(BASE_PLATFORM_LIST ${BASE_PLATFORM_LIST} m7 n8 y8 e9 l9 n0 k0)
    endif(${ARCH} MATCHES "ia32")
  endif(APPLE)
endif(UNIX)

if(PLATFORM_LIST)
  if (NOT MERGED_BLD)
    foreach(opt ${PLATFORM_LIST})
      set(FOUND_PLATFORM false)
      foreach(base_opt ${BASE_PLATFORM_LIST})
        string(STRIP "${opt}" opt_strip)
        if(opt_strip STREQUAL base_opt)
          set(FOUND_PLATFORM true)
        endif()
      endforeach(base_opt ${BASE_PLATFORM_LIST})
      if(NOT FOUND_PLATFORM)
        message (FATAL_ERROR "Incorrect platform: " ${opt})
      endif()
    endforeach(opt ${PLATFORM_LIST})
    if (PLATFORM_LIST STREQUAL "")
      message (FATAL_ERROR "PLATFORM_LIST cannot be empty")
    endif(PLATFORM_LIST STREQUAL "")
  else()
    message (FATAL_ERROR "PLATFORM_LIST cannot be set, when MERGED_BLD is on")
  endif(NOT MERGED_BLD)
endif()

if(NOT PLATFORM_LIST)
  set(PLATFORM_LIST ${BASE_PLATFORM_LIST})
endif()

if (NOT MERGED_BLD)
  set(PLATFORM_LIST ${PLATFORM_LIST} PARENT_SCOPE)
endif(NOT MERGED_BLD)

set(px_opt "-D_PX")
set(w7_opt "-D_W7")
set(s8_opt "-D_S8")
set(p8_opt "-D_P8")
set(g9_opt "-D_G9")
set(h9_opt "-D_H9")
set(mx_opt "-D_PX")
set(m7_opt "-D_M7")
set(n8_opt "-D_N8")
set(y8_opt "-D_Y8")
set(e9_opt "-D_E9")
set(l9_opt "-D_L9")
set(n0_opt "-D_N0")
set(k0_opt "-D_K0")

# define defaults for every supported compiler
set(DEFAULT_Intel_COMPILER_VER 18.0.0)
set(DEFAULT_MSVC_COMPILER_VER 19.14.26433)

string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+).*$" "\\1.\\2.\\3" CMAKE_C_COMPILER_VERSION_SHORT ${CMAKE_C_COMPILER_VERSION})

if(UNIX)
  if(APPLE)
    set(OS_STRING "macosx")
  elseif(ANDROID)
    set(OS_STRING "android")
  else()
    set(OS_STRING "linux")
  endif()
else()
  set(OS_STRING   "windows")
endif()

include("${CMAKE_SOURCE_DIR}/sources/cmake/${OS_STRING}/common.cmake") # common build options and ${OS_DEFAULT_COMPILER}

set(COMPILER_OPTIONS_FILE "${CMAKE_SOURCE_DIR}/sources/cmake/${OS_STRING}")
if (EXISTS "${COMPILER_OPTIONS_FILE}/${CMAKE_C_COMPILER_ID}${CMAKE_C_COMPILER_VERSION_SHORT}.cmake")
  set(COMPILER_OPTIONS_FILE "${COMPILER_OPTIONS_FILE}/${CMAKE_C_COMPILER_ID}${CMAKE_C_COMPILER_VERSION_SHORT}.cmake")
else()
  if ("${DEFAULT_${CMAKE_C_COMPILER_ID}_COMPILER_VER}" STREQUAL "")
    set(COMPILER_OPTIONS_FILE "${COMPILER_OPTIONS_FILE}/${OS_DEFAULT_COMPILER}.cmake")
    message(WARNING "Unknown compiler, using options from the OS default one: ${OS_DEFAULT_COMPILER}")
  else()
    set(COMPILER_OPTIONS_FILE "${COMPILER_OPTIONS_FILE}/${CMAKE_C_COMPILER_ID}${DEFAULT_${CMAKE_C_COMPILER_ID}_COMPILER_VER}.cmake")
    if(CMAKE_C_COMPILER_VERSION VERSION_LESS ${DEFAULT_${CMAKE_C_COMPILER_ID}_COMPILER_VER})
      message(WARNING "Version of the compiler is lower than default, using options from: ${DEFAULT_${CMAKE_C_COMPILER_ID}_COMPILER_VER}")
    endif()
  endif()
endif()

message (STATUS "Using compiler options from ........... " ${COMPILER_OPTIONS_FILE})

file(GLOB_RECURSE HEADERS
    ${IPP_CRYPTO_SOURCES_DIR}/*.h
    ${IPP_CRYPTO_SOURCES_INCLUDE_DIR}/*.h
    ${IPP_CRYPTO_INCLUDE_DIR}/ippcp*.h
   )

file(GLOB_RECURSE SOURCES
    ${IPP_CRYPTO_SOURCES_DIR}/*.c
   )

if(WIN32)
  file(GLOB_RECURSE ASM_SOURCES
      ${IPP_CRYPTO_SOURCES_DIR}/asm_${ARCH}/*.asm
  )
  file(GLOB_RECURSE ASM_SOURCES_PCS
    ${IPP_CRYPTO_SOURCES_DIR}/asm_${ARCH}/cpinitas.asm
  )
else()
  if(APPLE)
      set(ASM_PLAT_ARCH_PATH ${IPP_CRYPTO_SOURCES_DIR}/asm_${ARCH}_gas_converted/macosx)
  else()
    if(NONPIC_LIB)
      set(ASM_PLAT_ARCH_PATH ${IPP_CRYPTO_SOURCES_DIR}/asm_${ARCH}_gas_converted/linux/nonpic)
    else()
      set(ASM_PLAT_ARCH_PATH ${IPP_CRYPTO_SOURCES_DIR}/asm_${ARCH}_gas_converted/linux/pic)
    endif()
  endif()
  file(GLOB_RECURSE ASM_SOURCES_PCS
    ${ASM_PLAT_ARCH_PATH}/cpinitas/cpinitas.asm
  )
endif(WIN32)

file(GLOB_RECURSE TEST_SOURCES
    ${IPP_CRYPTO_TEST_DIR}/interface/*.cpp
   )

if(${CMAKE_C_COMPILER_ID} STREQUAL "Intel")
  if(NOT ANDROID)
    include_directories(
        ${IPP_CRYPTO_SOURCES_DIR}
        ${IPP_CRYPTO_SOURCES_INCLUDE_DIR}
        ${IPP_CRYPTO_INCLUDE_DIR}
        $ENV{ROOT}/compiler/include
        $ENV{ROOT}/compiler/include/icc
        $ENV{INCLUDE}
       )
  else()
    include_directories(
        ${IPP_CRYPTO_SOURCES_DIR}
        ${IPP_CRYPTO_SOURCES_INCLUDE_DIR}
        ${IPP_CRYPTO_INCLUDE_DIR}
        $ENV{ANDROID_GNU_X86_TOOLCHAIN}/include
        $ENV{ANDROID_SYSROOT}/usr/include
        $ENV{ANDROID_NDK_ROOT}/sources/cxx-stl/stlport/stlport
       )
  endif()
elseif(MSVC_IDE)
  include_directories(
      ${IPP_CRYPTO_SOURCES_DIR}
      ${IPP_CRYPTO_SOURCES_INCLUDE_DIR}
      ${IPP_CRYPTO_INCLUDE_DIR}/
      $ENV{INCLUDE}
      ${CMAKE_SYSTEM_INCLUDE_PATH}
    )
endif()

if(WIN32)
  set(can_use_assembler FALSE)
  enable_language(ASM_MASM)
  if(CMAKE_ASM_MASM_COMPILER_WORKS)
    set(can_use_assembler TRUE)
  else()
    message(FATAL_ERROR "Can't find assembler")
  endif()
else()
  set(can_use_assembler FALSE)
  if(USEYASM)
    set(CMAKE_ASM-ATT_COMPILER "${USEYASM}")
  endif(USEYASM)
  enable_language(ASM-ATT)
  if(CMAKE_ASM-ATT_COMPILER_WORKS)
    set(can_use_assembler TRUE)
  else()
    message(FATAL_ERROR "Can't find assembler")
  endif()
endif(WIN32)

set(LIBRARY_DEFINES "${LIBRARY_DEFINES} -D__STDC__ -D_IPP_DEBUG -D_IPP_C99 -D_IPP_v50_ -D_IPP_VERSION=\"-2019.0\"")

if(THREADED_LIB)
  set(LIBRARY_DEFINES "${LIBRARY_DEFINES} -D_IPP_OMP_STATIC")
endif()

# set Intel(R) IPP revision, if required
if(IPP_REVISION)
  set(LIBRARY_DEFINES "${LIBRARY_DEFINES} -DIPP_REVISION=${IPP_REVISION}")
endif()

include(${COMPILER_OPTIONS_FILE}) # uses ${CMAKE_C_FLAGS} ${LIBRARY_DEFINES} ${<letter>opt} from the scope

if(UNIX)
  if(ARCH MATCHES "ia32")
    if(NOT APPLE)
      set(ASMOPTS "--32")
    elseif(NOT USEYASM)
      set(ASMOPTS "-arch i386")
    endif(NOT APPLE)
  endif(ARCH MATCHES "ia32")
endif(UNIX)

if(UNIX)
  set(CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> <SOURCE> ${ASMOPTS} -o <OBJECT>")
  if(APPLE)
    if(USEYASM STREQUAL "")
      set(CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> <SOURCE> -q ${ASMOPTS} -o <OBJECT> -xassembler")
    else()
      if(${ARCH} MATCHES "ia32")
        set(CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> ${ASMOPTS} -o <OBJECT> -pgas -fmacho32 -mx86 -ax86 <SOURCE>")
      else()
        set(CMAKE_ASM-ATT_COMPILE_OBJECT "<CMAKE_ASM-ATT_COMPILER> ${ASMOPTS} -o <OBJECT> -pgas -fmacho64 -mamd64 -ax86 <SOURCE>")
      endif(${ARCH} MATCHES "ia32")
    endif(USEYASM STREQUAL "")
  endif(APPLE)
endif(UNIX)

if(UNIX)
  if(APPLE)
    set(LIB_EXPORT_FILE "-exported_symbols_list ${IPP_CRYPTO_SOURCES_DIR}/exports.macosx.lib-export")
  else()
    set(LIB_EXPORT_FILE "${IPP_CRYPTO_SOURCES_DIR}/exports.linux.lib-export")
  endif(APPLE)
  set(CMAKE_C_CREATE_SHARED_LIBRARY "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_C_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> ${LIB_EXPORT_FILE} <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
  set(CMAKE_CXX_CREATE_SHARED_LIBRARY "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LANGUAGE_COMPILE_FLAGS> <LINK_FLAGS> ${LIB_EXPORT_FILE} <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <SONAME_FLAG><TARGET_SONAME> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
endif(UNIX)

if(WIN32)
  set(ADD_ASMOPTS "/Cx")
  if(${ARCH} MATCHES "ia32")
    set(ADD_ASMOPTS "${ADD_ASMOPTS} /coff /safeseh")
  endif(${ARCH} MATCHES "ia32")

  foreach(srcfile ${ASM_SOURCES} ${ASM_SOURCES_PCS})
    if(${srcfile} MATCHES ".*asm")
      set_source_files_properties(${srcfile} PROPERTIES COMPILE_FLAGS ${ADD_ASMOPTS})
    endif()
  endforeach()
endif(WIN32)

if(THREADED_LIB)
  set(THREAD_SUFFIX "mt")
else()
  set(THREAD_SUFFIX "st")
endif(THREADED_LIB)
set(THREAD_SUFFIX  ${THREAD_SUFFIX}  PARENT_SCOPE)

if(NOT MERGED_BLD)
  set(IPPCP_LIB_STATIC "")
  set(IPPCP_LIB_DYNAMIC "")
endif(NOT MERGED_BLD)

cmake_policy(SET CMP0054 NEW)
set(ADD_CPINITAS_MERGEDSTATIC on)
foreach(opt ${PLATFORM_LIST})
  if(UNIX)
    file(GLOB_RECURSE ASM_SOURCES
      ${ASM_PLAT_ARCH_PATH}/${opt}/singlecpu/*.asm
    )
    list(APPEND ASM_SOURCES ${ASM_PLAT_ARCH_PATH}/cpinitas/cpinitas.asm)
  endif()

  if(DYNAMIC_LIB)
    set(IPPCP_DYN_ITER ${TARGET_NAME}_dyn_${opt})
    if(WIN32)
      add_library(${IPPCP_DYN_ITER} SHARED ippcp.def ${HEADERS} ${SOURCES} ${ASM_SOURCES} pcpver.rc)
      GENERATE_EXPORT_HEADER( ${IPPCP_DYN_ITER}
               BASE_NAME ${IPPCP_DYN_ITER}
               EXPORT_MACRO_NAME ${IPPCP_DYN_ITER}_EXPORT
               EXPORT_FILE_NAME ${IPPCP_DYN_ITER}_Export.h
               STATIC_DEFINE ${IPPCP_DYN_ITER}_BUILT_AS_STATIC
      )
      set_target_properties(${IPPCP_DYN_ITER} PROPERTIES LINK_FLAGS ${LINK_FLAG_DYNAMIC_WINDOWS})
      foreach(link ${LINK_LIB_STATIC_DEBUG})
        target_link_libraries(${IPPCP_DYN_ITER} debug ${link})
      endforeach()
      foreach(link ${LINK_LIB_STATIC_RELEASE})
        target_link_libraries(${IPPCP_DYN_ITER} optimized ${link})
      endforeach()
      if(THREADED_LIB)
        if(${CMAKE_C_COMPILER_ID} STREQUAL "Intel")
          target_link_libraries(${IPPCP_DYN_ITER} libiomp5md.lib)
        elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")
          target_link_libraries(${IPPCP_DYN_ITER} vcomp.lib)
        endif()
      endif(THREADED_LIB)
      # place ddls to lib folder
      set_target_properties(${IPPCP_DYN_ITER} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    else()
      add_library(${IPPCP_DYN_ITER} SHARED  ${HEADERS} ${SOURCES} ${ASM_SOURCES})
      if(APPLE)
        set(LINK_FLAG_DYNAMIC_MACOSX "${LINK_FLAG_DYNAMIC_MACOSX} -install_name @rpath/libippcp${opt}.dylib")
        set_target_properties(${IPPCP_DYN_ITER} PROPERTIES LINK_FLAGS ${LINK_FLAG_DYNAMIC_MACOSX})
      else()
        set_target_properties(${IPPCP_DYN_ITER} PROPERTIES LINK_FLAGS ${LINK_FLAG_DYNAMIC_LINUX})
      endif()
      if(THREADED_LIB)
        target_link_libraries(${IPPCP_DYN_ITER} iomp5)
      endif()
    endif()
    set_target_properties(${IPPCP_DYN_ITER} PROPERTIES OUTPUT_NAME ${TARGET_NAME}${opt})
    list(APPEND IPPCP_LIB_DYNAMIC ${IPPCP_DYN_ITER})
  endif(DYNAMIC_LIB)

  set(IPPCP_ST_ITER ${TARGET_NAME}_s_${opt})
  if(MERGED_BLD)
    if(UNIX)
      file(GLOB_RECURSE ASM_SOURCES
        ${ASM_PLAT_ARCH_PATH}/${opt}/merged/*.asm
      )
      if(ADD_CPINITAS_MERGEDSTATIC)
        set(ADD_CPINITAS_MERGEDSTATIC off)
        list(APPEND ASM_SOURCES ${ASM_PLAT_ARCH_PATH}/cpinitas/cpinitas.asm)
      endif()
    endif()

    add_library(${IPPCP_ST_ITER} OBJECT ${HEADERS} ${SOURCES} ${ASM_SOURCES})
    set(merged_dependency ${merged_dependency} $<TARGET_OBJECTS:${IPPCP_ST_ITER}>)
    set(MERGED_FLAGS "-D_OWN_MERGED_BLD -D_MERGED_BLD")
  else()
    add_library(${IPPCP_ST_ITER} STATIC ${HEADERS} ${SOURCES} ${ASM_SOURCES})
  endif()
  
  if(WIN32)
    set_target_properties(${IPPCP_ST_ITER} PROPERTIES STATIC_LIBRARY_FLAGS ${LINK_FLAG_STATIC_WINDOWS})
  endif()

  list(APPEND IPPCP_LIB_STATIC ${IPPCP_ST_ITER})

  # # Set optimization flags
  
  set(OPT_FLAGS_${opt} ${${opt}_opt})

  set_target_properties(${IPPCP_ST_ITER} PROPERTIES COMPILE_FLAGS "${OPT_FLAGS_${opt}} ${MERGED_FLAGS}")
  # Set optimization flag for cpinit.c to -O1
  # Fix for problem related with MSVC compiler -O2 optimization
  if((${ARCH} STREQUAL "intel64") AND ("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")) 
    set_source_files_properties(cpinit.c PROPERTIES COMPILE_FLAGS " -O1")
  endif()
  if(DYNAMIC_LIB)
    set_target_properties(${IPPCP_DYN_ITER} PROPERTIES COMPILE_FLAGS "${OPT_FLAGS_${opt}} -D_IPP_DATA ")
  endif(DYNAMIC_LIB)

endforeach()

if(MERGED_BLD)
  list(GET IPPCP_LIB_STATIC 0 IPPCP_LIB_STATIC_FIRST)
  set_target_properties(${IPPCP_LIB_STATIC_FIRST} PROPERTIES COMPILE_OPTIONS -D_IPP_DATA)
else()
  set(IPPCP_LIB_STATIC  ${IPPCP_LIB_STATIC}  PARENT_SCOPE)
  set(IPPCP_LIB_DYNAMIC ${IPPCP_LIB_DYNAMIC} PARENT_SCOPE)

  foreach(lib ${IPPCP_LIB_STATIC})
    set_target_properties(${lib} PROPERTIES COMPILE_OPTIONS -D_IPP_DATA)
  endforeach(lib ${IPPCP_LIB_STATIC})
endif()

if(MERGED_BLD)
  set(DISPATCHER ${CMAKE_BINARY_DIR}/dispatcher)
  set(IPPCP_API ${IPP_CRYPTO_INCLUDE_DIR}/ippcp.h)
  file(MAKE_DIRECTORY ${DISPATCHER})

  if(WIN32)
    if(${ARCH} MATCHES "ia32")
      set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_win32.py)
    else()
      set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_win64.py)
    endif()
  elseif(UNIX)
    if(APPLE)
      if(${ARCH} MATCHES "ia32")
        set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_mac32.py)
      else()
        set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_mac64.py)
      endif()
    else()
      if(NOT NONPIC_LIB)
        if(${ARCH} MATCHES "ia32")
          set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_lin32.py)
        else()
          set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_lin64.py)
        endif()
      else()
        if(${ARCH} MATCHES "ia32")
          set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_lin32.nonpic.py)
        else()
          set(DISPATCHER_GENERATOR ${IPP_CRYPTO_DISPATCHER_DIR}/gen_disp_lin64.nonpic.py)
        endif()
      endif()
    endif()
  endif(WIN32)

  execute_process(COMMAND ${PYTHON_EXECUTABLE} ${DISPATCHER_GENERATOR} ${IPPCP_API} ${DISPATCHER} "${PLATFORM_LIST}"
    RESULT_VARIABLE result
  )

  file(GLOB_RECURSE HEADERS
    ${CMAKE_BINARY_DIR}/dispatcher/*.h
  )

  file(GLOB_RECURSE SOURCES
    ${CMAKE_BINARY_DIR}/dispatcher/*.c
  )

  file(GLOB_RECURSE ASM_SOURCES
    ${CMAKE_BINARY_DIR}/dispatcher/*.asm
  )

  set(SOURCES ${SOURCES} ${ASM_SOURCES} ${merged_dependency})

  set(IPPCP_LIB_MERGED ${TARGET_NAME}_s)
  set(IPPCP_LIB_MERGED ${IPPCP_LIB_MERGED} PARENT_SCOPE)
  add_library(${IPPCP_LIB_MERGED} STATIC ${HEADERS} ${SOURCES})
  if(WIN32)
    set_target_properties(${IPPCP_LIB_MERGED} PROPERTIES OUTPUT_NAME "${TARGET_NAME}mt")
    set_target_properties(${IPPCP_LIB_MERGED} PROPERTIES STATIC_LIBRARY_FLAGS ${LINK_FLAG_STATIC_WINDOWS})
  else()
    set_target_properties(${IPPCP_LIB_MERGED} PROPERTIES OUTPUT_NAME "${TARGET_NAME}")
  endif(WIN32)

  if(UNIX)
    if(${ARCH} MATCHES "ia32")
      set_target_properties(${IPPCP_LIB_MERGED} PROPERTIES COMPILE_FLAGS "${CC_FLAGS_INLINE_ASM_UNIX_IA32} -D_GNU_SOURCE -D_FORTIFY_SOURCE=2 -O2")
    else()
      set_target_properties(${IPPCP_LIB_MERGED} PROPERTIES COMPILE_FLAGS "${CC_FLAGS_INLINE_ASM_UNIX_INTEL64} -D_GNU_SOURCE -D_FORTIFY_SOURCE=2 -O2")
    endif()
  endif()


  # Dynamic library
  if(DYNAMIC_LIB)
    set(IPPCP_LIB_PCS ${TARGET_NAME}_dyn)
    set(IPPCP_LIB_PCS ${IPPCP_LIB_PCS} PARENT_SCOPE)
    if(WIN32)
      if((${ARCH} STREQUAL "intel64") AND ("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC"))
        # Generate dynamic dispatcher for MSVC intel64
        file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/dispatcher_dyn)
        execute_process(COMMAND ${PYTHON_EXECUTABLE} ${IPP_CRYPTO_DISPATCHER_DIR}/gen_dyn_disp_win64.py ${IPPCP_API} ${CMAKE_BINARY_DIR}/dispatcher_dyn
          RESULT_VARIABLE result
        )
        set(ASM_SOURCES_PCS ${ASM_SOURCES_PCS} ${CMAKE_BINARY_DIR}/dispatcher_dyn/jmp_dynamic_lib.asm)
      endif()
      add_library(${IPPCP_LIB_PCS} SHARED pcpmain.c cpinit.c ${ASM_SOURCES_PCS} ippcp.def pcpver.rc)
      generate_export_header(${IPPCP_LIB_PCS}
               BASE_NAME ${IPPCP_LIB_PCS}
               EXPORT_MACRO_NAME ${IPPCP_LIB_PCS}_EXPORT
               EXPORT_FILE_NAME ${IPPCP_LIB_PCS}_Export.h
               STATIC_DEFINE ${TARGET_NAME}_dyn_BUILT_AS_STATIC
      )
      set_target_properties(${IPPCP_LIB_PCS} PROPERTIES LINK_FLAGS ${LINK_FLAG_DYNAMIC_WINDOWS})
      set_target_properties(${IPPCP_LIB_PCS} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    else()
      set(IPPCP_LIB_PCS ${IPPCP_LIB_PCS} PARENT_SCOPE)
      if(${ARCH} MATCHES "ia32")
        # NOTE: O3 is reduced to O1
        set_source_files_properties(pcpmain.c PROPERTIES COMPILE_FLAGS "${CC_FLAGS_INLINE_ASM_UNIX_IA32} -D_GNU_SOURCE -D_FORTIFY_SOURCE=2 -O1")
      else()
        set_source_files_properties(pcpmain.c PROPERTIES COMPILE_FLAGS "${CC_FLAGS_INLINE_ASM_UNIX_INTEL64} -D_GNU_SOURCE -D_FORTIFY_SOURCE=2 -O1")
      endif()
      add_library(${IPPCP_LIB_PCS} SHARED pcpmain.c cpinit.c  ${ASM_SOURCES_PCS})
      if(NOT APPLE)
        set_target_properties(${IPPCP_LIB_PCS} PROPERTIES LINK_FLAGS ${LINK_FLAG_PCS_LINUX})
      else()
        set(LINK_FLAG_PCS_MACOSX "${LINK_FLAG_PCS_MACOSX} -install_name @rpath/libippcp.dylib")
        set_target_properties(${IPPCP_LIB_PCS} PROPERTIES LINK_FLAGS ${LINK_FLAG_PCS_MACOSX})
      endif()
    endif(WIN32)
    set_target_properties(${IPPCP_LIB_PCS} PROPERTIES OUTPUT_NAME "${TARGET_NAME}")

    foreach(opt ${PLATFORM_LIST})
      add_dependencies(${IPPCP_LIB_PCS} ${TARGET_NAME}_dyn_${opt})
      target_link_libraries(${IPPCP_LIB_PCS} ${TARGET_NAME}_dyn_${opt})
    endforeach()
    set_target_properties(${IPPCP_LIB_PCS} PROPERTIES COMPILE_FLAGS "-D_PCS -D_IPP_DYNAMIC -D_IPP_DATA")
    if(WIN32)
      foreach(link ${LINK_LIB_STATIC_DEBUG})
        target_link_libraries(${IPPCP_LIB_PCS} debug ${link})
      endforeach()
      foreach(link ${LINK_LIB_STATIC_RELEASE})
        target_link_libraries(${IPPCP_LIB_PCS} optimized ${link})
      endforeach()
      if(THREADED_LIB)
        if (${CMAKE_C_COMPILER_ID} STREQUAL "Intel")
          target_link_libraries(${IPPCP_LIB_PCS} libiomp5md.lib)
        elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "MSVC")
          target_link_libraries(${IPPCP_LIB_PCS} vcomp.lib)
        endif()
      endif(THREADED_LIB)
    else()
      if(THREADED_LIB)
        set_target_properties(${IPPCP_LIB_PCS} PROPERTIES COMPILE_OPTIONS -qopenmp -qopenmp-lib compat)
        target_link_libraries(${IPPCP_LIB_PCS} iomp5)
      endif(THREADED_LIB)
    endif(WIN32)

  endif(DYNAMIC_LIB)

endif()
