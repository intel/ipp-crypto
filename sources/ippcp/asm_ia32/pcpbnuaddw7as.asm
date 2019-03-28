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
;     Purpose:  Cryptography Primitive.
;               Big Number Arithmetic
;
;     Content:
;        cpAddMul_BNU()
;
.686P
.387
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IF _IPP GE _IPP_W7
INCLUDE pcpvariant.inc

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

IF (_USE_C_cpAdd_BNU_ EQ 0)
ALIGN IPP_ALIGN_FACTOR

IPPASM cpAdd_BNU PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pDst:  PTR DWORD,\    ; target address
      pSrc1: PTR DWORD,\    ; source address
      pSrc2: PTR DWORD,\    ; source address
      len:       DWORD     ; length of BNU

   mov   eax,pSrc1   ; src1
   mov   ebx,pSrc2   ; src2
   mov   edx,pDst    ; dst
   mov   edi,len     ; length
   shl   edi,2

   xor   ecx,ecx
   pandn mm0,mm0

ALIGN IPP_ALIGN_FACTOR
main_loop:
   movd     mm1,DWORD PTR[eax + ecx]
   movd     mm2,DWORD PTR[ebx + ecx]

   paddq    mm0,mm1
   paddq    mm0,mm2
   movd     DWORD PTR[edx + ecx],mm0
   pshufw   mm0,mm0,11111110b

   add      ecx,4
   cmp      ecx,edi
   jl       main_loop

   movd     eax,mm0
   emms
   ret
IPPASM cpAdd_BNU endp
ENDIF

ENDIF
END

