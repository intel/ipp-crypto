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
;               Big Number Arithmetic
; 
;     Content:
;        cpMulAdc_BNU_school()
; 
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IF _IPP GE _IPP_V8
INCLUDE pcpvariant.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;;
;; Short-Length Squaring
;;
INIT MACRO r,a,n
   movd     xmm0,DWORD PTR[a]             ;; a[0]
   pxor     xmm7,xmm7                     ;; clear carry
   movd     DWORD PTR[r],xmm7             ;; r[0] = 0

   i = 1
   movd     xmm1,DWORD PTR[a+i*4]         ;; a[i]
   pmuludq  xmm1,xmm0                     ;; t0 = a[i]*a[0]
   movd     xmm2,DWORD PTR[a+i*4+4]       ;; a[i+1]
   pmuludq  xmm2,xmm0                     ;; t1 = a[i+1]*a[0]

   repeat (n-1)/2
      paddq    xmm7,xmm1                  ;; t0 += carry
      if n-(i+2) gt 0
         movd     xmm1,DWORD PTR[a+(i+2)*4] ;; read in advance a[i+2]
         pmuludq  xmm1,xmm0                 ;; multiply in advance a[i+2]*a[0]
      endif
      movd     DWORD PTR [r+i*4],xmm7     ;; r[i] = LO(t0)
      psrlq    xmm7,32                    ;; carry = HI(t0)

      paddq    xmm7,xmm2                  ;; t1 += carry
      if n-(i+3) gt 0
         movd     xmm2,DWORD PTR[a+(i+2)*4+4] ;; read in advance a[i+3]
         pmuludq  xmm2,xmm0                   ;; multiply in advance a[i+3]*a[0]
      endif
      movd     DWORD PTR [r+i*4+4],xmm7   ;; r[i+1] = LO(t1)
      psrlq    xmm7,32                    ;; carry = HI(t1)

      i = i+2
   endm

   if ((n-1) and 1) ne 0
      paddq    xmm7,xmm1                  ;; t0 += carry
      movd     DWORD PTR [r+i*4],xmm7     ;; r[i] = LO(t0)
      psrlq    xmm7,32                    ;; carry = HI(t0)
   endif

   movd     DWORD PTR [r+n*4],xmm7        ;; r[n] = extension
ENDM

UPDATE_MUL MACRO r,a,n
   i = 1
   repeat (n-2)
      movd     xmm0,DWORD PTR[a+i*4]      ;; a[i]
      pxor     xmm7,xmm7                  ;; clear carry

      j = i+1
      movd     xmm1,DWORD PTR[a+j*4]      ;; a[j]
      pmuludq  xmm1,xmm0                  ;; t0 = a[j]*a[i]
      movd     xmm3,DWORD PTR[r+(i+j)*4]  ;; r[i+j]
      if (j+1) lt n
         movd     xmm2,DWORD PTR[a+j*4+4]    ;; a[j+1]
         pmuludq  xmm2,xmm0                  ;; t1 = a[j+1]*a[i]
         movd     xmm4,DWORD PTR[r+(i+j)*4+4];; r[i+j+1]
      endif

      tn = n-j
      repeat tn/2
         paddq    xmm7,xmm1                     ;; t0 += carry+r[i+j]
         if n-(j+2) gt 0
            movd     xmm1,DWORD PTR[a+(j+2)*4]  ;; read in advance a[j+2]
            pmuludq  xmm1,xmm0                  ;; multiply in advance a[j+2]*a[i]
         endif
         paddq    xmm7,xmm3
         if n-(j+2) gt 0
            movd     xmm3,DWORD PTR[r+(i+2+j)*4];; read in advance r[i+j+2]
         endif
         movd     DWORD PTR [r+(i+j)*4],xmm7    ;; r[i+j] = LO(t0)
         psrlq    xmm7,32                       ;; carry = HI(t0)

         paddq    xmm7,xmm2                     ;; t1 += carry+r[i+j]
         if n-(j+3) gt 0
            movd     xmm2,DWORD PTR[a+(j+2)*4+4];; read in advance a[j+3]
            pmuludq  xmm2,xmm0                  ;; multiply in advance a[j+3]*a[i]
         endif
         paddq    xmm7,xmm4
         if n-(j+3) gt 0
            movd     xmm4,DWORD PTR[r+(i+2+j)*4+4];; read in advance r[i+j+3]
         endif
         movd     DWORD PTR [r+(i+j)*4+4],xmm7  ;; r[i+j+1] = LO(t1)
         psrlq    xmm7,32                       ;; carry = HI(t1)

         j = j+2
      endm

      if (tn and 1) ne 0
         paddq    xmm7,xmm1
         paddq    xmm7,xmm3
         movd     DWORD PTR [r+(i+j)*4],xmm7
         psrlq    xmm7,32                    ;; carry = HI(t1)
      endif

      movd     DWORD PTR [r+(n+i)*4],xmm7    ;; r[i+j] = extension

      i = i+1
   endm

   pandn    xmm7,xmm7                     ;; clear carry
   movd     DWORD PTR [r+(2*n-1)*4],xmm7  ;; r[2*n-1] = zero extension
