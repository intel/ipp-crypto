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

 
 .section .note.GNU-stack,"",%progbits 
 
.text
.p2align 5, 0x90
 
.globl e9_cpMulAdc_BNU_school
.type e9_cpMulAdc_BNU_school, @function
 
e9_cpMulAdc_BNU_school:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(24), %rsp
 
    cmp          %r8d, %edx
    jl           .Lgeneral_case_mul_entrygas_1
    jg           .Lgeneral_case_mulgas_1
    cmp          $(8), %edx
    jg           .Lgeneral_case_mulgas_1
    cmp          $(4), %edx
    jg           .Lmore_then_4gas_1
    cmp          $(3), %edx
    ja           .Lmul_4x4gas_1
    jz           .Lmul_3x3gas_1
    jp           .Lmul_2x2gas_1
.p2align 5, 0x90
.Lmul_1x1gas_1: 
    movq         (%rsi), %rax
    mulq         (%rcx)
    movq         %rax, (%rdi)
    movq         %rdx, (8)(%rdi)
    movq         (8)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_2x2gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         (24)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_3x3gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         (40)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_4x4gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (24)(%rcx), %r11
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          (24)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %r10, (24)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         (56)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lmore_then_4gas_1: 
    cmp          $(7), %edx
    ja           .Lmul_8x8gas_1
    jz           .Lmul_7x7gas_1
    jp           .Lmul_6x6gas_1
.p2align 5, 0x90
.Lmul_5x5gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (24)(%rcx), %r11
    mov          (32)(%rcx), %r12
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          (24)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %r10, (24)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    mov          (32)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    movq         %r8, (72)(%rdi)
    movq         (72)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_6x6gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (24)(%rcx), %r11
    mov          (32)(%rcx), %r12
    mov          (40)(%rcx), %r13
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    mov          (24)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %r10, (24)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %r8
    mov          (32)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          (40)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %r12, (40)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    movq         %r8, (72)(%rdi)
    movq         %r9, (80)(%rdi)
    movq         %r10, (88)(%rdi)
    movq         (88)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_7x7gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (24)(%rcx), %r11
    mov          (32)(%rcx), %r12
    mov          (40)(%rcx), %r13
    mov          (48)(%rcx), %r14
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          %r14, %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %r8
    mov          (24)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %r10, (24)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          (32)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (40)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %r12, (40)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (48)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %r13, (48)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    movq         %r8, (72)(%rdi)
    movq         %r9, (80)(%rdi)
    movq         %r10, (88)(%rdi)
    movq         %r11, (96)(%rdi)
    movq         %r12, (104)(%rdi)
    movq         (104)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lmul_8x8gas_1: 
    mov          (%rcx), %r8
    mov          (8)(%rcx), %r9
    mov          (16)(%rcx), %r10
    mov          (24)(%rcx), %r11
    mov          (32)(%rcx), %r12
    mov          (40)(%rcx), %r13
    mov          (48)(%rcx), %r14
    mov          (56)(%rcx), %r15
    mov          (%rsi), %rbx
    mov          %r8, %rax
    mul          %rbx
    mov          %rax, (%rdi)
    mov          %rdx, %r8
    mov          %r9, %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          %r10, %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          %r11, %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          %r12, %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          %r13, %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          %r14, %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    mov          %r15, %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    mov          (8)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %r8, (8)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %r8
    mov          (16)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %r9, (16)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %r9
    mov          (24)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %r10, (24)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    mov          (32)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %r11, (32)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    mov          (40)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %r12, (40)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          (48)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %r13, (48)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rbp, %r14
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    mov          (56)(%rsi), %rbx
    mov          (%rcx), %rax
    mul          %rbx
    add          %rax, %r14
    adc          $(0), %rdx
    mov          %r14, (56)(%rdi)
    mov          %rdx, %rbp
    mov          (8)(%rcx), %rax
    mul          %rbx
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rbp, %r15
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (16)(%rcx), %rax
    mul          %rbx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rbp, %r8
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (24)(%rcx), %rax
    mul          %rbx
    add          %rax, %r9
    adc          $(0), %rdx
    add          %rbp, %r9
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (32)(%rcx), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    add          %rbp, %r10
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (40)(%rcx), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rbp, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (48)(%rcx), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %rbp
    mov          (56)(%rcx), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rbp, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    movq         %r15, (64)(%rdi)
    movq         %r8, (72)(%rdi)
    movq         %r9, (80)(%rdi)
    movq         %r10, (88)(%rdi)
    movq         %r11, (96)(%rdi)
    movq         %r12, (104)(%rdi)
    movq         %r13, (112)(%rdi)
    movq         %r14, (120)(%rdi)
    movq         (120)(%rdi), %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.p2align 5, 0x90
