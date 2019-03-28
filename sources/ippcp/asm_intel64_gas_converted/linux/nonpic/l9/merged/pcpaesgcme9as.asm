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
 
POLY:
.quad                  0x1, 0xC200000000000000 
 
TWOONE:
.quad                  0x1,        0x100000000 
 
SHUF_CONST:
.quad    0x8090a0b0c0d0e0f,    0x1020304050607 
 
MASK1:
.quad   0xffffffffffffffff,                0x0 
 
MASK2:
.quad                  0x0, 0xffffffffffffffff 
 
INC_1:
.quad  1,0 
 
.p2align 5, 0x90
 
.globl l9_AesGcmPrecompute_avx
.type l9_AesGcmPrecompute_avx, @function
 
l9_AesGcmPrecompute_avx:
 
    movdqu       (%rsi), %xmm0
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqa       %xmm0, %xmm4
    psllq        $(1), %xmm0
    psrlq        $(63), %xmm4
    movdqa       %xmm4, %xmm3
    pslldq       $(8), %xmm4
    psrldq       $(8), %xmm3
    por          %xmm4, %xmm0
    pshufd       $(36), %xmm3, %xmm4
    pcmpeqd      TWOONE(%rip), %xmm4
    pand         POLY(%rip), %xmm4
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
    movdqa       %xmm1, %xmm5
    movdqa       %xmm1, %xmm15
    psllq        $(63), %xmm3
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm3
    pxor         %xmm15, %xmm3
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
    movdqa       %xmm2, %xmm5
    movdqa       %xmm2, %xmm15
    psllq        $(63), %xmm3
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm3
    pxor         %xmm15, %xmm3
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
    movdqu       %xmm0, (%rdi)
    movdqu       %xmm1, (16)(%rdi)
    movdqu       %xmm2, (32)(%rdi)
vzeroupper 
 
    ret
.Lfe1:
.size l9_AesGcmPrecompute_avx, .Lfe1-(l9_AesGcmPrecompute_avx)
.p2align 5, 0x90
 
.globl l9_AesGcmMulGcm_avx
.type l9_AesGcmMulGcm_avx, @function
 
l9_AesGcmMulGcm_avx:
 
    movdqa       (%rdi), %xmm0
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqa       (%rsi), %xmm1
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
    movdqa       %xmm0, %xmm4
    movdqa       %xmm0, %xmm15
    psllq        $(63), %xmm2
    psllq        $(62), %xmm4
    psllq        $(57), %xmm15
    pxor         %xmm4, %xmm2
    pxor         %xmm15, %xmm2
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
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqa       %xmm0, (%rdi)
vzeroupper 
 
    ret
.Lfe2:
.size l9_AesGcmMulGcm_avx, .Lfe2-(l9_AesGcmMulGcm_avx)
.p2align 5, 0x90
 
.globl l9_AesGcmAuth_avx
.type l9_AesGcmAuth_avx, @function
 
l9_AesGcmAuth_avx:
 
    movdqa       (%rdi), %xmm0
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqa       (%rcx), %xmm1
    movslq       %edx, %rdx
.p2align 5, 0x90
.Lauth_loopgas_3: 
    movdqu       (%rsi), %xmm2
    pshufb       SHUF_CONST(%rip), %xmm2
    add          $(16), %rsi
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
    movdqa       %xmm0, %xmm4
    movdqa       %xmm0, %xmm15
    psllq        $(63), %xmm2
    psllq        $(62), %xmm4
    psllq        $(57), %xmm15
    pxor         %xmm4, %xmm2
    pxor         %xmm15, %xmm2
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
    sub          $(16), %rdx
    jnz          .Lauth_loopgas_3
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqa       %xmm0, (%rdi)
vzeroupper 
 
    ret
.Lfe3:
.size l9_AesGcmAuth_avx, .Lfe3-(l9_AesGcmAuth_avx)
.p2align 5, 0x90
 
.globl l9_AesGcmEnc_avx
.type l9_AesGcmEnc_avx, @function
 
l9_AesGcmEnc_avx:
 
    push         %rbx
 
    sub          $(128), %rsp
 
    mov          (152)(%rsp), %rax
    mov          (160)(%rsp), %rbx
    mov          (144)(%rsp), %rcx
    movdqa       SHUF_CONST(%rip), %xmm4
    movdqu       (%rax), %xmm0
    movdqu       (%rbx), %xmm1
    movdqu       (%rcx), %xmm2
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (%rsp)
    movdqa       %xmm1, (16)(%rsp)
    pshufb       %xmm4, %xmm2
    pxor         %xmm1, %xmm1
    movdqa       %xmm2, (32)(%rsp)
    movdqa       %xmm1, (48)(%rsp)
    movdqa       %xmm1, (64)(%rsp)
    movdqa       %xmm1, (80)(%rsp)
    mov          (168)(%rsp), %rbx
    movdqa       (32)(%rbx), %xmm10
    pshufd       $(78), %xmm10, %xmm9
    pxor         %xmm10, %xmm9
    movdqa       %xmm9, (96)(%rsp)
    movslq       %edx, %rdx
    mov          %r9, %rcx
    mov          %rdx, %rax
    and          $(63), %rax
    and          $(-64), %rdx
    jz           .Lsingle_block_procgas_4
