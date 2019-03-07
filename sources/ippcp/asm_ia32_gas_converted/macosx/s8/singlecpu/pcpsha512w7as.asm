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
.p2align 4, 0x90
SWP_BYTE: 
 
pByteSwp:
.byte  7,6,5,4,3,2,1,0, 15,14,13,12,11,10,9,8 
.p2align 4, 0x90
 
.globl _UpdateSHA512

 
_UpdateSHA512:
    push         %ebp
    mov          %esp, %ebp
    push         %esi
    push         %edi
 
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %eax
    movl         (20)(%ebp), %edx
    sub          $(852), %esp
    mov          %esp, %ecx
    and          $(-16), %esp
    sub          %esp, %ecx
    add          $(852), %ecx
    mov          %ecx, (848)(%esp)
    movq         (%edi), %xmm0
    movq         (8)(%edi), %xmm1
    movq         (16)(%edi), %xmm2
    movq         (24)(%edi), %xmm3
    movq         (32)(%edi), %xmm4
    movq         (40)(%edi), %xmm5
    movq         (48)(%edi), %xmm6
    movq         (56)(%edi), %xmm7
    movdqa       %xmm0, (80)(%esp)
    movdqa       %xmm1, (96)(%esp)
    movdqa       %xmm2, (112)(%esp)
    movdqa       %xmm3, (128)(%esp)
    movdqa       %xmm4, (144)(%esp)
    movdqa       %xmm5, (160)(%esp)
    movdqa       %xmm6, (176)(%esp)
    movdqa       %xmm7, (192)(%esp)
.Lsha512_block_loopgas_1: 
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %ecx
    sub          $(.L__0000gas_1-SWP_BYTE), %ecx
    movdqa       ((pByteSwp-SWP_BYTE))(%ecx), %xmm1
    mov          $(0), %ecx
.p2align 4, 0x90
.Lloop1gas_1: 
    movdqu       (%esi,%ecx,8), %xmm0
    pshufb       %xmm1, %xmm0
    movdqa       %xmm0, (208)(%esp,%ecx,8)
    add          $(2), %ecx
    cmp          $(16), %ecx
    jl           .Lloop1gas_1
.p2align 4, 0x90
.Lloop2gas_1: 
    movdqa       (192)(%esp,%ecx,8), %xmm1
    movdqa       %xmm1, %xmm0
    psrlq        $(6), %xmm1
    movdqa       %xmm0, %xmm2
    movdqa       %xmm0, %xmm3
    psrlq        $(19), %xmm0
    psllq        $(45), %xmm3
    por          %xmm3, %xmm0
    pxor         %xmm1, %xmm0
    movdqa       %xmm2, %xmm3
    psrlq        $(61), %xmm2
    psllq        $(3), %xmm3
    por          %xmm3, %xmm2
    pxor         %xmm2, %xmm0
    movdqu       (88)(%esp,%ecx,8), %xmm5
    movdqa       %xmm5, %xmm4
    psrlq        $(7), %xmm5
    movdqa       %xmm4, %xmm6
    movdqa       %xmm4, %xmm3
    psrlq        $(1), %xmm4
    psllq        $(63), %xmm3
    por          %xmm3, %xmm4
    pxor         %xmm5, %xmm4
    movdqa       %xmm6, %xmm3
    psrlq        $(8), %xmm6
    psllq        $(56), %xmm3
    por          %xmm3, %xmm6
    pxor         %xmm6, %xmm4
    movdqu       (152)(%esp,%ecx,8), %xmm7
    paddq        %xmm4, %xmm0
    paddq        (80)(%esp,%ecx,8), %xmm7
    paddq        %xmm7, %xmm0
    movdqa       %xmm0, (208)(%esp,%ecx,8)
    add          $(2), %ecx
    cmp          $(80), %ecx
    jl           .Lloop2gas_1
    movdqa       (80)(%esp), %xmm0
    movdqa       (96)(%esp), %xmm1
    movdqa       (112)(%esp), %xmm2
    movdqa       (128)(%esp), %xmm3
    movdqa       (144)(%esp), %xmm4
    movdqa       (160)(%esp), %xmm5
    movdqa       (176)(%esp), %xmm6
    movdqa       (192)(%esp), %xmm7
    xor          %ecx, %ecx
