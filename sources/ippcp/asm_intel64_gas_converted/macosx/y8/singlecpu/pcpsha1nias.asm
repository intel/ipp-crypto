###############################################################################
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
###############################################################################

 
.text
.p2align 4, 0x90
 
UPPER_DWORD_MASK:
.quad                  0x0,  0xffffffff00000000 
 
PSHUFFLE_BYTE_FLIP_MASK:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
.p2align 4, 0x90
 
.globl _UpdateSHA1ni

 
_UpdateSHA1ni:
 
    sub          $(40), %rsp
 
    movslq       %edx, %rdx
    test         %rdx, %rdx
    jz           .Lquitgas_1
    movdqu       (%rdi), %xmm0
    pinsrd       $(3), (16)(%rdi), %xmm1
    pand         UPPER_DWORD_MASK(%rip), %xmm1
    pshufd       $(27), %xmm0, %xmm0
    movdqa       PSHUFFLE_BYTE_FLIP_MASK(%rip), %xmm7
.Lsha1_block_loopgas_1: 
    movdqa       %xmm0, (%rsp)
    movdqa       %xmm1, (16)(%rsp)
    movdqu       (%rsi), %xmm3
    pshufb       %xmm7, %xmm3
    paddd        %xmm3, %xmm1
    movdqa       %xmm0, %xmm2
    sha1rnds4    $(0), %xmm1, %xmm0
    movdqu       (16)(%rsi), %xmm4
    pshufb       %xmm7, %xmm4
    sha1nexte    %xmm4, %xmm2
    movdqa       %xmm0, %xmm1
    sha1rnds4    $(0), %xmm2, %xmm0
    sha1msg1     %xmm4, %xmm3
    movdqu       (32)(%rsi), %xmm5
    pshufb       %xmm7, %xmm5
    sha1nexte    %xmm5, %xmm1
    movdqa       %xmm0, %xmm2
    sha1rnds4    $(0), %xmm1, %xmm0
    sha1msg1     %xmm5, %xmm4
    pxor         %xmm5, %xmm3
    movdqu       (48)(%rsi), %xmm6
    pshufb       %xmm7, %xmm6
    sha1nexte    %xmm6, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm6, %xmm3
    sha1rnds4    $(0), %xmm2, %xmm0
    sha1msg1     %xmm6, %xmm5
    pxor         %xmm6, %xmm4
    sha1nexte    %xmm3, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm3, %xmm4
    sha1rnds4    $(0), %xmm1, %xmm0
    sha1msg1     %xmm3, %xmm6
    pxor         %xmm3, %xmm5
    sha1nexte    %xmm4, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm4, %xmm5
    sha1rnds4    $(1), %xmm2, %xmm0
    sha1msg1     %xmm4, %xmm3
    pxor         %xmm4, %xmm6
    sha1nexte    %xmm5, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm5, %xmm6
    sha1rnds4    $(1), %xmm1, %xmm0
    sha1msg1     %xmm5, %xmm4
    pxor         %xmm5, %xmm3
    sha1nexte    %xmm6, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm6, %xmm3
    sha1rnds4    $(1), %xmm2, %xmm0
    sha1msg1     %xmm6, %xmm5
    pxor         %xmm6, %xmm4
    sha1nexte    %xmm3, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm3, %xmm4
    sha1rnds4    $(1), %xmm1, %xmm0
    sha1msg1     %xmm3, %xmm6
    pxor         %xmm3, %xmm5
    sha1nexte    %xmm4, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm4, %xmm5
    sha1rnds4    $(1), %xmm2, %xmm0
    sha1msg1     %xmm4, %xmm3
    pxor         %xmm4, %xmm6
    sha1nexte    %xmm5, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm5, %xmm6
    sha1rnds4    $(2), %xmm1, %xmm0
    sha1msg1     %xmm5, %xmm4
    pxor         %xmm5, %xmm3
    sha1nexte    %xmm6, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm6, %xmm3
    sha1rnds4    $(2), %xmm2, %xmm0
    sha1msg1     %xmm6, %xmm5
    pxor         %xmm6, %xmm4
    sha1nexte    %xmm3, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm3, %xmm4
    sha1rnds4    $(2), %xmm1, %xmm0
    sha1msg1     %xmm3, %xmm6
    pxor         %xmm3, %xmm5
    sha1nexte    %xmm4, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm4, %xmm5
    sha1rnds4    $(2), %xmm2, %xmm0
    sha1msg1     %xmm4, %xmm3
    pxor         %xmm4, %xmm6
    sha1nexte    %xmm5, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm5, %xmm6
    sha1rnds4    $(2), %xmm1, %xmm0
    sha1msg1     %xmm5, %xmm4
    pxor         %xmm5, %xmm3
    sha1nexte    %xmm6, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm6, %xmm3
    sha1rnds4    $(3), %xmm2, %xmm0
    sha1msg1     %xmm6, %xmm5
    pxor         %xmm6, %xmm4
    sha1nexte    %xmm3, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm3, %xmm4
    sha1rnds4    $(3), %xmm1, %xmm0
    sha1msg1     %xmm3, %xmm6
    pxor         %xmm3, %xmm5
    sha1nexte    %xmm4, %xmm2
    movdqa       %xmm0, %xmm1
    sha1msg2     %xmm4, %xmm5
    sha1rnds4    $(3), %xmm2, %xmm0
    pxor         %xmm4, %xmm6
    sha1nexte    %xmm5, %xmm1
    movdqa       %xmm0, %xmm2
    sha1msg2     %xmm5, %xmm6
    sha1rnds4    $(3), %xmm1, %xmm0
    sha1nexte    %xmm6, %xmm2
    movdqa       %xmm0, %xmm1
    sha1rnds4    $(3), %xmm2, %xmm0
    sha1nexte    (16)(%rsp), %xmm1
    paddd        (%rsp), %xmm0
    add          $(64), %rsi
    sub          $(64), %rdx
    jg           .Lsha1_block_loopgas_1
    pshufd       $(27), %xmm0, %xmm0
    movdqu       %xmm0, (%rdi)
    pextrd       $(3), %xmm1, (16)(%rdi)
.Lquitgas_1: 
    add          $(40), %rsp
 
    ret
 
