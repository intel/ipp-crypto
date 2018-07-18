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
.p2align 4, 0x90
 
.globl n8_cpMontRedAdc_BNU
.type n8_cpMontRedAdc_BNU, @function
 
n8_cpMontRedAdc_BNU:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(40), %rsp
 
    movq         $(0), (16)(%rsp)
    movslq       %ecx, %rcx
    mov          %r8, %r15
    cmp          $(5), %rcx
    jge          .Lgeneral_casegas_1
    cmp          $(3), %rcx
    ja           .LmSize_4gas_1
    jz           .LmSize_3gas_1
    jp           .LmSize_2gas_1
.p2align 4, 0x90
.LmSize_1gas_1: 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    mov          %rdx, %rsi
    mov          %r8, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r8
    adc          %rdx, %r9
    adc          $(0), %rbx
    addq         (16)(%rsp), %r9
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r9, %r8
    subq         (%rsi), %r9
    sbb          $(0), %rbx
    cmovc        %r8, %r9
    movq         %r9, (%rdi)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.LmSize_2gas_1: 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    mov          %rdx, %rsi
    mov          %r8, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r8
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r9
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r9
    adc          %rdx, %r10
    adc          $(0), %rbx
    addq         (16)(%rsp), %r10
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r9, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r9
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r10
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r10
    adc          %rdx, %r11
    adc          $(0), %rbx
    addq         (16)(%rsp), %r11
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r10, %r8
    subq         (%rsi), %r10
    mov          %r11, %r9
    sbbq         (8)(%rsi), %r11
    sbb          $(0), %rbx
    cmovc        %r8, %r10
    movq         %r10, (%rdi)
    cmovc        %r9, %r11
    movq         %r11, (8)(%rdi)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.LmSize_3gas_1: 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    mov          %rdx, %rsi
    mov          %r8, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r8
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r9
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r9
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r10
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r10
    adc          %rdx, %r11
    adc          $(0), %rbx
    addq         (16)(%rsp), %r11
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r9, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r9
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r10
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r10
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r11
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r11
    adc          %rdx, %r12
    adc          $(0), %rbx
    addq         (16)(%rsp), %r12
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r10, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r10
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r11
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r11
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r12
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %rbx
    addq         (16)(%rsp), %r13
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r11, %r8
    subq         (%rsi), %r11
    mov          %r12, %r9
    sbbq         (8)(%rsi), %r12
    mov          %r13, %r10
    sbbq         (16)(%rsi), %r13
    sbb          $(0), %rbx
    cmovc        %r8, %r11
    movq         %r11, (%rdi)
    cmovc        %r9, %r12
    movq         %r12, (8)(%rdi)
    cmovc        %r10, %r13
    movq         %r13, (16)(%rdi)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.LmSize_4gas_1: 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %rcx
    mov          %rdx, %rsi
    mov          %r8, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r8
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r9
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r9
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r10
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r10
    movq         (24)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r11
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r11
    adc          %rdx, %r12
    adc          $(0), %rbx
    addq         (16)(%rsp), %r12
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r9, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r9
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r10
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r10
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r11
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r11
    movq         (24)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r12
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %rbx
    addq         (16)(%rsp), %r13
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r10, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r10
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r11
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r11
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r12
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r12
    movq         (24)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r13
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r13
    adc          %rdx, %r14
    adc          $(0), %rbx
    addq         (16)(%rsp), %r14
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r11, %rbp
    imul         %r15, %rbp
    movq         (%rsi), %rax
    mul          %rbp
    xor          %rbx, %rbx
    add          %rax, %r11
    movq         (8)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r12
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r12
    movq         (16)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r13
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %rbx
    mul          %rbp
    add          %rbx, %r14
    adc          $(0), %rdx
    xor          %rbx, %rbx
    add          %rax, %r14
    adc          %rdx, %rcx
    adc          $(0), %rbx
    addq         (16)(%rsp), %rcx
    adc          $(0), %rbx
    movq         %rbx, (16)(%rsp)
    mov          %r12, %r8
    subq         (%rsi), %r12
    mov          %r13, %r9
    sbbq         (8)(%rsi), %r13
    mov          %r14, %r10
    sbbq         (16)(%rsi), %r14
    mov          %rcx, %r11
    sbbq         (24)(%rsi), %rcx
    sbb          $(0), %rbx
    cmovc        %r8, %r12
    movq         %r12, (%rdi)
    cmovc        %r9, %r13
    movq         %r13, (8)(%rdi)
    cmovc        %r10, %r14
    movq         %r14, (16)(%rdi)
    cmovc        %r11, %rcx
    movq         %rcx, (24)(%rdi)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.Lgeneral_casegas_1: 
    lea          (-32)(%rdi,%rcx,8), %rdi
    movq         %rdi, (%rsp)
    mov          %rsi, %rdi
    mov          %rdx, %rsi
    lea          (-32)(%rdi,%rcx,8), %rdi
    lea          (-32)(%rsi,%rcx,8), %rsi
    mov          $(4), %rbx
    sub          %rcx, %rbx
    movq         %rbx, (24)(%rsp)
    mov          $(3), %rdx
    and          %rcx, %rdx
    test         $(1), %rcx
    jz           .Leven_len_Modulusgas_1
