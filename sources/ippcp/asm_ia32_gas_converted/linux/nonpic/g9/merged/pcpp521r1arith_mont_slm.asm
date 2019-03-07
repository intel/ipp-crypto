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
p521r1_data: 
 
_prime521r1:
.long   0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,  0xFFFFFFFF 
 

.long   0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,  0xFFFFFFFF 
 

.long        0x1FF 
 
.p2align 5, 0x90
 

.type g9_add_521, @function
 
g9_add_521:
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
    movl         (32)(%esi), %eax
    adcl         (32)(%ebx), %eax
    movl         %eax, (32)(%edi)
    movl         (36)(%esi), %eax
    adcl         (36)(%ebx), %eax
    movl         %eax, (36)(%edi)
    movl         (40)(%esi), %eax
    adcl         (40)(%ebx), %eax
    movl         %eax, (40)(%edi)
    movl         (44)(%esi), %eax
    adcl         (44)(%ebx), %eax
    movl         %eax, (44)(%edi)
    movl         (48)(%esi), %eax
    adcl         (48)(%ebx), %eax
    movl         %eax, (48)(%edi)
    movl         (52)(%esi), %eax
    adcl         (52)(%ebx), %eax
    movl         %eax, (52)(%edi)
    movl         (56)(%esi), %eax
    adcl         (56)(%ebx), %eax
    movl         %eax, (56)(%edi)
    movl         (60)(%esi), %eax
    adcl         (60)(%ebx), %eax
    movl         %eax, (60)(%edi)
    movl         (64)(%esi), %eax
    adcl         (64)(%ebx), %eax
    movl         %eax, (64)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe1:
.size g9_add_521, .Lfe1-(g9_add_521)
.p2align 5, 0x90
 

.type g9_sub_521, @function
 
g9_sub_521:
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
    movl         (32)(%esi), %eax
    sbbl         (32)(%ebx), %eax
    movl         %eax, (32)(%edi)
    movl         (36)(%esi), %eax
    sbbl         (36)(%ebx), %eax
    movl         %eax, (36)(%edi)
    movl         (40)(%esi), %eax
    sbbl         (40)(%ebx), %eax
    movl         %eax, (40)(%edi)
    movl         (44)(%esi), %eax
    sbbl         (44)(%ebx), %eax
    movl         %eax, (44)(%edi)
    movl         (48)(%esi), %eax
    sbbl         (48)(%ebx), %eax
    movl         %eax, (48)(%edi)
    movl         (52)(%esi), %eax
    sbbl         (52)(%ebx), %eax
    movl         %eax, (52)(%edi)
    movl         (56)(%esi), %eax
    sbbl         (56)(%ebx), %eax
    movl         %eax, (56)(%edi)
    movl         (60)(%esi), %eax
    sbbl         (60)(%ebx), %eax
    movl         %eax, (60)(%edi)
    movl         (64)(%esi), %eax
    sbbl         (64)(%ebx), %eax
    movl         %eax, (64)(%edi)
    mov          $(0), %eax
    adc          $(0), %eax
    ret
.Lfe2:
.size g9_sub_521, .Lfe2-(g9_sub_521)
.p2align 5, 0x90
 

.type g9_shl_521, @function
 
g9_shl_521:
    push         %ecx
    mov          $(13), %ecx
    pxor         %xmm1, %xmm1
.Lshl_loopgas_3: 
    movdqu       (%esi), %xmm0
    movdqa       %xmm0, %xmm2
    add          $(16), %esi
    palignr      $(8), %xmm1, %xmm2
    movdqa       %xmm0, %xmm1
    psllq        $(1), %xmm0
    psrlq        $(63), %xmm2
    por          %xmm2, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    sub          $(4), %ecx
    jg           .Lshl_loopgas_3
    movd         (%esi), %xmm0
    palignr      $(12), %xmm1, %xmm0
    psllq        $(1), %xmm0
    psrldq       $(4), %xmm0
    movd         %xmm0, (%edi)
    sub          $(64), %esi
    sub          $(64), %edi
    pop          %ecx
    xor          %eax, %eax
    ret
.Lfe3:
.size g9_shl_521, .Lfe3-(g9_shl_521)
.p2align 5, 0x90
 

.type g9_shr_521, @function
 
g9_shr_521:
    movl         (64)(%esi), %eax
    push         %ecx
    mov          $(9), %ecx
.Lshr_loopgas_4: 
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    palignr      $(8), %xmm0, %xmm1
    add          $(16), %esi
    psrlq        $(1), %xmm0
    psllq        $(63), %xmm1
    por          %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    sub          $(4), %ecx
    jg           .Lshr_loopgas_4
    pop          %ecx
    movdqu       (%esi), %xmm0
    movd         %eax, %xmm1
    palignr      $(8), %xmm0, %xmm1
    psrlq        $(1), %xmm0
    psllq        $(63), %xmm1
    por          %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    shr          $(1), %eax
    movl         %eax, (16)(%edi)
    sub          $(24), %esi
    sub          $(24), %esi
    ret
