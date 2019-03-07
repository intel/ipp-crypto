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
;        Encrypt_RIJ128_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc


COPY_8U MACRO  dst, src, limit, tmp
LOCAL next_byte
   xor   ecx, ecx
next_byte:
   mov   tmp, byte ptr[src+ecx]
   mov   byte ptr[dst+ecx], tmp
   add   ecx, 1
   cmp   ecx, limit
   jl    next_byte
ENDM



IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    RIJ128 OFB encryption
;*
;* void EncryptOFB_RIJ128_AES_NI(const Ipp32u* inpBlk,
;*                                     Ipp32u* outBlk,
;*                                     int nr,
;*                               const Ipp32u* pRKey,
;*                                     int length,
;*                                     int ofbBlks,
;*                               const Ipp8u* pIV)
;***************************************************************

IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128DecryptOFB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptOFB_RIJ128_AES_NI PROC NEAR C PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR BYTE,\  ; input  block address
pOutBlk:PTR BYTE,\  ; output block address
nr:DWORD,\          ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\         ; length of stream in bytes
ofbSize:DWORD,\     ; ofb blk size
pIV:PTR BYTE        ; IV

SC        equ (4)
BLKS_PER_LOOP = (4)

tmpInp   equ   esp
tmpOut   equ   tmpInp+sizeof(oword)
locDst   equ   tmpOut+sizeof(oword)
locSrc   equ   locDst+sizeof(oword)*4
locLen   equ   locSrc+sizeof(oword)*4
stackLen equ   sizeof(oword)+sizeof(oword)+sizeof(oword)*4+sizeof(oword)*4+sizeof(dword)

   sub      esp,stackLen   ; allocate stack

   mov      eax, pIV                   ; get IV
   movdqu   xmm0, oword ptr[eax]       ;
   movdqu   oword ptr [tmpInp], xmm0   ; and save into the stack

   mov      eax, nr                    ; number of rounds
   mov      ecx, pKey                  ; key material address
   lea      eax, [eax*4]               ; nr*16 offset (bytes) to end of key material
   lea      eax, [eax*4]
   lea      ecx, [ecx+eax]
   neg      eax                        ; save -nr*16
   mov      nr, eax
   mov      pKey, ecx                  ; save key material address

   mov      esi, pInpBlk               ; input stream
   mov      edi, pOutBlk               ; output stream
   mov      ebx, ofbSize               ; cfb blk size

  ALIGN IPP_ALIGN_FACTOR
;;
;; processing
;;
blks_loop:
   lea      ebx, [ebx*BLKS_PER_LOOP]   ; 4 cfb block

   cmp      len, ebx
   cmovl    ebx, len
   COPY_8U  <locSrc>, esi, ebx, dl     ; move 1-4 input blocks to stack

   mov      ecx, pKey
   mov      eax, nr

   mov      dword ptr[locLen], ebx
   xor      edx, edx                   ; index

  ALIGN IPP_ALIGN_FACTOR
single_blk:
   movdqa   xmm3, oword ptr[ecx+eax]   ; preload key material
   add      eax, 16

   movdqa   xmm4, oword ptr[ecx+eax]   ; preload next key material
   pxor     xmm0, xmm3                 ; whitening

ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   add         eax, 16
   aesenc      xmm0, xmm4                 ; regular round
   movdqa      xmm4, oword ptr[ecx+eax]
   jnz         cipher_loop
   aesenclast  xmm0, xmm4                 ; irregular round
   movdqu      oword ptr[tmpOut], xmm0    ; save chipher output

   mov         eax, ofbSize                  ; cfb blk size

   movdqu      xmm1, oword ptr[locSrc+edx]   ; get src blocks from the stack
   pxor        xmm1, xmm0                    ; xor src
   movdqu      oword ptr[locDst+edx],xmm1    ;and store into the stack

   movdqu      xmm0, oword ptr[tmpInp+eax]   ; update chiper input (IV)
   movdqu      oword ptr[tmpInp], xmm0

   add         edx, eax                      ; advance index
   mov         eax, nr
   cmp         edx, ebx
   jl          single_blk

   COPY_8U     edi, <locDst>, edx, bl     ; move 1-4 blocks to output

   mov         ebx, ofbSize               ; restore cfb blk size
   add         esi, edx                   ; advance pointers
   add         edi, edx
   sub         len, edx                   ; decrease stream counter
   jg          blks_loop

   mov      eax, pIV                   ; IV address
   movdqu   xmm0, oword ptr[tmpInp]    ; update IV before return
   movdqu   oword ptr[eax], xmm0

   add      esp,stackLen   ; remove local variables
   ret
IPPASM EncryptOFB_RIJ128_AES_NI ENDP


ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptOFB128_RIJ128_AES_NI PROC NEAR C PUBLIC \
USES esi edi,\
pInpBlk:PTR BYTE,\  ; input  block address
pOutBlk:PTR BYTE,\  ; output block address
nr:DWORD,\          ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\         ; length of stream in bytes
pIV:PTR BYTE        ; IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      eax, pIV                   ; get IV
   movdqu   xmm0, oword ptr[eax]       ;

   mov      eax, nr                    ; number of rounds
   mov      ecx, pKey                  ; key material address
   lea      eax, [eax*4]               ; nr*16 offset (bytes) to end of key material
   lea      eax, [eax*4]
   lea      ecx, [ecx+eax]
   neg      eax                        ; save -nr*16
   mov      nr, eax

   mov      esi, pInpBlk               ; input stream
   mov      edi, pOutBlk               ; output stream
   mov      edx, len                   ; length of stream

  ALIGN IPP_ALIGN_FACTOR
;;
;; processing
;;
blks_loop:
   movdqa   xmm3, oword ptr[ecx+eax]   ; preload key material
   add      eax, 16

  ALIGN IPP_ALIGN_FACTOR
single_blk:
   movdqa   xmm4, oword ptr[ecx+eax]   ; preload next key material
   pxor     xmm0, xmm3                 ; whitening

   movdqu      xmm1, oword ptr[esi]    ; input block

ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   add         eax, 16
   aesenc      xmm0, xmm4              ; regular round
   movdqa      xmm4, oword ptr[ecx+eax]
   jnz         cipher_loop
   aesenclast  xmm0, xmm4              ; irregular round

   pxor        xmm1, xmm0              ; xor src
   movdqu      oword ptr[edi],xmm1     ; and store into the dst

   mov         eax, nr                 ; restore key material counter
   add         esi, 16                 ; advance pointers
   add         edi, 16
   sub         edx, 16                 ; decrease stream counter
   jg          blks_loop

   mov      eax, pIV                   ; get IV address
   movdqu   oword ptr[eax], xmm0       ; update IV before return

   ret
IPPASM EncryptOFB128_RIJ128_AES_NI ENDP

ENDIF

END

