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
CONST_TABLE: 
 
u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
.p2align 5, 0x90
 
.globl g9_EncryptCTR_RIJ128pipe_AES_NI
.type g9_EncryptCTR_RIJ128pipe_AES_NI, @function
 
g9_EncryptCTR_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (32)(%ebp), %esi
    movl         (28)(%ebp), %edi
    movdqu       (%esi), %xmm6
    movdqu       (%edi), %xmm1
    movdqu       %xmm6, %xmm5
    pandn        %xmm1, %xmm6
    sub          $(16), %esp
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %eax
    sub          $(.L__0000gas_1-CONST_TABLE), %eax
    movdqa       ((u128_str-CONST_TABLE))(%eax), %xmm4
    movl         (%edi), %edx
    movl         (4)(%edi), %ecx
    movl         (8)(%edi), %ebx
    movl         (12)(%edi), %eax
    bswap        %edx
    bswap        %ecx
    bswap        %ebx
    bswap        %eax
    movl         %eax, (%esp)
    movl         %ebx, (4)(%esp)
    movl         %ecx, (8)(%esp)
    movl         %edx, (12)(%esp)
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    subl         $(64), (24)(%ebp)
    jl           .Lshort_inputgas_1
.Lblks_loopgas_1: 
    movl         (%esp), %eax
    movl         (4)(%esp), %ebx
    movl         (8)(%esp), %ecx
    movl         (12)(%esp), %edx
    pinsrd       $(0), %eax, %xmm0
    pinsrd       $(1), %ebx, %xmm0
    pinsrd       $(2), %ecx, %xmm0
    pinsrd       $(3), %edx, %xmm0
    pshufb       %xmm4, %xmm0
    pand         %xmm5, %xmm0
    por          %xmm6, %xmm0
    add          $(1), %eax
    adc          $(0), %ebx
    adc          $(0), %ecx
    adc          $(0), %edx
    pinsrd       $(0), %eax, %xmm1
    pinsrd       $(1), %ebx, %xmm1
    pinsrd       $(2), %ecx, %xmm1
    pinsrd       $(3), %edx, %xmm1
    pshufb       %xmm4, %xmm1
    pand         %xmm5, %xmm1
    por          %xmm6, %xmm1
    add          $(1), %eax
    adc          $(0), %ebx
    adc          $(0), %ecx
    adc          $(0), %edx
    pinsrd       $(0), %eax, %xmm2
    pinsrd       $(1), %ebx, %xmm2
    pinsrd       $(2), %ecx, %xmm2
    pinsrd       $(3), %edx, %xmm2
    pshufb       %xmm4, %xmm2
    pand         %xmm5, %xmm2
    por          %xmm6, %xmm2
    add          $(1), %eax
    adc          $(0), %ebx
    adc          $(0), %ecx
    adc          $(0), %edx
    pinsrd       $(0), %eax, %xmm3
    pinsrd       $(1), %ebx, %xmm3
    pinsrd       $(2), %ecx, %xmm3
    pinsrd       $(3), %edx, %xmm3
    pshufb       %xmm4, %xmm3
    pand         %xmm5, %xmm3
    por          %xmm6, %xmm3
    add          $(1), %eax
    adc          $(0), %ebx
    adc          $(0), %ecx
    adc          $(0), %edx
    movl         %eax, (%esp)
    movl         %ebx, (4)(%esp)
    movl         %ecx, (8)(%esp)
    movl         %edx, (12)(%esp)
    movl         (20)(%ebp), %ecx
    movdqa       (%ecx), %xmm7
    lea          (16)(%ecx), %ebx
    pxor         %xmm7, %xmm0
    pxor         %xmm7, %xmm1
    pxor         %xmm7, %xmm2
    pxor         %xmm7, %xmm3
    movdqa       (%ebx), %xmm7
    add          $(16), %ebx
    movl         (16)(%ebp), %eax
    sub          $(1), %eax
.Lcipher_loopgas_1: 
    aesenc       %xmm7, %xmm0
    aesenc       %xmm7, %xmm1
    aesenc       %xmm7, %xmm2
    aesenc       %xmm7, %xmm3
    movdqa       (%ebx), %xmm7
    add          $(16), %ebx
    dec          %eax
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm7, %xmm0
    aesenclast   %xmm7, %xmm1
    aesenclast   %xmm7, %xmm2
    aesenclast   %xmm7, %xmm3
    movdqu       (%esi), %xmm7
    pxor         %xmm7, %xmm0
    movdqu       %xmm0, (%edi)
    movdqu       (16)(%esi), %xmm7
    pxor         %xmm7, %xmm1
    movdqu       %xmm1, (16)(%edi)
    movdqu       (32)(%esi), %xmm7
    pxor         %xmm7, %xmm2
    movdqu       %xmm2, (32)(%edi)
    movdqu       (48)(%esi), %xmm7
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%edi)
    add          $(64), %esi
    add          $(64), %edi
    subl         $(64), (24)(%ebp)
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    addl         $(64), (24)(%ebp)
    jz           .Lquitgas_1
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %eax
    lea          (,%eax,4), %ebx
    lea          (-144)(%ecx,%ebx,4), %ebx
.Lsingle_blk_loopgas_1: 
    movdqu       (%esp), %xmm0
    pshufb       %xmm4, %xmm0
    pand         %xmm5, %xmm0
    por          %xmm6, %xmm0
    pxor         (%ecx), %xmm0
    cmp          $(12), %eax
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%ebx), %xmm0
    aesenc       (-48)(%ebx), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%ebx), %xmm0
    aesenc       (-16)(%ebx), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%ebx), %xmm0
    aesenc       (16)(%ebx), %xmm0
    aesenc       (32)(%ebx), %xmm0
    aesenc       (48)(%ebx), %xmm0
    aesenc       (64)(%ebx), %xmm0
    aesenc       (80)(%ebx), %xmm0
    aesenc       (96)(%ebx), %xmm0
    aesenc       (112)(%ebx), %xmm0
    aesenc       (128)(%ebx), %xmm0
    aesenclast   (144)(%ebx), %xmm0
    addl         $(1), (%esp)
    adcl         $(0), (4)(%esp)
    adcl         $(0), (8)(%esp)
    adcl         $(0), (12)(%esp)
    subl         $(16), (24)(%ebp)
    jl           .Lpartial_blockgas_1
    movdqu       (%esi), %xmm1
    add          $(16), %esi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    cmpl         $(0), (24)(%ebp)
    jz           .Lquitgas_1
    jmp          .Lsingle_blk_loopgas_1
.Lpartial_blockgas_1: 
    addl         $(16), (24)(%ebp)
.Lpartial_block_loopgas_1: 
    pextrb       $(0), %xmm0, %eax
    psrldq       $(1), %xmm0
    movzbl       (%esi), %ebx
    xor          %ebx, %eax
    movb         %al, (%edi)
    inc          %esi
    inc          %edi
    decl         (24)(%ebp)
    jnz          .Lpartial_block_loopgas_1
.Lquitgas_1: 
    movl         (28)(%ebp), %eax
    movdqu       (%esp), %xmm0
    pshufb       %xmm4, %xmm0
    pand         %xmm5, %xmm0
    por          %xmm6, %xmm0
    movdqu       %xmm0, (%eax)
    add          $(16), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size g9_EncryptCTR_RIJ128pipe_AES_NI, .Lfe1-(g9_EncryptCTR_RIJ128pipe_AES_NI)
 
