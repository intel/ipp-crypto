;===============================================================================
; Copyright 2006-2019 Intel Corporation
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
;               Big Number macros
; 
;     Content:
;        COPY_BNU
;        CMP_BNU
;        FIX_BNU
; 
;        SUB_FIX_BNU
;        ADD_FIX_BNU
;

;;
;; CMP_BNU     comare arbitrary BNUs
;;
;; input
;;    rSrc1    points BNU1
;;    rSrc2    points BNU2
;;    rLen     size of BNUs
;;
;; output
;;    flags
;;
CMP_BNU MACRO rSrc1:REQ,rSrc2:REQ,rLen:REQ, tmp:REQ
LOCAL cmp_loop,cmp_quit
cmp_loop:
   mov   tmp,[rSrc1+rLen*4-4]
   cmp   tmp,[rSrc2+rLen*4-4]
   jne   cmp_quit
   sub   rLen,1
   jg    cmp_loop
cmp_quit:
ENDM

;;
;; SUB_FIX_BNU subtract fixed size BNUs
;;
;; input
;;    rVal     points src/dst BNU
;;    rSrc     points source BNU
;;    immLen   BNU size
;;
SUB_FIX_BNU MACRO rVal:REQ,rSrc:REQ,immLen:REQ
    pxor     mm0,mm0
   i=0
   repeat immLen
   movd     mm1,DWORD PTR[rVal+i*4]
   movd     mm2,DWORD PTR[rSrc+i*4]
   if i ne 0
    paddq    mm1,mm0
   endif
    psubq    mm1,mm2
   movd     DWORD PTR[rVal+i*4],mm1
   if i lt (immLen-1)
    pshufw   mm0,mm1,11111110b
   endif
   i=i+1
   endm
ENDM

;;
;; ADD_FIX_BNU add fixed size BNUs
;;
;; input
;;    rVal     points src/dst BNU
;;    rSrc     points source BNU
;;    immLen   BNU size
;;
ADD_FIX_BNU MACRO rVal:REQ,rSrc:REQ,immLen:REQ
    pxor     mm0,mm0
   i=0
   repeat immLen
   movd     mm1,DWORD PTR[rVal+i*4]
   movd     mm2,DWORD PTR[rSrc+i*4]
   if i ne 0
    paddq    mm1,mm0
   endif
    paddq    mm1,mm2
   movd     DWORD PTR[rVal+i*4],mm1
   if i lt (immLen-1)
    pshufw   mm0,mm1,11111110b
   endif
   i=i+1
   endm
ENDM

;;
;; COPY_BNU copy arbitrary BNU
;;
COPY_BNU MACRO rSrc:REQ, rDst:REQ, rLen:REQ, rIdx:REQ, rTmp:REQ
LOCAL copy_bnu
   xor      rIdx,rIdx
copy_bnu:
   mov      rTmp,[rSrc+rIdx*4]
   mov      [rDst+rIdx*4],rTmp
   add      rIdx,1
   cmp      rIdx,rLen
   jl       copy_bnu
ENDM

;;
;; FIX_BNU     returns actual length of BNU
;;
;; input
;;    rSrc     points BNU
;;    rLen     initial BNU size
;;
;; output
;;    rLen     actual BNU size
;;
FIX_BNU MACRO rSrc,rLen, tmp
LOCAL fix_bnu_loop,fix_bnu_quit
fix_bnu_loop:
   mov      tmp,[rSrc+rLen*4-4]     ;; value
   test     tmp,tmp                 ;; test BNU component
   jnz      fix_bnu_quit
   sub      rLen,1
   jg       fix_bnu_loop
   add      rLen,1
fix_bnu_quit:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MULADD_START MACRO i,j
    movd mm1,DWORD PTR[eax + 4*j]
    movd mm3,DWORD PTR[eax + 4*j]
    pmuludq mm1,mm0
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    pand mm3,mm6
    psrlq mm7,32
    paddq mm7,mm3
ENDM

MULADD MACRO i,j
    movd mm1,DWORD PTR[eax + 4*j]
    movd mm3,DWORD PTR[eax + 4*j]
    movd mm2,DWORD PTR[edx + 4*(i+j)]
    pmuludq mm1,mm0
    pand mm3,mm6
    paddq mm1,mm2
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    psrlq mm7,32
    paddq mm7,mm3
