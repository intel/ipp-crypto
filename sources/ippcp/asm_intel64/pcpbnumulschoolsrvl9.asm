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
;               Big Number Multiplicative Operations
; 
;      Content:
;         cpMulAdc_BNU_school()
;         cpSqrAdc_BNU_school()
;         cpMontRedAdc_BNU()
; 
;  Implementation is using mulx and adcx/adox instruvtions
; 
;

include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_ADCOX_NI_ENABLING_ EQ _FEATURE_ON_) OR (_ADCOX_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_L9)

_xEMULATION_ = 1


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


include pcpbnumul.inc
include pcpbnusqr.inc
include pcpmred.inc

.LIST

;*************************************************************
;* Ipp64u  cpMulAdc_BNU_school(Ipp64u* pR;
;*                       const Ipp64u* pA, int  aSize,
;*                       const Ipp64u* pB, int  bSize)
;*
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMulAdc_BNU_school PROC PUBLIC FRAME
   USES_GPR rbx,rbp,rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 5

; rdi = pR
; rsi = pA
; edx = nsA
; rcx = pB
; r8d = nsB

   movsxd   rdx, edx    ; expand length
   movsxd   rbx, r8d

   xor      r8, r8      ; clear scratch
   xor      r9, r9
   xor      r10, r10
   xor      r11, r11
   xor      r12, r12
   xor      r13, r13
   xor      r14, r14
   xor      r15, r15

   cmp      rdx, rbx
   jl       swap_operans      ; nsA < nsB
   jg       test_8N_case      ; test if nsA=8*N and nsB=8*M

   cmp      rdx, 16
   jg       test_8N_case

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; short nsA==nsB (1,..,16)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   cmp      rdx, 4
   jg       more_then_4

   cmp      edx, 3
   ja       mul_4_4
   jz       mul_3_3
   jp       mul_2_2
  ;         mul_1_1

mul_1_1:
   MUL_NxN  1, rdi, rsi, rcx, rbx,rbp, r8
   jmp      quit
mul_2_2:
   MUL_NxN  2, rdi, rsi, rcx, rbx,rbp, r8,r9
   jmp      quit
mul_3_3:
   MUL_NxN  3, rdi, rsi, rcx, rbx,rbp, r8,r9,r10
   jmp      quit
mul_4_4:
   MUL_NxN  4, rdi, rsi, rcx, rbx,rbp, r8,r9,r10,r11
   jmp      quit

more_then_4:
   GET_EP   rax, mul_lxl_basic, rdx, rbp
   call     rax
   jmp      quit

swap_operans:
   SWAP     rsi, rcx       ; swap operands
   SWAP     rdx, rbx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8*N x 8*M case multiplier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_8N_case:
   mov      rax, rdx
   or       rax, rbx
   and      rax, 7
   jnz      general_mul

   call     mul_8Nx8M
   jmp      quit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general case multiplier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
general_mul:
   call    mul_NxM
   jmp     quit

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM cpMulAdc_BNU_school ENDP


;*************************************************************
;*
;* Ipp64u  cpSqrAdc_BNU_school(Ipp64u* pR;
;*                       const Ipp64u* pA, int  aSize)
;*
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpSqrAdc_BNU_school PROC PUBLIC FRAME
   USES_GPR rbx,rbp,rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

   movsxd   rdx, edx    ; expand length

   xor      r8, r8      ; clear scratch
   xor      r9, r9
   xor      r10, r10
   xor      r11, r11
   xor      r12, r12
   xor      r13, r13
   xor      r14, r14
   xor      r15, r15

   cmp      rdx, 16
   jg       test_8N_case

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; short nsA (1,..,16)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   GET_EP   rax, sqr_l_basic, rdx, rbp
   call     rax
   jmp      quit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8N case squarer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_8N_case:
   test     rdx, 7
   jnz      general_sqr

   call     sqr_8N
   jmp      quit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general case squarer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
general_sqr:
   call     sqr_N

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM cpSqrAdc_BNU_school ENDP


;*************************************************************
;*
;* Ipp64u  cpMontRedAdc_BNU(Ipp64u* pR;
;*                          Ipp64u* pProduct,
;*                    const Ipp64u* pModulus, int  mSize,
;*                          Ipp64u  m)
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontRedAdc_BNU PROC PUBLIC FRAME
      USES_GPR rbx,rbp,rsi,rdi,r12,r13,r14,r15
      LOCAL_FRAME = (0)
      USES_XMM
      COMP_ABI 5
;pR        (rdi) address of the reduction
;pProduct  (rsi) address of the temporary product
;pModulus  (rdx) address of the modulus
;mSize     (rcx) size    of the modulus
;m0        (r8)  montgomery helper (m')

   mov      r15, rdi    ; store reduction address

   ; reload parameters for future convinience:
   mov      rdi, rsi    ; rdi = temporary product buffer
   mov      rsi, rdx    ; rsi = modulus
   movsxd   rdx, ecx    ; rdx = length of modulus

   cmp      rdx, 16
   ja       test_8N_case   ; length of modulus >16

   cmp      rdx, 4
   ja       above4         ; length of modulus 4,..,16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; short modulus (1,..,4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   cmp      rdx, 3
   ja       red_4
   jz       red_3
   jp       red_2
  ;         red_1

red_1:
   mov      r9, qword ptr [rdi+sizeof(qword)*0]
   MRED_FIX 1, r15, rdi, rsi, r8, rbp,rbx, r9
   jmp      quit

red_2:
   mov      r9,  qword ptr [rdi+sizeof(qword)*0]
   mov      r10, qword ptr [rdi+sizeof(qword)*1]
   MRED_FIX 2, r15, rdi, rsi, r8, rbp,rbx, r9,r10
   jmp      quit

red_3:
   mov      r9,  qword ptr [rdi+sizeof(qword)*0]
   mov      r10, qword ptr [rdi+sizeof(qword)*1]
   mov      r11, qword ptr [rdi+sizeof(qword)*2]
   MRED_FIX 3, r15, rdi, rsi, r8, rbp,rbx, r9,r10,r11
   jmp      quit

red_4:
   mov      r9,  qword ptr [rdi+sizeof(qword)*0]
   mov      r10, qword ptr [rdi+sizeof(qword)*1]
   mov      r11, qword ptr [rdi+sizeof(qword)*2]
   mov      r12, qword ptr [rdi+sizeof(qword)*3]
   MRED_FIX 4, r15, rdi, rsi, r8, rbp,rbx, r9,r10,r11,r12
   jmp      quit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; short modulus (5,..,16)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
above4:
   mov      rbp, rdx
   sub      rbp, 4
   GET_EP   rax, mred_short, rbp    ; mred procedure

   call     rax
   jmp      quit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8N case squarer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_8N_case:
   test     rdx, 7
   jnz      general_case

   call     mred_8N
   jmp      quit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; general case modulus
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
general_case:
   call     mred_N

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM cpMontRedAdc_BNU ENDP

ENDIF

ENDIF ;; _ADCOX_NI_ENABLING_
END
