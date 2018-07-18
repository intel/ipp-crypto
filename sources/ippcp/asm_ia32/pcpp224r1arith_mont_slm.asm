;===============================================================================
; Copyright 2016-2018 Intel Corporation
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
;               P224r1 basic arithmetic function
;
;     Content:
;      p224r1_add
;      p224r1_sub
;      p224r1_neg
;      p224r1_div_by_2
;      p224r1_mul_mont_slm
;      p224r1_sqr_mont_slm
;      p224r1_mred
;      p224r1_mont_back
;      p224r1_select_pp_w5
;      p224r1_select_ap_w7
;

.686P
.387
.XMM
.MODEL FLAT,C

include asmdefs.inc
include ia_emm.inc

IF (_IPP GE _IPP_P8)

IFDEF IPP_PIC
LD_ADDR MACRO reg:REQ, addr:REQ
LOCAL LABEL
        call     LABEL
LABEL:  pop      reg
        sub      reg, LABEL-addr
ENDM
ELSE
LD_ADDR MACRO reg:REQ, addr:REQ
        lea      reg, addr
ENDM
ENDIF


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;;
;; some p224r1 constants
;;
p224r1_data:
_prime224r1 DD 000000001h,000000000h,000000000h,0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh

LEN224 = (224/32) ; dword's length of operands


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Ipp32u add_224(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
;; input:   edi = r
;;          esi = a
;;          ebx = b
;;
;; output:  eax = carry = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM add_224 PROC NEAR PRIVATE
      ; r = a+b
      mov   eax, dword ptr[esi]
      add   eax, dword ptr[ebx]
      mov   dword ptr[edi], eax

      mov   eax, dword ptr[esi+sizeof(dword)]
      adc   eax, dword ptr[ebx+sizeof(dword)]
      mov   dword ptr[edi+sizeof(dword)], eax

      mov   eax, dword ptr[esi+sizeof(dword)*2]
      adc   eax, dword ptr[ebx+sizeof(dword)*2]
      mov   dword ptr[edi+sizeof(dword)*2], eax

      mov   eax, dword ptr[esi+sizeof(dword)*3]
      adc   eax, dword ptr[ebx+sizeof(dword)*3]
      mov   dword ptr[edi+sizeof(dword)*3], eax

      mov   eax, dword ptr[esi+sizeof(dword)*4]
      adc   eax, dword ptr[ebx+sizeof(dword)*4]
      mov   dword ptr[edi+sizeof(dword)*4], eax

      mov   eax, dword ptr[esi+sizeof(dword)*5]
      adc   eax, dword ptr[ebx+sizeof(dword)*5]
      mov   dword ptr[edi+sizeof(dword)*5], eax

      mov   eax, dword ptr[esi+sizeof(dword)*6]
      adc   eax, dword ptr[ebx+sizeof(dword)*6]
      mov   dword ptr[edi+sizeof(dword)*6], eax

      mov   eax, 0
      adc   eax, 0
      ret
IPPASM add_224 ENDP

;;
;; Ipp32u sub_224(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
;; input:   edi = r
;;          esi = a
;;          ebx = b
;;
;; output:  eax = borrow = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sub_224 PROC NEAR PRIVATE
      ; r = a-b
      mov   eax, dword ptr[esi]
      sub   eax, dword ptr[ebx]
      mov   dword ptr[edi], eax

      mov   eax, dword ptr[esi+sizeof(dword)]
      sbb   eax, dword ptr[ebx+sizeof(dword)]
      mov   dword ptr[edi+sizeof(dword)], eax

      mov   eax, dword ptr[esi+sizeof(dword)*2]
      sbb   eax, dword ptr[ebx+sizeof(dword)*2]
      mov   dword ptr[edi+sizeof(dword)*2], eax

      mov   eax, dword ptr[esi+sizeof(dword)*3]
      sbb   eax, dword ptr[ebx+sizeof(dword)*3]
      mov   dword ptr[edi+sizeof(dword)*3], eax

      mov   eax, dword ptr[esi+sizeof(dword)*4]
      sbb   eax, dword ptr[ebx+sizeof(dword)*4]
      mov   dword ptr[edi+sizeof(dword)*4], eax

      mov   eax, dword ptr[esi+sizeof(dword)*5]
      sbb   eax, dword ptr[ebx+sizeof(dword)*5]
      mov   dword ptr[edi+sizeof(dword)*5], eax

      mov   eax, dword ptr[esi+sizeof(dword)*6]
      sbb   eax, dword ptr[ebx+sizeof(dword)*6]
      mov   dword ptr[edi+sizeof(dword)*6], eax

      mov   eax, 0
      adc   eax, 0
      ret
IPPASM sub_224 ENDP

;;
;; Ipp32u shl_224(Ipp32u* r, const Ipp32u* a)
;;
;; input:   edi = r
;;          esi = a
;;
;; output:  eax = extension = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM shl_224 PROC NEAR PRIVATE
      ; r = a<<1
      movdqu   xmm0, oword ptr[esi]
      movdqu   xmm1, oword ptr[esi+LEN224*sizeof(dword)-sizeof(oword)]
      mov      eax, dword ptr[esi+(LEN224-1)*sizeof(dword)]
      psrldq   xmm1, sizeof(dword)

      movdqa   xmm2, xmm0
      psllq    xmm0, 1
      psrlq    xmm2, 63
      movdqa   xmm3, xmm1
      psllq    xmm1, 1
      psrlq    xmm3, 63

      palignr  xmm3, xmm2, sizeof(qword)
      pslldq   xmm2, sizeof(qword)

      por      xmm1, xmm3
      por      xmm0, xmm2
      movdqu   oword ptr[edi], xmm0
      movq     qword ptr[edi+sizeof(oword)], xmm1
      psrldq   xmm1, sizeof(qword)
      movd     dword ptr[edi+sizeof(oword)+sizeof(qword)], xmm1

      shr     eax, 31
      ret
IPPASM shl_224 ENDP

;;
;; void shr_224(Ipp32u* r, const Ipp32u* a)
;;
;; input:   edi = r
;;          esi = a
;;          eax = ext
;; output:  eax = extension = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM shr_224 PROC NEAR PRIVATE
      ; r = a>>1
      movdqu   xmm0, oword ptr[esi]
      movdqu   xmm2, oword ptr[esi+LEN224*sizeof(dword)-sizeof(oword)]
      movd     xmm1, eax
      palignr  xmm1, xmm2, sizeof(dword)

      movdqa   xmm2, xmm0
      psrlq    xmm0, 1
      psllq    xmm2, 63
      movdqa   xmm3, xmm1
      psrlq    xmm1, 1
      psllq    xmm3, 63

      movdqa   xmm4, xmm3
      palignr  xmm3, xmm2, sizeof(qword)
      psrldq   xmm4, sizeof(qword)

      por      xmm0, xmm3
      por      xmm1, xmm4
      movdqu   oword ptr[edi], xmm0
      movq     qword ptr[edi+sizeof(oword)], xmm1
      psrldq   xmm1, sizeof(qword)
      movd     dword ptr[edi+sizeof(oword)+sizeof(qword)], xmm1

      ret
IPPASM shr_224 ENDP

;;
;; void cpy_224(Ipp32u* r, const Ipp32u* a)
;;
cpy_224 MACRO pdst:REQ,psrc:REQ
   movdqu   xmm0, oword ptr[psrc]
   movq     xmm1, qword ptr[psrc+sizeof(oword)]
   movd     xmm2, dword ptr[psrc+sizeof(oword)+sizeof(qword)]
   movdqu   oword ptr[pdst], xmm0
   movq     qword ptr[pdst+sizeof(oword)], xmm1
   movd     dword ptr[pdst+sizeof(oword)+sizeof(qword)], xmm2
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_add(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_add PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD,\  ; source A address
      pB:   PTR DWORD   ; source B address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN224]
_sp_   = _buf_+(LEN224)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      mov      edi, pR                 ; pR
      mov      esi, pA                 ; pA
      mov      ebx, pB                 ; pB
      CALLASM  add_224                 ; R = A+B
      mov      edx, eax

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  sub_224                 ; T = R-modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      sub      edx, eax                ; R = T<0? R : T
      cmovnz   esi, edi
      cpy_224  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_add ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_sub(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_sub PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD,\  ; source A address
      pB:   PTR DWORD   ; source B address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN224]
_sp_   = _buf_+(LEN224)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      mov      edi, pR                 ; pR
      mov      esi, pA                 ; pA
      mov      ebx, pB                 ; pB
      CALLASM  sub_224                 ; R = A-B
      mov      edx, eax

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  add_224                 ; T = R+modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      test     edx, edx                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_224  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_sub ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_neg(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_neg PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN224]
_sp_   = _buf_+(LEN224)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      mov   edi, pR                    ; outpur pR
      mov   esi, pA                    ; input pA

      ; r = 0-a
      mov   eax, 0
      sub   eax, dword ptr[esi]
      mov   dword ptr[edi], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)]
      mov   dword ptr[edi+sizeof(dword)], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*2]
      mov   dword ptr[edi+sizeof(dword)*2], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*3]
      mov   dword ptr[edi+sizeof(dword)*3], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*4]
      mov   dword ptr[edi+sizeof(dword)*4], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*5]
      mov   dword ptr[edi+sizeof(dword)*5], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*6]
      mov   dword ptr[edi+sizeof(dword)*6], eax
      sbb   edx,edx

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  add_224                 ; T = R+modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      test     edx, edx                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_224  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_neg ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_mul_by_2(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_by_2 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN224]
_sp_   = _buf_+(LEN224)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pA                 ; pA
      CALLASM  shl_224                 ; T = A<<1
      mov      edx, eax

      mov      esi, edi                ; T
      mov      edi, pR                 ; R
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  sub_224                 ; R = T-modulus

      sub      edx, eax                ; R = R<0? T : R
      cmovz    esi, edi
      cpy_224  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_mul_by_2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_mul_by_3(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_by_3 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_bufT_ = 0                             ; T buffer[LEN224]
_bufU_ = _bufT_+(LEN224)*sizeof(dword) ; U buffer[LEN224]
_mod_  = _bufU_+(LEN224)*sizeof(dword) ; modulus address [1]
_sp_   = _mod_+sizeof(dword)           ; esp [1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      LD_ADDR  eax, p224r1_data        ; srore modulus address
      lea      eax, dword ptr[eax+(_prime224r1-p224r1_data)]
      mov      dword ptr[esp+_mod_], eax

      lea      edi, [esp+_bufT_]       ; T
      mov      esi, pA                 ; A
      CALLASM  shl_224                 ; T = A<<1
      mov      edx, eax

      mov      esi, edi                ; T
      lea      edi, [esp+_bufU_]       ; U
      mov      ebx, [esp+_mod_]        ; modulus
      CALLASM  sub_224                 ; U = T-modulus

      sub      edx, eax                ; T = U<0? T : U
      cmovz    esi, edi
      cpy_224  edi, esi

      mov      esi, edi
      mov      ebx, pA
      CALLASM  add_224                 ; T +=A
      mov      edx, eax

      mov      edi, pR                 ; R
      mov      ebx, [esp+_mod_]        ; modulus
      CALLASM  sub_224                 ; R = T-modulus

      sub      edx, eax                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_224  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_mul_by_3 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_div_by_2(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_div_by_2 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN224]
_sp_   = _buf_+(LEN224)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pA                 ; A
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  add_224                 ; R = A+modulus
      mov      edx, 0

      mov      ecx, dword ptr[esi]     ; shifted_data = (a[0]&1)? T : A
      and      ecx, 1
      cmovnz   esi, edi
      cmovz    eax, edx
      mov      edi, pR
      CALLASM  shr_224

      mov      esp, [esp+_sp_]
      ret
IPPASM p224r1_div_by_2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_mul_mont_slm(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_mont_slm PROC NEAR C PUBLIC \
      USES ebp ebx esi edi,\
      pR:   PTR DWORD,\    ; product address
      pA:   PTR DWORD,\    ; source A address
      pB:   PTR DWORD     ; source B address
;
; stack layout:
;
_buf_    = 0
_rp_     = _buf_+(LEN224+1)*sizeof(dword) ; pR
_ap_     = _rp_ +sizeof(dword)            ; pA
_bp_     = _ap_+sizeof(dword)             ; pB
_sp_     = _bp_+sizeof(dword)             ; esp storage
_ssize_  = _sp_+sizeof(dword)             ; size allocated stack

      mov   eax, esp                   ; save esp
      sub   esp, _ssize_               ; allocate stack
      and   esp, -16                   ; provide 16-byte stack alignment
      mov   dword ptr[esp+_sp_], eax   ; store original esp

      ; clear buffer
      pxor  mm0, mm0
      movq  [esp+_buf_], mm0
      movq  [esp+_buf_+sizeof(qword)], mm0
      movq  [esp+_buf_+sizeof(qword)*2], mm0
      movq  [esp+_buf_+sizeof(qword)*3], mm0

      ; store parameters into the stack
      mov   edi, pR
      mov   esi, pA
      mov   ebp, pB
      mov   dword ptr[esp+_rp_], edi
      mov   dword ptr[esp+_ap_], esi
      mov   dword ptr[esp+_bp_], ebp

      mov   edi, LEN224

      movd  mm1, dword ptr[esi+sizeof(dword)]      ; pre load a[1], a[2], a[3], a[4]
      movd  mm2, dword ptr[esi+sizeof(dword)*2]
      movd  mm3, dword ptr[esi+sizeof(dword)*3]
      movd  mm4, dword ptr[esi+sizeof(dword)*4]

ALIGN IPP_ALIGN_FACTOR
mmul_loop:
;
; i-st pass
; modulus = 2^224 -2^96 +1
;           [7]    [3]  [0]
; m0 = 1
;
      movd     mm7, edi                   ; save pass counter

      mov      edx, dword ptr[ebp]        ; b = b[i]
      mov      eax, dword ptr[esi]        ; a[0]
      movd     mm0, edx
      add      ebp, sizeof(dword)
      mov      dword ptr[esp+_bp_], ebp

      pmuludq  mm1, mm0                   ; a[1]*b[i]
      pmuludq  mm2, mm0                   ; a[2]*b[i]

      mul      edx                        ; (E:u) = (edx:eax) = a[0]*b[i]+buf[0]
      add      eax, dword ptr[esp+_buf_]
      adc      edx, 0

      pmuludq  mm3, mm0                   ; a[3]*b[i]
      pmuludq  mm4, mm0                   ; a[4]*b[i]

; multiplication round 1 - round 4
      movd     ecx, mm1                   ; p = a[1]*b[i] + E
      psrlq    mm1, 32
      add      ecx, edx
      movd     edx, mm1
      adc      edx, 0
      add      ecx, dword ptr[esp+_buf_+sizeof(dword)*1]
      movd     mm1, dword ptr[esi+sizeof(dword)*5]
      adc      edx, 0

      movd     ebx, mm2                   ; p = a[2]*b[i] + E
      psrlq    mm2, 32
      add      ebx, edx
      movd     edx, mm2
      adc      edx, 0
      add      ebx, dword ptr[esp+_buf_+sizeof(dword)*2]
      movd     mm2, dword ptr[esi+sizeof(dword)*6]
      adc      edx, 0

      pmuludq  mm1, mm0                   ; a[5]*b[i]
      pmuludq  mm2, mm0                   ; a[6]*b[i]

      movd     ebp, mm3                   ; p = a[3]*b[i] + E
      psrlq    mm3, 32
      add      ebp, edx
      movd     edx, mm3
      adc      edx, 0
      add      ebp, dword ptr[esp+_buf_+sizeof(dword)*3]
      adc      edx, 0

      movd     edi, mm4                   ; p = a[4]*b[i] + E
      psrlq    mm4, 32
      add      edi, edx
      movd     edx, mm4
      adc      edx, 0
      add      edi, dword ptr[esp+_buf_+sizeof(dword)*4]
      adc      edx, 0

;;; and reduction ;;;
      neg      eax                                          ; u0

      adc      ecx, 0                                       ; +cf
      mov      dword ptr[esp+_buf_+sizeof(dword)*0], ecx
      adc      ebx, 0                                       ; +cf
      mov      dword ptr[esp+_buf_+sizeof(dword)*1], ebx

      mov      ecx, eax                                     ; save u0

      sbb      eax, 0                                       ; u0-cf
      sub      ebp, eax                                     ; -u0+cf
      mov      dword ptr[esp+_buf_+sizeof(dword)*2], ebp

      mov      eax, ecx                                     ; restore u0
      mov      ebp, 0

      sbb      edi, 0                                       ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*3], edi
      adc      ebp, 0                                      ; save bf

; multiplication round 5 - round 6
      movd     ecx, mm1                   ; p = a[5]*b[i] + E
      psrlq    mm1, 32
      add      ecx, edx
      movd     edx, mm1
      adc      edx, 0
      add      ecx, dword ptr[esp+_buf_+sizeof(dword)*5]
      adc      edx, 0

      movd     ebx, mm2                   ; p = a[6]*b[i] + E
      psrlq    mm2, 32
      add      ebx, edx
      movd     edx, mm2
      adc      edx, 0
      add      ebx, dword ptr[esp+_buf_+sizeof(dword)*6]
      adc      edx, 0

;;; and reduction ;;;
      sub      ecx, ebp                                  ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*4], ecx
      sbb      ebx, 0                                    ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*5], ebx

