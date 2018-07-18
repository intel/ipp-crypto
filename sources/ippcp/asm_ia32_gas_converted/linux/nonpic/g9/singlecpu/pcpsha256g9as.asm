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
SWP_BYTE: 
 
pByteSwp:
.byte  3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12 
.p2align 5, 0x90
 
.globl UpdateSHA256
.type UpdateSHA256, @function
 
UpdateSHA256:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(52), %esp
.Lsha256_block_loopgas_1: 
    movl         (8)(%ebp), %eax
    vmovdqu      (%eax), %xmm0
    vmovdqu      (16)(%eax), %xmm1
    vmovdqu      %xmm0, (%esp)
    vmovdqu      %xmm1, (16)(%esp)
    movl         (12)(%ebp), %eax
    movl         (20)(%ebp), %ebx
    lea          SWP_BYTE, %ecx
    movdqa       ((pByteSwp-SWP_BYTE))(%ecx), %xmm6
    vmovdqu      (%eax), %xmm0
    vmovdqu      (16)(%eax), %xmm1
    vmovdqu      (32)(%eax), %xmm2
    vmovdqu      (48)(%eax), %xmm3
 
    mov          (16)(%esp), %eax
    mov          (%esp), %edx
    vpshufb      %xmm6, %xmm0, %xmm0
    vpaddd       (%ebx), %xmm0, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (20)(%esp), %edi
    xor          (24)(%esp), %edi
    and          %eax, %edi
    xor          (24)(%esp), %edi
    mov          (28)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (4)(%esp), %esi
    movl         (8)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (12)(%esp), %eax
    mov          %edx, (28)(%esp)
    mov          %eax, (12)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (16)(%esp), %edi
    xor          (20)(%esp), %edi
    and          %eax, %edi
    xor          (20)(%esp), %edi
    mov          (24)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (%esp), %esi
    movl         (4)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (8)(%esp), %eax
    mov          %edx, (24)(%esp)
    mov          %eax, (8)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (12)(%esp), %edi
    xor          (16)(%esp), %edi
    and          %eax, %edi
    xor          (16)(%esp), %edi
    mov          (20)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (28)(%esp), %esi
    movl         (%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (4)(%esp), %eax
    mov          %edx, (20)(%esp)
    mov          %eax, (4)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (8)(%esp), %edi
    xor          (12)(%esp), %edi
    and          %eax, %edi
    xor          (12)(%esp), %edi
    mov          (16)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (24)(%esp), %esi
    movl         (28)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (%esp), %eax
    mov          %edx, (16)(%esp)
    mov          %eax, (%esp)
    vpshufb      %xmm6, %xmm1, %xmm1
    vpaddd       (16)(%ebx), %xmm1, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (4)(%esp), %edi
    xor          (8)(%esp), %edi
    and          %eax, %edi
    xor          (8)(%esp), %edi
    mov          (12)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (20)(%esp), %esi
    movl         (24)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (28)(%esp), %eax
    mov          %edx, (12)(%esp)
    mov          %eax, (28)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (%esp), %edi
    xor          (4)(%esp), %edi
    and          %eax, %edi
    xor          (4)(%esp), %edi
    mov          (8)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (16)(%esp), %esi
    movl         (20)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (24)(%esp), %eax
    mov          %edx, (8)(%esp)
    mov          %eax, (24)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (28)(%esp), %edi
    xor          (%esp), %edi
    and          %eax, %edi
    xor          (%esp), %edi
    mov          (4)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (12)(%esp), %esi
    movl         (16)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (20)(%esp), %eax
    mov          %edx, (4)(%esp)
    mov          %eax, (20)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (24)(%esp), %edi
    xor          (28)(%esp), %edi
    and          %eax, %edi
    xor          (28)(%esp), %edi
    mov          (%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (8)(%esp), %esi
    movl         (12)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (16)(%esp), %eax
    mov          %edx, (%esp)
    mov          %eax, (16)(%esp)
    vpshufb      %xmm6, %xmm2, %xmm2
    vpaddd       (32)(%ebx), %xmm2, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (20)(%esp), %edi
    xor          (24)(%esp), %edi
    and          %eax, %edi
    xor          (24)(%esp), %edi
    mov          (28)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (4)(%esp), %esi
    movl         (8)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (12)(%esp), %eax
    mov          %edx, (28)(%esp)
    mov          %eax, (12)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (16)(%esp), %edi
    xor          (20)(%esp), %edi
    and          %eax, %edi
    xor          (20)(%esp), %edi
    mov          (24)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (%esp), %esi
    movl         (4)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (8)(%esp), %eax
    mov          %edx, (24)(%esp)
    mov          %eax, (8)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (12)(%esp), %edi
    xor          (16)(%esp), %edi
    and          %eax, %edi
    xor          (16)(%esp), %edi
    mov          (20)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (28)(%esp), %esi
    movl         (%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (4)(%esp), %eax
    mov          %edx, (20)(%esp)
    mov          %eax, (4)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (8)(%esp), %edi
    xor          (12)(%esp), %edi
    and          %eax, %edi
    xor          (12)(%esp), %edi
    mov          (16)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (24)(%esp), %esi
    movl         (28)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (%esp), %eax
    mov          %edx, (16)(%esp)
    mov          %eax, (%esp)
    vpshufb      %xmm6, %xmm3, %xmm3
    vpaddd       (48)(%ebx), %xmm3, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (4)(%esp), %edi
    xor          (8)(%esp), %edi
    and          %eax, %edi
    xor          (8)(%esp), %edi
    mov          (12)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (20)(%esp), %esi
    movl         (24)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (28)(%esp), %eax
    mov          %edx, (12)(%esp)
    mov          %eax, (28)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (%esp), %edi
    xor          (4)(%esp), %edi
    and          %eax, %edi
    xor          (4)(%esp), %edi
    mov          (8)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (16)(%esp), %esi
    movl         (20)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (24)(%esp), %eax
    mov          %edx, (8)(%esp)
    mov          %eax, (24)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (28)(%esp), %edi
    xor          (%esp), %edi
    and          %eax, %edi
    xor          (%esp), %edi
    mov          (4)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (12)(%esp), %esi
    movl         (16)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (20)(%esp), %eax
    mov          %edx, (4)(%esp)
    mov          %eax, (20)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (24)(%esp), %edi
    xor          (28)(%esp), %edi
    and          %eax, %edi
    xor          (28)(%esp), %edi
    mov          (%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (8)(%esp), %esi
    movl         (12)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (16)(%esp), %eax
    mov          %edx, (%esp)
    mov          %eax, (16)(%esp)
    movl         $(48), (48)(%esp)
.Lloop_16_63gas_1: 
    add          $(64), %ebx
    vpshufd      $(250), %xmm3, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpshufd      $(165), %xmm0, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpshufd      $(80), %xmm0, %xmm7
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(165), %xmm2, %xmm6
    vpaddd       %xmm4, %xmm7, %xmm7
    vpaddd       %xmm6, %xmm7, %xmm7
    vpshufd      $(160), %xmm7, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpalignr     $(12), %xmm0, %xmm1, %xmm6
    vpshufd      $(80), %xmm6, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpalignr     $(12), %xmm2, %xmm3, %xmm6
    vpshufd      $(250), %xmm0, %xmm0
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(80), %xmm6, %xmm6
    vpaddd       %xmm4, %xmm0, %xmm0
    vpaddd       %xmm6, %xmm0, %xmm0
    vpshufd      $(136), %xmm7, %xmm7
    vpshufd      $(136), %xmm0, %xmm0
    vpalignr     $(8), %xmm7, %xmm0, %xmm0
    vpaddd       (%ebx), %xmm0, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (20)(%esp), %edi
    xor          (24)(%esp), %edi
    and          %eax, %edi
    xor          (24)(%esp), %edi
    mov          (28)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (4)(%esp), %esi
    movl         (8)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (12)(%esp), %eax
    mov          %edx, (28)(%esp)
    mov          %eax, (12)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (16)(%esp), %edi
    xor          (20)(%esp), %edi
    and          %eax, %edi
    xor          (20)(%esp), %edi
    mov          (24)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (%esp), %esi
    movl         (4)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (8)(%esp), %eax
    mov          %edx, (24)(%esp)
    mov          %eax, (8)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (12)(%esp), %edi
    xor          (16)(%esp), %edi
    and          %eax, %edi
    xor          (16)(%esp), %edi
    mov          (20)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (28)(%esp), %esi
    movl         (%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (4)(%esp), %eax
    mov          %edx, (20)(%esp)
    mov          %eax, (4)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (8)(%esp), %edi
    xor          (12)(%esp), %edi
    and          %eax, %edi
    xor          (12)(%esp), %edi
    mov          (16)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (24)(%esp), %esi
    movl         (28)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (%esp), %eax
    mov          %edx, (16)(%esp)
    mov          %eax, (%esp)
    vpshufd      $(250), %xmm0, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpshufd      $(165), %xmm1, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpshufd      $(80), %xmm1, %xmm7
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(165), %xmm3, %xmm6
    vpaddd       %xmm4, %xmm7, %xmm7
    vpaddd       %xmm6, %xmm7, %xmm7
    vpshufd      $(160), %xmm7, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpalignr     $(12), %xmm1, %xmm2, %xmm6
    vpshufd      $(80), %xmm6, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpalignr     $(12), %xmm3, %xmm0, %xmm6
    vpshufd      $(250), %xmm1, %xmm1
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(80), %xmm6, %xmm6
    vpaddd       %xmm4, %xmm1, %xmm1
    vpaddd       %xmm6, %xmm1, %xmm1
    vpshufd      $(136), %xmm7, %xmm7
    vpshufd      $(136), %xmm1, %xmm1
    vpalignr     $(8), %xmm7, %xmm1, %xmm1
    vpaddd       (16)(%ebx), %xmm1, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (4)(%esp), %edi
    xor          (8)(%esp), %edi
    and          %eax, %edi
    xor          (8)(%esp), %edi
    mov          (12)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (20)(%esp), %esi
    movl         (24)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (28)(%esp), %eax
    mov          %edx, (12)(%esp)
    mov          %eax, (28)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (%esp), %edi
    xor          (4)(%esp), %edi
    and          %eax, %edi
    xor          (4)(%esp), %edi
    mov          (8)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (16)(%esp), %esi
    movl         (20)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (24)(%esp), %eax
    mov          %edx, (8)(%esp)
    mov          %eax, (24)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (28)(%esp), %edi
    xor          (%esp), %edi
    and          %eax, %edi
    xor          (%esp), %edi
    mov          (4)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (12)(%esp), %esi
    movl         (16)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (20)(%esp), %eax
    mov          %edx, (4)(%esp)
    mov          %eax, (20)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (24)(%esp), %edi
    xor          (28)(%esp), %edi
    and          %eax, %edi
    xor          (28)(%esp), %edi
    mov          (%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (8)(%esp), %esi
    movl         (12)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (16)(%esp), %eax
    mov          %edx, (%esp)
    mov          %eax, (16)(%esp)
    vpshufd      $(250), %xmm1, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpshufd      $(165), %xmm2, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpshufd      $(80), %xmm2, %xmm7
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(165), %xmm0, %xmm6
    vpaddd       %xmm4, %xmm7, %xmm7
    vpaddd       %xmm6, %xmm7, %xmm7
    vpshufd      $(160), %xmm7, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpalignr     $(12), %xmm2, %xmm3, %xmm6
    vpshufd      $(80), %xmm6, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpalignr     $(12), %xmm0, %xmm1, %xmm6
    vpshufd      $(250), %xmm2, %xmm2
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(80), %xmm6, %xmm6
    vpaddd       %xmm4, %xmm2, %xmm2
    vpaddd       %xmm6, %xmm2, %xmm2
    vpshufd      $(136), %xmm7, %xmm7
    vpshufd      $(136), %xmm2, %xmm2
    vpalignr     $(8), %xmm7, %xmm2, %xmm2
    vpaddd       (32)(%ebx), %xmm2, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (20)(%esp), %edi
    xor          (24)(%esp), %edi
    and          %eax, %edi
    xor          (24)(%esp), %edi
    mov          (28)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (4)(%esp), %esi
    movl         (8)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (12)(%esp), %eax
    mov          %edx, (28)(%esp)
    mov          %eax, (12)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (16)(%esp), %edi
    xor          (20)(%esp), %edi
    and          %eax, %edi
    xor          (20)(%esp), %edi
    mov          (24)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (%esp), %esi
    movl         (4)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (8)(%esp), %eax
    mov          %edx, (24)(%esp)
    mov          %eax, (8)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (12)(%esp), %edi
    xor          (16)(%esp), %edi
    and          %eax, %edi
    xor          (16)(%esp), %edi
    mov          (20)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (28)(%esp), %esi
    movl         (%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (4)(%esp), %eax
    mov          %edx, (20)(%esp)
    mov          %eax, (4)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (8)(%esp), %edi
    xor          (12)(%esp), %edi
    and          %eax, %edi
    xor          (12)(%esp), %edi
    mov          (16)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (24)(%esp), %esi
    movl         (28)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (%esp), %eax
    mov          %edx, (16)(%esp)
    mov          %eax, (%esp)
    vpshufd      $(250), %xmm2, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpshufd      $(165), %xmm3, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpshufd      $(80), %xmm3, %xmm7
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(165), %xmm1, %xmm6
    vpaddd       %xmm4, %xmm7, %xmm7
    vpaddd       %xmm6, %xmm7, %xmm7
    vpshufd      $(160), %xmm7, %xmm6
    vpsrld       $(10), %xmm6, %xmm4
    vpsrlq       $(17), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpsrlq       $(2), %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vpalignr     $(12), %xmm3, %xmm0, %xmm6
    vpshufd      $(80), %xmm6, %xmm6
    vpsrld       $(3), %xmm6, %xmm5
    vpsrlq       $(7), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsrlq       $(11), %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpalignr     $(12), %xmm1, %xmm2, %xmm6
    vpshufd      $(250), %xmm3, %xmm3
    vpaddd       %xmm5, %xmm4, %xmm4
    vpshufd      $(80), %xmm6, %xmm6
    vpaddd       %xmm4, %xmm3, %xmm3
    vpaddd       %xmm6, %xmm3, %xmm3
    vpshufd      $(136), %xmm7, %xmm7
    vpshufd      $(136), %xmm3, %xmm3
    vpalignr     $(8), %xmm7, %xmm3, %xmm3
    vpaddd       (48)(%ebx), %xmm3, %xmm7
    vmovdqu      %xmm7, (32)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (4)(%esp), %edi
    xor          (8)(%esp), %edi
    and          %eax, %edi
    xor          (8)(%esp), %edi
    mov          (12)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (32)(%esp), %eax
    movl         (20)(%esp), %esi
    movl         (24)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (28)(%esp), %eax
    mov          %edx, (12)(%esp)
    mov          %eax, (28)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (%esp), %edi
    xor          (4)(%esp), %edi
    and          %eax, %edi
    xor          (4)(%esp), %edi
    mov          (8)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (36)(%esp), %eax
    movl         (16)(%esp), %esi
    movl         (20)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (24)(%esp), %eax
    mov          %edx, (8)(%esp)
    mov          %eax, (24)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (28)(%esp), %edi
    xor          (%esp), %edi
    and          %eax, %edi
    xor          (%esp), %edi
    mov          (4)(%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (40)(%esp), %eax
    movl         (12)(%esp), %esi
    movl         (16)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (20)(%esp), %eax
    mov          %edx, (4)(%esp)
    mov          %eax, (20)(%esp)
    mov          %eax, %esi
    shrd         $(6), %esi, %esi
    mov          %eax, %ecx
    shrd         $(11), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(14), %ecx, %ecx
    xor          %ecx, %esi
    mov          (24)(%esp), %edi
    xor          (28)(%esp), %edi
    and          %eax, %edi
    xor          (28)(%esp), %edi
    mov          (%esp), %eax
    add          %esi, %eax
    add          %edi, %eax
    addl         (44)(%esp), %eax
    movl         (8)(%esp), %esi
    movl         (12)(%esp), %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %esi, %ecx
    and          %ecx, %edi
    xor          %esi, %ecx
    xor          %ecx, %edi
    mov          %edx, %esi
    shrd         $(2), %esi, %esi
    mov          %edx, %ecx
    shrd         $(13), %ecx, %ecx
    xor          %ecx, %esi
    shrd         $(9), %ecx, %ecx
    xor          %ecx, %esi
    lea          (%edi,%esi), %edx
    add          %eax, %edx
    add          (16)(%esp), %eax
    mov          %edx, (%esp)
    mov          %eax, (16)(%esp)
    subl         $(16), (48)(%esp)
    jg           .Lloop_16_63gas_1
    movl         (8)(%ebp), %eax
    vmovdqu      (%esp), %xmm0
    vmovdqu      (16)(%esp), %xmm1
    vmovdqu      (%eax), %xmm7
    vpaddd       %xmm0, %xmm7, %xmm7
    vmovdqu      %xmm7, (%eax)
    vmovdqu      (16)(%eax), %xmm7
    vpaddd       %xmm1, %xmm7, %xmm7
    vmovdqu      %xmm7, (16)(%eax)
    addl         $(64), (12)(%ebp)
    subl         $(64), (16)(%ebp)
    jg           .Lsha256_block_loopgas_1
    add          $(52), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size UpdateSHA256, .Lfe1-(UpdateSHA256)
 
