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
;        cpSqrAdc_BNU_school()
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IF _IPP GE _IPP_W7
INCLUDE pcpvariant.inc

;;
;; Short-Length Squaring
;;
INIT MACRO r,a,n
   movd     mm0,DWORD PTR[a]              ;; a[0]
   pandn    mm7,mm7                       ;; clear carry
   movd     DWORD PTR[r],mm7              ;; r[0] = 0

   i = 1
   movd     mm1,DWORD PTR[a+i*4]          ;; a[i]
   pmuludq  mm1,mm0                       ;; t0 = a[i]*a[0]
   movd     mm2,DWORD PTR[a+i*4+4]        ;; a[i+1]
   pmuludq  mm2,mm0                       ;; t1 = a[i+1]*a[0]

   repeat (n-1)/2
      paddq    mm7,mm1                    ;; t0 += carry
      if n-(i+2) gt 0
         movd     mm1,DWORD PTR[a+(i+2)*4]   ;; read in advance a[i+2]
         pmuludq  mm1,mm0                    ;; multiply in advance a[i+2]*a[0]
      endif
      movd     DWORD PTR [r+i*4],mm7      ;; r[i] = LO(t0)
      psrlq    mm7,32                     ;; carry = HI(t0)

      paddq    mm7,mm2                    ;; t1 += carry
      if n-(i+3) gt 0
         movd     mm2,DWORD PTR[a+(i+2)*4+4] ;; read in advance a[i+3]
         pmuludq  mm2,mm0                    ;; multiply in advance a[i+3]*a[0]
      endif
      movd     DWORD PTR [r+i*4+4],mm7    ;; r[i+1] = LO(t1)
      psrlq    mm7,32                     ;; carry = HI(t1)

      i = i+2
   endm

   if ((n-1) and 1) ne 0
      paddq    mm7,mm1                    ;; t0 += carry
      movd     DWORD PTR [r+i*4],mm7      ;; r[i] = LO(t0)
      psrlq    mm7,32                     ;; carry = HI(t0)
   endif

   movd     DWORD PTR [r+n*4],mm7         ;; r[n] = extension
ENDM

UPDATE_MUL MACRO r,a,n
   i = 1
   repeat (n-2)
      movd     mm0,DWORD PTR[a+i*4]       ;; a[i]
      pandn    mm7,mm7                    ;; clear carry

      j = i+1
      movd     mm1,DWORD PTR[a+j*4]       ;; a[j]
      pmuludq  mm1,mm0                    ;; t0 = a[j]*a[i]
      movd     mm3,DWORD PTR[r+(i+j)*4]   ;; r[i+j]
      if (j+1) lt n
      movd     mm2,DWORD PTR[a+j*4+4]     ;; a[j+1]
      pmuludq  mm2,mm0                    ;; t1 = a[j+1]*a[i]
      movd     mm4,DWORD PTR[r+(i+j)*4+4] ;; r[i+j+1]
      endif

      tn = n-j
      repeat tn/2
         paddq    mm7,mm1                       ;; t0 += carry+r[i+j]
         if n-(j+2) gt 0
            movd     mm1,DWORD PTR[a+(j+2)*4]   ;; read in advance a[j+2]
            pmuludq  mm1,mm0                    ;; multiply in advance a[j+2]*a[i]
         endif
         paddq    mm7,mm3
         if n-(j+2) gt 0
            movd     mm3,DWORD PTR[r+(i+2+j)*4] ;; read in advance r[i+j+2]
         endif
         movd     DWORD PTR [r+(i+j)*4],mm7     ;; r[i+j] = LO(t0)
         psrlq    mm7,32                        ;; carry = HI(t0)

         paddq    mm7,mm2                       ;; t1 += carry+r[i+j]
         if n-(j+3) gt 0
            movd     mm2,DWORD PTR[a+(j+2)*4+4] ;; read in advance a[j+3]
            pmuludq  mm2,mm0                    ;; multiply in advance a[j+3]*a[i]
         endif
         paddq    mm7,mm4
         if n-(j+3) gt 0
            movd     mm4,DWORD PTR[r+(i+2+j)*4+4];; read in advance r[i+j+3]
         endif
         movd     DWORD PTR [r+(i+j)*4+4],mm7   ;; r[i+j+1] = LO(t1)
         psrlq    mm7,32                        ;; carry = HI(t1)

         j = j+2
      endm

      if (tn and 1) ne 0
         paddq    mm7,mm1
         paddq    mm7,mm3
         movd     DWORD PTR [r+(i+j)*4],mm7
         psrlq    mm7,32                        ;; carry = HI(t1)
      endif

      movd     DWORD PTR [r+(n+i)*4],mm7     ;; r[i+j] = extension

      i = i+1
   endm

   pandn    mm7,mm7                       ;; clear carry
   movd     DWORD PTR [r+(2*n-1)*4],mm7   ;; r[2*n-1] = zero extension
