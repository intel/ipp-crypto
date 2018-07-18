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
.p2align 5, 0x90
 
LOne:
.long  1,1,1,1,1,1,1,1 
 
LTwo:
.long  2,2,2,2,2,2,2,2 
 
LThree:
.long  3,3,3,3,3,3,3,3 
 
Lpoly:
.quad   0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff 
 

.quad   0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff 
 

.quad   0xffffffffffffffff, 0xffffffffffffffff,              0x1ff 
.p2align 5, 0x90
 
.globl _l9_p521r1_mul_by_2

 
_l9_p521r1_mul_by_2:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    xor          %rcx, %rcx
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    shld         $(1), %rax, %rcx
    shld         $(1), %r15, %rax
    shld         $(1), %r14, %r15
    shld         $(1), %r13, %r14
    shld         $(1), %r12, %r13
    shld         $(1), %r11, %r12
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    movq         %rax, (64)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r8, (%rdi)
    subq         Lpoly+0(%rip), %r8
    sbbq         Lpoly+8(%rip), %r9
    sbbq         Lpoly+16(%rip), %r10
    sbbq         Lpoly+24(%rip), %r11
    sbbq         Lpoly+32(%rip), %r12
    sbbq         Lpoly+40(%rip), %r13
    sbbq         Lpoly+48(%rip), %r14
    sbbq         Lpoly+56(%rip), %r15
    sbbq         Lpoly+64(%rip), %rax
    sbb          $(0), %rcx
    movq         (%rdi), %rdx
    cmovne       %rdx, %r8
    movq         (8)(%rdi), %rdx
    cmovne       %rdx, %r9
    movq         (16)(%rdi), %rdx
    cmovne       %rdx, %r10
    movq         (24)(%rdi), %rdx
    cmovne       %rdx, %r11
    movq         (32)(%rdi), %rdx
    cmovne       %rdx, %r12
    movq         (40)(%rdi), %rdx
    cmovne       %rdx, %r13
    movq         (48)(%rdi), %rdx
    cmovne       %rdx, %r14
    movq         (56)(%rdi), %rdx
    cmovne       %rdx, %r15
    movq         (64)(%rdi), %rdx
    cmovne       %rdx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_div_by_2

 
_l9_p521r1_div_by_2:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    xor          %rdx, %rdx
    xor          %rcx, %rcx
    addq         Lpoly+0(%rip), %r8
    adcq         Lpoly+8(%rip), %r9
    adcq         Lpoly+16(%rip), %r10
    adcq         Lpoly+24(%rip), %r11
    adcq         Lpoly+32(%rip), %r12
    adcq         Lpoly+40(%rip), %r13
    adcq         Lpoly+48(%rip), %r14
    adcq         Lpoly+56(%rip), %r15
    adcq         Lpoly+64(%rip), %rax
    adc          $(0), %rcx
    test         $(1), %r8
    cmovne       %rdx, %rcx
    movq         (%rsi), %rdx
    cmovne       %rdx, %r8
    movq         (8)(%rsi), %rdx
    cmovne       %rdx, %r9
    movq         (16)(%rsi), %rdx
    cmovne       %rdx, %r10
    movq         (24)(%rsi), %rdx
    cmovne       %rdx, %r11
    movq         (32)(%rsi), %rdx
    cmovne       %rdx, %r12
    movq         (40)(%rsi), %rdx
    cmovne       %rdx, %r13
    movq         (48)(%rsi), %rdx
    cmovne       %rdx, %r14
    movq         (56)(%rsi), %rdx
    cmovne       %rdx, %r15
    movq         (64)(%rsi), %rdx
    cmovne       %rdx, %rax
    shrd         $(1), %r9, %r8
    shrd         $(1), %r10, %r9
    shrd         $(1), %r11, %r10
    shrd         $(1), %r12, %r11
    shrd         $(1), %r13, %r12
    shrd         $(1), %r14, %r13
    shrd         $(1), %r15, %r14
    shrd         $(1), %rax, %r15
    shrd         $(1), %rcx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_mul_by_3

 
