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
.p2align 4, 0x90
CONST_TABLE: 
 
_poly:
.quad                  0x1, 0xC200000000000000 
 
_twoone:
.quad                  0x1,        0x100000000 
 
_u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
 
_mask1:
.quad   0xffffffffffffffff,                0x0 
 
_mask2:
.quad                  0x0, 0xffffffffffffffff 
 
_inc1:
.quad  1,0 
 
.p2align 4, 0x90
 
.globl p8_AesGcmPrecompute_avx
.type p8_AesGcmPrecompute_avx, @function
 
p8_AesGcmPrecompute_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
 
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %esi
    sub          $(.L__0000gas_1-CONST_TABLE), %esi
    movl         (8)(%ebp), %eax
    movdqu       (%eax), %xmm0
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm0
    movdqa       %xmm0, %xmm4
    psllq        $(1), %xmm0
    psrlq        $(63), %xmm4
    movdqa       %xmm4, %xmm3
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm3
    por          %xmm4, %xmm0
    pshufd       $(36), %xmm3, %xmm4
    pcmpeqd      ((_twoone-CONST_TABLE))(%esi), %xmm4
    pand         ((_poly-CONST_TABLE))(%esi), %xmm4
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, %xmm1
    pshufd       $(78), %xmm1, %xmm5
    pshufd       $(78), %xmm0, %xmm3
    pxor         %xmm1, %xmm5
    pxor         %xmm0, %xmm3
    pclmulqdq    $(0), %xmm3, %xmm5
    movdqa       %xmm1, %xmm4
    pclmulqdq    $(0), %xmm0, %xmm1
    pxor         %xmm3, %xmm3
    pclmulqdq    $(17), %xmm0, %xmm4
    pxor         %xmm1, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm3
    pslldq       $(8), %xmm5
    pxor         %xmm3, %xmm4
    pxor         %xmm5, %xmm1
    movdqa       %xmm1, %xmm3
    psllq        $(1), %xmm3
    pxor         %xmm1, %xmm3
    psllq        $(5), %xmm3
    pxor         %xmm1, %xmm3
    psllq        $(57), %xmm3
    movdqa       %xmm3, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm3
    pxor         %xmm5, %xmm1
    pxor         %xmm3, %xmm4
    movdqa       %xmm1, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm1, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm1, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm1
    pxor         %xmm4, %xmm1
    movdqa       %xmm1, %xmm2
    pshufd       $(78), %xmm2, %xmm5
    pshufd       $(78), %xmm1, %xmm3
    pxor         %xmm2, %xmm5
    pxor         %xmm1, %xmm3
    pclmulqdq    $(0), %xmm3, %xmm5
    movdqa       %xmm2, %xmm4
    pclmulqdq    $(0), %xmm1, %xmm2
    pxor         %xmm3, %xmm3
    pclmulqdq    $(17), %xmm1, %xmm4
    pxor         %xmm2, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm3
    pslldq       $(8), %xmm5
    pxor         %xmm3, %xmm4
    pxor         %xmm5, %xmm2
    movdqa       %xmm2, %xmm3
    psllq        $(1), %xmm3
    pxor         %xmm2, %xmm3
    psllq        $(5), %xmm3
    pxor         %xmm2, %xmm3
    psllq        $(57), %xmm3
    movdqa       %xmm3, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm3
    pxor         %xmm5, %xmm2
    pxor         %xmm3, %xmm4
    movdqa       %xmm2, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm2, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm2, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm2
    pxor         %xmm4, %xmm2
    movl         (12)(%ebp), %eax
    movdqu       %xmm0, (%eax)
    movdqu       %xmm1, (16)(%eax)
    movdqu       %xmm2, (32)(%eax)
    pop          %esi
    pop          %ebp
    ret
.Lfe1:
.size p8_AesGcmPrecompute_avx, .Lfe1-(p8_AesGcmPrecompute_avx)
.p2align 4, 0x90
 
