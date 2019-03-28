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
.p2align 6, 0x90
 
.globl n0_ARCFourProcessData
.type n0_ARCFourProcessData, @function
 
n0_ARCFourProcessData:
 
    push         %rbx
 
    push         %rbp
 
    movslq       %edx, %r8
    test         %r8, %r8
    mov          %rcx, %rbp
    jz           .Lquitgas_1
    movzbq       (4)(%rbp), %rax
    movzbq       (8)(%rbp), %rbx
    lea          (12)(%rbp), %rbp
    add          $(1), %rax
    movzbq       %al, %rax
    movzbq       (%rbp,%rax,4), %rcx
.p2align 6, 0x90
.Lmain_loopgas_1: 
    add          %rcx, %rbx
    movzbq       %bl, %rbx
    add          $(1), %rdi
    add          $(1), %rsi
    movzbq       (%rbp,%rbx,4), %rdx
    movl         %ecx, (%rbp,%rbx,4)
    add          %rdx, %rcx
    movzbq       %cl, %rcx
    movl         %edx, (%rbp,%rax,4)
    movb         (%rbp,%rcx,4), %dl
    add          $(1), %rax
    movzbq       %al, %rax
    xorb         (-1)(%rdi), %dl
    sub          $(1), %r8
    movzbq       (%rbp,%rax,4), %rcx
    movb         %dl, (-1)(%rsi)
    jne          .Lmain_loopgas_1
    lea          (-12)(%rbp), %rbp
    sub          $(1), %rax
    movzbq       %al, %rax
    movl         %eax, (4)(%rbp)
    movl         %ebx, (8)(%rbp)
.Lquitgas_1: 
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.Lfe1:
.size n0_ARCFourProcessData, .Lfe1-(n0_ARCFourProcessData)
 
