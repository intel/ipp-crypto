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
 
.p2align 5, 0x90
 
.globl _e9_DecryptCBC_RIJ128pipe_AES_NI

 
_e9_DecryptCBC_RIJ128pipe_AES_NI:
 
    push         %rbx
 
    sub          $(144), %rsp
 
    movdqu       (%r9), %xmm15
    movslq       %r8d, %r8
    lea          (,%rdx,4), %rax
    cmp          $(64), %r8
    jl           .Lshort123_inputgas_1
    cmp          $(256), %r8
    jle          .Lblock4xgas_1
    mov          %rsp, %rbx
    sub          $(64), %rsp
    movdqa       %xmm6, (%rsp)
    movdqa       %xmm7, (16)(%rsp)
    movdqa       %xmm8, (32)(%rsp)
    movdqa       %xmm9, (48)(%rsp)
    sub          $(128), %r8
.p2align 5, 0x90
.Lblk8_loopgas_1: 
    lea          (-16)(%rcx,%rax,4), %r9
    movdqu       (%rdi), %xmm0
    movdqu       (16)(%rdi), %xmm1
    movdqu       (32)(%rdi), %xmm2
    movdqu       (48)(%rdi), %xmm3
    movdqu       (64)(%rdi), %xmm6
    movdqu       (80)(%rdi), %xmm7
    movdqu       (96)(%rdi), %xmm8
    movdqu       (112)(%rdi), %xmm9
    movdqa       (16)(%r9), %xmm5
    movdqa       (%r9), %xmm4
    movdqa       %xmm0, (16)(%rbx)
    pxor         %xmm5, %xmm0
    movdqa       %xmm1, (32)(%rbx)
    pxor         %xmm5, %xmm1
    movdqa       %xmm2, (48)(%rbx)
    pxor         %xmm5, %xmm2
    movdqa       %xmm3, (64)(%rbx)
    pxor         %xmm5, %xmm3
    movdqa       %xmm6, (80)(%rbx)
    pxor         %xmm5, %xmm6
    movdqa       %xmm7, (96)(%rbx)
    pxor         %xmm5, %xmm7
    movdqa       %xmm8, (112)(%rbx)
    pxor         %xmm5, %xmm8
    movdqa       %xmm9, (128)(%rbx)
    pxor         %xmm5, %xmm9
    movdqa       (-16)(%r9), %xmm5
    sub          $(32), %r9
    lea          (-2)(%rdx), %r10
.p2align 5, 0x90
.Lcipher_loop8gas_1: 
    aesdec       %xmm4, %xmm0
    aesdec       %xmm4, %xmm1
    aesdec       %xmm4, %xmm2
    aesdec       %xmm4, %xmm3
    aesdec       %xmm4, %xmm6
    aesdec       %xmm4, %xmm7
    aesdec       %xmm4, %xmm8
    aesdec       %xmm4, %xmm9
    movdqa       (%r9), %xmm4
    aesdec       %xmm5, %xmm0
    aesdec       %xmm5, %xmm1
    aesdec       %xmm5, %xmm2
    aesdec       %xmm5, %xmm3
    aesdec       %xmm5, %xmm6
    aesdec       %xmm5, %xmm7
    aesdec       %xmm5, %xmm8
    aesdec       %xmm5, %xmm9
    movdqa       (-16)(%r9), %xmm5
    sub          $(32), %r9
    sub          $(2), %r10
    jnz          .Lcipher_loop8gas_1
    aesdec       %xmm4, %xmm0
    aesdec       %xmm4, %xmm1
    aesdec       %xmm4, %xmm2
    aesdec       %xmm4, %xmm3
    aesdec       %xmm4, %xmm6
    aesdec       %xmm4, %xmm7
    aesdec       %xmm4, %xmm8
    aesdec       %xmm4, %xmm9
    aesdeclast   %xmm5, %xmm0
    pxor         %xmm15, %xmm0
    movdqu       %xmm0, (%rsi)
    aesdeclast   %xmm5, %xmm1
    pxor         (16)(%rbx), %xmm1
    movdqu       %xmm1, (16)(%rsi)
    aesdeclast   %xmm5, %xmm2
    pxor         (32)(%rbx), %xmm2
    movdqu       %xmm2, (32)(%rsi)
    aesdeclast   %xmm5, %xmm3
    pxor         (48)(%rbx), %xmm3
    movdqu       %xmm3, (48)(%rsi)
    aesdeclast   %xmm5, %xmm6
    pxor         (64)(%rbx), %xmm6
    movdqu       %xmm6, (64)(%rsi)
    aesdeclast   %xmm5, %xmm7
    pxor         (80)(%rbx), %xmm7
    movdqu       %xmm7, (80)(%rsi)
    aesdeclast   %xmm5, %xmm8
    pxor         (96)(%rbx), %xmm8
    movdqu       %xmm8, (96)(%rsi)
    aesdeclast   %xmm5, %xmm9
    pxor         (112)(%rbx), %xmm9
    movdqu       %xmm9, (112)(%rsi)
    movdqa       (128)(%rbx), %xmm15
    add          $(128), %rsi
    add          $(128), %rdi
    sub          $(128), %r8
    jge          .Lblk8_loopgas_1
    movdqa       (%rsp), %xmm6
    movdqa       (16)(%rsp), %xmm7
    movdqa       (32)(%rsp), %xmm8
    movdqa       (48)(%rsp), %xmm9
    add          $(64), %rsp
    add          $(128), %r8
    jz           .Lquitgas_1