.p2align 5, 0x90
.Lblks4_loopgas_4: 
    movdqa       INC_1(%rip), %xmm6
    movdqa       SHUF_CONST(%rip), %xmm5
    movdqa       %xmm0, %xmm1
    paddd        %xmm6, %xmm1
    movdqa       %xmm1, %xmm2
    paddd        %xmm6, %xmm2
    movdqa       %xmm2, %xmm3
    paddd        %xmm6, %xmm3
    movdqa       %xmm3, %xmm4
    paddd        %xmm6, %xmm4
    movdqa       %xmm4, (%rsp)
    movdqa       (%rcx), %xmm0
    mov          %rcx, %r10
    pshufb       %xmm5, %xmm1
    pshufb       %xmm5, %xmm2
    pshufb       %xmm5, %xmm3
    pshufb       %xmm5, %xmm4
    pxor         %xmm0, %xmm1
    pxor         %xmm0, %xmm2
    pxor         %xmm0, %xmm3
    pxor         %xmm0, %xmm4
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    mov          %r8d, %r11d
    sub          $(1), %r11
.p2align 5, 0x90
.Lcipher4_loopgas_4: 
    aesenc       %xmm0, %xmm1
    aesenc       %xmm0, %xmm2
    aesenc       %xmm0, %xmm3
    aesenc       %xmm0, %xmm4
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher4_loopgas_4
    aesenclast   %xmm0, %xmm1
    aesenclast   %xmm0, %xmm2
    aesenclast   %xmm0, %xmm3
    aesenclast   %xmm0, %xmm4
    movdqa       (16)(%rsp), %xmm0
    movdqa       %xmm4, (16)(%rsp)
    movdqu       (%rsi), %xmm4
    movdqu       (16)(%rsi), %xmm5
    movdqu       (32)(%rsi), %xmm6
    movdqu       (48)(%rsi), %xmm7
    add          $(64), %rsi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%rdi)
    pshufb       SHUF_CONST(%rip), %xmm0
    pxor         (32)(%rsp), %xmm0
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm1
    pxor         (48)(%rsp), %xmm1
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm2
    pxor         (64)(%rsp), %xmm2
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm3
    pxor         (80)(%rsp), %xmm3
    add          $(64), %rdi
    cmp          $(64), %rdx
    je           .Lcombine_hashgas_4
    movdqa       MASK1(%rip), %xmm14
    pshufd       $(78), %xmm0, %xmm6
    movdqa       %xmm0, %xmm5
    pxor         %xmm0, %xmm6
    pclmulqdq    $(0), %xmm10, %xmm0
    pshufd       $(78), %xmm1, %xmm13
    movdqa       %xmm1, %xmm12
    pxor         %xmm1, %xmm13
    pclmulqdq    $(17), %xmm10, %xmm5
    pclmulqdq    $(0), %xmm9, %xmm6
    pxor         %xmm0, %xmm6
    pxor         %xmm5, %xmm6
    pshufd       $(78), %xmm6, %xmm4
    movdqa       %xmm4, %xmm6
    pand         MASK2(%rip), %xmm4
    pand         %xmm14, %xmm6
    pxor         %xmm4, %xmm0
    pxor         %xmm6, %xmm5
    movdqa       %xmm0, %xmm4
    psllq        $(1), %xmm0
    pclmulqdq    $(0), %xmm10, %xmm1
    pxor         %xmm4, %xmm0
    psllq        $(5), %xmm0
    pxor         %xmm4, %xmm0
    psllq        $(57), %xmm0
    pshufd       $(78), %xmm0, %xmm6
    movdqa       %xmm6, %xmm0
    pclmulqdq    $(17), %xmm10, %xmm12
    pand         %xmm14, %xmm6
    pand         MASK2(%rip), %xmm0
    pxor         %xmm4, %xmm0
    pxor         %xmm6, %xmm5
    movdqa       %xmm0, %xmm6
    psrlq        $(5), %xmm0
    pclmulqdq    $(0), %xmm9, %xmm13
    pxor         %xmm6, %xmm0
    psrlq        $(1), %xmm0
    pxor         %xmm6, %xmm0
    psrlq        $(1), %xmm0
    pxor         %xmm6, %xmm0
    pxor         %xmm5, %xmm0
    pxor         %xmm1, %xmm13
    pxor         %xmm12, %xmm13
    pshufd       $(78), %xmm13, %xmm11
    movdqa       %xmm11, %xmm13
    pand         MASK2(%rip), %xmm11
    pand         %xmm14, %xmm13
    pxor         %xmm11, %xmm1
    pxor         %xmm13, %xmm12
    movdqa       %xmm1, %xmm11
    movdqa       %xmm1, %xmm13
    movdqa       %xmm1, %xmm15
    psllq        $(63), %xmm11
    psllq        $(62), %xmm13
    psllq        $(57), %xmm15
    pxor         %xmm13, %xmm11
    pxor         %xmm15, %xmm11
    movdqa       %xmm11, %xmm13
    pslldq       $(8), %xmm13
    psrldq       $(8), %xmm11
    pxor         %xmm13, %xmm1
    pxor         %xmm11, %xmm12
    movdqa       %xmm1, %xmm13
    psrlq        $(5), %xmm13
    pxor         %xmm1, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm1, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm13, %xmm1
    pxor         %xmm12, %xmm1
    pshufd       $(78), %xmm2, %xmm6
    movdqa       %xmm2, %xmm5
    pxor         %xmm2, %xmm6
    pclmulqdq    $(0), %xmm10, %xmm2
    pshufd       $(78), %xmm3, %xmm13
    movdqa       %xmm3, %xmm12
    pxor         %xmm3, %xmm13
    pclmulqdq    $(17), %xmm10, %xmm5
    pclmulqdq    $(0), %xmm9, %xmm6
    pxor         %xmm2, %xmm6
    pxor         %xmm5, %xmm6
    pshufd       $(78), %xmm6, %xmm4
    movdqa       %xmm4, %xmm6
    pand         MASK2(%rip), %xmm4
    pand         %xmm14, %xmm6
    pxor         %xmm4, %xmm2
    pxor         %xmm6, %xmm5
    movdqa       %xmm2, %xmm4
    psllq        $(1), %xmm2
    pclmulqdq    $(0), %xmm10, %xmm3
    pxor         %xmm4, %xmm2
    psllq        $(5), %xmm2
    pxor         %xmm4, %xmm2
    psllq        $(57), %xmm2
    pshufd       $(78), %xmm2, %xmm6
    movdqa       %xmm6, %xmm2
    pclmulqdq    $(17), %xmm10, %xmm12
    pand         %xmm14, %xmm6
    pand         MASK2(%rip), %xmm2
    pxor         %xmm4, %xmm2
    pxor         %xmm6, %xmm5
    movdqa       %xmm2, %xmm6
    psrlq        $(5), %xmm2
    pclmulqdq    $(0), %xmm9, %xmm13
    pxor         %xmm6, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm6, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm6, %xmm2
    pxor         %xmm5, %xmm2
    pxor         %xmm3, %xmm13
    pxor         %xmm12, %xmm13
    pshufd       $(78), %xmm13, %xmm11
    movdqa       %xmm11, %xmm13
    pand         MASK2(%rip), %xmm11
    pand         %xmm14, %xmm13
    pxor         %xmm11, %xmm3
    pxor         %xmm13, %xmm12
    movdqa       %xmm3, %xmm11
    movdqa       %xmm3, %xmm13
    movdqa       %xmm3, %xmm15
    psllq        $(63), %xmm11
    psllq        $(62), %xmm13
    psllq        $(57), %xmm15
    pxor         %xmm13, %xmm11
    pxor         %xmm15, %xmm11
    movdqa       %xmm11, %xmm13
    pslldq       $(8), %xmm13
    psrldq       $(8), %xmm11
    pxor         %xmm13, %xmm3
    pxor         %xmm11, %xmm12
    movdqa       %xmm3, %xmm13
    psrlq        $(5), %xmm13
    pxor         %xmm3, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm3, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm13, %xmm3
    pxor         %xmm12, %xmm3
    movdqa       %xmm0, (32)(%rsp)
    movdqa       %xmm1, (48)(%rsp)
    movdqa       %xmm2, (64)(%rsp)
    movdqa       %xmm3, (80)(%rsp)
    sub          $(64), %rdx
    movdqa       (%rsp), %xmm0
    cmp          $(64), %rdx
    jge          .Lblks4_loopgas_4
