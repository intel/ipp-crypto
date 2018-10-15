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
_CONST_DATA: 
 
_INIT_IDX:
.word    0x0,  0x1,  0x2,  0x3,  0x4,  0x5,  0x6,  0x7 
 
_INCR_IDX:
.word    0x8,  0x8,  0x8,  0x8,  0x8,  0x8,  0x8,  0x8 
.p2align 4, 0x90
 
.globl p8_getAesGcmConst_table_ct
.type p8_getAesGcmConst_table_ct, @function
 
p8_getAesGcmConst_table_ct:
    push         %ebx
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %ebx
    sub          $(.L__0000gas_1-_CONST_DATA), %ebx
    pxor         %xmm2, %xmm2
    mov          %ecx, %eax
    shl          $(16), %ecx
    or           %eax, %ecx
    movd         %ecx, %xmm3
    pshufd       $(0), %xmm3, %xmm3
    movdqa       ((_INIT_IDX-_CONST_DATA))(%ebx), %xmm6
    xor          %eax, %eax
.p2align 4, 0x90
.Lsearch_loopgas_1: 
    movdqa       %xmm6, %xmm7
    paddw        ((_INCR_IDX-_CONST_DATA))(%ebx), %xmm6
    pcmpeqw      %xmm3, %xmm7
    pand         (%edx,%eax,2), %xmm7
    add          $(8), %eax
    cmp          $(256), %eax
    por          %xmm7, %xmm2
    jl           .Lsearch_loopgas_1
    movdqa       %xmm2, %xmm3
    psrldq       $(8), %xmm2
    por          %xmm3, %xmm2
    movdqa       %xmm2, %xmm3
    psrldq       $(4), %xmm2
    por          %xmm3, %xmm2
    movd         %xmm2, %eax
    pop          %ebx
    and          $(3), %ecx
    shl          $(4), %ecx
    shr          %cl, %eax
    ret
.Lfe1:
.size p8_getAesGcmConst_table_ct, .Lfe1-(p8_getAesGcmConst_table_ct)
.p2align 4, 0x90
 
.globl p8_AesGcmMulGcm_table2K
.type p8_AesGcmMulGcm_table2K, @function
 
p8_AesGcmMulGcm_table2K:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %edi
    movdqu       (%edi), %xmm0
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %edx
    movd         %xmm0, %ebx
    mov          $(4042322160), %eax
    and          %ebx, %eax
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1280)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1280)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1280)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1280)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (256)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (256)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (256)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (256)(%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1536)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1536)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1536)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1536)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (512)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (512)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (512)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (512)(%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1792)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1792)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1792)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1792)(%esi,%ecx), %xmm2
    movzbl       %bh, %ecx
    pxor         (768)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (768)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (768)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (768)(%esi,%ecx), %xmm2
    movdqa       %xmm3, %xmm0
    pslldq       $(1), %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm2, %xmm1
    pslldq       $(1), %xmm2
    pxor         %xmm2, %xmm5
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    call         p8_getAesGcmConst_table_ct
    shl          $(8), %eax
    movdqa       %xmm5, %xmm0
    pslldq       $(1), %xmm5
    pxor         %xmm5, %xmm4
    psrldq       $(15), %xmm1
    movd         %xmm1, %ecx
    mov          %eax, %ebx
    call         p8_getAesGcmConst_table_ct
    xor          %ebx, %eax
    shl          $(8), %eax
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    mov          %eax, %ebx
    call         p8_getAesGcmConst_table_ct
    xor          %ebx, %eax
    movd         %eax, %xmm0
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%edi)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe2:
.size p8_AesGcmMulGcm_table2K, .Lfe2-(p8_AesGcmMulGcm_table2K)
.p2align 4, 0x90
 
.globl p8_AesGcmAuth_table2K
.type p8_AesGcmAuth_table2K, @function
 
p8_AesGcmAuth_table2K:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %edi
    movdqu       (%edi), %xmm0
    movl         (20)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (24)(%ebp), %edx
.p2align 4, 0x90
.Lauth_loopgas_3: 
    movdqu       (%edi), %xmm4
    pxor         %xmm4, %xmm0
    movd         %xmm0, %ebx
    mov          $(4042322160), %eax
    and          %ebx, %eax
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    movdqa       (1024)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1280)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1280)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1280)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1280)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (256)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (256)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (256)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (256)(%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1536)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1536)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1536)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1536)(%esi,%ecx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (512)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (512)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (512)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (512)(%esi,%ecx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1792)(%esi,%ecx), %xmm5
    movzbl       %al, %ecx
    pxor         (1792)(%esi,%ecx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1792)(%esi,%ecx), %xmm3
    movzbl       %al, %ecx
    pxor         (1792)(%esi,%ecx), %xmm2
    movzbl       %bh, %ecx
    pxor         (768)(%esi,%ecx), %xmm5
    movzbl       %bl, %ecx
    pxor         (768)(%esi,%ecx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (768)(%esi,%ecx), %xmm3
    movzbl       %bl, %ecx
    pxor         (768)(%esi,%ecx), %xmm2
    movdqa       %xmm3, %xmm0
    pslldq       $(1), %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm2, %xmm1
    pslldq       $(1), %xmm2
    pxor         %xmm2, %xmm5
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    call         p8_getAesGcmConst_table_ct
    shl          $(8), %eax
    movdqa       %xmm5, %xmm0
    pslldq       $(1), %xmm5
    pxor         %xmm5, %xmm4
    psrldq       $(15), %xmm1
    movd         %xmm1, %ecx
    mov          %eax, %ebx
    call         p8_getAesGcmConst_table_ct
    xor          %ebx, %eax
    shl          $(8), %eax
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    mov          %eax, %ebx
    call         p8_getAesGcmConst_table_ct
    xor          %ebx, %eax
    movd         %eax, %xmm0
    pxor         %xmm4, %xmm0
    add          $(16), %edi
    subl         $(16), (16)(%ebp)
    jnz          .Lauth_loopgas_3
    movl         (8)(%ebp), %edi
    movdqu       %xmm0, (%edi)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe3:
.size p8_AesGcmAuth_table2K, .Lfe3-(p8_AesGcmAuth_table2K)
 
