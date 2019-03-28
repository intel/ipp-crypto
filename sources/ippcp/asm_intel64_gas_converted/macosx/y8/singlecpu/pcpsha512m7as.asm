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
 
pByteSwp:
.byte  7,6,5,4,3,2,1,0, 15,14,13,12,11,10,9,8 
.p2align 4, 0x90
 
.globl _UpdateSHA512

 
_UpdateSHA512:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    push         %rbp
 
    sub          $(152), %rsp
 
    movslq       %edx, %rdx
    movq         %rdx, (128)(%rsp)
    mov          %rcx, %rbp
.Lsha512_block_loopgas_1: 
    movdqu       pByteSwp(%rip), %xmm4
    movdqu       (%rsi), %xmm0
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (%rsp)
    movdqu       (16)(%rsi), %xmm1
    pshufb       %xmm4, %xmm1
    movdqa       %xmm1, (16)(%rsp)
    movdqu       (32)(%rsi), %xmm2
    pshufb       %xmm4, %xmm2
    movdqa       %xmm2, (32)(%rsp)
    movdqu       (48)(%rsi), %xmm3
    pshufb       %xmm4, %xmm3
    movdqa       %xmm3, (48)(%rsp)
    movdqu       (64)(%rsi), %xmm0
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (64)(%rsp)
    movdqu       (80)(%rsi), %xmm1
    pshufb       %xmm4, %xmm1
    movdqa       %xmm1, (80)(%rsp)
    movdqu       (96)(%rsi), %xmm2
    pshufb       %xmm4, %xmm2
    movdqa       %xmm2, (96)(%rsp)
    movdqu       (112)(%rsi), %xmm3
    pshufb       %xmm4, %xmm3
    movdqa       %xmm3, (112)(%rsp)
    mov          (%rdi), %r8
    mov          (8)(%rdi), %r9
    mov          (16)(%rdi), %r10
    mov          (24)(%rdi), %r11
    mov          (32)(%rdi), %r12
    mov          (40)(%rdi), %r13
    mov          (48)(%rdi), %r14
    mov          (56)(%rdi), %r15
    add          (%rbp), %r15
    add          (%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (8)(%rsp), %rax
    mov          (112)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (8)(%rsp), %rcx
    mov          (112)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (%rsp), %rax
    add          (72)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (%rsp)
    add          (8)(%rbp), %r14
    add          (8)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (16)(%rsp), %rax
    mov          (120)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (16)(%rsp), %rcx
    mov          (120)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (8)(%rsp), %rax
    add          (80)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (8)(%rsp)
    add          (16)(%rbp), %r13
    add          (16)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (24)(%rsp), %rax
    mov          (%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (24)(%rsp), %rcx
    mov          (%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (16)(%rsp), %rax
    add          (88)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (16)(%rsp)
    add          (24)(%rbp), %r12
    add          (24)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (32)(%rsp), %rax
    mov          (8)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (32)(%rsp), %rcx
    mov          (8)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (24)(%rsp), %rax
    add          (96)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (24)(%rsp)
    add          (32)(%rbp), %r11
    add          (32)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (40)(%rsp), %rax
    mov          (16)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (40)(%rsp), %rcx
    mov          (16)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (32)(%rsp), %rax
    add          (104)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (32)(%rsp)
    add          (40)(%rbp), %r10
    add          (40)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (48)(%rsp), %rax
    mov          (24)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (48)(%rsp), %rcx
    mov          (24)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (40)(%rsp), %rax
    add          (112)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (40)(%rsp)
    add          (48)(%rbp), %r9
    add          (48)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (56)(%rsp), %rax
    mov          (32)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (56)(%rsp), %rcx
    mov          (32)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (48)(%rsp), %rax
    add          (120)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (48)(%rsp)
    add          (56)(%rbp), %r8
    add          (56)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (64)(%rsp), %rax
    mov          (40)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (64)(%rsp), %rcx
    mov          (40)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (56)(%rsp), %rax
    add          (%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (56)(%rsp)
    add          (64)(%rbp), %r15
    add          (64)(%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (72)(%rsp), %rax
    mov          (48)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (72)(%rsp), %rcx
    mov          (48)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (64)(%rsp), %rax
    add          (8)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (64)(%rsp)
    add          (72)(%rbp), %r14
    add          (72)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (80)(%rsp), %rax
    mov          (56)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (80)(%rsp), %rcx
    mov          (56)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (72)(%rsp), %rax
    add          (16)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (72)(%rsp)
    add          (80)(%rbp), %r13
    add          (80)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (88)(%rsp), %rax
    mov          (64)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (88)(%rsp), %rcx
    mov          (64)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (80)(%rsp), %rax
    add          (24)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (80)(%rsp)
    add          (88)(%rbp), %r12
    add          (88)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (96)(%rsp), %rax
    mov          (72)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (96)(%rsp), %rcx
    mov          (72)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (88)(%rsp), %rax
    add          (32)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (88)(%rsp)
    add          (96)(%rbp), %r11
    add          (96)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (104)(%rsp), %rax
    mov          (80)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (104)(%rsp), %rcx
    mov          (80)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (96)(%rsp), %rax
    add          (40)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (96)(%rsp)
    add          (104)(%rbp), %r10
    add          (104)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (112)(%rsp), %rax
    mov          (88)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (112)(%rsp), %rcx
    mov          (88)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (104)(%rsp), %rax
    add          (48)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (104)(%rsp)
    add          (112)(%rbp), %r9
    add          (112)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (120)(%rsp), %rax
    mov          (96)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (120)(%rsp), %rcx
    mov          (96)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (112)(%rsp), %rax
    add          (56)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (112)(%rsp)
    add          (120)(%rbp), %r8
    add          (120)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (%rsp), %rax
    mov          (104)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (%rsp), %rcx
    mov          (104)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (120)(%rsp), %rax
    add          (64)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (120)(%rsp)
    add          (128)(%rbp), %r15
    add          (%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (8)(%rsp), %rax
    mov          (112)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (8)(%rsp), %rcx
    mov          (112)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (%rsp), %rax
    add          (72)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (%rsp)
    add          (136)(%rbp), %r14
    add          (8)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (16)(%rsp), %rax
    mov          (120)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (16)(%rsp), %rcx
    mov          (120)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (8)(%rsp), %rax
    add          (80)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (8)(%rsp)
    add          (144)(%rbp), %r13
    add          (16)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (24)(%rsp), %rax
    mov          (%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (24)(%rsp), %rcx
    mov          (%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (16)(%rsp), %rax
    add          (88)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (16)(%rsp)
    add          (152)(%rbp), %r12
    add          (24)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (32)(%rsp), %rax
    mov          (8)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (32)(%rsp), %rcx
    mov          (8)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (24)(%rsp), %rax
    add          (96)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (24)(%rsp)
    add          (160)(%rbp), %r11
    add          (32)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (40)(%rsp), %rax
    mov          (16)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (40)(%rsp), %rcx
    mov          (16)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (32)(%rsp), %rax
    add          (104)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (32)(%rsp)
    add          (168)(%rbp), %r10
    add          (40)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (48)(%rsp), %rax
    mov          (24)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (48)(%rsp), %rcx
    mov          (24)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (40)(%rsp), %rax
    add          (112)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (40)(%rsp)
    add          (176)(%rbp), %r9
    add          (48)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (56)(%rsp), %rax
    mov          (32)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (56)(%rsp), %rcx
    mov          (32)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (48)(%rsp), %rax
    add          (120)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (48)(%rsp)
    add          (184)(%rbp), %r8
    add          (56)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (64)(%rsp), %rax
    mov          (40)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (64)(%rsp), %rcx
    mov          (40)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (56)(%rsp), %rax
    add          (%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (56)(%rsp)
    add          (192)(%rbp), %r15
    add          (64)(%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (72)(%rsp), %rax
    mov          (48)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (72)(%rsp), %rcx
    mov          (48)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (64)(%rsp), %rax
    add          (8)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (64)(%rsp)
    add          (200)(%rbp), %r14
    add          (72)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (80)(%rsp), %rax
    mov          (56)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (80)(%rsp), %rcx
    mov          (56)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (72)(%rsp), %rax
    add          (16)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (72)(%rsp)
    add          (208)(%rbp), %r13
    add          (80)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (88)(%rsp), %rax
    mov          (64)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (88)(%rsp), %rcx
    mov          (64)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (80)(%rsp), %rax
    add          (24)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (80)(%rsp)
    add          (216)(%rbp), %r12
    add          (88)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (96)(%rsp), %rax
    mov          (72)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (96)(%rsp), %rcx
    mov          (72)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (88)(%rsp), %rax
    add          (32)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (88)(%rsp)
    add          (224)(%rbp), %r11
    add          (96)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (104)(%rsp), %rax
    mov          (80)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (104)(%rsp), %rcx
    mov          (80)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (96)(%rsp), %rax
    add          (40)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (96)(%rsp)
    add          (232)(%rbp), %r10
    add          (104)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (112)(%rsp), %rax
    mov          (88)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (112)(%rsp), %rcx
    mov          (88)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (104)(%rsp), %rax
    add          (48)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (104)(%rsp)
    add          (240)(%rbp), %r9
    add          (112)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (120)(%rsp), %rax
    mov          (96)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (120)(%rsp), %rcx
    mov          (96)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (112)(%rsp), %rax
    add          (56)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (112)(%rsp)
    add          (248)(%rbp), %r8
    add          (120)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (%rsp), %rax
    mov          (104)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (%rsp), %rcx
    mov          (104)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (120)(%rsp), %rax
    add          (64)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (120)(%rsp)
    add          (256)(%rbp), %r15
    add          (%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (8)(%rsp), %rax
    mov          (112)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (8)(%rsp), %rcx
    mov          (112)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (%rsp), %rax
    add          (72)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (%rsp)
    add          (264)(%rbp), %r14
    add          (8)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (16)(%rsp), %rax
    mov          (120)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (16)(%rsp), %rcx
    mov          (120)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (8)(%rsp), %rax
    add          (80)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (8)(%rsp)
    add          (272)(%rbp), %r13
    add          (16)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (24)(%rsp), %rax
    mov          (%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (24)(%rsp), %rcx
    mov          (%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (16)(%rsp), %rax
    add          (88)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (16)(%rsp)
    add          (280)(%rbp), %r12
    add          (24)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (32)(%rsp), %rax
    mov          (8)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (32)(%rsp), %rcx
    mov          (8)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (24)(%rsp), %rax
    add          (96)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (24)(%rsp)
    add          (288)(%rbp), %r11
    add          (32)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (40)(%rsp), %rax
    mov          (16)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (40)(%rsp), %rcx
    mov          (16)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (32)(%rsp), %rax
    add          (104)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (32)(%rsp)
    add          (296)(%rbp), %r10
    add          (40)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (48)(%rsp), %rax
    mov          (24)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (48)(%rsp), %rcx
    mov          (24)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (40)(%rsp), %rax
    add          (112)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (40)(%rsp)
    add          (304)(%rbp), %r9
    add          (48)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (56)(%rsp), %rax
    mov          (32)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (56)(%rsp), %rcx
    mov          (32)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (48)(%rsp), %rax
    add          (120)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (48)(%rsp)
    add          (312)(%rbp), %r8
    add          (56)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (64)(%rsp), %rax
    mov          (40)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (64)(%rsp), %rcx
    mov          (40)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (56)(%rsp), %rax
    add          (%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (56)(%rsp)
    add          (320)(%rbp), %r15
    add          (64)(%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (72)(%rsp), %rax
    mov          (48)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (72)(%rsp), %rcx
    mov          (48)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (64)(%rsp), %rax
    add          (8)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (64)(%rsp)
    add          (328)(%rbp), %r14
    add          (72)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (80)(%rsp), %rax
    mov          (56)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (80)(%rsp), %rcx
    mov          (56)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (72)(%rsp), %rax
    add          (16)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (72)(%rsp)
    add          (336)(%rbp), %r13
    add          (80)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (88)(%rsp), %rax
    mov          (64)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (88)(%rsp), %rcx
    mov          (64)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (80)(%rsp), %rax
    add          (24)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (80)(%rsp)
    add          (344)(%rbp), %r12
    add          (88)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (96)(%rsp), %rax
    mov          (72)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (96)(%rsp), %rcx
    mov          (72)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (88)(%rsp), %rax
    add          (32)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (88)(%rsp)
    add          (352)(%rbp), %r11
    add          (96)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (104)(%rsp), %rax
    mov          (80)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (104)(%rsp), %rcx
    mov          (80)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (96)(%rsp), %rax
    add          (40)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (96)(%rsp)
    add          (360)(%rbp), %r10
    add          (104)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (112)(%rsp), %rax
    mov          (88)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (112)(%rsp), %rcx
    mov          (88)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (104)(%rsp), %rax
    add          (48)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (104)(%rsp)
    add          (368)(%rbp), %r9
    add          (112)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (120)(%rsp), %rax
    mov          (96)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (120)(%rsp), %rcx
    mov          (96)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (112)(%rsp), %rax
    add          (56)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (112)(%rsp)
    add          (376)(%rbp), %r8
    add          (120)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (%rsp), %rax
    mov          (104)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (%rsp), %rcx
    mov          (104)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (120)(%rsp), %rax
    add          (64)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (120)(%rsp)
    add          (384)(%rbp), %r15
    add          (%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (8)(%rsp), %rax
    mov          (112)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (8)(%rsp), %rcx
    mov          (112)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (%rsp), %rax
    add          (72)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (%rsp)
    add          (392)(%rbp), %r14
    add          (8)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (16)(%rsp), %rax
    mov          (120)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (16)(%rsp), %rcx
    mov          (120)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (8)(%rsp), %rax
    add          (80)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (8)(%rsp)
    add          (400)(%rbp), %r13
    add          (16)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (24)(%rsp), %rax
    mov          (%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (24)(%rsp), %rcx
    mov          (%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (16)(%rsp), %rax
    add          (88)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (16)(%rsp)
    add          (408)(%rbp), %r12
    add          (24)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (32)(%rsp), %rax
    mov          (8)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (32)(%rsp), %rcx
    mov          (8)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (24)(%rsp), %rax
    add          (96)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (24)(%rsp)
    add          (416)(%rbp), %r11
    add          (32)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (40)(%rsp), %rax
    mov          (16)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (40)(%rsp), %rcx
    mov          (16)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (32)(%rsp), %rax
    add          (104)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (32)(%rsp)
    add          (424)(%rbp), %r10
    add          (40)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (48)(%rsp), %rax
    mov          (24)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (48)(%rsp), %rcx
    mov          (24)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (40)(%rsp), %rax
    add          (112)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (40)(%rsp)
    add          (432)(%rbp), %r9
    add          (48)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (56)(%rsp), %rax
    mov          (32)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (56)(%rsp), %rcx
    mov          (32)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (48)(%rsp), %rax
    add          (120)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (48)(%rsp)
    add          (440)(%rbp), %r8
    add          (56)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (64)(%rsp), %rax
    mov          (40)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (64)(%rsp), %rcx
    mov          (40)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (56)(%rsp), %rax
    add          (%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (56)(%rsp)
    add          (448)(%rbp), %r15
    add          (64)(%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    mov          (72)(%rsp), %rax
    mov          (48)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (72)(%rsp), %rcx
    mov          (48)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (64)(%rsp), %rax
    add          (8)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (64)(%rsp)
    add          (456)(%rbp), %r14
    add          (72)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    mov          (80)(%rsp), %rax
    mov          (56)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (80)(%rsp), %rcx
    mov          (56)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (72)(%rsp), %rax
    add          (16)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (72)(%rsp)
    add          (464)(%rbp), %r13
    add          (80)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    mov          (88)(%rsp), %rax
    mov          (64)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (88)(%rsp), %rcx
    mov          (64)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (80)(%rsp), %rax
    add          (24)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (80)(%rsp)
    add          (472)(%rbp), %r12
    add          (88)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    mov          (96)(%rsp), %rax
    mov          (72)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (96)(%rsp), %rcx
    mov          (72)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (88)(%rsp), %rax
    add          (32)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (88)(%rsp)
    add          (480)(%rbp), %r11
    add          (96)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    mov          (104)(%rsp), %rax
    mov          (80)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (104)(%rsp), %rcx
    mov          (80)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (96)(%rsp), %rax
    add          (40)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (96)(%rsp)
    add          (488)(%rbp), %r10
    add          (104)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    mov          (112)(%rsp), %rax
    mov          (88)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (112)(%rsp), %rcx
    mov          (88)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (104)(%rsp), %rax
    add          (48)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (104)(%rsp)
    add          (496)(%rbp), %r9
    add          (112)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    mov          (120)(%rsp), %rax
    mov          (96)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (120)(%rsp), %rcx
    mov          (96)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (112)(%rsp), %rax
    add          (56)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (112)(%rsp)
    add          (504)(%rbp), %r8
    add          (120)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    mov          (%rsp), %rax
    mov          (104)(%rsp), %rbx
    shr          $(7), %rax
    shr          $(6), %rbx
    mov          (%rsp), %rcx
    mov          (104)(%rsp), %rdx
    shrd         $(1), %rcx, %rcx
    shrd         $(19), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    shrd         $(7), %rcx, %rcx
    shrd         $(42), %rdx, %rdx
    xor          %rcx, %rax
    xor          %rdx, %rbx
    add          (120)(%rsp), %rax
    add          (64)(%rsp), %rbx
    add          %rbx, %rax
    mov          %rax, (120)(%rsp)
    add          (512)(%rbp), %r15
    add          (%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          (520)(%rbp), %r14
    add          (8)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          (528)(%rbp), %r13
    add          (16)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          (536)(%rbp), %r12
    add          (24)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          (544)(%rbp), %r11
    add          (32)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          (552)(%rbp), %r10
    add          (40)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          (560)(%rbp), %r9
    add          (48)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          (568)(%rbp), %r8
    add          (56)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          (576)(%rbp), %r15
    add          (64)(%rsp), %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    not          %rdx
    shrd         $(18), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(23), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          %r15, %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    xor          %r9, %rdx
    shrd         $(34), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(5), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r15
    add          (584)(%rbp), %r14
    add          (72)(%rsp), %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    not          %rdx
    shrd         $(18), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(23), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          %r14, %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    xor          %r8, %rdx
    shrd         $(34), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(5), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r14
    add          (592)(%rbp), %r13
    add          (80)(%rsp), %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    not          %rdx
    shrd         $(18), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(23), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          %r13, %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    xor          %r15, %rdx
    shrd         $(34), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(5), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r13
    add          (600)(%rbp), %r12
    add          (88)(%rsp), %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    not          %rdx
    shrd         $(18), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(23), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          %r12, %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    xor          %r14, %rdx
    shrd         $(34), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(5), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r12
    add          (608)(%rbp), %r11
    add          (96)(%rsp), %r11
    mov          %r8, %rcx
    mov          %r8, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r8, %rbx
    push         %r8
    not          %rdx
    shrd         $(18), %r8, %r8
    and          %r9, %rbx
    and          %r10, %rdx
    xor          %r8, %rcx
    shrd         $(23), %r8, %r8
    xor          %rbx, %rdx
    xor          %r8, %rcx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          %r11, %r15
    mov          %r12, %rcx
    mov          %r12, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r12, %rbx
    push         %r12
    xor          %r13, %rdx
    shrd         $(34), %r12, %r12
    and          %r13, %rbx
    and          %r14, %rdx
    xor          %r12, %rcx
    shrd         $(5), %r12, %r12
    xor          %rbx, %rdx
    xor          %r12, %rcx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r11
    add          (616)(%rbp), %r10
    add          (104)(%rsp), %r10
    mov          %r15, %rcx
    mov          %r15, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r15, %rbx
    push         %r15
    not          %rdx
    shrd         $(18), %r15, %r15
    and          %r8, %rbx
    and          %r9, %rdx
    xor          %r15, %rcx
    shrd         $(23), %r15, %r15
    xor          %rbx, %rdx
    xor          %r15, %rcx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          %r10, %r14
    mov          %r11, %rcx
    mov          %r11, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r11, %rbx
    push         %r11
    xor          %r12, %rdx
    shrd         $(34), %r11, %r11
    and          %r12, %rbx
    and          %r13, %rdx
    xor          %r11, %rcx
    shrd         $(5), %r11, %r11
    xor          %rbx, %rdx
    xor          %r11, %rcx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r10
    add          (624)(%rbp), %r9
    add          (112)(%rsp), %r9
    mov          %r14, %rcx
    mov          %r14, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r14, %rbx
    push         %r14
    not          %rdx
    shrd         $(18), %r14, %r14
    and          %r15, %rbx
    and          %r8, %rdx
    xor          %r14, %rcx
    shrd         $(23), %r14, %r14
    xor          %rbx, %rdx
    xor          %r14, %rcx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          %r9, %r13
    mov          %r10, %rcx
    mov          %r10, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r10, %rbx
    push         %r10
    xor          %r11, %rdx
    shrd         $(34), %r10, %r10
    and          %r11, %rbx
    and          %r12, %rdx
    xor          %r10, %rcx
    shrd         $(5), %r10, %r10
    xor          %rbx, %rdx
    xor          %r10, %rcx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r9
    add          (632)(%rbp), %r8
    add          (120)(%rsp), %r8
    mov          %r13, %rcx
    mov          %r13, %rdx
    shrd         $(14), %rcx, %rcx
    mov          %r13, %rbx
    push         %r13
    not          %rdx
    shrd         $(18), %r13, %r13
    and          %r14, %rbx
    and          %r15, %rdx
    xor          %r13, %rcx
    shrd         $(23), %r13, %r13
    xor          %rbx, %rdx
    xor          %r13, %rcx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, %r12
    mov          %r9, %rcx
    mov          %r9, %rdx
    shrd         $(28), %rcx, %rcx
    mov          %r9, %rbx
    push         %r9
    xor          %r10, %rdx
    shrd         $(34), %r9, %r9
    and          %r10, %rbx
    and          %r11, %rdx
    xor          %r9, %rcx
    shrd         $(5), %r9, %r9
    xor          %rbx, %rdx
    xor          %r9, %rcx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %rbx, %r8
    add          %r8, (%rdi)
    add          %r9, (8)(%rdi)
    add          %r10, (16)(%rdi)
    add          %r11, (24)(%rdi)
    add          %r12, (32)(%rdi)
    add          %r13, (40)(%rdi)
    add          %r14, (48)(%rdi)
    add          %r15, (56)(%rdi)
    add          $(128), %rsi
    subq         $(128), (128)(%rsp)
    jg           .Lsha512_block_loopgas_1
    add          $(152), %rsp
 
    pop          %rbp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
