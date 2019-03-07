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

 
.text
.p2align 5, 0x90
 
.globl _e9_DecryptCFB_RIJ128pipe_AES_NI

 
_e9_DecryptCFB_RIJ128pipe_AES_NI:
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(144), %rsp
 
    mov          (176)(%rsp), %rax
    movdqu       (%rax), %xmm4
    movdqa       %xmm4, (%rsp)
    mov          %rdi, %r13
    mov          %rsi, %r14
    mov          %rcx, %r15
    movslq       %r8d, %r8
    movslq       %r9d, %r9
    sub          $(4), %r8
    jl           .Lshort_inputgas_1
    lea          (,%r9,4), %r10
.Lblks_loopgas_1: 
    xor          %rcx, %rcx
.L__000Agas_1: 
    movl         (%r13,%rcx), %r11d
    movl         %r11d, (16)(%rsp,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__000Agas_1
    movdqa       (%r15), %xmm4
    lea          (%r9,%r9,2), %r10
    movdqa       (%rsp), %xmm0
    movdqu       (%rsp,%r9), %xmm1
    movdqu       (%rsp,%r9,2), %xmm2
    movdqu       (%rsp,%r10), %xmm3
    mov          %r15, %r10
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (16)(%r10), %xmm4
    add          $(16), %r10
    mov          %rdx, %r11
    sub          $(1), %r11
.Lcipher_loopgas_1: 
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    movdqa       (16)(%r10), %xmm4
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm4, %xmm0
    aesenclast   %xmm4, %xmm1
    aesenclast   %xmm4, %xmm2
    aesenclast   %xmm4, %xmm3
    lea          (%r9,%r9,2), %r10
    movdqa       (16)(%rsp), %xmm4
    movdqu       (16)(%rsp,%r9), %xmm5
    movdqu       (16)(%rsp,%r9,2), %xmm6
    movdqu       (16)(%rsp,%r10), %xmm7
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, (80)(%rsp)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (80)(%rsp,%r9)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (80)(%rsp,%r9,2)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (80)(%rsp,%r10)
    lea          (,%r9,4), %r10
    xor          %rcx, %rcx
.L__000Bgas_1: 
    movl         (80)(%rsp,%rcx), %r11d
    movl         %r11d, (%r14,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__000Bgas_1
    movdqu       (%rsp,%r10), %xmm0
    movdqu       %xmm0, (%rsp)
    add          %r10, %r13
    add          %r10, %r14
    sub          $(4), %r8
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    add          $(4), %r8
    jz           .Lquitgas_1
    lea          (,%r9,2), %r10
    lea          (%r9,%r9,2), %r11
    cmp          $(2), %r8
    cmovl        %r9, %r10
    cmovg        %r11, %r10
    xor          %rcx, %rcx
.L__000Cgas_1: 
    movb         (%r13,%rcx), %al
    movb         %al, (16)(%rsp,%rcx)
    add          $(1), %rcx
    cmp          %r10, %rcx
    jl           .L__000Cgas_1
    lea          (,%rdx,4), %rax
    lea          (-144)(%r15,%rax,4), %rax
    xor          %r11, %r11
.Lsingle_blk_loopgas_1: 
    movdqu       (%rsp,%r11), %xmm0
    pxor         (%r15), %xmm0
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%rax), %xmm0
    aesenc       (-48)(%rax), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%rax), %xmm0
    aesenc       (-16)(%rax), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%rax), %xmm0
    aesenc       (16)(%rax), %xmm0
    aesenc       (32)(%rax), %xmm0
    aesenc       (48)(%rax), %xmm0
    aesenc       (64)(%rax), %xmm0
    aesenc       (80)(%rax), %xmm0
    aesenc       (96)(%rax), %xmm0
    aesenc       (112)(%rax), %xmm0
    aesenc       (128)(%rax), %xmm0
    aesenclast   (144)(%rax), %xmm0
    movdqu       (16)(%rsp,%r11), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (80)(%rsp,%r11)
    add          %r9, %r11
    dec          %r8
    jnz          .Lsingle_blk_loopgas_1
    xor          %rcx, %rcx
.L__000Dgas_1: 
    movb         (80)(%rsp,%rcx), %al
    movb         %al, (%r14,%rcx)
    add          $(1), %rcx
    cmp          %r10, %rcx
    jl           .L__000Dgas_1