ENDM


FINALIZE MACRO r,a,n
   i = 0
   movd     mm0,DWORD PTR [a+i*4]      ;; a[i]
   pmuludq  mm0,mm0                    ;; p = a[i]*a[i]

   movd     mm2,DWORD PTR [r+(2*i)*4]  ;; r[2*i]
   paddq    mm2,mm2
   movd     mm3,DWORD PTR [r+(2*i+1)*4];; r[2*i+1]
   paddq    mm3,mm3

   pcmpeqd  mm6,mm6                    ;; mm6 = low 32 bit mask
   psrlq    mm6,32

   pandn    mm7,mm7                    ;; clear carry

   repeat n
      movq     mm1,mm0
      pand     mm0,mm6                    ;; mm0 = LO(p)
      psrlq    mm1,32                     ;; mm1 = HI(p)

      paddq    mm7,mm0                    ;; q = carry + 2*r[2*i] + LO(p)
      if n-(i+1) gt 0
         movd     mm0,DWORD PTR [a+(i+1)*4]  ;; a[i]
         pmuludq  mm0,mm0                    ;; p = a[i]*a[i]
      endif
      paddq    mm7,mm2
      if n-(i+1) gt 0
         movd     mm2,DWORD PTR [r+(2*i+2)*4]  ;; r[2*(i+1)]
         paddq    mm2,mm2
      endif
      movd     DWORD PTR[r+(2*i)*4],mm7   ;; r[2*i] = LO(q)
      psrlq    mm7,32                     ;; carry = HI(q)

      paddq    mm7,mm1                    ;; q = carry + 2*r[2*i+1] + HI(p)
      paddq    mm7,mm3
      if n-(i+1) gt 0
         movd     mm3,DWORD PTR [r+(2*i+2)*4+4]  ;; r[2*(i+1)+1]
         paddq    mm3,mm3
      endif
      movd     DWORD PTR[r+(2*i+1)*4],mm7 ;; r[2*i+1] = LO(q)
      psrlq    mm7,32                     ;; carry = HI(q)

      i = i+1
   endm
ENDM

INIT1 MACRO r,a,n
   movd     mm0,DWORD PTR[a]              ;; a[0]
   pandn    mm7,mm7                       ;; clear carry
   movd     DWORD PTR[r],mm7              ;; r[0] = 0

   i = 1
   repeat (n-1)
      movd     mm1,DWORD PTR[a+i*4]       ;; a[i]
      pmuludq  mm1,mm0                    ;; t0 = a[i]*a[0]
      paddq    mm7,mm1                    ;; t0 += carry
      movd     DWORD PTR [r+i*4],mm7      ;; r[i] = LO(t0)
      psrlq    mm7,32                     ;; carry = HI(t0)
      i = i+1
   endm
   movd     DWORD PTR [r+n*4],mm7         ;; r[n] = extension
ENDM

UPDATE_MUL1 MACRO r,a,n
   i = 1
   repeat (n-2)
      movd     mm0,DWORD PTR[a+i*4]       ;; a[i]
      pandn    mm7,mm7                    ;; clear carry

      j = i+1
      repeat (n-j)
         movd     mm1,DWORD PTR[a+j*4]       ;; a[j]
         pmuludq  mm1,mm0                    ;; t0 = a[j]*a[i]
         movd     mm3,DWORD PTR[r+(i+j)*4]   ;; r[i+j]
         paddq    mm7,mm1                    ;; t0 += carry+r[i+j]
         paddq    mm7,mm3
         movd     DWORD PTR[r+(i+j)*4],mm7   ;; r[i+j] = LO(t0)
         psrlq    mm7,32                     ;; carry = HI(t0)
         j = j+1
      endm

      movd     DWORD PTR [r+(n+i)*4],mm7     ;; r[i+j] = extension
      i = i+1
   endm

   pandn    mm7,mm7                          ;; clear carry
   movd     DWORD PTR[r+(2*n-1)*4],mm7       ;; r[2*n-1] = zero extension
