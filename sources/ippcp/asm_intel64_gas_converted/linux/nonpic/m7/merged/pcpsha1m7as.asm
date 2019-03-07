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
 
.globl m7_UpdateSHA1
.type m7_UpdateSHA1, @function
 
m7_UpdateSHA1:
 
    push         %rbx
 
    push         %r12
 
    push         %r13
 
    sub          $(64), %rsp
 
    movslq       %edx, %rdx
.Lsha1_block_loopgas_1: 
    mov          (%rdi), %r8d
    mov          (4)(%rdi), %r9d
    mov          (8)(%rdi), %r10d
    mov          (12)(%rdi), %r11d
    mov          (16)(%rdi), %r12d
    xor          %rcx, %rcx
.Lloop1gas_1: 
    mov          (%rsi,%rcx,4), %eax
    bswap        %eax
    mov          %eax, (%rsp,%rcx,4)
    mov          (4)(%rsi,%rcx,4), %ebx
    bswap        %ebx
    mov          %ebx, (4)(%rsp,%rcx,4)
    add          $(2), %rcx
    cmp          $(16), %rcx
    jl           .Lloop1gas_1
 
    mov          $(1518500249), %r13d
    mov          %r10d, %ebx
    xor          %r11d, %ebx
    and          %r9d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (52)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r9d, %ebx
    xor          %r10d, %ebx
    and          %r8d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (4)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (4)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (56)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (4)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r8d, %ebx
    xor          %r9d, %ebx
    and          %r12d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (8)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (8)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (60)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (8)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r12d, %ebx
    xor          %r8d, %ebx
    and          %r11d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (12)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (12)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (12)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r11d, %ebx
    xor          %r12d, %ebx
    and          %r10d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (16)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (16)(%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (4)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (16)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r10d, %ebx
    xor          %r11d, %ebx
    and          %r9d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (20)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (20)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (8)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (20)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r9d, %ebx
    xor          %r10d, %ebx
    and          %r8d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (24)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (24)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (12)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (24)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r8d, %ebx
    xor          %r9d, %ebx
    and          %r12d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (28)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (28)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (16)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (28)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r12d, %ebx
    xor          %r8d, %ebx
    and          %r11d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (32)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (32)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (20)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (32)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r11d, %ebx
    xor          %r12d, %ebx
    and          %r10d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (36)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (36)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (24)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (36)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r10d, %ebx
    xor          %r11d, %ebx
    and          %r9d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (40)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (40)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (28)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (40)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r9d, %ebx
    xor          %r10d, %ebx
    and          %r8d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (44)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (44)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (32)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (44)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r8d, %ebx
    xor          %r9d, %ebx
    and          %r12d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (48)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (48)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (36)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (48)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r12d, %ebx
    xor          %r8d, %ebx
    and          %r11d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (52)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (52)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (40)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (52)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r11d, %ebx
    xor          %r12d, %ebx
    and          %r10d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (56)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (56)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (44)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (56)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r10d, %ebx
    xor          %r11d, %ebx
    and          %r9d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (60)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (60)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (48)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (60)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r9d, %ebx
    xor          %r10d, %ebx
    and          %r8d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (52)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r8d, %ebx
    xor          %r9d, %ebx
    and          %r12d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (4)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (4)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (56)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (4)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r12d, %ebx
    xor          %r8d, %ebx
    and          %r11d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (8)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (8)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (60)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (8)(%rsp)
 
    mov          $(1518500249), %r13d
    mov          %r11d, %ebx
    xor          %r12d, %ebx
    and          %r10d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (12)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (12)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (12)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (16)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (16)(%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (4)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (16)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (20)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (20)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (8)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (20)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (24)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (24)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (12)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (24)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (28)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (28)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (16)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (28)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (32)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (32)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (20)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (32)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (36)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (36)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (24)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (36)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (40)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (40)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (28)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (40)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (44)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (44)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (32)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (44)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (48)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (48)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (36)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (48)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (52)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (52)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (40)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (52)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (56)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (56)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (44)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (56)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (60)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (60)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (48)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (60)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (52)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (4)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (4)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (56)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (4)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (8)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (8)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (60)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (8)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (12)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (12)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (12)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (16)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (16)(%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (4)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (16)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (20)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (20)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (8)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (20)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (24)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (24)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (12)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (24)(%rsp)
 
    mov          $(1859775393), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (28)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (28)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (16)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (28)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r9d, %ebx
    mov          %r9d, %ecx
    or           %r10d, %ebx
    and          %r10d, %ecx
    and          %r11d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (32)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (32)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (20)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (32)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r8d, %ebx
    mov          %r8d, %ecx
    or           %r9d, %ebx
    and          %r9d, %ecx
    and          %r10d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (36)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (36)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (24)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (36)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r12d, %ebx
    mov          %r12d, %ecx
    or           %r8d, %ebx
    and          %r8d, %ecx
    and          %r9d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (40)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (40)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (28)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (40)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r11d, %ebx
    mov          %r11d, %ecx
    or           %r12d, %ebx
    and          %r12d, %ecx
    and          %r8d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (44)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (44)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (32)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (44)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r10d, %ebx
    mov          %r10d, %ecx
    or           %r11d, %ebx
    and          %r11d, %ecx
    and          %r12d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (48)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (48)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (36)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (48)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r9d, %ebx
    mov          %r9d, %ecx
    or           %r10d, %ebx
    and          %r10d, %ecx
    and          %r11d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (52)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (52)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (40)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (52)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r8d, %ebx
    mov          %r8d, %ecx
    or           %r9d, %ebx
    and          %r9d, %ecx
    and          %r10d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (56)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (56)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (44)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (56)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r12d, %ebx
    mov          %r12d, %ecx
    or           %r8d, %ebx
    and          %r8d, %ecx
    and          %r9d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (60)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (60)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (48)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (60)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r11d, %ebx
    mov          %r11d, %ecx
    or           %r12d, %ebx
    and          %r12d, %ecx
    and          %r8d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (52)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r10d, %ebx
    mov          %r10d, %ecx
    or           %r11d, %ebx
    and          %r11d, %ecx
    and          %r12d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (4)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (4)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (56)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (4)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r9d, %ebx
    mov          %r9d, %ecx
    or           %r10d, %ebx
    and          %r10d, %ecx
    and          %r11d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (8)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (8)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (60)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (8)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r8d, %ebx
    mov          %r8d, %ecx
    or           %r9d, %ebx
    and          %r9d, %ecx
    and          %r10d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (12)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (12)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (12)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r12d, %ebx
    mov          %r12d, %ecx
    or           %r8d, %ebx
    and          %r8d, %ecx
    and          %r9d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (16)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (16)(%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (4)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (16)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r11d, %ebx
    mov          %r11d, %ecx
    or           %r12d, %ebx
    and          %r12d, %ecx
    and          %r8d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (20)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (20)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (8)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (20)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r10d, %ebx
    mov          %r10d, %ecx
    or           %r11d, %ebx
    and          %r11d, %ecx
    and          %r12d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (24)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (24)(%rsp), %eax
    xor          (32)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (12)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (24)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r9d, %ebx
    mov          %r9d, %ecx
    or           %r10d, %ebx
    and          %r10d, %ecx
    and          %r11d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (28)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (28)(%rsp), %eax
    xor          (36)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (16)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (28)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r8d, %ebx
    mov          %r8d, %ecx
    or           %r9d, %ebx
    and          %r9d, %ecx
    and          %r10d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (32)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (32)(%rsp), %eax
    xor          (40)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (20)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (32)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r12d, %ebx
    mov          %r12d, %ecx
    or           %r8d, %ebx
    and          %r8d, %ecx
    and          %r9d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (36)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (36)(%rsp), %eax
    xor          (44)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (24)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (36)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r11d, %ebx
    mov          %r11d, %ecx
    or           %r12d, %ebx
    and          %r12d, %ecx
    and          %r8d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (40)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (40)(%rsp), %eax
    xor          (48)(%rsp), %eax
    xor          (8)(%rsp), %eax
    xor          (28)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (40)(%rsp)
 
    mov          $(2400959708), %r13d
    mov          %r10d, %ebx
    mov          %r10d, %ecx
    or           %r11d, %ebx
    and          %r11d, %ecx
    and          %r12d, %ebx
    or           %ecx, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (44)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    mov          (44)(%rsp), %eax
    xor          (52)(%rsp), %eax
    xor          (12)(%rsp), %eax
    xor          (32)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (44)(%rsp)
 
    mov          $(3395469782), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (48)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
    mov          (48)(%rsp), %eax
    xor          (56)(%rsp), %eax
    xor          (16)(%rsp), %eax
    xor          (36)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (48)(%rsp)
 
    mov          $(3395469782), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (52)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
    mov          (52)(%rsp), %eax
    xor          (60)(%rsp), %eax
    xor          (20)(%rsp), %eax
    xor          (40)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (52)(%rsp)
 
    mov          $(3395469782), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (56)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
    mov          (56)(%rsp), %eax
    xor          (%rsp), %eax
    xor          (24)(%rsp), %eax
    xor          (44)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (56)(%rsp)
 
    mov          $(3395469782), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (60)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
    mov          (60)(%rsp), %eax
    xor          (4)(%rsp), %eax
    xor          (28)(%rsp), %eax
    xor          (48)(%rsp), %eax
    rol          $(1), %eax
    mov          %eax, (60)(%rsp)
 
    mov          $(3395469782), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
 
    mov          $(3395469782), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (4)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
 
    mov          $(3395469782), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (8)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
 
    mov          $(3395469782), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (12)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
 
    mov          $(3395469782), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (16)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
 
    mov          $(3395469782), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (20)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
 
    mov          $(3395469782), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (24)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
 
    mov          $(3395469782), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (28)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
 
    mov          $(3395469782), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (32)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
 
    mov          $(3395469782), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (36)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
 
    mov          $(3395469782), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (40)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
 
    mov          $(3395469782), %r13d
    mov          %r11d, %ebx
    xor          %r10d, %ebx
    xor          %r9d, %ebx
    ror          $(2), %r9d
    mov          %r8d, %ecx
    rol          $(5), %ecx
    add          (44)(%rsp), %r12d
    add          %ebx, %r13d
    add          %r13d, %r12d
    add          %ecx, %r12d
 
    mov          $(3395469782), %r13d
    mov          %r10d, %ebx
    xor          %r9d, %ebx
    xor          %r8d, %ebx
    ror          $(2), %r8d
    mov          %r12d, %ecx
    rol          $(5), %ecx
    add          (48)(%rsp), %r11d
    add          %ebx, %r13d
    add          %r13d, %r11d
    add          %ecx, %r11d
 
    mov          $(3395469782), %r13d
    mov          %r9d, %ebx
    xor          %r8d, %ebx
    xor          %r12d, %ebx
    ror          $(2), %r12d
    mov          %r11d, %ecx
    rol          $(5), %ecx
    add          (52)(%rsp), %r10d
    add          %ebx, %r13d
    add          %r13d, %r10d
    add          %ecx, %r10d
 
    mov          $(3395469782), %r13d
    mov          %r8d, %ebx
    xor          %r12d, %ebx
    xor          %r11d, %ebx
    ror          $(2), %r11d
    mov          %r10d, %ecx
    rol          $(5), %ecx
    add          (56)(%rsp), %r9d
    add          %ebx, %r13d
    add          %r13d, %r9d
    add          %ecx, %r9d
 
    mov          $(3395469782), %r13d
    mov          %r12d, %ebx
    xor          %r11d, %ebx
    xor          %r10d, %ebx
    ror          $(2), %r10d
    mov          %r9d, %ecx
    rol          $(5), %ecx
    add          (60)(%rsp), %r8d
    add          %ebx, %r13d
    add          %r13d, %r8d
    add          %ecx, %r8d
    add          %r8d, (%rdi)
    add          %r9d, (4)(%rdi)
    add          %r10d, (8)(%rdi)
    add          %r11d, (12)(%rdi)
    add          %r12d, (16)(%rdi)
    add          $(64), %rsi
    sub          $(64), %rdx
    jg           .Lsha1_block_loopgas_1
    add          $(64), %rsp
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lfe1:
.size m7_UpdateSHA1, .Lfe1-(m7_UpdateSHA1)
 
