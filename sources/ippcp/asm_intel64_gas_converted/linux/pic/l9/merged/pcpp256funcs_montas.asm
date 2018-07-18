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
.p2align 5, 0x90
.p2align 5, 0x90
 
.globl l9_gf256_add
.type l9_gf256_add, @function
 
l9_gf256_add:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    xor          %r14, %r14
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    addq         (%rdx), %r8
    adcq         (8)(%rdx), %r9
    adcq         (16)(%rdx), %r10
    adcq         (24)(%rdx), %r11
    adc          $(0), %r14
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %r12
    mov          %r11, %r13
    subq         (%rcx), %rax
    sbbq         (8)(%rcx), %rdx
    sbbq         (16)(%rcx), %r12
    sbbq         (24)(%rcx), %r13
    sbb          $(0), %r14
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %r12, %r10
    cmove        %r13, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    mov          %rdi, %rax
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe1:
.size l9_gf256_add, .Lfe1-(l9_gf256_add)
.p2align 5, 0x90
 
.globl l9_gf256_sub
.type l9_gf256_sub, @function
 
l9_gf256_sub:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    xor          %r14, %r14
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    subq         (%rdx), %r8
    sbbq         (8)(%rdx), %r9
    sbbq         (16)(%rdx), %r10
    sbbq         (24)(%rdx), %r11
    sbb          $(0), %r14
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %r12
    mov          %r11, %r13
    addq         (%rcx), %rax
    adcq         (8)(%rcx), %rdx
    adcq         (16)(%rcx), %r12
    adcq         (24)(%rcx), %r13
    test         %r14, %r14
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %r12, %r10
    cmovne       %r13, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    mov          %rdi, %rax
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe2:
.size l9_gf256_sub, .Lfe2-(l9_gf256_sub)
.p2align 5, 0x90
 
.globl l9_gf256_neg
.type l9_gf256_neg, @function
 
l9_gf256_neg:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    xor          %r14, %r14
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    subq         (%rsi), %r8
    sbbq         (8)(%rsi), %r9
    sbbq         (16)(%rsi), %r10
    sbbq         (24)(%rsi), %r11
    sbb          $(0), %r14
    mov          %r8, %rax
    mov          %r9, %rcx
    mov          %r10, %r12
    mov          %r11, %r13
    addq         (%rdx), %rax
    adcq         (8)(%rdx), %rcx
    adcq         (16)(%rdx), %r12
    adcq         (24)(%rdx), %r13
    test         %r14, %r14
    cmovne       %rax, %r8
    cmovne       %rcx, %r9
    cmovne       %r12, %r10
    cmovne       %r13, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    mov          %rdi, %rax
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe3:
.size l9_gf256_neg, .Lfe3-(l9_gf256_neg)
.p2align 5, 0x90
 
.globl l9_gf256_div2
.type l9_gf256_div2, @function
 
l9_gf256_div2:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    xor          %r14, %r14
    xor          %rsi, %rsi
    mov          %r8, %rax
    mov          %r9, %rcx
    mov          %r10, %r12
    mov          %r11, %r13
    addq         (%rdx), %rax
    adcq         (8)(%rdx), %rcx
    adcq         (16)(%rdx), %r12
    adcq         (24)(%rdx), %r13
    adc          $(0), %r14
    test         $(1), %r8
    cmovne       %rax, %r8
    cmovne       %rcx, %r9
    cmovne       %r12, %r10
    cmovne       %r13, %r11
    cmovne       %r14, %rsi
    shrd         $(1), %r9, %r8
    shrd         $(1), %r10, %r9
    shrd         $(1), %r11, %r10
    shrd         $(1), %rsi, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    mov          %rdi, %rax
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe4:
.size l9_gf256_div2, .Lfe4-(l9_gf256_div2)
.p2align 5, 0x90
 
.globl l9_gf256_mulm
.type l9_gf256_mulm, @function
 