_l9_p521r1_mul_by_3:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(88), %rsp
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    xor          %rcx, %rcx
    shld         $(1), %rax, %rcx
    shld         $(1), %r15, %rax
    shld         $(1), %r14, %r15
    shld         $(1), %r13, %r14
    shld         $(1), %r12, %r13
    shld         $(1), %r11, %r12
    shld         $(1), %r10, %r11
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    movq         %rax, (64)(%rsp)
    movq         %r15, (56)(%rsp)
    movq         %r14, (48)(%rsp)
    movq         %r13, (40)(%rsp)
    movq         %r12, (32)(%rsp)
    movq         %r11, (24)(%rsp)
    movq         %r10, (16)(%rsp)
    movq         %r9, (8)(%rsp)
    movq         %r8, (%rsp)
    subq         Lpoly+0(%rip), %r8
    sbbq         Lpoly+8(%rip), %r9
    sbbq         Lpoly+16(%rip), %r10
    sbbq         Lpoly+24(%rip), %r11
    sbbq         Lpoly+32(%rip), %r12
    sbbq         Lpoly+40(%rip), %r13
    sbbq         Lpoly+48(%rip), %r14
    sbbq         Lpoly+56(%rip), %r15
    sbbq         Lpoly+64(%rip), %rax
    sbb          $(0), %rcx
    movq         (%rsp), %rdx
    cmovb        %rdx, %r8
    movq         (8)(%rsp), %rdx
    cmovb        %rdx, %r9
    movq         (16)(%rsp), %rdx
    cmovb        %rdx, %r10
    movq         (24)(%rsp), %rdx
    cmovb        %rdx, %r11
    movq         (32)(%rsp), %rdx
    cmovb        %rdx, %r12
    movq         (40)(%rsp), %rdx
    cmovb        %rdx, %r13
    movq         (48)(%rsp), %rdx
    cmovb        %rdx, %r14
    movq         (56)(%rsp), %rdx
    cmovb        %rdx, %r15
    movq         (64)(%rsp), %rdx
    cmovb        %rdx, %rax
    xor          %rcx, %rcx
    addq         (%rsi), %r8
    adcq         (8)(%rsi), %r9
    adcq         (16)(%rsi), %r10
    adcq         (24)(%rsi), %r11
    adcq         (32)(%rsi), %r12
    adcq         (40)(%rsi), %r13
    adcq         (48)(%rsi), %r14
    adcq         (56)(%rsi), %r15
    adcq         (64)(%rsi), %rax
    adc          $(0), %rcx
    movq         %r8, (%rsp)
    movq         %r9, (8)(%rsp)
    movq         %r10, (16)(%rsp)
    movq         %r11, (24)(%rsp)
    movq         %r12, (32)(%rsp)
    movq         %r13, (40)(%rsp)
    movq         %r14, (48)(%rsp)
    movq         %r15, (56)(%rsp)
    movq         %rax, (64)(%rsp)
    subq         Lpoly+0(%rip), %r8
    sbbq         Lpoly+8(%rip), %r9
    sbbq         Lpoly+16(%rip), %r10
    sbbq         Lpoly+24(%rip), %r11
    sbbq         Lpoly+32(%rip), %r12
    sbbq         Lpoly+40(%rip), %r13
    sbbq         Lpoly+48(%rip), %r14
    sbbq         Lpoly+56(%rip), %r15
    sbbq         Lpoly+64(%rip), %rax
    sbb          $(0), %rcx
    movq         (%rsp), %rdx
    cmovb        %rdx, %r8
    movq         (8)(%rsp), %rdx
    cmovb        %rdx, %r9
    movq         (16)(%rsp), %rdx
    cmovb        %rdx, %r10
    movq         (24)(%rsp), %rdx
    cmovb        %rdx, %r11
    movq         (32)(%rsp), %rdx
    cmovb        %rdx, %r12
    movq         (40)(%rsp), %rdx
    cmovb        %rdx, %r13
    movq         (48)(%rsp), %rdx
    cmovb        %rdx, %r14
    movq         (56)(%rsp), %rdx
    cmovb        %rdx, %r15
    movq         (64)(%rsp), %rdx
    cmovb        %rdx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
    add          $(88), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_add

 
