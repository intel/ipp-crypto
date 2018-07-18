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
;               AES-GCM function
; 
;     Content:
;      AesGcmPrecompute_avx()
;      AesGcmMulGcm_avx()
;      AesGcmAuth_avx()
;      AesGcmEnc_avx()
;      AesGcmDec_avx()
;
;
;

.686P
.387
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

my_emulator = 0; set 1 for emulation
include emulator.inc


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

;;
;; a = a*b mod g(x), g(x) = x^128 + x^7 + x^2 +x +1
;;
sse_clmul_gcm MACRO GH, HK, tmpX0, tmpX1, tmpX2
   ;; GH, HK hold the values for the two operands which are carry-less multiplied
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; Karatsuba Method
   ;;
   ;; GH = [GH1:GH0]
   ;; HK = [HK1:HK0]
   ;;
   pshufd      tmpX2, GH, 01001110b ;; xmm2 = {GH0:GH1}
   pshufd      tmpX0, HK, 01001110b ;; xmm0 = {HK0:HK1}
   pxor        tmpX2, GH            ;; xmm2 = {GH0+GH1:GH1+GH0}
   pxor        tmpX0, HK            ;; xmm0 = {HK0+HK1:HK1+HK0}

my_pclmulqdq   tmpX2, tmpX0,00h     ;; tmpX2 = (a1+a0)*(b1+b0)     xmm2 = (GH1+GH0)*(HK1+HK0)
   movdqa      tmpX1, GH
my_pclmulqdq   GH,    HK,   00h     ;; GH = a0*b0                  GH   = GH0*HK0
   pxor        tmpX0, tmpX0
my_pclmulqdq   tmpX1, HK,   11h     ;; tmpX1 = a1*b1               xmm1 = GH1*HK1
   pxor        tmpX2, GH            ;;                             xmm2 = (GH1+GH0)*(HK1+HK0) + GH0*HK0
   pxor        tmpX2, tmpX1         ;; tmpX2 = a0*b1+a1*b0         xmm2 = (GH1+GH0)*(HK1+HK0) + GH0*HK0 + GH1*HK1 = GH0*HK1+GH1*HK0

   palignr     tmpX0, tmpX2, 8      ;; tmpX0 = {Zeros : HI(a0*b1+a1*b0)}
   pslldq      tmpX2, 8             ;; tmpX2 = {LO(HI(a0*b1+a1*b0)) : Zeros}
   pxor        tmpX1, tmpX0         ;; <xmm1:GH> holds the result of the carry-less multiplication of GH by HK
   pxor        GH,    tmpX2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;first phase of the reduction:
   ;  Most( (product_H * g1), 128))    product_H = GH
   ;                                   g1 = 2^256/g = g = 1+x+x^2+x^7+x^128
   ;
   movdqa   tmpX0, GH
   psllq    tmpX0, 1          ; GH<<1
   pxor     tmpX0, GH
   psllq    tmpX0, 5          ; ((GH<<1) ^ GH)<<5
   pxor     tmpX0, GH
   psllq    tmpX0, 57         ; (((GH<<1) ^ GH)<<5) ^ GH)<<57     <==>    GH<<63 ^ GH<<62 ^ GH<<57

   movdqa   tmpX2, tmpX0
   pslldq   tmpX2, 8          ; shift-L tmpX2 2 DWs
   psrldq   tmpX0, 8          ; shift-R xmm2 2 DWs

   pxor     GH, tmpX2         ; first phase of the reduction complete
   pxor     tmpX1, tmpX0      ; save the lost MS 1-2-7 bits from first phase

   ;second phase of the reduction
   movdqa   tmpX2, GH         ; move GH into xmm15
   psrlq    tmpX2, 5          ; packed right shifting >> 5
   pxor     tmpX2, GH         ; xor shifted versions
   psrlq    tmpX2, 1          ; packed right shifting >> 1
   pxor     tmpX2, GH         ; xor shifted versions
   psrlq    tmpX2, 1          ; packed right shifting >> 1

   pxor     GH, tmpX2         ; second phase of the reduction complete
   pxor     GH, tmpX1         ; the result is in GH
ENDM


IF _IPP GE _IPP_P8

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


ALIGN IPP_ALIGN_FACTOR
CONST_TABLE:
_poly       DQ    00000000000000001h,0C200000000000000h  ;; 0xC2000000000000000000000000000001
_twoone     DQ    00000000000000001h,00000000100000000h  ;; 0x00000001000000000000000000000001
_u128_str   DB    15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
_mask1      DQ    0ffffffffffffffffh,00000000000000000h  ;; 0x0000000000000000ffffffffffffffff
_mask2      DQ    00000000000000000h,0ffffffffffffffffh  ;; 0xffffffffffffffff0000000000000000
_inc1       DQ 1,0

