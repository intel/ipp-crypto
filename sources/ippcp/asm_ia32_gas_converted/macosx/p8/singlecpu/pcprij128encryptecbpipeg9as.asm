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
 
.globl _EncryptECB_RIJ128pipe_AES_NI

 
_EncryptECB_RIJ128pipe_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %esi
    movl         (12)(%ebp), %edi
    movl         (20)(%ebp), %ecx
    movl         (24)(%ebp), %edx
    sub          $(64), %edx
    jl           .Lshort_inputgas_1
.Lblks_loopgas_1: 
    movdqa       (%ecx), %xmm4
    lea          (16)(%ecx), %ebx
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    add          $(64), %esi
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
    movdqu       %xmm0, (%edi)
    aesenclast   %xmm4, %xmm1
    movdqu       %xmm1, (16)(%edi)
    aesenclast   %xmm4, %xmm2
    movdqu       %xmm2, (32)(%edi)
    aesenclast   %xmm4, %xmm3
    movdqu       %xmm3, (48)(%edi)
    add          $(64), %edi
    sub          $(64), %edx
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    add          $(64), %edx
    jz           .Lquitgas_1
    movl         (16)(%ebp), %eax
    lea          (,%eax,4), %ebx
    lea          (-144)(%ecx,%ebx,4), %ebx
.Lsingle_blk_loopgas_1: 
    movdqu       (%esi), %xmm0
    add          $(16), %esi
    pxor         (%ecx), %xmm0
    cmp          $(12), %eax
    jl           .Lkey_128_sgas_1
    jz           .Lkey_192_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%ebx), %xmm0
    aesenc       (-48)(%ebx), %xmm0
.Lkey_192_sgas_1: 
    aesenc       (-32)(%ebx), %xmm0
    aesenc       (-16)(%ebx), %xmm0
.Lkey_128_sgas_1: 
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
    movdqu       %xmm0, (%edi)
    add          $(16), %edi
    sub          $(16), %edx
    jnz          .Lsingle_blk_loopgas_1
.Lquitgas_1: 
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
