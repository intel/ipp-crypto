;===============================================================================
; Copyright 2016-2019 Intel Corporation
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
;               AES functions
; 
;     Content:
;        cpAESEncryptXTS_AES_NI()
; 
;
include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

ALPHA_MUL_CNT  dq 00000000000000087h, 00000000000000001h


;***************************************************************
;* Purpose:    AES-XTS encryption
;*
;* void cpAESEncryptXTS_AES_NI(Ipp8u* outBlk,
;*                       const Ipp8u* inpBlk,
;*                             int length,
;*                       const Ipp8u* pRKey,
;*                             int nr,
;*                             Ipp8u* pTweak)
;***************************************************************

;;
;; key = ks[0]
;; mul_cnt = {0x0000000000000001:0x0000000000000087}
;; returns:
;;    ktwk = twk^key
;;    twk = twk*alpha
;;    twk2= twk2 *2     - auxillary
;;
OUTER_MUL_X MACRO ktwk, twk, key, mul_cnt, twk2, mask
   movdqa   mask, twk2
   paddd    twk2, twk2
   movdqa   ktwk, twk
   psrad    mask, 31
   paddq    twk, twk
   pand     mask, mul_cnt
   pxor     ktwk, key
   pxor     twk, mask
ENDM
LAST_OUTER_MUL_X MACRO ktwk, twk, key, mul_cnt, twk2
   movdqa   ktwk, twk
   psrad    twk2, 31
   paddq    twk, twk
   pand     twk2, mul_cnt
   pxor     ktwk, key
   pxor     twk, twk2
ENDM

INNER_MUL_X MACRO ktwk, twk, key, mul_cnt, twk2, mask
   movdqa   mask, twk2
   paddd    twk2, twk2
   psrad    mask, 31
   paddq    twk, twk
   pand     mask, mul_cnt
   pxor     twk, mask
   IFDIF    <key>,<ktwk>
   movdqa   key, ktwk
   ENDIF
   pxor     ktwk, twk
ENDM

LAST_INNER_MUL_X MACRO twk, mul_cnt, twk2
   psrad    twk2, 31
   paddq    twk, twk
   pand     twk2, mul_cnt
   pxor     twk, twk2
ENDM


ALIGN IPP_ALIGN_FACTOR
IPPASM cpAESEncryptXTS_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi,rdi
      LOCAL_FRAME = sizeof(oword)*6
      USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
      COMP_ABI 6
;; rdi:        pOutBlk:     PTR BYTE      ; pointer to the output bloak
;; rsi:        pInpBlk:     PTR BYTE      ; pointer to the input block
;; edx:        nBlocks          DWORD     ; number of blocks
;; rcx:        pKey:        PTR BYTE      ; key material address
;; r8d:        nr:              DWORD     ; number of rounds
;; r9          pTweak:      PTR BYTE      ; pointer to the input/outpout (ciphertext) tweak

AES_BLOCK = (16)

   movsxd   r8,  r8d                         ; number of cipher rounds

   movdqu   xmm15, xmmword ptr[r9]           ; input tweak value

   shl      r8, 4                            ; key schedule length (bytes)

   movdqa   xmm0, xmmword ptr[rcx]           ; key[0]
   movdqa   xmm8, xmmword ptr ALPHA_MUL_CNT  ; mul constant

   pshufd   xmm9, xmm15, 5Fh                 ; {twk[1]:twk[1]:twk[3]:twk[3]} - auxillary value

   movsxd   rdx, edx                         ; number of blocks being processing

   ;; compute:
   ;; - ktwk[i] = twk[i]^key[0]
   ;; - twk[i+1] = twk[i]*alpha^(i+1), i=0..5
        OUTER_MUL_X  xmm10, xmm15, xmm0, xmm8, xmm9, xmm14
        OUTER_MUL_X  xmm11, xmm15, xmm0, xmm8, xmm9, xmm14
        OUTER_MUL_X  xmm12, xmm15, xmm0, xmm8, xmm9, xmm14
        OUTER_MUL_X  xmm13, xmm15, xmm0, xmm8, xmm9, xmm14
   LAST_OUTER_MUL_X  xmm14, xmm15, xmm0, xmm8, xmm9

   movdqa   xmm8, xmm15                ; save tweak for next iteration
   pxor     xmm15, xmm0                ; add key[0]

   sub      rdx, 6         ; test input length
   jc       short_input

