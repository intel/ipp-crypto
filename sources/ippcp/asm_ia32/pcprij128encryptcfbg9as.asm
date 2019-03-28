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

include asmdefs.inc
include ia_emm.inc


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

COPY_32U MACRO  dst, src, limit, tmp
LOCAL next_dword
   xor   ecx, ecx
next_dword:
   mov   tmp, dword ptr[src+ecx]
   mov   dword ptr[dst+ecx], tmp
   add   ecx, 4
   cmp   ecx, limit
   jl    next_dword
ENDM

COPY_128U MACRO  dst, src, limit, tmp
LOCAL next_oword
   xor   ecx, ecx
next_oword:
   movdqu   tmp, oword ptr[src+ecx]
   movdqu   oword ptr[dst+ecx], tmp
   add   ecx, 16
   cmp   ecx, limit
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
;*                                     int len,
;*                                     int cfbSize,
;*                               const Ipp8u* pIV)
;***************************************************************

IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128EncryptCFB
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB_RIJ128_AES_NI PROC NEAR PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR DWORD,\    ; input  blocks address
pOutBlk:PTR DWORD,\    ; output blocks address
nr:DWORD,\             ; number of rounds
pKey:PTR DWORD,\       ; key material address
len:DWORD,\            ; length of stream in bytes
cfbSize:DWORD,\        ; cfb blk size
pIV:PTR BYTE           ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   sub      esp,16*(1+4+4)    ; allocate stask:
                              ; +0*16  IV
                              ; +1*16  inp0, inp1, inp2, inp3
                              ; +5*16  out0, out1, out2, out3

   mov      eax, pIV                   ; IV address
   movdqu   xmm4, oword ptr[eax]       ; get IV
   movdqu   oword ptr [esp+0*16], xmm4 ; into the stack

;;
;; processing
;;
blks_loop:
   mov      esi,pInpBlk                ; input data address

   mov      edx,cfbSize                ; size of block
   lea      ebx, [edx*BLKS_PER_LOOP]   ; 4 cfb block
   mov      edx, len
   cmp      edx, ebx
   cmovl    ebx, edx
   COPY_8U <esp+5*16>, esi, ebx, dl    ; move 1-4 input blocks to stack

   ; get actual address of key material: pRKeys += (nr-9) * SC
   mov      ecx, pKey
   mov      edx, nr
   lea      eax,[edx*4]
   lea      eax, [ecx+eax*4-9*(SC)*4]  ; AES-128 round keys

   xor      esi, esi                   ; index
   mov      edi, ebx
