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
 
.globl cpAddMulDgt_BNU
.type cpAddMulDgt_BNU, @function
 
cpAddMulDgt_BNU:
 
    push         %rbx
 
    push         %r12
 
    mov          %edx, %edx
    movq         (%rsi), %rax
    cmp          $(1), %rdx
    jnz          .Lgeneral_casegas_1
    mul          %rcx
    addq         %rax, (%rdi)
    adc          $(0), %rdx
    mov          %rdx, %rax
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lgeneral_casegas_1: 
    lea          (-40)(%rsi,%rdx,8), %rsi
    lea          (-40)(%rdi,%rdx,8), %rdi
    mov          $(5), %rbx
    sub          %rdx, %rbx
    mul          %rcx
    mov          %rax, %r8
    movq         (8)(%rsi,%rbx,8), %rax
    mov          %rdx, %r9
    cmp          $(0), %rbx
    jge          .Lskip_muladd_loop4gas_1
.p2align 4, 0x90
.Lmuladd_loop4gas_1: 
    mul          %rcx
    xor          %r10, %r10
    addq         %r8, (%rdi,%rbx,8)
    adc          %rax, %r9
    movq         (16)(%rsi,%rbx,8), %rax
    adc          %rdx, %r10
    mul          %rcx
    xor          %r11, %r11
    addq         %r9, (8)(%rdi,%rbx,8)
    adc          %rax, %r10
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %rcx
    xor          %r8, %r8
    addq         %r10, (16)(%rdi,%rbx,8)
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r8
    mul          %rcx
    xor          %r9, %r9
    addq         %r11, (24)(%rdi,%rbx,8)
    adc          %rax, %r8
    movq         (40)(%rsi,%rbx,8), %rax
    adc          %rdx, %r9
    add          $(4), %rbx
    jnc          .Lmuladd_loop4gas_1
.Lskip_muladd_loop4gas_1: 
    mul          %rcx
    xor          %r10, %r10
    addq         %r8, (%rdi,%rbx,8)
    adc          %rax, %r9
    adc          %rdx, %r10
    cmp          $(2), %rbx
    ja           .Lfin_mul1x4n_2gas_1
    jz           .Lfin_mul1x4n_3gas_1
    jp           .Lfin_mul1x4n_4gas_1
.Lfin_mul1x4n_1gas_1: 
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %rcx
    xor          %r11, %r11
    addq         %r9, (8)(%rdi,%rbx,8)
    adc          %rax, %r10
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %rcx
    xor          %r8, %r8
    addq         %r10, (16)(%rdi,%rbx,8)
    adc          %rax, %r11
    movq         (32)(%rsi,%rbx,8), %rax
    adc          %rdx, %r8
    mul          %rcx
    xor          %r9, %r9
    addq         %r11, (24)(%rdi,%rbx,8)
    adc          %rax, %r8
    adc          $(0), %rdx
    addq         %r8, (32)(%rdi,%rbx,8)
    adc          $(0), %rdx
    mov          %rdx, %rax
    jmp          .Lexitgas_1
.Lfin_mul1x4n_4gas_1: 
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %rcx
    xor          %r11, %r11
    addq         %r9, (8)(%rdi,%rbx,8)
    adc          %rax, %r10
    movq         (24)(%rsi,%rbx,8), %rax
    adc          %rdx, %r11
    mul          %rcx
    xor          %r8, %r8
    addq         %r10, (16)(%rdi,%rbx,8)
    adc          %rax, %r11
    adc          $(0), %rdx
    addq         %r11, (24)(%rdi,%rbx,8)
    adc          $(0), %rdx
    mov          %rdx, %rax
    jmp          .Lexitgas_1
.Lfin_mul1x4n_3gas_1: 
    movq         (16)(%rsi,%rbx,8), %rax
    mul          %rcx
    xor          %r11, %r11
    addq         %r9, (8)(%rdi,%rbx,8)
    adc          %rax, %r10
    adc          $(0), %rdx
    addq         %r10, (16)(%rdi,%rbx,8)
    adc          $(0), %rdx
    mov          %rdx, %rax
    jmp          .Lexitgas_1
.Lfin_mul1x4n_2gas_1: 
    addq         %r9, (8)(%rdi,%rbx,8)
    adc          $(0), %r10
    mov          %r10, %rax
.Lexitgas_1: 
 
    pop          %r12
 
    pop          %rbx
 
    ret
.Lfe1:
.size cpAddMulDgt_BNU, .Lfe1-(cpAddMulDgt_BNU)
 
