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

 
.text
.p2align 4, 0x90
 
.globl _n8_cpSqrAdc_BNU_school

 
_n8_cpSqrAdc_BNU_school:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(40), %rsp
 
    cmp          $(4), %edx
    jg           .Lmore_then_4gas_1
    cmp          $(3), %edx
    jg           .LSQR4gas_1
    je           .LSQR3gas_1
    jp           .LSQR2gas_1
.p2align 4, 0x90
.LSQR1gas_1: 
    movq         (%rsi), %rax
    mul          %rax
    movq         %rax, (%rdi)
    mov          %rdx, %rax
    movq         %rdx, (8)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR2gas_1: 
    movq         (%rsi), %rax
    mulq         (8)(%rsi)
    xor          %rcx, %rcx
    mov          %rax, %r10
    mov          %rdx, %r11
    movq         (%rsi), %rax
    mul          %rax
    add          %r10, %r10
    adc          %r11, %r11
    adc          $(0), %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    movq         (8)(%rsi), %rax
    mul          %rax
    movq         %r8, (%rdi)
    add          %r10, %r9
    movq         %r9, (8)(%rdi)
    adc          %r11, %rax
    movq         %rax, (16)(%rdi)
    adc          %rcx, %rdx
    movq         %rdx, (24)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR3gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (8)(%rsi), %rax
    mulq         (16)(%rsi)
    xor          %r11, %r11
    add          %rax, %r10
    adc          %rdx, %r11
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %rcx, %rcx
    movq         (%rsi), %rax
    mul          %rax
    mov          %rax, %r12
    mov          %rdx, %r13
    movq         (8)(%rsi), %rax
    mul          %rax
    mov          %rax, %r14
    mov          %rdx, %r15
    movq         (16)(%rsi), %rax
    mul          %rax
    movq         %r12, (%rdi)
    add          %r8, %r13
    movq         %r13, (8)(%rdi)
    adc          %r9, %r14
    movq         %r14, (16)(%rdi)
    adc          %r10, %r15
    movq         %r15, (24)(%rdi)
    adc          %r11, %rax
    movq         %rax, (32)(%rdi)
    adc          %rcx, %rdx
    movq         %rdx, (40)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR4gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          (24)(%rsi), %r11
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rax
    mul          %rcx
    xor          %r12, %r12
    add          %rax, %r10
    movq         (24)(%rsi), %rax
    adc          %rdx, %r11
    adc          $(0), %r12
    mul          %rcx
    movq         (16)(%rsi), %rcx
    add          %rax, %r11
    movq         (24)(%rsi), %rax
    adc          %rdx, %r12
    mul          %rcx
    xor          %r13, %r13
    add          %rax, %r12
    adc          %rdx, %r13
    mov          (%rsi), %rax
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          $(0), %rcx
    mul          %rax
    mov          %rax, (%rdi)
    mov          (8)(%rsi), %rax
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r8
    adc          %rax, %r9
    mov          (16)(%rsi), %rax
    mov          %r8, (8)(%rdi)
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r10
    adc          %rax, %r11
    mov          (24)(%rsi), %rax
    mov          %r10, (24)(%rdi)
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r12
    adc          %rax, %r13
    mov          %r12, (40)(%rdi)
    adc          $(0), %rdx
    mov          %r13, (48)(%rdi)
    add          %rcx, %rdx
    mov          %rdx, (56)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.Lmore_then_4gas_1: 
    cmp          $(8), %edx
    jg           .Lgeneral_casegas_1
    cmp          $(7), %edx
    jg           .LSQR8gas_1
    je           .LSQR7gas_1
    jp           .LSQR6gas_1
