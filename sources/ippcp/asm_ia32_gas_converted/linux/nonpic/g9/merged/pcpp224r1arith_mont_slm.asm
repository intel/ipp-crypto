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
p224r1_data: 
 
_prime224r1:
.long          0x1,        0x0,        0x0, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF 
 
.p2align 5, 0x90
 

.type g9_add_224, @function
 
g9_add_224:
    movl         (%esi), %eax
    addl         (%ebx), %eax
    movl         %eax, (%edi)
    movl         (4)(%esi), %eax
    adcl         (4)(%ebx), %eax
    movl         %eax, (4)(%edi)
    movl         (8)(%esi), %eax
    adcl         (8)(%ebx), %eax
    movl         %eax, (8)(%edi)
    movl         (12)(%esi), %eax
    adcl         (12)(%ebx), %eax
    movl         %eax, (12)(%edi)
    movl         (16)(%esi), %eax
    adcl         (16)(%ebx), %eax
    movl         %eax, (16)(%edi)
    movl         (20)(%esi), %eax
    adcl         (20)(%ebx), %eax
    movl         %eax, (20)(%edi)
    movl         (24)(%esi), %eax
    adcl         (24)(%ebx), %eax
    movl         %eax, (24)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe1:
.size g9_add_224, .Lfe1-(g9_add_224)
.p2align 5, 0x90
 

.type g9_sub_224, @function
 
g9_sub_224:
    movl         (%esi), %eax
    subl         (%ebx), %eax
    movl         %eax, (%edi)
    movl         (4)(%esi), %eax
    sbbl         (4)(%ebx), %eax
    movl         %eax, (4)(%edi)
    movl         (8)(%esi), %eax
    sbbl         (8)(%ebx), %eax
    movl         %eax, (8)(%edi)
    movl         (12)(%esi), %eax
    sbbl         (12)(%ebx), %eax
    movl         %eax, (12)(%edi)
    movl         (16)(%esi), %eax
    sbbl         (16)(%ebx), %eax
    movl         %eax, (16)(%edi)
    movl         (20)(%esi), %eax
    sbbl         (20)(%ebx), %eax
    movl         %eax, (20)(%edi)
    movl         (24)(%esi), %eax
    sbbl         (24)(%ebx), %eax
    movl         %eax, (24)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe2:
.size g9_sub_224, .Lfe2-(g9_sub_224)
.p2align 5, 0x90
 

.type g9_shl_224, @function
 
g9_shl_224:
    movdqu       (%esi), %xmm0
    movdqu       (12)(%esi), %xmm1
    movl         (24)(%esi), %eax
    psrldq       $(4), %xmm1
    movdqa       %xmm0, %xmm2
    psllq        $(1), %xmm0
    psrlq        $(63), %xmm2
    movdqa       %xmm1, %xmm3
    psllq        $(1), %xmm1
    psrlq        $(63), %xmm3
    palignr      $(8), %xmm2, %xmm3
    pslldq       $(8), %xmm2
    por          %xmm3, %xmm1
    por          %xmm2, %xmm0
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    psrldq       $(8), %xmm1
    movd         %xmm1, (24)(%edi)
    shr          $(31), %eax
    ret
.Lfe3:
.size g9_shl_224, .Lfe3-(g9_shl_224)
.p2align 5, 0x90
 

.type g9_shr_224, @function
 
g9_shr_224:
    movdqu       (%esi), %xmm0
    movdqu       (12)(%esi), %xmm2
    movd         %eax, %xmm1
    palignr      $(4), %xmm2, %xmm1
    movdqa       %xmm0, %xmm2
    psrlq        $(1), %xmm0
    psllq        $(63), %xmm2
    movdqa       %xmm1, %xmm3
    psrlq        $(1), %xmm1
    psllq        $(63), %xmm3
    movdqa       %xmm3, %xmm4
    palignr      $(8), %xmm2, %xmm3
    psrldq       $(8), %xmm4
    por          %xmm3, %xmm0
    por          %xmm4, %xmm1
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    psrldq       $(8), %xmm1
    movd         %xmm1, (24)(%edi)
    ret
.Lfe4:
.size g9_shr_224, .Lfe4-(g9_shr_224)
.p2align 5, 0x90
 
