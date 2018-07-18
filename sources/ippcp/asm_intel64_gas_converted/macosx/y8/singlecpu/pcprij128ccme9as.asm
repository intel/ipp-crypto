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
.p2align 4, 0x90
 
u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
 
increment:
.quad  1,0 
.p2align 4, 0x90
 
.globl _AuthEncrypt_RIJ128_AES_NI

 
_AuthEncrypt_RIJ128_AES_NI:
 
    push         %rbx
 
    movdqa       (%r9), %xmm0
    movdqa       (16)(%r9), %xmm2
    movdqa       (32)(%r9), %xmm1
    movdqa       u128_str(%rip), %xmm7
    pshufb       %xmm7, %xmm2
    pshufb       %xmm7, %xmm1
    movdqa       %xmm1, %xmm3
    pandn        %xmm2, %xmm3
    pand         %xmm1, %xmm2
    mov          %r8d, %r8d
    movslq       %edx, %rdx
    lea          (,%rdx,4), %rdx
    lea          (,%rdx,4), %rdx
    lea          (%rdx,%rcx), %rcx
    neg          %rdx
    mov          %rdx, %rbx
.p2align 4, 0x90
.Lblk_loopgas_1: 
    movdqu       (%rdi), %xmm4
    pxor         %xmm4, %xmm0
    movdqa       %xmm3, %xmm5
    paddq        increment(%rip), %xmm2
    pand         %xmm1, %xmm2
    por          %xmm2, %xmm5
    pshufb       %xmm7, %xmm5
    movdqa       (%rdx,%rcx), %xmm6
    add          $(16), %rdx
    pxor         %xmm6, %xmm5
    pxor         %xmm6, %xmm0
    movdqa       (%rdx,%rcx), %xmm6
.p2align 4, 0x90
.Lcipher_loopgas_1: 
    aesenc       %xmm6, %xmm5
    aesenc       %xmm6, %xmm0
    movdqa       (16)(%rdx,%rcx), %xmm6
    add          $(16), %rdx
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm6, %xmm5
    aesenclast   %xmm6, %xmm0
    pxor         %xmm5, %xmm4
    movdqu       %xmm4, (%rsi)
    mov          %rbx, %rdx
    add          $(16), %rsi
    add          $(16), %rdi
    sub          $(16), %r8
    jnz          .Lblk_loopgas_1
    movdqu       %xmm0, (%r9)
    movdqu       %xmm5, (16)(%r9)
    pxor         %xmm6, %xmm6
 
    pop          %rbx
 
    ret
 
.p2align 4, 0x90
 
.globl _DecryptAuth_RIJ128_AES_NI

 
_DecryptAuth_RIJ128_AES_NI:
 
    push         %rbx
 
    sub          $(16), %rsp
 
    movdqa       (%r9), %xmm0
    movdqa       (16)(%r9), %xmm2
    movdqa       (32)(%r9), %xmm1
    movdqa       u128_str(%rip), %xmm7
    pshufb       %xmm7, %xmm2
    pshufb       %xmm7, %xmm1
    movdqa       %xmm1, %xmm3
    pandn        %xmm2, %xmm3
    pand         %xmm1, %xmm2
    mov          %r8d, %r8d
    movslq       %edx, %rdx
    lea          (,%rdx,4), %rdx
    lea          (,%rdx,4), %rdx
    lea          (%rdx,%rcx), %rcx
    neg          %rdx
    mov          %rdx, %rbx
.p2align 4, 0x90
.Lblk_loopgas_2: 
    movdqu       (%rdi), %xmm4
    movdqa       %xmm3, %xmm5
    paddq        increment(%rip), %xmm2
    pand         %xmm1, %xmm2
    por          %xmm2, %xmm5
    pshufb       %xmm7, %xmm5
    movdqa       (%rdx,%rcx), %xmm6
    add          $(16), %rdx
    pxor         %xmm6, %xmm5
    movdqa       (%rdx,%rcx), %xmm6
.p2align 4, 0x90
.Lcipher_loopgas_2: 
    aesenc       %xmm6, %xmm5
    movdqa       (16)(%rdx,%rcx), %xmm6
    add          $(16), %rdx
    jnz          .Lcipher_loopgas_2
    aesenclast   %xmm6, %xmm5
    pxor         %xmm5, %xmm4
    movdqu       %xmm4, (%rsi)
    mov          %rbx, %rdx
    movdqa       (%rdx,%rcx), %xmm6
    add          $(16), %rdx
    pxor         %xmm4, %xmm0
    pxor         %xmm6, %xmm0
    movdqa       (%rdx,%rcx), %xmm6
.p2align 4, 0x90
.Lauth_loopgas_2: 
    aesenc       %xmm6, %xmm0
    movdqa       (16)(%rdx,%rcx), %xmm6
    add          $(16), %rdx
    jnz          .Lauth_loopgas_2
    aesenclast   %xmm6, %xmm0
    mov          %rbx, %rdx
    add          $(16), %rsi
    add          $(16), %rdi
    sub          $(16), %r8
    jnz          .Lblk_loopgas_2
    movdqu       %xmm0, (%r9)
    movdqu       %xmm6, (16)(%r9)
    pxor         %xmm6, %xmm6
    add          $(16), %rsp
 
    pop          %rbx
 
    ret
 
