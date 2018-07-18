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
 
Lpoly:
.quad   0xFFFFFFFFFFFFFFFF,         0xFFFFFFFF,                0x0, 0xFFFFFFFF00000001 
 
LRR:
.quad                  0x3, 0xfffffffbffffffff, 0xfffffffffffffffe,        0x4fffffffd 
 
LOne:
.long  1,1,1,1,1,1,1,1 
 
LTwo:
.long  2,2,2,2,2,2,2,2 
 
LThree:
.long  3,3,3,3,3,3,3,3 
.p2align 4, 0x90
 
.globl _n8_p256r1_mul_by_2

 
_n8_p256r1_mul_by_2:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_div_by_2

 
_n8_p256r1_div_by_2:
 
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
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_mul_by_3

 
_n8_p256r1_mul_by_3:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_add

 
_n8_p256r1_add:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_sub

 
_n8_p256r1_sub:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_neg

 
_n8_p256r1_neg:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
p256r1_mmull: 
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
    mov          %r8, %rax
    shl          $(32), %rax
    mov          %r8, %rdx
    shr          $(32), %rdx
    mov          %r8, %rcx
    mov          %r8, %rbp
    xor          %r8, %r8
    sub          %rax, %rcx
    sbb          %rdx, %rbp
    add          %rax, %r9
    adc          %rdx, %r10
    adc          %rcx, %r11
    adc          %rbp, %r12
    adc          $(0), %r13
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
    adc          %rdx, %r13
    adc          $(0), %r8
    mov          %r9, %rax
    shl          $(32), %rax
    mov          %r9, %rdx
    shr          $(32), %rdx
    mov          %r9, %rcx
    mov          %r9, %rbp
    xor          %r9, %r9
    sub          %rax, %rcx
    sbb          %rdx, %rbp
    add          %rax, %r10
    adc          %rdx, %r11
    adc          %rcx, %r12
    adc          %rbp, %r13
    adc          $(0), %r8
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
    adc          %rdx, %r8
    adc          $(0), %r9
    mov          %r10, %rax
    shl          $(32), %rax
    mov          %r10, %rdx
    shr          $(32), %rdx
    mov          %r10, %rcx
    mov          %r10, %rbp
    xor          %r10, %r10
    sub          %rax, %rcx
    sbb          %rdx, %rbp
    add          %rax, %r11
    adc          %rdx, %r12
    adc          %rcx, %r13
    adc          %rbp, %r8
    adc          $(0), %r9
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
    add          %rcx, %r8
    adc          $(0), %rdx
    add          %rax, %r8
    adc          %rdx, %r9
    adc          $(0), %r10
    mov          %r11, %rax
    shl          $(32), %rax
    mov          %r11, %rdx
    shr          $(32), %rdx
    mov          %r11, %rcx
    mov          %r11, %rbp
    xor          %r11, %r11
    sub          %rax, %rcx
    sbb          %rdx, %rbp
    add          %rax, %r12
    adc          %rdx, %r13
    adc          %rcx, %r8
    adc          %rbp, %r9
    adc          $(0), %r10
    movq         Lpoly+0(%rip), %rax
    movq         Lpoly+8(%rip), %rdx
    movq         Lpoly+16(%rip), %rcx
    movq         Lpoly+24(%rip), %rbp
    mov          %r12, %rbx
    mov          %r13, %r11
    mov          %r8, %r14
    mov          %r9, %r15
    sub          %rax, %rbx
    sbb          %rdx, %r11
    sbb          %rcx, %r14
    sbb          %rbp, %r15
    sbb          $(0), %r10
    cmovnc       %rbx, %r12
    cmovnc       %r11, %r13
    cmovnc       %r14, %r8
    cmovnc       %r15, %r9
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    ret
.p2align 4, 0x90
 
