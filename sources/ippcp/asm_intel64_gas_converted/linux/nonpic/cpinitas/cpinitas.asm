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
 
.globl cpGetReg
.type cpGetReg, @function
 
cpGetReg:
    push         %rbx
    movslq       %esi, %r9
    movslq       %edx, %r10
    mov          %rdi, %r11
    mov          %r9, %rax
    mov          %r10, %rcx
    xor          %ebx, %ebx
    xor          %edx, %edx
    cpuid
    mov          %eax, (%r11)
    mov          %ebx, (4)(%r11)
    mov          %ecx, (8)(%r11)
    mov          %edx, (12)(%r11)
    pop          %rbx
    ret
.Lfe1:
.size cpGetReg, .Lfe1-(cpGetReg)
 
.p2align 5, 0x90
 
.globl cp_is_avx_extension
.type cp_is_avx_extension, @function
 
cp_is_avx_extension:
    push         %rbx
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
    pop          %rbx
    ret
.Lfe2:
.size cp_is_avx_extension, .Lfe2-(cp_is_avx_extension)
.p2align 5, 0x90
 
.globl cp_is_avx512_extension
.type cp_is_avx512_extension, @function
 
cp_is_avx512_extension:
    push         %rbx
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
    pop          %rbx
    ret
.Lfe3:
.size cp_is_avx512_extension, .Lfe3-(cp_is_avx512_extension)
.p2align 5, 0x90
 
.globl cp_issue_avx512_instruction
.type cp_issue_avx512_instruction, @function
 
cp_issue_avx512_instruction:
 

.byte   0x62, 0xf1, 0x7d, 0x48, 0xef, 0xc0 
    xor          %eax, %eax
    ret
.Lfe4:
.size cp_issue_avx512_instruction, .Lfe4-(cp_issue_avx512_instruction)
.p2align 5, 0x90
 
.globl ippcpSafeInit
.type ippcpSafeInit, @function
 
ippcpSafeInit:
    push         %rcx
    push         %rdx
    push         %rdi
    push         %rsi
    push         %r8
    push         %r9
    call         ippcpInit
    pop          %r9
    pop          %r8
    pop          %rsi
    pop          %rdi
    pop          %rdx
    pop          %rcx
    ret
.Lfe5:
.size ippcpSafeInit, .Lfe5-(ippcpSafeInit)
.p2align 5, 0x90
 
.globl cp_get_pentium_counter
.type cp_get_pentium_counter, @function
 
cp_get_pentium_counter:
    rdtsc
    sal          $(32), %rdx
    or           %rdx, %rax
    ret
.Lfe6:
.size cp_get_pentium_counter, .Lfe6-(cp_get_pentium_counter)
.p2align 5, 0x90
 
.globl cpStartTscp
.type cpStartTscp, @function
 
cpStartTscp:
    push         %rbx
    xor          %rax, %rax
    cpuid
    pop          %rbx
rdtscp 
    sal          $(32), %rdx
    or           %rdx, %rax
    ret
.Lfe7:
.size cpStartTscp, .Lfe7-(cpStartTscp)
.p2align 5, 0x90
 
.globl cpStopTscp
.type cpStopTscp, @function
 
cpStopTscp:
rdtscp 
    sal          $(32), %rdx
    or           %rdx, %rax
    push         %rax
    push         %rbx
    xor          %rax, %rax
    cpuid
    pop          %rbx
    pop          %rax
    ret
.Lfe8:
.size cpStopTscp, .Lfe8-(cpStopTscp)
.p2align 5, 0x90
 
.globl cpStartTsc
.type cpStartTsc, @function
 
cpStartTsc:
    push         %rbx
    xor          %rax, %rax
    cpuid
    pop          %rbx
    rdtsc
    sal          $(32), %rdx
    or           %rdx, %rax
    ret
.Lfe9:
.size cpStartTsc, .Lfe9-(cpStartTsc)
.p2align 5, 0x90
 
.globl cpStopTsc
.type cpStopTsc, @function
 
cpStopTsc:
    rdtsc
    sal          $(32), %rdx
    or           %rdx, %rax
    push         %rax
    push         %rbx
    xor          %rax, %rax
    cpuid
    pop          %rbx
    pop          %rax
    ret
.Lfe10:
.size cpStopTsc, .Lfe10-(cpStopTsc)
.p2align 5, 0x90
 
.globl cpGetCacheSize
.type cpGetCacheSize, @function
 
cpGetCacheSize:
 
    push         %rbx
 
    push         %rbp
 
    sub          $(24), %rsp
 
    mov          %rsp, %rbp
    xor          %esi, %esi
    mov          $(2), %eax
    cpuid
    cmp          $(1), %al
    jne          .LGetCacheSize_11gas_11
    test         $(2147483648), %eax
    jz           .LGetCacheSize_00gas_11
    xor          %eax, %eax
.LGetCacheSize_00gas_11: 
    test         $(2147483648), %ebx
    jz           .LGetCacheSize_01gas_11
    xor          %ebx, %ebx
.LGetCacheSize_01gas_11: 
    test         $(2147483648), %ecx
    jz           .LGetCacheSize_02gas_11
    xor          %ecx, %ecx
.LGetCacheSize_02gas_11: 
    test         $(2147483648), %edx
    jz           .LGetCacheSize_03gas_11
    xor          %edx, %edx
.LGetCacheSize_03gas_11: 
    test         %eax, %eax
    jz           .LGetCacheSize_04gas_11
    mov          %eax, (%rbp)
    add          $(4), %rbp
    add          $(3), %esi
.LGetCacheSize_04gas_11: 
    test         %ebx, %ebx
    jz           .LGetCacheSize_05gas_11
    mov          %ebx, (%rbp)
    add          $(4), %rbp
    add          $(4), %esi
.LGetCacheSize_05gas_11: 
    test         %ecx, %ecx
    jz           .LGetCacheSize_06gas_11
    mov          %ecx, (%rbp)
    add          $(4), %rbp
    add          $(4), %esi
.LGetCacheSize_06gas_11: 
    test         %edx, %edx
    jz           .LGetCacheSize_07gas_11
    mov          %edx, (%rbp)
    add          $(4), %esi
.LGetCacheSize_07gas_11: 
    test         %esi, %esi
    jz           .LGetCacheSize_11gas_11
    mov          $(-1), %eax
.LGetCacheSize_08gas_11: 
    xor          %edx, %edx
    add          (%rdi), %edx
    jz           .LExitGetCacheSize00gas_11
    add          $(8), %rdi
    mov          %esi, %ecx
.LGetCacheSize_09gas_11: 
    cmpb         (%rsp,%rcx), %dl
    je           .LGetCacheSize_10gas_11
    dec          %ecx
    jnz          .LGetCacheSize_09gas_11
    jmp          .LGetCacheSize_08gas_11
.LGetCacheSize_10gas_11: 
    mov          (-4)(%rdi), %eax
.LExitGetCacheSize00gas_11: 
    add          $(24), %rsp
vzeroupper 
 
    pop          %rbp
 
    pop          %rbx
 
    ret
.LGetCacheSize_11gas_11: 
    mov          $(-1), %eax
    jmp          .LExitGetCacheSize00gas_11
.Lfe11:
.size cpGetCacheSize, .Lfe11-(cpGetCacheSize)
 
