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

 
 .section .note.GNU-stack,"",%progbits 
 
.text
.p2align 4, 0x90
 
.globl p8_GCMreduce
.type p8_GCMreduce, @function
 
p8_GCMreduce:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %esi
    movdqu       (%esi), %xmm3
    movdqu       (16)(%esi), %xmm6
    movl         (12)(%ebp), %esi
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
    movdqu       %xmm6, (%esi)
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe1:
.size p8_GCMreduce, .Lfe1-(p8_GCMreduce)
 
