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
;        cpDiv_BNU32()
; 
;

include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc

IF _IPP32E GE _IPP32E_M7

;;
;; FIX_BNU     returns actual length of BNU
;;
;; input
;;    rSrc     points BNU
;;    rLen     initial BNU size
;;
;; output
;;    rSrc     points BNU
;;    rLen     actual BNU size
;;
FIX_BNU MACRO rSrc,rLen, tmp
LOCAL fix_bnu_loop,fix_bnu_quit
fix_bnu_loop:
   mov      tmp&d,[rSrc+rLen*4-4]   ;; value
   test     tmp&d,tmp&d             ;; test BNU component
   jnz      fix_bnu_quit
   sub      rLen,1
   jg       fix_bnu_loop
   add      rLen,1
fix_bnu_quit:
ENDM

;;
;; Number of Leaging Zeros in32-bit value
;;
NLZ32u MACRO rNlz:REQ,rVal:REQ
LOCAL nlz16,nlz8,nlz4,nlz2,nlz1,nlz_quit
   mov      rNlz,32
   test     rVal,rVal
   jz       nlz_quit

   xor      rNlz,rNlz
nlz16:
   test     rVal,0FFFF0000h
   jnz      nlz8
   shl      rVal,16
   add      rNlz,16
nlz8:
   test     rVal,0FF000000h
   jnz      nlz4
   shl      rVal,8
   add      rNlz,8
nlz4:
   test     rVal,0F0000000h
   jnz      nlz2
   shl      rVal,4
   add      rNlz,4
nlz2:
   test     rVal,0C0000000h
   jnz      nlz1
   shl      rVal,2
   add      rNlz,2
nlz1:
   test     rVal,080000000h
   jnz      nlz_quit
   add      rNlz,1
nlz_quit:
ENDM

;;
;; (Logical) Shift BNU Left and Right
;;
;;    Input:
;;       rDst  source/destination address
;;       rLen  length (dwords) of BNU
;;       CL    left shift
;;       rTmpH scratch
;;       rTmpL scratch
;;    Note
;;       rDst don't changes
;;       rLen changes
;;
SHL_BNU_I MACRO rDst:REQ,rLen:REQ, rTmpH:REQ,rTmpL:REQ
LOCAL shl_bnu_loop,shl_bnu_quit
   mov      rTmpH&d,[rDst+rLen*4-4]
   sub      rLen,1
   jz       shl_bnu_quit
shl_bnu_loop:
   mov      rTmpL&d,[rDst+rLen*4-4]
   shld     rTmpH&d,rTmpL&d, CL
   mov      [rDst+rLen*4],rTmpH&d
   mov      rTmpH&d,rTmpL&d
   sub      rLen,1
   jg       shl_bnu_loop
shl_bnu_quit:
   shl      rTmpH&d,CL
   mov      [rDst],rTmpH&d
ENDM

SHR_BNU_I MACRO rDst:REQ,rLen:REQ, rTmpH:REQ,rTmpL:REQ
LOCAL shr_bnu_loop,shr_bnu_quit
   push     rDst
   mov      rTmpL&d,[rDst]
   sub      rLen,1
   jz       shr_bnu_quit
shr_bnu_loop:
   mov      rTmpH&d,[rDst+4]
   shrd     rTmpL&d,rTmpH&d, CL
   mov      [rDst],rTmpL&d
   add      rDst,4
   mov      rTmpL&d,rTmpH&d
   sub      rLen,1
   jg       shr_bnu_loop
shr_bnu_quit:
   shr      rTmpL&d,CL
   mov      [rDst],rTmpL&d
   pop      rDst
ENDM

;;
;; Multuply BNU by 32-bit digit and Subtract
;;
;; input
;;    rSrc     points source BNU
;;    rDgt     32-bit digit value
;;    rDst     points accumulator (resultant) BNU
;;    rLen     BNU size
;;    rIdx     (scratch) source/target index
;;    rExp     (scratch) expansion
;;
;; output
;;    rDgt     32-bit expansion
;;
;; Note
;;    rdx and rax used in mul instruction,
;;    this mean any macro argument may be neither rax nor rdx
;;
xMDC_BNU_D32 MACRO rSrc:REQ, rDgt:REQ, rDst:REQ, rLen:REQ, rIdx:REQ,rExp:REQ
LOCAL mdc_loop, mdc_short, mdc_quit
   xor      rIdx,rIdx            ;; index = 0
   xor      rExp,rExp            ;; carry = 0

   sub      rLen,2               ;; test length
   jl       mdc_short

