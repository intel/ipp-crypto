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
;               P384r1 basic arithmetic function
;
;     Content:
;      p384r1_add
;      p384r1_sub
;      p384r1_neg
;      p384r1_div_by_2
;      p384r1_mul_mont_slm
;      p384r1_sqr_mont_slm
;      p384r1_mred
;      p384r1_select_pp_w5
;      p384r1_select_ap_w5
;

.686P
.387
.XMM
.MODEL FLAT,C

include asmdefs.inc
include ia_emm.inc
include pcpvariant.inc

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
;; some p384r1 constants
;;
p384r1_data:
_prime384r1 DD 0FFFFFFFFh,000000000h,000000000h,0FFFFFFFFh,0FFFFFFFEh,0FFFFFFFFh
            DD 0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh,0FFFFFFFFh

LEN384 = (384/32) ; dword's length of operands

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Ipp32u add_384(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
;; input:   edi = r
;;          esi = a
;;          ebx = b
;;
;; output:  eax = carry = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM add_384 PROC NEAR PRIVATE
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

      mov   eax, dword ptr[esi+sizeof(dword)*7]
      adc   eax, dword ptr[ebx+sizeof(dword)*7]
      mov   dword ptr[edi+sizeof(dword)*7], eax

      mov   eax, dword ptr[esi+sizeof(dword)*8]
      adc   eax, dword ptr[ebx+sizeof(dword)*8]
      mov   dword ptr[edi+sizeof(dword)*8], eax

      mov   eax, dword ptr[esi+sizeof(dword)*9]
      adc   eax, dword ptr[ebx+sizeof(dword)*9]
      mov   dword ptr[edi+sizeof(dword)*9], eax

      mov   eax, dword ptr[esi+sizeof(dword)*10]
      adc   eax, dword ptr[ebx+sizeof(dword)*10]
      mov   dword ptr[edi+sizeof(dword)*10], eax

      mov   eax, dword ptr[esi+sizeof(dword)*11]
      adc   eax, dword ptr[ebx+sizeof(dword)*11]
      mov   dword ptr[edi+sizeof(dword)*11], eax
      mov   eax, 0
      adc   eax, 0
      ret
IPPASM add_384 ENDP

;;
;; Ipp32u sub_384(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
;; input:   edi = r
;;          esi = a
;;          ebx = b
;;
;; output:  eax = borrow = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sub_384 PROC NEAR PRIVATE
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

      mov   eax, dword ptr[esi+sizeof(dword)*7]
      sbb   eax, dword ptr[ebx+sizeof(dword)*7]
      mov   dword ptr[edi+sizeof(dword)*7], eax

      mov   eax, dword ptr[esi+sizeof(dword)*8]
      sbb   eax, dword ptr[ebx+sizeof(dword)*8]
      mov   dword ptr[edi+sizeof(dword)*8], eax

      mov   eax, dword ptr[esi+sizeof(dword)*9]
      sbb   eax, dword ptr[ebx+sizeof(dword)*9]
      mov   dword ptr[edi+sizeof(dword)*9], eax

      mov   eax, dword ptr[esi+sizeof(dword)*10]
      sbb   eax, dword ptr[ebx+sizeof(dword)*10]
      mov   dword ptr[edi+sizeof(dword)*10], eax

      mov   eax, dword ptr[esi+sizeof(dword)*11]
      sbb   eax, dword ptr[ebx+sizeof(dword)*11]
      mov   dword ptr[edi+sizeof(dword)*11], eax
      mov   eax, 0
      adc   eax, 0
      ret
IPPASM sub_384 ENDP

;;
;; Ipp32u shl_384(Ipp32u* r, const Ipp32u* a)
;;
;; input:   edi = r
;;          esi = a
;;
;; output:  eax = extension = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM shl_384 PROC NEAR PRIVATE
      mov      eax, dword ptr[esi+(LEN384-1)*sizeof(dword)]
      ; r = a<<1
      movdqu   xmm3, oword ptr[esi+sizeof(oword)*2]
      movdqu   xmm2, oword ptr[esi+sizeof(oword)]
      movdqu   xmm1, oword ptr[esi]

      movdqa   xmm4, xmm3
      palignr  xmm4, xmm2, sizeof(qword)
      psllq    xmm3, 1
      psrlq    xmm4, 63
      por      xmm3, xmm4
      movdqu   oword ptr[edi+sizeof(oword)*2], xmm3

      movdqa   xmm4, xmm2
      palignr  xmm4, xmm1, sizeof(qword)
      psllq    xmm2, 1
      psrlq    xmm4, 63
      por      xmm2, xmm4
      movdqu   oword ptr[edi+sizeof(oword)], xmm2

      movdqa   xmm4, xmm1
      pslldq   xmm4, sizeof(qword)
      psllq    xmm1, 1
      psrlq    xmm4, 63
      por      xmm1, xmm4
      movdqu   oword ptr[edi], xmm1

      shr     eax, 31
      ret
IPPASM shl_384 ENDP

;;
;; void shr_384(Ipp32u* r, const Ipp32u* a)
;;
;; input:   edi = r
;;          esi = a
;;          eax = ext
;; output:  eax = extension = 0/1
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM shr_384 PROC NEAR PRIVATE
      ; r = a>>1
      movdqu   xmm3, oword ptr[esi]
      movdqu   xmm2, oword ptr[esi+sizeof(oword)]
      movdqu   xmm1, oword ptr[esi+sizeof(oword)*2]

      movdqa   xmm4, xmm2
      palignr  xmm4, xmm3, sizeof(qword)
      psrlq    xmm3, 1
      psllq    xmm4, 63
      por      xmm3, xmm4
      movdqu   oword ptr[edi], xmm3

      movdqa   xmm4, xmm1
      palignr  xmm4, xmm2, sizeof(qword)
      psrlq    xmm2, 1
      psllq    xmm4, 63
      por      xmm2, xmm4
      movdqu   oword ptr[edi+sizeof(oword)], xmm2

      movdqa   xmm4, xmm0
      palignr  xmm4, xmm1, sizeof(qword)
      psrlq    xmm1, 1
      psllq    xmm4, 63
      por      xmm1, xmm4
      movdqu   oword ptr[edi+sizeof(oword)*2], xmm1

      ret
IPPASM shr_384 ENDP

;;
;; void cpy_384(Ipp32u* r, const Ipp32u* a)
;;
cpy_384 MACRO pdst:REQ,psrc:REQ
   movdqu   xmm0, oword ptr[psrc]
   movdqu   xmm1, oword ptr[psrc+sizeof(oword)]
   movdqu   xmm2, oword ptr[psrc+sizeof(oword)*2]
   movdqu   oword ptr[pdst], xmm0
   movdqu   oword ptr[pdst+sizeof(oword)], xmm1
   movdqu   oword ptr[pdst+sizeof(oword)*2], xmm2
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_add(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_add PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD,\  ; source A address
      pB:   PTR DWORD   ; source B address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN384]
_sp_   = _buf_+(LEN384)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      mov      edi, pR                 ; pR
      mov      esi, pA                 ; pA
      mov      ebx, pB                 ; pB
      CALLASM  add_384                 ; R = A+B
      mov      edx, eax

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  sub_384                 ; T = R-modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      sub      edx, eax                ; R = T<0? R : T
      cmovnz   esi, edi
      cpy_384  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_add ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_sub(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_sub PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD,\  ; source A address
      pB:   PTR DWORD   ; source B address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN384]
_sp_   = _buf_+(LEN384)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      mov      edi, pR                 ; pR
      mov      esi, pA                 ; pA
      mov      ebx, pB                 ; pB
      CALLASM  sub_384                 ; R = A-B
      mov      edx, eax

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  add_384                 ; T = R+modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      test     edx, edx                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_384  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_sub ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_neg(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_neg PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN384]
_sp_   = _buf_+(LEN384)*sizeof(dword)  ; esp[1]
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
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*7]
      mov   dword ptr[edi+sizeof(dword)*7], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*8]
      mov   dword ptr[edi+sizeof(dword)*8], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*9]
      mov   dword ptr[edi+sizeof(dword)*9], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*10]
      mov   dword ptr[edi+sizeof(dword)*10], eax
      mov   eax, 0
      sbb   eax, dword ptr[esi+sizeof(dword)*11]
      mov   dword ptr[edi+sizeof(dword)*11], eax
      sbb   edx,edx

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pR                 ; R
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  add_384                 ; T = R+modulus

      lea      esi,[esp+_buf_]
      mov      edi, pR
      test     edx, edx                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_384  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_neg ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_mul_by_2(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mul_by_2 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN384]
