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
;               Rijndael Inverse Cipher function
; 
;     Content:
;        Decrypt_RIJ128_AES_NI()
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
;* Purpose:    pipelined RIJ128 CFB decryption
;*
;* void DecryptCFB_RIJ128pipe_AES_NI(const Ipp32u* inpBlk,
;*                                         Ipp32u* outBlk,
;*                                         int nr,
;*                                   const Ipp32u* pRKey,
;*                                         int cfbBlks,
;*                                         int cfbSize,
;*                                   const Ipp8u* pIV)
;***************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsRijndael128DecryptCFB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptCFB_RIJ128pipe_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi,r13,r14,r15
      LOCAL_FRAME = (1+4+4)*16
      USES_XMM    xmm6,xmm7
      COMP_ABI 7
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         cfbBlks:      DWORD     ; length of stream in cfbSize
;; r9d         cfbSize:      DWORD     ; cfb blk size
;; [rsp+ARG_7] pIV       PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      rax, [rsp+ARG_7]           ; IV address
   movdqu   xmm4, oword ptr[rax]       ; get IV
   movdqa   oword ptr [rsp+0*16], xmm4 ; into the stack

   mov      r13, rdi
   mov      r14, rsi
   mov      r15, rcx

   movsxd   r8, r8d                    ; length of stream
   movsxd   r9, r9d                    ; cfb blk size

   sub      r8, BLKS_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
   lea      r10, [r9*BLKS_PER_LOOP]
blks_loop:
   COPY_32U <rsp+16>, r13, r10, r11d   ; move 4 input blocks to stack

   movdqa   xmm4, oword ptr[r15]

   lea      r10, [r9+r9*2]
   movdqa   xmm0, oword ptr [rsp]      ; get encoded blocks
   movdqu   xmm1, oword ptr [rsp+r9]
   movdqu   xmm2, oword ptr [rsp+r9*2]
   movdqu   xmm3, oword ptr [rsp+r10]

   mov      r10, r15                   ; set pointer to the key material

   pxor     xmm0, xmm4                 ; whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr[r10+16]    ; pre load operation's keys
   add      r10, 16

   mov      r11, rdx                   ; counter depending on key length
   sub      r11, 1
cipher_loop:
   aesenc      xmm0, xmm4              ; regular round
   aesenc      xmm1, xmm4
   aesenc      xmm2, xmm4
   aesenc      xmm3, xmm4
   movdqa      xmm4, oword ptr [r10+16]; pre load operation's keys
   add         r10, 16
   dec         r11
   jnz         cipher_loop

   aesenclast  xmm0, xmm4              ; irregular round and IV
   aesenclast  xmm1, xmm4
   aesenclast  xmm2, xmm4
   aesenclast  xmm3, xmm4

   lea         r10, [r9+r9*2]          ; get src blocks from the stack
   movdqa      xmm4, oword ptr[rsp+16]
   movdqu      xmm5, oword ptr[rsp+16+r9]
   movdqu      xmm6, oword ptr[rsp+16+r9*2]
   movdqu      xmm7, oword ptr[rsp+16+r10]

   pxor        xmm0, xmm4              ; xor src
   movdqa      oword ptr[rsp+5*16],xmm0;and store into the stack
   pxor        xmm1, xmm5
   movdqu      oword ptr[rsp+5*16+r9], xmm1
   pxor        xmm2, xmm6
   movdqu      oword ptr[rsp+5*16+r9*2], xmm2
   pxor        xmm3, xmm7
   movdqu      oword ptr[rsp+5*16+r10], xmm3

   lea         r10, [r9*BLKS_PER_LOOP]
  ;COPY_8U     r14, <rsp+5*16>, r10    ; move 4 blocks to output
   COPY_32U    r14, <rsp+5*16>, r10, r11d ; move 4 blocks to output

   movdqu      xmm0, oword ptr[rsp+r10]; update IV
   movdqu      oword ptr[rsp], xmm0

   add         r13, r10
   add         r14, r10
   sub         r8, BLKS_PER_LOOP
   jge         blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      r8, BLKS_PER_LOOP
   jz       quit

   lea      r10, [r9*2]
   lea      r11, [r9+r9*2]
   cmp      r8, 2
   cmovl    r10, r9
   cmovg    r10, r11
   COPY_8U  <rsp+16>, r13, r10, al     ; move recent input blocks to stack

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [r15+rax*4-9*(SC)*4]  ; AES-128 round keys

   xor      r11, r11                   ; index