.Lfe4:
.size g9_shr_521, .Lfe4-(g9_shr_521)
.p2align 5, 0x90
 
.globl g9_p521r1_add
.type g9_p521r1_add, @function
 
g9_p521r1_add:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         g9_add_521
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_sub_521
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    sub          %eax, %edx
    cmovne       %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe5:
.size g9_p521r1_add, .Lfe5-(g9_p521r1_add)
.p2align 5, 0x90
 
.globl g9_p521r1_sub
.type g9_p521r1_sub, @function
 
g9_p521r1_sub:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebx
    call         g9_sub_521
    mov          %eax, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_add_521
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe6:
.size g9_p521r1_sub, .Lfe6-(g9_p521r1_sub)
.p2align 5, 0x90
 
.globl g9_p521r1_neg
.type g9_p521r1_neg, @function
 
g9_p521r1_neg:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
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
    mov          $(0), %eax
    sbbl         (32)(%esi), %eax
    movl         %eax, (32)(%edi)
    mov          $(0), %eax
    sbbl         (36)(%esi), %eax
    movl         %eax, (36)(%edi)
    mov          $(0), %eax
    sbbl         (40)(%esi), %eax
    movl         %eax, (40)(%edi)
    mov          $(0), %eax
    sbbl         (44)(%esi), %eax
    movl         %eax, (44)(%edi)
    mov          $(0), %eax
    sbbl         (48)(%esi), %eax
    movl         %eax, (48)(%edi)
    mov          $(0), %eax
    sbbl         (52)(%esi), %eax
    movl         %eax, (52)(%edi)
    mov          $(0), %eax
    sbbl         (56)(%esi), %eax
    movl         %eax, (56)(%edi)
    mov          $(0), %eax
    sbbl         (60)(%esi), %eax
    movl         %eax, (60)(%edi)
    mov          $(0), %eax
    sbbl         (64)(%esi), %eax
    movl         %eax, (64)(%edi)
    sbb          %edx, %edx
    lea          (%esp), %edi
    movl         (8)(%ebp), %esi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_add_521
    lea          (%esp), %esi
    movl         (8)(%ebp), %edi
    test         %edx, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe7:
.size g9_p521r1_neg, .Lfe7-(g9_p521r1_neg)
.p2align 5, 0x90
 
.globl g9_p521r1_mul_by_2
.type g9_p521r1_mul_by_2, @function
 
g9_p521r1_mul_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         g9_shl_521
    mov          %eax, %edx
    mov          %edi, %esi
    movl         (8)(%ebp), %edi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_sub_521
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe8:
.size g9_p521r1_mul_by_2, .Lfe8-(g9_p521r1_mul_by_2)
.p2align 5, 0x90
 
.globl g9_p521r1_mul_by_3
.type g9_p521r1_mul_by_3, @function
 
g9_p521r1_mul_by_3:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(144), %esp
    and          $(-16), %esp
    movl         %eax, (140)(%esp)
    lea          p521r1_data, %eax
    lea          ((_prime521r1-p521r1_data))(%eax), %eax
    movl         %eax, (136)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    call         g9_shl_521
    mov          %eax, %edx
    mov          %edi, %esi
    lea          (68)(%esp), %edi
    mov          (136)(%esp), %ebx
    call         g9_sub_521
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          %edi, %esi
    movl         (12)(%ebp), %ebx
    call         g9_add_521
    mov          %eax, %edx
    movl         (8)(%ebp), %edi
    mov          (136)(%esp), %ebx
    call         g9_sub_521
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (140)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe9:
.size g9_p521r1_mul_by_3, .Lfe9-(g9_p521r1_mul_by_3)
.p2align 5, 0x90
 
.globl g9_p521r1_div_by_2
.type g9_p521r1_div_by_2, @function
 
g9_p521r1_div_by_2:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    mov          %esp, %eax
    sub          $(72), %esp
    and          $(-16), %esp
    movl         %eax, (68)(%esp)
    lea          (%esp), %edi
    movl         (12)(%ebp), %esi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_add_521
    mov          $(0), %edx
    movl         (%esi), %ecx
    and          $(1), %ecx
    cmovne       %edi, %esi
    cmove        %edx, %eax
    movl         (8)(%ebp), %edi
    call         g9_shr_521
    mov          (68)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe10:
.size g9_p521r1_div_by_2, .Lfe10-(g9_p521r1_div_by_2)
.p2align 5, 0x90
 
