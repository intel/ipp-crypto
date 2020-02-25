;===============================================================================
; Copyright 2015-2020 Intel Corporation
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;===============================================================================

;
;
;     Purpose:  Cryptography Primitive.
;               Big Number Operations
;
;     Content:
;        cpAddSub_BNU_school()
;
;

%include "asmdefs.inc"
%include "ia_32e.inc"
%include "pcpvariant.inc"

%if (_ENABLE_KARATSUBA_)

%if (_IPP32E >= _IPP32E_M7)

segment .text align=IPP_ALIGN_FACTOR


;*************************************************************
; Ipp64u cpAddSub_BNU(Ipp64u* pDst,
;                const Ipp64u* pSrcA,
;                const Ipp64u* pSrcB,
;                const Ipp64u* pSrcC,
;                      int len );
; returns positive borrow
;*************************************************************
align IPP_ALIGN_FACTOR
IPPASM cpAddSub_BNU,PUBLIC
%assign LOCAL_FRAME 0
        USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14
        USES_XMM
        COMP_ABI 5

; rdi = pDst
; rsi = pSrcA
; rdx = pSrcB
; rcx = pSrcC
; r8  = len

    movsxd  r8,  r8d    ; length
    xor     rax, rax
    xor     rbx, rbx

    cmp     r8, 2
    jge     .ADD_GE2

;********** lenSrcA == 1 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; rsi = a
    adc     r8, qword [rdx]             ; r8  = a+b
    sbb     rax, rax                        ;
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a+b-c = s
    mov     qword [rdi], r8             ;
    sbb     rbx, rbx                        ;
    jmp     .FINAL

;********** lenSrcA == 1  END ********************************

.ADD_GE2:
    jg      .ADD_GT2

;********** lenSrcA == 2 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     rbx, rbx                        ;
    jmp     .FINAL

;********** lenSrcA == 2 END *********************************

.ADD_GT2:
    cmp     r8, 4
    jge     .ADD_GE4

;********** lenSrcA == 3 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     rbx, rbx                        ;
    jmp     .FINAL

;********** lenSrcA == 3 END *********************************

.ADD_GE4:
    jg      .ADD_GT4

;********** lenSrcA == 4 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2
    mov     r11, qword [rsi+24]         ; r11 = a3
    adc     r11, qword [rdx+24]         ; r11 = a3+b3
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     r11, qword [rcx+24]         ; r11 = a3+b3-c3 = s3
    mov     qword [rdi+24], r11         ; save s2
    sbb     rbx, rbx                        ; rax = carry
    jmp     .FINAL

;********** lenSrcA == 4 END *********************************

.ADD_GT4:
    cmp     r8, 6
    jge     .ADD_GE6

;********** lenSrcA == 5 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2
    mov     r11, qword [rsi+24]         ; r11 = a3
    adc     r11, qword [rdx+24]         ; r11 = a3+b3
    mov     rsi, qword [rsi+32]         ; rsi = a4
    adc     rsi, qword [rdx+32]         ; rsi = a4+b4
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     r11, qword [rcx+24]         ; r11 = a3+b3-c3 = s3
    mov     qword [rdi+24], r11         ; save s3
    sbb     rsi, qword [rcx+32]         ; rsi = a4+b4-c4 = s4
    mov     qword [rdi+32], rsi         ; save s4
    sbb     rbx, rbx                        ; rax = carry
    jmp     .FINAL

;********** lenSrcA == 5 END *********************************

.ADD_GE6:
    jg      .ADD_GT6

;********** lenSrcA == 6 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2
    mov     r11, qword [rsi+24]         ; r11 = a3
    adc     r11, qword [rdx+24]         ; r11 = a3+b3
    mov     r12, qword [rsi+32]         ; r12 = a4
    adc     r12, qword [rdx+32]         ; r12 = a4+b4
    mov     rsi, qword [rsi+40]         ; rsi = a5
    adc     rsi, qword [rdx+40]         ; rsi = a5+b5
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     r11, qword [rcx+24]         ; r11 = a3+b3-c3 = s3
    mov     qword [rdi+24], r11         ; save s3
    sbb     r12, qword [rcx+32]         ; r12 = a4+b4-c4 = s4
    mov     qword [rdi+32], r12         ; save s4
    sbb     rsi, qword [rcx+40]         ; rsi = a5+b5-c5 = s5
    mov     qword [rdi+40], rsi         ; save s5
    sbb     rbx, rbx                        ; rax = carry
    jmp     .FINAL

