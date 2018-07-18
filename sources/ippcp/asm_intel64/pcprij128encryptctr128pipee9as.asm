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
;               Rijndael Cipher function
; 
;     Content:
;        EncryptCTR_RIJ128pipe_AES_NI()
; 
;
include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    pipelined RIJ128 CTR128 encryption/decryption
;*
;*
;* void EncryptStreamCTR32_AES_NI(const Ipp8u* inpBlk,
;*                                      Ipp8u* outBlk,
;*                                      int nr,
;*                                const Ipp8u* pRKey,
;*                                      int length,
;*                                      Ipp8u* pIV)
;***************************************************************
AES_BLOCK     = (16)

ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptStreamCTR32_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx
      LOCAL_FRAME = sizeof(oword)*8
      USES_XMM xmm6,xmm7,xmm8,xmm9
      COMP_ABI 6
;; rdi:        pInpBlk:     PTR BYTE   ; pointer to the input
;; rsi:        pOutBlk:     PTR BYTE   ; pointer to the output
;; rdx:        nr:              DWORD  ; number of rounds
;; rcx         pKey:        PTR BYTE   ; key material address
;; r8d         length:          DWORD  ; length of the input
;; r9          pIV    :     PTR BYTE   ; pointer to the iv (BE string counter representation)

SC        equ (4)

   movdqu   xmm0, oword ptr[r9]        ; input IV
   movsxd   r8, r8d                    ; length

   lea      r11, [r8+AES_BLOCK-1]      ; r11 = blocks = ceil(len/AES_BLOCK)
   shr      r11, 4

   mov      rax, qword ptr[r9+sizeof(qword)] ; input IV
   mov      rbx, qword ptr[r9]
   bswap    rax
   bswap    rbx
   mov      r10d, eax         ; save ctr32
   add      rax, r11                         ; +blocks
   adc      rbx, 0
   bswap    rax
   bswap    rbx
   mov      qword ptr[r9+sizeof(qword)], rax ; update IV
   mov      qword ptr[r9], rbx

   mov      r11d, dword ptr[rcx+AES_BLOCK-sizeof(dword)] ; get whitening keys corresponding to ctr32

   pxor     xmm0, oword ptr[rcx]       ; apply whitening keys
   add      rcx, AES_BLOCK             ; mov pointer to the round keys
   movdqa   oword ptr[rsp+0*AES_BLOCK], xmm0 ; store unchanged part of ctr128
   movdqa   oword ptr[rsp+1*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+2*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+3*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+4*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+5*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+6*AES_BLOCK], xmm0
   movdqa   oword ptr[rsp+7*AES_BLOCK], xmm0

   mov      r9, rsp
   cmp      r8, AES_BLOCK              ; test if single block processed
   jle      short123_input

   movdqa   xmm1, xmm0
   movdqa   xmm2, xmm0
   movdqa   xmm3, xmm0
   lea      ebx, [r10d+1]                    ; init ctr32+1
   lea      eax, [r10d+2]                    ; init ctr32+2
   lea      r9d, [r10d+3]                    ; init ctr32+3
   bswap    ebx
   bswap    eax
   bswap    r9d
   xor      ebx, r11d
   pinsrd   xmm1, ebx, 3
   xor      eax, r11d
   pinsrd   xmm2, eax, 3
   xor      r9d,  r11d
   pinsrd   xmm3, r9d, 3

   movdqa   oword ptr[rsp+1*AES_BLOCK], xmm1
   movdqa   oword ptr[rsp+2*AES_BLOCK], xmm2
   movdqa   oword ptr[rsp+3*AES_BLOCK], xmm3

   mov      r9, rsp

   movdqa   xmm4, oword ptr[rcx+0*AES_BLOCK] ; pre load operation's keys
   movdqa   xmm5, oword ptr[rcx+1*AES_BLOCK]

   cmp      r8, (4*AES_BLOCK)                ; test if 1-2-3 blocks processed
   jl       short123_input
   jz       short_input

   lea      eax, [r10d+4]                    ; init ctr32+4
   lea      ebx, [r10d+5]                    ; init ctr32+5
   bswap    eax
   bswap    ebx
   xor      ebx, r11d
   xor      eax, r11d
   mov      dword ptr[rsp+4*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   mov      dword ptr[rsp+5*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx

   lea      eax, [r10d+6]                    ; init ctr32+6
   lea      ebx, [r10d+7]                    ; init ctr32+7
   bswap    eax
   bswap    ebx
   xor      eax, r11d
   xor      ebx, r11d
   mov      dword ptr[rsp+6*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   mov      dword ptr[rsp+7*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx

   cmp      r8, (8*AES_BLOCK)
   jl       short_input

;;
;; 8-blocks processing alaivalbe
;;
   sub      rsp, sizeof(oword)*4    ; save xmm registers
   movdqa   oword ptr [rsp+0*sizeof(oword)], xmm10
   movdqa   oword ptr [rsp+1*sizeof(oword)], xmm11
   movdqa   oword ptr [rsp+2*sizeof(oword)], xmm12
   movdqa   oword ptr [rsp+3*sizeof(oword)], xmm13

   push     rcx         ; store pointer to the key material
   push     rdx         ; store number of rounds
   sub      r8, (8*AES_BLOCK)

ALIGN IPP_ALIGN_FACTOR
blk8_loop:
;  movdqa   xmm4, oword ptr[rcx+0*AES_BLOCK] ; pre load operation's keys
;  movdqa   xmm5, oword ptr[rcx+1*AES_BLOCK]
   add      rcx, (2*AES_BLOCK)

   add      r10d, 8     ; next counter value
   sub      rdx, 4      ; rounds -= 4

   movdqa   xmm6, oword ptr[r9+4*AES_BLOCK]  ; load current ctr32
   movdqa   xmm7, oword ptr[r9+5*AES_BLOCK]
   movdqa   xmm8, oword ptr[r9+6*AES_BLOCK]
   movdqa   xmm9, oword ptr[r9+7*AES_BLOCK]

      mov      eax, r10d                     ; improve next 2 ctr32 values in advance
   aesenc   xmm0, xmm4
      lea      ebx, [r10d+1]
   aesenc   xmm1, xmm4
      bswap    eax
   aesenc   xmm2, xmm4
      bswap    ebx
   aesenc   xmm3, xmm4
      xor      eax, r11d
   aesenc   xmm6, xmm4
      xor      ebx, r11d
   aesenc   xmm7, xmm4
      mov      dword ptr[r9+0*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   aesenc   xmm8, xmm4
      mov      dword ptr[r9+1*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx
   aesenc   xmm9, xmm4
   movdqa   xmm4, oword ptr[rcx]          ; pre load operation's keys

      lea      eax, [r10d+2]              ; improve next 2 ctr32 values in advance
   aesenc   xmm0, xmm5
      lea      ebx, [r10d+3]
   aesenc   xmm1, xmm5
      bswap    eax
   aesenc   xmm2, xmm5
      bswap    ebx
   aesenc   xmm3, xmm5
      xor      eax, r11d
   aesenc   xmm6, xmm5
      xor      ebx, r11d
   aesenc   xmm7, xmm5
      mov      dword ptr[r9+2*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   aesenc   xmm8, xmm5
      mov      dword ptr[r9+3*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx
   aesenc   xmm9, xmm5
   movdqa   xmm5, oword ptr [rcx+AES_BLOCK]  ; pre load operation's keys

ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   add      rcx, (2*AES_BLOCK)
   sub      rdx, 2

   aesenc   xmm0, xmm4
   aesenc   xmm1, xmm4
   aesenc   xmm2, xmm4
   aesenc   xmm3, xmm4
   aesenc   xmm6, xmm4
   aesenc   xmm7, xmm4
   aesenc   xmm8, xmm4
   aesenc   xmm9, xmm4
   movdqa   xmm4, oword ptr[rcx]             ; pre load operation's keys

   aesenc   xmm0, xmm5
   aesenc   xmm1, xmm5
   aesenc   xmm2, xmm5
   aesenc   xmm3, xmm5
   aesenc   xmm6, xmm5
   aesenc   xmm7, xmm5
   aesenc   xmm8, xmm5
   aesenc   xmm9, xmm5
   movdqa   xmm5, oword ptr [rcx+AES_BLOCK]  ; pre load operation's keys
   jnz      cipher_loop

      lea      eax, [r10d+4]                 ; improve next 2 ctr32 values in advance
   aesenc   xmm0, xmm4
      lea      ebx, [r10d+5]
   aesenc   xmm1, xmm4
      bswap    eax
   aesenc   xmm2, xmm4
      bswap    ebx
   aesenc   xmm3, xmm4
      xor      eax, r11d
   aesenc   xmm6, xmm4
      xor      ebx, r11d
   aesenc   xmm7, xmm4
      mov      dword ptr[r9+4*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   aesenc   xmm8, xmm4
      mov      dword ptr[r9+5*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx
   aesenc   xmm9, xmm4

      lea      eax, [r10d+6]                 ; improve next 2 ctr32 values in advance
   aesenclast xmm0, xmm5
      lea      ebx, [r10d+7]
   aesenclast xmm1, xmm5
      bswap    eax
   aesenclast xmm2, xmm5
      bswap    ebx
   aesenclast xmm3, xmm5
      xor      eax, r11d
   aesenclast xmm6, xmm5
      xor      ebx, r11d
   aesenclast xmm7, xmm5
      mov      dword ptr[r9+6*AES_BLOCK+AES_BLOCK-sizeof(dword)], eax
   aesenclast xmm8, xmm5
      mov      dword ptr[r9+7*AES_BLOCK+AES_BLOCK-sizeof(dword)], ebx
   aesenclast xmm9, xmm5

   movdqu   xmm10, oword ptr[rdi+0*AES_BLOCK]
   movdqu   xmm11, oword ptr[rdi+1*AES_BLOCK]
   movdqu   xmm12, oword ptr[rdi+2*AES_BLOCK]
   movdqu   xmm13, oword ptr[rdi+3*AES_BLOCK]
   pxor     xmm0, xmm10
   pxor     xmm1, xmm11
   pxor     xmm2, xmm12
   pxor     xmm3, xmm13
   movdqu   oword ptr[rsi+0*AES_BLOCK], xmm0
   movdqu   oword ptr[rsi+1*AES_BLOCK], xmm1
   movdqu   oword ptr[rsi+2*AES_BLOCK], xmm2
   movdqu   oword ptr[rsi+3*AES_BLOCK], xmm3
   movdqu   xmm10, oword ptr[rdi+4*AES_BLOCK]
   movdqu   xmm11, oword ptr[rdi+5*AES_BLOCK]
   movdqu   xmm12, oword ptr[rdi+6*AES_BLOCK]
   movdqu   xmm13, oword ptr[rdi+7*AES_BLOCK]
   pxor     xmm6, xmm10
   pxor     xmm7, xmm11
   pxor     xmm8, xmm12
   pxor     xmm9, xmm13
   movdqu   oword ptr[rsi+4*AES_BLOCK], xmm6
   movdqu   oword ptr[rsi+5*AES_BLOCK], xmm7
   movdqu   oword ptr[rsi+6*AES_BLOCK], xmm8
   movdqu   oword ptr[rsi+7*AES_BLOCK], xmm9

   mov      rcx, qword ptr[rsp+sizeof(qword)]   ; restore pointer to the key material
   mov      rdx, qword ptr[rsp]                 ; restore number of rounds

   movdqa   xmm0, oword ptr[r9+0*AES_BLOCK]  ; load next current ctr32
   movdqa   xmm1, oword ptr[r9+1*AES_BLOCK]
   movdqa   xmm2, oword ptr[r9+2*AES_BLOCK]
   movdqa   xmm3, oword ptr[r9+3*AES_BLOCK]

   movdqa   xmm4, oword ptr[rcx+0*AES_BLOCK] ; pre load operation's keys
   movdqa   xmm5, oword ptr[rcx+1*AES_BLOCK] ; pre load operation's keys

   add      rdi, 8*AES_BLOCK
   add      rsi, 8*AES_BLOCK
   sub      r8,  8*AES_BLOCK
   jge      blk8_loop

   pop      rdx
   pop      rcx

   movdqa   xmm10,oword ptr [rsp+0*sizeof(oword)]  ; resrore xmm registers
   movdqa   xmm11,oword ptr [rsp+1*sizeof(oword)]
   movdqa   xmm12,oword ptr [rsp+2*sizeof(oword)]
   movdqa   xmm13,oword ptr [rsp+3*sizeof(oword)]
   add      rsp, sizeof(oword)*4                   ; release stack

   add      r8, 8*AES_BLOCK
   jz       quit

ALIGN IPP_ALIGN_FACTOR
short_input:
;;
;; test if 4-blocks processing alaivalbe
;;
   cmp      r8, (4*AES_BLOCK)
   jl       short123_input

   mov      rbx, rcx                ; pointer to the key material
   lea      r10, [rdx-2]            ; rounds -= 2

ALIGN IPP_ALIGN_FACTOR
cipher_loop4:
   add      rbx, (2*AES_BLOCK)
   sub      r10, 2

   aesenc   xmm0, xmm4           ; regular round
   aesenc   xmm1, xmm4
   aesenc   xmm2, xmm4
   aesenc   xmm3, xmm4
   movdqa   xmm4, oword ptr[rbx] ; pre load operation's keys

   aesenc   xmm0, xmm5
   aesenc   xmm1, xmm5
   aesenc   xmm2, xmm5
   aesenc   xmm3, xmm5
   movdqa   xmm5, oword ptr [rbx+AES_BLOCK]  ; pre load operation's keys
   jnz      cipher_loop4

   movdqu   xmm6, oword ptr[rdi+0*AES_BLOCK]
   movdqu   xmm7, oword ptr[rdi+1*AES_BLOCK]
   movdqu   xmm8, oword ptr[rdi+2*AES_BLOCK]
   movdqu   xmm9, oword ptr[rdi+3*AES_BLOCK]
   add      rdi, (4*AES_BLOCK)

   aesenc   xmm0, xmm4
   aesenc   xmm1, xmm4
   aesenc   xmm2, xmm4
   aesenc   xmm3, xmm4

   aesenclast xmm0, xmm5
   aesenclast xmm1, xmm5
   aesenclast xmm2, xmm5
   aesenclast xmm3, xmm5

   pxor     xmm0, xmm6
   movdqu   oword ptr[rsi+0*AES_BLOCK], xmm0
   pxor     xmm1, xmm7
   movdqu   oword ptr[rsi+1*AES_BLOCK], xmm1
   pxor     xmm2, xmm8
   movdqu   oword ptr[rsi+2*AES_BLOCK], xmm2
   pxor     xmm3, xmm9
   movdqu   oword ptr[rsi+3*AES_BLOCK], xmm3
   add      rsi, (4*AES_BLOCK)

   add      r9, (4*AES_BLOCK)

   sub      r8, (4*AES_BLOCK)
   jz       quit

;;
;; block-by-block processing
;;
short123_input:
   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rbx,[rdx*4]
   lea      rbx, [rcx+rbx*4-10*(SC)*4]  ; AES-128 round keys

single_blk:
   movdqa   xmm0, oword ptr[r9]  ; counter from the stack
   add      r9, AES_BLOCK

   cmp      rdx,12               ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

key_256_s:
   aesenc      xmm0,oword ptr[rbx-4*4*SC]
   aesenc      xmm0,oword ptr[rbx-3*4*SC]
key_192_s:
   aesenc      xmm0,oword ptr[rbx-2*4*SC]
   aesenc      xmm0,oword ptr[rbx-1*4*SC]
key_128_s:
   aesenc      xmm0,oword ptr[rbx+0*4*SC]
   aesenc      xmm0,oword ptr[rbx+1*4*SC]
   aesenc      xmm0,oword ptr[rbx+2*4*SC]
   aesenc      xmm0,oword ptr[rbx+3*4*SC]
   aesenc      xmm0,oword ptr[rbx+4*4*SC]
   aesenc      xmm0,oword ptr[rbx+5*4*SC]
   aesenc      xmm0,oword ptr[rbx+6*4*SC]
   aesenc      xmm0,oword ptr[rbx+7*4*SC]
   aesenc      xmm0,oword ptr[rbx+8*4*SC]
   aesenclast  xmm0,oword ptr[rbx+9*4*SC]

   cmp         r8, AES_BLOCK              ; test if partial bloak
   jl          partial_block

   movdqu      xmm1, oword ptr[rdi] ; input data block
   add         rdi, AES_BLOCK
   pxor        xmm0, xmm1           ; output block
   movdqu      oword ptr[rsi], xmm0 ; save output block
   add         rsi, AES_BLOCK

   sub         r8, AES_BLOCK
   jz          quit
   jmp         single_blk

partial_block:
   pextrb      eax, xmm0, 0
   psrldq      xmm0, 1
   movzx       edx, byte ptr[rdi]
   inc         rdi
   xor         rax, rdx
   mov         byte ptr[rsi], al
   inc         rsi
   dec         r8
   jnz         partial_block

quit:
   pxor  xmm4, xmm4
   pxor  xmm5, xmm5

   REST_XMM
   REST_GPR
   ret
IPPASM EncryptStreamCTR32_AES_NI ENDP

ENDIF ;; _IPP32E_Y8
ENDIF ;; _AES_NI_ENABLING_

END