ENDM


FINALIZE MACRO r,a,n
   i = 0
   movd     xmm0,DWORD PTR [a+i*4]        ;; a[i]
   pmuludq  xmm0,xmm0                     ;; p = a[i]*a[i]

   movd     xmm2,DWORD PTR [r+(2*i)*4]    ;; r[2*i]
   paddq    xmm2,xmm2
   movd     xmm3,DWORD PTR [r+(2*i+1)*4]  ;; r[2*i+1]
   paddq    xmm3,xmm3

   pcmpeqd  xmm6,xmm6                     ;; mm6 = low 32 bit mask
   psrlq    xmm6,32

   pandn    xmm7,xmm7                     ;; clear carry

   repeat n
      movq     xmm1,xmm0
      pand     xmm0,xmm6                        ;; mm0 = LO(p)
      psrlq    xmm1,32                          ;; mm1 = HI(p)

      paddq    xmm7,xmm0                        ;; q = carry + 2*r[2*i] + LO(p)
      if n-(i+1) gt 0
         movd     xmm0,DWORD PTR [a+(i+1)*4]    ;; a[i]
         pmuludq  xmm0,xmm0                     ;; p = a[i]*a[i]
      endif
      paddq    xmm7,xmm2
      if n-(i+1) gt 0
         movd     xmm2,DWORD PTR [r+(2*i+2)*4]  ;; r[2*(i+1)]
         paddq    xmm2,xmm2
      endif
      movd     DWORD PTR[r+(2*i)*4],xmm7        ;; r[2*i] = LO(q)
      psrlq    xmm7,32                          ;; carry = HI(q)

      paddq    xmm7,xmm1                        ;; q = carry + 2*r[2*i+1] + HI(p)
      paddq    xmm7,xmm3
      if n-(i+1) gt 0
         movd     xmm3,DWORD PTR [r+(2*i+2)*4+4];; r[2*(i+1)+1]
         paddq    xmm3,xmm3
      endif
      movd     DWORD PTR[r+(2*i+1)*4],xmm7      ;; r[2*i+1] = LO(q)
      psrlq    xmm7,32                          ;; carry = HI(q)

      i = i+1
   endm
ENDM

SQR_SHORT MACRO r,a,n
   INIT        r,a,n
   UPDATE_MUL  r,a,n
   FINALIZE    r,a,n
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Middle-Length Squaring
;;
SQR_DECOMPOSE MACRO i
   movd     xmm7,DWORD PTR[eax + 4*i]
   movd     xmm0,DWORD PTR[eax + 4*i]
   movd     xmm6,DWORD PTR[eax + 4*i]

   if i ne 0
      movd  xmm1,DWORD PTR[edx + 4*(2*i)]
   endif

   psllq    xmm0,1
   pmuludq  xmm7,xmm7
   psrad    xmm6,32

   if i ne 0
      paddq xmm7,xmm1
   endif

   movd     DWORD PTR[edx + 4*(2*i)],xmm7
   psrlq    xmm7,32
ENDM

MULADD_START MACRO i,j
   movd     xmm1,DWORD PTR[eax + 4*j]
   movd     xmm3,DWORD PTR[eax + 4*j]
   pmuludq  xmm1,xmm0
   paddq    xmm7,xmm1
   movd     DWORD PTR[edx + 4*(i+j)],xmm7
   pand     xmm3,xmm6
   psrlq    xmm7,32
   paddq    xmm7,xmm3
ENDM