mdc_loop:
   mov      rax, [rSrc+rIdx]     ;; a = src[i]
   mul      rDgt                 ;; x = a*w

   add      rax, rExp            ;; x += borrow
   adc      rdx,0

   xor      rExp,rExp            ;; zero extension of r
   sub      [rDst+rIdx],rax      ;; dst[] -= x
   sbb      rExp,rdx

   neg      rExp                 ;; update borrow

   add      rIdx,2*4             ;; advance index
   sub      rLen,2               ;; decrease counter
   jge      mdc_loop             ;; continue

   add      rLen,2
   jz       mdc_quit

mdc_short:
   mov      eax, [rSrc+rIdx]     ;; a = src[i]
   mul      rDgt&d               ;; x = a*w

   add      eax, rExp&d          ;; x += borrow
   adc      edx,0

   xor      rExp&d, rExp&d       ;; zero extension of r
   sub      [rDst+rIdx],eax      ;; dst[] -= x
   sbb      rExp&d,edx

   neg      rExp&d               ;; update borrow

mdc_quit:
   mov      rDgt,rExp            ;; return borrow
ENDM

;;
;; xADD_BNU     add BNUs
;;
;; input
;;    rDst     points resultant BNU
;;    rSrc1    points source BNU
;;    rSrc2    points source BNU
;;    rLen     BNU size
;;    rIdx     source, resultant index
;;
;; output
;;    rCarry   carry value (byte)
;;
xADD_BNU MACRO rDst,rCarry, rSrc1,rSrc2,rLen, rIdx,tmp1,tmp2
LOCAL add_bnu_loop,short_bnu,add_bnu_exit
   xor      rCarry,rCarry           ;; carry=0
   xor      rIdx,rIdx               ;; index=0

   sub      rLen,2                  ;; test BNU size
   jl       short_bnu

   clc                              ;; CF=0
add_bnu_loop:
   mov      tmp1,[rSrc1+rIdx*8]     ;; src1[]
   mov      tmp2,[rSrc2+rIdx*8]     ;; src2[]
   adc      tmp1,tmp2               ;; x = src1[]+src[2]+CF
   mov      [rDst+rIdx*8],tmp1      ;; dst[] = x

   inc      rIdx                    ;; advance index
   dec      rLen                    ;; decrease length
   dec      rLen
   jge      add_bnu_loop            ;; continue
   setc     rCarry&b                ;; save CF

   add      rIdx,rIdx               ;; restore ordinal index
   add      rLen,2                  ;; restore length
   jz       add_bnu_exit

short_bnu:
   shr      rCarry&d,1              ;; restore CF
   mov      tmp1&d,[rSrc1+rIdx*4]   ;; src1[]
   mov      tmp2&d,[rSrc2+rIdx*4]   ;; src2[]
   adc      tmp1&d,tmp2&d           ;; x = src1[]-src[2]-CF
   mov      [rDst+rIdx*4],tmp1&d    ;; dst[] = x
   setc     rCarry&b                ;; save CF
   add      rIdx,1                  ;; advance index
add_bnu_exit:
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;*************************************************************
;* Ipp32u cpDiv_BNU32(Ipp32u* pQ, int* sizeQ,
;*                    Ipp32u* pX, int  sizeX,
;*                    Ipp32u* pY, int  sizeY)
;*
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpDiv_BNU32 PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14,r15
      LOCAL_FRAME = 4*8
      USES_XMM
      COMP_ABI 6

; rdi = pQ     ; address of quotient
; rsi = sizeQ  ; address of quotient length
; rdx = pX     ; address of denominator (remaider)
; rcx = sizeX  ; length (dwords) of denominator
; r8  = pY     ; address of divired
; r9  = sizeY  ; length (dwords) of length

   movsxd rcx, ecx    ; length
   movsxd r9,  r9d

; make sure denominator and divider are fixed
   FIX_BNU  rdx,rcx, rax
   FIX_BNU  r8, r9,  rax

   mov   r10, rdx    ; save pX
   mov   r11, rcx    ; save sizeX

;
; special case: sizeX < sizeY
;
spec_case1:
   cmp      rcx, r9
   jae      spec_case2

   test     rdi, rdi             ; if quotient was requested
   jz       spec_case1_quit
   mov      DWORD PTR[rdi], 0    ; pQ[0] = 0
   mov      DWORD PTR[rsi], 1    ; sizeQ = 1
spec_case1_quit:
   mov      rax, rcx             ; remainder length address
   REST_XMM
   REST_GPR
   ret

;
; special case: 1 == sizeY
;
spec_case2:
   cmp      r9, 1
   jnz      common_case

   mov      ebx, [r8]            ; divider = pY[0]
   xor      edx,edx              ; init remaider

