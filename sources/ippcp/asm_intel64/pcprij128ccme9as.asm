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
;               Rijndael Inverse Cipher function
; 
;     Content:
;        AuthEncrypt_RIJ128_AES_NI()
;        DecryptAuth_RIJ128_AES_NI()
; 
;
include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


ALIGN IPP_ALIGN_FACTOR
u128_str    DB 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
increment   DQ 1,0

;***************************************************************
;* Purpose:    Authenticate and Encrypt
;*
;* void AuthEncrypt_RIJ128_AES_NI(Ipp8u* outBlk,
;*                          const Ipp8u* inpBlk,
;*                                int nr,
;*                          const Ipp8u* pRKey,
;*                                Ipp32u len,
;*                                Ipp8u* pLocalState)
;* inp localCtx:
;*    MAC
;*    CTRi
;*    CTRi mask
;*
;* out localCtx:
;*    new MAC
;*    S = enc(CTRi)
;***************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsAES_CCMEncrypt
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM AuthEncrypt_RIJ128_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi, rdi, rbx
      LOCAL_FRAME = 0
      USES_XMM xmm6, xmm7
      COMP_ABI 6
;; rdi:     pInpBlk:  PTR BYTE,  ; input  blocks address
;; rsi:     pOutBlk:  PTR BYTE,  ; output blocks address
;; rdx:     nr:          DWORD,  ; number of rounds
;; rcx      pKey:     PTR BYTE,  ; key material address
;; r8d      length:      DWORD,  ; length (bytes)
;; r9       pLocCtx:  PTR BYTE   ; pointer to the localState

BYTES_PER_BLK = (16)

   movdqa   xmm0, oword ptr [r9]                   ; MAC
   movdqa   xmm2, oword ptr [r9+sizeof(oword)]     ; CTRi block
   movdqa   xmm1, oword ptr [r9+sizeof(oword)*2]   ; CTR mask

   movdqa   xmm7, oword ptr u128_str

   pshufb   xmm2, xmm7     ; CTRi block (LE)
   pshufb   xmm1, xmm7     ; CTR mask

   movdqa   xmm3, xmm1
   pandn    xmm3, xmm2     ; CTR block template
   pand     xmm2, xmm1     ; CTR value

   mov      r8d, r8d       ; expand length
   movsxd   rdx, edx       ; expand number of rounds

   lea      rdx, [rdx*4]   ; nrCounter = -nr*16
   lea      rdx, [rdx*4]   ; pKey += nr*16
   lea      rcx, [rcx+rdx]
   neg      rdx
   mov      rbx, rdx

ALIGN IPP_ALIGN_FACTOR
;;
;; block-by-block processing
;;
blk_loop:
   movdqu   xmm4, oword ptr [rdi]      ; input block src[i]
   pxor     xmm0, xmm4                 ; MAC ^= src[i]

   movdqa   xmm5, xmm3
   paddq    xmm2, oword ptr increment  ; advance counter bits
   pand     xmm2, xmm1                 ; and mask them
   por      xmm5, xmm2
   pshufb   xmm5, xmm7                 ; CTRi (BE)

   movdqa   xmm6, oword ptr [rcx+rdx]  ; keys for whitening
   add      rdx, 16

   pxor     xmm5, xmm6                 ; whitening (CTRi)
   pxor     xmm0, xmm6                 ; whitening (MAC)

   movdqa   xmm6, oword ptr [rcx+rdx]  ; pre load operation's keys

  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   aesenc   xmm5, xmm6                 ; regular round (CTRi)
   aesenc   xmm0, xmm6                 ; regular round (MAC)
   movdqa   xmm6, oword ptr [rcx+rdx+16]
   add      rdx, 16
   jnz      cipher_loop
   aesenclast  xmm5, xmm6              ; irregular round (CTRi)
   aesenclast  xmm0, xmm6              ; irregular round (MAC)

   pxor     xmm4, xmm5                 ; dst[i] = src[i] ^ ENC(CTRi)
   movdqu   oword ptr[rsi], xmm4

   mov      rdx, rbx
   add      rsi, BYTES_PER_BLK
   add      rdi, BYTES_PER_BLK
   sub      r8,  BYTES_PER_BLK
   jnz      blk_loop

   movdqu   oword ptr[r9], xmm0                 ; update MAC value
   movdqu   oword ptr[r9+sizeof(oword)], xmm5   ; update ENC(Ctri)

   pxor     xmm6, xmm6

   REST_XMM
   REST_GPR
   ret
IPPASM AuthEncrypt_RIJ128_AES_NI ENDP


