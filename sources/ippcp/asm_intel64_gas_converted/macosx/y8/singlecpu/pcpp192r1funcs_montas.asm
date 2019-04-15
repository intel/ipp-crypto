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
 
Lpoly:
.quad   0xFFFFFFFFFFFFFFFF, 0xFFFFFFFFFFFFFFFE, 0xFFFFFFFFFFFFFFFF 
 
LRR:
.quad                  0x1,                0x2,                0x1 
 
LOne:
.long  1,1,1,1,1,1,1,1 
.p2align 4, 0x90
 
.globl _p192r1_mul_by_2

 
_p192r1_mul_by_2:
 
    push         %r12
 
    xor          %r12, %r12
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    shld         $(1), %r10, %r12
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r12
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_div_by_2

 
_p192r1_div_by_2:
 
    push         %r12
 
    push         %r13
 
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    xor          %r12, %r12
    xor          %r13, %r13
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    adc          $(0), %r12
    test         $(1), %r8
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    cmovne       %r12, %r13
    shrd         $(1), %r9, %r8
    shrd         $(1), %r10, %r9
    shrd         $(1), %r13, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_mul_by_3

 
_p192r1_mul_by_3:
 
    push         %r12
 
    xor          %r12, %r12
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    shld         $(1), %r10, %r12
    shld         $(1), %r9, %r10
    shld         $(1), %r8, %r9
    shl          $(1), %r8
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r12
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    xor          %r12, %r12
    addq         (%rsi), %r8
    adcq         (8)(%rsi), %r9
    adcq         (16)(%rsi), %r10
    adc          $(0), %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r12
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_add

 
_p192r1_add:
 
    push         %r12
 
    xor          %r12, %r12
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    addq         (%rdx), %r8
    adcq         (8)(%rdx), %r9
    adcq         (16)(%rdx), %r10
    adc          $(0), %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r12
    cmove        %rax, %r8
    cmove        %rdx, %r9
    cmove        %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_sub

 
_p192r1_sub:
 
    push         %r12
 
    xor          %r12, %r12
    movq         (%rsi), %r8
    movq         (8)(%rsi), %r9
    movq         (16)(%rsi), %r10
    subq         (%rdx), %r8
    sbbq         (8)(%rdx), %r9
    sbbq         (16)(%rdx), %r10
    sbb          $(0), %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    test         %r12, %r12
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_neg

 
_p192r1_neg:
 
    push         %r12
 
    xor          %r12, %r12
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    subq         (%rsi), %r8
    sbbq         (8)(%rsi), %r9
    sbbq         (16)(%rsi), %r10
    sbb          $(0), %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    addq         Lpoly+0(%rip), %rax
    adcq         Lpoly+8(%rip), %rdx
    adcq         Lpoly+16(%rip), %rcx
    test         %r12, %r12
    cmovne       %rax, %r8
    cmovne       %rdx, %r9
    cmovne       %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
p192r1_mmull: 
    xor          %r12, %r12
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
    sub          %r8, %r9
    sbb          $(0), %r10
    sbb          $(0), %r8
    add          %r8, %r11
    adc          $(0), %r12
    xor          %r8, %r8
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
    adc          %rdx, %r12
    adc          $(0), %r8
    sub          %r9, %r10
    sbb          $(0), %r11
    sbb          $(0), %r9
    add          %r9, %r12
    adc          $(0), %r8
    xor          %r9, %r9
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
    adc          %rdx, %r8
    adc          $(0), %r9
    sub          %r10, %r11
    sbb          $(0), %r12
    sbb          $(0), %r10
    add          %r10, %r8
    adc          $(0), %r9
    xor          %r10, %r10
    mov          %r11, %rax
    mov          %r12, %rdx
    mov          %r8, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r9
    cmovnc       %rax, %r11
    cmovnc       %rdx, %r12
    cmovnc       %rcx, %r8
    movq         %r11, (%rdi)
    movq         %r12, (8)(%rdi)
    movq         %r8, (16)(%rdi)
    ret
.p2align 4, 0x90
 
