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

; 
; 
;     Purpose:  Cryptography Primitive.
;               Big Number Operations
; 
;     Content:
;        cpAdd_BNU()
; 
;

include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;*************************************************************
;* Ipp64u cpAdd_BNU(Ipp64u* pDst,
;*             const Ipp64u* pSrc1,
;*             const Ipp64u* pSrc2,
;*                   int len)
;* returns carry
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpAdd_BNU PROC PUBLIC FRAME
    USES_GPR rsi,rdi
    LOCAL_FRAME = 0
    USES_XMM
    COMP_ABI 4

; rdi = pDst
; rsi = pSrcA
; rdx = pSrcB
; rcx = len

   movsxd   rcx, ecx    ; unsigned length
   xor      rax, rax

    cmp     rcx, 2
    jge     ADD_GE2

;********** lenSrcA == 1 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; rsi = a
    adc     r8, qword ptr [rdx]             ; r8  = a+b = s
    mov     qword ptr [rdi], r8             ; save s
    sbb     rax, rax                        ;
    jmp     FINAL

;********** lenSrcA == 1  END ********************************

ADD_GE2:
    jg      ADD_GT2

;********** lenSrcA == 2 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     qword ptr [rdi], r8             ; save s0
    mov     qword ptr [rdi+8], r9           ; save s1
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 2 END *********************************

ADD_GT2:
    cmp     rcx, 4
    jge     ADD_GE4

;********** lenSrcA == 3 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     qword ptr [rdi], r8             ; save s0
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     qword ptr [rdi+16], r10         ; save s2
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 3 END *********************************

ADD_GE4:
    jg      ADD_GT4

;********** lenSrcA == 4 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword ptr [rsi+24]         ; r11 = a3
    adc     r11, qword ptr [rdx+24]         ; r11 = a3+b3 = s3
    mov     qword ptr [rdi], r8             ; save s0
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     qword ptr [rdi+16], r10         ; save s2
    mov     qword ptr [rdi+24], r11         ; save s2
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 4 END *********************************

ADD_GT4:
    cmp     rcx, 6
    jge     ADD_GE6

;********** lenSrcA == 5 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword ptr [rsi+24]         ; r11 = a3
    adc     r11, qword ptr [rdx+24]         ; r11 = a3+b3 = s3
    mov     rcx, qword ptr [rsi+32]         ; rcx = a4
    adc     rcx, qword ptr [rdx+32]         ; rcx = a4+b4 = s4
    mov     qword ptr [rdi], r8             ; save s0
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     qword ptr [rdi+16], r10         ; save s2
    mov     qword ptr [rdi+24], r11         ; save s3
    mov     qword ptr [rdi+32], rcx         ; save s4
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 5 END *********************************

ADD_GE6:
    jg      ADD_GT6

;********** lenSrcA == 6 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword ptr [rsi+24]         ; r11 = a3
    adc     r11, qword ptr [rdx+24]         ; r11 = a3+b3 = s3
    mov     rcx, qword ptr [rsi+32]         ; rcx = a4
    adc     rcx, qword ptr [rdx+32]         ; rcx = a4+b4 = s4
    mov     rsi, qword ptr [rsi+40]         ; rsi = a5
    adc     rsi, qword ptr [rdx+40]         ; rsi = a5+b5 = s5
    mov     qword ptr [rdi], r8             ; save s0
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     qword ptr [rdi+16], r10         ; save s2
    mov     qword ptr [rdi+24], r11         ; save s3
    mov     qword ptr [rdi+32], rcx         ; save s4
    mov     qword ptr [rdi+40], rsi         ; save s5
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 6 END *********************************

ADD_GT6:
    cmp     rcx, 8
    jge     ADD_GE8

ADD_EQ7:
;********** lenSrcA == 7 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword ptr [rsi+24]         ; r11 = a3
    adc     r11, qword ptr [rdx+24]         ; r11 = a3+b3 = s3
    mov     rcx, qword ptr [rsi+32]         ; rcx = a4
    adc     rcx, qword ptr [rdx+32]         ; rcx = a4+b4 = s4
    mov     qword ptr [rdi], r8             ; save s0
    mov     r8, qword ptr [rsi+40]          ; r8  = a5
    adc     r8, qword ptr [rdx+40]          ; r8  = a5+b5 = s5
    mov     rsi, qword ptr [rsi+48]         ; rsi = a6
    adc     rsi, qword ptr [rdx+48]         ; rsi = a6+b6 = s6
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     qword ptr [rdi+16], r10         ; save s2
    mov     qword ptr [rdi+24], r11         ; save s3
    mov     qword ptr [rdi+32], rcx         ; save s4
    mov     qword ptr [rdi+40], r8          ; save s5
    mov     qword ptr [rdi+48], rsi         ; save s6
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 7 END *********************************


