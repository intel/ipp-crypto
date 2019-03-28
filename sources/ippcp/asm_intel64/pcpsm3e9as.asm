;===============================================================================
; Copyright 2015-2019 Intel Corporation
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
;               Message block processing according to SM3
; 
;     Content:
;        UpdateSM3
; 

include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_ENABLE_ALG_SM3_)
IF _IPP32E GE _IPP32E_E9

A  textequ <r8d>
B  textequ <r9d>
C  textequ <r10d>
D  textequ <r11d>
E  textequ <r12d>
F  textequ <r13d>
G  textequ <r14d>
H  textequ <r15d>

hPtr  textequ <rdi>
mPtr  textequ <rsi>
kPtr  textequ <rcx>

t0 textequ <eax>
t1 textequ <ebx>
t2 textequ <ebp>
t3 textequ <edx>

W0 textequ <xmm0>
W1 textequ <xmm1>
W2 textequ <xmm2>
W3 textequ <xmm3>

xT0 textequ <xmm4>
xT1 textequ <xmm5>
xTr textequ <xmm6>
xWZZZ textequ <xmm7>
xBCAST textequ <xmm8>
xROL8  textequ <xmm9>


ROTATE_H MACRO
   DUMMY textequ  H
   H     textequ  G
   G     textequ  F
   F     textequ  E
   E     textequ  D
   D     textequ  C
   C     textequ  B
   B     textequ  A
   A     textequ  DUMMY
ENDM