.globl g9_p224r1_add
.type g9_p224r1_add, @function
 
g9_p224r1_add:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(32), %esp
    and          $(-16), %esp
    movl         %eax, (28)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         g9_add_224
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_sub_224
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    sub          %eax, %edx
    cmovne       %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (28)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe5:
.size g9_p224r1_add, .Lfe5-(g9_p224r1_add)
.p2align 5, 0x90
 
.globl g9_p224r1_sub
.type g9_p224r1_sub, @function
 
g9_p224r1_sub:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(32), %esp
    and          $(-16), %esp
    movl         %eax, (28)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         g9_sub_224
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_add_224
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (28)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe6:
.size g9_p224r1_sub, .Lfe6-(g9_p224r1_sub)
.p2align 5, 0x90
 
.globl g9_p224r1_neg
.type g9_p224r1_neg, @function
 
g9_p224r1_neg:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(32), %esp
    and          $(-16), %esp
    movl         %eax, (28)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    mov          $(0), %eax
    subl         (%esi), %eax
    movl         %eax, (%edi)
    mov          $(0), %eax
    sbbl         (4)(%esi), %eax
    movl         %eax, (4)(%edi)
    mov          $(0), %eax
    sbbl         (8)(%esi), %eax
    movl         %eax, (8)(%edi)
    mov          $(0), %eax
    sbbl         (12)(%esi), %eax
    movl         %eax, (12)(%edi)
    mov          $(0), %eax
    sbbl         (16)(%esi), %eax
    movl         %eax, (16)(%edi)
    mov          $(0), %eax
    sbbl         (20)(%esi), %eax
    movl         %eax, (20)(%edi)
    mov          $(0), %eax
    sbbl         (24)(%esi), %eax
    movl         %eax, (24)(%edi)
    sbb          %edx, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_add_224
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (28)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe7:
.size g9_p224r1_neg, .Lfe7-(g9_p224r1_neg)
.p2align 5, 0x90
 
.globl g9_p224r1_mul_by_2
.type g9_p224r1_mul_by_2, @function
 
g9_p224r1_mul_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(32), %esp
    and          $(-16), %esp
    movl         %eax, (28)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         g9_shl_224
    mov          %eax, %edx
    mov          %edi, %esi
    movl         (8)(%ebp), %edi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_sub_224
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (28)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe8:
.size g9_p224r1_mul_by_2, .Lfe8-(g9_p224r1_mul_by_2)
.p2align 5, 0x90
 
.globl g9_p224r1_mul_by_3
.type g9_p224r1_mul_by_3, @function
 
g9_p224r1_mul_by_3:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(64), %esp
    and          $(-16), %esp
    movl         %eax, (60)(%esp)
    lea          p224r1_data, %eax
    lea          ((_prime224r1-p224r1_data))(%eax), %eax
    movl         %eax, (56)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         g9_shl_224
    mov          %eax, %edx
    mov          %edi, %esi
    lea          (28)(%esp), %edi
    mov          (56)(%esp), %ebx
    call         g9_sub_224
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          %edi, %esi
    movl         (12)(%ebp), %ebx
    call         g9_add_224
    mov          %eax, %edx
    movl         (8)(%ebp), %edi
    mov          (56)(%esp), %ebx
    call         g9_sub_224
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (60)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe9:
.size g9_p224r1_mul_by_3, .Lfe9-(g9_p224r1_mul_by_3)
.p2align 5, 0x90
 
.globl g9_p224r1_div_by_2
.type g9_p224r1_div_by_2, @function
 
g9_p224r1_div_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(32), %esp
    and          $(-16), %esp
    movl         %eax, (28)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_add_224
    mov          $(0), %edx
    movl         (%esi), %ecx
    and          $(1), %ecx
    cmovne       %edi, %esi
    cmove        %edx, %eax
    movl         (8)(%ebp), %edi
    call         g9_shr_224
    mov          (28)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe10:
.size g9_p224r1_div_by_2, .Lfe10-(g9_p224r1_div_by_2)
.p2align 5, 0x90
 
.globl g9_p224r1_mul_mont_slm
.type g9_p224r1_mul_mont_slm, @function
 
