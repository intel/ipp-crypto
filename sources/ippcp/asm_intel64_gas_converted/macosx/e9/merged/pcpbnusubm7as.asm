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
.p2align 5, 0x90
 
.globl _e9_cpSub_BNU

 
_e9_cpSub_BNU:
 
    movslq       %ecx, %rcx
    xor          %rax, %rax
    cmp          $(2), %rcx
    jge          .LSUB_GE2gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         %r8, (%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GE2gas_1: 
    jg           .LSUB_GT2gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GT2gas_1: 
    cmp          $(4), %rcx
    jge          .LSUB_GE4gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GE4gas_1: 
    jg           .LSUB_GT4gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         (24)(%rsi), %r11
    sbbq         (24)(%rdx), %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GT4gas_1: 
    cmp          $(6), %rcx
    jge          .LSUB_GE6gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         (24)(%rsi), %r11
    sbbq         (24)(%rdx), %r11
    movq         (32)(%rsi), %rcx
    sbbq         (32)(%rdx), %rcx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %rcx, (32)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GE6gas_1: 
    jg           .LSUB_GT6gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         (24)(%rsi), %r11
    sbbq         (24)(%rdx), %r11
    movq         (32)(%rsi), %rcx
    sbbq         (32)(%rdx), %rcx
    movq         (40)(%rsi), %rsi
    sbbq         (40)(%rdx), %rsi
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %rcx, (32)(%rdi)
    movq         %rsi, (40)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GT6gas_1: 
    cmp          $(8), %rcx
    jge          .LSUB_GE8gas_1
.LSUB_EQ7gas_1: 
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         (24)(%rsi), %r11
    sbbq         (24)(%rdx), %r11
    movq         (32)(%rsi), %rcx
    sbbq         (32)(%rdx), %rcx
    movq         %r8, (%rdi)
    movq         (40)(%rsi), %r8
    sbbq         (40)(%rdx), %r8
    movq         (48)(%rsi), %rsi
    sbbq         (48)(%rdx), %rsi
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %rcx, (32)(%rdi)
    movq         %r8, (40)(%rdi)
    movq         %rsi, (48)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GE8gas_1: 
    jg           .LSUB_GT8gas_1
    add          %rax, %rax
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         (8)(%rsi), %r9
    sbbq         (8)(%rdx), %r9
    movq         (16)(%rsi), %r10
    sbbq         (16)(%rdx), %r10
    movq         (24)(%rsi), %r11
    sbbq         (24)(%rdx), %r11
    movq         (32)(%rsi), %rcx
    sbbq         (32)(%rdx), %rcx
    movq         %r8, (%rdi)
    movq         (40)(%rsi), %r8
    sbbq         (40)(%rdx), %r8
    movq         %r9, (8)(%rdi)
    movq         (48)(%rsi), %r9
    sbbq         (48)(%rdx), %r9
    movq         (56)(%rsi), %rsi
    sbbq         (56)(%rdx), %rsi
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %rcx, (32)(%rdi)
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %rsi, (56)(%rdi)
    sbb          %rax, %rax
    jmp          .LFINALgas_1
.LSUB_GT8gas_1: 
    mov          %rax, %r8
    mov          %rcx, %rax
    and          $(3), %rcx
    xor          %rax, %rcx
    lea          (%rsi,%rcx,8), %rsi
    lea          (%rdx,%rcx,8), %rdx
    lea          (%rdi,%rcx,8), %rdi
    neg          %rcx
    add          %r8, %r8
    jmp          .LSUB_GLOOPgas_1
.p2align 5, 0x90
.LSUB_GLOOPgas_1: 
    movq         (%rsi,%rcx,8), %r8
    movq         (8)(%rsi,%rcx,8), %r9
    movq         (16)(%rsi,%rcx,8), %r10
    movq         (24)(%rsi,%rcx,8), %r11
    sbbq         (%rdx,%rcx,8), %r8
    sbbq         (8)(%rdx,%rcx,8), %r9
    sbbq         (16)(%rdx,%rcx,8), %r10
    sbbq         (24)(%rdx,%rcx,8), %r11
    movq         %r8, (%rdi,%rcx,8)
    movq         %r9, (8)(%rdi,%rcx,8)
    movq         %r10, (16)(%rdi,%rcx,8)
    movq         %r11, (24)(%rdi,%rcx,8)
    lea          (4)(%rcx), %rcx
    jrcxz        .LSUB_LLAST0gas_1
    jmp          .LSUB_GLOOPgas_1
.LSUB_LLAST0gas_1: 
    sbb          %rcx, %rcx
    and          $(3), %rax
    jz           .LFIN0gas_1
.LSUB_LLOOPgas_1: 
    test         $(2), %rax
    jz           .LSUB_LLAST1gas_1
    add          %rcx, %rcx
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    sbbq         (%rdx), %r8
    sbbq         (8)(%rdx), %r9
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    sbb          %rcx, %rcx
    test         $(1), %rax
    jz           .LFIN0gas_1
    add          $(16), %rsi
    add          $(16), %rdx
    add          $(16), %rdi
.LSUB_LLAST1gas_1: 
    add          %rcx, %rcx
    movq         (%rsi), %r8
    sbbq         (%rdx), %r8
    movq         %r8, (%rdi)
    sbb          %rcx, %rcx
.LFIN0gas_1: 
    mov          %rcx, %rax
.LFINALgas_1: 
    neg          %rax
vzeroupper 
 
    ret
 
