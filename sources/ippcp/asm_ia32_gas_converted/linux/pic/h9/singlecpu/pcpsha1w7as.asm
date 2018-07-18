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
.p2align 5, 0x90
 
.globl UpdateSHA1
.type UpdateSHA1, @function
 
UpdateSHA1:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    movl         (20)(%ebp), %eax
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %eax
    movl         (8)(%ebp), %edi
    sub          $(76), %esp
    mov          %edi, (64)(%esp)
.Lsha1_block_loopgas_1: 
    mov          %esi, (68)(%esp)
    mov          %eax, (72)(%esp)
    xor          %ecx, %ecx
.Lloop1gas_1: 
    mov          (%esi,%ecx,4), %eax
    mov          (4)(%esi,%ecx,4), %edx
    bswap        %eax
    bswap        %edx
    mov          %eax, (%esp,%ecx,4)
    mov          %edx, (4)(%esp,%ecx,4)
    add          $(2), %ecx
    cmp          $(16), %ecx
    jl           .Lloop1gas_1
    mov          (%edi), %eax
    mov          (4)(%edi), %ebx
    mov          (8)(%edi), %ecx
    mov          (12)(%edi), %edx
    mov          (16)(%edi), %ebp
 
    mov          %ecx, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (%esp), %ebp
    lea          (1518500249)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (%esp), %esi
    xor          (8)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (52)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (%esp)
 
    mov          %ebx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (4)(%esp), %edx
    lea          (1518500249)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (4)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (56)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (4)(%esp)
 
    mov          %eax, %edi
    xor          %ebx, %edi
    and          %ebp, %edi
    xor          %ebx, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (8)(%esp), %ecx
    lea          (1518500249)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (8)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (60)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (8)(%esp)
 
    mov          %ebp, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %eax, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (12)(%esp), %ebx
    lea          (1518500249)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (12)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (%esp), %esi
    rol          $(1), %esi
    mov          %esi, (12)(%esp)
 
    mov          %edx, %edi
    xor          %ebp, %edi
    and          %ecx, %edi
    xor          %ebp, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (16)(%esp), %eax
    lea          (1518500249)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (16)(%esp), %esi
    xor          (24)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (4)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (16)(%esp)
 
    mov          %ecx, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (20)(%esp), %ebp
    lea          (1518500249)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (20)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (8)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (20)(%esp)
 
    mov          %ebx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (24)(%esp), %edx
    lea          (1518500249)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (24)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (12)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (24)(%esp)
 
    mov          %eax, %edi
    xor          %ebx, %edi
    and          %ebp, %edi
    xor          %ebx, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (28)(%esp), %ecx
    lea          (1518500249)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (28)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (16)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (28)(%esp)
 
    mov          %ebp, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %eax, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (32)(%esp), %ebx
    lea          (1518500249)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (32)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (%esp), %esi
    xor          (20)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (32)(%esp)
 
    mov          %edx, %edi
    xor          %ebp, %edi
    and          %ecx, %edi
    xor          %ebp, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (36)(%esp), %eax
    lea          (1518500249)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (36)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (24)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (36)(%esp)
 
    mov          %ecx, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (40)(%esp), %ebp
    lea          (1518500249)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (40)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (8)(%esp), %esi
    xor          (28)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (40)(%esp)
 
    mov          %ebx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (44)(%esp), %edx
    lea          (1518500249)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (44)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (32)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (44)(%esp)
 
    mov          %eax, %edi
    xor          %ebx, %edi
    and          %ebp, %edi
    xor          %ebx, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (48)(%esp), %ecx
    lea          (1518500249)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (48)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (36)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (48)(%esp)
 
    mov          %ebp, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %eax, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (52)(%esp), %ebx
    lea          (1518500249)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (52)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (40)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (52)(%esp)
 
    mov          %edx, %edi
    xor          %ebp, %edi
    and          %ecx, %edi
    xor          %ebp, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (56)(%esp), %eax
    lea          (1518500249)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (56)(%esp), %esi
    xor          (%esp), %esi
    xor          (24)(%esp), %esi
    xor          (44)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (56)(%esp)
 
    mov          %ecx, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (60)(%esp), %ebp
    lea          (1518500249)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (60)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (48)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (60)(%esp)
 
    mov          %ebx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (%esp), %edx
    lea          (1518500249)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (%esp), %esi
    xor          (8)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (52)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (%esp)
 
    mov          %eax, %edi
    xor          %ebx, %edi
    and          %ebp, %edi
    xor          %ebx, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (4)(%esp), %ecx
    lea          (1518500249)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (4)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (56)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (4)(%esp)
 
    mov          %ebp, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %eax, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (8)(%esp), %ebx
    lea          (1518500249)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (8)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (60)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (8)(%esp)
 
    mov          %edx, %edi
    xor          %ebp, %edi
    and          %ecx, %edi
    xor          %ebp, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (12)(%esp), %eax
    lea          (1518500249)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (12)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (%esp), %esi
    rol          $(1), %esi
    mov          %esi, (12)(%esp)
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (16)(%esp), %ebp
    lea          (1859775393)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (16)(%esp), %esi
    xor          (24)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (4)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (16)(%esp)
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (20)(%esp), %edx
    lea          (1859775393)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (20)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (8)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (20)(%esp)
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (24)(%esp), %ecx
    lea          (1859775393)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (24)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (12)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (24)(%esp)
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (28)(%esp), %ebx
    lea          (1859775393)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (28)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (16)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (28)(%esp)
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (32)(%esp), %eax
    lea          (1859775393)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (32)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (%esp), %esi
    xor          (20)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (32)(%esp)
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (36)(%esp), %ebp
    lea          (1859775393)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (36)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (24)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (36)(%esp)
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (40)(%esp), %edx
    lea          (1859775393)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (40)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (8)(%esp), %esi
    xor          (28)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (40)(%esp)
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (44)(%esp), %ecx
    lea          (1859775393)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (44)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (32)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (44)(%esp)
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (48)(%esp), %ebx
    lea          (1859775393)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (48)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (36)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (48)(%esp)
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (52)(%esp), %eax
    lea          (1859775393)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (52)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (40)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (52)(%esp)
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (56)(%esp), %ebp
    lea          (1859775393)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (56)(%esp), %esi
    xor          (%esp), %esi
    xor          (24)(%esp), %esi
    xor          (44)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (56)(%esp)
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (60)(%esp), %edx
    lea          (1859775393)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (60)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (48)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (60)(%esp)
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (%esp), %ecx
    lea          (1859775393)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (%esp), %esi
    xor          (8)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (52)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (%esp)
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (4)(%esp), %ebx
    lea          (1859775393)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (4)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (56)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (4)(%esp)
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (8)(%esp), %eax
    lea          (1859775393)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (8)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (60)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (8)(%esp)
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (12)(%esp), %ebp
    lea          (1859775393)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (12)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (%esp), %esi
    rol          $(1), %esi
    mov          %esi, (12)(%esp)
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (16)(%esp), %edx
    lea          (1859775393)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (16)(%esp), %esi
    xor          (24)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (4)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (16)(%esp)
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (20)(%esp), %ecx
    lea          (1859775393)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (20)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (8)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (20)(%esp)
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (24)(%esp), %ebx
    lea          (1859775393)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (24)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (12)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (24)(%esp)
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (28)(%esp), %eax
    lea          (1859775393)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (28)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (16)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (28)(%esp)
 
    mov          %ebx, %edi
    mov          %ebx, %esi
    or           %ecx, %edi
    and          %ecx, %esi
    and          %edx, %edi
    or           %esi, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (32)(%esp), %ebp
    lea          (2400959708)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (32)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (%esp), %esi
    xor          (20)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (32)(%esp)
 
    mov          %eax, %edi
    mov          %eax, %esi
    or           %ebx, %edi
    and          %ebx, %esi
    and          %ecx, %edi
    or           %esi, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (36)(%esp), %edx
    lea          (2400959708)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (36)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (24)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (36)(%esp)
 
    mov          %ebp, %edi
    mov          %ebp, %esi
    or           %eax, %edi
    and          %eax, %esi
    and          %ebx, %edi
    or           %esi, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (40)(%esp), %ecx
    lea          (2400959708)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (40)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (8)(%esp), %esi
    xor          (28)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (40)(%esp)
 
    mov          %edx, %edi
    mov          %edx, %esi
    or           %ebp, %edi
    and          %ebp, %esi
    and          %eax, %edi
    or           %esi, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (44)(%esp), %ebx
    lea          (2400959708)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (44)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (32)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (44)(%esp)
 
    mov          %ecx, %edi
    mov          %ecx, %esi
    or           %edx, %edi
    and          %edx, %esi
    and          %ebp, %edi
    or           %esi, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (48)(%esp), %eax
    lea          (2400959708)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (48)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (36)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (48)(%esp)
 
    mov          %ebx, %edi
    mov          %ebx, %esi
    or           %ecx, %edi
    and          %ecx, %esi
    and          %edx, %edi
    or           %esi, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (52)(%esp), %ebp
    lea          (2400959708)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (52)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (40)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (52)(%esp)
 
    mov          %eax, %edi
    mov          %eax, %esi
    or           %ebx, %edi
    and          %ebx, %esi
    and          %ecx, %edi
    or           %esi, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (56)(%esp), %edx
    lea          (2400959708)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (56)(%esp), %esi
    xor          (%esp), %esi
    xor          (24)(%esp), %esi
    xor          (44)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (56)(%esp)
 
    mov          %ebp, %edi
    mov          %ebp, %esi
    or           %eax, %edi
    and          %eax, %esi
    and          %ebx, %edi
    or           %esi, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (60)(%esp), %ecx
    lea          (2400959708)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (60)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (48)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (60)(%esp)
 
    mov          %edx, %edi
    mov          %edx, %esi
    or           %ebp, %edi
    and          %ebp, %esi
    and          %eax, %edi
    or           %esi, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (%esp), %ebx
    lea          (2400959708)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (%esp), %esi
    xor          (8)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (52)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (%esp)
 
    mov          %ecx, %edi
    mov          %ecx, %esi
    or           %edx, %edi
    and          %edx, %esi
    and          %ebp, %edi
    or           %esi, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (4)(%esp), %eax
    lea          (2400959708)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (4)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (56)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (4)(%esp)
 
    mov          %ebx, %edi
    mov          %ebx, %esi
    or           %ecx, %edi
    and          %ecx, %esi
    and          %edx, %edi
    or           %esi, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (8)(%esp), %ebp
    lea          (2400959708)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (8)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (60)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (8)(%esp)
 
    mov          %eax, %edi
    mov          %eax, %esi
    or           %ebx, %edi
    and          %ebx, %esi
    and          %ecx, %edi
    or           %esi, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (12)(%esp), %edx
    lea          (2400959708)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (12)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (%esp), %esi
    rol          $(1), %esi
    mov          %esi, (12)(%esp)
 
    mov          %ebp, %edi
    mov          %ebp, %esi
    or           %eax, %edi
    and          %eax, %esi
    and          %ebx, %edi
    or           %esi, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (16)(%esp), %ecx
    lea          (2400959708)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (16)(%esp), %esi
    xor          (24)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (4)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (16)(%esp)
 
    mov          %edx, %edi
    mov          %edx, %esi
    or           %ebp, %edi
    and          %ebp, %esi
    and          %eax, %edi
    or           %esi, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (20)(%esp), %ebx
    lea          (2400959708)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (20)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (8)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (20)(%esp)
 
    mov          %ecx, %edi
    mov          %ecx, %esi
    or           %edx, %edi
    and          %edx, %esi
    and          %ebp, %edi
    or           %esi, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (24)(%esp), %eax
    lea          (2400959708)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (24)(%esp), %esi
    xor          (32)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (12)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (24)(%esp)
 
    mov          %ebx, %edi
    mov          %ebx, %esi
    or           %ecx, %edi
    and          %ecx, %esi
    and          %edx, %edi
    or           %esi, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (28)(%esp), %ebp
    lea          (2400959708)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (28)(%esp), %esi
    xor          (36)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (16)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (28)(%esp)
 
    mov          %eax, %edi
    mov          %eax, %esi
    or           %ebx, %edi
    and          %ebx, %esi
    and          %ecx, %edi
    or           %esi, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (32)(%esp), %edx
    lea          (2400959708)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (32)(%esp), %esi
    xor          (40)(%esp), %esi
    xor          (%esp), %esi
    xor          (20)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (32)(%esp)
 
    mov          %ebp, %edi
    mov          %ebp, %esi
    or           %eax, %edi
    and          %eax, %esi
    and          %ebx, %edi
    or           %esi, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (36)(%esp), %ecx
    lea          (2400959708)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (36)(%esp), %esi
    xor          (44)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (24)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (36)(%esp)
 
    mov          %edx, %edi
    mov          %edx, %esi
    or           %ebp, %edi
    and          %ebp, %esi
    and          %eax, %edi
    or           %esi, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (40)(%esp), %ebx
    lea          (2400959708)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (40)(%esp), %esi
    xor          (48)(%esp), %esi
    xor          (8)(%esp), %esi
    xor          (28)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (40)(%esp)
 
    mov          %ecx, %edi
    mov          %ecx, %esi
    or           %edx, %edi
    and          %edx, %esi
    and          %ebp, %edi
    or           %esi, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (44)(%esp), %eax
    lea          (2400959708)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (44)(%esp), %esi
    xor          (52)(%esp), %esi
    xor          (12)(%esp), %esi
    xor          (32)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (44)(%esp)
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (48)(%esp), %ebp
    lea          (3395469782)(%ebp,%edi), %ebp
    add          %esi, %ebp
    mov          (48)(%esp), %esi
    xor          (56)(%esp), %esi
    xor          (16)(%esp), %esi
    xor          (36)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (48)(%esp)
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (52)(%esp), %edx
    lea          (3395469782)(%edi,%edx), %edx
    add          %esi, %edx
    mov          (52)(%esp), %esi
    xor          (60)(%esp), %esi
    xor          (20)(%esp), %esi
    xor          (40)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (52)(%esp)
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (56)(%esp), %ecx
    lea          (3395469782)(%edi,%ecx), %ecx
    add          %esi, %ecx
    mov          (56)(%esp), %esi
    xor          (%esp), %esi
    xor          (24)(%esp), %esi
    xor          (44)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (56)(%esp)
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (60)(%esp), %ebx
    lea          (3395469782)(%edi,%ebx), %ebx
    add          %esi, %ebx
    mov          (60)(%esp), %esi
    xor          (4)(%esp), %esi
    xor          (28)(%esp), %esi
    xor          (48)(%esp), %esi
    rol          $(1), %esi
    mov          %esi, (60)(%esp)
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (%esp), %eax
    lea          (3395469782)(%edi,%eax), %eax
    add          %esi, %eax
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (4)(%esp), %ebp
    lea          (3395469782)(%ebp,%edi), %ebp
    add          %esi, %ebp
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (8)(%esp), %edx
    lea          (3395469782)(%edi,%edx), %edx
    add          %esi, %edx
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (12)(%esp), %ecx
    lea          (3395469782)(%edi,%ecx), %ecx
    add          %esi, %ecx
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (16)(%esp), %ebx
    lea          (3395469782)(%edi,%ebx), %ebx
    add          %esi, %ebx
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (20)(%esp), %eax
    lea          (3395469782)(%edi,%eax), %eax
    add          %esi, %eax
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (24)(%esp), %ebp
    lea          (3395469782)(%ebp,%edi), %ebp
    add          %esi, %ebp
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (28)(%esp), %edx
    lea          (3395469782)(%edi,%edx), %edx
    add          %esi, %edx
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (32)(%esp), %ecx
    lea          (3395469782)(%edi,%ecx), %ecx
    add          %esi, %ecx
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (36)(%esp), %ebx
    lea          (3395469782)(%edi,%ebx), %ebx
    add          %esi, %ebx
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (40)(%esp), %eax
    lea          (3395469782)(%edi,%eax), %eax
    add          %esi, %eax
 
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    ror          $(2), %ebx
    mov          %eax, %esi
    rol          $(5), %esi
    add          (44)(%esp), %ebp
    lea          (3395469782)(%ebp,%edi), %ebp
    add          %esi, %ebp
 
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    ror          $(2), %eax
    mov          %ebp, %esi
    rol          $(5), %esi
    add          (48)(%esp), %edx
    lea          (3395469782)(%edi,%edx), %edx
    add          %esi, %edx
 
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %ebp, %edi
    ror          $(2), %ebp
    mov          %edx, %esi
    rol          $(5), %esi
    add          (52)(%esp), %ecx
    lea          (3395469782)(%edi,%ecx), %ecx
    add          %esi, %ecx
 
    mov          %eax, %edi
    xor          %ebp, %edi
    xor          %edx, %edi
    ror          $(2), %edx
    mov          %ecx, %esi
    rol          $(5), %esi
    add          (56)(%esp), %ebx
    lea          (3395469782)(%edi,%ebx), %ebx
    add          %esi, %ebx
 
    mov          %ebp, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    ror          $(2), %ecx
    mov          %ebx, %esi
    rol          $(5), %esi
    add          (60)(%esp), %eax
    lea          (3395469782)(%edi,%eax), %eax
    add          %esi, %eax
    mov          (64)(%esp), %edi
    mov          (68)(%esp), %esi
    add          %eax, (%edi)
    mov          (72)(%esp), %eax
    add          %ebx, (4)(%edi)
    add          %ecx, (8)(%edi)
    add          %edx, (12)(%edi)
    add          %ebp, (16)(%edi)
    add          $(64), %esi
    sub          $(64), %eax
    jg           .Lsha1_block_loopgas_1
    add          $(76), %esp
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size UpdateSHA1, .Lfe1-(UpdateSHA1)
 
