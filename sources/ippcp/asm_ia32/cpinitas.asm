;===============================================================================
; Copyright 2014-2018 Intel Corporation
; All Rights Reserved.
;
; If this  software was obtained  under the  Intel Simplified  Software License,
; the following terms apply:
;
; The source code,  information  and material  ("Material") contained  herein is
; owned by Intel Corporation or its  suppliers or licensors,  and  title to such
; Material remains with Intel  Corporation or its  suppliers or  licensors.  The
; Material  contains  proprietary  information  of  Intel or  its suppliers  and
; licensors.  The Material is protected by  worldwide copyright  laws and treaty
; provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
; modified, published,  uploaded, posted, transmitted,  distributed or disclosed
; in any way without Intel's prior express written permission.  No license under
; any patent,  copyright or other  intellectual property rights  in the Material
; is granted to  or  conferred  upon  you,  either   expressly,  by implication,
; inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
; property rights must be express and approved by Intel in writing.
;
; Unless otherwise agreed by Intel in writing,  you may not remove or alter this
; notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
; suppliers or licensors in any way.
;
;
; If this  software  was obtained  under the  Apache License,  Version  2.0 (the
; "License"), the following terms apply:
;
; You may  not use this  file except  in compliance  with  the License.  You may
; obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
;
;
; Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
; distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
; WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;
; See the   License  for the   specific  language   governing   permissions  and
; limitations under the License.
;===============================================================================

INCLUDE asmdefs.inc

  .686
  .XMM
  .model FLAT, C

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

IFDEF _IPP_DATA

;####################################################################
;#          void ownGetReg( int* buf, int valueEAX, int valueECX ); #
;####################################################################

buf       EQU [esp+12]
valueEAX  EQU [esp+16]
valueECX  EQU [esp+20]

cpGetReg PROC PUBLIC

        push    ebx
        push    esi
        mov     eax, valueEAX
        mov     ecx, valueECX
        xor     ebx, ebx
        xor     edx, edx
        mov     esi, buf
        cpuid
        mov     [esi], eax
        mov     [esi + 4], ebx
        mov     [esi + 8], ecx
        mov     [esi + 12], edx
        pop     esi
        pop     ebx
        ret

cpGetReg ENDP

;###################################################

; Feature information after XGETBV(ECX=0), EAX, bits 2,1 ( XMM state and YMM state are enabled by OS )
XGETBV_MASK          equ   06h
; OSXSAVE support, feature information after cpuid(1), ECX, bit 27 ( XGETBV is enabled by OS )
XSAVEXGETBV_FLAG     equ   8000000h
XGETBV_AVX512_MASK   equ   0E0h

cp_is_avx_extension PROC NEAR C PUBLIC Uses ebx edx ecx
         mov eax, 1
         cpuid
         xor   eax, eax
         and   ecx, 018000000h
         cmp   ecx, 018000000h
         jne   not_avx
         xor   ecx, ecx
         db 00fh,001h,0d0h        ; xgetbv      
         mov   ecx, eax           
         xor   eax, eax
         and   ecx, XGETBV_MASK
         cmp   ecx, XGETBV_MASK
         jne   not_avx
         mov   eax, 1    
not_avx:
         ret
cp_is_avx_extension ENDP

cp_is_avx512_extension PROC NEAR C PUBLIC Uses ebx edx ecx
         mov eax, 1
         cpuid
         xor   eax, eax
         and   ecx, XSAVEXGETBV_FLAG
         cmp   ecx, XSAVEXGETBV_FLAG
         jne   not_avx512
         xor   ecx, ecx
         db 00fh,001h,0d0h        ; xgetbv      
         mov   ecx, eax           
         xor   eax, eax
         and   ecx, XGETBV_AVX512_MASK
         cmp   ecx, XGETBV_AVX512_MASK
         jne   not_avx512
         mov   eax, 1    
not_avx512:
         ret
cp_is_avx512_extension ENDP

IFDEF LINUX32
  IFNDEF OSX32

