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

 
.text
.p2align 4, 0x90
 
.globl _cpAdd_BNU

 
_cpAdd_BNU:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %eax
    movl         (16)(%ebp), %ebx
    movl         (8)(%ebp), %edx
    movl         (20)(%ebp), %edi
    shl          $(2), %edi
    xor          %ecx, %ecx
    pandn        %mm0, %mm0
.p2align 4, 0x90
.Lmain_loopgas_1: 
    movd         (%ecx,%eax), %mm1
    movd         (%ebx,%ecx), %mm2
    paddq        %mm1, %mm0
    paddq        %mm2, %mm0
    movd         %mm0, (%edx,%ecx)
    pshufw       $(254), %mm0, %mm0
    add          $(4), %ecx
    cmp          %edi, %ecx
    jl           .Lmain_loopgas_1
    movd         %mm0, %eax
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
