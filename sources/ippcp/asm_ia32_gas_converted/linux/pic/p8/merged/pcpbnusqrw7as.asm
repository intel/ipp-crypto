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
 
.globl p8_cpSqrAdc_BNU_school
.type p8_cpSqrAdc_BNU_school, @function
 
p8_cpSqrAdc_BNU_school:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %eax
    movl         (8)(%ebp), %ebx
    movl         (16)(%ebp), %ecx
.Llen1gas_1: 
    cmp          $(1), %ecx
    jg           .Llen2gas_1
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movq         %mm0, (%ebx)
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen2gas_1: 
    cmp          $(2), %ecx
    jg           .Llen3gas_1
    movd         (%eax), %mm0
    movd         (4)(%eax), %mm1
    movq         %mm0, %mm2
    pmuludq      %mm0, %mm0
    pmuludq      %mm1, %mm2
    pmuludq      %mm1, %mm1
    pcmpeqd      %mm7, %mm7
    psrlq        $(32), %mm7
    pand         %mm2, %mm7
    paddq        %mm7, %mm7
    psrlq        $(32), %mm2
    paddq        %mm2, %mm2
    movd         %mm0, (%ebx)
    psrlq        $(32), %mm0
    paddq        %mm7, %mm0
    movd         %mm0, (4)(%ebx)
    psrlq        $(32), %mm0
    paddq        %mm1, %mm2
    paddq        %mm0, %mm2
    movq         %mm2, (8)(%ebx)
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen3gas_1: 
    cmp          $(3), %ecx
    jg           .Llen4gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (12)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (16)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (20)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen4gas_1: 
    cmp          $(4), %ecx
    jg           .Llen5gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (16)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (20)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (24)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (28)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen5gas_1: 
    cmp          $(5), %ecx
    jg           .Llen6gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (20)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (24)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (28)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (32)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (36)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen6gas_1: 
    cmp          $(6), %ecx
    jg           .Llen7gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (24)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (28)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (32)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (36)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (40)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (44)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen7gas_1: 
    cmp          $(7), %ecx
    jg           .Llen8gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (28)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (32)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (36)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (40)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (44)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (52)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen8gas_1: 
    cmp          $(8), %ecx
    jg           .Llen9gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (32)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (36)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (40)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (44)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (60)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen9gas_1: 
    cmp          $(9), %ecx
    jg           .Llen10gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (36)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (40)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (44)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (68)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen10gas_1: 
    cmp          $(10), %ecx
    jg           .Llen11gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (40)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (44)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (76)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen11gas_1: 
    cmp          $(11), %ecx
    jg           .Llen12gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (44)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (84)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen12gas_1: 
    cmp          $(12), %ecx
    jg           .Llen13gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (48)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (92)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen13gas_1: 
    cmp          $(13), %ecx
    jg           .Llen14gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (52)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (88)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (92)(%ebx)
 
    movd         (44)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (92)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (96)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (100)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (48)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (96)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen14gas_1: 
    cmp          $(14), %ecx
    jg           .Llen15gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (56)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (92)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (88)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (96)(%ebx)
 
    movd         (44)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (92)(%ebx), %mm3
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (96)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (100)(%ebx)
 
    movd         (48)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (100)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (104)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (108)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (48)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (96)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (52)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (104)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen15gas_1: 
    cmp          $(15), %ecx
    jg           .Llen16gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (60)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (92)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (96)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (88)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (100)(%ebx)
 
    movd         (44)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (92)(%ebx), %mm3
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (96)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (104)(%ebx)
 
    movd         (48)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (100)(%ebx), %mm3
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (104)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (108)(%ebx)
 
    movd         (52)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (108)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (112)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (116)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (48)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (96)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (52)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (104)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (56)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (112)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (116)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen16gas_1: 
    cmp          $(16), %ecx
    jg           .Llen17gas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (64)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (92)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (96)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (100)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (88)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (104)(%ebx)
 
    movd         (44)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (92)(%ebx), %mm3
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (96)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (104)(%ebx), %mm4
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (108)(%ebx)
 
    movd         (48)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (100)(%ebx), %mm3
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (104)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (112)(%ebx)
 
    movd         (52)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (108)(%ebx), %mm3
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (112)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (116)(%ebx)
 
    movd         (56)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (116)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (120)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (124)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (48)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (96)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (52)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (104)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (56)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (112)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (116)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (60)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (120)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (124)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (120)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (124)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Llen17gas_1: 
    cmp          $(17), %ecx
    jg           .Lcommon_casegas_1
    movd         (%eax), %mm0
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
 
    movd         (4)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (8)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (68)(%ebx)
 
    movd         (4)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (8)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (12)(%ebx), %mm3
    movd         (12)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (16)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (24)(%ebx), %mm4
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (72)(%ebx)
 
    movd         (8)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (12)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (20)(%ebx), %mm3
    movd         (16)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (24)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (32)(%ebx), %mm4
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (76)(%ebx)
 
    movd         (12)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (16)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (28)(%ebx), %mm3
    movd         (20)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (32)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (40)(%ebx), %mm4
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (80)(%ebx)
 
    movd         (16)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (20)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (36)(%ebx), %mm3
    movd         (24)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (40)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (48)(%ebx), %mm4
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (84)(%ebx)
 
    movd         (20)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (24)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (44)(%ebx), %mm3
    movd         (28)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (48)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (56)(%ebx), %mm4
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (88)(%ebx)
 
    movd         (24)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (28)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (52)(%ebx), %mm3
    movd         (32)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (56)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (64)(%ebx), %mm4
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (92)(%ebx)
 
    movd         (28)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (32)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (60)(%ebx), %mm3
    movd         (36)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (64)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (72)(%ebx), %mm4
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (96)(%ebx)
 
    movd         (32)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (36)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (68)(%ebx), %mm3
    movd         (40)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (72)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (80)(%ebx), %mm4
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (100)(%ebx)
 
    movd         (36)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (40)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (76)(%ebx), %mm3
    movd         (44)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (80)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (88)(%ebx), %mm4
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (104)(%ebx)
 
    movd         (40)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (44)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (84)(%ebx), %mm3
    movd         (48)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (88)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (96)(%ebx), %mm4
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (104)(%ebx), %mm4
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (108)(%ebx)
 
    movd         (44)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (48)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (92)(%ebx), %mm3
    movd         (52)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (96)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (104)(%ebx), %mm4
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (112)(%ebx)
 
    movd         (48)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (52)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (100)(%ebx), %mm3
    movd         (56)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (104)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm4, %mm7
    movd         (112)(%ebx), %mm4
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (116)(%ebx)
 
    movd         (52)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (56)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (108)(%ebx), %mm3
    movd         (60)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (112)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm3, %mm7
    movd         (116)(%ebx), %mm3
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (120)(%ebx)
 
    movd         (56)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (60)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (116)(%ebx), %mm3
    movd         (64)(%eax), %mm2
    pmuludq      %mm0, %mm2
    movd         (120)(%ebx), %mm4
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm7
    paddq        %mm4, %mm7
    movd         %mm7, (120)(%ebx)
    psrlq        $(32), %mm7
 
    movd         %mm7, (124)(%ebx)
 
    movd         (60)(%eax), %mm0
    pandn        %mm7, %mm7
 
    movd         (64)(%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         (124)(%ebx), %mm3
 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (124)(%ebx)
    psrlq        $(32), %mm7
    movd         %mm7, (128)(%ebx)
 
    pandn        %mm7, %mm7
    movd         %mm7, (132)(%ebx)
 
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    movd         (%ebx), %mm2
    paddq        %mm2, %mm2
    movd         (4)(%ebx), %mm3
    paddq        %mm3, %mm3
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    pandn        %mm7, %mm7
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (4)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (8)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (12)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (4)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (8)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (16)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (8)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (20)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (12)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (12)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (24)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (16)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (28)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (20)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (16)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (32)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (24)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (36)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (28)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (20)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (40)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (32)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (44)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (36)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (24)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (48)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (40)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (52)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (44)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (28)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (56)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (48)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (60)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (52)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (32)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (64)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (56)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (68)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (60)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (36)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (72)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (64)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (76)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (68)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (40)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (80)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (72)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (84)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (76)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (44)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (88)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (80)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (92)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (84)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (48)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (96)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (88)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (100)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (92)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (52)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (104)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (96)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (108)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (100)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (56)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (112)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (104)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (116)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (108)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (60)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (120)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (112)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (124)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (116)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    movd         (64)(%eax), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm2, %mm7
    movd         (128)(%ebx), %mm2
    paddq        %mm2, %mm2
    movd         %mm7, (120)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         (132)(%ebx), %mm3
    paddq        %mm3, %mm3
    movd         %mm7, (124)(%ebx)
    psrlq        $(32), %mm7
 
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (128)(%ebx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (132)(%ebx)
    psrlq        $(32), %mm7
 
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lcommon_casegas_1: 
    mov          $(1), %edx
    movd         (%eax), %mm0
    movd         (%eax,%edx,4), %mm1
    pmuludq      %mm0, %mm1
    pandn        %mm7, %mm7
    movd         %mm7, (%ebx)
.Linit_loopgas_1: 
    movd         (4)(%eax,%edx,4), %mm2
    pmuludq      %mm0, %mm2
    paddq        %mm1, %mm7
    movd         %mm7, (%ebx,%edx,4)
    psrlq        $(32), %mm7
    add          $(2), %edx
    cmp          %ecx, %edx
    jg           .Lbreak_init_loopgas_1
    movd         (%eax,%edx,4), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm7
    movd         %mm7, (-4)(%ebx,%edx,4)
    psrlq        $(32), %mm7
    jl           .Linit_loopgas_1
.Lbreak_init_loopgas_1: 
    movd         %mm7, (%ebx,%ecx,4)
    mov          $(1), %edx
.Lupdate_mul_loopgas_1: 
    mov          %edx, %esi
    add          $(1), %esi
    mov          %edx, %edi
    add          %esi, %edi
    movd         (%eax,%edx,4), %mm0
    movd         (%eax,%esi,4), %mm1
    pmuludq      %mm0, %mm1
    movd         (%ebx,%edi,4), %mm3
    pandn        %mm7, %mm7
.Lupdate_mul_inner_loopgas_1: 
    paddq        %mm1, %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (%ebx,%edi,4)
    psrlq        $(32), %mm7
    movd         (4)(%eax,%esi,4), %mm1
    pmuludq      %mm0, %mm1
    movd         (4)(%ebx,%edi,4), %mm3
    add          $(1), %edi
    add          $(1), %esi
    cmp          %ecx, %esi
    jl           .Lupdate_mul_inner_loopgas_1
    movd         %mm7, (%ebx,%edi,4)
    add          $(1), %edx
    sub          $(1), %esi
    cmp          %esi, %edx
    jl           .Lupdate_mul_loopgas_1
    pandn        %mm7, %mm7
    movd         %mm7, (4)(%ebx,%edi,4)
    pcmpeqd      %mm6, %mm6
    psrlq        $(32), %mm6
    movd         (%eax), %mm0
    pmuludq      %mm0, %mm0
    mov          $(0), %edx
    movd         (%ebx), %mm2
    movd         (4)(%ebx), %mm3
    pandn        %mm7, %mm7
.Lsqr_loopgas_1: 
    paddq        %mm2, %mm2
    paddq        %mm3, %mm3
    movq         %mm0, %mm1
    pand         %mm6, %mm0
    psrlq        $(32), %mm1
    paddq        %mm2, %mm7
    paddq        %mm0, %mm7
    movd         %mm7, (%ebx,%edx,8)
    psrlq        $(32), %mm7
    movd         (4)(%eax,%edx,4), %mm0
    pmuludq      %mm0, %mm0
    paddq        %mm3, %mm7
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%ebx,%edx,8)
    psrlq        $(32), %mm7
    add          $(1), %edx
    movd         (%ebx,%edx,8), %mm2
    movd         (4)(%ebx,%edx,8), %mm3
    cmp          %ecx, %edx
    jl           .Lsqr_loopgas_1
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size p8_cpSqrAdc_BNU_school, .Lfe1-(p8_cpSqrAdc_BNU_school)
 
