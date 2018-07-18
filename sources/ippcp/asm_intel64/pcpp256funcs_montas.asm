;===============================================================================
; Copyright 2015-2018 Intel Corporation
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
;               256-bit modular arithmetic
; 
     
;
include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_add(Ipp64u res[4], Ipp64u a[4], Ipp64u b[4], Ipp64u poly[4])
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_add PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 4

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ r12
t3 equ r13
t4 equ r14

   xor   t4,  t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]  ; a[] = A
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   add   a0, qword ptr[rdx+sizeof(qword)*0]  ; a[] = a[]+b[]
   adc   a1, qword ptr[rdx+sizeof(qword)*1]
   adc   a2, qword ptr[rdx+sizeof(qword)*2]
   adc   a3, qword ptr[rdx+sizeof(qword)*3]
   adc   t4, 0

   mov   t0, a0                              ; save result t[] = a[]
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   sub   t0, qword ptr[rcx+sizeof(qword)*0]  ; t[] = a[]+b[] -poly[]
   sbb   t1, qword ptr[rcx+sizeof(qword)*1]
   sbb   t2, qword ptr[rcx+sizeof(qword)*2]
   sbb   t3, qword ptr[rcx+sizeof(qword)*3]
   sbb   t4, 0

   cmovz a0, t0                              ; A = a:t
   cmovz a1, t1
   cmovz a2, t2
   cmovz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   mov   rax, rdi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_sub(Ipp64u res[4], Ipp64u a[4], Ipp64u b[4], Ipp64u poly[4])
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_sub PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 4

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ r12
t3 equ r13
t4 equ r14

   xor   t4,  t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]  ; a[] = A
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   sub   a0, qword ptr[rdx+sizeof(qword)*0]  ; a[] = a[]-b[]
   sbb   a1, qword ptr[rdx+sizeof(qword)*1]
   sbb   a2, qword ptr[rdx+sizeof(qword)*2]
   sbb   a3, qword ptr[rdx+sizeof(qword)*3]
   sbb   t4, 0

   mov   t0, a0                              ; save result t[] = a[]
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr[rcx+sizeof(qword)*0]  ; t[] = a[]-b[] +poly[]
   adc   t1, qword ptr[rcx+sizeof(qword)*1]
   adc   t2, qword ptr[rcx+sizeof(qword)*2]
   adc   t3, qword ptr[rcx+sizeof(qword)*3]
   test  t4, t4

   cmovnz a0, t0                              ; A = a:t
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   mov   rax, rdi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_neg(Ipp64u res[4], Ipp64u a[4], Ipp64u poly[4])
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_neg PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rcx
t2 equ r12
t3 equ r13
t4 equ r14

   xor   t4, t4

   xor   a0, a0                              ; a[] = 0;
   xor   a1, a1
   xor   a2, a2
   xor   a3, a3

   sub   a0, qword ptr[rsi+sizeof(qword)*0]  ; a[] = -a[]
   sbb   a1, qword ptr[rsi+sizeof(qword)*1]
   sbb   a2, qword ptr[rsi+sizeof(qword)*2]
   sbb   a3, qword ptr[rsi+sizeof(qword)*3]
   sbb   t4, 0

   mov   t0, a0                              ; t[] = a[]
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr[rdx+sizeof(qword)*0]  ; t[] = -a[] +poly[]
   adc   t1, qword ptr[rdx+sizeof(qword)*1]
   adc   t2, qword ptr[rdx+sizeof(qword)*2]
   adc   t3, qword ptr[rdx+sizeof(qword)*3]
   test  t4, t4

   cmovnz a0, t0                              ; A = a:t
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   mov   rax, rdi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_div2(Ipp64u res[4], Ipp64u a[4], Ipp64u poly[4])
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_div2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rcx
t2 equ r12
t3 equ r13
t4 equ r14

   mov   a0, qword ptr[rsi+sizeof(qword)*0]  ; a[] = A
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   xor   t4,  t4
   xor   rsi, rsi

   mov   t0, a0                              ; t[] = A
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr[rdx+sizeof(qword)*0]  ; t[] += poly[]
   adc   t1, qword ptr[rdx+sizeof(qword)*1]
   adc   t2, qword ptr[rdx+sizeof(qword)*2]
   adc   t3, qword ptr[rdx+sizeof(qword)*3]
   adc   t4, 0

   test  a0, 1                               ; if (A[0] & 1)
   cmovnz a0, t0                             ; a[] = t[]
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3
   cmovnz rsi,t4

   shrd  a0, a1, 1                           ; a[] /= 2
   shrd  a1, a2, 1
   shrd  a2, a3, 1
   shrd  a3, rsi,1

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   mov   rax, rdi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_div2 ENDP


