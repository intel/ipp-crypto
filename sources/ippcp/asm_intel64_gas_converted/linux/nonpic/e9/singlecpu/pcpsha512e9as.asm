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
 
SHUFB_BSWAP:
.byte  7,6,5,4,3,2,1,0, 15,14,13,12,11,10,9,8 
.p2align 5, 0x90
 
.globl UpdateSHA512
.type UpdateSHA512, @function
 
UpdateSHA512:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(40), %rsp
 
    vmovdqa      SHUFB_BSWAP(%rip), %xmm9
    movslq       %edx, %rdx
.p2align 5, 0x90
.Lsha512_block_loopgas_1: 
    vmovdqu      (%rsi), %xmm0
    vpshufb      %xmm9, %xmm0, %xmm0
    vmovdqu      (16)(%rsi), %xmm1
    vpshufb      %xmm9, %xmm1, %xmm1
    vmovdqu      (32)(%rsi), %xmm2
    vpshufb      %xmm9, %xmm2, %xmm2
    vmovdqu      (48)(%rsi), %xmm3
    vpshufb      %xmm9, %xmm3, %xmm3
    vmovdqu      (64)(%rsi), %xmm4
    vpshufb      %xmm9, %xmm4, %xmm4
    vmovdqu      (80)(%rsi), %xmm5
    vpshufb      %xmm9, %xmm5, %xmm5
    vmovdqu      (96)(%rsi), %xmm6
    vpshufb      %xmm9, %xmm6, %xmm6
    vmovdqu      (112)(%rsi), %xmm7
    vpshufb      %xmm9, %xmm7, %xmm7
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    vpaddq       (%rcx), %xmm0, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm4, %xmm5, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm0, %xmm1, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm0, %xmm0
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm7, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm7, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm7, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm7, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm7, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm0, %xmm0
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm0, %xmm0
    add          %rax, %r14
    vpaddq       (16)(%rcx), %xmm1, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm5, %xmm6, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm1, %xmm2, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm1, %xmm1
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm0, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm0, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm0, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm0, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm0, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm1, %xmm1
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm1, %xmm1
    add          %rax, %r12
    vpaddq       (32)(%rcx), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm6, %xmm7, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm2, %xmm3, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm2, %xmm2
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm1, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm1, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm1, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm1, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm1, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm2, %xmm2
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm2, %xmm2
    add          %rax, %r10
    vpaddq       (48)(%rcx), %xmm3, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm7, %xmm0, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm3, %xmm4, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm3, %xmm3
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm2, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm2, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm2, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm2, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm2, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm3, %xmm3
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm3, %xmm3
    add          %rax, %r8
    vpaddq       (64)(%rcx), %xmm4, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm0, %xmm1, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm4, %xmm5, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm4, %xmm4
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm3, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm3, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm3, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm3, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm3, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm4, %xmm4
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm4, %xmm4
    add          %rax, %r14
    vpaddq       (80)(%rcx), %xmm5, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm1, %xmm2, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm5, %xmm6, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm5, %xmm5
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm4, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm4, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm4, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm4, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm4, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm5, %xmm5
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm5, %xmm5
    add          %rax, %r12
    vpaddq       (96)(%rcx), %xmm6, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm2, %xmm3, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm6, %xmm7, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm6, %xmm6
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm5, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm5, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm5, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm5, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm5, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm6, %xmm6
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm6, %xmm6
    add          %rax, %r10
    vpaddq       (112)(%rcx), %xmm7, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm3, %xmm4, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm7, %xmm0, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm7, %xmm7
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm6, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm6, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm6, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm6, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm6, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm7, %xmm7
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm7, %xmm7
    add          %rax, %r8
    vpaddq       (128)(%rcx), %xmm0, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm4, %xmm5, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm0, %xmm1, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm0, %xmm0
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm7, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm7, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm7, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm7, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm7, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm0, %xmm0
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm0, %xmm0
    add          %rax, %r14
    vpaddq       (144)(%rcx), %xmm1, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm5, %xmm6, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm1, %xmm2, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm1, %xmm1
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm0, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm0, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm0, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm0, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm0, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm1, %xmm1
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm1, %xmm1
    add          %rax, %r12
    vpaddq       (160)(%rcx), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm6, %xmm7, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm2, %xmm3, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm2, %xmm2
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm1, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm1, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm1, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm1, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm1, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm2, %xmm2
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm2, %xmm2
    add          %rax, %r10
    vpaddq       (176)(%rcx), %xmm3, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm7, %xmm0, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm3, %xmm4, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm3, %xmm3
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm2, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm2, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm2, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm2, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm2, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm3, %xmm3
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm3, %xmm3
    add          %rax, %r8
    vpaddq       (192)(%rcx), %xmm4, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm0, %xmm1, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm4, %xmm5, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm4, %xmm4
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm3, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm3, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm3, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm3, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm3, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm4, %xmm4
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm4, %xmm4
    add          %rax, %r14
    vpaddq       (208)(%rcx), %xmm5, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm1, %xmm2, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm5, %xmm6, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm5, %xmm5
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm4, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm4, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm4, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm4, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm4, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm5, %xmm5
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm5, %xmm5
    add          %rax, %r12
    vpaddq       (224)(%rcx), %xmm6, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm2, %xmm3, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm6, %xmm7, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm6, %xmm6
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm5, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm5, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm5, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm5, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm5, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm6, %xmm6
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm6, %xmm6
    add          %rax, %r10
    vpaddq       (240)(%rcx), %xmm7, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm3, %xmm4, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm7, %xmm0, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm7, %xmm7
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm6, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm6, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm6, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm6, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm6, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm7, %xmm7
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm7, %xmm7
    add          %rax, %r8
    vpaddq       (256)(%rcx), %xmm0, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm4, %xmm5, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm0, %xmm1, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm0, %xmm0
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm7, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm7, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm7, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm7, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm7, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm0, %xmm0
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm0, %xmm0
    add          %rax, %r14
    vpaddq       (272)(%rcx), %xmm1, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm5, %xmm6, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm1, %xmm2, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm1, %xmm1
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm0, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm0, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm0, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm0, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm0, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm1, %xmm1
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm1, %xmm1
    add          %rax, %r12
    vpaddq       (288)(%rcx), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm6, %xmm7, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm2, %xmm3, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm2, %xmm2
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm1, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm1, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm1, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm1, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm1, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm2, %xmm2
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm2, %xmm2
    add          %rax, %r10
    vpaddq       (304)(%rcx), %xmm3, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm7, %xmm0, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm3, %xmm4, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm3, %xmm3
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm2, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm2, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm2, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm2, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm2, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm3, %xmm3
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm3, %xmm3
    add          %rax, %r8
    vpaddq       (320)(%rcx), %xmm4, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm0, %xmm1, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm4, %xmm5, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm4, %xmm4
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm3, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm3, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm3, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm3, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm3, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm4, %xmm4
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm4, %xmm4
    add          %rax, %r14
    vpaddq       (336)(%rcx), %xmm5, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm1, %xmm2, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm5, %xmm6, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm5, %xmm5
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm4, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm4, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm4, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm4, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm4, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm5, %xmm5
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm5, %xmm5
    add          %rax, %r12
    vpaddq       (352)(%rcx), %xmm6, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm2, %xmm3, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm6, %xmm7, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm6, %xmm6
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm5, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm5, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm5, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm5, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm5, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm6, %xmm6
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm6, %xmm6
    add          %rax, %r10
    vpaddq       (368)(%rcx), %xmm7, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm3, %xmm4, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm7, %xmm0, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm7, %xmm7
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm6, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm6, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm6, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm6, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm6, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm7, %xmm7
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm7, %xmm7
    add          %rax, %r8
    vpaddq       (384)(%rcx), %xmm0, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm4, %xmm5, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm0, %xmm1, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm0, %xmm0
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm7, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm7, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm7, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm7, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm7, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm0, %xmm0
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm0, %xmm0
    add          %rax, %r14
    vpaddq       (400)(%rcx), %xmm1, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm5, %xmm6, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm1, %xmm2, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm1, %xmm1
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm0, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm0, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm0, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm0, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm0, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm1, %xmm1
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm1, %xmm1
    add          %rax, %r12
    vpaddq       (416)(%rcx), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm6, %xmm7, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm2, %xmm3, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm2, %xmm2
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm1, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm1, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm1, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm1, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm1, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm2, %xmm2
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm2, %xmm2
    add          %rax, %r10
    vpaddq       (432)(%rcx), %xmm3, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm7, %xmm0, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm3, %xmm4, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm3, %xmm3
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm2, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm2, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm2, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm2, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm2, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm3, %xmm3
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm3, %xmm3
    add          %rax, %r8
    vpaddq       (448)(%rcx), %xmm4, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r15
    vpalignr     $(8), %xmm0, %xmm1, %xmm9
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm4, %xmm5, %xmm8
    mov          %r13, %rax
    xor          %r12, %rbp
    vpaddq       %xmm9, %xmm4, %xmm4
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    vpsrlq       $(6), %xmm3, %xmm11
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm3, %xmm9
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    vpsllq       $(3), %xmm3, %xmm10
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r8, %rax
    xor          %r10, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm3, %xmm9
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    vpsllq       $(45), %xmm3, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r15
    add          %rax, %r15
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm4, %xmm4
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r14, %r10
    mov          %r15, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r9, %rax
    add          %rbp, %r14
    vpaddq       %xmm11, %xmm4, %xmm4
    add          %rax, %r14
    vpaddq       (464)(%rcx), %xmm5, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r13
    vpalignr     $(8), %xmm1, %xmm2, %xmm9
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm5, %xmm6, %xmm8
    mov          %r11, %rax
    xor          %r10, %rbp
    vpaddq       %xmm9, %xmm5, %xmm5
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    vpsrlq       $(6), %xmm4, %xmm11
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm4, %xmm9
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    vpsllq       $(3), %xmm4, %xmm10
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r14, %rax
    xor          %r8, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm4, %xmm9
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    vpsllq       $(45), %xmm4, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r13
    add          %rax, %r13
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm5, %xmm5
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r12, %r8
    mov          %r13, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r15, %rax
    add          %rbp, %r12
    vpaddq       %xmm11, %xmm5, %xmm5
    add          %rax, %r12
    vpaddq       (480)(%rcx), %xmm6, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r11
    vpalignr     $(8), %xmm2, %xmm3, %xmm9
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm6, %xmm7, %xmm8
    mov          %r9, %rax
    xor          %r8, %rbp
    vpaddq       %xmm9, %xmm6, %xmm6
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    vpsrlq       $(6), %xmm5, %xmm11
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm5, %xmm9
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    vpsllq       $(3), %xmm5, %xmm10
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r12, %rax
    xor          %r14, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm5, %xmm9
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    vpsllq       $(45), %xmm5, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r11
    add          %rax, %r11
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm6, %xmm6
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r10, %r14
    mov          %r11, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r13, %rax
    add          %rbp, %r10
    vpaddq       %xmm11, %xmm6, %xmm6
    add          %rax, %r10
    vpaddq       (496)(%rcx), %xmm7, %xmm9
    vmovdqa      %xmm9, (%rsp)
    addq         (%rsp), %r9
    vpalignr     $(8), %xmm3, %xmm4, %xmm9
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    vpalignr     $(8), %xmm7, %xmm0, %xmm8
    mov          %r15, %rax
    xor          %r14, %rbp
    vpaddq       %xmm9, %xmm7, %xmm7
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    vpsrlq       $(6), %xmm6, %xmm11
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    vpsrlq       $(61), %xmm6, %xmm9
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    vpsllq       $(3), %xmm6, %xmm10
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    mov          %r10, %rax
    xor          %r12, %rax
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    vpsrlq       $(19), %xmm6, %xmm9
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    vpsllq       $(45), %xmm6, %xmm10
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    vpxor        %xmm9, %xmm11, %xmm11
    add          %rbp, %r9
    add          %rax, %r9
    vpxor        %xmm10, %xmm11, %xmm11
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    vpaddq       %xmm11, %xmm7, %xmm7
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    vpsrlq       $(7), %xmm8, %xmm11
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    vpsrlq       $(1), %xmm8, %xmm9
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    vpsllq       $(63), %xmm8, %xmm10
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    vpxor        %xmm9, %xmm11, %xmm11
    add          %r8, %r12
    mov          %r9, %rbp
    vpxor        %xmm10, %xmm11, %xmm11
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    vpsrlq       $(8), %xmm8, %xmm9
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    vpsllq       $(56), %xmm8, %xmm10
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    vpxor        %xmm9, %xmm11, %xmm11
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    vpxor        %xmm10, %xmm11, %xmm11
    xor          %r11, %rax
    add          %rbp, %r8
    vpaddq       %xmm11, %xmm7, %xmm7
    add          %rax, %r8
    vpaddq       (512)(%rcx), %xmm0, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r15
    mov          %r13, %rax
    xor          %r12, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r8, %rax
    xor          %r10, %rax
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    add          %rbp, %r15
    add          %rax, %r15
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    add          %r14, %r10
    mov          %r15, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    xor          %r9, %rax
    add          %rbp, %r14
    add          %rax, %r14
    vpaddq       (528)(%rcx), %xmm1, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r13
    mov          %r11, %rax
    xor          %r10, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r14, %rax
    xor          %r8, %rax
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    add          %rbp, %r13
    add          %rax, %r13
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    add          %r12, %r8
    mov          %r13, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    xor          %r15, %rax
    add          %rbp, %r12
    add          %rax, %r12
    vpaddq       (544)(%rcx), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r11
    mov          %r9, %rax
    xor          %r8, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r12, %rax
    xor          %r14, %rax
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    add          %rbp, %r11
    add          %rax, %r11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    add          %r10, %r14
    mov          %r11, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    xor          %r13, %rax
    add          %rbp, %r10
    add          %rax, %r10
    vpaddq       (560)(%rcx), %xmm3, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r9
    mov          %r15, %rax
    xor          %r14, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r10, %rax
    xor          %r12, %rax
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    add          %rbp, %r9
    add          %rax, %r9
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    add          %r8, %r12
    mov          %r9, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    xor          %r11, %rax
    add          %rbp, %r8
    add          %rax, %r8
    vpaddq       (576)(%rcx), %xmm4, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r12, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r15
    mov          %r13, %rax
    xor          %r12, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r14, %rax
    and          %r12, %rax
    xor          %r12, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r14, %rax
    add          %rax, %r15
    add          %rbp, %r15
    add          %r15, %r11
    mov          %r8, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r8, %rax
    xor          %r10, %rax
    xor          %r8, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r10, %r9
    and          %r9, %rax
    xor          %r8, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r10, %r9
    xor          %r10, %rax
    add          %rbp, %r15
    add          %rax, %r15
    mov          %r11, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r14
    mov          %r12, %rax
    xor          %r11, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r13, %rax
    and          %r11, %rax
    xor          %r11, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r13, %rax
    add          %rax, %r14
    add          %rbp, %r14
    add          %r14, %r10
    mov          %r15, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r15, %rax
    xor          %r9, %rax
    xor          %r15, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r9, %r8
    and          %r8, %rax
    xor          %r15, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r9, %r8
    xor          %r9, %rax
    add          %rbp, %r14
    add          %rax, %r14
    vpaddq       (592)(%rcx), %xmm5, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r10, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r13
    mov          %r11, %rax
    xor          %r10, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r12, %rax
    and          %r10, %rax
    xor          %r10, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r12, %rax
    add          %rax, %r13
    add          %rbp, %r13
    add          %r13, %r9
    mov          %r14, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r14, %rax
    xor          %r8, %rax
    xor          %r14, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r8, %r15
    and          %r15, %rax
    xor          %r14, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r8, %r15
    xor          %r8, %rax
    add          %rbp, %r13
    add          %rax, %r13
    mov          %r9, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r12
    mov          %r10, %rax
    xor          %r9, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r11, %rax
    and          %r9, %rax
    xor          %r9, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r11, %rax
    add          %rax, %r12
    add          %rbp, %r12
    add          %r12, %r8
    mov          %r13, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r13, %rax
    xor          %r15, %rax
    xor          %r13, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r15, %r14
    and          %r14, %rax
    xor          %r13, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r15, %r14
    xor          %r15, %rax
    add          %rbp, %r12
    add          %rax, %r12
    vpaddq       (608)(%rcx), %xmm6, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r8, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r11
    mov          %r9, %rax
    xor          %r8, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r10, %rax
    and          %r8, %rax
    xor          %r8, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r10, %rax
    add          %rax, %r11
    add          %rbp, %r11
    add          %r11, %r15
    mov          %r12, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r12, %rax
    xor          %r14, %rax
    xor          %r12, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r14, %r13
    and          %r13, %rax
    xor          %r12, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r14, %r13
    xor          %r14, %rax
    add          %rbp, %r11
    add          %rax, %r11
    mov          %r15, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r10
    mov          %r8, %rax
    xor          %r15, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r9, %rax
    and          %r15, %rax
    xor          %r15, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r9, %rax
    add          %rax, %r10
    add          %rbp, %r10
    add          %r10, %r14
    mov          %r11, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r11, %rax
    xor          %r13, %rax
    xor          %r11, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r13, %r12
    and          %r12, %rax
    xor          %r11, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r13, %r12
    xor          %r13, %rax
    add          %rbp, %r10
    add          %rax, %r10
    vpaddq       (624)(%rcx), %xmm7, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %r14, %rbp
    shld         $(41), %rbp, %rbp
    addq         (%rsp), %r9
    mov          %r15, %rax
    xor          %r14, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r8, %rax
    and          %r14, %rax
    xor          %r14, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r8, %rax
    add          %rax, %r9
    add          %rbp, %r9
    add          %r9, %r13
    mov          %r10, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r10, %rax
    xor          %r12, %rax
    xor          %r10, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r12, %r11
    and          %r11, %rax
    xor          %r10, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r12, %r11
    xor          %r12, %rax
    add          %rbp, %r9
    add          %rax, %r9
    mov          %r13, %rbp
    shld         $(41), %rbp, %rbp
    addq         (8)(%rsp), %r8
    mov          %r14, %rax
    xor          %r13, %rbp
    shld         $(60), %rbp, %rbp
    xor          %r15, %rax
    and          %r13, %rax
    xor          %r13, %rbp
    shld         $(50), %rbp, %rbp
    xor          %r15, %rax
    add          %rax, %r8
    add          %rbp, %r8
    add          %r8, %r12
    mov          %r9, %rbp
    shld         $(59), %rbp, %rbp
    mov          %r9, %rax
    xor          %r11, %rax
    xor          %r9, %rbp
    shld         $(58), %rbp, %rbp
    xor          %r11, %r10
    and          %r10, %rax
    xor          %r9, %rbp
    shld         $(36), %rbp, %rbp
    xor          %r11, %r10
    xor          %r11, %rax
    add          %rbp, %r8
    add          %rax, %r8
    addq         %r8, (%rdi)
    addq         %r9, (8)(%rdi)
    addq         %r10, (16)(%rdi)
    addq         %r11, (24)(%rdi)
    addq         %r12, (32)(%rdi)
    addq         %r13, (40)(%rdi)
    addq         %r14, (48)(%rdi)
    addq         %r15, (56)(%rdi)
    vmovdqa      SHUFB_BSWAP(%rip), %xmm9
    add          $(128), %rsi
    sub          $(128), %rdx
    jg           .Lsha512_block_loopgas_1
    add          $(40), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size UpdateSHA512, .Lfe1-(UpdateSHA512)
 
