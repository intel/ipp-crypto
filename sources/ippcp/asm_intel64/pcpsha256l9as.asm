;===============================================================================
; Copyright 2017-2018 Intel Corporation
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
;               Message block processing according to SHA256
; 
;     Content:
;        UpdateSHA256
;
include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc
include pcpvariant.inc

IF (_ENABLE_ALG_SHA256_)
IF (_SHA_NI_ENABLING_ EQ _FEATURE_OFF_) OR (_SHA_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_L9 )

;;
;; assignments
;;
hA textequ <eax>     ;; hash values into GPU registers
hB textequ <ebx>
hC textequ <ecx>
hD textequ <edx>
hE textequ <r8d>
hF textequ <r9d>
hG textequ <r10d>
hH textequ <r11d>

T1 textequ <r12d>    ;; scratch
T2 textequ <r13d>
T3 textequ <r14d>
T4 textequ <r15d>
T5 textequ <edi>

W0 textequ <ymm0>   ;; W values into YMM registers
W1 textequ <ymm1>
W2 textequ <ymm2>
W3 textequ <ymm3>

yT1 textequ <ymm4>   ;; scratch
yT2 textequ <ymm5>
yT3 textequ <ymm6>
yT4 textequ <ymm7>

W0L textequ <xmm0>
W1L textequ <xmm1>
W2L textequ <xmm2>
W3L textequ <xmm3>

YMM_zzBA        textequ <ymm8>   ;; byte swap constant
YMM_DCzz        textequ <ymm9>   ;; byte swap constant
YMM_SHUFB_BSWAP textequ <ymm10>  ;; byte swap constant

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; textual rotation of W args
;;
ROTATE_W MACRO
   _X textequ  W0
   W0 textequ  W1
   W1 textequ  W2
   W2 textequ  W3
   W3 textequ  _X
ENDM

;;
;; textual rotation of HASH arguments
;;
ROTATE_H MACRO
   _X textequ  hH
   hH textequ  hG
   hG textequ  hF
   hF textequ  hE
   hE textequ  hD
   hD textequ  hC
   hC textequ  hB
   hB textequ  hA
   hA textequ  _X
ENDM

ROTATE_2 MACRO nm1, nm2
   _X   textequ  nm2
    nm2 textequ  nm1
    nm1 textequ _X
ENDM

;;
;; compute next 4 W[t], W[t+1], W[t+2] and W[t+3], t=16,...63
;; (see pcpsha256e9as.asm for details)
UPDATE_W MACRO  nr, W0, W1, W2, W3
  W_AHEAD = 16

   vpalignr yT3,W1,W0,4
   vpalignr yT2,W3,W2,4
   vpsrld   yT1,yT3,7
   vpaddd   W0,W0,yT2
   vpsrld   yT2,yT3,3
   vpslld   yT4,yT3,14
   vpxor    yT3,yT2,yT1
   vpshufd  yT2,W3,250
   vpsrld   yT1,yT1,11
   vpxor    yT3,yT3,yT4
   vpslld   yT4,yT4,11
   vpxor    yT3,yT3,yT1
   vpsrld   yT1,yT2,10
   vpxor    yT3,yT3,yT4
   vpsrlq   yT2,yT2,17
   vpaddd   W0,W0,yT3
   vpxor    yT1,yT1,yT2
   vpsrlq   yT2,yT2,2
   vpxor    yT1,yT1,yT2
   vpshufb  yT1,yT1,YMM_zzBA
   vpaddd   W0,W0,yT1
   vpshufd  yT2,W0,80
   vpsrld   yT1,yT2,10
   vpsrlq   yT2,yT2,17
   vpxor    yT1,yT1,yT2
   vpsrlq   yT2,yT2,2
   vpxor    yT1,yT1,yT2
   vpshufb  yT1,yT1,YMM_DCzz
   vpaddd   W0,W0,yT1
   vpaddd   yT1,W0,YMMWORD PTR[rbp+(nr/4)*sizeof(ymmword)]
   vmovdqa  YMMWORD PTR[rsp+(W_AHEAD/4)*sizeof(ymmword)+(nr/4)*sizeof(ymmword)],yT1
