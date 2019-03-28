;===============================================================================
; Copyright 2014-2019 Intel Corporation
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
;        DecryptCBC_RIJ128pipe_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

include asmdefs.inc
INCLUDE ia_emm.inc

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    pipelined RIJ128 CBC decryption
;*
;* void DecryptCBC_RIJ128pipe_AES_NI(const Ipp32u* inpBlk,
;*                                         Ipp32u* outBlk,
;*                                         int nr,
;*                                   const Ipp32u* pRKey,
;*                                         int len,
;*                                   const Ipp8u* pIV)
;***************************************************************

;IF (_IPP GE _IPP_P8) AND (_IPP LT _IPP_G9)
IF (_IPP GE _IPP_P8)
;;
;; Lib = G9
;;
;; Caller = ippsRijndael128DecryptCBC
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM DecryptCBC_RIJ128pipe_AES_NI PROC NEAR C PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR DWORD,\    ; input  block address
pOutBlk:PTR DWORD,\    ; output block address
nr:DWORD,\    ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\    ; length(byte)
pIV:PTR DWORD\     ; IV

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   mov      esi,pInpBlk       ; input data address
   mov      edi,pOutBlk       ; output data address
   mov      ecx,pKey          ; key material address
   mov      eax,nr            ; number of rounds

   sub      esp, 16*(1+4+1)   ; allocate stack
   lea      edx, [esp+16]
   and      edx, -16

   mov      ebx, pIV
   movdqu   xmm4, oword ptr [ebx]      ; save IV
   movdqa   oword ptr [edx+0*16], xmm4 ; into the stack

   sub      len, BYTES_PER_LOOP
   jl       short_input

   lea      ebx,[eax*SC]      ; keys offset
   lea      ecx,[ecx+ebx*4]
;;
;; pipelined processing
;;
blks_loop:
   movdqa   xmm4, oword ptr [ecx]      ; keys for whitening
   lea      ebx, [ecx-16]              ; set pointer to the round's key material

   movdqu   xmm0, oword ptr[esi+0*BYTES_PER_BLK]   ; get input blocks
   movdqu   xmm1, oword ptr[esi+1*BYTES_PER_BLK]
   movdqu   xmm2, oword ptr[esi+2*BYTES_PER_BLK]
   movdqu   xmm3, oword ptr[esi+3*BYTES_PER_BLK]
   movdqa   oword ptr [edx+1*16], xmm0             ; and save as IVx
   movdqa   oword ptr [edx+2*16], xmm1             ; for next operations
   movdqa   oword ptr [edx+3*16], xmm2             ; into the stack
   movdqa   oword ptr [edx+4*16], xmm3

   pxor     xmm0, xmm4                 ;whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr [ebx]      ; pre load operation's keys
   sub      ebx, 16

   mov      eax, nr                    ; counter depending on key length
   sub      eax, 1
cipher_loop:
   aesdec      xmm0, xmm4              ; regular round
   aesdec      xmm1, xmm4
   aesdec      xmm2, xmm4
   aesdec      xmm3, xmm4
   movdqa      xmm4, oword ptr [ebx]   ; pre load operation's keys
   sub         ebx, 16
   dec         eax
   jnz         cipher_loop

   aesdeclast  xmm0, xmm4                 ; irregular round and IV
   pxor        xmm0, oword ptr[edx+0*16]  ; xor with IV
   movdqu      oword ptr[edi+0*16], xmm0  ; and store output blocls

   aesdeclast  xmm1, xmm4
   pxor        xmm1, oword ptr[edx+1*16]
   movdqu      oword ptr[edi+1*16], xmm1

   aesdeclast  xmm2, xmm4
   pxor        xmm2, oword ptr[edx+2*16]
   movdqu      oword ptr[edi+2*16], xmm2

   aesdeclast  xmm3, xmm4
   pxor        xmm3, oword ptr[edx+3*16]
   movdqu      oword ptr[edi+3*16], xmm3

   movdqa      xmm4, oword ptr[edx+4*16]     ; update IV
   movdqa      oword ptr[edx+0*16], xmm4

   add         esi, BYTES_PER_LOOP
   add         edi, BYTES_PER_LOOP
   sub         len, BYTES_PER_LOOP
   jge         blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      len, BYTES_PER_LOOP
   jz       quit

   mov      eax, nr
   mov      ecx, pKey
   lea      ebx,[eax*SC]               ; set pointer to the key material
   lea      ebx,[ecx+ebx*4]

single_blk_loop:
   movdqu   xmm0, oword ptr[esi]       ; get input block
   movdqa   oword ptr[edx+16], xmm0    ; and save as IV for future
   pxor     xmm0, oword ptr [ebx]      ; whitening

   cmp      eax,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

key_256_s:
   aesdec      xmm0, oword ptr[ecx+9*SC*4+4*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4+3*SC*4]
key_192_s:
   aesdec      xmm0, oword ptr[ecx+9*SC*4+2*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4+1*SC*4]
key_128_s:
   aesdec      xmm0, oword ptr[ecx+9*SC*4-0*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-1*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-2*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-3*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-4*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-5*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-6*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-7*SC*4]
   aesdec      xmm0, oword ptr[ecx+9*SC*4-8*SC*4]
   aesdeclast  xmm0, oword ptr[ecx+9*SC*4-9*SC*4]

   pxor        xmm0, oword ptr[edx+0*16]  ; add IV
   movdqu      oword ptr[edi], xmm0       ; and save output blocl

   movdqa      xmm4, oword ptr[edx+1*16]  ; update IV
   movdqa      oword ptr[edx+0*16], xmm4

   add         esi, BYTES_PER_BLK
   add         edi, BYTES_PER_BLK
   sub         len, BYTES_PER_BLK
   jnz         single_blk_loop

quit:
   add      esp, 16*(1+4+1)   ; free stack
   ret
IPPASM DecryptCBC_RIJ128pipe_AES_NI ENDP
ENDIF
END