single_blk_loop:
   movdqu   xmm0, oword ptr[rsp+r11]   ; get encoded block

   pxor     xmm0, oword ptr [r15]      ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

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

   movdqu   xmm1, oword ptr[rsp+r11+16]   ; get input block from the stack
   pxor     xmm0, xmm1                    ; xor src
   movdqu   oword ptr[rsp+5*16+r11], xmm0 ; and save output

   add      r11, r9
   dec      r8
   jnz      single_blk_loop

   COPY_8U  r14, <rsp+5*16>, r10, al     ; copy rest output from the stack

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM DecryptCFB_RIJ128pipe_AES_NI ENDP

ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptCFB32_RIJ128pipe_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi,r13,r14,r15
      LOCAL_FRAME = (1+4+4)*16
      USES_XMM    xmm6,xmm7
      COMP_ABI 7
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         cfbBlks:      DWORD     ; length of stream in cfbSize
;; r9d         cfbSize:      DWORD     ; cfb blk size (4 bytes multible)
;; [rsp+ARG_7] pIV       PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      rax, [rsp+ARG_7]           ; IV address
   movdqu   xmm4, oword ptr[rax]       ; get IV
   movdqa   oword ptr [rsp+0*16], xmm4 ; into the stack

   mov      r13, rdi
   mov      r14, rsi
   mov      r15, rcx

   movsxd   r8, r8d                    ; length of stream
   movsxd   r9, r9d                    ; cfb blk size

   sub      r8, BLKS_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
   lea      r10, [r9*BLKS_PER_LOOP]
blks_loop:
   COPY_128U <rsp+16>, r13, r10, xmm0  ; move 4 input blocks to stack

   movdqa   xmm4, oword ptr[r15]

   lea      r10, [r9+r9*2]
   movdqa   xmm0, oword ptr [rsp]      ; get encoded blocks
   movdqu   xmm1, oword ptr [rsp+r9]
   movdqu   xmm2, oword ptr [rsp+r9*2]
   movdqu   xmm3, oword ptr [rsp+r10]

   mov      r10, r15                   ; set pointer to the key material

   pxor     xmm0, xmm4                 ; whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr[r10+16]    ; pre load operation's keys
   add      r10, 16

   mov      r11, rdx                   ; counter depending on key length
   sub      r11, 1
cipher_loop:
   aesenc      xmm0, xmm4              ; regular round
   aesenc      xmm1, xmm4
   aesenc      xmm2, xmm4
   aesenc      xmm3, xmm4
   movdqa      xmm4, oword ptr [r10+16]; pre load operation's keys
   add         r10, 16
   dec         r11
   jnz         cipher_loop

   aesenclast  xmm0, xmm4              ; irregular round and IV
   aesenclast  xmm1, xmm4
   aesenclast  xmm2, xmm4
   aesenclast  xmm3, xmm4

   lea         r10, [r9+r9*2]          ; get src blocks from the stack
   movdqa      xmm4, oword ptr[rsp+16]
   movdqu      xmm5, oword ptr[rsp+16+r9]
   movdqu      xmm6, oword ptr[rsp+16+r9*2]
   movdqu      xmm7, oword ptr[rsp+16+r10]

   pxor        xmm0, xmm4              ; xor src
   movdqa      oword ptr[rsp+5*16],xmm0;and store into the stack
   pxor        xmm1, xmm5
   movdqu      oword ptr[rsp+5*16+r9], xmm1
   pxor        xmm2, xmm6
   movdqu      oword ptr[rsp+5*16+r9*2], xmm2
   pxor        xmm3, xmm7
   movdqu      oword ptr[rsp+5*16+r10], xmm3

   lea         r10, [r9*BLKS_PER_LOOP]
   COPY_128U   r14, <rsp+5*16>, r10, xmm0 ; move 4 blocks to output

   movdqu      xmm0, oword ptr[rsp+r10]   ; update IV
   movdqu      oword ptr[rsp], xmm0

   add         r13, r10
   add         r14, r10
   sub         r8, BLKS_PER_LOOP
   jge         blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      r8, BLKS_PER_LOOP
   jz       quit

   lea      r10, [r9*2]
   lea      r11, [r9+r9*2]
   cmp      r8, 2
   cmovl    r10, r9
   cmovg    r10, r11
   COPY_32U <rsp+16>, r13, r10, eax    ; move recent input blocks to stack

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [r15+rax*4-9*(SC)*4]  ; AES-128 round keys

   xor      r11, r11                   ; index