ENDM

;;
;; regular round (i):
;;
;; T1 = h + Sum1(e) + Ch(e,f,g) + K[i] + W[i]
;; T2 = Sum0(a) + Maj(a,b,c)
;; h = g
;; g = f
;; f = e
;; e = d + T1
;; d = c
;; c = b
;; b = a
;; a = T1+T2
;;
;; sum1(e) = (e>>>25)^(e>>>11)^(e>>>6)
;; sum0(a) = (a>>>13)^(a>>>22)^(a>>>2)
;; ch(e,f,g) = (e&f)^(~e^g)
;; maj(a,b,m)= (a&b)^(a&c)^(b&c)
;;
;; note:
;; 1) U + ch(e,f,g) = U + (e&f) & (~e&g)
;; 2) maj(a,b,c)= (a&b)^(a&c)^(b&c) = (a^b)&(b^c) ^b
;; to make sure both are correct - use GF(2) arith instead of logic 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;    or
;; X = sum0(a[i-1]) computed on prev round
;; a[i] += X
;; h[i] += (K[i]+W[i]) + sum1(e[i]) + ch(e[i],f[i],g[i]) or
;; h[i] += (K[i]+W[i]) + sum1(e[i]) + (e[i]&f[i]) + (~e[i]&g[i])  -- helps break dependencies
;; d[i] += h[i]
;; h[i] += maj(a[i],b[i],c[i])
;; and following textual shift
;;   {a[i+1],b[i+1],c[i+1],d[i+1],e[i+1],f[i+1],g[i+1],h[i+1]} <= {h[i],a[i],b[i],c[i],d[i],e[i],f[i],g[i]}
;;
;; on entry:
;; - T1 = f
;; - T3 = sum0{a[i-1])
;; - T5 = b&c
SHA256_ROUND MACRO  nr, hA,hB,hC,hD,hE,hF,hG,hH
   add   hH, dword ptr[rsp+(nr/4)*sizeof(ymmword)+(nr AND 3)*sizeof(dword)] ;; h += (k[t]+w[t])
   and   T1, hE       ;; ch(e,f,g): (f&e)
   rorx  T2, hE, 25   ;; sum1(e): e>>>25
   rorx  T4, hE, 11   ;; sum1(e): e>>>11
   add   hA, T3       ;; complete computation a += sum0(a[t-1])
   add   hH, T1       ;; h += (k[t]+w[t]) + (f&e)
   andn  T1, hE, hG   ;; ch(e,f,g): (~e&g)
   xor   T2, T4       ;; sum1(e): (e>>>25)^(e>>>11)
   rorx  T3, hE, 6    ;; sum1(e): e>>>6
   add   hH, T1       ;; h += (k[t]+w[t]) + (f&e) + (~e&g)
   xor   T2, T3       ;; sum1(e) = (e>>>25)^(e>>>11)^(e>>>6)
   mov   T4, hA       ;; maj(a,b,c): a
   rorx  T1, hA, 22   ;; sum0(a): a>>>22
   add   hH, T2       ;; h += (k[t]+w[t]) +(f&e) +(~e&g) +sig1(e)
   xor   T4, hB       ;; maj(a,b,c): (a^b)
   rorx  T3, hA, 13   ;; sum0(a): a>>>13
   rorx  T2, hA, 2    ;; sum0(a): a>>>2
   add   hD, hH       ;; d += h
   and   T5, T4       ;; maj(a,b,c): (b^c)&(a^b)
   xor   T3, T1       ;; sum0(a): (a>>>13)^(a>>>22)
   xor   T5, hB       ;; maj(a,b,c) = (b^c)&(a^b)^b = (a&b)^(a&c)^(b&c)
   xor   T3, T2       ;;  sum0(a): = (a>>>13)^(a>>>22)^(a>>>2)
   add   hH, T5       ;; h += (k[t]+w[t]) +(f&e) +(~e&g) +sig1(e) +maj(a,b,c)
   mov   T1, hE       ;; T1 = f     (next round)
   ROTATE_2 T4,T5     ;; T5 = (b^c) (next round)
