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
 
.globl _y8_cpDiv_BNU32

 
_y8_cpDiv_BNU32:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(40), %rsp
 
    movslq       %ecx, %rcx
    movslq       %r9d, %r9
.L__000Dgas_1: 
    mov          (-4)(%rdx,%rcx,4), %eax
    test         %eax, %eax
    jnz          .L__000Egas_1
    sub          $(1), %rcx
    jg           .L__000Dgas_1
    add          $(1), %rcx
.L__000Egas_1: 
.L__000Fgas_1: 
    mov          (-4)(%r8,%r9,4), %eax
    test         %eax, %eax
    jnz          .L__0010gas_1
    sub          $(1), %r9
    jg           .L__000Fgas_1
    add          $(1), %r9
.L__0010gas_1: 
    mov          %rdx, %r10
    mov          %rcx, %r11
.Lspec_case1gas_1: 
    cmp          %r9, %rcx
    jae          .Lspec_case2gas_1
    test         %rdi, %rdi
    jz           .Lspec_case1_quitgas_1
    movl         $(0), (%rdi)
    movl         $(1), (%rsi)
.Lspec_case1_quitgas_1: 
    mov          %rcx, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lspec_case2gas_1: 
    cmp          $(1), %r9
    jnz          .Lcommon_casegas_1
    mov          (%r8), %ebx
    xor          %edx, %edx
.Lspec_case2_loopgas_1: 
    mov          (-4)(%r10,%r11,4), %eax
    div          %ebx
    test         %rdi, %rdi
    je           .Lspec_case2_contgas_1
    mov          %eax, (-4)(%rdi,%r11,4)
.Lspec_case2_contgas_1: 
    sub          $(1), %r11
    jg           .Lspec_case2_loopgas_1
    test         %rdi, %rdi
    je           .Lspec_case2_quitgas_1
.L__001Cgas_1: 
    mov          (-4)(%rdi,%rcx,4), %eax
    test         %eax, %eax
    jnz          .L__001Dgas_1
    sub          $(1), %rcx
    jg           .L__001Cgas_1
    add          $(1), %rcx
.L__001Dgas_1: 
    movl         %ecx, (%rsi)
.Lspec_case2_quitgas_1: 
    movl         %edx, (%r10)
    mov          $(1), %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lcommon_casegas_1: 
    xor          %eax, %eax
    mov          %eax, (%r10,%r11,4)
    mov          (-4)(%r8,%r9,4), %eax
    mov          $(32), %ecx
    test         %eax, %eax
    jz           .L__002Egas_1
    xor          %ecx, %ecx
.L__0029gas_1: 
    test         $(4294901760), %eax
    jnz          .L__002Agas_1
    shl          $(16), %eax
    add          $(16), %ecx
.L__002Agas_1: 
    test         $(4278190080), %eax
    jnz          .L__002Bgas_1
    shl          $(8), %eax
    add          $(8), %ecx
.L__002Bgas_1: 
    test         $(4026531840), %eax
    jnz          .L__002Cgas_1
    shl          $(4), %eax
    add          $(4), %ecx
.L__002Cgas_1: 
    test         $(3221225472), %eax
    jnz          .L__002Dgas_1
    shl          $(2), %eax
    add          $(2), %ecx
.L__002Dgas_1: 
    test         $(2147483648), %eax
    jnz          .L__002Egas_1
    add          $(1), %ecx
.L__002Egas_1: 
    test         %ecx, %ecx
    jz           .Ldivisiongas_1
    mov          %r9, %r15
    mov          (-4)(%r8,%r15,4), %r12d
    sub          $(1), %r15
    jz           .L__0030gas_1
.L__002Fgas_1: 
    mov          (-4)(%r8,%r15,4), %r13d
    shld         %cl, %r13d, %r12d
    mov          %r12d, (%r8,%r15,4)
    mov          %r13d, %r12d
    sub          $(1), %r15
    jg           .L__002Fgas_1
.L__0030gas_1: 
    shl          %cl, %r12d
    mov          %r12d, (%r8)
    lea          (1)(%r11), %r15
    mov          (-4)(%r10,%r15,4), %r12d
    sub          $(1), %r15
    jz           .L__0032gas_1
.L__0031gas_1: 
    mov          (-4)(%r10,%r15,4), %r13d
    shld         %cl, %r13d, %r12d
    mov          %r12d, (%r10,%r15,4)
    mov          %r13d, %r12d
    sub          $(1), %r15
    jg           .L__0031gas_1
.L__0032gas_1: 
    shl          %cl, %r12d
    mov          %r12d, (%r10)
.Ldivisiongas_1: 
    mov          (-4)(%r8,%r9,4), %ebx
    mov          %r10, (%rsp)
    mov          %r11, (8)(%rsp)
    sub          %r9, %r11
    mov          %r11, (16)(%rsp)
    lea          (%r10,%r11,4), %r10
.Ldivision_loopgas_1: 
    mov          (-4)(%r10,%r9,4), %rax
    xor          %rdx, %rdx
    div          %rbx
    mov          %rax, %r12
    mov          %rdx, %r13
    mov          (-8)(%r8,%r9,4), %ebp