; last multiplication round 7
      movd     edi, mm7                   ; restore pass counter

      sbb      eax, 0                     ; u-bf
      mov      ebx, 0

      add      edx, dword ptr[esp+_buf_+sizeof(dword)*7]
      adc      ebx, 0
      add      edx, eax
      mov      dword ptr[esp+_buf_+sizeof(dword)*6], edx
      adc      ebx, 0
      mov      dword ptr[esp+_buf_+sizeof(dword)*7], ebx

      sub      edi, 1
      movd  mm1, dword ptr[esi+sizeof(dword)]               ; speculative load a[1], a[2], a[3], a[4]
      movd  mm2, dword ptr[esi+sizeof(dword)*2]
      movd  mm3, dword ptr[esi+sizeof(dword)*3]
      movd  mm4, dword ptr[esi+sizeof(dword)*4]
      jz       exit_mmul_loop

      mov      ebp, dword ptr[esp+_bp_]            ; restore pB
      jmp      mmul_loop

exit_mmul_loop:
      emms

; final reduction
      mov      edi, [esp+_rp_]         ; result
      lea      esi, [esp+_buf_]        ; buffer
      LD_ADDR  ebx, p224r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
      CALLASM  sub_224
      mov      edx, dword ptr[esp+_buf_+LEN224*sizeof(dword)]
      sub      edx, eax

