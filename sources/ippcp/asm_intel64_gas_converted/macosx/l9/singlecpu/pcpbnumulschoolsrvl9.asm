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
 


 
_mla_1x1:
    movq         (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mov          %rbx, %r8
    ret
 
.p2align 5, 0x90
 


 
_mul_1x1:
    movq         (%rcx), %rdx
    mulxq        (%rsi), %rax, %rdx
    movq         %rax, (%rdi)
    movq         %rdx, (8)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_2x2:
    movq         (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mov          %rbp, %r9
    movq         (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mov          %rbp, %r9
    ret
 
.p2align 5, 0x90
 


 
_mul_2x2:
    call         _mla_2x2
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_3x3:
    movq         (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    movq         (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    movq         (16)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (16)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    ret
 
.p2align 5, 0x90
 


 
_mul_3x3:
    call         _mla_3x3
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_4x2:
    movq         (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    movq         (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    ret
 
.p2align 5, 0x90
 


 
_mla_4x4:
    call         _mla_4x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_4x2
    sub          $(16), %rdi
    sub          $(16), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mul_4x4:
    call         _mla_4x4
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_5x2:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    ret
 
.p2align 5, 0x90
 


 
_mla_5x5:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_5x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_5x2
    sub          $(24), %rdi
    sub          $(24), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mul_5x5:
    call         _mla_5x5
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    movq         %r11, (64)(%rdi)
    movq         %r12, (72)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_6x2:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mov          %rbp, %r13
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mov          %rbp, %r13
    ret
 
.p2align 5, 0x90
 


 
_mla_6x6:
    call         _mla_6x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_6x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_6x2
    sub          $(32), %rdi
    sub          $(32), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mul_6x6:
    call         _mla_6x6
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    movq         %r10, (64)(%rdi)
    movq         %r11, (72)(%rdi)
    movq         %r12, (80)(%rdi)
    movq         %r13, (88)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_7x2:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mov          %rbx, %r14
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mov          %rbx, %r14
    ret
 
.p2align 5, 0x90
 


 
_mla_7x7:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mov          %rbx, %r14
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_7x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_7x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_7x2
    sub          $(40), %rdi
    sub          $(40), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mul_7x7:
    call         _mla_7x7
    movq         %r8, (56)(%rdi)
    movq         %r9, (64)(%rdi)
    movq         %r10, (72)(%rdi)
    movq         %r11, (80)(%rdi)
    movq         %r12, (88)(%rdi)
    movq         %r13, (96)(%rdi)
    movq         %r14, (104)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mla_8x1:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (56)(%rsi), %r14, %rbp
    add          %r15, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mov          %rbp, %r15
    ret
 
.p2align 5, 0x90
 


 
_mla_8x2:
    mov          (%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (56)(%rsi), %r14, %rbp
    add          %r15, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mov          %rbp, %r15
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (56)(%rsi), %r14, %rbp
    add          %r15, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mov          %rbp, %r15
    ret
 
.p2align 5, 0x90
 


 
_mla_8x3:
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x2
    sub          $(8), %rdi
    sub          $(8), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mla_8x4:
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(16), %rdi
    sub          $(16), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mla_8x5:
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x4
    sub          $(8), %rdi
    sub          $(8), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mla_8x6:
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x4
    sub          $(16), %rdi
    sub          $(16), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mla_8x7:
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x6
    sub          $(8), %rdi
    sub          $(8), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mla_8x8:
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(48), %rdi
    sub          $(48), %rcx
    ret
 
.p2align 5, 0x90
 


 
_mul_8x8:
    call         _mla_8x8
    movq         %r8, (64)(%rdi)
    movq         %r9, (72)(%rdi)
    movq         %r10, (80)(%rdi)
    movq         %r11, (88)(%rdi)
    movq         %r12, (96)(%rdi)
    movq         %r13, (104)(%rdi)
    movq         %r14, (112)(%rdi)
    movq         %r15, (120)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_9x9:
    call         _mla_8x8
    mov          (64)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (64)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (56)(%rsi), %r14, %rbp
    add          %r15, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mov          %rbp, %r15
    push         %r15
    mov          (64)(%rsi), %rdx
    mov          (64)(%rdi), %r15
    mulx         (%rcx), %rax, %rbx
    add          %r15, %rax
    adc          $(0), %rbx
    mov          %rax, (64)(%rdi)
    mulx         (8)(%rcx), %r15, %rbp
    add          %r8, %r15
    adc          $(0), %rbp
    add          %rbx, %r15
    adc          $(0), %rbp
    mulx         (16)(%rcx), %r8, %rbx
    add          %r9, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (24)(%rcx), %r9, %rbp
    add          %r10, %r9
    adc          $(0), %rbp
    add          %rbx, %r9
    adc          $(0), %rbp
    mulx         (32)(%rcx), %r10, %rbx
    add          %r11, %r10
    adc          $(0), %rbx
    add          %rbp, %r10
    adc          $(0), %rbx
    mulx         (40)(%rcx), %r11, %rbp
    add          %r12, %r11
    adc          $(0), %rbp
    add          %rbx, %r11
    adc          $(0), %rbp
    mulx         (48)(%rcx), %r12, %rbx
    add          %r13, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (56)(%rcx), %r13, %rbp
    add          %r14, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mov          %rbp, %r14
    movq         %r15, (72)(%rdi)
    mulx         (64)(%rcx), %rbp, %r15
    pop          %rax
    add          %rax, %r14
    adc          $(0), %r15
    add          %rbp, %r14
    adc          $(0), %r15
    movq         %r8, (80)(%rdi)
    movq         %r9, (88)(%rdi)
    movq         %r10, (96)(%rdi)
    movq         %r11, (104)(%rdi)
    movq         %r12, (112)(%rdi)
    movq         %r13, (120)(%rdi)
    movq         %r14, (128)(%rdi)
    movq         %r15, (136)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_10x10:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rcx
    call         _mla_8x2
    push         %r15
    push         %r14
    add          $(64), %rsi
    sub          $(64), %rcx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          %r13, %r15
    mov          %r12, %r14
    mov          %r11, %r13
    mov          %r10, %r12
    mov          %r9, %r11
    mov          %r8, %r10
    movq         (8)(%rdi), %r9
    movq         (%rdi), %r8
    call         _mla_8x2
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    movq         %r10, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %r12, (48)(%rdi)
    movq         %r13, (56)(%rdi)
    add          $(64), %rdi
    xor          %r10, %r10
    pop          %r8
    pop          %r9
    add          %r14, %r8
    adc          %r15, %r9
    adc          $(0), %r10
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    add          $(64), %rcx
    call         _mla_2x2
    add          $(16), %rdi
    add          %r10, %r8
    adc          $(0), %r9
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_11x11:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rcx
    call         _mla_8x3
    push         %r15
    push         %r14
    push         %r13
    add          $(64), %rsi
    sub          $(64), %rcx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          %r12, %r15
    mov          %r11, %r14
    mov          %r10, %r13
    mov          %r9, %r12
    mov          %r8, %r11
    movq         (16)(%rdi), %r10
    movq         (8)(%rdi), %r9
    movq         (%rdi), %r8
    call         _mla_8x3
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    movq         %r11, (48)(%rdi)
    movq         %r12, (56)(%rdi)
    add          $(64), %rdi
    xor          %r11, %r11
    pop          %r8
    pop          %r9
    pop          %r10
    add          %r13, %r8
    adc          %r14, %r9
    adc          %r15, %r10
    adc          $(0), %r11
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    add          $(64), %rcx
    call         _mla_3x3
    add          $(24), %rdi
    add          %r11, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_12x12:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rcx
    call         _mla_8x4
    push         %r15
    push         %r14
    push         %r13
    push         %r12
    add          $(64), %rsi
    sub          $(64), %rcx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          %r11, %r15
    mov          %r10, %r14
    mov          %r9, %r13
    mov          %r8, %r12
    movq         (24)(%rdi), %r11
    movq         (16)(%rdi), %r10
    movq         (8)(%rdi), %r9
    movq         (%rdi), %r8
    call         _mla_8x4
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    add          $(64), %rdi
    xor          %rax, %rax
    pop          %r8
    pop          %r9
    pop          %r10
    pop          %r11
    add          %r12, %r8
    adc          %r13, %r9
    adc          %r14, %r10
    adc          %r15, %r11
    adc          $(0), %rax
    push         %rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    add          $(64), %rcx
    call         _mla_4x4
    add          $(32), %rdi
    pop          %rax
    add          %rax, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_13x13:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rcx
    call         _mla_8x5
    push         %r15
    push         %r14
    push         %r13
    push         %r12
    push         %r11
    add          $(64), %rsi
    sub          $(64), %rcx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          %r10, %r15
    mov          %r9, %r14
    mov          %r8, %r13
    movq         (32)(%rdi), %r12
    movq         (24)(%rdi), %r11
    movq         (16)(%rdi), %r10
    movq         (8)(%rdi), %r9
    movq         (%rdi), %r8
    call         _mla_8x5
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    add          $(64), %rdi
    xor          %rax, %rax
    pop          %r8
    pop          %r9
    pop          %r10
    pop          %rbx
    pop          %rbp
    add          %r11, %r8
    adc          %r12, %r9
    adc          %r13, %r10
    adc          %r14, %rbx
    adc          %r15, %rbp
    adc          $(0), %rax
    push         %rax
    mov          %rbx, %r11
    mov          %rbp, %r12
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    add          $(64), %rcx
    call         _mla_5x5
    add          $(40), %rdi
    pop          %rax
    add          %rax, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_14x14:
    call         _mla_7x7
    add          $(56), %rdi
    add          $(56), %rsi
    call         _mla_7x7
    movq         %r8, (56)(%rdi)
    movq         %r9, (64)(%rdi)
    movq         %r10, (72)(%rdi)
    movq         %r11, (80)(%rdi)
    movq         %r12, (88)(%rdi)
    movq         %r13, (96)(%rdi)
    movq         %r14, (104)(%rdi)
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    add          $(56), %rcx
    sub          $(56), %rsi
    call         _mla_7x7
    xor          %rdx, %rdx
    movq         (56)(%rdi), %rax
    add          %rax, %r8
    movq         (64)(%rdi), %rax
    adc          %rax, %r9
    movq         (72)(%rdi), %rax
    adc          %rax, %r10
    movq         (80)(%rdi), %rax
    adc          %rax, %r11
    movq         (88)(%rdi), %rax
    adc          %rax, %r12
    movq         (96)(%rdi), %rax
    adc          %rax, %r13
    movq         (104)(%rdi), %rax
    adc          %rax, %r14
    adc          $(0), %rdx
    push         %rdx
    add          $(56), %rdi
    add          $(56), %rsi
    call         _mla_7x7
    sub          $(112), %rdi
    sub          $(56), %rsi
    sub          $(56), %rcx
    pop          %rdx
    add          %rdx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    movq         %r8, (168)(%rdi)
    movq         %r9, (176)(%rdi)
    movq         %r10, (184)(%rdi)
    movq         %r11, (192)(%rdi)
    movq         %r12, (200)(%rdi)
    movq         %r13, (208)(%rdi)
    movq         %r14, (216)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_15x15:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rcx
    call         _mla_8x7
    movq         %r8, (56)(%rdi)
    movq         %r9, (64)(%rdi)
    movq         %r10, (72)(%rdi)
    movq         %r11, (80)(%rdi)
    movq         %r12, (88)(%rdi)
    movq         %r13, (96)(%rdi)
    movq         %r14, (104)(%rdi)
    movq         %r15, (112)(%rdi)
    add          $(64), %rsi
    sub          $(64), %rcx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mla_8x7
    movq         %r8, (56)(%rdi)
    add          $(64), %rdi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    add          $(64), %rcx
    mov          %r9, %r8
    mov          %r10, %r9
    mov          %r11, %r10
    mov          %r12, %r11
    mov          %r13, %r12
    mov          %r14, %r13
    mov          %r15, %r14
    xor          %rdx, %rdx
    movq         (%rdi), %rax
    add          %rax, %r8
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    adc          $(0), %rdx
    push         %rdx
    call         _mla_7x7
    add          $(56), %rdi
    pop          %rax
    add          %rax, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_mul_16x16:
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_8x8
    movq         %r8, (64)(%rdi)
    movq         %r9, (72)(%rdi)
    movq         %r10, (80)(%rdi)
    movq         %r11, (88)(%rdi)
    movq         %r12, (96)(%rdi)
    movq         %r13, (104)(%rdi)
    movq         %r14, (112)(%rdi)
    movq         %r15, (120)(%rdi)
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    add          $(64), %rcx
    sub          $(64), %rsi
    call         _mla_8x8
    xor          %rdx, %rdx
    movq         (64)(%rdi), %rax
    add          %rax, %r8
    movq         (72)(%rdi), %rax
    adc          %rax, %r9
    movq         (80)(%rdi), %rax
    adc          %rax, %r10
    movq         (88)(%rdi), %rax
    adc          %rax, %r11
    movq         (96)(%rdi), %rax
    adc          %rax, %r12
    movq         (104)(%rdi), %rax
    adc          %rax, %r13
    movq         (112)(%rdi), %rax
    adc          %rax, %r14
    movq         (120)(%rdi), %rax
    adc          %rax, %r15
    adc          $(0), %rdx
    push         %rdx
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_8x8
    sub          $(128), %rdi
    sub          $(64), %rsi
    sub          $(64), %rcx
    pop          %rdx
    add          %rdx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    movq         %r8, (192)(%rdi)
    movq         %r9, (200)(%rdi)
    movq         %r10, (208)(%rdi)
    movq         %r11, (216)(%rdi)
    movq         %r12, (224)(%rdi)
    movq         %r13, (232)(%rdi)
    movq         %r14, (240)(%rdi)
    movq         %r15, (248)(%rdi)
    ret
 
mul_lxl_basic:
.quad  _mul_1x1 - mul_lxl_basic 
 

.quad  _mul_2x2 - mul_lxl_basic 
 

.quad  _mul_3x3 - mul_lxl_basic 
 

.quad  _mul_4x4 - mul_lxl_basic 
 

.quad  _mul_5x5 - mul_lxl_basic 
 

.quad  _mul_6x6 - mul_lxl_basic 
 

.quad  _mul_7x7 - mul_lxl_basic 
 

.quad  _mul_8x8 - mul_lxl_basic 
 

.quad  _mul_9x9 - mul_lxl_basic 
 

.quad  _mul_10x10-mul_lxl_basic 
 

.quad  _mul_11x11-mul_lxl_basic 
 

.quad  _mul_12x12-mul_lxl_basic 
 

.quad  _mul_13x13-mul_lxl_basic 
 

.quad  _mul_14x14-mul_lxl_basic 
 

.quad  _mul_15x15-mul_lxl_basic 
 

.quad  _mul_16x16-mul_lxl_basic 
 
mla_lxl_short:
.quad  _mla_1x1 - mla_lxl_short 
 

.quad  _mla_2x2 - mla_lxl_short 
 

.quad  _mla_3x3 - mla_lxl_short 
 

.quad  _mla_4x4 - mla_lxl_short 
 

.quad  _mla_5x5 - mla_lxl_short 
 

.quad  _mla_6x6 - mla_lxl_short 
 

.quad  _mla_7x7 - mla_lxl_short 
 
mla_8xl_tail:
.quad  _mla_8x1 - mla_8xl_tail 
 

.quad  _mla_8x2 - mla_8xl_tail 
 

.quad  _mla_8x3 - mla_8xl_tail 
 

.quad  _mla_8x4 - mla_8xl_tail 
 

.quad  _mla_8x5 - mla_8xl_tail 
 

.quad  _mla_8x6 - mla_8xl_tail 
 

.quad  _mla_8x7 - mla_8xl_tail 
.p2align 5, 0x90
 


 
_mul_8Nx8M:
    push         %rbx
    push         %rdi
    push         %rsi
    push         %rdx
.Lmul_loopAgas_36: 
    push         %rdx
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rsi
    pop          %rdx
    sub          $(8), %rdx
    jnz          .Lmul_loopAgas_36
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    jmp          .Lmla_enrtygas_36
.Lmla_loopBgas_36: 
    push         %rbx
    push         %rdi
    push         %rsi
    push         %rdx
    xor          %rax, %rax
    push         %rax
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
.LloopAgas_36: 
    push         %rdx
    call         _mla_8x8
    add          $(64), %rdi
    add          $(64), %rsi
    pop          %rdx
    sub          $(8), %rdx
    jz           .Lexit_loopAgas_36
    pop          %rax
    neg          %rax
    movq         (%rdi), %rax
    adc          %rax, %r8
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    movq         (56)(%rdi), %rax
    adc          %rax, %r15
    sbb          %rax, %rax
    push         %rax
    jmp          .LloopAgas_36
.Lexit_loopAgas_36: 
    pop          %rax
    neg          %rax
    adc          $(0), %r8
    movq         %r8, (%rdi)
    adc          $(0), %r9
    movq         %r9, (8)(%rdi)
    adc          $(0), %r10
    movq         %r10, (16)(%rdi)
    adc          $(0), %r11
    movq         %r11, (24)(%rdi)
    adc          $(0), %r12
    movq         %r12, (32)(%rdi)
    adc          $(0), %r13
    movq         %r13, (40)(%rdi)
    adc          $(0), %r14
    movq         %r14, (48)(%rdi)
    adc          $(0), %r15
    movq         %r15, (56)(%rdi)
.Lmla_enrtygas_36: 
    pop          %rdx
    pop          %rsi
    pop          %rdi
    add          $(64), %rdi
    add          $(64), %rcx
    pop          %rbx
    sub          $(8), %rbx
    jnz          .Lmla_loopBgas_36
    ret
 
.p2align 5, 0x90
 


 
_mla_simple:
    xor          %rax, %rax
    mov          %rdx, %r11
    cmp          %rbx, %r11
    jge          .Lms_mla_entrygas_37
    xor          %rbx, %r11
    xor          %r11, %rbx
    xor          %rbx, %r11
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    jmp          .Lms_mla_entrygas_37
.Lms_loopBgas_37: 
    push         %rbx
    push         %rdi
    push         %rsi
    push         %r11
    push         %rax
    movq         (%rcx), %rdx
    xor          %r10, %r10
.Lms_loopAgas_37: 
    mulxq        (%rsi), %r8, %r9
    add          $(8), %rdi
    add          $(8), %rsi
    add          %r10, %r8
    adc          $(0), %r9
    addq         (-8)(%rdi), %r8
    adc          $(0), %r9
    movq         %r8, (-8)(%rdi)
    mov          %r9, %r10
    sub          $(1), %r11
    jnz          .Lms_loopAgas_37
    pop          %rax
    shr          $(1), %rax
    adcq         (%rdi), %r10
    movq         %r10, (%rdi)
    adc          $(0), %rax
    pop          %r11
    pop          %rsi
    pop          %rdi
    pop          %rbx
    add          $(8), %rdi
    add          $(8), %rcx
.Lms_mla_entrygas_37: 
    sub          $(1), %rbx
    jnc          .Lms_loopBgas_37
    ret
 
.p2align 5, 0x90
 


 
_mul_NxM:
 
    sub          $(56), %rsp
    cmp          $(8), %rbx
    jge          .Lregular_entrygas_38
    cmp          $(8), %rdx
    jge          .Lirregular_entrygas_38
    mov          %rdx, %r8
    add          %rbx, %r8
    mov          %rdi, %rbp
    xor          %rax, %rax
.L__0000gas_38: 
    movq         %rax, (%rbp)
    add          $(8), %rbp
    sub          $(1), %r8
    jnz          .L__0000gas_38
    call         _mla_simple
    jmp          .Lquitgas_38
.Lirregular_entrygas_38: 
    mov          %rbx, (%rsp)
    mov          %rdx, (24)(%rsp)
    mov          %rdx, (32)(%rsp)
    lea          mla_8xl_tail(%rip), %rax
    mov          (-8)(%rax,%rbx,8), %rbp
    add          %rbp, %rax
    mov          %rax, (48)(%rsp)
    jmp          .Lirr_init_entrygas_38
.Lirr_init_loopgas_38: 
    mov          %rdx, (32)(%rsp)
    call         *%rax
    mov          (%rsp), %rbx
    movq         %r8, (%rdi,%rbx,8)
    movq         %r9, (8)(%rdi,%rbx,8)
    movq         %r10, (16)(%rdi,%rbx,8)
    movq         %r11, (24)(%rdi,%rbx,8)
    movq         %r12, (32)(%rdi,%rbx,8)
    movq         %r13, (40)(%rdi,%rbx,8)
    movq         %r14, (48)(%rdi,%rbx,8)
    movq         %r15, (56)(%rdi,%rbx,8)
    add          $(64), %rsi
    add          $(64), %rdi
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    xor          %r12, %r12
    xor          %r13, %r13
    xor          %r14, %r14
    xor          %r15, %r15
    movq         (%rdi), %r8
    cmp          $(1), %rbx
    jz           .Lcontinuegas_38
    movq         (8)(%rdi), %r9
    cmp          $(2), %rbx
    jz           .Lcontinuegas_38
    movq         (16)(%rdi), %r10
    cmp          $(3), %rbx
    jz           .Lcontinuegas_38
    movq         (24)(%rdi), %r11
    cmp          $(4), %rbx
    jz           .Lcontinuegas_38
    movq         (32)(%rdi), %r12
    cmp          $(5), %rbx
    jz           .Lcontinuegas_38
    movq         (40)(%rdi), %r13
    cmp          $(6), %rbx
    jz           .Lcontinuegas_38
    movq         (48)(%rdi), %r14
.Lcontinuegas_38: 
    mov          (32)(%rsp), %rdx
.Lirr_init_entrygas_38: 
    sub          $(8), %rdx
    mov          (48)(%rsp), %rax
    jnc          .Lirr_init_loopgas_38
    add          $(8), %rdx
    jz           .Lquitgas_38
    lea          (%rdi,%rbx,8), %rbp
    xor          %rax, %rax
.L__0001gas_38: 
    movq         %rax, (%rbp)
    add          $(8), %rbp
    sub          $(1), %rdx
    jnz          .L__0001gas_38
    mov          (32)(%rsp), %rdx
    call         _mla_simple
    jmp          .Lquitgas_38
.Lregular_entrygas_38: 
    sub          $(8), %rbx
    xor          %rax, %rax
    mov          %rbx, (%rsp)
    mov          %rdi, (8)(%rsp)
    mov          %rsi, (16)(%rsp)
    mov          %rdx, (24)(%rsp)
    mov          %rdx, (32)(%rsp)
    mov          %rax, (40)(%rsp)
    mov          %rdx, %rbp
    and          $(7), %rbp
    lea          mla_8xl_tail(%rip), %rax
    mov          (-8)(%rax,%rbp,8), %rbp
    add          %rbp, %rax
    mov          %rax, (48)(%rsp)
    sub          $(8), %rdx
.Linit_loopAgas_38: 
    mov          %rdx, (32)(%rsp)
    call         _mla_8x8
    mov          (32)(%rsp), %rdx
    add          $(64), %rdi
    add          $(64), %rsi
    sub          $(8), %rdx
    jnc          .Linit_loopAgas_38
    add          $(8), %rdx
    jz           .Linit_completegas_38
    mov          %rdx, (32)(%rsp)
    mov          (48)(%rsp), %rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         *%rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          (32)(%rsp), %rdx
    lea          (%rdi,%rdx,8), %rdi
.Linit_completegas_38: 
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    jmp          .Lmla_enrtygas_38
.Lmla_loopBgas_38: 
    mov          %rbx, (%rsp)
    mov          %rdi, (8)(%rsp)
    xor          %rax, %rax
    mov          %rax, (40)(%rsp)
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    sub          $(8), %rdx
.LloopAgas_38: 
    mov          %rdx, (32)(%rsp)
    call         _mla_8x8
    mov          (32)(%rsp), %rdx
    add          $(64), %rdi
    add          $(64), %rsi
    sub          $(8), %rdx
    jc           .Lexit_loopAgas_38
    mov          (40)(%rsp), %rax
    shr          $(1), %rax
    movq         (%rdi), %rbx
    adc          %rbx, %r8
    movq         (8)(%rdi), %rbx
    adc          %rbx, %r9
    movq         (16)(%rdi), %rbx
    adc          %rbx, %r10
    movq         (24)(%rdi), %rbx
    adc          %rbx, %r11
    movq         (32)(%rdi), %rbx
    adc          %rbx, %r12
    movq         (40)(%rdi), %rbx
    adc          %rbx, %r13
    movq         (48)(%rdi), %rbx
    adc          %rbx, %r14
    movq         (56)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    mov          %rax, (40)(%rsp)
    jmp          .LloopAgas_38
.Lexit_loopAgas_38: 
    add          $(8), %rdx
    jz           .Lcomplete_reg_loopBgas_38
    mov          %rdx, (32)(%rsp)
    xor          %rax, %rax
.Lput_zerogas_38: 
    movq         %rax, (%rdi,%rdx,8)
    add          $(1), %rdx
    cmp          $(8), %rdx
    jl           .Lput_zerogas_38
    mov          (40)(%rsp), %rax
    shr          $(1), %rax
    mov          (%rdi), %rbx
    adc          %rbx, %r8
    mov          (8)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (16)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (24)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (32)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (40)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    mov          %rax, (40)(%rsp)
    mov          (48)(%rsp), %rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         *%rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    mov          (32)(%rsp), %rdx
    lea          (%rdi,%rdx,8), %rdi
    mov          (40)(%rsp), %rax
    shr          $(1), %rax
    dec          %rdx
    jz           .Lmt_1gas_38
    dec          %rdx
    jz           .Lmt_2gas_38
    dec          %rdx
    jz           .Lmt_3gas_38
    dec          %rdx
    jz           .Lmt_4gas_38
    dec          %rdx
    jz           .Lmt_5gas_38
    dec          %rdx
    jz           .Lmt_6gas_38
.Lmt_7gas_38:
    adc          $(0), %r9
.Lmt_6gas_38:
    adc          $(0), %r10
.Lmt_5gas_38:
    adc          $(0), %r11
.Lmt_4gas_38:
    adc          $(0), %r12
.Lmt_3gas_38:
    adc          $(0), %r13
.Lmt_2gas_38:
    adc          $(0), %r14
.Lmt_1gas_38:
    adc          $(0), %r15
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    jmp          .Lmla_enrtygas_38
.Lcomplete_reg_loopBgas_38: 
    mov          (40)(%rsp), %rax
    add          %rax, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
.Lmla_enrtygas_38: 
    mov          (%rsp), %rbx
    mov          (8)(%rsp), %rdi
    mov          (24)(%rsp), %rdx
    mov          (16)(%rsp), %rsi
    add          $(64), %rcx
    add          $(64), %rdi
    sub          $(8), %rbx
    jnc          .Lmla_loopBgas_38
    add          $(8), %rbx
    jz           .Lquitgas_38
    mov          %rbx, (%rsp)
    lea          mla_8xl_tail(%rip), %rax
    mov          (-8)(%rax,%rbx,8), %rbp
    add          %rbp, %rax
    mov          %rax, (48)(%rsp)
    lea          (%rdi,%rdx,8), %rbp
    xor          %rax, %rax
.L__0002gas_38: 
    movq         %rax, (%rbp)
    add          $(8), %rbp
    sub          $(1), %rbx
    jnz          .L__0002gas_38
    xor          %rax, %rax
    mov          %rax, (40)(%rsp)
    sub          $(8), %rdx
.Ltail_loopAgas_38: 
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          %rdx, (32)(%rsp)
    mov          (48)(%rsp), %rax
    call         *%rax
.Lenrty_tail_loopAgas_38: 
    mov          (40)(%rsp), %rax
    shr          $(1), %rax
    adc          $(0), %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    adc          $(0), %rax
    mov          (%rsp), %rbx
    mov          %rbx, %rbp
    dec          %rbp
    jz           .Ltt_1gas_38
    dec          %rbp
    jz           .Ltt_2gas_38
    dec          %rbp
    jz           .Ltt_3gas_38
    dec          %rbp
    jz           .Ltt_4gas_38
    dec          %rbp
    jz           .Ltt_5gas_38
    dec          %rbp
    jz           .Ltt_6gas_38
.Ltt_7gas_38:  
    mov          (8)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r9
.Ltt_6gas_38:  
    mov          (16)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r10
.Ltt_5gas_38:  
    mov          (24)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r11
.Ltt_4gas_38:  
    mov          (32)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r12
.Ltt_3gas_38:  
    mov          (40)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r13
.Ltt_2gas_38:  
    mov          (48)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r14
.Ltt_1gas_38:  
    mov          (56)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r15
    adc          $(0), %rax
    mov          %rax, (40)(%rsp)
    movq         %r8, (%rdi,%rbx,8)
    movq         %r9, (8)(%rdi,%rbx,8)
    movq         %r10, (16)(%rdi,%rbx,8)
    movq         %r11, (24)(%rdi,%rbx,8)
    movq         %r12, (32)(%rdi,%rbx,8)
    movq         %r13, (40)(%rdi,%rbx,8)
    movq         %r14, (48)(%rdi,%rbx,8)
    movq         %r15, (56)(%rdi,%rbx,8)
    mov          (32)(%rsp), %rdx
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnc          .Ltail_loopAgas_38
    add          $(8), %rdx
    jz           .Lquitgas_38
    mov          (40)(%rsp), %rax
    mov          %rbx, %rbp
    dec          %rbp
    movq         (%rdi,%rbx,8), %r8
    add          %rax, %r8
    movq         %r8, (%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (8)(%rdi,%rbx,8), %r9
    adc          $(0), %r9
    movq         %r9, (8)(%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (16)(%rdi,%rbx,8), %r10
    adc          $(0), %r10
    movq         %r10, (16)(%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (24)(%rdi,%rbx,8), %r11
    adc          $(0), %r11
    movq         %r11, (24)(%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (32)(%rdi,%rbx,8), %r12
    adc          $(0), %r12
    movq         %r12, (32)(%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (40)(%rdi,%rbx,8), %r13
    adc          $(0), %r13
    movq         %r13, (40)(%rdi,%rbx,8)
    jz           .Lsimplegas_38
    dec          %rbp
    movq         (48)(%rdi,%rbx,8), %r14
    adc          $(0), %r14
    movq         %r14, (48)(%rdi,%rbx,8)
.Lsimplegas_38: 
    call         _mla_simple
.Lquitgas_38: 
    add          $(56), %rsp
    ret
 
.p2align 5, 0x90
 


 
_sqr_1:
    movq         (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    movq         %rax, (%rdi)
    movq         %rdx, (8)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_2:
    movq         (%rsi), %rdx
    mulxq        (8)(%rsi), %r8, %r9
    mulx         %rdx, %r10, %r11
    movq         (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          $(0), %rcx
    movq         %r10, (%rdi)
    add          %r8, %r11
    movq         %r11, (8)(%rdi)
    adc          %r9, %rax
    movq         %rax, (16)(%rdi)
    adc          %rcx, %rdx
    movq         %rdx, (24)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_3:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    movq         (8)(%rsi), %rdx
    mulxq        (16)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    movq         (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %rcx, %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    adc          %rax, %rcx
    mov          %rcx, (40)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_4:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    mulx         (24)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    movq         (8)(%rsi), %rdx
    mulxq        (16)(%rsi), %rax, %rcx
    xor          %r12, %r12
    add          %rax, %r10
    adc          %rcx, %r11
    adc          $(0), %r12
    mulxq        (24)(%rsi), %rax, %rcx
    add          %rax, %r11
    adc          %rcx, %r12
    movq         (16)(%rsi), %rdx
    mulxq        (24)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    mov          (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          $(0), %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    mov          (24)(%rsi), %rdx
    adc          %rax, %r12
    mov          %r12, (40)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r13
    mov          %r13, (48)(%rdi)
    adc          %rax, %rcx
    mov          %rcx, (56)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_5:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    mulx         (24)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    mulx         (32)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    mov          (8)(%rsi), %rdx
    mulx         (16)(%rsi), %rax, %rbp
    add          %rax, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %rax, %rcx
    add          %rax, %r11
    adc          $(0), %rcx
    add          %rbp, %r11
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r12
    adc          $(0), %rcx
    add          %rbp, %r12
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mov          %rbp, %r13
    movq         (16)(%rsi), %rdx
    mulxq        (24)(%rsi), %rax, %rcx
    xor          %r14, %r14
    add          %rax, %r12
    adc          %rcx, %r13
    adc          $(0), %r14
    mulxq        (32)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          %rcx, %r14
    movq         (24)(%rsi), %rdx
    mulxq        (32)(%rsi), %rax, %r15
    add          %rax, %r14
    adc          $(0), %r15
    mov          (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          %r15, %r15
    adc          $(0), %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    mov          (24)(%rsi), %rdx
    adc          %rax, %r12
    mov          %r12, (40)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r13
    mov          %r13, (48)(%rdi)
    mov          (32)(%rsi), %rdx
    adc          %rax, %r14
    mov          %r14, (56)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r15
    mov          %r15, (64)(%rdi)
    mov          (40)(%rsi), %rdx
    adc          %rax, %rcx
    mov          %rcx, (72)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_6:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    mulx         (24)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    mulx         (32)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    mulx         (40)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    mov          (8)(%rsi), %rdx
    mulx         (16)(%rsi), %rax, %rbp
    add          %rax, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %rax, %rcx
    add          %rax, %r11
    adc          $(0), %rcx
    add          %rbp, %r11
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r12
    adc          $(0), %rcx
    add          %rbp, %r12
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mov          %rbp, %r14
    mov          (16)(%rsi), %rdx
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r14
    adc          $(0), %rcx
    add          %rbp, %r14
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mov          %rbp, %r15
    movq         (24)(%rsi), %rdx
    mulxq        (32)(%rsi), %rax, %rcx
    xor          %rbx, %rbx
    add          %rax, %r14
    adc          %rcx, %r15
    adc          $(0), %rbx
    mulxq        (40)(%rsi), %rax, %rcx
    add          %rax, %r15
    adc          %rcx, %rbx
    movq         (32)(%rsi), %rdx
    mulxq        (40)(%rsi), %rax, %rbp
    add          %rax, %rbx
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          %r15, %r15
    adc          %rbx, %rbx
    adc          %rbp, %rbp
    adc          $(0), %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    mov          (24)(%rsi), %rdx
    adc          %rax, %r12
    mov          %r12, (40)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r13
    mov          %r13, (48)(%rdi)
    mov          (32)(%rsi), %rdx
    adc          %rax, %r14
    mov          %r14, (56)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r15
    mov          %r15, (64)(%rdi)
    mov          (40)(%rsi), %rdx
    adc          %rax, %rbx
    mov          %rbx, (72)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %rbp
    mov          %rbp, (80)(%rdi)
    adc          %rax, %rcx
    mov          %rcx, (88)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_7:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    mulx         (24)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    mulx         (32)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    mulx         (40)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %r13
    adc          $(0), %r14
    mov          (8)(%rsi), %rdx
    mulx         (16)(%rsi), %rax, %rbp
    add          %rax, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %rax, %rcx
    add          %rax, %r11
    adc          $(0), %rcx
    add          %rbp, %r11
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r12
    adc          $(0), %rcx
    add          %rbp, %r12
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (48)(%rsi), %rax, %rcx
    add          %rax, %r14
    adc          $(0), %rcx
    add          %rbp, %r14
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mov          %rbp, %r15
    mov          (16)(%rsi), %rdx
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    xor          %rbx, %rbx
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r14
    adc          $(0), %rcx
    add          %rbp, %r14
    adc          $(0), %rcx
    mov          %rcx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (24)(%rsi), %rax
    mulq         (32)(%rsi)
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rdx, %r15
    adc          $(0), %rbx
    mov          (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          $(0), %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    mov          (24)(%rsi), %rdx
    adc          %rax, %r12
    mov          %r12, (40)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r13
    mov          %r13, (48)(%rdi)
    adc          %rax, %r14
    mov          %r14, (56)(%rdi)
    adc          $(0), %rcx
    mov          (16)(%rsi), %rax
    xor          %r8, %r8
    mulq         (48)(%rsi)
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    mov          (24)(%rsi), %rdx
    mulx         (40)(%rsi), %rax, %r14
    add          %rax, %r15
    adc          %r14, %rbx
    adc          $(0), %r8
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %rbx
    adc          %r14, %r8
    mov          (32)(%rsi), %rdx
    mulx         (40)(%rsi), %rax, %r14
    xor          %r9, %r9
    add          %rax, %rbx
    adc          %r14, %r8
    adc          $(0), %r9
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %r8
    adc          %r14, %r9
    mov          (40)(%rsi), %rax
    xor          %r10, %r10
    mulq         (48)(%rsi)
    add          %rax, %r9
    adc          %rdx, %r10
    mov          (32)(%rsi), %rdx
    xor          %r11, %r11
    add          %r15, %r15
    adc          %rbx, %rbx
    adc          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          $(0), %r11
    mulx         %rdx, %rdx, %rax
    add          %rcx, %rdx
    adc          $(0), %rax
    add          %rdx, %r15
    mov          (40)(%rsi), %rdx
    mov          %r15, (64)(%rdi)
    adc          %rax, %rbx
    mov          %rbx, (72)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r8
    mov          %r8, (80)(%rdi)
    mov          (48)(%rsi), %rdx
    adc          %rax, %r9
    mov          %r9, (88)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r10
    mov          %r10, (96)(%rdi)
    adc          %rax, %r11
    mov          %r11, (104)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr_8:
    mov          (%rsi), %rdx
    mulx         (8)(%rsi), %r8, %r9
    mulx         (16)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    mulx         (24)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    mulx         (32)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    mulx         (40)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %r13
    adc          $(0), %r14
    mulx         (56)(%rsi), %rax, %r15
    add          %rax, %r14
    adc          $(0), %r15
    mov          (8)(%rsi), %rdx
    mulx         (16)(%rsi), %rax, %rbp
    add          %rax, %r10
    adc          $(0), %rbp
    xor          %rbx, %rbx
    mulx         (24)(%rsi), %rax, %rcx
    add          %rax, %r11
    adc          $(0), %rcx
    add          %rbp, %r11
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r12
    adc          $(0), %rcx
    add          %rbp, %r12
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (48)(%rsi), %rax, %rcx
    add          %rax, %r14
    adc          $(0), %rcx
    add          %rbp, %r14
    adc          $(0), %rcx
    mov          %rcx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (16)(%rsi), %rdx
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    mulx         (32)(%rsi), %rax, %rcx
    add          %rax, %r13
    adc          $(0), %rcx
    add          %rbp, %r13
    adc          $(0), %rcx
    mov          %rcx, %rbp
    mulx         (40)(%rsi), %rax, %rcx
    add          %rax, %r14
    adc          $(0), %rcx
    add          %rbp, %r14
    adc          $(0), %rcx
    mov          %rcx, %rbp
    add          %rbp, %r15
    adc          $(0), %rbx
    mov          (24)(%rsi), %rax
    mulq         (32)(%rsi)
    add          %rax, %r14
    adc          $(0), %rdx
    add          %rdx, %r15
    adc          $(0), %rbx
    mov          (%rsi), %rdx
    xor          %rcx, %rcx
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          $(0), %rcx
    mulx         %rdx, %rdx, %rax
    mov          %rdx, (%rdi)
    mov          (8)(%rsi), %rdx
    add          %rax, %r8
    mov          %r8, (8)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r9
    mov          %r9, (16)(%rdi)
    mov          (16)(%rsi), %rdx
    adc          %rax, %r10
    mov          %r10, (24)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r11
    mov          %r11, (32)(%rdi)
    mov          (24)(%rsi), %rdx
    adc          %rax, %r12
    mov          %r12, (40)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r13
    mov          %r13, (48)(%rdi)
    adc          %rax, %r14
    mov          %r14, (56)(%rdi)
    adc          $(0), %rcx
    mov          (8)(%rsi), %rax
    xor          %r8, %r8
    mulq         (56)(%rsi)
    add          %rax, %r15
    adc          $(0), %rdx
    add          %rdx, %rbx
    adc          $(0), %r8
    mov          (16)(%rsi), %rdx
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %r15
    adc          %r14, %rbx
    adc          $(0), %r8
    mulx         (56)(%rsi), %rax, %r14
    xor          %r9, %r9
    add          %rax, %rbx
    adc          %r14, %r8
    adc          $(0), %r9
    mov          (24)(%rsi), %rdx
    mulx         (40)(%rsi), %rax, %r14
    add          %rax, %r15
    adc          $(0), %r14
    add          %r14, %rbx
    adc          $(0), %r8
    adc          $(0), %r9
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %rbx
    adc          $(0), %r14
    add          %r14, %r8
    adc          $(0), %r9
    mulx         (56)(%rsi), %rax, %r14
    add          %rax, %r8
    adc          $(0), %r14
    add          %r14, %r9
    mov          (32)(%rsi), %rdx
    mulx         (40)(%rsi), %rax, %r10
    add          %rax, %rbx
    adc          $(0), %r10
    mulx         (48)(%rsi), %rax, %r14
    add          %rax, %r8
    adc          $(0), %r14
    add          %r10, %r8
    adc          $(0), %r14
    mov          %r14, %r10
    mulx         (56)(%rsi), %rax, %r14
    add          %rax, %r9
    adc          $(0), %r14
    add          %r10, %r9
    adc          $(0), %r14
    mov          %r14, %r10
    mov          (40)(%rsi), %rdx
    mulx         (48)(%rsi), %rax, %r11
    add          %rax, %r9
    adc          $(0), %r11
    mulx         (56)(%rsi), %rax, %r14
    add          %rax, %r10
    adc          $(0), %r14
    add          %r11, %r10
    adc          $(0), %r14
    mov          %r14, %r11
    mov          (48)(%rsi), %rax
    mulq         (56)(%rsi)
    add          %rax, %r11
    adc          $(0), %rdx
    mov          %rdx, %r12
    mov          (32)(%rsi), %rdx
    xor          %r13, %r13
    add          %r15, %r15
    adc          %rbx, %rbx
    adc          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          $(0), %r13
    mulx         %rdx, %rdx, %rax
    add          %rcx, %rdx
    adc          $(0), %rax
    add          %rdx, %r15
    mov          (40)(%rsi), %rdx
    mov          %r15, (64)(%rdi)
    adc          %rax, %rbx
    mov          %rbx, (72)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r8
    mov          %r8, (80)(%rdi)
    mov          (48)(%rsi), %rdx
    adc          %rax, %r9
    mov          %r9, (88)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r10
    mov          %r10, (96)(%rdi)
    mov          (56)(%rsi), %rdx
    adc          %rax, %r11
    mov          %r11, (104)(%rdi)
    mulx         %rdx, %rdx, %rax
    adc          %rdx, %r12
    mov          %r12, (112)(%rdi)
    adc          %rax, %r13
    mov          %r13, (120)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_add_diag_4:
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          %r14, %r14
    adc          %r15, %r15
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    mov          (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r10
    adc          %rdx, %r11
    mov          (16)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r12
    adc          %rdx, %r13
    mov          (24)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r14
    adc          %rdx, %r15
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    ret
 
.p2align 5, 0x90
 


 
_sqr8_triangle:
    mov          (%rsi), %rdx
    mov          %r8, (%rdi)
    mulx         (8)(%rsi), %rax, %rbp
    add          %rax, %r9
    adc          $(0), %rbp
    mulx         (16)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    add          %rbp, %r10
    adc          $(0), %rbx
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r11
    adc          $(0), %rbp
    add          %rbx, %r11
    adc          $(0), %rbp
    mulx         (32)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (40)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    mov          (8)(%rsi), %rdx
    mov          %r9, (8)(%rdi)
    mulx         (16)(%rsi), %rax, %rbx
    add          %rax, %r11
    adc          $(0), %rbx
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (32)(%rsi), %rax, %rbx
    add          %rax, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (40)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    mov          (16)(%rsi), %rdx
    mov          %r10, (16)(%rdi)
    mulx         (24)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    mulx         (32)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (40)(%rsi), %rax, %rbp
    add          %rax, %r15
    adc          $(0), %rbp
    add          %rbx, %r15
    adc          $(0), %rbp
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    mov          (24)(%rsi), %rdx
    mov          %r11, (24)(%rdi)
    mulx         (32)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    mulx         (40)(%rsi), %rax, %rbp
    add          %rax, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    add          %rbx, %r10
    adc          $(0), %r11
    mov          (32)(%rsi), %rdx
    mov          %r12, (32)(%rdi)
    mulx         (40)(%rsi), %rax, %rbp
    add          %rax, %r9
    adc          $(0), %rbp
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    add          %rbp, %r10
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    add          %rbx, %r11
    adc          $(0), %r12
    mov          (40)(%rsi), %rdx
    mov          %r13, (40)(%rdi)
    mulx         (48)(%rsi), %rax, %rbx
    add          %rax, %r11
    adc          $(0), %rbx
    mulx         (56)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    add          %rbx, %r12
    adc          $(0), %r13
    mov          (48)(%rsi), %rdx
    mov          %r14, (48)(%rdi)
    mulx         (56)(%rsi), %rax, %r14
    add          %rax, %r13
    adc          $(0), %r14
    ret
 
.p2align 5, 0x90
 


 
_sqr_9:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x1
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    xor          %rbx, %rbx
    movq         %rbx, (72)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    sub          $(64), %rsi
    sub          $(128), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_10:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x2
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    movq         %r10, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %r12, (48)(%rdi)
    movq         %r13, (56)(%rdi)
    movq         %r14, (64)(%rdi)
    movq         (64)(%rsi), %rdx
    mulx         (72)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    xor          %rbx, %rbx
    movq         %r15, (72)(%rdi)
    movq         %r8, (80)(%rdi)
    movq         %rbx, (88)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    mov          (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r10
    adc          %rdx, %r11
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    sub          $(64), %rsi
    sub          $(128), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_11:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x2
    sub          $(8), %rdi
    sub          $(8), %rcx
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    movq         %r11, (48)(%rdi)
    movq         %r12, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r13, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r14, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    xor          %rbx, %rbx
    movq         %r15, (80)(%rdi)
    movq         %r8, (88)(%rdi)
    movq         %r9, (96)(%rdi)
    movq         %rbx, (104)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    mov          (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r10
    adc          %rdx, %r11
    mov          (16)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    sub          $(64), %rsi
    sub          $(128), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_12:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(16), %rdi
    sub          $(16), %rcx
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r12, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r13, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r14, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    xor          %rbx, %rbx
    movq         %r15, (88)(%rdi)
    movq         %r8, (96)(%rdi)
    movq         %r9, (104)(%rdi)
    movq         %r10, (112)(%rdi)
    movq         %rbx, (120)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    sub          $(64), %rsi
    sub          $(128), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_13:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(24), %rdi
    sub          $(24), %rcx
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r11, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r12, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r13, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r14, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    xor          %rbx, %rbx
    movq         %r15, (96)(%rdi)
    movq         %r8, (104)(%rdi)
    movq         %r9, (112)(%rdi)
    movq         %r10, (120)(%rdi)
    movq         %r11, (128)(%rdi)
    movq         %rbx, (136)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    sub          $(96), %rsi
    sub          $(192), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_14:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(32), %rdi
    sub          $(32), %rcx
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r10, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbp
    add          %rax, %r11
    adc          $(0), %rbp
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r11, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r13
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r12, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r15
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r13, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r9
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    add          %rbx, %r10
    adc          $(0), %r11
    movq         (96)(%rsi), %rdx
    mov          %r14, (96)(%rdi)
    mulx         (104)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    xor          %rbx, %rbx
    movq         %r15, (104)(%rdi)
    movq         %r8, (112)(%rdi)
    movq         %r9, (120)(%rdi)
    movq         %r10, (128)(%rdi)
    movq         %r11, (136)(%rdi)
    movq         %r12, (144)(%rdi)
    movq         %rbx, (152)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    mov          (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r10
    adc          %rdx, %r11
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    sub          $(96), %rsi
    sub          $(192), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_15:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x1
    add          $(8), %rdi
    add          $(8), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(40), %rdi
    sub          $(40), %rcx
    movq         %r8, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r9, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r11
    adc          $(0), %rbp
    add          %rbx, %r11
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r10, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r11, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r15
    adc          $(0), %rbp
    add          %rbx, %r15
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r12, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r8
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    add          %rbx, %r10
    adc          $(0), %r11
    movq         (96)(%rsi), %rdx
    mov          %r13, (96)(%rdi)
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    add          %rbx, %r11
    adc          $(0), %r12
    movq         (104)(%rsi), %rdx
    mov          %r14, (104)(%rdi)
    mulx         (112)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    xor          %rbx, %rbx
    movq         %r15, (112)(%rdi)
    movq         %r8, (120)(%rdi)
    movq         %r9, (128)(%rdi)
    movq         %r10, (136)(%rdi)
    movq         %r11, (144)(%rdi)
    movq         %r12, (152)(%rdi)
    movq         %r13, (160)(%rdi)
    movq         %rbx, (168)(%rdi)
    sub          $(64), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          %r10, %r10
    adc          %r11, %r11
    adc          %r12, %r12
    adc          %r13, %r13
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    mov          (8)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r10
    adc          %rdx, %r11
    mov          (16)(%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    adc          %rax, %r12
    adc          %rdx, %r13
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    sub          $(96), %rsi
    sub          $(192), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr_16:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    mov          %rsi, %rcx
    add          $(64), %rsi
    add          $(64), %rdi
    xor          %r15, %r15
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    add          $(16), %rdi
    add          $(16), %rcx
    call         _mla_8x2
    sub          $(48), %rdi
    sub          $(48), %rcx
    add          $(64), %rdi
    call         _sqr8_triangle
    xor          %rbx, %rbx
    movq         %r15, (56)(%rdi)
    movq         %r8, (64)(%rdi)
    movq         %r9, (72)(%rdi)
    movq         %r10, (80)(%rdi)
    movq         %r11, (88)(%rdi)
    movq         %r12, (96)(%rdi)
    movq         %r13, (104)(%rdi)
    movq         %r14, (112)(%rdi)
    movq         %rbx, (120)(%rdi)
    sub          $(64), %rsi
    sub          $(128), %rdi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    call         _add_diag_4
    sub          $(96), %rsi
    sub          $(192), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr9_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x1
    xor          %rax, %rax
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    movq         %r15, (64)(%rdi)
    movq         %rax, (72)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr10_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x2
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    movq         %r10, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %r12, (48)(%rdi)
    movq         %r13, (56)(%rdi)
    movq         %r14, (64)(%rdi)
    movq         (64)(%rsi), %rdx
    mulx         (72)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    xor          %rax, %rax
    movq         %r15, (72)(%rdi)
    movq         %r8, (80)(%rdi)
    movq         %rax, (88)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr11_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x3
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    movq         %r11, (48)(%rdi)
    movq         %r12, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r13, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r14, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    xor          %rax, %rax
    movq         %r15, (80)(%rdi)
    movq         %r8, (88)(%rdi)
    movq         %r9, (96)(%rdi)
    movq         %rax, (104)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr12_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x4
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r12, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r13, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r14, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    xor          %rax, %rax
    movq         %r15, (88)(%rdi)
    movq         %r8, (96)(%rdi)
    movq         %r9, (104)(%rdi)
    movq         %r10, (112)(%rdi)
    movq         %rax, (120)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr13_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x5
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r11, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r12, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r13, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r14, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    xor          %rax, %rax
    movq         %r15, (96)(%rdi)
    movq         %r8, (104)(%rdi)
    movq         %r9, (112)(%rdi)
    movq         %r10, (120)(%rdi)
    movq         %r11, (128)(%rdi)
    movq         %rax, (136)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr14_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x6
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r10, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbp
    add          %rax, %r11
    adc          $(0), %rbp
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r11, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbx
    add          %rax, %r13
    adc          $(0), %rbx
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r12, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbp
    add          %rax, %r15
    adc          $(0), %rbp
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r13, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %rbx
    add          %rax, %r9
    adc          $(0), %rbx
    mulx         (104)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    add          %rbx, %r10
    adc          $(0), %r11
    movq         (96)(%rsi), %rdx
    mov          %r14, (96)(%rdi)
    mulx         (104)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    xor          %rax, %rax
    movq         %r15, (104)(%rdi)
    movq         %r8, (112)(%rdi)
    movq         %r9, (120)(%rdi)
    movq         %r10, (128)(%rdi)
    movq         %r11, (136)(%rdi)
    movq         %r12, (144)(%rdi)
    movq         %rax, (152)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr15_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    lea          (64)(%rsi), %rcx
    add          $(64), %rdi
    call         _mla_8x7
    movq         %r8, (56)(%rdi)
    movq         (64)(%rsi), %rdx
    mov          %r9, (64)(%rdi)
    mulx         (72)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r11
    adc          $(0), %rbp
    add          %rbx, %r11
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r12
    adc          $(0), %rbx
    add          %rbp, %r12
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r13
    adc          $(0), %rbp
    add          %rbx, %r13
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    add          %rbp, %r14
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r8
    add          %rax, %r15
    adc          $(0), %r8
    add          %rbx, %r15
    adc          $(0), %r8
    movq         (72)(%rsi), %rdx
    mov          %r10, (72)(%rdi)
    mulx         (80)(%rsi), %rax, %rbp
    add          %rax, %r12
    adc          $(0), %rbp
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r15
    adc          $(0), %rbx
    add          %rbp, %r15
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r9
    add          %rax, %r8
    adc          $(0), %r9
    add          %rbx, %r8
    adc          $(0), %r9
    movq         (80)(%rsi), %rdx
    mov          %r11, (80)(%rdi)
    mulx         (88)(%rsi), %rax, %rbx
    add          %rax, %r14
    adc          $(0), %rbx
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r15
    adc          $(0), %rbp
    add          %rbx, %r15
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r8
    adc          $(0), %rbx
    add          %rbp, %r8
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r10
    add          %rax, %r9
    adc          $(0), %r10
    add          %rbx, %r9
    adc          $(0), %r10
    movq         (88)(%rsi), %rdx
    mov          %r12, (88)(%rdi)
    mulx         (96)(%rsi), %rax, %rbp
    add          %rax, %r8
    adc          $(0), %rbp
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r11
    add          %rax, %r10
    adc          $(0), %r11
    add          %rbx, %r10
    adc          $(0), %r11
    movq         (96)(%rsi), %rdx
    mov          %r13, (96)(%rdi)
    mulx         (104)(%rsi), %rax, %rbx
    add          %rax, %r10
    adc          $(0), %rbx
    mulx         (112)(%rsi), %rax, %r12
    add          %rax, %r11
    adc          $(0), %r12
    add          %rbx, %r11
    adc          $(0), %r12
    movq         (104)(%rsi), %rdx
    mov          %r14, (104)(%rdi)
    mulx         (112)(%rsi), %rax, %r13
    add          %rax, %r12
    adc          $(0), %r13
    xor          %rax, %rax
    movq         %r15, (112)(%rdi)
    movq         %r8, (120)(%rdi)
    movq         %r9, (128)(%rdi)
    movq         %r10, (136)(%rdi)
    movq         %r11, (144)(%rdi)
    movq         %r12, (152)(%rdi)
    movq         %r13, (160)(%rdi)
    movq         %rax, (168)(%rdi)
    sub          $(64), %rdi
    ret
 
.p2align 5, 0x90
 


 
_sqr16_triangle:
    call         _sqr8_triangle
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    mov          %rsi, %rcx
    add          $(64), %rsi
    add          $(64), %rdi
    call         _mla_8x8
    add          $(64), %rdi
    call         _sqr8_triangle
    xor          %rax, %rax
    movq         %r15, (56)(%rdi)
    movq         %r8, (64)(%rdi)
    movq         %r9, (72)(%rdi)
    movq         %r10, (80)(%rdi)
    movq         %r11, (88)(%rdi)
    movq         %r12, (96)(%rdi)
    movq         %r13, (104)(%rdi)
    movq         %r14, (112)(%rdi)
    movq         %rax, (120)(%rdi)
    sub          $(64), %rsi
    sub          $(128), %rdi
    ret
 
sqr_l_basic:
.quad  _sqr_1 - sqr_l_basic 
 

.quad  _sqr_2 - sqr_l_basic 
 

.quad  _sqr_3 - sqr_l_basic 
 

.quad  _sqr_4 - sqr_l_basic 
 

.quad  _sqr_5 - sqr_l_basic 
 

.quad  _sqr_6 - sqr_l_basic 
 

.quad  _sqr_7 - sqr_l_basic 
 

.quad  _sqr_8 - sqr_l_basic 
 

.quad  _sqr_9 - sqr_l_basic 
 

.quad  _sqr_10- sqr_l_basic 
 

.quad  _sqr_11- sqr_l_basic 
 

.quad  _sqr_12- sqr_l_basic 
 

.quad  _sqr_13- sqr_l_basic 
 

.quad  _sqr_14- sqr_l_basic 
 

.quad  _sqr_15- sqr_l_basic 
 

.quad  _sqr_16- sqr_l_basic 
 
sqrN_triangle:
.quad  _sqr9_triangle - sqrN_triangle 
 

.quad  _sqr10_triangle - sqrN_triangle 
 

.quad  _sqr11_triangle - sqrN_triangle 
 

.quad  _sqr12_triangle - sqrN_triangle 
 

.quad  _sqr13_triangle - sqrN_triangle 
 

.quad  _sqr14_triangle - sqrN_triangle 
 

.quad  _sqr15_triangle - sqrN_triangle 
 

.quad  _sqr16_triangle - sqrN_triangle 
.p2align 5, 0x90
 


 
_sqr_8N:
    push         %rdi
    push         %rsi
    push         %rdx
    push         %rdi
    push         %rsi
    push         %rdx
    push         %rdx
    call         _sqr8_triangle
    pop          %rdx
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    add          $(64), %rdi
    sub          $(8), %rdx
    mov          %rsi, %rcx
    add          $(64), %rsi
.LinitLoopgas_65: 
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnz          .LinitLoopgas_65
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    jmp          .Lupdate_Trianglegas_65
.LouterLoopgas_65: 
    push         %rdi
    push         %rsi
    push         %rdx
    xor          %rax, %rax
    push         %rax
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
.LinnerLoop_entrygas_65: 
    push         %rdx
    call         _sqr8_triangle
    pop          %rdx
    movq         %r15, (56)(%rdi)
    xor          %r15, %r15
    add          $(64), %rdi
    sub          $(8), %rdx
    jz           .LskipInnerLoopgas_65
    mov          %rsi, %rcx
    add          $(64), %rsi
.LinnerLoopgas_65: 
    pop          %rax
    neg          %rax
    movq         (%rdi), %rax
    adc          %rax, %r8
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    movq         (56)(%rdi), %rax
    adc          %rax, %r15
    sbb          %rax, %rax
    push         %rax
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnz          .LinnerLoopgas_65
.LskipInnerLoopgas_65: 
    pop          %rax
    neg          %rax
    adc          $(0), %r8
    movq         %r8, (%rdi)
    adc          $(0), %r9
    movq         %r9, (8)(%rdi)
    adc          $(0), %r10
    movq         %r10, (16)(%rdi)
    adc          $(0), %r11
    movq         %r11, (24)(%rdi)
    adc          $(0), %r12
    movq         %r12, (32)(%rdi)
    adc          $(0), %r13
    movq         %r13, (40)(%rdi)
    adc          $(0), %r14
    movq         %r14, (48)(%rdi)
    adc          $(0), %r15
    movq         %r15, (56)(%rdi)
.Lupdate_Trianglegas_65: 
    pop          %rdx
    pop          %rsi
    pop          %rdi
    add          $(64), %rsi
    add          $(128), %rdi
    sub          $(8), %rdx
    jnz          .LouterLoopgas_65
    pop          %rcx
    pop          %rsi
    pop          %rdi
    xor          %rbx, %rbx
.Lupdate_loopgas_65: 
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    sub          $(4), %rcx
    jnz          .Lupdate_loopgas_65
    ret
 
.p2align 5, 0x90
 


 
_sqr_N:
    push         %rdi
    push         %rsi
    push         %rdx
    push         %rdi
    push         %rsi
    push         %rdx
    mov          %rdx, %rbp
    and          $(7), %rbp
    lea          mla_8xl_tail(%rip), %rax
    mov          (-8)(%rax,%rbp,8), %rbp
    add          %rbp, %rax
    push         %rax
    sub          $(8), %rdx
    push         %rdx
    call         _sqr8_triangle
    pop          %rdx
    movq         %r15, (56)(%rdi)
    add          $(64), %rdi
    xor          %r15, %r15
    mov          %rsi, %rcx
    add          $(64), %rsi
    sub          $(8), %rdx
.LinitLoopgas_66: 
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnc          .LinitLoopgas_66
    add          $(8), %rdx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    mov          (%rsp), %rax
    push         %rdx
    call         *%rax
    pop          %rdx
    lea          (%rdi,%rdx,8), %rdi
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    jmp          .Lupdate_Trianglegas_66
.LouterLoopgas_66: 
    push         %rdi
    push         %rsi
    push         %rdx
    push         %rax
    xor          %rax, %rax
    push         %rax
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    sub          $(8), %rdx
    push         %rdx
    call         _sqr8_triangle
    pop          %rdx
    movq         %r15, (56)(%rdi)
    add          $(64), %rdi
    xor          %r15, %r15
    mov          %rsi, %rcx
    add          $(64), %rsi
    sub          $(8), %rdx
.LinnerLoopgas_66: 
    pop          %rax
    neg          %rax
    movq         (%rdi), %rax
    adc          %rax, %r8
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    movq         (56)(%rdi), %rax
    adc          %rax, %r15
    sbb          %rax, %rax
    push         %rax
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnc          .LinnerLoopgas_66
    add          $(8), %rdx
    pxor         %xmm0, %xmm0
    movdqu       %xmm0, (%rdi,%rdx,8)
    movdqu       %xmm0, (16)(%rdi,%rdx,8)
    movdqu       %xmm0, (32)(%rdi,%rdx,8)
    movdqu       %xmm0, (48)(%rdi,%rdx,8)
    pop          %rax
    neg          %rax
    movq         (%rdi), %rax
    adc          %rax, %r8
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    movq         (56)(%rdi), %rax
    adc          %rax, %r15
    sbb          %rax, %rax
    neg          %rax
    movq         %rax, (64)(%rdi)
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    mov          (%rsp), %rax
    push         %rdx
    call         *%rax
    pop          %rdx
    lea          (%rdi,%rdx,8), %rdi
    xor          %rax, %rax
    movq         (%rdi), %rax
    add          %rax, %r8
    movq         %r8, (%rdi)
    movq         (8)(%rdi), %rax
    adc          %rax, %r9
    movq         %r9, (8)(%rdi)
    movq         (16)(%rdi), %rax
    adc          %rax, %r10
    movq         %r10, (16)(%rdi)
    movq         (24)(%rdi), %rax
    adc          %rax, %r11
    movq         %r11, (24)(%rdi)
    movq         (32)(%rdi), %rax
    adc          %rax, %r12
    movq         %r12, (32)(%rdi)
    movq         (40)(%rdi), %rax
    adc          %rax, %r13
    movq         %r13, (40)(%rdi)
    movq         (48)(%rdi), %rax
    adc          %rax, %r14
    movq         %r14, (48)(%rdi)
    movq         (56)(%rdi), %rax
    adc          %rax, %r15
    movq         %r15, (56)(%rdi)
.Lupdate_Trianglegas_66: 
    pop          %rax
    pop          %rdx
    pop          %rsi
    pop          %rdi
    add          $(64), %rsi
    add          $(128), %rdi
    sub          $(8), %rdx
    cmp          $(16), %rdx
    jg           .LouterLoopgas_66
    mov          %rdx, %rbp
    sub          $(8), %rbp
    lea          sqrN_triangle(%rip), %rax
    mov          (-8)(%rax,%rbp,8), %rbp
    add          %rbp, %rax
    sub          $(256), %rsp
    push         %rdi
    push         %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    lea          (16)(%rsp), %rdi
    call         *%rax
    mov          %rdi, %rsi
    pop          %rdx
    pop          %rdi
    movdqu       (%rsi), %xmm0
    movdqu       (16)(%rsi), %xmm1
    movdqu       (32)(%rsi), %xmm2
    movdqu       (48)(%rsi), %xmm3
    add          $(64), %rsi
    movdqu       %xmm0, (%rdi)
    movdqu       %xmm1, (16)(%rdi)
    movdqu       %xmm2, (32)(%rdi)
    movdqu       %xmm3, (48)(%rdi)
    add          $(64), %rdi
    lea          (-8)(%rdx), %rax
    xor          %rbx, %rbx
.Lupdate1gas_66: 
    movq         (%rsi), %r8
    movq         (%rdi), %r9
    add          $(8), %rsi
    neg          %rbx
    adc          %r9, %r8
    sbb          %rbx, %rbx
    movq         %r8, (%rdi)
    add          $(8), %rdi
    sub          $(1), %rax
    jg           .Lupdate1gas_66
.Lupdate2gas_66: 
    movq         (%rsi), %r8
    add          $(8), %rsi
    neg          %rbx
    adc          $(0), %r8
    sbb          %rbx, %rbx
    movq         %r8, (%rdi)
    add          $(8), %rdi
    sub          $(1), %rdx
    jg           .Lupdate2gas_66
    add          $(256), %rsp
.Ladd_diagonalsgas_66: 
    pop          %rcx
    pop          %rsi
    pop          %rdi
    sub          $(4), %rcx
    xor          %rbx, %rbx
.Ladd_diagonal_loopgas_66: 
    call         _add_diag_4
    add          $(64), %rdi
    add          $(32), %rsi
    sub          $(4), %rcx
    jnc          .Ladd_diagonal_loopgas_66
    add          $(4), %rcx
    jz           .Lquitgas_66
.Ladd_diagonal_restgas_66: 
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    xor          %rbp, %rbp
    add          %r8, %r8
    adc          %r9, %r9
    adc          $(0), %rbp
    mov          (%rsi), %rdx
    mulx         %rdx, %rax, %rdx
    add          %rbx, %rax
    adc          $(0), %rdx
    add          %rax, %r8
    mov          %rbp, %rbx
    adc          %rdx, %r9
    adc          $(0), %rbx
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    add          $(16), %rdi
    add          $(8), %rsi
    sub          $(1), %rcx
    jnz          .Ladd_diagonal_restgas_66
.Lquitgas_66: 
    ret
 
.p2align 5, 0x90
 


 
_sub_N:
    xor          %rax, %rax
.Lsub_nextgas_67: 
    lea          (8)(%rdi), %rdi
    movq         (%rsi), %r8
    movq         (%rcx), %r9
    lea          (8)(%rsi), %rsi
    lea          (8)(%rcx), %rcx
    sbb          %r9, %r8
    movq         %r8, (-8)(%rdi)
    dec          %rdx
    jnz          .Lsub_nextgas_67
    adc          $(0), %rax
    ret
 
.p2align 5, 0x90
 


 
_copy_ae_N:
    lea          (8)(%rdi), %rdi
    movq         (%rsi), %r8
    movq         (%rcx), %r9
    lea          (8)(%rsi), %rsi
    lea          (8)(%rcx), %rcx
    cmovae       %r9, %r8
    movq         %r8, (-8)(%rdi)
    dec          %rdx
    jnz          _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred1_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rbx, %r8
    ret
 
.p2align 5, 0x90
 


 
_mred2_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mov          %rbp, %r9
    ret
 
.p2align 5, 0x90
 


 
_mred3_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    ret
 
.p2align 5, 0x90
 


 
_mred4_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    ret
 
.p2align 5, 0x90
 


 
_mred5_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    ret
 
.p2align 5, 0x90
 


 
_mred6_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mov          %rbp, %r13
    ret
 
.p2align 5, 0x90
 


 
_mred7_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mov          %rbx, %r14
    ret
 
.p2align 5, 0x90
 


 
_mred8_start:
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (32)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mulx         (40)(%rsi), %r12, %rbp
    add          %r13, %r12
    adc          $(0), %rbp
    add          %rbx, %r12
    adc          $(0), %rbp
    mulx         (48)(%rsi), %r13, %rbx
    add          %r14, %r13
    adc          $(0), %rbx
    add          %rbp, %r13
    adc          $(0), %rbx
    mulx         (56)(%rsi), %r14, %rbp
    add          %r15, %r14
    adc          $(0), %rbp
    add          %rbx, %r14
    adc          $(0), %rbp
    mov          %rbp, %r15
    ret
 
.p2align 5, 0x90
 


 
_mred8x1_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x2_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x3_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x4_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (24)(%rcx)
    call         _mred8_start
    mov          %rax, (24)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x5_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (24)(%rcx)
    call         _mred8_start
    mov          %rax, (24)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (32)(%rcx)
    call         _mred8_start
    mov          %rax, (32)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x6_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (24)(%rcx)
    call         _mred8_start
    mov          %rax, (24)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (32)(%rcx)
    call         _mred8_start
    mov          %rax, (32)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (40)(%rcx)
    call         _mred8_start
    mov          %rax, (40)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x7_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (24)(%rcx)
    call         _mred8_start
    mov          %rax, (24)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (32)(%rcx)
    call         _mred8_start
    mov          %rax, (32)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (40)(%rcx)
    call         _mred8_start
    mov          %rax, (40)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (48)(%rcx)
    call         _mred8_start
    mov          %rax, (48)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred8x8_start:
    push         %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (%rcx)
    call         _mred8_start
    mov          %rax, (%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (8)(%rcx)
    call         _mred8_start
    mov          %rax, (8)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (16)(%rcx)
    call         _mred8_start
    mov          %rax, (16)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (24)(%rcx)
    call         _mred8_start
    mov          %rax, (24)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (32)(%rcx)
    call         _mred8_start
    mov          %rax, (32)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (40)(%rcx)
    call         _mred8_start
    mov          %rax, (40)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (48)(%rcx)
    call         _mred8_start
    mov          %rax, (48)(%rdi)
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    movq         %rdx, (56)(%rcx)
    call         _mred8_start
    mov          %rax, (56)(%rdi)
    pop          %rdx
    ret
 
.p2align 5, 0x90
 


 
_mred_5:
 
    push         %r8
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred5_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred5_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred5_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred5_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred5_start
    pop          %rax
    xor          %rax, %rax
    mov          (40)(%rdi), %rbx
    add          %rbx, %r8
    movq         %r8, (40)(%rdi)
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r9
    movq         %r9, (48)(%rdi)
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r10
    movq         %r10, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r11
    movq         %r11, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r12
    movq         %r12, (72)(%rdi)
    adc          $(0), %rax
    mov          (%rsi), %rbx
    sub          %rbx, %r8
    mov          (8)(%rsi), %rbx
    sbb          %rbx, %r9
    mov          (16)(%rsi), %rbx
    sbb          %rbx, %r10
    mov          (24)(%rsi), %rbx
    sbb          %rbx, %r11
    mov          (32)(%rsi), %rbx
    sbb          %rbx, %r12
    sbb          $(0), %rax
    movq         (40)(%rdi), %rax
    movq         (48)(%rdi), %rbx
    movq         (56)(%rdi), %rcx
    movq         (64)(%rdi), %rdx
    movq         (72)(%rdi), %rbp
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    cmovae       %r12, %rbp
    movq         %rax, (%r15)
    movq         %rbx, (8)(%r15)
    movq         %rcx, (16)(%r15)
    movq         %rdx, (24)(%r15)
    movq         %rbp, (32)(%r15)
    ret
 
.p2align 5, 0x90
 


 
_mred_6:
 
    push         %r8
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred6_start
    pop          %rax
    xor          %rax, %rax
    mov          (48)(%rdi), %rbx
    add          %rbx, %r8
    movq         %r8, (48)(%rdi)
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r9
    movq         %r9, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r10
    movq         %r10, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r11
    movq         %r11, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r12
    movq         %r12, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r13
    movq         %r13, (88)(%rdi)
    adc          $(0), %rax
    mov          (%rsi), %rbx
    sub          %rbx, %r8
    mov          (8)(%rsi), %rbx
    sbb          %rbx, %r9
    mov          (16)(%rsi), %rbx
    sbb          %rbx, %r10
    mov          (24)(%rsi), %rbx
    sbb          %rbx, %r11
    mov          (32)(%rsi), %rbx
    sbb          %rbx, %r12
    mov          (40)(%rsi), %rbx
    sbb          %rbx, %r13
    sbb          $(0), %rax
    movq         (48)(%rdi), %rax
    movq         (56)(%rdi), %rbx
    movq         (64)(%rdi), %rcx
    movq         (72)(%rdi), %rdx
    movq         (80)(%rdi), %rbp
    movq         (88)(%rdi), %rsi
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    cmovae       %r12, %rbp
    cmovae       %r13, %rsi
    movq         %rax, (%r15)
    movq         %rbx, (8)(%r15)
    movq         %rcx, (16)(%r15)
    movq         %rdx, (24)(%r15)
    movq         %rbp, (32)(%r15)
    movq         %rsi, (40)(%r15)
    ret
 
.p2align 5, 0x90
 


 
_mred_7:
 
    push         %r8
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred7_start
    pop          %rax
    xor          %rax, %rax
    mov          (56)(%rdi), %rbx
    add          %rbx, %r8
    movq         %r8, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r9
    movq         %r9, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r10
    movq         %r10, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r11
    movq         %r11, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r12
    movq         %r12, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r13
    movq         %r13, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r14
    movq         %r14, (104)(%rdi)
    adc          $(0), %rax
    mov          (%rsi), %rbx
    sub          %rbx, %r8
    mov          (8)(%rsi), %rbx
    sbb          %rbx, %r9
    mov          (16)(%rsi), %rbx
    sbb          %rbx, %r10
    mov          (24)(%rsi), %rbx
    sbb          %rbx, %r11
    mov          (32)(%rsi), %rbx
    sbb          %rbx, %r12
    mov          (40)(%rsi), %rbx
    sbb          %rbx, %r13
    mov          (48)(%rsi), %rbx
    sbb          %rbx, %r14
    sbb          $(0), %rax
    movq         (56)(%rdi), %rax
    movq         (64)(%rdi), %rbx
    movq         (72)(%rdi), %rcx
    movq         (80)(%rdi), %rdx
    movq         (88)(%rdi), %rbp
    movq         (96)(%rdi), %rsi
    movq         (104)(%rdi), %rdi
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    cmovae       %r12, %rbp
    cmovae       %r13, %rsi
    cmovae       %r14, %rdi
    movq         %rax, (%r15)
    movq         %rbx, (8)(%r15)
    movq         %rcx, (16)(%r15)
    movq         %rdx, (24)(%r15)
    movq         %rbp, (32)(%r15)
    movq         %rsi, (40)(%r15)
    movq         %rdi, (48)(%r15)
    ret
 
.p2align 5, 0x90
 


 
_mred_8:
 
    push         %r15
    push         %r8
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    mov          (%rsp), %rdx
    mulx         %r8, %rdx, %rbx
    call         _mred8_start
    pop          %rax
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    movq         %r8, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    movq         %r9, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    movq         %r10, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    movq         %r11, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    movq         %r12, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    movq         %r13, (104)(%rdi)
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    movq         %r14, (112)(%rdi)
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    movq         %r15, (120)(%rdi)
    adc          $(0), %rax
    mov          (%rsi), %rbx
    sub          %rbx, %r8
    mov          (8)(%rsi), %rbx
    sbb          %rbx, %r9
    mov          (16)(%rsi), %rbx
    sbb          %rbx, %r10
    mov          (24)(%rsi), %rbx
    sbb          %rbx, %r11
    mov          (32)(%rsi), %rbx
    sbb          %rbx, %r12
    mov          (40)(%rsi), %rbx
    sbb          %rbx, %r13
    mov          (48)(%rsi), %rbx
    sbb          %rbx, %r14
    mov          (56)(%rsi), %rbx
    sbb          %rbx, %r15
    sbb          $(0), %rax
    pop          %rsi
    movq         (64)(%rdi), %rax
    movq         (72)(%rdi), %rbx
    movq         (80)(%rdi), %rcx
    movq         (88)(%rdi), %rdx
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    movq         %rax, (%rsi)
    movq         %rbx, (8)(%rsi)
    movq         %rcx, (16)(%rsi)
    movq         %rdx, (24)(%rsi)
    movq         (96)(%rdi), %rax
    movq         (104)(%rdi), %rbx
    movq         (112)(%rdi), %rcx
    movq         (120)(%rdi), %rdx
    cmovae       %r12, %rax
    cmovae       %r13, %rbx
    cmovae       %r14, %rcx
    cmovae       %r15, %rdx
    movq         %rax, (32)(%rsi)
    movq         %rbx, (40)(%rsi)
    movq         %rcx, (48)(%rsi)
    movq         %rdx, (56)(%rsi)
    ret
 
.p2align 5, 0x90
 


 
_mred_9:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x1
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (64)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x1_start
    xor          %rax, %rax
    movq         %r8, (8)(%rdi)
    movq         %r9, (16)(%rdi)
    movq         %r10, (24)(%rdi)
    movq         %r11, (32)(%rdi)
    movq         %r12, (40)(%rdi)
    movq         %r13, (48)(%rdi)
    movq         %r14, (56)(%rdi)
    mov          %r15, %r8
    addq         (64)(%rdi), %r8
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_1x1
    pop          %rax
    shr          $(1), %rax
    mov          (8)(%rdi), %rbx
    adc          %rbx, %r8
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    movq         %r8, (8)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-56)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(9), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(72), %rdi
    sub          $(72), %rsi
    mov          %rdi, %rcx
    mov          $(9), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_10:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x2
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    movq         %r10, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %r12, (48)(%rdi)
    movq         %r13, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (72)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x2_start
    xor          %rax, %rax
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    movq         %r10, (32)(%rdi)
    movq         %r11, (40)(%rdi)
    movq         %r12, (48)(%rdi)
    movq         %r13, (56)(%rdi)
    mov          %r14, %r8
    mov          %r15, %r9
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_2x2
    pop          %rax
    shr          $(1), %rax
    mov          (16)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (24)(%rdi), %rbx
    adc          %rbx, %r9
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-48)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(10), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(80), %rdi
    sub          $(80), %rsi
    mov          %rdi, %rcx
    mov          $(10), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_11:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x3
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    movq         %r11, (48)(%rdi)
    movq         %r12, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (80)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x3_start
    xor          %rax, %rax
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    movq         %r11, (48)(%rdi)
    movq         %r12, (56)(%rdi)
    mov          %r13, %r8
    mov          %r14, %r9
    mov          %r15, %r10
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adcq         (80)(%rdi), %r10
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_3x3
    pop          %rax
    shr          $(1), %rax
    mov          (24)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (32)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (40)(%rdi), %rbx
    adc          %rbx, %r10
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-40)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(11), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(88), %rdi
    sub          $(88), %rsi
    mov          %rdi, %rcx
    mov          $(11), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_12:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x4
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (88)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x4_start
    xor          %rax, %rax
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    mov          %r12, %r8
    mov          %r13, %r9
    mov          %r14, %r10
    mov          %r15, %r11
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adcq         (80)(%rdi), %r10
    adcq         (88)(%rdi), %r11
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_4x4
    pop          %rax
    shr          $(1), %rax
    mov          (32)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (40)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r11
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-32)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(12), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(96), %rdi
    sub          $(96), %rsi
    mov          %rdi, %rcx
    mov          $(12), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_13:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x5
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (96)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x5_start
    xor          %rax, %rax
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    mov          %r11, %r8
    mov          %r12, %r9
    mov          %r13, %r10
    mov          %r14, %r11
    mov          %r15, %r12
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adcq         (80)(%rdi), %r10
    adcq         (88)(%rdi), %r11
    adcq         (96)(%rdi), %r12
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_5x5
    pop          %rax
    shr          $(1), %rax
    mov          (40)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r12
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    movq         %r8, (40)(%rdi)
    movq         %r9, (48)(%rdi)
    movq         %r10, (56)(%rdi)
    movq         %r11, (64)(%rdi)
    movq         %r12, (72)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-24)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(13), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(104), %rdi
    sub          $(104), %rsi
    mov          %rdi, %rcx
    mov          $(13), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_14:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x6
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r10
    mov          %r10, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (104)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x6_start
    xor          %rax, %rax
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    mov          %r10, %r8
    mov          %r11, %r9
    mov          %r12, %r10
    mov          %r13, %r11
    mov          %r14, %r12
    mov          %r15, %r13
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adcq         (80)(%rdi), %r10
    adcq         (88)(%rdi), %r11
    adcq         (96)(%rdi), %r12
    adcq         (104)(%rdi), %r13
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_6x6
    pop          %rax
    shr          $(1), %rax
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r13
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    movq         %r8, (48)(%rdi)
    movq         %r9, (56)(%rdi)
    movq         %r10, (64)(%rdi)
    movq         %r11, (72)(%rdi)
    movq         %r12, (80)(%rdi)
    movq         %r13, (88)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-16)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(14), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(112), %rdi
    sub          $(112), %rsi
    mov          %rdi, %rcx
    mov          $(14), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_15:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    push         %r8
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    call         _mla_8x7
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    pop          %rax
    shr          $(1), %rax
    movq         %r8, (56)(%rdi)
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r9
    mov          %r9, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r10
    mov          %r10, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (104)(%rdi)
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (112)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rdx
    call         _mred8x7_start
    xor          %rax, %rax
    movq         %r8, (56)(%rdi)
    mov          %r9, %r8
    mov          %r10, %r9
    mov          %r11, %r10
    mov          %r12, %r11
    mov          %r13, %r12
    mov          %r14, %r13
    mov          %r15, %r14
    addq         (64)(%rdi), %r8
    adcq         (72)(%rdi), %r9
    adcq         (80)(%rdi), %r10
    adcq         (88)(%rdi), %r11
    adcq         (96)(%rdi), %r12
    adcq         (104)(%rdi), %r13
    adcq         (112)(%rdi), %r14
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_7x7
    pop          %rax
    shr          $(1), %rax
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r14
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    movq         %r8, (56)(%rdi)
    movq         %r9, (64)(%rdi)
    movq         %r10, (72)(%rdi)
    movq         %r11, (80)(%rdi)
    movq         %r12, (88)(%rdi)
    movq         %r13, (96)(%rdi)
    movq         %r14, (104)(%rdi)
    adc          $(0), %rax
    pop          %rcx
    add          $(64), %rsp
    lea          (-64)(%rsi), %rcx
    lea          (-8)(%rdi), %rsi
    pop          %rdi
    mov          %rax, %rbx
    mov          $(15), %rdx
    call         _sub_N
    sub          %rax, %rbx
    sub          $(120), %rdi
    sub          $(120), %rsi
    mov          %rdi, %rcx
    mov          $(15), %rdx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_16:
 
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rsi
    add          $(64), %rdi
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    pop          %rax
    shr          $(1), %rax
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r8
    mov          %r8, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          %r9, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          %r10, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (104)(%rdi)
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (112)(%rdi)
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (120)(%rdi)
    adc          $(0), %rax
    push         %rax
    sub          $(64), %rsi
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    call         _mla_8x8
    sub          $(64), %rsi
    pop          %rax
    shr          $(1), %rax
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    adc          $(0), %rax
    movq         %r8, (64)(%rdi)
    movq         %r9, (72)(%rdi)
    movq         %r10, (80)(%rdi)
    movq         %r11, (88)(%rdi)
    movq         %r12, (96)(%rdi)
    movq         %r13, (104)(%rdi)
    movq         %r14, (112)(%rdi)
    movq         %r15, (120)(%rdi)
    add          $(64), %rsp
    pop          %rbp
    mov          (%rdi), %rbx
    sub          (%rsi), %rbx
    mov          %rbx, (%rbp)
    mov          (8)(%rdi), %rbx
    sbb          (8)(%rsi), %rbx
    mov          %rbx, (8)(%rbp)
    mov          (16)(%rdi), %rbx
    sbb          (16)(%rsi), %rbx
    mov          %rbx, (16)(%rbp)
    mov          (24)(%rdi), %rbx
    sbb          (24)(%rsi), %rbx
    mov          %rbx, (24)(%rbp)
    mov          (32)(%rdi), %rbx
    sbb          (32)(%rsi), %rbx
    mov          %rbx, (32)(%rbp)
    mov          (40)(%rdi), %rbx
    sbb          (40)(%rsi), %rbx
    mov          %rbx, (40)(%rbp)
    mov          (48)(%rdi), %rbx
    sbb          (48)(%rsi), %rbx
    mov          %rbx, (48)(%rbp)
    mov          (56)(%rdi), %rbx
    sbb          (56)(%rsi), %rbx
    mov          %rbx, (56)(%rbp)
    mov          (64)(%rsi), %rbx
    sbb          %rbx, %r8
    mov          (72)(%rsi), %rbx
    sbb          %rbx, %r9
    mov          (80)(%rsi), %rbx
    sbb          %rbx, %r10
    mov          (88)(%rsi), %rbx
    sbb          %rbx, %r11
    mov          (96)(%rsi), %rbx
    sbb          %rbx, %r12
    mov          (104)(%rsi), %rbx
    sbb          %rbx, %r13
    mov          (112)(%rsi), %rbx
    sbb          %rbx, %r14
    mov          (120)(%rsi), %rbx
    sbb          %rbx, %r15
    sbb          $(0), %rax
    movq         (64)(%rdi), %rax
    movq         (72)(%rdi), %rbx
    movq         (80)(%rdi), %rcx
    movq         (88)(%rdi), %rdx
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    movq         %rax, (64)(%rbp)
    movq         %rbx, (72)(%rbp)
    movq         %rcx, (80)(%rbp)
    movq         %rdx, (88)(%rbp)
    movq         (96)(%rdi), %rax
    movq         (104)(%rdi), %rbx
    movq         (112)(%rdi), %rcx
    movq         (120)(%rdi), %rdx
    cmovae       %r12, %rax
    cmovae       %r13, %rbx
    cmovae       %r14, %rcx
    cmovae       %r15, %rdx
    movq         %rax, (96)(%rbp)
    movq         %rbx, (104)(%rbp)
    movq         %rcx, (112)(%rbp)
    movq         %rdx, (120)(%rbp)
    movq         (%rbp), %r8
    movq         (8)(%rbp), %r9
    movq         (16)(%rbp), %r10
    movq         (24)(%rbp), %r11
    movq         (32)(%rbp), %r12
    movq         (40)(%rbp), %r13
    movq         (48)(%rbp), %r14
    movq         (56)(%rbp), %r15
    movq         (%rdi), %rax
    movq         (8)(%rdi), %rbx
    movq         (16)(%rdi), %rcx
    movq         (24)(%rdi), %rdx
    cmovae       %r8, %rax
    cmovae       %r9, %rbx
    cmovae       %r10, %rcx
    cmovae       %r11, %rdx
    movq         %rax, (%rbp)
    movq         %rbx, (8)(%rbp)
    movq         %rcx, (16)(%rbp)
    movq         %rdx, (24)(%rbp)
    movq         (32)(%rdi), %rax
    movq         (40)(%rdi), %rbx
    movq         (48)(%rdi), %rcx
    movq         (56)(%rdi), %rdx
    cmovae       %r12, %rax
    cmovae       %r13, %rbx
    cmovae       %r14, %rcx
    cmovae       %r15, %rdx
    movq         %rax, (32)(%rbp)
    movq         %rbx, (40)(%rbp)
    movq         %rcx, (48)(%rbp)
    movq         %rdx, (56)(%rbp)
    ret
 
mred_short:
.quad  _mred_5 - mred_short 
 

.quad  _mred_6 - mred_short 
 

.quad  _mred_7 - mred_short 
 

.quad  _mred_8 - mred_short 
 

.quad  _mred_9 - mred_short 
 

.quad  _mred_10 - mred_short 
 

.quad  _mred_11 - mred_short 
 

.quad  _mred_12 - mred_short 
 

.quad  _mred_13 - mred_short 
 

.quad  _mred_14 - mred_short 
 

.quad  _mred_15 - mred_short 
 

.quad  _mred_16 - mred_short 
 
mred8x_start:
.quad  _mred8x1_start - mred8x_start 
 

.quad  _mred8x2_start - mred8x_start 
 

.quad  _mred8x3_start - mred8x_start 
 

.quad  _mred8x4_start - mred8x_start 
 

.quad  _mred8x5_start - mred8x_start 
 

.quad  _mred8x6_start - mred8x_start 
 

.quad  _mred8x7_start - mred8x_start 
.p2align 5, 0x90
 


 
_mred_8N:
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    mov          %rdx, %rbx
    xor          %rax, %rax
.LpassLoopgas_97: 
    push         %rdi
    push         %rsi
    push         %rdx
    push         %r8
    push         %rbx
    push         %rax
    push         %rdx
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    pop          %rdx
    xor          %rax, %rax
    mov          (64)(%rdi), %rbx
    add          %rbx, %r8
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
    jmp          .LentryInnerLoopgas_97
.LinnerLoopgas_97: 
    push         %rdx
    call         _mla_8x8
    pop          %rdx
    pop          %rax
    shr          $(1), %rax
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r8
    mov          %r8, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          %r9, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          %r10, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (104)(%rdi)
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (112)(%rdi)
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (120)(%rdi)
    adc          $(0), %rax
    push         %rax
.LentryInnerLoopgas_97: 
    add          $(64), %rdi
    add          $(64), %rsi
    sub          $(8), %rdx
    jg           .LinnerLoopgas_97
    pop          %rax
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    adc          $(0), %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    pop          %rbx
    pop          %r8
    pop          %rdx
    pop          %rsi
    pop          %rdi
    add          $(64), %rdi
    sub          $(8), %rbx
    jg           .LpassLoopgas_97
    add          $(64), %rsp
    mov          %rdx, %r14
    lea          (,%rdx,8), %r15
    mov          %rax, %rbx
    mov          %rsi, %rcx
    mov          %rdi, %rsi
    pop          %rdi
    call         _sub_N
    sub          %rax, %rbx
    mov          %r14, %rdx
    sub          %r15, %rdi
    sub          %r15, %rsi
    mov          %rdi, %rcx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 


 
_mred_N:
    push         %r15
    sub          $(64), %rsp
    mov          %rsp, %rcx
    mov          %rdx, %rbx
    sub          $(8), %rbx
    xor          %rax, %rax
    mov          $(7), %r15
    and          %rdx, %r15
    lea          mla_8xl_tail(%rip), %rbp
    mov          (-8)(%rbp,%r15,8), %r15
    add          %r15, %rbp
.LpassLoopgas_98: 
    push         %rdi
    push         %rsi
    push         %rdx
    push         %r8
    push         %rbx
    push         %rax
    push         %rbp
    sub          $(8), %rdx
    push         %rdx
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    call         _mred8x8_start
    pop          %rdx
    xor          %rax, %rax
    push         %rax
    jmp          .LentryInnerLoopgas_98
.LinnerLoopgas_98: 
    push         %rdx
    call         _mla_8x8
    pop          %rdx
.LentryInnerLoopgas_98: 
    pop          %rax
    shr          $(1), %rax
    mov          (64)(%rdi), %rbx
    adc          %rbx, %r8
    mov          %r8, (64)(%rdi)
    mov          (72)(%rdi), %rbx
    adc          %rbx, %r9
    mov          %r9, (72)(%rdi)
    mov          (80)(%rdi), %rbx
    adc          %rbx, %r10
    mov          %r10, (80)(%rdi)
    mov          (88)(%rdi), %rbx
    adc          %rbx, %r11
    mov          %r11, (88)(%rdi)
    mov          (96)(%rdi), %rbx
    adc          %rbx, %r12
    mov          %r12, (96)(%rdi)
    mov          (104)(%rdi), %rbx
    adc          %rbx, %r13
    mov          %r13, (104)(%rdi)
    mov          (112)(%rdi), %rbx
    adc          %rbx, %r14
    mov          %r14, (112)(%rdi)
    mov          (120)(%rdi), %rbx
    adc          %rbx, %r15
    mov          %r15, (120)(%rdi)
    adc          $(0), %rax
    push         %rax
    add          $(64), %rdi
    add          $(64), %rsi
    sub          $(8), %rdx
    jnc          .LinnerLoopgas_98
    add          $(8), %rdx
    jz           .Lcomplete_regular_passgas_98
    mov          (8)(%rsp), %rax
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    push         %rdx
    call         *%rax
    pop          %rdx
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    lea          (%rdi,%rdx,8), %rdi
    pop          %rax
    shr          $(1), %rax
    mov          %rdx, %rbx
    dec          %rbx
    jz           .Lmt_1gas_98
    dec          %rbx
    jz           .Lmt_2gas_98
    dec          %rbx
    jz           .Lmt_3gas_98
    dec          %rbx
    jz           .Lmt_4gas_98
    dec          %rbx
    jz           .Lmt_5gas_98
    dec          %rbx
    jz           .Lmt_6gas_98
.Lmt_7gas_98:  
    mov          (8)(%rdi), %rbx
    adc          %rbx, %r9
.Lmt_6gas_98:  
    mov          (16)(%rdi), %rbx
    adc          %rbx, %r10
.Lmt_5gas_98:  
    mov          (24)(%rdi), %rbx
    adc          %rbx, %r11
.Lmt_4gas_98:  
    mov          (32)(%rdi), %rbx
    adc          %rbx, %r12
.Lmt_3gas_98:  
    mov          (40)(%rdi), %rbx
    adc          %rbx, %r13
.Lmt_2gas_98:  
    mov          (48)(%rdi), %rbx
    adc          %rbx, %r14
.Lmt_1gas_98:  
    mov          (56)(%rdi), %rbx
    adc          %rbx, %r15
    adc          $(0), %rax
    push         %rax
.Lcomplete_regular_passgas_98: 
    pop          %rax
    pop          %rbp
    pop          %rbx
    add          %rbx, %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    adc          $(0), %rax
    movq         %r8, (%rdi)
    movq         %r9, (8)(%rdi)
    movq         %r10, (16)(%rdi)
    movq         %r11, (24)(%rdi)
    movq         %r12, (32)(%rdi)
    movq         %r13, (40)(%rdi)
    movq         %r14, (48)(%rdi)
    movq         %r15, (56)(%rdi)
    pop          %rbx
    pop          %r8
    pop          %rdx
    pop          %rsi
    pop          %rdi
    add          $(64), %rdi
    sub          $(8), %rbx
    jnc          .LpassLoopgas_98
    add          $(8), %rbx
    jz           .Lcomplete_reductiongas_98
    push         %rdi
    push         %rsi
    push         %rdx
    push         %r8
    push         %rbx
    push         %rax
    push         %rbp
    sub          $(8), %rdx
    push         %rdx
    mov          %r8, %rdx
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    lea          mred8x_start(%rip), %rax
    mov          (-8)(%rax,%rbx,8), %rbp
    add          %rbp, %rax
    call         *%rax
    pop          %rdx
    xor          %rax, %rax
    push         %rax
    jmp          .LentryTailLoopgas_98
.LtailLoopgas_98: 
    movq         (%rdi), %r8
    movq         (8)(%rdi), %r9
    movq         (16)(%rdi), %r10
    movq         (24)(%rdi), %r11
    movq         (32)(%rdi), %r12
    movq         (40)(%rdi), %r13
    movq         (48)(%rdi), %r14
    movq         (56)(%rdi), %r15
    mov          (8)(%rsp), %rax
    push         %rdx
    call         *%rax
    pop          %rdx
.LentryTailLoopgas_98: 
    pop          %rax
    shr          $(1), %rax
    adc          $(0), %r8
    adc          $(0), %r9
    adc          $(0), %r10
    adc          $(0), %r11
    adc          $(0), %r12
    adc          $(0), %r13
    adc          $(0), %r14
    adc          $(0), %r15
    adc          $(0), %rax
    mov          (16)(%rsp), %rbx
    cmp          $(1), %rbx
    jz           .Ltt_1gas_98
    cmp          $(2), %rbx
    jz           .Ltt_2gas_98
    cmp          $(3), %rbx
    jz           .Ltt_3gas_98
    cmp          $(4), %rbx
    jz           .Ltt_4gas_98
    cmp          $(5), %rbx
    jz           .Ltt_5gas_98
    cmp          $(6), %rbx
    jz           .Ltt_6gas_98
.Ltt_7gas_98:  
    mov          (8)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r9
.Ltt_6gas_98:  
    mov          (16)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r10
.Ltt_5gas_98:  
    mov          (24)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r11
.Ltt_4gas_98:  
    mov          (32)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r12
.Ltt_3gas_98:  
    mov          (40)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r13
.Ltt_2gas_98:  
    mov          (48)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r14
.Ltt_1gas_98:  
    mov          (56)(%rdi,%rbx,8), %rbp
    adc          %rbp, %r15
    adc          $(0), %rax
    push         %rax
    movq         %r8, (%rdi,%rbx,8)
    movq         %r9, (8)(%rdi,%rbx,8)
    movq         %r10, (16)(%rdi,%rbx,8)
    movq         %r11, (24)(%rdi,%rbx,8)
    movq         %r12, (32)(%rdi,%rbx,8)
    movq         %r13, (40)(%rdi,%rbx,8)
    movq         %r14, (48)(%rdi,%rbx,8)
    movq         %r15, (56)(%rdi,%rbx,8)
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(8), %rdx
    jnc          .LtailLoopgas_98
    add          $(8), %rdx
    mov          %rdx, %rbx
    movq         (%rdi), %r8
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (8)(%rdi), %r9
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (16)(%rdi), %r10
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (24)(%rdi), %r11
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (32)(%rdi), %r12
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (40)(%rdi), %r13
    dec          %rbx
    jz           .Lget_tail_procgas_98
    movq         (48)(%rdi), %r14
.Lget_tail_procgas_98: 
    lea          mla_lxl_short(%rip), %rax
    mov          (-8)(%rax,%rdx,8), %rbp
    add          %rbp, %rax
    push         %rdx
    call         *%rax
    pop          %rdx
    lea          (%rdi,%rdx,8), %rdi
    pop          %rax
    shr          $(1), %rax
    mov          %rdx, %rbx
    mov          (%rdi), %rbp
    adc          %rbp, %r8
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (8)(%rdi), %rbp
    adc          %rbp, %r9
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (16)(%rdi), %rbp
    adc          %rbp, %r10
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (24)(%rdi), %rbp
    adc          %rbp, %r11
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (32)(%rdi), %rbp
    adc          %rbp, %r12
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (40)(%rdi), %rbp
    adc          %rbp, %r13
    dec          %rbx
    jz           .Ladd_carry1gas_98
    mov          (48)(%rdi), %rbp
    adc          %rbp, %r14
.Ladd_carry1gas_98: 
    adc          $(0), %rax
    pop          %rbp
    pop          %rbx
    add          %rbx, %r8
    movq         %r8, (%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r9
    movq         %r9, (8)(%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r10
    movq         %r10, (16)(%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r11
    movq         %r11, (24)(%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r12
    movq         %r12, (32)(%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r13
    movq         %r13, (40)(%rdi)
    dec          %rdx
    jz           .Ladd_carry2gas_98
    adc          $(0), %r14
    movq         %r14, (48)(%rdi)
.Ladd_carry2gas_98: 
    adc          $(0), %rax
    pop          %rbx
    pop          %r8
    pop          %rdx
    pop          %rsi
    pop          %rdi
    lea          (%rdi,%rbx,8), %rdi
.Lcomplete_reductiongas_98: 
    add          $(64), %rsp
    mov          %rdx, %r14
    lea          (,%rdx,8), %r15
    mov          %rax, %rbx
    mov          %rsi, %rcx
    mov          %rdi, %rsi
    pop          %rdi
    call         _sub_N
    sub          %rax, %rbx
    mov          %r14, %rdx
    sub          %r15, %rdi
    sub          %r15, %rsi
    mov          %rdi, %rcx
    shr          $(1), %rbx
    call         _copy_ae_N
    ret
 
.p2align 5, 0x90
 
.globl _cpMulAdc_BNU_school

 
_cpMulAdc_BNU_school:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movslq       %edx, %rdx
    movslq       %r8d, %rbx
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    xor          %r12, %r12
    xor          %r13, %r13
    xor          %r14, %r14
    xor          %r15, %r15
    cmp          %rbx, %rdx
    jl           .Lswap_operansgas_99
    jg           .Ltest_8N_casegas_99
    cmp          $(16), %rdx
    jg           .Ltest_8N_casegas_99
    cmp          $(4), %rdx
    jg           .Lmore_then_4gas_99
    cmp          $(3), %edx
    ja           .Lmul_4_4gas_99
    jz           .Lmul_3_3gas_99
    jp           .Lmul_2_2gas_99
.Lmul_1_1gas_99: 
    mov          (%rcx), %rdx
    mulx         (%rsi), %rbp, %r8
    mov          %rbp, (%rdi)
    movq         %r8, (8)(%rdi)
    jmp          .Lquitgas_99
.Lmul_2_2gas_99: 
    mov          (%rcx), %rdx
    mulx         (%rsi), %rbp, %r8
    mov          %rbp, (%rdi)
    mulx         (8)(%rsi), %rbx, %r9
    add          %rbx, %r8
    adc          $(0), %r9
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mov          %rbp, %r9
    movq         %r8, (16)(%rdi)
    movq         %r9, (24)(%rdi)
    jmp          .Lquitgas_99
.Lmul_3_3gas_99: 
    mov          (%rcx), %rdx
    mulx         (%rsi), %rbp, %r8
    mov          %rbp, (%rdi)
    mulx         (8)(%rsi), %rbx, %r9
    add          %rbx, %r8
    mulx         (16)(%rsi), %rbp, %r10
    adc          %rbp, %r9
    adc          $(0), %r10
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    mov          (16)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (16)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    movq         %r8, (24)(%rdi)
    movq         %r9, (32)(%rdi)
    movq         %r10, (40)(%rdi)
    jmp          .Lquitgas_99
.Lmul_4_4gas_99: 
    mov          (%rcx), %rdx
    mulx         (%rsi), %rbp, %r8
    mov          %rbp, (%rdi)
    mulx         (8)(%rsi), %rbx, %r9
    add          %rbx, %r8
    mulx         (16)(%rsi), %rbp, %r10
    adc          %rbp, %r9
    mulx         (24)(%rsi), %rbx, %r11
    adc          %rbx, %r10
    adc          $(0), %r11
    mov          (8)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (8)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    mov          (16)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (16)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    mov          (24)(%rcx), %rdx
    mulx         (%rsi), %rax, %rbx
    add          %r8, %rax
    adc          $(0), %rbx
    mov          %rax, (24)(%rdi)
    mulx         (8)(%rsi), %r8, %rbp
    add          %r9, %r8
    adc          $(0), %rbp
    add          %rbx, %r8
    adc          $(0), %rbp
    mulx         (16)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (24)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    movq         %r8, (32)(%rdi)
    movq         %r9, (40)(%rdi)
    movq         %r10, (48)(%rdi)
    movq         %r11, (56)(%rdi)
    jmp          .Lquitgas_99
.Lmore_then_4gas_99: 
    lea          mul_lxl_basic(%rip), %rax
    mov          (-8)(%rax,%rdx,8), %rbp
    add          %rbp, %rax
    call         *%rax
    jmp          .Lquitgas_99
.Lswap_operansgas_99: 
    xor          %rcx, %rsi
    xor          %rsi, %rcx
    xor          %rcx, %rsi
    xor          %rbx, %rdx
    xor          %rdx, %rbx
    xor          %rbx, %rdx
.Ltest_8N_casegas_99: 
    mov          %rdx, %rax
    or           %rbx, %rax
    and          $(7), %rax
    jnz          .Lgeneral_mulgas_99
    call         _mul_8Nx8M
    jmp          .Lquitgas_99
.Lgeneral_mulgas_99: 
    call         _mul_NxM
    jmp          .Lquitgas_99
.Lquitgas_99: 
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
.p2align 5, 0x90
 
.globl _cpSqrAdc_BNU_school

 
_cpSqrAdc_BNU_school:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    movslq       %edx, %rdx
    xor          %r8, %r8
    xor          %r9, %r9
    xor          %r10, %r10
    xor          %r11, %r11
    xor          %r12, %r12
    xor          %r13, %r13
    xor          %r14, %r14
    xor          %r15, %r15
    cmp          $(16), %rdx
    jg           .Ltest_8N_casegas_100
    lea          sqr_l_basic(%rip), %rax
    mov          (-8)(%rax,%rdx,8), %rbp
    add          %rbp, %rax
    call         *%rax
    jmp          .Lquitgas_100
.Ltest_8N_casegas_100: 
    test         $(7), %rdx
    jnz          .Lgeneral_sqrgas_100
    call         _sqr_8N
    jmp          .Lquitgas_100
.Lgeneral_sqrgas_100: 
    call         _sqr_N
.Lquitgas_100: 
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
.p2align 5, 0x90
 
.globl _cpMontRedAdc_BNU

 
_cpMontRedAdc_BNU:
 
    push         %rbx
 
    push         %rbp
 
    push         %r12
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    mov          %rdi, %r15
    mov          %rsi, %rdi
    mov          %rdx, %rsi
    movslq       %ecx, %rdx
    cmp          $(16), %rdx
    ja           .Ltest_8N_casegas_101
    cmp          $(4), %rdx
    ja           .Labove4gas_101
    cmp          $(3), %rdx
    ja           .Lred_4gas_101
    jz           .Lred_3gas_101
    jp           .Lred_2gas_101
.Lred_1gas_101: 
    movq         (%rdi), %r9
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mov          %rbp, %r9
    xor          %rbx, %rbx
    addq         (8)(%rdi), %r9
    movq         %r9, (8)(%rdi)
    adc          $(0), %rbx
    subq         (%rsi), %r9
    sbb          $(0), %rbx
    movq         (8)(%rdi), %rax
    cmovae       %r9, %rax
    movq         %rax, (%r15)
    jmp          .Lquitgas_101
.Lred_2gas_101: 
    movq         (%rdi), %r9
    movq         (8)(%rdi), %r10
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mov          %rbx, %r10
    xor          %rbx, %rbx
    addq         (16)(%rdi), %r9
    movq         %r9, (16)(%rdi)
    adcq         (24)(%rdi), %r10
    movq         %r10, (24)(%rdi)
    adc          $(0), %rbx
    subq         (%rsi), %r9
    sbbq         (8)(%rsi), %r10
    sbb          $(0), %rbx
    movq         (16)(%rdi), %rax
    cmovae       %r9, %rax
    movq         %rax, (%r15)
    movq         (24)(%rdi), %rax
    cmovae       %r10, %rax
    movq         %rax, (8)(%r15)
    jmp          .Lquitgas_101
.Lred_3gas_101: 
    movq         (%rdi), %r9
    movq         (8)(%rdi), %r10
    movq         (16)(%rdi), %r11
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mov          %rbp, %r11
    xor          %rbx, %rbx
    addq         (24)(%rdi), %r9
    movq         %r9, (24)(%rdi)
    adcq         (32)(%rdi), %r10
    movq         %r10, (32)(%rdi)
    adcq         (40)(%rdi), %r11
    movq         %r11, (40)(%rdi)
    adc          $(0), %rbx
    subq         (%rsi), %r9
    sbbq         (8)(%rsi), %r10
    sbbq         (16)(%rsi), %r11
    sbb          $(0), %rbx
    movq         (24)(%rdi), %rax
    cmovae       %r9, %rax
    movq         %rax, (%r15)
    movq         (32)(%rdi), %rax
    cmovae       %r10, %rax
    movq         %rax, (8)(%r15)
    movq         (40)(%rdi), %rax
    cmovae       %r11, %rax
    movq         %rax, (16)(%r15)
    jmp          .Lquitgas_101
.Lred_4gas_101: 
    movq         (%rdi), %r9
    movq         (8)(%rdi), %r10
    movq         (16)(%rdi), %r11
    movq         (24)(%rdi), %r12
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    mov          %r8, %rdx
    imul         %r9, %rdx
    mulx         (%rsi), %rax, %rbp
    add          %r9, %rax
    adc          $(0), %rbp
    mulx         (8)(%rsi), %r9, %rbx
    add          %r10, %r9
    adc          $(0), %rbx
    add          %rbp, %r9
    adc          $(0), %rbx
    mulx         (16)(%rsi), %r10, %rbp
    add          %r11, %r10
    adc          $(0), %rbp
    add          %rbx, %r10
    adc          $(0), %rbp
    mulx         (24)(%rsi), %r11, %rbx
    add          %r12, %r11
    adc          $(0), %rbx
    add          %rbp, %r11
    adc          $(0), %rbx
    mov          %rbx, %r12
    xor          %rbx, %rbx
    addq         (32)(%rdi), %r9
    movq         %r9, (32)(%rdi)
    adcq         (40)(%rdi), %r10
    movq         %r10, (40)(%rdi)
    adcq         (48)(%rdi), %r11
    movq         %r11, (48)(%rdi)
    adcq         (56)(%rdi), %r12
    movq         %r12, (56)(%rdi)
    adc          $(0), %rbx
    subq         (%rsi), %r9
    sbbq         (8)(%rsi), %r10
    sbbq         (16)(%rsi), %r11
    sbbq         (24)(%rsi), %r12
    sbb          $(0), %rbx
    movq         (32)(%rdi), %rax
    cmovae       %r9, %rax
    movq         %rax, (%r15)
    movq         (40)(%rdi), %rax
    cmovae       %r10, %rax
    movq         %rax, (8)(%r15)
    movq         (48)(%rdi), %rax
    cmovae       %r11, %rax
    movq         %rax, (16)(%r15)
    movq         (56)(%rdi), %rax
    cmovae       %r12, %rax
    movq         %rax, (24)(%r15)
    jmp          .Lquitgas_101
.Labove4gas_101: 
    mov          %rdx, %rbp
    sub          $(4), %rbp
    lea          mred_short(%rip), %rax
    mov          (-8)(%rax,%rbp,8), %rbp
    add          %rbp, %rax
    call         *%rax
    jmp          .Lquitgas_101
.Ltest_8N_casegas_101: 
    test         $(7), %rdx
    jnz          .Lgeneral_casegas_101
    call         _mred_8N
    jmp          .Lquitgas_101
.Lgeneral_casegas_101: 
    call         _mred_N
.Lquitgas_101: 
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    pop          %r12
 
    pop          %rbp
 
    pop          %rbx
 
    ret
 
