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
;
;     Content:
;        cpInc_BNU()
;
.686P
.387
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IF _IPP GE _IPP_W7
INCLUDE pcpvariant.inc

IF (_USE_C_cpInc_BNU_ EQ 0)

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR
IPPASM cpInc_BNU PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pDst:  PTR DWORD,\    ; target address
      pSrc:  PTR DWORD,\    ; source address
      len:       DWORD,\    ; length of BNU
      value:     DWORD     ; increment val

   mov   edi, pDst   ; dst
   mov   esi, pSrc   ; src
   mov   eax, value  ; value
   movd  mm0, value
   mov   edx,len     ; length
   shl   edx,2

   xor   ecx,ecx

ALIGN IPP_ALIGN_FACTOR
main_loop:
   movd     mm1,DWORD PTR[esi + ecx]
   paddq    mm1,mm0
   movd     DWORD PTR[edi + ecx],mm1
   pshufw   mm0,mm1,11111110b
   movd     eax, mm0

   add      ecx,4
   cmp      ecx,edx
   jl       main_loop

exit_loop:
   emms
   ret
IPPASM cpInc_BNU endp
ENDIF

ENDIF
END