ROUND_00_15 MACRO nr
   mov   t0, A
   mov   t1, [kPtr+nr*sizeof(dword)]
   shld  t0, t0, 12  ; t0 = t
   add   t1, t0
   add   t1, E
   shld  t1, t1, 7   ; t1 = SS1
   xor   t0, t1      ; t0 = SS2

   add   t1, H       ; t1: TT2 = SS1 + h
   add   t0, D       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(nr and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(nr and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t2, B
   mov   t3, F

   xor   t2, C
   xor   t3, G

   xor   t2, A       ; t2 = FF(a,b,c) = a^b^c
   xor   t3, E       ; t3 = GG(e,f,g) = e^f^g

   add   t1, t3      ; t1: TT2 = SS1 +h +w[nr] +GG
   add   t0, t2      ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF

   shld  B, B, 9
   shld  F, F, 19

   mov   H, t0

   mov   D, t1
   shld  D, D, 8
   xor   D, t1
   shld  D, D, 9
   xor   D, t1

   ROTATE_H
ENDM

ROUND_16_63 MACRO nr, A,B,C,D,E,F,G,H
   mov   t0, A
   mov   t1, [kPtr+nr*sizeof(dword)]
   shld  t0, t0, 12     ; t0 = t
   add   t1, t0
   add   t1, E
   shld  t1, t1, 7      ; t1 = SS1
   xor   t0, t1         ; t0 = SS2

   add   t1, H       ; t1: TT2 = SS1 + h
   add   t0, D       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(nr and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(nr and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t3, B
   mov   t2, B
   and   t3, C
   xor   t2, C
   and   t2, A
   add   t2, t3

   mov   t3, F
   xor   t3, G
   and   t3, E
   xor   t3, G

   add   t0, t2         ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF
   add   t1, t3         ; t1: TT2 = SS1 +h +w[nr] +GG

   shld  B, B, 9
   shld  F, F, 19

   mov   H, t0

   mov   D, t1
   shld  D, D, 8
   xor   D, t1
   shld  D, D, 9
   xor   D, t1

  ;ROTATE_H
ENDM


;;
;; Y = ROL32(X,nbits)
xmmROL32 MACRO Y, X, nbits
IF nbits NE 8
   vpslld   xTr,X, nbits
   vpsrld   Y, X, (32-nbits)
   vpxor    Y, Y, xTr
ELSE
   ;;vpshufb  Y, X, oword ptr rol_32_8
   vpshufb  Y, X, xROL8
ENDIF
ENDM

xmmBCAST MACRO Y, X
   ;;vpshufb  Y, X, oword ptr bcast
   vpshufb  Y, X, xBCAST
ENDM

;;
;; w[j] = P1(w[t-16]^w[t-9]^ROL32(w[t-3],15)) ^ ROL32(w[t-13],7) ^ w[t-6]
;;
ROTATE_W MACRO
   DUMMY textequ  W0
   W0    textequ  W1
   W1    textequ  W2
   W2    textequ  W3
   W3    textequ  DUMMY
ENDM

QSCHED MACRO
   vpalignr xT0, W1, W0, sizeof(dword)*3  ;; T0 = {w6,w5,w4,w3}
   xmmROL32 xT0, xT0, 7                   ;; T0 = ROL32({w6,w5,w4,w3}, 7)

   ;; compute P1() argument
   vpsrldq  xT1, W3, sizeof(dword)        ;; T1 = {Z,w15,w14,w13}
   xmmROL32 xT1, xT1, 15                  ;; T1 = ROL32({Z,w15,w14,w13}, 15)
   vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15)
   vpalignr xT1, W2, W1, sizeof(dword)*3  ;; T1 = {w10,w9,w8,w7}
   vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15) ^ {w10,w9,w8,w7}

   ;; compute W0 = P1(W0), P1(x) = x ^ rol32(x,15) ^ rol(x,23)
   xmmROL32 xT1, W0, 8
   vpxor    xT1, xT1, W0
   xmmROL32 xT1, xT1, 15
   vpxor    W0, W0, xT1

   vpalignr xT1, W3, W2, sizeof(dword)*2  ;; T1 = {w13,w12,w11,w10}

   vpxor    W0, W0, xT0
   vpxor    W0, W0, xT1

   ;; compute P1(rol(w16,15))
   xmmBCAST    xT0, W0                    ;; T0 = {w16,w16,w16,rw16}
   vpsrlq      xT0, xT0, (32-15)          ;; T0 = {??,rol(w16,15),??,rol(w16,15)}
   xmmBCAST    xT0, xT0                   ;; T0 = {rol(w16,15),rol(w16,15),rol(w16,15),rol(w16,15)}
   vpsllq      xT1, xT0, 15
   vpxor       xT0, xT0, xT1
   vpsllq      xT1, xT1, (23-15)
   vpxor       xT0, xT0, xT1
  ;;vpshufb     xT0, xT0, oword ptr wzzz   ;; T0 = {P1(rol(w16,15)),zz,zz,zz}
   vpshufb     xT0, xT0, xWZZZ             ;; T0 = {P1(rol(w16,15)),zz,zz,zz}

   vpxor       W0, W0, xT0
   ROTATE_W
ENDM


QSCHED_W_QROUND_00_15 MACRO nr, A,B,C,D,E,F,G,H
      vpalignr xT0, W1, W0, sizeof(dword)*3  ;; T0 = {w6,w5,w4,w3}
      xmmROL32 xT0, xT0, 7                   ;; T0 = ROL32({w6,w5,w4,w3}, 7)

   t = nr
  ;ROUND_00_15  t
   mov   t0, A
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12  ; t0 = t
   add   t1, t0
   add   t1, E
   shld  t1, t1, 7   ; t1 = SS1
   xor   t0, t1      ; t0 = SS2

   add   t1, H       ; t1: TT2 = SS1 + h
   add   t0, D       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

      vpsrldq  xT1, W3, sizeof(dword)        ;; T1 = {Z,w15,w14,w13}
      xmmROL32 xT1, xT1, 15                  ;; T1 = ROL32({Z,w15,w14,w13}, 15)

   mov   t2, B
   mov   t3, F

   xor   t2, C
   xor   t3, G

   xor   t2, A       ; t2 = FF(a,b,c) = a^b^c
   xor   t3, E       ; t3 = GG(e,f,g) = e^f^g

   add   t1, t3      ; t1: TT2 = SS1 +h +w[nr] +GG
   add   t0, t2      ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF

   shld  B, B, 9
   shld  F, F, 19

   mov   H, t0

      vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15)
      vpalignr xT1, W2, W1, sizeof(dword)*3  ;; T1 = {w10,w9,w8,w7}
      vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15) ^ {w10,w9,w8,w7}

   mov   D, t1
   shld  D, D, 8
   xor   D, t1
   shld  D, D, 9
   xor   D, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;

   t = t+1
  ;ROUND_00_15  t
   mov   t0, H
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12  ; t0 = t
   add   t1, t0
   add   t1, D
   shld  t1, t1, 7   ; t1 = SS1
   xor   t0, t1      ; t0 = SS2

      xmmROL32 xT1, W0, 8
      vpxor    xT1, xT1, W0

   add   t1, G       ; t1: TT2 = SS1 + h
   add   t0, C       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

      xmmROL32 xT1, xT1, 15
      vpxor    W0, W0, xT1

   mov   t2, A
   mov   t3, E

   xor   t2, B
   xor   t3, F

   xor   t2, H       ; t2 = FF(a,b,c) = a^b^c
   xor   t3, D       ; t3 = GG(e,f,g) = e^f^g

   add   t1, t3      ; t1: TT2 = SS1 +h +w[nr] +GG
   add   t0, t2      ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF

   shld  A, A, 9
   shld  E, E, 19

   mov   G, t0

   mov   C, t1
   shld  C, C, 8
   xor   C, t1
   shld  C, C, 9
   xor   C, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;

      vpalignr xT1, W3, W2, sizeof(dword)*2  ;; T1 = {w13,w12,w11,w10}
      vpxor    W0, W0, xT0
      vpxor    W0, W0, xT1

   t = t+1
  ;ROUND_00_15  t
   mov   t0, G
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12  ; t0 = t
   add   t1, t0
   add   t1, C
   shld  t1, t1, 7   ; t1 = SS1
   xor   t0, t1      ; t0 = SS2

   add   t1, F       ; t1: TT2 = SS1 + h
   add   t0, B       ; t0: TT1 = SS2 + d

      xmmBCAST    xT0, W0                    ;; T0 = {w16,w16,w16,rw16}
      vpsrlq      xT0, xT0, (32-15)          ;; T0 = {??,rol(w16,15),??,rol(w16,15)}

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t2, H
   mov   t3, D

   xor   t2, A
   xor   t3, E

   xor   t2, G       ; t2 = FF(a,b,c) = a^b^c
   xor   t3, C       ; t3 = GG(e,f,g) = e^f^g

   add   t1, t3      ; t1: TT2 = SS1 +h +w[nr] +GG
   add   t0, t2      ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF

   shld  H, H, 9
   shld  D, D, 19

      xmmBCAST    xT0, xT0                   ;; T0 = {rol(w16,15),rol(w16,15),rol(w16,15),rol(w16,15)}
      vpsllq      xT1, xT0, 15

   mov   F, t0

   mov   B, t1
   shld  B, B, 8
   xor   B, t1
   shld  B, B, 9
   xor   B, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;

   t = t+1
  ;ROUND_00_15  t
   mov   t0, F
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12  ; t0 = t
   add   t1, t0
   add   t1, B
   shld  t1, t1, 7   ; t1 = SS1
   xor   t0, t1      ; t0 = SS2

      vpxor       xT0, xT0, xT1
      vpsllq      xT1, xT1, (23-15)

   add   t1, E       ; t1: TT2 = SS1 + h
   add   t0, A       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t2, G
   mov   t3, C

   xor   t2, H
   xor   t3, D

      vpxor       xT0, xT0, xT1
    ;;vpshufb     xT0, xT0, oword ptr wzzz   ;; T0 = {P1(rol(w16,15)),zz,zz,zz}
      vpshufb     xT0, xT0, xWZZZ   ;; T0 = {P1(rol(w16,15)),zz,zz,zz}

   xor   t2, F       ; t2 = FF(a,b,c) = a^b^c
   xor   t3, B       ; t3 = GG(e,f,g) = e^f^g

   add   t1, t3      ; t1: TT2 = SS1 +h +w[nr] +GG
   add   t0, t2      ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF

   shld  G, G, 9
   shld  C, C, 19

      vpxor       W0, W0, xT0

   mov   E, t0

   mov   A, t1
   shld  A, A, 8
   xor   A, t1
   shld  A, A, 9
   xor   A, t1

  ;ROTATE_H
   ROTATE_W
  ;;;;;;;;;;;;;;;
