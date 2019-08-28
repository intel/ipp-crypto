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
 
.globl _DecryptCFB_RIJ128pipe_AES_NI

 
_DecryptCFB_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(144), %esp
    movl         (32)(%ebp), %eax
    movdqu       (%eax), %xmm4
    movdqu       %xmm4, (%esp)
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (28)(%ebp), %edx
    subl         $(4), (24)(%ebp)
    jl           .Lshort_inputgas_1
.Lblks_loopgas_1: 
    lea          (,%edx,4), %eax
    xor          %ecx, %ecx
.L__0000gas_1: 
    movl         (%esi,%ecx), %ebx
    movl         %ebx, (16)(%esp,%ecx)
    add          $(4), %ecx
    cmp          %eax, %ecx
    jl           .L__0000gas_1
    movl         (20)(%ebp), %ecx
    movdqa       (%ecx), %xmm4
    lea          (%edx,%edx,2), %ebx
    movdqu       (%esp), %xmm0
    movdqu       (%esp,%edx), %xmm1
    movdqu       (%esp,%edx,2), %xmm2
    movdqu       (%esp,%ebx), %xmm3
    lea          (16)(%ecx), %ebx
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    add          $(16), %ebx
    movl         (16)(%ebp), %eax
    sub          $(1), %eax
.Lcipher_loopgas_1: 
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    add          $(16), %ebx
    dec          %eax
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm4, %xmm0
    aesenclast   %xmm4, %xmm1
    aesenclast   %xmm4, %xmm2
    aesenclast   %xmm4, %xmm3
    lea          (%edx,%edx,2), %ebx
    movdqu       (16)(%esp), %xmm4
    movdqu       (16)(%esp,%edx), %xmm5
    movdqu       (16)(%esp,%edx,2), %xmm6
    movdqu       (16)(%esp,%ebx), %xmm7
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (80)(%esp)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (80)(%esp,%edx)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (80)(%esp,%edx,2)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (80)(%esp,%ebx)
    lea          (,%edx,4), %eax
    xor          %ecx, %ecx
.L__0001gas_1: 
    movl         (80)(%esp,%ecx), %ebx
    movl         %ebx, (%edi,%ecx)
    add          $(4), %ecx
    cmp          %eax, %ecx
    jl           .L__0001gas_1
    movdqu       (%esp,%eax), %xmm0
    movdqu       %xmm0, (%esp)
    add          %eax, %esi
    add          %eax, %edi
    subl         $(4), (24)(%ebp)
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    addl         $(4), (24)(%ebp)
    jz           .Lquitgas_1
    lea          (,%edx,2), %ebx
    lea          (%edx,%edx,2), %ecx
    cmpl         $(2), (24)(%ebp)
    cmovl        %edx, %ebx
    cmovg        %ecx, %ebx
    xor          %ecx, %ecx
.L__0002gas_1: 
    movb         (%esi,%ecx), %al
    movb         %al, (16)(%esp,%ecx)
    add          $(1), %ecx
    cmp          %ebx, %ecx
    jl           .L__0002gas_1
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %eax
    lea          (,%eax,4), %esi
    lea          (-144)(%ecx,%esi,4), %esi
    xor          %eax, %eax
.Lsingle_blk_loopgas_1: 
    movdqu       (%esp,%eax), %xmm0
    pxor         (%ecx), %xmm0
    cmpl         $(12), (16)(%ebp)
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%esi), %xmm0
    aesenc       (-48)(%esi), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%esi), %xmm0
    aesenc       (-16)(%esi), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%esi), %xmm0
    aesenc       (16)(%esi), %xmm0
    aesenc       (32)(%esi), %xmm0
    aesenc       (48)(%esi), %xmm0
    aesenc       (64)(%esi), %xmm0
    aesenc       (80)(%esi), %xmm0
    aesenc       (96)(%esi), %xmm0
    aesenc       (112)(%esi), %xmm0
    aesenc       (128)(%esi), %xmm0
    aesenclast   (144)(%esi), %xmm0
    movdqu       (16)(%esp,%eax), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (80)(%esp,%eax)
    add          %edx, %eax
    decl         (24)(%ebp)
    jnz          .Lsingle_blk_loopgas_1
    xor          %ecx, %ecx
