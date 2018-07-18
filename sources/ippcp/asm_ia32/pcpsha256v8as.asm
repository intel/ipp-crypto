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
;               Message block processing according to SHA256
; 
;     Content:
;        UpdateSHA256
; 
;

.686P
.387
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc
INCLUDE pcpvariant.inc

IF (_ENABLE_ALG_SHA256_)
IF (_SHA_NI_ENABLING_ EQ _FEATURE_OFF_) OR (_SHA_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP GE _IPP_V8) AND (_IPP LT _IPP_G9)

IFDEF IPP_PIC

LD_ADDR MACRO reg:REQ, addr:REQ
LOCAL LABEL
        call     LABEL
LABEL:  pop      reg
        sub      reg, LABEL-addr
ENDM

ELSE
LD_ADDR MACRO reg:REQ, addr:REQ
        lea      reg, addr
ENDM
ENDIF



XMM_SHUFB_BSWAP textequ <xmm6>
W0  textequ <xmm0>
W4  textequ <xmm1>
W8  textequ <xmm2>
W12 textequ <xmm3>
SIG1  textequ <xmm4>
SIG0  textequ <xmm5>
X     textequ <xmm6>
W     textequ <xmm7>

regTbl textequ <ebx>


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
ROUND MACRO nr, hashBuff, wBuff, F1,F2, T1,T2 ;;A,B,C,D,E,F,G,H, T1
   Summ1    F1, eax, T1
   Chj      F2, eax,<[hashBuff+((vF-nr) and 7)*sizeof(dword)]>,<[hashBuff+((vG-nr) and 7)*sizeof(dword)]>
   mov      eax, [hashBuff+((vH-nr) and 7)*sizeof(dword)]
   add      eax, F1
   add      eax, F2
   add      eax, dword ptr [wBuff+(nr and 3)*sizeof(dword)]

   mov      F1, dword ptr [hashBuff+((vB-nr) and 7)*sizeof(dword)]
   mov      T1, dword ptr [hashBuff+((vC-nr) and 7)*sizeof(dword)]
   Maj      F2, edx,F1, T1
   Summ0    F1, edx, T1
   lea      edx, [F1+F2]

   add      edx,eax                                      ; T2+T1
   add      eax,[hashBuff+((vD-nr) and 7)*sizeof(dword)] ; T1+d

   mov      [hashBuff+((vH-nr) and 7)*sizeof(dword)],edx
   mov      [hashBuff+((vD-nr) and 7)*sizeof(dword)],eax
ENDM

;;
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
SWP_BYTE:
pByteSwp DB    3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; SHA256(Ipp32u digest[], Ipp8u dataBlock[], int dataLen, Ipp32u K_256[])
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSHA256 PROC NEAR C PUBLIC \
USES esi edi ebx,\
pHash: PTR DWORD,\  ; pointer to hash
pData: PTR BYTE,\   ; pointer to data block
dataLen: DWORD,\    ; data length
pTbl: PTR DWORD     ; pointer to the SHA256 const table

MBS_SHA256  equ   (64)

hSize       = sizeof(dword)*8 ; size of hash
wSize       = sizeof(oword)   ; W values queue (dwords)
cntSize     = sizeof(dword)   ; local counter

hashOff  = 0                  ; hash address
wOff     = hashOff+hSize      ; W values offset
cntOff   = wOff+wSize

stackSize = (hSize+wSize+cntSize)   ; stack size
   sub            esp, stackSize

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sha256_block_loop:

   mov            eax, pHash  ; pointer to the hash
   movdqu         W0, oword ptr [eax]              ; load initial hash value
   movdqu         W4, oword ptr [eax+sizeof(oword)]
   movdqu         oword ptr [esp+hashOff], W0
   movdqu         oword ptr [esp+hashOff+sizeof(oword)*1], W4

  ;movdqa         XMM_SHUFB_BSWAP, oword ptr pByteSwp ; load shuffle mask
   LD_ADDR        eax, SWP_BYTE
   movdqa         XMM_SHUFB_BSWAP, oword ptr[eax+(pByteSwp-SWP_BYTE)]
   mov            eax, pData     ; pointer to the data block
   mov            regTbl, pTbl   ; pointer to SHA256 table (points K_256[] constants)

   movdqu         W0, oword ptr [eax]       ; load buffer content
   movdqu         W4, oword ptr [eax+sizeof(oword)]
   movdqu         W8, oword ptr [eax+sizeof(oword)*2]
   movdqu         W12,oword ptr [eax+sizeof(oword)*3]