;;
;; GF256 multiplicative operations
;;
MUL_4x1 MACRO    dm, ACC4, ACC3, ACC2, ACC1, ACC0, aPtr, B
   mov   rax, qword ptr[aPtr+sizeof(qword)*0]
   mul   B
   mov   ACC0,rax
   mov   ACC1,rdx
   imul  dm,  ACC0

   mov   rax, qword ptr[aPtr+sizeof(qword)*1]
   mul   B
   add   ACC1,rax
   adc   rdx, 0
   mov   ACC2,rdx

   mov   rax, qword ptr[aPtr+sizeof(qword)*2]
   mul   B
   add   ACC2,rax
   adc   rdx, 0
   mov   ACC3,rdx

   mov   rax, qword ptr[aPtr+sizeof(qword)*3]
   mul   B
   add   ACC3,rax
   adc   rdx, 0
   mov   ACC4,rdx
ENDM


MLA_4x1 MACRO  dm, ACC5, ACC4, ACC3, ACC2, ACC1, ACC0, aPtr, B, TMP
   mov   rax, qword ptr[aPtr+sizeof(qword)*0]
   mul   B
   add   ACC0,rax
   adc   rdx, 0
   mov   TMP, rdx
   imul  dm,  ACC0

   mov   rax, qword ptr[aPtr+sizeof(qword)*1]
   mul   B
   add   ACC1,TMP
   adc   rdx, 0
   add   ACC1,rax
   adc   rdx, 0
   mov   TMP, rdx

   mov   rax, qword ptr[aPtr+sizeof(qword)*2]
   mul   B
   add   ACC2,TMP
   adc   rdx, 0
   add   ACC2,rax
   adc   rdx, 0
   mov   TMP, rdx

   mov   rax, qword ptr[aPtr+sizeof(qword)*3]
   mul   B
   add   ACC3,TMP
   adc   rdx, 0
   add   ACC3,rax
   adc   ACC4,rdx
   adc   ACC5,0
ENDM

MRED_4x1 MACRO ACC5, ACC4, ACC3, ACC2, ACC1, ACC0, mPtr, dm
   mov   rax, qword ptr[mPtr+sizeof(qword)*0]
   mul   dm
   add   ACC0,rax
   adc   rdx, 0
   mov   ACC0,rdx

   mov   rax, qword ptr[mPtr+sizeof(qword)*1]
   mul   dm
   add   ACC1,ACC0
   adc   rdx, 0
   add   ACC1,rax
   adc   rdx, 0
   mov   ACC0,rdx

   mov   rax, qword ptr[mPtr+sizeof(qword)*2]
   mul   dm
   add   ACC2,ACC0
   adc   rdx, 0
   add   ACC2,rax
   adc   rdx, 0
   mov   ACC0,rdx

   mov   rax, qword ptr[mPtr+sizeof(qword)*3]
   mul   dm
   add   ACC3,ACC0
   adc   rdx, 0
   add   ACC3,rax
   adc   rdx, 0
   add   ACC4,rdx

   adc   ACC5,0
   xor   ACC0,ACC0
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_mulm(Ipp64u res[4], Ipp64u a[4], Ipp64u b[4], Ipp64u poly[4], Ipp64u m0)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_mulm PROC PUBLIC FRAME
   USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14,r15
   LOCAL_FRAME = 2*sizeof(qword)
   USES_XMM
   COMP_ABI 5

