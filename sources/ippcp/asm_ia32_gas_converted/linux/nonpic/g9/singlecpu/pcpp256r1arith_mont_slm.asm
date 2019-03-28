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
p256r1_data: 
 
_prime256r1:
.long   0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,        0x0,        0x0,        0x0,        0x1,  0xFFFFFFFF 
 
.p2align 5, 0x90
 

.type add_256, @function
 
add_256:
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
    movl         (28)(%esi), %eax
    adcl         (28)(%ebx), %eax
    movl         %eax, (28)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe1:
.size add_256, .Lfe1-(add_256)
.p2align 5, 0x90
 

.type sub_256, @function
 
sub_256:
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
    movl         (28)(%esi), %eax
    sbbl         (28)(%ebx), %eax
    movl         %eax, (28)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe2:
.size sub_256, .Lfe2-(sub_256)
.p2align 5, 0x90
 

.type shl_256, @function
 
shl_256:
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movl         (28)(%esi), %eax
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
    movdqu       %xmm1, (16)(%edi)
    shr          $(31), %eax
    ret
.Lfe3:
.size shl_256, .Lfe3-(shl_256)
.p2align 5, 0x90
 

.type shr_256, @function
 
shr_256:
    movd         %eax, %xmm4
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    psllq        $(63), %xmm4
    movdqa       %xmm0, %xmm2
    psrlq        $(1), %xmm0
    psllq        $(63), %xmm2
    movdqa       %xmm1, %xmm3
    psrlq        $(1), %xmm1
    psllq        $(63), %xmm3
    palignr      $(8), %xmm3, %xmm4
    palignr      $(8), %xmm2, %xmm3
    por          %xmm4, %xmm1
    por          %xmm3, %xmm0
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    ret
.Lfe4:
.size shr_256, .Lfe4-(shr_256)
.p2align 5, 0x90
 
.globl p256r1_add
.type p256r1_add, @function
 
p256r1_add:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(36), %esp
    and          $(-16), %esp
    movl         %eax, (32)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         add_256
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         sub_256
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    sub          %eax, %edx
    cmovne       %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (32)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe5:
.size p256r1_add, .Lfe5-(p256r1_add)
.p2align 5, 0x90
 
.globl p256r1_sub
.type p256r1_sub, @function
 
p256r1_sub:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(36), %esp
    and          $(-16), %esp
    movl         %eax, (32)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         sub_256
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         add_256
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (32)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe6:
.size p256r1_sub, .Lfe6-(p256r1_sub)
.p2align 5, 0x90
 
.globl p256r1_neg
.type p256r1_neg, @function
 
p256r1_neg:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(36), %esp
    and          $(-16), %esp
    movl         %eax, (32)(%esp)
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
    mov          $(0), %eax
    sbbl         (28)(%esi), %eax
    movl         %eax, (28)(%edi)
    sbb          %edx, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         add_256
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (32)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe7:
.size p256r1_neg, .Lfe7-(p256r1_neg)
.p2align 5, 0x90
 
.globl p256r1_mul_by_2
.type p256r1_mul_by_2, @function
 
p256r1_mul_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(36), %esp
    and          $(-16), %esp
    movl         %eax, (32)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         shl_256
    mov          %eax, %edx
    mov          %edi, %esi
    movl         (8)(%ebp), %edi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         sub_256
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (32)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe8:
.size p256r1_mul_by_2, .Lfe8-(p256r1_mul_by_2)
.p2align 5, 0x90
 
.globl p256r1_mul_by_3
.type p256r1_mul_by_3, @function
 
p256r1_mul_by_3:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
    lea          p256r1_data, %eax
    lea          ((_prime256r1-p256r1_data))(%eax), %eax
    movl         %eax, (64)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         shl_256
    mov          %eax, %edx
    mov          %edi, %esi
    lea          (32)(%esp), %edi
    mov          (64)(%esp), %ebx
    call         sub_256
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          %edi, %esi
    movl         (12)(%ebp), %ebx
    call         add_256
    mov          %eax, %edx
    movl         (8)(%ebp), %edi
    mov          (64)(%esp), %ebx
    call         sub_256
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe9:
.size p256r1_mul_by_3, .Lfe9-(p256r1_mul_by_3)
.p2align 5, 0x90
 
.globl p256r1_div_by_2
.type p256r1_div_by_2, @function
 
p256r1_div_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(36), %esp
    and          $(-16), %esp
    movl         %eax, (32)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         add_256
    mov          $(0), %edx
    movl         (%esi), %ecx
    and          $(1), %ecx
    cmovne       %edi, %esi
    cmove        %edx, %eax
    movl         (8)(%ebp), %edi
    call         shr_256
    mov          (32)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe10:
.size p256r1_div_by_2, .Lfe10-(p256r1_div_by_2)
.p2align 5, 0x90
 
.globl p256r1_mul_mont_slm
.type p256r1_mul_mont_slm, @function
 