_sp_   = _buf_+(LEN384)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pA                 ; pA
      CALLASM  shl_384                 ; T = A<<1
      mov      edx, eax

      mov      esi, edi                ; T
      mov      edi, pR                 ; R
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  sub_384                 ; R = T-modulus

      sub      edx, eax                ; R = R<0? T : R
      cmovz    esi, edi
      cpy_384  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_mul_by_2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_mul_by_3(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mul_by_3 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_bufT_ = 0                             ; T buffer[LEN384]
_bufU_ = _bufT_+(LEN384)*sizeof(dword) ; U buffer[LEN384]
_mod_  = _bufU_+(LEN384)*sizeof(dword) ; modulus address [1]
_sp_   = _mod_+sizeof(dword)           ; esp [1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      LD_ADDR  eax, p384r1_data        ; srore modulus address
      lea      eax, dword ptr[eax+(_prime384r1-p384r1_data)]
      mov      dword ptr[esp+_mod_], eax

      lea      edi, [esp+_bufT_]       ; T
      mov      esi, pA                 ; A
      CALLASM  shl_384                 ; T = A<<1
      mov      edx, eax

      mov      esi, edi                ; T
      lea      edi, [esp+_bufU_]       ; U
      mov      ebx, [esp+_mod_]        ; modulus
      CALLASM  sub_384                 ; U = T-modulus

      sub      edx, eax                ; T = U<0? T : U
      cmovz    esi, edi
      cpy_384  edi, esi

      mov      esi, edi
      mov      ebx, pA
      CALLASM  add_384                 ; T +=A
      mov      edx, eax

      mov      edi, pR                 ; R
      mov      ebx, [esp+_mod_]        ; modulus
      CALLASM  sub_384                 ; R = T-modulus

      sub      edx, eax                ; R = T<0? R : T
      cmovz    esi, edi
      cpy_384  edi, esi

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_mul_by_3 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_div_by_2(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_div_by_2 PROC NEAR C PUBLIC \
      USES esi edi ebx,\
      pR:   PTR DWORD,\  ; product address
      pA:   PTR DWORD   ; source A address
;
; stack layout:
;
_buf_  = 0                             ; buffer[LEN384]
_sp_   = _buf_+(LEN384)*sizeof(dword)  ; esp[1]
_frame_= _sp_ +sizeof(dword)           ; +16 bytes for alignment

      mov   eax, esp                   ; save esp
      sub   esp, _frame_               ; allocate frame
      and   esp, -16                   ; provide 16-byte alignment
      mov   dword ptr[esp+_sp_], eax   ; store esp

      lea      edi, [esp+_buf_]        ; T
      mov      esi, pA                 ; A
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  add_384                 ; R = A+modulus
      mov      edx, 0

      mov      ecx, dword ptr[esi]     ; shifted_data = (a[0]&1)? T : A
      and      ecx, 1
      cmovnz   esi, edi
      cmovz    eax, edx
      movd     xmm0, eax
      mov      edi, pR
      CALLASM  shr_384

      mov      esp, [esp+_sp_]
      ret
IPPASM p384r1_div_by_2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_mul_mont_slm(Ipp32u* r, const Ipp32u* a, const Ipp32u* b)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mul_mont_slm PROC NEAR C PUBLIC \
      USES ebp ebx esi edi,\
      pR:   PTR DWORD,\    ; product address
      pA:   PTR DWORD,\    ; source A address
      pB:   PTR DWORD     ; source B address
;
; stack layout:
;
_buf_    = 0
_rp_     = _buf_+(LEN384+1)*sizeof(dword) ; pR
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
      movq  [esp+_buf_+sizeof(qword)*4], mm0
      movq  [esp+_buf_+sizeof(qword)*5], mm0
      movq  [esp+_buf_+sizeof(qword)*6], mm0

      ; store parameters into the stack
      mov   edi, pR
      mov   esi, pA
      mov   ebp, pB
      mov   dword ptr[esp+_rp_], edi
      mov   dword ptr[esp+_ap_], esi
      mov   dword ptr[esp+_bp_], ebp

      mov   eax, LEN384

      movd  mm1, dword ptr[esi+sizeof(dword)]      ; pre load a[1], a[2], a[3], a[4]
      movd  mm2, dword ptr[esi+sizeof(dword)*2]
      movd  mm3, dword ptr[esi+sizeof(dword)*3]
      movd  mm4, dword ptr[esi+sizeof(dword)*4]


ALIGN IPP_ALIGN_FACTOR
mmul_loop:
;
; i-st pass
; modulus = 2^384 -2^128 -2^96 +2^32 -1
;           [12]   [4]    [3]   [1]  [0]
; m0 = 1
;
; T0 = a[ 0]*b[i] + p[0]
; e0 = HI(T0), u = LO(T0)
;
; T1  = a[ 1]*b[i] +e0  +p[ 1], (cf=0),  e1 = HI( T1), p1 =LO( T1),  (cf1 ,p1 ) = p1 +u,        p[ 0] = p1,  cf1
; T2  = a[ 2]*b[i] +e1  +p[ 2], (cf=0),  e2 = HI( T2), p2 =LO( T2),  (cf2 ,p2 ) = p2 +cf1,      p[ 1] = p2,  cf2
; T3  = a[ 3]*b[i] +e2  +p[ 3], (cf=0),  e3 = HI( T3), p3 =LO( T3),  (bf3 ,p3 ) = p3 +cf2 -u,   p[ 2] = p3,  bf3
; T4  = a[ 4]*b[i] +e3  +p[ 4], (cf=0),  e4 = HI( T4), p4 =LO( T4),  (bf4 ,p4 ) = p4 -bf3 -u,   p[ 3] = p4,  bf4
; T5  = a[ 5]*b[i] +e4  +p[ 5], (cf=0),  e5 = HI( T5), p5 =LO( T5),  (bf5 ,p5 ) = p5 -bf4,      p[ 4] = p5,  bf5
; T6  = a[ 6]*b[i] +e5  +p[ 6], (cf=0),  e6 = HI( T6), p6 =LO( T6),  (bf6 ,p6 ) = p6 -bf5,      p[ 5] = p6,  bf6
; T7  = a[ 7]*b[i] +e6  +p[ 7], (cf=0),  e7 = HI( T7), p7 =LO( T7),  (bf7 ,p7 ) = p7 -bf6,      p[ 6] = p7,  bf7
; T8  = a[ 8]*b[i] +e7  +p[ 8], (cf=0),  e8 = HI( T8), p8 =LO( T8),  (bf8 ,p8 ) = p8 -bf7,      p[ 7] = p8,  bf8
; T9  = a[ 9]*b[i] +e8  +p[ 9], (cf=0),  e9 = HI( T9), p9 =LO( T9),  (bf9 ,p9 ) = p9 -bf8,      p[ 8] = p9,  bf9
; T10 = a[10]*b[i] +e9  +p[10], (cf=0),  e10= HI(T10), p10=LO(T10),  (bf10,p10) = p10-bf9,      p[ 9] = p10, bf9
; T11 = a[11]*b[i] +e10 +p[11], (cf=0),  e11= HI(T11), p11=LO(T11),  (bf11,p11) = p11-bf10,     p[10] = p11, bf10
;                                                                    (cf12,p12) = e11-bf11+u    p[11] = p12, cf12
;                                                                                               p[13] = cf12
      movd     mm7, eax                   ; save pass counter

      mov      edx, dword ptr[ebp]     ; b = b[i]
      mov      eax, dword ptr[esi]     ; a[0]
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
     ;pmuludq  mm1, mm0

      movd     ebx, mm2                   ; p = a[2]*b[i] + E
      psrlq    mm2, 32
      add      ebx, edx
      movd     edx, mm2
      adc      edx, 0
      add      ebx, dword ptr[esp+_buf_+sizeof(dword)*2]
      movd     mm2, dword ptr[esi+sizeof(dword)*6]
      adc      edx, 0
      pmuludq  mm1, mm0
      pmuludq  mm2, mm0

      movd     ebp, mm3                   ; p = a[3]*b[i] + E
      psrlq    mm3, 32
      add      ebp, edx
      movd     edx, mm3
      adc      edx, 0
      add      ebp, dword ptr[esp+_buf_+sizeof(dword)*3]
      movd     mm3, dword ptr[esi+sizeof(dword)*7]
      adc      edx, 0
     ;pmuludq  mm3, mm0

      movd     edi, mm4                   ; p = a[4]*b[i] + E
      psrlq    mm4, 32
      add      edi, edx
      movd     edx, mm4
      adc      edx, 0
      add      edi, dword ptr[esp+_buf_+sizeof(dword)*4]
      movd     mm4, dword ptr[esi+sizeof(dword)*8]
      adc      edx, 0
      pmuludq  mm3, mm0
      pmuludq  mm4, mm0

;;; and reduction ;;;
      add      ecx, eax                                     ; +u0
      mov      dword ptr[esp+_buf_+sizeof(dword)*0], ecx
      mov      ecx, eax                                     ; save u0
      adc      ebx, 0                                       ; +cf
      mov      dword ptr[esp+_buf_+sizeof(dword)*1], ebx
      sbb      eax, 0                                       ; eax = u0-cf
      sub      ebp, eax                                     ; ebp-eax = ebp+cf-u0
      mov      dword ptr[esp+_buf_+sizeof(dword)*2], ebp
      sbb      edi, ecx                                     ; edi-u0-bf
      mov      eax, 0
      mov      dword ptr[esp+_buf_+sizeof(dword)*3], edi
      movd     mm6, ecx
     ;sbb      eax, eax                                     ; save bf signu: eax = bf? 0xffffffff: 0x00000000
     adc       eax, 0

; multiplication round 5 - round 8
      movd     ecx, mm1                   ; p = a[5]*b[i] + E
      psrlq    mm1, 32
      add      ecx, edx
      movd     edx, mm1
      adc      edx, 0
      add      ecx, dword ptr[esp+_buf_+sizeof(dword)*5]
      movd     mm1, dword ptr[esi+sizeof(dword)*9]
      adc      edx, 0
     ;pmuludq  mm1, mm0

      movd     ebx, mm2                   ; p = a[6]*b[i] + E
      psrlq    mm2, 32
      add      ebx, edx
      movd     edx, mm2
      adc      edx, 0
      add      ebx, dword ptr[esp+_buf_+sizeof(dword)*6]
      movd     mm2, dword ptr[esi+sizeof(dword)*10]
      adc      edx, 0
      pmuludq  mm1, mm0
      pmuludq  mm2, mm0

      movd     ebp, mm3                   ; p = a[7]*b[i] + E
      psrlq    mm3, 32
      add      ebp, edx
      movd     edx, mm3
      adc      edx, 0
      add      ebp, dword ptr[esp+_buf_+sizeof(dword)*7]
      movd     mm3, dword ptr[esi+sizeof(dword)*11]
      adc      edx, 0
      pmuludq  mm3, mm0

      movd     edi, mm4                   ; p = a[8]*b[i] + E
      psrlq    mm4, 32
      add      edi, edx
      movd     edx, mm4
      adc      edx, 0
      add      edi, dword ptr[esp+_buf_+sizeof(dword)*8]
      adc      edx, 0

;;; and reduction ;;;
     ;add      eax, eax                                  ; restore bf
     ;sbb      ecx, 0                                    ; -bf
      sub      ecx, eax
      movd     eax, mm6
      mov      dword ptr[esp+_buf_+sizeof(dword)*4], ecx
      sbb      ebx, 0                                    ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*5], ebx
      sbb      ebp, 0                                    ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*6], ebp
      sbb      edi, 0                                    ; -bf
      mov      eax, 0
      mov      dword ptr[esp+_buf_+sizeof(dword)*7], edi
     ;sbb      eax, eax
      adc      eax, 0

; multiplication round 9 - round 11
      movd     ecx, mm1                   ; p = a[9]*b[i] + E
      psrlq    mm1, 32
      add      ecx, edx
      movd     edx, mm1
      adc      edx, 0
      add      ecx, dword ptr[esp+_buf_+sizeof(dword)*9]
      adc      edx, 0

      movd     ebx, mm2                   ; p = a[10]*b[i] + E
      psrlq    mm2, 32
      add      ebx, edx
      movd     edx, mm2
      adc      edx, 0
      add      ebx, dword ptr[esp+_buf_+sizeof(dword)*10]
      adc      edx, 0

      movd     ebp, mm3                   ; p = a[11]*b[i] + E
      psrlq    mm3, 32
      add      ebp, edx
      movd     edx, mm3
      adc      edx, 0
      add      ebp, dword ptr[esp+_buf_+sizeof(dword)*11]
      adc      edx, 0

;;; and reduction ;;;
     ;add      eax, eax                                     ; restore bf
     ;sbb      ecx, 0                                       ; u0-bf
      sub      ecx, eax
      mov      dword ptr[esp+_buf_+sizeof(dword)*8], ecx
      movd     ecx, mm6
      sbb      ebx, 0                                       ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*9], ebx
      sbb      ebp, 0                                       ; -bf
      mov      dword ptr[esp+_buf_+sizeof(dword)*10], ebp
      sbb      ecx, 0                                       ; u0-bf
      mov      ebx, 0

