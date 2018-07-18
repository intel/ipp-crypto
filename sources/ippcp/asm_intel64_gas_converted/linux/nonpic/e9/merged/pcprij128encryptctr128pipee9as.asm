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
 
.globl e9_EncryptStreamCTR32_AES_NI
.type e9_EncryptStreamCTR32_AES_NI, @function
 
e9_EncryptStreamCTR32_AES_NI:
 
    push         %rbx
 
    sub          $(128), %rsp
 
    movdqu       (%r9), %xmm0
    movslq       %r8d, %r8
    lea          (15)(%r8), %r11
    shr          $(4), %r11
    movq         (8)(%r9), %rax
    movq         (%r9), %rbx
    bswap        %rax
    bswap        %rbx
    mov          %eax, %r10d
    add          %r11, %rax
    adc          $(0), %rbx
    bswap        %rax
    bswap        %rbx
    movq         %rax, (8)(%r9)
    movq         %rbx, (%r9)
    movl         (12)(%rcx), %r11d
    pxor         (%rcx), %xmm0
    add          $(16), %rcx
    movdqa       %xmm0, (%rsp)
    movdqa       %xmm0, (16)(%rsp)
    movdqa       %xmm0, (32)(%rsp)
    movdqa       %xmm0, (48)(%rsp)
    movdqa       %xmm0, (64)(%rsp)
    movdqa       %xmm0, (80)(%rsp)
    movdqa       %xmm0, (96)(%rsp)
    movdqa       %xmm0, (112)(%rsp)
    mov          %rsp, %r9
    cmp          $(16), %r8
    jle          .Lshort123_inputgas_1
    movdqa       %xmm0, %xmm1
    movdqa       %xmm0, %xmm2
    movdqa       %xmm0, %xmm3
    lea          (1)(%r10d), %ebx
    lea          (2)(%r10d), %eax
    lea          (3)(%r10d), %r9d
    bswap        %ebx
    bswap        %eax
    bswap        %r9d
    xor          %r11d, %ebx
    pinsrd       $(3), %ebx, %xmm1
    xor          %r11d, %eax
    pinsrd       $(3), %eax, %xmm2
    xor          %r11d, %r9d
    pinsrd       $(3), %r9d, %xmm3
    movdqa       %xmm1, (16)(%rsp)
    movdqa       %xmm2, (32)(%rsp)
    movdqa       %xmm3, (48)(%rsp)
    mov          %rsp, %r9
    movdqa       (%rcx), %xmm4
    movdqa       (16)(%rcx), %xmm5
    cmp          $(64), %r8
    jl           .Lshort123_inputgas_1
    jz           .Lshort_inputgas_1
    lea          (4)(%r10d), %eax
    lea          (5)(%r10d), %ebx
    bswap        %eax
    bswap        %ebx
    xor          %r11d, %ebx
    xor          %r11d, %eax
    movl         %eax, (76)(%rsp)
    movl         %ebx, (92)(%rsp)
    lea          (6)(%r10d), %eax
    lea          (7)(%r10d), %ebx
    bswap        %eax
    bswap        %ebx
    xor          %r11d, %eax
    xor          %r11d, %ebx
    movl         %eax, (108)(%rsp)
    movl         %ebx, (124)(%rsp)
    cmp          $(128), %r8
    jl           .Lshort_inputgas_1
    sub          $(64), %rsp
    movdqa       %xmm10, (%rsp)
    movdqa       %xmm11, (16)(%rsp)
    movdqa       %xmm12, (32)(%rsp)
    movdqa       %xmm13, (48)(%rsp)
    push         %rcx
    push         %rdx
    sub          $(128), %r8