.Ltune_loopgas_1: 
    mov          $(18446744069414584320), %r15
    and          %rax, %r15
    jne          .Ltunegas_1
    mul          %rbp
    mov          %r13, %r14
    shl          $(32), %r14
    mov          (-8)(%r10,%r9,4), %edx
    or           %r14, %rdx
    cmp          %rdx, %rax
    jbe          .Lmul_and_subgas_1
.Ltunegas_1: 
    sub          $(1), %r12
    add          %ebx, %r13d
    mov          %r12, %rax
    jnc          .Ltune_loopgas_1
.Lmul_and_subgas_1: 
    mov          %r9, %r15
    mov          %r12d, %ebp
    xor          %r13, %r13
    xor          %r14, %r14
    sub          $(2), %r15
    jl           .L__0034gas_1
.L__0033gas_1: 
    mov          (%r13,%r8), %rax
    mul          %rbp
    add          %r14, %rax
    adc          $(0), %rdx
    xor          %r14, %r14
    sub          %rax, (%r13,%r10)
    sbb          %rdx, %r14
    neg          %r14
    add          $(8), %r13
    sub          $(2), %r15
    jge          .L__0033gas_1
    add          $(2), %r15
    jz           .L__0035gas_1
.L__0034gas_1: 
    mov          (%r13,%r8), %eax
    mul          %ebp
    add          %r14d, %eax
    adc          $(0), %edx
    xor          %r14d, %r14d
    sub          %eax, (%r13,%r10)
    sbb          %edx, %r14d
    neg          %r14d
.L__0035gas_1: 
    mov          %r14, %rbp
    sub          %ebp, (%r10,%r9,4)
    jnc          .Lstore_duotationgas_1
    sub          $(1), %r12d
    mov          %r9, %r15
    xor          %rax, %rax
    xor          %r13, %r13
    sub          $(2), %r15
    jl           .L__0037gas_1
    clc
.L__0036gas_1: 
    mov          (%r10,%r13,8), %r14
    mov          (%r8,%r13,8), %rdx
    adc          %rdx, %r14
    mov          %r14, (%r10,%r13,8)
    inc          %r13
    dec          %r15
    dec          %r15
    jge          .L__0036gas_1
    setc         %al
    add          %r13, %r13
    add          $(2), %r15
    jz           .L__0038gas_1
.L__0037gas_1: 
    shr          $(1), %eax
    mov          (%r10,%r13,4), %r14d
    mov          (%r8,%r13,4), %edx
    adc          %edx, %r14d
    mov          %r14d, (%r10,%r13,4)
    setc         %al
    add          $(1), %r13
.L__0038gas_1: 
    add          %eax, (%r10,%r9,4)
.Lstore_duotationgas_1: 
    test         %rdi, %rdi
    jz           .Lcont_division_loopgas_1
    movl         %r12d, (%rdi,%r11,4)
.Lcont_division_loopgas_1: 
    sub          $(4), %r10
    sub          $(1), %r11
    jge          .Ldivision_loopgas_1
    mov          (%rsp), %r10
    mov          (8)(%rsp), %r11
    test         %ecx, %ecx
    jz           .Lstore_resultsgas_1
    mov          %r9, %r15
    push         %r8
    mov          (%r8), %r13d
    sub          $(1), %r15
    jz           .L__003Agas_1
.L__0039gas_1: 
    mov          (4)(%r8), %r12d
    shrd         %cl, %r12d, %r13d
    mov          %r13d, (%r8)
    add          $(4), %r8
    mov          %r12d, %r13d
    sub          $(1), %r15
    jg           .L__0039gas_1
.L__003Agas_1: 
    shr          %cl, %r13d
    mov          %r13d, (%r8)
    pop          %r8
    mov          %r11, %r15
    push         %r10
    mov          (%r10), %r13d
    sub          $(1), %r15
    jz           .L__003Cgas_1
.L__003Bgas_1: 
    mov          (4)(%r10), %r12d
    shrd         %cl, %r12d, %r13d
    mov          %r13d, (%r10)
    add          $(4), %r10
    mov          %r12d, %r13d
    sub          $(1), %r15
    jg           .L__003Bgas_1
.L__003Cgas_1: 
    shr          %cl, %r13d
    mov          %r13d, (%r10)
    pop          %r10
.Lstore_resultsgas_1: 
    test         %rdi, %rdi
    jz           .Lquitgas_1
    mov          (16)(%rsp), %rcx
    add          $(1), %rcx
.L__003Dgas_1: 
    mov          (-4)(%rdi,%rcx,4), %eax
    test         %eax, %eax
    jnz          .L__003Egas_1
    sub          $(1), %rcx
    jg           .L__003Dgas_1
    add          $(1), %rcx
.L__003Egas_1: 
    movl         %ecx, (%rsi)
.Lquitgas_1: 
.L__003Fgas_1: 
    mov          (-4)(%r10,%r11,4), %eax
    test         %eax, %eax
    jnz          .L__0040gas_1
    sub          $(1), %r11
    jg           .L__003Fgas_1
    add          $(1), %r11
.L__0040gas_1: 
    mov          %r11, %rax
    add          $(40), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