single_blk_loop:
   movdqu   xmm0, oword ptr[rsp+r11]   ; get encoded block

   pxor     xmm0, oword ptr [r15]      ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

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

   movdqu   xmm1, oword ptr[rsp+r11+16]   ; get input block from the stack
   pxor     xmm0, xmm1                    ; xor src
   movdqu   oword ptr[rsp+5*16+r11], xmm0 ; and save output

   add      r11, r9
   dec      r8
   jnz      single_blk_loop

   COPY_32U r14, <rsp+5*16>, r10, eax    ; copy rest output from the stack

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM DecryptCFB32_RIJ128pipe_AES_NI ENDP


;;
;; Lib = Y8
;;
;; Caller = ippsRijndael128DecryptCFB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptCFB128_RIJ128pipe_AES_NI PROC PUBLIC FRAME
      USES_GPR    rsi,rdi
      LOCAL_FRAME = 0
      USES_XMM    xmm6,xmm7
      COMP_ABI 6
;; rdi:        pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:        pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:        nr:           DWORD,    ; number of rounds
;; rcx         pKey:     PTR DWORD     ; key material address
;; r8d         lenBytes:     DWORD     ; length of stream in bytes
;; r9          pIV       PTR BYTE      ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   movdqu   xmm0, oword ptr[r9]        ; get IV

   movsxd   r8, r8d                    ; length of the stream
   sub      r8, BYTES_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
blks_loop:
   movdqa   xmm7, oword ptr[rcx]       ; get initial key material
   mov      r10, rcx                   ; set pointer to the key material

   movdqu   xmm1, oword ptr [rdi+0*BYTES_PER_BLK] ; get another encoded cblocks
   movdqu   xmm2, oword ptr [rdi+1*BYTES_PER_BLK]
   movdqu   xmm3, oword ptr [rdi+2*BYTES_PER_BLK]

   pxor     xmm0, xmm7                 ; whitening
   pxor     xmm1, xmm7
   pxor     xmm2, xmm7
   pxor     xmm3, xmm7

   movdqa   xmm7, oword ptr[r10+16]    ; pre load operation's keys
   add      r10, 16

   mov      r11, rdx                      ; counter depending on key length
   sub      r11, 1
cipher_loop:
   aesenc      xmm0, xmm7                 ; regular round
   aesenc      xmm1, xmm7
   aesenc      xmm2, xmm7
   aesenc      xmm3, xmm7
   movdqa      xmm7, oword ptr [r10+16]   ; pre load operation's keys
   add         r10, 16
   dec         r11
   jnz         cipher_loop

   aesenclast  xmm0, xmm7                 ; irregular round and IV
   movdqu      xmm4, oword ptr[rdi+0*BYTES_PER_BLK]  ; 4 input blocks
   aesenclast  xmm1, xmm7
   movdqu      xmm5, oword ptr[rdi+1*BYTES_PER_BLK]
   aesenclast  xmm2, xmm7
   movdqu      xmm6, oword ptr[rdi+2*BYTES_PER_BLK]
   aesenclast  xmm3, xmm7
   movdqu      xmm7, oword ptr[rdi+3*BYTES_PER_BLK]
   add         rdi, BYTES_PER_LOOP

   pxor     xmm0, xmm4                 ; 4 output blocks
   movdqu   oword ptr[rsi+0*16], xmm0
   pxor     xmm1, xmm5
   movdqu   oword ptr[rsi+1*16], xmm1
   pxor     xmm2, xmm6
   movdqu   oword ptr[rsi+2*16], xmm2
   pxor     xmm3, xmm7
   movdqu   oword ptr[rsi+3*16], xmm3
   add      rsi, BYTES_PER_LOOP

   movdqa   xmm0, xmm7                 ; update IV
   sub      r8, BYTES_PER_LOOP
   jge      blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      r8, BYTES_PER_LOOP
   jz       quit

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      rax,[rdx*4]
   lea      rax, [rcx+rax*4-9*(SC)*4]  ; AES-128 round keys

single_blk_loop:
   pxor     xmm0, oword ptr [rcx]      ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

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

   movdqu      xmm1, oword ptr[rdi]       ; input block from the stream
   add         rdi, BYTES_PER_BLK
   pxor        xmm0, xmm1                 ; xor src
   movdqu      oword ptr[rsi], xmm0       ; and save output
   add         rsi, BYTES_PER_BLK

   movdqa      xmm0, xmm1                 ; update IV
   sub         r8, BYTES_PER_BLK
   jnz         single_blk_loop

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM DecryptCFB128_RIJ128pipe_AES_NI ENDP
ENDIF

ENDIF ;; _AES_NI_ENABLING_
END