.Lblock4xgas_1: 
    cmp          $(64), %r8
    jl           .Lshort123_inputgas_1
    sub          $(64), %r8
.p2align 5, 0x90
.Lblk4_loopgas_1: 
    lea          (-16)(%rcx,%rax,4), %r9
    movdqu       (%rdi), %xmm0
    movdqu       (16)(%rdi), %xmm1
    movdqu       (32)(%rdi), %xmm2
    movdqu       (48)(%rdi), %xmm3
    movdqa       (16)(%r9), %xmm5
    movdqa       (%r9), %xmm4
    movdqa       %xmm0, (16)(%rsp)
    pxor         %xmm5, %xmm0
    movdqa       %xmm1, (32)(%rsp)
    pxor         %xmm5, %xmm1
    movdqa       %xmm2, (48)(%rsp)
    pxor         %xmm5, %xmm2
    movdqa       %xmm3, (64)(%rsp)
    pxor         %xmm5, %xmm3
    movdqa       (-16)(%r9), %xmm5
    sub          $(32), %r9
    lea          (-2)(%rdx), %r10
.p2align 5, 0x90
.Lcipher_loop4gas_1: 
    aesdec       %xmm4, %xmm0
    aesdec       %xmm4, %xmm1
    aesdec       %xmm4, %xmm2
    aesdec       %xmm4, %xmm3
    movdqa       (%r9), %xmm4
    aesdec       %xmm5, %xmm0
    aesdec       %xmm5, %xmm1
    aesdec       %xmm5, %xmm2
    aesdec       %xmm5, %xmm3
    movdqa       (-16)(%r9), %xmm5
    sub          $(32), %r9
    sub          $(2), %r10
    jnz          .Lcipher_loop4gas_1
    aesdec       %xmm4, %xmm0
    aesdec       %xmm4, %xmm1
    aesdec       %xmm4, %xmm2
    aesdec       %xmm4, %xmm3
    aesdeclast   %xmm5, %xmm0
    pxor         %xmm15, %xmm0
    movdqu       %xmm0, (%rsi)
    aesdeclast   %xmm5, %xmm1
    pxor         (16)(%rsp), %xmm1
    movdqu       %xmm1, (16)(%rsi)
    aesdeclast   %xmm5, %xmm2
    pxor         (32)(%rsp), %xmm2
    movdqu       %xmm2, (32)(%rsi)
    aesdeclast   %xmm5, %xmm3
    pxor         (48)(%rsp), %xmm3
    movdqu       %xmm3, (48)(%rsi)
    movdqa       (64)(%rsp), %xmm15
    add          $(64), %rsi
    add          $(64), %rdi
    sub          $(64), %r8
    jge          .Lblk4_loopgas_1
    add          $(64), %r8
    jz           .Lquitgas_1
.Lshort123_inputgas_1: 
    lea          (%rcx,%rax,4), %r9
.p2align 5, 0x90
.Lsingle_blk_loopgas_1: 
    movdqu       (%rdi), %xmm0
    add          $(16), %rdi
    movdqa       %xmm0, %xmm1
    pxor         (%r9), %xmm0
    cmp          $(12), %rdx
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesdec       (208)(%rcx), %xmm0
    aesdec       (192)(%rcx), %xmm0
.Lkey_192_sgas_1: 
    aesdec       (176)(%rcx), %xmm0
    aesdec       (160)(%rcx), %xmm0
.Lkey_128_sgas_1: 
    aesdec       (144)(%rcx), %xmm0
    aesdec       (128)(%rcx), %xmm0
    aesdec       (112)(%rcx), %xmm0
    aesdec       (96)(%rcx), %xmm0
    aesdec       (80)(%rcx), %xmm0
    aesdec       (64)(%rcx), %xmm0
    aesdec       (48)(%rcx), %xmm0
    aesdec       (32)(%rcx), %xmm0
    aesdec       (16)(%rcx), %xmm0
    aesdeclast   (%rcx), %xmm0
    pxor         %xmm15, %xmm0
    movdqu       %xmm0, (%rsi)
    add          $(16), %rsi
    sub          $(16), %r8
    movdqa       %xmm1, %xmm15
    jnz          .Lsingle_blk_loopgas_1
.Lquitgas_1: 
    pxor         %xmm4, %xmm4
    pxor         %xmm5, %xmm5
    add          $(144), %rsp
vzeroupper 
 
    pop          %rbx
 
    ret
 