ENDM

;;
;; does 4 regular rounds and computes next 4 W values
;; (just 4 instances of SHA256_ROUND merged together woth UPDATE_W)
;;
SHA256_4ROUND_SHED MACRO  round
  W_AHEAD = 16
vpalignr yT3,W1,W0,4
   nr = round
   add   hH, dword ptr[rsp+(nr/4)*sizeof(ymmword)+(nr AND 3)*sizeof(dword)]
   and   T1, hE
   rorx  T2, hE, 25
vpalignr yT2,W3,W2,4
   rorx  T4, hE, 11
   add   hA, T3
   add   hH, T1
vpsrld   yT1,yT3,7
   andn  T1, hE, hG
   xor   T2, T4
   rorx  T3, hE, 6
vpaddd   W0,W0,yT2
   add   hH, T1
   xor   T2, T3
   mov   T4, hA
vpsrld   yT2,yT3,3
   rorx  T1, hA, 22
   add   hH, T2
   xor   T4, hB
vpslld   yT4,yT3,14
   rorx  T3, hA, 13
   rorx  T2, hA, 2
   add   hD, hH
vpxor    yT3,yT2,yT1
   and   T5, T4
   xor   T3, T1
   xor   T5, hB
vpshufd  yT2,W3,250
   xor   T3, T2
   add   hH, T5
   mov   T1, hE
   ROTATE_2 T4,T5
   ROTATE_H

vpsrld   yT1,yT1,11
   nr = nr+1
   add   hH, dword ptr[rsp+(nr/4)*sizeof(ymmword)+(nr AND 3)*sizeof(dword)]
   and   T1, hE
   rorx  T2, hE, 25
vpxor    yT3,yT3,yT4
   rorx  T4, hE, 11
   add   hA, T3
   add   hH, T1
vpslld   yT4,yT4,11
   andn  T1, hE, hG
   xor   T2, T4
   rorx  T3, hE, 6
vpxor    yT3,yT3,yT1
   add   hH, T1
   xor   T2, T3
   mov   T4, hA
vpsrld   yT1,yT2,10
   rorx  T1, hA, 22
   add   hH, T2
   xor   T4, hB
vpxor    yT3,yT3,yT4
   rorx  T3, hA, 13
   rorx  T2, hA, 2
   add   hD, hH
vpsrlq   yT2,yT2,17
   and   T5, T4
   xor   T3, T1
   xor   T5, hB
vpaddd   W0,W0,yT3
   xor   T3, T2
   add   hH, T5
   mov   T1, hE
   ROTATE_2 T4,T5
   ROTATE_H

vpxor    yT1,yT1,yT2
   nr = nr+1
   add   hH, dword ptr[rsp+(nr/4)*sizeof(ymmword)+(nr AND 3)*sizeof(dword)]
   and   T1, hE
   rorx  T2, hE, 25
vpsrlq   yT2,yT2,2
   rorx  T4, hE, 11
   add   hA, T3
   add   hH, T1
vpxor    yT1,yT1,yT2
   andn  T1, hE, hG
   xor   T2, T4
   rorx  T3, hE, 6
vpshufb  yT1,yT1,YMM_zzBA
   add   hH, T1
   xor   T2, T3
   mov   T4, hA
vpaddd   W0,W0,yT1
   rorx  T1, hA, 22
   add   hH, T2
   xor   T4, hB
vpshufd  yT2,W0,80
   rorx  T3, hA, 13
   rorx  T2, hA, 2
   add   hD, hH
vpsrld   yT1,yT2,10
   and   T5, T4
   xor   T3, T1
   xor   T5, hB
vpsrlq   yT2,yT2,17
   xor   T3, T2
   add   hH, T5
   mov   T1, hE
   ROTATE_2 T4,T5
   ROTATE_H