ADD_GE8:
    jg       ADD_GT8

;********** lenSrcA == 8 *************************************
    add     rax, rax
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword ptr [rsi+16]         ; r10 = a2
    adc     r10, qword ptr [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword ptr [rsi+24]         ; r11 = a3
    adc     r11, qword ptr [rdx+24]         ; r11 = a3+b3 = s3
    mov     rcx, qword ptr [rsi+32]         ; rcx = a4
    adc     rcx, qword ptr [rdx+32]         ; rcx = a4+b4 = s4
    mov     qword ptr [rdi], r8             ; save s0
    mov     r8, qword ptr [rsi+40]          ; r8  = a5
    adc     r8, qword ptr [rdx+40]          ; r8  = a5+b5 = s5
    mov     qword ptr [rdi+8], r9           ; save s1
    mov     r9, qword ptr [rsi+48]          ; r9  = a7
    adc     r9, qword ptr [rdx+48]          ; r9  = a7+b7 = s7
    mov     rsi, qword ptr [rsi+56]         ; rsi = a6
    adc     rsi, qword ptr [rdx+56]         ; rsi = a6+b6 = s6
    mov     qword ptr [rdi+16], r10         ; save s2
    mov     qword ptr [rdi+24], r11         ; save s3
    mov     qword ptr [rdi+32], rcx         ; save s4
    mov     qword ptr [rdi+40], r8          ; save s5
    mov     qword ptr [rdi+48], r9          ; save s6
    mov     qword ptr [rdi+56], rsi         ; save s7
    sbb     rax, rax                        ; rax = carry
    jmp     FINAL

;********** lenSrcA == 8 END *********************************


;********** lenSrcA > 8  *************************************

ADD_GT8:
    mov     r8, rax
    mov     rax, rcx                        ; rax = len
    and     rcx, 3                          ;
    xor     rcx, rax                        ;
    lea     rsi, [rsi+8*rcx]                ;
    lea     rdx, [rdx+8*rcx]                ;
    lea     rdi, [rdi+8*rcx]                ;
    neg     rcx
    add     r8, r8
    jmp     ADD_GLOOP

   ALIGN IPP_ALIGN_FACTOR
ADD_GLOOP:
    mov     r8, qword ptr [rsi+8*rcx]       ; r8  = a0
    mov     r9, qword ptr [rsi+8*rcx+8]     ; r9  = a1
    mov     r10, qword ptr [rsi+8*rcx+16]   ; r10 = a2
    mov     r11, qword ptr [rsi+8*rcx+24]   ; r11 = a3
    adc     r8, qword ptr [rdx+8*rcx]       ; r8  = a0+b0 = r0
    adc     r9, qword ptr [rdx+8*rcx+8]     ; r9  = a1+b1 = r1
    adc     r10, qword ptr [rdx+8*rcx+16]   ; r10 = a2+b2 = r2
    adc     r11, qword ptr [rdx+8*rcx+24]   ; r11 = a3+b3 = r3
    mov     qword ptr [rdi+8*rcx], r8       ;
    mov     qword ptr [rdi+8*rcx+8], r9     ;
    mov     qword ptr [rdi+8*rcx+16], r10   ;
    mov     qword ptr [rdi+8*rcx+24], r11   ;
    lea     rcx, [rcx+4]
    jrcxz   ADD_LLAST0
    jmp     ADD_GLOOP

ADD_LLAST0:
    sbb     rcx, rcx
    and     rax, 3
    jz      FIN0

ADD_LLOOP:
    test    rax, 2
    jz      ADD_LLAST1

    add     rcx, rcx
    mov     r8, qword ptr [rsi]             ; r8  = a0
    mov     r9, qword ptr [rsi+8]           ; r9  = a1
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = r0
    adc     r9, qword ptr [rdx+8]           ; r9  = a1+b1 = r1
    mov     qword ptr [rdi], r8             ;
    mov     qword ptr [rdi+8], r9           ;
    sbb     rcx, rcx
    test    rax, 1
    jz      FIN0

    add     rsi, 16
    add     rdx, 16
    add     rdi, 16

ADD_LLAST1:
    add     rcx, rcx
    mov     r8, qword ptr [rsi]             ; r8  = a0
    adc     r8, qword ptr [rdx]             ; r8  = a0+b0 = r0
    mov     qword ptr [rdi], r8             ;
    sbb     rcx, rcx

FIN0:
    mov     rax, rcx

;******************* FINAL ***********************************************************

FINAL:
    neg   rax
    REST_XMM
    REST_GPR
    ret
IPPASM cpAdd_BNU ENDP

ENDIF
END