;***************************************************************
;* Purpose:    Decrypt and Authenticate
;*
;* void DecryptAuth_RIJ128_AES_NI(Ipp8u* outBlk,
;*                          const Ipp8u* inpBlk,
;*                                int nr,
;*                          const Ipp8u* pRKey,
;*                                Ipp32u len,
;*                                Ipp8u* pLocalState)
;* inp localCtx:
;*    MAC
;*    CTRi
;*    CTRi mask
;*
;* out localCtx:
;*    new MAC
;*    S = enc(CTRi)
;***************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsAES_CCMDecrypt
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptAuth_RIJ128_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi, rdi, rbx
      LOCAL_FRAME = sizeof(qword)
      USES_XMM xmm6, xmm7
      COMP_ABI 6
;; rdi:     pInpBlk:  PTR BYTE,  ; input  blocks address
;; rsi:     pOutBlk:  PTR BYTE,  ; output blocks address
;; rdx:     nr:          DWORD,  ; number of rounds
;; rcx      pKey:     PTR BYTE,  ; key material address
;; r8d      length:      DWORD,  ; length (bytes)
;; r9       pLocCtx:  PTR BYTE   ; pointer to the localState

BYTES_PER_BLK = (16)

   movdqa   xmm0, oword ptr [r9]                   ; MAC
   movdqa   xmm2, oword ptr [r9+sizeof(oword)]     ; CTRi block
   movdqa   xmm1, oword ptr [r9+sizeof(oword)*2]   ; CTR mask

   movdqa   xmm7, oword ptr u128_str

   pshufb   xmm2, xmm7     ; CTRi block (LE)
   pshufb   xmm1, xmm7     ; CTR mask

   movdqa   xmm3, xmm1
   pandn    xmm3, xmm2     ; CTR block template
   pand     xmm2, xmm1     ; CTR value

   mov      r8d, r8d       ; expand length
   movsxd   rdx, edx       ; expand number of rounds

   lea      rdx, [rdx*4]   ; nrCounter = -nr*16
   lea      rdx, [rdx*4]   ; pKey += nr*16
   lea      rcx, [rcx+rdx]
   neg      rdx
   mov      rbx, rdx

ALIGN IPP_ALIGN_FACTOR
;;
;; block-by-block processing
;;
blk_loop:

   ;;;;;;;;;;;;;;;;;
   ;; decryption
   ;;;;;;;;;;;;;;;;;
   movdqu   xmm4, oword ptr [rdi]      ; input block src[i]

   movdqa   xmm5, xmm3
   paddq    xmm2, oword ptr increment  ; advance counter bits
   pand     xmm2, xmm1                 ; and mask them
   por      xmm5, xmm2
   pshufb   xmm5, xmm7                 ; CTRi (BE)

   movdqa   xmm6, oword ptr [rcx+rdx]  ; keys for whitening
   add      rdx, 16

   pxor     xmm5, xmm6                 ; whitening (CTRi)
   movdqa   xmm6, oword ptr [rcx+rdx]  ; pre load operation's keys

  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   aesenc   xmm5, xmm6                 ; regular round (CTRi)
   movdqa   xmm6, oword ptr [rcx+rdx+16]
   add      rdx, 16
   jnz      cipher_loop
   aesenclast  xmm5, xmm6              ; irregular round (CTRi)

   pxor     xmm4, xmm5                 ; dst[i] = src[i] ^ ENC(CTRi)
   movdqu   oword ptr[rsi], xmm4

   ;;;;;;;;;;;;;;;;;
   ;; update MAC
   ;;;;;;;;;;;;;;;;;
   mov      rdx, rbx

   movdqa   xmm6, oword ptr [rcx+rdx]  ; keys for whitening
   add      rdx, 16

   pxor     xmm0, xmm4                 ; MAC ^= dst[i]
   pxor     xmm0, xmm6                 ; whitening (MAC)

   movdqa   xmm6, oword ptr [rcx+rdx]  ; pre load operation's keys

  ALIGN IPP_ALIGN_FACTOR
auth_loop:
   aesenc   xmm0, xmm6                 ; regular round (MAC)
   movdqa   xmm6, oword ptr [rcx+rdx+16]
   add      rdx, 16
   jnz      auth_loop
   aesenclast  xmm0, xmm6              ; irregular round (MAC)


   mov      rdx, rbx
   add      rsi, BYTES_PER_BLK
   add      rdi, BYTES_PER_BLK
   sub      r8,  BYTES_PER_BLK
   jnz      blk_loop

   movdqu   oword ptr[r9], xmm0                 ; update MAC value
   movdqu   oword ptr[r9+sizeof(oword)], xmm6   ; update ENC(Ctri)

   pxor     xmm6, xmm6

   REST_XMM
   REST_GPR
   ret
IPPASM DecryptAuth_RIJ128_AES_NI ENDP

ENDIF
ENDIF ;; _AES_NI_ENABLING_

END
