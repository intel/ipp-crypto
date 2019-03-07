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
;               Purge block
; 
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
include ia_emm.inc

IF _IPP GE _IPP_W7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;***************************************************************
;* Purpose:     Clear memory block
;*
;* void PurgeBlock(Ipp8u *pDst, int len)
;*
;***************************************************************

;;
;; Lib = W7
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM PurgeBlock PROC NEAR C PUBLIC \
      USES edi,\
      pDst:  PTR DWORD,\    ; target address
      len:       DWORD     ; length

   mov      edi, pDst   ; mem address
   mov      ecx, len    ; length
   xor      eax, eax
   sub      ecx, sizeof(dword)
   jl       test_purge
purge4:
   mov      dword ptr[edi], eax  ; clear
   add      edi, sizeof(dword)
   sub      ecx, sizeof(dword)
   jge      purge4

test_purge:
   add      ecx, sizeof(dword)
   jz       quit
purge1:
   mov      byte ptr[edi], al
   add      edi, sizeof(byte)
   sub      ecx, sizeof(byte)
   jg       purge1

quit:
   ret
IPPASM PurgeBlock ENDP

ENDIF
END
