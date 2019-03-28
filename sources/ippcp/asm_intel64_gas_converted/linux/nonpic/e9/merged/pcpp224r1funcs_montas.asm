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
 
Lpoly:
.quad                  0x1, 0xffffffff00000000, 0xffffffffffffffff,         0xffffffff 
 
LRR:
.quad   0xffffffff00000001, 0xffffffff00000000, 0xfffffffe00000000,         0xffffffff 
 
LOne:
.long  1,1,1,1,1,1,1,1 
 
LTwo:
.long  2,2,2,2,2,2,2,2 
 
LThree:
.long  3,3,3,3,3,3,3,3 
.p2align 5, 0x90
 
.globl e9_p224r1_mul_by_2
.type e9_p224r1_mul_by_2, @function
 
e9_p224r1_mul_by_2:
 
    push         %r12
 
    push         %r13
 
    xor          %r13, %r13
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    shld         $(1), %r11, %r13
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbbq         Lpoly+24(%rip), %r12
    sbb          $(0), %r13
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    cmove        %r12, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe1:
.size e9_p224r1_mul_by_2, .Lfe1-(e9_p224r1_mul_by_2)
.p2align 5, 0x90
 
.globl e9_p224r1_div_by_2
.type e9_p224r1_div_by_2, @function
 
e9_p224r1_div_by_2:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    xor          %r13, %r13
    xor          %r14, %r14
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    adcq         Lpoly+24(%rip), %r12
    adc          $(0), %r13
    test         $(1), %r8
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    cmovne       %r12, %r11
    cmovne       %r13, %r14
    shrd         $(1), %r9, %r8
    shrd         $(1), %r10, %r9
    shrd         $(1), %r11, %r10
    shrd         $(1), %r14, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe2:
.size e9_p224r1_div_by_2, .Lfe2-(e9_p224r1_div_by_2)
.p2align 5, 0x90
 
.globl e9_p224r1_mul_by_3
.type e9_p224r1_mul_by_3, @function
 
e9_p224r1_mul_by_3:
 
    push         %r12
 
    push         %r13
 
    xor          %r13, %r13
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    shld         $(1), %r11, %r13
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbbq         Lpoly+24(%rip), %r12
    sbb          $(0), %r13
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    cmove        %r12, %r11
    xor          %r13, %r13
    addq         (%rsi), %r8
    adcq         (8)(%rsi), %r9
    adcq         (16)(%rsi), %r10
    adcq         (24)(%rsi), %r11
    adc          $(0), %r13
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbbq         Lpoly+24(%rip), %r12
    sbb          $(0), %r13
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    cmove        %r12, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe3:
.size e9_p224r1_mul_by_3, .Lfe3-(e9_p224r1_mul_by_3)
.p2align 5, 0x90
 
.globl e9_p224r1_add
.type e9_p224r1_add, @function
 
e9_p224r1_add:
 
    push         %r12
 
    push         %r13
 
    xor          %r13, %r13
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    addq         (%rdx), %r8
    adcq         (8)(%rdx), %r9
    adcq         (16)(%rdx), %r10
    adcq         (24)(%rdx), %r11
    adc          $(0), %r13
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbbq         Lpoly+24(%rip), %r12
    sbb          $(0), %r13
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    cmove        %r12, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe4:
.size e9_p224r1_add, .Lfe4-(e9_p224r1_add)
.p2align 5, 0x90
 
.globl e9_p224r1_sub
.type e9_p224r1_sub, @function
 
e9_p224r1_sub:
 
    push         %r12
 
    push         %r13
 
    xor          %r13, %r13
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    subq         (%rdx), %r8
    sbbq         (8)(%rdx), %r9
    sbbq         (16)(%rdx), %r10
    sbbq         (24)(%rdx), %r11
    sbb          $(0), %r13
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    adcq         Lpoly+24(%rip), %r12
    test         %r13, %r13
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    cmovne       %r12, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe5:
.size e9_p224r1_sub, .Lfe5-(e9_p224r1_sub)
.p2align 5, 0x90
 
.globl e9_p224r1_neg
.type e9_p224r1_neg, @function
 
