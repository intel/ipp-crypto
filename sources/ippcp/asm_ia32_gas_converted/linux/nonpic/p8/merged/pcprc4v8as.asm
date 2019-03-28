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
 
.globl p8_ARCFourProcessData
.type p8_ARCFourProcessData, @function
 
p8_ARCFourProcessData:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    movl         (16)(%ebp), %edx
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (20)(%ebp), %ebp
    test         %edx, %edx
    jz           .Lquitgas_1
    movl         (4)(%ebp), %eax
    movl         (8)(%ebp), %ebx
    lea          (12)(%ebp), %ebp
    add          $(1), %eax
    and          $(255), %eax
    movl         (%ebp,%eax,4), %ecx
    lea          (%esi,%edx), %edx
    push         %edx
.p2align 4, 0x90
.Lmain_loopgas_1: 
    add          %ecx, %ebx
    movzbl       %bl, %ebx
    movl         (%ebp,%ebx,4), %edx
    movl         %ecx, (%ebp,%ebx,4)
    add          %edx, %ecx
    movzbl       %cl, %ecx
    movl         %edx, (%ebp,%eax,4)
    add          $(1), %eax
    movb         (%ebp,%ecx,4), %dl
    movzbl       %al, %eax
    xorb         (%esi), %dl
    add          $(1), %esi
    movl         (%ebp,%eax,4), %ecx
    movb         %dl, (%edi)
    add          $(1), %edi
    cmpl         (%esp), %esi
    jb           .Lmain_loopgas_1
    lea          (-12)(%ebp), %ebp
    pop          %edx
    dec          %eax
    and          $(255), %eax
    movl         %eax, (4)(%ebp)
    movl         %ebx, (8)(%ebp)
.Lquitgas_1: 
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size p8_ARCFourProcessData, .Lfe1-(p8_ARCFourProcessData)
 