.Lodd_len_Modulusgas_1: 
    movq         (%rdi,%rbx,8), %r9
    imul         %r15, %r9
    movq         (%rsi,%rbx,8), %rax
    mul          %r9
    mov          %rax, %r11
    movq         (8)(%rsi,%rbx,8), %rax
    mov          %rdx, %r12
    add          $(1), %rbx
    jz           .Lskip_mlax1gas_1
.p2align 4, 0x90
.L__000Dgas_1: 
    mul          %r9
    xor          %r13, %r13
    addq         (-8)(%rdi,%rbx,8), %r11
    adc          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r11, (-8)(%rdi,%rbx,8)
    mul          %r9
    xor          %r14, %r14
    addq         (%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (%rdi,%rbx,8)
    mul          %r9
    xor          %r11, %r11
    addq         (8)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    movq         %r13, (8)(%rdi,%rbx,8)
    mul          %r9
    xor          %r12, %r12
    addq         (16)(%rdi,%rbx,8), %r14
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (16)(%rdi,%rbx,8)
    add          $(4), %rbx
    jnc          .L__000Dgas_1
.Lskip_mlax1gas_1: 
    mul          %r9
    xor          %r13, %r13
    addq         %r11, (-8)(%rdi,%rbx,8)
    adc          %rax, %r12
    adc          %rdx, %r13
    cmp          $(2), %rbx
    ja           .Lfin_mla1x4n_2gas_1
    jz           .Lfin_mla1x4n_3gas_1
    jp           .Lfin_mla1x4n_4gas_1
.Lfin_mla1x4n_1gas_1: 
    movq         (8)(%rsi), %rax
    movq         (24)(%rsp), %rbx
    mul          %r9
    xor          %r14, %r14
    addq         (%rdi), %r12
    adc          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    movq         %r12, (%rdi)
    mul          %r9
    xor          %r11, %r11
    addq         (8)(%rdi), %r13
    adc          %rax, %r14
    movq         (24)(%rsi), %rax
    adc          %rdx, %r11
    movq         %r13, (8)(%rdi)
    mul          %r9
    addq         (16)(%rdi), %r14
    adc          %rax, %r11
    adc          $(0), %rdx
    xor          %rax, %rax
    movq         %r14, (16)(%rdi)
    addq         (24)(%rdi), %r11
    adcq         (32)(%rdi), %rdx
    adc          $(0), %rax
    movq         %r11, (24)(%rdi)
    movq         %rdx, (32)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(8), %rdi
    sub          $(1), %rcx
    jmp          .Lmla2x4n_1gas_1
.Lfin_mla1x4n_4gas_1: 
    movq         (16)(%rsi), %rax
    movq         (24)(%rsp), %rbx
    mul          %r9
    xor          %r11, %r14
    addq         (8)(%rdi), %r12
    adc          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi)
    mul          %r9
    addq         (16)(%rdi), %r13
    adc          %rax, %r14
    adc          $(0), %rdx
    xor          %rax, %rax
    movq         %r13, (16)(%rdi)
    addq         (24)(%rdi), %r14
    adcq         (32)(%rdi), %rdx
    adc          $(0), %rax
    movq         %r14, (24)(%rdi)
    movq         %rdx, (32)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(8), %rdi
    sub          $(1), %rcx
    jmp          .Lmla2x4n_4gas_1
