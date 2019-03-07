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
 
.globl cpMontRedAdc_BNU
.type cpMontRedAdc_BNU, @function
 
cpMontRedAdc_BNU:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (16)(%ebp), %eax
    movl         (20)(%ebp), %edi
    movl         (12)(%ebp), %edx
.Ltst_reduct4gas_1: 
    cmp          $(4), %edi
    jne          .Ltst_reduct5gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (16)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (16)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (20)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (20)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (24)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (24)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (28)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (28)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(16), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct5gas_1: 
    cmp          $(5), %edi
    jne          .Ltst_reduct6gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (20)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (20)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (24)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (24)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (28)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (28)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (32)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (32)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (36)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (36)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(20), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct6gas_1: 
    cmp          $(6), %edi
    jne          .Ltst_reduct7gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (24)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (24)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (28)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (28)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (32)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (32)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (36)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (36)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (40)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (40)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(24), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct7gas_1: 
    cmp          $(7), %edi
    jne          .Ltst_reduct8gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (28)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (28)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (32)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (32)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (36)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (36)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (40)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (40)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(28), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct8gas_1: 
    cmp          $(8), %edi
    jne          .Ltst_reduct9gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (32)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (32)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (36)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (36)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (40)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (40)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(32), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct9gas_1: 
    cmp          $(9), %edi
    jne          .Ltst_reduct10gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (36)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (36)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (40)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (40)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(36), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct10gas_1: 
    cmp          $(10), %edi
    jne          .Ltst_reduct11gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (40)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (40)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(40), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct11gas_1: 
    cmp          $(11), %edi
    jne          .Ltst_reduct12gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (44)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (44)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(44), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct12gas_1: 
    cmp          $(12), %edi
    jne          .Ltst_reduct13gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (48)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (48)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (88)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (88)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (44)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (92)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (92)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(48), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct13gas_1: 
    cmp          $(13), %edi
    jne          .Ltst_reduct14gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (52)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (52)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (88)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (88)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (92)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (92)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (44)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (96)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (96)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (48)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (100)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (100)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(52), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct14gas_1: 
    cmp          $(14), %edi
    jne          .Ltst_reduct15gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (56)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (56)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (88)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (88)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (92)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (92)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (96)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (96)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (44)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (100)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (100)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (48)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (104)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (104)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (52)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (108)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (108)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(56), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct15gas_1: 
    cmp          $(15), %edi
    jne          .Ltst_reduct16gas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (60)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (60)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (88)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (88)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (92)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (92)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (96)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (96)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (100)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (100)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (44)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (104)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (104)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (48)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (108)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (108)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (52)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (112)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (112)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (56)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (116)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (112)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (112)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (116)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(60), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct16gas_1: 
    cmp          $(16), %edi
    jne          .Lreduct_generalgas_1
    movd         (24)(%ebp), %xmm5
    pandn        %xmm6, %xmm6
 
    movd         (%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (64)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (64)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (4)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (68)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (4)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (4)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (68)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (8)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (72)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (8)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (8)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (72)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (12)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (76)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (12)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (12)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (76)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (16)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (80)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (16)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (16)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (80)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (20)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (84)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (20)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (20)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (84)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (24)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (88)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (24)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (24)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (88)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (28)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (92)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (28)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (28)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (92)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (32)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (96)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (32)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (32)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (96)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (36)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (100)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (36)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (36)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (100)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (40)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (104)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (40)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (40)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (104)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (44)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (108)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (44)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (44)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (108)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (48)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (112)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (48)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (48)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (112)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (52)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (116)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (52)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (52)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (112)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (112)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (116)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (56)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (120)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (56)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (56)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (112)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (112)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (116)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (116)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (120)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    movd         (60)(%edx), %xmm0
    pmuludq      %xmm5, %xmm0
    movd         (124)(%edx), %xmm4
    paddq        %xmm6, %xmm4
    movd         (%eax), %xmm7
    pmuludq      %xmm0, %xmm7
    movd         (60)(%edx), %xmm2
    paddq        %xmm2, %xmm7
    movd         %xmm7, (60)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (4)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (64)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (64)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (8)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (68)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (68)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (12)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (72)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (72)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (16)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (76)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (76)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (20)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (80)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (80)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (24)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (84)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (84)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (28)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (88)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (88)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (32)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (92)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (92)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (36)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (96)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (96)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (40)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (100)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (100)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (44)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (104)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (104)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (48)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (108)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (108)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (52)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (112)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (112)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (56)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (116)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (116)(%edx)
    psrlq        $(32), %xmm7
 
    movd         (60)(%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (120)(%edx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (120)(%edx)
    psrlq        $(32), %xmm7
 
    paddq        %xmm4, %xmm7
    movd         %xmm7, (124)(%edx)
    pshuflw      $(254), %xmm7, %xmm6
 
    psrlq        $(32), %xmm7
    add          $(64), %edx
    jmp          .Lfinishgas_1
.Lreduct_generalgas_1: 
    sub          $(4), %esp
    pandn        %xmm6, %xmm6
    mov          %edi, %ebx
    shl          $(2), %ebx
    shl          $(2), %edi
.LmainLoopgas_1: 
    movd         (24)(%ebp), %xmm0
    movd         (%edx), %xmm1
    movd         %xmm6, (%esp)
    pmuludq      %xmm1, %xmm0
    xor          %ecx, %ecx
    pandn        %xmm7, %xmm7
    mov          %edi, %esi
    and          $(28), %esi
    jz           .LtestSize_8gas_1
.Lsmall_loopgas_1: 
    movd         (%ecx,%eax), %xmm1
    pmuludq      %xmm0, %xmm1
    movd         (%edx,%ecx), %xmm2
    paddq        %xmm2, %xmm1
    paddq        %xmm1, %xmm7
    movd         %xmm7, (%edx,%ecx)
    psrlq        $(32), %xmm7
    add          $(4), %ecx
    cmp          %esi, %ecx
    jl           .Lsmall_loopgas_1
.LtestSize_8gas_1: 
    mov          %edi, %esi
    and          $(32), %esi
    jz           .LtestSize_16gas_1
    movd         (%ecx,%eax), %xmm1
    movd         (%edx,%ecx), %xmm2
    movd         (4)(%ecx,%eax), %xmm3
    movd         (4)(%edx,%ecx), %xmm4
    movd         (8)(%ecx,%eax), %xmm5
    movd         (8)(%edx,%ecx), %xmm6
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (12)(%ecx,%eax), %xmm1
    movd         (12)(%edx,%ecx), %xmm2
    movd         %xmm7, (%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (16)(%ecx,%eax), %xmm3
    movd         (16)(%edx,%ecx), %xmm4
    movd         %xmm7, (4)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         (20)(%ecx,%eax), %xmm5
    movd         (20)(%edx,%ecx), %xmm6
    movd         %xmm7, (8)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (24)(%ecx,%eax), %xmm1
    movd         (24)(%edx,%ecx), %xmm2
    movd         %xmm7, (12)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (28)(%ecx,%eax), %xmm3
    movd         (28)(%edx,%ecx), %xmm4
    movd         %xmm7, (16)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         %xmm7, (20)(%edx,%ecx)
    psrlq        $(32), %xmm7
    paddq        %xmm1, %xmm7
    movd         %xmm7, (24)(%edx,%ecx)
    psrlq        $(32), %xmm7
    paddq        %xmm3, %xmm7
    movd         %xmm7, (28)(%edx,%ecx)
    psrlq        $(32), %xmm7
    add          $(32), %ecx
.LtestSize_16gas_1: 
    mov          %edi, %esi
    and          $(4294967232), %esi
    jz           .Lnext_termgas_1
.Lunroll16_loopgas_1: 
    movd         (%ecx,%eax), %xmm1
    movd         (%edx,%ecx), %xmm2
    movd         (4)(%ecx,%eax), %xmm3
    movd         (4)(%edx,%ecx), %xmm4
    movd         (8)(%ecx,%eax), %xmm5
    movd         (8)(%edx,%ecx), %xmm6
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (12)(%ecx,%eax), %xmm1
    movd         (12)(%edx,%ecx), %xmm2
    movd         %xmm7, (%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (16)(%ecx,%eax), %xmm3
    movd         (16)(%edx,%ecx), %xmm4
    movd         %xmm7, (4)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         (20)(%ecx,%eax), %xmm5
    movd         (20)(%edx,%ecx), %xmm6
    movd         %xmm7, (8)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (24)(%ecx,%eax), %xmm1
    movd         (24)(%edx,%ecx), %xmm2
    movd         %xmm7, (12)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (28)(%ecx,%eax), %xmm3
    movd         (28)(%edx,%ecx), %xmm4
    movd         %xmm7, (16)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         (32)(%ecx,%eax), %xmm5
    movd         (32)(%edx,%ecx), %xmm6
    movd         %xmm7, (20)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (36)(%ecx,%eax), %xmm1
    movd         (36)(%edx,%ecx), %xmm2
    movd         %xmm7, (24)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (40)(%ecx,%eax), %xmm3
    movd         (40)(%edx,%ecx), %xmm4
    movd         %xmm7, (28)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         (44)(%ecx,%eax), %xmm5
    movd         (44)(%edx,%ecx), %xmm6
    movd         %xmm7, (32)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (48)(%ecx,%eax), %xmm1
    movd         (48)(%edx,%ecx), %xmm2
    movd         %xmm7, (36)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         (52)(%ecx,%eax), %xmm3
    movd         (52)(%edx,%ecx), %xmm4
    movd         %xmm7, (40)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm3
    paddq        %xmm4, %xmm3
    paddq        %xmm5, %xmm7
    movd         (56)(%ecx,%eax), %xmm5
    movd         (56)(%edx,%ecx), %xmm6
    movd         %xmm7, (44)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm5
    paddq        %xmm6, %xmm5
    paddq        %xmm1, %xmm7
    movd         (60)(%ecx,%eax), %xmm1
    movd         (60)(%edx,%ecx), %xmm2
    movd         %xmm7, (48)(%edx,%ecx)
    psrlq        $(32), %xmm7
    pmuludq      %xmm0, %xmm1
    paddq        %xmm2, %xmm1
    paddq        %xmm3, %xmm7
    movd         %xmm7, (52)(%edx,%ecx)
    psrlq        $(32), %xmm7
    paddq        %xmm5, %xmm7
    movd         %xmm7, (56)(%edx,%ecx)
    psrlq        $(32), %xmm7
    paddq        %xmm1, %xmm7
    movd         %xmm7, (60)(%edx,%ecx)
    psrlq        $(32), %xmm7
    add          $(64), %ecx
    cmp          %esi, %ecx
    jl           .Lunroll16_loopgas_1
.Lnext_termgas_1: 
    movd         (%edx,%ecx), %xmm1
    paddq        %xmm1, %xmm7
    movd         (%esp), %xmm6
    paddq        %xmm7, %xmm6
    movd         %xmm6, (%edx,%ecx)
    psrlq        $(32), %xmm6
    add          $(4), %edx
    sub          $(4), %ebx
    jg           .LmainLoopgas_1
    add          $(4), %esp
    shr          $(2), %edi
.Lfinishgas_1: 
    pxor         %xmm7, %xmm7
    psubd        %xmm6, %xmm7
    movl         (8)(%ebp), %esi
    pandn        %xmm0, %xmm0
    xor          %ecx, %ecx
.Lsubtract_loopgas_1: 
    movd         (%edx,%ecx,4), %xmm1
    paddq        %xmm1, %xmm0
    movd         (%eax,%ecx,4), %xmm2
    psubq        %xmm2, %xmm0
    movd         %xmm0, (%esi,%ecx,4)
    pshuflw      $(254), %xmm0, %xmm0
    add          $(1), %ecx
    cmp          %edi, %ecx
    jl           .Lsubtract_loopgas_1
    pcmpeqd      %xmm6, %xmm6
    pxor         %xmm6, %xmm0
    por          %xmm7, %xmm0
    pcmpeqd      %xmm7, %xmm7
    pxor         %xmm0, %xmm7
    xor          %ecx, %ecx
.Lmasked_copy_loopgas_1: 
    movd         (%esi,%ecx,4), %xmm1
    pand         %xmm0, %xmm1
    movd         (%edx,%ecx,4), %xmm2
    pand         %xmm7, %xmm2
    por          %xmm2, %xmm1
    movd         %xmm1, (%esi,%ecx,4)
    add          $(1), %ecx
    cmp          %edi, %ecx
    jl           .Lmasked_copy_loopgas_1
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size cpMontRedAdc_BNU, .Lfe1-(cpMontRedAdc_BNU)
 