.globl p8_AesGcmMulGcm_avx
.type p8_AesGcmMulGcm_avx, @function
 
p8_AesGcmMulGcm_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    call         .L__0001gas_2
.L__0001gas_2:
    pop          %esi
    sub          $(.L__0001gas_2-CONST_TABLE), %esi
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %eax
    movdqa       (%edi), %xmm0
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm0
    movdqa       (%eax), %xmm1
    pshufd       $(78), %xmm0, %xmm4
    pshufd       $(78), %xmm1, %xmm2
    pxor         %xmm0, %xmm4
    pxor         %xmm1, %xmm2
    pclmulqdq    $(0), %xmm2, %xmm4
    movdqa       %xmm0, %xmm3
    pclmulqdq    $(0), %xmm1, %xmm0
    pxor         %xmm2, %xmm2
    pclmulqdq    $(17), %xmm1, %xmm3
    pxor         %xmm0, %xmm4
    pxor         %xmm3, %xmm4
    palignr      $(8), %xmm4, %xmm2
    pslldq       $(8), %xmm4
    pxor         %xmm2, %xmm3
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, %xmm2
    psllq        $(1), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(5), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(57), %xmm2
    movdqa       %xmm2, %xmm4
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm2
    pxor         %xmm4, %xmm0
    pxor         %xmm2, %xmm3
    movdqa       %xmm0, %xmm4
    psrlq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm4, %xmm0
    pxor         %xmm3, %xmm0
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm0
    movdqa       %xmm0, (%edi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe2:
.size p8_AesGcmMulGcm_avx, .Lfe2-(p8_AesGcmMulGcm_avx)
.p2align 4, 0x90
 
.globl p8_AesGcmAuth_avx
.type p8_AesGcmAuth_avx, @function
 
p8_AesGcmAuth_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    call         .L__0002gas_3
.L__0002gas_3:
    pop          %esi
    sub          $(.L__0002gas_3-CONST_TABLE), %esi
    movl         (8)(%ebp), %edi
    movdqa       (%edi), %xmm0
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm0
    movl         (20)(%ebp), %eax
    movdqa       (%eax), %xmm1
    movl         (12)(%ebp), %ecx
    movl         (16)(%ebp), %edx
.p2align 4, 0x90
.Lauth_loopgas_3: 
    movdqu       (%ecx), %xmm2
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm2
    add          $(16), %ecx
    pxor         %xmm2, %xmm0
    pshufd       $(78), %xmm0, %xmm4
    pshufd       $(78), %xmm1, %xmm2
    pxor         %xmm0, %xmm4
    pxor         %xmm1, %xmm2
    pclmulqdq    $(0), %xmm2, %xmm4
    movdqa       %xmm0, %xmm3
    pclmulqdq    $(0), %xmm1, %xmm0
    pxor         %xmm2, %xmm2
    pclmulqdq    $(17), %xmm1, %xmm3
    pxor         %xmm0, %xmm4
    pxor         %xmm3, %xmm4
    palignr      $(8), %xmm4, %xmm2
    pslldq       $(8), %xmm4
    pxor         %xmm2, %xmm3
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, %xmm2
    psllq        $(1), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(5), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(57), %xmm2
    movdqa       %xmm2, %xmm4
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm2
    pxor         %xmm4, %xmm0
    pxor         %xmm2, %xmm3
    movdqa       %xmm0, %xmm4
    psrlq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm4, %xmm0
    pxor         %xmm3, %xmm0
    sub          $(16), %edx
    jnz          .Lauth_loopgas_3
    pshufb       ((_u128_str-CONST_TABLE))(%esi), %xmm0
    movdqa       %xmm0, (%edi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe3:
.size p8_AesGcmAuth_avx, .Lfe3-(p8_AesGcmAuth_avx)
.p2align 4, 0x90
 
.globl p8_AesGcmEnc_avx
.type p8_AesGcmEnc_avx, @function
 
p8_AesGcmEnc_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(152), %esp
    lea          (16)(%esp), %ebx
    and          $(-16), %ebx
    movl         (20)(%ebp), %eax
    call         .L__0003gas_4
.L__0003gas_4:
    pop          %esi
    sub          $(.L__0003gas_4-CONST_TABLE), %esi
    movdqa       ((_u128_str-CONST_TABLE))(%esi), %xmm4
    movdqa       ((_inc1-CONST_TABLE))(%esi), %xmm5
    movl         (36)(%ebp), %eax
    movl         (40)(%ebp), %ecx
    movl         (32)(%ebp), %edx
    movdqu       (%eax), %xmm0
    movdqu       (%ecx), %xmm1
    movdqu       (%edx), %xmm2
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (%ebx)
    movdqa       %xmm1, (16)(%ebx)
    pshufb       %xmm4, %xmm2
    pxor         %xmm1, %xmm1
    movdqa       %xmm2, (32)(%ebx)
    movdqa       %xmm1, (48)(%ebx)
    movdqa       %xmm1, (64)(%ebx)
    movdqa       %xmm1, (80)(%ebx)
    movdqa       %xmm4, (96)(%ebx)
    movdqa       %xmm5, (112)(%ebx)
    movl         (28)(%ebp), %ecx
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
    movl         (16)(%ebp), %eax
    mov          $(63), %edx
    and          %eax, %edx
    and          $(-64), %eax
    movl         %eax, (128)(%ebx)
    movl         %edx, (132)(%ebx)
    jz           .Lsingle_block_procgas_4
.p2align 4, 0x90
.Lblks4_loopgas_4: 
    movdqa       (112)(%ebx), %xmm5
    movdqa       %xmm0, %xmm1
    paddd        %xmm5, %xmm1
    movdqa       %xmm1, %xmm2
    paddd        %xmm5, %xmm2
    movdqa       %xmm2, %xmm3
    paddd        %xmm5, %xmm3
    movdqa       %xmm3, %xmm4
    paddd        %xmm5, %xmm4
    movdqa       %xmm4, (%ebx)
    movdqa       (96)(%ebx), %xmm5
    movdqa       (%ecx), %xmm0
    lea          (16)(%ecx), %eax
    pshufb       %xmm5, %xmm1
    pshufb       %xmm5, %xmm2
    pshufb       %xmm5, %xmm3
    pshufb       %xmm5, %xmm4
    pxor         %xmm0, %xmm1
    pxor         %xmm0, %xmm2
    pxor         %xmm0, %xmm3
    pxor         %xmm0, %xmm4
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    movl         (24)(%ebp), %edx
    sub          $(1), %edx
.p2align 4, 0x90
.Lcipher4_loopgas_4: 
    aesenc       %xmm0, %xmm1
    aesenc       %xmm0, %xmm2
    aesenc       %xmm0, %xmm3
    aesenc       %xmm0, %xmm4
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    dec          %edx
    jnz          .Lcipher4_loopgas_4
    aesenclast   %xmm0, %xmm1
    aesenclast   %xmm0, %xmm2
    aesenclast   %xmm0, %xmm3
    aesenclast   %xmm0, %xmm4
    movdqa       (16)(%ebx), %xmm0
    movdqa       %xmm4, (16)(%ebx)
    movdqu       (%esi), %xmm4
    movdqu       (16)(%esi), %xmm5
    movdqu       (32)(%esi), %xmm6
    movdqu       (48)(%esi), %xmm7
    add          $(64), %esi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%edi)
    pshufb       (96)(%ebx), %xmm0
    pxor         (32)(%ebx), %xmm0
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%edi)
    pshufb       (96)(%ebx), %xmm1
    pxor         (48)(%ebx), %xmm1
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%edi)
    pshufb       (96)(%ebx), %xmm2
    pxor         (64)(%ebx), %xmm2
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%edi)
    pshufb       (96)(%ebx), %xmm3
    pxor         (80)(%ebx), %xmm3
    add          $(64), %edi
    movl         (44)(%ebp), %eax
    movdqa       (32)(%eax), %xmm7
    cmpl         $(64), (128)(%ebx)
    je           .Lcombine_hashgas_4
    pshufd       $(78), %xmm0, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm0, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm0, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm0
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm0, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm0
    movdqa       %xmm0, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm0, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm0
    pxor         %xmm4, %xmm5
    movdqa       %xmm0, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm0, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm0, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm0
    pxor         %xmm5, %xmm0
    pshufd       $(78), %xmm1, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm1, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm1, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm1
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm1, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm1
    movdqa       %xmm1, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm1, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm1, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm1
    pxor         %xmm4, %xmm5
    movdqa       %xmm1, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm1, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm1, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm1
    pxor         %xmm5, %xmm1
    pshufd       $(78), %xmm2, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm2, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm2, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm2
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm2, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm2
    movdqa       %xmm2, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm2, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm2, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm2
    pxor         %xmm4, %xmm5
    movdqa       %xmm2, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm2
    pxor         %xmm5, %xmm2
    pshufd       $(78), %xmm3, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm3, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm3, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm3
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm3, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm3
    movdqa       %xmm3, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm3, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm3, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm3
    pxor         %xmm4, %xmm5
    movdqa       %xmm3, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm3, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm3, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm3
    pxor         %xmm5, %xmm3
    movdqa       %xmm0, (32)(%ebx)
    movdqa       %xmm1, (48)(%ebx)
    movdqa       %xmm2, (64)(%ebx)
    movdqa       %xmm3, (80)(%ebx)
    movdqa       (%ebx), %xmm0
    subl         $(64), (128)(%ebx)
    jge          .Lblks4_loopgas_4