MULADD MACRO i,j
   movd     xmm1,DWORD PTR[eax + 4*j]
   movd     xmm3,DWORD PTR[eax + 4*j]
   movd     xmm2,DWORD PTR[edx + 4*(i+j)]
   pmuludq  xmm1,xmm0
   pand     xmm3,xmm6
   paddq    xmm1,xmm2
   paddq    xmm7,xmm1
   movd     DWORD PTR[edx + 4*(i+j)],xmm7
   psrlq    xmm7,32
   paddq    xmm7,xmm3
ENDM

STORE_CARRY MACRO i,nsize
   movq     QWORD PTR [edx + 4*(i + nsize)],xmm7
ENDM

STORE_CARRY_NEXT MACRO i,nsize
   movd     xmm4,DWORD PTR[edx + 4*(i + nsize)]
   paddq    xmm4,xmm7
   movd     DWORD PTR[edx + 4*(i + nsize)],xmm4
   psrlq    xmm7,32
   movd     DWORD PTR[edx + 4*(i + nsize + 1)],xmm7
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

LAST_STEP MACRO nsize
   movd     xmm7,DWORD PTR[eax + 4*(nsize - 1)]
   pmuludq  xmm7,xmm7
   movd     xmm2,DWORD PTR[edx + 4*(2*nsize - 2)]
   paddq    xmm7,xmm2
   movd     xmm4,DWORD PTR[edx + 4*(2*nsize - 1)]
   movd     DWORD PTR[edx + 4*(2*nsize - 2)],xmm7
   psrlq    xmm7,32
   paddq    xmm7,xmm4
   movd     DWORD PTR[edx + 4*(2*nsize - 1)],xmm7
ENDM

SQR_MIDDL MACRO nsize
   i = 0
   repeat nsize - 1
      INNER_LOOP i,nsize
      i = i + 1
   endm
   LAST_STEP nsize
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UNROLL16_MULADD MACRO
   movd     xmm1,DWORD PTR[eax + ecx]
   movd     xmm2,DWORD PTR[edx + ecx]
   movd     xmm3,DWORD PTR[eax + ecx + 4]
   movd     xmm4,DWORD PTR[edx + ecx + 4]
   movd     xmm5,DWORD PTR[eax + ecx + 8]
   movd     xmm6,DWORD PTR[edx + ecx + 8]

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2
   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4
   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 12]
   movd     xmm2,DWORD PTR[edx + ecx + 12]
   movd     DWORD PTR[edx + ecx],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 16]
   movd     xmm4,DWORD PTR[edx + ecx + 16]
   movd     DWORD PTR[edx + ecx + 4],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     xmm5,DWORD PTR[eax + ecx + 20]
   movd     xmm6,DWORD PTR[edx + ecx + 20]
   movd     DWORD PTR[edx + ecx + 8],xmm7
   psrlq    xmm7,32

   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 24]
   movd     xmm2,DWORD PTR[edx + ecx + 24]
   movd     DWORD PTR[edx + ecx + 12],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 28]
   movd     xmm4,DWORD PTR[edx + ecx + 28]
   movd     DWORD PTR[edx + ecx + 16],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     xmm5,DWORD PTR[eax + ecx + 32]
   movd     xmm6,DWORD PTR[edx + ecx + 32]
   movd     DWORD PTR[edx + ecx + 20],xmm7
   psrlq    xmm7,32

   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 36]
   movd     xmm2,DWORD PTR[edx + ecx + 36]
   movd     DWORD PTR[edx + ecx + 24],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 40]
   movd     xmm4,DWORD PTR[edx + ecx + 40]
   movd     DWORD PTR[edx + ecx + 28],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     xmm5,DWORD PTR[eax + ecx + 44]
   movd     xmm6,DWORD PTR[edx + ecx + 44]
   movd     DWORD PTR[edx + ecx + 32],xmm7
   psrlq    xmm7,32

   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 48]
   movd     xmm2,DWORD PTR[edx + ecx + 48]
   movd     DWORD PTR[edx + ecx + 36],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 52]
   movd     xmm4,DWORD PTR[edx + ecx + 52]
   movd     DWORD PTR[edx + ecx + 40],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     xmm5,DWORD PTR[eax + ecx + 56]
   movd     xmm6,DWORD PTR[edx + ecx + 56]
   movd     DWORD PTR[edx + ecx + 44],xmm7
   psrlq    xmm7,32

   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 60]
   movd     xmm2,DWORD PTR[edx + ecx + 60]
   movd     DWORD PTR[edx + ecx + 48],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     DWORD PTR[edx + ecx + 52],xmm7
   psrlq    xmm7,32

   paddq    xmm7,xmm5
   movd     DWORD PTR[edx + ecx + 56],xmm7
   psrlq    xmm7,32

   paddq    xmm7,xmm1
   movd     DWORD PTR[edx + ecx + 60],xmm7
   psrlq    xmm7,32