POLY        equ [esi+(_poly - CONST_TABLE)]
TWOONE      equ [esi+(_twoone - CONST_TABLE)]
u128_str    equ [esi+(_u128_str - CONST_TABLE)]
MASK1       equ [esi+(_mask1 - CONST_TABLE)]
MASK2       equ [esi+(_mask2 - CONST_TABLE)]
inc1        equ [esi+(_inc1 - CONST_TABLE)]


sizeof_oword_ = (16)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; void GCMpipePrecomute(const Ipp8u* pRefHkey, Ipp8u* pMultipliers);
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmPrecompute_avx PROC NEAR C PUBLIC \
USES  esi,\
pHkey:         PTR BYTE,\ ; pointer to the reflected hkey
pMultipliers:  PTR BYTE  ; output to the precomputed multipliers

   LD_ADDR  esi, CONST_TABLE

   mov      eax, pHkey
   movdqu   xmm0, oword ptr [eax]   ;  xmm0 holds HashKey
   pshufb   xmm0, oword ptr u128_str

   ; precompute HashKey<<1 mod poly from the HashKey
   movdqa   xmm4, xmm0
   psllq    xmm0, 1
   psrlq    xmm4, 63
   movdqa   xmm3, xmm4
   pslldq   xmm4, 8
   psrldq   xmm3, 8
   por      xmm0, xmm4
   ;reduction
   pshufd   xmm4, xmm3, 00100100b
   pcmpeqd  xmm4, oword ptr TWOONE  ; TWOONE = 0x00000001000000000000000000000001
   pand     xmm4, oword ptr POLY
   pxor     xmm0, xmm4              ; xmm0 holds the HashKey<<1 mod poly

   movdqa         xmm1, xmm0
   sse_clmul_gcm  xmm1, xmm0, xmm3, xmm4, xmm5  ; xmm1 holds (HashKey^2)<<1 mod poly

   movdqa         xmm2, xmm1
   sse_clmul_gcm  xmm2, xmm1, xmm3, xmm4, xmm5  ; xmm2 holds (HashKey^4)<<1 mod poly

   mov      eax, pMultipliers
   movdqu   oword ptr [eax+sizeof_oword_*0], xmm0
   movdqu   oword ptr [eax+sizeof_oword_*1], xmm1
   movdqu   oword ptr [eax+sizeof_oword_*2], xmm2

   ret
IPPASM AesGcmPrecompute_avx ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; void AesGcmMulGcm_avx(Ipp8u* pHash, const Ipp8u* pHKey)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmMulGcm_avx PROC NEAR C PUBLIC \
      USES  esi edi,\
      pHash: PTR BYTE,\
      pHKey: PTR BYTE

   LD_ADDR  esi, CONST_TABLE

   mov   edi, pHash        ; (edi) pointer to the Hash value
   mov   eax, pHKey        ; (eax) pointer to the (hkey<<1) value

   movdqa   xmm0, oword ptr [edi]
   pshufb   xmm0, oword ptr u128_str
   movdqa   xmm1, oword ptr [eax]

   sse_clmul_gcm  xmm0, xmm1, xmm2, xmm3, xmm4  ; xmm0 holds Hash*HKey mod poly

   pshufb   xmm0, oword ptr u128_str
   movdqa   oword ptr [edi], xmm0

   ret