.Lcombine_hashgas_4: 
    pshufd       $(78), %xmm0, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm0, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm0, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm0
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm0, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm0
    movdqa       %xmm0, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm0, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm0
    pxor         %xmm4, %xmm5
    movdqa       %xmm0, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm0, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm0, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm0
    pxor         %xmm5, %xmm0
    movdqa       (16)(%eax), %xmm7
    pshufd       $(78), %xmm1, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm1, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm1, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm1
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm1, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm1
    movdqa       %xmm1, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm1, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm1, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm1
    pxor         %xmm4, %xmm5
    movdqa       %xmm1, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm1, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm1, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm1
    pxor         %xmm5, %xmm1
    movdqa       (%eax), %xmm7
    pshufd       $(78), %xmm2, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm2, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm2, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm2
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm2, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm2
    movdqa       %xmm2, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm2, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm2, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm2
    pxor         %xmm4, %xmm5
    movdqa       %xmm2, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm2
    pxor         %xmm5, %xmm2
    pxor         %xmm1, %xmm3
    pxor         %xmm2, %xmm3
    pshufd       $(78), %xmm3, %xmm6
    pshufd       $(78), %xmm7, %xmm4
    pxor         %xmm3, %xmm6
    pxor         %xmm7, %xmm4
    pclmulqdq    $(0), %xmm4, %xmm6
    movdqa       %xmm3, %xmm5
    pclmulqdq    $(0), %xmm7, %xmm3
    pxor         %xmm4, %xmm4
    pclmulqdq    $(17), %xmm7, %xmm5
    pxor         %xmm3, %xmm6
    pxor         %xmm5, %xmm6
    palignr      $(8), %xmm6, %xmm4
    pslldq       $(8), %xmm6
    pxor         %xmm4, %xmm5
    pxor         %xmm6, %xmm3
    movdqa       %xmm3, %xmm4
    psllq        $(1), %xmm4
    pxor         %xmm3, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm3, %xmm4
    psllq        $(57), %xmm4
    movdqa       %xmm4, %xmm6
    pslldq       $(8), %xmm6
    psrldq       $(8), %xmm4
    pxor         %xmm6, %xmm3
    pxor         %xmm4, %xmm5
    movdqa       %xmm3, %xmm6
    psrlq        $(5), %xmm6
    pxor         %xmm3, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm3, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm6, %xmm3
    pxor         %xmm5, %xmm3
    pxor         %xmm0, %xmm3
    movdqa       %xmm3, (32)(%ebx)
