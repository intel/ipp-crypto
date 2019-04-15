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
 
SHA1_YMM_K:
.long   0x5a827999,  0x5a827999,  0x5a827999,  0x5a827999,  0x5a827999,  0x5a827999,  0x5a827999,  0x5a827999 
 

.long   0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1,  0x6ed9eba1 
 

.long   0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc,  0x8f1bbcdc 
 

.long   0xca62c1d6,  0xca62c1d6,  0xca62c1d6,  0xca62c1d6,  0xca62c1d6,  0xca62c1d6,  0xca62c1d6,  0xca62c1d6 
 
SHA1_YMM_BF:
.long     0x10203, 0x4050607, 0x8090a0b, 0xc0d0e0f 
 

.long     0x10203, 0x4050607, 0x8090a0b, 0xc0d0e0f 
.p2align 5, 0x90
 
.globl _UpdateSHA1

 
_UpdateSHA1:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(648), %rsp
 
    mov          %rsp, %r15
    and          $(-32), %rsp
    movslq       %edx, %r14
    vmovdqa      SHA1_YMM_BF(%rip), %ymm11
    movl         (%rdi), %eax
    movl         (4)(%rdi), %ebp
    movl         (8)(%rdi), %ecx
    movl         (12)(%rdi), %edx
    movl         (16)(%rdi), %r8d
