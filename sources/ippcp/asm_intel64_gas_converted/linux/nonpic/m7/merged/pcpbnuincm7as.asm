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
 
.globl m7_cpInc_BNU
.type m7_cpInc_BNU, @function
 
m7_cpInc_BNU:
 
    movslq       %edx, %rdx
    movq         (%rsi), %r8
    add          %rcx, %r8
    movq         %r8, (%rdi)
    lea          (%rsi,%rdx,8), %rsi
    lea          (%rdi,%rdx,8), %rdi
    lea          (,%rdx,8), %rcx
    sbb          %rax, %rax
    neg          %rcx
    add          $(8), %rcx
    jrcxz        .Lexitgas_1
    add          %rax, %rax
    jnc          .Lcopygas_1
.p2align 4, 0x90
.Linc_loopgas_1: 
    movq         (%rsi,%rcx), %r8
    adc          $(0), %r8
    movq         %r8, (%rdi,%rcx)
    lea          (8)(%rcx), %rcx
    jrcxz        .Lexit_loopgas_1
    jnc          .Lexit_loopgas_1
    jmp          .Linc_loopgas_1
.Lexit_loopgas_1: 
    sbb          %rax, %rax
.Lcopygas_1: 
    cmp          %rdi, %rsi
    jz           .Lexitgas_1
    jrcxz        .Lexitgas_1
.Lcopy_loopgas_1: 
    movq         (%rsi,%rcx), %r8
    movq         %r8, (%rdi,%rcx)
    add          $(8), %rcx
    jnz          .Lcopy_loopgas_1
.Lexitgas_1: 
    neg          %rax
 
    ret
.Lfe1:
.size m7_cpInc_BNU, .Lfe1-(m7_cpInc_BNU)
.p2align 4, 0x90
 
.globl m7_cpDec_BNU
.type m7_cpDec_BNU, @function
 
m7_cpDec_BNU:
 
    movslq       %edx, %rdx
    movq         (%rsi), %r8
    sub          %rcx, %r8
    movq         %r8, (%rdi)
    lea          (%rsi,%rdx,8), %rsi
    lea          (%rdi,%rdx,8), %rdi
    lea          (,%rdx,8), %rcx
    sbb          %rax, %rax
    neg          %rcx
    add          $(8), %rcx
    jrcxz        .Lexitgas_2
    add          %rax, %rax
    jnc          .Lcopygas_2
.p2align 4, 0x90
.Linc_loopgas_2: 
    movq         (%rsi,%rcx), %r8
    sbb          $(0), %r8
    movq         %r8, (%rdi,%rcx)
    lea          (8)(%rcx), %rcx
    jrcxz        .Lexit_loopgas_2
    jnc          .Lexit_loopgas_2
    jmp          .Linc_loopgas_2
.Lexit_loopgas_2: 
    sbb          %rax, %rax
.Lcopygas_2: 
    cmp          %rdi, %rsi
    jz           .Lexitgas_2
    jrcxz        .Lexitgas_2
.Lcopy_loopgas_2: 
    movq         (%rsi,%rcx), %r8
    movq         %r8, (%rdi,%rcx)
    add          $(8), %rcx
    jnz          .Lcopy_loopgas_2
.Lexitgas_2: 
    neg          %rax
 
    ret
.Lfe2:
.size m7_cpDec_BNU, .Lfe2-(m7_cpDec_BNU)
 
