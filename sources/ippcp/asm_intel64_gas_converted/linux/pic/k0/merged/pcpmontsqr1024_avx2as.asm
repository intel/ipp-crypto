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
 
.globl k0_cpMontSqr1024_avx2
.type k0_cpMontSqr1024_avx2, @function
 
k0_cpMontSqr1024_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(64), %rsp
 
    movslq       %ecx, %rcx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rsi,%rcx,8)
    vmovdqu      %ymm11, (%rdx,%rcx,8)
 
    movq         %rdi, (%rsp)
    movq         %rsi, (8)(%rsp)
    movq         %rdx, (16)(%rsp)
    movq         %rcx, (24)(%rsp)
    movq         %r8, (32)(%rsp)
    mov          $(40), %rcx
    mov          %r9, %rdi
    movq         %rdi, (48)(%rsp)
    lea          (%rdi,%rcx,8), %rbx
    lea          (%rbx,%rcx,8), %r9
    movq         %r9, (40)(%rsp)
    mov          %rsi, %rax
    mov          $(4), %rcx
    vmovdqu      (%rsi), %ymm0
    vmovdqu      (32)(%rsi), %ymm1
    vmovdqu      (64)(%rsi), %ymm2
    vmovdqu      (96)(%rsi), %ymm3
    vmovdqu      (128)(%rsi), %ymm4
    vmovdqu      (160)(%rsi), %ymm5
    vmovdqu      (192)(%rsi), %ymm6
    vmovdqu      (224)(%rsi), %ymm7
    vmovdqu      (256)(%rsi), %ymm8
    vmovdqu      (288)(%rsi), %ymm9
    vmovdqu      %ymm0, (%r9)
    vpbroadcastq (%rax), %ymm10
    vpaddq       %ymm1, %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%r9)
    vpaddq       %ymm2, %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%r9)
    vpaddq       %ymm3, %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%r9)
    vpaddq       %ymm4, %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%r9)
    vpaddq       %ymm5, %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%r9)
    vpaddq       %ymm6, %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%r9)
    vpaddq       %ymm7, %ymm7, %ymm7
    vmovdqu      %ymm7, (224)(%r9)
    vpaddq       %ymm8, %ymm8, %ymm8
    vmovdqu      %ymm8, (256)(%r9)
    vpaddq       %ymm9, %ymm9, %ymm9
    vmovdqu      %ymm9, (288)(%r9)
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpbroadcastq (32)(%rax), %ymm14
    vmovdqu      %ymm11, (%rbx)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vmovdqu      %ymm11, (32)(%rbx)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vmovdqu      %ymm11, (64)(%rbx)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vmovdqu      %ymm11, (96)(%rbx)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vmovdqu      %ymm11, (128)(%rbx)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vmovdqu      %ymm11, (160)(%rbx)
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vmovdqu      %ymm11, (192)(%rbx)
    vpmuludq     (224)(%r9), %ymm10, %ymm7
    vmovdqu      %ymm11, (224)(%rbx)
    vpmuludq     (256)(%r9), %ymm10, %ymm8
    vmovdqu      %ymm11, (256)(%rbx)
    vpmuludq     (288)(%r9), %ymm10, %ymm9
    vmovdqu      %ymm11, (288)(%rbx)
    jmp          .Lsqr1024_epgas_1
.p2align 6, 0x90
.Lsqr1024_loop4gas_1: 
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpbroadcastq (32)(%rax), %ymm14
    vpaddq       (%rdi), %ymm0, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vpmuludq     (224)(%r9), %ymm10, %ymm7
    vpaddq       (224)(%rdi), %ymm7, %ymm7
    vpmuludq     (256)(%r9), %ymm10, %ymm8
    vpaddq       (256)(%rdi), %ymm8, %ymm8
    vpmuludq     (288)(%r9), %ymm10, %ymm9
    vpaddq       (288)(%rdi), %ymm9, %ymm9