;; stack structure:
res   = 0
m0    = res+sizeof(qword)

   mov   qword ptr[rsp+res], rdi    ; save result
   mov   rbx, rdx                   ; rbx = bPtr
   mov   rdi, rcx                   ; rcx = mPtr
   mov   qword ptr[rsp+m0], r8      ; save  m0

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; P = A[] * b[0]
   mov         r14, qword ptr[rbx+sizeof(qword)*0]
   mov         r15, qword ptr[rsp+m0]
   MUL_4x1     r15, acc4,acc3,acc2,acc1,acc0, rsi, r14

   xor         acc5,acc5
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step
   MRED_4x1    acc5,acc4,acc3,acc2,acc1,acc0, rdi, r15

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; P+= A[] * b[1]
   mov         r14, qword ptr[rbx+sizeof(qword)*1]
   mov         r15, qword ptr[rsp+m0]
   MLA_4x1     r15, acc0,acc5,acc4,acc3,acc2,acc1, rsi, r14, rcx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step
   MRED_4x1    acc0,acc5,acc4,acc3,acc2,acc1, rdi, r15

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; P+= A[] * b[2]
   mov         r14, qword ptr[rbx+sizeof(qword)*2]
   mov         r15, qword ptr[rsp+m0]
   MLA_4x1     r15, acc1,acc0,acc5,acc4,acc3,acc2, rsi, r14, rcx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step
   MRED_4x1    acc1,acc0,acc5,acc4,acc3,acc2, rdi, r15

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; P+= A[] * b[3]
   mov         r14, qword ptr[rbx+sizeof(qword)*3]
   mov         r15, qword ptr[rsp+m0]
   MLA_4x1     r15, acc2,acc1,acc0,acc5,acc4,acc3, rsi, r14, rcx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step
   MRED_4x1    acc2,acc1,acc0,acc5,acc4,acc3, rdi, r15

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; final reduction
   mov   rsi, qword ptr[rsp+res]             ;; restore result address

   mov   rax, acc4                           ;; copy temporary result
   mov   rbx, acc5
   mov   rcx, acc0
   mov   rdx, acc1

   sub   rax, qword ptr[rdi+sizeof(qword)*0] ;; subtract modulus
   sbb   rbx, qword ptr[rdi+sizeof(qword)*1]
   sbb   rcx, qword ptr[rdi+sizeof(qword)*2]
   sbb   rdx, qword ptr[rdi+sizeof(qword)*3]
   sbb   acc2, 0

   cmovnc acc4, rax
   cmovnc acc5, rbx
   cmovnc acc0, rcx
   cmovnc acc1, rdx

   mov   qword ptr[rsi+sizeof(qword)*0], acc4
   mov   qword ptr[rsi+sizeof(qword)*1], acc5
   mov   qword ptr[rsi+sizeof(qword)*2], acc0
   mov   qword ptr[rsi+sizeof(qword)*3], acc1

   mov   rax, rsi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_mulm ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ipp64u* gf256_sqrm(Ipp64u res[4], Ipp64u a[4], Ipp64u poly[4], Ipp64u m0)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM gf256_sqrm PROC PUBLIC FRAME
   USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14,r15
   LOCAL_FRAME = 2*sizeof(qword)
   USES_XMM
   COMP_ABI 4

;; stack structure:
res   = 0
m0    = res+sizeof(qword)

   mov   qword ptr[rsp+res], rdi    ; save result
   mov   rdi, rdx                   ; rdi = mPtr
   mov   qword ptr[rsp+m0], rcx     ; save  m0

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13
acc6 equ r14
acc7 equ r15

