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
 
.p2align 6, 0x90
 
.globl n0_cpMontMul4n_avx2
.type n0_cpMontMul4n_avx2, @function
 
n0_cpMontMul4n_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(48), %rsp
 
    mov          %rdx, %rbp
    movslq       %r8d, %r8
 
    movq         %rdi, (%rsp)
    movq         %rsi, (16)(%rsp)
    movq         %rcx, (24)(%rsp)
    movq         %r8, (32)(%rsp)
    movq         (96)(%rsp), %rdi
    mov          %rdi, (8)(%rsp)
    vpxor        %ymm0, %ymm0, %ymm0
    xor          %rax, %rax
    vmovdqu      %ymm0, (%rsi,%r8,8)
    vmovdqu      %ymm0, (%rcx,%r8,8)
    mov          %r8, %r14
.p2align 6, 0x90
.LclearLoopgas_1: 
    vmovdqu      %ymm0, (%rdi)
    add          $(32), %rdi
    sub          $(4), %r14
    jg           .LclearLoopgas_1
    vmovdqu      %ymm0, (%rdi)
    lea          (3)(%r8), %r14
    and          $(-4), %r14
.p2align 6, 0x90
.Lloop4_Bgas_1: 
    sub          $(4), %r8
    jl           .Lexit_loop4_Bgas_1
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm6
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    movq         (24)(%rbp), %rbx
    vpbroadcastq (24)(%rbp), %ymm7
    imulq        (%rsi), %rbx
    add          %rbx, %r13
    mov          %r13, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    imulq        (%rcx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpaddq       (32)(%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (32)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lloop16_Agas_1: 
    sub          $(16), %r11
    jl           .Lexit_loop16_Agas_1
    vmovdqu      (%rdi), %ymm0
    vmovdqu      (32)(%rdi), %ymm1
    vmovdqu      (64)(%rdi), %ymm2
    vmovdqu      (96)(%rdi), %ymm3
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (32)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (32)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (64)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (64)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (24)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (24)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (56)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (56)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (88)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (48)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (48)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (80)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-24)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (8)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (8)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (40)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (40)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (72)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vmovdqu      %ymm0, (-32)(%rdi)
    vmovdqu      %ymm1, (%rdi)
    vmovdqu      %ymm2, (32)(%rdi)
    vmovdqu      %ymm3, (64)(%rdi)
    add          $(128), %rdi
    add          $(128), %rsi
    add          $(128), %rcx
    jmp          .Lloop16_Agas_1
.Lexit_loop16_Agas_1: 
    add          $(16), %r11
    jz           .LexitAgas_1
.Lloop4_Agas_1: 
    sub          $(4), %r11
    jl           .LexitAgas_1
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-24)(%rsi), %ymm7, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vmovdqu      %ymm0, (-32)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lloop4_Agas_1
.LexitAgas_1: 
    vpmuludq     (-8)(%rsi), %ymm5, %ymm1
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (-16)(%rsi), %ymm6, %ymm2
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (-24)(%rsi), %ymm7, %ymm3
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpaddq       %ymm2, %ymm1, %ymm1
    vpaddq       %ymm3, %ymm1, %ymm1
    vmovdqu      %ymm1, (-32)(%rdi)
    jmp          .Lloop4_Bgas_1
.Lexit_loop4_Bgas_1: 
    movq         (%rsp), %rdi
    movq         (8)(%rsp), %rsi
    movq         (32)(%rsp), %r8
    xor          %rax, %rax
.Lnorm_loopgas_1: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r8
    jg           .Lnorm_loopgas_1
    movq         %rax, (%rdi)
    add          $(48), %rsp
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size n0_cpMontMul4n_avx2, .Lfe1-(n0_cpMontMul4n_avx2)
.p2align 6, 0x90
 
.globl n0_cpMontMul4n1_avx2
.type n0_cpMontMul4n1_avx2, @function
 
