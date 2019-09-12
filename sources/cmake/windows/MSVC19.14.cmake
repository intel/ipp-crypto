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
# Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography
#

# linker
set(LINK_FLAG_STATIC_WINDOWS " ")
# Suppresses the display of the copyright banner when the compiler starts up and display of informational messages during compiling.
set(LINK_FLAG_DYNAMIC_WINDOWS "/nologo")
# Displays information about modules that are incompatible with safe structured exception handling when /SAFESEH isn't specified.
set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /VERBOSE:SAFESEH")
# Disable incremental linking
set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /INCREMENTAL:NO")
# Indicates that an executable was tested to be compatible with the Windows Data Execution Prevention feature.
set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /NXCOMPAT")
# Specifies whether to generate an executable image that can be randomly rebased at load time.
set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /DYNAMICBASE")
if(${ARCH} MATCHES "ia32")
  # When /SAFESEH is specified, the linker will only produce an image if it can also produce a table of the image's safe exception handlers.
  set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /SAFESEH")
endif(${ARCH} MATCHES "ia32")

# Link to libc for debug purposes (printf, etc)
set(LINK_LIB_STATIC_RELEASE libcmt)
set(LINK_LIB_STATIC_DEBUG libcmtd)

# compiler
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LIBRARY_DEFINES}")

# Suppresses the display of the copyright banner when the compiler starts up and display of informational messages during compiling.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /nologo")
# Prevents the compiler from searching for include files in directories specified in the PATH and INCLUDE environment variables.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /X")
# Warning level = 4
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4")
# Detects some buffer overruns that overwrite a function's return address, exception handler address, or certain types of parameters. 
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /GS")
# Controls how the members of a structure are packed into memory and specifies the same packing for all structures in a module.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Zp16")
# Allows the compiler to package individual functions in the form of packaged functions. Smaller resulting size.
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Gy")

# Causes the application to use the multithread, static version of the run-time library (debug version).
set(CMAKE_C_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
# The /Zi option produces a separate PDB file that contains all the symbolic debugging information for use with the debugger.
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Zi" CACHE STRING "" FORCE)
# Turns off all optimizations in the program and speeds compilation.
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Od" CACHE STRING "" FORCE)
# Debug macro
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /DDEBUG" CACHE STRING "" FORCE)

# Causes the application to use the multithread, static version of the run-time library.
set(CMAKE_C_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
# Omits the default C runtime library name from the .obj file.
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zl" CACHE STRING "" FORCE)
# "Maximize Speed". Selects a predefined set of options that affect the size and speed of generated code.
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /O2" CACHE STRING "" FORCE) # /Ob2 is included in /O2
# No-debug macro
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /DNDEBUG" CACHE STRING "" FORCE)

set(w7_opt "${w7_opt} /arch:SSE2")
set(s8_opt "${s8_opt} /arch:SSE2")
set(p8_opt "${p8_opt} /arch:SSE2")
set(g9_opt "${g9_opt} /arch:AVX")
set(h9_opt "${h9_opt} /arch:AVX2")

set(m7_opt "${m7_opt}")
set(n8_opt "${n8_opt}")
set(y8_opt "${y8_opt}")
set(e9_opt "${e9_opt} /arch:AVX")
set(l9_opt "${l9_opt} /arch:AVX2")
set(n0_opt "${n0_opt} /arch:AVX2")
set(k0_opt "${k0_opt} /arch:AVX2")