.Lgeneral_case_mul_entrygas_1: 
    xor          %rcx, %rsi
    xor          %r8d, %edx
    xor          %rsi, %rcx
    xor          %edx, %r8d
    xor          %rcx, %rsi
    xor          %r8d, %edx
.p2align 5, 0x90
.Lgeneral_case_mulgas_1: 
    movslq       %edx, %rdx
    movslq       %r8d, %r8
    lea          (-32)(%rdi,%rdx,8), %rdi
    lea          (-32)(%rsi,%rdx,8), %rsi
    mov          $(4), %rbx
    sub          %rdx, %rbx
    movq         %rbx, (%rsp)
    movq         (%rsi,%rbx,8), %rax
    movq         (%rcx), %r10
    test         $(1), %r8
    jz           .Linit_even_Bgas_1
.Linit_odd_Bgas_1: 
    xor          %r12, %r12
    cmp          $(0), %rbx
    jge          .Lskip_mul1gas_1
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
    cmp          $(2), %rbx
    ja           .Lfin_mul1x4n_1gas_1
    jz           .Lfin_mul1x4n_2gas_1
    jp           .Lfin_mul1x4n_3gas_1
.Lfin_mul1x4n_4gas_1: 
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r12
    movq         %r12, (%rdi)
    movq         (8)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r13
    movq         %r13, (8)(%rdi)
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    xor          %r15, %r15
    add          %rax, %r14
    movq         %r14, (16)(%rdi)
    movq         (24)(%rsi), %rax
    adc          %rdx, %r15
    mul          %r10
    movq         (%rsp), %rbx
    add          %rax, %r15
    movq         %r15, (24)(%rdi)
    movq         (%rsi,%rbx,8), %rax
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    add          $(8), %rcx
    add          $(1), %r8
    jmp          .Lmla2x4n_4gas_1
.Lfin_mul1x4n_3gas_1: 
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
    movq         (%rsp), %rbx
    add          %rax, %r14
    movq         %r14, (24)(%rdi)
    movq         (%rsi,%rbx,8), %rax
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    add          $(8), %rcx
    add          $(1), %r8
    jmp          .Lmla2x4n_3gas_1
.Lfin_mul1x4n_2gas_1: 
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r12
    movq         %r12, (16)(%rdi)
    movq         (24)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r10
    movq         (%rsp), %rbx
    add          %rax, %r13
    movq         %r13, (24)(%rdi)
    movq         (%rsi,%rbx,8), %rax
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    add          $(8), %rcx
    add          $(1), %r8
    jmp          .Lmla2x4n_2gas_1
.Lfin_mul1x4n_1gas_1: 
    mul          %r10
    movq         (%rsp), %rbx
    add          %rax, %r12
    movq         %r12, (24)(%rdi)
    movq         (%rsi,%rbx,8), %rax
    adc          $(0), %rdx
    movq         %rdx, (32)(%rdi)
    add          $(8), %rdi
    add          $(8), %rcx
    add          $(1), %r8
    jmp          .Lmla2x4n_1gas_1
.Linit_even_Bgas_1: 
    mov          %rax, %rbp
    mul          %r10
    movq         (8)(%rcx), %r11
    xor          %r14, %r14
    mov          %rax, %r12
    mov          %rbp, %rax
    mov          %rdx, %r13
    cmp          $(0), %rbx
    jge          .Lskip_mul_nx2gas_1
.p2align 5, 0x90
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
    cmp          $(2), %rbx
    ja           .Lfin_mul2x4n_1gas_1
    jz           .Lfin_mul2x4n_2gas_1
    jp           .Lfin_mul2x4n_3gas_1