_l9_p521r1_add:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    xor          %rcx, %rcx
    addq         (%rdx), %r8
    adcq         (8)(%rdx), %r9
    adcq         (16)(%rdx), %r10
    adcq         (24)(%rdx), %r11
    adcq         (32)(%rdx), %r12
    adcq         (40)(%rdx), %r13
    adcq         (48)(%rdx), %r14
    adcq         (56)(%rdx), %r15
    adcq         (64)(%rdx), %rax
    adc          $(0), %rcx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
    subq         Lpoly+0(%rip), %r8
    sbbq         Lpoly+8(%rip), %r9
    sbbq         Lpoly+16(%rip), %r10
    sbbq         Lpoly+24(%rip), %r11
    sbbq         Lpoly+32(%rip), %r12
    sbbq         Lpoly+40(%rip), %r13
    sbbq         Lpoly+48(%rip), %r14
    sbbq         Lpoly+56(%rip), %r15
    sbbq         Lpoly+64(%rip), %rax
    sbb          $(0), %rcx
    movq         (%rdi), %rdx
    cmovb        %rdx, %r8
    movq         (8)(%rdi), %rdx
    cmovb        %rdx, %r9
    movq         (16)(%rdi), %rdx
    cmovb        %rdx, %r10
    movq         (24)(%rdi), %rdx
    cmovb        %rdx, %r11
    movq         (32)(%rdi), %rdx
    cmovb        %rdx, %r12
    movq         (40)(%rdi), %rdx
    cmovb        %rdx, %r13
    movq         (48)(%rdi), %rdx
    cmovb        %rdx, %r14
    movq         (56)(%rdi), %rdx
    cmovb        %rdx, %r15
    movq         (64)(%rdi), %rdx
    cmovb        %rdx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_sub

 
_l9_p521r1_sub:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    xor          %rcx, %rcx
    subq         (%rdx), %r8
    sbbq         (8)(%rdx), %r9
    sbbq         (16)(%rdx), %r10
    sbbq         (24)(%rdx), %r11
    sbbq         (32)(%rdx), %r12
    sbbq         (40)(%rdx), %r13
    sbbq         (48)(%rdx), %r14
    sbbq         (56)(%rdx), %r15
    sbbq         (64)(%rdx), %rax
    sbb          $(0), %rcx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
    addq         Lpoly+0(%rip), %r8
    adcq         Lpoly+8(%rip), %r9
    adcq         Lpoly+16(%rip), %r10
    adcq         Lpoly+24(%rip), %r11
    adcq         Lpoly+32(%rip), %r12
    adcq         Lpoly+40(%rip), %r13
    adcq         Lpoly+48(%rip), %r14
    adcq         Lpoly+56(%rip), %r15
    adcq         Lpoly+64(%rip), %rax
    test         %rcx, %rcx
    movq         (%rdi), %rdx
    cmove        %rdx, %r8
    movq         (8)(%rdi), %rdx
    cmove        %rdx, %r9
    movq         (16)(%rdi), %rdx
    cmove        %rdx, %r10
    movq         (24)(%rdi), %rdx
    cmove        %rdx, %r11
    movq         (32)(%rdi), %rdx
    cmove        %rdx, %r12
    movq         (40)(%rdi), %rdx
    cmove        %rdx, %r13
    movq         (48)(%rdi), %rdx
    cmove        %rdx, %r14
    movq         (56)(%rdi), %rdx
    cmove        %rdx, %r15
    movq         (64)(%rdi), %rdx
    cmove        %rdx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_neg

 
