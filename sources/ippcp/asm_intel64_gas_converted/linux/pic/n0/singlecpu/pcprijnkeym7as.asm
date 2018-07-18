###############################################################################
# Copyright 2018 Intel Corporation
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
 
.globl Touch_SubsDword_8uT
.type Touch_SubsDword_8uT, @function
 
Touch_SubsDword_8uT:
 
    movslq       %edx, %r8
    xor          %rcx, %rcx
.Ltouch_tblgas_1: 
    mov          (%rsi,%rcx), %rax
    add          $(64), %rcx
    cmp          %r8, %rcx
    jl           .Ltouch_tblgas_1
    mov          %rdi, %rax
    and          $(255), %rax
    movzbq       (%rsi,%rax), %rax
    shr          $(8), %rdi
    mov          %rdi, %r9
    and          $(255), %r9
    movzbq       (%r9,%rsi), %r9
    shl          $(8), %r9
    shr          $(8), %rdi
    mov          %rdi, %rcx
    and          $(255), %rcx
    movzbq       (%rsi,%rcx), %rcx
    shl          $(16), %rcx
    shr          $(8), %rdi
    mov          %rdi, %rdx
    and          $(255), %rdx
    movzbq       (%rsi,%rdx), %rdx
    shl          $(24), %rdx
    or           %r9, %rax
    or           %rcx, %rax
    or           %rdx, %rax
 
    ret
.Lfe1:
.size Touch_SubsDword_8uT, .Lfe1-(Touch_SubsDword_8uT)
 