l9_gf256_mulm:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(24), %rsp
 
    movq         %rdi, (%rsp)
    mov          %rdx, %rbx
    mov          %rcx, %rdi
    movq         %r8, (8)(%rsp)
    movq         (%rbx), %r14
    movq         (8)(%rsp), %r15
    movq         (%rsi), %rax
    mul          %r14
    mov          %rax, %r8
    mov          %rdx, %r9
    imul         %r8, %r15
    movq         (8)(%rsi), %rax
    mul          %r14
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (16)(%rsi), %rax
    mul          %r14
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (24)(%rsi), %rax
    mul          %r14
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    xor          %r13, %r13
    movq         (%rdi), %rax
    mul          %r15
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (8)(%rdi), %rax
    mul          %r15
    add          %r8, %r9
    adc          $(0), %rdx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (16)(%rdi), %rax
    mul          %r15
    add          %r8, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (24)(%rdi), %rax
    mul          %r15
    add          %r8, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rdx, %r12
    adc          $(0), %r13
    xor          %r8, %r8
    movq         (8)(%rbx), %r14
    movq         (8)(%rsp), %r15
    movq         (%rsi), %rax
    mul          %r14
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %rcx
    imul         %r9, %r15
    movq         (8)(%rsi), %rax
    mul          %r14
    add          %rcx, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rsi), %rax
    mul          %r14
    add          %rcx, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rsi), %rax
    mul          %r14
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r8
    movq         (%rdi), %rax
    mul          %r15
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (8)(%rdi), %rax
    mul          %r15
    add          %r9, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (16)(%rdi), %rax
    mul          %r15
    add          %r9, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (24)(%rdi), %rax
    mul          %r15
    add          %r9, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rdx, %r13
    adc          $(0), %r8
    xor          %r9, %r9
    movq         (16)(%rbx), %r14
    movq         (8)(%rsp), %r15
    movq         (%rsi), %rax
    mul          %r14
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rcx
    imul         %r10, %r15
    movq         (8)(%rsi), %rax
    mul          %r14
    add          %rcx, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rsi), %rax
    mul          %r14
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rsi), %rax
    mul          %r14
    add          %rcx, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          %rdx, %r8
    adc          $(0), %r9
    movq         (%rdi), %rax
    mul          %r15
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (8)(%rdi), %rax
    mul          %r15
    add          %r10, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (16)(%rdi), %rax
    mul          %r15
    add          %r10, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (24)(%rdi), %rax
    mul          %r15
    add          %r10, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rdx, %r8
    adc          $(0), %r9
    xor          %r10, %r10
    movq         (24)(%rbx), %r14
    movq         (8)(%rsp), %r15
    movq         (%rsi), %rax
    mul          %r14
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    imul         %r11, %r15
    movq         (8)(%rsi), %rax
    mul          %r14
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rsi), %rax
    mul          %r14
    add          %rcx, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rsi), %rax
    mul          %r14
    add          %rcx, %r8
    adc          $(0), %rdx
    add          %rax, %r8
    adc          %rdx, %r9
    adc          $(0), %r10
    movq         (%rdi), %rax
    mul          %r15
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (8)(%rdi), %rax
    mul          %r15
    add          %r11, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (16)(%rdi), %rax
    mul          %r15
    add          %r11, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (24)(%rdi), %rax
    mul          %r15
    add          %r11, %r8
    adc          $(0), %rdx
    add          %rax, %r8
    adc          $(0), %rdx
    add          %rdx, %r9
    adc          $(0), %r10
    xor          %r11, %r11
    movq         (%rsp), %rsi
    mov          %r12, %rax
    mov          %r13, %rbx
    mov          %r8, %rcx
    mov          %r9, %rdx
    subq         (%rdi), %rax
    sbbq         (8)(%rdi), %rbx
    sbbq         (16)(%rdi), %rcx
    sbbq         (24)(%rdi), %rdx
    sbb          $(0), %r10
    cmovnc       %rax, %r12
    cmovnc       %rbx, %r13
    cmovnc       %rcx, %r8
    cmovnc       %rdx, %r9
    movq         %r12, (%rsi)
    movq         %r13, (8)(%rsi)
    movq         %r8, (16)(%rsi)
    movq         %r9, (24)(%rsi)
    mov          %rsi, %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe5:
.size l9_gf256_mulm, .Lfe5-(l9_gf256_mulm)
.p2align 5, 0x90
 
.globl l9_gf256_sqrm
.type l9_gf256_sqrm, @function
 