g9_p224r1_mul_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    mov          %esp, %eax
    sub          $(48), %esp
    and          $(-16), %esp
    movl         %eax, (44)(%esp)
    pxor         %mm0, %mm0
    movq         %mm0, (%esp)
    movq         %mm0, (8)(%esp)
    movq         %mm0, (16)(%esp)
    movq         %mm0, (24)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebp
    movl         %edi, (32)(%esp)
    movl         %esi, (36)(%esp)
    movl         %ebp, (40)(%esp)
    mov          $(7), %edi
    movd         (4)(%esi), %mm1
    movd         (8)(%esi), %mm2
    movd         (12)(%esi), %mm3
    movd         (16)(%esi), %mm4
.p2align 5, 0x90
.Lmmul_loopgas_11: 
    movd         %edi, %mm7
    movl         (%ebp), %edx
    movl         (%esi), %eax
    movd         %edx, %mm0
    add          $(4), %ebp
    movl         %ebp, (40)(%esp)
    pmuludq      %mm0, %mm1
    pmuludq      %mm0, %mm2
    mul          %edx
    addl         (%esp), %eax
    adc          $(0), %edx
    pmuludq      %mm0, %mm3
    pmuludq      %mm0, %mm4
    movd         %mm1, %ecx
    psrlq        $(32), %mm1
    add          %edx, %ecx
    movd         %mm1, %edx
    adc          $(0), %edx
    addl         (4)(%esp), %ecx
    movd         (20)(%esi), %mm1
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (8)(%esp), %ebx
    movd         (24)(%esi), %mm2
    adc          $(0), %edx
    pmuludq      %mm0, %mm1
    pmuludq      %mm0, %mm2
    movd         %mm3, %ebp
    psrlq        $(32), %mm3
    add          %edx, %ebp
    movd         %mm3, %edx
    adc          $(0), %edx
    addl         (12)(%esp), %ebp
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (16)(%esp), %edi
    adc          $(0), %edx
    neg          %eax
    adc          $(0), %ecx
    movl         %ecx, (%esp)
    adc          $(0), %ebx
    movl         %ebx, (4)(%esp)
    mov          %eax, %ecx
    sbb          $(0), %eax
    sub          %eax, %ebp
    movl         %ebp, (8)(%esp)
    mov          %ecx, %eax
    mov          $(0), %ebp
    sbb          $(0), %edi
    movl         %edi, (12)(%esp)
    adc          $(0), %ebp
    movd         %mm1, %ecx
    psrlq        $(32), %mm1
    add          %edx, %ecx
    movd         %mm1, %edx
    adc          $(0), %edx
    addl         (20)(%esp), %ecx
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (24)(%esp), %ebx
    adc          $(0), %edx
    sub          %ebp, %ecx
    movl         %ecx, (16)(%esp)
    sbb          $(0), %ebx
    movl         %ebx, (20)(%esp)
    movd         %mm7, %edi
    sbb          $(0), %eax
    mov          $(0), %ebx
    addl         (28)(%esp), %edx
    adc          $(0), %ebx
    add          %eax, %edx
    movl         %edx, (24)(%esp)
    adc          $(0), %ebx
    movl         %ebx, (28)(%esp)
    sub          $(1), %edi
    movd         (4)(%esi), %mm1
    movd         (8)(%esi), %mm2
    movd         (12)(%esi), %mm3
    movd         (16)(%esi), %mm4
    jz           .Lexit_mmul_loopgas_11
    movl         (40)(%esp), %ebp
    jmp          .Lmmul_loopgas_11
.Lexit_mmul_loopgas_11: 
    emms
    mov          (32)(%esp), %edi
    lea          (%esp), %esi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_sub_224
    movl         (28)(%esp), %edx
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    mov          (44)(%esp), %esp
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe11:
.size g9_p224r1_mul_mont_slm, .Lfe11-(g9_p224r1_mul_mont_slm)
.p2align 5, 0x90
 
.globl g9_p224r1_sqr_mont_slm
.type g9_p224r1_sqr_mont_slm, @function
 