.p2align 5, 0x90
.Lblk8_loopgas_1: 
    add          $(32), %rcx
    add          $(8), %r10d
    sub          $(4), %rdx
    movdqa       (64)(%r9), %xmm6
    movdqa       (80)(%r9), %xmm7
    movdqa       (96)(%r9), %xmm8
    movdqa       (112)(%r9), %xmm9
    mov          %r10d, %eax
    aesenc       %xmm4, %xmm0
    lea          (1)(%r10d), %ebx
    aesenc       %xmm4, %xmm1
    bswap        %eax
    aesenc       %xmm4, %xmm2
    bswap        %ebx
    aesenc       %xmm4, %xmm3
    xor          %r11d, %eax
    aesenc       %xmm4, %xmm6
    xor          %r11d, %ebx
    aesenc       %xmm4, %xmm7
    movl         %eax, (12)(%r9)
    aesenc       %xmm4, %xmm8
    movl         %ebx, (28)(%r9)
    aesenc       %xmm4, %xmm9
    movdqa       (%rcx), %xmm4
    lea          (2)(%r10d), %eax
    aesenc       %xmm5, %xmm0
    lea          (3)(%r10d), %ebx
    aesenc       %xmm5, %xmm1
    bswap        %eax
    aesenc       %xmm5, %xmm2
    bswap        %ebx
    aesenc       %xmm5, %xmm3
    xor          %r11d, %eax
    aesenc       %xmm5, %xmm6
    xor          %r11d, %ebx
    aesenc       %xmm5, %xmm7
    movl         %eax, (44)(%r9)
    aesenc       %xmm5, %xmm8
    movl         %ebx, (60)(%r9)
    aesenc       %xmm5, %xmm9
    movdqa       (16)(%rcx), %xmm5
.p2align 5, 0x90
.Lcipher_loopgas_1: 
    add          $(32), %rcx
    sub          $(2), %rdx
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    aesenc       %xmm4, %xmm6
    aesenc       %xmm4, %xmm7
    aesenc       %xmm4, %xmm8
    aesenc       %xmm4, %xmm9
    movdqa       (%rcx), %xmm4
    aesenc       %xmm5, %xmm0
    aesenc       %xmm5, %xmm1
    aesenc       %xmm5, %xmm2
    aesenc       %xmm5, %xmm3
    aesenc       %xmm5, %xmm6
    aesenc       %xmm5, %xmm7
    aesenc       %xmm5, %xmm8
    aesenc       %xmm5, %xmm9
    movdqa       (16)(%rcx), %xmm5
    jnz          .Lcipher_loopgas_1
    lea          (4)(%r10d), %eax
    aesenc       %xmm4, %xmm0
    lea          (5)(%r10d), %ebx
    aesenc       %xmm4, %xmm1
    bswap        %eax
    aesenc       %xmm4, %xmm2
    bswap        %ebx
    aesenc       %xmm4, %xmm3
    xor          %r11d, %eax
    aesenc       %xmm4, %xmm6
    xor          %r11d, %ebx
    aesenc       %xmm4, %xmm7
    movl         %eax, (76)(%r9)
    aesenc       %xmm4, %xmm8
    movl         %ebx, (92)(%r9)
    aesenc       %xmm4, %xmm9
    lea          (6)(%r10d), %eax
    aesenclast   %xmm5, %xmm0
    lea          (7)(%r10d), %ebx
    aesenclast   %xmm5, %xmm1
    bswap        %eax
    aesenclast   %xmm5, %xmm2
    bswap        %ebx
    aesenclast   %xmm5, %xmm3
    xor          %r11d, %eax
    aesenclast   %xmm5, %xmm6
    xor          %r11d, %ebx
    aesenclast   %xmm5, %xmm7
    movl         %eax, (108)(%r9)
    aesenclast   %xmm5, %xmm8
    movl         %ebx, (124)(%r9)
    aesenclast   %xmm5, %xmm9
    movdqu       (%rdi), %xmm10
    movdqu       (16)(%rdi), %xmm11
    movdqu       (32)(%rdi), %xmm12
    movdqu       (48)(%rdi), %xmm13
    pxor         %xmm10, %xmm0
    pxor         %xmm11, %xmm1
    pxor         %xmm12, %xmm2
    pxor         %xmm13, %xmm3
    movdqu       %xmm0, (%rsi)
    movdqu       %xmm1, (16)(%rsi)
    movdqu       %xmm2, (32)(%rsi)
    movdqu       %xmm3, (48)(%rsi)
    movdqu       (64)(%rdi), %xmm10
    movdqu       (80)(%rdi), %xmm11
    movdqu       (96)(%rdi), %xmm12
    movdqu       (112)(%rdi), %xmm13
    pxor         %xmm10, %xmm6
    pxor         %xmm11, %xmm7
    pxor         %xmm12, %xmm8
    pxor         %xmm13, %xmm9
    movdqu       %xmm6, (64)(%rsi)
    movdqu       %xmm7, (80)(%rsi)
    movdqu       %xmm8, (96)(%rsi)
    movdqu       %xmm9, (112)(%rsi)
    movq         (8)(%rsp), %rcx
    movq         (%rsp), %rdx
    movdqa       (%r9), %xmm0
    movdqa       (16)(%r9), %xmm1
    movdqa       (32)(%r9), %xmm2
    movdqa       (48)(%r9), %xmm3
    movdqa       (%rcx), %xmm4
    movdqa       (16)(%rcx), %xmm5
    add          $(128), %rdi
    add          $(128), %rsi
    sub          $(128), %r8
    jge          .Lblk8_loopgas_1
    pop          %rdx
    pop          %rcx
    movdqa       (%rsp), %xmm10
    movdqa       (16)(%rsp), %xmm11
    movdqa       (32)(%rsp), %xmm12
    movdqa       (48)(%rsp), %xmm13
    add          $(64), %rsp
    add          $(128), %r8
    jz           .Lquitgas_1
