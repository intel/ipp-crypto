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

 
.text
.p2align 6, 0x90
 
u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
.p2align 6, 0x90
 
.globl _EncryptCTR_RIJ128pipe_AES_NI

 
_EncryptCTR_RIJ128pipe_AES_NI:
 
    push         %rbx
 
    mov          (16)(%rsp), %rax
    movdqu       (%rax), %xmm8
    movdqu       (%r9), %xmm0
    movdqa       %xmm8, %xmm9
    pandn        %xmm0, %xmm9
    movq         (%r9), %rbx
    movq         (8)(%r9), %rax
    bswap        %rbx
    bswap        %rax
    movslq       %r8d, %r8
    sub          $(64), %r8
    jl           .Lshort_inputgas_1
.Lblks_loopgas_1: 
    movdqa       u128_str(%rip), %xmm4
    pinsrq       $(0), %rax, %xmm0
    pinsrq       $(1), %rbx, %xmm0
    pshufb       %xmm4, %xmm0
    pand         %xmm8, %xmm0
    por          %xmm9, %xmm0
    add          $(1), %rax
    adc          $(0), %rbx
    pinsrq       $(0), %rax, %xmm1
    pinsrq       $(1), %rbx, %xmm1
    pshufb       %xmm4, %xmm1
    pand         %xmm8, %xmm1
    por          %xmm9, %xmm1
    add          $(1), %rax
    adc          $(0), %rbx
    pinsrq       $(0), %rax, %xmm2
    pinsrq       $(1), %rbx, %xmm2
    pshufb       %xmm4, %xmm2
    pand         %xmm8, %xmm2
    por          %xmm9, %xmm2
    add          $(1), %rax
    adc          $(0), %rbx
    pinsrq       $(0), %rax, %xmm3
    pinsrq       $(1), %rbx, %xmm3
    pshufb       %xmm4, %xmm3
    pand         %xmm8, %xmm3
    por          %xmm9, %xmm3
    movdqa       (%rcx), %xmm4
    mov          %rcx, %r10
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
    movdqu       (%rdi), %xmm4
    movdqu       (16)(%rdi), %xmm5
    movdqu       (32)(%rdi), %xmm6
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
    add          $(1), %rax
    adc          $(0), %rbx
    add          $(64), %rsi
    sub          $(64), %r8
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    add          $(64), %r8
    jz           .Lquitgas_1
    lea          (,%rdx,4), %r10
    lea          (-144)(%rcx,%r10,4), %r10
.Lsingle_blk_loopgas_1: 
    pinsrq       $(0), %rax, %xmm0
    pinsrq       $(1), %rbx, %xmm0
    pshufb       u128_str(%rip), %xmm0
    pand         %xmm8, %xmm0
    por          %xmm9, %xmm0
    pxor         (%rcx), %xmm0
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%r10), %xmm0
    aesenc       (-48)(%r10), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%r10), %xmm0
    aesenc       (-16)(%r10), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%r10), %xmm0
    aesenc       (16)(%r10), %xmm0
    aesenc       (32)(%r10), %xmm0
    aesenc       (48)(%r10), %xmm0
    aesenc       (64)(%r10), %xmm0
    aesenc       (80)(%r10), %xmm0
    aesenc       (96)(%r10), %xmm0
    aesenc       (112)(%r10), %xmm0
    aesenc       (128)(%r10), %xmm0
    aesenclast   (144)(%r10), %xmm0
    add          $(1), %rax
    adc          $(0), %rbx
    sub          $(16), %r8
    jl           .Lpartial_blockgas_1
    movdqu       (%rdi), %xmm4
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%rsi)
    add          $(16), %rdi
    add          $(16), %rsi
    cmp          $(0), %r8
    jz           .Lquitgas_1
    jmp          .Lsingle_blk_loopgas_1
.Lpartial_blockgas_1: 
    add          $(16), %r8
.Lpartial_block_loopgas_1: 
    pextrb       $(0), %xmm0, %r10d
    psrldq       $(1), %xmm0
    movzbl       (%rdi), %r11d
    xor          %r11, %r10
    movb         %r10b, (%rsi)
    inc          %rdi
    inc          %rsi
    dec          %r8
    jnz          .Lpartial_block_loopgas_1
.Lquitgas_1: 
    pinsrq       $(0), %rax, %xmm0
    pinsrq       $(1), %rbx, %xmm0
    pshufb       u128_str(%rip), %xmm0
    pand         %xmm8, %xmm0
    por          %xmm9, %xmm0
    movdqu       %xmm0, (%r9)
vzeroupper 
 
    pop          %rbx
 
    ret
 
