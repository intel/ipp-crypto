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
 
Lpoly:
.quad           0xffffffff, 0xffffffff00000000, 0xfffffffffffffffe 
 

.quad   0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff 
 
LOne:
.long  1,1,1,1,1,1,1,1 
 
LTwo:
.long  2,2,2,2,2,2,2,2 
 
LThree:
.long  3,3,3,3,3,3,3,3 
.p2align 6, 0x90
 
.globl p384r1_mul_by_2
.type p384r1_mul_by_2, @function
 
p384r1_mul_by_2:
 
    push         %r12
 
    xor          %r11, %r11
    movq         (%rsi), %rax
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rdx
    movq         (24)(%rsi), %r8
    movq         (32)(%rsi), %r9
    movq         (40)(%rsi), %r10
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    movq         %r10, (40)(%rdi)
    shld         $(1), %r8, %r9
    movq         %r9, (32)(%rdi)
    shld         $(1), %rdx, %r8
    movq         %r8, (24)(%rdi)
    shld         $(1), %rcx, %rdx
    movq         %rdx, (16)(%rdi)
    shld         $(1), %rax, %rcx
    movq         %rcx, (8)(%rdi)
    shl          $(1), %rax
    movq         %rax, (%rdi)
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rcx
    sbbq         Lpoly+16(%rip), %rdx
    sbbq         Lpoly+24(%rip), %r8
    sbbq         Lpoly+32(%rip), %r9
    sbbq         Lpoly+40(%rip), %r10
    sbb          $(0), %r11
    movq         (%rdi), %r12
    cmovne       %r12, %rax
    movq         (8)(%rdi), %r12
    cmovne       %r12, %rcx
    movq         (16)(%rdi), %r12
    cmovne       %r12, %rdx
    movq         (24)(%rdi), %r12
    cmovne       %r12, %r8
    movq         (32)(%rdi), %r12
    cmovne       %r12, %r9
    movq         (40)(%rdi), %r12
    cmovne       %r12, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rdx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
 
    pop          %r12
 
    ret
.Lfe1:
.size p384r1_mul_by_2, .Lfe1-(p384r1_mul_by_2)
.p2align 6, 0x90
 
.globl p384r1_div_by_2
.type p384r1_div_by_2, @function
 
p384r1_div_by_2:
 
    push         %r12
 
    movq         (%rsi), %rax
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rdx
    movq         (24)(%rsi), %r8
    movq         (32)(%rsi), %r9
    movq         (40)(%rsi), %r10
    xor          %r12, %r12
    xor          %r11, %r11
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rcx
    adcq         Lpoly+16(%rip), %rdx
    adcq         Lpoly+24(%rip), %r8
    adcq         Lpoly+32(%rip), %r9
    adcq         Lpoly+40(%rip), %r10
    adc          $(0), %r11
    test         $(1), %rax
    cmovne       %r12, %r11
    movq         (%rsi), %r12
    cmovne       %r12, %rax
    movq         (8)(%rsi), %r12
    cmovne       %r12, %rcx
    movq         (16)(%rsi), %r12
    cmovne       %r12, %rdx
    movq         (24)(%rsi), %r12
    cmovne       %r12, %r8
    movq         (32)(%rsi), %r12
    cmovne       %r12, %r9
    movq         (40)(%rsi), %r12
    cmovne       %r12, %r10
    shrd         $(1), %rcx, %rax
    shrd         $(1), %rdx, %rcx
    shrd         $(1), %r8, %rdx
    shrd         $(1), %r9, %r8
    shrd         $(1), %r10, %r9
    shrd         $(1), %r11, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rdx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
 
    pop          %r12
 
    ret
.Lfe2:
.size p384r1_div_by_2, .Lfe2-(p384r1_div_by_2)
.p2align 6, 0x90
 
.globl p384r1_mul_by_3
.type p384r1_mul_by_3, @function
 
