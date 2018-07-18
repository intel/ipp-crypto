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
.p2align 6, 0x90
 
.globl EncryptCFB_RIJ128_AES_NI
.type EncryptCFB_RIJ128_AES_NI, @function
 
EncryptCFB_RIJ128_AES_NI:
 
    push         %r12
 
    push         %r15
 
    sub          $(152), %rsp
 
    mov          (176)(%rsp), %rax
    movdqu       (%rax), %xmm4
    movdqa       %xmm4, (%rsp)
    movslq       %r8d, %r8
    movslq       %r9d, %r9
    mov          %rcx, %r15
    lea          (,%rdx,4), %rax
    lea          (-144)(%r15,%rax,4), %rax
    lea          (,%r9,4), %r10
.Lblks_loopgas_1: 
    cmp          %r10, %r8
    cmovl        %r8, %r10
    xor          %rcx, %rcx
.L__0009gas_1: 
    movb         (%rdi,%rcx), %r11b
    movb         %r11b, (80)(%rsp,%rcx)
    add          $(1), %rcx
    cmp          %r10, %rcx
    jl           .L__0009gas_1
    mov          %r10, %r12
    xor          %r11, %r11
.Lsingle_blkgas_1: 
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
    movdqu       (80)(%rsp,%r11), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (16)(%rsp,%r11)
    add          %r9, %r11
    sub          %r9, %r12
    jg           .Lsingle_blkgas_1
    xor          %rcx, %rcx
.L__000Agas_1: 
    movb         (16)(%rsp,%rcx), %r11b
    movb         %r11b, (%rsi,%rcx)
    add          $(1), %rcx
    cmp          %r10, %rcx
    jl           .L__000Agas_1
    movdqu       (%rsp,%r10), %xmm0
    movdqa       %xmm0, (%rsp)
    add          %r10, %rdi
    add          %r10, %rsi
    sub          %r10, %r8
    jg           .Lblks_loopgas_1
    add          $(152), %rsp
 
    pop          %r15
 
    pop          %r12
 
    ret
.Lfe1:
.size EncryptCFB_RIJ128_AES_NI, .Lfe1-(EncryptCFB_RIJ128_AES_NI)
.p2align 6, 0x90
 
.globl EncryptCFB32_RIJ128_AES_NI
.type EncryptCFB32_RIJ128_AES_NI, @function
 
EncryptCFB32_RIJ128_AES_NI:
 
    push         %r12
 
    push         %r15
 
    sub          $(152), %rsp
 
    mov          (176)(%rsp), %rax
    movdqu       (%rax), %xmm4
    movdqa       %xmm4, (%rsp)
    movslq       %r8d, %r8
    movslq       %r9d, %r9
    mov          %rcx, %r15
    lea          (,%rdx,4), %rax
    lea          (-144)(%r15,%rax,4), %rax
    lea          (,%r9,4), %r10
.Lblks_loopgas_2: 
    cmp          %r10, %r8
    cmovl        %r8, %r10
    xor          %rcx, %rcx
.L__001Bgas_2: 
    movl         (%rdi,%rcx), %r11d
    movl         %r11d, (80)(%rsp,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__001Bgas_2
    mov          %r10, %r12
    xor          %r11, %r11
.Lsingle_blkgas_2: 
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
    movdqu       (80)(%rsp,%r11), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (16)(%rsp,%r11)
    add          %r9, %r11
    sub          %r9, %r12
    jg           .Lsingle_blkgas_2
    xor          %rcx, %rcx
.L__001Cgas_2: 
    movl         (16)(%rsp,%rcx), %r11d
    movl         %r11d, (%rsi,%rcx)
    add          $(4), %rcx
    cmp          %r10, %rcx
    jl           .L__001Cgas_2
    movdqu       (%rsp,%r10), %xmm0
    movdqa       %xmm0, (%rsp)
    add          %r10, %rdi
    add          %r10, %rsi
    sub          %r10, %r8
    jg           .Lblks_loopgas_2
    add          $(152), %rsp
 
    pop          %r15
 
    pop          %r12
 
    ret
.Lfe2:
.size EncryptCFB32_RIJ128_AES_NI, .Lfe2-(EncryptCFB32_RIJ128_AES_NI)
.p2align 6, 0x90
 
.globl EncryptCFB128_RIJ128_AES_NI
.type EncryptCFB128_RIJ128_AES_NI, @function
 
EncryptCFB128_RIJ128_AES_NI:
 
    movdqu       (%r9), %xmm0
    movslq       %r8d, %r8
    movslq       %r9d, %r9
    lea          (,%rdx,4), %rax
    lea          (-144)(%rcx,%rax,4), %rax
.Lblks_loopgas_3: 
    pxor         (%rcx), %xmm0
    movdqu       (%rdi), %xmm1
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
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%rsi)
    add          $(16), %rdi
    add          $(16), %rsi
    sub          $(16), %r8
    jg           .Lblks_loopgas_3
 
    ret
.Lfe3:
.size EncryptCFB128_RIJ128_AES_NI, .Lfe3-(EncryptCFB128_RIJ128_AES_NI)
 