; last multiplication round 12
      movd     eax, mm7                                     ; restore pass counter

      add      edx, dword ptr[esp+_buf_+sizeof(dword)*12]
      adc      ebx, 0
      add      edx, ecx
      adc      ebx, 0
      mov      dword ptr[esp+_buf_+sizeof(dword)*11], edx
      mov      dword ptr[esp+_buf_+sizeof(dword)*12], ebx

      sub      eax, 1
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
      LD_ADDR  ebx, p384r1_data        ; modulus
      lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
      CALLASM  sub_384
      mov      edx, dword ptr[esp+_buf_+sizeof(dword)*12]
      sub      edx, eax

; copy
      cmovz    esi, edi
      cpy_384  edi, esi

      mov   esp, [esp+_sp_]            ; release stack
      ret
IPPASM p384r1_mul_mont_slm ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_sqr_mont_slm(Ipp32u* r, const Ipp32u* a)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_sqr_mont_slm PROC NEAR C PUBLIC \
      USES esi edi,\
      pR:   PTR DWORD,\    ; product address
      pA:   PTR DWORD     ; source A address

      ;; use p384r1_mul_mont_slm to compute sqr
      mov   esi, pA
      mov   edi, pR
      push  esi
      push  esi
      push  edi
      callasm  p384r1_mul_mont_slm
      add   esp, sizeof(dword)*3
      ret
