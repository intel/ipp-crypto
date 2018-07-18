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
 
.globl cpSqr_avx2_V0
.type cpSqr_avx2_V0, @function
 
cpSqr_avx2_V0:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    sub          $(56), %rsp
 
    movslq       %edx, %rdx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rsi,%rdx,8)
 
    lea          (3)(%rdx), %rax
    and          $(-4), %rax
    shr          $(2), %rax
    movq         %rdi, (%rsp)
    movq         %rsi, (8)(%rsp)
    movq         %rdx, (16)(%rsp)
    movq         %rax, (24)(%rsp)
    mov          %rcx, %rdi
    shl          $(2), %rax
    movq         %rdi, (40)(%rsp)
    lea          (%rdi,%rax,8), %rbx
    lea          (%rbx,%rax,8), %r9
    movq         %r9, (32)(%rsp)
.Lclr_dbl_loopgas_1: 
    vmovdqu      (%rsi), %ymm0
    vpaddq       %ymm0, %ymm0, %ymm0
    vmovdqu      %ymm11, (%rdi)
    vmovdqu      %ymm11, (%rbx)
    vmovdqu      %ymm0, (%r9)
    add          $(32), %rsi
    add          $(32), %rdi
    add          $(32), %rbx
    add          $(32), %r9
    sub          $(4), %rax
    jg           .Lclr_dbl_loopgas_1
    movq         (8)(%rsp), %rsi
    movq         (40)(%rsp), %rdi
    movq         (32)(%rsp), %r9
    mov          %rsi, %rax
    mov          $(4), %rcx
.p2align 5, 0x90
.Lsqr_offset_loopgas_1: 
    movq         (24)(%rsp), %r10
    mov          $(3), %r12
    and          %r10, %r12
    lea          (-7)(%r10), %r11
    shr          $(2), %r10
    sub          $(1), %r10
    push         %r9
    push         %rsi
    push         %rdi
    push         %rax
.p2align 5, 0x90
.Lsqr_outer_loopgas_1: 
    vpbroadcastq (%rax), %ymm10
    vpbroadcastq (32)(%rax), %ymm11
    vpbroadcastq (64)(%rax), %ymm12
    vpbroadcastq (96)(%rax), %ymm13
    vmovdqu      (128)(%r9), %ymm7
    vmovdqu      (160)(%r9), %ymm8
    vmovdqu      (192)(%r9), %ymm9
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpmuludq     %ymm7, %ymm10, %ymm4
    vpmuludq     %ymm8, %ymm10, %ymm5
    vpmuludq     %ymm9, %ymm10, %ymm6
    vpmuludq     (32)(%rsi), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     %ymm7, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     %ymm8, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (64)(%rsi), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     %ymm7, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (96)(%rsi), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    push         %r11
    push         %rdi
    push         %r9
    add          $(224), %rdi
    add          $(224), %r9