ENDM

SQUARE_SHORT MACRO r,a,n
   INIT        r,a,n
   UPDATE_MUL  r,a,n
   FINALIZE    r,a,n
   emms
ENDM


;;
;; Middle-Length Squaring
;;
SQR_DECOMPOSE MACRO i
   movd mm7,DWORD PTR[eax + 4*i]
   movd mm0,DWORD PTR[eax + 4*i]
   movd mm6,DWORD PTR[eax + 4*i]
   if i ne 0
      movd mm1,DWORD PTR[ebx + 4*(2*i)]
   endif
   pslld mm0,1
   pmuludq mm7,mm7
   psrad mm6,32
   if i ne 0
      paddq mm7,mm1
   endif
   movd DWORD PTR[ebx + 4*(2*i)],mm7
   psrlq mm7,32
ENDM


MULADD_START MACRO i,j
   movd mm1,DWORD PTR[eax + 4*j]
   movd mm3,DWORD PTR[eax + 4*j]
   pmuludq mm1,mm0
   paddq mm7,mm1
   movd DWORD PTR[ebx + 4*(i+j)],mm7
   pand mm3,mm6
   psrlq mm7,32
   paddq mm7,mm3
ENDM

MULADD MACRO i,j
   movd mm1,DWORD PTR[eax + 4*j]
   movd mm3,DWORD PTR[eax + 4*j]
   movd mm2,DWORD PTR[ebx + 4*(i+j)]
   pmuludq mm1,mm0
   pand mm3,mm6
   paddq mm1,mm2
   paddq mm7,mm1
   movd DWORD PTR[ebx + 4*(i+j)],mm7
   psrlq mm7,32
   paddq mm7,mm3
ENDM

STORE_CARRY MACRO i,s
   movq [ebx + 4*(i + s)],mm7
ENDM

STORE_CARRY_NEXT MACRO i,s
   movd mm4,DWORD PTR[ebx + 4*(i + s)]
   paddq mm4,mm7
   movd DWORD PTR[ebx + 4*(i + s)],mm4
   psrlq mm7,32
   movd DWORD PTR[ebx + 4*(i + s + 1)],mm7
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

LAST_STEP MACRO s
    movd mm7,DWORD PTR[eax + 4*(s - 1)]
    movd mm2,DWORD PTR[ebx + 4*(2*s - 2)]
    pmuludq mm7,mm7
    paddq mm7,mm2
    movd mm4,DWORD PTR[ebx + 4*(2*s - 1)]
    movd DWORD PTR[ebx + 4*(2*s - 2)],mm7
    psrlq mm7,32
    paddq mm4,mm7
    movd DWORD PTR[ebx + 4*(2*s - 1)],mm4
ENDM

SQUARE_MIDL MACRO nsize
   i = 0
   repeat nsize - 1
      INNER_LOOP i,nsize
      i = i + 1
   endm
   LAST_STEP nsize
   emms
ENDM

IF (_USE_C_cpSqrAdc_BNU_school_ EQ 0)

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;*************************************************************
;* void cpSqrAdc_BNU_school(Ipp32u* pR, const Ipp32u* pA, int aSize)
;*
;*************************************************************

;;
;; Lib = W7
;;
;; Caller = ippsMontMul
;; Caller = ippsMontExp
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
IPPASM cpSqrAdc_BNU_school PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; target address
      pA:   PTR DWORD,\  ; source address
      aSize:    DWORD   ; BNU length

   mov      eax,pA               ; src
   mov      ebx,pR               ; dst
   mov      ecx,aSize            ; length

;;
;; switch
;;
len1:
   cmp      ecx,1
   jg       len2

   movd     mm0,DWORD PTR [eax]
   pmuludq  mm0,mm0
   movq     QWORD PTR [ebx],mm0
   emms
   ret

