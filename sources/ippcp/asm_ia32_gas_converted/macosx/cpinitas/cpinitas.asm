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
.p2align 5, 0x90
 
.globl _cpGetReg

 
_cpGetReg:
    push         %ebx
    push         %esi
    mov          (16)(%esp), %eax
    mov          (20)(%esp), %ecx
    xor          %ebx, %ebx
    xor          %edx, %edx
    mov          (12)(%esp), %esi
    cpuid
    mov          %eax, (%esi)
    mov          %ebx, (4)(%esi)
    mov          %ecx, (8)(%esi)
    mov          %edx, (12)(%esi)
    pop          %esi
    pop          %ebx
    ret
 
.p2align 5, 0x90
 
.globl _cp_is_avx_extension

 
_cp_is_avx_extension:
    push         %ebp
    mov          %esp, %ebp
    push         %ecx
    push         %edx
    push         %ebx
    mov          $(1), %eax
    cpuid
    xor          %eax, %eax
    and          $(402653184), %ecx
    cmp          $(402653184), %ecx
    jne          .Lnot_avxgas_2
    xor          %ecx, %ecx
 

.byte    0xf,  0x1, 0xd0 
    mov          %eax, %ecx
    xor          %eax, %eax
    and          $(6), %ecx
    cmp          $(6), %ecx
    jne          .Lnot_avxgas_2
    mov          $(1), %eax
.Lnot_avxgas_2: 
    pop          %ebx
    pop          %edx
    pop          %ecx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _cp_is_avx512_extension

 
_cp_is_avx512_extension:
    push         %ebp
    mov          %esp, %ebp
    push         %ecx
    push         %edx
    push         %ebx
    mov          $(1), %eax
    cpuid
    xor          %eax, %eax
    and          $(134217728), %ecx
    cmp          $(134217728), %ecx
    jne          .Lnot_avx512gas_3
    xor          %ecx, %ecx
 

.byte    0xf,  0x1, 0xd0 
    mov          %eax, %ecx
    xor          %eax, %eax
    and          $(224), %ecx
    cmp          $(224), %ecx
    jne          .Lnot_avx512gas_3
    mov          $(1), %eax
.Lnot_avx512gas_3: 
    pop          %ebx
    pop          %edx
    pop          %ecx
    pop          %ebp
    ret
 
.p2align 5, 0x90
 
.globl _cp_get_pentium_counter

 
_cp_get_pentium_counter:
    rdtsc
    ret
 
.p2align 5, 0x90
 
.globl _cpStartTscp

 
_cpStartTscp:
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
rdtscp 
    ret
 
.p2align 5, 0x90
 
.globl _cpStopTscp

 
_cpStopTscp:
rdtscp 
    push         %eax
    push         %edx
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
    pop          %edx
    pop          %eax
    ret
 
.p2align 5, 0x90
 
.globl _cpStartTsc

 
_cpStartTsc:
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
    rdtsc
    ret
 
.p2align 5, 0x90
 
.globl _cpStopTsc

 
_cpStopTsc:
    rdtsc
    push         %eax
    push         %edx
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
    pop          %edx
    pop          %eax
    ret
 
.p2align 5, 0x90
 
.globl _cpGetCacheSize

 
_cpGetCacheSize:
    push         %edi
    push         %esi
    push         %ebx
    push         %ebp
    sub          $(16), %esp
    mov          (36)(%esp), %edi
    mov          %esp, %ebp
    xor          %esi, %esi
    mov          $(2), %eax
    cpuid
    cmp          $(1), %al
    jne          .LGetCacheSize_11gas_9
    test         $(2147483648), %eax
    jz           .LGetCacheSize_00gas_9
    xor          %eax, %eax
.LGetCacheSize_00gas_9: 
    test         $(2147483648), %ebx
    jz           .LGetCacheSize_01gas_9
    xor          %ebx, %ebx
.LGetCacheSize_01gas_9: 
    test         $(2147483648), %ecx
    jz           .LGetCacheSize_02gas_9
    xor          %ecx, %ecx
.LGetCacheSize_02gas_9: 
    test         $(2147483648), %edx
    jz           .LGetCacheSize_03gas_9
    xor          %edx, %edx
.LGetCacheSize_03gas_9: 
    test         %eax, %eax
    jz           .LGetCacheSize_04gas_9
    mov          %eax, (%ebp)
    add          $(4), %ebp
    add          $(3), %esi
.LGetCacheSize_04gas_9: 
    test         %ebx, %ebx
    jz           .LGetCacheSize_05gas_9
    mov          %ebx, (%ebp)
    add          $(4), %ebp
    add          $(4), %esi
.LGetCacheSize_05gas_9: 
    test         %ecx, %ecx
    jz           .LGetCacheSize_06gas_9
    mov          %ecx, (%ebp)
    add          $(4), %ebp
    add          $(4), %esi
.LGetCacheSize_06gas_9: 
    test         %edx, %edx
    jz           .LGetCacheSize_07gas_9
    mov          %edx, (%ebp)
    add          $(4), %esi
.LGetCacheSize_07gas_9: 
    test         %esi, %esi
    jz           .LGetCacheSize_11gas_9
    mov          $(-1), %eax
.LGetCacheSize_08gas_9: 
    xor          %edx, %edx
    add          (%edi), %edx
    jz           .LExitGetCacheSize00gas_9
    add          $(8), %edi
    mov          %esi, %ecx
.LGetCacheSize_09gas_9: 
    cmpb         (%esp,%ecx), %dl
    je           .LGetCacheSize_10gas_9
    dec          %ecx
    jnz          .LGetCacheSize_09gas_9
    jmp          .LGetCacheSize_08gas_9
.LGetCacheSize_10gas_9: 
    mov          (-4)(%edi), %eax
.LExitGetCacheSize00gas_9: 
    add          $(16), %esp
    pop          %ebp
    pop          %ebx
    pop          %esi
    pop          %edi
    ret
.LGetCacheSize_11gas_9: 
    mov          $(-1), %eax
    jmp          .LExitGetCacheSize00gas_9
 
