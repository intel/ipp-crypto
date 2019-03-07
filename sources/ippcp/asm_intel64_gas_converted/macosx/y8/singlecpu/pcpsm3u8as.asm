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
 
bswap128:
.byte  3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12 
.p2align 4, 0x90
 
.globl _UpdateSM3

 
_UpdateSM3:
 
    push         %rbp
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(312), %rsp
 
    movslq       %edx, %rdx
    movq         %rdi, (272)(%rsp)
    movq         %rdx, (288)(%rsp)
    mov          (%rdi), %r8d
    mov          (4)(%rdi), %r9d
    mov          (8)(%rdi), %r10d
    mov          (12)(%rdi), %r11d
    mov          (16)(%rdi), %r12d
    mov          (20)(%rdi), %r13d
    mov          (24)(%rdi), %r14d
    mov          (28)(%rdi), %r15d
.p2align 4, 0x90
.Lmain_loopgas_1: 
    xor          %rdi, %rdi
    movdqu       (%rsi), %xmm0
    movdqu       (16)(%rsi), %xmm1
    movdqu       (32)(%rsi), %xmm2
    movdqu       (48)(%rsi), %xmm3
    add          $(64), %rsi
    movq         %rsi, (280)(%rsp)
    pshufb       bswap128(%rip), %xmm0
    pshufb       bswap128(%rip), %xmm1
    pshufb       bswap128(%rip), %xmm2
    pshufb       bswap128(%rip), %xmm3
    movdqu       %xmm0, (%rsp)
    movdqu       %xmm1, (16)(%rsp)
    movdqu       %xmm2, (32)(%rsp)
    movdqu       %xmm3, (48)(%rsp)