n0_cpMontMul4n1_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(48), %rsp
 
    mov          %rdx, %rbp
    movslq       %r8d, %r8
 
    movq         %rdi, (%rsp)
    movq         %rsi, (16)(%rsp)
    movq         %rcx, (24)(%rsp)
    movq         %r8, (32)(%rsp)
    movq         (96)(%rsp), %rdi
    mov          %rdi, (8)(%rsp)
    vpxor        %ymm0, %ymm0, %ymm0
    xor          %rax, %rax
    vmovdqu      %ymm0, (%rsi,%r8,8)
    vmovdqu      %ymm0, (%rcx,%r8,8)
    mov          %r8, %r14
.p2align 6, 0x90
.LclearLoopgas_2: 
    vmovdqu      %ymm0, (%rdi)
    add          $(32), %rdi
    sub          $(4), %r14
    jg           .LclearLoopgas_2
    movq         %rax, (%rdi)
    lea          (3)(%r8), %r14
    and          $(-4), %r14
.p2align 6, 0x90
.Lloop4_Bgas_2: 
    sub          $(4), %r8
    jl           .Lexit_loop4_Bgas_2
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm6
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    movq         (24)(%rbp), %rbx
    vpbroadcastq (24)(%rbp), %ymm7
    imulq        (%rsi), %rbx
    add          %rbx, %r13
    mov          %r13, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    imulq        (%rcx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpaddq       (32)(%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (32)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lloop16_Agas_2: 
    sub          $(16), %r11
    jl           .Lexit_loop16_Agas_2
    vmovdqu      (%rdi), %ymm0
    vmovdqu      (32)(%rdi), %ymm1
    vmovdqu      (64)(%rdi), %ymm2
    vmovdqu      (96)(%rdi), %ymm3
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (32)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (32)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (64)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (64)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (24)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (24)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (56)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (56)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (88)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (48)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (48)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (80)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-24)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (8)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (8)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (40)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (40)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (72)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vmovdqu      %ymm0, (-32)(%rdi)
    vmovdqu      %ymm1, (%rdi)
    vmovdqu      %ymm2, (32)(%rdi)
    vmovdqu      %ymm3, (64)(%rdi)
    add          $(128), %rdi
    add          $(128), %rsi
    add          $(128), %rcx
    jmp          .Lloop16_Agas_2
.Lexit_loop16_Agas_2: 
    add          $(16), %r11
    jz           .LexitAgas_2
.Lloop4_Agas_2: 
    sub          $(4), %r11
    jl           .LexitAgas_2
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-24)(%rsi), %ymm7, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vmovdqu      %ymm0, (-32)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lloop4_Agas_2
.LexitAgas_2: 
    jmp          .Lloop4_Bgas_2
.Lexit_loop4_Bgas_2: 
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         %r11, (%rdi)
    movq         %r12, (8)(%rdi)
    movq         %r13, (16)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lrem_loop4_Agas_2: 
    sub          $(4), %r11
    jl           .Lexit_rem_loop4_Agas_2
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vmovdqu      %ymm0, (-8)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lrem_loop4_Agas_2
.Lexit_rem_loop4_Agas_2: 
    movq         (%rsp), %rdi
    movq         (8)(%rsp), %rsi
    movq         (32)(%rsp), %r8
    xor          %rax, %rax
.Lnorm_loopgas_2: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r8
    jg           .Lnorm_loopgas_2
    movq         %rax, (%rdi)
    add          $(48), %rsp
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe2:
.size n0_cpMontMul4n1_avx2, .Lfe2-(n0_cpMontMul4n1_avx2)
.p2align 6, 0x90
 
.globl n0_cpMontMul4n2_avx2
.type n0_cpMontMul4n2_avx2, @function
 
n0_cpMontMul4n2_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(48), %rsp
 
    mov          %rdx, %rbp
    movslq       %r8d, %r8
 
    movq         %rdi, (%rsp)
    movq         %rsi, (16)(%rsp)
    movq         %rcx, (24)(%rsp)
    movq         %r8, (32)(%rsp)
    movq         (96)(%rsp), %rdi
    mov          %rdi, (8)(%rsp)
    vpxor        %ymm0, %ymm0, %ymm0
    xor          %rax, %rax
    vmovdqu      %ymm0, (%rsi,%r8,8)
    vmovdqu      %ymm0, (%rcx,%r8,8)
    mov          %r8, %r14
