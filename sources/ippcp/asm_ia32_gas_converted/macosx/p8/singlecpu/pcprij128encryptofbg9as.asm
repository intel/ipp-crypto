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
 
.globl _EncryptOFB_RIJ128_AES_NI

 
_EncryptOFB_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    sub          $(164), %esp
    movl         (32)(%ebp), %eax
    movdqu       (%eax), %xmm0
    movdqu       %xmm0, (%esp)
    movl         (16)(%ebp), %eax
    movl         (20)(%ebp), %ecx
    lea          (,%eax,4), %eax
    lea          (,%eax,4), %eax
    lea          (%ecx,%eax), %ecx
    neg          %eax
    movl         %eax, (16)(%ebp)
    movl         %ecx, (20)(%ebp)
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (28)(%ebp), %ebx
.p2align 4, 0x90
.Lblks_loopgas_1: 
    lea          (,%ebx,4), %ebx
    cmpl         %ebx, (24)(%ebp)
    cmovll       (24)(%ebp), %ebx
    xor          %ecx, %ecx
.L__0000gas_1: 
    movb         (%esi,%ecx), %dl
    movb         %dl, (96)(%esp,%ecx)
    add          $(1), %ecx
    cmp          %ebx, %ecx
    jl           .L__0000gas_1
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %eax
    movl         %ebx, (160)(%esp)
    xor          %edx, %edx
.p2align 4, 0x90
.Lsingle_blkgas_1: 
    movdqa       (%ecx,%eax), %xmm3
    add          $(16), %eax
    movdqa       (%ecx,%eax), %xmm4
    pxor         %xmm3, %xmm0
.p2align 4, 0x90
.Lcipher_loopgas_1: 
    add          $(16), %eax
    aesenc       %xmm4, %xmm0
    movdqa       (%ecx,%eax), %xmm4
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm4, %xmm0
    movdqu       %xmm0, (16)(%esp)
    movl         (28)(%ebp), %eax
    movdqu       (96)(%esp,%edx), %xmm1
    pxor         %xmm0, %xmm1
    movdqu       %xmm1, (32)(%esp,%edx)
    movdqu       (%esp,%eax), %xmm0
    movdqu       %xmm0, (%esp)
    add          %eax, %edx
    movl         (16)(%ebp), %eax
    cmp          %ebx, %edx
    jl           .Lsingle_blkgas_1
    xor          %ecx, %ecx
.L__0001gas_1: 
    movb         (32)(%esp,%ecx), %bl
    movb         %bl, (%edi,%ecx)
    add          $(1), %ecx
    cmp          %edx, %ecx
    jl           .L__0001gas_1
    movl         (28)(%ebp), %ebx
    add          %edx, %esi
    add          %edx, %edi
    subl         %edx, (24)(%ebp)
    jg           .Lblks_loopgas_1
    movl         (32)(%ebp), %eax
    movdqu       (%esp), %xmm0
    movdqu       %xmm0, (%eax)
    add          $(164), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
.p2align 4, 0x90
 
.globl _EncryptOFB128_RIJ128_AES_NI

 
_EncryptOFB128_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (28)(%ebp), %eax
    movdqu       (%eax), %xmm0
    movl         (16)(%ebp), %eax
    movl         (20)(%ebp), %ecx
    lea          (,%eax,4), %eax
    lea          (,%eax,4), %eax
    lea          (%ecx,%eax), %ecx
    neg          %eax
    movl         %eax, (16)(%ebp)
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (24)(%ebp), %edx
.p2align 4, 0x90
.Lblks_loopgas_2: 
    movdqa       (%ecx,%eax), %xmm3
    add          $(16), %eax
.p2align 4, 0x90
.Lsingle_blkgas_2: 
    movdqa       (%ecx,%eax), %xmm4
    pxor         %xmm3, %xmm0
    movdqu       (%esi), %xmm1
.p2align 4, 0x90
.Lcipher_loopgas_2: 
    add          $(16), %eax
    aesenc       %xmm4, %xmm0
    movdqa       (%ecx,%eax), %xmm4
    jnz          .Lcipher_loopgas_2
    aesenclast   %xmm4, %xmm0
    pxor         %xmm0, %xmm1
    movdqu       %xmm1, (%edi)
    movl         (16)(%ebp), %eax
    add          $(16), %esi
    add          $(16), %edi
    sub          $(16), %edx
    jg           .Lblks_loopgas_2
    movl         (28)(%ebp), %eax
    movdqu       %xmm0, (%eax)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
 