.Lcombine_hashgas_4: 
    movdqa       (%rbx), %xmm8
    movdqa       (16)(%rbx), %xmm9
    pshufd       $(78), %xmm0, %xmm5
    pshufd       $(78), %xmm10, %xmm6
    pxor         %xmm0, %xmm5
    pxor         %xmm10, %xmm6
    pclmulqdq    $(0), %xmm6, %xmm5
    movdqa       %xmm0, %xmm4
    pclmulqdq    $(0), %xmm10, %xmm0
    pxor         %xmm6, %xmm6
    pclmulqdq    $(17), %xmm10, %xmm4
    pxor         %xmm0, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm6
    pslldq       $(8), %xmm5
    pxor         %xmm6, %xmm4
    pxor         %xmm5, %xmm0
    movdqa       %xmm0, %xmm6
    movdqa       %xmm0, %xmm5
    movdqa       %xmm0, %xmm15
    psllq        $(63), %xmm6
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm6
    pxor         %xmm15, %xmm6
    movdqa       %xmm6, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm6
    pxor         %xmm5, %xmm0
    pxor         %xmm6, %xmm4
    movdqa       %xmm0, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm0, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm0, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm0
    pxor         %xmm4, %xmm0
    pshufd       $(78), %xmm1, %xmm5
    pshufd       $(78), %xmm9, %xmm6
    pxor         %xmm1, %xmm5
    pxor         %xmm9, %xmm6
    pclmulqdq    $(0), %xmm6, %xmm5
    movdqa       %xmm1, %xmm4
    pclmulqdq    $(0), %xmm9, %xmm1
    pxor         %xmm6, %xmm6
    pclmulqdq    $(17), %xmm9, %xmm4
    pxor         %xmm1, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm6
    pslldq       $(8), %xmm5
    pxor         %xmm6, %xmm4
    pxor         %xmm5, %xmm1
    movdqa       %xmm1, %xmm6
    movdqa       %xmm1, %xmm5
    movdqa       %xmm1, %xmm15
    psllq        $(63), %xmm6
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm6
    pxor         %xmm15, %xmm6
    movdqa       %xmm6, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm6
    pxor         %xmm5, %xmm1
    pxor         %xmm6, %xmm4
    movdqa       %xmm1, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm1, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm1, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm1
    pxor         %xmm4, %xmm1
    pshufd       $(78), %xmm2, %xmm5
    pshufd       $(78), %xmm8, %xmm6
    pxor         %xmm2, %xmm5
    pxor         %xmm8, %xmm6
    pclmulqdq    $(0), %xmm6, %xmm5
    movdqa       %xmm2, %xmm4
    pclmulqdq    $(0), %xmm8, %xmm2
    pxor         %xmm6, %xmm6
    pclmulqdq    $(17), %xmm8, %xmm4
    pxor         %xmm2, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm6
    pslldq       $(8), %xmm5
    pxor         %xmm6, %xmm4
    pxor         %xmm5, %xmm2
    movdqa       %xmm2, %xmm6
    movdqa       %xmm2, %xmm5
    movdqa       %xmm2, %xmm15
    psllq        $(63), %xmm6
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm6
    pxor         %xmm15, %xmm6
    movdqa       %xmm6, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm6
    pxor         %xmm5, %xmm2
    pxor         %xmm6, %xmm4
    movdqa       %xmm2, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm2, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm2, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm2
    pxor         %xmm4, %xmm2
    pxor         %xmm1, %xmm3
    pxor         %xmm2, %xmm3
    pshufd       $(78), %xmm3, %xmm5
    pshufd       $(78), %xmm8, %xmm6
    pxor         %xmm3, %xmm5
    pxor         %xmm8, %xmm6
    pclmulqdq    $(0), %xmm6, %xmm5
    movdqa       %xmm3, %xmm4
    pclmulqdq    $(0), %xmm8, %xmm3
    pxor         %xmm6, %xmm6
    pclmulqdq    $(17), %xmm8, %xmm4
    pxor         %xmm3, %xmm5
    pxor         %xmm4, %xmm5
    palignr      $(8), %xmm5, %xmm6
    pslldq       $(8), %xmm5
    pxor         %xmm6, %xmm4
    pxor         %xmm5, %xmm3
    movdqa       %xmm3, %xmm6
    movdqa       %xmm3, %xmm5
    movdqa       %xmm3, %xmm15
    psllq        $(63), %xmm6
    psllq        $(62), %xmm5
    psllq        $(57), %xmm15
    pxor         %xmm5, %xmm6
    pxor         %xmm15, %xmm6
    movdqa       %xmm6, %xmm5
    pslldq       $(8), %xmm5
    psrldq       $(8), %xmm6
    pxor         %xmm5, %xmm3
    pxor         %xmm6, %xmm4
    movdqa       %xmm3, %xmm5
    psrlq        $(5), %xmm5
    pxor         %xmm3, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm3, %xmm5
    psrlq        $(1), %xmm5
    pxor         %xmm5, %xmm3
    pxor         %xmm4, %xmm3
    pxor         %xmm0, %xmm3
    movdqa       %xmm3, (32)(%rsp)
