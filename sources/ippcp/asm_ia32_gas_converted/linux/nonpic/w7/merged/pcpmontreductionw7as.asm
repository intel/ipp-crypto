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
 
.globl w7_cpMontRedAdc_BNU
.type w7_cpMontRedAdc_BNU, @function
 
w7_cpMontRedAdc_BNU:
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
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (16)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (16)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (20)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (20)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (24)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (28)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (28)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(16), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct5gas_1: 
    cmp          $(5), %edi
    jne          .Ltst_reduct6gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (20)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (20)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (24)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (28)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (28)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (32)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (36)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (36)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(20), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct6gas_1: 
    cmp          $(6), %edi
    jne          .Ltst_reduct7gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (24)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (24)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (28)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (28)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (32)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (36)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (36)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (40)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(24), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct7gas_1: 
    cmp          $(7), %edi
    jne          .Ltst_reduct8gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (28)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (28)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (32)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (36)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (36)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (40)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(28), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct8gas_1: 
    cmp          $(8), %edi
    jne          .Ltst_reduct9gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (32)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (32)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (36)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (36)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (40)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(32), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct9gas_1: 
    cmp          $(9), %edi
    jne          .Ltst_reduct10gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (36)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (36)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (40)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(36), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct10gas_1: 
    cmp          $(10), %edi
    jne          .Ltst_reduct11gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (40)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (40)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(40), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct11gas_1: 
    cmp          $(11), %edi
    jne          .Ltst_reduct12gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (44)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (44)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(44), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct12gas_1: 
    cmp          $(12), %edi
    jne          .Ltst_reduct13gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (48)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (48)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (88)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (44)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (92)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (92)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(48), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct13gas_1: 
    cmp          $(13), %edi
    jne          .Ltst_reduct14gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (52)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (52)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (88)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (92)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (92)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (44)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (96)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (48)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (100)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (100)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(52), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct14gas_1: 
    cmp          $(14), %edi
    jne          .Ltst_reduct15gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (56)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (56)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (88)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (92)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (92)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (96)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (44)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (100)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (100)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (48)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (104)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (52)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (108)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (108)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(56), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct15gas_1: 
    cmp          $(15), %edi
    jne          .Ltst_reduct16gas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (60)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (60)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (88)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (92)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (92)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (96)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (100)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (100)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (44)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (104)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (48)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (108)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (108)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (52)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (112)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (112)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (56)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (116)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (112)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (112)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (116)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(60), %edx
    jmp          .Lfinishgas_1