.p2align 5, 0x90
.Lsqr_inner_loopgas_1: 
    vmovdqu      (%r9), %ymm6
    vpmuludq     %ymm7, %ymm13, %ymm0
    vpmuludq     %ymm8, %ymm12, %ymm1
    vpmuludq     %ymm9, %ymm11, %ymm2
    vpmuludq     %ymm6, %ymm10, %ymm3
    vpaddq       %ymm1, %ymm0, %ymm0
    vpaddq       %ymm2, %ymm0, %ymm0
    vpaddq       %ymm3, %ymm0, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vmovdqa      %ymm8, %ymm7
    vmovdqa      %ymm9, %ymm8
    vmovdqa      %ymm6, %ymm9
    add          $(32), %r9
    add          $(32), %rdi
    sub          $(1), %r11
    jg           .Lsqr_inner_loopgas_1
    vpmuludq     %ymm9, %ymm11, %ymm1
    vpmuludq     %ymm8, %ymm12, %ymm2
    vpmuludq     %ymm7, %ymm13, %ymm3
    vpaddq       %ymm2, %ymm1, %ymm1
    vpaddq       %ymm3, %ymm1, %ymm1
    vpaddq       (%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (%rdi)
    vpmuludq     %ymm9, %ymm12, %ymm2
    vpmuludq     %ymm8, %ymm13, %ymm3
    vpaddq       %ymm3, %ymm2, %ymm2
    vpaddq       (32)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (32)(%rdi)
    vpmuludq     %ymm9, %ymm13, %ymm3
    vpaddq       (64)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (64)(%rdi)
    pop          %r9
    pop          %rdi
    pop          %r11
    add          $(128), %r9
    add          $(256), %rdi
    add          $(128), %rax
    add          $(128), %rsi
    sub          $(4), %r11
    sub          $(1), %r10
    jg           .Lsqr_outer_loopgas_1
    cmp          $(2), %r12
    ja           .L_4n_3gas_1
    jz           .L_4n_2gas_1
    jp           .L_4n_1gas_1
    jmp          .L_4n_0gas_1
.L_4n_3gas_1: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_2gas_1: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_1gas_1: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_0gas_1: 
    vpbroadcastq (%rax), %ymm10
    vpbroadcastq (32)(%rax), %ymm11
    vpbroadcastq (64)(%rax), %ymm12
    vpbroadcastq (96)(%rax), %ymm13
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpmuludq     (32)(%rsi), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm11, %ymm4
    vpmuludq     (64)(%rsi), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm12, %ymm5
    vpmuludq     (96)(%rsi), %ymm13, %ymm6
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    pop          %rax
    pop          %rdi
    pop          %rsi
    pop          %r9
    add          $(8), %rdi
    add          $(8), %rax
    sub          $(1), %rcx
    jg           .Lsqr_offset_loopgas_1
    add          $(56), %rsp
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size cpSqr_avx2_V0, .Lfe1-(cpSqr_avx2_V0)
.p2align 5, 0x90
 
.globl cpSqr_avx2
.type cpSqr_avx2, @function
 
cpSqr_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    sub          $(56), %rsp
 
    movslq       %edx, %rdx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rsi,%rdx,8)
 
    lea          (3)(%rdx), %rax
    and          $(-4), %rax
    shr          $(2), %rax
    movq         %rdi, (%rsp)
    movq         %rsi, (8)(%rsp)
    movq         %rdx, (16)(%rsp)
    movq         %rax, (24)(%rsp)
    mov          %rcx, %rdi
    shl          $(2), %rax
    movq         %rdi, (40)(%rsp)
    lea          (%rdi,%rax,8), %rbx
    lea          (%rbx,%rax,8), %r9
    movq         %r9, (32)(%rsp)
.Lclr_dbl_loopgas_2: 
    vmovdqu      (%rsi), %ymm0
    vpaddq       %ymm0, %ymm0, %ymm0
    vmovdqu      %ymm11, (%rdi)
    vmovdqu      %ymm11, (%rbx)
    vmovdqu      %ymm0, (%r9)
    add          $(32), %rsi
    add          $(32), %rdi
    add          $(32), %rbx
    add          $(32), %r9
    sub          $(4), %rax
    jg           .Lclr_dbl_loopgas_2
    movq         (8)(%rsp), %rsi
    movq         (40)(%rsp), %rdi
    movq         (32)(%rsp), %r9
    mov          %rsi, %rax
    mov          $(4), %rcx
.p2align 5, 0x90
.Lsqr_offset_loopgas_2: 
    movq         (24)(%rsp), %r10
    mov          $(3), %r12
    and          %r10, %r12
    lea          (-7)(%r10), %r11
    shr          $(2), %r10
    sub          $(1), %r10
    push         %r9
    push         %rsi
    push         %rdi
    push         %rax
