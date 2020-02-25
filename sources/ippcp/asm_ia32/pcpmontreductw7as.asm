;===============================================================================
; Copyright 2014-2020 Intel Corporation
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
;               Big Number Arithmetic (Montgomery Reduction)
;
;     Content:
;        MontReduct()
;
;
;
;







%include "asmdefs.inc"
%include "ia_emm.inc"
%include "pcpvariant.inc"

%if _USE_NN_MONTMUL_ == _USE
%if (_IPP >= _IPP_W7)


segment .data align=IPP_ALIGN_FACTOR

align IPP_ALIGN_FACTOR

    MASK1 DQ 0000000000000000H
    MASK2 DQ 00000000FFFFFFFFH

align IPP_ALIGN_FACTOR
segment .data align=IPP_ALIGN_FACTOR


%macro ALIGN_STACK 0.nolist
    sub                    esp,40
    sub                    esp,15
    and                    esp,0FFFFFFF0H
%endmacro


%macro fastmovq 2.nolist
  %xdefine %%mm1 %1
  %xdefine %%mm2 %2

    pshufw %%mm1,%%mm2,11100100b
%endmacro



%macro DEEP_UNROLLED_MULADD 0.nolist
    main_loop:

    movd mm1,DWORD [eax + ecx]
    movd mm2,DWORD [edx + ecx]
    movd mm3,DWORD [eax + ecx + 4]
    movd mm4,DWORD [edx + ecx + 4]
    movd mm5,DWORD [eax + ecx + 8]
    movd mm6,DWORD [edx + ecx + 8]

    pmuludq mm1,mm0
    paddq mm1,mm2
    pmuludq mm3,mm0
    paddq mm3,mm4
    pmuludq mm5,mm0
    paddq mm5,mm6


    movd mm2,DWORD [edx + ecx + 12]
    paddq mm7,mm1
    movd mm1,DWORD [eax + ecx + 12]

    pmuludq mm1,mm0
    paddq mm1,mm2
    movd mm2,DWORD [edx + ecx + 24]
    movd DWORD [edx + ecx],mm7

    psrlq mm7,32
    paddq mm7,mm3

    movd mm3,DWORD [eax + ecx + 16]
    movd mm4,DWORD [edx + ecx + 16]

    pmuludq mm3,mm0


    movd DWORD [edx + ecx + 4],mm7

    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD [edx + ecx + 28]
    paddq mm7,mm5
    movd mm5,DWORD [eax + ecx + 20]
    movd mm6,DWORD [edx + ecx + 20]

    pmuludq mm5,mm0
    movd DWORD [edx + ecx + 8],mm7
    psrlq mm7,32


    paddq mm5,mm6
    movd mm6,DWORD [edx + ecx + 32]
    paddq mm7,mm1

    movd mm1,DWORD [eax + ecx + 24]


    pmuludq mm1,mm0


    movd DWORD [edx + ecx + 12],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD [edx + ecx + 36]
    paddq mm7,mm3

    movd mm3,DWORD [eax + ecx + 28]
    pmuludq mm3,mm0

    movd DWORD [edx + ecx + 16],mm7
    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD [edx + ecx + 40]
    paddq mm7,mm5

    movd mm5,DWORD [eax + ecx + 32]
    pmuludq mm5,mm0

    movd DWORD [edx + ecx + 20],mm7
    psrlq mm7,32

    paddq mm5,mm6
    movd mm6,DWORD [edx + ecx + 44]
    paddq mm7,mm1
    movd mm1,DWORD [eax + ecx + 36]
    pmuludq mm1,mm0
    movd DWORD [edx + ecx + 24],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD [edx + ecx + 48]
    paddq mm7,mm3
    movd mm3,DWORD [eax + ecx + 40]
    pmuludq mm3,mm0

    movd DWORD [edx + ecx + 28],mm7
    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD [edx + ecx + 52]
    paddq mm7,mm5

    movd mm5,DWORD [eax + ecx + 44]
    pmuludq mm5,mm0

    movd DWORD [edx + ecx + 32],mm7
    psrlq mm7,32
    paddq mm5,mm6
    movd mm6,DWORD [edx + ecx + 56]
    paddq mm7,mm1

    movd mm1,DWORD [eax + ecx + 48]
    pmuludq mm1,mm0

    movd DWORD [edx + ecx + 36],mm7
    psrlq mm7,32

    paddq mm1,mm2
    movd mm2,DWORD [edx + ecx + 60]
    paddq mm7,mm3

    movd mm3,DWORD [eax + ecx + 52]
    pmuludq mm3,mm0

    movd DWORD [edx + ecx + 40],mm7
    psrlq mm7,32
    paddq mm3,mm4
    paddq mm7,mm5

    movd mm5,DWORD [eax + ecx + 56]

    pmuludq mm5,mm0
    movd DWORD [edx + ecx + 44],mm7
    psrlq mm7,32
    paddq mm5,mm6
    paddq mm7,mm1

    movd mm1,DWORD [eax + ecx + 60]

    pmuludq mm1,mm0
    movd DWORD [edx + ecx + 48],mm7
    psrlq mm7,32

    paddq mm7,mm3
    movd DWORD [edx + ecx + 52],mm7
    psrlq mm7,32
    paddq mm1,mm2
    paddq mm7,mm5
    movd DWORD [edx + ecx + 56],mm7
    psrlq mm7,32

    paddq mm7,mm1
    movd DWORD [edx + ecx + 60],mm7
    psrlq mm7,32



    add ecx,64
    cmp ecx,edi
    jl main_loop