.Lfin_mla1x4n_3gas_1: 
    movq         (24)(%rsi), %rax
    movq         (24)(%rsp), %rbx
    mul          %r9
    addq         (16)(%rdi), %r12
    adc          %rax, %r13
    adc          $(0), %rdx
    xor          %rax, %rax
    movq         %r12, (16)(%rdi)
    addq         (24)(%rdi), %r13
    adcq         (32)(%rdi), %rdx
    adc          $(0), %rax
    movq         %r13, (24)(%rdi)
    movq         %rdx, (32)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(8), %rdi
    sub          $(1), %rcx
    jmp          .Lmla2x4n_3gas_1
.Lfin_mla1x4n_2gas_1: 
    movq         (24)(%rsp), %rbx
    xor          %rax, %rax
    addq         (24)(%rdi), %r12
    adcq         (32)(%rdi), %r13
    adc          $(0), %rax
    movq         %r12, (24)(%rdi)
    movq         %r13, (32)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(8), %rdi
    sub          $(1), %rcx
    jmp          .Lmla2x4n_2gas_1
.p2align 4, 0x90
.Leven_len_Modulusgas_1: 
    xor          %rax, %rax
    cmp          $(2), %rdx
    ja           .Lmla2x4n_1gas_1
    jz           .Lmla2x4n_2gas_1
    jp           .Lmla2x4n_3gas_1
.p2align 4, 0x90
.Lmla2x4n_4gas_1: 
    movq         (%rdi,%rbx,8), %r9
    imul         %r15, %r9
    movq         (%rsi,%rbx,8), %rax
    mul          %r9
    movq         (8)(%rsi,%rbx,8), %r10
    imul         %r9, %r10
    mov          %rax, %r11
    mov          %rdx, %r12
    addq         (%rdi,%rbx,8), %rax
    adcq         (8)(%rdi,%rbx,8), %rdx
    add          %rdx, %r10
    imul         %r15, %r10
    movq         (%rsi,%rbx,8), %rax
    xor          %r13, %r13
.p2align 4, 0x90
.L__000Egas_1: 
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (%rdi,%rbx,8), %r11
    adc          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r11, (%rdi,%rbx,8)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (8)(%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi,%rbx,8)
    adc          $(0), %r11
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %r9
    addq         (16)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    movq         %r13, (16)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r9
    addq         (24)(%rdi,%rbx,8), %r14
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (24)(%rdi,%rbx,8)
    adc          $(0), %r13
    add          $(4), %rbx
    jnc          .L__000Egas_1
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (8)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (%rdi), %r11
    adc          %rax, %r12
    movq         (8)(%rsi), %rax
    adc          %rdx, %r13
    movq         %r11, (%rdi)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (8)(%rdi), %r12
    adc          %rax, %r13
    movq         (16)(%rsi), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi)
    adc          $(0), %r11
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi), %rax
    adc          %rdx, %r11
    mul          %r9
    addq         (16)(%rdi), %r13
    adc          %rax, %r14
    movq         (24)(%rsi), %rax
    adc          %rdx, %r11
    movq         %r13, (16)(%rdi)
    adc          $(0), %r12
    mul          %r10
    movq         (24)(%rsp), %rbx
    addq         (24)(%rdi), %r14
    adc          %rax, %r11
    movq         %r14, (24)(%rdi)
    adc          %rdx, %r12
    xor          %rax, %rax
    addq         (32)(%rdi), %r11
    adcq         (40)(%rdi), %r12
    adc          $(0), %rax
    addq         (16)(%rsp), %r11
    adc          $(0), %r12
    adc          $(0), %rax
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(16), %rdi
    sub          $(2), %rcx
    jnz          .Lmla2x4n_4gas_1
    movq         (%rsp), %rdx
    xor          %rcx, %rcx
