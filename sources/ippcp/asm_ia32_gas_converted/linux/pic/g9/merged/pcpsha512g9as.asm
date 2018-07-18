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
.p2align 5, 0x90
SWP_BYTE: 
 
pByteSwp:
.byte  7,6,5,4,3,2,1,0, 15,14,13,12,11,10,9,8 
.p2align 5, 0x90
 
.globl g9_UpdateSHA512
.type g9_UpdateSHA512, @function
 
g9_UpdateSHA512:
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
    vmovq        (%edi), %xmm0
    vmovq        (8)(%edi), %xmm1
    vmovq        (16)(%edi), %xmm2
    vmovq        (24)(%edi), %xmm3
    vmovq        (32)(%edi), %xmm4
    vmovq        (40)(%edi), %xmm5
    vmovq        (48)(%edi), %xmm6
    vmovq        (56)(%edi), %xmm7
    vmovdqa      %xmm0, (80)(%esp)
    vmovdqa      %xmm1, (96)(%esp)
    vmovdqa      %xmm2, (112)(%esp)
    vmovdqa      %xmm3, (128)(%esp)
    vmovdqa      %xmm4, (144)(%esp)
    vmovdqa      %xmm5, (160)(%esp)
    vmovdqa      %xmm6, (176)(%esp)
    vmovdqa      %xmm7, (192)(%esp)
.Lsha512_block_loopgas_1: 
    call         .L__0000gas_1
.L__0000gas_1:
    pop          %ecx
    sub          $(.L__0000gas_1-SWP_BYTE), %ecx
    movdqa       ((pByteSwp-SWP_BYTE))(%ecx), %xmm1
    mov          $(0), %ecx
.p2align 5, 0x90
.Lloop1gas_1: 
    vmovdqu      (%esi,%ecx,8), %xmm0
    vpshufb      %xmm1, %xmm0, %xmm0
    vmovdqa      %xmm0, (208)(%esp,%ecx,8)
    add          $(2), %ecx
    cmp          $(16), %ecx
    jl           .Lloop1gas_1
.p2align 5, 0x90
.Lloop2gas_1: 
    vmovdqa      (192)(%esp,%ecx,8), %xmm1
    vpsrlq       $(6), %xmm1, %xmm0
    vmovdqa      %xmm1, %xmm2
    vpsllq       $(45), %xmm1, %xmm3
    vpsrlq       $(19), %xmm1, %xmm1
    vpor         %xmm3, %xmm1, %xmm1
    vpxor        %xmm1, %xmm0, %xmm0
    vpsllq       $(3), %xmm2, %xmm3
    vpsrlq       $(61), %xmm2, %xmm2
    vpor         %xmm3, %xmm2, %xmm2
    vpxor        %xmm2, %xmm0, %xmm0
    vmovdqu      (88)(%esp,%ecx,8), %xmm5
    vpsrlq       $(7), %xmm5, %xmm4
    vmovdqa      %xmm5, %xmm6
    vpsllq       $(63), %xmm5, %xmm3
    vpsrlq       $(1), %xmm5, %xmm5
    vpor         %xmm3, %xmm5, %xmm5
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(56), %xmm6, %xmm3
    vpsrlq       $(8), %xmm6, %xmm6
    vpor         %xmm3, %xmm6, %xmm6
    vpxor        %xmm6, %xmm4, %xmm4
    vmovdqu      (152)(%esp,%ecx,8), %xmm7
    vpaddq       %xmm4, %xmm0, %xmm0
    vpaddq       (80)(%esp,%ecx,8), %xmm7, %xmm7
    vpaddq       %xmm7, %xmm0, %xmm0
    vmovdqa      %xmm0, (208)(%esp,%ecx,8)
    add          $(2), %ecx
    cmp          $(80), %ecx
    jl           .Lloop2gas_1
    vmovdqa      (80)(%esp), %xmm0
    vmovdqa      (96)(%esp), %xmm1
    vmovdqa      (112)(%esp), %xmm2
    vmovdqa      (128)(%esp), %xmm3
    vmovdqa      (144)(%esp), %xmm4
    vmovdqa      (160)(%esp), %xmm5
    vmovdqa      (176)(%esp), %xmm6
    vmovdqa      (192)(%esp), %xmm7
    xor          %ecx, %ecx