.Lsingle_block_procgas_4: 
    test         %rax, %rax
    jz           .Lquitgas_4
.p2align 5, 0x90
.Lblk_loopgas_4: 
    movdqa       (%rsp), %xmm0
    movdqa       %xmm0, %xmm1
    paddd        INC_1(%rip), %xmm1
    movdqa       %xmm1, (%rsp)
    movdqa       (%rcx), %xmm0
    mov          %rcx, %r10
    pshufb       SHUF_CONST(%rip), %xmm1
    pxor         %xmm0, %xmm1
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    mov          %r8d, %r11d
    sub          $(1), %r11
.p2align 5, 0x90
.Lcipher_loopgas_4: 
    aesenc       %xmm0, %xmm1
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher_loopgas_4
    aesenclast   %xmm0, %xmm1
    movdqa       (16)(%rsp), %xmm0
    movdqa       %xmm1, (16)(%rsp)
    movdqu       (%rsi), %xmm1
    add          $(16), %rsi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%rdi)
    add          $(16), %rdi
    pshufb       SHUF_CONST(%rip), %xmm0
    pxor         (32)(%rsp), %xmm0
    movdqa       (%rbx), %xmm1
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
    movdqa       %xmm0, %xmm4
    movdqa       %xmm0, %xmm15
    psllq        $(63), %xmm2
    psllq        $(62), %xmm4
    psllq        $(57), %xmm15
    pxor         %xmm4, %xmm2
    pxor         %xmm15, %xmm2
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
    movdqa       %xmm0, (32)(%rsp)
    sub          $(16), %rax
    jg           .Lblk_loopgas_4