.p2align 5, 0x90
.Lsqr_outer_loopgas_2: 
    vpbroadcastq (%rax), %ymm10
    vpbroadcastq (32)(%rax), %ymm11
    vpbroadcastq (64)(%rax), %ymm12
    vpbroadcastq (96)(%rax), %ymm13
    vmovdqu      (128)(%r9), %ymm7
    vmovdqu      (160)(%r9), %ymm8
    vmovdqu      (192)(%r9), %ymm9
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpmuludq     %ymm7, %ymm10, %ymm4
    vpmuludq     %ymm8, %ymm10, %ymm5
    vpmuludq     %ymm9, %ymm10, %ymm6
    vpmuludq     (32)(%rsi), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     %ymm7, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     %ymm8, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (64)(%rsi), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm5, %ymm5
    vpmuludq     %ymm7, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpmuludq     (96)(%rsi), %ymm13, %ymm14
    vpaddq       %ymm14, %ymm6, %ymm6
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    push         %r11
    push         %rdi
    push         %r9
    add          $(224), %rdi
    add          $(224), %r9
    sub          $(4), %r11
    jl           .Lexit_sqr_inner_loop4gas_2
.p2align 5, 0x90
.Lsqr_inner_loop4gas_2: 
    vmovdqu      (%r9), %ymm6
    vpmuludq     %ymm7, %ymm13, %ymm14
    vpaddq       (%rdi), %ymm14, %ymm0
    vpmuludq     %ymm8, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vpmuludq     %ymm9, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vpmuludq     %ymm6, %ymm10, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vmovdqu      (32)(%r9), %ymm7
    vpmuludq     %ymm8, %ymm13, %ymm14
    vpaddq       (32)(%rdi), %ymm14, %ymm1
    vpmuludq     %ymm9, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     %ymm6, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm1, %ymm1
    vpmuludq     %ymm7, %ymm10, %ymm14
    vpaddq       %ymm14, %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vmovdqu      (64)(%r9), %ymm8
    vpmuludq     %ymm9, %ymm13, %ymm14
    vpaddq       (64)(%rdi), %ymm14, %ymm2
    vpmuludq     %ymm6, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     %ymm7, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     %ymm8, %ymm10, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vmovdqu      (96)(%r9), %ymm9
    vpmuludq     %ymm6, %ymm13, %ymm14
    vpaddq       (96)(%rdi), %ymm14, %ymm3
    vpmuludq     %ymm7, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     %ymm8, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     %ymm9, %ymm10, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    add          $(128), %r9
    add          $(128), %rdi
    sub          $(4), %r11
    jge          .Lsqr_inner_loop4gas_2
.Lexit_sqr_inner_loop4gas_2: 
    add          $(4), %r11
    jz           .Lexit_sqr_inner_loopgas_2
.Lsqr_inner_loopgas_2: 
    vmovdqu      (%r9), %ymm6
    vpmuludq     %ymm7, %ymm13, %ymm14
    vpaddq       (%rdi), %ymm14, %ymm0
    vpmuludq     %ymm8, %ymm12, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vpmuludq     %ymm9, %ymm11, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vpmuludq     %ymm6, %ymm10, %ymm14
    vpaddq       %ymm14, %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vmovdqa      %ymm8, %ymm7
    vmovdqa      %ymm9, %ymm8
    vmovdqa      %ymm6, %ymm9
    add          $(32), %r9
    add          $(32), %rdi
    sub          $(1), %r11
    jg           .Lsqr_inner_loopgas_2