;;
;; blocks processing
;;
ALIGN IPP_ALIGN_FACTOR
blks_loop:
   pxor     xmm0, xmmword ptr[rcx+r8]  ; key[0]^key[last]

   lea      rax, [r8-6*AES_BLOCK]      ; cipher_loop counter
   lea      r10, [rcx+rax+AES_BLOCK]   ; mov key pointer down
   neg      rax

   movdqu   xmm2, xmmword ptr[rsi]              ; src[0] - src[7]
   movdqu   xmm3, xmmword ptr[rsi+AES_BLOCK]
   movdqu   xmm4, xmmword ptr[rsi+2*AES_BLOCK]
   movdqu   xmm5, xmmword ptr[rsi+3*AES_BLOCK]
   movdqu   xmm6, xmmword ptr[rsi+4*AES_BLOCK]
   movdqu   xmm7, xmmword ptr[rsi+5*AES_BLOCK]

   movdqa   xmm1, xmmword ptr[rcx+1*AES_BLOCK]  ; key[1]

   pxor     xmm2, xmm10                         ; src[] ^twk[] ^ key[0]
   pxor     xmm3, xmm11
   pxor     xmm4, xmm12
   pxor     xmm5, xmm13
   pxor     xmm6, xmm14
   pxor     xmm7, xmm15

   pxor     xmm10, xmm0                         ; store twk[] ^ key[last]
   pxor     xmm11, xmm0
   pxor     xmm12, xmm0
   pxor     xmm13, xmm0
   pxor     xmm14, xmm0
   pxor     xmm15, xmm0
   movdqa   xmm0, xmmword ptr[rcx+2*AES_BLOCK]  ; key[2]

   movdqa   xmmword ptr[rsp+0*AES_BLOCK], xmm10
   movdqa   xmmword ptr[rsp+1*AES_BLOCK], xmm11
   movdqa   xmmword ptr[rsp+2*AES_BLOCK], xmm12
   movdqa   xmmword ptr[rsp+3*AES_BLOCK], xmm13
   movdqa   xmmword ptr[rsp+4*AES_BLOCK], xmm14
   movdqa   xmmword ptr[rsp+5*AES_BLOCK], xmm15
   add      rsi, 6*AES_BLOCK

ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   add      rax, 2*AES_BLOCK  ; inc loop counter
   aesenc   xmm2, xmm1     ; regular rounds 3 - (last-2)
   aesenc   xmm3, xmm1
   aesenc   xmm4, xmm1
   aesenc   xmm5, xmm1
   aesenc   xmm6, xmm1
   aesenc   xmm7, xmm1
   movdqa   xmm1, xmmword ptr[r10+rax]
   aesenc   xmm2, xmm0
   aesenc   xmm3, xmm0
   aesenc   xmm4, xmm0
   aesenc   xmm5, xmm0
   aesenc   xmm6, xmm0
   aesenc   xmm7, xmm0
   movdqa   xmm0, xmmword ptr[r10+rax+AES_BLOCK]
   jnz      cipher_loop

   movdqa   xmm10, xmmword ptr[rcx] ; key[0]

   movdqa   xmm15, xmm8             ; restore tweak value
   pshufd   xmm9,  xmm8, 5Fh        ; {twk[1]:twk[1]:twk[3]:twk[3]} - auxillary value
   movdqa   xmm8, xmmword ptr ALPHA_MUL_CNT     ; mul constant

   ;
   ; last 6 rounds (5 regular rounds + irregular)
   ; merged together with next tweaks computation
   ;
   aesenc   xmm2, xmm1
   aesenc   xmm3, xmm1
   aesenc   xmm4, xmm1
   aesenc   xmm5, xmm1
   aesenc   xmm6, xmm1
   aesenc   xmm7, xmm1
   movdqa   xmm1, xmmword ptr[rcx+r8-3*AES_BLOCK]

   INNER_MUL_X xmm10, xmm15, xmm11,  xmm8, xmm9, xmm14

   aesenc   xmm2, xmm0
   aesenc   xmm3, xmm0
   aesenc   xmm4, xmm0
   aesenc   xmm5, xmm0
   aesenc   xmm6, xmm0
   aesenc   xmm7, xmm0
   movdqa   xmm0, xmmword ptr[rcx+r8-2*AES_BLOCK]

   INNER_MUL_X xmm11, xmm15, xmm12,  xmm8, xmm9, xmm14

   aesenc   xmm2, xmm1
   aesenc   xmm3, xmm1
   aesenc   xmm4, xmm1
   aesenc   xmm5, xmm1
   aesenc   xmm6, xmm1
   aesenc   xmm7, xmm1
   movdqa   xmm1, xmmword ptr[rcx+r8-1*AES_BLOCK]

   INNER_MUL_X xmm12, xmm15, xmm13,  xmm8, xmm9, xmm14

   aesenc   xmm2, xmm0
   aesenc   xmm3, xmm0
   aesenc   xmm4, xmm0
   aesenc   xmm5, xmm0
   aesenc   xmm6, xmm0
   aesenc   xmm7, xmm0

   INNER_MUL_X xmm13, xmm15, xmm14,  xmm8, xmm9, xmm14

   aesenc   xmm2, xmm1
   aesenc   xmm3, xmm1
   aesenc   xmm4, xmm1
   aesenc   xmm5, xmm1
   aesenc   xmm6, xmm1
   aesenc   xmm7, xmm1

   INNER_MUL_X xmm14, xmm15, xmm0,   xmm8, xmm9, xmm0

   aesenclast xmm2, xmmword ptr[rsp]            ; final irregular round
   aesenclast xmm3, xmmword ptr[rsp+1*AES_BLOCK]
   aesenclast xmm4, xmmword ptr[rsp+2*AES_BLOCK]
   aesenclast xmm5, xmmword ptr[rsp+3*AES_BLOCK]
   aesenclast xmm6, xmmword ptr[rsp+4*AES_BLOCK]
   aesenclast xmm7, xmmword ptr[rsp+5*AES_BLOCK]

   LAST_INNER_MUL_X xmm15, xmm8, xmm9
   movdqa   xmm8, xmm15                ; save tweak for next iteration
   pxor     xmm15, xmm0                ; add key[0]

   movdqu   xmmword ptr[rdi+0*AES_BLOCK], xmm2  ; store output blocks
   movdqu   xmmword ptr[rdi+1*AES_BLOCK], xmm3
   movdqu   xmmword ptr[rdi+2*AES_BLOCK], xmm4
   movdqu   xmmword ptr[rdi+3*AES_BLOCK], xmm5
   movdqu   xmmword ptr[rdi+4*AES_BLOCK], xmm6
   movdqu   xmmword ptr[rdi+5*AES_BLOCK], xmm7
   add      rdi, 6*AES_BLOCK

   sub      rdx, 6
   jnc      blks_loop

