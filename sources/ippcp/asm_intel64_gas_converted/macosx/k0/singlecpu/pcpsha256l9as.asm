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
.p2align 6, 0x90
 
SHA256_YMM_K:
.long   0x428a2f98,  0x71374491,  0xb5c0fbcf,  0xe9b5dba5,  0x428a2f98,  0x71374491,  0xb5c0fbcf,  0xe9b5dba5 
 

.long   0x3956c25b,  0x59f111f1,  0x923f82a4,  0xab1c5ed5,  0x3956c25b,  0x59f111f1,  0x923f82a4,  0xab1c5ed5 
 

.long   0xd807aa98,  0x12835b01,  0x243185be,  0x550c7dc3,  0xd807aa98,  0x12835b01,  0x243185be,  0x550c7dc3 
 

.long   0x72be5d74,  0x80deb1fe,  0x9bdc06a7,  0xc19bf174,  0x72be5d74,  0x80deb1fe,  0x9bdc06a7,  0xc19bf174 
 

.long   0xe49b69c1,  0xefbe4786,   0xfc19dc6,  0x240ca1cc,  0xe49b69c1,  0xefbe4786,   0xfc19dc6,  0x240ca1cc 
 

.long   0x2de92c6f,  0x4a7484aa,  0x5cb0a9dc,  0x76f988da,  0x2de92c6f,  0x4a7484aa,  0x5cb0a9dc,  0x76f988da 
 

.long   0x983e5152,  0xa831c66d,  0xb00327c8,  0xbf597fc7,  0x983e5152,  0xa831c66d,  0xb00327c8,  0xbf597fc7 
 

.long   0xc6e00bf3,  0xd5a79147,   0x6ca6351,  0x14292967,  0xc6e00bf3,  0xd5a79147,   0x6ca6351,  0x14292967 
 

.long   0x27b70a85,  0x2e1b2138,  0x4d2c6dfc,  0x53380d13,  0x27b70a85,  0x2e1b2138,  0x4d2c6dfc,  0x53380d13 
 

.long   0x650a7354,  0x766a0abb,  0x81c2c92e,  0x92722c85,  0x650a7354,  0x766a0abb,  0x81c2c92e,  0x92722c85 
 

.long   0xa2bfe8a1,  0xa81a664b,  0xc24b8b70,  0xc76c51a3,  0xa2bfe8a1,  0xa81a664b,  0xc24b8b70,  0xc76c51a3 
 

.long   0xd192e819,  0xd6990624,  0xf40e3585,  0x106aa070,  0xd192e819,  0xd6990624,  0xf40e3585,  0x106aa070 
 

.long   0x19a4c116,  0x1e376c08,  0x2748774c,  0x34b0bcb5,  0x19a4c116,  0x1e376c08,  0x2748774c,  0x34b0bcb5 
 

.long   0x391c0cb3,  0x4ed8aa4a,  0x5b9cca4f,  0x682e6ff3,  0x391c0cb3,  0x4ed8aa4a,  0x5b9cca4f,  0x682e6ff3 
 

.long   0x748f82ee,  0x78a5636f,  0x84c87814,  0x8cc70208,  0x748f82ee,  0x78a5636f,  0x84c87814,  0x8cc70208 
 

.long   0x90befffa,  0xa4506ceb,  0xbef9a3f7,  0xc67178f2,  0x90befffa,  0xa4506ceb,  0xbef9a3f7,  0xc67178f2 
 
SHA256_YMM_BF:
.long      0x10203,   0x4050607,   0x8090a0b,   0xc0d0e0f,     0x10203,   0x4050607,   0x8090a0b,   0xc0d0e0f 
 
SHA256_DCzz:
.byte   0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0,1,2,3, 8,9,10,11 
 

.byte   0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0,1,2,3, 8,9,10,11 
 
SHA256_zzBA:
.byte  0,1,2,3, 8,9,10,11,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff 
 

.byte  0,1,2,3, 8,9,10,11,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff 
.p2align 6, 0x90
 
.globl _UpdateSHA256

 
_UpdateSHA256:
 
    push         %rbx
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(544), %rsp
 
    mov          %rsp, %r15
    and          $(-64), %rsp
    movslq       %edx, %r14
    movq         %rdi, (8)(%rsp)
    movq         %r14, (16)(%rsp)
    movq         %r15, (24)(%rsp)
    lea          (32)(%rsp), %rsp
    movl         (%rdi), %eax
    movl         (4)(%rdi), %ebx
    movl         (8)(%rdi), %ecx
    movl         (12)(%rdi), %edx
    movl         (16)(%rdi), %r8d
    movl         (20)(%rdi), %r9d
    movl         (24)(%rdi), %r10d
    movl         (28)(%rdi), %r11d
    vmovdqa      SHA256_YMM_BF(%rip), %ymm10
    vmovdqa      SHA256_zzBA(%rip), %ymm8
    vmovdqa      SHA256_DCzz(%rip), %ymm9