.Lsingle_block_procgas_4: 
    cmpl         $(0), (132)(%ebx)
    jz           .Lquitgas_4
.p2align 4, 0x90
.Lblk_loopgas_4: 
    movdqa       (%ebx), %xmm0
    movdqa       %xmm0, %xmm1
    paddd        (112)(%ebx), %xmm1
    movdqa       %xmm1, (%ebx)
    movdqa       (%ecx), %xmm0
    lea          (16)(%ecx), %eax
    pshufb       (96)(%ebx), %xmm1
    pxor         %xmm0, %xmm1
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    movl         (24)(%ebp), %edx
    sub          $(1), %edx
.p2align 4, 0x90
.Lcipher_loopgas_4: 
    aesenc       %xmm0, %xmm1
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    dec          %edx
    jnz          .Lcipher_loopgas_4
    aesenclast   %xmm0, %xmm1
    movdqa       (16)(%ebx), %xmm0
    movdqa       %xmm1, (16)(%ebx)
    movdqu       (%esi), %xmm1
    add          $(16), %esi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    movl         (44)(%ebp), %eax
    pshufb       (96)(%ebx), %xmm0
    pxor         (32)(%ebx), %xmm0
    movdqa       (%eax), %xmm1
    pshufd       $(78), %xmm0, %xmm4
    pshufd       $(78), %xmm1, %xmm2
    pxor         %xmm0, %xmm4
    pxor         %xmm1, %xmm2
    pclmulqdq    $(0), %xmm2, %xmm4
    movdqa       %xmm0, %xmm3
    pclmulqdq    $(0), %xmm1, %xmm0
    pxor         %xmm2, %xmm2
    pclmulqdq    $(17), %xmm1, %xmm3
    pxor         %xmm0, %xmm4
    pxor         %xmm3, %xmm4
    palignr      $(8), %xmm4, %xmm2
    pslldq       $(8), %xmm4
    pxor         %xmm2, %xmm3
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, %xmm2
    psllq        $(1), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(5), %xmm2
    pxor         %xmm0, %xmm2
    psllq        $(57), %xmm2
    movdqa       %xmm2, %xmm4
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm2
    pxor         %xmm4, %xmm0
    pxor         %xmm2, %xmm3
    movdqa       %xmm0, %xmm4
    psrlq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm0, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm4, %xmm0
    pxor         %xmm3, %xmm0
    movdqa       %xmm0, (32)(%ebx)
    subl         $(16), (132)(%ebx)
    jg           .Lblk_loopgas_4