p384r1_mul_by_3:
 
    push         %r12
 
    push         %r13
 
    sub          $(56), %rsp
 
    xor          %r11, %r11
    movq         (%rsi), %rax
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rdx
    movq         (24)(%rsi), %r8
    movq         (32)(%rsi), %r9
    movq         (40)(%rsi), %r10
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    movq         %r10, (40)(%rsp)
    shld         $(1), %r8, %r9
    movq         %r9, (32)(%rsp)
    shld         $(1), %rdx, %r8
    movq         %r8, (24)(%rsp)
    shld         $(1), %rcx, %rdx
    movq         %rdx, (16)(%rsp)
    shld         $(1), %rax, %rcx
    movq         %rcx, (8)(%rsp)
    shl          $(1), %rax
    movq         %rax, (%rsp)
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rcx
    sbbq         Lpoly+16(%rip), %rdx
    sbbq         Lpoly+24(%rip), %r8
    sbbq         Lpoly+32(%rip), %r9
    sbbq         Lpoly+40(%rip), %r10
    sbb          $(0), %r11
    movq         (%rsp), %r12
    cmovb        %r12, %rax
    movq         (8)(%rsp), %r12
    cmovb        %r12, %rcx
    movq         (16)(%rsp), %r12
    cmovb        %r12, %rdx
    movq         (24)(%rsp), %r12
    cmovb        %r12, %r8
    movq         (32)(%rsp), %r12
    cmovb        %r12, %r9
    movq         (40)(%rsp), %r12
    cmovb        %r12, %r10
    xor          %r11, %r11
    addq         (%rsi), %rax
    movq         %rax, (%rsp)
    adcq         (8)(%rsi), %rcx
    movq         %rcx, (8)(%rsp)
    adcq         (16)(%rsi), %rdx
    movq         %rdx, (16)(%rsp)
    adcq         (24)(%rsi), %r8
    movq         %r8, (24)(%rsp)
    adcq         (32)(%rsi), %r9
    movq         %r9, (32)(%rsp)
    adcq         (40)(%rsi), %r10
    movq         %r10, (40)(%rsp)
    adc          $(0), %r11
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rcx
    sbbq         Lpoly+16(%rip), %rdx
    sbbq         Lpoly+24(%rip), %r8
    sbbq         Lpoly+32(%rip), %r9
    sbbq         Lpoly+40(%rip), %r10
    sbb          $(0), %r11
    movq         (%rsp), %r12
    cmovb        %r12, %rax
    movq         (8)(%rsp), %r12
    cmovb        %r12, %rcx
    movq         (16)(%rsp), %r12
    cmovb        %r12, %rdx
    movq         (24)(%rsp), %r12
    cmovb        %r12, %r8
    movq         (32)(%rsp), %r12
    cmovb        %r12, %r9
    movq         (40)(%rsp), %r12
    cmovb        %r12, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rdx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    add          $(56), %rsp
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe3:
.size p384r1_mul_by_3, .Lfe3-(p384r1_mul_by_3)
.p2align 6, 0x90
 
.globl p384r1_add
.type p384r1_add, @function
 
p384r1_add:
 
    push         %rbx
 
    push         %r12
 
    xor          %r11, %r11
    movq         (%rsi), %rax
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rbx
    movq         (24)(%rsi), %r8
    movq         (32)(%rsi), %r9
    movq         (40)(%rsi), %r10
    addq         (%rdx), %rax
    adcq         (8)(%rdx), %rcx
    adcq         (16)(%rdx), %rbx
    adcq         (24)(%rdx), %r8
    adcq         (32)(%rdx), %r9
    adcq         (40)(%rdx), %r10
    adc          $(0), %r11
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rbx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rcx
    sbbq         Lpoly+16(%rip), %rbx
    sbbq         Lpoly+24(%rip), %r8
    sbbq         Lpoly+32(%rip), %r9
    sbbq         Lpoly+40(%rip), %r10
    sbb          $(0), %r11
    movq         (%rdi), %r12
    cmovb        %r12, %rax
    movq         (8)(%rdi), %r12
    cmovb        %r12, %rcx
    movq         (16)(%rdi), %r12
    cmovb        %r12, %rbx
    movq         (24)(%rdi), %r12
    cmovb        %r12, %r8
    movq         (32)(%rdi), %r12
    cmovb        %r12, %r9
    movq         (40)(%rdi), %r12
    cmovb        %r12, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rbx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lfe4:
.size p384r1_add, .Lfe4-(p384r1_add)
.p2align 6, 0x90
 
.globl p384r1_sub
.type p384r1_sub, @function
 
p384r1_sub:
 
    push         %rbx
 
    push         %r12
 
    xor          %r11, %r11
    movq         (%rsi), %rax
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rbx
    movq         (24)(%rsi), %r8
    movq         (32)(%rsi), %r9
    movq         (40)(%rsi), %r10
    subq         (%rdx), %rax
    sbbq         (8)(%rdx), %rcx
    sbbq         (16)(%rdx), %rbx
    sbbq         (24)(%rdx), %r8
    sbbq         (32)(%rdx), %r9
    sbbq         (40)(%rdx), %r10
    sbb          $(0), %r11
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rbx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rcx
    adcq         Lpoly+16(%rip), %rbx
    adcq         Lpoly+24(%rip), %r8
    adcq         Lpoly+32(%rip), %r9
    adcq         Lpoly+40(%rip), %r10
    test         %r11, %r11
    movq         (%rdi), %r12
    cmove        %r12, %rax
    movq         (8)(%rdi), %r12
    cmove        %r12, %rcx
    movq         (16)(%rdi), %r12
    cmove        %r12, %rbx
    movq         (24)(%rdi), %r12
    cmove        %r12, %r8
    movq         (32)(%rdi), %r12
    cmove        %r12, %r9
    movq         (40)(%rdi), %r12
    cmove        %r12, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rbx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lfe5:
.size p384r1_sub, .Lfe5-(p384r1_sub)
.p2align 6, 0x90
 
.globl p384r1_neg
.type p384r1_neg, @function
 
p384r1_neg:
 
    push         %r12
 
    xor          %r11, %r11
    xor          %rax, %rax
    xor          %rcx, %rcx
    xor          %rdx, %rdx
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    subq         (%rsi), %rax
    sbbq         (8)(%rsi), %rcx
    sbbq         (16)(%rsi), %rdx
    sbbq         (24)(%rsi), %r8
    sbbq         (32)(%rsi), %r9
    sbbq         (40)(%rsi), %r10
    sbb          $(0), %r11
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rdx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rcx
    adcq         Lpoly+16(%rip), %rdx
    adcq         Lpoly+24(%rip), %r8
    adcq         Lpoly+32(%rip), %r9
    adcq         Lpoly+40(%rip), %r10
    test         %r11, %r11
    movq         (%rdi), %r12
    cmove        %r12, %rax
    movq         (8)(%rdi), %r12
    cmove        %r12, %rcx
    movq         (16)(%rdi), %r12
    cmove        %r12, %rdx
    movq         (24)(%rdi), %r12
    cmove        %r12, %r8
    movq         (32)(%rdi), %r12
    cmove        %r12, %r9
    movq         (40)(%rdi), %r12
    cmove        %r12, %r10
    movq         %rax, (%rdi)
    movq         %rcx, (8)(%rdi)
    movq         %rdx, (16)(%rdi)
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
 
    pop          %r12
 
    ret
.Lfe6:
.size p384r1_neg, .Lfe6-(p384r1_neg)
.p2align 6, 0x90
 
.globl p384r1_mred
.type p384r1_mred, @function
 