.p2align 4, 0x90
.L__000Fgas_1: 
    add          %rcx, %rcx
    movq         (%rdi,%rbx,8), %r11
    sbbq         (%rsi,%rbx,8), %r11
    movq         %r11, (%rdx,%rbx,8)
    movq         (8)(%rdi,%rbx,8), %r12
    sbbq         (8)(%rsi,%rbx,8), %r12
    movq         %r12, (8)(%rdx,%rbx,8)
    movq         (16)(%rdi,%rbx,8), %r13
    sbbq         (16)(%rsi,%rbx,8), %r13
    movq         %r13, (16)(%rdx,%rbx,8)
    movq         (24)(%rdi,%rbx,8), %r14
    sbbq         (24)(%rsi,%rbx,8), %r14
    movq         %r14, (24)(%rdx,%rbx,8)
    sbb          %rcx, %rcx
    add          $(4), %rbx
    jnc          .L__000Fgas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (%rdi), %r11
    sbbq         (%rsi), %r11
    movq         %r11, (%rdx)
    movq         (8)(%rdi), %r12
    sbbq         (8)(%rsi), %r12
    movq         %r12, (8)(%rdx)
    movq         (16)(%rdi), %r13
    sbbq         (16)(%rsi), %r13
    movq         %r13, (16)(%rdx)
    movq         (24)(%rdi), %r14
    sbbq         (24)(%rsi), %r14
    movq         %r14, (24)(%rdx)
    sbb          $(0), %rax
    sbb          %rcx, %rcx
    mov          %rcx, %r14
.p2align 4, 0x90
.L__0010gas_1: 
    add          %r14, %r14
    movq         (%rdx,%rbx,8), %r11
    movq         (%rdi,%rbx,8), %r12
    movq         (8)(%rdx,%rbx,8), %r13
    movq         (8)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx,%rbx,8)
    movq         (16)(%rdx,%rbx,8), %r11
    movq         (16)(%rdi,%rbx,8), %r12
    movq         (24)(%rdx,%rbx,8), %r13
    movq         (24)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx,%rbx,8)
    mov          %rcx, %r14
    add          $(4), %rbx
    jnc          .L__0010gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (%rdx), %r11
    movq         (%rdi), %r12
    cmovc        %r12, %r11
    movq         %r11, (%rdx)
    movq         (8)(%rdx), %r13
    movq         (8)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx)
    movq         (16)(%rdx), %r11
    movq         (16)(%rdi), %r12
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx)
    movq         (24)(%rdx), %r13
    movq         (24)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.Lmla2x4n_3gas_1: 
    movq         (%rdi,%rbx,8), %r9
    imul         %r15, %r9
    movq         (%rsi,%rbx,8), %rax
    mul          %r9
    movq         (8)(%rsi,%rbx,8), %r10
    imul         %r9, %r10
    mov          %rax, %r11
    mov          %rdx, %r12
    addq         (%rdi,%rbx,8), %rax
    adcq         (8)(%rdi,%rbx,8), %rdx
    add          %rdx, %r10
    imul         %r15, %r10
    movq         (%rsi,%rbx,8), %rax
    xor          %r13, %r13
