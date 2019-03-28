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
ENCODE_DATA: 
 
u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
 
increment:
.quad  1,0 
.p2align 5, 0x90
 
.globl g9_AuthEncrypt_RIJ128_AES_NI
.type g9_AuthEncrypt_RIJ128_AES_NI, @function
 
g9_AuthEncrypt_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (28)(%ebp), %eax
    movdqa       (%eax), %xmm0
    movdqa       (16)(%eax), %xmm2
    movdqa       (32)(%eax), %xmm1
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %eax
    sub          $(.L__0000gas_1-ENCODE_DATA), %eax
    movdqa       ((u128_str-ENCODE_DATA))(%eax), %xmm7
    pshufb       %xmm7, %xmm2
    pshufb       %xmm7, %xmm1
    movdqa       %xmm1, %xmm3
    pandn        %xmm2, %xmm3
    pand         %xmm1, %xmm2
    movl         (16)(%ebp), %edx
    movl         (20)(%ebp), %ecx
    lea          (,%edx,4), %edx
    lea          (,%edx,4), %edx
    lea          (%edx,%ecx), %ecx
    neg          %edx
    mov          %edx, %ebx
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
.p2align 5, 0x90
.Lblk_loopgas_1: 
    movdqu       (%esi), %xmm4
    pxor         %xmm4, %xmm0
    movdqa       %xmm3, %xmm5
    paddq        ((increment-ENCODE_DATA))(%eax), %xmm2
    pand         %xmm1, %xmm2
    por          %xmm2, %xmm5
    pshufb       %xmm7, %xmm5
    movdqa       (%edx,%ecx), %xmm6
    add          $(16), %edx
    pxor         %xmm6, %xmm5
    pxor         %xmm6, %xmm0
    movdqa       (%edx,%ecx), %xmm6
.p2align 5, 0x90
.Lcipher_loopgas_1: 
    aesenc       %xmm6, %xmm5
    aesenc       %xmm6, %xmm0
    movdqa       (16)(%edx,%ecx), %xmm6
    add          $(16), %edx
    jnz          .Lcipher_loopgas_1
    aesenclast   %xmm6, %xmm5
    aesenclast   %xmm6, %xmm0
    pxor         %xmm5, %xmm4
    movdqu       %xmm4, (%edi)
    mov          %ebx, %edx
    add          $(16), %esi
    add          $(16), %edi
    subl         $(16), (24)(%ebp)
    jnz          .Lblk_loopgas_1
    movl         (28)(%ebp), %eax
    movdqu       %xmm0, (%eax)
    movdqu       %xmm5, (16)(%eax)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size g9_AuthEncrypt_RIJ128_AES_NI, .Lfe1-(g9_AuthEncrypt_RIJ128_AES_NI)
.p2align 5, 0x90
 
.globl g9_DecryptAuth_RIJ128_AES_NI
.type g9_DecryptAuth_RIJ128_AES_NI, @function
 
g9_DecryptAuth_RIJ128_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (28)(%ebp), %eax
    movdqa       (%eax), %xmm0
    movdqa       (16)(%eax), %xmm2
    movdqa       (32)(%eax), %xmm1
    call         .L__0001gas_2
.L__0001gas_2:
    pop          %eax
    sub          $(.L__0001gas_2-ENCODE_DATA), %eax
    movdqa       ((u128_str-ENCODE_DATA))(%eax), %xmm7
    pshufb       %xmm7, %xmm2
    pshufb       %xmm7, %xmm1
    movdqa       %xmm1, %xmm3
    pandn        %xmm2, %xmm3
    pand         %xmm1, %xmm2
    movl         (16)(%ebp), %edx
    movl         (20)(%ebp), %ecx
    lea          (,%edx,4), %edx
    lea          (,%edx,4), %edx
    lea          (%edx,%ecx), %ecx
    neg          %edx
    mov          %edx, %ebx
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
.p2align 5, 0x90
.Lblk_loopgas_2: 
    movdqu       (%esi), %xmm4
    movdqa       %xmm3, %xmm5
    paddq        ((increment-ENCODE_DATA))(%eax), %xmm2
    pand         %xmm1, %xmm2
    por          %xmm2, %xmm5
    pshufb       %xmm7, %xmm5
    movdqa       (%edx,%ecx), %xmm6
    add          $(16), %edx
    pxor         %xmm6, %xmm5
    movdqa       (%edx,%ecx), %xmm6
.p2align 5, 0x90
.Lcipher_loopgas_2: 
    aesenc       %xmm6, %xmm5
    movdqa       (16)(%edx,%ecx), %xmm6
    add          $(16), %edx
    jnz          .Lcipher_loopgas_2
    aesenclast   %xmm6, %xmm5
    pxor         %xmm5, %xmm4
    movdqu       %xmm4, (%edi)
    mov          %ebx, %edx
    movdqa       (%edx,%ecx), %xmm6
    add          $(16), %edx
    pxor         %xmm4, %xmm0
    pxor         %xmm6, %xmm0
    movdqa       (%edx,%ecx), %xmm6
.p2align 5, 0x90
.Lauth_loopgas_2: 
    aesenc       %xmm6, %xmm0
    movdqa       (16)(%edx,%ecx), %xmm6
    add          $(16), %edx
    jnz          .Lauth_loopgas_2
    aesenclast   %xmm6, %xmm0
    mov          %ebx, %edx
    add          $(16), %esi
    add          $(16), %edi
    subl         $(16), (24)(%ebp)
    jnz          .Lblk_loopgas_2
    movl         (28)(%ebp), %eax
    movdqu       %xmm0, (%eax)
    movdqu       %xmm6, (16)(%eax)
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe2:
.size g9_DecryptAuth_RIJ128_AES_NI, .Lfe2-(g9_DecryptAuth_RIJ128_AES_NI)
 