ENDM

UNROLL8_MULADD MACRO
   movd     xmm1,DWORD PTR[eax + ecx]
   movd     xmm2,DWORD PTR[edx + ecx]
   movd     xmm3,DWORD PTR[eax + ecx + 4]
   movd     xmm4,DWORD PTR[edx + ecx + 4]
   movd     xmm5,DWORD PTR[eax + ecx + 8]
   movd     xmm6,DWORD PTR[edx + ecx + 8]

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2
   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4
   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 12]
   movd     xmm2,DWORD PTR[edx + ecx + 12]
   movd     DWORD PTR[edx + ecx],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 16]
   movd     xmm4,DWORD PTR[edx + ecx + 16]
   movd     DWORD PTR[edx + ecx + 4],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     xmm5,DWORD PTR[eax + ecx + 20]
   movd     xmm6,DWORD PTR[edx + ecx + 20]
   movd     DWORD PTR[edx + ecx + 8],xmm7
   psrlq    xmm7,32

   pmuludq  xmm5,xmm0
   paddq    xmm5,xmm6

   paddq    xmm7,xmm1
   movd     xmm1,DWORD PTR[eax + ecx + 24]
   movd     xmm2,DWORD PTR[edx + ecx + 24]
   movd     DWORD PTR[edx + ecx + 12],xmm7
   psrlq    xmm7,32

   pmuludq  xmm1,xmm0
   paddq    xmm1,xmm2

   paddq    xmm7,xmm3
   movd     xmm3,DWORD PTR[eax + ecx + 28]
   movd     xmm4,DWORD PTR[edx + ecx + 28]
   movd     DWORD PTR[edx + ecx + 16],xmm7
   psrlq    xmm7,32

   pmuludq  xmm3,xmm0
   paddq    xmm3,xmm4

   paddq    xmm7,xmm5
   movd     DWORD PTR[edx + ecx + 20],xmm7
   psrlq    xmm7,32

   paddq    xmm7,xmm1
   movd     DWORD PTR[edx + ecx + 24],xmm7
   psrlq    xmm7,32

   paddq    xmm7,xmm3
   movd     DWORD PTR[edx + ecx + 28],xmm7
   psrlq    xmm7,32
ENDM


MUL_MAC0_START MACRO
    movd    xmm7,DWORD PTR[eax]
    pmuludq xmm7,xmm0
    movd    DWORD PTR[edx],xmm7
    psrlq   xmm7,32
ENDM

MUL_MAC0_START2 MACRO
    movd    xmm1,DWORD PTR[eax]
    pmuludq xmm1,xmm0
    movd    DWORD PTR[edx],xmm1
    psrlq   xmm1,32

    movd    xmm7,DWORD PTR[eax+4]
    pmuludq xmm7,xmm0
    paddq   xmm7,xmm1
    movd    DWORD PTR[edx+4],xmm7
    psrlq   xmm7,32
ENDM

MUL_MAC0 MACRO j
    movd    xmm1,DWORD PTR[eax + 4*j]
    pmuludq xmm1,xmm0
    paddq   xmm1,xmm7
    movd    DWORD PTR[edx + 4*j],xmm1
    psrlq   xmm1,32

    movd    xmm7,DWORD PTR[eax + 4*(j+1)]
    pmuludq xmm7,xmm0
    paddq   xmm7,xmm1
    movd    DWORD PTR[edx + 4*(j+1)],xmm7
    psrlq   xmm7,32
ENDM

MUL_MAC_START MACRO i
    movd    xmm7,DWORD PTR[eax]
    pmuludq xmm7,xmm0
    movd    xmm2,DWORD PTR[edx + 4*(i)]
    paddq   xmm7,xmm2
    movd    DWORD PTR[edx + 4*(i)],xmm7
    psrlq   xmm7,32
