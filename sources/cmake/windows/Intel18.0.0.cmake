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

# linker
set(LINK_FLAG_DYNAMIC_WINDOWS "/nologo /VERBOSE:SAFESEH /INCREMENTAL:NO /NXCOMPAT /DYNAMICBASE")
if(${ARCH} MATCHES "ia32")
  set(LINK_FLAG_DYNAMIC_WINDOWS "${LINK_FLAG_DYNAMIC_WINDOWS} /SAFESEH")
endif(${ARCH} MATCHES "ia32")

set(LINK_LIB_STATIC_RELEASE_VS2015 libcmt kernel32 user32 gdi32 uuid advapi32 vfw32 shell32) # check
set(LINK_LIB_STATIC_DEBUG_VS2015 libcmtd kernel32 user32 gdi32 uuid advapi32 vfw32 shell32)

set(LINK_LIB_STATIC_RELEASE  ${LINK_LIB_STATIC_RELEASE_VS2015})
set(LINK_LIB_STATIC_DEBUG  ${LINK_LIB_STATIC_DEBUG_VS2015})

# compiler
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${LIBRARY_DEFINES}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -nologo -Qfp-speculation:safe -Qfreestanding -X -W4 -GS -Qdiag-error:266 -Qdiag-disable:13366 /Qfnalign:32 /Qalign-loops:32 -Qrestrict -Zp16 -Qvc12 -Qopt-report2 -Qopt-report-phase:vec -Qopt-report-stdout -Qsox- /Gy -Qstd=c99")
if(THREADED_LIB)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Qopenmp -Qopenmp-lib:compat")
endif()
if(CODE_COVERAGE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Qrof-gen:srcpos /Qprof-dir:${PROF_DATA_DIR}")
endif()

set(CMAKE_C_FLAGS_DEBUG "/MTd /Zi /Od /Ob2 /DDEBUG" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "/MT /Zl /O3 /Ob2 /DNDEBUG" CACHE STRING "" FORCE)