ENDM

QSCHED_W_QROUND_16_63 MACRO nr, A,B,C,D,E,F,G,H
      vpalignr xT0, W1, W0, sizeof(dword)*3  ;; T0 = {w6,w5,w4,w3}
      xmmROL32 xT0, xT0, 7                   ;; T0 = ROL32({w6,w5,w4,w3}, 7)

   t = nr
  ;ROUND_16_63  t
   mov   t0, A
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12     ; t0 = t
   add   t1, t0
   add   t1, E
   shld  t1, t1, 7      ; t1 = SS1
   xor   t0, t1         ; t0 = SS2

   add   t1, H       ; t1: TT2 = SS1 + h
   add   t0, D       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

      vpsrldq  xT1, W3, sizeof(dword)        ;; T1 = {Z,w15,w14,w13}
      xmmROL32 xT1, xT1, 15                  ;; T1 = ROL32({Z,w15,w14,w13}, 15)

   mov   t3, B
   mov   t2, B
   and   t3, C
   xor   t2, C
   and   t2, A
   add   t2, t3

   mov   t3, F
   xor   t3, G
   and   t3, E
   xor   t3, G

   add   t0, t2         ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF
   add   t1, t3         ; t1: TT2 = SS1 +h +w[nr] +GG

   shld  B, B, 9
   shld  F, F, 19

   mov   H, t0

      vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15)
      vpalignr xT1, W2, W1, sizeof(dword)*3  ;; T1 = {w10,w9,w8,w7}
      vpxor    W0, W0, xT1                   ;; W0 = {w3,w2,w1,w0} ^ ROL32({Z,w15,w14,w13}, 15) ^ {w10,w9,w8,w7}

   mov   D, t1
   shld  D, D, 8
   xor   D, t1
   shld  D, D, 9
   xor   D, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   t = t + 1
  ;ROUND_16_63  t
   mov   t0, H
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12     ; t0 = t
   add   t1, t0
   add   t1, D
   shld  t1, t1, 7      ; t1 = SS1
   xor   t0, t1         ; t0 = SS2

      xmmROL32 xT1, W0, 8
      vpxor    xT1, xT1, W0

   add   t1, G       ; t1: TT2 = SS1 + h
   add   t0, C       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

      xmmROL32 xT1, xT1, 15
      vpxor    W0, W0, xT1

   mov   t3, A
   mov   t2, A
   and   t3, B
   xor   t2, B
   and   t2, H
   add   t2, t3

   mov   t3, E
   xor   t3, F
   and   t3, D
   xor   t3, F

   add   t0, t2         ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF
   add   t1, t3         ; t1: TT2 = SS1 +h +w[nr] +GG

   shld  A, A, 9
   shld  E, E, 19

   mov   G, t0

   mov   C, t1
   shld  C, C, 8
   xor   C, t1
   shld  C, C, 9
   xor   C, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      vpalignr xT1, W3, W2, sizeof(dword)*2  ;; T1 = {w13,w12,w11,w10}
      vpxor    W0, W0, xT0
      vpxor    W0, W0, xT1

   t = t + 1
  ;ROUND_16_63  t
   mov   t0, G
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12     ; t0 = t
   add   t1, t0
   add   t1, C
   shld  t1, t1, 7      ; t1 = SS1
   xor   t0, t1         ; t0 = SS2

   add   t1, F       ; t1: TT2 = SS1 + h
   add   t0, B       ; t0: TT1 = SS2 + d

      xmmBCAST    xT0, W0                    ;; T0 = {w16,w16,w16,rw16}
      vpsrlq      xT0, xT0, (32-15)          ;; T0 = {??,rol(w16,15),??,rol(w16,15)}

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t3, H
   mov   t2, H
   and   t3, A
   xor   t2, A
   and   t2, G
   add   t2, t3

   mov   t3, D
   xor   t3, E
   and   t3, C
   xor   t3, E

   add   t0, t2         ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF
   add   t1, t3         ; t1: TT2 = SS1 +h +w[nr] +GG

   shld  H, H, 9
   shld  D, D, 19

      xmmBCAST    xT0, xT0                   ;; T0 = {rol(w16,15),rol(w16,15),rol(w16,15),rol(w16,15)}
      vpsllq      xT1, xT0, 15

   mov   F, t0

   mov   B, t1
   shld  B, B, 8
   xor   B, t1
   shld  B, B, 9
   xor   B, t1

  ;ROTATE_H
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   t = t + 1
  ;ROUND_16_63  t
   mov   t0, F
   mov   t1, [kPtr+t*sizeof(dword)]
   shld  t0, t0, 12     ; t0 = t
   add   t1, t0
   add   t1, B
   shld  t1, t1, 7      ; t1 = SS1
   xor   t0, t1         ; t0 = SS2

      vpxor       xT0, xT0, xT1
      vpsllq      xT1, xT1, (23-15)

   add   t1, E       ; t1: TT2 = SS1 + h
   add   t0, A       ; t0: TT1 = SS2 + d

   add   t1, [rsp+(t and 3)*sizeof(dword)]               ; t1: TT2 = SS1 + h +w[nr]
   add   t0, [rsp+(t and 3)*sizeof(dword)+sizeof(oword)] ; t0: TT1 = SS2 + d +(w[nr]^w[nr+4])

   mov   t3, G
   mov   t2, G
   and   t3, H
   xor   t2, H
   and   t2, F
   add   t2, t3

      vpxor       xT0, xT0, xT1
    ;;vpshufb     xT0, xT0, oword ptr wzzz   ;; T0 = {P1(rol(w16,15)),zz,zz,zz}
      vpshufb     xT0, xT0, xWZZZ   ;; T0 = {P1(rol(w16,15)),zz,zz,zz}

   mov   t3, C
   xor   t3, D
   and   t3, B
   xor   t3, D

   add   t0, t2         ; t0: TT1 = SS2 +d +(w[nr]^w[nr+4]) +FF
   add   t1, t3         ; t1: TT2 = SS1 +h +w[nr] +GG

   shld  G, G, 9
   shld  C, C, 19

      vpxor       W0, W0, xT0

   mov   E, t0

   mov   A, t1
   shld  A, A, 8
   xor   A, t1
   shld  A, A, 9
   xor   A, t1

  ;ROTATE_H
   ROTATE_W
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDM


.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

bswap128    DB    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12
rol_32_8    DB    3,0,1,2, 7,4,5,6, 11,8,9,10, 15,12,13,14
bcast       DB    0,1,2,3, 0,1,2,3, 0,1,2,3, 0,1,2,3
wzzz        DB    80h,80h,80h,80h, 80h,80h,80h,80h, 80h,80h,80h,80h,12,13,14,15

;********************************************************************
;* void UpdateSM3(Ipp32u* hash,
;                 const Ipp8u* msg, int msgLen,
;                 const Ipp32u* K_SM3)
;********************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSM3 PROC PUBLIC FRAME
      USES_GPR rbp,rbx,rsi,rdi,r12,r13,r14,r15
      LOCAL_FRAME = sizeof(oword)*2+sizeof(qword)*2
      USES_XMM xmm6,xmm7,xmm8,xmm9
      COMP_ABI 4

;; rdi = hash
;; rsi = data buffer
;; rdx = data buffer length (bytes)
;; rcx = address of SM3 constants

;; stack structure:
_wj   = 0                     ; W[t+3]:W[t+2]:W[t+1]:W[t]
_hash = _wj+sizeof(oword)*2   ; hash pointer
_len  = _hash+sizeof(qword)   ; msg length

MBS_SM3  equ   (64)

   movsxd   rdx, edx

   movdqa   xT0, oword ptr bswap128    ; swap byte
   movdqa   xWZZZ, oword ptr wzzz      ; shufle constant
   movdqa   xBCAST, oword ptr bcast
   movdqa   xROL8, oword ptr rol_32_8

   mov      qword ptr[rsp+_hash], rdi  ; save hash pointer
   mov      qword ptr[rsp+_len], rdx   ; save msg length

