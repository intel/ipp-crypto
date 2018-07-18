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
CONST_TABLE: 
 
_u128_str:
.byte  15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0 
.p2align 5, 0x90
 
.globl _GCMmul_avx

 
_GCMmul_avx:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (12)(%ebp), %edi
    movl         (8)(%ebp), %esi
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %eax
    sub          $(.L__0000gas_1-CONST_TABLE), %eax
    movdqu       (%edi), %xmm1
    movdqu       (%esi), %xmm0
    pshufb       ((_u128_str-CONST_TABLE))(%eax), %xmm1
    pshufd       $(78), %xmm0, %xmm4
    pshufd       $(78), %xmm1, %xmm5
    pxor         %xmm0, %xmm4
    pxor         %xmm1, %xmm5
    pclmulqdq    $(0), %xmm5, %xmm4
    movdqu       %xmm0, %xmm3
    pclmulqdq    $(0), %xmm1, %xmm3
    movdqu       %xmm0, %xmm6
    pclmulqdq    $(17), %xmm1, %xmm6
    pxor         %xmm5, %xmm5
    pxor         %xmm3, %xmm4
    pxor         %xmm6, %xmm4
    palignr      $(8), %xmm4, %xmm5
    pslldq       $(8), %xmm4
    pxor         %xmm4, %xmm3
    pxor         %xmm5, %xmm6
    movdqu       %xmm3, %xmm4
    movdqu       %xmm6, %xmm5
    pslld        $(1), %xmm3
    pslld        $(1), %xmm6
    psrld        $(31), %xmm4
    psrld        $(31), %xmm5
    palignr      $(12), %xmm4, %xmm5
    pslldq       $(4), %xmm4
    por          %xmm4, %xmm3
    por          %xmm5, %xmm6
    movdqu       %xmm3, %xmm0
    movdqu       %xmm3, %xmm1
    movdqu       %xmm3, %xmm2
    pslld        $(31), %xmm0
    pslld        $(30), %xmm1
    pslld        $(25), %xmm2
    pxor         %xmm1, %xmm0
    pxor         %xmm2, %xmm0
    movdqu       %xmm0, %xmm1
    pslldq       $(12), %xmm0
    pxor         %xmm0, %xmm3
    movdqu       %xmm3, %xmm2
    movdqu       %xmm3, %xmm4
    movdqu       %xmm3, %xmm5
    psrldq       $(4), %xmm1
    psrld        $(1), %xmm2
    psrld        $(2), %xmm4
    psrld        $(7), %xmm5
    pxor         %xmm4, %xmm2
    pxor         %xmm5, %xmm2
    pxor         %xmm1, %xmm2
    pxor         %xmm2, %xmm3
    pxor         %xmm3, %xmm6
    pshufb       ((_u128_str-CONST_TABLE))(%eax), %xmm6
    movdqu       %xmm6, (%edi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
 