.p2align 4, 0x90
.L__0011gas_1: 
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (%rdi,%rbx,8), %r11
    adc          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r11, (%rdi,%rbx,8)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (8)(%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi,%rbx,8)
    adc          $(0), %r11
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %r9
    addq         (16)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    movq         %r13, (16)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r9
    addq         (24)(%rdi,%rbx,8), %r14
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (24)(%rdi,%rbx,8)
    adc          $(0), %r13
    add          $(4), %rbx
    jnc          .L__0011gas_1
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (16)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (8)(%rdi), %r11
    adc          %rax, %r12
    movq         (16)(%rsi), %rax
    adc          %rdx, %r13
    movq         %r11, (8)(%rdi)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (16)(%rdi), %r12
    adc          %rax, %r13
    movq         (24)(%rsi), %rax
    adc          %rdx, %r14
    movq         %r12, (16)(%rdi)
    adc          $(0), %r11
    mul          %r10
    movq         (24)(%rsp), %rbx
    addq         (24)(%rdi), %r13
    adc          %rax, %r14
    movq         %r13, (24)(%rdi)
    adc          %rdx, %r11
    xor          %rax, %rax
    addq         (32)(%rdi), %r14
    adcq         (40)(%rdi), %r11
    adc          $(0), %rax
    addq         (16)(%rsp), %r14
    adc          $(0), %r11
    adc          $(0), %rax
    movq         %r14, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(16), %rdi
    sub          $(2), %rcx
    jnz          .Lmla2x4n_3gas_1
    movq         (%rsp), %rdx
    xor          %rcx, %rcx
.p2align 4, 0x90
.L__0012gas_1: 
    add          %rcx, %rcx
    movq         (%rdi,%rbx,8), %r11
    sbbq         (%rsi,%rbx,8), %r11
    movq         %r11, (%rdx,%rbx,8)
    movq         (8)(%rdi,%rbx,8), %r12
    sbbq         (8)(%rsi,%rbx,8), %r12
    movq         %r12, (8)(%rdx,%rbx,8)
    movq         (16)(%rdi,%rbx,8), %r13
    sbbq         (16)(%rsi,%rbx,8), %r13
    movq         %r13, (16)(%rdx,%rbx,8)
    movq         (24)(%rdi,%rbx,8), %r14
    sbbq         (24)(%rsi,%rbx,8), %r14
    movq         %r14, (24)(%rdx,%rbx,8)
    sbb          %rcx, %rcx
    add          $(4), %rbx
    jnc          .L__0012gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (8)(%rdi), %r12
    sbbq         (8)(%rsi), %r12
    movq         %r12, (8)(%rdx)
    movq         (16)(%rdi), %r13
    sbbq         (16)(%rsi), %r13
    movq         %r13, (16)(%rdx)
    movq         (24)(%rdi), %r14
    sbbq         (24)(%rsi), %r14
    movq         %r14, (24)(%rdx)
    sbb          $(0), %rax
    sbb          %rcx, %rcx
    mov          %rcx, %r14
.p2align 4, 0x90
.L__0013gas_1: 
    add          %r14, %r14
    movq         (%rdx,%rbx,8), %r11
    movq         (%rdi,%rbx,8), %r12
    movq         (8)(%rdx,%rbx,8), %r13
    movq         (8)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx,%rbx,8)
    movq         (16)(%rdx,%rbx,8), %r11
    movq         (16)(%rdi,%rbx,8), %r12
    movq         (24)(%rdx,%rbx,8), %r13
    movq         (24)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx,%rbx,8)
    mov          %rcx, %r14
    add          $(4), %rbx
    jnc          .L__0013gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (8)(%rdx), %r13
    movq         (8)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx)
    movq         (16)(%rdx), %r11
    movq         (16)(%rdi), %r12
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx)
    movq         (24)(%rdx), %r13
    movq         (24)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.Lmla2x4n_2gas_1: 
    movq         (%rdi,%rbx,8), %r9
    imul         %r15, %r9
    movq         (%rsi,%rbx,8), %rax
    mul          %r9
    movq         (8)(%rsi,%rbx,8), %r10
    imul         %r9, %r10
    mov          %rax, %r11
    mov          %rdx, %r12
    addq         (%rdi,%rbx,8), %rax
    adcq         (8)(%rdi,%rbx,8), %rdx
    add          %rdx, %r10
    imul         %r15, %r10
    movq         (%rsi,%rbx,8), %rax
    xor          %r13, %r13