e9_p224r1_neg:
 
    push         %r12
 
    push         %r13
 
    xor          %r13, %r13
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    subq         (%rsi), %r8
    sbbq         (8)(%rsi), %r9
    sbbq         (16)(%rsi), %r10
    sbbq         (24)(%rsi), %r11
    sbb          $(0), %r13
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %r12
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    adcq         Lpoly+24(%rip), %r12
    test         %r13, %r13
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    cmovne       %r12, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe6:
.size e9_p224r1_neg, .Lfe6-(e9_p224r1_neg)
.p2align 5, 0x90
p224r1_mmull: 
    xor          %r13, %r13
    movq         (%rbx), %rax
    mulq         (%rsi)
    mov          %rax, %r8
    mov          %rdx, %r9
    movq         (%rbx), %rax
    mulq         (8)(%rsi)
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %r10
    movq         (%rbx), %rax
    mulq         (16)(%rsi)
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (%rbx), %rax
    mulq         (24)(%rsi)
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    neg          %r8
    mov          %r8, %rcx
    mov          %r8, %rbp
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rbp
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rbp, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rbp
    neg          %r8
    adc          %rax, %r9
    adc          %rdx, %r10
    adc          %rcx, %r11
    adc          %rbp, %r12
    movq         (8)(%rbx), %rax
    mulq         (%rsi)
    add          %rax, %r9
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (8)(%rbx), %rax
    mulq         (8)(%rsi)
    add          %rcx, %r10
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (8)(%rbx), %rax
    mulq         (16)(%rsi)
    add          %rcx, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (8)(%rbx), %rax
    mulq         (24)(%rsi)
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %r13
    neg          %r9
    mov          %r9, %rcx
    mov          %r9, %rbp
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rbp
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rbp, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rbp
    neg          %r9
    adc          %rax, %r10
    adc          %rdx, %r11
    adc          %rcx, %r12
    adc          %rbp, %r13
    movq         (16)(%rbx), %rax
    mulq         (%rsi)
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rbx), %rax
    mulq         (8)(%rsi)
    add          %rcx, %r11
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rbx), %rax
    mulq         (16)(%rsi)
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (16)(%rbx), %rax
    mulq         (24)(%rsi)
    add          %rcx, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %r14
    neg          %r10
    mov          %r10, %rcx
    mov          %r10, %rbp
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rbp
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rbp, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rbp
    neg          %r10
    adc          %rax, %r11
    adc          %rdx, %r12
    adc          %rcx, %r13
    adc          %rbp, %r14
    movq         (24)(%rbx), %rax
    mulq         (%rsi)
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rbx), %rax
    mulq         (8)(%rsi)
    add          %rcx, %r12
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rbx), %rax
    mulq         (16)(%rsi)
    add          %rcx, %r13
    adc          $(0), %rdx
    add          %rax, %r13
    adc          $(0), %rdx
    mov          %rdx, %rcx
    movq         (24)(%rbx), %rax
    mulq         (24)(%rsi)
    add          %rcx, %r14
    adc          $(0), %rdx
    add          %rax, %r14
    adc          $(0), %rdx
    mov          %rdx, %r15
    neg          %r11
    mov          %r11, %rcx
    mov          %r11, %rbp
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rbp
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rbp, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rbp
    neg          %r11
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          %rcx, %r14
    adc          %rbp, %r15
    movq         Lpoly+0(%rip), %rax
    movq         Lpoly+8(%rip), %rdx
    movq         Lpoly+16(%rip), %rcx
    movq         Lpoly+24(%rip), %rbp
    mov          %r12, %r8
    mov          %r13, %r9
    mov          %r14, %r10
    mov          %r15, %r11
    sub          %rax, %r12
    sbb          %rdx, %r13
    sbb          %rcx, %r14
    sbb          %rbp, %r15
    cmovc        %r8, %r12
    cmovc        %r9, %r13
    cmovc        %r10, %r14
    cmovc        %r11, %r15
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    movq         %r14, (16)(%rdi)
    movq         %r15, (24)(%rdi)
    ret
 
.globl e9_p224r1_mul_montl
.type e9_p224r1_mul_montl, @function
 
e9_p224r1_mul_montl:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    mov          %rdx, %rbx
    call         p224r1_mmull
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
.Lfe7:
.size e9_p224r1_mul_montl, .Lfe7-(e9_p224r1_mul_montl)
.p2align 5, 0x90
 
.globl e9_p224r1_to_mont
.type e9_p224r1_to_mont, @function
 
e9_p224r1_to_mont:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    lea          LRR(%rip), %rbx
    call         p224r1_mmull
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
.Lfe8:
.size e9_p224r1_to_mont, .Lfe8-(e9_p224r1_to_mont)
.p2align 5, 0x90
 
.globl e9_p224r1_sqr_montl
.type e9_p224r1_sqr_montl, @function
 
e9_p224r1_sqr_montl:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    mov          %rsi, %rbx
    call         p224r1_mmull
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
.Lfe9:
.size e9_p224r1_sqr_montl, .Lfe9-(e9_p224r1_sqr_montl)
.p2align 5, 0x90
 
.globl e9_p224r1_mont_back
.type e9_p224r1_mont_back, @function
 
