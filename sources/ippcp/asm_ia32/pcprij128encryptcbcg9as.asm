;===============================================================================
; Copyright 2014-2018 Intel Corporation
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
;        EncryptCBC_RIJ128pipe_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    RIJ128 CBC encryption
;*
;* void EncryptCBC_RIJ128_AES_NI(const Ipp32u* inpBlk,
;*                                     Ipp32u* outBlk,
;*                                     int nr,
;*                                const Ipp32u* pRKey,
;*                                      int len,
;*                                const Ipp8u* pIV)
;***************************************************************

;IF (_IPP GE _IPP_P8) AND (_IPP LT _IPP_G9)
IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128EncryptCBC
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM EncryptCBC_RIJ128_AES_NI PROC NEAR C PUBLIC \
USES esi edi,\
pInpBlk:PTR BYTE,\  ; input  block address
pOutBlk:PTR BYTE,\  ; output block address
nr:DWORD,\          ; number of rounds
pKey:PTR DWORD,\    ; key material address
len:DWORD,\         ; length (bytes)
pIV:PTR BYTE        ; IV

SC        equ (4)
BYTES_PER_BLK = (16)

   mov      edx, pIV          ; IV address
   mov      esi,pInpBlk       ; input data address
   mov      ecx,pKey          ; key material address
   mov      eax,nr            ; number of rounds
   mov      edi,pOutBlk       ; output data address

   movdqu   xmm0, oword ptr [edx]   ; IV

   mov      edx, len          ; length of stream

ALIGN IPP_ALIGN_FACTOR
;;
;; block-by-block processing
;;
blks_loop:
   movdqu   xmm1, oword ptr[esi]       ; input block

   movdqa   xmm4, oword ptr[ecx]       ; preload key material

   pxor     xmm0, xmm1                 ; src[] ^ iv

   pxor     xmm0, xmm4                 ; whitening

   movdqa   xmm4, oword ptr[ecx+16]    ; preload key material
   add      ecx, 16

   sub      eax, 1                     ; counter depending on key length
  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   aesenc      xmm0, xmm4              ; regular round
   movdqa      xmm4, oword ptr[ecx+16]
   add         ecx, 16
   sub         eax, 1
   jnz         cipher_loop
   aesenclast  xmm0, xmm4              ; irregular round

   movdqu      oword ptr[edi], xmm0    ; store output block

   mov         ecx, pKey               ; restore key pointer
   mov         eax, nr                 ; resrore number of rounds

   add         esi, BYTES_PER_BLK      ; advance pointers
   add         edi, BYTES_PER_BLK
   sub         edx, BYTES_PER_BLK      ; decrease counter
   jnz         blks_loop

   ret
IPPASM EncryptCBC_RIJ128_AES_NI ENDP
ENDIF
END