.p2align 4, 0x90
.Lrounds_00_15gas_1: 
    mov          (52)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (28)(%rsp,%rdi,4), %ebp
    xor          (%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (12)(%rsp,%rdi,4), %ebp
    xor          (40)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (64)(%rsp,%rdi,4)
    mov          %r8d, %eax
    mov          (%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r9d, %ebp
    mov          %r13d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r11d, %eax
    add          %r15d, %ebx
    mov          (%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
    mov          (56)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (32)(%rsp,%rdi,4), %ebp
    xor          (4)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (16)(%rsp,%rdi,4), %ebp
    xor          (44)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (68)(%rsp,%rdi,4)
    mov          %r15d, %eax
    mov          (4)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r8d, %ebp
    mov          %r12d, %edx
    xor          %r9d, %ebp
    xor          %r13d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r10d, %eax
    add          %r14d, %ebx
    mov          (4)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    mov          (60)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (36)(%rsp,%rdi,4), %ebp
    xor          (8)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (20)(%rsp,%rdi,4), %ebp
    xor          (48)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (72)(%rsp,%rdi,4)
    mov          %r14d, %eax
    mov          (8)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r15d, %ebp
    mov          %r11d, %edx
    xor          %r8d, %ebp
    xor          %r12d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r9d, %eax
    add          %r13d, %ebx
    mov          (8)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
    mov          (64)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (40)(%rsp,%rdi,4), %ebp
    xor          (12)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (24)(%rsp,%rdi,4), %ebp
    xor          (52)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (76)(%rsp,%rdi,4)
    mov          %r13d, %eax
    mov          (12)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r14d, %ebp
    mov          %r10d, %edx
    xor          %r15d, %ebp
    xor          %r11d, %edx
    xor          %r13d, %ebp
    xor          %r9d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r8d, %eax
    add          %r12d, %ebx
    mov          (12)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    mov          (68)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (44)(%rsp,%rdi,4), %ebp
    xor          (16)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (28)(%rsp,%rdi,4), %ebp
    xor          (56)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (80)(%rsp,%rdi,4)
    mov          %r12d, %eax
    mov          (16)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r13d, %ebp
    mov          %r9d, %edx
    xor          %r14d, %ebp
    xor          %r10d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r15d, %eax
    add          %r11d, %ebx
    mov          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (32)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
    mov          (72)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (48)(%rsp,%rdi,4), %ebp
    xor          (20)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (32)(%rsp,%rdi,4), %ebp
    xor          (60)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (84)(%rsp,%rdi,4)
    mov          %r11d, %eax
    mov          (20)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r12d, %ebp
    mov          %r8d, %edx
    xor          %r13d, %ebp
    xor          %r9d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r14d, %eax
    add          %r10d, %ebx
    mov          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (36)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    mov          (76)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (52)(%rsp,%rdi,4), %ebp
    xor          (24)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (36)(%rsp,%rdi,4), %ebp
    xor          (64)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (88)(%rsp,%rdi,4)
    mov          %r10d, %eax
    mov          (24)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r11d, %ebp
    mov          %r15d, %edx
    xor          %r12d, %ebp
    xor          %r8d, %edx
    xor          %r10d, %ebp
    xor          %r14d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r13d, %eax
    add          %r9d, %ebx
    mov          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (40)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
    mov          (80)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (56)(%rsp,%rdi,4), %ebp
    xor          (28)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (40)(%rsp,%rdi,4), %ebp
    xor          (68)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (92)(%rsp,%rdi,4)
    mov          %r9d, %eax
    mov          (28)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
    mov          %r10d, %ebp
    mov          %r14d, %edx
    xor          %r11d, %ebp
    xor          %r15d, %edx
    xor          %r9d, %ebp
    xor          %r13d, %edx
    add          %ebp, %eax
    add          %edx, %ebx
    add          %r12d, %eax
    add          %r8d, %ebx
    mov          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (44)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    add          $(8), %rdi
    cmp          $(16), %rdi
    jne          .Lrounds_00_15gas_1
.p2align 4, 0x90
.Lrounds_16_47gas_1: 
    mov          (52)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (28)(%rsp,%rdi,4), %ebp
    xor          (%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (12)(%rsp,%rdi,4), %ebp
    xor          (40)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (64)(%rsp,%rdi,4)
    mov          %r8d, %eax
    mov          (%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r11d, %eax
    add          %r15d, %ebx
    mov          (%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
    mov          (56)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (32)(%rsp,%rdi,4), %ebp
    xor          (4)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (16)(%rsp,%rdi,4), %ebp
    xor          (44)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (68)(%rsp,%rdi,4)
    mov          %r15d, %eax
    mov          (4)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r10d, %eax
    add          %r14d, %ebx
    mov          (4)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    mov          (60)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (36)(%rsp,%rdi,4), %ebp
    xor          (8)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (20)(%rsp,%rdi,4), %ebp
    xor          (48)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (72)(%rsp,%rdi,4)
    mov          %r14d, %eax
    mov          (8)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r9d, %eax
    add          %r13d, %ebx
    mov          (8)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
    mov          (64)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (40)(%rsp,%rdi,4), %ebp
    xor          (12)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (24)(%rsp,%rdi,4), %ebp
    xor          (52)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (76)(%rsp,%rdi,4)
    mov          %r13d, %eax
    mov          (12)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r8d, %eax
    add          %r12d, %ebx
    mov          (12)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    mov          (68)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (44)(%rsp,%rdi,4), %ebp
    xor          (16)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (28)(%rsp,%rdi,4), %ebp
    xor          (56)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (80)(%rsp,%rdi,4)
    mov          %r12d, %eax
    mov          (16)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r15d, %eax
    add          %r11d, %ebx
    mov          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (32)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
    mov          (72)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (48)(%rsp,%rdi,4), %ebp
    xor          (20)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (32)(%rsp,%rdi,4), %ebp
    xor          (60)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (84)(%rsp,%rdi,4)
    mov          %r11d, %eax
    mov          (20)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r14d, %eax
    add          %r10d, %ebx
    mov          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (36)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    mov          (76)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (52)(%rsp,%rdi,4), %ebp
    xor          (24)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (36)(%rsp,%rdi,4), %ebp
    xor          (64)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (88)(%rsp,%rdi,4)
    mov          %r10d, %eax
    mov          (24)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r13d, %eax
    add          %r9d, %ebx
    mov          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (40)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
    mov          (80)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (56)(%rsp,%rdi,4), %ebp
    xor          (28)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (40)(%rsp,%rdi,4), %ebp
    xor          (68)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (92)(%rsp,%rdi,4)
    mov          %r9d, %eax
    mov          (28)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r12d, %eax
    add          %r8d, %ebx
    mov          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (44)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    add          $(8), %rdi
    cmp          $(48), %rdi
    jne          .Lrounds_16_47gas_1
    mov          (52)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (28)(%rsp,%rdi,4), %ebp
    xor          (%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (12)(%rsp,%rdi,4), %ebp
    xor          (40)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (64)(%rsp,%rdi,4)
    mov          (56)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (32)(%rsp,%rdi,4), %ebp
    xor          (4)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (16)(%rsp,%rdi,4), %ebp
    xor          (44)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (68)(%rsp,%rdi,4)
    mov          (60)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (36)(%rsp,%rdi,4), %ebp
    xor          (8)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (20)(%rsp,%rdi,4), %ebp
    xor          (48)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (72)(%rsp,%rdi,4)
    mov          (64)(%rsp,%rdi,4), %ebp
    shld         $(15), %ebp, %ebp
    xor          (40)(%rsp,%rdi,4), %ebp
    xor          (12)(%rsp,%rdi,4), %ebp
    mov          %ebp, %edx
    shld         $(8), %edx, %edx
    xor          %ebp, %edx
    shld         $(15), %edx, %edx
    xor          %ebp, %edx
    mov          (24)(%rsp,%rdi,4), %ebp
    xor          (52)(%rsp,%rdi,4), %edx
    shld         $(7), %ebp, %ebp
    xor          %ebp, %edx
    mov          %edx, (76)(%rsp,%rdi,4)
.p2align 4, 0x90
.Lrounds_48_63gas_1: 
    mov          %r8d, %eax
    mov          (%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r12d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r11d, %eax
    add          %r15d, %ebx
    mov          (%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r9d, %r9d
    shld         $(19), %r13d, %r13d
    mov          %eax, %r15d
    mov          %ebx, %r11d
    shld         $(8), %r11d, %r11d
    xor          %ebx, %r11d
    shld         $(9), %r11d, %r11d
    xor          %ebx, %r11d
    mov          %r15d, %eax
    mov          (4)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r11d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r10d, %eax
    add          %r14d, %ebx
    mov          (4)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r8d, %r8d
    shld         $(19), %r12d, %r12d
    mov          %eax, %r14d
    mov          %ebx, %r10d
    shld         $(8), %r10d, %r10d
    xor          %ebx, %r10d
    shld         $(9), %r10d, %r10d
    xor          %ebx, %r10d
    mov          %r14d, %eax
    mov          (8)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r10d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r9d, %eax
    add          %r13d, %ebx
    mov          (8)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r15d, %r15d
    shld         $(19), %r11d, %r11d
    mov          %eax, %r13d
    mov          %ebx, %r9d
    shld         $(8), %r9d, %r9d
    xor          %ebx, %r9d
    shld         $(9), %r9d, %r9d
    xor          %ebx, %r9d
    mov          %r13d, %eax
    mov          (12)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r9d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r8d, %eax
    add          %r12d, %ebx
    mov          (12)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r14d, %r14d
    shld         $(19), %r10d, %r10d
    mov          %eax, %r12d
    mov          %ebx, %r8d
    shld         $(8), %r8d, %r8d
    xor          %ebx, %r8d
    shld         $(9), %r8d, %r8d
    xor          %ebx, %r8d
    mov          %r12d, %eax
    mov          (16)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r8d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r15d, %eax
    add          %r11d, %ebx
    mov          (16)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (32)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r13d, %r13d
    shld         $(19), %r9d, %r9d
    mov          %eax, %r11d
    mov          %ebx, %r15d
    shld         $(8), %r15d, %r15d
    xor          %ebx, %r15d
    shld         $(9), %r15d, %r15d
    xor          %ebx, %r15d
    mov          %r11d, %eax
    mov          (20)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r15d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r14d, %eax
    add          %r10d, %ebx
    mov          (20)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (36)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r12d, %r12d
    shld         $(19), %r8d, %r8d
    mov          %eax, %r10d
    mov          %ebx, %r14d
    shld         $(8), %r14d, %r14d
    xor          %ebx, %r14d
    shld         $(9), %r14d, %r14d
    xor          %ebx, %r14d
    mov          %r10d, %eax
    mov          (24)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r14d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r13d, %eax
    add          %r9d, %ebx
    mov          (24)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (40)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r11d, %r11d
    shld         $(19), %r15d, %r15d
    mov          %eax, %r9d
    mov          %ebx, %r13d
    shld         $(8), %r13d, %r13d
    xor          %ebx, %r13d
    shld         $(9), %r13d, %r13d
    xor          %ebx, %r13d
    mov          %r9d, %eax
    mov          (28)(%rcx,%rdi,4), %ebx
    shld         $(12), %eax, %eax
    add          %eax, %ebx
    add          %r13d, %ebx
    shld         $(7), %ebx, %ebx
    xor          %ebx, %eax
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
    add          %r12d, %eax
    add          %r8d, %ebx
    mov          (28)(%rsp,%rdi,4), %ebp
    add          %ebp, %ebx
    xor          (44)(%rsp,%rdi,4), %ebp
    add          %ebp, %eax
    shld         $(9), %r10d, %r10d
    shld         $(19), %r14d, %r14d
    mov          %eax, %r8d
    mov          %ebx, %r12d
    shld         $(8), %r12d, %r12d
    xor          %ebx, %r12d
    shld         $(9), %r12d, %r12d
    xor          %ebx, %r12d
    add          $(8), %rdi
    cmp          $(64), %rdi
    jne          .Lrounds_48_63gas_1
    mov          (272)(%rsp), %rdi
    mov          (280)(%rsp), %rsi
    xor          (%rdi), %r8d
    xor          (4)(%rdi), %r9d
    xor          (8)(%rdi), %r10d
    xor          (12)(%rdi), %r11d
    xor          (16)(%rdi), %r12d
    xor          (20)(%rdi), %r13d
    xor          (24)(%rdi), %r14d
    xor          (28)(%rdi), %r15d
    mov          %r8d, (%rdi)
    mov          %r9d, (4)(%rdi)
    mov          %r10d, (8)(%rdi)
    mov          %r11d, (12)(%rdi)
    mov          %r12d, (16)(%rdi)
    mov          %r13d, (20)(%rdi)
    mov          %r14d, (24)(%rdi)
    mov          %r15d, (28)(%rdi)
    subq         $(64), (288)(%rsp)
    jne          .Lmain_loopgas_1
    add          $(312), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    pop          %rbp
 
    ret
 
