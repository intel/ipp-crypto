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

# compiler
set(CC_FLAGS_INLINE_ASM_UNIX_IA32 "-fasm-blocks -use_msasm -w -m32 -fomit-frame-pointer")

set(CC_FLAGS_INLINE_ASM_UNIX_INTEL64 "-fasm-blocks -use_msasm -ffixed-rdi -ffixed-rsi -ffixed-rbx -ffixed-rcx -ffixed-rdx -ffixed-rbp -ffixed-r8 -ffixed-r9 -ffixed-r12 -ffixed-r13 -ffixed-r14 -ffixed-r15")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} ${LIBRARY_DEFINES}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding -restrict -qopt-report2 -qopt-report-phase:vec -std=c99 -falign-functions=32 -falign-loops=32 -diag-error 266 -diag-disable 13366 -Wformat -Wformat-security -fstack-protector")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -platform=android")
if(NOT NONPIC_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpic -fPIC")
endif()
if(THREADED_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qopenmp -qopenmp-lib compat")
endif()
if(CODE_COVERAGE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -prof-gen:srcpos -prof-dir ${PROF_DATA_DIR}")
endif()

if(${ARCH} MATCHES "ia32")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -no-sox  -Zp16 -gcc -falign-stack=maintain-16-byte -Wa,--32 -no-use-asm -m32")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -no-sox  -Zp16 -gcc")
endif(${ARCH} MATCHES "ia32")

set(w7_opt "${w7_opt} -xSSE2")
set(s8_opt "${s8_opt} -xATOM_SSSE3 -minstruction=nomovbe")
set(p8_opt "${p8_opt} -xATOM_SSE4.2 -minstruction=nomovbe")
set(g9_opt "${g9_opt} -xAVX")
set(h9_opt "${h9_opt} -xCORE-AVX2")
set(m7_opt "${m7_opt} -xSSE3")
set(n8_opt "${n8_opt} -xATOM_SSSE3 -minstruction=nomovbe")
set(y8_opt "${y8_opt} -xATOM_SSE4.2 -minstruction=nomovbe")
set(e9_opt "${e9_opt} -xAVX")
set(l9_opt "${l9_opt} -xCORE-AVX2")
set(n0_opt "${n0_opt} -xMIC-AVX512")
set(k0_opt "${k0_opt} -xCORE-AVX512")