_l9_p521r1_neg:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    xor          %r12, %r12
    xor          %r13, %r13
    xor          %r14, %r14
    xor          %r15, %r15
    xor          %rax, %rax
    xor          %rcx, %rcx
    subq         (%rsi), %r8
    sbbq         (8)(%rsi), %r9
    sbbq         (16)(%rsi), %r10
    sbbq         (24)(%rsi), %r11
    sbbq         (32)(%rsi), %r12
    sbbq         (40)(%rsi), %r13
    sbbq         (48)(%rsi), %r14
    sbbq         (56)(%rsi), %r15
    sbbq         (64)(%rsi), %rax
    sbb          $(0), %rcx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
    addq         Lpoly+0(%rip), %r8
    adcq         Lpoly+8(%rip), %r9
    adcq         Lpoly+16(%rip), %r10
    adcq         Lpoly+24(%rip), %r11
    adcq         Lpoly+32(%rip), %r12
    adcq         Lpoly+40(%rip), %r13
    adcq         Lpoly+48(%rip), %r14
    adcq         Lpoly+56(%rip), %r15
    adcq         Lpoly+64(%rip), %rax
    test         %rcx, %rcx
    movq         (%rdi), %rdx
    cmove        %rdx, %r8
    movq         (8)(%rdi), %rdx
    cmove        %rdx, %r9
    movq         (16)(%rdi), %rdx
    cmove        %rdx, %r10
    movq         (24)(%rdi), %rdx
    cmove        %rdx, %r11
    movq         (32)(%rdi), %rdx
    cmove        %rdx, %r12
    movq         (40)(%rdi), %rdx
    cmove        %rdx, %r13
    movq         (48)(%rdi), %rdx
    cmove        %rdx, %r14
    movq         (56)(%rdi), %rdx
    cmove        %rdx, %r15
    movq         (64)(%rdi), %rdx
    cmove        %rdx, %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    movq         %rax, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_mred

 
_l9_p521r1_mred:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    movq         (24)(%rsi), %r11
    movq         (32)(%rsi), %r12
    movq         (40)(%rsi), %r13
    movq         (48)(%rsi), %r14
    movq         (56)(%rsi), %r15
    movq         (64)(%rsi), %rax
    movq         (72)(%rsi), %rcx
    xor          %rdx, %rdx
    mov          %r8, %rbx
    shr          $(55), %rbx
    shl          $(9), %r8
    add          %rdx, %rbx
    add          %r8, %rax
    adc          %rbx, %rcx
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (80)(%rsi), %r8
    mov          %r9, %rbx
    shr          $(55), %rbx
    shl          $(9), %r9
    add          %rdx, %rbx
    add          %r9, %rcx
    adc          %rbx, %r8
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (88)(%rsi), %r9
    mov          %r10, %rbx
    shr          $(55), %rbx
    shl          $(9), %r10
    add          %rdx, %rbx
    add          %r10, %r8
    adc          %rbx, %r9
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (96)(%rsi), %r10
    mov          %r11, %rbx
    shr          $(55), %rbx
    shl          $(9), %r11
    add          %rdx, %rbx
    add          %r11, %r9
    adc          %rbx, %r10
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (104)(%rsi), %r11
    mov          %r12, %rbx
    shr          $(55), %rbx
    shl          $(9), %r12
    add          %rdx, %rbx
    add          %r12, %r10
    adc          %rbx, %r11
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (112)(%rsi), %r12
    mov          %r13, %rbx
    shr          $(55), %rbx
    shl          $(9), %r13
    add          %rdx, %rbx
    add          %r13, %r11
    adc          %rbx, %r12
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (120)(%rsi), %r13
    mov          %r14, %rbx
    shr          $(55), %rbx
    shl          $(9), %r14
    add          %rdx, %rbx
    add          %r14, %r12
    adc          %rbx, %r13
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (128)(%rsi), %r14
    mov          %r15, %rbx
    shr          $(55), %rbx
    shl          $(9), %r15
    add          %rdx, %rbx
    add          %r15, %r13
    adc          %rbx, %r14
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         (136)(%rsi), %r15
    mov          %rax, %rbx
    shr          $(55), %rbx
    shl          $(9), %rax
    add          %rdx, %rbx
    add          %rax, %r14
    adc          %rbx, %r15
    mov          $(0), %rdx
    adc          $(0), %rdx
    movq         %rcx, (%rdi)
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    subq         Lpoly+0(%rip), %rcx
    sbbq         Lpoly+8(%rip), %r8
    sbbq         Lpoly+16(%rip), %r9
    sbbq         Lpoly+24(%rip), %r10
    sbbq         Lpoly+32(%rip), %r11
    sbbq         Lpoly+40(%rip), %r12
    sbbq         Lpoly+48(%rip), %r13
    sbbq         Lpoly+56(%rip), %r14
    sbbq         Lpoly+64(%rip), %r15
    movq         (%rdi), %rbx
    cmovb        %rbx, %rcx
    movq         (8)(%rdi), %rbx
    cmovb        %rbx, %r8
    movq         (16)(%rdi), %rbx
    cmovb        %rbx, %r9
    movq         (24)(%rdi), %rbx
    cmovb        %rbx, %r10
    movq         (32)(%rdi), %rbx
    cmovb        %rbx, %r11
    movq         (40)(%rdi), %rbx
    cmovb        %rbx, %r12
    movq         (48)(%rdi), %rbx
    cmovb        %rbx, %r13
    movq         (56)(%rdi), %rbx
    cmovb        %rbx, %r14
    movq         (64)(%rdi), %rbx
    cmovb        %rbx, %r15
    movq         %rcx, (%rdi)
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_select_pp_w5

 
_l9_p521r1_select_pp_w5:
 
    push         %r12
 
    push         %r13
 
    sub          $(40), %rsp
 
    movd         %edx, %xmm15
    pshufd       $(0), %xmm15, %xmm15
    movdqa       %xmm15, (%rsp)
    movdqa       LOne(%rip), %xmm14
    movdqa       %xmm14, (16)(%rsp)
    pxor         %xmm0, %xmm0
    pxor         %xmm1, %xmm1
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    pxor         %xmm6, %xmm6
    pxor         %xmm7, %xmm7
    pxor         %xmm8, %xmm8
    pxor         %xmm9, %xmm9
    pxor         %xmm10, %xmm10
    pxor         %xmm11, %xmm11
    pxor         %xmm12, %xmm12
    pxor         %xmm13, %xmm13
    mov          $(16), %rcx