; copy
      cmovz    esi, edi
      cpy_224  edi, esi

      mov   esp, [esp+_sp_]            ; release stack
      ret
IPPASM p224r1_mul_mont_slm ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_sqr_mont_slm(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_sqr_mont_slm PROC NEAR C PUBLIC \
      USES esi edi,\
      pR:   PTR DWORD,\    ; product address
      pA:   PTR DWORD     ; source A address

      ;; use p224r1_mul_mont_slm to compute sqr
      mov   esi, pA
      mov   edi, pR
      push  esi
      push  esi
      push  edi
      callasm  p224r1_mul_mont_slm
      add   esp, sizeof(dword)*3
      ret
IPPASM p224r1_sqr_mont_slm ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_mred(Ipp32u* r, Ipp32u* prod)
;;
; modulus = 2^224 -2^96 +1
;           [7]   [3]   [0]
; m0 = -1
;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mred PROC NEAR C PUBLIC \
      USES  ebx esi edi,\
      pR:   PTR DWORD,\    ; reduction address
      pA:   PTR DWORD     ; source product address

   ; get parameters:
   mov   esi, pA

   mov   ecx, LEN224
   xor   edx, edx
ALIGN IPP_ALIGN_FACTOR
mred_loop:
   mov   eax, dword ptr[esi]
   neg   eax

   mov   ebx, 0
   mov   dword ptr[esi], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)]
   adc   ebx, 0
   mov   dword ptr[esi+sizeof(dword)], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*2]
   adc   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*2], ebx

   push  eax
   mov   ebx, dword ptr[esi+sizeof(dword)*3]
   sbb   eax, 0
   sub   ebx, eax
   mov   dword ptr[esi+sizeof(dword)*3], ebx
   pop   eax

   mov   ebx, dword ptr[esi+sizeof(dword)*4]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*4], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*5]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*5], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*6]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*6], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*7]
   sbb   eax, 0
   add   eax, edx
   mov   edx, 0
   adc   edx, 0
   add   ebx, eax
   mov   dword ptr[esi+sizeof(dword)*7], ebx
   adc   edx, 0

   lea   esi, [esi+sizeof(dword)]
   sub   ecx, 1
   jnz   mred_loop

   ; final reduction
   mov      edi, pR           ; result
   LD_ADDR  ebx, p224r1_data  ; addres of the modulus
   lea      ebx, dword ptr[ebx+(_prime224r1-p224r1_data)]
   CALLASM  sub_224

   sub      edx, eax
   cmovz    esi, edi
   cpy_224  edi, esi

   ret
