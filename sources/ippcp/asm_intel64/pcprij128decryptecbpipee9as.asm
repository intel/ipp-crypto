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
;        DecryptECB_RIJ128pipe_AES_NI()
; 
;
include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    pipelined RIJ128 ECB decryption
;*
;* void DecryptECB_RIJ128pipe_AES_NI(const Ipp32u* inpBlk,
;*                                         Ipp32u* outBlk,
;*                                         int nr,
;*                                   const Ipp32u* pRKey,
;*                                         int len)
;***************************************************************

;;
;; Lib = Y8
;;
;; Caller = ippsAESDecryptECB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptECB_RIJ128pipe_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi, rdi
      LOCAL_FRAME = 0
      USES_XMM
      COMP_ABI 5
;; rdi:     pInpBlk:  PTR DWORD,    ; input  blocks address
;; rsi:     pOutBlk:  PTR DWORD,    ; output blocks address
;; rdx:     nr:           DWORD,    ; number of rounds
;; rcx      pKey:     PTR DWORD     ; key material address
;; r8d      length:       DWORD     ; length (bytes)

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   lea      rax,[rdx*SC]               ; keys offset

   movsxd   r8, r8d
   sub      r8, BYTES_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
;ALIGN IPP_ALIGN_FACTOR
blks_loop:
   lea      r9,[rcx+rax*4]             ; set pointer to the key material
   movdqa   xmm4, oword ptr [r9]       ; keys for whitening
   sub      r9, 16

   movdqu   xmm0, oword ptr[rdi+0*BYTES_PER_BLK]  ; get input blocks
   movdqu   xmm1, oword ptr[rdi+1*BYTES_PER_BLK]
   movdqu   xmm2, oword ptr[rdi+2*BYTES_PER_BLK]
   movdqu   xmm3, oword ptr[rdi+3*BYTES_PER_BLK]
   add      rdi, BYTES_PER_LOOP

   pxor     xmm0, xmm4                 ; whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr [r9]       ; pre load operation's keys
   sub      r9, 16

   mov      r10, rdx                   ; counter depending on key length
   sub      r10, 1
;ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   aesdec      xmm0, xmm4              ; regular round
   aesdec      xmm1, xmm4
   aesdec      xmm2, xmm4
   aesdec      xmm3, xmm4
   movdqa      xmm4, oword ptr [r9]    ; pre load operation's keys
   sub         r9, 16
   dec         r10
   jnz         cipher_loop

   aesdeclast  xmm0, xmm4                 ; irregular round
   movdqu      oword ptr[rsi+0*BYTES_PER_BLK], xmm0  ; store output blocks

   aesdeclast  xmm1, xmm4
   movdqu      oword ptr[rsi+1*BYTES_PER_BLK], xmm1

   aesdeclast  xmm2, xmm4
   movdqu      oword ptr[rsi+2*BYTES_PER_BLK], xmm2

   aesdeclast  xmm3, xmm4
   movdqu      oword ptr[rsi+3*BYTES_PER_BLK], xmm3

   add         rsi, BYTES_PER_LOOP
   sub         r8, BYTES_PER_LOOP
   jge         blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      r8, BYTES_PER_LOOP
   jz       quit

   lea      r9,[rcx+rax*4]             ; set pointer to the key material
ALIGN IPP_ALIGN_FACTOR
single_blk_loop:
   movdqu   xmm0, oword ptr[rdi]       ; get input block
   add      rdi,  BYTES_PER_BLK
   pxor     xmm0, oword ptr [r9]       ; whitening

   cmp      rdx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

key_256_s:
   aesdec      xmm0, oword ptr[rcx+9*SC*4+4*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4+3*SC*4]
key_192_s:
   aesdec      xmm0, oword ptr[rcx+9*SC*4+2*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4+1*SC*4]
key_128_s:
   aesdec      xmm0, oword ptr[rcx+9*SC*4-0*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-1*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-2*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-3*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-4*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-5*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-6*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-7*SC*4]
   aesdec      xmm0, oword ptr[rcx+9*SC*4-8*SC*4]
   aesdeclast  xmm0, oword ptr[rcx+9*SC*4-9*SC*4]

   movdqu      oword ptr[rsi], xmm0    ; save output block
   add         rsi, BYTES_PER_BLK

   sub         r8, BYTES_PER_BLK
   jnz         single_blk_loop

quit:
   pxor  xmm4, xmm4

   REST_XMM
   REST_GPR
   ret
IPPASM DecryptECB_RIJ128pipe_AES_NI ENDP
ENDIF

ENDIF ;; _AES_NI_ENABLING_
END