p384r1_mred:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    xor          %rdx, %rdx
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    mov          %r8, %rax
    shl          $(32), %rax
    add          %r8, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r8
    pop          %rcx
    adc          %r15, %r9
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r9
    mov          $(0), %rcx
    sbb          %r15, %r10
    adc          $(0), %rcx
    sub          %rax, %r10
    adc          $(0), %rcx
    sub          %rcx, %r11
    sbb          $(0), %r12
    sbb          $(0), %r13
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r14
    adc          $(0), %rdx
    movq         (56)(%rsi), %r8
    mov          %r9, %rax
    shl          $(32), %rax
    add          %r9, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r9
    pop          %rcx
    adc          %r15, %r10
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r10
    mov          $(0), %rcx
    sbb          %r15, %r11
    adc          $(0), %rcx
    sub          %rax, %r11
    adc          $(0), %rcx
    sub          %rcx, %r12
    sbb          $(0), %r13
    sbb          $(0), %r14
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r8
    adc          $(0), %rdx
    movq         (64)(%rsi), %r9
    mov          %r10, %rax
    shl          $(32), %rax
    add          %r10, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r10
    pop          %rcx
    adc          %r15, %r11
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r11
    mov          $(0), %rcx
    sbb          %r15, %r12
    adc          $(0), %rcx
    sub          %rax, %r12
    adc          $(0), %rcx
    sub          %rcx, %r13
    sbb          $(0), %r14
    sbb          $(0), %r8
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r9
    adc          $(0), %rdx
    movq         (72)(%rsi), %r10
    mov          %r11, %rax
    shl          $(32), %rax
    add          %r11, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r11
    pop          %rcx
    adc          %r15, %r12
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r12
    mov          $(0), %rcx
    sbb          %r15, %r13
    adc          $(0), %rcx
    sub          %rax, %r13
    adc          $(0), %rcx
    sub          %rcx, %r14
    sbb          $(0), %r8
    sbb          $(0), %r9
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r10
    adc          $(0), %rdx
    movq         (80)(%rsi), %r11
    mov          %r12, %rax
    shl          $(32), %rax
    add          %r12, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r12
    pop          %rcx
    adc          %r15, %r13
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r13
    mov          $(0), %rcx
    sbb          %r15, %r14
    adc          $(0), %rcx
    sub          %rax, %r14
    adc          $(0), %rcx
    sub          %rcx, %r8
    sbb          $(0), %r9
    sbb          $(0), %r10
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r11
    adc          $(0), %rdx
    movq         (88)(%rsi), %r12
    mov          %r13, %rax
    shl          $(32), %rax
    add          %r13, %rax
    mov          %rax, %r15
    shr          $(32), %r15
    push         %r15
    mov          %rax, %rcx
    shl          $(32), %rcx
    push         %rcx
    sub          %rax, %rcx
    sbb          $(0), %r15
    add          %rcx, %r13
    pop          %rcx
    adc          %r15, %r14
    pop          %r15
    sbb          $(0), %r15
    sub          %rcx, %r14
    mov          $(0), %rcx
    sbb          %r15, %r8
    adc          $(0), %rcx
    sub          %rax, %r8
    adc          $(0), %rcx
    sub          %rcx, %r9
    sbb          $(0), %r10
    sbb          $(0), %r11
    sbb          $(0), %rax
    add          %rdx, %rax
    mov          $(0), %rdx
    adc          $(0), %rdx
    add          %rax, %r12
    adc          $(0), %rdx
    movq         %r14, (%rdi)
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    subq         Lpoly+0(%rip), %r14
    sbbq         Lpoly+8(%rip), %r8
    sbbq         Lpoly+16(%rip), %r9
    sbbq         Lpoly+24(%rip), %r10
    sbbq         Lpoly+32(%rip), %r11
    sbbq         Lpoly+40(%rip), %r12
    sbb          $(0), %rdx
    movq         (%rdi), %rax
    cmovne       %rax, %r14
    movq         (8)(%rdi), %rax
    cmovne       %rax, %r8
    movq         (16)(%rdi), %rax
    cmovne       %rax, %r9
    movq         (24)(%rdi), %rax
    cmovne       %rax, %r10
    movq         (32)(%rdi), %rax
    cmovne       %rax, %r11
    movq         (40)(%rdi), %rax
    cmovne       %rax, %r12
    movq         %r14, (%rdi)
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe7:
.size p384r1_mred, .Lfe7-(p384r1_mred)
.p2align 6, 0x90
 
.globl p384r1_select_pp_w5
.type p384r1_select_pp_w5, @function
 
p384r1_select_pp_w5:
 
    push         %r12
 
    push         %r13
 
    movdqa       LOne(%rip), %xmm10
    movd         %edx, %xmm9
    pshufd       $(0), %xmm9, %xmm9
    pxor         %xmm0, %xmm0
    pxor         %xmm1, %xmm1
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    pxor         %xmm6, %xmm6
    pxor         %xmm7, %xmm7
    pxor         %xmm8, %xmm8
    mov          $(16), %rcx
