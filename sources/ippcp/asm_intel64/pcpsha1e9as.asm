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
;               Message block processing according to SHA1
; 
;     Content:
;        UpdateSHA1
; 
;
include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_ENABLE_ALG_SHA1_)
IF (_SHA_NI_ENABLING_ EQ _FEATURE_OFF_) OR (_SHA_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
;;IF (_IPP32E GE _IPP32E_E9 )
IF (_IPP32E EQ _IPP32E_E9 )

;;
;; SHA1 constants K[i]
SHA1_K1 equ (05a827999h)
SHA1_K2 equ (06ed9eba1h)
SHA1_K3 equ (08f1bbcdch)
SHA1_K4 equ (0ca62c1d6h)

;;
;; Magic functions defined in FIPS 180-1
;;
;; F1, F2, F3 and F4 assumes, that
;; - T1 returns function value
;; - T2 is the temporary
;;

F1 MACRO B,C,D       ;; F1 = ((D ^ (B & (C ^ D)))
   mov   T1,C
   xor   T1,D
   and   T1,B
   xor   T1,D
ENDM

F2 MACRO B,C,D       ;; F2 = (B ^ C ^ D)
   mov   T1,D
   xor   T1,C
   xor   T1,B
ENDM


F3 MACRO B,C,D       ;; F3 = ((B & C) | (B & D) | (C & D)) = B&C | (B|C)&D
   mov   T1,C
   mov   T2,B
   or    T1,B
   and   T2,C
   and   T1,D
   or    T1,T2
ENDM

F4 MACRO B,C,D       ;; F4 =F2 = (B ^ C ^ D)
   F2    B,C,D
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; rotations
;;

ROL_5 MACRO x
   shld  x,x, 5
ENDM

ROL_30 MACRO x
   shld  x,x, 30
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; textual rotation of W array
;;
ROTATE_W MACRO
    W_minus_32    textequ  W_minus_28
    W_minus_28    textequ  W_minus_24
    W_minus_24    textequ  W_minus_20
    W_minus_20    textequ  W_minus_16
    W_minus_16    textequ  W_minus_12
    W_minus_12    textequ  W_minus_08
    W_minus_08    textequ  W_minus_04
    W_minus_04    textequ  W
    W             textequ  W_minus_32
ENDM


;;
;; SHA1 update round:
;;    - F1 magic is used (and imbedded into the macros directly)
;;    - 16 bytes of input are swapped
;;
SHA1_UPDATE_RND_F1_BSWAP MACRO A,B,C,D,E, nr, Wchunk
   vpshufb  W, Wchunk, XMM_SHUFB_BSWAP
   vpaddd   Wchunk, W, oword ptr [K_XMM]
   vmovdqa  oword ptr [rsp + (nr AND 15)*4], Wchunk
   mov      T1,C   ; F1
   mov      T2,A
   xor      T1,D   ; F1
   and      T1,B   ; F1
   ROL_5    T2
   xor      T1,D   ; F1
   add      E, T2
   ROL_30   B
   add      T1, dword ptr [rsp + (nr AND 15)*4]
   add      E,T1

   ROTATE_W
ENDM

;;
;; SHA1 update round:
;;    - F1 magic is used (and imbedded into the macros directly)
;;
SHA1_UPDATE_RND_F1 MACRO A,B,C,D,E, nr
   mov      T1,C   ; F1
   mov      T2,A
   xor      T1,D   ; F1
   ROL_5    T2
   and      T1,B   ; F1
   xor      T1,D   ; F1
   add      E, T2
   ROL_30   B
   add      T1, dword ptr [rsp + (nr AND 15)*4]
   add      E,T1
ENDM

;;
;; update W
;;
W_CALC MACRO nr
   W_CALC_ahead = 8

   i = (nr + W_CALC_ahead)

   IF (i LT 20)
      K_XMM    textequ <K_BASE>
   ELSEIF (i LT 40)
      K_XMM    textequ <K_BASE+16>
   ELSEIF (i LT 60)
      K_XMM    textequ <K_BASE+32>
   ELSE
      K_XMM    textequ <K_BASE+48>
   ENDIF

   IF (i LT 32)
      IF ((i AND 3) EQ 0)        ;; just scheduling to interleave with ALUs
         vpalignr W, W_minus_12, W_minus_16, 8       ; w[i-14]
         vpsrldq  W_TMP, W_minus_04, 4               ; w[i-3]
         vpxor    W, W, W_minus_08
      ELSEIF ((i AND 3) EQ 1)
         vpxor    W_TMP, W_TMP, W_minus_16
         vpxor    W, W, W_TMP
         vpslldq  W_TMP2, W, 12
      ELSEIF ((i AND 3) EQ 2)
         vpslld   W_TMP, W, 1
         vpsrld   W, W, 31
         vpor     W_TMP, W_TMP, W
         vpslld   W, W_TMP2, 2
         vpsrld   W_TMP2, W_TMP2, 30
      ELSEIF ((i AND 3) EQ 3)
         vpxor    W_TMP, W_TMP, W
         vpxor    W, W_TMP, W_TMP2
         vpaddd   W_TMP, W, oword ptr [K_XMM]
         vmovdqa  oword ptr [rsp + ((i AND (NOT 3)) AND 15)*4],W_TMP

         ROTATE_W
      ENDIF

;; ELSEIF (i LT 83)
   ELSEIF (i LT 80)
      IF ((i AND 3) EQ 0)  ;; scheduling to interleave with ALUs
         vpalignr W_TMP, W_minus_04, W_minus_08, 8
         vpxor    W, W, W_minus_28      ;; W == W_minus_32
      ELSEIF ((i AND 3) EQ 1)
         vpxor    W_TMP, W_TMP, W_minus_16
         vpxor    W, W, W_TMP
      ELSEIF ((i AND 3) EQ 2)
         vpslld   W_TMP, W, 2
         vpsrld   W, W, 30
         vpor     W, W_TMP, W
      ELSEIF ((i AND 3) EQ 3)
         vpaddd   W_TMP, W, oword ptr [K_XMM]
         vmovdqa  oword ptr [rsp + ((i AND (NOT 3)) AND 15)*4],W_TMP

         ROTATE_W
      ENDIF

   ENDIF
ENDM

;;
;; Regular hash update
;;
SHA1_UPDATE_REGULAR MACRO A,B,C,D,E, nr, MagiF
   W_CALC   nr

   add      E, dword ptr [rsp + (nr AND 15)*4]
   MagiF    B,C,D
   add      D, dword ptr [rsp +((nr+1) AND 15)*4]
   ROL_30   B
   mov      T3,A
   add      E, T1
   ROL_5    T3
   add      T3, E
   mov      E, T3

   W_CALC   nr+1

   ROL_5    T3
   add      D,T3
   MagiF    A,B,C
   add      D, T1
   ROL_30   A

; write: %1, %2
; rotate: %1<=%4, %2<=%5, %3<=%1, %4<=%2, %5<=%3
ENDM

;; update hash macro
UPDATE_HASH MACRO hash0, hashAdd
     add    hashAdd, hash0
     mov    hash0, hashAdd
ENDM

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

K_XMM_AR       dd SHA1_K1, SHA1_K1, SHA1_K1, SHA1_K1
               dd SHA1_K2, SHA1_K2, SHA1_K2, SHA1_K2
               dd SHA1_K3, SHA1_K3, SHA1_K3, SHA1_K3
               dd SHA1_K4, SHA1_K4, SHA1_K4, SHA1_K4

shuffle_mask   DD 00010203h
               DD 04050607h
               DD 08090a0bh
               DD 0c0d0e0fh

;*****************************************************************************************
;* Purpose:     Update internal digest according to message block
;*
;* void UpdateSHA1(DigestSHA1 digest, const Ipp32u* mblk, int mlen, const void* pParam)
;*
;*****************************************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsSHA1Update
;; Caller = ippsSHA1Final
;; Caller = ippsSHA1MessageDigest
;;
;; Caller = ippsHMACSHA1Update
;; Caller = ippsHMACSHA1Final
;; Caller = ippsHMACSHA1MessageDigest
;;

;; assign hash values to GPU registers
A textequ <ecx>
B textequ <eax>
C textequ <edx>
D textequ <r8d>
E textequ <r9d>

;; temporary
T1 textequ <r10d>
T2 textequ <r11d>
T3 textequ <r13d>
T4 textequ <r13d>

W_TMP    textequ <xmm0>
W_TMP2   textequ <xmm1>

W0  textequ <xmm2>
W4  textequ <xmm3>
W8  textequ <xmm4>
W12 textequ <xmm5>
W16 textequ <xmm6>
W20 textequ <xmm7>
W24 textequ <xmm8>
W28 textequ <xmm9>

;; endianness swap constant
XMM_SHUFB_BSWAP textequ <xmm10>

;; K_BASE contains K_XMM_AR address
K_BASE textequ <r12>


ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSHA1 PROC PUBLIC FRAME
      USES_GPR rdi,rsi,r12,r13,r14
      ;;LOCAL_FRAME = (16*4+16*10)
      LOCAL_FRAME = (16*4)
      USES_XMM_AVX xmm6,xmm7,xmm8,xmm9,xmm10
      COMP_ABI 4

;;
;; rdi = digest ptr
;; rsi = data block ptr
;; rdx = data length
;; rcx = dummy

MBS_SHA1 equ   (64)

   movsxd         r14, edx

   movdqa         XMM_SHUFB_BSWAP, oword ptr shuffle_mask   ; load shuffle mask
   lea            K_BASE, K_XMM_AR                          ; SHA1 const array address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sha1_block_loop:
   mov            A, dword ptr [rdi]         ; load initial hash value
   mov            B, dword ptr [rdi+4]
   mov            C, dword ptr [rdi+8]
   mov            D, dword ptr [rdi+12]
   mov            E, dword ptr [rdi+16]

   movdqu         W28, oword ptr [rsi]       ; load buffer content
   movdqu         W24, oword ptr [rsi+16]
   movdqu         W20, oword ptr [rsi+32]
   movdqu         W16, oword ptr [rsi+48]

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;SHA1_MAIN_BODY

   W           textequ  W0
   W_minus_04  textequ  W4
   W_minus_08  textequ  W8
   W_minus_12  textequ  W12
   W_minus_16  textequ  W16
   W_minus_20  textequ  W20
   W_minus_24  textequ  W24
   W_minus_28  textequ  W28
   W_minus_32  textequ  W

   ;; assignment
   K_XMM textequ <K_BASE>

;;F textequ <F1>
   SHA1_UPDATE_RND_F1_BSWAP   A,B,C,D,E, 0, W28
   SHA1_UPDATE_RND_F1         E,A,B,C,D, 1
   SHA1_UPDATE_RND_F1         D,E,A,B,C, 2
   SHA1_UPDATE_RND_F1         C,D,E,A,B, 3

   SHA1_UPDATE_RND_F1_BSWAP   B,C,D,E,A, 4, W24
   SHA1_UPDATE_RND_F1         A,B,C,D,E, 5
   SHA1_UPDATE_RND_F1         E,A,B,C,D, 6
   SHA1_UPDATE_RND_F1         D,E,A,B,C, 7

   SHA1_UPDATE_RND_F1_BSWAP   C,D,E,A,B, 8, W20
   SHA1_UPDATE_RND_F1         B,C,D,E,A, 9
   SHA1_UPDATE_RND_F1         A,B,C,D,E, 10
   SHA1_UPDATE_RND_F1         E,A,B,C,D, 11

   SHA1_UPDATE_RND_F1_BSWAP   D,E,A,B,C, 12, W16

   W_CALC 8
   W_CALC 9
   W_CALC 10

   SHA1_UPDATE_RND_F1         C,D,E,A,B, 13

   W_CALC 11
   W_CALC 12

   SHA1_UPDATE_RND_F1         B,C,D,E,A, 14

   W_CALC 13
   W_CALC 14
   W_CALC 15

   SHA1_UPDATE_RND_F1         A,B,C,D,E, 15

   SHA1_UPDATE_REGULAR        E,A,B,C,D,16, F1
   SHA1_UPDATE_REGULAR        C,D,E,A,B,18, F1

;;F textequ <F2>
   SHA1_UPDATE_REGULAR        A,B,C,D,E,20, F2
   SHA1_UPDATE_REGULAR        D,E,A,B,C,22, F2
   SHA1_UPDATE_REGULAR        B,C,D,E,A,24, F2
   SHA1_UPDATE_REGULAR        E,A,B,C,D,26, F2
   SHA1_UPDATE_REGULAR        C,D,E,A,B,28, F2

   SHA1_UPDATE_REGULAR        A,B,C,D,E,30, F2
   SHA1_UPDATE_REGULAR        D,E,A,B,C,32, F2
   SHA1_UPDATE_REGULAR        B,C,D,E,A,34, F2
   SHA1_UPDATE_REGULAR        E,A,B,C,D,36, F2
   SHA1_UPDATE_REGULAR        C,D,E,A,B,38, F2

;;F textequ <F3>
   SHA1_UPDATE_REGULAR        A,B,C,D,E,40, F3
   SHA1_UPDATE_REGULAR        D,E,A,B,C,42, F3
   SHA1_UPDATE_REGULAR        B,C,D,E,A,44, F3
   SHA1_UPDATE_REGULAR        E,A,B,C,D,46, F3
   SHA1_UPDATE_REGULAR        C,D,E,A,B,48, F3

   SHA1_UPDATE_REGULAR        A,B,C,D,E,50, F3
   SHA1_UPDATE_REGULAR        D,E,A,B,C,52, F3
   SHA1_UPDATE_REGULAR        B,C,D,E,A,54, F3
   SHA1_UPDATE_REGULAR        E,A,B,C,D,56, F3
   SHA1_UPDATE_REGULAR        C,D,E,A,B,58, F3

;;F textequ <F4>
   SHA1_UPDATE_REGULAR        A,B,C,D,E,60, F4
   SHA1_UPDATE_REGULAR        D,E,A,B,C,62, F4
   SHA1_UPDATE_REGULAR        B,C,D,E,A,64, F4
   SHA1_UPDATE_REGULAR        E,A,B,C,D,66, F4
   SHA1_UPDATE_REGULAR        C,D,E,A,B,68, F4

   SHA1_UPDATE_REGULAR        A,B,C,D,E,70, F4
   SHA1_UPDATE_REGULAR        D,E,A,B,C,72, F4
   SHA1_UPDATE_REGULAR        B,C,D,E,A,74, F4
   SHA1_UPDATE_REGULAR        E,A,B,C,D,76, F4
   SHA1_UPDATE_REGULAR        C,D,E,A,B,78, F4
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   UPDATE_HASH    dword ptr [rdi],   A
   UPDATE_HASH    dword ptr [rdi+4], B
   UPDATE_HASH    dword ptr [rdi+8], C
   UPDATE_HASH    dword ptr [rdi+12],D
   UPDATE_HASH    dword ptr [rdi+16],E

   add            rsi, MBS_SHA1
   sub            r14, MBS_SHA1
   jg             sha1_block_loop

   REST_XMM_AVX
   REST_GPR
   ret
IPPASM UpdateSHA1 ENDP

ENDIF    ;; _IPP32E GE _IPP32E_E9
ENDIF    ;; _FEATURE_OFF_ / _FEATURE_TICKTOCK_
ENDIF    ;; _ENABLE_ALG_SHA1_
END