.p2align 4, 0x90
.LSQR5gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          (24)(%rsi), %r11
    mov          (32)(%rsi), %r12
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          %rbp, %r13
    movq         (16)(%rsi), %rcx
    movq         (24)(%rsi), %rax
    mul          %rcx
    xor          %r14, %r14
    add          %rax, %r12
    movq         (32)(%rsi), %rax
    adc          %rdx, %r13
    adc          $(0), %r14
    mul          %rcx
    movq         (24)(%rsi), %rcx
    add          %rax, %r13
    movq         (32)(%rsi), %rax
    adc          %rdx, %r14
    mul          %rcx
    xor          %r15, %r15
    add          %rax, %r14
    adc          %rdx, %r15
    mov          (%rsi), %rax
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          %r15, %r15
    adc          $(0), %rcx
    mul          %rax
    mov          %rax, (%rdi)
    mov          (8)(%rsi), %rax
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r8
    adc          %rax, %r9
    mov          (16)(%rsi), %rax
    mov          %r8, (8)(%rdi)
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r10
    adc          %rax, %r11
    mov          (24)(%rsi), %rax
    mov          %r10, (24)(%rdi)
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r12
    adc          %rax, %r13
    mov          (32)(%rsi), %rax
    mov          %r12, (40)(%rdi)
    adc          $(0), %rdx
    mov          %r13, (48)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r14
    adc          %rax, %r15
    mov          %r14, (56)(%rdi)
    adc          $(0), %rdx
    mov          %r15, (64)(%rdi)
    add          %rcx, %rdx
    mov          %rdx, (72)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR6gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          (24)(%rsi), %r11
    mov          (32)(%rsi), %r12
    mov          (40)(%rsi), %r13
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          %rbp, %r14
    movq         (16)(%rsi), %rcx
    movq         (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          %rbp, %r15
    movq         (24)(%rsi), %rcx
    movq         (32)(%rsi), %rax
    mul          %rcx
    xor          %rbx, %rbx
    add          %rax, %r14
    movq         (40)(%rsi), %rax
    adc          %rdx, %r15
    adc          $(0), %rbx
    mul          %rcx
    movq         (32)(%rsi), %rcx
    add          %rax, %r15
    movq         (40)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rcx
    xor          %rbp, %rbp
    add          %rax, %rbx
    adc          %rdx, %rbp
    mov          (%rsi), %rax
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          %r15, %r15
    adc          %rbx, %rbx
    adc          %rbp, %rbp
    adc          $(0), %rcx
    movq         %rcx, (%rsp)
    mul          %rax
    mov          %rax, (%rdi)
    mov          (8)(%rsi), %rax
    mov          %rdx, %rcx
    mul          %rax
    add          %rcx, %r8
    adc          %rax, %r9
    mov          (16)(%rsi), %rax
    mov          %r8, (8)(%rdi)
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rcx
    mul          %rax
    add          %rcx, %r10
    adc          %rax, %r11
    mov          (24)(%rsi), %rax
    mov          %r10, (24)(%rdi)
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rcx
    mul          %rax
    add          %rcx, %r12
    adc          %rax, %r13
    mov          (32)(%rsi), %rax
    mov          %r12, (40)(%rdi)
    adc          $(0), %rdx
    mov          %r13, (48)(%rdi)
    mov          %rdx, %rcx
    mul          %rax
    add          %rcx, %r14
    adc          %rax, %r15
    mov          (40)(%rsi), %rax
    mov          %r14, (56)(%rdi)
    adc          $(0), %rdx
    mov          %r15, (64)(%rdi)
    mov          %rdx, %rcx
    mul          %rax
    add          %rcx, %rbx
    adc          %rax, %rbp
    mov          %rbx, (72)(%rdi)
    adcq         (%rsp), %rdx
    mov          %rbp, (80)(%rdi)
    mov          %rdx, (88)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR7gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          (24)(%rsi), %r11
    mov          (32)(%rsi), %r12
    mov          (40)(%rsi), %r13
    mov          (48)(%rsi), %r14
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          %r14, %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          (8)(%rsi), %rcx
    mov          (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rsi), %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          %rbp, %r15
    mov          (16)(%rsi), %rcx
    xor          %rbx, %rbx
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (24)(%rsi), %rax
    mulq         (32)(%rsi)
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rdx, %r15
    adc          $(0), %rbx
    mov          (%rsi), %rax
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          $(0), %rcx
    mul          %rax
    mov          %rax, (%rdi)
    mov          (8)(%rsi), %rax
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r8
    adc          %rax, %r9
    mov          (16)(%rsi), %rax
    mov          %r8, (8)(%rdi)
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r10
    adc          %rax, %r11
    mov          (24)(%rsi), %rax
    mov          %r10, (24)(%rdi)
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mul          %rax
    add          %rbp, %r12
    adc          %rax, %r13
    mov          %r12, (40)(%rdi)
    adc          %rdx, %r14
    mov          %r13, (48)(%rdi)
    adc          $(0), %rcx
    mov          %r14, (56)(%rdi)
    mov          (16)(%rsi), %rax
    xor          %r8, %r8
    mulq         (48)(%rsi)
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    mov          (24)(%rsi), %r14
    mov          (40)(%rsi), %rax
    mul          %r14
    add          %rax, %r15
    mov          (48)(%rsi), %rax
    adc          %rdx, %rbx
    adc          $(0), %r8
    mul          %r14
    add          %rax, %rbx
    adc          %rdx, %r8
    mov          (32)(%rsi), %r14
    xor          %r9, %r9
    mov          (40)(%rsi), %rax
    mul          %r14
    add          %rax, %rbx
    mov          (48)(%rsi), %rax
    adc          %rdx, %r8
    adc          $(0), %r9
    mul          %r14
    add          %rax, %r8
    adc          %rdx, %r9
    mov          (40)(%rsi), %r14
    xor          %r10, %r10
    mov          (48)(%rsi), %rax
    mul          %r14
    add          %rax, %r9
    adc          %rdx, %r10
    mov          (32)(%rsi), %rax
    xor          %r11, %r11
    add          %r15, %r15
    adc          %rbx, %rbx
    adc          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          $(0), %r11
    mul          %rax
    add          %rcx, %r15
    adc          $(0), %rdx
    xor          %rcx, %rcx
    add          %rax, %r15
    mov          (40)(%rsi), %rax
    adc          %rdx, %rbx
    mov          %r15, (64)(%rdi)
    adc          $(0), %rcx
    mov          %rbx, (72)(%rdi)
    mul          %rax
    add          %rcx, %r8
    adc          $(0), %rdx
    xor          %rcx, %rcx
    add          %rax, %r8
    mov          (48)(%rsi), %rax
    adc          %rdx, %r9
    mov          %r8, (80)(%rdi)
    adc          $(0), %rcx
    mov          %r9, (88)(%rdi)
    mul          %rax
    add          %rcx, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          %r11, %rdx
    mov          %r10, (96)(%rdi)
    mov          %rdx, (104)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.LSQR8gas_1: 
    mov          (%rsi), %r8
    mov          (8)(%rsi), %r9
    mov          (16)(%rsi), %r10
    mov          (24)(%rsi), %r11
    mov          (32)(%rsi), %r12
    mov          (40)(%rsi), %r13
    mov          (48)(%rsi), %r14
    mov          (56)(%rsi), %r15
    mov          %r8, %rcx
    mov          %r9, %rax
    mul          %rcx
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          %r14, %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          %r15, %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    mov          (8)(%rsi), %rcx
    xor          %rbx, %rbx
    mov          (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rsi), %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (16)(%rsi), %rcx
    mov          (24)(%rsi), %rax
    mul          %rcx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rsi), %rax
    mul          %rcx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rsi), %rax
    mul          %rcx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (24)(%rsi), %rax
    mulq         (32)(%rsi)
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rdx, %r15
    adc          $(0), %rbx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          $(0), %rcx
    mov          (%rsi), %rax
    mul          %rax
    mov          %rax, (%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rsi), %rax
    mul          %rax
    add          %rbp, %r8
    adc          %rax, %r9
    mov          %r8, (8)(%rdi)
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (16)(%rsi), %rax
    mul          %rax
    mov          %rax, %r8
    mov          %rdx, %r9
    mov          (24)(%rsi), %rax
    mul          %rax
    add          %rbp, %r10
    adc          %r8, %r11
    mov          %r10, (24)(%rdi)
    adc          %r9, %r12
    mov          %r11, (32)(%rdi)
    adc          %rax, %r13
    mov          %r12, (40)(%rdi)
    adc          %rdx, %r14
    mov          %r13, (48)(%rdi)
    adc          $(0), %rcx
    mov          %r14, (56)(%rdi)
    mov          (8)(%rsi), %rax
    xor          %r8, %r8
    mulq         (56)(%rsi)
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    mov          (16)(%rsi), %r14
    mov          (48)(%rsi), %rax
    mul          %r14
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    mov          (56)(%rsi), %rax
    xor          %r9, %r9
    mul          %r14
    add          %rax, %rbx
    adc          $(0), %rdx
    add          %rdx, %r8
    adc          $(0), %r9
    mov          (24)(%rsi), %r14
    mov          (40)(%rsi), %rax
    mul          %r14
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    adc          $(0), %r9
    mov          (48)(%rsi), %rax
    mul          %r14
    add          %rax, %rbx
    adc          $(0), %rdx
    add          %rdx, %r8
    adc          $(0), %r9
    mov          (56)(%rsi), %rax
    mul          %r14
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rdx, %r9
    mov          (32)(%rsi), %r14
    mov          (40)(%rsi), %rax
    mul          %r14
    add          %rax, %rbx
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (48)(%rsi), %rax
    mul          %r14
    add          %rax, %r8
    adc          $(0), %rdx
    add          %r10, %r8
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (56)(%rsi), %rax
    mul          %r14
    add          %rax, %r9
    adc          $(0), %rdx
    add          %r10, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (40)(%rsi), %r14
    mov          (48)(%rsi), %rax
    mul          %r14
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (56)(%rsi), %rax
    mul          %r14
    add          %rax, %r10
    adc          $(0), %rdx
    add          %r11, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (48)(%rsi), %rax
    mulq         (56)(%rsi)
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    xor          %r13, %r13
    add          %r15, %r15
    adc          %rbx, %rbx
    adc          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          $(0), %r13
    mov          (32)(%rsi), %rax
    mul          %rax
    add          %rcx, %rax
    adc          $(0), %rdx
    add          %r15, %rax
    adc          $(0), %rdx
    mov          %rax, (64)(%rdi)
    mov          %rdx, %rcx
    mov          (40)(%rsi), %rax
    mul          %rax
    add          %rcx, %rbx
    adc          %rax, %r8
    mov          %rbx, (72)(%rdi)
    adc          $(0), %rdx
    mov          %r8, (80)(%rdi)
    mov          %rdx, %rcx
    mov          (48)(%rsi), %rax
    mul          %rax
    mov          %rax, %r15
    mov          %rdx, %rbx
    mov          (56)(%rsi), %rax
    mul          %rax
    add          %rcx, %r9
    adc          %r15, %r10
    mov          %r9, (88)(%rdi)
    adc          %rbx, %r11
    mov          %r10, (96)(%rdi)
    adc          %rax, %r12
    mov          %r11, (104)(%rdi)
    adc          %rdx, %r13
    mov          %r12, (112)(%rdi)
    mov          %r13, (120)(%rdi)
    mov          %rdx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 4, 0x90