ENDM

SQR_DECOMPOSE MACRO i
    movd mm7,DWORD PTR[eax + 4*i]
    movd mm0,DWORD PTR[eax + 4*i]
    movd mm6,DWORD PTR[eax + 4*i]
    if i ne 0
    movd mm1,DWORD PTR[edx + 4*(2*i)]
    endif
    pslld mm0,1
    pmuludq mm7,mm7
    psrad mm6,32
    if i ne 0
    paddq mm7,mm1
    endif
    movd DWORD PTR[edx + 4*(2*i)],mm7
    psrlq mm7,32
ENDM

STORE_CARRY MACRO i,s
    movq DWORD PTR[edx + 4*(i + s)],mm7
ENDM

STORE_CARRY_NEXT MACRO i,s
    movd mm4,DWORD PTR[edx + 4*(i + s)]
    paddq mm4,mm7
    movd DWORD PTR[edx + 4*(i + s)],mm4
    psrlq mm7,32
    movd DWORD PTR[edx + 4*(i + s + 1)],mm7
ENDM

LAST_STEP MACRO s
    movd mm7,DWORD PTR[eax + 4*(s - 1)]
    movd mm2,DWORD PTR[edx + 4*(2*s - 2)]
    pmuludq mm7,mm7
    paddq mm7,mm2
    movd mm4,DWORD PTR[edx + 4*(2*s - 1)]
    movd DWORD PTR[edx + 4*(2*s - 2)],mm7
    psrlq mm7,32
    paddq mm4,mm7
    movd DWORD PTR[edx + 4*(2*s - 1)],mm4
ENDM

INNER_LOOP MACRO i, nsize
    j = i + 1
    s = nsize - i - 1

    SQR_DECOMPOSE i

    repeat s
   if i eq 0
     MULADD_START i,j
   else
     MULADD i,j
   endif
    j = j + 1
    endm

   if i eq 0
     STORE_CARRY i,nsize
   else
     STORE_CARRY_NEXT i,nsize
   endif
ENDM

OUTER_LOOP MACRO nsize
    i = 0
    repeat nsize - 1
    INNER_LOOP i,nsize
    i = i + 1
    endm

    LAST_STEP nsize
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MULADD_START1 MACRO i,j
    movd mm1,DWORD PTR[eax + 4*j]
    pmuludq mm1,mm0
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    psrlq mm7,32
ENDM

MULADD_START_wt_carry MACRO i
    movd mm7,DWORD PTR[eax]
    movd mm2,DWORD PTR[edx + 4*(i)]
    pmuludq mm7,mm0
    paddq mm7,mm2
    movd DWORD PTR[edx + 4*(i)],mm7
    psrlq mm7,32
ENDM

MULADD_START1 MACRO i,j
    movd mm1,DWORD PTR[eax + 4*j]
    pmuludq mm1,mm0
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    psrlq mm7,32
ENDM

MULADD_START_wt_carry1 MACRO
    movd mm7,DWORD PTR[eax]
    pmuludq mm7,mm0
    movd DWORD PTR[edx],mm7
    psrlq mm7,32
ENDM

MULADD1 MACRO i,j
    movd mm1,DWORD PTR[eax + 4*j]
    movd mm2,DWORD PTR[edx + 4*(i+j)]
    pmuludq mm1,mm0
    paddq mm1,mm2
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    psrlq mm7,32
ENDM

INNER_LOOP1 MACRO i, nsize
    j = 0
    movd mm0,DWORD PTR[ebx + 4*i]

    repeat nsize
if i eq 0
    if j eq 0
        MULADD_START_wt_carry1
    else
        MULADD_START1 i,j
    endif
else
    if j eq 0
        MULADD_START_wt_carry i
    else
        MULADD1 i,j
    endif
endif
    j = j + 1
    endm
    movd DWORD PTR[edx + 4*(i + nsize)],mm7
ENDM

OUTER_LOOP1 MACRO nsize
    i = 0
    repeat nsize
    INNER_LOOP1 i,nsize
    i = i + 1
    endm
ENDM