%ECHO .weak __ashldi3

__ashldi3 PROC PUBLIC
        mov    eax, [esp+4]
        mov    edx, [esp+8]
        mov    ecx, [esp+12]
        test   cl, 20H
        je     less
        mov    edx, eax
        xor    eax, eax
        shl    edx, cl
        ret    
less:
        shld   edx, eax, cl
        shl    eax, cl
        ret    
__ashldi3 ENDP

ALIGN IPP_ALIGN_FACTOR

%ECHO .weak __ashrdi3

__ashrdi3 PROC PUBLIC
        mov    eax, [esp+4]
        mov    edx, [esp+8]
        mov    ecx, [esp+12]
        test   cl, 20H
        je     less
        mov    eax, edx
        sar    edx, 1FH
        sar    eax, cl
        ret    
less:
        shrd   eax, edx, cl
        sar    edx, cl
        ret    
__ashrdi3 ENDP

%ECHO .weak __divdi3

__divdi3 PROC PUBLIC
        xor    ecx, ecx
        mov    eax, dword ptr [8+esp]
        or     eax, eax
        jge    Apositive
        mov    ecx, 1
        mov    edx, dword ptr [4+esp]
        neg    eax
        neg    edx
        sbb    eax, 0
        mov    dword ptr [4+esp], edx
        mov    dword ptr [8+esp], eax
Apositive:
        mov    eax, dword ptr [16+esp]
        or     eax,eax
        jge    ABpositive
        sub    ecx, 1
        mov    edx, dword ptr [12+esp]
        neg    eax
        neg    edx
        sbb    eax, 0
        mov    dword ptr [12+esp], edx
        mov    dword ptr [16+esp], eax
ABpositive:
        mov    eax, dword ptr [16+esp]
        xor    edx, edx
        push   ecx
        test   eax, eax
        jne    non_zero_hi
        mov    eax, dword ptr [12+esp]
        div    dword ptr [16+esp]
        mov    ecx, eax
        mov    eax, dword ptr [8+esp]
        div    dword ptr [16+esp]
        mov    edx, ecx
        jmp    return
non_zero_hi:
        mov    ecx, dword ptr [12+esp]
        cmp    eax, ecx
        jb     divisor_greater
        jne    return_zero
        mov    ecx, dword ptr [16+esp]
        mov    eax, dword ptr [8+esp]
        cmp    ecx, eax
        ja     return_zero
return_one:
        mov    eax, 1
        jmp    return
return_zero:
        add    esp, 4
        xor    eax, eax
        ret    
divisor_greater:
        test   eax, 80000000h
        jne    return_one
find_hi_bit:
        bsr    ecx, eax
        add    ecx, 1
hi_bit_found:
        mov    edx, dword ptr [16+esp]
        push   ebx
        shrd   edx, eax, cl
        mov    ebx, edx
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        shrd   eax, edx, cl
        shr    edx, cl
make_div:
        div    ebx
        mov    ebx, eax
        mul    dword ptr [24+esp]
        mov    ecx, eax
        mov    eax, dword ptr [20+esp]
        mul    ebx
        add    edx, ecx
        jb     need_dec
        cmp    dword ptr [16+esp], edx
        jb     need_dec
        ja     after_dec
        cmp    dword ptr [12+esp], eax
        jae    after_dec
need_dec:
        sub    ebx, 1
after_dec:
        xor    edx, edx
        mov    eax, ebx
        pop    ebx
return:
        pop    ecx
        test   ecx, ecx
        jne    ch_sign
        ret    
ch_sign:
        neg    edx
        neg    eax
        sbb    edx, 0
        ret    
__divdi3 ENDP

%ECHO .weak __udivdi3
        
__udivdi3 PROC PUBLIC
        xor    ecx,ecx
ABpositive:
        mov    eax, dword ptr [16+esp]
        xor    edx, edx
        push   ecx
        test   eax, eax
        jne    non_zero_hi
        mov    eax, dword ptr [12+esp]
        div    dword ptr [16+esp]
        mov    ecx, eax
        mov    eax, dword ptr [8+esp]
        div    dword ptr [16+esp]
        mov    edx, ecx
        jmp    return