p256r1_mul_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    mov          %esp, %eax
    sub          $(52), %esp
    and          $(-16), %esp
    movl         %eax, (48)(%esp)
    pxor         %mm0, %mm0
    movq         %mm0, (%esp)
    movq         %mm0, (8)(%esp)
    movq         %mm0, (16)(%esp)
    movq         %mm0, (24)(%esp)
    movd         %mm0, (32)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebp
    movl         %edi, (36)(%esp)
    movl         %esi, (40)(%esp)
    movl         %ebp, (44)(%esp)
    mov          $(8), %edi
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
    movl         %ebp, (44)(%esp)
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
    movd         (28)(%esi), %mm3
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (16)(%esp), %edi
    adc          $(0), %edx
    pmuludq      %mm0, %mm3
    movl         %ecx, (%esp)
    movl         %ebx, (4)(%esp)
    add          %eax, %ebp
    movl         %ebp, (8)(%esp)
    adc          $(0), %edi
    movl         %edi, (12)(%esp)
    mov          $(0), %edi
    adc          $(0), %edi
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
    movd         %mm3, %ebp
    psrlq        $(32), %mm3
    add          %edx, %ebp
    movd         %mm3, %edx
    adc          $(0), %edx
    addl         (28)(%esp), %ebp
    adc          $(0), %edx
    add          %edi, %ecx
    movl         %ecx, (16)(%esp)
    adc          %eax, %ebx
    movl         %ebx, (20)(%esp)
    mov          %eax, %ecx
    sbb          $(0), %eax
    sub          %eax, %ebp
    movl         %ebp, (24)(%esp)
    movd         %mm7, %edi
    sbb          $(0), %ecx
    mov          $(0), %ebx
    addl         (32)(%esp), %edx
    adc          $(0), %ebx
    add          %ecx, %edx
    movl         %edx, (28)(%esp)
    adc          $(0), %ebx
    movl         %ebx, (32)(%esp)
    sub          $(1), %edi
    movd         (4)(%esi), %mm1
    movd         (8)(%esi), %mm2
    movd         (12)(%esi), %mm3
    movd         (16)(%esi), %mm4
    jz           .Lexit_mmul_loopgas_11
    movl         (44)(%esp), %ebp
    jmp          .Lmmul_loopgas_11
.Lexit_mmul_loopgas_11: 
    emms
    mov          (36)(%esp), %edi
    lea          (%esp), %esi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         sub_256
    movl         (32)(%esp), %edx
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    mov          (48)(%esp), %esp
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe11:
.size p256r1_mul_mont_slm, .Lfe11-(p256r1_mul_mont_slm)
.p2align 5, 0x90
 
.globl p256r1_sqr_mont_slm
.type p256r1_sqr_mont_slm, @function
 
p256r1_sqr_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
    push         %esi
    push         %esi
    push         %edi
    call         p256r1_mul_mont_slm
    add          $(12), %esp
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe12:
.size p256r1_sqr_mont_slm, .Lfe12-(p256r1_sqr_mont_slm)
.p2align 5, 0x90
 
.globl p256r1_mred
.type p256r1_mred, @function
 
p256r1_mred:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    mov          $(8), %ecx
    xor          %edx, %edx
.p2align 5, 0x90
.Lmred_loopgas_13: 
    movl         (%esi), %eax
    mov          $(0), %ebx
    movl         %ebx, (%esi)
    movl         (12)(%esi), %ebx
    add          %eax, %ebx
    movl         %ebx, (12)(%esi)
    movl         (16)(%esi), %ebx
    adc          $(0), %ebx
    movl         %ebx, (16)(%esi)
    movl         (20)(%esi), %ebx
    adc          $(0), %ebx
    movl         %ebx, (20)(%esi)
    movl         (24)(%esi), %ebx
    adc          %eax, %ebx
    movl         %ebx, (24)(%esi)
    movl         (28)(%esi), %ebx
    push         %eax
    sbb          $(0), %eax
    sub          %eax, %ebx
    movl         %ebx, (28)(%esi)
    pop          %eax
    movl         (32)(%esi), %ebx
    sbb          $(0), %eax
    add          %edx, %eax
    mov          $(0), %edx
    adc          $(0), %edx
    add          %eax, %ebx
    movl         %ebx, (32)(%esi)
    adc          $(0), %edx
    lea          (4)(%esi), %esi
    sub          $(1), %ecx
    jnz          .Lmred_loopgas_13
    movl         (8)(%ebp), %edi
    lea          p256r1_data, %ebx
    lea          ((_prime256r1-p256r1_data))(%ebx), %ebx
    call         sub_256
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe13:
.size p256r1_mred, .Lfe13-(p256r1_mred)
.p2align 5, 0x90
 
.globl p256r1_select_pp_w5
.type p256r1_select_pp_w5, @function
 
p256r1_select_pp_w5:
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
    movdqa       %xmm0, (80)(%edi)
    movdqa       %xmm6, %xmm5
    mov          $(16), %ecx
.p2align 5, 0x90
.Lselect_loopgas_14: 
    movdqa       %xmm5, %xmm4
    pcmpeqd      %xmm7, %xmm4
    movdqa       (%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (%edi), %xmm0
    movdqa       %xmm0, (%edi)
    movdqa       (16)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (16)(%edi), %xmm1
    movdqa       %xmm1, (16)(%edi)
    movdqa       (32)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (32)(%edi), %xmm0
    movdqa       %xmm0, (32)(%edi)
    movdqa       (48)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (48)(%edi), %xmm1
    movdqa       %xmm1, (48)(%edi)
    movdqa       (64)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (64)(%edi), %xmm0
    movdqa       %xmm0, (64)(%edi)
    movdqa       (80)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (80)(%edi), %xmm1
    movdqa       %xmm1, (80)(%edi)
    paddd        %xmm6, %xmm5
    add          $(96), %esi
    sub          $(1), %ecx
    jnz          .Lselect_loopgas_14
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe14:
.size p256r1_select_pp_w5, .Lfe14-(p256r1_select_pp_w5)
 
