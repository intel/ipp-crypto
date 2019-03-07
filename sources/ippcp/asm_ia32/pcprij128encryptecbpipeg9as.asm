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
;        EncryptECB_RIJ128pipe_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    pipelined RIJ128 ECB encryption
;*
;* void EncryptECB_RIJ128pipe_AES_NI(const Ipp32u* inpBlk,
;*                                         Ipp32u* outBlk,
;*                                         int nr,
;*                                   const Ipp32u* pRKey,
;*                                         int len)
;***************************************************************

;IF (_IPP GE _IPP_P8) AND (_IPP LT _IPP_G9)
IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128EncryptECB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptECB_RIJ128pipe_AES_NI PROC NEAR C PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR DWORD,\    ; input  block address
pOutBlk:PTR DWORD,\    ; output block address
nr:DWORD,\             ; number of rounds
pKey:PTR DWORD,\       ; key material address
len:DWORD              ; length(byte)

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   mov      esi,pInpBlk       ; input data address
   mov      edi,pOutBlk       ; output data address
   mov      ecx,pKey          ; key material address
   mov      edx,len           ; length

   sub      edx, BYTES_PER_LOOP
   jl       short_input

;;
;; pipelined processing
;;
blks_loop:
   movdqa   xmm4, oword ptr[ecx]    ; keys for whitening
   lea      ebx, [ecx+16]           ; pointer to the round's key material

   movdqu   xmm0, oword ptr[esi+0*BYTES_PER_BLK]  ; get input blocks
   movdqu   xmm1, oword ptr[esi+1*BYTES_PER_BLK]
   movdqu   xmm2, oword ptr[esi+2*BYTES_PER_BLK]
   movdqu   xmm3, oword ptr[esi+3*BYTES_PER_BLK]
   add      esi, BYTES_PER_LOOP

   pxor     xmm0, xmm4                 ; whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr[ebx]      ; pre load round keys
   add      ebx, 16

   mov      eax,nr                     ; number of rounds depending on key length
   sub      eax, 1
cipher_loop:
   aesenc      xmm0, xmm4              ; regular round
   aesenc      xmm1, xmm4
   aesenc      xmm2, xmm4
   aesenc      xmm3, xmm4
   movdqa      xmm4, oword ptr[ebx]
   add         ebx, 16
   dec         eax
   jnz         cipher_loop

   aesenclast  xmm0, xmm4                 ; irregular round
   movdqu      oword ptr[edi+0*BYTES_PER_BLK], xmm0  ; store output blocks
   aesenclast  xmm1, xmm4
   movdqu      oword ptr[edi+1*BYTES_PER_BLK], xmm1
   aesenclast  xmm2, xmm4
   movdqu      oword ptr[edi+2*BYTES_PER_BLK], xmm2
   aesenclast  xmm3, xmm4
   movdqu      oword ptr[edi+3*BYTES_PER_BLK], xmm3

   add         edi, BYTES_PER_LOOP
   sub         edx, BYTES_PER_LOOP
   jge         blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      edx, BYTES_PER_LOOP
   jz       quit

   ; get actual address of key material: pRKeys += (nr-9) * SC
   mov      eax, nr
   lea      ebx,[eax*4]
   lea      ebx,[ecx+ebx*4-9*(SC)*4]   ; AES-128 round keys

single_blk_loop:
   movdqu   xmm0, oword ptr[esi]       ; get input block
   add      esi, BYTES_PER_BLK
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

   movdqu   oword ptr[edi], xmm0    ; save output block
   add      edi, BYTES_PER_BLK

   sub      edx, BYTES_PER_BLK
   jnz      single_blk_loop

quit:
   ret
IPPASM EncryptECB_RIJ128pipe_AES_NI ENDP
ENDIF
END
