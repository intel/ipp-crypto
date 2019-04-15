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
 
.globl _g9_EncryptCFB_RIJ128_AES_NI

 
_g9_EncryptCFB_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(144), %esp
    movl         (32)(%ebp), %eax
    movdqu       (%eax), %xmm4
    movdqu       %xmm4, (%esp)
.Lblks_loopgas_1: 
    movl         (8)(%ebp), %esi
    movl         (28)(%ebp), %edx
    lea          (,%edx,4), %ebx
    movl         (24)(%ebp), %edx
    cmp          %ebx, %edx
    cmovl        %edx, %ebx
    xor          %ecx, %ecx
.L__0000gas_1: 
    movb         (%esi,%ecx), %dl
    movb         %dl, (80)(%esp,%ecx)
    add          $(1), %ecx
    cmp          %ebx, %ecx
    jl           .L__0000gas_1
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %edx
    lea          (,%edx,4), %eax
    lea          (-144)(%ecx,%eax,4), %eax
    xor          %esi, %esi
    mov          %ebx, %edi
.Lsingle_blkgas_1: 
    movdqu       (%esp,%esi), %xmm0
    pxor         (%ecx), %xmm0
    cmp          $(12), %edx
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%eax), %xmm0
    aesenc       (-48)(%eax), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%eax), %xmm0
    aesenc       (-16)(%eax), %xmm0
.Lkey_128_sgas_1: 
    aesenc       (%eax), %xmm0
    aesenc       (16)(%eax), %xmm0
    aesenc       (32)(%eax), %xmm0
    aesenc       (48)(%eax), %xmm0
    aesenc       (64)(%eax), %xmm0
    aesenc       (80)(%eax), %xmm0
    aesenc       (96)(%eax), %xmm0
    aesenc       (112)(%eax), %xmm0
    aesenc       (128)(%eax), %xmm0
    aesenclast   (144)(%eax), %xmm0
    movdqu       (80)(%esp,%esi), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (16)(%esp,%esi)
    addl         (28)(%ebp), %esi
    subl         (28)(%ebp), %edi
    jg           .Lsingle_blkgas_1
    movl         (12)(%ebp), %edi
    xor          %ecx, %ecx
.L__0001gas_1: 
    movb         (16)(%esp,%ecx), %dl
    movb         %dl, (%edi,%ecx)
    add          $(1), %ecx
    cmp          %ebx, %ecx
    jl           .L__0001gas_1
    movdqu       (%esp,%ebx), %xmm0
    movdqu       %xmm0, (%esp)
    addl         %ebx, (8)(%ebp)
    addl         %ebx, (12)(%ebp)
    subl         %ebx, (24)(%ebp)
    jg           .Lblks_loopgas_1
    add          $(144), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _g9_EncryptCFB32_RIJ128_AES_NI

 
_g9_EncryptCFB32_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(144), %esp
    movl         (32)(%ebp), %eax
    movdqu       (%eax), %xmm4
    movdqu       %xmm4, (%esp)
.Lblks_loopgas_2: 
    movl         (8)(%ebp), %esi
    movl         (28)(%ebp), %edx
    lea          (,%edx,4), %ebx
    movl         (24)(%ebp), %edx
    cmp          %ebx, %edx
    cmovl        %edx, %ebx
    xor          %ecx, %ecx
.L__0002gas_2: 
    movl         (%esi,%ecx), %edx
    movl         %edx, (80)(%esp,%ecx)
    add          $(4), %ecx
    cmp          %ebx, %ecx
    jl           .L__0002gas_2
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %edx
    lea          (,%edx,4), %eax
    lea          (-144)(%ecx,%eax,4), %eax
    xor          %esi, %esi
    mov          %ebx, %edi
.Lsingle_blkgas_2: 
    movdqu       (%esp,%esi), %xmm0
    pxor         (%ecx), %xmm0
    cmp          $(12), %edx
    jl           .Lkey_128_sgas_2
    jz           .Lkey_192_sgas_2
.Lkey_256_sgas_2: 
    aesenc       (-64)(%eax), %xmm0
    aesenc       (-48)(%eax), %xmm0
.Lkey_192_sgas_2: 
    aesenc       (-32)(%eax), %xmm0
    aesenc       (-16)(%eax), %xmm0
.Lkey_128_sgas_2: 
    aesenc       (%eax), %xmm0
    aesenc       (16)(%eax), %xmm0
    aesenc       (32)(%eax), %xmm0
    aesenc       (48)(%eax), %xmm0
    aesenc       (64)(%eax), %xmm0
    aesenc       (80)(%eax), %xmm0
    aesenc       (96)(%eax), %xmm0
    aesenc       (112)(%eax), %xmm0
    aesenc       (128)(%eax), %xmm0
    aesenclast   (144)(%eax), %xmm0
    movdqu       (80)(%esp,%esi), %xmm1
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (16)(%esp,%esi)
    addl         (28)(%ebp), %esi
    subl         (28)(%ebp), %edi
    jg           .Lsingle_blkgas_2
    movl         (12)(%ebp), %edi
    xor          %ecx, %ecx
.L__0003gas_2: 
    movl         (16)(%esp,%ecx), %edx
    movl         %edx, (%edi,%ecx)
    add          $(4), %ecx
    cmp          %ebx, %ecx
    jl           .L__0003gas_2
    movdqu       (%esp,%ebx), %xmm0
    movdqu       %xmm0, (%esp)
    addl         %ebx, (8)(%ebp)
    addl         %ebx, (12)(%ebp)
    subl         %ebx, (24)(%ebp)
    jg           .Lblks_loopgas_2
    add          $(144), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _g9_EncryptCFB128_RIJ128_AES_NI

 
_g9_EncryptCFB128_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (28)(%ebp), %eax
    movdqu       (%eax), %xmm0
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (24)(%ebp), %ebx
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %edx
    lea          (,%edx,4), %eax
    lea          (-144)(%ecx,%eax,4), %eax
.Lblks_loopgas_3: 
    pxor         (%ecx), %xmm0
    movdqu       (%esi), %xmm1
    cmp          $(12), %edx
    jl           .Lkey_128_sgas_3
    jz           .Lkey_192_sgas_3
.Lkey_256_sgas_3: 
    aesenc       (-64)(%eax), %xmm0
    aesenc       (-48)(%eax), %xmm0
.Lkey_192_sgas_3: 
    aesenc       (-32)(%eax), %xmm0
    aesenc       (-16)(%eax), %xmm0
.Lkey_128_sgas_3: 
    aesenc       (%eax), %xmm0
    aesenc       (16)(%eax), %xmm0
    aesenc       (32)(%eax), %xmm0
    aesenc       (48)(%eax), %xmm0
    aesenc       (64)(%eax), %xmm0
    aesenc       (80)(%eax), %xmm0
    aesenc       (96)(%eax), %xmm0
    aesenc       (112)(%eax), %xmm0
    aesenc       (128)(%eax), %xmm0
    aesenclast   (144)(%eax), %xmm0
    pxor         %xmm1, %xmm0
    movdqu       %xmm0, (%edi)
    add          $(16), %esi
    add          $(16), %edi
    sub          $(16), %ebx
    jg           .Lblks_loopgas_3
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