.p2align 4, 0x90
.L__0014gas_1: 
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (%rdi,%rbx,8), %r11
    adc          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r11, (%rdi,%rbx,8)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (8)(%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi,%rbx,8)
    adc          $(0), %r11
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %r9
    addq         (16)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    movq         %r13, (16)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r9
    addq         (24)(%rdi,%rbx,8), %r14
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (24)(%rdi,%rbx,8)
    adc          $(0), %r13
    add          $(4), %rbx
    jnc          .L__0014gas_1
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (24)(%rsi), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (16)(%rdi), %r11
    adc          %rax, %r12
    movq         (24)(%rsi), %rax
    adc          %rdx, %r13
    movq         %r11, (16)(%rdi)
    adc          $(0), %r14
    mul          %r10
    movq         (24)(%rsp), %rbx
    addq         (24)(%rdi), %r12
    adc          %rax, %r13
    movq         %r12, (24)(%rdi)
    adc          %rdx, %r14
    xor          %rax, %rax
    addq         (32)(%rdi), %r13
    adcq         (40)(%rdi), %r14
    adc          $(0), %rax
    addq         (16)(%rsp), %r13
    adc          $(0), %r14
    adc          $(0), %rax
    movq         %r13, (32)(%rdi)
    movq         %r14, (40)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(16), %rdi
    sub          $(2), %rcx
    jnz          .Lmla2x4n_2gas_1
    movq         (%rsp), %rdx
    xor          %rcx, %rcx
.p2align 4, 0x90
.L__0015gas_1: 
    add          %rcx, %rcx
    movq         (%rdi,%rbx,8), %r11
    sbbq         (%rsi,%rbx,8), %r11
    movq         %r11, (%rdx,%rbx,8)
    movq         (8)(%rdi,%rbx,8), %r12
    sbbq         (8)(%rsi,%rbx,8), %r12
    movq         %r12, (8)(%rdx,%rbx,8)
    movq         (16)(%rdi,%rbx,8), %r13
    sbbq         (16)(%rsi,%rbx,8), %r13
    movq         %r13, (16)(%rdx,%rbx,8)
    movq         (24)(%rdi,%rbx,8), %r14
    sbbq         (24)(%rsi,%rbx,8), %r14
    movq         %r14, (24)(%rdx,%rbx,8)
    sbb          %rcx, %rcx
    add          $(4), %rbx
    jnc          .L__0015gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (16)(%rdi), %r13
    sbbq         (16)(%rsi), %r13
    movq         %r13, (16)(%rdx)
    movq         (24)(%rdi), %r14
    sbbq         (24)(%rsi), %r14
    movq         %r14, (24)(%rdx)
    sbb          $(0), %rax
    sbb          %rcx, %rcx
    mov          %rcx, %r14
.p2align 4, 0x90
.L__0016gas_1: 
    add          %r14, %r14
    movq         (%rdx,%rbx,8), %r11
    movq         (%rdi,%rbx,8), %r12
    movq         (8)(%rdx,%rbx,8), %r13
    movq         (8)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx,%rbx,8)
    movq         (16)(%rdx,%rbx,8), %r11
    movq         (16)(%rdi,%rbx,8), %r12
    movq         (24)(%rdx,%rbx,8), %r13
    movq         (24)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx,%rbx,8)
    mov          %rcx, %r14
    add          $(4), %rbx
    jnc          .L__0016gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (16)(%rdx), %r11
    movq         (16)(%rdi), %r12
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx)
    movq         (24)(%rdx), %r13
    movq         (24)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx)
    jmp          .Lquitgas_1
.p2align 4, 0x90
.Lmla2x4n_1gas_1: 
    movq         (%rdi,%rbx,8), %r9
    imul         %r15, %r9
    movq         (%rsi,%rbx,8), %rax
    mul          %r9
    movq         (8)(%rsi,%rbx,8), %r10
    imul         %r9, %r10
    mov          %rax, %r11
    mov          %rdx, %r12
    addq         (%rdi,%rbx,8), %rax
    adcq         (8)(%rdi,%rbx,8), %rdx
    add          %rdx, %r10
    imul         %r15, %r10
    movq         (%rsi,%rbx,8), %rax
    xor          %r13, %r13