.Lquitgas_4: 
    movdqa       (96)(%ebx), %xmm4
    movdqa       (%ebx), %xmm0
    movdqa       (16)(%ebx), %xmm1
    movdqa       (32)(%ebx), %xmm2
    movl         (36)(%ebp), %eax
    movl         (40)(%ebp), %ecx
    movl         (32)(%ebp), %edx
    pshufb       %xmm4, %xmm0
    movdqu       %xmm0, (%eax)
    movdqu       %xmm1, (%ecx)
    pshufb       %xmm4, %xmm2
    movdqu       %xmm2, (%edx)
    add          $(152), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe4:
.size p8_AesGcmEnc_avx, .Lfe4-(p8_AesGcmEnc_avx)
.p2align 4, 0x90
 
.globl p8_AesGcmDec_avx
.type p8_AesGcmDec_avx, @function
 
p8_AesGcmDec_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(152), %esp
    lea          (16)(%esp), %ebx
    and          $(-16), %ebx
    movl         (20)(%ebp), %eax
    call         .L__0004gas_5
.L__0004gas_5:
    pop          %esi
    sub          $(.L__0004gas_5-CONST_TABLE), %esi
    movdqa       ((_u128_str-CONST_TABLE))(%esi), %xmm4
    movdqa       ((_inc1-CONST_TABLE))(%esi), %xmm5
    movl         (36)(%ebp), %eax
    movl         (40)(%ebp), %ecx
    movl         (32)(%ebp), %edx
    movdqu       (%eax), %xmm0
    movdqu       (%ecx), %xmm1
    movdqu       (%edx), %xmm2
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (%ebx)
    movdqa       %xmm1, (16)(%ebx)
    pshufb       %xmm4, %xmm2
    pxor         %xmm1, %xmm1
    movdqa       %xmm2, (32)(%ebx)
    movdqa       %xmm1, (48)(%ebx)
    movdqa       %xmm1, (64)(%ebx)
    movdqa       %xmm1, (80)(%ebx)
    movdqa       %xmm4, (96)(%ebx)
    movdqa       %xmm5, (112)(%ebx)
    movl         (28)(%ebp), %ecx
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
    movl         (16)(%ebp), %eax
    mov          $(63), %edx
    and          %eax, %edx
    and          $(-64), %eax
    movl         %eax, (128)(%ebx)
    movl         %edx, (132)(%ebx)
    jz           .Lsingle_block_procgas_5
