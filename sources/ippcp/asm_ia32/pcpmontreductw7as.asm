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
;               Big Number Arithmetic (Montgomery Reduction)
; 
;     Content:
;        MontReduct()
; 
; 
; 
;

    .686P
    .387
    .XMM
    .MODEL FLAT,C


INCLUDE asmdefs.inc
INCLUDE ia_emm.inc
INCLUDE pcpvariant.inc

IF _USE_NN_MONTMUL_ EQ _USE
IF _IPP GE _IPP_W7



IPPDATA SEGMENT 'DATA' ALIGN (IPP_ALIGN_FACTOR)

   ALIGN IPP_ALIGN_FACTOR

    MASK1 DQ 0000000000000000H
    MASK2 DQ 00000000FFFFFFFFH

   ALIGN IPP_ALIGN_FACTOR
IPPDATA SEGMENT 'DATA' ALIGN (IPP_ALIGN_FACTOR)


    ALIGN_STACK  MACRO

    sub                    esp,40
    sub                    esp,15
    and                    esp,0FFFFFFF0H

    ENDM

    fastmovq MACRO mm1,mm2

    pshufw mm1,mm2,11100100b

    ENDM


    DEEP_UNROLLED_MULADD MACRO

    main_loop:

    movd mm1,DWORD PTR[eax + ecx]
    movd mm2,DWORD PTR[edx + ecx]
    movd mm3,DWORD PTR[eax + ecx + 4]
    movd mm4,DWORD PTR[edx + ecx + 4]
    movd mm5,DWORD PTR[eax + ecx + 8]
    movd mm6,DWORD PTR[edx + ecx + 8]

    pmuludq mm1,mm0
    paddq mm1,mm2
    pmuludq mm3,mm0
    paddq mm3,mm4
    pmuludq mm5,mm0
    paddq mm5,mm6


    movd mm2,DWORD PTR[edx + ecx + 12]
    paddq mm7,mm1
    movd mm1,DWORD PTR[eax + ecx + 12]

    pmuludq mm1,mm0
    paddq mm1,mm2
    movd mm2,DWORD PTR[edx + ecx + 24]
    movd DWORD PTR[edx + ecx],mm7

    psrlq mm7,32
    paddq mm7,mm3

    movd mm3,DWORD PTR[eax + ecx + 16]
    movd mm4,DWORD PTR[edx + ecx + 16]

    pmuludq mm3,mm0


    movd DWORD PTR[edx + ecx + 4],mm7

    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD PTR[edx + ecx + 28]
    paddq mm7,mm5
    movd mm5,DWORD PTR[eax + ecx + 20]
    movd mm6,DWORD PTR[edx + ecx + 20]

    pmuludq mm5,mm0
    movd DWORD PTR[edx + ecx + 8],mm7
    psrlq mm7,32


    paddq mm5,mm6
    movd mm6,DWORD PTR[edx + ecx + 32]
    paddq mm7,mm1

    movd mm1,DWORD PTR[eax + ecx + 24]


    pmuludq mm1,mm0


    movd DWORD PTR[edx + ecx + 12],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD PTR[edx + ecx + 36]
    paddq mm7,mm3

    movd mm3,DWORD PTR[eax + ecx + 28]
    pmuludq mm3,mm0

    movd DWORD PTR[edx + ecx + 16],mm7
    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD PTR[edx + ecx + 40]
    paddq mm7,mm5

    movd mm5,DWORD PTR[eax + ecx + 32]
    pmuludq mm5,mm0

    movd DWORD PTR[edx + ecx + 20],mm7
    psrlq mm7,32

    paddq mm5,mm6
    movd mm6,DWORD PTR[edx + ecx + 44]
    paddq mm7,mm1
    movd mm1,DWORD PTR[eax + ecx + 36]
    pmuludq mm1,mm0
    movd DWORD PTR[edx + ecx + 24],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD PTR[edx + ecx + 48]
    paddq mm7,mm3
    movd mm3,DWORD PTR[eax + ecx + 40]
    pmuludq mm3,mm0

    movd DWORD PTR[edx + ecx + 28],mm7
    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD PTR[edx + ecx + 52]
    paddq mm7,mm5

    movd mm5,DWORD PTR[eax + ecx + 44]
    pmuludq mm5,mm0

    movd DWORD PTR[edx + ecx + 32],mm7
    psrlq mm7,32
    paddq mm5,mm6
    movd mm6,DWORD PTR[edx + ecx + 56]
    paddq mm7,mm1

    movd mm1,DWORD PTR[eax + ecx + 48]
    pmuludq mm1,mm0

    movd DWORD PTR[edx + ecx + 36],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD PTR[edx + ecx + 60]
    paddq mm7,mm3

    movd mm3,DWORD PTR[eax + ecx + 52]
    pmuludq mm3,mm0

    movd DWORD PTR[edx + ecx + 40],mm7
    psrlq mm7,32
    paddq mm3,mm4
    paddq mm7,mm5

    movd mm5,DWORD PTR[eax + ecx + 56]

    pmuludq mm5,mm0
    movd DWORD PTR[edx + ecx + 44],mm7
    psrlq mm7,32
    paddq mm5,mm6
    paddq mm7,mm1

    movd mm1,DWORD PTR[eax + ecx + 60]

    pmuludq mm1,mm0
    movd DWORD PTR[edx + ecx + 48],mm7
    psrlq mm7,32

    paddq mm7,mm3
    movd DWORD PTR[edx + ecx + 52],mm7
    psrlq mm7,32
    paddq mm1,mm2
    paddq mm7,mm5
    movd DWORD PTR[edx + ecx + 56],mm7
    psrlq mm7,32

    paddq mm7,mm1
    movd DWORD PTR[edx + ecx + 60],mm7
    psrlq mm7,32



    add ecx,64
    cmp ecx,edi
    jl main_loop


    ENDM

    UNROLL8_MULADD MACRO

    main_loop1:

    movd mm1,DWORD PTR[eax + ecx]
    movd mm2,DWORD PTR[edx + ecx]
    movd mm3,DWORD PTR[eax + ecx + 4]
    movd mm4,DWORD PTR[edx + ecx + 4]
    movd mm5,DWORD PTR[eax + ecx + 8]
    movd mm6,DWORD PTR[edx + ecx + 8]

    pmuludq mm1,mm0
    paddq mm1,mm2
    pmuludq mm3,mm0
    paddq mm3,mm4
    pmuludq mm5,mm0
    paddq mm5,mm6


    movd mm2,DWORD PTR[edx + ecx + 12]
    paddq mm7,mm1
    movd mm1,DWORD PTR[eax + ecx + 12]

    pmuludq mm1,mm0
    paddq mm1,mm2
    movd mm2,DWORD PTR[edx + ecx + 24]
    movd DWORD PTR[edx + ecx],mm7

    psrlq mm7,32
    paddq mm7,mm3

    movd mm3,DWORD PTR[eax + ecx + 16]
    movd mm4,DWORD PTR[edx + ecx + 16]

    pmuludq mm3,mm0


    movd DWORD PTR[edx + ecx + 4],mm7

    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD PTR[edx + ecx + 28]
    paddq mm7,mm5
    movd mm5,DWORD PTR[eax + ecx + 20]
    movd mm6,DWORD PTR[edx + ecx + 20]

    pmuludq mm5,mm0
    movd DWORD PTR[edx + ecx + 8],mm7
    psrlq mm7,32


    paddq mm5,mm6
