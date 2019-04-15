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
.p2align 6, 0x90
 
.globl n0_Encrypt_RIJ128_AES_NI
.type n0_Encrypt_RIJ128_AES_NI, @function
 
n0_Encrypt_RIJ128_AES_NI:
 
    movdqu       (%rdi), %xmm0
    pxor         (%rcx), %xmm0
    lea          (,%rdx,4), %rax
    lea          (-144)(%rcx,%rax,4), %rcx
    cmp          $(12), %rdx
    jl           .Lkey_128gas_1
    jz           .Lkey_192gas_1
.Lkey_256gas_1: 
    aesenc       (-64)(%rcx), %xmm0
    aesenc       (-48)(%rcx), %xmm0
.Lkey_192gas_1: 
    aesenc       (-32)(%rcx), %xmm0
    aesenc       (-16)(%rcx), %xmm0
.Lkey_128gas_1: 
    aesenc       (%rcx), %xmm0
    aesenc       (16)(%rcx), %xmm0
    aesenc       (32)(%rcx), %xmm0
    aesenc       (48)(%rcx), %xmm0
    aesenc       (64)(%rcx), %xmm0
    aesenc       (80)(%rcx), %xmm0
    aesenc       (96)(%rcx), %xmm0
    aesenc       (112)(%rcx), %xmm0
    aesenc       (128)(%rcx), %xmm0
    aesenclast   (144)(%rcx), %xmm0
    movdqu       %xmm0, (%rsi)
 
    ret
.Lfe1:
.size n0_Encrypt_RIJ128_AES_NI, .Lfe1-(n0_Encrypt_RIJ128_AES_NI)
 
