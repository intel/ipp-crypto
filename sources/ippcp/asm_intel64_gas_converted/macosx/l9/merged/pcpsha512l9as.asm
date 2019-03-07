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
.p2align 5, 0x90
 
SHA512_YMM_K:
.quad   0x428a2f98d728ae22,  0x7137449123ef65cd,  0x428a2f98d728ae22,  0x7137449123ef65cd 
 

.quad   0xb5c0fbcfec4d3b2f,  0xe9b5dba58189dbbc,  0xb5c0fbcfec4d3b2f,  0xe9b5dba58189dbbc 
 

.quad   0x3956c25bf348b538,  0x59f111f1b605d019,  0x3956c25bf348b538,  0x59f111f1b605d019 
 

.quad   0x923f82a4af194f9b,  0xab1c5ed5da6d8118,  0x923f82a4af194f9b,  0xab1c5ed5da6d8118 
 

.quad   0xd807aa98a3030242,  0x12835b0145706fbe,  0xd807aa98a3030242,  0x12835b0145706fbe 
 

.quad   0x243185be4ee4b28c,  0x550c7dc3d5ffb4e2,  0x243185be4ee4b28c,  0x550c7dc3d5ffb4e2 
 

.quad   0x72be5d74f27b896f,  0x80deb1fe3b1696b1,  0x72be5d74f27b896f,  0x80deb1fe3b1696b1 
 

.quad   0x9bdc06a725c71235,  0xc19bf174cf692694,  0x9bdc06a725c71235,  0xc19bf174cf692694 
 

.quad   0xe49b69c19ef14ad2,  0xefbe4786384f25e3,  0xe49b69c19ef14ad2,  0xefbe4786384f25e3 
 

.quad    0xfc19dc68b8cd5b5,  0x240ca1cc77ac9c65,   0xfc19dc68b8cd5b5,  0x240ca1cc77ac9c65 
 

.quad   0x2de92c6f592b0275,  0x4a7484aa6ea6e483,  0x2de92c6f592b0275,  0x4a7484aa6ea6e483 
 

.quad   0x5cb0a9dcbd41fbd4,  0x76f988da831153b5,  0x5cb0a9dcbd41fbd4,  0x76f988da831153b5 
 

.quad   0x983e5152ee66dfab,  0xa831c66d2db43210,  0x983e5152ee66dfab,  0xa831c66d2db43210 
 

.quad   0xb00327c898fb213f,  0xbf597fc7beef0ee4,  0xb00327c898fb213f,  0xbf597fc7beef0ee4 
 

.quad   0xc6e00bf33da88fc2,  0xd5a79147930aa725,  0xc6e00bf33da88fc2,  0xd5a79147930aa725 
 

.quad    0x6ca6351e003826f,  0x142929670a0e6e70,   0x6ca6351e003826f,  0x142929670a0e6e70 
 

.quad   0x27b70a8546d22ffc,  0x2e1b21385c26c926,  0x27b70a8546d22ffc,  0x2e1b21385c26c926 
 

.quad   0x4d2c6dfc5ac42aed,  0x53380d139d95b3df,  0x4d2c6dfc5ac42aed,  0x53380d139d95b3df 
 

.quad   0x650a73548baf63de,  0x766a0abb3c77b2a8,  0x650a73548baf63de,  0x766a0abb3c77b2a8 
 

.quad   0x81c2c92e47edaee6,  0x92722c851482353b,  0x81c2c92e47edaee6,  0x92722c851482353b 
 

.quad   0xa2bfe8a14cf10364,  0xa81a664bbc423001,  0xa2bfe8a14cf10364,  0xa81a664bbc423001 
 

.quad   0xc24b8b70d0f89791,  0xc76c51a30654be30,  0xc24b8b70d0f89791,  0xc76c51a30654be30 
 

.quad   0xd192e819d6ef5218,  0xd69906245565a910,  0xd192e819d6ef5218,  0xd69906245565a910 
 

.quad   0xf40e35855771202a,  0x106aa07032bbd1b8,  0xf40e35855771202a,  0x106aa07032bbd1b8 
 

.quad   0x19a4c116b8d2d0c8,  0x1e376c085141ab53,  0x19a4c116b8d2d0c8,  0x1e376c085141ab53 
 

.quad   0x2748774cdf8eeb99,  0x34b0bcb5e19b48a8,  0x2748774cdf8eeb99,  0x34b0bcb5e19b48a8 
 

.quad   0x391c0cb3c5c95a63,  0x4ed8aa4ae3418acb,  0x391c0cb3c5c95a63,  0x4ed8aa4ae3418acb 
 

.quad   0x5b9cca4f7763e373,  0x682e6ff3d6b2b8a3,  0x5b9cca4f7763e373,  0x682e6ff3d6b2b8a3 
 

.quad   0x748f82ee5defb2fc,  0x78a5636f43172f60,  0x748f82ee5defb2fc,  0x78a5636f43172f60 
 

.quad   0x84c87814a1f0ab72,  0x8cc702081a6439ec,  0x84c87814a1f0ab72,  0x8cc702081a6439ec 
 

.quad   0x90befffa23631e28,  0xa4506cebde82bde9,  0x90befffa23631e28,  0xa4506cebde82bde9 
 

.quad   0xbef9a3f7b2c67915,  0xc67178f2e372532b,  0xbef9a3f7b2c67915,  0xc67178f2e372532b 
 

.quad   0xca273eceea26619c,  0xd186b8c721c0c207,  0xca273eceea26619c,  0xd186b8c721c0c207 
 

.quad   0xeada7dd6cde0eb1e,  0xf57d4f7fee6ed178,  0xeada7dd6cde0eb1e,  0xf57d4f7fee6ed178 
 