.Ltst_reduct16gas_1: 
    cmp          $(16), %edi
    jne          .Lreduct_generalgas_1
    movd         (24)(%ebp), %mm5
    pandn        %mm6, %mm6
 
    movd         (%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (64)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (64)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (4)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (68)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (4)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (4)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (68)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (8)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (72)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (8)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (8)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (72)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (12)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (76)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (12)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (12)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (76)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (16)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (80)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (16)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (16)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (80)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (20)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (84)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (20)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (20)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (84)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (24)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (88)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (24)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (24)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (88)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (28)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (92)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (28)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (28)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (92)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (32)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (96)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (32)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (32)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (96)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (36)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (100)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (36)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (36)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (100)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (40)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (104)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (40)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (40)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (104)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (44)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (108)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (44)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (44)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (108)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (48)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (112)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (48)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (48)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (112)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (52)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (116)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (52)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (52)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (112)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (112)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (116)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (56)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (120)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (56)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (56)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (112)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (112)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (116)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (116)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (120)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    movd         (60)(%edx), %mm0
    pmuludq      %mm5, %mm0
    movd         (124)(%edx), %mm4
    paddq        %mm6, %mm4
    movd         (%eax), %mm7
    movd         (60)(%edx), %mm2
    pmuludq      %mm0, %mm7
    paddq        %mm2, %mm7
    movd         %mm7, (60)(%edx)
    psrlq        $(32), %mm7
 
    movd         (4)(%eax), %mm1
    movd         (64)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (64)(%edx)
    psrlq        $(32), %mm7
 
    movd         (8)(%eax), %mm1
    movd         (68)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (68)(%edx)
    psrlq        $(32), %mm7
 
    movd         (12)(%eax), %mm1
    movd         (72)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (72)(%edx)
    psrlq        $(32), %mm7
 
    movd         (16)(%eax), %mm1
    movd         (76)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (76)(%edx)
    psrlq        $(32), %mm7
 
    movd         (20)(%eax), %mm1
    movd         (80)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (80)(%edx)
    psrlq        $(32), %mm7
 
    movd         (24)(%eax), %mm1
    movd         (84)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (84)(%edx)
    psrlq        $(32), %mm7
 
    movd         (28)(%eax), %mm1
    movd         (88)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (88)(%edx)
    psrlq        $(32), %mm7
 
    movd         (32)(%eax), %mm1
    movd         (92)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (92)(%edx)
    psrlq        $(32), %mm7
 
    movd         (36)(%eax), %mm1
    movd         (96)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (96)(%edx)
    psrlq        $(32), %mm7
 
    movd         (40)(%eax), %mm1
    movd         (100)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (100)(%edx)
    psrlq        $(32), %mm7
 
    movd         (44)(%eax), %mm1
    movd         (104)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (104)(%edx)
    psrlq        $(32), %mm7
 
    movd         (48)(%eax), %mm1
    movd         (108)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (108)(%edx)
    psrlq        $(32), %mm7
 
    movd         (52)(%eax), %mm1
    movd         (112)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (112)(%edx)
    psrlq        $(32), %mm7
 
    movd         (56)(%eax), %mm1
    movd         (116)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (116)(%edx)
    psrlq        $(32), %mm7
 
    movd         (60)(%eax), %mm1
    movd         (120)(%edx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    paddq        %mm1, %mm7
    movd         %mm7, (120)(%edx)
    psrlq        $(32), %mm7
 
    paddq        %mm4, %mm7
    movd         %mm7, (124)(%edx)
    pshufw       $(254), %mm7, %mm6
 
    psrlq        $(32), %mm7
    add          $(64), %edx
    jmp          .Lfinishgas_1
.Lreduct_generalgas_1: 
    sub          $(4), %esp
    pandn        %mm6, %mm6
    mov          %edi, %ebx
    shl          $(2), %ebx
    shl          $(2), %edi
.LmainLoopgas_1: 
    movd         (24)(%ebp), %mm0
    movd         (%edx), %mm1
    movd         %mm6, (%esp)
    pmuludq      %mm1, %mm0
    xor          %ecx, %ecx
    pandn        %mm7, %mm7
    mov          %edi, %esi
    and          $(28), %esi
    jz           .LtestSize_8gas_1
.Lsmall_loopgas_1: 
    movd         (%ecx,%eax), %mm1
    movd         (%edx,%ecx), %mm2
    pmuludq      %mm0, %mm1
    paddq        %mm1, %mm2
    paddq        %mm2, %mm7
    movd         %mm7, (%edx,%ecx)
    psrlq        $(32), %mm7
    add          $(4), %ecx
    cmp          %esi, %ecx
    jl           .Lsmall_loopgas_1
.LtestSize_8gas_1: 
    mov          %edi, %esi
    and          $(32), %esi
    jz           .LtestSize_16gas_1
    movd         (%ecx,%eax), %mm1
    movd         (%edx,%ecx), %mm2
    movd         (4)(%ecx,%eax), %mm3
    movd         (4)(%edx,%ecx), %mm4
    movd         (8)(%ecx,%eax), %mm5
    movd         (8)(%edx,%ecx), %mm6
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    pmuludq      %mm0, %mm3
    paddq        %mm4, %mm3
    pmuludq      %mm0, %mm5
    paddq        %mm6, %mm5
    movd         (12)(%edx,%ecx), %mm2
    paddq        %mm1, %mm7
    movd         (12)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    movd         (24)(%edx,%ecx), %mm2
    movd         %mm7, (%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm3, %mm7
    movd         (16)(%ecx,%eax), %mm3
    movd         (16)(%edx,%ecx), %mm4
    pmuludq      %mm0, %mm3
    movd         %mm7, (4)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    movd         (28)(%edx,%ecx), %mm4
    paddq        %mm5, %mm7
    movd         (20)(%ecx,%eax), %mm5
    movd         (20)(%edx,%ecx), %mm6
    pmuludq      %mm0, %mm5
    movd         %mm7, (8)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm6, %mm5
    paddq        %mm1, %mm7
    movd         (24)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm1
    paddq        %mm3, %mm7
    movd         (28)(%ecx,%eax), %mm3
    pmuludq      %mm0, %mm3
    movd         %mm7, (16)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    paddq        %mm5, %mm7
    movd         %mm7, (20)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    movd         %mm7, (24)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (28)(%edx,%ecx)
    psrlq        $(32), %mm7
    add          $(32), %ecx
.LtestSize_16gas_1: 
    mov          %edi, %esi
    and          $(4294967232), %esi
    jz           .Lnext_termgas_1
.Lunroll16_loopgas_1: 
    movd         (%ecx,%eax), %mm1
    movd         (%edx,%ecx), %mm2
    movd         (4)(%ecx,%eax), %mm3
    movd         (4)(%edx,%ecx), %mm4
    movd         (8)(%ecx,%eax), %mm5
    movd         (8)(%edx,%ecx), %mm6
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    pmuludq      %mm0, %mm3
    paddq        %mm4, %mm3
    pmuludq      %mm0, %mm5
    paddq        %mm6, %mm5
    movd         (12)(%edx,%ecx), %mm2
    paddq        %mm1, %mm7
    movd         (12)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    paddq        %mm2, %mm1
    movd         (24)(%edx,%ecx), %mm2
    movd         %mm7, (%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm3, %mm7
    movd         (16)(%ecx,%eax), %mm3
    movd         (16)(%edx,%ecx), %mm4
    pmuludq      %mm0, %mm3
    movd         %mm7, (4)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    movd         (28)(%edx,%ecx), %mm4
    paddq        %mm5, %mm7
    movd         (20)(%ecx,%eax), %mm5
    movd         (20)(%edx,%ecx), %mm6
    pmuludq      %mm0, %mm5
    movd         %mm7, (8)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm6, %mm5
    movd         (32)(%edx,%ecx), %mm6
    paddq        %mm1, %mm7
    movd         (24)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (12)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm1
    movd         (36)(%edx,%ecx), %mm2
    paddq        %mm3, %mm7
    movd         (28)(%ecx,%eax), %mm3
    pmuludq      %mm0, %mm3
    movd         %mm7, (16)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    movd         (40)(%edx,%ecx), %mm4
    paddq        %mm5, %mm7
    movd         (32)(%ecx,%eax), %mm5
    pmuludq      %mm0, %mm5
    movd         %mm7, (20)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm6, %mm5
    movd         (44)(%edx,%ecx), %mm6
    paddq        %mm1, %mm7
    movd         (36)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (24)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm1
    movd         (48)(%edx,%ecx), %mm2
    paddq        %mm3, %mm7
    movd         (40)(%ecx,%eax), %mm3
    pmuludq      %mm0, %mm3
    movd         %mm7, (28)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    movd         (52)(%edx,%ecx), %mm4
    paddq        %mm5, %mm7
    movd         (44)(%ecx,%eax), %mm5
    pmuludq      %mm0, %mm5
    movd         %mm7, (32)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm6, %mm5
    movd         (56)(%edx,%ecx), %mm6
    paddq        %mm1, %mm7
    movd         (48)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (36)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm1
    movd         (60)(%edx,%ecx), %mm2
    paddq        %mm3, %mm7
    movd         (52)(%ecx,%eax), %mm3
    pmuludq      %mm0, %mm3
    movd         %mm7, (40)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm4, %mm3
    paddq        %mm5, %mm7
    movd         (56)(%ecx,%eax), %mm5
    pmuludq      %mm0, %mm5
    movd         %mm7, (44)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm6, %mm5
    paddq        %mm1, %mm7
    movd         (60)(%ecx,%eax), %mm1
    pmuludq      %mm0, %mm1
    movd         %mm7, (48)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm3, %mm7
    movd         %mm7, (52)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm2, %mm1
    paddq        %mm5, %mm7
    movd         %mm7, (56)(%edx,%ecx)
    psrlq        $(32), %mm7
    paddq        %mm1, %mm7
    movd         %mm7, (60)(%edx,%ecx)
    psrlq        $(32), %mm7
    add          $(64), %ecx
    cmp          %esi, %ecx
    jl           .Lunroll16_loopgas_1
.Lnext_termgas_1: 
    movd         (%edx,%ecx), %mm1
    movd         (%esp), %mm6
    paddq        %mm1, %mm7
    paddq        %mm7, %mm6
    movd         %mm6, (%edx,%ecx)
    psrlq        $(32), %mm6
    add          $(4), %edx
    sub          $(4), %ebx
    jg           .LmainLoopgas_1
    add          $(4), %esp
    shr          $(2), %edi
.Lfinishgas_1: 
    pxor         %mm7, %mm7
    psubd        %mm6, %mm7
    movl         (8)(%ebp), %esi
    mov          %edi, %ebx
    pandn        %mm0, %mm0
    xor          %ecx, %ecx
.Lsubtract_loopgas_1: 
    movd         (%edx,%ecx,4), %mm1
    movd         (%eax,%ecx,4), %mm2
    psubq        %mm2, %mm1
    paddq        %mm0, %mm1
    movd         %mm1, (%esi,%ecx,4)
    pshufw       $(254), %mm1, %mm0
    add          $(1), %ecx
    cmp          %edi, %ecx
    jl           .Lsubtract_loopgas_1
    pcmpeqd      %mm6, %mm6
    pxor         %mm6, %mm0
    por          %mm7, %mm0
    pcmpeqd      %mm7, %mm7
    pxor         %mm0, %mm7
    xor          %ecx, %ecx
.Lmasked_copy_loopgas_1: 
    movd         (%esi,%ecx,4), %mm1
    pand         %mm0, %mm1
    movd         (%edx,%ecx,4), %mm2
    pand         %mm7, %mm2
    por          %mm2, %mm1
    movd         %mm1, (%esi,%ecx,4)
    add          $(1), %ecx
    cmp          %edi, %ecx
    jl           .Lmasked_copy_loopgas_1
    emms
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size w7_cpMontRedAdc_BNU, .Lfe1-(w7_cpMontRedAdc_BNU)
 