;********** lenSrcA == 6 END *********************************

.ADD_GT6:
    cmp     r8, 8
    jge     .ADD_GE8

.ADD_EQ7:
;********** lenSrcA == 7 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword [rsi+24]         ; r11 = a3
    adc     r11, qword [rdx+24]         ; r11 = a3+b3 = s3
    mov     r12, qword [rsi+32]         ; r12 = a4
    adc     r12, qword [rdx+32]         ; r12 = a4+b4 = s4
    mov     r13, qword [rsi+40]         ; r13 = a5
    adc     r13, qword [rdx+40]         ; r13 = a5+b5 = s5
    mov     rsi, qword [rsi+48]         ; rsi = a6
    adc     rsi, qword [rdx+48]         ; rsi = a6+b6 = s6
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     r11, qword [rcx+24]         ; r11 = a3+b3-c3 = s3
    mov     qword [rdi+24], r11         ; save s3
    sbb     r12, qword [rcx+32]         ; r12 = a4+b4-c4 = s4
    mov     qword [rdi+32], r12         ; save s4
    sbb     r13, qword [rcx+40]         ; r13 = a5+b5-c5 = s5
    mov     qword [rdi+40], r13         ; save s5
    sbb     rsi, qword [rcx+48]         ; rsi = a6+b6-c6 = s6
    mov     qword [rdi+48], rsi         ; save s6
    sbb     rbx, rbx                        ; rax = carry
    jmp     .FINAL

;********** lenSrcA == 7 END *********************************


.ADD_GE8:
    jg       .ADD_GT8

;********** lenSrcA == 8 *************************************
    add     rax, rax
    mov     r8, qword [rsi]             ; r8  = a0
    adc     r8, qword [rdx]             ; r8  = a0+b0 = s0
    mov     r9, qword [rsi+8]           ; r9  = a1
    adc     r9, qword [rdx+8]           ; r9  = a1+b1 = s1
    mov     r10, qword [rsi+16]         ; r10 = a2
    adc     r10, qword [rdx+16]         ; r10 = a2+b2 = s2
    mov     r11, qword [rsi+24]         ; r11 = a3
    adc     r11, qword [rdx+24]         ; r11 = a3+b3 = s3
    mov     r12, qword [rsi+32]         ; r12 = a4
    adc     r12, qword [rdx+32]         ; r12 = a4+b4 = s4
    mov     r13, qword [rsi+40]         ; r13 = a5
    adc     r13, qword [rdx+40]         ; r13 = a5+b5 = s5
    mov     r14, qword [rsi+48]         ; r14 = a6
    adc     r14, qword [rdx+48]         ; r14 = a6+b6 = s6
    mov     rsi, qword [rsi+56]         ; rsi = a7
    adc     rsi, qword [rdx+56]         ; rsi = a7+b7 = s7
    sbb     rax, rax                        ; rax = carry
    add     rbx, rbx
    sbb     r8, qword [rcx]             ; r8  = a0+b0-c0 = s0
    mov     qword [rdi], r8             ; save s0
    sbb     r9, qword [rcx+8]           ; r9  = a1+b1-c1 = s1
    mov     qword [rdi+8], r9           ; save s1
    sbb     r10, qword [rcx+16]         ; r10 = a2+b2-c2 = s2
    mov     qword [rdi+16], r10         ; save s2
    sbb     r11, qword [rcx+24]         ; r11 = a3+b3-c3 = s3
    mov     qword [rdi+24], r11         ; save s3
    sbb     r12, qword [rcx+32]         ; r12 = a4+b4-c4 = s4
    mov     qword [rdi+32], r12         ; save s4
    sbb     r13, qword [rcx+40]         ; r13 = a5+b5-c5 = s5
    mov     qword [rdi+40], r13         ; save s5
    sbb     r14, qword [rcx+48]         ; r14 = a6+b6-c6 = s6
    mov     qword [rdi+48], r14         ; save s6
    sbb     rsi, qword [rcx+56]         ; rsi = a7+b7-c7 = s7
    mov     qword [rdi+56], rsi         ; save s7
    sbb     rbx, rbx                        ; rax = carry
    jmp     .FINAL

;********** lenSrcA == 8 END *********************************


;********** lenSrcA > 8  *************************************