.p2align 4, 0x90
.Lblks4_loopgas_5: 
    movdqa       (112)(%ebx), %xmm5
    movdqa       %xmm0, %xmm1
    paddd        %xmm5, %xmm1
    movdqa       %xmm1, %xmm2
    paddd        %xmm5, %xmm2
    movdqa       %xmm2, %xmm3
    paddd        %xmm5, %xmm3
    movdqa       %xmm3, %xmm4
    paddd        %xmm5, %xmm4
    movdqa       %xmm4, (%ebx)
    movdqa       (96)(%ebx), %xmm5
    movdqa       (%ecx), %xmm0
    lea          (16)(%ecx), %eax
    pshufb       %xmm5, %xmm1
    pshufb       %xmm5, %xmm2
    pshufb       %xmm5, %xmm3
    pshufb       %xmm5, %xmm4
    pxor         %xmm0, %xmm1
    pxor         %xmm0, %xmm2
    pxor         %xmm0, %xmm3
    pxor         %xmm0, %xmm4
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    movl         (24)(%ebp), %edx
    sub          $(1), %edx
.p2align 4, 0x90
.Lcipher4_loopgas_5: 
    aesenc       %xmm0, %xmm1
    aesenc       %xmm0, %xmm2
    aesenc       %xmm0, %xmm3
    aesenc       %xmm0, %xmm4
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    dec          %edx
    jnz          .Lcipher4_loopgas_5
    aesenclast   %xmm0, %xmm1
    aesenclast   %xmm0, %xmm2
    aesenclast   %xmm0, %xmm3
    aesenclast   %xmm0, %xmm4
    movdqa       (16)(%ebx), %xmm0
    movdqa       %xmm4, (16)(%ebx)
    movdqu       (%esi), %xmm4
    movdqu       (16)(%esi), %xmm5
    movdqu       (32)(%esi), %xmm6
    movdqu       (48)(%esi), %xmm7
    add          $(64), %esi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%edi)
    pshufb       (96)(%ebx), %xmm4
    pxor         (32)(%ebx), %xmm4
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%edi)
    pshufb       (96)(%ebx), %xmm5
    pxor         (48)(%ebx), %xmm5
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%edi)
    pshufb       (96)(%ebx), %xmm6
    pxor         (64)(%ebx), %xmm6
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%edi)
    pshufb       (96)(%ebx), %xmm7
    pxor         (80)(%ebx), %xmm7
    add          $(64), %edi
    movl         (44)(%ebp), %eax
    movdqa       (32)(%eax), %xmm0
    cmpl         $(64), (128)(%ebx)
    je           .Lcombine_hashgas_5
    pshufd       $(78), %xmm4, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm4, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm4, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm4
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm4, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm4
    movdqa       %xmm4, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm4, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm4, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm4
    pxor         %xmm1, %xmm2
    movdqa       %xmm4, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm4, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm4, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm4
    pxor         %xmm2, %xmm4
    pshufd       $(78), %xmm5, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm5, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm5, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm5
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm5, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm5
    movdqa       %xmm5, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm5, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm5, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm5
    pxor         %xmm1, %xmm2
    movdqa       %xmm5, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm5, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm5, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm5
    pxor         %xmm2, %xmm5
    pshufd       $(78), %xmm6, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm6, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm6, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm6
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm6, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm6
    movdqa       %xmm6, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm6, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm6, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm6
    pxor         %xmm1, %xmm2
    movdqa       %xmm6, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm6, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm6, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm6
    pxor         %xmm2, %xmm6
    pshufd       $(78), %xmm7, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm7, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm7, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm7
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm7, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm7
    movdqa       %xmm7, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm7, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm7, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm7
    pxor         %xmm1, %xmm2
    movdqa       %xmm7, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm7, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm7, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm7
    pxor         %xmm2, %xmm7
    movdqa       %xmm4, (32)(%ebx)
    movdqa       %xmm5, (48)(%ebx)
    movdqa       %xmm6, (64)(%ebx)
    movdqa       %xmm7, (80)(%ebx)
    movdqa       (%ebx), %xmm0
    subl         $(64), (128)(%ebx)
    jge          .Lblks4_loopgas_5
