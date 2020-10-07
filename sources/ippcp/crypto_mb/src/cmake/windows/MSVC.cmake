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

# Security Linker flags

set(LINK_FLAG_SECURITY "")

# Specifies whether to generate an executable image that can be randomly rebased at load time.
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} /DYNAMICBASE")
# This option modifies the header of an executable image, a .dll file or .exe file, to indicate whether ASLR with 64-bit addresses is supported.
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} /HIGHENTROPYVA")
# The /LARGEADDRESSAWARE option tells the linker that the application can handle addresses larger than 2 gigabytes.
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} /LARGEADDRESSAWARE")
# Enforce a signature check at load time on the binary file
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} /INTEGRITYCHECK")
# Indicates that an executable is compatible with the Windows Data Execution Prevention (DEP) feature
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} /NXCOMPAT")

# Security Compiler flags

set(CMAKE_C_FLAGS_SECURITY "")
# Detect some buffer overruns.
set(CMAKE_C_FLAGS_SECURITY "${CMAKE_C_FLAGS_SECURITY} /GS")
# Warning level = 3
set(CMAKE_C_FLAGS_SECURITY "${CMAKE_C_FLAGS_SECURITY} /W3")
# Changes all warnings to errors.
set(CMAKE_C_FLAGS_SECURITY "${CMAKE_C_FLAGS_SECURITY} /WX")

# Linker flags

# Add export files
set(LINK_FLAGS_DYNAMIC "/DEF:${CRYPTO_MB_SOURCES_DIR}/cmake/dll_export/crypto_mb.defs")
if(NOT OPENSSL_DISABLE)
    set(LINK_FLAGS_DYNAMIC "/DEF:${LINK_FLAGS_DYNAMIC} ${CRYPTO_MB_SOURCES_DIR}/cmake/dll_export/crypto_mb_ssl.defs")
endif()

# Compiler flags

# Causes the application to use the multithread, static version of the run-time library
set(CMAKE_C_FLAGS_RELEASE "/MT" CACHE STRING "" FORCE)
# Optimization level = 2
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /O2" CACHE STRING "" FORCE)
# No-debug macro
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /DNDEBUG" CACHE STRING "" FORCE)

# Causes the application to use the multithread, static version of the run-time library (debug version).
set(CMAKE_C_FLAGS_DEBUG "/MTd" CACHE STRING "" FORCE)
# The /Zi option produces a separate PDB file that contains all the symbolic debugging information for use with the debugger.
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Zi" CACHE STRING "" FORCE)
# Turns off all optimizations.
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Od" CACHE STRING "" FORCE)
# Debug macro
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /D_DEBUG" CACHE STRING "" FORCE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}")

# Optimisation dependent flags
set(AVX512_CFLAGS "${AVX512_CFLAGS} /arch:AVX512")