;    movd mm6,DWORD PTR[edx + ecx + 32]
    paddq mm7,mm1

    movd mm1,DWORD PTR[eax + ecx + 24]


    pmuludq mm1,mm0


    movd DWORD PTR[edx + ecx + 12],mm7
    psrlq mm7,32

    paddq mm1,mm2
;   movd mm2,DWORD PTR[edx + ecx + 36]
    paddq mm7,mm3

    movd mm3,DWORD PTR[eax + ecx + 28]
    pmuludq mm3,mm0

    movd DWORD PTR[edx + ecx + 16],mm7
    psrlq mm7,32
    paddq mm3,mm4
;   movd mm4,DWORD PTR[edx + ecx + 40]
    paddq mm7,mm5

;   movd mm5,DWORD PTR[eax + ecx + 32]
;   pmuludq mm5,mm0

    movd DWORD PTR[edx + ecx + 20],mm7
    psrlq mm7,32

;   paddq mm5,mm6
;   movd mm6,DWORD PTR[edx + ecx + 44]
    paddq mm7,mm1
;   movd mm1,DWORD PTR[eax + ecx + 36]
;   pmuludq mm1,mm0
    movd DWORD PTR[edx + ecx + 24],mm7
    psrlq mm7,32

;   paddq mm1,mm2
;   movd mm2,DWORD PTR[edx + ecx + 48]
    paddq mm7,mm3