spec_case2_loop:
   mov      eax,[r10+r11*4-4]
   div      ebx                  ; (edx,eax)/pY[0]

   test     rdi, rdi             ; store if quotient requested
   je       spec_case2_cont
   mov      [rdi+r11*4-4],eax

spec_case2_cont:
   sub      r11,1
   jg       spec_case2_loop

   test     rdi, rdi             ; if quotient was requested
   je       spec_case2_quit
   FIX_BNU  rdi,rcx, rax          ; fix quotient
   mov      DWORD PTR[rsi], ecx   ; store quotient length
spec_case2_quit:
   mov      DWORD PTR[r10],edx   ; pX[0] = remainder value
   mov      rax, 1
   REST_XMM
   REST_GPR
   ret

;
; common case
;
common_case:
   xor         eax,eax              ; expand denominator
   mov         [r10+r11*4], eax     ; by zero

   mov         eax,[r8+r9*4-4]      ; get divider's
   NLZ32u      ecx,eax              ; factor

   test        ecx,ecx              ; test normalization factor
   jz          division             ; and
   mov         r15,r9               ; normalize
   SHL_BNU_I   r8,r15, r12,r13      ; divider
   lea         r15,[r11+1]          ; and
   SHL_BNU_I   r10,r15, r12,r13     ; denominator

; compute quotation digit-by-digit
division:
   mov         ebx,[r8+r9*4-4]      ; yHi - the most significant divider digit pY[ySize-1]

   mov         [rsp], r10           ; save pX
   mov         [rsp+8], r11         ; save sizeX

   sub         r11, r9              ; estimate length of quotient = (sizeX-sizeY+1)
   mov         [rsp+16], r11        ; (will use for loop counter)

   lea         r10, [r10+r11*4]     ; points current denominator position

division_loop:
   mov         rax,[r10+r9*4-4]     ; tmp = (pX[xSize],pX[xSize-1])
   xor         rdx,rdx              ; estimate quotation digit:
   div         rbx                  ; (rax) q = tmp/yHi
                                    ; (rdx) r = tmp%yHi
   mov         r12,rax
   mov         r13,rdx

   mov         ebp,[r8+r9*4-8]      ; next significant divider digit pY[ySize-2]
tune_loop:
   mov         r15,0FFFFFFFF00000000h
   and         r15,rax              ; if q >= base tune q value
   jne         tune
   mul         rbp                  ; (rax) A = q*pY[ySize-2]
   mov         r14,r13
   shl         r14,32               ; (rdx) B = QWORD(r,pX[xSize-2])
   mov         edx,[r10+r9*4-8]
   or          rdx,r14
   cmp         rax,rdx              ; if A>B tune q value
   jbe         mul_and_sub
tune:
   sub         r12,1                ; q -= 1
   add         r13d,ebx             ; r += yHi
   mov         rax,r12
   jnc         tune_loop

mul_and_sub:
   mov         r15,r9               ; multiplay and subtract
   mov         ebp,r12d
   xMDC_BNU_D32 r8, rbp, r10,r15, r13,r14
   sub         [r10+r9*4],ebp      ; extend = (pX[i+sizeY] -= extend);

   jnc         store_duotation
   sub         r12d,1
   mov         r15,r9
   xADD_BNU    r10,rax, r10,r8,r15, r13,r14,rdx
   add         [r10+r9*4],eax      ; pX[i+sizeY] += extend;

store_duotation:
   test        rdi, rdi
   jz          cont_division_loop
   mov         DWORD PTR[rdi+r11*4],r12d

cont_division_loop:
   sub         r10,4
   sub         r11,1
   jge         division_loop

   mov         r10,[rsp]            ; restore pX
   mov         r11,[rsp+8]          ; restore sizeX

   test        ecx,ecx              ; test normalization factor
   jz          store_results        ; and
   mov         r15,r9               ; de-normalize
   SHR_BNU_I   r8,r15, r12,r13      ; divider
   mov         r15,r11              ; and
   SHR_BNU_I   r10,r15, r12,r13     ; remainder

store_results:
   test        rdi, rdi
   jz          quit
   mov         rcx,[rsp+16]         ; restore quotient length
   add         rcx,1
   FIX_BNU     rdi, rcx, rax        ; fix quotient
   mov         DWORD PTR[rsi], ecx

quit:
   FIX_BNU     r10,r11, rax         ; fix remainder
   mov         rax, r11
   REST_XMM
   REST_GPR
   ret
IPPASM cpDiv_BNU32 ENDP

ENDIF
END