.ADD_GT8:
    mov     rbp, rcx    ; pC
    mov     rcx, r8     ; length
    and     r8, 3       ; length%4
    xor     rcx, r8     ; length/4
    lea     rsi, [rsi+rcx*sizeof(qword)]
    lea     rdx, [rdx+rcx*sizeof(qword)]
    lea     rbp, [rbp+rcx*sizeof(qword)]
    lea     rdi, [rdi+rcx*sizeof(qword)]
    neg     rcx
    jmp     .SUB_GLOOP

align IPP_ALIGN_FACTOR
.SUB_GLOOP:
    add     rax, rax
    mov     r9,  qword [rsi+sizeof(qword)*rcx]                   ; r8  = a0
    mov     r10, qword [rsi+sizeof(qword)*rcx+sizeof(qword)]     ; r9  = a1
    mov     r11, qword [rsi+sizeof(qword)*rcx+sizeof(qword)*2]   ; r10 = a2
    mov     r12, qword [rsi+sizeof(qword)*rcx+sizeof(qword)*3]   ; r11 = a3
    adc     r9,  qword [rdx+sizeof(qword)*rcx]                   ; r8  = a0+b0
    adc     r10, qword [rdx+sizeof(qword)*rcx+sizeof(qword)]     ; r9  = a1+b1
    adc     r11, qword [rdx+sizeof(qword)*rcx+sizeof(qword)*2]   ; r10 = a2+b2
    adc     r12, qword [rdx+sizeof(qword)*rcx+sizeof(qword)*3]   ; r11 = a3+b3
    sbb     rax, rax
    add     rbx, rbx
    sbb     r9,  qword [rbp+sizeof(qword)*rcx]                   ; r8  = a0+b0+c0
    mov     qword [rdi+sizeof(qword)*rcx], r9
    sbb     r10, qword [rbp+sizeof(qword)*rcx+sizeof(qword)]     ; r9  = a1+b1+c1
    mov     qword [rdi+sizeof(qword)*rcx+sizeof(qword)], r10
    sbb     r11, qword [rbp+sizeof(qword)*rcx+sizeof(qword)*2]   ; r10 = a2+b2+c2
    mov     qword [rdi+sizeof(qword)*rcx+sizeof(qword)*2], r11
    sbb     r12, qword [rbp+sizeof(qword)*rcx+sizeof(qword)*3]   ; r11 = a3+b3+c3
    mov     qword [rdi+sizeof(qword)*rcx+sizeof(qword)*3], r12
    sbb     rbx, rbx
    lea     rcx, [rcx+4]
    jrcxz   .EXIT_LOOP
    jmp     .SUB_GLOOP

.EXIT_LOOP:
    test    r8, r8
    jz      .FINAL

.SUB_LAST2:
    test    r8, 2
    jz      .SUB_LAST1

    add     rax, rax
    mov     r9,  qword [rsi]                ; r8  = a0
    mov     r10, qword [rsi+sizeof(qword)]  ; r9  = a1
    lea     rsi, [rsi+sizeof(qword)*2]
    adc     r9,  qword [rdx]                ; r8  = a0+b0
    adc     r10, qword [rdx+sizeof(qword)]  ; r9  = a1+b1
    lea     rdx, [rdx+sizeof(qword)*2]
    sbb     rax, rax
    add     rbx, rbx
    sbb     r9,  qword [rbp]       ; r8  = a0+b0+c0
    mov     qword [rdi], r9
    sbb     r10, qword [rbp+sizeof(qword)]    ; r9  = a1+b1+c1
    mov     qword [rdi+sizeof(qword)], r10
    lea     rbp, [rbp+sizeof(qword)*2]
    lea     rdi, [rdi+sizeof(qword)*2]
    sbb     rbx, rbx
    test    r8, 1
    jz      .FINAL

.SUB_LAST1:
    add     rax, rax
    mov     r9, qword [rsi]       ; r8  = a0
    adc     r9, qword [rdx]       ; r8  = a0+b0
    sbb     rax, rax
    add     rbx, rbx
    sbb     r9, qword [rbp]       ; r8  = a0+b0+c0 = s0
    mov     qword [rdi], r9
    sbb     rbx, rbx

;******************* .FINAL ***********************************************************

.FINAL:
    sub     rax, rbx
    neg     rax
    REST_XMM
    REST_GPR
    ret
ENDFUNC cpAddSub_BNU


%endif    ;; _IPP32E_M7
%endif    ;; _ENABLE_KARATSUBA_