.Lsqr1024_epgas_1: 
    vmovdqu      %ymm0, (%rdi)
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (32)(%rsi), %ymm14, %ymm11
    vpbroadcastq (64)(%rax), %ymm10
    vpaddq       %ymm11, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm4, %ymm4
    vpmuludq     (128)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm5, %ymm5
    vpmuludq     (160)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm6, %ymm6
    vpmuludq     (192)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm7, %ymm7
    vpmuludq     (224)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm8, %ymm8
    vpmuludq     (256)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm9, %ymm9
    vpmuludq     (288)(%r9), %ymm14, %ymm0
    vpaddq       (%rbx), %ymm0, %ymm0
    vmovdqu      %ymm2, (64)(%rdi)
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (64)(%rsi), %ymm10, %ymm11
    vpbroadcastq (96)(%rax), %ymm14
    vpaddq       %ymm11, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm5, %ymm5
    vpmuludq     (128)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm6, %ymm6
    vpmuludq     (160)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm7, %ymm7
    vpmuludq     (192)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm8, %ymm8
    vpmuludq     (224)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm9, %ymm9
    vpmuludq     (256)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm0, %ymm0
    vpmuludq     (288)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rbx), %ymm1, %ymm1
    vmovdqu      %ymm4, (128)(%rdi)
    vmovdqu      %ymm5, (160)(%rdi)
    vpmuludq     (96)(%rsi), %ymm14, %ymm11
    vpbroadcastq (128)(%rax), %ymm10
    vpaddq       %ymm11, %ymm6, %ymm6
    vpmuludq     (128)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (160)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (192)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm9, %ymm9
    vpmuludq     (224)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (256)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (288)(%r9), %ymm14, %ymm2
    vpaddq       (64)(%rbx), %ymm2, %ymm2
    vmovdqu      %ymm6, (192)(%rdi)
    vmovdqu      %ymm7, (224)(%rdi)
    vpmuludq     (128)(%rsi), %ymm10, %ymm11
    vpbroadcastq (160)(%rax), %ymm14
    vpaddq       %ymm11, %ymm8, %ymm8
    vpmuludq     (160)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm9, %ymm9
    vpmuludq     (192)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (224)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm1, %ymm1
    vpmuludq     (256)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (288)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rbx), %ymm3, %ymm3
    vmovdqu      %ymm8, (256)(%rdi)
    vmovdqu      %ymm9, (288)(%rdi)
    vpmuludq     (160)(%rsi), %ymm14, %ymm11
    vpbroadcastq (192)(%rax), %ymm10
    vpaddq       %ymm11, %ymm0, %ymm0
    vpmuludq     (192)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (224)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (256)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm3, %ymm3
    vpmuludq     (288)(%r9), %ymm14, %ymm4
    vpaddq       (128)(%rbx), %ymm4, %ymm4
    vmovdqu      %ymm0, (320)(%rdi)
    vmovdqu      %ymm1, (352)(%rdi)
    vpmuludq     (192)(%rsi), %ymm10, %ymm11
    vpbroadcastq (224)(%rax), %ymm14
    vpaddq       %ymm11, %ymm2, %ymm2
    vpmuludq     (224)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (256)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm4, %ymm4
    vpmuludq     (288)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rbx), %ymm5, %ymm5
    vmovdqu      %ymm2, (384)(%rdi)
    vmovdqu      %ymm3, (416)(%rdi)
    vpmuludq     (224)(%rsi), %ymm14, %ymm11
    vpbroadcastq (256)(%rax), %ymm10
    vpaddq       %ymm11, %ymm4, %ymm4
    vpmuludq     (256)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm5, %ymm5
    vpmuludq     (288)(%r9), %ymm14, %ymm6
    vpaddq       (192)(%rbx), %ymm6, %ymm6
    vmovdqu      %ymm4, (448)(%rdi)
    vmovdqu      %ymm5, (480)(%rdi)
    vpmuludq     (256)(%rsi), %ymm10, %ymm11
    vpbroadcastq (288)(%rax), %ymm14
    vpaddq       %ymm11, %ymm6, %ymm6
    vpmuludq     (288)(%r9), %ymm10, %ymm7
    vpaddq       (224)(%rbx), %ymm7, %ymm7
    vpmuludq     (288)(%rsi), %ymm14, %ymm8
    vpbroadcastq (8)(%rax), %ymm10
    vpaddq       (256)(%rbx), %ymm8, %ymm8
    vmovdqu      %ymm6, (512)(%rdi)
    vmovdqu      %ymm7, (544)(%rdi)
    vmovdqu      %ymm8, (576)(%rdi)
    add          $(8), %rdi
    add          $(8), %rbx
    add          $(8), %rax
    sub          $(1), %rcx
    jnz          .Lsqr1024_loop4gas_1
    movq         (48)(%rsp), %rdi
    movq         (16)(%rsp), %rcx
    movq         (32)(%rsp), %r8
    mov          $(38), %r9
    movq         (%rdi), %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    mov          %r10, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm10
    vmovdqu      (32)(%rdi), %ymm1
    vmovdqu      (64)(%rdi), %ymm2
    vmovdqu      (96)(%rdi), %ymm3
    vmovdqu      (128)(%rdi), %ymm4
    vmovdqu      (160)(%rdi), %ymm5
    vmovdqu      (192)(%rdi), %ymm6
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    vpbroadcastq %xmm10, %ymm10
    vmovdqu      (224)(%rdi), %ymm7
    vmovdqu      (256)(%rdi), %ymm8
    vmovdqu      (288)(%rdi), %ymm9
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r10
    imulq        (24)(%rcx), %rdx
    add          %rdx, %r13
    add          %r10, %r11
    mov          %r11, %rdx
    imul         %r8d, %edx
    and          $(134217727), %rdx