.p2align 6, 0x90
.Lsha256_block2_loopgas_1: 
    lea          (64)(%rsi), %r12
    cmp          $(64), %r14
    cmovbe       %rsi, %r12
    lea          SHA256_YMM_K(%rip), %rbp
    vmovdqu      (%rsi), %xmm0
    vmovdqu      (16)(%rsi), %xmm1
    vmovdqu      (32)(%rsi), %xmm2
    vmovdqu      (48)(%rsi), %xmm3
    vinserti128  $(1), (%r12), %ymm0, %ymm0
    vinserti128  $(1), (16)(%r12), %ymm1, %ymm1
    vinserti128  $(1), (32)(%r12), %ymm2, %ymm2
    vinserti128  $(1), (48)(%r12), %ymm3, %ymm3
    vpshufb      %ymm10, %ymm0, %ymm0
    vpshufb      %ymm10, %ymm1, %ymm1
    vpshufb      %ymm10, %ymm2, %ymm2
    vpshufb      %ymm10, %ymm3, %ymm3
    vpaddd       (%rbp), %ymm0, %ymm4
    vpaddd       (32)(%rbp), %ymm1, %ymm5
    vpaddd       (64)(%rbp), %ymm2, %ymm6
    vpaddd       (96)(%rbp), %ymm3, %ymm7
    add          $(128), %rbp
    vmovdqa      %ymm4, (%rsp)
    vmovdqa      %ymm5, (32)(%rsp)
    vmovdqa      %ymm6, (64)(%rsp)
    vmovdqa      %ymm7, (96)(%rsp)
    mov          %ebx, %edi
    xor          %r14d, %r14d
    mov          %r9d, %r12d
    xor          %ecx, %edi