.globl _n8_p256r1_mul_montl

 
_n8_p256r1_mul_montl:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    mov          %rdx, %rbx
    call         p256r1_mmull
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_to_mont

 
_n8_p256r1_to_mont:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    lea          LRR(%rip), %rbx
    call         p256r1_mmull
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_sqr_montl

 
_n8_p256r1_sqr_montl:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
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
    mov          %r8, %rcx
    shl          $(32), %rcx
    mov          %r8, %rbp
    shr          $(32), %rbp
    mov          %r8, %rbx
    mov          %r8, %rdx
    xor          %r8, %r8
    sub          %rcx, %rbx
    sbb          %rbp, %rdx
    add          %rcx, %r9
    adc          %rbp, %r10
    adc          %rbx, %r11
    adc          %rdx, %r12
    adc          $(0), %r8
    mov          %r9, %rcx
    shl          $(32), %rcx
    mov          %r9, %rbp
    shr          $(32), %rbp
    mov          %r9, %rbx
    mov          %r9, %rdx
    xor          %r9, %r9
    sub          %rcx, %rbx
    sbb          %rbp, %rdx
    add          %rcx, %r10
    adc          %rbp, %r11
    adc          %rbx, %r12
    adc          %rdx, %r13
    adc          $(0), %r9
    add          %r8, %r13
    adc          $(0), %r9
    mov          %r10, %rcx
    shl          $(32), %rcx
    mov          %r10, %rbp
    shr          $(32), %rbp
    mov          %r10, %rbx
    mov          %r10, %rdx
    xor          %r10, %r10
    sub          %rcx, %rbx
    sbb          %rbp, %rdx
    add          %rcx, %r11
    adc          %rbp, %r12
    adc          %rbx, %r13
    adc          %rdx, %r14
    adc          $(0), %r10
    add          %r9, %r14
    adc          $(0), %r10
    mov          %r11, %rcx
    shl          $(32), %rcx
    mov          %r11, %rbp
    shr          $(32), %rbp
    mov          %r11, %rbx
    mov          %r11, %rdx
    xor          %r11, %r11
    sub          %rcx, %rbx
    sbb          %rbp, %rdx
    add          %rcx, %r12
    adc          %rbp, %r13
    adc          %rbx, %r14
    adc          %rdx, %r15
    adc          $(0), %r11
    add          %r10, %r15
    adc          $(0), %r11
    movq         Lpoly+0(%rip), %rcx
    movq         Lpoly+8(%rip), %rbp
    movq         Lpoly+16(%rip), %rbx
    movq         Lpoly+24(%rip), %rdx
    mov          %r12, %rax
    mov          %r13, %r8
    mov          %r14, %r9
    mov          %r15, %r10
    sub          %rcx, %rax
    sbb          %rbp, %r8
    sbb          %rbx, %r9
    sbb          %rdx, %r10
    sbb          $(0), %r11
    cmovnc       %rax, %r12
    cmovnc       %r8, %r13
    cmovnc       %r9, %r14
    cmovnc       %r10, %r15
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    movq         %r14, (16)(%rdi)
    movq         %r15, (24)(%rdi)
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_mont_back

 
_n8_p256r1_mont_back:
 
    push         %r12
 
    push         %r13
 
    movq         (%rsi), %r10
    movq         (8)(%rsi), %r11
    movq         (16)(%rsi), %r12
    movq         (24)(%rsi), %r13
    xor          %r8, %r8
    xor          %r9, %r9
    mov          %r10, %rax
    shl          $(32), %rax
    mov          %r10, %rdx
    shr          $(32), %rdx
    mov          %r10, %rcx
    mov          %r10, %rsi
    xor          %r10, %r10
    sub          %rax, %rcx
    sbb          %rdx, %rsi
    add          %rax, %r11
    adc          %rdx, %r12
    adc          %rcx, %r13
    adc          %rsi, %r8
    adc          $(0), %r9
    mov          %r11, %rax
    shl          $(32), %rax
    mov          %r11, %rdx
    shr          $(32), %rdx
    mov          %r11, %rcx
    mov          %r11, %rsi
    xor          %r11, %r11
    sub          %rax, %rcx
    sbb          %rdx, %rsi
    add          %rax, %r12
    adc          %rdx, %r13
    adc          %rcx, %r8
    adc          %rsi, %r9
    adc          $(0), %r10
    mov          %r12, %rax
    shl          $(32), %rax
    mov          %r12, %rdx
    shr          $(32), %rdx
    mov          %r12, %rcx
    mov          %r12, %rsi
    xor          %r12, %r12
    sub          %rax, %rcx
    sbb          %rdx, %rsi
    add          %rax, %r13
    adc          %rdx, %r8
    adc          %rcx, %r9
    adc          %rsi, %r10
    adc          $(0), %r11
    mov          %r13, %rax
    shl          $(32), %rax
    mov          %r13, %rdx
    shr          $(32), %rdx
    mov          %r13, %rcx
    mov          %r13, %rsi
    xor          %r13, %r13
    sub          %rax, %rcx
    sbb          %rdx, %rsi
    add          %rax, %r8
    adc          %rdx, %r9
    adc          %rcx, %r10
    adc          %rsi, %r11
    adc          $(0), %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    mov          %r11, %rsi
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbbq         Lpoly+24(%rip), %rsi
    sbb          $(0), %r12
    cmovnc       %rax, %r8
    cmovnc       %rdx, %r9
    cmovnc       %rcx, %r10
    cmovnc       %rsi, %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_select_pp_w5

 
_n8_p256r1_select_pp_w5:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _n8_p256r1_select_ap_w7

 
_n8_p256r1_select_ap_w7:
 
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
 
    pop          %r13
 
    pop          %r12
 
    ret
 