non_zero_hi:
        mov    ecx, dword ptr [12+esp]
        cmp    eax, ecx
        jb     divisor_greater
        jne    return_zero
        mov    ecx, dword ptr [16+esp]
        mov    eax, dword ptr [8+esp]
        cmp    ecx, eax
        ja     return_zero
return_one:
        mov    eax, 1
        jmp    return
return_zero:
        add    esp, 4
        xor    eax, eax
        ret    
divisor_greater:
        test   eax, 80000000h
        jne    return_one
find_hi_bit:
        bsr    ecx, eax
        add    ecx, 1
hi_bit_found:
        mov    edx, dword ptr [16+esp]
        push   ebx
        shrd   edx, eax, cl
        mov    ebx, edx
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        shrd   eax, edx, cl
        shr    edx, cl
make_div:
        div    ebx
        mov    ebx, eax
        mul    dword ptr [24+esp]
        mov    ecx, eax
        mov    eax, dword ptr [20+esp]
        mul    ebx
        add    edx, ecx
        jb     need_dec
        cmp    dword ptr [16+esp], edx
        jb     need_dec
        ja     after_dec
        cmp    dword ptr [12+esp], eax
        jae    after_dec
need_dec:
        sub    ebx, 1
after_dec:
        xor    edx, edx
        mov    eax, ebx
        pop    ebx
return:
        pop    ecx
        test   ecx, ecx
        jne    ch_sign
        ret    
ch_sign:
        neg    edx
        neg    eax
        sbb    edx, 0
        ret    
__udivdi3 ENDP        

%ECHO .weak __moddi3

__moddi3 PROC PUBLIC
        sub    esp, 8
        mov    dword ptr [esp], 0
        mov    eax, dword ptr [esp+16]
        or     eax, eax
        jge    Apositive
        inc    dword ptr [esp]
        mov    edx, dword ptr [esp+12]
        neg    eax
        neg    edx
        sbb    eax, 0
        mov    dword ptr [esp+16], eax
        mov    dword ptr [esp+12], edx

Apositive:
        mov    eax, dword ptr [esp+24]
        or     eax, eax
        jge    ABpositive
        mov    edx, dword ptr [esp+20]
        neg    eax
        neg    edx
        sbb    eax, 0
        mov    dword ptr [esp+24], eax
        mov    dword ptr [esp+20], edx
        jmp    ABpositive
        lea    esi, dword ptr [esi]
        lea    edi, dword ptr [edi]

        sub    esp, 8
        mov    dword ptr [esp], 0

ABpositive:
        mov    eax, dword ptr [esp+24]
        test   eax, eax
        jne    non_zero_hi
        mov    eax, dword ptr [esp+16]
        mov    edx, 0
        div    dword ptr [esp+20]
        mov    ecx, eax
        mov    eax, dword ptr [12+esp]
        div    dword ptr [20+esp]
        mov    eax, edx
        xor    edx, edx
        jmp    return

non_zero_hi:
        mov    ecx, dword ptr [16+esp]
        cmp    eax, ecx
        jb     divisor_greater
        jne    return_devisor
        mov    ecx, dword ptr [20+esp]
        cmp    ecx, dword ptr [12+esp]
        ja     return_devisor

return_dif:
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        sub    eax, dword ptr [20+esp]
        sbb    edx, dword ptr [24+esp]
        jmp    return

return_devisor:
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        jmp    return

divisor_greater:
        test   eax, 80000000h
        jne    return_dif

find_hi_bit:
        bsr    ecx, eax
        add    ecx, 1

hi_bit_found:
        push   ebx
        mov    edx, dword ptr [24+esp]
        shrd   edx, eax, cl
        mov    ebx, edx
        mov    eax, dword ptr [16+esp]
        mov    edx, dword ptr [20+esp]
        shrd   eax, edx, cl
        shr    edx, cl
        div    ebx
        mov    ebx, eax

