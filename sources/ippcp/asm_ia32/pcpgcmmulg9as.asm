;===============================================================================
; Copyright 2014-2020 Intel Corporation
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
;               Reduction over AES-GCM polynomial (x^128 + x^7 + x^2 + x + 1)
;
;     Content:
;        GCMreduce()
;






%include "asmdefs.inc"
%include "ia_emm.inc"

%if (_IPP >= _IPP_P8)

%assign my_emulator  0; set 1 for emulation
%include "emulator.inc"

segment .text align=IPP_ALIGN_FACTOR


align IPP_ALIGN_FACTOR
CONST_TABLE:
_u128_str DB 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0

%xdefine u128_str  [eax+(_u128_str - CONST_TABLE)]



;*************************************************************
;* void GCMmul_avx(const Ipp8u* pA, Ipp8u* pB)
;*************************************************************
;;
;; Lib = G9
;;
;; Caller = ippsRijndael128GCMProcessIV
;; Caller = ippsRijndael128GCMProcessAAD
;; Caller = ippsRijndael128GCMEncrypt
;; Caller = ippsRijndael128GCMDecrypt
;; Caller = ippsRijndael128GCMGetTag
;;
align IPP_ALIGN_FACTOR
IPPASM GCMmul_avx,PUBLIC
  USES_GPR esi,edi

%xdefine pSrc [esp + ARG_1 + 0*sizeof(dword)] ; const multiplier
%xdefine pDst [esp + ARG_1 + 1*sizeof(dword)] ; multiplier/result

   mov      edi, pDst
   mov      esi, pSrc
   LD_ADDR  eax, CONST_TABLE

   movdqu   xmm1, oword [edi]    ; multiplicand and reduced result
   movdqu   xmm0, oword [esi]    ; const multiplicand
  ;pshufb   xmm1, oword u128_str; convert 2-nd multiplier
my_pshufbM  xmm1, u128_str; convert 2-nd multiplier

   ;
   ; carry-less multiplication (caratsuba)
   ;
   pshufd       xmm4, xmm0, 01001110b  ; xmm4 = {a[1]:a[0]}
   pshufd       xmm5, xmm1, 01001110b  ; xmm5 = {b[1]:b[0]}
   pxor         xmm4, xmm0
   pxor         xmm5, xmm1
  ;pclmulqdq    xmm4, xmm5, 00h        ; xmm4={xx:a[1]+a[0]}{yy:b[1]+b[0]}
my_pclmulqdq    xmm4, xmm5, 00h        ; xmm4={xx:a[1]+a[0]}{yy:b[1]+b[0]}
   movdqu       xmm3, xmm0
  ;pclmulqdq    xmm3, xmm1, 00h        ; xmm3=a0*b0
my_pclmulqdq    xmm3, xmm1, 00h        ; xmm3=a0*b0
   movdqu       xmm6, xmm0
  ;pclmulqdq    xmm6, xmm1, 11h        ; xmm6=a1*b1
my_pclmulqdq    xmm6, xmm1, 11h        ; xmm6=a1*b1

   pxor         xmm5, xmm5
   pxor         xmm4, xmm3             ; xmm4= a1*b0+a0*b1
   pxor         xmm4, xmm6

  ;palignr      xmm5, xmm4, 8
my_palignr      xmm5, xmm4, 8
   pslldq       xmm4, 8

   pxor         xmm3, xmm4
   pxor         xmm6, xmm5         ; register pair <xmm6:xmm3> holds the result of
                                   ; the carry-less multiplication of xmm0 by xmm1

   ; we shift the result of the multiplication by one bit position to the left
   ; cope for the fact that bits are reversed
   movdqu   xmm4, xmm3
   movdqu   xmm5, xmm6
   pslld    xmm3, 1
   pslld    xmm6, 1
   psrld    xmm4, 31
   psrld    xmm5, 31
  ;palignr  xmm5,xmm4, 12
my_palignr  xmm5,xmm4, 12
   pslldq   xmm4, 4
   por      xmm3, xmm4
   por      xmm6, xmm5

   ;first phase of the reduction
   movdqu   xmm0, xmm3
   movdqu   xmm1, xmm3
   movdqu   xmm2, xmm3     ;move xmm3 into xmm7, xmm8, xmm9 in order to perform the three shifts independently
   pslld    xmm0, 31       ; packed right shifting << 31
   pslld    xmm1, 30       ; packed right shifting shift << 30
   pslld    xmm2, 25       ; packed right shifting shift << 25
   pxor     xmm0, xmm1     ;xor the shifted versions
   pxor     xmm0, xmm2
   movdqu   xmm1, xmm0    ; xmm1 uses on the reduction second phase
   pslldq   xmm0, 12
   pxor     xmm3, xmm0     ;first phase of the reduction complete

   ;second phase of the reduction
   movdqu   xmm2,xmm3    ; make 3 copies of xmm3 (in in xmm2, xmm4, xmm5) for doing three shift operations
   movdqu   xmm4,xmm3
   movdqu   xmm5,xmm3
   psrldq   xmm1, 4
   psrld    xmm2,1       ; packed left shifting >> 1
   psrld    xmm4,2       ; packed left shifting >> 2
   psrld    xmm5,7       ; packed left shifting >> 7
   pxor     xmm2,xmm4    ; xor the shifted versions
   pxor     xmm2,xmm5
   pxor     xmm2,xmm1
   pxor     xmm3, xmm2
   pxor     xmm6, xmm3    ;the result is in xmm6

  ;pshufb   xmm6, oword u128_str   ; convert result back
my_pshufbM  xmm6, u128_str   ; convert result back
   movdqu   oword [edi], xmm6

   REST_GPR
   ret
ENDFUNC GCMmul_avx

%endif

