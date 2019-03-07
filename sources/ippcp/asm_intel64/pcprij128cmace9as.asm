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
include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc
include pcpvariant.inc

IF (_AES_NI_ENABLING_ EQ _FEATURE_ON_) OR (_AES_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_Y8)

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

;;
;; Lib = Y8
;;
;; Caller = ippsAES_CMACUpdate
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM cpAESCMAC_Update_AES_NI PROC PUBLIC FRAME
      USES_GPR rsi, rdi
      LOCAL_FRAME = 0
      USES_XMM
      COMP_ABI 5
;; rdi:     pDigest:  PTR DWORD,    ; input  blocks address
;; rsi:     pInput:   PTR DWORD,    ; output blocks address
;; rdx:     length:       DWORD,    ; lenght in bytes (multiple 16)
;; rcx:     nr:           DWORD     ; number of rounds
;; r8:      pRKey:    PTR DWORD     ; pointer to keys

SC        equ (4)
BYTES_PER_BLK = (16)

   movsxd   rdx, edx                ; input length
   movdqu   xmm0, oword ptr [rdi]   ; digest

ALIGN IPP_ALIGN_FACTOR
;;
;; pseudo-pipelined processing
;;
blks_loop:
   movdqu   xmm1, oword ptr[rsi]       ; input block

   movdqa   xmm4, oword ptr[r8]
   mov      r9, r8                     ; save pointer to the key material

   pxor     xmm0, xmm1                 ; digest ^ src[]

   pxor     xmm0, xmm4                 ; whitening

   movdqa   xmm4, oword ptr[r9+16]
   add      r9, 16

   mov      r10, rcx                   ; counter depending on key length
   sub      r10, 1
  ALIGN IPP_ALIGN_FACTOR
cipher_loop:
   aesenc      xmm0, xmm4             ; regular round
   movdqa      xmm4, oword ptr[r9+16]
   add         r9, 16
   dec         r10
   jnz         cipher_loop
   aesenclast  xmm0, xmm4             ; irregular round

   add         rsi, BYTES_PER_BLK     ; advance pointers
   sub         rdx, BYTES_PER_BLK     ; decrease counter
   jnz         blks_loop

   pxor     xmm4, xmm4
   movdqu   oword ptr[rdi], xmm0     ; store updated digest digest

   REST_XMM
   REST_GPR
   ret
IPPASM cpAESCMAC_Update_AES_NI ENDP
ENDIF

ENDIF ;; _AES_NI_ENABLING_
END