.Lquitgas_4: 
    movdqa       (%rsp), %xmm0
    movdqa       (16)(%rsp), %xmm1
    movdqa       (32)(%rsp), %xmm2
    mov          (152)(%rsp), %rax
    mov          (160)(%rsp), %rbx
    mov          (144)(%rsp), %rcx
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqu       %xmm0, (%rax)
    movdqu       %xmm1, (%rbx)
    pshufb       SHUF_CONST(%rip), %xmm2
    movdqu       %xmm2, (%rcx)
    add          $(128), %rsp
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe4:
.size l9_AesGcmEnc_avx, .Lfe4-(l9_AesGcmEnc_avx)
.p2align 5, 0x90
 
.globl l9_AesGcmDec_avx
.type l9_AesGcmDec_avx, @function
 
l9_AesGcmDec_avx:
 
    push         %rbx
 
    sub          $(128), %rsp
 
    mov          (152)(%rsp), %rax
    mov          (160)(%rsp), %rbx
    mov          (144)(%rsp), %rcx
    movdqa       SHUF_CONST(%rip), %xmm4
    movdqu       (%rax), %xmm0
    movdqu       (%rbx), %xmm1
    movdqu       (%rcx), %xmm2
    pshufb       %xmm4, %xmm0
    movdqa       %xmm0, (%rsp)
    movdqa       %xmm1, (16)(%rsp)
    pshufb       %xmm4, %xmm2
    pxor         %xmm1, %xmm1
    movdqa       %xmm2, (32)(%rsp)
    movdqa       %xmm1, (48)(%rsp)
    movdqa       %xmm1, (64)(%rsp)
    movdqa       %xmm1, (80)(%rsp)
    mov          (168)(%rsp), %rbx
    movdqa       (32)(%rbx), %xmm10
    pshufd       $(78), %xmm10, %xmm9
    pxor         %xmm10, %xmm9
    movdqa       %xmm9, (96)(%rsp)
    movslq       %edx, %rdx
    mov          %r9, %rcx
    mov          %rdx, %rax
    and          $(63), %rax
    and          $(-64), %rdx
    jz           .Lsingle_block_procgas_5
.p2align 5, 0x90
.Lblks4_loopgas_5: 
    movdqa       INC_1(%rip), %xmm6
    movdqa       SHUF_CONST(%rip), %xmm5
    movdqa       %xmm0, %xmm1
    paddd        INC_1(%rip), %xmm1
    movdqa       %xmm1, %xmm2
    paddd        INC_1(%rip), %xmm2
    movdqa       %xmm2, %xmm3
    paddd        INC_1(%rip), %xmm3
    movdqa       %xmm3, %xmm4
    paddd        INC_1(%rip), %xmm4
    movdqa       %xmm4, (%rsp)
    movdqa       (%rcx), %xmm0
    mov          %rcx, %r10
    pshufb       %xmm5, %xmm1
    pshufb       %xmm5, %xmm2
    pshufb       %xmm5, %xmm3
    pshufb       %xmm5, %xmm4
    pxor         %xmm0, %xmm1
    pxor         %xmm0, %xmm2
    pxor         %xmm0, %xmm3
    pxor         %xmm0, %xmm4
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    mov          %r8d, %r11d
    sub          $(1), %r11