.L__0003gas_1: 
    movb         (80)(%esp,%ecx), %al
    movb         %al, (%edi,%ecx)
    add          $(1), %ecx
    cmp          %ebx, %ecx
    jl           .L__0003gas_1
.Lquitgas_1: 
    add          $(144), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _DecryptCFB32_RIJ128pipe_AES_NI

 
_DecryptCFB32_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(144), %esp
    movl         (32)(%ebp), %eax
    movdqu       (%eax), %xmm4
    movdqu       %xmm4, (%esp)
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (28)(%ebp), %edx
    subl         $(4), (24)(%ebp)
    jl           .Lshort_inputgas_2
.Lblks_loopgas_2: 
    lea          (,%edx,4), %eax
    xor          %ecx, %ecx
.L__0004gas_2: 
    movdqu       (%esi,%ecx), %xmm0
    movdqu       %xmm0, (16)(%esp,%ecx)
    add          $(16), %ecx
    cmp          %eax, %ecx
    jl           .L__0004gas_2
    movl         (20)(%ebp), %ecx
    movdqa       (%ecx), %xmm4
    lea          (%edx,%edx,2), %ebx
    movdqu       (%esp), %xmm0
    movdqu       (%esp,%edx), %xmm1
    movdqu       (%esp,%edx,2), %xmm2
    movdqu       (%esp,%ebx), %xmm3
    lea          (16)(%ecx), %ebx
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    add          $(16), %ebx
    movl         (16)(%ebp), %eax
    sub          $(1), %eax
.Lcipher_loopgas_2: 
    aesenc       %xmm4, %xmm0
    aesenc       %xmm4, %xmm1
    aesenc       %xmm4, %xmm2
    aesenc       %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    add          $(16), %ebx
    dec          %eax
    jnz          .Lcipher_loopgas_2
    aesenclast   %xmm4, %xmm0
    aesenclast   %xmm4, %xmm1
    aesenclast   %xmm4, %xmm2
    aesenclast   %xmm4, %xmm3
    lea          (%edx,%edx,2), %ebx
    movdqu       (16)(%esp), %xmm4
    movdqu       (16)(%esp,%edx), %xmm5
    movdqu       (16)(%esp,%edx,2), %xmm6
    movdqu       (16)(%esp,%ebx), %xmm7
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (80)(%esp)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (80)(%esp,%edx)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (80)(%esp,%edx,2)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (80)(%esp,%ebx)
    lea          (,%edx,4), %eax
    xor          %ecx, %ecx
.L__0005gas_2: 
    movdqu       (80)(%esp,%ecx), %xmm0
    movdqu       %xmm0, (%edi,%ecx)
    add          $(16), %ecx
    cmp          %eax, %ecx
    jl           .L__0005gas_2
    movdqu       (%esp,%eax), %xmm0
    movdqu       %xmm0, (%esp)
    add          %eax, %esi
    add          %eax, %edi
    subl         $(4), (24)(%ebp)
    jge          .Lblks_loopgas_2
.Lshort_inputgas_2: 
    addl         $(4), (24)(%ebp)
    jz           .Lquitgas_2
    lea          (,%edx,2), %ebx
    lea          (%edx,%edx,2), %ecx
    cmpl         $(2), (24)(%ebp)
    cmovl        %edx, %ebx
    cmovg        %ecx, %ebx
    xor          %ecx, %ecx
.L__0006gas_2: 
    movl         (%esi,%ecx), %eax
    movl         %eax, (16)(%esp,%ecx)
    add          $(4), %ecx
    cmp          %ebx, %ecx
    jl           .L__0006gas_2
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %eax
    lea          (,%eax,4), %esi
    lea          (-144)(%ecx,%esi,4), %esi
    xor          %eax, %eax
.Lsingle_blk_loopgas_2: 
    movdqu       (%esp,%eax), %xmm0
    pxor         (%ecx), %xmm0
    cmpl         $(12), (16)(%ebp)
    jl           .Lkey_128_sgas_2
    jz           .Lkey_192_sgas_2
.Lkey_256_sgas_2: 
    aesenc       (-64)(%esi), %xmm0
    aesenc       (-48)(%esi), %xmm0
.Lkey_192_sgas_2: 
    aesenc       (-32)(%esi), %xmm0
    aesenc       (-16)(%esi), %xmm0