.Lselect_loopgas_8: 
    movdqa       (16)(%rsp), %xmm15
    movdqa       %xmm15, %xmm14
    pcmpeqd      (%rsp), %xmm15
    paddd        LOne(%rip), %xmm14
    movdqa       %xmm14, (16)(%rsp)
    movdqu       (%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm0
    movdqu       (16)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm1
    movdqu       (32)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm2
    movdqu       (48)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm3
    movdqu       (64)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm4
    movdqu       (80)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm5
    movdqu       (96)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm6
    movdqu       (112)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm7
    movdqu       (128)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm8
    movdqu       (144)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm9
    movdqu       (160)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm10
    movdqu       (176)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm11
    movdqu       (192)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm12
    movd         (208)(%rsi), %xmm14
    pand         %xmm15, %xmm14
    por          %xmm14, %xmm13
    add          $(216), %rsi
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
    movdqu       %xmm9, (144)(%rdi)
    movdqu       %xmm10, (160)(%rdi)
    movdqu       %xmm11, (176)(%rdi)
    movdqu       %xmm12, (192)(%rdi)
    movq         %xmm13, (208)(%rdi)
    add          $(40), %rsp
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 5, 0x90
 
.globl _l9_p521r1_select_ap_w5

 
_l9_p521r1_select_ap_w5:
 
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
.Lselect_loopgas_9: 
    movdqa       %xmm10, %xmm11
    pcmpeqd      %xmm9, %xmm11
    paddd        LOne(%rip), %xmm10
    movdqa       (%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm0
    movdqa       (16)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm1
    movdqa       (32)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm2
    movdqa       (48)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm3
    movdqa       (64)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm4
    movdqa       (80)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm5
    movdqa       (96)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm6
    movdqa       (112)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm7
    movdqa       (128)(%rsi), %xmm12
    pand         %xmm11, %xmm12
    por          %xmm12, %xmm8
    add          $(144), %rsi
    dec          %rcx
    jnz          .Lselect_loopgas_9
    movdqu       %xmm0, (%rdi)
    movdqu       %xmm1, (16)(%rdi)
    movdqu       %xmm2, (32)(%rdi)
    movdqu       %xmm3, (48)(%rdi)
    movdqu       %xmm4, (64)(%rdi)
    movdqu       %xmm5, (80)(%rdi)
    movdqu       %xmm6, (96)(%rdi)
    movdqu       %xmm7, (112)(%rdi)
    movdqu       %xmm8, (128)(%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
 
