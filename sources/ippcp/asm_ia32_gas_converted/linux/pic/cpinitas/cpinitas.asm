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
.Lfe1:
.size cpGetReg, .Lfe1-(cpGetReg)
 
.p2align 5, 0x90
 
.globl cp_is_avx_extension
.type cp_is_avx_extension, @function
 
cp_is_avx_extension:
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
.Lfe2:
.size cp_is_avx_extension, .Lfe2-(cp_is_avx_extension)
.p2align 5, 0x90
 
.globl cp_is_avx512_extension
.type cp_is_avx512_extension, @function
 
cp_is_avx512_extension:
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
.Lfe3:
.size cp_is_avx512_extension, .Lfe3-(cp_is_avx512_extension)
 .weak __ashldi3 
.p2align 5, 0x90
 
.globl __ashldi3
.type __ashldi3, @function
 
__ashldi3:
    mov          (4)(%esp), %eax
    mov          (8)(%esp), %edx
    mov          (12)(%esp), %ecx
    test         $(32), %cl
    je           .Llessgas_4
    mov          %eax, %edx
    xor          %eax, %eax
    shl          %cl, %edx
    ret
.Llessgas_4: 
    shld         %cl, %eax, %edx
    shl          %cl, %eax
    ret
.Lfe4:
.size __ashldi3, .Lfe4-(__ashldi3)
 .weak __ashrdi3 
.p2align 5, 0x90
 
.globl __ashrdi3
.type __ashrdi3, @function
 
__ashrdi3:
    mov          (4)(%esp), %eax
    mov          (8)(%esp), %edx
    mov          (12)(%esp), %ecx
    test         $(32), %cl
    je           .Llessgas_5
    mov          %edx, %eax
    sar          $(31), %edx
    sar          %cl, %eax
    ret
.Llessgas_5: 
    shrd         %cl, %edx, %eax
    sar          %cl, %edx
    ret
.Lfe5:
.size __ashrdi3, .Lfe5-(__ashrdi3)
 .weak __divdi3 
.p2align 5, 0x90
 
.globl __divdi3
.type __divdi3, @function
 
__divdi3:
    xor          %ecx, %ecx
    movl         (8)(%esp), %eax
    or           %eax, %eax
    jge          .LApositivegas_6
    mov          $(1), %ecx
    movl         (4)(%esp), %edx
    neg          %eax
    neg          %edx
    sbb          $(0), %eax
    movl         %edx, (4)(%esp)
    movl         %eax, (8)(%esp)
.LApositivegas_6: 
    movl         (16)(%esp), %eax
    or           %eax, %eax
    jge          .LABpositivegas_6
    sub          $(1), %ecx
    movl         (12)(%esp), %edx
    neg          %eax
    neg          %edx
    sbb          $(0), %eax
    movl         %edx, (12)(%esp)
    movl         %eax, (16)(%esp)
.LABpositivegas_6: 
    movl         (16)(%esp), %eax
    xor          %edx, %edx
    push         %ecx
    test         %eax, %eax
    jne          .Lnon_zero_higas_6
    movl         (12)(%esp), %eax
    divl         (16)(%esp)
    mov          %eax, %ecx
    movl         (8)(%esp), %eax
    divl         (16)(%esp)
    mov          %ecx, %edx
    jmp          .Lreturngas_6
.Lnon_zero_higas_6: 
    movl         (12)(%esp), %ecx
    cmp          %ecx, %eax
    jb           .Ldivisor_greatergas_6
    jne          .Lreturn_zerogas_6
    movl         (16)(%esp), %ecx
    movl         (8)(%esp), %eax
    cmp          %eax, %ecx
    ja           .Lreturn_zerogas_6
.Lreturn_onegas_6: 
    mov          $(1), %eax
    jmp          .Lreturngas_6
.Lreturn_zerogas_6: 
    add          $(4), %esp
    xor          %eax, %eax
    ret
.Ldivisor_greatergas_6: 
    test         $(2147483648), %eax
    jne          .Lreturn_onegas_6