IPPASM p384r1_sqr_mont_slm ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_mred(Ipp32u* r, Ipp32u* prod)
;;
; modulus = 2^384 -2^128 -2^96 +2^32 -1
;           [12]   [4]    [3]   [1]  [0]
; m0 = 1
;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mred PROC NEAR C PUBLIC \
      USES ebx esi edi,\
      pR:   PTR DWORD,\    ; reduction address
      pA:   PTR DWORD     ; source product address

   ; get parameters:
   mov   esi, pA

   mov   ecx, LEN384
   xor   edx, edx
ALIGN IPP_ALIGN_FACTOR
mred_loop:
   mov   eax, dword ptr[esi]

   mov   ebx, dword ptr[esi+sizeof(dword)]
   add   ebx, eax
   mov   dword ptr[esi+sizeof(dword)], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*2]
   adc   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*2], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*3]
   sbb   eax, 0
   sub   ebx, eax
   mov   eax, dword ptr [esi]
   mov   dword ptr[esi+sizeof(dword)*3], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*4]
   sbb   ebx, eax
   mov   dword ptr[esi+sizeof(dword)*4], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*5]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*5], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*6]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*6], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*7]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*7], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*8]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*8], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*9]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*9], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*10]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*10], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*11]
   sbb   ebx, 0
   mov   dword ptr[esi+sizeof(dword)*11], ebx

   mov   ebx, dword ptr[esi+sizeof(dword)*12]
   sbb   eax, 0
   add   eax, edx
   mov   edx, 0
   adc   edx, 0
   add   ebx, eax
   mov   dword ptr[esi+sizeof(dword)*12], ebx
   adc   edx, 0

   lea   esi, [esi+sizeof(dword)]
   sub   ecx, 1
   jnz   mred_loop

   ; final reduction
   mov      edi, pR           ; result
   LD_ADDR  ebx, p384r1_data  ; addres of the modulus
   lea      ebx, dword ptr[ebx+(_prime384r1-p384r1_data)]
   CALLASM  sub_384

   sub      edx, eax
   cmovz    esi, edi
   cpy_384  edi, esi

   ret