IPPASM p224r1_mred ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p224r1_select_pp_w5(P224_POINT *val, const P224_POINT *inTbl, int index)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_select_pp_w5 PROC NEAR C PUBLIC \
      USES esi edi,\
      pP:   PTR DWORD,\     ; pointer to output projective point
      pTbl: PTR DWORD,\     ; address of the table
      idx:      DWORD      ; index in the table

      pxor     xmm0, xmm0
      mov      edi, pP
      mov      esi, pTbl

      mov      eax, idx          ; broadcast input index
      movd     xmm7, eax
      pshufd   xmm7, xmm7, 00000000b

      mov      edx, 1            ; broadcast index increment index
      movd     xmm6, edx
      pshufd   xmm6, xmm6, 00000000b

      movdqa   oword ptr[edi], xmm0                   ; clear P
      movdqa   oword ptr[edi+sizeof(oword)], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*2], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*3], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*4], xmm0
      pxor     xmm3, xmm3

      ; skip index = 0, is implicictly infty -> load with offset -1
      movdqa   xmm5, xmm6           ; current_idx
      mov      ecx, (1 SHL (5-1))
ALIGN IPP_ALIGN_FACTOR
select_loop:
      movdqa   xmm4, xmm5
      pcmpeqd  xmm4, xmm7     ; mask = current_idx==idx? 0xFF : 0x00

      movdqu   xmm0, oword ptr[esi]
      pand     xmm0, xmm4
      por      xmm0, oword ptr[edi]
      movdqa   oword ptr[edi], xmm0

      movdqu   xmm1, oword ptr[esi+sizeof(oword)]
      pand     xmm1, xmm4
      por      xmm1, oword ptr[edi+sizeof(oword)]
      movdqa   oword ptr[edi+sizeof(oword)], xmm1

      movdqu   xmm0, oword ptr[esi+sizeof(oword)*2]
      pand     xmm0, xmm4
      por      xmm0, oword ptr[edi+sizeof(oword)*2]
      movdqa   oword ptr[edi+sizeof(oword)*2], xmm0

      movdqu   xmm1, oword ptr[esi+sizeof(oword)*3]
      pand     xmm1, xmm4
      por      xmm1, oword ptr[edi+sizeof(oword)*3]
      movdqa   oword ptr[edi+sizeof(oword)*3], xmm1

      movdqu   xmm0, oword ptr[esi+sizeof(oword)*4]
      pand     xmm0, xmm4
      por      xmm0, oword ptr[edi+sizeof(oword)*4]
      movdqa   oword ptr[edi+sizeof(oword)*4], xmm0

      movd     xmm1, dword ptr[esi+sizeof(oword)*5]
      pand     xmm1, xmm4
      por      xmm3, xmm1

      paddd    xmm5, xmm6     ; increment current_idx
      add      esi, sizeof(dword)*LEN224*3
      sub      ecx, 1
      jnz      select_loop

      movd     dword ptr[edi+sizeof(oword)*5], xmm3
      ret
IPPASM p224r1_select_pp_w5 ENDP

ENDIF    ;; _IPP GE _IPP_P8
END
