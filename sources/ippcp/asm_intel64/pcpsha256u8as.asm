;===============================================================================
; Copyright 2015-2018 Intel Corporation
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
;

include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc
include pcpvariant.inc

IF (_ENABLE_ALG_SHA256_)
IF (_SHA_NI_ENABLING_ EQ _FEATURE_OFF_) OR (_SHA_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF ((_IPP32E GE _IPP32E_U8 ) AND (_IPP32E LT _IPP32E_E9 )) OR (_IPP32E EQ _IPP32E_N8 )


XMM_SHUFB_BSWAP textequ <xmm6>
W0  textequ <xmm0>
W4  textequ <xmm1>
W8  textequ <xmm2>
W12 textequ <xmm3>
SIG1  textequ <xmm4>
SIG0  textequ <xmm5>
X     textequ <xmm6>
W     textequ <xmm7>

;; assign hash values to GPU registers
A  textequ <eax>
B  textequ <ebx>
C  textequ <edx>
D  textequ <r8d>
E  textequ <r9d>
F  textequ <r10d>
G  textequ <r11d>
H  textequ <r12d>
T1 textequ <r13d>
T2 textequ <r14d>
T3 textequ <r15d>

;; we are considering x, y, z are polynomials over GF(2)
;;                    & - multiplication
;;                    ^ - additive
;;                    operations

;;
;; Chj(x,y,z) = (x&y) ^ (~x & z)
;;            = (x&y) ^ ((1^x) &z)
;;            = (x&y) ^ (z ^ x&z)
;;            = x&y ^ z ^ x&z
;;            = x&(y^z) ^z
;;
Chj MACRO F:REQ, X:REQ,Y:REQ,Z:REQ
   mov   F, Y
   xor   F, Z
   and   F, X
   xor   F, Z
ENDM

;;
;; Maj(x,y,z) = (x&y) ^ (x&z) ^ (y&z)
;;            = (x&y) ^ (x&z) ^ (y&z) ^ (z&z) ^z   // note: ((z&z) ^z) = 0
;;            = x&(y^z) ^ z&(y^z) ^z
;;            = (x^z)&(y^z) ^z
;;
Maj MACRO F:REQ, X:REQ,Y:REQ,Z:REQ
   mov   F, X
   xor   F, Z
   xor   Z, Y
   and   F, Z
   xor   Z, Y
   xor   F, Z
ENDM

ROTR MACRO X, n
   ;;shrd  X,X, n
   ror   X, n
ENDM

;;
;; Summ0(x) = ROR(x,2) ^ ROR(x,13) ^ ROR(x,22)
;;
Summ0 MACRO F:REQ, X:REQ, T:REQ
   mov   F, X
   ROTR  F, 2
   mov   T, X
   ROTR  T, 13
   xor   F, T
   ROTR  T, (22-13)
   xor   F, T
ENDM

;;
;; Summ1(x) = ROR(x,6) ^ ROR(x,11) ^ ROR(x,25)
;;
Summ1 MACRO F:REQ, X:REQ, T:REQ
   mov   F, X
   ROTR  F, 6
   mov   T, X
   ROTR  T, 11
   xor   F, T
   ROTR  T, (25-11)
   xor   F, T
ENDM

;;
;; regular round (i):
;;
;; T1 = h + Sigma1(e) + Ch(e,f,g) + K[i] + W[i]
;; T2 = Sigma0(a) + Maj(a,b,c)
;; h = g
;; g = f
;; f = e
;; e = d + T1
;; d = c
;; c = b
;; b = a
;; a = T1+T2
;;
;;    or
;;
;; h += Sigma1(e) + Ch(e,f,g) + K[i] + W[i]  (==T1)
;; d += h
;; T2 = Sigma0(a) + Maj(a,b,c)
;; h += T2
;; and following textual shift {a,b,c,d,e,f,g,h} => {h,a,b,c,d,e,f,g}
;;
ROUND MACRO nr, A,B,C,D,E,F,G,H, T1,T2
   add      H, dword ptr [rsp+(nr and 3)*sizeof(dword)]
   Summ1    T1, E, T2
   Chj      T2, E,F,G
   add      H, T1
   add      H, T2

   add      D, H

   Summ0    T1, A, T2
   Maj      T2, A,B,C
   add      H, T1
   add      H, T2
ENDM

;; W[i] = Sigma1(W[i-2]) + W[i-7] + Sigma0(W[i-15]) + W[i-16], i=16,..,63
;;
;;for next rounds 16,17,18 and 19:
;; W[0] <= W[16] = Sigma1(W[14]) + W[ 9] + Sigma0(W[1]) + W[0]
;; W[1] <= W[17] = Sigma1(W[15]) + W[10] + Sigma0(W[2]) + W[1]
;; W[2] <= W[18] = Sigma1(W[ 0]) + W[11] + Sigma0(W[3]) + W[1]
;; W[3] <= W[19] = Sigma1(W[ 1]) + W[12] + Sigma0(W[4]) + W[2]
;;
;; the process is repeated exactly because texual round of W[]
;;
;; Sigma1() and Sigma0() functions are defined as following:
;; Sigma1(X) = ROR(X,17)^ROR(X,19)^SHR(X,10)
;; Sigma0(X) = ROR(X, 7)^ROR(X,18)^SHR(X, 3)
;;
UPDATE_W MACRO xS, xS0, xS4, xS8, xS12, SIGMA1, SIGMA0,X
   pshufd   SIGMA1, xS12, 11111010b   ;; SIGMA1 = {W[15],W[15],W[14],W[14]}
   movdqa   X, SIGMA1
   psrld    SIGMA1, 10
   psrlq    X, 17
   pxor     SIGMA1, X
   psrlq    X, (19-17)
   pxor     SIGMA1, X

   pshufd   SIGMA0, xS0, 10100101b   ;; SIGMA0 = {W[2],W[2],W[1],W[1]}
   movdqa   X, SIGMA0
   psrld    SIGMA0, 3
   psrlq    X, 7
   pxor     SIGMA0, X
   psrlq    X, (18-7)
   pxor     SIGMA0, X

   pshufd   xS, xS0, 01010000b   ;; {W[ 1],W[ 1],W[ 0],W[ 0]}
   pshufd   X, xS8, 10100101b    ;; {W[10],W[10],W[ 9],W[ 9]}
   paddd    xS, SIGMA1
   paddd    xS, SIGMA0
   paddd    xS, X


   pshufd   SIGMA1, xS, 10100000b   ;; SIGMA1 = {W[1],W[1],W[0],W[0]}
   movdqa   X, SIGMA1
   psrld    SIGMA1, 10
   psrlq    X, 17
   pxor     SIGMA1, X
   psrlq    X, (19-17)
   pxor     SIGMA1, X

   movdqa   SIGMA0, xS4             ;; SIGMA0 = {W[4],W[4],W[3],W[3]}
   palignr  SIGMA0, xS0, (3*sizeof(dword))
   pshufd   SIGMA0, SIGMA0, 01010000b
   movdqa   X, SIGMA0
   psrld    SIGMA0, 3
   psrlq    X, 7
   pxor     SIGMA0, X
   psrlq    X, (18-7)
   pxor     SIGMA0, X

   movdqa   X, xS12
   palignr  X, xS8, (3*sizeof(dword))  ;; {W[14],W[13],W[12],W[11]}
   pshufd   xS0, xS0, 11111010b        ;; {W[ 3],W[ 3],W[ 2],W[ 2]}
   pshufd   X, X, 01010000b            ;; {W[12],W[12],W[11],W[11]}
   paddd    xS0, SIGMA1
   paddd    xS0, SIGMA0
   paddd    xS0, X

   pshufd   xS, xS, 10001000b          ;; {W[1],W[0],W[1],W[0]}
   pshufd   xS0, xS0, 10001000b        ;; {W[3],W[2],W[3],W[2]}
   palignr  xS0, xS, (2*sizeof(dword)) ;; {W[3],W[2],W[1],W[0]}
   movdqa   xS, xS0
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR
pByteSwp DB    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; UpdateSHA256(Ipp32u digest[], Ipp8u dataBlock[], int datalen, Ipp32u K_256[])
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSHA256 PROC PUBLIC FRAME
      USES_GPR rbx,rsi,rdi,rbp,r12,r13,r14,r15
      LOCAL_FRAME = sizeof(oword)+sizeof(qword)
      USES_XMM xmm6,xmm7
      COMP_ABI 4
;;
;; rdi = pointer to the updated hash
;; rsi = pointer to the data block
;; rdx = data block length
;; rcx = pointer to the SHA_256 constant
;;

MBS_SHA256  equ   (64)

   movsxd   rdx, edx
   mov      qword ptr[rsp+sizeof(oword)], rdx   ; save length of buffer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sha256_block_loop:

   movdqu         W0, oword ptr [rsi]       ; load buffer content
   movdqu         W4, oword ptr [rsi+sizeof(oword)]
   movdqu         W8, oword ptr [rsi+sizeof(oword)*2]
   movdqu         W12,oword ptr [rsi+sizeof(oword)*3]

   mov            A, dword ptr [rdi]         ; load initial hash value
   mov            B, dword ptr [rdi+sizeof(dword)]
   mov            C, dword ptr [rdi+sizeof(dword)*2]
   mov            D, dword ptr [rdi+sizeof(dword)*3]
   mov            E, dword ptr [rdi+sizeof(dword)*4]
   mov            F, dword ptr [rdi+sizeof(dword)*5]
   mov            G, dword ptr [rdi+sizeof(dword)*6]
   mov            H, dword ptr [rdi+sizeof(dword)*7]

   movdqa         XMM_SHUFB_BSWAP, oword ptr pByteSwp ; load shuffle mask

                  ; rcx points K_256[] constants

   ;; perform 0-3 regular rounds
   pshufb   W0, XMM_SHUFB_BSWAP                 ; swap input
   movdqa   W, W0                               ; T = W[0-3]
   paddd    W, oword ptr [rcx+sizeof(oword)*0]  ; T += K_SHA256[0-3]
   movdqa   oword ptr [rsp], W
   ROUND    0, A,B,C,D,E,F,G,H, T1,T2
   ROUND    1, H,A,B,C,D,E,F,G, T1,T2
   ROUND    2, G,H,A,B,C,D,E,F, T1,T2
   ROUND    3, F,G,H,A,B,C,D,E, T1,T2

   ;; perform next 4-7 regular rounds
   pshufb   W4, XMM_SHUFB_BSWAP                 ; swap input
   movdqa   W, W4                               ; T = W[4-7]
   paddd    W, oword ptr [rcx+sizeof(oword)*1]  ; T += K_SHA256[4-7]
   movdqa   oword ptr [rsp], W
   ROUND    4, E,F,G,H,A,B,C,D, T1,T2
   ROUND    5, D,E,F,G,H,A,B,C, T1,T2
   ROUND    6, C,D,E,F,G,H,A,B, T1,T2
   ROUND    7, B,C,D,E,F,G,H,A, T1,T2

   ;; perform next 8-11 regular rounds
   pshufb   W8, XMM_SHUFB_BSWAP                 ; swap input
   movdqa   W, W8                               ; T = W[8-11]
   paddd    W, oword ptr [rcx+sizeof(oword)*2]  ; T += K_SHA256[8-11]
   movdqa   oword ptr [rsp], W
   ROUND    8, A,B,C,D,E,F,G,H, T1,T2
   ROUND    9, H,A,B,C,D,E,F,G, T1,T2
   ROUND   10, G,H,A,B,C,D,E,F, T1,T2
   ROUND   11, F,G,H,A,B,C,D,E, T1,T2

   ;; perform next 12-15 regular rounds
   pshufb   W12, XMM_SHUFB_BSWAP                ; swap input
   movdqa   W, W12                              ; T = W[12-15]
   paddd    W, oword ptr [rcx+sizeof(oword)*3]  ; T += K_SHA256[12-15]
   movdqa   oword ptr [rsp], W
   ROUND   12, E,F,G,H,A,B,C,D, T1,T2
   ROUND   13, D,E,F,G,H,A,B,C, T1,T2
   ROUND   14, C,D,E,F,G,H,A,B, T1,T2
   ROUND   15, B,C,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W0, W4, W8, W12, SIG1,SIG0,X     ; round: 16-19
   paddd       W, oword ptr [rcx+sizeof(oword)*4]  ; T += K_SHA256[16-19]
   movdqa      oword ptr [rsp], W
   ROUND   16, A,B,C,D,E,F,G,H, T1,T2
   ROUND   17, H,A,B,C,D,E,F,G, T1,T2
   ROUND   18, G,H,A,B,C,D,E,F, T1,T2
   ROUND   19, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W4, W8, W12,W0,  SIG1,SIG0,X     ; round: 20-23
   paddd       W, oword ptr [rcx+sizeof(oword)*5]  ; T += K_SHA256[20-23]
   movdqa      oword ptr [rsp], W
   ROUND   20, E,F,G,H,A,B,C,D, T1,T2
   ROUND   21, D,E,F,G,H,A,B,C, T1,T2
   ROUND   22, C,D,E,F,G,H,A,B, T1,T2
   ROUND   23, B,C,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W8, W12,W0, W4,  SIG1,SIG0,X     ; round: 24-27
   paddd       W, oword ptr [rcx+sizeof(oword)*6]  ; T += K_SHA256[24-27]
   movdqa      oword ptr [rsp], W
   ROUND   24, A,B,C,D,E,F,G,H, T1,T2
   ROUND   25, H,A,B,C,D,E,F,G, T1,T2
   ROUND   26, G,H,A,B,C,D,E,F, T1,T2
   ROUND   27, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W12,W0, W4, W8,  SIG1,SIG0,X     ; round: 28-31
   paddd       W, oword ptr [rcx+sizeof(oword)*7]  ; T += K_SHA256[28-31]
   movdqa      oword ptr [rsp], W
   ROUND   28, E,F,G,H,A,B,C,D, T1,T2
   ROUND   29, D,E,F,G,H,A,B,C, T1,T2
   ROUND   30, C,D,E,F,G,H,A,B, T1,T2
   ROUND   31, B,C,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W0, W4, W8, W12, SIG1,SIG0,X     ; round: 32-35
   paddd       W, oword ptr [rcx+sizeof(oword)*8]  ; T += K_SHA256[32-35]
   movdqa      oword ptr [rsp], W
   ROUND   32, A,B,C,D,E,F,G,H, T1,T2
   ROUND   33, H,A,B,C,D,E,F,G, T1,T2
   ROUND   34, G,H,A,B,C,D,E,F, T1,T2
   ROUND   35, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W4, W8, W12,W0,  SIG1,SIG0,X     ; round: 36-39
   paddd       W, oword ptr [rcx+sizeof(oword)*9]  ; T += K_SHA256[36-39]
   movdqa      oword ptr [rsp], W
   ROUND   36, E,F,G,H,A,B,C,D, T1,T2
   ROUND   37, D,E,F,G,H,A,B,C, T1,T2
   ROUND   38, C,D,E,F,G,H,A,B, T1,T2
   ROUND   39, B,C,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W8, W12,W0, W4,  SIG1,SIG0,X     ; round: 40-43
   paddd       W, oword ptr [rcx+sizeof(oword)*10] ; T += K_SHA256[40-43]
   movdqa      oword ptr [rsp], W
   ROUND   40, A,B,C,D,E,F,G,H, T1,T2
   ROUND   41, H,A,B,C,D,E,F,G, T1,T2
   ROUND   42, G,H,A,B,C,D,E,F, T1,T2
   ROUND   43, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W12,W0, W4, W8,  SIG1,SIG0,X     ; round: 44-47
   paddd       W, oword ptr [rcx+sizeof(oword)*11] ; T += K_SHA256[44-47]
   movdqa      oword ptr [rsp], W
   ROUND   44, E,F,G,H,A,B,C,D, T1,T2
   ROUND   45, D,E,F,G,H,A,B,C, T1,T2
   ROUND   46, C,D,E,F,G,H,A,B, T1,T2
   ROUND   47, B,c,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W0, W4, W8, W12, SIG1,SIG0,X     ; round: 48-51
   paddd       W, oword ptr [rcx+sizeof(oword)*12] ; T += K_SHA256[48-51]
   movdqa      oword ptr [rsp], W
   ROUND   48, A,B,C,D,E,F,G,H, T1,T2
   ROUND   49, H,A,B,C,D,E,F,G, T1,T2
   ROUND   50, G,H,A,B,C,D,E,F, T1,T2
   ROUND   51, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W4, W8, W12,W0,  SIG1,SIG0,X     ; round: 52-55
   paddd       W, oword ptr [rcx+sizeof(oword)*13] ; T += K_SHA256[52-55]
   movdqa      oword ptr [rsp], W
   ROUND   52, E,F,G,H,A,B,C,D, T1,T2
   ROUND   53, D,E,F,G,H,A,B,C, T1,T2
   ROUND   54, C,D,E,F,G,H,A,B, T1,T2
   ROUND   55, B,C,D,E,F,G,H,A, T1,T2

   UPDATE_W    W, W8, W12,W0, W4,  SIG1,SIG0,X     ; round: 56-59
   paddd       W, oword ptr [rcx+sizeof(oword)*14] ; T += K_SHA256[56-59]
   movdqa      oword ptr [rsp], W
   ROUND   56, A,B,C,D,E,F,G,H, T1,T2
   ROUND   57, H,A,B,C,D,E,F,G, T1,T2
   ROUND   58, G,H,A,B,C,D,E,F, T1,T2
   ROUND   59, F,G,H,A,B,C,D,E, T1,T2

   UPDATE_W    W, W12,W0, W4, W8,  SIG1,SIG0,X     ; round: 60-63
   paddd       W, oword ptr [rcx+sizeof(oword)*15] ; T += K_SHA256[60-63]
   movdqa      oword ptr [rsp], W
   ROUND   60, E,F,G,H,A,B,C,D, T1,T2
   ROUND   61, D,E,F,G,H,A,B,C, T1,T2
   ROUND   62, C,D,E,F,G,H,A,B, T1,T2
   ROUND   63, B,C,D,E,F,G,H,A, T1,T2

   add            dword ptr [rdi], A         ; update hash
   add            dword ptr [rdi+sizeof(dword)*1], B
   add            dword ptr [rdi+sizeof(dword)*2], C
   add            dword ptr [rdi+sizeof(dword)*3], D
   add            dword ptr [rdi+sizeof(dword)*4], E
   add            dword ptr [rdi+sizeof(dword)*5], F
   add            dword ptr [rdi+sizeof(dword)*6], G
   add            dword ptr [rdi+sizeof(dword)*7], H

   add      rsi, MBS_SHA256
   sub      qword ptr[rsp+sizeof(oword)], MBS_SHA256
   jg       sha256_block_loop

   REST_XMM
   REST_GPR
   ret
IPPASM UpdateSHA256 ENDP

ENDIF    ;; ((_IPP32E GE _IPP32E_U8 ) AND (_IPP32E LT _IPP32E_E9 )) OR (_IPP32E EQ _IPP32E_N8 )
ENDIF    ;; _FEATURE_OFF_ / _FEATURE_TICKTOCK_
ENDIF    ;; _ENABLE_ALG_SHA256_
END