.quad    0x6f067aa72176fba,   0xa637dc5a2c898a6,   0x6f067aa72176fba,   0xa637dc5a2c898a6 
 

.quad   0x113f9804bef90dae,  0x1b710b35131c471b,  0x113f9804bef90dae,  0x1b710b35131c471b 
 

.quad   0x28db77f523047d84,  0x32caab7b40c72493,  0x28db77f523047d84,  0x32caab7b40c72493 
 

.quad   0x3c9ebe0a15c9bebc,  0x431d67c49c100d4c,  0x3c9ebe0a15c9bebc,  0x431d67c49c100d4c 
 

.quad   0x4cc5d4becb3e42b6,  0x597f299cfc657e2a,  0x4cc5d4becb3e42b6,  0x597f299cfc657e2a 
 

.quad   0x5fcb6fab3ad6faec,  0x6c44198c4a475817,  0x5fcb6fab3ad6faec,  0x6c44198c4a475817 
 
SHA512_YMM_BF:
.quad      0x1020304050607,   0x8090a0b0c0d0e0f,     0x1020304050607,   0x8090a0b0c0d0e0f 
.p2align 5, 0x90
 
.globl _l9_UpdateSHA512

 
_l9_UpdateSHA512:
 
    push         %rbx
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(1312), %rsp
 
    mov          %rsp, %r15
    and          $(-32), %rsp
    movslq       %edx, %r14
    movq         %rdi, (8)(%rsp)
    movq         %r14, (16)(%rsp)
    movq         %r15, (24)(%rsp)
    lea          (32)(%rsp), %rsp
    vmovdqa      SHA512_YMM_BF(%rip), %ymm12
    movq         (%rdi), %rax
    movq         (8)(%rdi), %rbx
    movq         (16)(%rdi), %rcx
    movq         (24)(%rdi), %rdx
    movq         (32)(%rdi), %r8
    movq         (40)(%rdi), %r9
    movq         (48)(%rdi), %r10
    movq         (56)(%rdi), %r11
.p2align 5, 0x90
.Lsha512_block2_loopgas_1: 
    lea          (128)(%rsi), %r12
    cmp          $(128), %r14
    cmovbe       %rsi, %r12
    lea          SHA512_YMM_K(%rip), %rbp
    vmovdqu      (%rsi), %xmm0
    vmovdqu      (16)(%rsi), %xmm1
    vmovdqu      (32)(%rsi), %xmm2
    vmovdqu      (48)(%rsi), %xmm3
    vmovdqu      (64)(%rsi), %xmm4
    vmovdqu      (80)(%rsi), %xmm5
    vmovdqu      (96)(%rsi), %xmm6
    vmovdqu      (112)(%rsi), %xmm7
    vinserti128  $(1), (%r12), %ymm0, %ymm0
    vinserti128  $(1), (16)(%r12), %ymm1, %ymm1
    vinserti128  $(1), (32)(%r12), %ymm2, %ymm2
    vinserti128  $(1), (48)(%r12), %ymm3, %ymm3
    vinserti128  $(1), (64)(%r12), %ymm4, %ymm4
    vinserti128  $(1), (80)(%r12), %ymm5, %ymm5
    vinserti128  $(1), (96)(%r12), %ymm6, %ymm6
    vinserti128  $(1), (112)(%r12), %ymm7, %ymm7
    vpshufb      %ymm12, %ymm0, %ymm0
    vpshufb      %ymm12, %ymm1, %ymm1
    vpshufb      %ymm12, %ymm2, %ymm2
    vpshufb      %ymm12, %ymm3, %ymm3
    vpshufb      %ymm12, %ymm4, %ymm4
    vpshufb      %ymm12, %ymm5, %ymm5
    vpshufb      %ymm12, %ymm6, %ymm6
    vpshufb      %ymm12, %ymm7, %ymm7
    vpaddq       (%rbp), %ymm0, %ymm8
    vmovdqa      %ymm8, (%rsp)
    vpaddq       (32)(%rbp), %ymm1, %ymm9
    vmovdqa      %ymm9, (32)(%rsp)
    vpaddq       (64)(%rbp), %ymm2, %ymm10
    vmovdqa      %ymm10, (64)(%rsp)
    vpaddq       (96)(%rbp), %ymm3, %ymm11
    vmovdqa      %ymm11, (96)(%rsp)
    vpaddq       (128)(%rbp), %ymm4, %ymm8
    vmovdqa      %ymm8, (128)(%rsp)
    vpaddq       (160)(%rbp), %ymm5, %ymm9
    vmovdqa      %ymm9, (160)(%rsp)
    vpaddq       (192)(%rbp), %ymm6, %ymm10
    vmovdqa      %ymm10, (192)(%rsp)
    vpaddq       (224)(%rbp), %ymm7, %ymm11
    vmovdqa      %ymm11, (224)(%rsp)
    add          $(256), %rbp
    mov          %rbx, %rdi
    xor          %r14, %r14
    mov          %r9, %r12
    xor          %rcx, %rdi