.p2align 6, 0x90
.LclearLoopgas_3: 
    vmovdqu      %ymm0, (%rdi)
    add          $(32), %rdi
    sub          $(4), %r14
    jg           .LclearLoopgas_3
    vmovdqu      %xmm0, (%rdi)
    lea          (3)(%r8), %r14
    and          $(-4), %r14
.p2align 6, 0x90
.Lloop4_Bgas_3: 
    sub          $(4), %r8
    jl           .Lexit_loop4_Bgas_3
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm6
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    movq         (24)(%rbp), %rbx
    vpbroadcastq (24)(%rbp), %ymm7
    imulq        (%rsi), %rbx
    add          %rbx, %r13
    mov          %r13, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    imulq        (%rcx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpaddq       (32)(%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (32)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lloop16_Agas_3: 
    sub          $(16), %r11
    jl           .Lexit_loop16_Agas_3
    vmovdqu      (%rdi), %ymm0
    vmovdqu      (32)(%rdi), %ymm1
    vmovdqu      (64)(%rdi), %ymm2
    vmovdqu      (96)(%rdi), %ymm3
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (32)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (32)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (64)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (64)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (24)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (24)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (56)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (56)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (88)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (48)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (48)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (80)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-24)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (8)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (8)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (40)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (40)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (72)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vmovdqu      %ymm0, (-32)(%rdi)
    vmovdqu      %ymm1, (%rdi)
    vmovdqu      %ymm2, (32)(%rdi)
    vmovdqu      %ymm3, (64)(%rdi)
    add          $(128), %rdi
    add          $(128), %rsi
    add          $(128), %rcx
    jmp          .Lloop16_Agas_3
.Lexit_loop16_Agas_3: 
    add          $(16), %r11
    jz           .LexitAgas_3
.Lloop4_Agas_3: 
    sub          $(4), %r11
    jl           .LexitAgas_3
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-24)(%rsi), %ymm7, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vmovdqu      %ymm0, (-32)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lloop4_Agas_3
.LexitAgas_3: 
    vpmuludq     (-24)(%rsi), %ymm7, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vmovdqu      %ymm0, (-32)(%rdi)
    jmp          .Lloop4_Bgas_3
.Lexit_loop4_Bgas_3: 
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lrem_loop4_Agas_3: 
    sub          $(4), %r11
    jl           .Lexit_rem_loop4_Agas_3
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vmovdqu      %ymm0, (-16)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lrem_loop4_Agas_3
.Lexit_rem_loop4_Agas_3: 
    movq         (%rsp), %rdi
    movq         (8)(%rsp), %rsi
    movq         (32)(%rsp), %r8
    xor          %rax, %rax
.Lnorm_loopgas_3: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r8
    jg           .Lnorm_loopgas_3
    movq         %rax, (%rdi)
    add          $(48), %rsp
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe3:
.size n0_cpMontMul4n2_avx2, .Lfe3-(n0_cpMontMul4n2_avx2)
.p2align 6, 0x90
 
.globl n0_cpMontMul4n3_avx2
.type n0_cpMontMul4n3_avx2, @function
 
n0_cpMontMul4n3_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(48), %rsp
 
    mov          %rdx, %rbp
    movslq       %r8d, %r8
 
    movq         %rdi, (%rsp)
    movq         %rsi, (16)(%rsp)
    movq         %rcx, (24)(%rsp)
    movq         %r8, (32)(%rsp)
    movq         (96)(%rsp), %rdi
    mov          %rdi, (8)(%rsp)
    vpxor        %ymm0, %ymm0, %ymm0
    xor          %rax, %rax
    vmovdqu      %ymm0, (%rsi,%r8,8)
    vmovdqu      %ymm0, (%rcx,%r8,8)
    mov          %r8, %r14
.p2align 6, 0x90
.LclearLoopgas_4: 
    vmovdqu      %ymm0, (%rdi)
    add          $(32), %rdi
    sub          $(4), %r14
    jg           .LclearLoopgas_4
    vmovdqu      %xmm0, (%rdi)
    movq         %rax, (16)(%rdi)
    lea          (3)(%r8), %r14
    and          $(-4), %r14