len2:
   cmp      ecx,2
   jg       len3

   movd     mm0,DWORD PTR [eax]
   movd     mm1,DWORD PTR [eax+4]

   movq     mm2,mm0
   pmuludq  mm0,mm0              ; a[0]*a[0]
   pmuludq  mm2,mm1              ; a[0]*a[1]
   pmuludq  mm1,mm1              ; a[1]*a[1]

   pcmpeqd  mm7,mm7              ; mm7 = low 32 bit mask
   psrlq    mm7,32

   pand     mm7,mm2              ; mm7 = LO(a[0]*a[1])
   paddq    mm7,mm7
   psrlq    mm2,32               ; mm2 = HI(a[0]*a[1])
   paddq    mm2,mm2

   movd     DWORD PTR [ebx],mm0
   psrlq    mm0,32

   paddq    mm0,mm7
   movd     DWORD PTR [ebx+4],mm0
   psrlq    mm0,32

   paddq    mm2,mm1
   paddq    mm2,mm0
   movq     QWORD PTR [ebx+8],mm2

   emms
   ret

len3:
   cmp      ecx,3
   jg       len4
   SQUARE_SHORT ebx,eax,3
   ret

len4:
   cmp      ecx,4
   jg       len5
   SQUARE_SHORT ebx,eax,4
   ret

len5:
   cmp      ecx,5
   jg       len6
   SQUARE_SHORT ebx,eax,5
   ret

len6:
   cmp      ecx,6
   jg       len7
   SQUARE_SHORT ebx,eax,6
   ret

len7:
   cmp      ecx,7
   jg       len8
   SQUARE_SHORT ebx,eax,7
   ret

len8:
   cmp      ecx,8
   jg       len9
   ;SQUARE_MIDL 8
   SQUARE_SHORT ebx,eax,8
   ret

len9:
   cmp      ecx,9
   jg       len10
   ;SQUARE_MIDL 9
   SQUARE_SHORT ebx,eax,9
   ret

len10:
   cmp      ecx,10
   jg       len11
   ;SQUARE_MIDL 10
   SQUARE_SHORT ebx,eax,10
   ret

len11:
   cmp      ecx,11
   jg       len12
   ;SQUARE_MIDL 11
   SQUARE_SHORT ebx,eax,11
   ret

len12:
   cmp      ecx,12
   jg       len13
   ;SQUARE_MIDL 12
   SQUARE_SHORT ebx,eax,12
   ret

len13:
   cmp      ecx,13
   jg       len14
   ;SQUARE_MIDL 13
   SQUARE_SHORT ebx,eax,13
   ret

len14:
   cmp      ecx,14
   jg       len15
   ;SQUARE_MIDL 14
   SQUARE_SHORT ebx,eax,14
   ret

len15:
   cmp      ecx,15
   jg       len16
   ;SQUARE_MIDL 15
   SQUARE_SHORT ebx,eax,15
   ret

len16:
   cmp      ecx,16
   jg       len17
   ;SQUARE_MIDL 16
   SQUARE_SHORT ebx,eax,16
   ret

len17:
   cmp      ecx,17
   jg       common_case
   ;SQUARE_MIDL 17
   SQUARE_SHORT ebx,eax,17
   ret

;;
;; Ceneral case (aSize > 17)
;;
common_case:
;;
;; init result:
;;    r = (a[1],a[2],..a[N-1]) * a[0]
;;
   mov      edx,1                         ; i=1
   movd     mm0,DWORD PTR[eax]            ; a[0]
   movd     mm1,DWORD PTR[eax+edx*4]      ; a[i]
   pmuludq  mm1,mm0                       ; p = a[i]*a[0]
   pandn    mm7,mm7                       ; clear carry
   movd     DWORD PTR[ebx],mm7            ; r[0] = 0
init_loop:
   movd     mm2,DWORD PTR[eax+edx*4+4]    ; read in advance a[i+1]
   pmuludq  mm2,mm0                       ; q = a[i+1]*a[0]

   paddq    mm7,mm1                       ; p+= carry
   movd     DWORD PTR [ebx+edx*4],mm7     ; r[i] = LO(p)
   psrlq    mm7,32                        ; carry = HI(p)

   add      edx,2
   cmp      edx,ecx
   jg       break_init_loop

   movd     mm1,DWORD PTR[eax+edx*4]      ; next a[i]
   pmuludq  mm1,mm0                       ; p = a[i]*a[0]

   paddq    mm7,mm2                       ; q += carry
   movd     DWORD PTR [ebx+edx*4-4],mm7   ; r[i+1] = LO(q)
   psrlq    mm7,32                        ; carry = HI(q)

   jl       init_loop