vA = 0
vB = 1
vC = 2
vD = 3
vE = 4
vF = 5
vG = 6
vH = 7

   mov      eax, [esp+hashOff+vE*sizeof(dword)]
   mov      edx, [esp+hashOff+vA*sizeof(dword)]

   ;; perform 0-3 regular rounds
   pshufb   W0, XMM_SHUFB_BSWAP                    ; swap input
   movdqa   W, W0                                  ; T = W[0-3]
   paddd    W, oword ptr [regTbl+sizeof(oword)*0]  ; T += K_SHA256[0-3]
   movdqu   oword ptr [esp+wOff], W
   ROUND    0, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    1, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    2, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    3, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   ;; perform next 4-7 regular rounds
   pshufb   W4, XMM_SHUFB_BSWAP                    ; swap input
   movdqa   W, W4                                  ; T = W[4-7]
   paddd    W, oword ptr [regTbl+sizeof(oword)*1]  ; T += K_SHA256[4-7]
   movdqu   oword ptr [esp+wOff], W
   ROUND    4, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    5, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    6, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    7, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   ;; perform next 8-11 regular rounds
   pshufb   W8, XMM_SHUFB_BSWAP                    ; swap input
   movdqa   W, W8                                  ; T = W[8-11]
   paddd    W, oword ptr [regTbl+sizeof(oword)*2]  ; T += K_SHA256[8-11]
   movdqu   oword ptr [esp+wOff], W
   ROUND    8, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND    9, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   10, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   11, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   ;; perform next 12-15 regular rounds
   pshufb   W12, XMM_SHUFB_BSWAP                   ; swap input
   movdqa   W, W12                                 ; T = W[12-15]
   paddd    W, oword ptr [regTbl+sizeof(oword)*3]  ; T += K_SHA256[12-15]
   movdqu   oword ptr [esp+wOff], W
   ROUND   12, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   13, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   14, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   15, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   mov      dword ptr [esp+cntOff], (64-16)        ; init counter
loop_16_63:
   add      regTbl, sizeof(oword)*4                ; update SHA_256 pointer

   UPDATE_W    W, W0, W4, W8, W12, SIG1,SIG0,X        ; round: 16*i - 16*i+3
   paddd       W, oword ptr [regTbl+sizeof(oword)*0]  ; T += K_SHA256[16-19]
   movdqu      oword ptr [esp+wOff], W
   ROUND   16, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   17, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   18, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   19, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   UPDATE_W    W, W4, W8, W12,W0,  SIG1,SIG0,X        ; round: 20*i 20*i+3
   paddd       W, oword ptr [regTbl+sizeof(oword)*1]  ; T += K_SHA256[20-23]
   movdqu      oword ptr [esp+wOff], W
   ROUND   20, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   21, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   22, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   23, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   UPDATE_W    W, W8, W12,W0, W4,  SIG1,SIG0,X        ; round: 24*i - 24*i+3
   paddd       W, oword ptr [regTbl+sizeof(oword)*2]  ; T += K_SHA256[24-27]
   movdqu      oword ptr [esp+wOff], W
   ROUND   24, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   25, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   26, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   27, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   UPDATE_W    W, W12,W0, W4, W8,  SIG1,SIG0,X        ; round: 28*i - 28*i+3
   paddd       W, oword ptr [regTbl+sizeof(oword)*3]  ; T += K_SHA256[28-31]
   movdqu      oword ptr [esp+wOff], W
   ROUND   28, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   29, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   30, <esp+hashOff>,<esp+wOff>, esi,edi,ecx
   ROUND   31, <esp+hashOff>,<esp+wOff>, esi,edi,ecx

   sub         dword ptr [esp+cntOff], 16
   jg          loop_16_63

   mov            eax, pHash  ; pointer to the hash
   movdqu         W0, oword ptr [esp+hashOff]
   movdqu         W4, oword ptr [esp+hashOff+sizeof(oword)*1]

   ; update hash
   movdqu         W, oword ptr [eax]
   paddd          W, W0
   movdqu         oword ptr [eax], W
   movdqu         W, oword ptr [eax+sizeof(oword)]
   paddd          W, W4
   movdqu         oword ptr [eax+sizeof(oword)], W

   add            pData, MBS_SHA256
   sub            dataLen, MBS_SHA256
   jg             sha256_block_loop

   add            esp, stackSize
   ret
IPPASM UpdateSHA256 ENDP

ENDIF    ;; (_IPP GE _IPP_V8) AND (_IPP LT _IPP_G9)
ENDIF    ;; _FEATURE_OFF_ / _FEATURE_TICKTOCK_
ENDIF    ;; _ENABLE_ALG_SHA256_
END