.Lfind_hi_bitgas_6: 
    bsr          %eax, %ecx
    add          $(1), %ecx
.Lhi_bit_foundgas_6: 
    movl         (16)(%esp), %edx
    push         %ebx
    shrd         %cl, %eax, %edx
    mov          %edx, %ebx
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    shrd         %cl, %edx, %eax
    shr          %cl, %edx
.Lmake_divgas_6: 
    div          %ebx
    mov          %eax, %ebx
    mull         (24)(%esp)
    mov          %eax, %ecx
    movl         (20)(%esp), %eax
    mul          %ebx
    add          %ecx, %edx
    jb           .Lneed_decgas_6
    cmpl         %edx, (16)(%esp)
    jb           .Lneed_decgas_6
    ja           .Lafter_decgas_6
    cmpl         %eax, (12)(%esp)
    jae          .Lafter_decgas_6
.Lneed_decgas_6: 
    sub          $(1), %ebx
.Lafter_decgas_6: 
    xor          %edx, %edx
    mov          %ebx, %eax
    pop          %ebx
.Lreturngas_6: 
    pop          %ecx
    test         %ecx, %ecx
    jne          .Lch_signgas_6
    ret
.Lch_signgas_6: 
    neg          %edx
    neg          %eax
    sbb          $(0), %edx
    ret
.Lfe6:
.size __divdi3, .Lfe6-(__divdi3)
 .weak __udivdi3 
.p2align 5, 0x90
 
.globl __udivdi3
.type __udivdi3, @function
 
__udivdi3:
    xor          %ecx, %ecx
.LABpositivegas_7: 
    movl         (16)(%esp), %eax
    xor          %edx, %edx
    push         %ecx
    test         %eax, %eax
    jne          .Lnon_zero_higas_7
    movl         (12)(%esp), %eax
    divl         (16)(%esp)
    mov          %eax, %ecx
    movl         (8)(%esp), %eax
    divl         (16)(%esp)
    mov          %ecx, %edx
    jmp          .Lreturngas_7
.Lnon_zero_higas_7: 
    movl         (12)(%esp), %ecx
    cmp          %ecx, %eax
    jb           .Ldivisor_greatergas_7
    jne          .Lreturn_zerogas_7
    movl         (16)(%esp), %ecx
    movl         (8)(%esp), %eax
    cmp          %eax, %ecx
    ja           .Lreturn_zerogas_7
.Lreturn_onegas_7: 
    mov          $(1), %eax
    jmp          .Lreturngas_7
.Lreturn_zerogas_7: 
    add          $(4), %esp
    xor          %eax, %eax
    ret
.Ldivisor_greatergas_7: 
    test         $(2147483648), %eax
    jne          .Lreturn_onegas_7
.Lfind_hi_bitgas_7: 
    bsr          %eax, %ecx
    add          $(1), %ecx
.Lhi_bit_foundgas_7: 
    movl         (16)(%esp), %edx
    push         %ebx
    shrd         %cl, %eax, %edx
    mov          %edx, %ebx
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    shrd         %cl, %edx, %eax
    shr          %cl, %edx
.Lmake_divgas_7: 
    div          %ebx
    mov          %eax, %ebx
    mull         (24)(%esp)
    mov          %eax, %ecx
    movl         (20)(%esp), %eax
    mul          %ebx
    add          %ecx, %edx
    jb           .Lneed_decgas_7
    cmpl         %edx, (16)(%esp)
    jb           .Lneed_decgas_7
    ja           .Lafter_decgas_7
    cmpl         %eax, (12)(%esp)
    jae          .Lafter_decgas_7
.Lneed_decgas_7: 
    sub          $(1), %ebx
.Lafter_decgas_7: 
    xor          %edx, %edx
    mov          %ebx, %eax
    pop          %ebx
.Lreturngas_7: 
    pop          %ecx
    test         %ecx, %ecx
    jne          .Lch_signgas_7
    ret
.Lch_signgas_7: 
    neg          %edx
    neg          %eax
    sbb          $(0), %edx
    ret