multiple:
        mul    dword ptr [28+esp]
        mov    ecx, eax
        mov    eax, dword ptr [24+esp]
        mul    ebx
        add    edx, ecx
        jb     need_dec
        cmp    dword ptr [20+esp], edx
        jb     need_dec
        ja     after_dec
        cmp    dword ptr [16+esp], eax
        jb     need_dec

after_dec:
        mov    ebx, eax
        mov    eax, dword ptr [16+esp]
        sub    eax, ebx
        mov    ebx, edx
        mov    edx, dword ptr [20+esp]
        sbb    edx, ebx
        pop    ebx

return:
        mov    dword ptr [4+esp], eax
        mov    eax, dword ptr [esp]
        test   eax, eax
        jne    ch_sign
        mov    eax, dword ptr [4+esp]
        add    esp, 8
        ret    

ch_sign:
        mov    eax, dword ptr [4+esp]
        neg    edx
        neg    eax
        sbb    edx, 0
        add    esp, 8
        ret    

need_dec:
        dec    ebx
        mov    eax, ebx
        jmp    multiple
__moddi3 ENDP

%ECHO .weak __umoddi3

__umoddi3 PROC PUBLIC
        sub    esp, 8
        mov    dword ptr [esp], 0

ABpositive:
        mov    eax, dword ptr [esp+24]
        test   eax, eax
        jne    non_zero_hi
        mov    eax, dword ptr [esp+16]
        mov    edx, 0
        div    dword ptr [esp+20]
        mov    ecx, eax
        mov    eax, dword ptr [12+esp]
        div    dword ptr [20+esp]
        mov    eax, edx
        xor    edx, edx
        jmp    return

non_zero_hi:
        mov    ecx, dword ptr [16+esp]
        cmp    eax, ecx
        jb     divisor_greater
        jne    return_devisor
        mov    ecx, dword ptr [20+esp]
        cmp    ecx, dword ptr [12+esp]
        ja     return_devisor

return_dif:
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        sub    eax, dword ptr [20+esp]
        sbb    edx, dword ptr [24+esp]
        jmp    return

return_devisor:
        mov    eax, dword ptr [12+esp]
        mov    edx, dword ptr [16+esp]
        jmp    return

divisor_greater:
        test   eax, 80000000h
        jne    return_dif

find_hi_bit:
        bsr    ecx, eax
        add    ecx, 1

hi_bit_found:
        push   ebx
        mov    edx, dword ptr [24+esp]
        shrd   edx, eax, cl
        mov    ebx, edx
        mov    eax, dword ptr [16+esp]
        mov    edx, dword ptr [20+esp]
        shrd   eax, edx, cl
        shr    edx, cl
        div    ebx
        mov    ebx, eax

multiple:
        mul    dword ptr [28+esp]
        mov    ecx, eax
        mov    eax, dword ptr [24+esp]
        mul    ebx
        add    edx, ecx
        jb     need_dec
        cmp    dword ptr [20+esp], edx
        jb     need_dec
        ja     after_dec
        cmp    dword ptr [16+esp], eax
        jb     need_dec

after_dec:
        mov    ebx, eax
        mov    eax, dword ptr [16+esp]
        sub    eax, ebx
        mov    ebx, edx
        mov    edx, dword ptr [20+esp]
        sbb    edx, ebx
        pop    ebx

return:
        mov    dword ptr [4+esp], eax
        mov    eax, dword ptr [esp]
        test   eax, eax
        jne    ch_sign
        mov    eax, dword ptr [4+esp]
        add    esp, 8
        ret    

ch_sign:
        mov    eax, dword ptr [4+esp]
        neg    edx
        neg    eax
        sbb    edx, 0
        add    esp, 8
        ret    

need_dec:
        dec    ebx
        mov    eax, ebx
        jmp    multiple
__umoddi3 ENDP

%ECHO .weak __muldi3

