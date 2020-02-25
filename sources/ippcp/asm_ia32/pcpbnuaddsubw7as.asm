;===============================================================================
; Copyright 2015-2020 Intel Corporation
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;===============================================================================

;
;
;     Purpose:  Cryptography Primitive.
;
;     Content:
;        cpAddSub_BNU()
;





%include "asmdefs.inc"
%include "pcpvariant.inc"

%if _ENABLE_KARATSUBA_

%if (_IPP >= _IPP_W7)

segment .text align=IPP_ALIGN_FACTOR

align IPP_ALIGN_FACTOR
IPPASM cpAddSub_BNU,PUBLIC
  USES_GPR esi,edi,ebx

%xdefine pDst  [esp + ARG_1 + 0*sizeof(dword)] ; target address
%xdefine pSrcA [esp + ARG_1 + 1*sizeof(dword)] ; source address (A)
%xdefine pSrcB [esp + ARG_1 + 2*sizeof(dword)] ; source address (B)
%xdefine pSrcC [esp + ARG_1 + 3*sizeof(dword)] ; source address (C)
%xdefine len   [esp + ARG_1 + 4*sizeof(dword)] ; length of BNU

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

align IPP_ALIGN_FACTOR
.main_loop:
   movd     mm1,DWORD [eax + esi]
   movd     mm2,DWORD [ebx + esi]
   movd     mm3,DWORD [ecx + esi]

   paddq    mm0,mm1
   paddq    mm0,mm2
   psubq    mm0,mm3
   movd     DWORD [edi + esi],mm0
   pshufw   mm0,mm0,11111110b

   add      esi,4
   jnz      .main_loop

   movd     eax,mm0
   emms
   REST_GPR
   ret
ENDFUNC cpAddSub_BNU

%endif    ;; _IPP_W7
%endif    ;; _ENABLE_KARATSUBA_