.Lgeneral_casegas_1: 
 
    movslq       %edx, %rdx
    mov          %rdi, (%rsp)
    mov          %rsi, (8)(%rsp)
    mov          %rdx, (16)(%rsp)
    mov          %rdx, %r8
    mov          $(2), %rax
    mov          $(1), %rbx
    test         $(1), %r8
    cmove        %rbx, %rax
    sub          %rax, %rdx
    lea          (%rsi,%rax,8), %rsi
    lea          (%rdi,%rax,8), %rdi
    lea          (-32)(%rsi,%rdx,8), %rsi
    lea          (-32)(%rdi,%rdx,8), %rdi
    mov          $(4), %rcx
    sub          %rdx, %rcx
    test         $(1), %r8
    jnz          .Linit_odd_len_operationgas_1
.Linit_even_len_operationgas_1: 
    movq         (-8)(%rsi,%rcx,8), %r10
    movq         (%rsi,%rcx,8), %rax
    xor          %r12, %r12
    cmp          $(0), %rcx
    jge          .Lskip_mul1gas_1
    mov          %rcx, %rbx
.p2align 4, 0x90
.L__0065gas_1: 
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r12
    movq         %r12, (%rdi,%rbx,8)
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r13
    movq         %r13, (8)(%rdi,%rbx,8)
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    xor          %r15, %r15
    add          %rax, %r14
    movq         %r14, (16)(%rdi,%rbx,8)
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r15
    movq         %r15, (24)(%rdi,%rbx,8)
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    add          $(4), %rbx
    jnc          .L__0065gas_1