single_blk:
   movdqu   xmm0, oword ptr [esp+esi]  ; get processing blocks

   pxor     xmm0, oword ptr [ecx]      ; whitening

   cmp      edx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[eax-4*4*SC]
   aesenc     xmm0, oword ptr[eax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[eax-2*4*SC]
   aesenc     xmm0, oword ptr[eax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[eax+0*4*SC]
   aesenc     xmm0, oword ptr[eax+1*4*SC]
   aesenc     xmm0, oword ptr[eax+2*4*SC]
   aesenc     xmm0, oword ptr[eax+3*4*SC]
   aesenc     xmm0, oword ptr[eax+4*4*SC]
   aesenc     xmm0, oword ptr[eax+5*4*SC]
   aesenc     xmm0, oword ptr[eax+6*4*SC]
   aesenc     xmm0, oword ptr[eax+7*4*SC]
   aesenc     xmm0, oword ptr[eax+8*4*SC]
   aesenclast xmm0, oword ptr[eax+9*4*SC]

   movdqu      xmm1, oword ptr[esp+5*16+esi] ; get src blocks from the stack
   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[esp+1*16+esi],xmm0  ;and store into the stack

   add         esi, cfbSize                  ; advance index
   sub         edi, cfbSize                  ; decrease lenth
   jg          single_blk

   mov         edi,pOutBlk                   ; output data address
   COPY_8U     edi, <esp+1*16>, ebx, dl      ; move 1-4 blocks to output

   movdqu      xmm0, oword ptr[esp+ebx]; update IV
   movdqu      oword ptr[esp], xmm0

   add         pInpBlk, ebx
   add         pOutBlk, ebx
   sub         len, ebx
   jg          blks_loop

   add         esp, 16*(1+4+4)
   ret
IPPASM EncryptCFB_RIJ128_AES_NI ENDP

ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB32_RIJ128_AES_NI PROC NEAR PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR DWORD,\ ; input  blocks address
pOutBlk:PTR DWORD,\ ; output blocks address
nr:DWORD,\          ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\         ; length of stream in bytes
cfbSize:DWORD,\     ; cfb blk size
pIV:PTR BYTE        ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   sub      esp,16*(1+4+4)    ; allocate stask:
                              ; +0*16  IV
                              ; +1*16  inp0, inp1, inp2, inp3
                              ; +5*16  out0, out1, out2, out3

   mov      eax, pIV                   ; IV address
   movdqu   xmm4, oword ptr[eax]       ; get IV
   movdqu   oword ptr [esp+0*16], xmm4 ; into the stack

;;
;; processing
;;
blks_loop:
   mov      esi,pInpBlk                ; input data address

   mov      edx,cfbSize                ; size of block
   lea      ebx, [edx*BLKS_PER_LOOP]   ; 4 cfb block
   mov      edx, len
   cmp      edx, ebx
   cmovl    ebx, edx
   COPY_32U <esp+5*16>, esi, ebx, edx  ; move 1-4 input blocks to stack

   ; get actual address of key material: pRKeys += (nr-9) * SC
   mov      ecx, pKey
   mov      edx, nr
   lea      eax,[edx*4]
   lea      eax, [ecx+eax*4-9*(SC)*4]  ; AES-128 round keys

   xor      esi, esi                   ; index
   mov      edi, ebx
single_blk:
   movdqu   xmm0, oword ptr [esp+esi]  ; get processing blocks

   pxor     xmm0, oword ptr [ecx]      ; whitening

   cmp      edx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[eax-4*4*SC]
   aesenc     xmm0, oword ptr[eax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[eax-2*4*SC]
   aesenc     xmm0, oword ptr[eax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[eax+0*4*SC]
   aesenc     xmm0, oword ptr[eax+1*4*SC]
   aesenc     xmm0, oword ptr[eax+2*4*SC]
   aesenc     xmm0, oword ptr[eax+3*4*SC]
   aesenc     xmm0, oword ptr[eax+4*4*SC]
   aesenc     xmm0, oword ptr[eax+5*4*SC]
   aesenc     xmm0, oword ptr[eax+6*4*SC]
   aesenc     xmm0, oword ptr[eax+7*4*SC]
   aesenc     xmm0, oword ptr[eax+8*4*SC]
   aesenclast xmm0, oword ptr[eax+9*4*SC]

   movdqu      xmm1, oword ptr[esp+5*16+esi] ; get src blocks from the stack
   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[esp+1*16+esi],xmm0  ;and store into the stack

   add         esi, cfbSize                  ; advance index
   sub         edi, cfbSize                  ; decrease lenth
   jg          single_blk

   mov         edi,pOutBlk                   ; output data address
   COPY_32U    edi, <esp+1*16>, ebx, edx     ; move 1-4 blocks to output

   movdqu      xmm0, oword ptr[esp+ebx]      ; update IV
   movdqu      oword ptr[esp], xmm0

   add         pInpBlk, ebx
   add         pOutBlk, ebx
   sub         len, ebx
   jg          blks_loop

   add         esp, 16*(1+4+4)
   ret
IPPASM EncryptCFB32_RIJ128_AES_NI ENDP


ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCFB128_RIJ128_AES_NI PROC NEAR PUBLIC \
USES esi edi ebx,\
pInpBlk:PTR DWORD,\    ; input  blocks address
pOutBlk:PTR DWORD,\    ; output blocks address
nr:DWORD,\    ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\    ; length of stream in bytes
pIV:PTR BYTE     ; pointer to the IV

SC        equ (4)
BLKS_PER_LOOP = (4)

   mov      eax, pIV                   ; IV address
   movdqu   xmm0, oword ptr[eax]       ; get IV

   mov      esi,pInpBlk                ; input data address
   mov      edi,pOutBlk                ; output data address
   mov      ebx, len

   ; get actual address of key material: pRKeys += (nr-9) * SC
   mov      ecx, pKey
   mov      edx, nr
   lea      eax,[edx*4]
   lea      eax, [ecx+eax*4-9*(SC)*4]  ; AES-128 round keys


;;
;; processing
;;
blks_loop:
   pxor     xmm0, oword ptr [ecx]      ; whitening

   movdqu   xmm1, oword ptr[esi]       ; input blocks


   cmp      edx,12                     ; switch according to number of rounds
   jl       key_128_s
   jz       key_192_s
                                       ; do encryption
key_256_s:
   aesenc     xmm0, oword ptr[eax-4*4*SC]
   aesenc     xmm0, oword ptr[eax-3*4*SC]
key_192_s:
   aesenc     xmm0, oword ptr[eax-2*4*SC]
   aesenc     xmm0, oword ptr[eax-1*4*SC]
key_128_s:
   aesenc     xmm0, oword ptr[eax+0*4*SC]
   aesenc     xmm0, oword ptr[eax+1*4*SC]
   aesenc     xmm0, oword ptr[eax+2*4*SC]
   aesenc     xmm0, oword ptr[eax+3*4*SC]
   aesenc     xmm0, oword ptr[eax+4*4*SC]
   aesenc     xmm0, oword ptr[eax+5*4*SC]
   aesenc     xmm0, oword ptr[eax+6*4*SC]
   aesenc     xmm0, oword ptr[eax+7*4*SC]
   aesenc     xmm0, oword ptr[eax+8*4*SC]
   aesenclast xmm0, oword ptr[eax+9*4*SC]

   pxor        xmm0, xmm1                    ; xor src
   movdqu      oword ptr[edi],xmm0           ;and store into the dst

   add         esi, 16
   add         edi, 16
   sub         ebx, 16
   jg          blks_loop

   ret
IPPASM EncryptCFB128_RIJ128_AES_NI ENDP

ENDIF

END

