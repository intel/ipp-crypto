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





%include "asmdefs.inc"
%include "pcpvariant.inc"

%if _ENABLE_KARATSUBA_

%if (_IPP >= _IPP_W7)

segment .text align=IPP_ALIGN_FACTOR

align IPP_ALIGN_FACTOR
IPPASM cpAddAdd_BNU,PUBLIC
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
   paddq    mm0,mm3
   movd     DWORD [edi + esi],mm0
   pshufw   mm0,mm0,11111110b

   add      esi,4
   jnz      .main_loop

   movd     eax,mm0
   emms
   REST_GPR
   ret
ENDFUNC cpAddAdd_BNU

%endif    ;; _IPP_W7
%endif    ;; _ENABLE_KARATSUBA_