.globl g9_p521r1_mul_mont_slm
.type g9_p521r1_mul_mont_slm, @function
 
g9_p521r1_mul_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    mov          %esp, %eax
    sub          $(88), %esp
    and          $(-16), %esp
    movl         %eax, (84)(%esp)
    pxor         %xmm0, %xmm0
    movdqa       %xmm0, (%esp)
    movdqa       %xmm0, (16)(%esp)
    movdqa       %xmm0, (32)(%esp)
    movdqa       %xmm0, (48)(%esp)
    movq         %xmm0, (64)(%esp)
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %ebp
    movl         %edi, (72)(%esp)
    movl         %esi, (76)(%esp)
    movl         %ebp, (80)(%esp)
    mov          $(17), %ebx
    movd         (4)(%esi), %mm1
    movd         (8)(%esi), %mm2
    movd         (12)(%esi), %mm3
    movd         (16)(%esi), %mm4
.p2align 5, 0x90
.Lmmul_loopgas_11: 
    movd         %ebx, %mm7
    movl         (%ebp), %edx
    movl         (%esi), %eax
    movd         %edx, %mm0
    add          $(4), %ebp
    movl         %ebp, (80)(%esp)
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
    movl         %ecx, (%esp)
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (8)(%esp), %ebx
    movd         (24)(%esi), %mm2
    movl         %ebx, (4)(%esp)
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
    movl         %ebp, (8)(%esp)
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (16)(%esp), %edi
    movd         (32)(%esi), %mm4
    movl         %edi, (12)(%esp)
    adc          $(0), %edx
    pmuludq      %mm0, %mm3
    pmuludq      %mm0, %mm4
    movd         %mm1, %ecx
    psrlq        $(32), %mm1
    add          %edx, %ecx
    movd         %mm1, %edx
    adc          $(0), %edx
    addl         (20)(%esp), %ecx
    movd         (36)(%esi), %mm1
    movl         %ecx, (16)(%esp)
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (24)(%esp), %ebx
    movd         (40)(%esi), %mm2
    movl         %ebx, (20)(%esp)
    adc          $(0), %edx
    pmuludq      %mm0, %mm1
    pmuludq      %mm0, %mm2
    movd         %mm3, %ebp
    psrlq        $(32), %mm3
    add          %edx, %ebp
    movd         %mm3, %edx
    adc          $(0), %edx
    addl         (28)(%esp), %ebp
    movd         (44)(%esi), %mm3
    movl         %ebp, (24)(%esp)
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (32)(%esp), %edi
    movd         (48)(%esi), %mm4
    movl         %edi, (28)(%esp)
    adc          $(0), %edx
    pmuludq      %mm0, %mm3
    pmuludq      %mm0, %mm4
    movd         %mm1, %ecx
    psrlq        $(32), %mm1
    add          %edx, %ecx
    movd         %mm1, %edx
    adc          $(0), %edx
    addl         (36)(%esp), %ecx
    movd         (52)(%esi), %mm1
    movl         %ecx, (32)(%esp)
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (40)(%esp), %ebx
    movd         (56)(%esi), %mm2
    movl         %ebx, (36)(%esp)
    adc          $(0), %edx
    pmuludq      %mm0, %mm1
    pmuludq      %mm0, %mm2
    movd         %mm3, %ebp
    psrlq        $(32), %mm3
    add          %edx, %ebp
    movd         %mm3, %edx
    adc          $(0), %edx
    addl         (44)(%esp), %ebp
    movd         (60)(%esi), %mm3
    movl         %ebp, (40)(%esp)
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (48)(%esp), %edi
    movd         (64)(%esi), %mm4
    movl         %edi, (44)(%esp)
    adc          $(0), %edx
    pmuludq      %mm0, %mm3
    pmuludq      %mm0, %mm4
    movd         %mm1, %ecx
    psrlq        $(32), %mm1
    add          %edx, %ecx
    movd         %mm1, %edx
    adc          $(0), %edx
    addl         (52)(%esp), %ecx
    movl         %ecx, (48)(%esp)
    adc          $(0), %edx
    movd         %mm2, %ebx
    psrlq        $(32), %mm2
    add          %edx, %ebx
    movd         %mm2, %edx
    adc          $(0), %edx
    addl         (56)(%esp), %ebx
    movl         %ebx, (52)(%esp)
    adc          $(0), %edx
    movd         %mm3, %ebp
    psrlq        $(32), %mm3
    add          %edx, %ebp
    movd         %mm3, %edx
    adc          $(0), %edx
    addl         (60)(%esp), %ebp
    movl         %ebp, (56)(%esp)
    adc          $(0), %edx
    movd         %mm4, %edi
    psrlq        $(32), %mm4
    add          %edx, %edi
    movd         %mm4, %edx
    adc          $(0), %edx
    addl         (64)(%esp), %edi
    adc          $(0), %edx
    movd         %mm7, %ebx
    mov          %eax, %ecx
    shl          $(9), %eax
    shr          $(23), %ecx
    add          %eax, %edi
    movl         %edi, (60)(%esp)
    adc          %ecx, %edx
    movl         %edx, (64)(%esp)
    sub          $(1), %ebx
    movd         (4)(%esi), %mm1
    movd         (8)(%esi), %mm2
    movd         (12)(%esi), %mm3
    movd         (16)(%esi), %mm4
    jz           .Lexit_mmul_loopgas_11
    movl         (80)(%esp), %ebp
    jmp          .Lmmul_loopgas_11
