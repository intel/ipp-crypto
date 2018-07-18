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
 
bswap128:
.byte  3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12 
 
rol_32_8:
.byte  3,0,1,2, 7,4,5,6, 11,8,9,10, 15,12,13,14 
 
bcast:
.byte  0,1,2,3, 0,1,2,3, 0,1,2,3, 0,1,2,3 
 
wzzz:
.byte  0x80,0x80,0x80,0x80, 0x80,0x80,0x80,0x80, 0x80,0x80,0x80,0x80,12,13,14,15 
.p2align 5, 0x90
 
.globl l9_UpdateSM3
.type l9_UpdateSM3, @function
 
l9_UpdateSM3:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(56), %rsp
 
    movslq       %edx, %rdx
    movdqa       bswap128(%rip), %xmm4
    movdqa       wzzz(%rip), %xmm7
    movdqa       bcast(%rip), %xmm8
    movdqa       rol_32_8(%rip), %xmm9
    movq         %rdi, (32)(%rsp)
    movq         %rdx, (40)(%rsp)
.p2align 5, 0x90
.Lsm3_loopgas_1: 
    vmovdqu      (%rsi), %xmm0
    vpshufb      %xmm4, %xmm0, %xmm0
    vmovdqu      (16)(%rsi), %xmm1
    vpshufb      %xmm4, %xmm1, %xmm1
    vmovdqu      (32)(%rsi), %xmm2
    vpshufb      %xmm4, %xmm2, %xmm2
    vmovdqu      (48)(%rsi), %xmm3
    vpshufb      %xmm4, %xmm3, %xmm3
    add          $(64), %rsi
    mov          (%rdi), %r8d
    mov          (4)(%rdi), %r9d
    mov          (8)(%rdi), %r10d
    mov          (12)(%rdi), %r11d
    mov          (16)(%rdi), %r12d
    mov          (20)(%rdi), %r13d
    mov          (24)(%rdi), %r14d
    mov          (28)(%rdi), %r15d
    vmovdqa      %xmm0, (%rsp)
    vpxor        %xmm1, %xmm0, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm0, %xmm1, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm3, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %ebp
    mov          %r13d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm0, %xmm0
    vpalignr     $(12), %xmm1, %xmm2, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (4)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm0, %xmm5
    vpxor        %xmm0, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %r8d, %ebp
    mov          %r12d, %edx
    xor          %r9d, %ebp
    xor          %r13d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm2, %xmm3, %xmm5
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm5, %xmm0, %xmm0
 
    mov          %r14d, %eax
    mov          (8)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm0, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %ebp
    mov          %r11d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (12)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %ebp
    mov          %r10d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    xor          %r13d, %ebp
    xor          %r9d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm0, %xmm0
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm1, (%rsp)
    vpxor        %xmm2, %xmm1, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm1, %xmm2, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (16)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm0, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %ebp
    mov          %r9d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm1, %xmm1
    vpalignr     $(12), %xmm2, %xmm3, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (20)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm1, %xmm5
    vpxor        %xmm1, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %r12d, %ebp
    mov          %r8d, %edx
    xor          %r13d, %ebp
    xor          %r9d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm3, %xmm0, %xmm5
    vpxor        %xmm4, %xmm1, %xmm1
    vpxor        %xmm5, %xmm1, %xmm1
 
    mov          %r10d, %eax
    mov          (24)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm1, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %ebp
    mov          %r15d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (28)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %ebp
    mov          %r14d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    xor          %r9d, %ebp
    xor          %r13d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm1, %xmm1
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm2, (%rsp)
    vpxor        %xmm3, %xmm2, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm2, %xmm3, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (32)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm1, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %ebp
    mov          %r13d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm2, %xmm2
    vpalignr     $(12), %xmm3, %xmm0, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (36)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm2, %xmm5
    vpxor        %xmm2, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %r8d, %ebp
    mov          %r12d, %edx
    xor          %r9d, %ebp
    xor          %r13d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm0, %xmm1, %xmm5
    vpxor        %xmm4, %xmm2, %xmm2
    vpxor        %xmm5, %xmm2, %xmm2
 
    mov          %r14d, %eax
    mov          (40)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm2, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %ebp
    mov          %r11d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (44)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %ebp
    mov          %r10d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    xor          %r13d, %ebp
    xor          %r9d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm2, %xmm2
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm3, (%rsp)
    vpxor        %xmm0, %xmm3, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm3, %xmm0, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (48)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm2, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %ebp
    mov          %r9d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm3, %xmm3
    vpalignr     $(12), %xmm0, %xmm1, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (52)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm3, %xmm5
    vpxor        %xmm3, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %r12d, %ebp
    mov          %r8d, %edx
    xor          %r13d, %ebp
    xor          %r9d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm1, %xmm2, %xmm5
    vpxor        %xmm4, %xmm3, %xmm3
    vpxor        %xmm5, %xmm3, %xmm3
 
    mov          %r10d, %eax
    mov          (56)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm3, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %ebp
    mov          %r15d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (60)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %ebp
    mov          %r14d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    xor          %r9d, %ebp
    xor          %r13d, %edx
    add          %edx, %ebx
    add          %ebp, %eax
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm3, %xmm3
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm0, (%rsp)
    vpxor        %xmm1, %xmm0, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm0, %xmm1, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (64)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm3, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm0, %xmm0
    vpalignr     $(12), %xmm1, %xmm2, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (68)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm0, %xmm5
    vpxor        %xmm0, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm2, %xmm3, %xmm5
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm5, %xmm0, %xmm0
 
    mov          %r14d, %eax
    mov          (72)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm0, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (76)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm0, %xmm0
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm1, (%rsp)
    vpxor        %xmm2, %xmm1, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm1, %xmm2, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (80)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm0, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm1, %xmm1
    vpalignr     $(12), %xmm2, %xmm3, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (84)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm1, %xmm5
    vpxor        %xmm1, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm3, %xmm0, %xmm5
    vpxor        %xmm4, %xmm1, %xmm1
    vpxor        %xmm5, %xmm1, %xmm1
 
    mov          %r10d, %eax
    mov          (88)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm1, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (92)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm1, %xmm1
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm2, (%rsp)
    vpxor        %xmm3, %xmm2, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm2, %xmm3, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (96)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm1, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm2, %xmm2
    vpalignr     $(12), %xmm3, %xmm0, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (100)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm2, %xmm5
    vpxor        %xmm2, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm0, %xmm1, %xmm5
    vpxor        %xmm4, %xmm2, %xmm2
    vpxor        %xmm5, %xmm2, %xmm2
 
    mov          %r14d, %eax
    mov          (104)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm2, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (108)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm2, %xmm2
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm3, (%rsp)
    vpxor        %xmm0, %xmm3, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm3, %xmm0, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (112)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm2, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm3, %xmm3
    vpalignr     $(12), %xmm0, %xmm1, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (116)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm3, %xmm5
    vpxor        %xmm3, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm1, %xmm2, %xmm5
    vpxor        %xmm4, %xmm3, %xmm3
    vpxor        %xmm5, %xmm3, %xmm3
 
    mov          %r10d, %eax
    mov          (120)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm3, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (124)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm3, %xmm3
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm0, (%rsp)
    vpxor        %xmm1, %xmm0, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm0, %xmm1, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (128)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm3, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm0, %xmm0
    vpalignr     $(12), %xmm1, %xmm2, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (132)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm0, %xmm5
    vpxor        %xmm0, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm2, %xmm3, %xmm5
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm5, %xmm0, %xmm0
 
    mov          %r14d, %eax
    mov          (136)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm0, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (140)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm0, %xmm0
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm1, (%rsp)
    vpxor        %xmm2, %xmm1, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm1, %xmm2, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (144)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm0, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm1, %xmm1
    vpalignr     $(12), %xmm2, %xmm3, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (148)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm1, %xmm5
    vpxor        %xmm1, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm3, %xmm0, %xmm5
    vpxor        %xmm4, %xmm1, %xmm1
    vpxor        %xmm5, %xmm1, %xmm1
 
    mov          %r10d, %eax
    mov          (152)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm1, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (156)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm1, %xmm1
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm2, (%rsp)
    vpxor        %xmm3, %xmm2, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm2, %xmm3, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (160)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm1, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm2, %xmm2
    vpalignr     $(12), %xmm3, %xmm0, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (164)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm2, %xmm5
    vpxor        %xmm2, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm2, %xmm2
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm0, %xmm1, %xmm5
    vpxor        %xmm4, %xmm2, %xmm2
    vpxor        %xmm5, %xmm2, %xmm2
 
    mov          %r14d, %eax
    mov          (168)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm2, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (172)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm2, %xmm2
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm3, (%rsp)
    vpxor        %xmm0, %xmm3, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm3, %xmm0, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r12d, %eax
    mov          (176)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm2, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    vpxor        %xmm5, %xmm3, %xmm3
    vpalignr     $(12), %xmm0, %xmm1, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
 
    mov          %r11d, %eax
    mov          (180)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm3, %xmm5
    vpxor        %xmm3, %xmm5, %xmm5
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm3, %xmm3
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    vpalignr     $(8), %xmm1, %xmm2, %xmm5
    vpxor        %xmm4, %xmm3, %xmm3
    vpxor        %xmm5, %xmm3, %xmm3
 
    mov          %r10d, %eax
    mov          (184)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    vpshufb      %xmm8, %xmm3, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
 
    mov          %r9d, %eax
    mov          (188)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    vpxor        %xmm4, %xmm3, %xmm3
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm0, (%rsp)
    vpxor        %xmm1, %xmm0, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    vpalignr     $(12), %xmm0, %xmm1, %xmm4
    vpslld       $(7), %xmm4, %xmm6
    vpsrld       $(25), %xmm4, %xmm4
    vpxor        %xmm6, %xmm4, %xmm4
 
    mov          %r8d, %eax
    mov          (192)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    vpsrldq      $(4), %xmm3, %xmm5
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    vpxor        %xmm5, %xmm0, %xmm0
    vpalignr     $(12), %xmm1, %xmm2, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
 
    mov          %r15d, %eax
    mov          (196)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpshufb      %xmm9, %xmm0, %xmm5
    vpxor        %xmm0, %xmm5, %xmm5
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    vpslld       $(15), %xmm5, %xmm6
    vpsrld       $(17), %xmm5, %xmm5
    vpxor        %xmm6, %xmm5, %xmm5
    vpxor        %xmm5, %xmm0, %xmm0
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    vpalignr     $(8), %xmm2, %xmm3, %xmm5
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm5, %xmm0, %xmm0
 
    mov          %r14d, %eax
    mov          (200)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    vpshufb      %xmm8, %xmm0, %xmm4
    vpsrlq       $(17), %xmm4, %xmm4
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    vpshufb      %xmm8, %xmm4, %xmm4
    vpsllq       $(15), %xmm4, %xmm5
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
 
    mov          %r13d, %eax
    mov          (204)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(8), %xmm5, %xmm5
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    vpxor        %xmm5, %xmm4, %xmm4
    vpshufb      %xmm7, %xmm4, %xmm4
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    vpxor        %xmm4, %xmm0, %xmm0
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm1, (%rsp)
    vpxor        %xmm2, %xmm1, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    mov          %r12d, %eax
    mov          (208)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
    mov          %r11d, %eax
    mov          (212)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    mov          %r10d, %eax
    mov          (216)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
    mov          %r9d, %eax
    mov          (220)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    vmovdqa      %xmm2, (%rsp)
    vpxor        %xmm3, %xmm2, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    mov          %r8d, %eax
    mov          (224)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r15d, %ebx
    add          %r11d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    mov          %r9d, %edx
    mov          %r9d, %ebp
    and          %r10d, %edx
    xor          %r10d, %ebp
    and          %r8d, %ebp
    add          %edx, %ebp
    mov          %r13d, %edx
    xor          %r14d, %edx
    and          %r12d, %edx
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
    mov          %r15d, %eax
    mov          (228)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r14d, %ebx
    add          %r10d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    mov          %r8d, %edx
    mov          %r8d, %ebp
    and          %r9d, %edx
    xor          %r9d, %ebp
    and          %r15d, %ebp
    add          %edx, %ebp
    mov          %r12d, %edx
    xor          %r13d, %edx
    and          %r11d, %edx
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    mov          %r14d, %eax
    mov          (232)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r13d, %ebx
    add          %r9d, %eax
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r15d, %edx
    mov          %r15d, %ebp
    and          %r8d, %edx
    xor          %r8d, %ebp
    and          %r14d, %ebp
    add          %edx, %ebp
    mov          %r11d, %edx
    xor          %r12d, %edx
    and          %r10d, %edx
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
    mov          %r13d, %eax
    mov          (236)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r12d, %ebx
    add          %r8d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r14d, %edx
    mov          %r14d, %ebp
    and          %r15d, %edx
    xor          %r15d, %ebp
    and          %r13d, %ebp
    add          %edx, %ebp
    mov          %r10d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    vmovdqa      %xmm3, (%rsp)
    vpxor        %xmm0, %xmm3, %xmm4
    vmovdqa      %xmm4, (16)(%rsp)
    mov          %r12d, %eax
    mov          (240)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r11d, %ebx
    add          %r15d, %eax
    add          (%rsp), %ebx
    add          (16)(%rsp), %eax
    mov          %r13d, %edx
    mov          %r13d, %ebp
    and          %r14d, %edx
    xor          %r14d, %ebp
    and          %r12d, %ebp
    add          %edx, %ebp
    mov          %r9d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
    mov          %r11d, %eax
    mov          (244)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r10d, %ebx
    add          %r14d, %eax
    add          (4)(%rsp), %ebx
    add          (20)(%rsp), %eax
    mov          %r12d, %edx
    mov          %r12d, %ebp
    and          %r13d, %edx
    xor          %r13d, %ebp
    and          %r11d, %ebp
    add          %edx, %ebp
    mov          %r8d, %edx
    xor          %r9d, %edx
    and          %r15d, %edx
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    mov          %r10d, %eax
    mov          (248)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r9d, %ebx
    add          %r13d, %eax
    add          (8)(%rsp), %ebx
    add          (24)(%rsp), %eax
    mov          %r11d, %edx
    mov          %r11d, %ebp
    and          %r12d, %edx
    xor          %r12d, %ebp
    and          %r10d, %ebp
    add          %edx, %ebp
    mov          %r15d, %edx
    xor          %r8d, %edx
    and          %r14d, %edx
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
    mov          %r9d, %eax
    mov          (252)(%rcx), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    add          %r8d, %ebx
    add          %r12d, %eax
    add          (12)(%rsp), %ebx
    add          (28)(%rsp), %eax
    mov          %r10d, %edx
    mov          %r10d, %ebp
    and          %r11d, %edx
    xor          %r11d, %ebp
    and          %r9d, %ebp
    add          %edx, %ebp
    mov          %r14d, %edx
    xor          %r15d, %edx
    and          %r13d, %edx
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    movq         (32)(%rsp), %rdi
    xor          %r8d, (%rdi)
    xor          %r9d, (4)(%rdi)
    xor          %r10d, (8)(%rdi)
    xor          %r11d, (12)(%rdi)
    xor          %r12d, (16)(%rdi)
    xor          %r13d, (20)(%rdi)
    xor          %r14d, (24)(%rdi)
    xor          %r15d, (28)(%rdi)
    movdqa       bswap128(%rip), %xmm4
    subq         $(64), (40)(%rsp)
    cmpq         $(64), (40)(%rsp)
    jge          .Lsm3_loopgas_1
    add          $(56), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
.Lfe1:
.size l9_UpdateSM3, .Lfe1-(l9_UpdateSM3)
 