.globl _p192r1_mul_montl

 
_p192r1_mul_montl:
 
    push         %rbx
 
    push         %r12
 
    mov          %rdx, %rbx
    call         p192r1_mmull
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_to_mont

 
_p192r1_to_mont:
 
    push         %rbx
 
    push         %r12
 
    lea          LRR(%rip), %rbx
    call         p192r1_mmull
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_sqr_montl

 
_p192r1_sqr_montl:
 
    push         %r12
 
    push         %r13
 
    movq         (%rsi), %rcx
    movq         (8)(%rsi), %rax
    mul          %rcx
    mov          %rax, %r9
    mov          %rdx, %r10
    movq         (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r10
    adc          $(0), %rdx
    mov          %rdx, %r11
    movq         (8)(%rsi), %rcx
    movq         (16)(%rsi), %rax
    mul          %rcx
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    xor          %r13, %r13
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
    sub          %r8, %r9
    sbb          $(0), %r10
    sbb          $(0), %r8
    add          %r8, %r11
    mov          $(0), %r8
    adc          $(0), %r8
    sub          %r9, %r10
    sbb          $(0), %r11
    sbb          $(0), %r9
    add          %r9, %r12
    mov          $(0), %r9
    adc          $(0), %r9
    add          %r8, %r12
    adc          $(0), %r9
    sub          %r10, %r11
    sbb          $(0), %r12
    sbb          $(0), %r10
    add          %r10, %r13
    mov          $(0), %r10
    adc          $(0), %r10
    add          %r9, %r13
    adc          $(0), %r10
    mov          %r11, %rax
    mov          %r12, %rdx
    mov          %r13, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r10
    cmovnc       %rax, %r11
    cmovnc       %rdx, %r12
    cmovnc       %rcx, %r13
    movq         %r11, (%rdi)
    movq         %r12, (8)(%rdi)
    movq         %r13, (16)(%rdi)
 
    pop          %r13
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_mont_back

 
_p192r1_mont_back:
 
    push         %r12
 
    movq         (%rsi), %r10
    movq         (8)(%rsi), %r11
    movq         (16)(%rsi), %r12
    xor          %r8, %r8
    xor          %r9, %r9
    sub          %r10, %r11
    sbb          $(0), %r12
    sbb          $(0), %r10
    add          %r10, %r8
    adc          $(0), %r9
    xor          %r10, %r10
    sub          %r11, %r12
    sbb          $(0), %r8
    sbb          $(0), %r11
    add          %r11, %r9
    adc          $(0), %r10
    xor          %r11, %r11
    sub          %r12, %r8
    sbb          $(0), %r9
    sbb          $(0), %r12
    add          %r12, %r10
    adc          $(0), %r11
    xor          %r12, %r12
    mov          %r8, %rax
    mov          %r9, %rdx
    mov          %r10, %rcx
    subq         Lpoly+0(%rip), %rax
    sbbq         Lpoly+8(%rip), %rdx
    sbbq         Lpoly+16(%rip), %rcx
    sbb          $(0), %r12
    cmovnc       %rax, %r8
    cmovnc       %rdx, %r9
    cmovnc       %rcx, %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
 
    pop          %r12
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_select_pp_w5

 
_p192r1_select_pp_w5:
 
    movdqa       LOne(%rip), %xmm0
    movdqa       %xmm0, %xmm12
    movd         %edx, %xmm1
    pshufd       $(0), %xmm1, %xmm1
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    pxor         %xmm6, %xmm6
    mov          $(16), %rcx
.Lselect_loop_sse_w5gas_11: 
    movdqa       %xmm12, %xmm13
    pcmpeqd      %xmm1, %xmm13
    paddd        %xmm0, %xmm12
    movdqu       (%rsi), %xmm7
    movdqu       (16)(%rsi), %xmm8
    movdqu       (32)(%rsi), %xmm9
    movdqu       (48)(%rsi), %xmm10
    movq         (64)(%rsi), %xmm11
    add          $(72), %rsi
    pand         %xmm13, %xmm7
    pand         %xmm13, %xmm8
    pand         %xmm13, %xmm9
    pand         %xmm13, %xmm10
    pand         %xmm13, %xmm11
    por          %xmm7, %xmm2
    por          %xmm8, %xmm3
    por          %xmm9, %xmm4
    por          %xmm10, %xmm5
    por          %xmm11, %xmm6
    dec          %rcx
    jnz          .Lselect_loop_sse_w5gas_11
    movdqu       %xmm2, (%rdi)
    movdqu       %xmm3, (16)(%rdi)
    movdqu       %xmm4, (32)(%rdi)
    movdqu       %xmm5, (48)(%rdi)
    movq         %xmm6, (64)(%rdi)
 
    ret
 
.p2align 4, 0x90
 
.globl _p192r1_select_ap_w7

 
_p192r1_select_ap_w7:
 
    movdqa       LOne(%rip), %xmm0
    pxor         %xmm2, %xmm2
    pxor         %xmm3, %xmm3
    pxor         %xmm4, %xmm4
    movdqa       %xmm0, %xmm8
    movd         %edx, %xmm1
    pshufd       $(0), %xmm1, %xmm1
    mov          $(64), %rcx
.Lselect_loop_sse_w7gas_12: 
    movdqa       %xmm8, %xmm9
    pcmpeqd      %xmm1, %xmm9
    paddd        %xmm0, %xmm8
    movdqa       (%rsi), %xmm5
    movdqa       (16)(%rsi), %xmm6
    movdqa       (32)(%rsi), %xmm7
    add          $(48), %rsi
    pand         %xmm9, %xmm5
    pand         %xmm9, %xmm6
    pand         %xmm9, %xmm7
    por          %xmm5, %xmm2
    por          %xmm6, %xmm3
    por          %xmm7, %xmm4
    dec          %rcx
    jnz          .Lselect_loop_sse_w7gas_12
    movdqu       %xmm2, (%rdi)
    movdqu       %xmm3, (16)(%rdi)
    movdqu       %xmm4, (32)(%rdi)
 
    ret
 