ENDM

MUL_MAC_START2 MACRO i
    movd    xmm1,DWORD PTR[eax]
    pmuludq xmm1,xmm0
    movd    xmm2,DWORD PTR[edx + 4*i]
    paddq   xmm1,xmm2
    movd    DWORD PTR[edx + 4*i],xmm1
    psrlq   xmm1,32

    movd    xmm7,DWORD PTR[eax+4]
    pmuludq xmm7,xmm0
    movd    xmm2,DWORD PTR[edx + 4*(i+1)]
    paddq   xmm7,xmm2
    paddq   xmm7,xmm1
    movd    DWORD PTR[edx + 4*(i+1)],xmm7
    psrlq   xmm7,32
ENDM

MUL_MAC MACRO i,j
    movd    xmm1,DWORD PTR[eax + 4*j]
    pmuludq xmm1,xmm0
    movd    xmm2,DWORD PTR[edx + 4*(i+j)]
    paddq   xmm1,xmm2
    paddq   xmm1,xmm7
    movd    DWORD PTR[edx + 4*(i+j)],xmm1
    psrlq   xmm1,32

    movd    xmm7,DWORD PTR[eax + 4*(j+1)]
    pmuludq xmm7,xmm0
    movd    xmm2,DWORD PTR[edx + 4*(i+j+1)]
    paddq   xmm7,xmm2
    paddq   xmm7,xmm1
    movd    DWORD PTR[edx + 4*(i+j+1)],xmm7
    psrlq   xmm7,32
ENDM

INNER_LOOP1 MACRO i, nsize
   j = 0
   movd xmm0,DWORD PTR[ebx + 4*i]

   if i eq 0
      if nsize and 1
         MUL_MAC0_START
         j = j + 1
      else
         MUL_MAC0_START2
         j = j + 2
      endif
   else
      if nsize and 1
         MUL_MAC_START i
         j = j + 1
      else
         MUL_MAC_START2 i
         j = j + 2
      endif
   endif

   repeat ((nsize-j)/2)
      if i eq 0
         MUL_MAC0 j
      else
         MUL_MAC  i,j
      endif
      j = j + 2
   endm
   movd DWORD PTR[edx + 4*(i + nsize)],xmm7
ENDM

OUTER_LOOP1 MACRO nsize
   i = 0
   repeat nsize
      INNER_LOOP1 i,nsize
      i = i + 1
   endm
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

IF (_USE_C_cpMulAdc_BNU_school_ EQ 0)
;*************************************************************
;*
;* void cpMulAdc_BNU_school(Ipp32u* pR,
;*                    const Ipp32u* pA, int aSize,
;*                    const Ipp32u* pB, int bSize)
;*
;*************************************************************

;;
;; Lib = V8
;;
;; Caller = ippsMontMul
;; Caller = ippsMontExp
;; Caller = ippsModInv_BN
;;
;; Caller = ippsECCPGetPoint
;; Caller = ippsECCPCheckPoint
;; Caller = ippsECCPAddPoint
;; Caller = ippsECCPMulPointScalar
;; Caller = ippsECCPGenKeyPair
;; Caller = ippsECCPPublicKey
;; Caller = ippsECCPValidateKey
;; Caller = ippsECCPShareSecretKeyDH
;; Caller = ippsECCPShareSecretKeyDHC
;; Caller = ippsECCPSignDSA
;; Caller = ippsECCPSignNR
;; Caller = ippsECCPVerifyDSA
;; Caller = ippsECCPVerifyNR
;;
IPPASM cpMulAdc_BNU_school PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\     ; target address
      pA:   PTR DWORD,\     ; source address
      aSize:    DWORD,\     ; BNU length
      pB:   PTR DWORD,\     ; source address
      bSize:    DWORD      ; BNU length

   mov         eax,pA      ; pA
   mov         edi,aSize   ; aSzie_len
   mov         ebx,pB      ; pB
   mov         esi,bSize   ; bSize
   mov         edx,pR      ; pR

   cmp         eax,ebx
   jne         multiplication

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; squaring
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   cmp         edi,1
   jg          sqr2
sqr1:
   movd        xmm0,DWORD PTR [eax]
   pmuludq     xmm0,xmm0
   movq        QWORD PTR [edx],xmm0
   ret