.p2align 6, 0x90
.Lloop4_Bgas_4: 
    sub          $(4), %r8
    jl           .Lexit_loop4_Bgas_4
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm6
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    movq         (24)(%rbp), %rbx
    vpbroadcastq (24)(%rbp), %ymm7
    imulq        (%rsi), %rbx
    add          %rbx, %r13
    mov          %r13, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    imulq        (%rcx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpaddq       (32)(%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (32)(%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lloop16_Agas_4: 
    sub          $(16), %r11
    jl           .Lexit_loop16_Agas_4
    vmovdqu      (%rdi), %ymm0
    vmovdqu      (32)(%rdi), %ymm1
    vmovdqu      (64)(%rdi), %ymm2
    vmovdqu      (96)(%rdi), %ymm3
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (32)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (32)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (64)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (64)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (24)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (24)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (56)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (56)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (88)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (48)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (48)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (80)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-24)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (8)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (8)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (40)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (40)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rsi), %ymm7, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (72)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vmovdqu      %ymm0, (-32)(%rdi)
    vmovdqu      %ymm1, (%rdi)
    vmovdqu      %ymm2, (32)(%rdi)
    vmovdqu      %ymm3, (64)(%rdi)
    add          $(128), %rdi
    add          $(128), %rsi
    add          $(128), %rcx
    jmp          .Lloop16_Agas_4
.Lexit_loop16_Agas_4: 
    add          $(16), %r11
    jz           .LexitAgas_4
.Lloop4_Agas_4: 
    sub          $(4), %r11
    jl           .LexitAgas_4
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-24)(%rsi), %ymm7, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpmuludq     (-24)(%rcx), %ymm11, %ymm2
    vpaddq       %ymm2, %ymm0, %ymm0
    vmovdqu      %ymm0, (-32)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lloop4_Agas_4
.LexitAgas_4: 
    vpmuludq     (-16)(%rsi), %ymm6, %ymm2
    vpmuludq     (-16)(%rcx), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (-24)(%rsi), %ymm7, %ymm3
    vpmuludq     (-24)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpaddq       %ymm3, %ymm2, %ymm2
    vmovdqu      %ymm2, (-32)(%rdi)
    jmp          .Lloop4_Bgas_4
.Lexit_loop4_Bgas_4: 
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm4
    movq         (8)(%rsp), %rdi
    movq         (16)(%rsp), %rsi
    movq         (24)(%rsp), %rcx
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r11
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (24)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    mov          %rdx, %rax
    imulq        (24)(%rcx), %rax
    add          %rax, %r13
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm5
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r11
    mov          %r11, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r12
    mov          %rbx, %rax
    imulq        (16)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r12
    add          %r11, %r12
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r13
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm6
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    movq         %r13, (%rdi)
    add          $(32), %rbp
    add          $(32), %rsi
    add          $(32), %rcx
    add          $(32), %rdi
    mov          %r14, %r11
    sub          $(4), %r11
.p2align 6, 0x90
.Lrem_loop4_Agas_4: 
    sub          $(4), %r11
    jl           .Lexit_rem_loop4_Agas_4
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (%rsi), %ymm4, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (%rcx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rsi), %ymm5, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-8)(%rcx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vmovdqu      %ymm0, (-24)(%rdi)
    add          $(32), %rdi
    add          $(32), %rsi
    add          $(32), %rcx
    jmp          .Lrem_loop4_Agas_4
.Lexit_rem_loop4_Agas_4: 
    vmovdqu      (%rdi), %ymm0
    vpmuludq     (-16)(%rsi), %ymm6, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (-16)(%rcx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vmovdqu      %ymm0, (-24)(%rdi)
    movq         (%rsp), %rdi
    movq         (8)(%rsp), %rsi
    movq         (32)(%rsp), %r8
    xor          %rax, %rax
.Lnorm_loopgas_4: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r8
    jg           .Lnorm_loopgas_4
    movq         %rax, (%rdi)
    add          $(48), %rsp
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe4:
.size n0_cpMontMul4n3_avx2, .Lfe4-(n0_cpMontMul4n3_avx2)
 
