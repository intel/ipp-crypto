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
 
.globl n0_cpMontMul1024_avx2
.type n0_cpMontMul1024_avx2, @function
 
n0_cpMontMul1024_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(32), %rsp
 
    mov          %rdx, %rbp
    movslq       %r8d, %r8
vzeroall 
    vmovdqu      %ymm0, (%rsi,%r8,8)
    vmovdqu      %ymm0, (%rcx,%r8,8)
    xor          %r10, %r10
    vmovdqu      %ymm0, (%rsp)
.p2align 6, 0x90
.Lloop4_Bgas_1: 
    movq         (%rbp), %rbx
    vpbroadcastq (%rbp), %ymm0
    mov          %rbx, %r10
    imulq        (%rsi), %r10
    addq         (%rsp), %r10
    mov          %r10, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %r11
    imulq        (8)(%rsi), %r11
    addq         (8)(%rsp), %r11
    mov          %rbx, %r12
    imulq        (16)(%rsi), %r12
    addq         (16)(%rsp), %r12
    mov          %rbx, %r13
    imulq        (24)(%rsi), %r13
    addq         (24)(%rsp), %r13
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (32)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (64)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (128)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (160)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (192)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (224)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (256)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (288)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
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
    vpmuludq     (32)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (64)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (128)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (160)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (192)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (224)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (256)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (288)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    movq         (8)(%rbp), %rbx
    vpbroadcastq (8)(%rbp), %ymm0
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
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (24)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (56)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (120)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (152)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (184)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (216)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (248)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (280)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
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
    vpmuludq     (24)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (56)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (120)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (152)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (184)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (216)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (248)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (280)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    sub          $(2), %r8
    jz           .Lexit_loop_Bgas_1
    movq         (16)(%rbp), %rbx
    vpbroadcastq (16)(%rbp), %ymm0
    mov          %rbx, %rax
    imulq        (%rsi), %rax
    add          %rax, %r12
    mov          %r12, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    mov          %rbx, %rax
    imulq        (8)(%rsi), %rax
    add          %rax, %r13
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (16)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (48)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (112)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (144)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (176)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (208)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (240)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (272)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r13
    add          %r12, %r13
    vpmuludq     (16)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (48)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (112)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (144)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (176)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (208)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (240)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (272)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    movq         (24)(%rbp), %rbx
    vpbroadcastq (24)(%rbp), %ymm0
    imulq        (%rsi), %rbx
    add          %rbx, %r13
    mov          %r13, %rdx
    imul         %r9d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (8)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (40)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (104)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm4
    vpmuludq     (136)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm5
    vpmuludq     (168)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (200)(%rsi), %ymm0, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (232)(%rsi), %ymm0, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (264)(%rsi), %ymm0, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    vpmuludq     (296)(%rsi), %ymm0, %ymm10
    imulq        (%rcx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm14
    vpmuludq     (8)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpaddq       %ymm14, %ymm1, %ymm1
    vmovdqu      %ymm1, (%rsp)
    vpmuludq     (40)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm1
    vpmuludq     (72)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm2
    vpmuludq     (104)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm4, %ymm3
    vpmuludq     (136)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm5, %ymm4
    vpmuludq     (168)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm5
    vpmuludq     (200)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm6
    vpmuludq     (232)(%rcx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm7
    vpmuludq     (264)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm8
    vpmuludq     (296)(%rcx), %ymm11, %ymm12
    vpaddq       %ymm12, %ymm10, %ymm9
    add          $(32), %rbp
    sub          $(2), %r8
    jnz          .Lloop4_Bgas_1
.Lexit_loop_Bgas_1: 
    movq         %r12, (%rdi)
    movq         %r13, (8)(%rdi)
    vmovdqu      %ymm1, (16)(%rdi)
    vmovdqu      %ymm2, (48)(%rdi)
    vmovdqu      %ymm3, (80)(%rdi)
    vmovdqu      %ymm4, (112)(%rdi)
    vmovdqu      %ymm5, (144)(%rdi)
    vmovdqu      %ymm6, (176)(%rdi)
    vmovdqu      %ymm7, (208)(%rdi)
    vmovdqu      %ymm8, (240)(%rdi)
    vmovdqu      %ymm9, (272)(%rdi)
    mov          $(38), %r8
    xor          %rax, %rax
.Lnorm_loopgas_1: 
    addq         (%rdi), %rax
    add          $(8), %rdi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (-8)(%rdi)
    sub          $(1), %r8
    jg           .Lnorm_loopgas_1
    movq         %rax, (%rdi)
    add          $(32), %rsp
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size n0_cpMontMul1024_avx2, .Lfe1-(n0_cpMontMul1024_avx2)
 