;   movd mm3,DWORD PTR[eax + ecx + 40]
;   pmuludq mm3,mm0

    movd DWORD PTR[edx + ecx + 28],mm7   ;//
    psrlq mm7,32
;   paddq mm3,mm4
;   movd mm4,DWORD PTR[edx + ecx + 52]
;   paddq mm7,mm5

;   movd mm5,DWORD PTR[eax + ecx + 44]
;   pmuludq mm5,mm0

;   movd DWORD PTR[edx + ecx + 32],mm7
;   psrlq mm7,32
;   paddq mm5,mm6
;   movd mm6,DWORD PTR[edx + ecx + 56]
;   paddq mm7,mm1

;   movd mm1,DWORD PTR[eax + ecx + 48]
;   pmuludq mm1,mm0

;   movd DWORD PTR[edx + ecx + 36],mm7
;   psrlq mm7,32

;   paddq mm1,mm2
;   movd mm2,DWORD PTR[edx + ecx + 60]
;   paddq mm7,mm3

;   movd mm3,DWORD PTR[eax + ecx + 52]
;   pmuludq mm3,mm0

;   movd DWORD PTR[edx + ecx + 40],mm7
;   psrlq mm7,32
;   paddq mm3,mm4
;   paddq mm7,mm5

;   movd mm5,DWORD PTR[eax + ecx + 56]

;   pmuludq mm5,mm0
;   movd DWORD PTR[edx + ecx + 44],mm7
;   psrlq mm7,32
;   paddq mm5,mm6
;   paddq mm7,mm1

;   movd mm1,DWORD PTR[eax + ecx + 60]

;   pmuludq mm1,mm0
;   movd DWORD PTR[edx + ecx + 48],mm7
;   psrlq mm7,32

;   paddq mm7,mm3
;   movd DWORD PTR[edx + ecx + 52],mm7
;   psrlq mm7,32
;   paddq mm1,mm2
;   paddq mm7,mm5
;   movd DWORD PTR[edx + ecx + 56],mm7
;   psrlq mm7,32

;   paddq mm7,mm1
;   movd DWORD PTR[edx + ecx + 60],mm7
;   psrlq mm7,32



    add ecx,32
    cmp ecx,edi
    jl main_loop1

    ENDM

    CARRY equ qword ptr [esp]

    MULADD1 MACRO i,j,nsize
    movd mm1,DWORD PTR[eax + 4*j]
    movd mm2,DWORD PTR[edx + 4*(i+j)]
    pmuludq mm1,mm0
    paddq mm1,mm2
    paddq mm7,mm1
    movd DWORD PTR[edx + 4*(i+j)],mm7
    psrlq mm7,32
    ENDM

    MULADD_wt_carry MACRO i
    movd mm7,DWORD PTR[eax]
    movd mm2,DWORD PTR[edx + 4*(i)]
    pmuludq mm7,mm0
    paddq mm7,mm2
    movd DWORD PTR[edx + 4*(i)],mm7
    psrlq mm7,32
    ENDM



    INNER_LOOP1 MACRO i, nsize
    j = 0

    movd mm0,DWORD PTR[edx + 4*i]      ;x[i]

;    pandn mm7,mm7

    pmuludq mm0,mm5
    movd mm4,DWORD PTR[edx + 4*(i + nsize)]
