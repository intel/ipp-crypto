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
 
K_XMM_AR:
.long  1518500249, 1518500249, 1518500249, 1518500249 
 

.long  1859775393, 1859775393, 1859775393, 1859775393 
 

.long  2400959708, 2400959708, 2400959708, 2400959708 
 

.long  3395469782, 3395469782, 3395469782, 3395469782 
 
shuffle_mask:
.long     0x10203 
 

.long   0x4050607 
 

.long   0x8090a0b 
 

.long   0xc0d0e0f 
.p2align 5, 0x90
 
.globl _UpdateSHA1

 
_UpdateSHA1:
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    sub          $(64), %rsp
 
    movslq       %edx, %r14
    movdqa       shuffle_mask(%rip), %xmm10
    lea          K_XMM_AR(%rip), %r12
.Lsha1_block_loopgas_1: 
    movl         (%rdi), %ecx
    movl         (4)(%rdi), %eax
    movl         (8)(%rdi), %edx
    movl         (12)(%rdi), %r8d
    movl         (16)(%rdi), %r9d
    movdqu       (%rsi), %xmm9
    movdqu       (16)(%rsi), %xmm8
    movdqu       (32)(%rsi), %xmm7
    movdqu       (48)(%rsi), %xmm6
    vpshufb      %xmm10, %xmm9, %xmm2
    vpaddd       (%r12), %xmm2, %xmm9
    vmovdqa      %xmm9, (%rsp)
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    and          %eax, %r10d
    shld         $(5), %r11d, %r11d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    shld         $(30), %eax, %eax
    addl         (%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    shld         $(5), %r11d, %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    shld         $(30), %ecx, %ecx
    addl         (4)(%rsp), %r10d
    add          %r10d, %r8d
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    shld         $(5), %r11d, %r11d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r11d, %edx
    shld         $(30), %r9d, %r9d
    addl         (8)(%rsp), %r10d
    add          %r10d, %edx
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    shld         $(5), %r11d, %r11d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    add          %r11d, %eax
    shld         $(30), %r8d, %r8d
    addl         (12)(%rsp), %r10d
    add          %r10d, %eax
    vpshufb      %xmm10, %xmm8, %xmm9
    vpaddd       (%r12), %xmm9, %xmm8
    vmovdqa      %xmm8, (16)(%rsp)
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    and          %edx, %r10d
    shld         $(5), %r11d, %r11d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    shld         $(30), %edx, %edx
    addl         (16)(%rsp), %r10d
    add          %r10d, %ecx
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    shld         $(5), %r11d, %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    shld         $(30), %eax, %eax
    addl         (20)(%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    shld         $(5), %r11d, %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    shld         $(30), %ecx, %ecx
    addl         (24)(%rsp), %r10d
    add          %r10d, %r8d
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    shld         $(5), %r11d, %r11d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r11d, %edx
    shld         $(30), %r9d, %r9d
    addl         (28)(%rsp), %r10d
    add          %r10d, %edx
    vpshufb      %xmm10, %xmm7, %xmm8
    vpaddd       (%r12), %xmm8, %xmm7
    vmovdqa      %xmm7, (32)(%rsp)
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    and          %r8d, %r10d
    shld         $(5), %r11d, %r11d
    xor          %ecx, %r10d
    add          %r11d, %eax
    shld         $(30), %r8d, %r8d
    addl         (32)(%rsp), %r10d
    add          %r10d, %eax
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    shld         $(5), %r11d, %r11d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    shld         $(30), %edx, %edx
    addl         (36)(%rsp), %r10d
    add          %r10d, %ecx
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    shld         $(5), %r11d, %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    shld         $(30), %eax, %eax
    addl         (40)(%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    shld         $(5), %r11d, %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    shld         $(30), %ecx, %ecx
    addl         (44)(%rsp), %r10d
    add          %r10d, %r8d
    vpshufb      %xmm10, %xmm6, %xmm7
    vpaddd       (%r12), %xmm7, %xmm6
    vmovdqa      %xmm6, (48)(%rsp)
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    and          %r9d, %r10d
    shld         $(5), %r11d, %r11d
    xor          %eax, %r10d
    add          %r11d, %edx
    shld         $(30), %r9d, %r9d
    addl         (48)(%rsp), %r10d
    add          %r10d, %edx
 
    vpalignr     $(8), %xmm2, %xmm9, %xmm6
    vpsrldq      $(4), %xmm7, %xmm0
    vpxor        %xmm8, %xmm6, %xmm6
 
    vpxor        %xmm2, %xmm0, %xmm0
    vpxor        %xmm0, %xmm6, %xmm6
    vpslldq      $(12), %xmm6, %xmm1
 
    vpslld       $(1), %xmm6, %xmm0
    vpsrld       $(31), %xmm6, %xmm6
    vpor         %xmm6, %xmm0, %xmm0
    vpslld       $(2), %xmm1, %xmm6
    vpsrld       $(30), %xmm1, %xmm1
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    shld         $(5), %r11d, %r11d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    add          %r11d, %eax
    shld         $(30), %r8d, %r8d
    addl         (52)(%rsp), %r10d
    add          %r10d, %eax
 
    vpxor        %xmm6, %xmm0, %xmm0
    vpxor        %xmm1, %xmm0, %xmm6
    vpaddd       (%r12), %xmm6, %xmm0
    vmovdqa      %xmm0, (%rsp)
 
    vpalignr     $(8), %xmm9, %xmm8, %xmm5
    vpsrldq      $(4), %xmm6, %xmm0
    vpxor        %xmm7, %xmm5, %xmm5
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    shld         $(5), %r11d, %r11d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    shld         $(30), %edx, %edx
    addl         (56)(%rsp), %r10d
    add          %r10d, %ecx
 
    vpxor        %xmm9, %xmm0, %xmm0
    vpxor        %xmm0, %xmm5, %xmm5
    vpslldq      $(12), %xmm5, %xmm1
 
    vpslld       $(1), %xmm5, %xmm0
    vpsrld       $(31), %xmm5, %xmm5
    vpor         %xmm5, %xmm0, %xmm0
    vpslld       $(2), %xmm1, %xmm5
    vpsrld       $(30), %xmm1, %xmm1
 
    vpxor        %xmm5, %xmm0, %xmm0
    vpxor        %xmm1, %xmm0, %xmm5
    vpaddd       (16)(%r12), %xmm5, %xmm0
    vmovdqa      %xmm0, (16)(%rsp)
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    shld         $(5), %r11d, %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    shld         $(30), %eax, %eax
    addl         (60)(%rsp), %r10d
    add          %r10d, %r9d
 
    vpalignr     $(8), %xmm8, %xmm7, %xmm4
    vpsrldq      $(4), %xmm5, %xmm0
    vpxor        %xmm6, %xmm4, %xmm4
    addl         (%rsp), %r8d
    mov          %eax, %r10d
    xor          %edx, %r10d
    and          %ecx, %r10d
    xor          %edx, %r10d
    addl         (4)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpxor        %xmm8, %xmm0, %xmm0
    vpxor        %xmm0, %xmm4, %xmm4
    vpslldq      $(12), %xmm4, %xmm1
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    xor          %eax, %r10d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpslld       $(1), %xmm4, %xmm0
    vpsrld       $(31), %xmm4, %xmm4
    vpor         %xmm4, %xmm0, %xmm0
    vpslld       $(2), %xmm1, %xmm4
    vpsrld       $(30), %xmm1, %xmm1
    addl         (8)(%rsp), %eax
    mov          %r9d, %r10d
    xor          %ecx, %r10d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    addl         (12)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm1, %xmm0, %xmm4
    vpaddd       (16)(%r12), %xmm4, %xmm0
    vmovdqa      %xmm0, (32)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    xor          %r9d, %r10d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpalignr     $(8), %xmm7, %xmm6, %xmm3
    vpsrldq      $(4), %xmm4, %xmm0
    vpxor        %xmm5, %xmm3, %xmm3
    addl         (16)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (20)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpxor        %xmm7, %xmm0, %xmm0
    vpxor        %xmm0, %xmm3, %xmm3
    vpslldq      $(12), %xmm3, %xmm1
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    vpslld       $(1), %xmm3, %xmm0
    vpsrld       $(31), %xmm3, %xmm3
    vpor         %xmm3, %xmm0, %xmm0
    vpslld       $(2), %xmm1, %xmm3
    vpsrld       $(30), %xmm1, %xmm1
    addl         (24)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (28)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    vpxor        %xmm3, %xmm0, %xmm0
    vpxor        %xmm1, %xmm0, %xmm3
    vpaddd       (16)(%r12), %xmm3, %xmm0
    vmovdqa      %xmm0, (48)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    vpalignr     $(8), %xmm4, %xmm3, %xmm0
    vpxor        %xmm9, %xmm2, %xmm2
    addl         (32)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (36)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    vpxor        %xmm6, %xmm0, %xmm0
    vpxor        %xmm0, %xmm2, %xmm2
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    vpslld       $(2), %xmm2, %xmm0
    vpsrld       $(30), %xmm2, %xmm2
    vpor         %xmm2, %xmm0, %xmm2
    addl         (40)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (44)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpaddd       (16)(%r12), %xmm2, %xmm0
    vmovdqa      %xmm0, (%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpalignr     $(8), %xmm3, %xmm2, %xmm0
    vpxor        %xmm8, %xmm9, %xmm9
    addl         (48)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (52)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpxor        %xmm5, %xmm0, %xmm0
    vpxor        %xmm0, %xmm9, %xmm9
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpslld       $(2), %xmm9, %xmm0
    vpsrld       $(30), %xmm9, %xmm9
    vpor         %xmm9, %xmm0, %xmm9
    addl         (56)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (60)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpaddd       (16)(%r12), %xmm9, %xmm0
    vmovdqa      %xmm0, (16)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    vpalignr     $(8), %xmm2, %xmm9, %xmm0
    vpxor        %xmm7, %xmm8, %xmm8
    addl         (%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (4)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm0, %xmm8, %xmm8
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    vpslld       $(2), %xmm8, %xmm0
    vpsrld       $(30), %xmm8, %xmm8
    vpor         %xmm8, %xmm0, %xmm8
    addl         (8)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (12)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    vpaddd       (32)(%r12), %xmm8, %xmm0
    vmovdqa      %xmm0, (32)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    vpalignr     $(8), %xmm9, %xmm8, %xmm0
    vpxor        %xmm6, %xmm7, %xmm7
    addl         (16)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (20)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpxor        %xmm3, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpslld       $(2), %xmm7, %xmm0
    vpsrld       $(30), %xmm7, %xmm7
    vpor         %xmm7, %xmm0, %xmm7
    addl         (24)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (28)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpaddd       (32)(%r12), %xmm7, %xmm0
    vmovdqa      %xmm0, (48)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpalignr     $(8), %xmm8, %xmm7, %xmm0
    vpxor        %xmm5, %xmm6, %xmm6
    addl         (32)(%rsp), %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    addl         (36)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpxor        %xmm2, %xmm0, %xmm0
    vpxor        %xmm0, %xmm6, %xmm6
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    vpslld       $(2), %xmm6, %xmm0
    vpsrld       $(30), %xmm6, %xmm6
    vpor         %xmm6, %xmm0, %xmm6
    addl         (40)(%rsp), %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    addl         (44)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    vpaddd       (32)(%r12), %xmm6, %xmm0
    vmovdqa      %xmm0, (%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    vpalignr     $(8), %xmm7, %xmm6, %xmm0
    vpxor        %xmm4, %xmm5, %xmm5
    addl         (48)(%rsp), %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    addl         (52)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    vpxor        %xmm9, %xmm0, %xmm0
    vpxor        %xmm0, %xmm5, %xmm5
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    vpslld       $(2), %xmm5, %xmm0
    vpsrld       $(30), %xmm5, %xmm5
    vpor         %xmm5, %xmm0, %xmm5
    addl         (56)(%rsp), %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    addl         (60)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpaddd       (32)(%r12), %xmm5, %xmm0
    vmovdqa      %xmm0, (16)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpalignr     $(8), %xmm6, %xmm5, %xmm0
    vpxor        %xmm3, %xmm4, %xmm4
    addl         (%rsp), %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    addl         (4)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpxor        %xmm8, %xmm0, %xmm0
    vpxor        %xmm0, %xmm4, %xmm4
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpslld       $(2), %xmm4, %xmm0
    vpsrld       $(30), %xmm4, %xmm4
    vpor         %xmm4, %xmm0, %xmm4
    addl         (8)(%rsp), %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    addl         (12)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpaddd       (32)(%r12), %xmm4, %xmm0
    vmovdqa      %xmm0, (32)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    vpalignr     $(8), %xmm5, %xmm4, %xmm0
    vpxor        %xmm2, %xmm3, %xmm3
    addl         (16)(%rsp), %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    addl         (20)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    vpxor        %xmm7, %xmm0, %xmm0
    vpxor        %xmm0, %xmm3, %xmm3
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    vpslld       $(2), %xmm3, %xmm0
    vpsrld       $(30), %xmm3, %xmm3
    vpor         %xmm3, %xmm0, %xmm3
    addl         (24)(%rsp), %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    addl         (28)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    vpaddd       (48)(%r12), %xmm3, %xmm0
    vmovdqa      %xmm0, (48)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    vpalignr     $(8), %xmm4, %xmm3, %xmm0
    vpxor        %xmm9, %xmm2, %xmm2
    addl         (32)(%rsp), %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    addl         (36)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpxor        %xmm6, %xmm0, %xmm0
    vpxor        %xmm0, %xmm2, %xmm2
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpslld       $(2), %xmm2, %xmm0
    vpsrld       $(30), %xmm2, %xmm2
    vpor         %xmm2, %xmm0, %xmm2
    addl         (40)(%rsp), %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    addl         (44)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpaddd       (48)(%r12), %xmm2, %xmm0
    vmovdqa      %xmm0, (%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpalignr     $(8), %xmm3, %xmm2, %xmm0
    vpxor        %xmm8, %xmm9, %xmm9
    addl         (48)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (52)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpxor        %xmm5, %xmm0, %xmm0
    vpxor        %xmm0, %xmm9, %xmm9
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    vpslld       $(2), %xmm9, %xmm0
    vpsrld       $(30), %xmm9, %xmm9
    vpor         %xmm9, %xmm0, %xmm9
    addl         (56)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (60)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    vpaddd       (48)(%r12), %xmm9, %xmm0
    vmovdqa      %xmm0, (16)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    vpalignr     $(8), %xmm2, %xmm9, %xmm0
    vpxor        %xmm7, %xmm8, %xmm8
    addl         (%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (4)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    vpxor        %xmm4, %xmm0, %xmm0
    vpxor        %xmm0, %xmm8, %xmm8
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    vpslld       $(2), %xmm8, %xmm0
    vpsrld       $(30), %xmm8, %xmm8
    vpor         %xmm8, %xmm0, %xmm8
    addl         (8)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (12)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    vpaddd       (48)(%r12), %xmm8, %xmm0
    vmovdqa      %xmm0, (32)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    vpalignr     $(8), %xmm9, %xmm8, %xmm0
    vpxor        %xmm6, %xmm7, %xmm7
    addl         (16)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (20)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    vpxor        %xmm3, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
 
    vpslld       $(2), %xmm7, %xmm0
    vpsrld       $(30), %xmm7, %xmm7
    vpor         %xmm7, %xmm0, %xmm7
    addl         (24)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (28)(%rsp), %r8d
    shld         $(30), %eax, %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    shld         $(5), %r13d, %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    vpaddd       (48)(%r12), %xmm7, %xmm0
    vmovdqa      %xmm0, (48)(%rsp)
    shld         $(5), %r13d, %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    shld         $(30), %ecx, %ecx
 
    addl         (32)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (36)(%rsp), %eax
    shld         $(30), %r9d, %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    shld         $(5), %r13d, %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    shld         $(5), %r13d, %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    shld         $(30), %r8d, %r8d
 
    addl         (40)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (44)(%rsp), %r9d
    shld         $(30), %edx, %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    shld         $(5), %r13d, %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    shld         $(5), %r13d, %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    shld         $(30), %eax, %eax
 
    addl         (48)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (52)(%rsp), %edx
    shld         $(30), %ecx, %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    shld         $(5), %r13d, %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    shld         $(5), %r13d, %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    shld         $(30), %r9d, %r9d
 
    addl         (56)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (60)(%rsp), %ecx
    shld         $(30), %r8d, %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    shld         $(5), %r13d, %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    shld         $(5), %r13d, %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    shld         $(30), %edx, %edx
    addl         (%rdi), %ecx
    movl         %ecx, (%rdi)
    addl         (4)(%rdi), %eax
    movl         %eax, (4)(%rdi)
    addl         (8)(%rdi), %edx
    movl         %edx, (8)(%rdi)
    addl         (12)(%rdi), %r8d
    movl         %r8d, (12)(%rdi)
    addl         (16)(%rdi), %r9d
    movl         %r9d, (16)(%rdi)
    add          $(64), %rsi
    sub          $(64), %r14
    jg           .Lsha1_block_loopgas_1
    add          $(64), %rsp
vzeroupper 
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
