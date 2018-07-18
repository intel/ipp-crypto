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
;               Purge block
; 
; 
;

include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;***************************************************************
;* Purpose:     Clear memory block
;*
;* void PurgeBlock(Ipp8u *pDst, int len)
;*
;***************************************************************

;;
;; Lib = M7
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM PurgeBlock PROC PUBLIC FRAME
      USES_GPR  rsi,rdi
      USES_XMM
      COMP_ABI 2
;; rdi:  pDst:  PTR BYTE,    ; mem being clear
;; rsi:  len:      DWORD     ; length

   movsxd   rcx, esi    ; store stream length
   xor      rax, rax
   sub      rcx, sizeof(qword)
   jl       test_purge
purge8:
   mov      qword ptr[rdi], rax  ; clear
   add      rdi, sizeof(qword)
   sub      rcx, sizeof(qword)
   jge      purge8

test_purge:
   add      rcx, sizeof(qword)
   jz       quit
purge1:
   mov      byte ptr[rdi], al
   add      rdi, sizeof(byte)
   sub      rcx, sizeof(byte)
   jg       purge1

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM PurgeBlock ENDP

ENDIF
END
