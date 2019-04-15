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
;     Purpose:  Cryptography Primitive.
;               Rijndael Inverse Cipher function
; 
;     Content:
;        Encrypt_RIJ128_AES_NI()
; 
;
include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)


COPY_8U MACRO  dst, src, limit, tmp
LOCAL next_byte
   xor   rcx, rcx
next_byte:
   mov   tmp, byte ptr[src+rcx]
   mov   byte ptr[dst+rcx], tmp
   add   rcx, 1
   cmp   rcx, limit
   jl    next_byte
ENDM

COPY_32U MACRO  dst, src, limit, tmp
LOCAL next_dword
   xor   rcx, rcx
next_dword:
   mov   tmp, dword ptr[src+rcx]
   mov   dword ptr[dst+rcx], tmp
   add   rcx, 4
   cmp   rcx, limit
   jl    next_dword
ENDM

COPY_128U MACRO  dst, src, limit, tmp
LOCAL next_oword
   xor   rcx, rcx
next_oword:
   movdqu   tmp, oword ptr[src+rcx]
   movdqu   oword ptr[dst+rcx], tmp
   add   rcx, 16
   cmp   rcx, limit
   jl    next_oword
ENDM



IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;***************************************************************
;* Purpose:    RIJ128 CFB encryption
;*
;* void EncryptCFB_RIJ128_AES_NI(const Ipp32u* inpBlk,
;*                                     Ipp32u* outBlk,
;*                                     int nr,
;*                               const Ipp32u* pRKey,
;*                                     int cfbBlks,
;*                                     int cfbSize,
;*                               const Ipp8u* pIV)
;***************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsAESEncryptCFB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB_RIJ128_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi,r12,r15
      LOCAL_FRAME = (1+4+4)*16
      USES_XMM
      COMP_ABI 7
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         cfbBlks:      DWORD     ; length of stream in bytes
;; r9d         cfbSize:      DWORD     ; cfb blk size
;; [rsp+ARG_7] pIV       PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      rax, [rsp+ARG_7]           ; IV address
   movdqu   xmm4, oword ptr[rax]       ; get IV
   movdqa   oword ptr [rsp+0*16], xmm4 ; into the stack

   movsxd   r8, r8d                    ; length of stream
   movsxd   r9, r9d                    ; cfb blk size

   mov      r15, rcx                   ; save key material address

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [r15+rax*4-9*(SC)*4]  ; AES-128 round keys

;;
;; processing
;;
   lea      r10, [r9*BLKS_PER_LOOP]    ; 4 cfb block
blks_loop:
   cmp      r8, r10
   cmovl    r10, r8
   COPY_8U <rsp+5*16>, rdi, r10, r11b  ; move 1-4 input blocks to stack

   mov      r12, r10                   ; copy length to be processed
   xor      r11, r11                   ; index