.Lskip_mul1gas_1: 
    cmp          $(1), %rbx
    jne          .Lfin_mulx1_3gas_1
.Lfin_mulx1_1gas_1: 
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r12
    movq         %r12, (8)(%rdi)
    movq         (16)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r13
    movq         %r13, (16)(%rdi)
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    add          $(2), %rcx
    add          %rax, %r14
    movq         %r14, (24)(%rdi)
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    jmp          .Lodd_pass_pairsgas_1
.Lfin_mulx1_3gas_1: 
    mul          %r10
    add          $(2), %rcx
    add          %rax, %r12
    movq         %r12, (24)(%rdi)
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    jmp          .Leven_pass_pairsgas_1
.Linit_odd_len_operationgas_1: 
    movq         (-16)(%rsi,%rcx,8), %r10
    movq         (-8)(%rsi,%rcx,8), %r11
    mov          %r11, %rax
    mul          %r10
    movq         %rax, (-8)(%rdi,%rcx,8)
    movq         (%rsi,%rcx,8), %rax
    mov          %rdx, %r12
    mul          %r10
    xor          %r13, %r13
    xor          %r14, %r14
    add          %rax, %r12
    movq         (%rsi,%rcx,8), %rax
    adc          %rdx, %r13
    cmp          $(0), %rcx
    jge          .Lskip_mul_nx2gas_1
    mov          %rcx, %rbx
