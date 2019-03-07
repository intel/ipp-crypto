;===============================================================================
; Copyright 2015-2019 Intel Corporation
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
; 
;     Content:
;        cpAddAdd_BNU()
;

.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
include pcpvariant.inc

IF _ENABLE_KARATSUBA_

IF _IPP GE _IPP_W7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


ALIGN IPP_ALIGN_FACTOR
IPPASM cpAddAdd_BNU PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pDst:  PTR DWORD,\    ; target address
      pSrcA: PTR DWORD,\    ; source address (A)
      pSrcB: PTR DWORD,\    ; source address (B)
      pSrcC: PTR DWORD,\    ; source address (C)
      len:       DWORD     ; length of BNU

   mov   eax,pSrcA   ; srcA
   mov   ebx,pSrcB   ; srcB
   mov   ecx,pSrcC   ; srcC
   mov   edi,pDst    ; dst
   mov   esi,len     ; length
   shl   esi,2

   lea   eax, [eax+esi]
   lea   ebx, [ebx+esi]
   lea   ecx, [ecx+esi]
   lea   edi, [edi+esi]
   neg   esi

   pandn mm0,mm0

ALIGN IPP_ALIGN_FACTOR
main_loop:
   movd     mm1,DWORD PTR[eax + esi]
   movd     mm2,DWORD PTR[ebx + esi]
   movd     mm3,DWORD PTR[ecx + esi]

   paddq    mm0,mm1
   paddq    mm0,mm2
   paddq    mm0,mm3
   movd     DWORD PTR[edi + esi],mm0
   pshufw   mm0,mm0,11111110b

   add      esi,4
   jnz      main_loop

   movd     eax,mm0
   emms
   ret
IPPASM cpAddAdd_BNU endp

ENDIF    ;; _IPP_W7
ENDIF    ;; _ENABLE_KARATSUBA_
END