.Lfe7:
.size __udivdi3, .Lfe7-(__udivdi3)
 .weak __moddi3 
.p2align 5, 0x90
 
.globl __moddi3
.type __moddi3, @function
 
__moddi3:
    sub          $(8), %esp
    movl         $(0), (%esp)
    movl         (16)(%esp), %eax
    or           %eax, %eax
    jge          .LApositivegas_8
    incl         (%esp)
    movl         (12)(%esp), %edx
    neg          %eax
    neg          %edx
    sbb          $(0), %eax
    movl         %eax, (16)(%esp)
    movl         %edx, (12)(%esp)
.LApositivegas_8: 
    movl         (24)(%esp), %eax
    or           %eax, %eax
    jge          .LABpositivegas_8
    movl         (20)(%esp), %edx
    neg          %eax
    neg          %edx
    sbb          $(0), %eax
    movl         %eax, (24)(%esp)
    movl         %edx, (20)(%esp)
    jmp          .LABpositivegas_8
    lea          (%esi), %esi
    lea          (%edi), %edi
    sub          $(8), %esp
    movl         $(0), (%esp)
.LABpositivegas_8: 
    movl         (24)(%esp), %eax
    test         %eax, %eax
    jne          .Lnon_zero_higas_8
    movl         (16)(%esp), %eax
    mov          $(0), %edx
    divl         (20)(%esp)
    mov          %eax, %ecx
    movl         (12)(%esp), %eax
    divl         (20)(%esp)
    mov          %edx, %eax
    xor          %edx, %edx
    jmp          .Lreturngas_8
.Lnon_zero_higas_8: 
    movl         (16)(%esp), %ecx
    cmp          %ecx, %eax
    jb           .Ldivisor_greatergas_8
    jne          .Lreturn_devisorgas_8
    movl         (20)(%esp), %ecx
    cmpl         (12)(%esp), %ecx
    ja           .Lreturn_devisorgas_8
.Lreturn_difgas_8: 
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    subl         (20)(%esp), %eax
    sbbl         (24)(%esp), %edx
    jmp          .Lreturngas_8
.Lreturn_devisorgas_8: 
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    jmp          .Lreturngas_8
.Ldivisor_greatergas_8: 
    test         $(2147483648), %eax
    jne          .Lreturn_difgas_8
.Lfind_hi_bitgas_8: 
    bsr          %eax, %ecx
    add          $(1), %ecx
.Lhi_bit_foundgas_8: 
    push         %ebx
    movl         (24)(%esp), %edx
    shrd         %cl, %eax, %edx
    mov          %edx, %ebx
    movl         (16)(%esp), %eax
    movl         (20)(%esp), %edx
    shrd         %cl, %edx, %eax
    shr          %cl, %edx
    div          %ebx
    mov          %eax, %ebx
.Lmultiplegas_8: 
    mull         (28)(%esp)
    mov          %eax, %ecx
    movl         (24)(%esp), %eax
    mul          %ebx
    add          %ecx, %edx
    jb           .Lneed_decgas_8
    cmpl         %edx, (20)(%esp)
    jb           .Lneed_decgas_8
    ja           .Lafter_decgas_8
    cmpl         %eax, (16)(%esp)
    jb           .Lneed_decgas_8
.Lafter_decgas_8: 
    mov          %eax, %ebx
    movl         (16)(%esp), %eax
    sub          %ebx, %eax
    mov          %edx, %ebx
    movl         (20)(%esp), %edx
    sbb          %ebx, %edx
    pop          %ebx
.Lreturngas_8: 
    movl         %eax, (4)(%esp)
    movl         (%esp), %eax
    test         %eax, %eax
    jne          .Lch_signgas_8
    movl         (4)(%esp), %eax
    add          $(8), %esp
    ret
.Lch_signgas_8: 
    movl         (4)(%esp), %eax
    neg          %edx
    neg          %eax
    sbb          $(0), %edx
    add          $(8), %esp
    ret
.Lneed_decgas_8: 
    dec          %ebx
    mov          %ebx, %eax
    jmp          .Lmultiplegas_8