.Lexit_sqr_inner_loopgas_2: 
    vpmuludq     %ymm9, %ymm11, %ymm1
    vpmuludq     %ymm8, %ymm12, %ymm2
    vpmuludq     %ymm7, %ymm13, %ymm3
    vpaddq       %ymm2, %ymm1, %ymm1
    vpaddq       %ymm3, %ymm1, %ymm1
    vpaddq       (%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (%rdi)
    vpmuludq     %ymm9, %ymm12, %ymm2
    vpmuludq     %ymm8, %ymm13, %ymm3
    vpaddq       %ymm3, %ymm2, %ymm2
    vpaddq       (32)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (32)(%rdi)
    vpmuludq     %ymm9, %ymm13, %ymm3
    vpaddq       (64)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (64)(%rdi)
    pop          %r9
    pop          %rdi
    pop          %r11
    add          $(128), %r9
    add          $(256), %rdi
    add          $(128), %rax
    add          $(128), %rsi
    sub          $(4), %r11
    sub          $(1), %r10
    jg           .Lsqr_outer_loopgas_2
    cmp          $(2), %r12
    ja           .L_4n_3gas_2
    jz           .L_4n_2gas_2
    jp           .L_4n_1gas_2
    jmp          .L_4n_0gas_2
.L_4n_3gas_2: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpmuludq     (192)(%r9), %ymm10, %ymm6
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_2gas_2: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpmuludq     (160)(%r9), %ymm10, %ymm5
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_1gas_2: 
    vpbroadcastq (%rax), %ymm10
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpmuludq     (128)(%r9), %ymm10, %ymm4
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    add          $(64), %rdi
    add          $(32), %rsi
    add          $(32), %rax
    add          $(32), %r9
.L_4n_0gas_2: 
    vpbroadcastq (%rax), %ymm10
    vpbroadcastq (32)(%rax), %ymm11
    vpbroadcastq (64)(%rax), %ymm12
    vpbroadcastq (96)(%rax), %ymm13
    vpmuludq     (%rsi), %ymm10, %ymm0
    vpmuludq     (32)(%r9), %ymm10, %ymm1
    vpmuludq     (64)(%r9), %ymm10, %ymm2
    vpmuludq     (96)(%r9), %ymm10, %ymm3
    vpmuludq     (32)(%rsi), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm2, %ymm2
    vpmuludq     (64)(%r9), %ymm11, %ymm14
    vpaddq       %ymm14, %ymm3, %ymm3
    vpmuludq     (96)(%r9), %ymm11, %ymm4
    vpmuludq     (64)(%rsi), %ymm12, %ymm14
    vpaddq       %ymm14, %ymm4, %ymm4
    vpmuludq     (96)(%r9), %ymm12, %ymm5
    vpmuludq     (96)(%rsi), %ymm13, %ymm6
    vpaddq       (%rdi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rdi)
    vpaddq       (32)(%rdi), %ymm1, %ymm1
    vmovdqu      %ymm1, (32)(%rdi)
    vpaddq       (64)(%rdi), %ymm2, %ymm2
    vmovdqu      %ymm2, (64)(%rdi)
    vpaddq       (96)(%rdi), %ymm3, %ymm3
    vmovdqu      %ymm3, (96)(%rdi)
    vpaddq       (128)(%rdi), %ymm4, %ymm4
    vmovdqu      %ymm4, (128)(%rdi)
    vpaddq       (160)(%rdi), %ymm5, %ymm5
    vmovdqu      %ymm5, (160)(%rdi)
    vpaddq       (192)(%rdi), %ymm6, %ymm6
    vmovdqu      %ymm6, (192)(%rdi)
    pop          %rax
    pop          %rdi
    pop          %rsi
    pop          %r9
    add          $(8), %rdi
    add          $(8), %rax
    sub          $(1), %rcx
    jg           .Lsqr_offset_loopgas_2
    add          $(56), %rsp
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe2:
.size cpSqr_avx2, .Lfe2-(cpSqr_avx2)
.p2align 5, 0x90
 
.globl cpMontRed_avx2
.type cpMontRed_avx2, @function
 
cpMontRed_avx2:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    sub          $(72), %rsp
 
    movslq       %ecx, %r9
    movq         %rdi, (%rsp)
    movq         %rsi, (8)(%rsp)
    movq         %rdx, (16)(%rsp)
    movq         %r9, (24)(%rsp)
    lea          (%r9,%r9), %rcx
    movq         %rcx, (32)(%rsp)
    lea          (3)(%r9), %r11
    and          $(-4), %r11
    movq         %r11, (40)(%rsp)
    mov          $(3), %r11
    and          %r9, %r11
    movq         %r11, (48)(%rsp)
    mov          %rdx, %rbx
    vpxor        %ymm11, %ymm11, %ymm11
    vmovdqu      %ymm11, (%rbx,%r9,8)
    vmovdqu      %ymm11, (%rsi,%rcx,8)
.p2align 5, 0x90
.Louter_reduction_loop4gas_3: 
    movq         (%rsi), %r10
    movq         (8)(%rsi), %r11
    movq         (16)(%rsi), %r12
    movq         (24)(%rsi), %r13
    mov          %r10, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm8
    vpbroadcastq %xmm8, %ymm8
    mov          %rdx, %rax
    imulq        (%rbx), %rax
    add          %rax, %r10
    shr          $(27), %r10
    mov          %rdx, %rax
    imulq        (8)(%rbx), %rax
    add          %rax, %r11
    add          %r10, %r11
    mov          %rdx, %rax
    imulq        (16)(%rbx), %rax
    add          %rax, %r12
    imulq        (24)(%rbx), %rdx
    add          %rdx, %r13
    cmp          $(1), %r9
    jz           .Llast_1gas_3
    mov          %r11, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm9
    vpbroadcastq %xmm9, %ymm9
    mov          %rdx, %rax
    imulq        (%rbx), %rax
    add          %rax, %r11
    shr          $(27), %r11
    mov          %rdx, %rax
    imulq        (8)(%rbx), %rax
    add          %rax, %r12
    add          %r11, %r12
    imulq        (16)(%rbx), %rdx
    add          %rdx, %r13
    cmp          $(2), %r9
    jz           .Llast_2gas_3
    mov          %r12, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm10
    vpbroadcastq %xmm10, %ymm10
    mov          %rdx, %rax
    imulq        (%rbx), %rax
    add          %rax, %r12
    shr          $(27), %r12
    imulq        (8)(%rbx), %rdx
    add          %rdx, %r13
    add          %r12, %r13
    cmp          $(3), %r9
    jz           .Llast_3gas_3
    mov          %r13, %rdx
    imul         %r8d, %edx
    and          $(134217727), %edx
    vmovd        %edx, %xmm11
    vpbroadcastq %xmm11, %ymm11
    imulq        (%rbx), %rdx
    add          %rdx, %r13
    shr          $(27), %r13
    vmovq        %r13, %xmm0
    vpaddq       (32)(%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (32)(%rsi)
    add          $(32), %rbx
    add          $(32), %rsi
    movq         (40)(%rsp), %r11
    sub          $(4), %r11
.p2align 5, 0x90
.Linner_reduction_loop16gas_3: 
    sub          $(16), %r11
    jl           .Lexit_inner_reduction_loop16gas_3
    vmovdqu      (%rsi), %ymm0
    vmovdqu      (32)(%rsi), %ymm1
    vmovdqu      (64)(%rsi), %ymm2
    vmovdqu      (96)(%rsi), %ymm3
    vpmuludq     (%rbx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (32)(%rbx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (64)(%rbx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (96)(%rbx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-8)(%rbx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (24)(%rbx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (56)(%rbx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (88)(%rbx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-16)(%rbx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (16)(%rbx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (48)(%rbx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (80)(%rbx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vpmuludq     (-24)(%rbx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (8)(%rbx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm1, %ymm1
    vpmuludq     (40)(%rbx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm2, %ymm2
    vpmuludq     (72)(%rbx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm3, %ymm3
    vmovdqu      %ymm0, (%rsi)
    vmovdqu      %ymm1, (32)(%rsi)
    vmovdqu      %ymm2, (64)(%rsi)
    vmovdqu      %ymm3, (96)(%rsi)
    add          $(128), %rsi
    add          $(128), %rbx
    jmp          .Linner_reduction_loop16gas_3
.Lexit_inner_reduction_loop16gas_3: 
    add          $(16), %r11
    jz           .Lexit_inner_reductiongas_3
.Linner_reduction_loop4gas_3: 
    sub          $(4), %r11
    jl           .Lexit_inner_reductiongas_3
    vmovdqu      (%rsi), %ymm0
    vpmuludq     (%rbx), %ymm8, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-8)(%rbx), %ymm9, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-16)(%rbx), %ymm10, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vpmuludq     (-24)(%rbx), %ymm11, %ymm13
    vpaddq       %ymm13, %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    add          $(32), %rsi
    add          $(32), %rbx
    jmp          .Linner_reduction_loop4gas_3
.Lexit_inner_reductiongas_3: 
    movq         (48)(%rsp), %rax
    cmp          $(2), %rax
    ja           .L_4n_3gas_3
    jz           .L_4n_2gas_3
    jp           .Lnext_reduction_loop4gas_3
.L_4n_0gas_3: 
    vpmuludq     (-8)(%rbx), %ymm9, %ymm0
    vpmuludq     (-16)(%rbx), %ymm10, %ymm1
    vpmuludq     (-24)(%rbx), %ymm11, %ymm2
    vpaddq       %ymm1, %ymm0, %ymm0
    vpaddq       %ymm2, %ymm0, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    jmp          .Lnext_reduction_loop4gas_3
.L_4n_2gas_3: 
    vpmuludq     (-24)(%rbx), %ymm11, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    jmp          .Lnext_reduction_loop4gas_3
.L_4n_3gas_3: 
    vpmuludq     (-16)(%rbx), %ymm10, %ymm0
    vpmuludq     (-24)(%rbx), %ymm11, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
.Lnext_reduction_loop4gas_3: 
    movq         (8)(%rsp), %rsi
    add          $(32), %rsi
    movq         %rsi, (8)(%rsp)
    movq         (16)(%rsp), %rbx
    sub          $(4), %r9
    jg           .Louter_reduction_loop4gas_3
.Lexit_outer_reduction_loop4gas_3: 
    cmp          $(2), %r9
    ja           .Llast_3gas_3
    jz           .Llast_2gas_3
    jp           .Llast_1gas_3
    jmp          .Lnormalizationgas_3
.Llast_3gas_3: 
    movq         %r13, (24)(%rsi)
    add          $(32), %rsi
    add          $(32), %rbx
    movq         (40)(%rsp), %r11
    sub          $(4), %r11
.p2align 5, 0x90
.Lrem_loop4_4n_3gas_3: 
    vpmuludq     (%rbx), %ymm8, %ymm0
    vpmuludq     (-8)(%rbx), %ymm9, %ymm1
    vpmuludq     (-16)(%rbx), %ymm10, %ymm2
    vpaddq       %ymm1, %ymm0, %ymm0
    vpaddq       %ymm2, %ymm0, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    add          $(32), %rsi
    add          $(32), %rbx
    sub          $(4), %r11
    jg           .Lrem_loop4_4n_3gas_3
    vpmuludq     (-16)(%rbx), %ymm10, %ymm2
    vpaddq       (%rsi), %ymm2, %ymm2
    vmovdqu      %ymm2, (%rsi)
    jmp          .Lnormalizationgas_3
.Llast_2gas_3: 
    movq         %r12, (16)(%rsi)
    movq         %r13, (24)(%rsi)
    add          $(32), %rbx
    add          $(32), %rsi
    movq         (40)(%rsp), %r11
    sub          $(4), %r11
.p2align 5, 0x90
.Lrem_loop4_4n_2gas_3: 
    vpmuludq     (%rbx), %ymm8, %ymm0
    vpmuludq     (-8)(%rbx), %ymm9, %ymm1
    vpaddq       %ymm1, %ymm0, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    add          $(32), %rsi
    add          $(32), %rbx
    sub          $(4), %r11
    jg           .Lrem_loop4_4n_2gas_3
    jmp          .Lnormalizationgas_3
.Llast_1gas_3: 
    movq         %r11, (8)(%rsi)
    movq         %r12, (16)(%rsi)
    movq         %r13, (24)(%rsi)
    add          $(32), %rbx
    add          $(32), %rsi
    movq         (40)(%rsp), %r11
    sub          $(4), %r11
.p2align 5, 0x90
.Lrem_loop4_4n_1gas_3: 
    vpmuludq     (%rbx), %ymm8, %ymm0
    vpaddq       (%rsi), %ymm0, %ymm0
    vmovdqu      %ymm0, (%rsi)
    add          $(32), %rbx
    add          $(32), %rsi
    sub          $(4), %r11
    jg           .Lrem_loop4_4n_1gas_3
.p2align 5, 0x90
.Lnormalizationgas_3: 
    movq         (48)(%rsp), %rax
    movq         (8)(%rsp), %rsi
    movq         (%rsp), %rdi
    movq         (24)(%rsp), %r9
    lea          (%rsi,%rax,8), %rsi
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
    add          $(72), %rsp
vzeroupper 
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe3:
.size cpMontRed_avx2, .Lfe3-(cpMontRed_avx2)
 