ALIGN IPP_ALIGN_FACTOR
sm3_loop:
   ; read data block (64 bytes)
   vmovdqu  W0, oword ptr [mPtr+sizeof(oword)*0]
   vpshufb  W0, W0, xT0
   vmovdqu  W1, oword ptr [mPtr+sizeof(oword)*1]
   vpshufb  W1, W1, xT0
   vmovdqu  W2, oword ptr [mPtr+sizeof(oword)*2]
   vpshufb  W2, W2, xT0
   vmovdqu  W3, oword ptr [mPtr+sizeof(oword)*3]
   vpshufb  W3, W3, xT0
   add      mPtr, MBS_SM3

   mov   A, [hPtr+0*sizeof(dword)]     ; input hash value
   mov   B, [hPtr+1*sizeof(dword)]
   mov   C, [hPtr+2*sizeof(dword)]
   mov   D, [hPtr+3*sizeof(dword)]
   mov   E, [hPtr+4*sizeof(dword)]
   mov   F, [hPtr+5*sizeof(dword)]
   mov   G, [hPtr+6*sizeof(dword)]
   mov   H, [hPtr+7*sizeof(dword)]


   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_00_15 0, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_00_15 4, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_00_15 8, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_00_15 12, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 16, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 20, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 24, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 28, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 32, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 36, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 40, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 44, E,F,G,H,A,B,C,D

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   QSCHED_W_QROUND_16_63 48, A,B,C,D,E,F,G,H

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   ROTATE_W
   ROUND_16_63 52, E,F,G,H,A,B,C,D
   ROUND_16_63 53, D,E,F,G,H,A,B,C
   ROUND_16_63 54, C,D,E,F,G,H,A,B
   ROUND_16_63 55, B,C,D,E,F,G,H,A

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   ROTATE_W
   ROUND_16_63 56, A,B,C,D,E,F,G,H
   ROUND_16_63 57, H,A,B,C,D,E,F,G
   ROUND_16_63 58, G,H,A,B,C,D,E,F
   ROUND_16_63 59, F,G,H,A,B,C,D,E

   vmovdqa  oword ptr [rsp+_wj], W0
   vpxor    xT0, W0, W1
   vmovdqa  oword ptr [rsp+_wj+sizeof(oword)], xT0
   ROTATE_W
   ROUND_16_63 60, E,F,G,H,A,B,C,D
   ROUND_16_63 61, D,E,F,G,H,A,B,C
   ROUND_16_63 62, C,D,E,F,G,H,A,B
   ROUND_16_63 63, B,C,D,E,F,G,H,A

   mov      hPtr, qword ptr[rsp+_hash] ; restore hash pointer

   xor      [hPtr+0*sizeof(dword)], A  ; update hash
   xor      [hPtr+1*sizeof(dword)], B
   xor      [hPtr+2*sizeof(dword)], C
   xor      [hPtr+3*sizeof(dword)], D
   xor      [hPtr+4*sizeof(dword)], E
   xor      [hPtr+5*sizeof(dword)], F
   xor      [hPtr+6*sizeof(dword)], G
   xor      [hPtr+7*sizeof(dword)], H

   movdqa   xT0, oword ptr bswap128    ; swap byte

   sub      qword ptr [rsp+_len], MBS_SM3
   cmp      qword ptr [rsp+_len], MBS_SM3
   jge      sm3_loop

   REST_XMM
   REST_GPR
   ret
IPPASM UpdateSM3 ENDP

ENDIF    ;; _IPP32E GE _IPP32E_E9
ENDIF    ;; _ENABLE_ALG_SM3_
END
