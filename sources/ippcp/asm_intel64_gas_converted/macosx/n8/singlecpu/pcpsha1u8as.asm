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
.p2align 4, 0x90
 
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
.p2align 4, 0x90
 
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
    pshufb       %xmm10, %xmm9
    movdqa       %xmm9, %xmm2
    paddd        (%r12), %xmm9
    movdqa       %xmm9, (%rsp)
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    and          %eax, %r10d
    rol          $(5), %r11d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    rol          $(30), %eax
    addl         (%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    rol          $(5), %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    rol          $(30), %ecx
    addl         (4)(%rsp), %r10d
    add          %r10d, %r8d
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    rol          $(5), %r11d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r11d, %edx
    rol          $(30), %r9d
    addl         (8)(%rsp), %r10d
    add          %r10d, %edx
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    rol          $(5), %r11d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    add          %r11d, %eax
    rol          $(30), %r8d
    addl         (12)(%rsp), %r10d
    add          %r10d, %eax
    pshufb       %xmm10, %xmm8
    movdqa       %xmm8, %xmm9
    paddd        (%r12), %xmm8
    movdqa       %xmm8, (16)(%rsp)
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    and          %edx, %r10d
    rol          $(5), %r11d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    rol          $(30), %edx
    addl         (16)(%rsp), %r10d
    add          %r10d, %ecx
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    rol          $(5), %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    rol          $(30), %eax
    addl         (20)(%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    rol          $(5), %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    rol          $(30), %ecx
    addl         (24)(%rsp), %r10d
    add          %r10d, %r8d
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    rol          $(5), %r11d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r11d, %edx
    rol          $(30), %r9d
    addl         (28)(%rsp), %r10d
    add          %r10d, %edx
    pshufb       %xmm10, %xmm7
    movdqa       %xmm7, %xmm8
    paddd        (%r12), %xmm7
    movdqa       %xmm7, (32)(%rsp)
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    and          %r8d, %r10d
    rol          $(5), %r11d
    xor          %ecx, %r10d
    add          %r11d, %eax
    rol          $(30), %r8d
    addl         (32)(%rsp), %r10d
    add          %r10d, %eax
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    rol          $(5), %r11d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    rol          $(30), %edx
    addl         (36)(%rsp), %r10d
    add          %r10d, %ecx
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    rol          $(5), %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    rol          $(30), %eax
    addl         (40)(%rsp), %r10d
    add          %r10d, %r9d
    mov          %eax, %r10d
    mov          %r9d, %r11d
    xor          %edx, %r10d
    rol          $(5), %r11d
    and          %ecx, %r10d
    xor          %edx, %r10d
    add          %r11d, %r8d
    rol          $(30), %ecx
    addl         (44)(%rsp), %r10d
    add          %r10d, %r8d
    pshufb       %xmm10, %xmm6
    movdqa       %xmm6, %xmm7
    paddd        (%r12), %xmm6
    movdqa       %xmm6, (48)(%rsp)
    mov          %ecx, %r10d
    mov          %r8d, %r11d
    xor          %eax, %r10d
    and          %r9d, %r10d
    rol          $(5), %r11d
    xor          %eax, %r10d
    add          %r11d, %edx
    rol          $(30), %r9d
    addl         (48)(%rsp), %r10d
    add          %r10d, %edx
 
    movdqa       %xmm9, %xmm6
    palignr      $(8), %xmm2, %xmm6
    movdqa       %xmm7, %xmm0
    psrldq       $(4), %xmm0
    pxor         %xmm8, %xmm6
 
    pxor         %xmm2, %xmm0
    pxor         %xmm0, %xmm6
    movdqa       %xmm6, %xmm1
    movdqa       %xmm6, %xmm0
    pslldq       $(12), %xmm1
 
    psrld        $(31), %xmm6
    pslld        $(1), %xmm0
    por          %xmm6, %xmm0
    movdqa       %xmm1, %xmm6
    psrld        $(30), %xmm1
    pslld        $(2), %xmm6
    mov          %r9d, %r10d
    mov          %edx, %r11d
    xor          %ecx, %r10d
    rol          $(5), %r11d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    add          %r11d, %eax
    rol          $(30), %r8d
    addl         (52)(%rsp), %r10d
    add          %r10d, %eax
 
    pxor         %xmm6, %xmm0
    pxor         %xmm1, %xmm0
    movdqa       %xmm0, %xmm6
    paddd        (%r12), %xmm0
    movdqa       %xmm0, (((19&~3)&15)*4)(%rsp)
 
    movdqa       %xmm8, %xmm5
    palignr      $(8), %xmm9, %xmm5
    movdqa       %xmm6, %xmm0
    psrldq       $(4), %xmm0
    pxor         %xmm7, %xmm5
    mov          %r8d, %r10d
    mov          %eax, %r11d
    xor          %r9d, %r10d
    rol          $(5), %r11d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r11d, %ecx
    rol          $(30), %edx
    addl         (56)(%rsp), %r10d
    add          %r10d, %ecx
 
    pxor         %xmm9, %xmm0
    pxor         %xmm0, %xmm5
    movdqa       %xmm5, %xmm1
    movdqa       %xmm5, %xmm0
    pslldq       $(12), %xmm1
 
    psrld        $(31), %xmm5
    pslld        $(1), %xmm0
    por          %xmm5, %xmm0
    movdqa       %xmm1, %xmm5
    psrld        $(30), %xmm1
    pslld        $(2), %xmm5
 
    pxor         %xmm5, %xmm0
    pxor         %xmm1, %xmm0
    movdqa       %xmm0, %xmm5
    paddd        (16)(%r12), %xmm0
    movdqa       %xmm0, (((23&~3)&15)*4)(%rsp)
    mov          %edx, %r10d
    mov          %ecx, %r11d
    xor          %r8d, %r10d
    rol          $(5), %r11d
    and          %eax, %r10d
    xor          %r8d, %r10d
    add          %r11d, %r9d
    rol          $(30), %eax
    addl         (60)(%rsp), %r10d
    add          %r10d, %r9d
 
    movdqa       %xmm7, %xmm4
    palignr      $(8), %xmm8, %xmm4
    movdqa       %xmm5, %xmm0
    psrldq       $(4), %xmm0
    pxor         %xmm6, %xmm4
    addl         (%rsp), %r8d
    mov          %eax, %r10d
    xor          %edx, %r10d
    and          %ecx, %r10d
    xor          %edx, %r10d
    addl         (4)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    pxor         %xmm8, %xmm0
    pxor         %xmm0, %xmm4
    movdqa       %xmm4, %xmm1
    movdqa       %xmm4, %xmm0
    pslldq       $(12), %xmm1
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    xor          %eax, %r10d
    and          %r9d, %r10d
    xor          %eax, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    psrld        $(31), %xmm4
    pslld        $(1), %xmm0
    por          %xmm4, %xmm0
    movdqa       %xmm1, %xmm4
    psrld        $(30), %xmm1
    pslld        $(2), %xmm4
    addl         (8)(%rsp), %eax
    mov          %r9d, %r10d
    xor          %ecx, %r10d
    and          %r8d, %r10d
    xor          %ecx, %r10d
    addl         (12)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    pxor         %xmm4, %xmm0
    pxor         %xmm1, %xmm0
    movdqa       %xmm0, %xmm4
    paddd        (16)(%r12), %xmm0
    movdqa       %xmm0, (((27&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    xor          %r9d, %r10d
    and          %edx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    movdqa       %xmm6, %xmm3
    palignr      $(8), %xmm7, %xmm3
    movdqa       %xmm4, %xmm0
    psrldq       $(4), %xmm0
    pxor         %xmm5, %xmm3
    addl         (16)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (20)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    pxor         %xmm7, %xmm0
    pxor         %xmm0, %xmm3
    movdqa       %xmm3, %xmm1
    movdqa       %xmm3, %xmm0
    pslldq       $(12), %xmm1
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    psrld        $(31), %xmm3
    pslld        $(1), %xmm0
    por          %xmm3, %xmm0
    movdqa       %xmm1, %xmm3
    psrld        $(30), %xmm1
    pslld        $(2), %xmm3
    addl         (24)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (28)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    pxor         %xmm3, %xmm0
    pxor         %xmm1, %xmm0
    movdqa       %xmm0, %xmm3
    paddd        (16)(%r12), %xmm0
    movdqa       %xmm0, (((31&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    movdqa       %xmm3, %xmm0
    pxor         %xmm9, %xmm2
    palignr      $(8), %xmm4, %xmm0
    addl         (32)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (36)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    pxor         %xmm6, %xmm2
    pxor         %xmm0, %xmm2
    movdqa       %xmm2, %xmm0
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    psrld        $(30), %xmm2
    pslld        $(2), %xmm0
    por          %xmm2, %xmm0
    addl         (40)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (44)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    movdqa       %xmm0, %xmm2
    paddd        (16)(%r12), %xmm0
    movdqa       %xmm0, (((35&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    movdqa       %xmm2, %xmm0
    pxor         %xmm8, %xmm9
    palignr      $(8), %xmm3, %xmm0
    addl         (48)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (52)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    pxor         %xmm5, %xmm9
    pxor         %xmm0, %xmm9
    movdqa       %xmm9, %xmm0
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    psrld        $(30), %xmm9
    pslld        $(2), %xmm0
    por          %xmm9, %xmm0
    addl         (56)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (60)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    movdqa       %xmm0, %xmm9
    paddd        (16)(%r12), %xmm0
    movdqa       %xmm0, (((39&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    movdqa       %xmm9, %xmm0
    pxor         %xmm7, %xmm8
    palignr      $(8), %xmm2, %xmm0
    addl         (%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (4)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    pxor         %xmm4, %xmm8
    pxor         %xmm0, %xmm8
    movdqa       %xmm8, %xmm0
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    psrld        $(30), %xmm8
    pslld        $(2), %xmm0
    por          %xmm8, %xmm0
    addl         (8)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (12)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    movdqa       %xmm0, %xmm8
    paddd        (32)(%r12), %xmm0
    movdqa       %xmm0, (((43&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    movdqa       %xmm8, %xmm0
    pxor         %xmm6, %xmm7
    palignr      $(8), %xmm9, %xmm0
    addl         (16)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (20)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    pxor         %xmm3, %xmm7
    pxor         %xmm0, %xmm7
    movdqa       %xmm7, %xmm0
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    psrld        $(30), %xmm7
    pslld        $(2), %xmm0
    por          %xmm7, %xmm0
    addl         (24)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (28)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    movdqa       %xmm0, %xmm7
    paddd        (32)(%r12), %xmm0
    movdqa       %xmm0, (((47&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    movdqa       %xmm7, %xmm0
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm8, %xmm0
    addl         (32)(%rsp), %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    addl         (36)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    pxor         %xmm2, %xmm6
    pxor         %xmm0, %xmm6
    movdqa       %xmm6, %xmm0
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    psrld        $(30), %xmm6
    pslld        $(2), %xmm0
    por          %xmm6, %xmm0
    addl         (40)(%rsp), %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    addl         (44)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    movdqa       %xmm0, %xmm6
    paddd        (32)(%r12), %xmm0
    movdqa       %xmm0, (((51&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    movdqa       %xmm6, %xmm0
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm7, %xmm0
    addl         (48)(%rsp), %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    addl         (52)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    pxor         %xmm9, %xmm5
    pxor         %xmm0, %xmm5
    movdqa       %xmm5, %xmm0
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    psrld        $(30), %xmm5
    pslld        $(2), %xmm0
    por          %xmm5, %xmm0
    addl         (56)(%rsp), %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    addl         (60)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    movdqa       %xmm0, %xmm5
    paddd        (32)(%r12), %xmm0
    movdqa       %xmm0, (((55&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    movdqa       %xmm5, %xmm0
    pxor         %xmm3, %xmm4
    palignr      $(8), %xmm6, %xmm0
    addl         (%rsp), %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    addl         (4)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    pxor         %xmm8, %xmm4
    pxor         %xmm0, %xmm4
    movdqa       %xmm4, %xmm0
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    psrld        $(30), %xmm4
    pslld        $(2), %xmm0
    por          %xmm4, %xmm0
    addl         (8)(%rsp), %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    addl         (12)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    movdqa       %xmm0, %xmm4
    paddd        (32)(%r12), %xmm0
    movdqa       %xmm0, (((59&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    movdqa       %xmm4, %xmm0
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm5, %xmm0
    addl         (16)(%rsp), %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    addl         (20)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    pxor         %xmm7, %xmm3
    pxor         %xmm0, %xmm3
    movdqa       %xmm3, %xmm0
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    psrld        $(30), %xmm3
    pslld        $(2), %xmm0
    por          %xmm3, %xmm0
    addl         (24)(%rsp), %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    addl         (28)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    movdqa       %xmm0, %xmm3
    paddd        (48)(%r12), %xmm0
    movdqa       %xmm0, (((63&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %edx, %r10d
    mov          %eax, %r11d
    or           %eax, %r10d
    and          %edx, %r11d
    and          %r8d, %r10d
    or           %r11d, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    movdqa       %xmm3, %xmm0
    pxor         %xmm9, %xmm2
    palignr      $(8), %xmm4, %xmm0
    addl         (32)(%rsp), %r8d
    mov          %eax, %r10d
    mov          %ecx, %r11d
    or           %ecx, %r10d
    and          %eax, %r11d
    and          %edx, %r10d
    or           %r11d, %r10d
    addl         (36)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    pxor         %xmm6, %xmm2
    pxor         %xmm0, %xmm2
    movdqa       %xmm2, %xmm0
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %ecx, %r10d
    mov          %r9d, %r11d
    or           %r9d, %r10d
    and          %ecx, %r11d
    and          %eax, %r10d
    or           %r11d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    psrld        $(30), %xmm2
    pslld        $(2), %xmm0
    por          %xmm2, %xmm0
    addl         (40)(%rsp), %eax
    mov          %r9d, %r10d
    mov          %r8d, %r11d
    or           %r8d, %r10d
    and          %r9d, %r11d
    and          %ecx, %r10d
    or           %r11d, %r10d
    addl         (44)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    movdqa       %xmm0, %xmm2
    paddd        (48)(%r12), %xmm0
    movdqa       %xmm0, (((67&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r8d, %r10d
    mov          %edx, %r11d
    or           %edx, %r10d
    and          %r8d, %r11d
    and          %r9d, %r10d
    or           %r11d, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    movdqa       %xmm2, %xmm0
    pxor         %xmm8, %xmm9
    palignr      $(8), %xmm3, %xmm0
    addl         (48)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (52)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    pxor         %xmm5, %xmm9
    pxor         %xmm0, %xmm9
    movdqa       %xmm9, %xmm0
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    psrld        $(30), %xmm9
    pslld        $(2), %xmm0
    por          %xmm9, %xmm0
    addl         (56)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (60)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    movdqa       %xmm0, %xmm9
    paddd        (48)(%r12), %xmm0
    movdqa       %xmm0, (((71&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    movdqa       %xmm9, %xmm0
    pxor         %xmm7, %xmm8
    palignr      $(8), %xmm2, %xmm0
    addl         (%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (4)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    pxor         %xmm4, %xmm8
    pxor         %xmm0, %xmm8
    movdqa       %xmm8, %xmm0
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    psrld        $(30), %xmm8
    pslld        $(2), %xmm0
    por          %xmm8, %xmm0
    addl         (8)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (12)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    movdqa       %xmm0, %xmm8
    paddd        (48)(%r12), %xmm0
    movdqa       %xmm0, (((75&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    movdqa       %xmm8, %xmm0
    pxor         %xmm6, %xmm7
    palignr      $(8), %xmm9, %xmm0
    addl         (16)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (20)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    pxor         %xmm3, %xmm7
    pxor         %xmm0, %xmm7
    movdqa       %xmm7, %xmm0
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
 
    psrld        $(30), %xmm7
    pslld        $(2), %xmm0
    por          %xmm7, %xmm0
    addl         (24)(%rsp), %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    addl         (28)(%rsp), %r8d
    rol          $(30), %eax
    mov          %ecx, %r13d
    add          %r10d, %r9d
    rol          $(5), %r13d
    add          %r9d, %r13d
    mov          %r13d, %r9d
 
    movdqa       %xmm0, %xmm7
    paddd        (48)(%r12), %xmm0
    movdqa       %xmm0, (((79&~3)&15)*4)(%rsp)
    rol          $(5), %r13d
    add          %r13d, %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    add          %r10d, %r8d
    rol          $(30), %ecx
 
    movdqa       %xmm7, %xmm0
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm8, %xmm0
    addl         (32)(%rsp), %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    addl         (36)(%rsp), %eax
    rol          $(30), %r9d
    mov          %r8d, %r13d
    add          %r10d, %edx
    rol          $(5), %r13d
    add          %edx, %r13d
    mov          %r13d, %edx
 
    pxor         %xmm2, %xmm6
    pxor         %xmm0, %xmm6
    movdqa       %xmm6, %xmm0
    rol          $(5), %r13d
    add          %r13d, %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    add          %r10d, %eax
    rol          $(30), %r8d
 
    psrld        $(30), %xmm6
    pslld        $(2), %xmm0
    por          %xmm6, %xmm0
    addl         (40)(%rsp), %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    addl         (44)(%rsp), %r9d
    rol          $(30), %edx
    mov          %eax, %r13d
    add          %r10d, %ecx
    rol          $(5), %r13d
    add          %ecx, %r13d
    mov          %r13d, %ecx
 
    rol          $(5), %r13d
    add          %r13d, %r9d
    mov          %r8d, %r10d
    xor          %edx, %r10d
    xor          %eax, %r10d
    add          %r10d, %r9d
    rol          $(30), %eax
 
    addl         (48)(%rsp), %r8d
    mov          %edx, %r10d
    xor          %eax, %r10d
    xor          %ecx, %r10d
    addl         (52)(%rsp), %edx
    rol          $(30), %ecx
    mov          %r9d, %r13d
    add          %r10d, %r8d
    rol          $(5), %r13d
    add          %r8d, %r13d
    mov          %r13d, %r8d
 
    rol          $(5), %r13d
    add          %r13d, %edx
    mov          %eax, %r10d
    xor          %ecx, %r10d
    xor          %r9d, %r10d
    add          %r10d, %edx
    rol          $(30), %r9d
 
    addl         (56)(%rsp), %eax
    mov          %ecx, %r10d
    xor          %r9d, %r10d
    xor          %r8d, %r10d
    addl         (60)(%rsp), %ecx
    rol          $(30), %r8d
    mov          %edx, %r13d
    add          %r10d, %eax
    rol          $(5), %r13d
    add          %eax, %r13d
    mov          %r13d, %eax
 
    rol          $(5), %r13d
    add          %r13d, %ecx
    mov          %r9d, %r10d
    xor          %r8d, %r10d
    xor          %edx, %r10d
    add          %r10d, %ecx
    rol          $(30), %edx
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
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    ret
 
