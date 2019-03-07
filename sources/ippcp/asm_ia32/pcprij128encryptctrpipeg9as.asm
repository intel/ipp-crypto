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
;               Rijndael Cipher function
; 
;     Content:
;        EncryptCTR_RIJ128pipe_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


ALIGN IPP_ALIGN_FACTOR
CONST_TABLE:
u128_str DB 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0


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

;***************************************************************
;* Purpose:    pipelined RIJ128 CTR encryption/decryption
;*
;* void EncryptCTR_RIJ128pipe_AES_NI(const Ipp32u* inpBlk,
;*                                         Ipp32u* outBlk,
;*                                         int nr,
;*                                   const Ipp32u* pRKey,
;*                                         int length,
;*                                         Ipp8u* pCtrValue,
;*                                         Ipp8u* pCtrBitMask)
;***************************************************************

;IF (_IPP GE _IPP_P8) AND (_IPP LT _IPP_G9)
IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128EncryptCTR
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCTR_RIJ128pipe_AES_NI PROC NEAR C PUBLIC \
USES  esi edi ebx,\
pInpBlk:PTR DWORD,\    ; input  block address
pOutBlk:PTR DWORD,\    ; output block address
nr:DWORD,\             ; number of rounds
pKey:PTR DWORD,\       ; key material address
len:DWORD,\            ; number of blocks being processed
pCtrValue:PTR DWORD,\  ; pointer to the Counter
pCtrBitMask:PTR BYTE   ; pointer to the Counter Bit Mask

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   mov      esi, pCtrBitMask
   mov      edi, pCtrValue
   movdqu   xmm6, oword ptr[esi]       ; counter bit mask
   movdqu   xmm1, oword ptr[edi]       ; initial counter
   movdqu   xmm5, xmm6                 ; counter bit mask
   pandn    xmm6, xmm1                 ; counter template

   sub      esp, (4*4)                 ; allocate stack

   LD_ADDR  eax, CONST_TABLE           ; load bswap conversion tbl
   movdqa   xmm4, oword ptr [eax+(u128_str - CONST_TABLE)]

   ;;
   ;; init counter
   ;;
   mov      edx, dword ptr[edi]
   mov      ecx, dword ptr[edi+4]
   mov      ebx, dword ptr[edi+8]
   mov      eax, dword ptr[edi+12]
   bswap    edx
   bswap    ecx
   bswap    ebx
   bswap    eax

   mov      dword ptr [esp], eax       ; store counter
   mov      dword ptr [esp+4], ebx
   mov      dword ptr [esp+8], ecx
   mov      dword ptr [esp+12], edx

   mov      esi,pInpBlk       ; input data address
   mov      edi,pOutBlk       ; output data address

   sub      len, BYTES_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
blks_loop:
   mov      eax, dword ptr[esp]        ; get coutnter value
   mov      ebx, dword ptr[esp+4]
   mov      ecx, dword ptr[esp+8]
   mov      edx, dword ptr[esp+12]

   pinsrd   xmm0, eax, 0               ; set counter value
   pinsrd   xmm0, ebx, 1
   pinsrd   xmm0, ecx, 2
   pinsrd   xmm0, edx, 3
   pshufb   xmm0, xmm4                 ; convert int the octet string
   pand     xmm0, xmm5                 ; select counter bits
   por      xmm0, xmm6                 ; add unchanged bits

   add      eax, 1                     ; increment counter
   adc      ebx, 0
   adc      ecx, 0
   adc      edx, 0
   pinsrd   xmm1, eax, 0               ; set counter value
   pinsrd   xmm1, ebx, 1
   pinsrd   xmm1, ecx, 2
   pinsrd   xmm1, edx, 3
   pshufb   xmm1, xmm4                 ; convert int the octet string
   pand     xmm1, xmm5                 ; select counter bits
   por      xmm1, xmm6                 ; add unchanged bits

   add      eax, 1                     ; increment counter
   adc      ebx, 0
   adc      ecx, 0
   adc      edx, 0
   pinsrd   xmm2, eax, 0               ; set counter value
   pinsrd   xmm2, ebx, 1
   pinsrd   xmm2, ecx, 2
   pinsrd   xmm2, edx, 3
   pshufb   xmm2, xmm4                 ; convert int the octet string
   pand     xmm2, xmm5                 ; select counter bits
   por      xmm2, xmm6                 ; add unchanged bits

   add      eax, 1                     ; increment counter
   adc      ebx, 0
   adc      ecx, 0
   adc      edx, 0
   pinsrd   xmm3, eax, 0               ; set counter value
   pinsrd   xmm3, ebx, 1
   pinsrd   xmm3, ecx, 2
   pinsrd   xmm3, edx, 3
   pshufb   xmm3, xmm4                 ; convert int the octet string
   pand     xmm3, xmm5                 ; select counter bits
   por      xmm3, xmm6                 ; add unchanged bits

   add      eax, 1                     ; increment counter
   adc      ebx, 0
   adc      ecx, 0
   adc      edx, 0
   mov      dword ptr[esp], eax        ; and store for next itteration
   mov      dword ptr[esp+4], ebx
   mov      dword ptr[esp+8], ecx
   mov      dword ptr[esp+12], edx

   mov      ecx, pKey                  ; get key material address
   movdqa   xmm7, oword ptr[ecx]
   lea      ebx, [ecx+16]              ; pointer to the round's key material

   pxor     xmm0, xmm7                 ; whitening
   pxor     xmm1, xmm7
   pxor     xmm2, xmm7
   pxor     xmm3, xmm7

   movdqa   xmm7, oword ptr[ebx]       ; pre load round keys
   add      ebx, 16

   mov      eax, nr                    ; counter depending on key length
   sub      eax, 1
