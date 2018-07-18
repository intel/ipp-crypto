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
 
.globl _p8_cpAESEncryptXTS_AES_NI

 
_p8_cpAESEncryptXTS_AES_NI:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %esi
    movl         (8)(%ebp), %edi
 
    mov          %esp, %eax
    sub          $(88), %esp
    and          $(-16), %esp
    movl         %eax, (84)(%esp)
    movl         (28)(%ebp), %eax
    movdqu       (%eax), %xmm4
    movdqa       %xmm4, %xmm7
    mov          $(135), %eax
    mov          $(1), %ecx
    movd         %eax, %xmm0
    movd         %ecx, %xmm1
    punpcklqdq   %xmm1, %xmm0
    movl         (20)(%ebp), %ecx
    movl         (16)(%ebp), %edx
    movl         (24)(%ebp), %eax
    movdqa       %xmm0, (%esp)
    movl         %eax, (80)(%esp)
    sub          $(4), %edx
    jl           .Lshort_inputgas_1
    jmp          .Lblks_loop_epgas_1
.Lblks_loopgas_1: 
    pxor         %xmm1, %xmm1
    movdqa       %xmm7, %xmm4
    pcmpgtq      %xmm7, %xmm1
    paddq        %xmm4, %xmm4
    palignr      $(8), %xmm1, %xmm1
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm4
.Lblks_loop_epgas_1: 
    movdqa       %xmm4, (16)(%esp)
    pxor         %xmm1, %xmm1
    movdqa       %xmm4, %xmm5
    pcmpgtq      %xmm4, %xmm1
    paddq        %xmm5, %xmm5
    palignr      $(8), %xmm1, %xmm1
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm5
    movdqa       %xmm5, (32)(%esp)
    pxor         %xmm1, %xmm1
    movdqa       %xmm5, %xmm6
    pcmpgtq      %xmm5, %xmm1
    paddq        %xmm6, %xmm6
    palignr      $(8), %xmm1, %xmm1
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm6
    movdqa       %xmm6, (48)(%esp)
    pxor         %xmm1, %xmm1
    movdqa       %xmm6, %xmm7
    pcmpgtq      %xmm6, %xmm1
    paddq        %xmm7, %xmm7
    palignr      $(8), %xmm1, %xmm1
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm7
    movdqa       %xmm7, (64)(%esp)
    movdqu       (%esi), %xmm0
    movdqu       (16)(%esi), %xmm1
    movdqu       (32)(%esi), %xmm2
    movdqu       (48)(%esi), %xmm3
    add          $(64), %esi
    pxor         %xmm4, %xmm0
    pxor         %xmm5, %xmm1
    pxor         %xmm6, %xmm2
    pxor         %xmm7, %xmm3
    movdqa       (%ecx), %xmm4
    lea          (16)(%ecx), %ebx
    pxor         %xmm4, %xmm0
    pxor         %xmm4, %xmm1
    pxor         %xmm4, %xmm2
    pxor         %xmm4, %xmm3
    movdqa       (%ebx), %xmm4
    add          $(16), %ebx
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
    movdqa       (16)(%esp), %xmm4
    movdqa       (32)(%esp), %xmm5
    movdqa       (48)(%esp), %xmm6
    movdqa       (64)(%esp), %xmm7
    pxor         %xmm4, %xmm0
    pxor         %xmm5, %xmm1
    pxor         %xmm6, %xmm2
    pxor         %xmm7, %xmm3
    movdqu       %xmm0, (%edi)
    movdqu       %xmm1, (16)(%edi)
    movdqu       %xmm2, (32)(%edi)
    movdqu       %xmm3, (48)(%edi)
    add          $(64), %edi
    movdqa       (%esp), %xmm0
    movl         (80)(%esp), %eax
    sub          $(4), %edx
    jge          .Lblks_loopgas_1
.Lshort_inputgas_1: 
    add          $(4), %edx
    jz           .Lquitgas_1
    movl         (80)(%esp), %eax
    lea          (,%eax,4), %ebx
    lea          (-144)(%ecx,%ebx,4), %ebx
    jmp          .Lsingle_blk_loop_epgas_1
.Lsingle_blk_loopgas_1: 
    pxor         %xmm1, %xmm1
    movdqa       %xmm7, %xmm7
    pcmpgtq      %xmm7, %xmm1
    paddq        %xmm7, %xmm7
    palignr      $(8), %xmm1, %xmm1
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm7
.Lsingle_blk_loop_epgas_1: 
    movdqu       (%esi), %xmm1
    add          $(16), %esi
    pxor         %xmm7, %xmm1
    pxor         (%ecx), %xmm1
    cmp          $(12), %eax
    jl           .Lkey_128_sgas_1
.Lkey_256_sgas_1: 
    aesenc       (-64)(%ebx), %xmm1
    aesenc       (-48)(%ebx), %xmm1
    aesenc       (-32)(%ebx), %xmm1
    aesenc       (-16)(%ebx), %xmm1
.Lkey_128_sgas_1: 
    aesenc       (%ebx), %xmm1
    aesenc       (16)(%ebx), %xmm1
    aesenc       (32)(%ebx), %xmm1
    aesenc       (48)(%ebx), %xmm1
    aesenc       (64)(%ebx), %xmm1
    aesenc       (80)(%ebx), %xmm1
    aesenc       (96)(%ebx), %xmm1
    aesenc       (112)(%ebx), %xmm1
    aesenc       (128)(%ebx), %xmm1
    aesenclast   (144)(%ebx), %xmm1
    pxor         %xmm7, %xmm1
    movdqu       %xmm1, (%edi)
    add          $(16), %edi
    sub          $(1), %edx
    jnz          .Lsingle_blk_loopgas_1
.Lquitgas_1: 
    movl         (28)(%ebp), %eax
    movdqu       %xmm7, (%eax)
    mov          (84)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