.p2align 6, 0x90
.Lreduction_loopgas_1: 
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (32)(%rcx), %ymm10, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (64)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (96)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (128)(%rcx), %ymm10, %ymm14
    add          %rax, %r11
    shr          $(27), %r11
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (160)(%rcx), %ymm10, %ymm14
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    vpaddq       %ymm14, %ymm5, %ymm5
    add          %rax, %r12
    vpmuludq     (192)(%rcx), %ymm10, %ymm14
    imulq        (16)(%rcx), %rdx
    add          %r11, %r12
    vpaddq       %ymm14, %ymm6, %ymm6
    add          %rdx, %r13
    vpmuludq     (224)(%rcx), %ymm10, %ymm14
    mov          %r12, %rdx
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm7, %ymm7
    vpmuludq     (256)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    and          $(134217727), %rdx
    vpmuludq     (288)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    vmovd        %edx, %xmm12
    vpbroadcastq %xmm12, %ymm12
    vpmuludq     (24)(%rcx), %ymm11, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (56)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (88)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (120)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    add          %r12, %rax
    shr          $(27), %rax
    vpmuludq     (152)(%rcx), %ymm11, %ymm14
    imulq        (8)(%rcx), %rdx
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     (184)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (216)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm7, %ymm7
    add          %r13, %rdx
    add          %rax, %rdx
    vpmuludq     (248)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    vpmuludq     (280)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    sub          $(2), %r9
    jz           .Lexit_reduction_loopgas_1
    vpmuludq     (16)(%rcx), %ymm12, %ymm14
    mov          %rdx, %r13
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (48)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    and          $(134217727), %rdx
    vpmuludq     (80)(%rcx), %ymm12, %ymm14
    vmovd        %edx, %xmm13
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (112)(%rcx), %ymm12, %ymm14
    vpbroadcastq %xmm13, %ymm13
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (144)(%rcx), %ymm12, %ymm14
    imulq        (%rcx), %rdx
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     (176)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    add          %rdx, %r13
    vpmuludq     (208)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm7, %ymm7
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpmuludq     (8)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm0, %ymm1, %ymm1
    vpaddq       %ymm14, %ymm1, %ymm1
    vmovdqu      %ymm1, (%rdi)
    vpmuludq     (240)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    vpmuludq     (272)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    vmovq        %xmm1, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovq        %xmm1, %r10
    movq         (8)(%rdi), %r11
    movq         (16)(%rdi), %r12
    movq         (24)(%rdi), %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    vpmuludq     (40)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm2, %ymm1
    vpmuludq     (72)(%rcx), %ymm13, %ymm14
    add          %rax, %r10
    vpaddq       %ymm14, %ymm3, %ymm2
    shr          $(27), %r10
    vpmuludq     (104)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    vpaddq       %ymm14, %ymm4, %ymm3
    add          %rax, %r11
    vpmuludq     (136)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    vpaddq       %ymm14, %ymm5, %ymm4
    add          %rax, %r12
    vpmuludq     (168)(%rcx), %ymm13, %ymm14
    imulq        (24)(%rcx), %rdx
    vpaddq       %ymm14, %ymm6, %ymm5
    add          %rdx, %r13
    add          %r10, %r11
    vpmuludq     (200)(%rcx), %ymm13, %ymm14
    mov          %r11, %rdx
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm7, %ymm6
    and          $(134217727), %rdx
    vpmuludq     (232)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm7
    vpmuludq     (264)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm8
    vpmuludq     (296)(%rcx), %ymm13, %ymm14
    vpaddq       (320)(%rdi), %ymm14, %ymm9
    add          $(32), %rdi
    sub          $(2), %r9
    jnz          .Lreduction_loopgas_1