single_blk:
   movdqu   xmm0, oword ptr [rsp+r11]  ; get processing blocks

   pxor     xmm0, oword ptr [r15]      ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[rax-4*4*SC]
   aesenc     xmm0, oword ptr[rax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[rax-2*4*SC]
   aesenc     xmm0, oword ptr[rax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[rax+0*4*SC]
   aesenc     xmm0, oword ptr[rax+1*4*SC]
   aesenc     xmm0, oword ptr[rax+2*4*SC]
   aesenc     xmm0, oword ptr[rax+3*4*SC]
   aesenc     xmm0, oword ptr[rax+4*4*SC]
   aesenc     xmm0, oword ptr[rax+5*4*SC]
   aesenc     xmm0, oword ptr[rax+6*4*SC]
   aesenc     xmm0, oword ptr[rax+7*4*SC]
   aesenc     xmm0, oword ptr[rax+8*4*SC]
   aesenclast xmm0, oword ptr[rax+9*4*SC]

   movdqu      xmm1, oword ptr[rsp+5*16+r11] ; get src blocks from the stack
   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[rsp+1*16+r11],xmm0  ;and store into the stack

   add         r11, r9                       ; advance index
   sub         r12, r9                       ; decrease lenth
   jg          single_blk

   COPY_8U     rsi, <rsp+1*16>, r10, r11b    ; move 1-4 blocks to output

   movdqu      xmm0, oword ptr[rsp+r10]; update IV
   movdqa      oword ptr[rsp], xmm0

   add         rdi, r10
   add         rsi, r10
   sub         r8, r10
   jg          blks_loop

   REST_XMM
   REST_GPR
   ret
IPPASM EncryptCFB_RIJ128_AES_NI ENDP

ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB32_RIJ128_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi,r12,r15
      LOCAL_FRAME = (1+4+4)*16
      USES_XMM
      COMP_ABI 7
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         cfbBlks:      DWORD     ; length of stream in bytes
;; r9d         cfbSize:      DWORD     ; cfb blk size
;; [rsp+ARG_7] pIV       PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      rax, [rsp+ARG_7]           ; IV address
   movdqu   xmm4, oword ptr[rax]       ; get IV
   movdqa   oword ptr [rsp+0*16], xmm4 ; into the stack

   movsxd   r8, r8d                    ; length of stream
   movsxd   r9, r9d                    ; cfb blk size

   mov      r15, rcx                   ; save key material address

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [r15+rax*4-9*(SC)*4]  ; AES-128 round keys

;;
;; processing
;;
   lea      r10, [r9*BLKS_PER_LOOP]    ; 4 cfb block
blks_loop:
   cmp      r8, r10
   cmovl    r10, r8
   COPY_32U <rsp+5*16>, rdi, r10, r11d ; move 1-4 input blocks to stack

   mov      r12, r10                   ; copy length to be processed
   xor      r11, r11                   ; index
single_blk:
   movdqu   xmm0, oword ptr [rsp+r11]  ; get processing blocks

   pxor     xmm0, oword ptr [r15]      ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[rax-4*4*SC]
   aesenc     xmm0, oword ptr[rax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[rax-2*4*SC]
   aesenc     xmm0, oword ptr[rax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[rax+0*4*SC]
   aesenc     xmm0, oword ptr[rax+1*4*SC]
   aesenc     xmm0, oword ptr[rax+2*4*SC]
   aesenc     xmm0, oword ptr[rax+3*4*SC]
   aesenc     xmm0, oword ptr[rax+4*4*SC]
   aesenc     xmm0, oword ptr[rax+5*4*SC]
   aesenc     xmm0, oword ptr[rax+6*4*SC]
   aesenc     xmm0, oword ptr[rax+7*4*SC]
   aesenc     xmm0, oword ptr[rax+8*4*SC]
   aesenclast xmm0, oword ptr[rax+9*4*SC]

   movdqu      xmm1, oword ptr[rsp+5*16+r11] ; get src blocks from the stack
   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[rsp+1*16+r11],xmm0  ;and store into the stack

   add         r11, r9                       ; advance index
   sub         r12, r9                       ; decrease lenth
   jg          single_blk

   COPY_32U    rsi, <rsp+1*16>, r10, r11d    ; move 1-4 blocks to output

   movdqu      xmm0, oword ptr[rsp+r10]; update IV
   movdqa      oword ptr[rsp], xmm0

   add         rdi, r10
   add         rsi, r10
   sub         r8, r10
   jg          blks_loop

   REST_XMM
   REST_GPR
   ret
IPPASM EncryptCFB32_RIJ128_AES_NI ENDP


ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB128_RIJ128_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi
      LOCAL_FRAME = 0
      USES_XMM
      COMP_ABI 6
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         cfbBlks:      DWORD     ; length of stream in bytes
;; r9d         pIV:      PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   movdqu   xmm0, oword ptr[r9]        ; get IV

   movsxd   r8, r8d                    ; length of stream
   movsxd   r9, r9d                    ; cfb blk size

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [rcx+rax*4-9*(SC)*4]  ; AES-128 round keys

;;
;; processing
;;
blks_loop:
   pxor     xmm0, oword ptr [rcx]      ; whitening

   movdqu   xmm1, oword ptr[rdi]       ; input blocks


   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[rax-4*4*SC]
   aesenc     xmm0, oword ptr[rax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[rax-2*4*SC]
   aesenc     xmm0, oword ptr[rax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[rax+0*4*SC]
   aesenc     xmm0, oword ptr[rax+1*4*SC]
   aesenc     xmm0, oword ptr[rax+2*4*SC]
   aesenc     xmm0, oword ptr[rax+3*4*SC]
   aesenc     xmm0, oword ptr[rax+4*4*SC]
   aesenc     xmm0, oword ptr[rax+5*4*SC]
   aesenc     xmm0, oword ptr[rax+6*4*SC]
   aesenc     xmm0, oword ptr[rax+7*4*SC]
   aesenc     xmm0, oword ptr[rax+8*4*SC]
   aesenclast xmm0, oword ptr[rax+9*4*SC]

   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[rsi],xmm0           ;and store into the dst

   add         rdi, 16
   add         rsi, 16
   sub         r8, 16
   jg          blks_loop

   REST_XMM
   REST_GPR
   ret
IPPASM EncryptCFB128_RIJ128_AES_NI ENDP

ENDIF

ENDIF ;; _AES_NI_ENABLING_

END