.p2align 4, 0x90
.L__0017gas_1: 
    mul          %r10
    xor          %r14, %r14
    add          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    mul          %r9
    addq         (%rdi,%rbx,8), %r11
    adc          %rax, %r12
    movq         (8)(%rsi,%rbx,8), %rax
    adc          %rdx, %r13
    movq         %r11, (%rdi,%rbx,8)
    adc          $(0), %r14
    mul          %r10
    xor          %r11, %r11
    add          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    mul          %r9
    addq         (8)(%rdi,%rbx,8), %r12
    adc          %rax, %r13
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r14
    movq         %r12, (8)(%rdi,%rbx,8)
    adc          $(0), %r11
    mul          %r10
    xor          %r12, %r12
    add          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %r9
    addq         (16)(%rdi,%rbx,8), %r13
    adc          %rax, %r14
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    movq         %r13, (16)(%rdi,%rbx,8)
    adc          $(0), %r12
    mul          %r10
    xor          %r13, %r13
    add          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    mul          %r9
    addq         (24)(%rdi,%rbx,8), %r14
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r12
    movq         %r14, (24)(%rdi,%rbx,8)
    adc          $(0), %r13
    add          $(4), %rbx
    jnc          .L__0017gas_1
    mul          %r10
    movq         (24)(%rsp), %rbx
    addq         (24)(%rdi), %r11
    adc          %rax, %r12
    movq         %r11, (24)(%rdi)
    adc          %rdx, %r13
    xor          %rax, %rax
    addq         (32)(%rdi), %r12
    adcq         (40)(%rdi), %r13
    adc          $(0), %rax
    addq         (16)(%rsp), %r12
    adc          $(0), %r13
    adc          $(0), %rax
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %rax, (16)(%rsp)
    add          $(16), %rdi
    sub          $(2), %rcx
    jnz          .Lmla2x4n_1gas_1
    movq         (%rsp), %rdx
    xor          %rcx, %rcx
.p2align 4, 0x90
.L__0018gas_1: 
    add          %rcx, %rcx
    movq         (%rdi,%rbx,8), %r11
    sbbq         (%rsi,%rbx,8), %r11
    movq         %r11, (%rdx,%rbx,8)
    movq         (8)(%rdi,%rbx,8), %r12
    sbbq         (8)(%rsi,%rbx,8), %r12
    movq         %r12, (8)(%rdx,%rbx,8)
    movq         (16)(%rdi,%rbx,8), %r13
    sbbq         (16)(%rsi,%rbx,8), %r13
    movq         %r13, (16)(%rdx,%rbx,8)
    movq         (24)(%rdi,%rbx,8), %r14
    sbbq         (24)(%rsi,%rbx,8), %r14
    movq         %r14, (24)(%rdx,%rbx,8)
    sbb          %rcx, %rcx
    add          $(4), %rbx
    jnc          .L__0018gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (24)(%rdi), %r14
    sbbq         (24)(%rsi), %r14
    movq         %r14, (24)(%rdx)
    sbb          $(0), %rax
    sbb          %rcx, %rcx
    mov          %rcx, %r14
.p2align 4, 0x90
.L__0019gas_1: 
    add          %r14, %r14
    movq         (%rdx,%rbx,8), %r11
    movq         (%rdi,%rbx,8), %r12
    movq         (8)(%rdx,%rbx,8), %r13
    movq         (8)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (8)(%rdx,%rbx,8)
    movq         (16)(%rdx,%rbx,8), %r11
    movq         (16)(%rdi,%rbx,8), %r12
    movq         (24)(%rdx,%rbx,8), %r13
    movq         (24)(%rdi,%rbx,8), %r14
    cmovc        %r12, %r11
    movq         %r11, (16)(%rdx,%rbx,8)
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx,%rbx,8)
    mov          %rcx, %r14
    add          $(4), %rbx
    jnc          .L__0019gas_1
    add          %rcx, %rcx
    movq         (24)(%rsp), %rbx
    movq         (24)(%rdx), %r13
    movq         (24)(%rdi), %r14
    cmovc        %r14, %r13
    movq         %r13, (24)(%rdx)
.Lquitgas_1: 
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size n8_cpMontRedAdc_BNU, .Lfe1-(n8_cpMontRedAdc_BNU)
 