cipher_loop:
   aesenc      xmm0, xmm7              ; regular round
   aesenc      xmm1, xmm7
   aesenc      xmm2, xmm7
   aesenc      xmm3, xmm7
   movdqa      xmm7, oword ptr[ebx]
   add         ebx, 16
   dec         eax
   jnz         cipher_loop

   aesenclast  xmm0, xmm7              ; irregular round
   aesenclast  xmm1, xmm7
   aesenclast  xmm2, xmm7
   aesenclast  xmm3, xmm7

   movdqu      xmm7, oword ptr[esi+0*BYTES_PER_BLK]  ; xor input blocks
   pxor        xmm0, xmm7
   movdqu      oword ptr[edi+0*BYTES_PER_BLK], xmm0

   movdqu      xmm7, oword ptr[esi+1*BYTES_PER_BLK]
   pxor        xmm1, xmm7
   movdqu      oword ptr[edi+1*BYTES_PER_BLK], xmm1

   movdqu      xmm7, oword ptr[esi+2*BYTES_PER_BLK]
   pxor        xmm2, xmm7
   movdqu      oword ptr[edi+2*BYTES_PER_BLK], xmm2

   movdqu      xmm7, oword ptr[esi+3*BYTES_PER_BLK]
   pxor        xmm3, xmm7
   movdqu      oword ptr[edi+3*BYTES_PER_BLK], xmm3

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

   mov      ecx,pKey          ; key material address

   ; get actual address of key material: pRKeys += (nr-9) * SC
   mov      eax, nr
   lea      ebx,[eax*4]
   lea      ebx,[ecx+ebx*4-9*(SC)*4]  ; AES-128 round keys

single_blk_loop:
   movdqu   xmm0, oword ptr[esp]       ; get counter value
   pshufb   xmm0, xmm4                 ; convert int the octet string
   pand     xmm0, xmm5                 ; select counter bits
   por      xmm0, xmm6                 ; add unchanged bits

   pxor     xmm0, oword ptr[ecx]       ; whitening

   cmp      eax,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s

key_256_s:
   aesenc      xmm0,oword ptr[ebx-4*4*SC]
   aesenc      xmm0,oword ptr[ebx-3*4*SC]
key_192_s:
   aesenc      xmm0,oword ptr[ebx-2*4*SC]
   aesenc      xmm0,oword ptr[ebx-1*4*SC]
key_128_s:
   aesenc      xmm0,oword ptr[ebx+0*4*SC]
   aesenc      xmm0,oword ptr[ebx+1*4*SC]
   aesenc      xmm0,oword ptr[ebx+2*4*SC]
   aesenc      xmm0,oword ptr[ebx+3*4*SC]
   aesenc      xmm0,oword ptr[ebx+4*4*SC]
   aesenc      xmm0,oword ptr[ebx+5*4*SC]
   aesenc      xmm0,oword ptr[ebx+6*4*SC]
   aesenc      xmm0,oword ptr[ebx+7*4*SC]
   aesenc      xmm0,oword ptr[ebx+8*4*SC]
   aesenclast  xmm0,oword ptr[ebx+9*4*SC]

   add         dword ptr[esp], 1       ; advance counter value
   adc         dword ptr[esp+4], 0
   adc         dword ptr[esp+8], 0
   adc         dword ptr[esp+12], 0

   sub         len, BYTES_PER_BLK
   jl          partial_block

   movdqu      xmm1, oword ptr[esi]    ; input block
   add         esi, BYTES_PER_BLK
   pxor        xmm0, xmm1              ; output block
   movdqu      oword ptr[edi], xmm0    ; save output block
   add         edi, BYTES_PER_BLK

   cmp         len, 0
   jz          quit
   jmp         single_blk_loop

partial_block:
   add         len, BYTES_PER_BLK

partial_block_loop:
   pextrb      eax, xmm0, 0
   psrldq      xmm0, 1
   movzx       ebx, byte ptr[esi]
   xor         eax, ebx
   mov         byte ptr[edi], al
   inc         esi
   inc         edi
   dec         len
   jnz         partial_block_loop

quit:
   mov         eax, pCtrValue
   movdqu      xmm0, oword ptr[esp]       ; get counter value
   pshufb      xmm0, xmm4                 ; convert int the octet string
   pand        xmm0, xmm5                 ; select counter bits
   por         xmm0, xmm6                 ; add unchanged bits
   movdqu      oword ptr[eax], xmm0       ; return updated counter

   add      esp, (4*4)                    ; free stack
   ret
IPPASM EncryptCTR_RIJ128pipe_AES_NI ENDP
ENDIF
END