.p2align 4, 0x90
.Lloop3gas_1: 
    movdqa       %xmm4, (%esp)
    movdqa       %xmm0, (16)(%esp)
    movdqa       %xmm3, (32)(%esp)
    movdqa       %xmm7, (48)(%esp)
    movdqa       %xmm5, %xmm3
    pxor         %xmm6, %xmm3
    pand         %xmm4, %xmm3
    pxor         %xmm6, %xmm3
    movq         (208)(%esp,%ecx,8), %xmm7
    paddq        %xmm7, %xmm3
    movq         (%edx,%ecx,8), %xmm7
    paddq        %xmm7, %xmm3
    paddq        (48)(%esp), %xmm3
    movdqa       %xmm3, (48)(%esp)
    movdqa       %xmm1, %xmm3
    movdqa       %xmm0, %xmm7
    pxor         %xmm0, %xmm3
    pand         %xmm1, %xmm7
    pand         %xmm2, %xmm3
    pxor         %xmm3, %xmm7
    movdqa       %xmm7, (64)(%esp)
    movdqa       %xmm4, %xmm3
    movdqa       %xmm3, %xmm7
    psrlq        $(14), %xmm3
    psllq        $(50), %xmm7
    por          %xmm7, %xmm3
    movdqa       %xmm4, %xmm7
    psrlq        $(18), %xmm4
    psllq        $(46), %xmm7
    por          %xmm7, %xmm4
    pxor         %xmm4, %xmm3
    movdqa       %xmm4, %xmm7
    psrlq        $(23), %xmm4
    psllq        $(41), %xmm7
    por          %xmm7, %xmm4
    pxor         %xmm4, %xmm3
    paddq        (48)(%esp), %xmm3
    movdqa       %xmm0, %xmm7
    movdqa       %xmm7, %xmm4
    psrlq        $(28), %xmm7
    psllq        $(36), %xmm4
    por          %xmm4, %xmm7
    movdqa       %xmm0, %xmm4
    psrlq        $(34), %xmm0
    psllq        $(30), %xmm4
    por          %xmm4, %xmm0
    pxor         %xmm0, %xmm7
    movdqa       %xmm0, %xmm4
    psrlq        $(5), %xmm0
    psllq        $(59), %xmm4
    por          %xmm4, %xmm0
    pxor         %xmm0, %xmm7
    paddq        (64)(%esp), %xmm7
    paddq        %xmm3, %xmm7
    paddq        (32)(%esp), %xmm3
    movdqa       (%esp), %xmm4
    movdqa       (16)(%esp), %xmm0
    movdqa       %xmm3, (%esp)
    movdqa       %xmm7, (16)(%esp)
    movdqa       %xmm2, (32)(%esp)
    movdqa       %xmm6, (48)(%esp)
    movdqa       %xmm4, %xmm2
    pxor         %xmm5, %xmm2
    pand         %xmm3, %xmm2
    pxor         %xmm5, %xmm2
    movq         (216)(%esp,%ecx,8), %xmm6
    paddq        %xmm6, %xmm2
    movq         (8)(%edx,%ecx,8), %xmm6
    paddq        %xmm6, %xmm2
    paddq        (48)(%esp), %xmm2
    movdqa       %xmm2, (48)(%esp)
    movdqa       %xmm0, %xmm2
    movdqa       %xmm7, %xmm6
    pxor         %xmm7, %xmm2
    pand         %xmm0, %xmm6
    pand         %xmm1, %xmm2
    pxor         %xmm2, %xmm6
    movdqa       %xmm6, (64)(%esp)
    movdqa       %xmm3, %xmm2
    movdqa       %xmm2, %xmm6
    psrlq        $(14), %xmm2
    psllq        $(50), %xmm6
    por          %xmm6, %xmm2
    movdqa       %xmm3, %xmm6
    psrlq        $(18), %xmm3
    psllq        $(46), %xmm6
    por          %xmm6, %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm3, %xmm6
    psrlq        $(23), %xmm3
    psllq        $(41), %xmm6
    por          %xmm6, %xmm3
    pxor         %xmm3, %xmm2
    paddq        (48)(%esp), %xmm2
    movdqa       %xmm7, %xmm6
    movdqa       %xmm6, %xmm3
    psrlq        $(28), %xmm6
    psllq        $(36), %xmm3
    por          %xmm3, %xmm6
    movdqa       %xmm7, %xmm3
    psrlq        $(34), %xmm7
    psllq        $(30), %xmm3
    por          %xmm3, %xmm7
    pxor         %xmm7, %xmm6
    movdqa       %xmm7, %xmm3
    psrlq        $(5), %xmm7
    psllq        $(59), %xmm3
    por          %xmm3, %xmm7
    pxor         %xmm7, %xmm6
    paddq        (64)(%esp), %xmm6
    paddq        %xmm2, %xmm6
    paddq        (32)(%esp), %xmm2
    movdqa       (%esp), %xmm3
    movdqa       (16)(%esp), %xmm7
    movdqa       %xmm2, (%esp)
    movdqa       %xmm6, (16)(%esp)
    movdqa       %xmm1, (32)(%esp)
    movdqa       %xmm5, (48)(%esp)
    movdqa       %xmm3, %xmm1
    pxor         %xmm4, %xmm1
    pand         %xmm2, %xmm1
    pxor         %xmm4, %xmm1
    movq         (224)(%esp,%ecx,8), %xmm5
    paddq        %xmm5, %xmm1
    movq         (16)(%edx,%ecx,8), %xmm5
    paddq        %xmm5, %xmm1
    paddq        (48)(%esp), %xmm1
    movdqa       %xmm1, (48)(%esp)
    movdqa       %xmm7, %xmm1
    movdqa       %xmm6, %xmm5
    pxor         %xmm6, %xmm1
    pand         %xmm7, %xmm5
    pand         %xmm0, %xmm1
    pxor         %xmm1, %xmm5
    movdqa       %xmm5, (64)(%esp)
    movdqa       %xmm2, %xmm1
    movdqa       %xmm1, %xmm5
    psrlq        $(14), %xmm1
    psllq        $(50), %xmm5
    por          %xmm5, %xmm1
    movdqa       %xmm2, %xmm5
    psrlq        $(18), %xmm2
    psllq        $(46), %xmm5
    por          %xmm5, %xmm2
    pxor         %xmm2, %xmm1
    movdqa       %xmm2, %xmm5
    psrlq        $(23), %xmm2
    psllq        $(41), %xmm5
    por          %xmm5, %xmm2
    pxor         %xmm2, %xmm1
    paddq        (48)(%esp), %xmm1
    movdqa       %xmm6, %xmm5
    movdqa       %xmm5, %xmm2
    psrlq        $(28), %xmm5
    psllq        $(36), %xmm2
    por          %xmm2, %xmm5
    movdqa       %xmm6, %xmm2
    psrlq        $(34), %xmm6
    psllq        $(30), %xmm2
    por          %xmm2, %xmm6
    pxor         %xmm6, %xmm5
    movdqa       %xmm6, %xmm2
    psrlq        $(5), %xmm6
    psllq        $(59), %xmm2
    por          %xmm2, %xmm6
    pxor         %xmm6, %xmm5
    paddq        (64)(%esp), %xmm5
    paddq        %xmm1, %xmm5
    paddq        (32)(%esp), %xmm1
    movdqa       (%esp), %xmm2
    movdqa       (16)(%esp), %xmm6
    movdqa       %xmm1, (%esp)
    movdqa       %xmm5, (16)(%esp)
    movdqa       %xmm0, (32)(%esp)
    movdqa       %xmm4, (48)(%esp)
    movdqa       %xmm2, %xmm0
    pxor         %xmm3, %xmm0
    pand         %xmm1, %xmm0
    pxor         %xmm3, %xmm0
    movq         (232)(%esp,%ecx,8), %xmm4
    paddq        %xmm4, %xmm0
    movq         (24)(%edx,%ecx,8), %xmm4
    paddq        %xmm4, %xmm0
    paddq        (48)(%esp), %xmm0
    movdqa       %xmm0, (48)(%esp)
    movdqa       %xmm6, %xmm0
    movdqa       %xmm5, %xmm4
    pxor         %xmm5, %xmm0
    pand         %xmm6, %xmm4
    pand         %xmm7, %xmm0
    pxor         %xmm0, %xmm4
    movdqa       %xmm4, (64)(%esp)
    movdqa       %xmm1, %xmm0
    movdqa       %xmm0, %xmm4
    psrlq        $(14), %xmm0
    psllq        $(50), %xmm4
    por          %xmm4, %xmm0
    movdqa       %xmm1, %xmm4
    psrlq        $(18), %xmm1
    psllq        $(46), %xmm4
    por          %xmm4, %xmm1
    pxor         %xmm1, %xmm0
    movdqa       %xmm1, %xmm4
    psrlq        $(23), %xmm1
    psllq        $(41), %xmm4
    por          %xmm4, %xmm1
    pxor         %xmm1, %xmm0
    paddq        (48)(%esp), %xmm0
    movdqa       %xmm5, %xmm4
    movdqa       %xmm4, %xmm1
    psrlq        $(28), %xmm4
    psllq        $(36), %xmm1
    por          %xmm1, %xmm4
    movdqa       %xmm5, %xmm1
    psrlq        $(34), %xmm5
    psllq        $(30), %xmm1
    por          %xmm1, %xmm5
    pxor         %xmm5, %xmm4
    movdqa       %xmm5, %xmm1
    psrlq        $(5), %xmm5
    psllq        $(59), %xmm1
    por          %xmm1, %xmm5
    pxor         %xmm5, %xmm4
    paddq        (64)(%esp), %xmm4
    paddq        %xmm0, %xmm4
    paddq        (32)(%esp), %xmm0
    movdqa       (%esp), %xmm1
    movdqa       (16)(%esp), %xmm5
    movdqa       %xmm0, (%esp)
    movdqa       %xmm4, (16)(%esp)
    movdqa       %xmm7, (32)(%esp)
    movdqa       %xmm3, (48)(%esp)
    movdqa       %xmm1, %xmm7
    pxor         %xmm2, %xmm7
    pand         %xmm0, %xmm7
    pxor         %xmm2, %xmm7
    movq         (240)(%esp,%ecx,8), %xmm3
    paddq        %xmm3, %xmm7
    movq         (32)(%edx,%ecx,8), %xmm3
    paddq        %xmm3, %xmm7
    paddq        (48)(%esp), %xmm7
    movdqa       %xmm7, (48)(%esp)
    movdqa       %xmm5, %xmm7
    movdqa       %xmm4, %xmm3
    pxor         %xmm4, %xmm7
    pand         %xmm5, %xmm3
    pand         %xmm6, %xmm7
    pxor         %xmm7, %xmm3
    movdqa       %xmm3, (64)(%esp)
    movdqa       %xmm0, %xmm7
    movdqa       %xmm7, %xmm3
    psrlq        $(14), %xmm7
    psllq        $(50), %xmm3
    por          %xmm3, %xmm7
    movdqa       %xmm0, %xmm3
    psrlq        $(18), %xmm0
    psllq        $(46), %xmm3
    por          %xmm3, %xmm0
    pxor         %xmm0, %xmm7
    movdqa       %xmm0, %xmm3
    psrlq        $(23), %xmm0
    psllq        $(41), %xmm3
    por          %xmm3, %xmm0
    pxor         %xmm0, %xmm7
    paddq        (48)(%esp), %xmm7
    movdqa       %xmm4, %xmm3
    movdqa       %xmm3, %xmm0
    psrlq        $(28), %xmm3
    psllq        $(36), %xmm0
    por          %xmm0, %xmm3
    movdqa       %xmm4, %xmm0
    psrlq        $(34), %xmm4
    psllq        $(30), %xmm0
    por          %xmm0, %xmm4
    pxor         %xmm4, %xmm3
    movdqa       %xmm4, %xmm0
    psrlq        $(5), %xmm4
    psllq        $(59), %xmm0
    por          %xmm0, %xmm4
    pxor         %xmm4, %xmm3
    paddq        (64)(%esp), %xmm3
    paddq        %xmm7, %xmm3
    paddq        (32)(%esp), %xmm7
    movdqa       (%esp), %xmm0
    movdqa       (16)(%esp), %xmm4
    movdqa       %xmm7, (%esp)
    movdqa       %xmm3, (16)(%esp)
    movdqa       %xmm6, (32)(%esp)
    movdqa       %xmm2, (48)(%esp)
    movdqa       %xmm0, %xmm6
    pxor         %xmm1, %xmm6
    pand         %xmm7, %xmm6
    pxor         %xmm1, %xmm6
    movq         (248)(%esp,%ecx,8), %xmm2
    paddq        %xmm2, %xmm6
    movq         (40)(%edx,%ecx,8), %xmm2
    paddq        %xmm2, %xmm6
    paddq        (48)(%esp), %xmm6
    movdqa       %xmm6, (48)(%esp)
    movdqa       %xmm4, %xmm6
    movdqa       %xmm3, %xmm2
    pxor         %xmm3, %xmm6
    pand         %xmm4, %xmm2
    pand         %xmm5, %xmm6
    pxor         %xmm6, %xmm2
    movdqa       %xmm2, (64)(%esp)
    movdqa       %xmm7, %xmm6
    movdqa       %xmm6, %xmm2
    psrlq        $(14), %xmm6
    psllq        $(50), %xmm2
    por          %xmm2, %xmm6
    movdqa       %xmm7, %xmm2
    psrlq        $(18), %xmm7
    psllq        $(46), %xmm2
    por          %xmm2, %xmm7
    pxor         %xmm7, %xmm6
    movdqa       %xmm7, %xmm2
    psrlq        $(23), %xmm7
    psllq        $(41), %xmm2
    por          %xmm2, %xmm7
    pxor         %xmm7, %xmm6
    paddq        (48)(%esp), %xmm6
    movdqa       %xmm3, %xmm2
    movdqa       %xmm2, %xmm7
    psrlq        $(28), %xmm2
    psllq        $(36), %xmm7
    por          %xmm7, %xmm2
    movdqa       %xmm3, %xmm7
    psrlq        $(34), %xmm3
    psllq        $(30), %xmm7
    por          %xmm7, %xmm3
    pxor         %xmm3, %xmm2
    movdqa       %xmm3, %xmm7
    psrlq        $(5), %xmm3
    psllq        $(59), %xmm7
    por          %xmm7, %xmm3
    pxor         %xmm3, %xmm2
    paddq        (64)(%esp), %xmm2
    paddq        %xmm6, %xmm2
    paddq        (32)(%esp), %xmm6
    movdqa       (%esp), %xmm7
    movdqa       (16)(%esp), %xmm3
    movdqa       %xmm6, (%esp)
    movdqa       %xmm2, (16)(%esp)
    movdqa       %xmm5, (32)(%esp)
    movdqa       %xmm1, (48)(%esp)
    movdqa       %xmm7, %xmm5
    pxor         %xmm0, %xmm5
    pand         %xmm6, %xmm5
    pxor         %xmm0, %xmm5
    movq         (256)(%esp,%ecx,8), %xmm1
    paddq        %xmm1, %xmm5
    movq         (48)(%edx,%ecx,8), %xmm1
    paddq        %xmm1, %xmm5
    paddq        (48)(%esp), %xmm5
    movdqa       %xmm5, (48)(%esp)
    movdqa       %xmm3, %xmm5
    movdqa       %xmm2, %xmm1
    pxor         %xmm2, %xmm5
    pand         %xmm3, %xmm1
    pand         %xmm4, %xmm5
    pxor         %xmm5, %xmm1
    movdqa       %xmm1, (64)(%esp)
    movdqa       %xmm6, %xmm5
    movdqa       %xmm5, %xmm1
    psrlq        $(14), %xmm5
    psllq        $(50), %xmm1
    por          %xmm1, %xmm5
    movdqa       %xmm6, %xmm1
    psrlq        $(18), %xmm6
    psllq        $(46), %xmm1
    por          %xmm1, %xmm6
    pxor         %xmm6, %xmm5
    movdqa       %xmm6, %xmm1
    psrlq        $(23), %xmm6
    psllq        $(41), %xmm1
    por          %xmm1, %xmm6
    pxor         %xmm6, %xmm5
    paddq        (48)(%esp), %xmm5
    movdqa       %xmm2, %xmm1
    movdqa       %xmm1, %xmm6
    psrlq        $(28), %xmm1
    psllq        $(36), %xmm6
    por          %xmm6, %xmm1
    movdqa       %xmm2, %xmm6
    psrlq        $(34), %xmm2
    psllq        $(30), %xmm6
    por          %xmm6, %xmm2
    pxor         %xmm2, %xmm1
    movdqa       %xmm2, %xmm6
    psrlq        $(5), %xmm2
    psllq        $(59), %xmm6
    por          %xmm6, %xmm2
    pxor         %xmm2, %xmm1
    paddq        (64)(%esp), %xmm1
    paddq        %xmm5, %xmm1
    paddq        (32)(%esp), %xmm5
    movdqa       (%esp), %xmm6
    movdqa       (16)(%esp), %xmm2
    movdqa       %xmm5, (%esp)
    movdqa       %xmm1, (16)(%esp)
    movdqa       %xmm4, (32)(%esp)
    movdqa       %xmm0, (48)(%esp)
    movdqa       %xmm6, %xmm4
    pxor         %xmm7, %xmm4
    pand         %xmm5, %xmm4
    pxor         %xmm7, %xmm4
    movq         (264)(%esp,%ecx,8), %xmm0
    paddq        %xmm0, %xmm4
    movq         (56)(%edx,%ecx,8), %xmm0
    paddq        %xmm0, %xmm4
    paddq        (48)(%esp), %xmm4
    movdqa       %xmm4, (48)(%esp)
    movdqa       %xmm2, %xmm4
    movdqa       %xmm1, %xmm0
    pxor         %xmm1, %xmm4
    pand         %xmm2, %xmm0
    pand         %xmm3, %xmm4
    pxor         %xmm4, %xmm0
    movdqa       %xmm0, (64)(%esp)
    movdqa       %xmm5, %xmm4
    movdqa       %xmm4, %xmm0
    psrlq        $(14), %xmm4
    psllq        $(50), %xmm0
    por          %xmm0, %xmm4
    movdqa       %xmm5, %xmm0
    psrlq        $(18), %xmm5
    psllq        $(46), %xmm0
    por          %xmm0, %xmm5
    pxor         %xmm5, %xmm4
    movdqa       %xmm5, %xmm0
    psrlq        $(23), %xmm5
    psllq        $(41), %xmm0
    por          %xmm0, %xmm5
    pxor         %xmm5, %xmm4
    paddq        (48)(%esp), %xmm4
    movdqa       %xmm1, %xmm0
    movdqa       %xmm0, %xmm5
    psrlq        $(28), %xmm0
    psllq        $(36), %xmm5
    por          %xmm5, %xmm0
    movdqa       %xmm1, %xmm5
    psrlq        $(34), %xmm1
    psllq        $(30), %xmm5
    por          %xmm5, %xmm1
    pxor         %xmm1, %xmm0
    movdqa       %xmm1, %xmm5
    psrlq        $(5), %xmm1
    psllq        $(59), %xmm5
    por          %xmm5, %xmm1
    pxor         %xmm1, %xmm0
    paddq        (64)(%esp), %xmm0
    paddq        %xmm4, %xmm0
    paddq        (32)(%esp), %xmm4
    movdqa       (%esp), %xmm5
    movdqa       (16)(%esp), %xmm1
    add          $(8), %ecx
    cmp          $(80), %ecx
    jl           .Lloop3gas_1
    paddq        (80)(%esp), %xmm0
    paddq        (96)(%esp), %xmm1
    paddq        (112)(%esp), %xmm2
    paddq        (128)(%esp), %xmm3
    paddq        (144)(%esp), %xmm4
    paddq        (160)(%esp), %xmm5
    paddq        (176)(%esp), %xmm6
    paddq        (192)(%esp), %xmm7
    movdqa       %xmm0, (80)(%esp)
    movdqa       %xmm1, (96)(%esp)
    movdqa       %xmm2, (112)(%esp)
    movdqa       %xmm3, (128)(%esp)
    movdqa       %xmm4, (144)(%esp)
    movdqa       %xmm5, (160)(%esp)
    movdqa       %xmm6, (176)(%esp)
    movdqa       %xmm7, (192)(%esp)
    add          $(128), %esi
    sub          $(128), %eax
    jg           .Lsha512_block_loopgas_1
    movq         %xmm0, (%edi)
    movq         %xmm1, (8)(%edi)
    movq         %xmm2, (16)(%edi)
    movq         %xmm3, (24)(%edi)
    movq         %xmm4, (32)(%edi)
    movq         %xmm5, (40)(%edi)
    movq         %xmm6, (48)(%edi)
    movq         %xmm7, (56)(%edi)
    add          (848)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
 