sqr2:
   cmp         edi,2
   jg          sqr3
   movd        xmm0,DWORD PTR [eax]
   movd        xmm1,DWORD PTR [eax+4]

   movq        xmm2,xmm0
   pmuludq     xmm0,xmm0         ; a[0]*a[0]
   pmuludq     xmm2,xmm1         ; a[0]*a[1]
   pmuludq     xmm1,xmm1         ; a[1]*a[1]

   pcmpeqd     xmm7,xmm7         ; mm7 = low 32 bit mask
   psrlq       xmm7,32

   pand        xmm7,xmm2         ; mm7 = LO(a[0]*a[1])
   paddq       xmm7,xmm7
   psrlq       xmm2,32           ; mm2 = HI(a[0]*a[1])
   paddq       xmm2,xmm2

   movd        DWORD PTR [edx],xmm0
   psrlq       xmm0,32

   paddq       xmm0,xmm7
   movd        DWORD PTR [edx+4],xmm0
   psrlq       xmm0,32

   paddq       xmm2,xmm1
   paddq       xmm2,xmm0
   movq        QWORD PTR [edx+8],xmm2
   ret

sqr3:
   cmp         edi,3
   jg          sqr4
   SQR_SHORT   edx,eax,3
   ret

sqr4:
   cmp         edi,4
   jg          sqr5
   SQR_SHORT   edx,eax,4
   ret

sqr5:
   cmp         edi,5
   jg          sqr6
   SQR_SHORT   edx,eax,5
   ret

sqr6:
   cmp         edi,6
   jg          sqr7
   SQR_SHORT   edx,eax,6
   ret

sqr7:
   cmp         edi,7
   jg          sqr8
   SQR_SHORT   edx,eax,7
   ret

sqr8:
   cmp         edi,8
   jg          sqr9
   ;SQR_MIDDL   8
   SQR_SHORT   edx,eax,8
   ret

sqr9:
   cmp         edi,9
   jg          sqr10
   ;SQR_MIDDL   9
   SQR_SHORT   edx,eax,9
   ret

sqr10:
   cmp         edi,10
   jg          sqr11
   ;SQR_MIDDL   10
   SQR_SHORT   edx,eax,10
   ret

sqr11:
   cmp         edi,11
   jg          sqr12
   ;SQR_MIDDL   11
   SQR_SHORT   edx,eax,11
   ret

sqr12:
   cmp         edi,12
   jg          sqr13
   ;SQR_MIDDL   12
   SQR_SHORT   edx,eax,12
   ret

sqr13:
   cmp         edi,13
   jg          sqr14
   ;SQR_MIDDL   13
   SQR_SHORT   edx,eax,13
   ret

sqr14:
   cmp         edi,14
   jg          sqr15
   ;SQR_MIDDL   14
   SQR_SHORT   edx,eax,14
   ret

sqr15:
   cmp         edi,15
   jg          sqr16
   ;SQR_MIDDL   15
   SQR_SHORT   edx,eax,15
   ret

sqr16:
   cmp         edi,16
   jg          sqr17
   ;SQR_MIDDL   16
   SQR_SHORT   edx,eax,16
   ret

sqr17:
   cmp         edi,17
   jg          common_case_sqr
   ;SQR_MIDDL   17
   SQR_SHORT   edx,eax,17
   ret

;;
;; General case Squaring (aSize > 17)
;;
common_case_sqr:
   mov         ebx,edx                       ; copy pR
   mov         ecx,edi                       ; copy aSize
;;
;; init result:
;;    r = (a[1],a[2],..a[N-1]) * a[0]
;;
   mov         edx,1                         ; i=1
   movd        xmm0,DWORD PTR[eax]           ; a[0]
   movd        xmm1,DWORD PTR[eax+edx*4]     ; a[i]
   pmuludq     xmm1,xmm0                     ; p = a[i]*a[0]
   pandn       xmm7,xmm7                     ; clear carry
   movd        DWORD PTR[ebx],xmm7           ; r[0] = 0