vpxor    yT1,yT1,yT2
   nr = nr+1
   add   hH, dword ptr[rsp+(nr/4)*sizeof(ymmword)+(nr AND 3)*sizeof(dword)]
   and   T1, hE
   rorx  T2, hE, 25
vpsrlq   yT2,yT2,2
   rorx  T4, hE, 11
   add   hA, T3
   add   hH, T1
vpxor    yT1,yT1,yT2
   andn  T1, hE, hG
   xor   T2, T4
   rorx  T3, hE, 6
vpshufb  yT1,yT1,YMM_DCzz
   add   hH, T1
   xor   T2, T3
   mov   T4, hA
vpaddd   W0,W0,yT1
   rorx  T1, hA, 22
   add   hH, T2
   xor   T4, hB
vpaddd   yT1,W0,YMMWORD PTR[rbp+(nr/4)*sizeof(ymmword)]
   rorx  T3, hA, 13
   rorx  T2, hA, 2
   add   hD, hH
   and   T5, T4
   xor   T3, T1
   xor   T5, hB
vmovdqa  YMMWORD PTR[rsp+(W_AHEAD/4)*sizeof(ymmword)+(round/4)*sizeof(ymmword)],yT1
   xor   T3, T2
   add   hH, T5
   mov   T1, hE
   ROTATE_2 T4,T5
   ROTATE_H

   ROTATE_W
ENDM

;;
;; update hash
;;
UPDATE_HASH MACRO hashMem, hash
     add    hash, hashMem
     mov    hashMem, hash
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

SHA256_YMM_K   dd 0428a2f98h, 071374491h, 0b5c0fbcfh, 0e9b5dba5h,  0428a2f98h, 071374491h, 0b5c0fbcfh, 0e9b5dba5h
               dd 03956c25bh, 059f111f1h, 0923f82a4h, 0ab1c5ed5h,  03956c25bh, 059f111f1h, 0923f82a4h, 0ab1c5ed5h
               dd 0d807aa98h, 012835b01h, 0243185beh, 0550c7dc3h,  0d807aa98h, 012835b01h, 0243185beh, 0550c7dc3h
               dd 072be5d74h, 080deb1feh, 09bdc06a7h, 0c19bf174h,  072be5d74h, 080deb1feh, 09bdc06a7h, 0c19bf174h
               dd 0e49b69c1h, 0efbe4786h, 00fc19dc6h, 0240ca1cch,  0e49b69c1h, 0efbe4786h, 00fc19dc6h, 0240ca1cch
               dd 02de92c6fh, 04a7484aah, 05cb0a9dch, 076f988dah,  02de92c6fh, 04a7484aah, 05cb0a9dch, 076f988dah
               dd 0983e5152h, 0a831c66dh, 0b00327c8h, 0bf597fc7h,  0983e5152h, 0a831c66dh, 0b00327c8h, 0bf597fc7h
               dd 0c6e00bf3h, 0d5a79147h, 006ca6351h, 014292967h,  0c6e00bf3h, 0d5a79147h, 006ca6351h, 014292967h
               dd 027b70a85h, 02e1b2138h, 04d2c6dfch, 053380d13h,  027b70a85h, 02e1b2138h, 04d2c6dfch, 053380d13h
               dd 0650a7354h, 0766a0abbh, 081c2c92eh, 092722c85h,  0650a7354h, 0766a0abbh, 081c2c92eh, 092722c85h
               dd 0a2bfe8a1h, 0a81a664bh, 0c24b8b70h, 0c76c51a3h,  0a2bfe8a1h, 0a81a664bh, 0c24b8b70h, 0c76c51a3h
               dd 0d192e819h, 0d6990624h, 0f40e3585h, 0106aa070h,  0d192e819h, 0d6990624h, 0f40e3585h, 0106aa070h
               dd 019a4c116h, 01e376c08h, 02748774ch, 034b0bcb5h,  019a4c116h, 01e376c08h, 02748774ch, 034b0bcb5h
               dd 0391c0cb3h, 04ed8aa4ah, 05b9cca4fh, 0682e6ff3h,  0391c0cb3h, 04ed8aa4ah, 05b9cca4fh, 0682e6ff3h
               dd 0748f82eeh, 078a5636fh, 084c87814h, 08cc70208h,  0748f82eeh, 078a5636fh, 084c87814h, 08cc70208h
               dd 090befffah, 0a4506cebh, 0bef9a3f7h, 0c67178f2h,  090befffah, 0a4506cebh, 0bef9a3f7h, 0c67178f2h