l9_gf256_sqrm:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(24), %rsp
 
    movq         %rdi, (%rsp)
    mov          %rdx, %rdi
    movq         %rcx, (8)(%rsp)
    movq         (%rsi), %rbx
    movq         (8)(%rsi), %rax
    mul          %rbx
    mov          %rax, %r9
    mov          %rdx, %r10
    movq         (16)(%rsi), %rax
    mul          %rbx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (24)(%rsi), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    movq         (8)(%rsi), %rbx
    movq         (16)(%rsi), %rax
    mul          %rbx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rbp
    movq         (24)(%rsi), %rax
    mul          %rbx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rbp, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    movq         (16)(%rsi), %rbx
    movq         (24)(%rsi), %rax
    mul          %rbx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    xor          %r15, %r15
    shld         $(1), %r14, %r15
    shld         $(1), %r13, %r14
    shld         $(1), %r12, %r13
    shld         $(1), %r11, %r12
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    shl          $(1), %r9
    movq         (%rsi), %rax
    mul          %rax
    mov          %rax, %r8
    add          %rdx, %r9
    adc          $(0), %r10
    movq         (8)(%rsi), %rax
    mul          %rax
    add          %rax, %r10
    adc          %rdx, %r11
    adc          $(0), %r12
    movq         (16)(%rsi), %rax
    mul          %rax
    add          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %r14
    movq         (24)(%rsi), %rax
    mul          %rax
    add          %rax, %r14
    adc          %rdx, %r15
    movq         (8)(%rsp), %rcx
    imul         %r8, %rcx
    movq         (%rdi), %rax
    mul          %rcx
    add          %rax, %r8
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (8)(%rdi), %rax
    mul          %rcx
    add          %r8, %r9
    adc          $(0), %rdx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (16)(%rdi), %rax
    mul          %rcx
    add          %r8, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r8
    movq         (24)(%rdi), %rax
    mul          %rcx
    add          %r8, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    add          %rdx, %r12
    adc          $(0), %r13
    xor          %r8, %r8
    movq         (8)(%rsp), %rcx
    imul         %r9, %rcx
    movq         (%rdi), %rax
    mul          %rcx
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (8)(%rdi), %rax
    mul          %rcx
    add          %r9, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (16)(%rdi), %rax
    mul          %rcx
    add          %r9, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r9
    movq         (24)(%rdi), %rax
    mul          %rcx
    add          %r9, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    add          %rdx, %r13
    adc          $(0), %r14
    xor          %r9, %r9
    movq         (8)(%rsp), %rcx
    imul         %r10, %rcx
    movq         (%rdi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (8)(%rdi), %rax
    mul          %rcx
    add          %r10, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (16)(%rdi), %rax
    mul          %rcx
    add          %r10, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (24)(%rdi), %rax
    mul          %rcx
    add          %r10, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    add          %rdx, %r14
    adc          $(0), %r15
    xor          %r10, %r10
    movq         (8)(%rsp), %rcx
    imul         %r11, %rcx
    movq         (%rdi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (8)(%rdi), %rax
    mul          %rcx
    add          %r11, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (16)(%rdi), %rax
    mul          %rcx
    add          %r11, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (24)(%rdi), %rax
    mul          %rcx
    add          %r11, %r14
    adc          $(0), %rdx
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rdx, %r15
    adc          $(0), %r8
    xor          %r11, %r11
    movq         (%rsp), %rsi
    mov          %r12, %rax
    mov          %r13, %rbx
    mov          %r14, %rcx
    mov          %r15, %rdx
    subq         (%rdi), %rax
    sbbq         (8)(%rdi), %rbx
    sbbq         (16)(%rdi), %rcx
    sbbq         (24)(%rdi), %rdx
    sbb          $(0), %r8
    cmovnc       %rax, %r12
    cmovnc       %rbx, %r13
    cmovnc       %rcx, %r14
    cmovnc       %rdx, %r15
    movq         %r12, (%rsi)
    movq         %r13, (8)(%rsi)
    movq         %r14, (16)(%rsi)
    movq         %r15, (24)(%rsi)
    mov          %rsi, %rax
    add          $(24), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe6:
.size l9_gf256_sqrm, .Lfe6-(l9_gf256_sqrm)
 