.p2align 4, 0x90
.L__0066gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    movq         %r12, (%rdi,%rbx,8)
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    adc          $(0), %r15
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    mul          %r10
    movq         %r13, (8)(%rdi,%rbx,8)
    add          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    adc          $(0), %r12
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r10
    movq         %r14, (16)(%rdi,%rbx,8)
    add          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    adc          $(0), %r13
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r10
    movq         %r15, (24)(%rdi,%rbx,8)
    add          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    adc          $(0), %r14
    add          $(4), %rbx
    jnc          .L__0066gas_1
.Lskip_mul_nx2gas_1: 
    cmp          $(1), %rbx
    jnz          .Lfin_mul2x_3gas_1
.Lfin_mul2x_1gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    movq         %r12, (8)(%rdi)
    add          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    adc          $(0), %r15
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi), %rax
    adc          %rdx, %r15
    mul          %r10
    movq         %r13, (16)(%rdi)
    add          %rax, %r14
    movq         (24)(%rsi), %rax
    adc          %rdx, %r15
    adc          $(0), %r12
    mul          %r11
    add          $(2), %rcx
    movq         %r14, (24)(%rdi)
    add          %rax, %r15
    adc          %r12, %rdx
    movq         %r15, (32)(%rdi)
    movq         %rdx, (40)(%rdi)
    add          $(16), %rdi
    jmp          .Lodd_pass_pairsgas_1
.Lfin_mul2x_3gas_1: 
    mul          %r11
    add          $(2), %rcx
    movq         %r12, (24)(%rdi)
    add          %rax, %r13
    adc          %r14, %rdx
    movq         %r13, (32)(%rdi)
    movq         %rdx, (40)(%rdi)
    add          $(16), %rdi