SHA256_YMM_BF  dd 000010203h, 004050607h, 008090a0bh, 00c0d0e0fh,  000010203h, 004050607h, 008090a0bh, 00c0d0e0fh

SHA256_DCzz db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh, 0,1,2,3, 8,9,10,11
            db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh, 0,1,2,3, 8,9,10,11
SHA256_zzBA db 0,1,2,3, 8,9,10,11, 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
            db 0,1,2,3, 8,9,10,11, 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UpdateSHA256(Ipp32u digest[], Ipp8u dataBlock[], int datalen, Ipp32u K_256[])
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSHA256 PROC PUBLIC FRAME
      USES_GPR rbx,rsi,rdi,rbp,rbx,r12,r13,r14,r15
      LOCAL_FRAME = (sizeof(qword)*4 + sizeof(dword)*64*2)
      USES_XMM_AVX xmm6,xmm7,xmm8,xmm9,xmm10
      COMP_ABI 4
;;
;; rdi = pointer to the updated hash
;; rsi = pointer to the data block
;; rdx = data block length
;; rcx = pointer to the SHA_256 constant (ignored)
;;

MBS_SHA256  equ   (64)

;;
;; stack structure:
;;
_reserve  = 0                       ;; reserved
_hash    = _reserve+sizeof(qword)   ;; hash address
_len     = _hash+sizeof(qword)      ;; rest of processed data
_frame   = _len+sizeof(qword)       ;; rsp before alignment
_dataW   = _frame+sizeof(qword)     ;; W[t] values

   mov      r15, rsp                ; store orifinal rsp
   and      rsp, -IPP_ALIGN_FACTOR  ; 32-byte aligned stack

   movsxd   r14, edx                ; input length in bytes

   mov      qword ptr[rsp+_hash], rdi  ; store hash address
   mov      qword ptr[rsp+_len], r14   ; store length
   mov      qword ptr[rsp+_frame], r15 ; store rsp
   lea      rsp, qword ptr[rsp+_dataW] ; set up rsp

   mov      hA, dword ptr[rdi]       ; load initial hash value
   mov      hB, dword ptr[rdi+1*sizeof(dword)]
   mov      hC, dword ptr[rdi+2*sizeof(dword)]
   mov      hD, dword ptr[rdi+3*sizeof(dword)]
   mov      hE, dword ptr[rdi+4*sizeof(dword)]
   mov      hF, dword ptr[rdi+5*sizeof(dword)]
   mov      hG, dword ptr[rdi+6*sizeof(dword)]
   mov      hH, dword ptr[rdi+7*sizeof(dword)]

   vmovdqa  YMM_SHUFB_BSWAP, ymmword ptr SHA256_YMM_BF   ; load byte shuffler

   vmovdqa  YMM_zzBA, ymmword ptr SHA256_zzBA   ; load byte shuffler (zzBA)
   vmovdqa  YMM_DCzz, ymmword ptr SHA256_DCzz   ; load byte shuffler (DCzz)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data 2 block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIGN IPP_ALIGN_FACTOR