.p2align 6, 0x90
.Lblock1_shed_procgas_1: 
 
    vpalignr     $(4), %ymm0, %ymm1, %ymm6
 
    addl         (%rsp), %r11d
    and          %r8d, %r12d
    rorx         $(25), %r8d, %r13d
    vpalignr     $(4), %ymm2, %ymm3, %ymm5
    rorx         $(11), %r8d, %r15d
    add          %r14d, %eax
    add          %r12d, %r11d
    vpsrld       $(7), %ymm6, %ymm4
    andn         %r10d, %r8d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r8d, %r14d
    vpaddd       %ymm5, %ymm0, %ymm0
    add          %r12d, %r11d
    xor          %r14d, %r13d
    mov          %eax, %r15d
    vpsrld       $(3), %ymm6, %ymm5
    rorx         $(22), %eax, %r12d
    add          %r13d, %r11d
    xor          %ebx, %r15d
    vpslld       $(14), %ymm6, %ymm7
    rorx         $(13), %eax, %r14d
    rorx         $(2), %eax, %r13d
    add          %r11d, %edx
    vpxor        %ymm4, %ymm5, %ymm6
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %ebx, %edi
    vpshufd      $(250), %ymm3, %ymm5
    xor          %r13d, %r14d
    add          %edi, %r11d
    mov          %r8d, %r12d
    vpsrld       $(11), %ymm4, %ymm4
 
    addl         (4)(%rsp), %r10d
    and          %edx, %r12d
    rorx         $(25), %edx, %r13d
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(11), %edx, %edi
    add          %r14d, %r11d
    add          %r12d, %r10d
    vpslld       $(11), %ymm7, %ymm7
    andn         %r9d, %edx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %edx, %r14d
    vpxor        %ymm4, %ymm6, %ymm6
    add          %r12d, %r10d
    xor          %r14d, %r13d
    mov          %r11d, %edi
    vpsrld       $(10), %ymm5, %ymm4
    rorx         $(22), %r11d, %r12d
    add          %r13d, %r10d
    xor          %eax, %edi
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(13), %r11d, %r14d
    rorx         $(2), %r11d, %r13d
    add          %r10d, %ecx
    vpsrlq       $(17), %ymm5, %ymm5
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %eax, %r15d
    vpaddd       %ymm6, %ymm0, %ymm0
    xor          %r13d, %r14d
    add          %r15d, %r10d
    mov          %edx, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (8)(%rsp), %r9d
    and          %ecx, %r12d
    rorx         $(25), %ecx, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %ecx, %r15d
    add          %r14d, %r10d
    add          %r12d, %r9d
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %r8d, %ecx, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %ecx, %r14d
    vpshufb      %ymm8, %ymm4, %ymm4
    add          %r12d, %r9d
    xor          %r14d, %r13d
    mov          %r10d, %r15d
    vpaddd       %ymm4, %ymm0, %ymm0
    rorx         $(22), %r10d, %r12d
    add          %r13d, %r9d
    xor          %r11d, %r15d
    vpshufd      $(80), %ymm0, %ymm5
    rorx         $(13), %r10d, %r14d
    rorx         $(2), %r10d, %r13d
    add          %r9d, %ebx
    vpsrld       $(10), %ymm5, %ymm4
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r11d, %edi
    vpsrlq       $(17), %ymm5, %ymm5
    xor          %r13d, %r14d
    add          %edi, %r9d
    mov          %ecx, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (12)(%rsp), %r8d
    and          %ebx, %r12d
    rorx         $(25), %ebx, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %ebx, %edi
    add          %r14d, %r9d
    add          %r12d, %r8d
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %edx, %ebx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %ebx, %r14d
    vpshufb      %ymm9, %ymm4, %ymm4
    add          %r12d, %r8d
    xor          %r14d, %r13d
    mov          %r9d, %edi
    vpaddd       %ymm4, %ymm0, %ymm0
    rorx         $(22), %r9d, %r12d
    add          %r13d, %r8d
    xor          %r10d, %edi
    vpaddd       (%rbp), %ymm0, %ymm4
    rorx         $(13), %r9d, %r14d
    rorx         $(2), %r9d, %r13d
    add          %r8d, %eax
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r10d, %r15d
    vmovdqa      %ymm4, (128)(%rsp)
    xor          %r13d, %r14d
    add          %r15d, %r8d
    mov          %ebx, %r12d
 
    vpalignr     $(4), %ymm1, %ymm2, %ymm6
 
    addl         (32)(%rsp), %edx
    and          %eax, %r12d
    rorx         $(25), %eax, %r13d
    vpalignr     $(4), %ymm3, %ymm0, %ymm5
    rorx         $(11), %eax, %r15d
    add          %r14d, %r8d
    add          %r12d, %edx
    vpsrld       $(7), %ymm6, %ymm4
    andn         %ecx, %eax, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %eax, %r14d
    vpaddd       %ymm5, %ymm1, %ymm1
    add          %r12d, %edx
    xor          %r14d, %r13d
    mov          %r8d, %r15d
    vpsrld       $(3), %ymm6, %ymm5
    rorx         $(22), %r8d, %r12d
    add          %r13d, %edx
    xor          %r9d, %r15d
    vpslld       $(14), %ymm6, %ymm7
    rorx         $(13), %r8d, %r14d
    rorx         $(2), %r8d, %r13d
    add          %edx, %r11d
    vpxor        %ymm4, %ymm5, %ymm6
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r9d, %edi
    vpshufd      $(250), %ymm0, %ymm5
    xor          %r13d, %r14d
    add          %edi, %edx
    mov          %eax, %r12d
    vpsrld       $(11), %ymm4, %ymm4
 
    addl         (36)(%rsp), %ecx
    and          %r11d, %r12d
    rorx         $(25), %r11d, %r13d
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(11), %r11d, %edi
    add          %r14d, %edx
    add          %r12d, %ecx
    vpslld       $(11), %ymm7, %ymm7
    andn         %ebx, %r11d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r11d, %r14d
    vpxor        %ymm4, %ymm6, %ymm6
    add          %r12d, %ecx
    xor          %r14d, %r13d
    mov          %edx, %edi
    vpsrld       $(10), %ymm5, %ymm4
    rorx         $(22), %edx, %r12d
    add          %r13d, %ecx
    xor          %r8d, %edi
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(13), %edx, %r14d
    rorx         $(2), %edx, %r13d
    add          %ecx, %r10d
    vpsrlq       $(17), %ymm5, %ymm5
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r8d, %r15d
    vpaddd       %ymm6, %ymm1, %ymm1
    xor          %r13d, %r14d
    add          %r15d, %ecx
    mov          %r11d, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (40)(%rsp), %ebx
    and          %r10d, %r12d
    rorx         $(25), %r10d, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %r10d, %r15d
    add          %r14d, %ecx
    add          %r12d, %ebx
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %eax, %r10d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r10d, %r14d
    vpshufb      %ymm8, %ymm4, %ymm4
    add          %r12d, %ebx
    xor          %r14d, %r13d
    mov          %ecx, %r15d
    vpaddd       %ymm4, %ymm1, %ymm1
    rorx         $(22), %ecx, %r12d
    add          %r13d, %ebx
    xor          %edx, %r15d
    vpshufd      $(80), %ymm1, %ymm5
    rorx         $(13), %ecx, %r14d
    rorx         $(2), %ecx, %r13d
    add          %ebx, %r9d
    vpsrld       $(10), %ymm5, %ymm4
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %edx, %edi
    vpsrlq       $(17), %ymm5, %ymm5
    xor          %r13d, %r14d
    add          %edi, %ebx
    mov          %r10d, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (44)(%rsp), %eax
    and          %r9d, %r12d
    rorx         $(25), %r9d, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %r9d, %edi
    add          %r14d, %ebx
    add          %r12d, %eax
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %r11d, %r9d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r9d, %r14d
    vpshufb      %ymm9, %ymm4, %ymm4
    add          %r12d, %eax
    xor          %r14d, %r13d
    mov          %ebx, %edi
    vpaddd       %ymm4, %ymm1, %ymm1
    rorx         $(22), %ebx, %r12d
    add          %r13d, %eax
    xor          %ecx, %edi
    vpaddd       (32)(%rbp), %ymm1, %ymm4
    rorx         $(13), %ebx, %r14d
    rorx         $(2), %ebx, %r13d
    add          %eax, %r8d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %ecx, %r15d
    vmovdqa      %ymm4, (160)(%rsp)
    xor          %r13d, %r14d
    add          %r15d, %eax
    mov          %r9d, %r12d
 
    vpalignr     $(4), %ymm2, %ymm3, %ymm6
 
    addl         (64)(%rsp), %r11d
    and          %r8d, %r12d
    rorx         $(25), %r8d, %r13d
    vpalignr     $(4), %ymm0, %ymm1, %ymm5
    rorx         $(11), %r8d, %r15d
    add          %r14d, %eax
    add          %r12d, %r11d
    vpsrld       $(7), %ymm6, %ymm4
    andn         %r10d, %r8d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r8d, %r14d
    vpaddd       %ymm5, %ymm2, %ymm2
    add          %r12d, %r11d
    xor          %r14d, %r13d
    mov          %eax, %r15d
    vpsrld       $(3), %ymm6, %ymm5
    rorx         $(22), %eax, %r12d
    add          %r13d, %r11d
    xor          %ebx, %r15d
    vpslld       $(14), %ymm6, %ymm7
    rorx         $(13), %eax, %r14d
    rorx         $(2), %eax, %r13d
    add          %r11d, %edx
    vpxor        %ymm4, %ymm5, %ymm6
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %ebx, %edi
    vpshufd      $(250), %ymm1, %ymm5
    xor          %r13d, %r14d
    add          %edi, %r11d
    mov          %r8d, %r12d
    vpsrld       $(11), %ymm4, %ymm4
 
    addl         (68)(%rsp), %r10d
    and          %edx, %r12d
    rorx         $(25), %edx, %r13d
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(11), %edx, %edi
    add          %r14d, %r11d
    add          %r12d, %r10d
    vpslld       $(11), %ymm7, %ymm7
    andn         %r9d, %edx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %edx, %r14d
    vpxor        %ymm4, %ymm6, %ymm6
    add          %r12d, %r10d
    xor          %r14d, %r13d
    mov          %r11d, %edi
    vpsrld       $(10), %ymm5, %ymm4
    rorx         $(22), %r11d, %r12d
    add          %r13d, %r10d
    xor          %eax, %edi
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(13), %r11d, %r14d
    rorx         $(2), %r11d, %r13d
    add          %r10d, %ecx
    vpsrlq       $(17), %ymm5, %ymm5
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %eax, %r15d
    vpaddd       %ymm6, %ymm2, %ymm2
    xor          %r13d, %r14d
    add          %r15d, %r10d
    mov          %edx, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (72)(%rsp), %r9d
    and          %ecx, %r12d
    rorx         $(25), %ecx, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %ecx, %r15d
    add          %r14d, %r10d
    add          %r12d, %r9d
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %r8d, %ecx, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %ecx, %r14d
    vpshufb      %ymm8, %ymm4, %ymm4
    add          %r12d, %r9d
    xor          %r14d, %r13d
    mov          %r10d, %r15d
    vpaddd       %ymm4, %ymm2, %ymm2
    rorx         $(22), %r10d, %r12d
    add          %r13d, %r9d
    xor          %r11d, %r15d
    vpshufd      $(80), %ymm2, %ymm5
    rorx         $(13), %r10d, %r14d
    rorx         $(2), %r10d, %r13d
    add          %r9d, %ebx
    vpsrld       $(10), %ymm5, %ymm4
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r11d, %edi
    vpsrlq       $(17), %ymm5, %ymm5
    xor          %r13d, %r14d
    add          %edi, %r9d
    mov          %ecx, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (76)(%rsp), %r8d
    and          %ebx, %r12d
    rorx         $(25), %ebx, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %ebx, %edi
    add          %r14d, %r9d
    add          %r12d, %r8d
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %edx, %ebx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %ebx, %r14d
    vpshufb      %ymm9, %ymm4, %ymm4
    add          %r12d, %r8d
    xor          %r14d, %r13d
    mov          %r9d, %edi
    vpaddd       %ymm4, %ymm2, %ymm2
    rorx         $(22), %r9d, %r12d
    add          %r13d, %r8d
    xor          %r10d, %edi
    vpaddd       (64)(%rbp), %ymm2, %ymm4
    rorx         $(13), %r9d, %r14d
    rorx         $(2), %r9d, %r13d
    add          %r8d, %eax
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r10d, %r15d
    vmovdqa      %ymm4, (192)(%rsp)
    xor          %r13d, %r14d
    add          %r15d, %r8d
    mov          %ebx, %r12d
 
    vpalignr     $(4), %ymm3, %ymm0, %ymm6
 
    addl         (96)(%rsp), %edx
    and          %eax, %r12d
    rorx         $(25), %eax, %r13d
    vpalignr     $(4), %ymm1, %ymm2, %ymm5
    rorx         $(11), %eax, %r15d
    add          %r14d, %r8d
    add          %r12d, %edx
    vpsrld       $(7), %ymm6, %ymm4
    andn         %ecx, %eax, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %eax, %r14d
    vpaddd       %ymm5, %ymm3, %ymm3
    add          %r12d, %edx
    xor          %r14d, %r13d
    mov          %r8d, %r15d
    vpsrld       $(3), %ymm6, %ymm5
    rorx         $(22), %r8d, %r12d
    add          %r13d, %edx
    xor          %r9d, %r15d
    vpslld       $(14), %ymm6, %ymm7
    rorx         $(13), %r8d, %r14d
    rorx         $(2), %r8d, %r13d
    add          %edx, %r11d
    vpxor        %ymm4, %ymm5, %ymm6
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r9d, %edi
    vpshufd      $(250), %ymm2, %ymm5
    xor          %r13d, %r14d
    add          %edi, %edx
    mov          %eax, %r12d
    vpsrld       $(11), %ymm4, %ymm4
 
    addl         (100)(%rsp), %ecx
    and          %r11d, %r12d
    rorx         $(25), %r11d, %r13d
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(11), %r11d, %edi
    add          %r14d, %edx
    add          %r12d, %ecx
    vpslld       $(11), %ymm7, %ymm7
    andn         %ebx, %r11d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r11d, %r14d
    vpxor        %ymm4, %ymm6, %ymm6
    add          %r12d, %ecx
    xor          %r14d, %r13d
    mov          %edx, %edi
    vpsrld       $(10), %ymm5, %ymm4
    rorx         $(22), %edx, %r12d
    add          %r13d, %ecx
    xor          %r8d, %edi
    vpxor        %ymm7, %ymm6, %ymm6
    rorx         $(13), %edx, %r14d
    rorx         $(2), %edx, %r13d
    add          %ecx, %r10d
    vpsrlq       $(17), %ymm5, %ymm5
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r8d, %r15d
    vpaddd       %ymm6, %ymm3, %ymm3
    xor          %r13d, %r14d
    add          %r15d, %ecx
    mov          %r11d, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (104)(%rsp), %ebx
    and          %r10d, %r12d
    rorx         $(25), %r10d, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %r10d, %r15d
    add          %r14d, %ecx
    add          %r12d, %ebx
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %eax, %r10d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r10d, %r14d
    vpshufb      %ymm8, %ymm4, %ymm4
    add          %r12d, %ebx
    xor          %r14d, %r13d
    mov          %ecx, %r15d
    vpaddd       %ymm4, %ymm3, %ymm3
    rorx         $(22), %ecx, %r12d
    add          %r13d, %ebx
    xor          %edx, %r15d
    vpshufd      $(80), %ymm3, %ymm5
    rorx         $(13), %ecx, %r14d
    rorx         $(2), %ecx, %r13d
    add          %ebx, %r9d
    vpsrld       $(10), %ymm5, %ymm4
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %edx, %edi
    vpsrlq       $(17), %ymm5, %ymm5
    xor          %r13d, %r14d
    add          %edi, %ebx
    mov          %r10d, %r12d
    vpxor        %ymm5, %ymm4, %ymm4
 
    addl         (108)(%rsp), %eax
    and          %r9d, %r12d
    rorx         $(25), %r9d, %r13d
    vpsrlq       $(2), %ymm5, %ymm5
    rorx         $(11), %r9d, %edi
    add          %r14d, %ebx
    add          %r12d, %eax
    vpxor        %ymm5, %ymm4, %ymm4
    andn         %r11d, %r9d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r9d, %r14d
    vpshufb      %ymm9, %ymm4, %ymm4
    add          %r12d, %eax
    xor          %r14d, %r13d
    mov          %ebx, %edi
    vpaddd       %ymm4, %ymm3, %ymm3
    rorx         $(22), %ebx, %r12d
    add          %r13d, %eax
    xor          %ecx, %edi
    vpaddd       (96)(%rbp), %ymm3, %ymm4
    rorx         $(13), %ebx, %r14d
    rorx         $(2), %ebx, %r13d
    add          %eax, %r8d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %ecx, %r15d
    vmovdqa      %ymm4, (224)(%rsp)
    xor          %r13d, %r14d
    add          %r15d, %eax
    mov          %r9d, %r12d
    add          $(128), %rsp
    add          $(128), %rbp
    cmpl         $(3329325298), (-4)(%rbp)
    jne          .Lblock1_shed_procgas_1
    addl         (%rsp), %r11d
    and          %r8d, %r12d
    rorx         $(25), %r8d, %r13d
    rorx         $(11), %r8d, %r15d
    add          %r14d, %eax
    add          %r12d, %r11d
    andn         %r10d, %r8d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r8d, %r14d
    add          %r12d, %r11d
    xor          %r14d, %r13d
    mov          %eax, %r15d
    rorx         $(22), %eax, %r12d
    add          %r13d, %r11d
    xor          %ebx, %r15d
    rorx         $(13), %eax, %r14d
    rorx         $(2), %eax, %r13d
    add          %r11d, %edx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %ebx, %edi
    xor          %r13d, %r14d
    add          %edi, %r11d
    mov          %r8d, %r12d
    addl         (4)(%rsp), %r10d
    and          %edx, %r12d
    rorx         $(25), %edx, %r13d
    rorx         $(11), %edx, %edi
    add          %r14d, %r11d
    add          %r12d, %r10d
    andn         %r9d, %edx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %edx, %r14d
    add          %r12d, %r10d
    xor          %r14d, %r13d
    mov          %r11d, %edi
    rorx         $(22), %r11d, %r12d
    add          %r13d, %r10d
    xor          %eax, %edi
    rorx         $(13), %r11d, %r14d
    rorx         $(2), %r11d, %r13d
    add          %r10d, %ecx
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %eax, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r10d
    mov          %edx, %r12d
    addl         (8)(%rsp), %r9d
    and          %ecx, %r12d
    rorx         $(25), %ecx, %r13d
    rorx         $(11), %ecx, %r15d
    add          %r14d, %r10d
    add          %r12d, %r9d
    andn         %r8d, %ecx, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %ecx, %r14d
    add          %r12d, %r9d
    xor          %r14d, %r13d
    mov          %r10d, %r15d
    rorx         $(22), %r10d, %r12d
    add          %r13d, %r9d
    xor          %r11d, %r15d
    rorx         $(13), %r10d, %r14d
    rorx         $(2), %r10d, %r13d
    add          %r9d, %ebx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r11d, %edi
    xor          %r13d, %r14d
    add          %edi, %r9d
    mov          %ecx, %r12d
    addl         (12)(%rsp), %r8d
    and          %ebx, %r12d
    rorx         $(25), %ebx, %r13d
    rorx         $(11), %ebx, %edi
    add          %r14d, %r9d
    add          %r12d, %r8d
    andn         %edx, %ebx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %ebx, %r14d
    add          %r12d, %r8d
    xor          %r14d, %r13d
    mov          %r9d, %edi
    rorx         $(22), %r9d, %r12d
    add          %r13d, %r8d
    xor          %r10d, %edi
    rorx         $(13), %r9d, %r14d
    rorx         $(2), %r9d, %r13d
    add          %r8d, %eax
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r10d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r8d
    mov          %ebx, %r12d
    addl         (32)(%rsp), %edx
    and          %eax, %r12d
    rorx         $(25), %eax, %r13d
    rorx         $(11), %eax, %r15d
    add          %r14d, %r8d
    add          %r12d, %edx
    andn         %ecx, %eax, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %eax, %r14d
    add          %r12d, %edx
    xor          %r14d, %r13d
    mov          %r8d, %r15d
    rorx         $(22), %r8d, %r12d
    add          %r13d, %edx
    xor          %r9d, %r15d
    rorx         $(13), %r8d, %r14d
    rorx         $(2), %r8d, %r13d
    add          %edx, %r11d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r9d, %edi
    xor          %r13d, %r14d
    add          %edi, %edx
    mov          %eax, %r12d
    addl         (36)(%rsp), %ecx
    and          %r11d, %r12d
    rorx         $(25), %r11d, %r13d
    rorx         $(11), %r11d, %edi
    add          %r14d, %edx
    add          %r12d, %ecx
    andn         %ebx, %r11d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r11d, %r14d
    add          %r12d, %ecx
    xor          %r14d, %r13d
    mov          %edx, %edi
    rorx         $(22), %edx, %r12d
    add          %r13d, %ecx
    xor          %r8d, %edi
    rorx         $(13), %edx, %r14d
    rorx         $(2), %edx, %r13d
    add          %ecx, %r10d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r8d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %ecx
    mov          %r11d, %r12d
    addl         (40)(%rsp), %ebx
    and          %r10d, %r12d
    rorx         $(25), %r10d, %r13d
    rorx         $(11), %r10d, %r15d
    add          %r14d, %ecx
    add          %r12d, %ebx
    andn         %eax, %r10d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r10d, %r14d
    add          %r12d, %ebx
    xor          %r14d, %r13d
    mov          %ecx, %r15d
    rorx         $(22), %ecx, %r12d
    add          %r13d, %ebx
    xor          %edx, %r15d
    rorx         $(13), %ecx, %r14d
    rorx         $(2), %ecx, %r13d
    add          %ebx, %r9d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %edx, %edi
    xor          %r13d, %r14d
    add          %edi, %ebx
    mov          %r10d, %r12d
    addl         (44)(%rsp), %eax
    and          %r9d, %r12d
    rorx         $(25), %r9d, %r13d
    rorx         $(11), %r9d, %edi
    add          %r14d, %ebx
    add          %r12d, %eax
    andn         %r11d, %r9d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r9d, %r14d
    add          %r12d, %eax
    xor          %r14d, %r13d
    mov          %ebx, %edi
    rorx         $(22), %ebx, %r12d
    add          %r13d, %eax
    xor          %ecx, %edi
    rorx         $(13), %ebx, %r14d
    rorx         $(2), %ebx, %r13d
    add          %eax, %r8d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %ecx, %r15d
    xor          %r13d, %r14d
    add          %r15d, %eax
    mov          %r9d, %r12d
    addl         (64)(%rsp), %r11d
    and          %r8d, %r12d
    rorx         $(25), %r8d, %r13d
    rorx         $(11), %r8d, %r15d
    add          %r14d, %eax
    add          %r12d, %r11d
    andn         %r10d, %r8d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r8d, %r14d
    add          %r12d, %r11d
    xor          %r14d, %r13d
    mov          %eax, %r15d
    rorx         $(22), %eax, %r12d
    add          %r13d, %r11d
    xor          %ebx, %r15d
    rorx         $(13), %eax, %r14d
    rorx         $(2), %eax, %r13d
    add          %r11d, %edx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %ebx, %edi
    xor          %r13d, %r14d
    add          %edi, %r11d
    mov          %r8d, %r12d
    addl         (68)(%rsp), %r10d
    and          %edx, %r12d
    rorx         $(25), %edx, %r13d
    rorx         $(11), %edx, %edi
    add          %r14d, %r11d
    add          %r12d, %r10d
    andn         %r9d, %edx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %edx, %r14d
    add          %r12d, %r10d
    xor          %r14d, %r13d
    mov          %r11d, %edi
    rorx         $(22), %r11d, %r12d
    add          %r13d, %r10d
    xor          %eax, %edi
    rorx         $(13), %r11d, %r14d
    rorx         $(2), %r11d, %r13d
    add          %r10d, %ecx
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %eax, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r10d
    mov          %edx, %r12d
    addl         (72)(%rsp), %r9d
    and          %ecx, %r12d
    rorx         $(25), %ecx, %r13d
    rorx         $(11), %ecx, %r15d
    add          %r14d, %r10d
    add          %r12d, %r9d
    andn         %r8d, %ecx, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %ecx, %r14d
    add          %r12d, %r9d
    xor          %r14d, %r13d
    mov          %r10d, %r15d
    rorx         $(22), %r10d, %r12d
    add          %r13d, %r9d
    xor          %r11d, %r15d
    rorx         $(13), %r10d, %r14d
    rorx         $(2), %r10d, %r13d
    add          %r9d, %ebx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r11d, %edi
    xor          %r13d, %r14d
    add          %edi, %r9d
    mov          %ecx, %r12d
    addl         (76)(%rsp), %r8d
    and          %ebx, %r12d
    rorx         $(25), %ebx, %r13d
    rorx         $(11), %ebx, %edi
    add          %r14d, %r9d
    add          %r12d, %r8d
    andn         %edx, %ebx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %ebx, %r14d
    add          %r12d, %r8d
    xor          %r14d, %r13d
    mov          %r9d, %edi
    rorx         $(22), %r9d, %r12d
    add          %r13d, %r8d
    xor          %r10d, %edi
    rorx         $(13), %r9d, %r14d
    rorx         $(2), %r9d, %r13d
    add          %r8d, %eax
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r10d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r8d
    mov          %ebx, %r12d
    addl         (96)(%rsp), %edx
    and          %eax, %r12d
    rorx         $(25), %eax, %r13d
    rorx         $(11), %eax, %r15d
    add          %r14d, %r8d
    add          %r12d, %edx
    andn         %ecx, %eax, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %eax, %r14d
    add          %r12d, %edx
    xor          %r14d, %r13d
    mov          %r8d, %r15d
    rorx         $(22), %r8d, %r12d
    add          %r13d, %edx
    xor          %r9d, %r15d
    rorx         $(13), %r8d, %r14d
    rorx         $(2), %r8d, %r13d
    add          %edx, %r11d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r9d, %edi
    xor          %r13d, %r14d
    add          %edi, %edx
    mov          %eax, %r12d
    addl         (100)(%rsp), %ecx
    and          %r11d, %r12d
    rorx         $(25), %r11d, %r13d
    rorx         $(11), %r11d, %edi
    add          %r14d, %edx
    add          %r12d, %ecx
    andn         %ebx, %r11d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r11d, %r14d
    add          %r12d, %ecx
    xor          %r14d, %r13d
    mov          %edx, %edi
    rorx         $(22), %edx, %r12d
    add          %r13d, %ecx
    xor          %r8d, %edi
    rorx         $(13), %edx, %r14d
    rorx         $(2), %edx, %r13d
    add          %ecx, %r10d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r8d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %ecx
    mov          %r11d, %r12d
    addl         (104)(%rsp), %ebx
    and          %r10d, %r12d
    rorx         $(25), %r10d, %r13d
    rorx         $(11), %r10d, %r15d
    add          %r14d, %ecx
    add          %r12d, %ebx
    andn         %eax, %r10d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r10d, %r14d
    add          %r12d, %ebx
    xor          %r14d, %r13d
    mov          %ecx, %r15d
    rorx         $(22), %ecx, %r12d
    add          %r13d, %ebx
    xor          %edx, %r15d
    rorx         $(13), %ecx, %r14d
    rorx         $(2), %ecx, %r13d
    add          %ebx, %r9d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %edx, %edi
    xor          %r13d, %r14d
    add          %edi, %ebx
    mov          %r10d, %r12d
    addl         (108)(%rsp), %eax
    and          %r9d, %r12d
    rorx         $(25), %r9d, %r13d
    rorx         $(11), %r9d, %edi
    add          %r14d, %ebx
    add          %r12d, %eax
    andn         %r11d, %r9d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r9d, %r14d
    add          %r12d, %eax
    xor          %r14d, %r13d
    mov          %ebx, %edi
    rorx         $(22), %ebx, %r12d
    add          %r13d, %eax
    xor          %ecx, %edi
    rorx         $(13), %ebx, %r14d
    rorx         $(2), %ebx, %r13d
    add          %eax, %r8d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %ecx, %r15d
    xor          %r13d, %r14d
    add          %r15d, %eax
    mov          %r9d, %r12d
    add          %r14d, %eax
    sub          $(384), %rsp
    movq         (-24)(%rsp), %rdi
    movq         (-16)(%rsp), %r14
    addl         (%rdi), %eax
    movl         %eax, (%rdi)
    addl         (4)(%rdi), %ebx
    movl         %ebx, (4)(%rdi)
    addl         (8)(%rdi), %ecx
    movl         %ecx, (8)(%rdi)
    addl         (12)(%rdi), %edx
    movl         %edx, (12)(%rdi)
    addl         (16)(%rdi), %r8d
    movl         %r8d, (16)(%rdi)
    addl         (20)(%rdi), %r9d
    movl         %r9d, (20)(%rdi)
    addl         (24)(%rdi), %r10d
    movl         %r10d, (24)(%rdi)
    addl         (28)(%rdi), %r11d
    movl         %r11d, (28)(%rdi)
    cmp          $(128), %r14
    jl           .Ldonegas_1
    add          $(16), %rsp
    lea          (512)(%rsp), %rbp
    mov          %ebx, %edi
    xor          %r14d, %r14d
    mov          %r9d, %r12d
    xor          %ecx, %edi