.Lexit_reduction_loopgas_1: 
    movq         (%rsp), %rdi
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
    mov          $(38), %r9
    xor          %rax, %rax
.Lnorm_loopgas_1: 
    addq         (%rdi), %rax
    add          $(8), %rdi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (-8)(%rdi)
    sub          $(1), %r9
    jg           .Lnorm_loopgas_1
    movq         %rax, (%rdi)
    add          $(64), %rsp
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size k0_cpMontSqr1024_avx2, .Lfe1-(k0_cpMontSqr1024_avx2)
.p2align 6, 0x90
 
.globl k0_cpSqr1024_avx2
.type k0_cpSqr1024_avx2, @function
 
k0_cpSqr1024_avx2:
 
    push         %rbx
 
    sub          $(48), %rsp
 
    movslq       %edx, %rdx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rsi,%rdx,8)
 
    movq         %rdi, (%rsp)
    movq         %rsi, (8)(%rsp)
    movq         %rdx, (16)(%rsp)
    mov          $(40), %rdx
    mov          %rcx, %rdi
    movq         %rdi, (32)(%rsp)
    lea          (%rdi,%rdx,8), %rbx
    lea          (%rbx,%rdx,8), %r9
    movq         %r9, (24)(%rsp)
    mov          %rsi, %rax
    mov          $(4), %rcx
    vmovdqu      (%rsi), %ymm0
    vmovdqu      (32)(%rsi), %ymm1
    vmovdqu      (64)(%rsi), %ymm2
    vmovdqu      (96)(%rsi), %ymm3
    vmovdqu      (128)(%rsi), %ymm4
    vmovdqu      (160)(%rsi), %ymm5
    vmovdqu      (192)(%rsi), %ymm6
    vmovdqu      (224)(%rsi), %ymm7
    vmovdqu      (256)(%rsi), %ymm8
    vmovdqu      (288)(%rsi), %ymm9
    vmovdqu      %ymm0, (%r9)
    vpbroadcastq (%rax), %ymm10
    vpaddq       %ymm1, %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%r9)
    vpaddq       %ymm2, %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%r9)
    vpaddq       %ymm3, %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%r9)
    vpaddq       %ymm4, %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%r9)
    vpaddq       %ymm5, %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%r9)
    vpaddq       %ymm6, %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%r9)
    vpaddq       %ymm7, %ymm7, %ymm7
    vmovdqu      %ymm7, (224)(%r9)
    vpaddq       %ymm8, %ymm8, %ymm8
    vmovdqu      %ymm8, (256)(%r9)
    vpaddq       %ymm9, %ymm9, %ymm9
    vmovdqu      %ymm9, (288)(%r9)
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpbroadcastq (32)(%rax), %ymm14
    vmovdqu      %ymm11, (%rbx)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vmovdqu      %ymm11, (32)(%rbx)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vmovdqu      %ymm11, (64)(%rbx)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vmovdqu      %ymm11, (96)(%rbx)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vmovdqu      %ymm11, (128)(%rbx)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vmovdqu      %ymm11, (160)(%rbx)
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vmovdqu      %ymm11, (192)(%rbx)
    vpmuludq     (224)(%r9), %ymm10, %ymm7
    vmovdqu      %ymm11, (224)(%rbx)
    vpmuludq     (256)(%r9), %ymm10, %ymm8
    vmovdqu      %ymm11, (256)(%rbx)
    vpmuludq     (288)(%r9), %ymm10, %ymm9
    vmovdqu      %ymm11, (288)(%rbx)
    jmp          .Lsqr1024_epgas_2
.p2align 6, 0x90
.Lsqr1024_loop4gas_2: 
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpbroadcastq (32)(%rax), %ymm14
    vpaddq       (%rdi), %ymm0, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vpmuludq     (224)(%r9), %ymm10, %ymm7
    vpaddq       (224)(%rdi), %ymm7, %ymm7
    vpmuludq     (256)(%r9), %ymm10, %ymm8
    vpaddq       (256)(%rdi), %ymm8, %ymm8
    vpmuludq     (288)(%r9), %ymm10, %ymm9
    vpaddq       (288)(%rdi), %ymm9, %ymm9