.p2align 5, 0x90
.Lblock1_shed_procgas_1: 
 
    vpalignr     $(8), %ymm0, %ymm1, %ymm8
    addq         (%rsp), %r11
    and          %r8, %r12
    vpalignr     $(8), %ymm4, %ymm5, %ymm11
    rorx         $(41), %r8, %r13
    rorx         $(18), %r8, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %rax
    add          %r12, %r11
    vpaddq       %ymm11, %ymm0, %ymm0
    andn         %r10, %r8, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %r8, %r14
    add          %r12, %r11
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %rax, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %rax, %r12
    add          %r13, %r11
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %rbx, %r15
    rorx         $(34), %rax, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %rax, %r13
    add          %r11, %rdx
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %rbx, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm7, %ymm11
    add          %rdi, %r11
    mov          %r8, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (8)(%rsp), %r10
    and          %rdx, %r12
    vpsllq       $(3), %ymm7, %ymm10
    rorx         $(41), %rdx, %r13
    rorx         $(18), %rdx, %rdi
    vpaddq       %ymm8, %ymm0, %ymm0
    add          %r14, %r11
    add          %r12, %r10
    vpsrlq       $(19), %ymm7, %ymm9
    andn         %r9, %rdx, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %rdx, %r14
    add          %r12, %r10
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %r11, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %r11, %r12
    add          %r13, %r10
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %rax, %rdi
    rorx         $(34), %r11, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %r11, %r13
    add          %r10, %rcx
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm0, %ymm0
    xor          %rax, %r15
    xor          %r13, %r14
    vpaddq       (%rbp), %ymm0, %ymm10
    add          %r15, %r10
    mov          %rdx, %r12
    vmovdqa      %ymm10, (256)(%rsp)
 
    vpalignr     $(8), %ymm1, %ymm2, %ymm8
    addq         (32)(%rsp), %r9
    and          %rcx, %r12
    vpalignr     $(8), %ymm5, %ymm6, %ymm11
    rorx         $(41), %rcx, %r13
    rorx         $(18), %rcx, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %r10
    add          %r12, %r9
    vpaddq       %ymm11, %ymm1, %ymm1
    andn         %r8, %rcx, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %rcx, %r14
    add          %r12, %r9
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %r10, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %r10, %r12
    add          %r13, %r9
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %r11, %r15
    rorx         $(34), %r10, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %r10, %r13
    add          %r9, %rbx
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %r11, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm0, %ymm11
    add          %rdi, %r9
    mov          %rcx, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (40)(%rsp), %r8
    and          %rbx, %r12
    vpsllq       $(3), %ymm0, %ymm10
    rorx         $(41), %rbx, %r13
    rorx         $(18), %rbx, %rdi
    vpaddq       %ymm8, %ymm1, %ymm1
    add          %r14, %r9
    add          %r12, %r8
    vpsrlq       $(19), %ymm0, %ymm9
    andn         %rdx, %rbx, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %rbx, %r14
    add          %r12, %r8
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %r9, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %r9, %r12
    add          %r13, %r8
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %r10, %rdi
    rorx         $(34), %r9, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %r9, %r13
    add          %r8, %rax
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm1, %ymm1
    xor          %r10, %r15
    xor          %r13, %r14
    vpaddq       (32)(%rbp), %ymm1, %ymm10
    add          %r15, %r8
    mov          %rbx, %r12
    vmovdqa      %ymm10, (288)(%rsp)
 
    vpalignr     $(8), %ymm2, %ymm3, %ymm8
    addq         (64)(%rsp), %rdx
    and          %rax, %r12
    vpalignr     $(8), %ymm6, %ymm7, %ymm11
    rorx         $(41), %rax, %r13
    rorx         $(18), %rax, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %r8
    add          %r12, %rdx
    vpaddq       %ymm11, %ymm2, %ymm2
    andn         %rcx, %rax, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %rax, %r14
    add          %r12, %rdx
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %r8, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %r8, %r12
    add          %r13, %rdx
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %r9, %r15
    rorx         $(34), %r8, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %r8, %r13
    add          %rdx, %r11
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %r9, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm1, %ymm11
    add          %rdi, %rdx
    mov          %rax, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (72)(%rsp), %rcx
    and          %r11, %r12
    vpsllq       $(3), %ymm1, %ymm10
    rorx         $(41), %r11, %r13
    rorx         $(18), %r11, %rdi
    vpaddq       %ymm8, %ymm2, %ymm2
    add          %r14, %rdx
    add          %r12, %rcx
    vpsrlq       $(19), %ymm1, %ymm9
    andn         %rbx, %r11, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %r11, %r14
    add          %r12, %rcx
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %rdx, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %rdx, %r12
    add          %r13, %rcx
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %r8, %rdi
    rorx         $(34), %rdx, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %rdx, %r13
    add          %rcx, %r10
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm2, %ymm2
    xor          %r8, %r15
    xor          %r13, %r14
    vpaddq       (64)(%rbp), %ymm2, %ymm10
    add          %r15, %rcx
    mov          %r11, %r12
    vmovdqa      %ymm10, (320)(%rsp)
 
    vpalignr     $(8), %ymm3, %ymm4, %ymm8
    addq         (96)(%rsp), %rbx
    and          %r10, %r12
    vpalignr     $(8), %ymm7, %ymm0, %ymm11
    rorx         $(41), %r10, %r13
    rorx         $(18), %r10, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %rcx
    add          %r12, %rbx
    vpaddq       %ymm11, %ymm3, %ymm3
    andn         %rax, %r10, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %r10, %r14
    add          %r12, %rbx
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %rcx, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %rcx, %r12
    add          %r13, %rbx
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %rdx, %r15
    rorx         $(34), %rcx, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %rcx, %r13
    add          %rbx, %r9
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %rdx, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm2, %ymm11
    add          %rdi, %rbx
    mov          %r10, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (104)(%rsp), %rax
    and          %r9, %r12
    vpsllq       $(3), %ymm2, %ymm10
    rorx         $(41), %r9, %r13
    rorx         $(18), %r9, %rdi
    vpaddq       %ymm8, %ymm3, %ymm3
    add          %r14, %rbx
    add          %r12, %rax
    vpsrlq       $(19), %ymm2, %ymm9
    andn         %r11, %r9, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %r9, %r14
    add          %r12, %rax
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %rbx, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %rbx, %r12
    add          %r13, %rax
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %rcx, %rdi
    rorx         $(34), %rbx, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %rbx, %r13
    add          %rax, %r8
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm3, %ymm3
    xor          %rcx, %r15
    xor          %r13, %r14
    vpaddq       (96)(%rbp), %ymm3, %ymm10
    add          %r15, %rax
    mov          %r9, %r12
    vmovdqa      %ymm10, (352)(%rsp)
 
    vpalignr     $(8), %ymm4, %ymm5, %ymm8
    addq         (128)(%rsp), %r11
    and          %r8, %r12
    vpalignr     $(8), %ymm0, %ymm1, %ymm11
    rorx         $(41), %r8, %r13
    rorx         $(18), %r8, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %rax
    add          %r12, %r11
    vpaddq       %ymm11, %ymm4, %ymm4
    andn         %r10, %r8, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %r8, %r14
    add          %r12, %r11
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %rax, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %rax, %r12
    add          %r13, %r11
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %rbx, %r15
    rorx         $(34), %rax, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %rax, %r13
    add          %r11, %rdx
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %rbx, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm3, %ymm11
    add          %rdi, %r11
    mov          %r8, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (136)(%rsp), %r10
    and          %rdx, %r12
    vpsllq       $(3), %ymm3, %ymm10
    rorx         $(41), %rdx, %r13
    rorx         $(18), %rdx, %rdi
    vpaddq       %ymm8, %ymm4, %ymm4
    add          %r14, %r11
    add          %r12, %r10
    vpsrlq       $(19), %ymm3, %ymm9
    andn         %r9, %rdx, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %rdx, %r14
    add          %r12, %r10
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %r11, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %r11, %r12
    add          %r13, %r10
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %rax, %rdi
    rorx         $(34), %r11, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %r11, %r13
    add          %r10, %rcx
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm4, %ymm4
    xor          %rax, %r15
    xor          %r13, %r14
    vpaddq       (128)(%rbp), %ymm4, %ymm10
    add          %r15, %r10
    mov          %rdx, %r12
    vmovdqa      %ymm10, (384)(%rsp)
 
    vpalignr     $(8), %ymm5, %ymm6, %ymm8
    addq         (160)(%rsp), %r9
    and          %rcx, %r12
    vpalignr     $(8), %ymm1, %ymm2, %ymm11
    rorx         $(41), %rcx, %r13
    rorx         $(18), %rcx, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %r10
    add          %r12, %r9
    vpaddq       %ymm11, %ymm5, %ymm5
    andn         %r8, %rcx, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %rcx, %r14
    add          %r12, %r9
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %r10, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %r10, %r12
    add          %r13, %r9
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %r11, %r15
    rorx         $(34), %r10, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %r10, %r13
    add          %r9, %rbx
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %r11, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm4, %ymm11
    add          %rdi, %r9
    mov          %rcx, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (168)(%rsp), %r8
    and          %rbx, %r12
    vpsllq       $(3), %ymm4, %ymm10
    rorx         $(41), %rbx, %r13
    rorx         $(18), %rbx, %rdi
    vpaddq       %ymm8, %ymm5, %ymm5
    add          %r14, %r9
    add          %r12, %r8
    vpsrlq       $(19), %ymm4, %ymm9
    andn         %rdx, %rbx, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %rbx, %r14
    add          %r12, %r8
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %r9, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %r9, %r12
    add          %r13, %r8
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %r10, %rdi
    rorx         $(34), %r9, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %r9, %r13
    add          %r8, %rax
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm5, %ymm5
    xor          %r10, %r15
    xor          %r13, %r14
    vpaddq       (160)(%rbp), %ymm5, %ymm10
    add          %r15, %r8
    mov          %rbx, %r12
    vmovdqa      %ymm10, (416)(%rsp)
 
    vpalignr     $(8), %ymm6, %ymm7, %ymm8
    addq         (192)(%rsp), %rdx
    and          %rax, %r12
    vpalignr     $(8), %ymm2, %ymm3, %ymm11
    rorx         $(41), %rax, %r13
    rorx         $(18), %rax, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %r8
    add          %r12, %rdx
    vpaddq       %ymm11, %ymm6, %ymm6
    andn         %rcx, %rax, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %rax, %r14
    add          %r12, %rdx
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %r8, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %r8, %r12
    add          %r13, %rdx
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %r9, %r15
    rorx         $(34), %r8, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %r8, %r13
    add          %rdx, %r11
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %r9, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm5, %ymm11
    add          %rdi, %rdx
    mov          %rax, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (200)(%rsp), %rcx
    and          %r11, %r12
    vpsllq       $(3), %ymm5, %ymm10
    rorx         $(41), %r11, %r13
    rorx         $(18), %r11, %rdi
    vpaddq       %ymm8, %ymm6, %ymm6
    add          %r14, %rdx
    add          %r12, %rcx
    vpsrlq       $(19), %ymm5, %ymm9
    andn         %rbx, %r11, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %r11, %r14
    add          %r12, %rcx
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %rdx, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %rdx, %r12
    add          %r13, %rcx
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %r8, %rdi
    rorx         $(34), %rdx, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %rdx, %r13
    add          %rcx, %r10
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm6, %ymm6
    xor          %r8, %r15
    xor          %r13, %r14
    vpaddq       (192)(%rbp), %ymm6, %ymm10
    add          %r15, %rcx
    mov          %r11, %r12
    vmovdqa      %ymm10, (448)(%rsp)
 
    vpalignr     $(8), %ymm7, %ymm0, %ymm8
    addq         (224)(%rsp), %rbx
    and          %r10, %r12
    vpalignr     $(8), %ymm3, %ymm4, %ymm11
    rorx         $(41), %r10, %r13
    rorx         $(18), %r10, %r15
    vpsrlq       $(1), %ymm8, %ymm10
    add          %r14, %rcx
    add          %r12, %rbx
    vpaddq       %ymm11, %ymm7, %ymm7
    andn         %rax, %r10, %r12
    xor          %r15, %r13
    vpsrlq       $(7), %ymm8, %ymm11
    rorx         $(14), %r10, %r14
    add          %r12, %rbx
    vpsllq       $(56), %ymm8, %ymm9
    xor          %r14, %r13
    mov          %rcx, %r15
    vpxor        %ymm10, %ymm11, %ymm8
    rorx         $(39), %rcx, %r12
    add          %r13, %rbx
    vpsrlq       $(7), %ymm10, %ymm10
    xor          %rdx, %r15
    rorx         $(34), %rcx, %r14
    vpxor        %ymm9, %ymm8, %ymm8
    rorx         $(28), %rcx, %r13
    add          %rbx, %r9
    vpsllq       $(7), %ymm9, %ymm9
    and          %r15, %rdi
    xor          %r12, %r14
    vpxor        %ymm10, %ymm8, %ymm8
    xor          %rdx, %rdi
    xor          %r13, %r14
    vpsrlq       $(6), %ymm6, %ymm11
    add          %rdi, %rbx
    mov          %r10, %r12
    vpxor        %ymm9, %ymm8, %ymm8
 
    addq         (232)(%rsp), %rax
    and          %r9, %r12
    vpsllq       $(3), %ymm6, %ymm10
    rorx         $(41), %r9, %r13
    rorx         $(18), %r9, %rdi
    vpaddq       %ymm8, %ymm7, %ymm7
    add          %r14, %rbx
    add          %r12, %rax
    vpsrlq       $(19), %ymm6, %ymm9
    andn         %r11, %r9, %r12
    xor          %rdi, %r13
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(14), %r9, %r14
    add          %r12, %rax
    vpsllq       $(42), %ymm10, %ymm10
    xor          %r14, %r13
    mov          %rbx, %rdi
    vpxor        %ymm9, %ymm11, %ymm11
    rorx         $(39), %rbx, %r12
    add          %r13, %rax
    vpsrlq       $(42), %ymm9, %ymm9
    xor          %rcx, %rdi
    rorx         $(34), %rbx, %r14
    vpxor        %ymm10, %ymm11, %ymm11
    rorx         $(28), %rbx, %r13
    add          %rax, %r8
    vpxor        %ymm9, %ymm11, %ymm11
    and          %rdi, %r15
    xor          %r12, %r14
    vpaddq       %ymm11, %ymm7, %ymm7
    xor          %rcx, %r15
    xor          %r13, %r14
    vpaddq       (224)(%rbp), %ymm7, %ymm10
    add          %r15, %rax
    mov          %r9, %r12
    vmovdqa      %ymm10, (480)(%rsp)
    add          $(256), %rsp
    add          $(256), %rbp
    cmpl         $(1246189591), (-8)(%rbp)
    jne          .Lblock1_shed_procgas_1
    addq         (%rsp), %r11
    and          %r8, %r12
    rorx         $(41), %r8, %r13
    rorx         $(18), %r8, %r15
    add          %r14, %rax
    add          %r12, %r11
    andn         %r10, %r8, %r12
    xor          %r15, %r13
    rorx         $(14), %r8, %r14
    add          %r12, %r11
    xor          %r14, %r13
    mov          %rax, %r15
    rorx         $(39), %rax, %r12
    add          %r13, %r11
    xor          %rbx, %r15
    rorx         $(34), %rax, %r14
    rorx         $(28), %rax, %r13
    add          %r11, %rdx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rbx, %rdi
    xor          %r13, %r14
    add          %rdi, %r11
    mov          %r8, %r12
    addq         (8)(%rsp), %r10
    and          %rdx, %r12
    rorx         $(41), %rdx, %r13
    rorx         $(18), %rdx, %rdi
    add          %r14, %r11
    add          %r12, %r10
    andn         %r9, %rdx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rdx, %r14
    add          %r12, %r10
    xor          %r14, %r13
    mov          %r11, %rdi
    rorx         $(39), %r11, %r12
    add          %r13, %r10
    xor          %rax, %rdi
    rorx         $(34), %r11, %r14
    rorx         $(28), %r11, %r13
    add          %r10, %rcx
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rax, %r15
    xor          %r13, %r14
    add          %r15, %r10
    mov          %rdx, %r12
    addq         (32)(%rsp), %r9
    and          %rcx, %r12
    rorx         $(41), %rcx, %r13
    rorx         $(18), %rcx, %r15
    add          %r14, %r10
    add          %r12, %r9
    andn         %r8, %rcx, %r12
    xor          %r15, %r13
    rorx         $(14), %rcx, %r14
    add          %r12, %r9
    xor          %r14, %r13
    mov          %r10, %r15
    rorx         $(39), %r10, %r12
    add          %r13, %r9
    xor          %r11, %r15
    rorx         $(34), %r10, %r14
    rorx         $(28), %r10, %r13
    add          %r9, %rbx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r11, %rdi
    xor          %r13, %r14
    add          %rdi, %r9
    mov          %rcx, %r12
    addq         (40)(%rsp), %r8
    and          %rbx, %r12
    rorx         $(41), %rbx, %r13
    rorx         $(18), %rbx, %rdi
    add          %r14, %r9
    add          %r12, %r8
    andn         %rdx, %rbx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rbx, %r14
    add          %r12, %r8
    xor          %r14, %r13
    mov          %r9, %rdi
    rorx         $(39), %r9, %r12
    add          %r13, %r8
    xor          %r10, %rdi
    rorx         $(34), %r9, %r14
    rorx         $(28), %r9, %r13
    add          %r8, %rax
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r10, %r15
    xor          %r13, %r14
    add          %r15, %r8
    mov          %rbx, %r12
    addq         (64)(%rsp), %rdx
    and          %rax, %r12
    rorx         $(41), %rax, %r13
    rorx         $(18), %rax, %r15
    add          %r14, %r8
    add          %r12, %rdx
    andn         %rcx, %rax, %r12
    xor          %r15, %r13
    rorx         $(14), %rax, %r14
    add          %r12, %rdx
    xor          %r14, %r13
    mov          %r8, %r15
    rorx         $(39), %r8, %r12
    add          %r13, %rdx
    xor          %r9, %r15
    rorx         $(34), %r8, %r14
    rorx         $(28), %r8, %r13
    add          %rdx, %r11
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r9, %rdi
    xor          %r13, %r14
    add          %rdi, %rdx
    mov          %rax, %r12
    addq         (72)(%rsp), %rcx
    and          %r11, %r12
    rorx         $(41), %r11, %r13
    rorx         $(18), %r11, %rdi
    add          %r14, %rdx
    add          %r12, %rcx
    andn         %rbx, %r11, %r12
    xor          %rdi, %r13
    rorx         $(14), %r11, %r14
    add          %r12, %rcx
    xor          %r14, %r13
    mov          %rdx, %rdi
    rorx         $(39), %rdx, %r12
    add          %r13, %rcx
    xor          %r8, %rdi
    rorx         $(34), %rdx, %r14
    rorx         $(28), %rdx, %r13
    add          %rcx, %r10
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r8, %r15
    xor          %r13, %r14
    add          %r15, %rcx
    mov          %r11, %r12
    addq         (96)(%rsp), %rbx
    and          %r10, %r12
    rorx         $(41), %r10, %r13
    rorx         $(18), %r10, %r15
    add          %r14, %rcx
    add          %r12, %rbx
    andn         %rax, %r10, %r12
    xor          %r15, %r13
    rorx         $(14), %r10, %r14
    add          %r12, %rbx
    xor          %r14, %r13
    mov          %rcx, %r15
    rorx         $(39), %rcx, %r12
    add          %r13, %rbx
    xor          %rdx, %r15
    rorx         $(34), %rcx, %r14
    rorx         $(28), %rcx, %r13
    add          %rbx, %r9
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rdx, %rdi
    xor          %r13, %r14
    add          %rdi, %rbx
    mov          %r10, %r12
    addq         (104)(%rsp), %rax
    and          %r9, %r12
    rorx         $(41), %r9, %r13
    rorx         $(18), %r9, %rdi
    add          %r14, %rbx
    add          %r12, %rax
    andn         %r11, %r9, %r12
    xor          %rdi, %r13
    rorx         $(14), %r9, %r14
    add          %r12, %rax
    xor          %r14, %r13
    mov          %rbx, %rdi
    rorx         $(39), %rbx, %r12
    add          %r13, %rax
    xor          %rcx, %rdi
    rorx         $(34), %rbx, %r14
    rorx         $(28), %rbx, %r13
    add          %rax, %r8
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rcx, %r15
    xor          %r13, %r14
    add          %r15, %rax
    mov          %r9, %r12
    addq         (128)(%rsp), %r11
    and          %r8, %r12
    rorx         $(41), %r8, %r13
    rorx         $(18), %r8, %r15
    add          %r14, %rax
    add          %r12, %r11
    andn         %r10, %r8, %r12
    xor          %r15, %r13
    rorx         $(14), %r8, %r14
    add          %r12, %r11
    xor          %r14, %r13
    mov          %rax, %r15
    rorx         $(39), %rax, %r12
    add          %r13, %r11
    xor          %rbx, %r15
    rorx         $(34), %rax, %r14
    rorx         $(28), %rax, %r13
    add          %r11, %rdx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rbx, %rdi
    xor          %r13, %r14
    add          %rdi, %r11
    mov          %r8, %r12
    addq         (136)(%rsp), %r10
    and          %rdx, %r12
    rorx         $(41), %rdx, %r13
    rorx         $(18), %rdx, %rdi
    add          %r14, %r11
    add          %r12, %r10
    andn         %r9, %rdx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rdx, %r14
    add          %r12, %r10
    xor          %r14, %r13
    mov          %r11, %rdi
    rorx         $(39), %r11, %r12
    add          %r13, %r10
    xor          %rax, %rdi
    rorx         $(34), %r11, %r14
    rorx         $(28), %r11, %r13
    add          %r10, %rcx
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rax, %r15
    xor          %r13, %r14
    add          %r15, %r10
    mov          %rdx, %r12
    addq         (160)(%rsp), %r9
    and          %rcx, %r12
    rorx         $(41), %rcx, %r13
    rorx         $(18), %rcx, %r15
    add          %r14, %r10
    add          %r12, %r9
    andn         %r8, %rcx, %r12
    xor          %r15, %r13
    rorx         $(14), %rcx, %r14
    add          %r12, %r9
    xor          %r14, %r13
    mov          %r10, %r15
    rorx         $(39), %r10, %r12
    add          %r13, %r9
    xor          %r11, %r15
    rorx         $(34), %r10, %r14
    rorx         $(28), %r10, %r13
    add          %r9, %rbx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r11, %rdi
    xor          %r13, %r14
    add          %rdi, %r9
    mov          %rcx, %r12
    addq         (168)(%rsp), %r8
    and          %rbx, %r12
    rorx         $(41), %rbx, %r13
    rorx         $(18), %rbx, %rdi
    add          %r14, %r9
    add          %r12, %r8
    andn         %rdx, %rbx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rbx, %r14
    add          %r12, %r8
    xor          %r14, %r13
    mov          %r9, %rdi
    rorx         $(39), %r9, %r12
    add          %r13, %r8
    xor          %r10, %rdi
    rorx         $(34), %r9, %r14
    rorx         $(28), %r9, %r13
    add          %r8, %rax
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r10, %r15
    xor          %r13, %r14
    add          %r15, %r8
    mov          %rbx, %r12
    addq         (192)(%rsp), %rdx
    and          %rax, %r12
    rorx         $(41), %rax, %r13
    rorx         $(18), %rax, %r15
    add          %r14, %r8
    add          %r12, %rdx
    andn         %rcx, %rax, %r12
    xor          %r15, %r13
    rorx         $(14), %rax, %r14
    add          %r12, %rdx
    xor          %r14, %r13
    mov          %r8, %r15
    rorx         $(39), %r8, %r12
    add          %r13, %rdx
    xor          %r9, %r15
    rorx         $(34), %r8, %r14
    rorx         $(28), %r8, %r13
    add          %rdx, %r11
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r9, %rdi
    xor          %r13, %r14
    add          %rdi, %rdx
    mov          %rax, %r12
    addq         (200)(%rsp), %rcx
    and          %r11, %r12
    rorx         $(41), %r11, %r13
    rorx         $(18), %r11, %rdi
    add          %r14, %rdx
    add          %r12, %rcx
    andn         %rbx, %r11, %r12
    xor          %rdi, %r13
    rorx         $(14), %r11, %r14
    add          %r12, %rcx
    xor          %r14, %r13
    mov          %rdx, %rdi
    rorx         $(39), %rdx, %r12
    add          %r13, %rcx
    xor          %r8, %rdi
    rorx         $(34), %rdx, %r14
    rorx         $(28), %rdx, %r13
    add          %rcx, %r10
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r8, %r15
    xor          %r13, %r14
    add          %r15, %rcx
    mov          %r11, %r12
    addq         (224)(%rsp), %rbx
    and          %r10, %r12
    rorx         $(41), %r10, %r13
    rorx         $(18), %r10, %r15
    add          %r14, %rcx
    add          %r12, %rbx
    andn         %rax, %r10, %r12
    xor          %r15, %r13
    rorx         $(14), %r10, %r14
    add          %r12, %rbx
    xor          %r14, %r13
    mov          %rcx, %r15
    rorx         $(39), %rcx, %r12
    add          %r13, %rbx
    xor          %rdx, %r15
    rorx         $(34), %rcx, %r14
    rorx         $(28), %rcx, %r13
    add          %rbx, %r9
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rdx, %rdi
    xor          %r13, %r14
    add          %rdi, %rbx
    mov          %r10, %r12
    addq         (232)(%rsp), %rax
    and          %r9, %r12
    rorx         $(41), %r9, %r13
    rorx         $(18), %r9, %rdi
    add          %r14, %rbx
    add          %r12, %rax
    andn         %r11, %r9, %r12
    xor          %rdi, %r13
    rorx         $(14), %r9, %r14
    add          %r12, %rax
    xor          %r14, %r13
    mov          %rbx, %rdi
    rorx         $(39), %rbx, %r12
    add          %r13, %rax
    xor          %rcx, %rdi
    rorx         $(34), %rbx, %r14
    rorx         $(28), %rbx, %r13
    add          %rax, %r8
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rcx, %r15
    xor          %r13, %r14
    add          %r15, %rax
    mov          %r9, %r12
    add          %r14, %rax
    sub          $(1024), %rsp
    movq         (-24)(%rsp), %rdi
    movq         (-16)(%rsp), %r14
    addq         (%rdi), %rax
    movq         %rax, (%rdi)
    addq         (8)(%rdi), %rbx
    movq         %rbx, (8)(%rdi)
    addq         (16)(%rdi), %rcx
    movq         %rcx, (16)(%rdi)
    addq         (24)(%rdi), %rdx
    movq         %rdx, (24)(%rdi)
    addq         (32)(%rdi), %r8
    movq         %r8, (32)(%rdi)
    addq         (40)(%rdi), %r9
    movq         %r9, (40)(%rdi)
    addq         (48)(%rdi), %r10
    movq         %r10, (48)(%rdi)
    addq         (56)(%rdi), %r11
    movq         %r11, (56)(%rdi)
    cmp          $(256), %r14
    jl           .Ldonegas_1
    add          $(16), %rsp
    lea          (1280)(%rsp), %rbp
    mov          %rbx, %rdi
    xor          %r14, %r14
    mov          %r9, %r12
    xor          %rcx, %rdi
