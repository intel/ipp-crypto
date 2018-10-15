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

# Linker flags

# Security Linker flags
set(LINK_FLAG_SECURITY "") 
# Disallows undefined symbols in object files. Undefined symbols in shared libraries are still allowed
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} -Wl,-z,defs")
# Stack execution protection
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} -Wl,-z,noexecstack")
# Data relocation and protection (RELRO)
set(LINK_FLAG_SECURITY "${LINK_FLAG_SECURITY} -Wl,-z,relro -Wl,-z,now")

set(LINK_FLAG_DYNAMIC_LINUX "${LINK_FLAG_SECURITY} -nostdlib -Wl,-shared -Wl,-call_shared,-lc -Wl,-call_shared,-lm")
if(${ARCH} MATCHES "ia32")
  set(LINK_FLAG_DYNAMIC_LINUX "${LINK_FLAG_DYNAMIC_LINUX} -Wl,-m,elf_i386")
endif(${ARCH} MATCHES "ia32")

set(LINK_FLAG_PCS_LINUX "${LINK_FLAG_SECURITY} -nostdlib -Wl,-shared -Wl,-call_shared,-ldl -Wl,-call_shared,-lc -Wl,-call_shared,-lm")
if(${ARCH} MATCHES "ia32")
  set(LINK_FLAG_PCS_LINUX "${LINK_FLAG_PCS_LINUX} -Wl,-m,elf_i386")
endif(${ARCH} MATCHES "ia32")

# Compiler flags
set(CC_FLAGS_INLINE_ASM_UNIX_IA32 "-fasm-blocks -use_msasm -w -m32 -fomit-frame-pointer")

set(CC_FLAGS_INLINE_ASM_UNIX_INTEL64 "-fasm-blocks -use_msasm -ffixed-rdi -ffixed-rsi -ffixed-rbx -ffixed-rcx -ffixed-rdx -ffixed-rbp -ffixed-r8 -ffixed-r9 -ffixed-r12 -ffixed-r13 -ffixed-r14 -ffixed-r15")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LIBRARY_DEFINES}")

# Ensures that compilation takes place in a freestanding environment
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding")
# Determines whether pointer disambiguation is enabled with the restrict qualifier
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -restrict")
# Tells the compiler to generate an optimization report
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qopt-report2 -qopt-report-phase:vec")
# Tells the compiler to align functions and loops
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -falign-functions=32 -falign-loops=32")
# Other flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -diag-error 266 -diag-disable 13366")

# Security Compiler flags

# Stack-based Buffer Overrun Detection
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-protector")

# Format string vulnerabilities
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wformat -Wformat-security")

if(NOT NONPIC_LIB)
  # Position Independent Execution (PIE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpic -fPIC")
endif()
if(THREADED_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qopenmp -qopenmp-lib compat")
endif()
if(CODE_COVERAGE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -prof-gen:srcpos -prof-dir ${PROF_DATA_DIR}")
endif()

set (CMAKE_C_FLAGS_RELEASE " -O3 -DNDEBUG -w3" CACHE STRING "" FORCE)
set (CMAKE_C_FLAGS_RELEASE_INIT " -O3 -DNDEBUG -w3" CACHE STRING "" FORCE)

if(${ARCH} MATCHES "ia32")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -no-sox  -Zp16 -gcc -falign-stack=maintain-16-byte -Wa,--32 -no-use-asm -m32")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -no-sox  -Zp16 -gcc")
endif(${ARCH} MATCHES "ia32")

set(px_opt "${px_opt} -mia32")
set(w7_opt "${w7_opt} -xSSE2")
set(s8_opt "${s8_opt} -xATOM_SSSE3 -minstruction=nomovbe")
set(p8_opt "${p8_opt} -xATOM_SSE4.2 -minstruction=nomovbe")
set(g9_opt "${g9_opt} -xAVX")
set(h9_opt "${h9_opt} -xCORE-AVX2")
set(mx_opt "${mx_opt} -march=pentium")
set(m7_opt "${m7_opt} -xSSE3")
set(n8_opt "${n8_opt} -xATOM_SSSE3 -minstruction=nomovbe")
set(y8_opt "${y8_opt} -xATOM_SSE4.2 -minstruction=nomovbe")
set(e9_opt "${e9_opt} -xAVX")
set(l9_opt "${l9_opt} -xCORE-AVX2")
set(n0_opt "${n0_opt} -xMIC-AVX512")
set(k0_opt "${k0_opt} -xCORE-AVX512")
set(k0_opt "${k0_opt} -qopt-zmm-usage:high")