%endmacro


%macro UNROLL8_MULADD 0.nolist
    main_loop1:

    movd mm1,DWORD [eax + ecx]
    movd mm2,DWORD [edx + ecx]
    movd mm3,DWORD [eax + ecx + 4]
    movd mm4,DWORD [edx + ecx + 4]
    movd mm5,DWORD [eax + ecx + 8]
    movd mm6,DWORD [edx + ecx + 8]

    pmuludq mm1,mm0
    paddq mm1,mm2
    pmuludq mm3,mm0
    paddq mm3,mm4
    pmuludq mm5,mm0
    paddq mm5,mm6


    movd mm2,DWORD [edx + ecx + 12]
    paddq mm7,mm1
    movd mm1,DWORD [eax + ecx + 12]

    pmuludq mm1,mm0
    paddq mm1,mm2
    movd mm2,DWORD [edx + ecx + 24]
    movd DWORD [edx + ecx],mm7

    psrlq mm7,32
    paddq mm7,mm3

    movd mm3,DWORD [eax + ecx + 16]
    movd mm4,DWORD [edx + ecx + 16]

    pmuludq mm3,mm0


    movd DWORD [edx + ecx + 4],mm7

    psrlq mm7,32
    paddq mm3,mm4
    movd mm4,DWORD [edx + ecx + 28]
    paddq mm7,mm5
    movd mm5,DWORD [eax + ecx + 20]
    movd mm6,DWORD [edx + ecx + 20]

    pmuludq mm5,mm0
    movd DWORD [edx + ecx + 8],mm7
    psrlq mm7,32


    paddq mm5,mm6
;    movd mm6,DWORD [edx + ecx + 32]
    paddq mm7,mm1

    movd mm1,DWORD [eax + ecx + 24]


    pmuludq mm1,mm0


    movd DWORD [edx + ecx + 12],mm7
    psrlq mm7,32

    paddq mm1,mm2
;   movd mm2,DWORD [edx + ecx + 36]
    paddq mm7,mm3

    movd mm3,DWORD [eax + ecx + 28]
    pmuludq mm3,mm0

    movd DWORD [edx + ecx + 16],mm7
    psrlq mm7,32
    paddq mm3,mm4
;   movd mm4,DWORD [edx + ecx + 40]
    paddq mm7,mm5

;   movd mm5,DWORD [eax + ecx + 32]
;   pmuludq mm5,mm0

    movd DWORD [edx + ecx + 20],mm7
    psrlq mm7,32