;   pand mm0,MASK2
    paddq mm4,mm6
    repeat nsize
if j eq 0
    MULADD_wt_carry i
else
    MULADD1 i,j,nsize
endif
    j = j + 1
    endm
    paddq mm7,mm4 ;mm6 holds last carry


    movd DWORD PTR[edx + 4*(i + nsize)],mm7
    ;psrlq mm7,32
    ;movq mm6,mm7
    pshufw mm6,mm7,11111110b
    ;psrlq mm7,32
    ;pandn mm7,mm7



    ENDM



    OUTER_LOOP1 MACRO nsize
    movd mm5,DWORD PTR[ebp + 20] ;n0
    pandn mm6,mm6 ;last carry
    i = 0
    repeat nsize
    INNER_LOOP1 i,nsize
    i = i + 1
    endm
    psrlq mm7,32
    ENDM





    PUBLIC MontReduct
IPPDATA ENDS

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


IPPASM     MontReduct PROC NEAR

    push                ebp
    mov                 ebp, esp
    ALIGN_STACK
    mov                 DWORD PTR [ebp-8],ebx
    mov                 DWORD PTR [ebp-12],edx
    mov                 DWORD PTR [ebp-16],edi
    mov                 DWORD PTR [ebp-20],esi
    mov                 DWORD PTR [ebp-24],ecx


    mov eax,[ebp + 8]   ;a
    mov edi,[ebp + 12]  ;a_len
    mov edx,[ebp + 16]  ;x

    cmp edi,8
    je reduct8

    cmp edi,16
    je reduct16






    test edi,0fh
    jne sm_loop

    big_loop:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

    outer_big_loop:

    movd mm0,DWORD PTR[ebp + 20] ;n0
    movd mm1,DWORD PTR[edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2




    xor ecx,ecx




    DEEP_UNROLLED_MULADD

    paddq mm7,CARRY
    movd mm1,DWORD PTR[edx + ecx]
    paddq mm7,mm1
    movd DWORD PTR[edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne outer_big_loop

    jmp finish



    sm_loop:

    cmp edi,8

    jne sm_loop1


    middle_loop:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

    outer_middle_loop:

    movd mm0,DWORD PTR[ebp + 20] ;n0
    movd mm1,DWORD PTR[edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2




    xor ecx,ecx




    UNROLL8_MULADD

    paddq mm7,CARRY
    movd mm1,DWORD PTR[edx + ecx]
    paddq mm7,mm1
    movd DWORD PTR[edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne outer_middle_loop

    jmp finish



    sm_loop1:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

    outer_small_loop:

    movd mm0,DWORD PTR[ebp + 20] ;n0
    movd mm1,DWORD PTR[edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2

    xor ecx,ecx





    inner_small_loop:

    movd mm1,DWORD PTR[eax + ecx]
    movd mm2,DWORD PTR[edx + ecx]


    pmuludq mm1,mm0
    paddq mm2,mm1
    paddq mm7,mm2
    movd DWORD PTR[edx + ecx],mm7
    psrlq mm7,32

    add ecx,4

    cmp ecx,edi
    jl  inner_small_loop

    paddq mm7,CARRY
    movd mm1,DWORD PTR[edx + ecx]
    paddq mm7,mm1
    movd DWORD PTR[edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne outer_small_loop


    finish:
    mov esi,[ebp + 24]
    movd DWORD PTR[esi],mm7




    mov                 ebx,DWORD PTR [ebp-8]
    mov                 edx,DWORD PTR [ebp-12]
    mov                 edi,DWORD PTR [ebp-16]
    mov                 esi,DWORD PTR [ebp-20]
    mov                 ecx,DWORD PTR [ebp-24]
    mov                 esp,ebp
    pop                 ebp


    emms
    ret


    reduct8:
    OUTER_LOOP1 8
    jmp finish

    reduct16:
    OUTER_LOOP1 16
    jmp finish

    MontReduct endp

ENDIF
ENDIF ;; _USE_NN_MONTMUL_

END