.Lsqr1024_epgas_2: 
    vmovdqu      %ymm0, (%rdi)
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (32)(%rsi), %ymm14, %ymm11
    vpbroadcastq (64)(%rax), %ymm10
    vpaddq       %ymm11, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm4, %ymm4
    vpmuludq     (128)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm5, %ymm5
    vpmuludq     (160)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm6, %ymm6
    vpmuludq     (192)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm7, %ymm7
    vpmuludq     (224)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm8, %ymm8
    vpmuludq     (256)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm9, %ymm9
    vpmuludq     (288)(%r9), %ymm14, %ymm0
    vpaddq       (%rbx), %ymm0, %ymm0
    vmovdqu      %ymm2, (64)(%rdi)
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (64)(%rsi), %ymm10, %ymm11
    vpbroadcastq (96)(%rax), %ymm14
    vpaddq       %ymm11, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm5, %ymm5
    vpmuludq     (128)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm6, %ymm6
    vpmuludq     (160)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm7, %ymm7
    vpmuludq     (192)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm8, %ymm8
    vpmuludq     (224)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm9, %ymm9
    vpmuludq     (256)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm0, %ymm0
    vpmuludq     (288)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rbx), %ymm1, %ymm1
    vmovdqu      %ymm4, (128)(%rdi)
    vmovdqu      %ymm5, (160)(%rdi)
    vpmuludq     (96)(%rsi), %ymm14, %ymm11
    vpbroadcastq (128)(%rax), %ymm10
    vpaddq       %ymm11, %ymm6, %ymm6
    vpmuludq     (128)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm7, %ymm7
    vpmuludq     (160)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm8, %ymm8
    vpmuludq     (192)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm9, %ymm9
    vpmuludq     (224)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm0, %ymm0
    vpmuludq     (256)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (288)(%r9), %ymm14, %ymm2
    vpaddq       (64)(%rbx), %ymm2, %ymm2
    vmovdqu      %ymm6, (192)(%rdi)
    vmovdqu      %ymm7, (224)(%rdi)
    vpmuludq     (128)(%rsi), %ymm10, %ymm11
    vpbroadcastq (160)(%rax), %ymm14
    vpaddq       %ymm11, %ymm8, %ymm8
    vpmuludq     (160)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm9, %ymm9
    vpmuludq     (192)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (224)(%r9), %ymm10, %ymm11
    vpaddq       %ymm11, %ymm1, %ymm1
    vpmuludq     (256)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm2, %ymm2
    vpmuludq     (288)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rbx), %ymm3, %ymm3
    vmovdqu      %ymm8, (256)(%rdi)
    vmovdqu      %ymm9, (288)(%rdi)
    vpmuludq     (160)(%rsi), %ymm14, %ymm11
    vpbroadcastq (192)(%rax), %ymm10
    vpaddq       %ymm11, %ymm0, %ymm0
    vpmuludq     (192)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm1, %ymm1
    vpmuludq     (224)(%r9), %ymm14, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (256)(%r9), %ymm14, %ymm11
    vpaddq       %ymm11, %ymm3, %ymm3
    vpmuludq     (288)(%r9), %ymm14, %ymm4
    vpaddq       (128)(%rbx), %ymm4, %ymm4
    vmovdqu      %ymm0, (320)(%rdi)
    vmovdqu      %ymm1, (352)(%rdi)
    vpmuludq     (192)(%rsi), %ymm10, %ymm11
    vpbroadcastq (224)(%rax), %ymm14
    vpaddq       %ymm11, %ymm2, %ymm2
    vpmuludq     (224)(%r9), %ymm10, %ymm12
    vpaddq       %ymm12, %ymm3, %ymm3
    vpmuludq     (256)(%r9), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm4, %ymm4
    vpmuludq     (288)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rbx), %ymm5, %ymm5
    vmovdqu      %ymm2, (384)(%rdi)
    vmovdqu      %ymm3, (416)(%rdi)
    vpmuludq     (224)(%rsi), %ymm14, %ymm11
    vpbroadcastq (256)(%rax), %ymm10
    vpaddq       %ymm11, %ymm4, %ymm4
    vpmuludq     (256)(%r9), %ymm14, %ymm12
    vpaddq       %ymm12, %ymm5, %ymm5
    vpmuludq     (288)(%r9), %ymm14, %ymm6
    vpaddq       (192)(%rbx), %ymm6, %ymm6
    vmovdqu      %ymm4, (448)(%rdi)
    vmovdqu      %ymm5, (480)(%rdi)
    vpmuludq     (256)(%rsi), %ymm10, %ymm11
    vpbroadcastq (288)(%rax), %ymm14
    vpaddq       %ymm11, %ymm6, %ymm6
    vpmuludq     (288)(%r9), %ymm10, %ymm7
    vpaddq       (224)(%rbx), %ymm7, %ymm7
    vpmuludq     (288)(%rsi), %ymm14, %ymm8
    vpbroadcastq (8)(%rax), %ymm10
    vpaddq       (256)(%rbx), %ymm8, %ymm8
    vmovdqu      %ymm6, (512)(%rdi)
    vmovdqu      %ymm7, (544)(%rdi)
    vmovdqu      %ymm8, (576)(%rdi)
    add          $(8), %rdi
    add          $(8), %rbx
    add          $(8), %rax
    sub          $(1), %rcx
    jnz          .Lsqr1024_loop4gas_2
    movq         (32)(%rsp), %rsi
    movq         (%rsp), %rdi
    mov          $(76), %r9
    xor          %rax, %rax