.p2align 5, 0x90
.Lsha1_block2_loopgas_1: 
    lea          (64)(%rsi), %r13
    cmp          $(64), %r14
    cmovbe       %rsi, %r13
    vmovdqa      SHA1_YMM_K(%rip), %ymm12
    vmovdqu      (%rsi), %xmm9
    vmovdqu      (16)(%rsi), %xmm8
    vmovdqu      (32)(%rsi), %xmm7
    vmovdqu      (48)(%rsi), %xmm6
    vinserti128  $(1), (%r13), %ymm9, %ymm9
    vinserti128  $(1), (16)(%r13), %ymm8, %ymm8
    vinserti128  $(1), (32)(%r13), %ymm7, %ymm7
    vinserti128  $(1), (48)(%r13), %ymm6, %ymm6
    mov          %rsp, %r13
    vpshufb      %ymm11, %ymm9, %ymm2
    vpaddd       %ymm12, %ymm2, %ymm9
    vmovdqa      %ymm9, (%r13)
    vpshufb      %ymm11, %ymm8, %ymm9
    vpaddd       %ymm12, %ymm9, %ymm8
    vmovdqa      %ymm8, (32)(%r13)
    vpshufb      %ymm11, %ymm7, %ymm8
    vpaddd       %ymm12, %ymm8, %ymm7
    vmovdqa      %ymm7, (64)(%r13)
    vpshufb      %ymm11, %ymm6, %ymm7
    vpaddd       %ymm12, %ymm7, %ymm6
    vmovdqa      %ymm6, (96)(%r13)
    rorx         $(2), %ebp, %ebx
    andn         %edx, %ebp, %r10d
    and          %ecx, %ebp
    xor          %r10d, %ebp
    vpalignr     $(8), %ymm2, %ymm9, %ymm6
    vpsrldq      $(4), %ymm7, %ymm0
    vpxor        %ymm2, %ymm6, %ymm6
    vpxor        %ymm8, %ymm0, %ymm0
    addl         (%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    vpxor        %ymm0, %ymm6, %ymm6
    vpsrld       $(31), %ymm6, %ymm0
    vpslldq      $(12), %ymm6, %ymm1
    vpaddd       %ymm6, %ymm6, %ymm6
    addl         (4)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    vpsrld       $(30), %ymm1, %ymm10
    vpxor        %ymm0, %ymm6, %ymm6
    vpslld       $(2), %ymm1, %ymm1
    vpxor        %ymm10, %ymm6, %ymm6
    addl         (8)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    vpxor        %ymm1, %ymm6, %ymm6
    vpaddd       %ymm12, %ymm6, %ymm0
    vmovdqa      %ymm0, (128)(%r13)
    addl         (12)(%r13), %ebx
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    vmovdqa      SHA1_YMM_K+32(%rip), %ymm12
    vpalignr     $(8), %ymm9, %ymm8, %ymm5
    vpsrldq      $(4), %ymm6, %ymm0
    vpxor        %ymm9, %ymm5, %ymm5
    vpxor        %ymm7, %ymm0, %ymm0
    addl         (32)(%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    vpxor        %ymm0, %ymm5, %ymm5
    vpsrld       $(31), %ymm5, %ymm0
    vpslldq      $(12), %ymm5, %ymm1
    vpaddd       %ymm5, %ymm5, %ymm5
    addl         (36)(%r13), %eax
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    vpsrld       $(30), %ymm1, %ymm10
    vpxor        %ymm0, %ymm5, %ymm5
    vpslld       $(2), %ymm1, %ymm1
    vpxor        %ymm10, %ymm5, %ymm5
    addl         (40)(%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    vpxor        %ymm1, %ymm5, %ymm5
    vpaddd       %ymm12, %ymm5, %ymm0
    vmovdqa      %ymm0, (160)(%r13)
    addl         (44)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    vpalignr     $(8), %ymm8, %ymm7, %ymm4
    vpsrldq      $(4), %ymm5, %ymm0
    vpxor        %ymm8, %ymm4, %ymm4
    vpxor        %ymm6, %ymm0, %ymm0
    addl         (64)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    vpxor        %ymm0, %ymm4, %ymm4
    vpsrld       $(31), %ymm4, %ymm0
    vpslldq      $(12), %ymm4, %ymm1
    vpaddd       %ymm4, %ymm4, %ymm4
    addl         (68)(%r13), %ebx
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    vpsrld       $(30), %ymm1, %ymm10
    vpxor        %ymm0, %ymm4, %ymm4
    vpslld       $(2), %ymm1, %ymm1
    vpxor        %ymm10, %ymm4, %ymm4
    addl         (72)(%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    vpxor        %ymm1, %ymm4, %ymm4
    vpaddd       %ymm12, %ymm4, %ymm0
    vmovdqa      %ymm0, (192)(%r13)
    addl         (76)(%r13), %eax
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    vpalignr     $(8), %ymm7, %ymm6, %ymm3
    vpsrldq      $(4), %ymm4, %ymm0
    vpxor        %ymm7, %ymm3, %ymm3
    vpxor        %ymm5, %ymm0, %ymm0
    addl         (96)(%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    vpxor        %ymm0, %ymm3, %ymm3
    vpsrld       $(31), %ymm3, %ymm0
    vpslldq      $(12), %ymm3, %ymm1
    vpaddd       %ymm3, %ymm3, %ymm3
    addl         (100)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    vpsrld       $(30), %ymm1, %ymm10
    vpxor        %ymm0, %ymm3, %ymm3
    vpslld       $(2), %ymm1, %ymm1
    vpxor        %ymm10, %ymm3, %ymm3
    addl         (104)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    vpxor        %ymm1, %ymm3, %ymm3
    vpaddd       %ymm12, %ymm3, %ymm0
    vmovdqa      %ymm0, (224)(%r13)
    addl         (108)(%r13), %ebx
    add          $(128), %r13
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    vpalignr     $(8), %ymm4, %ymm3, %ymm0
    vpxor        %ymm9, %ymm2, %ymm2
    addl         (%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    vpxor        %ymm6, %ymm2, %ymm2
    vpxor        %ymm0, %ymm2, %ymm2
    addl         (4)(%r13), %eax
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    vpslld       $(2), %ymm2, %ymm0
    vpsrld       $(30), %ymm2, %ymm2
    addl         (8)(%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    vpxor        %ymm2, %ymm0, %ymm2
    vpaddd       %ymm12, %ymm2, %ymm0
    vmovdqa      %ymm0, (128)(%r13)
    addl         (12)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    add          %r11d, %edx
    xor          %ebp, %r8d
    xor          %ebx, %r8d
    vpalignr     $(8), %ymm3, %ymm2, %ymm0
    vpxor        %ymm8, %ymm9, %ymm9
    addl         (32)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    vpxor        %ymm5, %ymm9, %ymm9
    vpxor        %ymm0, %ymm9, %ymm9
    addl         (36)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    vpslld       $(2), %ymm9, %ymm0
    vpsrld       $(30), %ymm9, %ymm9
    addl         (40)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    vpxor        %ymm9, %ymm0, %ymm9
    vpaddd       %ymm12, %ymm9, %ymm0
    vmovdqa      %ymm0, (160)(%r13)
    addl         (44)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    vmovdqa      SHA1_YMM_K+64(%rip), %ymm12
    vpalignr     $(8), %ymm2, %ymm9, %ymm0
    vpxor        %ymm7, %ymm8, %ymm8
    addl         (64)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    vpxor        %ymm4, %ymm8, %ymm8
    vpxor        %ymm0, %ymm8, %ymm8
    addl         (68)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    vpslld       $(2), %ymm8, %ymm0
    vpsrld       $(30), %ymm8, %ymm8
    addl         (72)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    vpxor        %ymm8, %ymm0, %ymm8
    vpaddd       %ymm12, %ymm8, %ymm0
    vmovdqa      %ymm0, (192)(%r13)
    addl         (76)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    vpalignr     $(8), %ymm9, %ymm8, %ymm0
    vpxor        %ymm6, %ymm7, %ymm7
    addl         (96)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    vpxor        %ymm3, %ymm7, %ymm7
    vpxor        %ymm0, %ymm7, %ymm7
    addl         (100)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    vpslld       $(2), %ymm7, %ymm0
    vpsrld       $(30), %ymm7, %ymm7
    addl         (104)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    vpxor        %ymm7, %ymm0, %ymm7
    vpaddd       %ymm12, %ymm7, %ymm0
    vmovdqa      %ymm0, (224)(%r13)
    addl         (108)(%r13), %edx
    add          $(128), %r13
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    vpalignr     $(8), %ymm8, %ymm7, %ymm0
    vpxor        %ymm5, %ymm6, %ymm6
    addl         (%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    vpxor        %ymm2, %ymm6, %ymm6
    vpxor        %ymm0, %ymm6, %ymm6
    addl         (4)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    vpslld       $(2), %ymm6, %ymm0
    vpsrld       $(30), %ymm6, %ymm6
    addl         (8)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    vpxor        %ymm6, %ymm0, %ymm6
    vpaddd       %ymm12, %ymm6, %ymm0
    vmovdqa      %ymm0, (128)(%r13)
    addl         (12)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    vpalignr     $(8), %ymm7, %ymm6, %ymm0
    vpxor        %ymm4, %ymm5, %ymm5
    addl         (32)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    vpxor        %ymm9, %ymm5, %ymm5
    vpxor        %ymm0, %ymm5, %ymm5
    addl         (36)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    vpslld       $(2), %ymm5, %ymm0
    vpsrld       $(30), %ymm5, %ymm5
    addl         (40)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    vpxor        %ymm5, %ymm0, %ymm5
    vpaddd       %ymm12, %ymm5, %ymm0
    vmovdqa      %ymm0, (160)(%r13)
    addl         (44)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    and          %r10d, %ecx
    vpalignr     $(8), %ymm6, %ymm5, %ymm0
    vpxor        %ymm3, %ymm4, %ymm4
    addl         (64)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    vpxor        %ymm8, %ymm4, %ymm4
    vpxor        %ymm0, %ymm4, %ymm4
    addl         (68)(%r13), %eax
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    vpslld       $(2), %ymm4, %ymm0
    vpsrld       $(30), %ymm4, %ymm4
    addl         (72)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    vpxor        %ymm4, %ymm0, %ymm4
    vpaddd       %ymm12, %ymm4, %ymm0
    vmovdqa      %ymm0, (192)(%r13)
    addl         (76)(%r13), %edx
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    vmovdqa      SHA1_YMM_K+96(%rip), %ymm12
    vpalignr     $(8), %ymm5, %ymm4, %ymm0
    vpxor        %ymm2, %ymm3, %ymm3
    addl         (96)(%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    vpxor        %ymm7, %ymm3, %ymm3
    vpxor        %ymm0, %ymm3, %ymm3
    addl         (100)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    vpslld       $(2), %ymm3, %ymm0
    vpsrld       $(30), %ymm3, %ymm3
    addl         (104)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    vpxor        %ymm3, %ymm0, %ymm3
    vpaddd       %ymm12, %ymm3, %ymm0
    vmovdqa      %ymm0, (224)(%r13)
    addl         (108)(%r13), %eax
    add          $(128), %r13
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    vpalignr     $(8), %ymm4, %ymm3, %ymm0
    vpxor        %ymm9, %ymm2, %ymm2
    addl         (%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    vpxor        %ymm6, %ymm2, %ymm2
    vpxor        %ymm0, %ymm2, %ymm2
    addl         (4)(%r13), %edx
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    vpslld       $(2), %ymm2, %ymm0
    vpsrld       $(30), %ymm2, %ymm2
    addl         (8)(%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    vpxor        %ymm2, %ymm0, %ymm2
    vpaddd       %ymm12, %ymm2, %ymm0
    vmovdqa      %ymm0, (128)(%r13)
    addl         (12)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    vpalignr     $(8), %ymm3, %ymm2, %ymm0
    vpxor        %ymm8, %ymm9, %ymm9
    addl         (32)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    vpxor        %ymm5, %ymm9, %ymm9
    vpxor        %ymm0, %ymm9, %ymm9
    addl         (36)(%r13), %eax
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    vpslld       $(2), %ymm9, %ymm0
    vpsrld       $(30), %ymm9, %ymm9
    addl         (40)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    vpxor        %ymm9, %ymm0, %ymm9
    vpaddd       %ymm12, %ymm9, %ymm0
    vmovdqa      %ymm0, (160)(%r13)
    addl         (44)(%r13), %edx
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    vpalignr     $(8), %ymm2, %ymm9, %ymm0
    vpxor        %ymm7, %ymm8, %ymm8
    addl         (64)(%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    vpxor        %ymm4, %ymm8, %ymm8
    vpxor        %ymm0, %ymm8, %ymm8
    addl         (68)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    vpslld       $(2), %ymm8, %ymm0
    vpsrld       $(30), %ymm8, %ymm8
    addl         (72)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    vpxor        %ymm8, %ymm0, %ymm8
    vpaddd       %ymm12, %ymm8, %ymm0
    vmovdqa      %ymm0, (192)(%r13)
    addl         (76)(%r13), %eax
    xor          %edx, %ebx
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    vpalignr     $(8), %ymm9, %ymm8, %ymm0
    vpxor        %ymm6, %ymm7, %ymm7
    addl         (96)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    vpxor        %ymm3, %ymm7, %ymm7
    vpxor        %ymm0, %ymm7, %ymm7
    addl         (100)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    vpslld       $(2), %ymm7, %ymm0
    vpsrld       $(30), %ymm7, %ymm7
    addl         (104)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    vpxor        %ymm7, %ymm0, %ymm7
    vpaddd       %ymm12, %ymm7, %ymm0
    vmovdqa      %ymm0, (224)(%r13)
    addl         (108)(%r13), %ebx
    add          $(128), %r13
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (4)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (8)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (12)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (32)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (36)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (40)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (44)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (64)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (68)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (72)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (76)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (96)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (100)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (104)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (108)(%r13), %edx
    add          $(128), %r13
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    add          %r11d, %edx
    lea          (16)(%rsp), %r13
    addl         (%rdi), %edx
    movl         %edx, (%rdi)
    addl         (4)(%rdi), %r8d
    movl         %r8d, (4)(%rdi)
    addl         (8)(%rdi), %ebp
    movl         %ebp, (8)(%rdi)
    addl         (12)(%rdi), %ebx
    movl         %ebx, (12)(%rdi)
    addl         (16)(%rdi), %ecx
    movl         %ecx, (16)(%rdi)
    cmp          $(128), %r14
    jl           .Ldonegas_1
    rorx         $(2), %r8d, %eax
    andn         %ebx, %r8d, %r10d
    and          %ebp, %r8d
    xor          %r10d, %r8d
    addl         (%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    addl         (4)(%r13), %ebx
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    addl         (8)(%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    addl         (12)(%r13), %eax
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    addl         (32)(%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    addl         (36)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    addl         (40)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    addl         (44)(%r13), %ebx
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    addl         (64)(%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    addl         (68)(%r13), %eax
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    addl         (72)(%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    addl         (76)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    addl         (96)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    addl         (100)(%r13), %ebx
    andn         %eax, %ecx, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    and          %r8d, %ecx
    add          %r11d, %ebx
    xor          %r10d, %ecx
    addl         (104)(%r13), %ebp
    andn         %r8d, %ebx, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    and          %edx, %ebx
    add          %r11d, %ebp
    xor          %r10d, %ebx
    addl         (108)(%r13), %eax
    add          $(128), %r13
    andn         %edx, %ebp, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    and          %ecx, %ebp
    add          %r11d, %eax
    xor          %r10d, %ebp
    addl         (%r13), %r8d
    andn         %ecx, %eax, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    and          %ebx, %eax
    add          %r11d, %r8d
    xor          %r10d, %eax
    addl         (4)(%r13), %edx
    andn         %ebx, %r8d, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    and          %ebp, %r8d
    add          %r11d, %edx
    xor          %r10d, %r8d
    addl         (8)(%r13), %ecx
    andn         %ebp, %edx, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    and          %eax, %edx
    add          %r11d, %ecx
    xor          %r10d, %edx
    addl         (12)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    add          %r11d, %ebx
    xor          %r8d, %ecx
    xor          %eax, %ecx
    addl         (32)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (36)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (40)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (44)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (64)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (68)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (72)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (76)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (96)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (100)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (104)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (108)(%r13), %ebx
    add          $(128), %r13
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (4)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (8)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (12)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (32)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (36)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (40)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (44)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    mov          %ecx, %r10d
    xor          %edx, %r10d
    and          %r10d, %ebp
    addl         (64)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    addl         (68)(%r13), %edx
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    addl         (72)(%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    addl         (76)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    addl         (96)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    addl         (100)(%r13), %eax
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    addl         (104)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    addl         (108)(%r13), %edx
    add          $(128), %r13
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    addl         (%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    addl         (4)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    addl         (8)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    addl         (12)(%r13), %eax
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    addl         (32)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    addl         (36)(%r13), %edx
    xor          %ebx, %eax
    mov          %ebp, %r10d
    xor          %ebx, %r10d
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    and          %r10d, %r8d
    addl         (40)(%r13), %ecx
    xor          %ebp, %r8d
    mov          %eax, %r10d
    xor          %ebp, %r10d
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    and          %r10d, %edx
    addl         (44)(%r13), %ebx
    xor          %eax, %edx
    mov          %r8d, %r10d
    xor          %eax, %r10d
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    and          %r10d, %ecx
    addl         (64)(%r13), %ebp
    xor          %r8d, %ecx
    mov          %edx, %r10d
    xor          %r8d, %r10d
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    and          %r10d, %ebx
    addl         (68)(%r13), %eax
    xor          %edx, %ebx
    mov          %ecx, %r10d
    xor          %edx, %r10d
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    and          %r10d, %ebp
    addl         (72)(%r13), %r8d
    xor          %ecx, %ebp
    mov          %ebx, %r10d
    xor          %ecx, %r10d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    and          %r10d, %eax
    addl         (76)(%r13), %edx
    xor          %ebx, %eax
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (96)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (100)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (104)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (108)(%r13), %eax
    add          $(128), %r13
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (4)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (8)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (12)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (32)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (36)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (40)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (44)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (64)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (68)(%r13), %ebx
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    rorx         $(2), %ecx, %edx
    xor          %r8d, %ecx
    add          %r11d, %ebx
    xor          %eax, %ecx
    addl         (72)(%r13), %ebp
    add          %ecx, %ebp
    rorx         $(27), %ebx, %r11d
    rorx         $(2), %ebx, %ecx
    xor          %edx, %ebx
    add          %r11d, %ebp
    xor          %r8d, %ebx
    addl         (76)(%r13), %eax
    add          %ebx, %eax
    rorx         $(27), %ebp, %r11d
    rorx         $(2), %ebp, %ebx
    xor          %ecx, %ebp
    add          %r11d, %eax
    xor          %edx, %ebp
    addl         (96)(%r13), %r8d
    add          %ebp, %r8d
    rorx         $(27), %eax, %r11d
    rorx         $(2), %eax, %ebp
    xor          %ebx, %eax
    add          %r11d, %r8d
    xor          %ecx, %eax
    addl         (100)(%r13), %edx
    add          %eax, %edx
    rorx         $(27), %r8d, %r11d
    rorx         $(2), %r8d, %eax
    xor          %ebp, %r8d
    add          %r11d, %edx
    xor          %ebx, %r8d
    addl         (104)(%r13), %ecx
    add          %r8d, %ecx
    rorx         $(27), %edx, %r11d
    rorx         $(2), %edx, %r8d
    xor          %eax, %edx
    add          %r11d, %ecx
    xor          %ebp, %edx
    addl         (108)(%r13), %ebx
    add          $(128), %r13
    add          %edx, %ebx
    rorx         $(27), %ecx, %r11d
    add          %r11d, %ebx
    addl         (%rdi), %ebx
    movl         %ebx, (%rdi)
    addl         (4)(%rdi), %ecx
    movl         %ecx, (4)(%rdi)
    addl         (8)(%rdi), %r8d
    movl         %r8d, (8)(%rdi)
    addl         (12)(%rdi), %eax
    movl         %eax, (12)(%rdi)
    addl         (16)(%rdi), %ebp
    movl         %ebp, (16)(%rdi)
    mov          %eax, %edx
    mov          %ebx, %eax
    mov          %ebp, %r10d
    mov          %ecx, %ebp
    mov          %r8d, %ecx
    mov          %r10d, %r8d
    add          $(128), %rsi
    sub          $(128), %r14
    jg           .Lsha1_block2_loopgas_1
.Ldonegas_1: 
    mov          %r15, %rsp
    add          $(648), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
 