.Lfe8:
.size __moddi3, .Lfe8-(__moddi3)
 .weak __umoddi3 
.p2align 5, 0x90
 
.globl __umoddi3
.type __umoddi3, @function
 
__umoddi3:
    sub          $(8), %esp
    movl         $(0), (%esp)
.LABpositivegas_9: 
    movl         (24)(%esp), %eax
    test         %eax, %eax
    jne          .Lnon_zero_higas_9
    movl         (16)(%esp), %eax
    mov          $(0), %edx
    divl         (20)(%esp)
    mov          %eax, %ecx
    movl         (12)(%esp), %eax
    divl         (20)(%esp)
    mov          %edx, %eax
    xor          %edx, %edx
    jmp          .Lreturngas_9
.Lnon_zero_higas_9: 
    movl         (16)(%esp), %ecx
    cmp          %ecx, %eax
    jb           .Ldivisor_greatergas_9
    jne          .Lreturn_devisorgas_9
    movl         (20)(%esp), %ecx
    cmpl         (12)(%esp), %ecx
    ja           .Lreturn_devisorgas_9
.Lreturn_difgas_9: 
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    subl         (20)(%esp), %eax
    sbbl         (24)(%esp), %edx
    jmp          .Lreturngas_9
.Lreturn_devisorgas_9: 
    movl         (12)(%esp), %eax
    movl         (16)(%esp), %edx
    jmp          .Lreturngas_9
.Ldivisor_greatergas_9: 
    test         $(2147483648), %eax
    jne          .Lreturn_difgas_9
.Lfind_hi_bitgas_9: 
    bsr          %eax, %ecx
    add          $(1), %ecx
.Lhi_bit_foundgas_9: 
    push         %ebx
    movl         (24)(%esp), %edx
    shrd         %cl, %eax, %edx
    mov          %edx, %ebx
    movl         (16)(%esp), %eax
    movl         (20)(%esp), %edx
    shrd         %cl, %edx, %eax
    shr          %cl, %edx
    div          %ebx
    mov          %eax, %ebx
.Lmultiplegas_9: 
    mull         (28)(%esp)
    mov          %eax, %ecx
    movl         (24)(%esp), %eax
    mul          %ebx
    add          %ecx, %edx
    jb           .Lneed_decgas_9
    cmpl         %edx, (20)(%esp)
    jb           .Lneed_decgas_9
    ja           .Lafter_decgas_9
    cmpl         %eax, (16)(%esp)
    jb           .Lneed_decgas_9
.Lafter_decgas_9: 
    mov          %eax, %ebx
    movl         (16)(%esp), %eax
    sub          %ebx, %eax
    mov          %edx, %ebx
    movl         (20)(%esp), %edx
    sbb          %ebx, %edx
    pop          %ebx
.Lreturngas_9: 
    movl         %eax, (4)(%esp)
    movl         (%esp), %eax
    test         %eax, %eax
    jne          .Lch_signgas_9
    movl         (4)(%esp), %eax
    add          $(8), %esp
    ret
.Lch_signgas_9: 
    movl         (4)(%esp), %eax
    neg          %edx
    neg          %eax
    sbb          $(0), %edx
    add          $(8), %esp
    ret
.Lneed_decgas_9: 
    dec          %ebx
    mov          %ebx, %eax
    jmp          .Lmultiplegas_9
.Lfe9:
.size __umoddi3, .Lfe9-(__umoddi3)
 .weak __muldi3 
.p2align 5, 0x90
 
.globl __muldi3
.type __muldi3, @function
 
__muldi3:
    movl         (8)(%esp), %eax
    mull         (12)(%esp)
    mov          %eax, %ecx
    movl         (4)(%esp), %eax
    mull         (16)(%esp)
    add          %eax, %ecx
    movl         (4)(%esp), %eax
    mull         (12)(%esp)
    add          %ecx, %edx
    ret
.Lfe10:
.size __muldi3, .Lfe10-(__muldi3)
.p2align 5, 0x90
 