.p2align 5, 0x90
.Lloop3gas_1: 
    vmovdqa      %xmm4, (%esp)
    vmovdqa      %xmm0, (16)(%esp)
    vmovdqa      %xmm3, (32)(%esp)
    vmovdqa      %xmm7, (48)(%esp)
    vpxor        %xmm6, %xmm5, %xmm3
    vpand        %xmm4, %xmm3, %xmm3
    vpxor        %xmm6, %xmm3, %xmm3
    vmovq        (208)(%esp,%ecx,8), %xmm7
    vpaddq       %xmm7, %xmm3, %xmm3
    vmovq        (%edx,%ecx,8), %xmm7
    vpaddq       %xmm7, %xmm3, %xmm3
    vpaddq       (48)(%esp), %xmm3, %xmm3
    vmovdqa      %xmm3, (48)(%esp)
    vpxor        %xmm1, %xmm0, %xmm3
    vpand        %xmm1, %xmm0, %xmm7
    vpand        %xmm2, %xmm3, %xmm3
    vpxor        %xmm3, %xmm7, %xmm7
    vmovdqa      %xmm7, (64)(%esp)
    vmovdqa      %xmm4, %xmm3
    vpsllq       $(50), %xmm3, %xmm7
    vpsrlq       $(14), %xmm3, %xmm3
    vpor         %xmm7, %xmm3, %xmm3
    vpsllq       $(46), %xmm4, %xmm7
    vpsrlq       $(18), %xmm4, %xmm4
    vpor         %xmm7, %xmm4, %xmm4
    vpxor        %xmm4, %xmm3, %xmm3
    vpsllq       $(41), %xmm4, %xmm7
    vpsrlq       $(23), %xmm4, %xmm4
    vpor         %xmm7, %xmm4, %xmm4
    vpxor        %xmm4, %xmm3, %xmm3
    vpaddq       (48)(%esp), %xmm3, %xmm3
    vmovdqa      %xmm0, %xmm7
    vpsllq       $(36), %xmm7, %xmm4
    vpsrlq       $(28), %xmm7, %xmm7
    vpor         %xmm4, %xmm7, %xmm7
    vpsllq       $(30), %xmm0, %xmm4
    vpsrlq       $(34), %xmm0, %xmm0
    vpor         %xmm4, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    vpsllq       $(59), %xmm0, %xmm4
    vpsrlq       $(5), %xmm0, %xmm0
    vpor         %xmm4, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    vpaddq       (64)(%esp), %xmm7, %xmm7
    vpaddq       %xmm3, %xmm7, %xmm7
    vpaddq       (32)(%esp), %xmm3, %xmm3
    vmovdqa      (%esp), %xmm4
    vmovdqa      (16)(%esp), %xmm0
    vmovdqa      %xmm3, (%esp)
    vmovdqa      %xmm7, (16)(%esp)
    vmovdqa      %xmm2, (32)(%esp)
    vmovdqa      %xmm6, (48)(%esp)
    vpxor        %xmm5, %xmm4, %xmm2
    vpand        %xmm3, %xmm2, %xmm2
    vpxor        %xmm5, %xmm2, %xmm2
    vmovq        (216)(%esp,%ecx,8), %xmm6
    vpaddq       %xmm6, %xmm2, %xmm2
    vmovq        (8)(%edx,%ecx,8), %xmm6
    vpaddq       %xmm6, %xmm2, %xmm2
    vpaddq       (48)(%esp), %xmm2, %xmm2
    vmovdqa      %xmm2, (48)(%esp)
    vpxor        %xmm0, %xmm7, %xmm2
    vpand        %xmm0, %xmm7, %xmm6
    vpand        %xmm1, %xmm2, %xmm2
    vpxor        %xmm2, %xmm6, %xmm6
    vmovdqa      %xmm6, (64)(%esp)
    vmovdqa      %xmm3, %xmm2
    vpsllq       $(50), %xmm2, %xmm6
    vpsrlq       $(14), %xmm2, %xmm2
    vpor         %xmm6, %xmm2, %xmm2
    vpsllq       $(46), %xmm3, %xmm6
    vpsrlq       $(18), %xmm3, %xmm3
    vpor         %xmm6, %xmm3, %xmm3
    vpxor        %xmm3, %xmm2, %xmm2
    vpsllq       $(41), %xmm3, %xmm6
    vpsrlq       $(23), %xmm3, %xmm3
    vpor         %xmm6, %xmm3, %xmm3
    vpxor        %xmm3, %xmm2, %xmm2
    vpaddq       (48)(%esp), %xmm2, %xmm2
    vmovdqa      %xmm7, %xmm6
    vpsllq       $(36), %xmm6, %xmm3
    vpsrlq       $(28), %xmm6, %xmm6
    vpor         %xmm3, %xmm6, %xmm6
    vpsllq       $(30), %xmm7, %xmm3
    vpsrlq       $(34), %xmm7, %xmm7
    vpor         %xmm3, %xmm7, %xmm7
    vpxor        %xmm7, %xmm6, %xmm6
    vpsllq       $(59), %xmm7, %xmm3
    vpsrlq       $(5), %xmm7, %xmm7
    vpor         %xmm3, %xmm7, %xmm7
    vpxor        %xmm7, %xmm6, %xmm6
    vpaddq       (64)(%esp), %xmm6, %xmm6
    vpaddq       %xmm2, %xmm6, %xmm6
    vpaddq       (32)(%esp), %xmm2, %xmm2
    vmovdqa      (%esp), %xmm3
    vmovdqa      (16)(%esp), %xmm7
    vmovdqa      %xmm2, (%esp)
    vmovdqa      %xmm6, (16)(%esp)
    vmovdqa      %xmm1, (32)(%esp)
    vmovdqa      %xmm5, (48)(%esp)
    vpxor        %xmm4, %xmm3, %xmm1
    vpand        %xmm2, %xmm1, %xmm1
    vpxor        %xmm4, %xmm1, %xmm1
    vmovq        (224)(%esp,%ecx,8), %xmm5
    vpaddq       %xmm5, %xmm1, %xmm1
    vmovq        (16)(%edx,%ecx,8), %xmm5
    vpaddq       %xmm5, %xmm1, %xmm1
    vpaddq       (48)(%esp), %xmm1, %xmm1
    vmovdqa      %xmm1, (48)(%esp)
    vpxor        %xmm7, %xmm6, %xmm1
    vpand        %xmm7, %xmm6, %xmm5
    vpand        %xmm0, %xmm1, %xmm1
    vpxor        %xmm1, %xmm5, %xmm5
    vmovdqa      %xmm5, (64)(%esp)
    vmovdqa      %xmm2, %xmm1
    vpsllq       $(50), %xmm1, %xmm5
    vpsrlq       $(14), %xmm1, %xmm1
    vpor         %xmm5, %xmm1, %xmm1
    vpsllq       $(46), %xmm2, %xmm5
    vpsrlq       $(18), %xmm2, %xmm2
    vpor         %xmm5, %xmm2, %xmm2
    vpxor        %xmm2, %xmm1, %xmm1
    vpsllq       $(41), %xmm2, %xmm5
    vpsrlq       $(23), %xmm2, %xmm2
    vpor         %xmm5, %xmm2, %xmm2
    vpxor        %xmm2, %xmm1, %xmm1
    vpaddq       (48)(%esp), %xmm1, %xmm1
    vmovdqa      %xmm6, %xmm5
    vpsllq       $(36), %xmm5, %xmm2
    vpsrlq       $(28), %xmm5, %xmm5
    vpor         %xmm2, %xmm5, %xmm5
    vpsllq       $(30), %xmm6, %xmm2
    vpsrlq       $(34), %xmm6, %xmm6
    vpor         %xmm2, %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsllq       $(59), %xmm6, %xmm2
    vpsrlq       $(5), %xmm6, %xmm6
    vpor         %xmm2, %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpaddq       (64)(%esp), %xmm5, %xmm5
    vpaddq       %xmm1, %xmm5, %xmm5
    vpaddq       (32)(%esp), %xmm1, %xmm1
    vmovdqa      (%esp), %xmm2
    vmovdqa      (16)(%esp), %xmm6
    vmovdqa      %xmm1, (%esp)
    vmovdqa      %xmm5, (16)(%esp)
    vmovdqa      %xmm0, (32)(%esp)
    vmovdqa      %xmm4, (48)(%esp)
    vpxor        %xmm3, %xmm2, %xmm0
    vpand        %xmm1, %xmm0, %xmm0
    vpxor        %xmm3, %xmm0, %xmm0
    vmovq        (232)(%esp,%ecx,8), %xmm4
    vpaddq       %xmm4, %xmm0, %xmm0
    vmovq        (24)(%edx,%ecx,8), %xmm4
    vpaddq       %xmm4, %xmm0, %xmm0
    vpaddq       (48)(%esp), %xmm0, %xmm0
    vmovdqa      %xmm0, (48)(%esp)
    vpxor        %xmm6, %xmm5, %xmm0
    vpand        %xmm6, %xmm5, %xmm4
    vpand        %xmm7, %xmm0, %xmm0
    vpxor        %xmm0, %xmm4, %xmm4
    vmovdqa      %xmm4, (64)(%esp)
    vmovdqa      %xmm1, %xmm0
    vpsllq       $(50), %xmm0, %xmm4
    vpsrlq       $(14), %xmm0, %xmm0
    vpor         %xmm4, %xmm0, %xmm0
    vpsllq       $(46), %xmm1, %xmm4
    vpsrlq       $(18), %xmm1, %xmm1
    vpor         %xmm4, %xmm1, %xmm1
    vpxor        %xmm1, %xmm0, %xmm0
    vpsllq       $(41), %xmm1, %xmm4
    vpsrlq       $(23), %xmm1, %xmm1
    vpor         %xmm4, %xmm1, %xmm1
    vpxor        %xmm1, %xmm0, %xmm0
    vpaddq       (48)(%esp), %xmm0, %xmm0
    vmovdqa      %xmm5, %xmm4
    vpsllq       $(36), %xmm4, %xmm1
    vpsrlq       $(28), %xmm4, %xmm4
    vpor         %xmm1, %xmm4, %xmm4
    vpsllq       $(30), %xmm5, %xmm1
    vpsrlq       $(34), %xmm5, %xmm5
    vpor         %xmm1, %xmm5, %xmm5
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(59), %xmm5, %xmm1
    vpsrlq       $(5), %xmm5, %xmm5
    vpor         %xmm1, %xmm5, %xmm5
    vpxor        %xmm5, %xmm4, %xmm4
    vpaddq       (64)(%esp), %xmm4, %xmm4
    vpaddq       %xmm0, %xmm4, %xmm4
    vpaddq       (32)(%esp), %xmm0, %xmm0
    vmovdqa      (%esp), %xmm1
    vmovdqa      (16)(%esp), %xmm5
    vmovdqa      %xmm0, (%esp)
    vmovdqa      %xmm4, (16)(%esp)
    vmovdqa      %xmm7, (32)(%esp)
    vmovdqa      %xmm3, (48)(%esp)
    vpxor        %xmm2, %xmm1, %xmm7
    vpand        %xmm0, %xmm7, %xmm7
    vpxor        %xmm2, %xmm7, %xmm7
    vmovq        (240)(%esp,%ecx,8), %xmm3
    vpaddq       %xmm3, %xmm7, %xmm7
    vmovq        (32)(%edx,%ecx,8), %xmm3
    vpaddq       %xmm3, %xmm7, %xmm7
    vpaddq       (48)(%esp), %xmm7, %xmm7
    vmovdqa      %xmm7, (48)(%esp)
    vpxor        %xmm5, %xmm4, %xmm7
    vpand        %xmm5, %xmm4, %xmm3
    vpand        %xmm6, %xmm7, %xmm7
    vpxor        %xmm7, %xmm3, %xmm3
    vmovdqa      %xmm3, (64)(%esp)
    vmovdqa      %xmm0, %xmm7
    vpsllq       $(50), %xmm7, %xmm3
    vpsrlq       $(14), %xmm7, %xmm7
    vpor         %xmm3, %xmm7, %xmm7
    vpsllq       $(46), %xmm0, %xmm3
    vpsrlq       $(18), %xmm0, %xmm0
    vpor         %xmm3, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    vpsllq       $(41), %xmm0, %xmm3
    vpsrlq       $(23), %xmm0, %xmm0
    vpor         %xmm3, %xmm0, %xmm0
    vpxor        %xmm0, %xmm7, %xmm7
    vpaddq       (48)(%esp), %xmm7, %xmm7
    vmovdqa      %xmm4, %xmm3
    vpsllq       $(36), %xmm3, %xmm0
    vpsrlq       $(28), %xmm3, %xmm3
    vpor         %xmm0, %xmm3, %xmm3
    vpsllq       $(30), %xmm4, %xmm0
    vpsrlq       $(34), %xmm4, %xmm4
    vpor         %xmm0, %xmm4, %xmm4
    vpxor        %xmm4, %xmm3, %xmm3
    vpsllq       $(59), %xmm4, %xmm0
    vpsrlq       $(5), %xmm4, %xmm4
    vpor         %xmm0, %xmm4, %xmm4
    vpxor        %xmm4, %xmm3, %xmm3
    vpaddq       (64)(%esp), %xmm3, %xmm3
    vpaddq       %xmm7, %xmm3, %xmm3
    vpaddq       (32)(%esp), %xmm7, %xmm7
    vmovdqa      (%esp), %xmm0
    vmovdqa      (16)(%esp), %xmm4
    vmovdqa      %xmm7, (%esp)
    vmovdqa      %xmm3, (16)(%esp)
    vmovdqa      %xmm6, (32)(%esp)
    vmovdqa      %xmm2, (48)(%esp)
    vpxor        %xmm1, %xmm0, %xmm6
    vpand        %xmm7, %xmm6, %xmm6
    vpxor        %xmm1, %xmm6, %xmm6
    vmovq        (248)(%esp,%ecx,8), %xmm2
    vpaddq       %xmm2, %xmm6, %xmm6
    vmovq        (40)(%edx,%ecx,8), %xmm2
    vpaddq       %xmm2, %xmm6, %xmm6
    vpaddq       (48)(%esp), %xmm6, %xmm6
    vmovdqa      %xmm6, (48)(%esp)
    vpxor        %xmm4, %xmm3, %xmm6
    vpand        %xmm4, %xmm3, %xmm2
    vpand        %xmm5, %xmm6, %xmm6
    vpxor        %xmm6, %xmm2, %xmm2
    vmovdqa      %xmm2, (64)(%esp)
    vmovdqa      %xmm7, %xmm6
    vpsllq       $(50), %xmm6, %xmm2
    vpsrlq       $(14), %xmm6, %xmm6
    vpor         %xmm2, %xmm6, %xmm6
    vpsllq       $(46), %xmm7, %xmm2
    vpsrlq       $(18), %xmm7, %xmm7
    vpor         %xmm2, %xmm7, %xmm7
    vpxor        %xmm7, %xmm6, %xmm6
    vpsllq       $(41), %xmm7, %xmm2
    vpsrlq       $(23), %xmm7, %xmm7
    vpor         %xmm2, %xmm7, %xmm7
    vpxor        %xmm7, %xmm6, %xmm6
    vpaddq       (48)(%esp), %xmm6, %xmm6
    vmovdqa      %xmm3, %xmm2
    vpsllq       $(36), %xmm2, %xmm7
    vpsrlq       $(28), %xmm2, %xmm2
    vpor         %xmm7, %xmm2, %xmm2
    vpsllq       $(30), %xmm3, %xmm7
    vpsrlq       $(34), %xmm3, %xmm3
    vpor         %xmm7, %xmm3, %xmm3
    vpxor        %xmm3, %xmm2, %xmm2
    vpsllq       $(59), %xmm3, %xmm7
    vpsrlq       $(5), %xmm3, %xmm3
    vpor         %xmm7, %xmm3, %xmm3
    vpxor        %xmm3, %xmm2, %xmm2
    vpaddq       (64)(%esp), %xmm2, %xmm2
    vpaddq       %xmm6, %xmm2, %xmm2
    vpaddq       (32)(%esp), %xmm6, %xmm6
    vmovdqa      (%esp), %xmm7
    vmovdqa      (16)(%esp), %xmm3
    vmovdqa      %xmm6, (%esp)
    vmovdqa      %xmm2, (16)(%esp)
    vmovdqa      %xmm5, (32)(%esp)
    vmovdqa      %xmm1, (48)(%esp)
    vpxor        %xmm0, %xmm7, %xmm5
    vpand        %xmm6, %xmm5, %xmm5
    vpxor        %xmm0, %xmm5, %xmm5
    vmovq        (256)(%esp,%ecx,8), %xmm1
    vpaddq       %xmm1, %xmm5, %xmm5
    vmovq        (48)(%edx,%ecx,8), %xmm1
    vpaddq       %xmm1, %xmm5, %xmm5
    vpaddq       (48)(%esp), %xmm5, %xmm5
    vmovdqa      %xmm5, (48)(%esp)
    vpxor        %xmm3, %xmm2, %xmm5
    vpand        %xmm3, %xmm2, %xmm1
    vpand        %xmm4, %xmm5, %xmm5
    vpxor        %xmm5, %xmm1, %xmm1
    vmovdqa      %xmm1, (64)(%esp)
    vmovdqa      %xmm6, %xmm5
    vpsllq       $(50), %xmm5, %xmm1
    vpsrlq       $(14), %xmm5, %xmm5
    vpor         %xmm1, %xmm5, %xmm5
    vpsllq       $(46), %xmm6, %xmm1
    vpsrlq       $(18), %xmm6, %xmm6
    vpor         %xmm1, %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpsllq       $(41), %xmm6, %xmm1
    vpsrlq       $(23), %xmm6, %xmm6
    vpor         %xmm1, %xmm6, %xmm6
    vpxor        %xmm6, %xmm5, %xmm5
    vpaddq       (48)(%esp), %xmm5, %xmm5
    vmovdqa      %xmm2, %xmm1
    vpsllq       $(36), %xmm1, %xmm6
    vpsrlq       $(28), %xmm1, %xmm1
    vpor         %xmm6, %xmm1, %xmm1
    vpsllq       $(30), %xmm2, %xmm6
    vpsrlq       $(34), %xmm2, %xmm2
    vpor         %xmm6, %xmm2, %xmm2
    vpxor        %xmm2, %xmm1, %xmm1
    vpsllq       $(59), %xmm2, %xmm6
    vpsrlq       $(5), %xmm2, %xmm2
    vpor         %xmm6, %xmm2, %xmm2
    vpxor        %xmm2, %xmm1, %xmm1
    vpaddq       (64)(%esp), %xmm1, %xmm1
    vpaddq       %xmm5, %xmm1, %xmm1
    vpaddq       (32)(%esp), %xmm5, %xmm5
    vmovdqa      (%esp), %xmm6
    vmovdqa      (16)(%esp), %xmm2
    vmovdqa      %xmm5, (%esp)
    vmovdqa      %xmm1, (16)(%esp)
    vmovdqa      %xmm4, (32)(%esp)
    vmovdqa      %xmm0, (48)(%esp)
    vpxor        %xmm7, %xmm6, %xmm4
    vpand        %xmm5, %xmm4, %xmm4
    vpxor        %xmm7, %xmm4, %xmm4
    vmovq        (264)(%esp,%ecx,8), %xmm0
    vpaddq       %xmm0, %xmm4, %xmm4
    vmovq        (56)(%edx,%ecx,8), %xmm0
    vpaddq       %xmm0, %xmm4, %xmm4
    vpaddq       (48)(%esp), %xmm4, %xmm4
    vmovdqa      %xmm4, (48)(%esp)
    vpxor        %xmm2, %xmm1, %xmm4
    vpand        %xmm2, %xmm1, %xmm0
    vpand        %xmm3, %xmm4, %xmm4
    vpxor        %xmm4, %xmm0, %xmm0
    vmovdqa      %xmm0, (64)(%esp)
    vmovdqa      %xmm5, %xmm4
    vpsllq       $(50), %xmm4, %xmm0
    vpsrlq       $(14), %xmm4, %xmm4
    vpor         %xmm0, %xmm4, %xmm4
    vpsllq       $(46), %xmm5, %xmm0
    vpsrlq       $(18), %xmm5, %xmm5
    vpor         %xmm0, %xmm5, %xmm5
    vpxor        %xmm5, %xmm4, %xmm4
    vpsllq       $(41), %xmm5, %xmm0
    vpsrlq       $(23), %xmm5, %xmm5
    vpor         %xmm0, %xmm5, %xmm5
    vpxor        %xmm5, %xmm4, %xmm4
    vpaddq       (48)(%esp), %xmm4, %xmm4
    vmovdqa      %xmm1, %xmm0
    vpsllq       $(36), %xmm0, %xmm5
    vpsrlq       $(28), %xmm0, %xmm0
    vpor         %xmm5, %xmm0, %xmm0
    vpsllq       $(30), %xmm1, %xmm5
    vpsrlq       $(34), %xmm1, %xmm1
    vpor         %xmm5, %xmm1, %xmm1
    vpxor        %xmm1, %xmm0, %xmm0
    vpsllq       $(59), %xmm1, %xmm5
    vpsrlq       $(5), %xmm1, %xmm1
    vpor         %xmm5, %xmm1, %xmm1
    vpxor        %xmm1, %xmm0, %xmm0
    vpaddq       (64)(%esp), %xmm0, %xmm0
    vpaddq       %xmm4, %xmm0, %xmm0
    vpaddq       (32)(%esp), %xmm4, %xmm4
    vmovdqa      (%esp), %xmm5
    vmovdqa      (16)(%esp), %xmm1
    add          $(8), %ecx
    cmp          $(80), %ecx
    jl           .Lloop3gas_1
    vpaddq       (80)(%esp), %xmm0, %xmm0
    vpaddq       (96)(%esp), %xmm1, %xmm1
    vpaddq       (112)(%esp), %xmm2, %xmm2
    vpaddq       (128)(%esp), %xmm3, %xmm3
    vpaddq       (144)(%esp), %xmm4, %xmm4
    vpaddq       (160)(%esp), %xmm5, %xmm5
    vpaddq       (176)(%esp), %xmm6, %xmm6
    vpaddq       (192)(%esp), %xmm7, %xmm7
    vmovdqa      %xmm0, (80)(%esp)
    vmovdqa      %xmm1, (96)(%esp)
    vmovdqa      %xmm2, (112)(%esp)
    vmovdqa      %xmm3, (128)(%esp)
    vmovdqa      %xmm4, (144)(%esp)
    vmovdqa      %xmm5, (160)(%esp)
    vmovdqa      %xmm6, (176)(%esp)
    vmovdqa      %xmm7, (192)(%esp)
    add          $(128), %esi
    sub          $(128), %eax
    jg           .Lsha512_block_loopgas_1
    vmovq        %xmm0, (%edi)
    vmovq        %xmm1, (8)(%edi)
    vmovq        %xmm2, (16)(%edi)
    vmovq        %xmm3, (24)(%edi)
    vmovq        %xmm4, (32)(%edi)
    vmovq        %xmm5, (40)(%edi)
    vmovq        %xmm6, (48)(%edi)
    vmovq        %xmm7, (56)(%edi)
    add          (848)(%esp), %esp
    pop          %edi
    pop          %esi
    pop          %ebp
    ret
.Lfe1:
.size g9_UpdateSHA512, .Lfe1-(g9_UpdateSHA512)
 