t0 equ rcx
t1 equ rbp
t2 equ rbx
t3 equ rdx
t4 equ rax

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; diagonal
   mov   t2, qword ptr[rsi+sizeof(qword)*0]
   mov   rax,qword ptr[rsi+sizeof(qword)*1]
   mul   t2
   mov   acc1, rax
   mov   acc2, rdx
   mov   rax,qword ptr[rsi+sizeof(qword)*2]
   mul   t2
   add   acc2, rax
   adc   rdx, 0
   mov   acc3, rdx
   mov   rax,qword ptr[rsi+sizeof(qword)*3]
   mul   t2
   add   acc3, rax
   adc   rdx, 0
   mov   acc4, rdx
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[rsi+sizeof(qword)*1]
   mov   rax,qword ptr[rsi+sizeof(qword)*2]
   mul   t2
   add   acc3, rax
   adc   rdx, 0
   mov   t1, rdx
   mov   rax,qword ptr[rsi+sizeof(qword)*3]
   mul   t2
   add   acc4, rax
   adc   rdx, 0
   add   acc4, t1
   adc   rdx, 0
   mov   acc5, rdx
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[rsi+sizeof(qword)*2]
   mov   rax,qword ptr[rsi+sizeof(qword)*3]
   mul   t2
   add   acc5, rax
   adc   rdx, 0
   mov   acc6, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; doubling
   xor   acc7, acc7
   shld  acc7, acc6, 1
   shld  acc6, acc5, 1
   shld  acc5, acc4, 1
   shld  acc4, acc3, 1
   shld  acc3, acc2, 1
   shld  acc2, acc1, 1
   shl   acc1, 1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; add sruares
   mov   rax,qword ptr[rsi+sizeof(qword)*0]
   mul   rax
   mov   acc0, rax
   add   acc1, rdx
   adc   acc2, 0
   mov   rax,qword ptr[rsi+sizeof(qword)*1]
   mul   rax
   add   acc2, rax
   adc   acc3, rdx
   adc   acc4, 0
   mov   rax,qword ptr[rsi+sizeof(qword)*2]
   mul   rax
   add   acc4, rax
   adc   acc5, rdx
   adc   acc6, 0
   mov   rax,qword ptr[rsi+sizeof(qword)*3]
   mul   rax
   add   acc6, rax
   adc   acc7, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction
   mov   rcx, qword ptr[rsp+m0]  ; restore m0
   imul  rcx, acc0
   MRED_4x1    acc5,acc4,acc3,acc2,acc1,acc0, rdi, rcx

   mov   rcx, qword ptr[rsp+m0]  ; restore m0
   imul  rcx, acc1
   MRED_4x1    acc6,acc5,acc4,acc3,acc2,acc1, rdi, rcx

   mov   rcx, qword ptr[rsp+m0]  ; restore m0
   imul  rcx, acc2
   MRED_4x1    acc7,acc6,acc5,acc4,acc3,acc2, rdi, rcx

   mov   rcx, qword ptr[rsp+m0]  ; restore m0
   imul  rcx, acc3
   MRED_4x1    acc0,acc7,acc6,acc5,acc4,acc3, rdi, rcx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; final reduction
   mov   rsi, qword ptr[rsp+res]             ;; restore result address

   mov   rax, acc4                           ;; copy temporary result
   mov   rbx, acc5
   mov   rcx, acc6
   mov   rdx, acc7

   sub   rax, qword ptr[rdi+sizeof(qword)*0] ;; subtract modulus
   sbb   rbx, qword ptr[rdi+sizeof(qword)*1]
   sbb   rcx, qword ptr[rdi+sizeof(qword)*2]
   sbb   rdx, qword ptr[rdi+sizeof(qword)*3]
   sbb   acc0, 0

   cmovnc acc4, rax
   cmovnc acc5, rbx
   cmovnc acc6, rcx
   cmovnc acc7, rdx

   mov   qword ptr[rsi+sizeof(qword)*0], acc4
   mov   qword ptr[rsi+sizeof(qword)*1], acc5
   mov   qword ptr[rsi+sizeof(qword)*2], acc6
   mov   qword ptr[rsi+sizeof(qword)*3], acc7

   mov   rax, rsi                            ; return pointer to result

   REST_XMM
   REST_GPR
   ret
IPPASM gf256_sqrm ENDP


ENDIF ;; _IPP32E_M7
END