break_init_loop:
   movd     DWORD PTR [ebx+ecx*4],mm7     ; r[aSize] = carry

;;
;; add other a[i]*a[j], i=1,..,N-1, j=i+1,..,N-1
;;
   mov      edx,1                         ; i=1

update_mul_loop:
   mov      esi,edx                       ; j=i+1
   add      esi,1
   mov      edi,edx                       ; i+j
   add      edi,esi

   movd     mm0,DWORD PTR[eax+edx*4]      ; a[i]
   movd     mm1,DWORD PTR[eax+esi*4]      ; a[j]
   pmuludq  mm1,mm0                       ; p = a[j]*a[i]
   movd     mm3,DWORD PTR[ebx+edi*4]      ; r[i+j]
   pandn    mm7,mm7                       ; clear carry

update_mul_inner_loop:
   paddq    mm7,mm1                       ; p += carry+r[i+j]
   paddq    mm7,mm3
   movd     DWORD PTR [ebx+edi*4],mm7     ; r[i+j] = LO(p)
   psrlq    mm7,32                        ; carry = HI(p)

   movd     mm1,DWORD PTR[eax+esi*4+4]    ; read in advance a[i+1]
   pmuludq  mm1,mm0                       ; p = a[j+1]*a[i]
   movd     mm3,DWORD PTR[ebx+edi*4+4]    ; read in advance r[i+j+1]

   add      edi,1
   add      esi,1
   cmp      esi,ecx
   jl       update_mul_inner_loop

   movd     DWORD PTR [ebx+edi*4],mm7     ; r[i+j] = carry
   add      edx,1
   sub      esi,1
   cmp      edx,esi
   jl       update_mul_loop
   pandn    mm7,mm7                       ; clear carry
   movd     DWORD PTR [ebx+edi*4+4],mm7   ; r[i+j+1] = 0

;;
;; double a[i]*a[j] and add a[i]^2
;;
   pcmpeqd  mm6,mm6                       ; mm6 = low 32 bit mask
   psrlq    mm6,32

   movd     mm0,DWORD PTR [eax]           ; a[i]
   pmuludq  mm0,mm0                       ; p = a[i]*a[i]
   mov      edx,0                         ; i=0
   movd     mm2,DWORD PTR [ebx]           ; r[2*i]
   movd     mm3,DWORD PTR [ebx+4]         ; r[2*i+1]
   pandn    mm7,mm7                       ; clear carry
sqr_loop:
   paddq    mm2,mm2                       ; 2*r[2*i]
   paddq    mm3,mm3                       ; 2*r[2*i+1]

   movq     mm1,mm0
   pand     mm0,mm6                       ; mm0 = LO(p)
   psrlq    mm1,32                        ; mm1 = HI(p)

   paddq    mm7,mm2                       ; q = carry + 2*r[2*i] + LO(p)
   paddq    mm7,mm0
   movd     DWORD PTR[ebx+edx*8],mm7      ; r[2*i] = LO(q)
   psrlq    mm7,32                        ; carry = HI(q)

   movd     mm0,DWORD PTR [eax+edx*4+4]   ; read in advance a[i+1]
   pmuludq  mm0,mm0                       ; p = a[i+1]*a[i+1]

   paddq    mm7,mm3                       ; q = carry + 2*r[2*i+1] + HI(p)
   paddq    mm7,mm1
   movd     DWORD PTR[ebx+edx*8+4],mm7    ; r[2*i+1] = LO(q)
   psrlq    mm7,32                        ; carry = HI(q)

   add      edx,1
   movd     mm2,DWORD PTR [ebx+edx*8]     ; r[2*(i+1)]
   movd     mm3,DWORD PTR [ebx+edx*8+4]   ; r[2*(i+1)+1]
   cmp      edx,ecx
   jl       sqr_loop

   emms
   ret
IPPASM cpSqrAdc_BNU_school endp
ENDIF

ENDIF
END