.Lfin_mul2x4n_4gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    movq         %r12, (%rdi)
    add          %rax, %r13
    movq         (8)(%rsi), %rax
    adc          %rdx, %r14
    adc          $(0), %r15
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    movq         (16)(%rsi), %rax
    adc          %rdx, %r15
    mul          %r10
    movq         %r13, (8)(%rdi)
    add          %rax, %r14
    movq         (16)(%rsi), %rax
    adc          %rdx, %r15
    adc          $(0), %r12
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    movq         (24)(%rsi), %rax
    adc          %rdx, %r12
    mul          %r10
    movq         %r14, (16)(%rdi)
    add          %rax, %r15
    movq         (24)(%rsi), %rax
    adc          %rdx, %r12
    adc          $(0), %r13
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    movq         %r15, (8)(%rdi)
    add          %rax, %r12
    movq         (%rsi,%rbx,8), %rax
    adc          %r13, %rdx
    movq         %r12, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
.p2align 5, 0x90
.Lmla2x4n_4gas_1: 
    sub          $(2), %r8
    jz           .Lquitgas_1
    movq         (%rcx), %r10
    mul          %r10
    movq         (8)(%rcx), %r11
    xor          %r14, %r14
    mov          %rax, %r12
    movq         (%rsi,%rbx,8), %rax
    mov          %rdx, %r13
    cmp          $(0), %rbx
    jz           .Lskip_mla_x2gas_1
.p2align 5, 0x90
.L__0067gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    movq         %r12, (%rdi,%rbx,8)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (8)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    adc          %rdx, %r12
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          %rax, %r15
    adc          %rdx, %r12
    adc          $(0), %r13
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    adc          %rdx, %r13
    movq         (32)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r14
    movq         (32)(%rsi,%rbx,8), %rax
    add          $(4), %rbx
    jnc          .L__0067gas_1
.Lskip_mla_x2gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi), %r12
    movq         %r12, (%rdi)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (8)(%rsi), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (16)(%rsi), %rax
    mul          %r10
    addq         (8)(%rdi), %r13
    movq         %r13, (8)(%rdi)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (16)(%rsi), %rax
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    adc          %rdx, %r12
    movq         (24)(%rsi), %rax
    mul          %r10
    addq         (16)(%rdi), %r14
    movq         %r14, (16)(%rdi)
    adc          %rax, %r15
    adc          %rdx, %r12
    adc          $(0), %r13
    movq         (24)(%rsi), %rax
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    addq         (8)(%rdi), %r15
    movq         %r15, (8)(%rdi)
    adc          %rax, %r12
    adc          %r13, %rdx
    movq         (%rsi,%rbx,8), %rax
    movq         %r12, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
    jmp          .Lmla2x4n_4gas_1
.Lfin_mul2x4n_3gas_1: 
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
    add          $(16), %rdi
    mov          (%rsp), %rbx
    movq         %r14, (8)(%rdi)
    add          %rax, %r15
    movq         (%rsi,%rbx,8), %rax
    adc          %r12, %rdx
    movq         %r15, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
.p2align 5, 0x90
.Lmla2x4n_3gas_1: 
    sub          $(2), %r8
    jz           .Lquitgas_1
    movq         (%rcx), %r10
    mul          %r10
    movq         (8)(%rcx), %r11
    xor          %r14, %r14
    mov          %rax, %r12
    movq         (%rsi,%rbx,8), %rax
    mov          %rdx, %r13
.p2align 5, 0x90
.L__0068gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    movq         %r12, (%rdi,%rbx,8)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (8)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    adc          %rdx, %r12
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          %rax, %r15
    adc          %rdx, %r12
    adc          $(0), %r13
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    adc          %rdx, %r13
    movq         (32)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r14
    movq         (32)(%rsi,%rbx,8), %rax
    add          $(4), %rbx
    jnc          .L__0068gas_1
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
    add          $(16), %rdi
    mov          (%rsp), %rbx
    addq         (8)(%rdi), %r14
    movq         %r14, (8)(%rdi)
    adc          %rax, %r15
    adc          %r12, %rdx
    movq         (%rsi,%rbx,8), %rax
    movq         %r15, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
    jmp          .Lmla2x4n_3gas_1