e9_p224r1_mont_back:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    xor          %r12, %r12
    xor          %r13, %r13
    xor          %r14, %r14
    xor          %r15, %r15
    neg          %r8
    mov          %r8, %rcx
    mov          %r8, %rsi
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rsi
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rsi, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rsi
    neg          %r8
    adc          %rax, %r9
    adc          %rdx, %r10
    adc          %rcx, %r11
    adc          %rsi, %r12
    neg          %r9
    mov          %r9, %rcx
    mov          %r9, %rsi
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rsi
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rsi, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rsi
    neg          %r9
    adc          %rax, %r10
    adc          %rdx, %r11
    adc          %rcx, %r12
    adc          %rsi, %r13
    neg          %r10
    mov          %r10, %rcx
    mov          %r10, %rsi
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rsi
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rsi, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rsi
    neg          %r10
    adc          %rax, %r11
    adc          %rdx, %r12
    adc          %rcx, %r13
    adc          %rsi, %r14
    neg          %r11
    mov          %r11, %rcx
    mov          %r11, %rsi
    xor          %rax, %rax
    xor          %rdx, %rdx
    shr          $(32), %rsi
    shl          $(32), %rcx
    sub          %rcx, %rax
    sbb          %rsi, %rdx
    sbb          $(0), %rcx
    sbb          $(0), %rsi
    neg          %r11
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          %rcx, %r14
    adc          %rsi, %r15
    mov          %r12, %r8
    mov          %r13, %r9
    mov          %r14, %r10
    mov          %r15, %r11
    subq         Lpoly+0(%rip), %r12
    sbbq         Lpoly+8(%rip), %r13
    sbbq         Lpoly+16(%rip), %r14
    sbbq         Lpoly+24(%rip), %r15
    cmovc        %r8, %r12
    cmovc        %r9, %r13
    cmovc        %r10, %r14
    cmovc        %r11, %r15
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    movq         %r14, (16)(%rdi)
    movq         %r15, (24)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe10:
.size e9_p224r1_mont_back, .Lfe10-(e9_p224r1_mont_back)
.p2align 5, 0x90
 
.globl e9_p224r1_select_pp_w5
.type e9_p224r1_select_pp_w5, @function
 
e9_p224r1_select_pp_w5:
 
    push         %r12
 
    push         %r13
 
    movdqa       LOne(%rip), %xmm0
    movdqa       %xmm0, %xmm8
    movd         %edx, %xmm1
    pshufd       $(0), %xmm1, %xmm1
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    pxor         %xmm6, %xmm6
    pxor         %xmm7, %xmm7
    mov          $(16), %rcx
.Lselect_loop_sse_w5gas_11: 
    movdqa       %xmm8, %xmm15
    pcmpeqd      %xmm1, %xmm15
    paddd        %xmm0, %xmm8
    movdqa       (%rsi), %xmm9
    movdqa       (16)(%rsi), %xmm10
    movdqa       (32)(%rsi), %xmm11
    movdqa       (48)(%rsi), %xmm12
    movdqa       (64)(%rsi), %xmm13
    movdqa       (80)(%rsi), %xmm14
    add          $(96), %rsi
    pand         %xmm15, %xmm9
    pand         %xmm15, %xmm10
    pand         %xmm15, %xmm11
    pand         %xmm15, %xmm12
    pand         %xmm15, %xmm13
    pand         %xmm15, %xmm14
    por          %xmm9, %xmm2
    por          %xmm10, %xmm3
    por          %xmm11, %xmm4
    por          %xmm12, %xmm5
    por          %xmm13, %xmm6
    por          %xmm14, %xmm7
    dec          %rcx
    jnz          .Lselect_loop_sse_w5gas_11
    movdqu       %xmm2, (%rdi)
    movdqu       %xmm3, (16)(%rdi)
    movdqu       %xmm4, (32)(%rdi)
    movdqu       %xmm5, (48)(%rdi)
    movdqu       %xmm6, (64)(%rdi)
    movdqu       %xmm7, (80)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe11:
.size e9_p224r1_select_pp_w5, .Lfe11-(e9_p224r1_select_pp_w5)
.p2align 5, 0x90
 
.globl e9_p224r1_select_ap_w7
.type e9_p224r1_select_ap_w7, @function
 
e9_p224r1_select_ap_w7:
 
    push         %r12
 
    push         %r13
 
    movdqa       LOne(%rip), %xmm0
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    movdqa       %xmm0, %xmm8
    movd         %edx, %xmm1
    pshufd       $(0), %xmm1, %xmm1
    mov          $(64), %rcx
.Lselect_loop_sse_w7gas_12: 
    movdqa       %xmm8, %xmm15
    pcmpeqd      %xmm1, %xmm15
    paddd        %xmm0, %xmm8
    movdqa       (%rsi), %xmm9
    movdqa       (16)(%rsi), %xmm10
    movdqa       (32)(%rsi), %xmm11
    movdqa       (48)(%rsi), %xmm12
    add          $(64), %rsi
    pand         %xmm15, %xmm9
    pand         %xmm15, %xmm10
    pand         %xmm15, %xmm11
    pand         %xmm15, %xmm12
    por          %xmm9, %xmm2
    por          %xmm10, %xmm3
    por          %xmm11, %xmm4
    por          %xmm12, %xmm5
    dec          %rcx
    jnz          .Lselect_loop_sse_w7gas_12
    movdqu       %xmm2, (%rdi)
    movdqu       %xmm3, (16)(%rdi)
    movdqu       %xmm4, (32)(%rdi)
    movdqu       %xmm5, (48)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe12:
.size e9_p224r1_select_ap_w7, .Lfe12-(e9_p224r1_select_ap_w7)
 
