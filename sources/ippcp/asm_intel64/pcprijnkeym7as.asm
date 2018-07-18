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
;               Rijndael Key Expansion Support
; 
;     Content:
;        SubsDword_8uT()
; 
;
include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

CACHE_LINE_SIZE   equ (64)

;***************************************************************
;* Purpose:    Mitigation of the Key Expansion procedure
;*
;* Ipp32u Touch_SubsDword_8uT(Ipp32u inp,
;*                      const Ipp8u* pTbl,
;*                            int tblBytes)
;***************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM Touch_SubsDword_8uT PROC PUBLIC FRAME
      USES_GPR rsi, rdi
      USES_XMM
      COMP_ABI 3
;; rdi:     inp:      DWORD,     ; input dword
;; rsi:     pTbl: PTR BYTE,      ; Rijndael's S-box
;; edx      tblLen:   DWORD      ; length of table (bytes)

   movsxd   r8, edx              ; length
   xor      rcx, rcx
touch_tbl:
   mov      rax, [rsi+rcx]
   add      rcx, CACHE_LINE_SIZE
   cmp      rcx, r8
   jl       touch_tbl

   mov      rax, rdi
   and      rax, 0FFh         ; b[0]
   movzx    rax, BYTE PTR[rsi+rax]

   shr      rdi, 8
   mov      r9, rdi
   and      r9, 0FFh          ; b[1]
   movzx    r9, BYTE PTR[rsi+r9]
   shl      r9, 8

   shr      rdi, 8
   mov      rcx, rdi
   and      rcx, 0FFh         ; b[2]
   movzx    rcx, BYTE PTR[rsi+rcx]
   shl      rcx, 16

   shr      rdi, 8
   mov      rdx, rdi
   and      rdx, 0FFh         ; b[3]
   movzx    rdx, BYTE PTR[rsi+rdx]
   shl      rdx, 24

   or       rax, r9
   or       rax, rcx
   or       rax, rdx
   REST_XMM
   REST_GPR
   ret
IPPASM Touch_SubsDword_8uT ENDP

ENDIF
END