.p2align 6, 0x90
.Lblock2_procgas_1: 
    addl         (%rsp), %r11d
    and          %r8d, %r12d
    rorx         $(25), %r8d, %r13d
    rorx         $(11), %r8d, %r15d
    add          %r14d, %eax
    add          %r12d, %r11d
    andn         %r10d, %r8d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r8d, %r14d
    add          %r12d, %r11d
    xor          %r14d, %r13d
    mov          %eax, %r15d
    rorx         $(22), %eax, %r12d
    add          %r13d, %r11d
    xor          %ebx, %r15d
    rorx         $(13), %eax, %r14d
    rorx         $(2), %eax, %r13d
    add          %r11d, %edx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %ebx, %edi
    xor          %r13d, %r14d
    add          %edi, %r11d
    mov          %r8d, %r12d
    addl         (4)(%rsp), %r10d
    and          %edx, %r12d
    rorx         $(25), %edx, %r13d
    rorx         $(11), %edx, %edi
    add          %r14d, %r11d
    add          %r12d, %r10d
    andn         %r9d, %edx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %edx, %r14d
    add          %r12d, %r10d
    xor          %r14d, %r13d
    mov          %r11d, %edi
    rorx         $(22), %r11d, %r12d
    add          %r13d, %r10d
    xor          %eax, %edi
    rorx         $(13), %r11d, %r14d
    rorx         $(2), %r11d, %r13d
    add          %r10d, %ecx
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %eax, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r10d
    mov          %edx, %r12d
    addl         (8)(%rsp), %r9d
    and          %ecx, %r12d
    rorx         $(25), %ecx, %r13d
    rorx         $(11), %ecx, %r15d
    add          %r14d, %r10d
    add          %r12d, %r9d
    andn         %r8d, %ecx, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %ecx, %r14d
    add          %r12d, %r9d
    xor          %r14d, %r13d
    mov          %r10d, %r15d
    rorx         $(22), %r10d, %r12d
    add          %r13d, %r9d
    xor          %r11d, %r15d
    rorx         $(13), %r10d, %r14d
    rorx         $(2), %r10d, %r13d
    add          %r9d, %ebx
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r11d, %edi
    xor          %r13d, %r14d
    add          %edi, %r9d
    mov          %ecx, %r12d
    addl         (12)(%rsp), %r8d
    and          %ebx, %r12d
    rorx         $(25), %ebx, %r13d
    rorx         $(11), %ebx, %edi
    add          %r14d, %r9d
    add          %r12d, %r8d
    andn         %edx, %ebx, %r12d
    xor          %edi, %r13d
    rorx         $(6), %ebx, %r14d
    add          %r12d, %r8d
    xor          %r14d, %r13d
    mov          %r9d, %edi
    rorx         $(22), %r9d, %r12d
    add          %r13d, %r8d
    xor          %r10d, %edi
    rorx         $(13), %r9d, %r14d
    rorx         $(2), %r9d, %r13d
    add          %r8d, %eax
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r10d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %r8d
    mov          %ebx, %r12d
    addl         (32)(%rsp), %edx
    and          %eax, %r12d
    rorx         $(25), %eax, %r13d
    rorx         $(11), %eax, %r15d
    add          %r14d, %r8d
    add          %r12d, %edx
    andn         %ecx, %eax, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %eax, %r14d
    add          %r12d, %edx
    xor          %r14d, %r13d
    mov          %r8d, %r15d
    rorx         $(22), %r8d, %r12d
    add          %r13d, %edx
    xor          %r9d, %r15d
    rorx         $(13), %r8d, %r14d
    rorx         $(2), %r8d, %r13d
    add          %edx, %r11d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %r9d, %edi
    xor          %r13d, %r14d
    add          %edi, %edx
    mov          %eax, %r12d
    addl         (36)(%rsp), %ecx
    and          %r11d, %r12d
    rorx         $(25), %r11d, %r13d
    rorx         $(11), %r11d, %edi
    add          %r14d, %edx
    add          %r12d, %ecx
    andn         %ebx, %r11d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r11d, %r14d
    add          %r12d, %ecx
    xor          %r14d, %r13d
    mov          %edx, %edi
    rorx         $(22), %edx, %r12d
    add          %r13d, %ecx
    xor          %r8d, %edi
    rorx         $(13), %edx, %r14d
    rorx         $(2), %edx, %r13d
    add          %ecx, %r10d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %r8d, %r15d
    xor          %r13d, %r14d
    add          %r15d, %ecx
    mov          %r11d, %r12d
    addl         (40)(%rsp), %ebx
    and          %r10d, %r12d
    rorx         $(25), %r10d, %r13d
    rorx         $(11), %r10d, %r15d
    add          %r14d, %ecx
    add          %r12d, %ebx
    andn         %eax, %r10d, %r12d
    xor          %r15d, %r13d
    rorx         $(6), %r10d, %r14d
    add          %r12d, %ebx
    xor          %r14d, %r13d
    mov          %ecx, %r15d
    rorx         $(22), %ecx, %r12d
    add          %r13d, %ebx
    xor          %edx, %r15d
    rorx         $(13), %ecx, %r14d
    rorx         $(2), %ecx, %r13d
    add          %ebx, %r9d
    and          %r15d, %edi
    xor          %r12d, %r14d
    xor          %edx, %edi
    xor          %r13d, %r14d
    add          %edi, %ebx
    mov          %r10d, %r12d
    addl         (44)(%rsp), %eax
    and          %r9d, %r12d
    rorx         $(25), %r9d, %r13d
    rorx         $(11), %r9d, %edi
    add          %r14d, %ebx
    add          %r12d, %eax
    andn         %r11d, %r9d, %r12d
    xor          %edi, %r13d
    rorx         $(6), %r9d, %r14d
    add          %r12d, %eax
    xor          %r14d, %r13d
    mov          %ebx, %edi
    rorx         $(22), %ebx, %r12d
    add          %r13d, %eax
    xor          %ecx, %edi
    rorx         $(13), %ebx, %r14d
    rorx         $(2), %ebx, %r13d
    add          %eax, %r8d
    and          %edi, %r15d
    xor          %r12d, %r14d
    xor          %ecx, %r15d
    xor          %r13d, %r14d
    add          %r15d, %eax
    mov          %r9d, %r12d
    add          $(64), %rsp
    cmp          %rbp, %rsp
    jb           .Lblock2_procgas_1
    add          %r14d, %eax
    sub          $(528), %rsp
    movq         (-24)(%rsp), %rdi
    movq         (-16)(%rsp), %r14
    addl         (%rdi), %eax
    movl         %eax, (%rdi)
    addl         (4)(%rdi), %ebx
    movl         %ebx, (4)(%rdi)
    addl         (8)(%rdi), %ecx
    movl         %ecx, (8)(%rdi)
    addl         (12)(%rdi), %edx
    movl         %edx, (12)(%rdi)
    addl         (16)(%rdi), %r8d
    movl         %r8d, (16)(%rdi)
    addl         (20)(%rdi), %r9d
    movl         %r9d, (20)(%rdi)
    addl         (24)(%rdi), %r10d
    movl         %r10d, (24)(%rdi)
    addl         (28)(%rdi), %r11d
    movl         %r11d, (28)(%rdi)
    add          $(128), %rsi
    sub          $(128), %r14
    movq         %r14, (-16)(%rsp)
    jg           .Lsha256_block2_loopgas_1
.Ldonegas_1: 
    movq         (-8)(%rsp), %rsp
    add          $(544), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
