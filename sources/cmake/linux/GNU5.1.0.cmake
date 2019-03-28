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
set(LINK_FLAG_DYNAMIC_LINUX "-nostdlib -Wl,-shared -Wl,-z,defs -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now")
if(${ARCH} MATCHES "ia32")
  set(LINK_FLAG_DYNAMIC_LINUX "${LINK_FLAG_DYNAMIC_LINUX} -m32")
endif(${ARCH} MATCHES "ia32")

set(LINK_FLAG_PCS_LINUX "-nostdlib -Wl,-call_shared,-ldl")
if(${ARCH} MATCHES "ia32")
  set(LINK_FLAG_PCS_LINUX "${LINK_FLAG_PCS_LINUX} -m32")
endif(${ARCH} MATCHES "ia32")

# compiler
set(CC_FLAGS_INLINE_ASM_UNIX_IA32 "-use_msasm -w -m32 -fomit-frame-pointer")

set(CC_FLAGS_INLINE_ASM_UNIX_INTEL64 "-use_msasm -ffixed-rdi -ffixed-rsi -ffixed-rbx -ffixed-rcx -ffixed-rdx -ffixed-rbp -ffixed-r8 -ffixed-r9 -ffixed-r12 -ffixed-r13 -ffixed-r14 -ffixed-r15")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS} ${LIBRARY_DEFINES}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -ffreestanding -flto-report -std=c99 -falign-functions=32 -falign-loops=32 -Wformat -Wformat-security -fstack-protector")
if(NOT NONPIC_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpic -fPIC")
endif()
if(THREADED_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fopenmp")
endif()

if(${ARCH} MATCHES "ia32")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpack-struct=16 -mpreferred-stack-boundary=4 -Wa,--32 -m32")
else()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fpack-struct=16")
endif(${ARCH} MATCHES "ia32")

set (CMAKE_C_FLAGS_RELEASE " -O3 -DNDEBUG" CACHE STRING "" FORCE)
set (CMAKE_C_FLAGS_RELEASE_INIT " -O3 -DNDEBUG" CACHE STRING "" FORCE)

set(w7_opt "${w7_opt} -march=pentium4 -msse2")
set(s8_opt "${s8_opt} -march=core2 -mssse3")
set(p8_opt "${p8_opt} -march=nehalem -msse4.2 -maes -mpclmul -msha")
set(g9_opt "${g9_opt} -march=sandybridge -mavx -maes -mpclmul -msha -mrdrnd -mrdseed")
set(h9_opt "${h9_opt} -march=haswell -mavx2 -maes -mpclmul -msha -mrdrnd -mrdseed")

set(m7_opt "${m7_opt} -march=nocona -msse3")
set(n8_opt "${n8_opt} -march=core2 -mssse3")
set(y8_opt "${y8_opt} -march=nehalem -msse4.2 -maes -mpclmul -msha")
set(e9_opt "${e9_opt} -march=sandybridge -mavx -maes -mpclmul -msha -mrdrnd -mrdseed")
set(l9_opt "${l9_opt} -march=haswell -mavx2 -maes -mpclmul -msha -mrdrnd -mrdseed")
set(n0_opt "${n0_opt} -march=knl -mavx2 -maes -mavx512f -mavx512cd -mavx512pf -mavx512er -mpclmul -msha -mrdrnd -mrdseed")
if(CMAKE_C_COMPILER_VERSION VERSION_LESS 6.1.0)
  set(k0_opt "${k0_opt} -march=knl")
else()
  set(k0_opt "${k0_opt} -march=skylake-avx512")
endif()
set(k0_opt "${k0_opt} -mavx2 -maes -mavx512f -mavx512cd -mavx512vl -mavx512bw -mavx512dq -mavx512ifma -mpclmul -msha -mrdrnd -mrdseed -madx -mgfni -mvaes -mvpclmulqdq")