.Lselect_loopgas_8: 
    movdqa       %xmm10, %xmm11
    pcmpeqd      %xmm9, %xmm11
    paddd        LOne(%rip), %xmm10
    movdqa       %xmm11, %xmm12
    pand         (%rsi), %xmm12
    por          %xmm12, %xmm0
    movdqa       %xmm11, %xmm12
    pand         (16)(%rsi), %xmm12
    por          %xmm12, %xmm1
    movdqa       %xmm11, %xmm12
    pand         (32)(%rsi), %xmm12
    por          %xmm12, %xmm2
    movdqa       %xmm11, %xmm12
    pand         (48)(%rsi), %xmm12
    por          %xmm12, %xmm3
    movdqa       %xmm11, %xmm12
    pand         (64)(%rsi), %xmm12
    por          %xmm12, %xmm4
    movdqa       %xmm11, %xmm12
    pand         (80)(%rsi), %xmm12
    por          %xmm12, %xmm5
    movdqa       %xmm11, %xmm12
    pand         (96)(%rsi), %xmm12
    por          %xmm12, %xmm6
    movdqa       %xmm11, %xmm12
    pand         (112)(%rsi), %xmm12
    por          %xmm12, %xmm7
    movdqa       %xmm11, %xmm12
    pand         (128)(%rsi), %xmm12
    por          %xmm12, %xmm8
    add          $(144), %rsi
    dec          %rcx
    jnz          .Lselect_loopgas_8
    movdqu       %xmm0, (%rdi)
    movdqu       %xmm1, (16)(%rdi)
    movdqu       %xmm2, (32)(%rdi)
    movdqu       %xmm3, (48)(%rdi)
    movdqu       %xmm4, (64)(%rdi)
    movdqu       %xmm5, (80)(%rdi)
    movdqu       %xmm6, (96)(%rdi)
    movdqu       %xmm7, (112)(%rdi)
    movdqu       %xmm8, (128)(%rdi)
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe8:
.size p384r1_select_pp_w5, .Lfe8-(p384r1_select_pp_w5)
.p2align 6, 0x90
 
.globl p384r1_select_ap_w5
.type p384r1_select_ap_w5, @function
 
p384r1_select_ap_w5:
 
    push         %r12
 
    push         %r13
 
    movdqa       LOne(%rip), %xmm13
    movd         %edx, %xmm12
    pshufd       $(0), %xmm12, %xmm12
    pxor         %xmm0, %xmm0
    pxor         %xmm1, %xmm1
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    mov          $(16), %rcx
.Lselect_loopgas_9: 
    movdqa       %xmm13, %xmm14
    pcmpeqd      %xmm12, %xmm14
    paddd        LOne(%rip), %xmm13
    movdqa       (%rsi), %xmm6
    movdqa       (16)(%rsi), %xmm7
    movdqa       (32)(%rsi), %xmm8
    movdqa       (48)(%rsi), %xmm9
    movdqa       (64)(%rsi), %xmm10
    movdqa       (80)(%rsi), %xmm11
    add          $(96), %rsi
    pand         %xmm14, %xmm6
    pand         %xmm14, %xmm7
    pand         %xmm14, %xmm8
    pand         %xmm14, %xmm9
    pand         %xmm14, %xmm10
    pand         %xmm14, %xmm11
    por          %xmm6, %xmm0
    por          %xmm7, %xmm1
    por          %xmm8, %xmm2
    por          %xmm9, %xmm3
    por          %xmm10, %xmm4
    por          %xmm11, %xmm5
    dec          %rcx
    jnz          .Lselect_loopgas_9
    movdqu       %xmm0, (%rdi)
    movdqu       %xmm1, (16)(%rdi)
    movdqu       %xmm2, (32)(%rdi)
    movdqu       %xmm3, (48)(%rdi)
    movdqu       %xmm4, (64)(%rdi)
    movdqu       %xmm5, (80)(%rdi)
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe9:
.size p384r1_select_ap_w5, .Lfe9-(p384r1_select_ap_w5)
 