__muldi3 PROC PUBLIC
        mov    eax, dword ptr [esp+8]
        mul    dword ptr [esp+12]
        mov    ecx, eax
        mov    eax, dword ptr [esp+4]
        mul    dword ptr [esp+16]
        add    ecx, eax
        mov    eax, dword ptr [esp+4]
        mul    dword ptr [esp+12]
        add    edx, ecx
        ret    
__muldi3 ENDP

  ENDIF;  IFNDEF OSX32
ENDIF; IFDEF LINUX32


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cp_get_pentium_counter PROC NEAR C PUBLIC
         rdtsc
         ret
cp_get_pentium_counter ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cpStartTscp PROC NEAR C PUBLIC
         push     ebx
         xor      eax, eax
         cpuid
         pop      ebx
         rdtscp
         ret
cpStartTscp ENDP

cpStopTscp PROC NEAR C PUBLIC
         rdtscp
         push     eax
         push     edx
         push     ebx
         xor      eax, eax
         cpuid
         pop      ebx
         pop      edx
         pop      eax
         ret
cpStopTscp ENDP

cpStartTsc PROC NEAR C PUBLIC
         push     ebx
         xor      eax, eax
         cpuid
         pop      ebx
         rdtsc
         ret
cpStartTsc ENDP

cpStopTsc PROC NEAR C PUBLIC
         rdtsc
         push     eax
         push     edx
         push     ebx
         xor      eax, eax
         cpuid
         pop      ebx
         pop      edx
         pop      eax
         ret
cpStopTsc ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;*****************************************
; int cpGetCacheSize( int* tableCache );
PUBLIC  cpGetCacheSize
table   EQU 36[esp]
cpGetCacheSize  PROC
        push    edi
        push    esi
        push    ebx
        push    ebp
        sub     esp, 16

        mov     edi, table
        mov     ebp, esp
        xor     esi, esi

        mov     eax, 2
        cpuid

        cmp     al, 1
        jne     GetCacheSize_11

        test    eax, 080000000h
        jz      GetCacheSize_00
        xor     eax, eax
GetCacheSize_00:
        test    ebx, 080000000h
        jz      GetCacheSize_01
        xor     ebx, ebx
GetCacheSize_01:
        test    ecx, 080000000h
        jz      GetCacheSize_02
        xor     ecx, ecx
GetCacheSize_02:
        test    edx, 080000000h
        jz      GetCacheSize_03
        xor     edx, edx

GetCacheSize_03:
        test    eax, eax
        jz      GetCacheSize_04
        mov     [ebp], eax
        add     ebp, 4
        add     esi, 3
GetCacheSize_04:
        test    ebx, ebx
        jz      GetCacheSize_05
        mov     [ebp], ebx
        add     ebp, 4
        add     esi, 4
GetCacheSize_05:
        test    ecx, ecx
        jz      GetCacheSize_06
        mov     [ebp], ecx
        add     ebp, 4
        add     esi, 4
GetCacheSize_06:
        test    edx, edx
        jz      GetCacheSize_07
        mov     [ebp], edx
        add     esi, 4

GetCacheSize_07:
        test    esi, esi
        jz      GetCacheSize_11
        mov     eax, -1
GetCacheSize_08:
        xor     edx, edx
        add     edx, [edi]
        jz      ExitGetCacheSize00
        add     edi, 8
        mov     ecx, esi
GetCacheSize_09:
        cmp     dl, BYTE PTR [esp + ecx]
        je      GetCacheSize_10
        dec     ecx
        jnz     GetCacheSize_09
        jmp     GetCacheSize_08

GetCacheSize_10:
        mov     eax, [edi - 4]

ExitGetCacheSize00:
        add     esp, 16
        pop     ebp
        pop     ebx
        pop     esi
        pop     edi
        ret

GetCacheSize_11:
        mov     eax, -1
        jmp     ExitGetCacheSize00

cpGetCacheSize  ENDP

;*****************************************

ENDIF ; IPP_DATA
END