sqr_init_loop:
   movd        xmm2,DWORD PTR[eax+edx*4+4]   ; read in advance a[i+1]
   pmuludq     xmm2,xmm0                     ; q = a[i+1]*a[0]

   paddq       xmm7,xmm1                     ; p+= carry
   movd        DWORD PTR [ebx+edx*4],xmm7    ; r[i] = LO(p)
   psrlq       xmm7,32                       ; carry = HI(p)

   add         edx,2
   cmp         edx,ecx
   jg          sqr_break_init_loop

   movd        xmm1,DWORD PTR[eax+edx*4]     ; next a[i]
   pmuludq     xmm1,xmm0                     ; p = a[i]*a[0]

   paddq       xmm7,xmm2                     ; q += carry
   movd        DWORD PTR [ebx+edx*4-4],xmm7  ; r[i+1] = LO(q)
   psrlq       xmm7,32                       ; carry = HI(q)

   jl          sqr_init_loop

sqr_break_init_loop:
   movd        DWORD PTR [ebx+ecx*4],xmm7    ; r[aSize] = carry

;;
;; add other a[i]*a[j], i=1,..,N-1, j=i+1,..,N-1
;;
   mov         edx,1                         ; i=1

sqr_update_mul_loop:
   mov         esi,edx                       ; j=i+1
   add         esi,1
   mov         edi,edx                       ; i+j
   add         edi,esi

   movd        xmm0,DWORD PTR[eax+edx*4]     ; a[i]
   movd        xmm1,DWORD PTR[eax+esi*4]     ; a[j]
   pmuludq     xmm1,xmm0                     ; p = a[j]*a[i]
   movd        xmm3,DWORD PTR[ebx+edi*4]     ; r[i+j]
   pandn       xmm7,xmm7                     ; clear carry

sqr_update_mul_inner_loop:
   paddq       xmm7,xmm1                     ; p += carry+r[i+j]
   paddq       xmm7,xmm3
   movd        DWORD PTR [ebx+edi*4],xmm7    ; r[i+j] = LO(p)
   psrlq       xmm7,32                       ; carry = HI(p)

   movd        xmm1,DWORD PTR[eax+esi*4+4]   ; read in advance a[i+1]
   pmuludq     xmm1,xmm0                     ; p = a[j+1]*a[i]
   movd        xmm3,DWORD PTR[ebx+edi*4+4]   ; read in advance r[i+j+1]

   add         edi,1
   add         esi,1
   cmp         esi,ecx
   jl          sqr_update_mul_inner_loop

   movd        DWORD PTR [ebx+edi*4],xmm7    ; r[i+j] = carry
   add         edx,1
   sub         esi,1
   cmp         edx,esi
   jl          sqr_update_mul_loop
   pandn       xmm7,xmm7                     ; clear carry
   movd        DWORD PTR [ebx+edi*4+4],xmm7  ; r[i+j+1] = 0

;;
;; double a[i]*a[j] and add a[i]^2
;;
   pcmpeqd     xmm6,xmm6                     ; xmm6 = low 32 bit mask
   psrlq       xmm6,32

   movd        xmm0,DWORD PTR [eax]          ; a[i]
   pmuludq     xmm0,xmm0                     ; p = a[i]*a[i]
   mov         edx,0                         ; i=0
   movd        xmm2,DWORD PTR [ebx]          ; r[2*i]
   movd        xmm3,DWORD PTR [ebx+4]        ; r[2*i+1]
   pandn       xmm7,xmm7                     ; clear carry
sqr_loop:
   paddq       xmm2,xmm2                     ; 2*r[2*i]
   paddq       xmm3,xmm3                     ; 2*r[2*i+1]

   movq        xmm1,xmm0
   pand        xmm0,xmm6                     ; xmm0 = LO(p)
   psrlq       xmm1,32                       ; xmm1 = HI(p)

   paddq       xmm7,xmm2                     ; q = carry + 2*r[2*i] + LO(p)
   paddq       xmm7,xmm0
   movd        DWORD PTR[ebx+edx*8],xmm7     ; r[2*i] = LO(q)
   psrlq       xmm7,32                       ; carry = HI(q)

   movd        xmm0,DWORD PTR [eax+edx*4+4]  ; read in advance a[i+1]
   pmuludq     xmm0,xmm0                     ; p = a[i+1]*a[i+1]

   paddq       xmm7,xmm3                     ; q = carry + 2*r[2*i+1] + HI(p)
   paddq       xmm7,xmm1
   movd        DWORD PTR[ebx+edx*8+4],xmm7   ; r[2*i+1] = LO(q)
   psrlq       xmm7,32                       ; carry = HI(q)

   add         edx,1
   movd        xmm2,DWORD PTR [ebx+edx*8]    ; r[2*(i+1)]
   movd        xmm3,DWORD PTR [ebx+edx*8+4]  ; r[2*(i+1)+1]
   cmp         edx,ecx
   jl          sqr_loop

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; multiplication
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
multiplication:
   cmp         edi,esi
   jne         common_case_mul