.Lkey_128_sgas_2: 
    aesenc       (%esi), %xmm0
    aesenc       (16)(%esi), %xmm0
    aesenc       (32)(%esi), %xmm0
    aesenc       (48)(%esi), %xmm0
    aesenc       (64)(%esi), %xmm0
    aesenc       (80)(%esi), %xmm0
    aesenc       (96)(%esi), %xmm0
    aesenc       (112)(%esi), %xmm0
    aesenc       (128)(%esi), %xmm0
    aesenclast   (144)(%esi), %xmm0
    movdqu       (16)(%esp,%eax), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (80)(%esp,%eax)
    add          %edx, %eax
    decl         (24)(%ebp)
    jnz          .Lsingle_blk_loopgas_2
    xor          %ecx, %ecx
.L__0007gas_2: 
    movl         (80)(%esp,%ecx), %eax
    movl         %eax, (%edi,%ecx)
    add          $(4), %ecx
    cmp          %ebx, %ecx
    jl           .L__0007gas_2
.Lquitgas_2: 
    add          $(144), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _DecryptCFB128_RIJ128pipe_AES_NI

 
_DecryptCFB128_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (20)(%ebp), %ecx
    movl         (24)(%ebp), %edx
    movl         (28)(%ebp), %eax
    movdqu       (%eax), %xmm0
    sub          $(64), %edx
    jl           .Lshort_inputgas_3
.Lblks_loopgas_3: 
    movdqa       (%ecx), %xmm7
    lea          (16)(%ecx), %ebx
    movdqu       (%esi), %xmm1
    movdqu       (16)(%esi), %xmm2
    movdqu       (32)(%esi), %xmm3
    pxor         %xmm7, %xmm0
    pxor         %xmm7, %xmm1
    pxor         %xmm7, %xmm2
    pxor         %xmm7, %xmm3
    movdqa       (%ebx), %xmm7
    add          $(16), %ebx
    movl         (16)(%ebp), %eax
    sub          $(1), %eax
.Lcipher_loopgas_3: 
    aesenc       %xmm7, %xmm0
    aesenc       %xmm7, %xmm1
    aesenc       %xmm7, %xmm2
    aesenc       %xmm7, %xmm3
    movdqa       (%ebx), %xmm7
    add          $(16), %ebx
    dec          %eax
    jnz          .Lcipher_loopgas_3
    aesenclast   %xmm7, %xmm0
    movdqu       (%esi), %xmm4
    aesenclast   %xmm7, %xmm1
    movdqu       (16)(%esi), %xmm5
    aesenclast   %xmm7, %xmm2
    movdqu       (32)(%esi), %xmm6
    aesenclast   %xmm7, %xmm3
    movdqu       (48)(%esi), %xmm7
    add          $(64), %esi
    pxor         %xmm4, %xmm0
    movdqu       %xmm0, (%edi)
    pxor         %xmm5, %xmm1
    movdqu       %xmm1, (16)(%edi)
    pxor         %xmm6, %xmm2
    movdqu       %xmm2, (32)(%edi)
    pxor         %xmm7, %xmm3
    movdqu       %xmm3, (48)(%edi)
    add          $(64), %edi
    movdqa       %xmm7, %xmm0
    sub          $(64), %edx
    jge          .Lblks_loopgas_3
.Lshort_inputgas_3: 
    add          $(64), %edx
    jz           .Lquitgas_3
    movl         (16)(%ebp), %eax
    lea          (,%eax,4), %ebx
    lea          (-144)(%ecx,%ebx,4), %ebx
.Lsingle_blk_loopgas_3: 
    pxor         (%ecx), %xmm0
    cmp          $(12), %eax
    jl           .Lkey_128_sgas_3
    jz           .Lkey_192_sgas_3
.Lkey_256_sgas_3: 
    aesenc       (-64)(%ebx), %xmm0
    aesenc       (-48)(%ebx), %xmm0
.Lkey_192_sgas_3: 
    aesenc       (-32)(%ebx), %xmm0
    aesenc       (-16)(%ebx), %xmm0
.Lkey_128_sgas_3: 
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
    movdqu       (%esi), %xmm1
    add          $(16), %esi
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    movdqa       %xmm1, %xmm0
    sub          $(16), %edx
    jnz          .Lsingle_blk_loopgas_3
.Lquitgas_3: 
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
