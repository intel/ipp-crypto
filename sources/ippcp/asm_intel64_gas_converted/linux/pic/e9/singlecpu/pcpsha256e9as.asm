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
.byte  3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12 
 
SHUFD_ZZ10:
.byte  0,1,2,3, 8,9,10,11,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff 
 
SHUFD_32ZZ:
.byte   0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0,1,2,3, 8,9,10,11 
.p2align 5, 0x90
 
.globl UpdateSHA256
.type UpdateSHA256, @function
 
UpdateSHA256:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(40), %rsp
 
    movslq       %edx, %rdx
    movq         %rdx, (16)(%rsp)
    mov          %rcx, %rbp
.p2align 5, 0x90
.Lsha256_block_loopgas_1: 
    vmovdqu      (%rsi), %xmm0
    vpshufb      SHUFB_BSWAP(%rip), %xmm0, %xmm0
    vmovdqu      (16)(%rsi), %xmm1
    vpshufb      SHUFB_BSWAP(%rip), %xmm1, %xmm1
    vmovdqu      (32)(%rsi), %xmm2
    vpshufb      SHUFB_BSWAP(%rip), %xmm2, %xmm2
    vmovdqu      (48)(%rsi), %xmm3
    vpshufb      SHUFB_BSWAP(%rip), %xmm3, %xmm3
    movl         (%rdi), %eax
    movl         (4)(%rdi), %ebx
    movl         (8)(%rdi), %ecx
    movl         (12)(%rdi), %edx
    movl         (16)(%rdi), %r8d
    movl         (20)(%rdi), %r9d
    movl         (24)(%rdi), %r10d
    movl         (28)(%rdi), %r11d
    vpaddd       (%rbp), %xmm0, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpaddd       %xmm7, %xmm0, %xmm0
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (16)(%rbp), %xmm1, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpaddd       %xmm7, %xmm1, %xmm1
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (32)(%rbp), %xmm2, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpaddd       %xmm7, %xmm2, %xmm2
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (48)(%rbp), %xmm3, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpaddd       %xmm7, %xmm3, %xmm3
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (64)(%rbp), %xmm0, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpaddd       %xmm7, %xmm0, %xmm0
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (80)(%rbp), %xmm1, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpaddd       %xmm7, %xmm1, %xmm1
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (96)(%rbp), %xmm2, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpaddd       %xmm7, %xmm2, %xmm2
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (112)(%rbp), %xmm3, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpaddd       %xmm7, %xmm3, %xmm3
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (128)(%rbp), %xmm0, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpaddd       %xmm7, %xmm0, %xmm0
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm0, %xmm0
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (144)(%rbp), %xmm1, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpaddd       %xmm7, %xmm1, %xmm1
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm0, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm1, %xmm1
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (160)(%rbp), %xmm2, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm2, %xmm3, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    vpalignr     $(4), %xmm0, %xmm1, %xmm7
    vpaddd       %xmm7, %xmm2, %xmm2
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    vpshufd      $(250), %xmm1, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    vpshufd      $(80), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm2, %xmm2
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (176)(%rbp), %xmm3, %xmm7
    vmovdqa      %xmm7, (%rsp)
    vpalignr     $(4), %xmm3, %xmm0, %xmm7
    vpsrld       $(3), %xmm7, %xmm4
    vpsrld       $(7), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrld       $(18), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(14), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpslld       $(25), %xmm7, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    vpalignr     $(4), %xmm1, %xmm2, %xmm7
    vpaddd       %xmm7, %xmm3, %xmm3
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    vpshufd      $(250), %xmm2, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_ZZ10(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    vpshufd      $(80), %xmm3, %xmm7
    vpsrld       $(10), %xmm7, %xmm4
    vpsrlq       $(17), %xmm7, %xmm6
    vpsrlq       $(19), %xmm7, %xmm7
    vpxor        %xmm6, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vpshufb      SHUFD_32ZZ(%rip), %xmm4, %xmm4
    vpaddd       %xmm4, %xmm3, %xmm3
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (192)(%rbp), %xmm0, %xmm7
    vmovdqa      %xmm7, (%rsp)
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (208)(%rbp), %xmm1, %xmm7
    vmovdqa      %xmm7, (%rsp)
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    vpaddd       (224)(%rbp), %xmm2, %xmm7
    vmovdqa      %xmm7, (%rsp)
    addl         (%rsp), %r11d
    mov          %r8d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r10d, %r13d
    and          %r8d, %r13d
    xor          %r10d, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    add          %r11d, %edx
    mov          %eax, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ecx, %r13d
    xor          %ecx, %ebx
    and          %ebx, %r13d
    xor          %ecx, %ebx
    xor          %ecx, %r13d
    add          %r12d, %r11d
    add          %r13d, %r11d
    addl         (4)(%rsp), %r10d
    mov          %edx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r9d, %r13d
    and          %edx, %r13d
    xor          %r9d, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    add          %r10d, %ecx
    mov          %r11d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %ebx, %r13d
    xor          %ebx, %eax
    and          %eax, %r13d
    xor          %ebx, %eax
    xor          %ebx, %r13d
    add          %r12d, %r10d
    add          %r13d, %r10d
    addl         (8)(%rsp), %r9d
    mov          %ecx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r8d, %r13d
    and          %ecx, %r13d
    xor          %r8d, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    add          %r9d, %ebx
    mov          %r10d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %eax, %r13d
    xor          %eax, %r11d
    and          %r11d, %r13d
    xor          %eax, %r11d
    xor          %eax, %r13d
    add          %r12d, %r9d
    add          %r13d, %r9d
    addl         (12)(%rsp), %r8d
    mov          %ebx, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %edx, %r13d
    and          %ebx, %r13d
    xor          %edx, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    add          %r8d, %eax
    mov          %r9d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r9d, %r13d
    xor          %r11d, %r13d
    xor          %r11d, %r10d
    and          %r10d, %r13d
    xor          %r11d, %r10d
    xor          %r11d, %r13d
    add          %r12d, %r8d
    add          %r13d, %r8d
    vpaddd       (240)(%rbp), %xmm3, %xmm7
    vmovdqa      %xmm7, (%rsp)
    addl         (%rsp), %edx
    mov          %eax, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %eax, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %ecx, %r13d
    and          %eax, %r13d
    xor          %ecx, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    add          %edx, %r11d
    mov          %r8d, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %r8d, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %r8d, %r13d
    xor          %r10d, %r13d
    xor          %r10d, %r9d
    and          %r9d, %r13d
    xor          %r10d, %r9d
    xor          %r10d, %r13d
    add          %r12d, %edx
    add          %r13d, %edx
    addl         (4)(%rsp), %ecx
    mov          %r11d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r11d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %eax, %r13d
    xor          %ebx, %r13d
    and          %r11d, %r13d
    xor          %ebx, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    add          %ecx, %r10d
    mov          %edx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %edx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %edx, %r13d
    xor          %r9d, %r13d
    xor          %r9d, %r8d
    and          %r8d, %r13d
    xor          %r9d, %r8d
    xor          %r9d, %r13d
    add          %r12d, %ecx
    add          %r13d, %ecx
    addl         (8)(%rsp), %ebx
    mov          %r10d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r10d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r11d, %r13d
    xor          %eax, %r13d
    and          %r10d, %r13d
    xor          %eax, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    add          %ebx, %r9d
    mov          %ecx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ecx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ecx, %r13d
    xor          %r8d, %r13d
    xor          %r8d, %edx
    and          %edx, %r13d
    xor          %r8d, %edx
    xor          %r8d, %r13d
    add          %r12d, %ebx
    add          %r13d, %ebx
    addl         (12)(%rsp), %eax
    mov          %r9d, %r12d
    shrd         $(14), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(5), %r12d, %r12d
    xor          %r9d, %r12d
    shrd         $(6), %r12d, %r12d
    mov          %r10d, %r13d
    xor          %r11d, %r13d
    and          %r9d, %r13d
    xor          %r11d, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    add          %eax, %r8d
    mov          %ebx, %r12d
    shrd         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(11), %r12d, %r12d
    xor          %ebx, %r12d
    shrd         $(2), %r12d, %r12d
    mov          %ebx, %r13d
    xor          %edx, %r13d
    xor          %edx, %ecx
    and          %ecx, %r13d
    xor          %edx, %ecx
    xor          %edx, %r13d
    add          %r12d, %eax
    add          %r13d, %eax
    addl         %eax, (%rdi)
    addl         %ebx, (4)(%rdi)
    addl         %ecx, (8)(%rdi)
    addl         %edx, (12)(%rdi)
    addl         %r8d, (16)(%rdi)
    addl         %r9d, (20)(%rdi)
    addl         %r10d, (24)(%rdi)
    addl         %r11d, (28)(%rdi)
    add          $(64), %rsi
    subq         $(64), (16)(%rsp)
    jg           .Lsha256_block_loopgas_1
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
.size UpdateSHA256, .Lfe1-(UpdateSHA256)
 