mul4:
   cmp         edi,4
   jne         mul5
   OUTER_LOOP1 4
   ret

mul5:
   cmp         edi,5
   jne         mul6
   OUTER_LOOP1 5
   ret

mul6:
   cmp         edi,6
   jne         mul7
   OUTER_LOOP1 6
   ret

mul7:
   cmp         edi,7
   jne         mul8
   OUTER_LOOP1 7
   ret

mul8:
   cmp         edi,8
   jne         mul9
   OUTER_LOOP1 8
   ret

mul9:
   cmp         edi,9
   jne         mul10
   OUTER_LOOP1 9
   ret

mul10:
   cmp         edi,10
   jne         mul11
   OUTER_LOOP1 10
   ret

mul11:
   cmp         edi,11
   jne         mul12
   OUTER_LOOP1 11
   ret

mul12:
   cmp         edi,12
   jne         mul13
   OUTER_LOOP1 12
   ret

mul13:
   cmp         edi,13
   jne         mul14
   OUTER_LOOP1 13
   ret

mul14:
   cmp         edi,14
   jne         mul15
   OUTER_LOOP1 14
   ret

mul15:
   cmp         edi,15
   jne         mul16
   OUTER_LOOP1 15
   ret

mul16:
   cmp         edi,16
   jne         mul17
   OUTER_LOOP1 16
   ret

mul17:
   cmp         edi,17
   jne         common_case_mul
   OUTER_LOOP1 17
   ret

;;
;; General case Multiplication
;;
common_case_mul:
   cmp         esi,edi     ; bSize ~ aSize
   jae         ini_result

   xor         edi,esi     ; swap(aSize,bSize)
   xor         esi,edi
   xor         edi,esi
   mov         edi,aSize
   mov         esi,bSize

   xor         eax,ebx     ; swap(pA,pB)
   xor         ebx,eax
   xor         eax,ebx
   mov         eax,pA
   mov         ebx,pB

ini_result:
   add         esi,edi
   xor         ecx,ecx
mul_init_loop:
   mov         [edx],ecx
   add         edx,4
   sub         esi,1
   jne         mul_init_loop

   mov         esi,edi     ; restore aSize
   mov         edx,pR      ; restore pR

   shl         edi,2       ; aSize*4
;
; multiplication loop
;
macLoop:
   movd        xmm0,DWORD PTR[ebx]  ; pB[]
   pxor        xmm7,xmm7
   mov         esi,edi     ; number of loops (==aSize*4)
   xor         ecx,ecx     ; init loop counter

   and         esi,7*4
   jz          testSize_8
tiny_loop:
   movd        xmm1,DWORD PTR[eax+ecx]
   movd        xmm2,DWORD PTR[edx+ecx]

   pmuludq     xmm1,xmm0
   paddq       xmm1,xmm2
   paddq       xmm7,xmm1
   movd        DWORD PTR[edx+ecx],xmm7
   psrlq       xmm7,32

   add         ecx,4
   cmp         ecx,esi
   jl          tiny_loop

testSize_8:
   mov      esi,edi        ; restore aSize*4
   and      esi,8*4
   jz       testSize_16

   UNROLL8_MULADD
   add      ecx,8*4

testSize_16:
   mov      esi,edi        ; restore aSize*4
   and      esi,0FFFFFFC0h
   jz       next_term

huge_loop:
   UNROLL16_MULADD
   add      ecx,16*4
   cmp      ecx,esi
   jl       huge_loop

next_term:
   movd        DWORD PTR[edx + ecx],xmm7

   add         ebx,4       ; move to the next B[]
   add         edx,4       ; move pR
   sub         bSize,1     ; decrease bSize
   jne         macLoop

   ret
IPPASM cpMulAdc_BNU_school ENDP
ENDIF

ENDIF ;; _IPP_V8
END
