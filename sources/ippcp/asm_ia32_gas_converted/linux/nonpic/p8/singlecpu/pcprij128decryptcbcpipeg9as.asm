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
.p2align 4, 0x90
 
.globl DecryptCBC_RIJ128pipe_AES_NI
.type DecryptCBC_RIJ128pipe_AES_NI, @function
 
DecryptCBC_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %eax
    sub          $(96), %esp
    lea          (16)(%esp), %edx
    and          $(-16), %edx
    movl         (28)(%ebp), %ebx
    movdqu       (%ebx), %xmm4
    movdqa       %xmm4, (%edx)
    subl         $(64), (24)(%ebp)
    jl           .Lshort_inputgas_1
    lea          (,%eax,4), %ebx
    lea          (%ecx,%ebx,4), %ecx
.Lblks_loopgas_1: 
    movdqa       (%ecx), %xmm4
    lea          (-16)(%ecx), %ebx
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    movdqa       %xmm0, (16)(%edx)
    movdqa       %xmm1, (32)(%edx)
    movdqa       %xmm2, (48)(%edx)
    movdqa       %xmm3, (64)(%edx)
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    sub          $(16), %ebx
    movl         (16)(%ebp), %eax
    sub          $(1), %eax
.Lcipher_loopgas_1: 
    aesdec       %xmm4, %xmm0
    aesdec       %xmm4, %xmm1
    aesdec       %xmm4, %xmm2
    aesdec       %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    sub          $(16), %ebx
    dec          %eax
    jnz          .Lcipher_loopgas_1
    aesdeclast   %xmm4, %xmm0
    pxor         (%edx), %xmm0
    movdqu       %xmm0, (%edi)
    aesdeclast   %xmm4, %xmm1
    pxor         (16)(%edx), %xmm1
    movdqu       %xmm1, (16)(%edi)
    aesdeclast   %xmm4, %xmm2
    pxor         (32)(%edx), %xmm2
    movdqu       %xmm2, (32)(%edi)
    aesdeclast   %xmm4, %xmm3
    pxor         (48)(%edx), %xmm3
    movdqu       %xmm3, (48)(%edi)
    movdqa       (64)(%edx), %xmm4
    movdqa       %xmm4, (%edx)
    add          $(64), %esi
    add          $(64), %edi
    subl         $(64), (24)(%ebp)
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    addl         $(64), (24)(%ebp)
    jz           .Lquitgas_1
    movl         (16)(%ebp), %eax
    movl         (20)(%ebp), %ecx
    lea          (,%eax,4), %ebx
    lea          (%ecx,%ebx,4), %ebx
.Lsingle_blk_loopgas_1: 
    movdqu       (%esi), %xmm0
    movdqa       %xmm0, (16)(%edx)
    pxor         (%ebx), %xmm0
    cmp          $(12), %eax
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesdec       (208)(%ecx), %xmm0
    aesdec       (192)(%ecx), %xmm0
.Lkey_192_sgas_1: 
    aesdec       (176)(%ecx), %xmm0
    aesdec       (160)(%ecx), %xmm0
.Lkey_128_sgas_1: 
    aesdec       (144)(%ecx), %xmm0
    aesdec       (128)(%ecx), %xmm0
    aesdec       (112)(%ecx), %xmm0
    aesdec       (96)(%ecx), %xmm0
    aesdec       (80)(%ecx), %xmm0
    aesdec       (64)(%ecx), %xmm0
    aesdec       (48)(%ecx), %xmm0
    aesdec       (32)(%ecx), %xmm0
    aesdec       (16)(%ecx), %xmm0
    aesdeclast   (%ecx), %xmm0
    pxor         (%edx), %xmm0
    movdqu       %xmm0, (%edi)
    movdqa       (16)(%edx), %xmm4
    movdqa       %xmm4, (%edx)
    add          $(16), %esi
    add          $(16), %edi
    subl         $(16), (24)(%ebp)
    jnz          .Lsingle_blk_loopgas_1
.Lquitgas_1: 
    add          $(96), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
.Lfe1:
.size DecryptCBC_RIJ128pipe_AES_NI, .Lfe1-(DecryptCBC_RIJ128pipe_AES_NI)
 