IPPASM p384r1_mred ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void p384r1_select_pp_w5(P384_POINT *val, const P384_POINT *in_t, int index)
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_select_pp_w5 PROC NEAR C PUBLIC \
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

      movdqa   oword ptr[edi], xmm0                   ; clear P.X
      movdqa   oword ptr[edi+sizeof(oword)], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*2], xmm0

      movdqa   oword ptr[edi+sizeof(oword)*3], xmm0   ; clear P.Y
      movdqa   oword ptr[edi+sizeof(oword)*4], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*5], xmm0

      movdqa   oword ptr[edi+sizeof(oword)*6], xmm0   ; clear P.Z
      movdqa   oword ptr[edi+sizeof(oword)*7], xmm0
      movdqa   oword ptr[edi+sizeof(oword)*8], xmm0

      ; skip index = 0, is implicictly infty -> load with offset -1
      movdqa   xmm5, xmm6           ; current_idx
      mov      ecx, 16
ALIGN IPP_ALIGN_FACTOR
select_loop:
      movdqa   xmm4, xmm5
      pcmpeqd  xmm4, xmm7     ; mask = current_idx==idx? 0xFF : 0x00

      movdqa   xmm0, xmm4
      pand     xmm0, oword ptr[esi]
      por      xmm0, oword ptr[edi]
      movdqa   oword ptr[edi], xmm0
      movdqa   xmm1, xmm4
      pand     xmm1, oword ptr[esi+sizeof(oword)]
      por      xmm1, oword ptr[edi+sizeof(oword)]
      movdqa   oword ptr[edi+sizeof(oword)], xmm1
      movdqa   xmm2, xmm4
      pand     xmm2, oword ptr[esi+sizeof(oword)*2]
      por      xmm2, oword ptr[edi+sizeof(oword)*2]
      movdqa   oword ptr[edi+sizeof(oword)*2], xmm2

      movdqa   xmm0, xmm4
      pand     xmm0, oword ptr[esi+sizeof(oword)*3]
      por      xmm0, oword ptr[edi+sizeof(oword)*3]
      movdqa   oword ptr[edi+sizeof(oword)*3], xmm0
      movdqa   xmm1, xmm4
      pand     xmm1, oword ptr[esi+sizeof(oword)*4]
      por      xmm1, oword ptr[edi+sizeof(oword)*4]
      movdqa   oword ptr[edi+sizeof(oword)*4], xmm1
      movdqa   xmm2, xmm4
      pand     xmm2, oword ptr[esi+sizeof(oword)*5]
      por      xmm2, oword ptr[edi+sizeof(oword)*5]
      movdqa   oword ptr[edi+sizeof(oword)*5], xmm2

      movdqa   xmm0, xmm4
      pand     xmm0, oword ptr[esi+sizeof(oword)*6]
      por      xmm0, oword ptr[edi+sizeof(oword)*6]
      movdqa   oword ptr[edi+sizeof(oword)*6], xmm0
      movdqa   xmm1, xmm4
      pand     xmm1, oword ptr[esi+sizeof(oword)*7]
      por      xmm1, oword ptr[edi+sizeof(oword)*7]
      movdqa   oword ptr[edi+sizeof(oword)*7], xmm1
      movdqa   xmm2, xmm4
      pand     xmm2, oword ptr[esi+sizeof(oword)*8]
      por      xmm2, oword ptr[edi+sizeof(oword)*8]
      movdqa   oword ptr[edi+sizeof(oword)*8], xmm2

      paddd    xmm5, xmm6     ; increment current_idx
      add      esi, sizeof(oword)*9
      sub      ecx, 1
      jnz      select_loop

      ret
IPPASM p384r1_select_pp_w5 ENDP

ENDIF    ;; _IPP GE _IPP_P8
END