short_input:
   add      rdx, 6
   jz       quit

   movdqa   xmmword ptr[rsp+0*AES_BLOCK], xmm10    ; save pre-computed twae
   movdqa   xmmword ptr[rsp+1*AES_BLOCK], xmm11
   movdqa   xmmword ptr[rsp+2*AES_BLOCK], xmm12
   movdqa   xmmword ptr[rsp+3*AES_BLOCK], xmm13
   movdqa   xmmword ptr[rsp+4*AES_BLOCK], xmm14
   movdqa   xmmword ptr[rsp+5*AES_BLOCK], xmm15

;;
;; block-by-block processing
;;
   movdqa   xmm0, xmmword ptr[rcx]     ; key[0]
   pxor     xmm0, xmmword ptr[rcx+r8]  ; key[0] ^ key[last]

   lea   r10, [rcx+r8-9*AES_BLOCK]  ; r10 = &key[nr-9]
   xor   rax, rax

single_blk_loop:
   movdqu   xmm2, xmmword ptr[rsi]     ; input block
   movdqa   xmm1, xmmword ptr[rsp+rax] ; tweak ^ key[0]
   add      rsi, AES_BLOCK

   pxor     xmm2, xmm1     ; src[] ^tweak ^ key[0]
   pxor     xmm1, xmm0     ; tweak ^ key[lasl]
   cmp      r8, 12*16      ; switch according to number of rounds
   jl       key_128_s

key_256_s:
   aesenc      xmm2, xmmword ptr[r10-4*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10-3*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10-2*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10-1*AES_BLOCK]
key_128_s:
   aesenc      xmm2, xmmword ptr[r10+0*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+1*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+2*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+3*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+4*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+5*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+6*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+7*AES_BLOCK]
   aesenc      xmm2, xmmword ptr[r10+8*AES_BLOCK]
   aesenclast  xmm2, xmm1

   movdqu      xmmword ptr[rdi], xmm2        ; output block
   add         rdi, AES_BLOCK
   add         rax, AES_BLOCK
   sub         rdx, 1
   jnz         single_blk_loop

   movdqa      xmm10, xmmword ptr[rsp+rax]   ; tweak ^ key[0]

quit:
   pxor     xmm10, xmmword ptr[rcx]          ; remove key[0]
   movdqu   xmmword ptr[r9], xmm10           ; and save tweak value

   pxor     xmm1, xmm1

   REST_XMM
   REST_GPR
   ret
IPPASM cpAESEncryptXTS_AES_NI ENDP

ENDIF ;; _AES_NI_ENABLING_
ENDIF ;;_IPP32E_Y8
END