.Lcombine_hashgas_5: 
    pshufd       $(78), %xmm4, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm4, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm4, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm4
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm4, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm4
    movdqa       %xmm4, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm4, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm4, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm4
    pxor         %xmm1, %xmm2
    movdqa       %xmm4, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm4, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm4, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm4
    pxor         %xmm2, %xmm4
    movdqa       (16)(%eax), %xmm0
    pshufd       $(78), %xmm5, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm5, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm5, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm5
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm5, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm5
    movdqa       %xmm5, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm5, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm5, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm5
    pxor         %xmm1, %xmm2
    movdqa       %xmm5, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm5, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm5, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm5
    pxor         %xmm2, %xmm5
    movdqa       (%eax), %xmm0
    pshufd       $(78), %xmm6, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm6, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm6, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm6
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm6, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm6
    movdqa       %xmm6, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm6, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm6, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm6
    pxor         %xmm1, %xmm2
    movdqa       %xmm6, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm6, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm6, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm6
    pxor         %xmm2, %xmm6
    pxor         %xmm5, %xmm7
    pxor         %xmm6, %xmm7
    pshufd       $(78), %xmm7, %xmm3
    pshufd       $(78), %xmm0, %xmm1
    pxor         %xmm7, %xmm3
    pxor         %xmm0, %xmm1
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqa       %xmm7, %xmm2
    pclmulqdq    $(0), %xmm0, %xmm7
    pxor         %xmm1, %xmm1
    pclmulqdq    $(17), %xmm0, %xmm2
    pxor         %xmm7, %xmm3
    pxor         %xmm2, %xmm3
    palignr      $(8), %xmm3, %xmm1
    pslldq       $(8), %xmm3
    pxor         %xmm1, %xmm2
    pxor         %xmm3, %xmm7
    movdqa       %xmm7, %xmm1
    psllq        $(1), %xmm1
    pxor         %xmm7, %xmm1
    psllq        $(5), %xmm1
    pxor         %xmm7, %xmm1
    psllq        $(57), %xmm1
    movdqa       %xmm1, %xmm3
    pslldq       $(8), %xmm3
    psrldq       $(8), %xmm1
    pxor         %xmm3, %xmm7
    pxor         %xmm1, %xmm2
    movdqa       %xmm7, %xmm3
    psrlq        $(5), %xmm3
    pxor         %xmm7, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm7, %xmm3
    psrlq        $(1), %xmm3
    pxor         %xmm3, %xmm7
    pxor         %xmm2, %xmm7
    pxor         %xmm4, %xmm7
    movdqa       %xmm7, (32)(%ebx)