.Lnorm_loopgas_2: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r9
    jg           .Lnorm_loopgas_2
    movq         %rax, (%rdi)
    add          $(48), %rsp
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe2:
.size k0_cpSqr1024_avx2, .Lfe2-(k0_cpSqr1024_avx2)
.p2align 6, 0x90
 
.globl k0_cpMontRed1024_avx2
.type k0_cpMontRed1024_avx2, @function
 
k0_cpMontRed1024_avx2:
 
    push         %r12
 
    push         %r13
 
    movslq       %ecx, %r9
    mov          %rdx, %rcx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rdx,%r9,8)
    movq         (%rsi), %r10
    movq         (8)(%rsi), %r11
    movq         (16)(%rsi), %r12
    movq         (24)(%rsi), %r13
    mov          %r10, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm10
    vmovdqu      (32)(%rsi), %ymm1
    vmovdqu      (64)(%rsi), %ymm2
    vmovdqu      (96)(%rsi), %ymm3
    vmovdqu      (128)(%rsi), %ymm4
    vmovdqu      (160)(%rsi), %ymm5
    vmovdqu      (192)(%rsi), %ymm6
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    add          %rax, %r10
    vpbroadcastq %xmm10, %ymm10
    vmovdqu      (224)(%rsi), %ymm7
    vmovdqu      (256)(%rsi), %ymm8
    vmovdqu      (288)(%rsi), %ymm9
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    add          %rax, %r11
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    add          %rax, %r12
    shr          $(27), %r10
    imulq        (24)(%rcx), %rdx
    add          %rdx, %r13
    add          %r10, %r11
    mov          %r11, %rdx
    imul         %r8d, %edx
    and          $(134217727), %rdx