sha256_block2_loop:
   lea      r12, [rsi+MBS_SHA256]   ; next block

   cmp      r14, MBS_SHA256         ; if single block processed
   cmovbe   r12, rsi                ; use the same data block address
   lea      rbp, ymmword ptr SHA256_YMM_K ; ptr to SHA256 consts

   vmovdqu  W0L, xmmword ptr [rsi]           ; load data block
   vmovdqu  W1L, xmmword ptr [rsi+1*sizeof(xmmword)]
   vmovdqu  W2L, xmmword ptr [rsi+2*sizeof(xmmword)]
   vmovdqu  W3L, xmmword ptr [rsi+3*sizeof(xmmword)]

   vinserti128 W0, W0, xmmword ptr[r12], 1   ; merge next data block
   vinserti128 W1, W1, xmmword ptr[r12+1*sizeof(xmmword)], 1
   vinserti128 W2, W2, xmmword ptr[r12+2*sizeof(xmmword)], 1
   vinserti128 W3, W3, xmmword ptr[r12+3*sizeof(xmmword)], 1

   vpshufb  W0, W0, YMM_SHUFB_BSWAP
   vpshufb  W1, W1, YMM_SHUFB_BSWAP
   vpshufb  W2, W2, YMM_SHUFB_BSWAP
   vpshufb  W3, W3, YMM_SHUFB_BSWAP
   vpaddd   yT1, W0, ymmword ptr[rbp]
   vpaddd   yT2, W1, ymmword ptr[rbp+1*sizeof(ymmword)]
   vpaddd   yT3, W2, ymmword ptr[rbp+2*sizeof(ymmword)]
   vpaddd   yT4, W3, ymmword ptr[rbp+3*sizeof(ymmword)]
   add      rbp, 4*sizeof(ymmword)
   vmovdqa  ymmword ptr [rsp], yT1
   vmovdqa  ymmword ptr [rsp+1*sizeof(ymmword)], yT2
   vmovdqa  ymmword ptr [rsp+2*sizeof(ymmword)], yT3
   vmovdqa  ymmword ptr [rsp+3*sizeof(ymmword)], yT4

   mov      T5, hB   ; T5 = b^c
   xor      T3, T3   ; T3 = 0
   mov      T1, hF   ; T1 = f
   xor      T5, hC

ALIGN IPP_ALIGN_FACTOR
block1_shed_proc:
   SHA256_4ROUND_SHED 0
   SHA256_4ROUND_SHED 4
   SHA256_4ROUND_SHED 8
   SHA256_4ROUND_SHED 12

   add      rsp, 4*sizeof(ymmword)
   add      rbp, 4*sizeof(ymmword)

   ;; and repeat
   cmp      dword ptr[rbp-sizeof(dword)],0c67178f2h
   jne      block1_shed_proc

   ;; the rest 16 rounds
   SHA256_ROUND  0, hA,hB,hC,hD,hE,hF,hG,hH
   SHA256_ROUND  1, hH,hA,hB,hC,hD,hE,hF,hG
   SHA256_ROUND  2, hG,hH,hA,hB,hC,hD,hE,hF
   SHA256_ROUND  3, hF,hG,hH,hA,hB,hC,hD,hE
   SHA256_ROUND  4, hE,hF,hG,hH,hA,hB,hC,hD
   SHA256_ROUND  5, hD,hE,hF,hG,hH,hA,hB,hC
   SHA256_ROUND  6, hC,hD,hE,hF,hG,hH,hA,hB
   SHA256_ROUND  7, hB,hC,hD,hE,hF,hG,hH,hA
   SHA256_ROUND  8, hA,hB,hC,hD,hE,hF,hG,hH
   SHA256_ROUND  9, hH,hA,hB,hC,hD,hE,hF,hG
   SHA256_ROUND 10, hG,hH,hA,hB,hC,hD,hE,hF
   SHA256_ROUND 11, hF,hG,hH,hA,hB,hC,hD,hE
   SHA256_ROUND 12, hE,hF,hG,hH,hA,hB,hC,hD
   SHA256_ROUND 13, hD,hE,hF,hG,hH,hA,hB,hC
   SHA256_ROUND 14, hC,hD,hE,hF,hG,hH,hA,hB
   SHA256_ROUND 15, hB,hC,hD,hE,hF,hG,hH,hA
   add          hA, T3

   sub      rsp, (16-4)*sizeof(ymmword)   ; restore stack to W

   mov   rdi, qword ptr[rsp+_hash-_dataW] ; restore hash pointer
   mov   r14, qword ptr[rsp+_len-_dataW]  ; restore data length

   ;; update hash values by 1-st data block
   UPDATE_HASH    dword ptr [rdi],   hA
   UPDATE_HASH    dword ptr [rdi+1*sizeof(dword)], hB
   UPDATE_HASH    dword ptr [rdi+2*sizeof(dword)], hC
   UPDATE_HASH    dword ptr [rdi+3*sizeof(dword)], hD
   UPDATE_HASH    dword ptr [rdi+4*sizeof(dword)], hE
   UPDATE_HASH    dword ptr [rdi+5*sizeof(dword)], hF
   UPDATE_HASH    dword ptr [rdi+6*sizeof(dword)], hG
   UPDATE_HASH    dword ptr [rdi+7*sizeof(dword)], hH

   cmp   r14, MBS_SHA256*2
   jl    done

   ;; do 64 rounds for the next block
   add      rsp, 4*sizeof(dword)          ; restore stack to next block W
   lea      rbp, [rsp+16*sizeof(ymmword)] ; use rbp for loop limiter

   mov      T5, hB   ; T5 = b^c
   xor      T3, T3   ; T3 = 0
   mov      T1, hF   ; T1 = f
   xor      T5, hC