g9_p224r1_sqr_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
    push         %esi
    push         %esi
    push         %edi
    call         g9_p224r1_mul_mont_slm
    add          $(12), %esp
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe12:
.size g9_p224r1_sqr_mont_slm, .Lfe12-(g9_p224r1_sqr_mont_slm)
.p2align 5, 0x90
 
.globl g9_p224r1_mred
.type g9_p224r1_mred, @function
 
g9_p224r1_mred:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    mov          $(7), %ecx
    xor          %edx, %edx
.p2align 5, 0x90
.Lmred_loopgas_13: 
    movl         (%esi), %eax
    neg          %eax
    mov          $(0), %ebx
    movl         %ebx, (%esi)
    movl         (4)(%esi), %ebx
    adc          $(0), %ebx
    movl         %ebx, (4)(%esi)
    movl         (8)(%esi), %ebx
    adc          $(0), %ebx
    movl         %ebx, (8)(%esi)
    push         %eax
    movl         (12)(%esi), %ebx
    sbb          $(0), %eax
    sub          %eax, %ebx
    movl         %ebx, (12)(%esi)
    pop          %eax
    movl         (16)(%esi), %ebx
    sbb          $(0), %ebx
    movl         %ebx, (16)(%esi)
    movl         (20)(%esi), %ebx
    sbb          $(0), %ebx
    movl         %ebx, (20)(%esi)
    movl         (24)(%esi), %ebx
    sbb          $(0), %ebx
    movl         %ebx, (24)(%esi)
    movl         (28)(%esi), %ebx
    sbb          $(0), %eax
    add          %edx, %eax
    mov          $(0), %edx
    adc          $(0), %edx
    add          %eax, %ebx
    movl         %ebx, (28)(%esi)
    adc          $(0), %edx
    lea          (4)(%esi), %esi
    sub          $(1), %ecx
    jnz          .Lmred_loopgas_13
    movl         (8)(%ebp), %edi
    lea          p224r1_data, %ebx
    lea          ((_prime224r1-p224r1_data))(%ebx), %ebx
    call         g9_sub_224
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movq         (16)(%esi), %xmm1
    movd         (24)(%esi), %xmm2
    movdqu       %xmm0, (%edi)
    movq         %xmm1, (16)(%edi)
    movd         %xmm2, (24)(%edi)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe13:
.size g9_p224r1_mred, .Lfe13-(g9_p224r1_mred)
.p2align 5, 0x90
 
.globl g9_p224r1_select_pp_w5
.type g9_p224r1_select_pp_w5, @function
 
g9_p224r1_select_pp_w5:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    pxor         %xmm0, %xmm0
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %eax
    movd         %eax, %xmm7
    pshufd       $(0), %xmm7, %xmm7
    mov          $(1), %edx
    movd         %edx, %xmm6
    pshufd       $(0), %xmm6, %xmm6
    movdqa       %xmm0, (%edi)
    movdqa       %xmm0, (16)(%edi)
    movdqa       %xmm0, (32)(%edi)
    movdqa       %xmm0, (48)(%edi)
    movdqa       %xmm0, (64)(%edi)
    pxor         %xmm3, %xmm3
    movdqa       %xmm6, %xmm5
    mov          $(16), %ecx
.p2align 5, 0x90
.Lselect_loopgas_14: 
    movdqa       %xmm5, %xmm4
    pcmpeqd      %xmm7, %xmm4
    movdqu       (%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (%edi), %xmm0
    movdqa       %xmm0, (%edi)
    movdqu       (16)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (16)(%edi), %xmm1
    movdqa       %xmm1, (16)(%edi)
    movdqu       (32)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (32)(%edi), %xmm0
    movdqa       %xmm0, (32)(%edi)
    movdqu       (48)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (48)(%edi), %xmm1
    movdqa       %xmm1, (48)(%edi)
    movdqu       (64)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (64)(%edi), %xmm0
    movdqa       %xmm0, (64)(%edi)
    movd         (80)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          %xmm1, %xmm3
    paddd        %xmm6, %xmm5
    add          $(84), %esi
    sub          $(1), %ecx
    jnz          .Lselect_loopgas_14
    movd         %xmm3, (80)(%edi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe14:
.size g9_p224r1_select_pp_w5, .Lfe14-(g9_p224r1_select_pp_w5)
 