.Lfin_mul2x4n_2gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    movq         %r12, (16)(%rdi)
    add          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    adc          $(0), %r15
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    movq         %r13, (8)(%rdi)
    add          %rax, %r14
    movq         (%rsi,%rbx,8), %rax
    adc          %r15, %rdx
    movq         %r14, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
.p2align 5, 0x90
.Lmla2x4n_2gas_1: 
    sub          $(2), %r8
    jz           .Lquitgas_1
    movq         (%rcx), %r10
    mul          %r10
    movq         (8)(%rcx), %r11
    xor          %r14, %r14
    mov          %rax, %r12
    movq         (%rsi,%rbx,8), %rax
    mov          %rdx, %r13
.p2align 5, 0x90
.L__0069gas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    movq         %r12, (%rdi,%rbx,8)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (8)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    adc          %rdx, %r12
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          %rax, %r15
    adc          %rdx, %r12
    adc          $(0), %r13
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    adc          %rdx, %r13
    movq         (32)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r14
    movq         (32)(%rsi,%rbx,8), %rax
    add          $(4), %rbx
    jnc          .L__0069gas_1
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (16)(%rdi), %r12
    movq         %r12, (16)(%rdi)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (24)(%rsi), %rax
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    addq         (8)(%rdi), %r13
    movq         %r13, (8)(%rdi)
    adc          %rax, %r14
    adc          %r15, %rdx
    movq         (%rsi,%rbx,8), %rax
    movq         %r14, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
    jmp          .Lmla2x4n_2gas_1
.Lfin_mul2x4n_1gas_1: 
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    movq         %r12, (8)(%rdi)
    add          %rax, %r13
    movq         (%rsi,%rbx,8), %rax
    adc          %r14, %rdx
    movq         %r13, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
.p2align 5, 0x90
.Lmla2x4n_1gas_1: 
    sub          $(2), %r8
    jz           .Lquitgas_1
    movq         (%rcx), %r10
    mul          %r10
    movq         (8)(%rcx), %r11
    xor          %r14, %r14
    mov          %rax, %r12
    movq         (%rsi,%rbx,8), %rax
    mov          %rdx, %r13
.p2align 5, 0x90
.L__006Agas_1: 
    mul          %r11
    xor          %r15, %r15
    add          %rax, %r13
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r10
    addq         (%rdi,%rbx,8), %r12
    movq         %r12, (%rdi,%rbx,8)
    adc          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %r15
    movq         (8)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r12, %r12
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (8)(%rdi,%rbx,8), %r13
    movq         %r13, (8)(%rdi,%rbx,8)
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %r12
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r13, %r13
    add          %rax, %r15
    adc          %rdx, %r12
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (16)(%rdi,%rbx,8), %r14
    movq         %r14, (16)(%rdi,%rbx,8)
    adc          %rax, %r15
    adc          %rdx, %r12
    adc          $(0), %r13
    movq         (24)(%rsi,%rbx,8), %rax
    mul          %r11
    xor          %r14, %r14
    add          %rax, %r12
    adc          %rdx, %r13
    movq         (32)(%rsi,%rbx,8), %rax
    mul          %r10
    addq         (24)(%rdi,%rbx,8), %r15
    movq         %r15, (24)(%rdi,%rbx,8)
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r14
    movq         (32)(%rsi,%rbx,8), %rax
    add          $(4), %rbx
    jnc          .L__006Agas_1
    mul          %r11
    add          $(16), %rdi
    mov          (%rsp), %rbx
    addq         (8)(%rdi), %r12
    movq         %r12, (8)(%rdi)
    adc          %rax, %r13
    adc          %r14, %rdx
    movq         (%rsi,%rbx,8), %rax
    movq         %r13, (16)(%rdi)
    movq         %rdx, (24)(%rdi)
    add          $(16), %rcx
    jmp          .Lmla2x4n_1gas_1
.Lquitgas_1: 
    mov          %rdx, %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size e9_cpMulAdc_BNU_school, .Lfe1-(e9_cpMulAdc_BNU_school)
 