.p2align 6, 0x90
.Lreduction_loopgas_3: 
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    vpmuludq     (32)(%rcx), %ymm10, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (64)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (96)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (128)(%rcx), %ymm10, %ymm14
    add          %rax, %r11
    shr          $(27), %r11
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (160)(%rcx), %ymm10, %ymm14
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    vpaddq       %ymm14, %ymm5, %ymm5
    add          %rax, %r12
    vpmuludq     (192)(%rcx), %ymm10, %ymm14
    imulq        (16)(%rcx), %rdx
    add          %r11, %r12
    vpaddq       %ymm14, %ymm6, %ymm6
    add          %rdx, %r13
    vpmuludq     (224)(%rcx), %ymm10, %ymm14
    mov          %r12, %rdx
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm7, %ymm7
    vpmuludq     (256)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    and          $(134217727), %rdx
    vpmuludq     (288)(%rcx), %ymm10, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    vmovd        %edx, %xmm12
    vpbroadcastq %xmm12, %ymm12
    vpmuludq     (24)(%rcx), %ymm11, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (56)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (88)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (120)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    add          %r12, %rax
    shr          $(27), %rax
    vpmuludq     (152)(%rcx), %ymm11, %ymm14
    imulq        (8)(%rcx), %rdx
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     (184)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (216)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm7, %ymm7
    add          %r13, %rdx
    add          %rax, %rdx
    vpmuludq     (248)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    vpmuludq     (280)(%rcx), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    sub          $(2), %r9
    jz           .Lexit_reduction_loopgas_3
    vpmuludq     (16)(%rcx), %ymm12, %ymm14
    mov          %rdx, %r13
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     (48)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    and          $(134217727), %rdx
    vpmuludq     (80)(%rcx), %ymm12, %ymm14
    vmovd        %edx, %xmm13
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (112)(%rcx), %ymm12, %ymm14
    vpbroadcastq %xmm13, %ymm13
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (144)(%rcx), %ymm12, %ymm14
    imulq        (%rcx), %rdx
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     (176)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    add          %rdx, %r13
    vpmuludq     (208)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm7, %ymm7
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpmuludq     (8)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm0, %ymm1, %ymm1
    vpaddq       %ymm14, %ymm1, %ymm1
    vmovdqu      %ymm1, (%rsi)
    vpmuludq     (240)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm8
    vpmuludq     (272)(%rcx), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm9
    vmovq        %xmm1, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovq        %xmm1, %r10
    movq         (8)(%rsi), %r11
    movq         (16)(%rsi), %r12
    movq         (24)(%rsi), %r13
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    vpmuludq     (40)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (%rcx), %rax
    vpaddq       %ymm14, %ymm2, %ymm1
    vpmuludq     (72)(%rcx), %ymm13, %ymm14
    add          %rax, %r10
    vpaddq       %ymm14, %ymm3, %ymm2
    shr          $(27), %r10
    vpmuludq     (104)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (8)(%rcx), %rax
    vpaddq       %ymm14, %ymm4, %ymm3
    add          %rax, %r11
    vpmuludq     (136)(%rcx), %ymm13, %ymm14
    mov          %rdx, %rax
    imulq        (16)(%rcx), %rax
    vpaddq       %ymm14, %ymm5, %ymm4
    add          %rax, %r12
    vpmuludq     (168)(%rcx), %ymm13, %ymm14
    imulq        (24)(%rcx), %rdx
    vpaddq       %ymm14, %ymm6, %ymm5
    add          %rdx, %r13
    add          %r10, %r11
    vpmuludq     (200)(%rcx), %ymm13, %ymm14
    mov          %r11, %rdx
    imul         %r8d, %edx
    vpaddq       %ymm14, %ymm7, %ymm6
    and          $(134217727), %rdx
    vpmuludq     (232)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm8, %ymm7
    vpmuludq     (264)(%rcx), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm9, %ymm8
    vpmuludq     (296)(%rcx), %ymm13, %ymm14
    vpaddq       (320)(%rsi), %ymm14, %ymm9
    add          $(32), %rsi
    sub          $(2), %r9
    jnz          .Lreduction_loopgas_3
.Lexit_reduction_loopgas_3: 
    movq         (%rsp), %rsi
    movq         %r12, (%rsi)
    movq         %r13, (8)(%rsi)
    vmovdqu      %ymm1, (16)(%rsi)
    vmovdqu      %ymm2, (48)(%rsi)
    vmovdqu      %ymm3, (80)(%rsi)
    vmovdqu      %ymm4, (112)(%rsi)
    vmovdqu      %ymm5, (144)(%rsi)
    vmovdqu      %ymm6, (176)(%rsi)
    vmovdqu      %ymm7, (208)(%rsi)
    vmovdqu      %ymm8, (240)(%rsi)
    vmovdqu      %ymm9, (272)(%rsi)
    mov          $(38), %r9
    xor          %rax, %rax
.Lnorm_loopgas_3: 
    addq         (%rsi), %rax
    add          $(8), %rsi
    mov          $(134217727), %rdx
    and          %rax, %rdx
    shr          $(27), %rax
    movq         %rdx, (%rdi)
    add          $(8), %rdi
    sub          $(1), %r9
    jg           .Lnorm_loopgas_3
    movq         %rax, (%rdi)
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    ret
.Lfe3:
.size k0_cpMontRed1024_avx2, .Lfe3-(k0_cpMontRed1024_avx2)
 