.globl cp_get_pentium_counter
.type cp_get_pentium_counter, @function
 
cp_get_pentium_counter:
    rdtsc
    ret
.Lfe11:
.size cp_get_pentium_counter, .Lfe11-(cp_get_pentium_counter)
.p2align 5, 0x90
 
.globl cpStartTscp
.type cpStartTscp, @function
 
cpStartTscp:
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
rdtscp 
    ret
.Lfe12:
.size cpStartTscp, .Lfe12-(cpStartTscp)
.p2align 5, 0x90
 
.globl cpStopTscp
.type cpStopTscp, @function
 
cpStopTscp:
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
.Lfe13:
.size cpStopTscp, .Lfe13-(cpStopTscp)
.p2align 5, 0x90
 
.globl cpStartTsc
.type cpStartTsc, @function
 
cpStartTsc:
    push         %ebx
    xor          %eax, %eax
    cpuid
    pop          %ebx
    rdtsc
    ret
.Lfe14:
.size cpStartTsc, .Lfe14-(cpStartTsc)
.p2align 5, 0x90
 
.globl cpStopTsc
.type cpStopTsc, @function
 
cpStopTsc:
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
.Lfe15:
.size cpStopTsc, .Lfe15-(cpStopTsc)
.p2align 5, 0x90
 
.globl cpGetCacheSize
.type cpGetCacheSize, @function
 
cpGetCacheSize:
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
    jne          .LGetCacheSize_11gas_16
    test         $(2147483648), %eax
    jz           .LGetCacheSize_00gas_16
    xor          %eax, %eax
.LGetCacheSize_00gas_16: 
    test         $(2147483648), %ebx
    jz           .LGetCacheSize_01gas_16
    xor          %ebx, %ebx
.LGetCacheSize_01gas_16: 
    test         $(2147483648), %ecx
    jz           .LGetCacheSize_02gas_16
    xor          %ecx, %ecx
.LGetCacheSize_02gas_16: 
    test         $(2147483648), %edx
    jz           .LGetCacheSize_03gas_16
    xor          %edx, %edx
.LGetCacheSize_03gas_16: 
    test         %eax, %eax
    jz           .LGetCacheSize_04gas_16
    mov          %eax, (%ebp)
    add          $(4), %ebp
    add          $(3), %esi
.LGetCacheSize_04gas_16: 
    test         %ebx, %ebx
    jz           .LGetCacheSize_05gas_16
    mov          %ebx, (%ebp)
    add          $(4), %ebp
    add          $(4), %esi
.LGetCacheSize_05gas_16: 
    test         %ecx, %ecx
    jz           .LGetCacheSize_06gas_16
    mov          %ecx, (%ebp)
    add          $(4), %ebp
    add          $(4), %esi
.LGetCacheSize_06gas_16: 
    test         %edx, %edx
    jz           .LGetCacheSize_07gas_16
    mov          %edx, (%ebp)
    add          $(4), %esi
.LGetCacheSize_07gas_16: 
    test         %esi, %esi
    jz           .LGetCacheSize_11gas_16
    mov          $(-1), %eax
.LGetCacheSize_08gas_16: 
    xor          %edx, %edx
    add          (%edi), %edx
    jz           .LExitGetCacheSize00gas_16
    add          $(8), %edi
    mov          %esi, %ecx
.LGetCacheSize_09gas_16: 
    cmpb         (%esp,%ecx), %dl
    je           .LGetCacheSize_10gas_16
    dec          %ecx
    jnz          .LGetCacheSize_09gas_16
    jmp          .LGetCacheSize_08gas_16
.LGetCacheSize_10gas_16: 
    mov          (-4)(%edi), %eax
.LExitGetCacheSize00gas_16: 
    add          $(16), %esp
    pop          %ebp
    pop          %ebx
    pop          %esi
    pop          %edi
    ret
.LGetCacheSize_11gas_16: 
    mov          $(-1), %eax
    jmp          .LExitGetCacheSize00gas_16
.Lfe16:
.size cpGetCacheSize, .Lfe16-(cpGetCacheSize)
 