.p2align 5, 0x90
.Lcipher4_loopgas_5: 
    aesenc       %xmm0, %xmm1
    aesenc       %xmm0, %xmm2
    aesenc       %xmm0, %xmm3
    aesenc       %xmm0, %xmm4
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher4_loopgas_5
    aesenclast   %xmm0, %xmm1
    aesenclast   %xmm0, %xmm2
    aesenclast   %xmm0, %xmm3
    aesenclast   %xmm0, %xmm4
    movdqa       (16)(%rsp), %xmm0
    movdqa       %xmm4, (16)(%rsp)
    movdqu       (%rsi), %xmm4
    movdqu       (16)(%rsi), %xmm5
    movdqu       (32)(%rsi), %xmm6
    movdqu       (48)(%rsi), %xmm7
    add          $(64), %rsi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%rdi)
    pshufb       SHUF_CONST(%rip), %xmm4
    pxor         (32)(%rsp), %xmm4
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm5
    pxor         (48)(%rsp), %xmm5
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm6
    pxor         (64)(%rsp), %xmm6
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%rdi)
    pshufb       SHUF_CONST(%rip), %xmm7
    pxor         (80)(%rsp), %xmm7
    add          $(64), %rdi
    cmp          $(64), %rdx
    je           .Lcombine_hashgas_5
    movdqa       MASK1(%rip), %xmm14
    pshufd       $(78), %xmm4, %xmm2
    movdqa       %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pclmulqdq    $(0), %xmm10, %xmm4
    pshufd       $(78), %xmm5, %xmm13
    movdqa       %xmm5, %xmm12
    pxor         %xmm5, %xmm13
    pclmulqdq    $(17), %xmm10, %xmm1
    pclmulqdq    $(0), %xmm9, %xmm2
    pxor         %xmm4, %xmm2
    pxor         %xmm1, %xmm2
    pshufd       $(78), %xmm2, %xmm0
    movdqa       %xmm0, %xmm2
    pand         MASK2(%rip), %xmm0
    pand         %xmm14, %xmm2
    pxor         %xmm0, %xmm4
    pxor         %xmm2, %xmm1
    movdqa       %xmm4, %xmm0
    psllq        $(1), %xmm4
    pclmulqdq    $(0), %xmm10, %xmm5
    pxor         %xmm0, %xmm4
    psllq        $(5), %xmm4
    pxor         %xmm0, %xmm4
    psllq        $(57), %xmm4
    pshufd       $(78), %xmm4, %xmm2
    movdqa       %xmm2, %xmm4
    pclmulqdq    $(17), %xmm10, %xmm12
    pand         %xmm14, %xmm2
    pand         MASK2(%rip), %xmm4
    pxor         %xmm0, %xmm4
    pxor         %xmm2, %xmm1
    movdqa       %xmm4, %xmm2
    psrlq        $(5), %xmm4
    pclmulqdq    $(0), %xmm9, %xmm13
    pxor         %xmm2, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm2, %xmm4
    psrlq        $(1), %xmm4
    pxor         %xmm2, %xmm4
    pxor         %xmm1, %xmm4
    pxor         %xmm5, %xmm13
    pxor         %xmm12, %xmm13
    pshufd       $(78), %xmm13, %xmm11
    movdqa       %xmm11, %xmm13
    pand         MASK2(%rip), %xmm11
    pand         %xmm14, %xmm13
    pxor         %xmm11, %xmm5
    pxor         %xmm13, %xmm12
    movdqa       %xmm5, %xmm11
    movdqa       %xmm5, %xmm13
    movdqa       %xmm5, %xmm15
    psllq        $(63), %xmm11
    psllq        $(62), %xmm13
    psllq        $(57), %xmm15
    pxor         %xmm13, %xmm11
    pxor         %xmm15, %xmm11
    movdqa       %xmm11, %xmm13
    pslldq       $(8), %xmm13
    psrldq       $(8), %xmm11
    pxor         %xmm13, %xmm5
    pxor         %xmm11, %xmm12
    movdqa       %xmm5, %xmm13
    psrlq        $(5), %xmm13
    pxor         %xmm5, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm5, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm13, %xmm5
    pxor         %xmm12, %xmm5
    pshufd       $(78), %xmm6, %xmm2
    movdqa       %xmm6, %xmm1
    pxor         %xmm6, %xmm2
    pclmulqdq    $(0), %xmm10, %xmm6
    pshufd       $(78), %xmm7, %xmm13
    movdqa       %xmm7, %xmm12
    pxor         %xmm7, %xmm13
    pclmulqdq    $(17), %xmm10, %xmm1
    pclmulqdq    $(0), %xmm9, %xmm2
    pxor         %xmm6, %xmm2
    pxor         %xmm1, %xmm2
    pshufd       $(78), %xmm2, %xmm0
    movdqa       %xmm0, %xmm2
    pand         MASK2(%rip), %xmm0
    pand         %xmm14, %xmm2
    pxor         %xmm0, %xmm6
    pxor         %xmm2, %xmm1
    movdqa       %xmm6, %xmm0
    psllq        $(1), %xmm6
    pclmulqdq    $(0), %xmm10, %xmm7
    pxor         %xmm0, %xmm6
    psllq        $(5), %xmm6
    pxor         %xmm0, %xmm6
    psllq        $(57), %xmm6
    pshufd       $(78), %xmm6, %xmm2
    movdqa       %xmm2, %xmm6
    pclmulqdq    $(17), %xmm10, %xmm12
    pand         %xmm14, %xmm2
    pand         MASK2(%rip), %xmm6
    pxor         %xmm0, %xmm6
    pxor         %xmm2, %xmm1
    movdqa       %xmm6, %xmm2
    psrlq        $(5), %xmm6
    pclmulqdq    $(0), %xmm9, %xmm13
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm2, %xmm6
    psrlq        $(1), %xmm6
    pxor         %xmm2, %xmm6
    pxor         %xmm1, %xmm6
    pxor         %xmm7, %xmm13
    pxor         %xmm12, %xmm13
    pshufd       $(78), %xmm13, %xmm11
    movdqa       %xmm11, %xmm13
    pand         MASK2(%rip), %xmm11
    pand         %xmm14, %xmm13
    pxor         %xmm11, %xmm7
    pxor         %xmm13, %xmm12
    movdqa       %xmm7, %xmm11
    movdqa       %xmm7, %xmm13
    movdqa       %xmm7, %xmm15
    psllq        $(63), %xmm11
    psllq        $(62), %xmm13
    psllq        $(57), %xmm15
    pxor         %xmm13, %xmm11
    pxor         %xmm15, %xmm11
    movdqa       %xmm11, %xmm13
    pslldq       $(8), %xmm13
    psrldq       $(8), %xmm11
    pxor         %xmm13, %xmm7
    pxor         %xmm11, %xmm12
    movdqa       %xmm7, %xmm13
    psrlq        $(5), %xmm13
    pxor         %xmm7, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm7, %xmm13
    psrlq        $(1), %xmm13
    pxor         %xmm13, %xmm7
    pxor         %xmm12, %xmm7
    movdqa       %xmm4, (32)(%rsp)
    movdqa       %xmm5, (48)(%rsp)
    movdqa       %xmm6, (64)(%rsp)
    movdqa       %xmm7, (80)(%rsp)
    sub          $(64), %rdx
    movdqa       (%rsp), %xmm0
    cmp          $(64), %rdx
    jge          .Lblks4_loopgas_5
