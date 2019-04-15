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
.p2align 5, 0x90
 
INIT_IDX:
.word    0x0,  0x1,  0x2,  0x3,  0x4,  0x5,  0x6,  0x7 
 
INCR_IDX:
.word    0x8,  0x8,  0x8,  0x8,  0x8,  0x8,  0x8,  0x8 
.p2align 5, 0x90
getAesGcmConst_table_ct: 
    pxor         %xmm2, %xmm2
    mov          %rcx, %rax
    shl          $(16), %rcx
    or           %rax, %rcx
    movd         %rcx, %xmm3
    pshufd       $(0), %xmm3, %xmm3
    movdqa       INIT_IDX(%rip), %xmm6
    xor          %rax, %rax
.p2align 5, 0x90
search_loop: 
    movdqa       %xmm6, %xmm7
    paddw        INCR_IDX(%rip), %xmm6
    pcmpeqw      %xmm3, %xmm7
    pand         (%r9,%rax,2), %xmm7
    add          $(8), %rax
    cmp          $(256), %rax
    por          %xmm7, %xmm2
    jl           search_loop
    movdqa       %xmm2, %xmm3
    psrldq       $(8), %xmm2
    por          %xmm3, %xmm2
    movd         %xmm2, %rax
    and          $(3), %rcx
    shl          $(4), %rcx
    shr          %cl, %rax
    ret
.p2align 5, 0x90
 
.globl AesGcmMulGcm_table2K
.type AesGcmMulGcm_table2K, @function
 
AesGcmMulGcm_table2K:
 
    push         %rbx
 
    movdqu       (%rdi), %xmm0
    mov          %rsi, %r8
    mov          %rdx, %r9
    movd         %xmm0, %ebx
    mov          $(4042322160), %eax
    and          %ebx, %eax
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1280)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1280)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1280)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1280)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (256)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (256)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (256)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (256)(%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1536)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1536)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1536)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1536)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (512)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (512)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (512)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (512)(%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1792)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1792)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1792)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1792)(%r8,%rcx), %xmm2
    movzbl       %bh, %ecx
    pxor         (768)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (768)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (768)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (768)(%r8,%rcx), %xmm2
    movdqa       %xmm3, %xmm0
    pslldq       $(1), %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm2, %xmm1
    pslldq       $(1), %xmm2
    pxor         %xmm2, %xmm5
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    call         getAesGcmConst_table_ct
    shl          $(8), %eax
    movdqa       %xmm5, %xmm0
    pslldq       $(1), %xmm5
    pxor         %xmm5, %xmm4
    psrldq       $(15), %xmm1
    movd         %xmm1, %ecx
    mov          %rax, %rbx
    call         getAesGcmConst_table_ct
    xor          %rbx, %rax
    shl          $(8), %eax
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    mov          %rax, %rbx
    call         getAesGcmConst_table_ct
    xor          %rbx, %rax
    movd         %eax, %xmm0
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%rdi)
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe1:
.size AesGcmMulGcm_table2K, .Lfe1-(AesGcmMulGcm_table2K)
.p2align 5, 0x90
 
.globl AesGcmAuth_table2K
.type AesGcmAuth_table2K, @function
 
AesGcmAuth_table2K:
 
    push         %rbx
 
    mov          %r8, %r9
    movdqu       (%rdi), %xmm0
    mov          %rcx, %r8
.p2align 5, 0x90
.Lauth_loopgas_2: 
    movdqu       (%rsi), %xmm4
    pxor         %xmm4, %xmm0
    movd         %xmm0, %ebx
    mov          $(4042322160), %eax
    and          %ebx, %eax
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    movdqa       (1024)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1280)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1280)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1280)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1280)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (256)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (256)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (256)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (256)(%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1536)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1536)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1536)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1536)(%r8,%rcx), %xmm2
    psrldq       $(4), %xmm0
    movd         %xmm0, %eax
    and          $(4042322160), %eax
    movzbl       %bh, %ecx
    pxor         (512)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (512)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (512)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (512)(%r8,%rcx), %xmm2
    movd         %xmm0, %ebx
    shl          $(4), %ebx
    and          $(4042322160), %ebx
    movzbl       %ah, %ecx
    pxor         (1792)(%r8,%rcx), %xmm5
    movzbl       %al, %ecx
    pxor         (1792)(%r8,%rcx), %xmm4
    shr          $(16), %eax
    movzbl       %ah, %ecx
    pxor         (1792)(%r8,%rcx), %xmm3
    movzbl       %al, %ecx
    pxor         (1792)(%r8,%rcx), %xmm2
    movzbl       %bh, %ecx
    pxor         (768)(%r8,%rcx), %xmm5
    movzbl       %bl, %ecx
    pxor         (768)(%r8,%rcx), %xmm4
    shr          $(16), %ebx
    movzbl       %bh, %ecx
    pxor         (768)(%r8,%rcx), %xmm3
    movzbl       %bl, %ecx
    pxor         (768)(%r8,%rcx), %xmm2
    movdqa       %xmm3, %xmm0
    pslldq       $(1), %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm2, %xmm1
    pslldq       $(1), %xmm2
    pxor         %xmm2, %xmm5
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    call         getAesGcmConst_table_ct
    shl          $(8), %eax
    movdqa       %xmm5, %xmm0
    pslldq       $(1), %xmm5
    pxor         %xmm5, %xmm4
    psrldq       $(15), %xmm1
    movd         %xmm1, %ecx
    mov          %rax, %rbx
    call         getAesGcmConst_table_ct
    xor          %rbx, %rax
    shl          $(8), %eax
    psrldq       $(15), %xmm0
    movd         %xmm0, %ecx
    mov          %rax, %rbx
    call         getAesGcmConst_table_ct
    xor          %rbx, %rax
    movd         %eax, %xmm0
    pxor         %xmm4, %xmm0
    add          $(16), %rsi
    sub          $(16), %rdx
    jnz          .Lauth_loopgas_2
    movdqu       %xmm0, (%rdi)
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe2:
.size AesGcmAuth_table2K, .Lfe2-(AesGcmAuth_table2K)
 