.Lexit_mmul_loopgas_11: 
    emms
    mov          (72)(%esp), %edi
    lea          (%esp), %esi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_sub_521
    movl         (68)(%esp), %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    mov          (84)(%esp), %esp
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe11:
.size g9_p521r1_mul_mont_slm, .Lfe11-(g9_p521r1_mul_mont_slm)
.p2align 5, 0x90
 
.globl g9_p521r1_sqr_mont_slm
.type g9_p521r1_sqr_mont_slm, @function
 
g9_p521r1_sqr_mont_slm:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
    push         %esi
    push         %esi
    push         %edi
    call         g9_p521r1_mul_mont_slm
    add          $(12), %esp
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe12:
.size g9_p521r1_sqr_mont_slm, .Lfe12-(g9_p521r1_sqr_mont_slm)
.p2align 5, 0x90
 
.globl g9_p521r1_mred
.type g9_p521r1_mred, @function
 
g9_p521r1_mred:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    mov          $(17), %ecx
    xor          %edx, %edx
.p2align 5, 0x90
.Lmred_loopgas_13: 
    movl         (%esi), %ebx
    movl         (%esi), %eax
    shr          $(23), %ebx
    shl          $(9), %eax
    add          %edx, %ebx
    addl         (64)(%esi), %eax
    movl         (68)(%esi), %edx
    adc          %edx, %ebx
    mov          $(0), %edx
    movl         %eax, (64)(%esi)
    movl         %ebx, (68)(%esi)
    adc          $(0), %edx
    lea          (4)(%esi), %esi
    sub          $(1), %ecx
    jnz          .Lmred_loopgas_13
    movl         (8)(%ebp), %edi
    lea          p521r1_data, %ebx
    lea          ((_prime521r1-p521r1_data))(%ebx), %ebx
    call         g9_sub_521
    sub          %eax, %edx
    cmove        %edi, %esi
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movl         (64)(%esi), %eax
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    movl         %eax, (64)(%edi)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe13:
.size g9_p521r1_mred, .Lfe13-(g9_p521r1_mred)
.p2align 5, 0x90
 
.globl g9_p521r1_select_pp_w5
.type g9_p521r1_select_pp_w5, @function
 
g9_p521r1_select_pp_w5:
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
    movdqa       %xmm0, (96)(%edi)
    movdqa       %xmm0, (112)(%edi)
    movdqa       %xmm0, (128)(%edi)
    movdqa       %xmm0, (144)(%edi)
    movdqa       %xmm0, (160)(%edi)
    movdqa       %xmm0, (176)(%edi)
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
    movdqu       (80)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (80)(%edi), %xmm1
    movdqa       %xmm1, (80)(%edi)
    movdqu       (96)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (96)(%edi), %xmm0
    movdqa       %xmm0, (96)(%edi)
    movdqu       (112)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (112)(%edi), %xmm1
    movdqa       %xmm1, (112)(%edi)
    movdqu       (128)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (128)(%edi), %xmm0
    movdqa       %xmm0, (128)(%edi)
    movdqu       (144)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (144)(%edi), %xmm1
    movdqa       %xmm1, (144)(%edi)
    movdqu       (160)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          (160)(%edi), %xmm0
    movdqa       %xmm0, (160)(%edi)
    movdqu       (176)(%esi), %xmm1
    pand         %xmm4, %xmm1
    por          (176)(%edi), %xmm1
    movdqa       %xmm1, (176)(%edi)
    movdqu       (192)(%esi), %xmm0
    pand         %xmm4, %xmm0
    por          %xmm0, %xmm3
    paddd        %xmm6, %xmm5
    add          $(204), %esi
    sub          $(1), %ecx
    jnz          .Lselect_loopgas_14
    movq         %xmm3, (192)(%edi)
    psrldq       $(8), %xmm3
    movd         %xmm3, (200)(%edi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe14:
.size g9_p521r1_select_pp_w5, .Lfe14-(g9_p521r1_select_pp_w5)
 
