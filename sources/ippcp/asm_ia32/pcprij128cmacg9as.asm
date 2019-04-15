;===============================================================================
; Copyright 2019 Intel Corporation
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
;        cpAESCMAC_Update_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:    AES-CMAC update
;*
;* void cpAESCMAC_Update_AES_NI(Ipp8u* digest,
;*                       const  Ipp8u* input,
;*                              int    inpLen,
;*                                     int nr,
;*                               const Ipp32u* pRKey)
;***************************************************************

;IF (_IPP GE _IPP_P8) AND (_IPP LT _IPP_G9)
IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsAES_CMACUpdate
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM cpAESCMAC_Update_AES_NI PROC NEAR C PUBLIC \
USES esi edi,\
pDigest:PTR BYTE,\  ; input/output digest
pinpBlk:PTR BYTE,\  ; input blocks
len:DWORD,\         ; length (bytes)
nr:DWORD,\          ; number of rounds
pKey:PTR DWORD      ; key material address

SC        equ (4)
BYTES_PER_BLK = (16)

   mov      edi, pDigest      ; pointer to digest
   mov      esi,pInpBlk       ; input data address
   mov      ecx,pKey          ; key material address
   mov      eax,nr            ; number of rounds

   movdqu   xmm0, oword ptr [edi]   ; digest

   mov      edx, len          ; length of stream

ALIGN IPP_ALIGN_FACTOR
;;
;; block-by-block processing
;;
blks_loop:
   movdqu   xmm1, oword ptr[esi]       ; input block

   movdqa   xmm4, oword ptr[ecx]       ; preload key material

   pxor     xmm0, xmm1                 ; digest ^ src[]

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

   mov         ecx, pKey               ; restore key pointer
   mov         eax, nr                 ; resrore number of rounds

   add         esi, BYTES_PER_BLK      ; advance pointers
   sub         edx, BYTES_PER_BLK      ; decrease counter
   jnz         blks_loop

   pxor        xmm4, xmm4
   movdqu      oword ptr[edi], xmm0    ; store output block

   ret
IPPASM cpAESCMAC_Update_AES_NI ENDP
ENDIF
END