.Lquitgas_1: 
    add          $(144), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    ret
 
.p2align 5, 0x90
 
.globl _e9_DecryptCFB32_RIJ128pipe_AES_NI

 
_e9_DecryptCFB32_RIJ128pipe_AES_NI:
 
    push         %r13
 
    push         %r14
 
    push         %r15
 
    sub          $(144), %rsp
 
    mov          (176)(%rsp), %rax
    movdqu       (%rax), %xmm4
    movdqa       %xmm4, (%rsp)
    mov          %rdi, %r13
    mov          %rsi, %r14
    mov          %rcx, %r15
    movslq       %r8d, %r8
    movslq       %r9d, %r9
    sub          $(4), %r8
    jl           .Lshort_inputgas_2
    lea          (,%r9,4), %r10
.Lblks_loopgas_2: 
    xor          %rcx, %rcx
.L__0020gas_2: 
    movdqu       (%r13,%rcx), %xmm0
    movdqu       %xmm0, (16)(%rsp,%rcx)
    add          $(16), %rcx
    cmp          %r10, %rcx
    jl           .L__0020gas_2
    movdqa       (%r15), %xmm4
    lea          (%r9,%r9,2), %r10
    movdqa       (%rsp), %xmm0
    movdqu       (%rsp,%r9), %xmm1
    movdqu       (%rsp,%r9,2), %xmm2
    movdqu       (%rsp,%r10), %xmm3
    mov          %r15, %r10
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (16)(%r10), %xmm4
    add          $(16), %r10
    mov          %rdx, %r11
    sub          $(1), %r11
.Lcipher_loopgas_2: 
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    movdqa       (16)(%r10), %xmm4
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher_loopgas_2
    aesenclast   %xmm4, %xmm0
    aesenclast   %xmm4, %xmm1
    aesenclast   %xmm4, %xmm2
    aesenclast   %xmm4, %xmm3
    lea          (%r9,%r9,2), %r10
    movdqa       (16)(%rsp), %xmm4
    movdqu       (16)(%rsp,%r9), %xmm5
    movdqu       (16)(%rsp,%r9,2), %xmm6
    movdqu       (16)(%rsp,%r10), %xmm7
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, (80)(%rsp)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (80)(%rsp,%r9)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (80)(%rsp,%r9,2)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (80)(%rsp,%r10)
    lea          (,%r9,4), %r10
    xor          %rcx, %rcx
.L__0021gas_2: 
    movdqu       (80)(%rsp,%rcx), %xmm0
    movdqu       %xmm0, (%r14,%rcx)
    add          $(16), %rcx
    cmp          %r10, %rcx
    jl           .L__0021gas_2
    movdqu       (%rsp,%r10), %xmm0
    movdqu       %xmm0, (%rsp)
    add          %r10, %r13
    add          %r10, %r14
    sub          $(4), %r8
    jge          .Lblks_loopgas_2
.Lshort_inputgas_2: 
    add          $(4), %r8
    jz           .Lquitgas_2
    lea          (,%r9,2), %r10
    lea          (%r9,%r9,2), %r11
    cmp          $(2), %r8
    cmovl        %r9, %r10
    cmovg        %r11, %r10
    xor          %rcx, %rcx