.Lcombine_hashgas_5: 
    movdqa       (%rbx), %xmm8
    movdqa       (16)(%rbx), %xmm9
    pshufd       $(78), %xmm4, %xmm2
    pshufd       $(78), %xmm10, %xmm0
    pxor         %xmm4, %xmm2
    pxor         %xmm10, %xmm0
    pclmulqdq    $(0), %xmm0, %xmm2
    movdqa       %xmm4, %xmm1
    pclmulqdq    $(0), %xmm10, %xmm4
    pxor         %xmm0, %xmm0
    pclmulqdq    $(17), %xmm10, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm1, %xmm2
    palignr      $(8), %xmm2, %xmm0
    pslldq       $(8), %xmm2
    pxor         %xmm0, %xmm1
    pxor         %xmm2, %xmm4
    movdqa       %xmm4, %xmm0
    movdqa       %xmm4, %xmm2
    movdqa       %xmm4, %xmm15
    psllq        $(63), %xmm0
    psllq        $(62), %xmm2
    psllq        $(57), %xmm15
    pxor         %xmm2, %xmm0
    pxor         %xmm15, %xmm0
    movdqa       %xmm0, %xmm2
    pslldq       $(8), %xmm2
    psrldq       $(8), %xmm0
    pxor         %xmm2, %xmm4
    pxor         %xmm0, %xmm1
    movdqa       %xmm4, %xmm2
    psrlq        $(5), %xmm2
    pxor         %xmm4, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm4, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm2, %xmm4
    pxor         %xmm1, %xmm4
    pshufd       $(78), %xmm5, %xmm2
    pshufd       $(78), %xmm9, %xmm0
    pxor         %xmm5, %xmm2
    pxor         %xmm9, %xmm0
    pclmulqdq    $(0), %xmm0, %xmm2
    movdqa       %xmm5, %xmm1
    pclmulqdq    $(0), %xmm9, %xmm5
    pxor         %xmm0, %xmm0
    pclmulqdq    $(17), %xmm9, %xmm1
    pxor         %xmm5, %xmm2
    pxor         %xmm1, %xmm2
    palignr      $(8), %xmm2, %xmm0
    pslldq       $(8), %xmm2
    pxor         %xmm0, %xmm1
    pxor         %xmm2, %xmm5
    movdqa       %xmm5, %xmm0
    movdqa       %xmm5, %xmm2
    movdqa       %xmm5, %xmm15
    psllq        $(63), %xmm0
    psllq        $(62), %xmm2
    psllq        $(57), %xmm15
    pxor         %xmm2, %xmm0
    pxor         %xmm15, %xmm0
    movdqa       %xmm0, %xmm2
    pslldq       $(8), %xmm2
    psrldq       $(8), %xmm0
    pxor         %xmm2, %xmm5
    pxor         %xmm0, %xmm1
    movdqa       %xmm5, %xmm2
    psrlq        $(5), %xmm2
    pxor         %xmm5, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm5, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm2, %xmm5
    pxor         %xmm1, %xmm5
    pshufd       $(78), %xmm6, %xmm2
    pshufd       $(78), %xmm8, %xmm0
    pxor         %xmm6, %xmm2
    pxor         %xmm8, %xmm0
    pclmulqdq    $(0), %xmm0, %xmm2
    movdqa       %xmm6, %xmm1
    pclmulqdq    $(0), %xmm8, %xmm6
    pxor         %xmm0, %xmm0
    pclmulqdq    $(17), %xmm8, %xmm1
    pxor         %xmm6, %xmm2
    pxor         %xmm1, %xmm2
    palignr      $(8), %xmm2, %xmm0
    pslldq       $(8), %xmm2
    pxor         %xmm0, %xmm1
    pxor         %xmm2, %xmm6
    movdqa       %xmm6, %xmm0
    movdqa       %xmm6, %xmm2
    movdqa       %xmm6, %xmm15
    psllq        $(63), %xmm0
    psllq        $(62), %xmm2
    psllq        $(57), %xmm15
    pxor         %xmm2, %xmm0
    pxor         %xmm15, %xmm0
    movdqa       %xmm0, %xmm2
    pslldq       $(8), %xmm2
    psrldq       $(8), %xmm0
    pxor         %xmm2, %xmm6
    pxor         %xmm0, %xmm1
    movdqa       %xmm6, %xmm2
    psrlq        $(5), %xmm2
    pxor         %xmm6, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm6, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm2, %xmm6
    pxor         %xmm1, %xmm6
    pxor         %xmm5, %xmm7
    pxor         %xmm6, %xmm7
    pshufd       $(78), %xmm7, %xmm2
    pshufd       $(78), %xmm8, %xmm0
    pxor         %xmm7, %xmm2
    pxor         %xmm8, %xmm0
    pclmulqdq    $(0), %xmm0, %xmm2
    movdqa       %xmm7, %xmm1
    pclmulqdq    $(0), %xmm8, %xmm7
    pxor         %xmm0, %xmm0
    pclmulqdq    $(17), %xmm8, %xmm1
    pxor         %xmm7, %xmm2
    pxor         %xmm1, %xmm2
    palignr      $(8), %xmm2, %xmm0
    pslldq       $(8), %xmm2
    pxor         %xmm0, %xmm1
    pxor         %xmm2, %xmm7
    movdqa       %xmm7, %xmm0
    movdqa       %xmm7, %xmm2
    movdqa       %xmm7, %xmm15
    psllq        $(63), %xmm0
    psllq        $(62), %xmm2
    psllq        $(57), %xmm15
    pxor         %xmm2, %xmm0
    pxor         %xmm15, %xmm0
    movdqa       %xmm0, %xmm2
    pslldq       $(8), %xmm2
    psrldq       $(8), %xmm0
    pxor         %xmm2, %xmm7
    pxor         %xmm0, %xmm1
    movdqa       %xmm7, %xmm2
    psrlq        $(5), %xmm2
    pxor         %xmm7, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm7, %xmm2
    psrlq        $(1), %xmm2
    pxor         %xmm2, %xmm7
    pxor         %xmm1, %xmm7
    pxor         %xmm4, %xmm7
    movdqa       %xmm7, (32)(%rsp)
