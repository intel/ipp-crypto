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
.p2align 4, 0x90
 
.globl UpdateSHA256
.type UpdateSHA256, @function
 
UpdateSHA256:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(80), %rsp
 
    movslq       %edx, %rdx
    movq         %rdx, (64)(%rsp)
.Lsha256_block_loopgas_1: 
    xor          %rcx, %rcx
.Lloop1gas_1: 
    mov          (%rsi,%rcx,4), %r8d
    bswap        %r8d
    mov          %r8d, (%rsp,%rcx,4)
    mov          (4)(%rsi,%rcx,4), %r9d
    bswap        %r9d
    mov          %r9d, (4)(%rsp,%rcx,4)
    add          $(2), %rcx
    cmp          $(16), %rcx
    jl           .Lloop1gas_1
    mov          (%rdi), %r8d
    mov          (4)(%rdi), %r9d
    mov          (8)(%rdi), %r10d
    mov          (12)(%rdi), %r11d
    mov          (16)(%rdi), %r12d
    mov          (20)(%rdi), %r13d
    mov          (24)(%rdi), %r14d
    mov          (28)(%rdi), %r15d
    add          $(1116352408), %r15d
    add          (%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (4)(%rsp), %eax
    mov          (56)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (4)(%rsp), %ecx
    mov          (56)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (%rsp), %eax
    add          (36)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (%rsp)
    add          $(1899447441), %r14d
    add          (4)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (8)(%rsp), %eax
    mov          (60)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (8)(%rsp), %ecx
    mov          (60)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (4)(%rsp), %eax
    add          (40)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (4)(%rsp)
    add          $(3049323471), %r13d
    add          (8)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (12)(%rsp), %eax
    mov          (%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (12)(%rsp), %ecx
    mov          (%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (8)(%rsp), %eax
    add          (44)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (8)(%rsp)
    add          $(3921009573), %r12d
    add          (12)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (16)(%rsp), %eax
    mov          (4)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (16)(%rsp), %ecx
    mov          (4)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (12)(%rsp), %eax
    add          (48)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (12)(%rsp)
    add          $(961987163), %r11d
    add          (16)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (20)(%rsp), %eax
    mov          (8)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (20)(%rsp), %ecx
    mov          (8)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (16)(%rsp), %eax
    add          (52)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (16)(%rsp)
    add          $(1508970993), %r10d
    add          (20)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (24)(%rsp), %eax
    mov          (12)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (24)(%rsp), %ecx
    mov          (12)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (20)(%rsp), %eax
    add          (56)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (20)(%rsp)
    add          $(2453635748), %r9d
    add          (24)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (28)(%rsp), %eax
    mov          (16)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (28)(%rsp), %ecx
    mov          (16)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (24)(%rsp), %eax
    add          (60)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (24)(%rsp)
    add          $(2870763221), %r8d
    add          (28)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (32)(%rsp), %eax
    mov          (20)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (32)(%rsp), %ecx
    mov          (20)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (28)(%rsp), %eax
    add          (%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (28)(%rsp)
    add          $(3624381080), %r15d
    add          (32)(%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (36)(%rsp), %eax
    mov          (24)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (36)(%rsp), %ecx
    mov          (24)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (32)(%rsp), %eax
    add          (4)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (32)(%rsp)
    add          $(310598401), %r14d
    add          (36)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (40)(%rsp), %eax
    mov          (28)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (40)(%rsp), %ecx
    mov          (28)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (36)(%rsp), %eax
    add          (8)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (36)(%rsp)
    add          $(607225278), %r13d
    add          (40)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (44)(%rsp), %eax
    mov          (32)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (44)(%rsp), %ecx
    mov          (32)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (40)(%rsp), %eax
    add          (12)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (40)(%rsp)
    add          $(1426881987), %r12d
    add          (44)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (48)(%rsp), %eax
    mov          (36)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (48)(%rsp), %ecx
    mov          (36)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (44)(%rsp), %eax
    add          (16)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (44)(%rsp)
    add          $(1925078388), %r11d
    add          (48)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (52)(%rsp), %eax
    mov          (40)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (52)(%rsp), %ecx
    mov          (40)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (48)(%rsp), %eax
    add          (20)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (48)(%rsp)
    add          $(2162078206), %r10d
    add          (52)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (56)(%rsp), %eax
    mov          (44)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (56)(%rsp), %ecx
    mov          (44)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (52)(%rsp), %eax
    add          (24)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (52)(%rsp)
    add          $(2614888103), %r9d
    add          (56)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (60)(%rsp), %eax
    mov          (48)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (60)(%rsp), %ecx
    mov          (48)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (56)(%rsp), %eax
    add          (28)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (56)(%rsp)
    add          $(3248222580), %r8d
    add          (60)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (%rsp), %eax
    mov          (52)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (%rsp), %ecx
    mov          (52)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (60)(%rsp), %eax
    add          (32)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (60)(%rsp)
    add          $(3835390401), %r15d
    add          (%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (4)(%rsp), %eax
    mov          (56)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (4)(%rsp), %ecx
    mov          (56)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (%rsp), %eax
    add          (36)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (%rsp)
    add          $(4022224774), %r14d
    add          (4)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (8)(%rsp), %eax
    mov          (60)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (8)(%rsp), %ecx
    mov          (60)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (4)(%rsp), %eax
    add          (40)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (4)(%rsp)
    add          $(264347078), %r13d
    add          (8)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (12)(%rsp), %eax
    mov          (%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (12)(%rsp), %ecx
    mov          (%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (8)(%rsp), %eax
    add          (44)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (8)(%rsp)
    add          $(604807628), %r12d
    add          (12)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (16)(%rsp), %eax
    mov          (4)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (16)(%rsp), %ecx
    mov          (4)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (12)(%rsp), %eax
    add          (48)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (12)(%rsp)
    add          $(770255983), %r11d
    add          (16)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (20)(%rsp), %eax
    mov          (8)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (20)(%rsp), %ecx
    mov          (8)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (16)(%rsp), %eax
    add          (52)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (16)(%rsp)
    add          $(1249150122), %r10d
    add          (20)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (24)(%rsp), %eax
    mov          (12)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (24)(%rsp), %ecx
    mov          (12)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (20)(%rsp), %eax
    add          (56)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (20)(%rsp)
    add          $(1555081692), %r9d
    add          (24)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (28)(%rsp), %eax
    mov          (16)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (28)(%rsp), %ecx
    mov          (16)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (24)(%rsp), %eax
    add          (60)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (24)(%rsp)
    add          $(1996064986), %r8d
    add          (28)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (32)(%rsp), %eax
    mov          (20)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (32)(%rsp), %ecx
    mov          (20)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (28)(%rsp), %eax
    add          (%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (28)(%rsp)
    add          $(2554220882), %r15d
    add          (32)(%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (36)(%rsp), %eax
    mov          (24)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (36)(%rsp), %ecx
    mov          (24)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (32)(%rsp), %eax
    add          (4)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (32)(%rsp)
    add          $(2821834349), %r14d
    add          (36)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (40)(%rsp), %eax
    mov          (28)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (40)(%rsp), %ecx
    mov          (28)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (36)(%rsp), %eax
    add          (8)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (36)(%rsp)
    add          $(2952996808), %r13d
    add          (40)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (44)(%rsp), %eax
    mov          (32)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (44)(%rsp), %ecx
    mov          (32)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (40)(%rsp), %eax
    add          (12)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (40)(%rsp)
    add          $(3210313671), %r12d
    add          (44)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (48)(%rsp), %eax
    mov          (36)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (48)(%rsp), %ecx
    mov          (36)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (44)(%rsp), %eax
    add          (16)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (44)(%rsp)
    add          $(3336571891), %r11d
    add          (48)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (52)(%rsp), %eax
    mov          (40)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (52)(%rsp), %ecx
    mov          (40)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (48)(%rsp), %eax
    add          (20)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (48)(%rsp)
    add          $(3584528711), %r10d
    add          (52)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (56)(%rsp), %eax
    mov          (44)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (56)(%rsp), %ecx
    mov          (44)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (52)(%rsp), %eax
    add          (24)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (52)(%rsp)
    add          $(113926993), %r9d
    add          (56)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (60)(%rsp), %eax
    mov          (48)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (60)(%rsp), %ecx
    mov          (48)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (56)(%rsp), %eax
    add          (28)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (56)(%rsp)
    add          $(338241895), %r8d
    add          (60)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (%rsp), %eax
    mov          (52)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (%rsp), %ecx
    mov          (52)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (60)(%rsp), %eax
    add          (32)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (60)(%rsp)
    add          $(666307205), %r15d
    add          (%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (4)(%rsp), %eax
    mov          (56)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (4)(%rsp), %ecx
    mov          (56)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (%rsp), %eax
    add          (36)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (%rsp)
    add          $(773529912), %r14d
    add          (4)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (8)(%rsp), %eax
    mov          (60)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (8)(%rsp), %ecx
    mov          (60)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (4)(%rsp), %eax
    add          (40)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (4)(%rsp)
    add          $(1294757372), %r13d
    add          (8)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (12)(%rsp), %eax
    mov          (%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (12)(%rsp), %ecx
    mov          (%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (8)(%rsp), %eax
    add          (44)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (8)(%rsp)
    add          $(1396182291), %r12d
    add          (12)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (16)(%rsp), %eax
    mov          (4)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (16)(%rsp), %ecx
    mov          (4)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (12)(%rsp), %eax
    add          (48)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (12)(%rsp)
    add          $(1695183700), %r11d
    add          (16)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (20)(%rsp), %eax
    mov          (8)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (20)(%rsp), %ecx
    mov          (8)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (16)(%rsp), %eax
    add          (52)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (16)(%rsp)
    add          $(1986661051), %r10d
    add          (20)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (24)(%rsp), %eax
    mov          (12)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (24)(%rsp), %ecx
    mov          (12)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (20)(%rsp), %eax
    add          (56)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (20)(%rsp)
    add          $(2177026350), %r9d
    add          (24)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (28)(%rsp), %eax
    mov          (16)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (28)(%rsp), %ecx
    mov          (16)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (24)(%rsp), %eax
    add          (60)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (24)(%rsp)
    add          $(2456956037), %r8d
    add          (28)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (32)(%rsp), %eax
    mov          (20)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (32)(%rsp), %ecx
    mov          (20)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (28)(%rsp), %eax
    add          (%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (28)(%rsp)
    add          $(2730485921), %r15d
    add          (32)(%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    mov          (36)(%rsp), %eax
    mov          (24)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (36)(%rsp), %ecx
    mov          (24)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (32)(%rsp), %eax
    add          (4)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (32)(%rsp)
    add          $(2820302411), %r14d
    add          (36)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    mov          (40)(%rsp), %eax
    mov          (28)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (40)(%rsp), %ecx
    mov          (28)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (36)(%rsp), %eax
    add          (8)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (36)(%rsp)
    add          $(3259730800), %r13d
    add          (40)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    mov          (44)(%rsp), %eax
    mov          (32)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (44)(%rsp), %ecx
    mov          (32)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (40)(%rsp), %eax
    add          (12)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (40)(%rsp)
    add          $(3345764771), %r12d
    add          (44)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    mov          (48)(%rsp), %eax
    mov          (36)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (48)(%rsp), %ecx
    mov          (36)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (44)(%rsp), %eax
    add          (16)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (44)(%rsp)
    add          $(3516065817), %r11d
    add          (48)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    mov          (52)(%rsp), %eax
    mov          (40)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (52)(%rsp), %ecx
    mov          (40)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (48)(%rsp), %eax
    add          (20)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (48)(%rsp)
    add          $(3600352804), %r10d
    add          (52)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    mov          (56)(%rsp), %eax
    mov          (44)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (56)(%rsp), %ecx
    mov          (44)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (52)(%rsp), %eax
    add          (24)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (52)(%rsp)
    add          $(4094571909), %r9d
    add          (56)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    mov          (60)(%rsp), %eax
    mov          (48)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (60)(%rsp), %ecx
    mov          (48)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (56)(%rsp), %eax
    add          (28)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (56)(%rsp)
    add          $(275423344), %r8d
    add          (60)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    mov          (%rsp), %eax
    mov          (52)(%rsp), %ebx
    shr          $(3), %eax
    shr          $(10), %ebx
    mov          (%rsp), %ecx
    mov          (52)(%rsp), %edx
    ror          $(7), %ecx
    ror          $(17), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    ror          $(11), %ecx
    ror          $(2), %edx
    xor          %ecx, %eax
    xor          %edx, %ebx
    add          (60)(%rsp), %eax
    add          (32)(%rsp), %ebx
    add          %ebx, %eax
    mov          %eax, (60)(%rsp)
    add          $(430227734), %r15d
    add          (%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          $(506948616), %r14d
    add          (4)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          $(659060556), %r13d
    add          (8)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          $(883997877), %r12d
    add          (12)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          $(958139571), %r11d
    add          (16)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          $(1322822218), %r10d
    add          (20)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          $(1537002063), %r9d
    add          (24)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          $(1747873779), %r8d
    add          (28)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          $(1955562222), %r15d
    add          (32)(%rsp), %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(6), %ecx
    mov          %r12d, %ebx
    push         %r12
    not          %edx
    ror          $(11), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(14), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          %r15d, %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(2), %ecx
    mov          %r8d, %ebx
    push         %r8
    xor          %r9d, %edx
    ror          $(13), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(9), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r15d
    add          $(2024104815), %r14d
    add          (36)(%rsp), %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(6), %ecx
    mov          %r11d, %ebx
    push         %r11
    not          %edx
    ror          $(11), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(14), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          %r14d, %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(2), %ecx
    mov          %r15d, %ebx
    push         %r15
    xor          %r8d, %edx
    ror          $(13), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(9), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r14d
    add          $(2227730452), %r13d
    add          (40)(%rsp), %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(6), %ecx
    mov          %r10d, %ebx
    push         %r10
    not          %edx
    ror          $(11), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(14), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          %r13d, %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(2), %ecx
    mov          %r14d, %ebx
    push         %r14
    xor          %r15d, %edx
    ror          $(13), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(9), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r13d
    add          $(2361852424), %r12d
    add          (44)(%rsp), %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(6), %ecx
    mov          %r9d, %ebx
    push         %r9
    not          %edx
    ror          $(11), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(14), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          %r12d, %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(2), %ecx
    mov          %r13d, %ebx
    push         %r13
    xor          %r14d, %edx
    ror          $(13), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(9), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r12d
    add          $(2428436474), %r11d
    add          (48)(%rsp), %r11d
    mov          %r8d, %ecx
    mov          %r8d, %edx
    ror          $(6), %ecx
    mov          %r8d, %ebx
    push         %r8
    not          %edx
    ror          $(11), %r8d
    and          %r9d, %ebx
    and          %r10d, %edx
    xor          %r8d, %ecx
    ror          $(14), %r8d
    xor          %ebx, %edx
    xor          %r8d, %ecx
    pop          %r8
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          %r11d, %r15d
    mov          %r12d, %ecx
    mov          %r12d, %edx
    ror          $(2), %ecx
    mov          %r12d, %ebx
    push         %r12
    xor          %r13d, %edx
    ror          $(13), %r12d
    and          %r13d, %ebx
    and          %r14d, %edx
    xor          %r12d, %ecx
    ror          $(9), %r12d
    xor          %ebx, %edx
    xor          %r12d, %ecx
    pop          %r12
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r11d
    add          $(2756734187), %r10d
    add          (52)(%rsp), %r10d
    mov          %r15d, %ecx
    mov          %r15d, %edx
    ror          $(6), %ecx
    mov          %r15d, %ebx
    push         %r15
    not          %edx
    ror          $(11), %r15d
    and          %r8d, %ebx
    and          %r9d, %edx
    xor          %r15d, %ecx
    ror          $(14), %r15d
    xor          %ebx, %edx
    xor          %r15d, %ecx
    pop          %r15
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          %r10d, %r14d
    mov          %r11d, %ecx
    mov          %r11d, %edx
    ror          $(2), %ecx
    mov          %r11d, %ebx
    push         %r11
    xor          %r12d, %edx
    ror          $(13), %r11d
    and          %r12d, %ebx
    and          %r13d, %edx
    xor          %r11d, %ecx
    ror          $(9), %r11d
    xor          %ebx, %edx
    xor          %r11d, %ecx
    pop          %r11
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r10d
    add          $(3204031479), %r9d
    add          (56)(%rsp), %r9d
    mov          %r14d, %ecx
    mov          %r14d, %edx
    ror          $(6), %ecx
    mov          %r14d, %ebx
    push         %r14
    not          %edx
    ror          $(11), %r14d
    and          %r15d, %ebx
    and          %r8d, %edx
    xor          %r14d, %ecx
    ror          $(14), %r14d
    xor          %ebx, %edx
    xor          %r14d, %ecx
    pop          %r14
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          %r9d, %r13d
    mov          %r10d, %ecx
    mov          %r10d, %edx
    ror          $(2), %ecx
    mov          %r10d, %ebx
    push         %r10
    xor          %r11d, %edx
    ror          $(13), %r10d
    and          %r11d, %ebx
    and          %r12d, %edx
    xor          %r10d, %ecx
    ror          $(9), %r10d
    xor          %ebx, %edx
    xor          %r10d, %ecx
    pop          %r10
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r9d
    add          $(3329325298), %r8d
    add          (60)(%rsp), %r8d
    mov          %r13d, %ecx
    mov          %r13d, %edx
    ror          $(6), %ecx
    mov          %r13d, %ebx
    push         %r13
    not          %edx
    ror          $(11), %r13d
    and          %r14d, %ebx
    and          %r15d, %edx
    xor          %r13d, %ecx
    ror          $(14), %r13d
    xor          %ebx, %edx
    xor          %r13d, %ecx
    pop          %r13
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, %r12d
    mov          %r9d, %ecx
    mov          %r9d, %edx
    ror          $(2), %ecx
    mov          %r9d, %ebx
    push         %r9
    xor          %r10d, %edx
    ror          $(13), %r9d
    and          %r10d, %ebx
    and          %r11d, %edx
    xor          %r9d, %ecx
    ror          $(9), %r9d
    xor          %ebx, %edx
    xor          %r9d, %ecx
    pop          %r9
    lea          (%rdx,%rcx), %rbx
    add          %ebx, %r8d
    add          %r8d, (%rdi)
    add          %r9d, (4)(%rdi)
    add          %r10d, (8)(%rdi)
    add          %r11d, (12)(%rdi)
    add          %r12d, (16)(%rdi)
    add          %r13d, (20)(%rdi)
    add          %r14d, (24)(%rdi)
    add          %r15d, (28)(%rdi)
    add          $(64), %rsi
    subq         $(64), (64)(%rsp)
    jg           .Lsha256_block_loopgas_1
    add          $(80), %rsp
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lfe1:
.size UpdateSHA256, .Lfe1-(UpdateSHA256)
 