;   paddq mm5,mm6
;   movd mm6,DWORD [edx + ecx + 44]
    paddq mm7,mm1
;   movd mm1,DWORD [eax + ecx + 36]
;   pmuludq mm1,mm0
    movd DWORD [edx + ecx + 24],mm7
    psrlq mm7,32

;   paddq mm1,mm2
;   movd mm2,DWORD [edx + ecx + 48]
    paddq mm7,mm3
;   movd mm3,DWORD [eax + ecx + 40]
;   pmuludq mm3,mm0

    movd DWORD [edx + ecx + 28],mm7   ;//
    psrlq mm7,32
;   paddq mm3,mm4
;   movd mm4,DWORD [edx + ecx + 52]
;   paddq mm7,mm5

;   movd mm5,DWORD [eax + ecx + 44]
;   pmuludq mm5,mm0

;   movd DWORD [edx + ecx + 32],mm7
;   psrlq mm7,32
;   paddq mm5,mm6
;   movd mm6,DWORD [edx + ecx + 56]
;   paddq mm7,mm1

;   movd mm1,DWORD [eax + ecx + 48]
;   pmuludq mm1,mm0

;   movd DWORD [edx + ecx + 36],mm7
;   psrlq mm7,32

;   paddq mm1,mm2
;   movd mm2,DWORD [edx + ecx + 60]
;   paddq mm7,mm3

;   movd mm3,DWORD [eax + ecx + 52]
;   pmuludq mm3,mm0

;   movd DWORD [edx + ecx + 40],mm7
;   psrlq mm7,32
;   paddq mm3,mm4
;   paddq mm7,mm5

;   movd mm5,DWORD [eax + ecx + 56]

;   pmuludq mm5,mm0
;   movd DWORD [edx + ecx + 44],mm7
;   psrlq mm7,32
;   paddq mm5,mm6
;   paddq mm7,mm1

;   movd mm1,DWORD [eax + ecx + 60]

;   pmuludq mm1,mm0
;   movd DWORD [edx + ecx + 48],mm7
;   psrlq mm7,32

;   paddq mm7,mm3
;   movd DWORD [edx + ecx + 52],mm7
;   psrlq mm7,32
;   paddq mm1,mm2
;   paddq mm7,mm5
;   movd DWORD [edx + ecx + 56],mm7
;   psrlq mm7,32

;   paddq mm7,mm1
;   movd DWORD [edx + ecx + 60],mm7
;   psrlq mm7,32



    add ecx,32
    cmp ecx,edi
    jl main_loop1
%endmacro


%xdefine CARRY  qword [esp]

%macro MULADD1 3.nolist
  %xdefine %%i %1
  %xdefine %%j %2
  %xdefine %%nsize %3

    movd mm1,DWORD [eax + 4*%%j]
    movd mm2,DWORD [edx + 4*(%%i+%%j)]
    pmuludq mm1,mm0
    paddq mm1,mm2
    paddq mm7,mm1
    movd DWORD [edx + 4*(%%i+%%j)],mm7
    psrlq mm7,32
%endmacro


%macro MULADD_wt_carry 1.nolist
  %xdefine %%i %1

    movd mm7,DWORD [eax]
    movd mm2,DWORD [edx + 4*(%%i)]
    pmuludq mm7,mm0
    paddq mm7,mm2
    movd DWORD [edx + 4*(%%i)],mm7
    psrlq mm7,32
%endmacro




%macro INNER_LOOP1 2.nolist
  %xdefine %%i %1
  %xdefine %%nsize %2

  %assign %%j  0

    movd mm0,DWORD [edx + 4*%%i]      ;x[i]

;    pandn mm7,mm7

    pmuludq mm0,mm5
    movd mm4,DWORD [edx + 4*(%%i + %%nsize)]
;   pand mm0,MASK2
    paddq mm4,mm6
    %rep %%nsize
%if %%j == 0
    MULADD_wt_carry %%i
%else
    MULADD1 %%i,%%j,%%nsize