.L__0022gas_2: 
    movl         (%r13,%rcx), %eax
    movl         %eax, (16)(%rsp,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__0022gas_2
    lea          (,%rdx,4), %rax
    lea          (-144)(%r15,%rax,4), %rax
    xor          %r11, %r11
.Lsingle_blk_loopgas_2: 
    movdqu       (%rsp,%r11), %xmm0
    pxor         (%r15), %xmm0
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_2
    jz           .Lkey_192_sgas_2
.Lkey_256_sgas_2: 
    aesenc       (-64)(%rax), %xmm0
    aesenc       (-48)(%rax), %xmm0
.Lkey_192_sgas_2: 
    aesenc       (-32)(%rax), %xmm0
    aesenc       (-16)(%rax), %xmm0
.Lkey_128_sgas_2: 
    aesenc       (%rax), %xmm0
    aesenc       (16)(%rax), %xmm0
    aesenc       (32)(%rax), %xmm0
    aesenc       (48)(%rax), %xmm0
    aesenc       (64)(%rax), %xmm0
    aesenc       (80)(%rax), %xmm0
    aesenc       (96)(%rax), %xmm0
    aesenc       (112)(%rax), %xmm0
    aesenc       (128)(%rax), %xmm0
    aesenclast   (144)(%rax), %xmm0
    movdqu       (16)(%rsp,%r11), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (80)(%rsp,%r11)
    add          %r9, %r11
    dec          %r8
    jnz          .Lsingle_blk_loopgas_2
    xor          %rcx, %rcx
.L__0023gas_2: 
    movl         (80)(%rsp,%rcx), %eax
    movl         %eax, (%r14,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__0023gas_2
.Lquitgas_2: 
    add          $(144), %rsp
vzeroupper 
 
    pop          %r15
 
    pop          %r14
 
    pop          %r13
 
    ret
 
.p2align 5, 0x90
 
.globl _e9_DecryptCFB128_RIJ128pipe_AES_NI

 
_e9_DecryptCFB128_RIJ128pipe_AES_NI:
 
    movdqu       (%r9), %xmm0
    movslq       %r8d, %r8
    sub          $(64), %r8
    jl           .Lshort_inputgas_3
.Lblks_loopgas_3: 
    movdqa       (%rcx), %xmm7
    mov          %rcx, %r10
    movdqu       (%rdi), %xmm1
    movdqu       (16)(%rdi), %xmm2
    movdqu       (32)(%rdi), %xmm3
    pxor         %xmm7, %xmm0
    pxor         %xmm7, %xmm1
    pxor         %xmm7, %xmm2
    pxor         %xmm7, %xmm3
    movdqa       (16)(%r10), %xmm7
    add          $(16), %r10
    mov          %rdx, %r11
    sub          $(1), %r11
.Lcipher_loopgas_3: 
    aesenc       %xmm7, %xmm0
    aesenc       %xmm7, %xmm1
    aesenc       %xmm7, %xmm2
    aesenc       %xmm7, %xmm3
    movdqa       (16)(%r10), %xmm7
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher_loopgas_3
    aesenclast   %xmm7, %xmm0
    movdqu       (%rdi), %xmm4
    aesenclast   %xmm7, %xmm1
    movdqu       (16)(%rdi), %xmm5
    aesenclast   %xmm7, %xmm2
    movdqu       (32)(%rdi), %xmm6
    aesenclast   %xmm7, %xmm3
    movdqu       (48)(%rdi), %xmm7
    add          $(64), %rdi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%rsi)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%rsi)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%rsi)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%rsi)
    add          $(64), %rsi
    movdqa       %xmm7, %xmm0
    sub          $(64), %r8
    jge          .Lblks_loopgas_3
.Lshort_inputgas_3: 
    add          $(64), %r8
    jz           .Lquitgas_3
    lea          (,%rdx,4), %rax
    lea          (-144)(%rcx,%rax,4), %rax
.Lsingle_blk_loopgas_3: 
    pxor         (%rcx), %xmm0
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_3
    jz           .Lkey_192_sgas_3
.Lkey_256_sgas_3: 
    aesenc       (-64)(%rax), %xmm0
    aesenc       (-48)(%rax), %xmm0
.Lkey_192_sgas_3: 
    aesenc       (-32)(%rax), %xmm0
    aesenc       (-16)(%rax), %xmm0
.Lkey_128_sgas_3: 
    aesenc       (%rax), %xmm0
    aesenc       (16)(%rax), %xmm0
    aesenc       (32)(%rax), %xmm0
    aesenc       (48)(%rax), %xmm0
    aesenc       (64)(%rax), %xmm0
    aesenc       (80)(%rax), %xmm0
    aesenc       (96)(%rax), %xmm0
    aesenc       (112)(%rax), %xmm0
    aesenc       (128)(%rax), %xmm0
    aesenclast   (144)(%rax), %xmm0
    movdqu       (%rdi), %xmm1
    add          $(16), %rdi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%rsi)
    add          $(16), %rsi
    movdqa       %xmm1, %xmm0
    sub          $(16), %r8
    jnz          .Lsingle_blk_loopgas_3
.Lquitgas_3: 
vzeroupper 
 
    ret
 