.Lsingle_block_procgas_5: 
    cmpl         $(0), (132)(%ebx)
    jz           .Lquitgas_5
.p2align 4, 0x90
.Lblk_loopgas_5: 
    movdqa       (%ebx), %xmm0
    movdqa       %xmm0, %xmm1
    paddd        (112)(%ebx), %xmm1
    movdqa       %xmm1, (%ebx)
    movdqa       (%ecx), %xmm0
    lea          (16)(%ecx), %eax
    pshufb       (96)(%ebx), %xmm1
    pxor         %xmm0, %xmm1
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    movl         (24)(%ebp), %edx
    sub          $(1), %edx
.p2align 4, 0x90
.Lcipher_loopgas_5: 
    aesenc       %xmm0, %xmm1
    movdqa       (%eax), %xmm0
    add          $(16), %eax
    dec          %edx
    jnz          .Lcipher_loopgas_5
    aesenclast   %xmm0, %xmm1
    movdqa       (16)(%ebx), %xmm0
    movdqa       %xmm1, (16)(%ebx)
    movdqu       (%esi), %xmm1
    add          $(16), %esi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    movl         (44)(%ebp), %eax
    pshufb       (96)(%ebx), %xmm1
    pxor         (32)(%ebx), %xmm1
    movdqa       (%eax), %xmm0
    pshufd       $(78), %xmm1, %xmm4
    pshufd       $(78), %xmm0, %xmm2
    pxor         %xmm1, %xmm4
    pxor         %xmm0, %xmm2
    pclmulqdq    $(0), %xmm2, %xmm4
    movdqa       %xmm1, %xmm3
    pclmulqdq    $(0), %xmm0, %xmm1
    pxor         %xmm2, %xmm2
    pclmulqdq    $(17), %xmm0, %xmm3
    pxor         %xmm1, %xmm4
    pxor         %xmm3, %xmm4
    palignr      $(8), %xmm4, %xmm2
    pslldq       $(8), %xmm4
    pxor         %xmm2, %xmm3
    pxor         %xmm4, %xmm1
    movdqa       %xmm1, %xmm2
    psllq        $(1), %xmm2
    pxor         %xmm1, %xmm2
    psllq        $(5), %xmm2
    pxor         %xmm1, %xmm2
    psllq        $(57), %xmm2
    movdqa       %xmm2, %xmm4
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm2
    pxor         %xmm4, %xmm1
    pxor         %xmm2, %xmm3
    movdqa       %xmm1, %xmm4
    psrlq        $(5), %xmm4
    pxor         %xmm1, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm1, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm4, %xmm1
    pxor         %xmm3, %xmm1
    movdqa       %xmm1, (32)(%ebx)
    subl         $(16), (132)(%ebx)
    jg           .Lblk_loopgas_5
.Lquitgas_5: 
    movdqa       (96)(%ebx), %xmm4
    movdqa       (%ebx), %xmm0
    movdqa       (16)(%ebx), %xmm1
    movdqa       (32)(%ebx), %xmm2
    movl         (36)(%ebp), %eax
    movl         (40)(%ebp), %ecx
    movl         (32)(%ebp), %edx
    pshufb       %xmm4, %xmm0
    movdqu       %xmm0, (%eax)
    movdqu       %xmm1, (%ecx)
    pshufb       %xmm4, %xmm2
    movdqu       %xmm2, (%edx)
    add          $(152), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe5:
.size p8_AesGcmDec_avx, .Lfe5-(p8_AesGcmDec_avx)
 
