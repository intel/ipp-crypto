###############################################################################
# Copyright 2018 Intel Corporation
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

 
 .section .note.GNU-stack,"",%progbits 
 
.text
.p2align 6, 0x90
 
PSHUFFLE_BYTE_FLIP_MASK:
.byte  3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12 
.p2align 6, 0x90
 
.globl UpdateSHA256ni
.type UpdateSHA256ni, @function
 
UpdateSHA256ni:
 
    sub          $(40), %rsp
 
    movslq       %edx, %rdx
    test         %rdx, %rdx
    jz           .Lquitgas_1
    movdqu       (%rdi), %xmm1
    movdqu       (16)(%rdi), %xmm2
    pshufd       $(177), %xmm1, %xmm1
    pshufd       $(27), %xmm2, %xmm2
    movdqa       %xmm1, %xmm7
    palignr      $(8), %xmm2, %xmm1
    pblendw      $(240), %xmm7, %xmm2
    movdqa       PSHUFFLE_BYTE_FLIP_MASK(%rip), %xmm8
.Lsha256_block_loopgas_1: 
    movdqa       %xmm1, %xmm9
    movdqa       %xmm2, %xmm10
    movdqu       (%rsi), %xmm0
    pshufb       %xmm8, %xmm0
    movdqa       %xmm0, %xmm3
    paddd        (%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    movdqu       (16)(%rsi), %xmm0
    pshufb       %xmm8, %xmm0
    movdqa       %xmm0, %xmm4
    paddd        (16)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm4, %xmm3
    movdqu       (32)(%rsi), %xmm0
    pshufb       %xmm8, %xmm0
    movdqa       %xmm0, %xmm5
    paddd        (32)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm5, %xmm4
    movdqu       (48)(%rsi), %xmm0
    pshufb       %xmm8, %xmm0
    movdqa       %xmm0, %xmm6
    paddd        (48)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm6, %xmm7
    palignr      $(4), %xmm5, %xmm7
    paddd        %xmm7, %xmm3
    sha256msg2   %xmm6, %xmm3
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm6, %xmm5
    movdqa       %xmm3, %xmm0
    paddd        (64)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm3, %xmm7
    palignr      $(4), %xmm6, %xmm7
    paddd        %xmm7, %xmm4
    sha256msg2   %xmm3, %xmm4
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm3, %xmm6
    movdqa       %xmm4, %xmm0
    paddd        (80)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm4, %xmm7
    palignr      $(4), %xmm3, %xmm7
    paddd        %xmm7, %xmm5
    sha256msg2   %xmm4, %xmm5
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm4, %xmm3
    movdqa       %xmm5, %xmm0
    paddd        (96)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm5, %xmm7
    palignr      $(4), %xmm4, %xmm7
    paddd        %xmm7, %xmm6
    sha256msg2   %xmm5, %xmm6
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm5, %xmm4
    movdqa       %xmm6, %xmm0
    paddd        (112)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm6, %xmm7
    palignr      $(4), %xmm5, %xmm7
    paddd        %xmm7, %xmm3
    sha256msg2   %xmm6, %xmm3
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm6, %xmm5
    movdqa       %xmm3, %xmm0
    paddd        (128)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm3, %xmm7
    palignr      $(4), %xmm6, %xmm7
    paddd        %xmm7, %xmm4
    sha256msg2   %xmm3, %xmm4
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm3, %xmm6
    movdqa       %xmm4, %xmm0
    paddd        (144)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm4, %xmm7
    palignr      $(4), %xmm3, %xmm7
    paddd        %xmm7, %xmm5
    sha256msg2   %xmm4, %xmm5
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm4, %xmm3
    movdqa       %xmm5, %xmm0
    paddd        (160)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm5, %xmm7
    palignr      $(4), %xmm4, %xmm7
    paddd        %xmm7, %xmm6
    sha256msg2   %xmm5, %xmm6
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm5, %xmm4
    movdqa       %xmm6, %xmm0
    paddd        (176)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm6, %xmm7
    palignr      $(4), %xmm5, %xmm7
    paddd        %xmm7, %xmm3
    sha256msg2   %xmm6, %xmm3
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm6, %xmm5
    movdqa       %xmm3, %xmm0
    paddd        (192)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm3, %xmm7
    palignr      $(4), %xmm6, %xmm7
    paddd        %xmm7, %xmm4
    sha256msg2   %xmm3, %xmm4
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    sha256msg1   %xmm3, %xmm6
    movdqa       %xmm4, %xmm0
    paddd        (208)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm4, %xmm7
    palignr      $(4), %xmm3, %xmm7
    paddd        %xmm7, %xmm5
    sha256msg2   %xmm4, %xmm5
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    movdqa       %xmm5, %xmm0
    paddd        (224)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    movdqa       %xmm5, %xmm7
    palignr      $(4), %xmm4, %xmm7
    paddd        %xmm7, %xmm6
    sha256msg2   %xmm5, %xmm6
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    movdqa       %xmm6, %xmm0
    paddd        (240)(%rcx), %xmm0
    sha256rnds2  %xmm1, %xmm2
    pshufd       $(14), %xmm0, %xmm0
    sha256rnds2  %xmm2, %xmm1
    paddd        %xmm9, %xmm1
    paddd        %xmm10, %xmm2
    add          $(64), %rsi
    sub          $(64), %rdx
    jg           .Lsha256_block_loopgas_1
    pshufd       $(27), %xmm1, %xmm1
    pshufd       $(177), %xmm2, %xmm2
    movdqa       %xmm1, %xmm7
    pblendw      $(240), %xmm2, %xmm1
    palignr      $(8), %xmm7, %xmm2
    movdqu       %xmm1, (%rdi)
    movdqu       %xmm2, (16)(%rdi)
.Lquitgas_1: 
    add          $(40), %rsp
 
    ret
.Lfe1:
.size UpdateSHA256ni, .Lfe1-(UpdateSHA256ni)
 