%endif
  %assign %%j  %%j + 1
    %endrep
    paddq mm7,mm4 ;mm6 holds last carry


    movd DWORD [edx + 4*(%%i + %%nsize)],mm7
    ;psrlq mm7,32
    ;movq mm6,mm7
    pshufw mm6,mm7,11111110b
    ;psrlq mm7,32
    ;pandn mm7,mm7
%endmacro




%macro OUTER_LOOP1 1.nolist
  %xdefine %%nsize %1

    movd mm5,DWORD [ebp + 20] ;n0
    pandn mm6,mm6 ;last carry
    %assign %%i  0
    %rep %%nsize
      INNER_LOOP1 %%i,ns%%ize
    %assign %%i  %%i + 1
    %endrep
    psrlq mm7,32
%endmacro


segment .text align=IPP_ALIGN_FACTOR
IPPASM MontReduct
    push                ebp
    mov                 ebp, esp
    ALIGN_STACK
    mov                 DWORD [ebp-8],ebx
    mov                 DWORD [ebp-12],edx
    mov                 DWORD [ebp-16],edi
    mov                 DWORD [ebp-20],esi
    mov                 DWORD [ebp-24],ecx


    mov eax,[ebp + 8]   ;a
    mov edi,[ebp + 12]  ;a_len
    mov edx,[ebp + 16]  ;x

    cmp edi,8
    je .reduct8

    cmp edi,16
    je .reduct16

    test edi,0fh
    jne .sm_loop

.big_loop:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

.outer_big_loop:

    movd mm0,DWORD [ebp + 20] ;n0
    movd mm1,DWORD [edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2

    xor ecx,ecx

    DEEP_UNROLLED_MULADD

    paddq mm7,CARRY
    movd mm1,DWORD [edx + ecx]
    paddq mm7,mm1
    movd DWORD [edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne .outer_big_loop

    jmp .finish

.sm_loop:

    cmp edi,8

    jne .sm_loop1

.middle_loop:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

.outer_middle_loop:

    movd mm0,DWORD [ebp + 20] ;n0
    movd mm1,DWORD [edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2

    xor ecx,ecx

    UNROLL8_MULADD

    paddq mm7,CARRY
    movd mm1,DWORD [edx + ecx]
    paddq mm7,mm1
    movd DWORD [edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne .outer_middle_loop

    jmp .finish

.sm_loop1:

    shl edi,2
    mov esi,edi

    pandn mm7,mm7
    movq CARRY,mm7

.outer_small_loop:

    movd mm0,DWORD [ebp + 20] ;n0
    movd mm1,DWORD [edx]      ;x[i]

    pandn mm7,mm7

    pmuludq mm0,mm1
    pand mm0,MASK2

    xor ecx,ecx

.inner_small_loop:

    movd mm1,DWORD [eax + ecx]
    movd mm2,DWORD [edx + ecx]


    pmuludq mm1,mm0
    paddq mm2,mm1
    paddq mm7,mm2
    movd DWORD [edx + ecx],mm7
    psrlq mm7,32

    add ecx,4

    cmp ecx,edi
    jl  .inner_small_loop

    paddq mm7,CARRY
    movd mm1,DWORD [edx + ecx]
    paddq mm7,mm1
    movd DWORD [edx + ecx],mm7
    psrlq mm7,32
    movq CARRY,mm7

    add edx,4
    add ebx,4
    add esi,-4
    jne .outer_small_loop

.finish:
    mov esi,[ebp + 24]
    movd DWORD [esi],mm7

    mov                 ebx,DWORD [ebp-8]
    mov                 edx,DWORD [ebp-12]
    mov                 edi,DWORD [ebp-16]
    mov                 esi,DWORD [ebp-20]
    mov                 ecx,DWORD [ebp-24]
    mov                 esp,ebp
    pop                 ebp

    emms
    ret

.reduct8:
    OUTER_LOOP1 8
    jmp .finish

.reduct16:
    OUTER_LOOP1 16
    jmp .finish

ENDFUNC MontReduct

%endif
%endif ;; _USE_NN_MONTMUL_