.p2align 4, 0x90
.Leven_pass_pairsgas_1: 
    movq         (-16)(%rsi,%rcx,8), %r10
    movq         (-8)(%rsi,%rcx,8), %r11
    mov          %r11, %rax
    mul          %r10
    xor          %r12, %r12
    addq         %rax, (-8)(%rdi,%rcx,8)
    movq         (%rsi,%rcx,8), %rax
    adc          %rdx, %r12
    mul          %r10
    xor          %r13, %r13
    xor          %r14, %r14
    add          %rax, %r12
    movq         (%rsi,%rcx,8), %rax
    adc          %rdx, %r13
    cmp          $(0), %rcx
    jge          .Lskip1gas_1
    mov          %rcx, %rbx
.p2align 4, 0x90
.L__0067gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (%rdi,%rbx,8)
    adc          $(0), %r15
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    adc          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          $(0), %r13
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    adc          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          $(0), %r14
    add          $(4), %rbx
    jnc          .L__0067gas_1
.Lskip1gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (8)(%rdi), %r12
    movq         %r12, (8)(%rdi)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (16)(%rsi), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (24)(%rsi), %rax
    mul          %r10
    addq         (16)(%rdi), %r13
    movq         %r13, (16)(%rdi)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (24)(%rsi), %rax
    mul          %r11
    add          $(2), %rcx
    addq         (24)(%rdi), %r14
    movq         %r14, (24)(%rdi)
    adc          %rax, %r15
    adc          %r12, %rdx
    movq         %r15, (32)(%rdi)
    movq         %rdx, (40)(%rdi)
    add          $(16), %rdi
.Lodd_pass_pairsgas_1: 
    movq         (-16)(%rsi,%rcx,8), %r10
    movq         (-8)(%rsi,%rcx,8), %r11
    mov          %r11, %rax
    mul          %r10
    xor          %r12, %r12
    addq         %rax, (-8)(%rdi,%rcx,8)
    movq         (%rsi,%rcx,8), %rax
    adc          %rdx, %r12
    mul          %r10
    xor          %r13, %r13
    xor          %r14, %r14
    add          %rax, %r12
    movq         (%rsi,%rcx,8), %rax
    adc          %rdx, %r13
    cmp          $(0), %rcx
    jge          .Lskip2gas_1
    mov          %rcx, %rbx
.p2align 4, 0x90
.L__0068gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (%rdi,%rbx,8)
    adc          $(0), %r15
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r15
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    adc          %rax, %r15
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          $(0), %r13
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    adc          %rax, %r12
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          $(0), %r14
    add          $(4), %rbx
    jnc          .L__0068gas_1
.Lskip2gas_1: 
    mul          %r11
    add          $(2), %rcx
    addq         (24)(%rdi), %r12
    movq         %r12, (24)(%rdi)
    adc          %rax, %r13
    adc          %r14, %rdx
    movq         %r13, (32)(%rdi)
    movq         %rdx, (40)(%rdi)
    add          $(16), %rdi
    cmp          $(4), %rcx
    jl           .Leven_pass_pairsgas_1
.Ladd_diaggas_1: 
    mov          (%rsp), %rdi
    mov          (8)(%rsp), %rsi
    mov          (16)(%rsp), %rcx
    xor          %rbx, %rbx
    xor          %r12, %r12
    xor          %r13, %r13
    lea          (%rdi,%rcx,8), %rax
    lea          (%rsi,%rcx,8), %rsi
    movq         %r12, (%rdi)
    movq         %r12, (-8)(%rax,%rcx,8)
    neg          %rcx
.p2align 4, 0x90
.Ladd_diag_loopgas_1: 
    movq         (%rsi,%rcx,8), %rax
    mul          %rax
    movq         (%rdi), %r14
    movq         (8)(%rdi), %r15
    add          $(1), %r12
    adc          %r14, %r14
    adc          %r15, %r15
    sbb          %r12, %r12
    add          $(1), %r13
    adc          %rax, %r14
    adc          %rdx, %r15
    sbb          %r13, %r13
    movq         %r14, (%rdi)
    movq         %r15, (8)(%rdi)
    add          $(16), %rdi
    add          $(1), %rcx
    jnz          .Ladd_diag_loopgas_1
    mov          %r15, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