.p2align 5, 0x90
.Lshort_inputgas_1: 
    cmp          $(64), %r8
    jl           .Lshort123_inputgas_1
    mov          %rcx, %rbx
    lea          (-2)(%rdx), %r10
.p2align 5, 0x90
.Lcipher_loop4gas_1: 
    add          $(32), %rbx
    sub          $(2), %r10
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    movdqa       (%rbx), %xmm4
    aesenc       %xmm5, %xmm0
    aesenc       %xmm5, %xmm1
    aesenc       %xmm5, %xmm2
    aesenc       %xmm5, %xmm3
    movdqa       (16)(%rbx), %xmm5
    jnz          .Lcipher_loop4gas_1
    movdqu       (%rdi), %xmm6
    movdqu       (16)(%rdi), %xmm7
    movdqu       (32)(%rdi), %xmm8
    movdqu       (48)(%rdi), %xmm9
    add          $(64), %rdi
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    aesenclast   %xmm5, %xmm0
    aesenclast   %xmm5, %xmm1
    aesenclast   %xmm5, %xmm2
    aesenclast   %xmm5, %xmm3
    pxor         %xmm6, %xmm0
    movdqu       %xmm0, (%rsi)
    pxor         %xmm7, %xmm1
    movdqu       %xmm1, (16)(%rsi)
    pxor         %xmm8, %xmm2
    movdqu       %xmm2, (32)(%rsi)
    pxor         %xmm9, %xmm3
    movdqu       %xmm3, (48)(%rsi)
    add          $(64), %rsi
    add          $(64), %r9
    sub          $(64), %r8
    jz           .Lquitgas_1
.Lshort123_inputgas_1: 
    lea          (,%rdx,4), %rbx
    lea          (-160)(%rcx,%rbx,4), %rbx
.Lsingle_blkgas_1: 
    movdqa       (%r9), %xmm0
    add          $(16), %r9
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%rbx), %xmm0
    aesenc       (-48)(%rbx), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%rbx), %xmm0
    aesenc       (-16)(%rbx), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%rbx), %xmm0
    aesenc       (16)(%rbx), %xmm0
    aesenc       (32)(%rbx), %xmm0
    aesenc       (48)(%rbx), %xmm0
    aesenc       (64)(%rbx), %xmm0
    aesenc       (80)(%rbx), %xmm0
    aesenc       (96)(%rbx), %xmm0
    aesenc       (112)(%rbx), %xmm0
    aesenc       (128)(%rbx), %xmm0
    aesenclast   (144)(%rbx), %xmm0
    cmp          $(16), %r8
    jl           .Lpartial_blockgas_1
    movdqu       (%rdi), %xmm1
    add          $(16), %rdi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%rsi)
    add          $(16), %rsi
    sub          $(16), %r8
    jz           .Lquitgas_1
    jmp          .Lsingle_blkgas_1
.Lpartial_blockgas_1: 
    pextrb       $(0), %xmm0, %eax
    psrldq       $(1), %xmm0
    movzbl       (%rdi), %edx
    inc          %rdi
    xor          %rdx, %rax
    movb         %al, (%rsi)
    inc          %rsi
    dec          %r8
    jnz          .Lpartial_blockgas_1
.Lquitgas_1: 
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    add          $(128), %rsp
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe1:
.size e9_EncryptStreamCTR32_AES_NI, .Lfe1-(e9_EncryptStreamCTR32_AES_NI)
 