.p2align 5, 0x90
.Lblock2_procgas_1: 
    addq         (%rsp), %r11
    and          %r8, %r12
    rorx         $(41), %r8, %r13
    rorx         $(18), %r8, %r15
    add          %r14, %rax
    add          %r12, %r11
    andn         %r10, %r8, %r12
    xor          %r15, %r13
    rorx         $(14), %r8, %r14
    add          %r12, %r11
    xor          %r14, %r13
    mov          %rax, %r15
    rorx         $(39), %rax, %r12
    add          %r13, %r11
    xor          %rbx, %r15
    rorx         $(34), %rax, %r14
    rorx         $(28), %rax, %r13
    add          %r11, %rdx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rbx, %rdi
    xor          %r13, %r14
    add          %rdi, %r11
    mov          %r8, %r12
    addq         (8)(%rsp), %r10
    and          %rdx, %r12
    rorx         $(41), %rdx, %r13
    rorx         $(18), %rdx, %rdi
    add          %r14, %r11
    add          %r12, %r10
    andn         %r9, %rdx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rdx, %r14
    add          %r12, %r10
    xor          %r14, %r13
    mov          %r11, %rdi
    rorx         $(39), %r11, %r12
    add          %r13, %r10
    xor          %rax, %rdi
    rorx         $(34), %r11, %r14
    rorx         $(28), %r11, %r13
    add          %r10, %rcx
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rax, %r15
    xor          %r13, %r14
    add          %r15, %r10
    mov          %rdx, %r12
    addq         (32)(%rsp), %r9
    and          %rcx, %r12
    rorx         $(41), %rcx, %r13
    rorx         $(18), %rcx, %r15
    add          %r14, %r10
    add          %r12, %r9
    andn         %r8, %rcx, %r12
    xor          %r15, %r13
    rorx         $(14), %rcx, %r14
    add          %r12, %r9
    xor          %r14, %r13
    mov          %r10, %r15
    rorx         $(39), %r10, %r12
    add          %r13, %r9
    xor          %r11, %r15
    rorx         $(34), %r10, %r14
    rorx         $(28), %r10, %r13
    add          %r9, %rbx
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r11, %rdi
    xor          %r13, %r14
    add          %rdi, %r9
    mov          %rcx, %r12
    addq         (40)(%rsp), %r8
    and          %rbx, %r12
    rorx         $(41), %rbx, %r13
    rorx         $(18), %rbx, %rdi
    add          %r14, %r9
    add          %r12, %r8
    andn         %rdx, %rbx, %r12
    xor          %rdi, %r13
    rorx         $(14), %rbx, %r14
    add          %r12, %r8
    xor          %r14, %r13
    mov          %r9, %rdi
    rorx         $(39), %r9, %r12
    add          %r13, %r8
    xor          %r10, %rdi
    rorx         $(34), %r9, %r14
    rorx         $(28), %r9, %r13
    add          %r8, %rax
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r10, %r15
    xor          %r13, %r14
    add          %r15, %r8
    mov          %rbx, %r12
    addq         (64)(%rsp), %rdx
    and          %rax, %r12
    rorx         $(41), %rax, %r13
    rorx         $(18), %rax, %r15
    add          %r14, %r8
    add          %r12, %rdx
    andn         %rcx, %rax, %r12
    xor          %r15, %r13
    rorx         $(14), %rax, %r14
    add          %r12, %rdx
    xor          %r14, %r13
    mov          %r8, %r15
    rorx         $(39), %r8, %r12
    add          %r13, %rdx
    xor          %r9, %r15
    rorx         $(34), %r8, %r14
    rorx         $(28), %r8, %r13
    add          %rdx, %r11
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %r9, %rdi
    xor          %r13, %r14
    add          %rdi, %rdx
    mov          %rax, %r12
    addq         (72)(%rsp), %rcx
    and          %r11, %r12
    rorx         $(41), %r11, %r13
    rorx         $(18), %r11, %rdi
    add          %r14, %rdx
    add          %r12, %rcx
    andn         %rbx, %r11, %r12
    xor          %rdi, %r13
    rorx         $(14), %r11, %r14
    add          %r12, %rcx
    xor          %r14, %r13
    mov          %rdx, %rdi
    rorx         $(39), %rdx, %r12
    add          %r13, %rcx
    xor          %r8, %rdi
    rorx         $(34), %rdx, %r14
    rorx         $(28), %rdx, %r13
    add          %rcx, %r10
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %r8, %r15
    xor          %r13, %r14
    add          %r15, %rcx
    mov          %r11, %r12
    addq         (96)(%rsp), %rbx
    and          %r10, %r12
    rorx         $(41), %r10, %r13
    rorx         $(18), %r10, %r15
    add          %r14, %rcx
    add          %r12, %rbx
    andn         %rax, %r10, %r12
    xor          %r15, %r13
    rorx         $(14), %r10, %r14
    add          %r12, %rbx
    xor          %r14, %r13
    mov          %rcx, %r15
    rorx         $(39), %rcx, %r12
    add          %r13, %rbx
    xor          %rdx, %r15
    rorx         $(34), %rcx, %r14
    rorx         $(28), %rcx, %r13
    add          %rbx, %r9
    and          %r15, %rdi
    xor          %r12, %r14
    xor          %rdx, %rdi
    xor          %r13, %r14
    add          %rdi, %rbx
    mov          %r10, %r12
    addq         (104)(%rsp), %rax
    and          %r9, %r12
    rorx         $(41), %r9, %r13
    rorx         $(18), %r9, %rdi
    add          %r14, %rbx
    add          %r12, %rax
    andn         %r11, %r9, %r12
    xor          %rdi, %r13
    rorx         $(14), %r9, %r14
    add          %r12, %rax
    xor          %r14, %r13
    mov          %rbx, %rdi
    rorx         $(39), %rbx, %r12
    add          %r13, %rax
    xor          %rcx, %rdi
    rorx         $(34), %rbx, %r14
    rorx         $(28), %rbx, %r13
    add          %rax, %r8
    and          %rdi, %r15
    xor          %r12, %r14
    xor          %rcx, %r15
    xor          %r13, %r14
    add          %r15, %rax
    mov          %r9, %r12
    add          $(128), %rsp
    cmp          %rbp, %rsp
    jb           .Lblock2_procgas_1
    add          %r14, %rax
    sub          $(1296), %rsp
    movq         (-24)(%rsp), %rdi
    movq         (-16)(%rsp), %r14
    addq         (%rdi), %rax
    movq         %rax, (%rdi)
    addq         (8)(%rdi), %rbx
    movq         %rbx, (8)(%rdi)
    addq         (16)(%rdi), %rcx
    movq         %rcx, (16)(%rdi)
    addq         (24)(%rdi), %rdx
    movq         %rdx, (24)(%rdi)
    addq         (32)(%rdi), %r8
    movq         %r8, (32)(%rdi)
    addq         (40)(%rdi), %r9
    movq         %r9, (40)(%rdi)
    addq         (48)(%rdi), %r10
    movq         %r10, (48)(%rdi)
    addq         (56)(%rdi), %r11
    movq         %r11, (56)(%rdi)
    add          $(256), %rsi
    sub          $(256), %r14
    movq         %r14, (-16)(%rsp)
    jg           .Lsha512_block2_loopgas_1
.Ldonegas_1: 
    movq         (-8)(%rsp), %rsp
    add          $(1312), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