ALIGN IPP_ALIGN_FACTOR
block2_proc:
   SHA256_ROUND  0, hA,hB,hC,hD,hE,hF,hG,hH
   SHA256_ROUND  1, hH,hA,hB,hC,hD,hE,hF,hG
   SHA256_ROUND  2, hG,hH,hA,hB,hC,hD,hE,hF
   SHA256_ROUND  3, hF,hG,hH,hA,hB,hC,hD,hE
   SHA256_ROUND  4, hE,hF,hG,hH,hA,hB,hC,hD
   SHA256_ROUND  5, hD,hE,hF,hG,hH,hA,hB,hC
   SHA256_ROUND  6, hC,hD,hE,hF,hG,hH,hA,hB
   SHA256_ROUND  7, hB,hC,hD,hE,hF,hG,hH,hA
   add      rsp, 2*sizeof(ymmword)
   cmp      rsp, rbp
   jb       block2_proc
   add      hA, T3

   sub      rsp, 16*sizeof(ymmword)+4*sizeof(dword)   ; restore stack

   mov   rdi, qword ptr[rsp+_hash-_dataW] ; restore hash pointer
   mov   r14, qword ptr[rsp+_len-_dataW]  ; restore data length

   ;; update hash values by 2-nd data block
   UPDATE_HASH    dword ptr [rdi],   hA
   UPDATE_HASH    dword ptr [rdi+1*sizeof(dword)], hB
   UPDATE_HASH    dword ptr [rdi+2*sizeof(dword)], hC
   UPDATE_HASH    dword ptr [rdi+3*sizeof(dword)], hD
   UPDATE_HASH    dword ptr [rdi+4*sizeof(dword)], hE
   UPDATE_HASH    dword ptr [rdi+5*sizeof(dword)], hF
   UPDATE_HASH    dword ptr [rdi+6*sizeof(dword)], hG
   UPDATE_HASH    dword ptr [rdi+7*sizeof(dword)], hH

   add      rsi, MBS_SHA256*2                ; move data pointer
   sub      r14, MBS_SHA256*2                ; update data length
   mov      qword ptr[rsp+_len-_dataW], r14
   jg       sha256_block2_loop

done:
   mov   rsp, qword ptr[rsp+_frame-_dataW]
   REST_XMM_AVX
   REST_GPR
   ret
IPPASM UpdateSHA256 ENDP

ENDIF    ;; _IPP32E_L9 and above
ENDIF    ;; _FEATURE_OFF_ / _FEATURE_TICKTOCK_
ENDIF    ;; _ENABLE_ALG_SHA256_
END