.Lsingle_block_procgas_5: 
    test         %rax, %rax
    jz           .Lquitgas_5
.p2align 5, 0x90
.Lblk_loopgas_5: 
    movdqa       (%rsp), %xmm0
    movdqa       %xmm0, %xmm1
    paddd        INC_1(%rip), %xmm1
    movdqa       %xmm1, (%rsp)
    movdqa       (%rcx), %xmm0
    mov          %rcx, %r10
    pshufb       SHUF_CONST(%rip), %xmm1
    pxor         %xmm0, %xmm1
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    mov          %r8d, %r11d
    sub          $(1), %r11
.p2align 5, 0x90
.Lcipher_loopgas_5: 
    aesenc       %xmm0, %xmm1
    movdqa       (16)(%r10), %xmm0
    add          $(16), %r10
    dec          %r11
    jnz          .Lcipher_loopgas_5
    aesenclast   %xmm0, %xmm1
    movdqa       (16)(%rsp), %xmm0
    movdqa       %xmm1, (16)(%rsp)
    movdqu       (%rsi), %xmm1
    add          $(16), %rsi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%rdi)
    add          $(16), %rdi
    pshufb       SHUF_CONST(%rip), %xmm1
    pxor         (32)(%rsp), %xmm1
    movdqa       (%rbx), %xmm0
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
    movdqa       %xmm1, %xmm4
    movdqa       %xmm1, %xmm15
    psllq        $(63), %xmm2
    psllq        $(62), %xmm4
    psllq        $(57), %xmm15
    pxor         %xmm4, %xmm2
    pxor         %xmm15, %xmm2
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
    movdqa       %xmm1, (32)(%rsp)
    sub          $(16), %rax
    jg           .Lblk_loopgas_5
.Lquitgas_5: 
    movdqa       (%rsp), %xmm0
    movdqa       (16)(%rsp), %xmm1
    movdqa       (32)(%rsp), %xmm2
    mov          (152)(%rsp), %rax
    mov          (160)(%rsp), %rbx
    mov          (144)(%rsp), %rcx
    pshufb       SHUF_CONST(%rip), %xmm0
    movdqu       %xmm0, (%rax)
    movdqu       %xmm1, (%rbx)
    pshufb       SHUF_CONST(%rip), %xmm2
    movdqu       %xmm2, (%rcx)
    add          $(128), %rsp
vzeroupper 
 
    pop          %rbx
 
    ret
.Lfe5:
.size l9_AesGcmDec_avx, .Lfe5-(l9_AesGcmDec_avx)
 