IPPASM AesGcmMulGcm_avx ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; void AesGcmAuth_avx(Ipp8u* pHash, const Ipp8u* pSrc, int len, const Ipp8u* pHKey
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmAuth_avx PROC NEAR C PUBLIC \
      USES     esi edi,\
      pHash:   PTR BYTE,\
      pSrc:    PTR BYTE,\
      len:     DWORD,\
      pHKey:   PTR BYTE

BYTES_PER_BLK = (16)

   LD_ADDR  esi, CONST_TABLE

   mov      edi, pHash
   movdqa   xmm0, oword ptr [edi]
   pshufb   xmm0, oword ptr u128_str
   mov      eax, pHKey
   movdqa   xmm1, oword ptr [eax]

   mov      ecx, pSrc
   mov      edx, len

  ALIGN IPP_ALIGN_FACTOR
auth_loop:
   movdqu   xmm2, oword ptr [ecx]  ; src[]
   pshufb   xmm2, oword ptr u128_str
   add      ecx, BYTES_PER_BLK
   pxor     xmm0, xmm2              ; hash ^= src[]

   sse_clmul_gcm  xmm0, xmm1, xmm2, xmm3, xmm4  ; xmm0 holds Hash*HKey mod poly

   sub      edx, BYTES_PER_BLK
   jnz      auth_loop

   pshufb   xmm0, oword ptr u128_str
   movdqa   oword ptr [edi], xmm0

   ret
IPPASM AesGcmAuth_avx ENDP


;***************************************************************
;* Purpose:    pipelined AES-GCM encryption
;*
;* void AesGcmEnc_avx(Ipp8u* pDst,
;*              const Ipp8u* pSrc,
;*                    int length,
;*              RijnCipher cipher,
;*                    int nr,
;*              const Ipp8u* pRKey,
;*                    Ipp8u* pGhash,
;*                    Ipp8u* pCtrValue,
;*                    Ipp8u* pEncCtrValue,
;*              const Ipp8u* pPrecomData)
;***************************************************************

;;
;; Lib = P8, G9
;;
;; Caller = ippsRijndael128GCMEncrypt
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmEnc_avx PROC NEAR C PUBLIC \
USES esi edi ebx,\
pDst:PTR BYTE,\  ; output block address
pSrc:PTR BYTE,\  ; input  block address
len:DWORD,\ ; length(byte)
cipher:PTR DWORD,\
nr:DWORD,\ ; number of rounds
pKey:PTR BYTE,\  ; key material address
pGhash:PTR BYTE,\  ; hash
pCounter:PTR BYTE,\  ; counter
pEcounter:PTR BYTE,\  ; enc. counter
pPrecomData:PTR BYTE   ; const multipliers

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

;;
;; stack structure:
CNT      = (0)
ECNT     = (CNT+sizeof_oword_)
GHASH    = (ECNT+sizeof_oword_)

GHASH0         = (GHASH)
GHASH1         = (GHASH0+sizeof_oword_)
GHASH2         = (GHASH1+sizeof_oword_)
GHASH3         = (GHASH2+sizeof_oword_)

SHUF_CONST = (GHASH3+sizeof_oword_)
INC_1      = (SHUF_CONST+sizeof_oword_)

BLKS4      = (INC_1+sizeof_oword_)
BLKS       = (BLKS4+sizeof(dword))
STACK_SIZE = (BLKS+sizeof(dword)+sizeof_oword_)

   sub      esp, STACK_SIZE             ; alocate stack
   lea      ebx, [esp+sizeof_oword_]    ; align stack
   and      ebx, -sizeof_oword_
   mov      eax, cipher                 ; due to bug in ml12 - dummy instruction
   LD_ADDR  esi, CONST_TABLE
   movdqa   xmm4, oword ptr u128_str
   movdqa   xmm5, oword ptr inc1

   mov      eax, pCounter              ; address of the counter
   mov      ecx, pEcounter             ; address of the encrypted counter
   mov      edx, pGhash                ; address of hash value

   movdqu   xmm0, oword ptr[eax]       ; counter value
   movdqu   xmm1, oword ptr[ecx]       ; encrypted counter value
   movdqu   xmm2, oword ptr[edx]       ; hash value

my_pshufb   xmm0, xmm4                 ; convert counter and
   movdqa   oword ptr [ebx+CNT], xmm0  ; and store into the stack
   movdqa   oword ptr [ebx+ECNT], xmm1 ; store encrypted counter into the stack

my_pshufb   xmm2, xmm4                 ; convert hash value
   pxor     xmm1, xmm1
   movdqa   oword ptr [ebx+GHASH0], xmm2  ; store hash into the stack
   movdqa   oword ptr [ebx+GHASH1], xmm1  ;
   movdqa   oword ptr [ebx+GHASH2], xmm1  ;
   movdqa   oword ptr [ebx+GHASH3], xmm1  ;

   movdqa   oword ptr [ebx+SHUF_CONST], xmm4 ; store constants into the stack
   movdqa   oword ptr [ebx+INC_1], xmm5

   mov      ecx, pKey                  ; key marerial
   mov      esi, pSrc                  ; src/dst pointers
   mov      edi, pDst

   mov      eax, len
   mov      edx, BYTES_PER_LOOP-1
   and      edx, eax
   and      eax,-BYTES_PER_LOOP
   mov      dword ptr [ebx+BLKS4], eax ; 4-blks counter
   mov      dword ptr [ebx+BLKS], edx  ; rest counter
   jz       single_block_proc

;;
;; pipelined processing
;;
  ALIGN IPP_ALIGN_FACTOR
blks4_loop:
   ;;
   ;; ctr encryption
   ;;
   movdqa   xmm5, oword ptr [ebx+INC_1]

   movdqa   xmm1, xmm0                 ; counter+1
   paddd    xmm1, xmm5
   movdqa   xmm2, xmm1                 ; counter+2
   paddd    xmm2, xmm5
   movdqa   xmm3, xmm2                 ; counter+3
   paddd    xmm3, xmm5
   movdqa   xmm4, xmm3                 ; counter+4
   paddd    xmm4, xmm5
   movdqa   oword ptr [ebx+CNT], xmm4

   movdqa   xmm5,oword ptr [ebx+SHUF_CONST]

   movdqa   xmm0, oword ptr[ecx]       ; pre-load whitening keys
   lea      eax, [ecx+16]              ; pointer to the round's key material

my_pshufb   xmm1, xmm5                 ; counter, counter+1, counter+2, counter+3
my_pshufb   xmm2, xmm5                 ; ready to be encrypted
my_pshufb   xmm3, xmm5
my_pshufb   xmm4, xmm5

   pxor     xmm1, xmm0                 ; whitening
   pxor     xmm2, xmm0
   pxor     xmm3, xmm0
   pxor     xmm4, xmm0

   movdqa   xmm0, oword ptr[eax]       ; pre load round keys
   add      eax, 16

   mov      edx, nr                    ; counter depending on key length
   sub      edx, 1

  ALIGN IPP_ALIGN_FACTOR
cipher4_loop:
my_aesenc      xmm1, xmm0              ; regular round
my_aesenc      xmm2, xmm0
my_aesenc      xmm3, xmm0
my_aesenc      xmm4, xmm0
   movdqa      xmm0, oword ptr[eax]
   add         eax, 16
   dec         edx
   jnz         cipher4_loop
my_aesenclast  xmm1, xmm0
my_aesenclast  xmm2, xmm0
my_aesenclast  xmm3, xmm0
my_aesenclast  xmm4, xmm0

   movdqa      xmm0, oword ptr [ebx+ECNT]    ; load pre-calculated encrypted counter
   movdqa      oword ptr [ebx+ECNT], xmm4    ; save encrypted counter+4

   movdqu      xmm4, oword ptr[esi+0*BYTES_PER_BLK]   ; ctr encryption of 4 input blocks
   movdqu      xmm5, oword ptr[esi+1*BYTES_PER_BLK]
   movdqu      xmm6, oword ptr[esi+2*BYTES_PER_BLK]
   movdqu      xmm7, oword ptr[esi+3*BYTES_PER_BLK]
   add         esi, BYTES_PER_LOOP

   pxor        xmm0, xmm4                             ; ctr encryption
   movdqu      oword ptr[edi+0*BYTES_PER_BLK], xmm0   ; store result
my_pshufbM     xmm0, oword ptr [ebx+SHUF_CONST]            ; convert for multiplication and
   pxor        xmm0, oword ptr [ebx+GHASH0]

   pxor        xmm1, xmm5
   movdqu      oword ptr[edi+1*BYTES_PER_BLK], xmm1
my_pshufbM     xmm1, oword ptr [ebx+SHUF_CONST]
   pxor        xmm1, oword ptr[ebx+GHASH1]

   pxor        xmm2, xmm6
   movdqu      oword ptr[edi+2*BYTES_PER_BLK], xmm2
my_pshufbM     xmm2, oword ptr [ebx+SHUF_CONST]
   pxor        xmm2, oword ptr[ebx+GHASH2]

   pxor        xmm3, xmm7
   movdqu      oword ptr[edi+3*BYTES_PER_BLK], xmm3
my_pshufbM     xmm3, oword ptr [ebx+SHUF_CONST]
   pxor        xmm3, oword ptr[ebx+GHASH3]

   add         edi, BYTES_PER_LOOP

   mov         eax, pPrecomData                        ; pointer to the {hk<<1,hk^2<<1,kh^4<<1} multipliers
   movdqa      xmm7,oword ptr [eax+sizeof_oword_*2]

   cmp         dword ptr [ebx+BLKS4], BYTES_PER_LOOP
   je          combine_hash

   ;;
   ;; update hash value
   ;;
   sse_clmul_gcm  xmm0, xmm7, xmm4, xmm5, xmm6       ; gHash0 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm1, xmm7, xmm4, xmm5, xmm6       ; gHash1 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm2, xmm7, xmm4, xmm5, xmm6       ; gHash2 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm3, xmm7, xmm4, xmm5, xmm6       ; gHash3 = gHash0 * (HashKey^4)<<1 mod poly

   movdqa      oword ptr [ebx+GHASH0], xmm0
   movdqa      oword ptr [ebx+GHASH1], xmm1
   movdqa      oword ptr [ebx+GHASH2], xmm2
   movdqa      oword ptr [ebx+GHASH3], xmm3

   movdqa      xmm0, oword ptr [ebx+CNT]     ; next counter value
   sub         dword ptr [ebx+BLKS4], BYTES_PER_LOOP
   jge         blks4_loop

combine_hash:
   sse_clmul_gcm  xmm0, xmm7, xmm4, xmm5, xmm6       ; gHash0 = gHash0 * (HashKey^4)<<1 mod poly
   movdqa         xmm7,oword ptr [eax+sizeof_oword_*1]
   sse_clmul_gcm  xmm1, xmm7, xmm4, xmm5, xmm6       ; gHash1 = gHash1 * (HashKey^2)<<1 mod poly
   movdqa         xmm7,oword ptr [eax+sizeof_oword_*0]
   sse_clmul_gcm  xmm2, xmm7, xmm4, xmm5, xmm6       ; gHash2 = gHash2 * (HashKey^1)<<1 mod poly

   pxor           xmm3, xmm1
   pxor           xmm3, xmm2
   sse_clmul_gcm  xmm3, xmm7, xmm4, xmm5, xmm6        ; gHash3 = gHash3 * (HashKey)<<1 mod poly

   pxor           xmm3, xmm0
   movdqa         oword ptr[ebx+GHASH0], xmm3         ; store ghash

;;
;; rest of input processing (1-3 blocks)
;;
single_block_proc:
   cmp      dword ptr [ebx+BLKS],0
   jz       quit

  ALIGN IPP_ALIGN_FACTOR
blk_loop:
   movdqa   xmm0, oword ptr [ebx+CNT]  ; advance counter value
   movdqa   xmm1, xmm0
   paddd    xmm1, oword ptr [ebx+INC_1]
   movdqa   oword ptr [ebx+CNT], xmm1

   movdqa   xmm0, oword ptr[ecx]       ; pre-load whitening keys
   lea      eax, [ecx+16]

my_pshufb   xmm1, oword ptr [ebx+SHUF_CONST] ; counter is ready to be encrypted

   pxor     xmm1, xmm0                 ; whitening

   movdqa   xmm0, oword ptr[eax]
   add      eax, 16

   mov      edx, nr                    ; counter depending on key length
   sub      edx, 1

  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
my_aesenc      xmm1, xmm0              ; regular round
   movdqa      xmm0, oword ptr[eax]
   add         eax, 16
   dec         edx
   jnz         cipher_loop
my_aesenclast  xmm1, xmm0

   movdqa      xmm0, oword ptr [ebx+ECNT]    ; load pre-calculated encrypted counter
   movdqa      oword ptr [ebx+ECNT], xmm1    ; save encrypted counter

   movdqu      xmm1, oword ptr[esi]          ; input block
   add         esi, BYTES_PER_BLK
   pxor        xmm0, xmm1                    ; ctr encryption
   movdqu      oword ptr[edi], xmm0
   add         edi, BYTES_PER_BLK

   mov         eax, pPrecomData

   pshufb      xmm0, oword ptr [ebx+SHUF_CONST]
   pxor        xmm0, oword ptr [ebx+GHASH0]
   movdqa      xmm1, oword ptr [eax]
   sse_clmul_gcm   xmm0, xmm1, xmm2, xmm3, xmm4 ; update hash value
   movdqa      oword ptr [ebx+GHASH0], xmm0

   sub         dword ptr [ebx+BLKS], BYTES_PER_BLK
   jg          blk_loop

;;
;; exit
;;
quit:
   movdqa   xmm4, oword ptr [ebx+SHUF_CONST]

   movdqa   xmm0, oword ptr [ebx+CNT]       ; counter
   movdqa   xmm1, oword ptr [ebx+ECNT]      ; encrypted counter
   movdqa   xmm2, oword ptr [ebx+GHASH0]    ; hash

   mov      eax, pCounter              ; address of the counter
   mov      ecx, pEcounter             ; address of the encrypted counter
   mov      edx, pGhash                ; address of hash value

my_pshufb   xmm0, xmm4                 ; convert counter back and
   movdqu   oword ptr [eax], xmm0      ; and store

   movdqu   oword ptr [ecx], xmm1      ; store encrypted counter into the context

my_pshufb   xmm2, xmm4                 ; convert hash value back
   movdqu   oword ptr [edx], xmm2      ; store hash into the context

   add      esp, STACK_SIZE            ; free stack
   ret
IPPASM AesGcmEnc_avx ENDP


;***************************************************************
;* Purpose:    pipelined AES-GCM decryption
;*
;* void AesGcmEnc_avx(Ipp8u* pDst,
;*              const Ipp8u* pSrc,
;*                    int length,
;*              RijnCipher cipher,
;*                    int nr,
;*              const Ipp8u* pRKey,
;*                    Ipp8u* pGhash,
;*                    Ipp8u* pCtrValue,
;*                    Ipp8u* pEncCtrValue,
;*              const Ipp8u* pPrecomData)
;***************************************************************

;;
;; Lib = P8, G9
;;
;; Caller = ippsRijndael128GCMDecrypt
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmDec_avx PROC NEAR C PUBLIC \
USES esi edi ebx,\
pDst:PTR BYTE,\  ; output block address
pSrc:PTR BYTE,\  ; input  block address
len:DWORD,\ ; length(byte)
cipher:PTR DWORD,\
nr:DWORD,\ ; number of rounds
pKey:PTR BYTE,\  ; key material address
pGhash:PTR BYTE,\  ; hash
pCounter:PTR BYTE,\  ; counter
pEcounter:PTR BYTE,\  ; enc. counter
pPrecomData:PTR BYTE   ; const multipliers

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

;;
;; stack structure:
CNT      = (0)
ECNT     = (CNT+sizeof_oword_)
GHASH    = (ECNT+sizeof_oword_)

GHASH0   = (GHASH)
GHASH1   = (GHASH0+sizeof_oword_)
GHASH2   = (GHASH1+sizeof_oword_)
GHASH3   = (GHASH2+sizeof_oword_)

SHUF_CONST = (GHASH3+sizeof_oword_)
INC_1      = (SHUF_CONST+sizeof_oword_)

BLKS4      = (INC_1+sizeof_oword_)
BLKS       = (BLKS4+sizeof(dword))
STACK_SIZE = (BLKS+sizeof(dword)+sizeof_oword_)

   sub      esp, STACK_SIZE            ; alocate stack
   lea      ebx, [esp+sizeof_oword_]   ; align stack
   and      ebx, -sizeof_oword_
   mov      eax, cipher                 ; due to bug in ml12 - dummy instruction

   LD_ADDR  esi, CONST_TABLE
   movdqa   xmm4, oword ptr u128_str
   movdqa   xmm5, oword ptr inc1

   mov      eax, pCounter              ; address of the counter
   mov      ecx, pEcounter             ; address of the encrypted counter
   mov      edx, pGhash                ; address of hash value

   movdqu   xmm0, oword ptr[eax]       ; counter value
   movdqu   xmm1, oword ptr[ecx]       ; encrypted counter value
   movdqu   xmm2, oword ptr[edx]       ; hash value

my_pshufb   xmm0, xmm4                 ; convert counter and
   movdqa   oword ptr [ebx+CNT], xmm0  ; and store into the stack
   movdqa   oword ptr [ebx+ECNT], xmm1 ; store encrypted counter into the stack

my_pshufb   xmm2, xmm4                 ; convert hash value
   pxor     xmm1, xmm1
   movdqa   oword ptr [ebx+GHASH0], xmm2  ; store hash into the stack
   movdqa   oword ptr [ebx+GHASH1], xmm1  ;
   movdqa   oword ptr [ebx+GHASH2], xmm1  ;
   movdqa   oword ptr [ebx+GHASH3], xmm1  ;

   movdqa   oword ptr [ebx+SHUF_CONST], xmm4 ; store constants into the stack
   movdqa   oword ptr [ebx+INC_1], xmm5

   mov      ecx, pKey                  ; key marerial
   mov      esi, pSrc                  ; src/dst pointers
   mov      edi, pDst   

   mov      eax, len
   mov      edx, BYTES_PER_LOOP-1
   and      edx, eax
   and      eax,-BYTES_PER_LOOP
   mov      dword ptr [ebx+BLKS4], eax ; 4-blks counter
   mov      dword ptr [ebx+BLKS], edx  ; rest counter
   jz       single_block_proc

;;
;; pipelined processing
;;
  ALIGN IPP_ALIGN_FACTOR
blks4_loop:
   ;;
   ;; ctr encryption
   ;;
   movdqa   xmm5, oword ptr [ebx+INC_1]

   movdqa   xmm1, xmm0                 ; counter+1
   paddd    xmm1, xmm5
   movdqa   xmm2, xmm1                 ; counter+2
   paddd    xmm2, xmm5
   movdqa   xmm3, xmm2                 ; counter+3
   paddd    xmm3, xmm5
   movdqa   xmm4, xmm3                 ; counter+4
   paddd    xmm4, xmm5
   movdqa   oword ptr [ebx+CNT], xmm4

   movdqa   xmm5,oword ptr [ebx+SHUF_CONST]

   movdqa   xmm0, oword ptr[ecx]       ; pre-load whitening keys
   lea      eax, [ecx+16]              ; pointer to the round's key material

my_pshufb   xmm1, xmm5                 ; counter, counter+1, counter+2, counter+3
my_pshufb   xmm2, xmm5                 ; ready to be encrypted
my_pshufb   xmm3, xmm5
my_pshufb   xmm4, xmm5

   pxor     xmm1, xmm0                 ; whitening
   pxor     xmm2, xmm0
   pxor     xmm3, xmm0
   pxor     xmm4, xmm0

   movdqa   xmm0, oword ptr[eax]       ; pre load round keys
   add      eax, 16

   mov      edx, nr                    ; counter depending on key length
   sub      edx, 1

  ALIGN IPP_ALIGN_FACTOR
cipher4_loop:
my_aesenc      xmm1, xmm0              ; regular round
my_aesenc      xmm2, xmm0
my_aesenc      xmm3, xmm0
my_aesenc      xmm4, xmm0
   movdqa      xmm0, oword ptr[eax]
   add         eax, 16
   dec         edx
   jnz         cipher4_loop
my_aesenclast  xmm1, xmm0
my_aesenclast  xmm2, xmm0
my_aesenclast  xmm3, xmm0
my_aesenclast  xmm4, xmm0

   movdqa      xmm0, oword ptr [ebx+ECNT]    ; load pre-calculated encrypted counter
   movdqa      oword ptr [ebx+ECNT], xmm4    ; save encrypted counter+4

   movdqu      xmm4, oword ptr[esi+0*BYTES_PER_BLK]   ; ctr encryption of 4 input blocks
   movdqu      xmm5, oword ptr[esi+1*BYTES_PER_BLK]
   movdqu      xmm6, oword ptr[esi+2*BYTES_PER_BLK]
   movdqu      xmm7, oword ptr[esi+3*BYTES_PER_BLK]
   add         esi, BYTES_PER_LOOP

   pxor        xmm0, xmm4                             ; ctr encryption
   movdqu      oword ptr[edi+0*BYTES_PER_BLK], xmm0   ; store result
my_pshufbM     xmm4, oword ptr [ebx+SHUF_CONST]       ; convert for multiplication and
   pxor        xmm4, oword ptr [ebx+GHASH0]

   pxor        xmm1, xmm5
   movdqu      oword ptr[edi+1*BYTES_PER_BLK], xmm1
my_pshufbM     xmm5, oword ptr [ebx+SHUF_CONST]
   pxor        xmm5, oword ptr[ebx+GHASH1]

   pxor        xmm2, xmm6
   movdqu      oword ptr[edi+2*BYTES_PER_BLK], xmm2
  ;pshufb      xmm6, oword ptr [ebx+SHUF_CONST]
my_pshufbM     xmm6, oword ptr [ebx+SHUF_CONST]
   pxor        xmm6, oword ptr[ebx+GHASH2]

   pxor        xmm3, xmm7
   movdqu      oword ptr[edi+3*BYTES_PER_BLK], xmm3
my_pshufbM     xmm7, oword ptr [ebx+SHUF_CONST]
   pxor        xmm7, oword ptr[ebx+GHASH3]

   add         edi, BYTES_PER_LOOP

   mov         eax, pPrecomData                 ; pointer to the const multipliers (c^1, c^2, c^4)
   movdqa      xmm0,oword ptr [eax+sizeof_oword_*2]

   cmp         dword ptr [ebx+BLKS4], BYTES_PER_LOOP
   je          combine_hash

   ;;
   ;; update hash value
   ;;
   sse_clmul_gcm  xmm4, xmm0, xmm1, xmm2, xmm3       ; gHash0 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm5, xmm0, xmm1, xmm2, xmm3       ; gHash1 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm6, xmm0, xmm1, xmm2, xmm3       ; gHash2 = gHash0 * (HashKey^4)<<1 mod poly
   sse_clmul_gcm  xmm7, xmm0, xmm1, xmm2, xmm3       ; gHash3 = gHash0 * (HashKey^4)<<1 mod poly

   movdqa      oword ptr [ebx+GHASH0], xmm4
   movdqa      oword ptr [ebx+GHASH1], xmm5
   movdqa      oword ptr [ebx+GHASH2], xmm6
   movdqa      oword ptr [ebx+GHASH3], xmm7

   movdqa      xmm0, oword ptr [ebx+CNT]     ; next counter value
   sub         dword ptr [ebx+BLKS4], BYTES_PER_LOOP
   jge         blks4_loop

combine_hash:
   sse_clmul_gcm  xmm4, xmm0, xmm1, xmm2, xmm3       ; gHash0 = gHash0 * (HashKey^4)<<1 mod poly
   movdqa         xmm0, oword ptr [eax+sizeof_oword_*1]
   sse_clmul_gcm  xmm5, xmm0, xmm1, xmm2, xmm3       ; gHash1 = gHash1 * (HashKey^2)<<1 mod poly
   movdqa         xmm0, oword ptr [eax+sizeof_oword_*0]
   sse_clmul_gcm  xmm6, xmm0, xmm1, xmm2, xmm3       ; gHash2 = gHash2 * (HashKey^1)<<1 mod poly

   pxor           xmm7, xmm5
   pxor           xmm7, xmm6
   sse_clmul_gcm  xmm7, xmm0, xmm1, xmm2, xmm3        ; gHash3 = gHash3 * (HashKey)<<1 mod poly

   pxor           xmm7, xmm4
   movdqa         oword ptr[ebx+GHASH0], xmm7         ; store ghash

;;
;; rest of input processing (1-3 blocks)
;;
single_block_proc:
   cmp      dword ptr [ebx+BLKS],0
   jz       quit

  ALIGN IPP_ALIGN_FACTOR
blk_loop:
   movdqa   xmm0, oword ptr [ebx+CNT]  ; advance counter value
   movdqa   xmm1, xmm0
   paddd    xmm1, oword ptr [ebx+INC_1]
   movdqa   oword ptr [ebx+CNT], xmm1

   movdqa   xmm0, oword ptr[ecx]       ; pre-load whitening keys
   lea      eax, [ecx+16]

my_pshufb   xmm1, oword ptr [ebx+SHUF_CONST] ; counter is ready to be encrypted

   pxor     xmm1, xmm0                 ; whitening

   movdqa   xmm0, oword ptr[eax]
   add      eax, 16

   mov      edx, nr                    ; counter depending on key length
   sub      edx, 1

  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
my_aesenc      xmm1, xmm0              ; regular round
   movdqa      xmm0, oword ptr[eax]
   add         eax, 16
   dec         edx
   jnz         cipher_loop
my_aesenclast  xmm1, xmm0

   movdqa      xmm0, oword ptr [ebx+ECNT]    ; load pre-calculated encrypted counter
   movdqa      oword ptr [ebx+ECNT], xmm1    ; save encrypted counter

   movdqu      xmm1, oword ptr[esi]          ; input block
   add         esi, BYTES_PER_BLK
   pxor        xmm0, xmm1                    ; ctr encryption
   movdqu      oword ptr[edi], xmm0
   add         edi, BYTES_PER_BLK

   mov         eax, pPrecomData

   pshufb      xmm1, oword ptr [ebx+SHUF_CONST]
   pxor        xmm1, oword ptr [ebx+GHASH0]
   movdqa      xmm0, oword ptr [eax]
   sse_clmul_gcm   xmm1, xmm0, xmm2, xmm3, xmm4 ; update hash value
   movdqa      oword ptr [ebx+GHASH0], xmm1

   sub         dword ptr [ebx+BLKS], BYTES_PER_BLK
   jg          blk_loop

;;
;; exit
;;
quit:
   movdqa   xmm4, oword ptr [ebx+SHUF_CONST]

   movdqa   xmm0, oword ptr [ebx+CNT]     ; counter
   movdqa   xmm1, oword ptr [ebx+ECNT]    ; encrypted counter
   movdqa   xmm2, oword ptr [ebx+GHASH0]  ; hash

   mov      eax, pCounter              ; address of the counter
   mov      ecx, pEcounter             ; address of the encrypted counter
   mov      edx, pGhash                ; address of hash value

my_pshufb   xmm0, xmm4                 ; convert counter back and
   movdqu   oword ptr [eax], xmm0      ; and store

   movdqu   oword ptr [ecx], xmm1      ; store encrypted counter into the context

my_pshufb   xmm2, xmm4                 ; convert hash value back
   movdqu   oword ptr [edx], xmm2      ; store hash into the context

   add      esp, STACK_SIZE            ; free stack
   ret
IPPASM AesGcmDec_avx ENDP

ENDIF
END
