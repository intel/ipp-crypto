;===============================================================================
; Copyright 2014-2019 Intel Corporation
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
 include ia_32e.inc

LOCAL_ALIGN_FACTOR EQU 32
 
IFDEF _IPP_DATA
IPPCODE SEGMENT 'CODE' ALIGN (LOCAL_ALIGN_FACTOR)

;####################################################################
;#          void cpGetReg( int* buf, int valueEAX, int valueECX ); #
;####################################################################

IFDEF _WIN64
buf       equ rcx
valueEAX  equ edx
valueECX  equ r8d
ELSE
buf       equ rdi
valueEAX  equ esi
valueECX  equ edx
ENDIF

ALIGN LOCAL_ALIGN_FACTOR
cpGetReg    PROC PUBLIC
        push rbx
        movsxd  r9, valueEAX
        movsxd  r10, valueECX
        mov     r11, buf

        mov     rax, r9
        mov     rcx, r10
        xor     ebx, ebx
        xor     edx, edx
        cpuid
        mov     [r11], eax
        mov     [r11 + 4], ebx
        mov     [r11 + 8], ecx
        mov     [r11 + 12], edx
        pop rbx
        ret

cpGetReg ENDP

;###################################################

; OSXSAVE support, feature information after cpuid(1), ECX, bit 27 ( XGETBV is enabled by OS )
XSAVEXGETBV_FLAG   equ   8000000h

; Feature information after XGETBV(ECX=0), EAX, bits 2,1 ( XMM state and YMM state are enabled by OS )
XGETBV_MASK        equ   06h

XGETBV_AVX512_MASK equ 0E0h

ALIGN LOCAL_ALIGN_FACTOR
cp_is_avx_extension PROC PUBLIC
         push  rbx
         mov   eax, 1
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
         pop   rbx
         ret
cp_is_avx_extension ENDP

ALIGN LOCAL_ALIGN_FACTOR
cp_is_avx512_extension PROC PUBLIC
         push  rbx
         mov   eax, 1
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
         pop   rbx
         ret
cp_is_avx512_extension ENDP

ALIGN LOCAL_ALIGN_FACTOR
cp_issue_avx512_instruction PROC PUBLIC
         db    062h,0f1h,07dh,048h,0efh,0c0h ; vpxord  zmm0, zmm0, zmm0
         xor   eax, eax
         ret
cp_issue_avx512_instruction ENDP

IFDEF _WIN64
  EXTRN ippcpInit:PROC
ENDIF

;####################################################################
;#          void ippSafeInit( );                                    #
;####################################################################

ALIGN LOCAL_ALIGN_FACTOR
ippcpSafeInit PROC PUBLIC
        push rcx
        push rdx
IFDEF LINUX32E
        push rdi
        push rsi
ENDIF
        push r8
        push r9
IFDEF LINUX32E
  IFDEF OSXEM64T
    %ECHO   call _ippcpInit
  ELSE
    IFDEF IPP_PIC
       %ECHO   call ippcpInit@PLT
    ELSE
      %ECHO   call ippcpInit
    ENDIF
  ENDIF
ELSE
        call ippcpInit
ENDIF
        pop  r9
        pop  r8
IFDEF LINUX32E
        pop  rsi
        pop  rdi
ENDIF
        pop  rdx
        pop  rcx
        ret
ippcpSafeInit ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIGN LOCAL_ALIGN_FACTOR
cp_get_pentium_counter PROC  PUBLIC
         rdtsc
         sal    rdx,32
         or     rax,rdx
         ret
cp_get_pentium_counter ENDP

ALIGN LOCAL_ALIGN_FACTOR
cpStartTscp PROC PUBLIC
         push     rbx
         xor      rax, rax
         cpuid
         pop      rbx
         rdtscp
         sal      rdx,32
         or       rax,rdx
         ret
cpStartTscp ENDP

ALIGN LOCAL_ALIGN_FACTOR
cpStopTscp PROC PUBLIC
         rdtscp
         sal      rdx,32
         or       rax,rdx
         push     rax
         push     rbx
         xor      rax, rax
         cpuid
         pop      rbx
         pop      rax
         ret
cpStopTscp ENDP

ALIGN LOCAL_ALIGN_FACTOR
cpStartTsc PROC PUBLIC
         push     rbx
         xor      rax, rax
         cpuid
         pop      rbx
         rdtsc
         sal      rdx,32
         or       rax,rdx
         ret
cpStartTsc ENDP

ALIGN LOCAL_ALIGN_FACTOR
cpStopTsc PROC PUBLIC
         rdtsc
         sal      rdx,32
         or       rax,rdx
         push     rax
         push     rbx
         xor      rax, rax
         cpuid
         pop      rbx
         pop      rax
         ret
cpStopTsc ENDP


;*****************************************
; int cpGetCacheSize( int* tableCache );
ALIGN LOCAL_ALIGN_FACTOR
table   EQU rdi
cpGetCacheSize  PROC PUBLIC FRAME

        USES_GPR rsi, rdi, rbx, rbp
        LOCAL_FRAME = 16
        USES_XMM
        COMP_ABI 1

        mov     rbp, rsp
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
        mov     [rbp], eax
        add     rbp, 4
        add     esi, 3
GetCacheSize_04:
        test    ebx, ebx
        jz      GetCacheSize_05
        mov     [rbp], ebx
        add     rbp, 4
        add     esi, 4
GetCacheSize_05:
        test    ecx, ecx
        jz      GetCacheSize_06
        mov     [rbp], ecx
        add     rbp, 4
        add     esi, 4
GetCacheSize_06:
        test    edx, edx
        jz      GetCacheSize_07
        mov     [rbp], edx
        add     esi, 4

GetCacheSize_07:
        test    esi, esi
        jz      GetCacheSize_11
        mov     eax, -1
GetCacheSize_08:
        xor     edx, edx
        add     edx, [table]
        jz      ExitGetCacheSize00
        add     table, 8
        mov     ecx, esi
GetCacheSize_09:
        cmp     dl, BYTE PTR [rsp + rcx]
        je      GetCacheSize_10
        dec     ecx
        jnz     GetCacheSize_09
        jmp     GetCacheSize_08

GetCacheSize_10:
        mov     eax, [table - 4]

ExitGetCacheSize00:
        REST_XMM
        REST_GPR
        ret

GetCacheSize_11:
        mov     eax, -1
        jmp     ExitGetCacheSize00

cpGetCacheSize  ENDP

;*
;****************************

ENDIF ; _IPP_DATA
END
