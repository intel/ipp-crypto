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
;               secp p224r1 specific implementation
; 


include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

_xEMULATION_ = 1
_ADCX_ADOX_ = 1

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

;; The p224r1 polynomial
Lpoly DQ 00000000000000001h,0ffffffff00000000h,0ffffffffffffffffh,000000000ffffffffh

;; mont(1)
;; ffffffff00000000 ffffffffffffffff 0000000000000000 0000000000000000

;; 2^(2*224) mod P precomputed for p224r1 polynomial
LRR   DQ 0ffffffff00000001h,0ffffffff00000000h,0fffffffe00000000h,000000000ffffffffh

LOne     DD    1,1,1,1,1,1,1,1
LTwo     DD    2,2,2,2,2,2,2,2
LThree   DD    3,3,3,3,3,3,3,3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_mul_by_2(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   xor   t4, t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   shld  t4, a3, 1
   shld  a3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0, 1

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, qword ptr Lpoly+sizeof(qword)*3
   sbb   t4, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2
   cmovz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_mul_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_div_by_2(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_div_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   xor   t4,  t4
   xor   r14, r14

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   adc   t3, qword ptr Lpoly+sizeof(qword)*3
   adc   t4, 0
   test  a0, 1

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3
   cmovnz r14,t4

   shrd  a0, a1, 1
   shrd  a1, a2, 1
   shrd  a2, a3, 1
   shrd  a3, r14,1

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_div_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_mul_by_3(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_by_3 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   xor   t4, t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   shld  t4, a3, 1
   shld  a3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0, 1

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, qword ptr Lpoly+sizeof(qword)*3
   sbb   t4, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2
   cmovz a3, t3

   xor   t4, t4
   add   a0, qword ptr[rsi+sizeof(qword)*0]
   adc   a1, qword ptr[rsi+sizeof(qword)*1]
   adc   a2, qword ptr[rsi+sizeof(qword)*2]
   adc   a3, qword ptr[rsi+sizeof(qword)*3]
   adc   t4, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, qword ptr Lpoly+sizeof(qword)*3
   sbb   t4, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2
   cmovz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_mul_by_3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_add(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_add PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   xor   t4,  t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   add   a0, qword ptr[rdx+sizeof(qword)*0]
   adc   a1, qword ptr[rdx+sizeof(qword)*1]
   adc   a2, qword ptr[rdx+sizeof(qword)*2]
   adc   a3, qword ptr[rdx+sizeof(qword)*3]
   adc   t4, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, qword ptr Lpoly+sizeof(qword)*3
   sbb   t4, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2
   cmovz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_sub(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_sub PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   xor   t4,  t4

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]

   sub   a0, qword ptr[rdx+sizeof(qword)*0]
   sbb   a1, qword ptr[rdx+sizeof(qword)*1]
   sbb   a2, qword ptr[rdx+sizeof(qword)*2]
   sbb   a3, qword ptr[rdx+sizeof(qword)*3]
   sbb   t4, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   adc   t3, qword ptr Lpoly+sizeof(qword)*3
   test  t4, t4

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_neg(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_neg PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12
t4 equ r13

   xor   t4, t4

   xor   a0, a0
   xor   a1, a1
   xor   a2, a2
   xor   a3, a3

   sub   a0, qword ptr[rsi+sizeof(qword)*0]
   sbb   a1, qword ptr[rsi+sizeof(qword)*1]
   sbb   a2, qword ptr[rsi+sizeof(qword)*2]
   sbb   a3, qword ptr[rsi+sizeof(qword)*3]
   sbb   t4, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2
   mov   t3, a3

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   adc   t3, qword ptr Lpoly+sizeof(qword)*3
   test  t4, t4

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz a3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_mul_montl(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
; void p224r1_mul_montx(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; was working on GFp functionality the problem (in reduction spep) has been found
;; 1) "sqr" impementation has been changed by "mul"
;; 2) fortunately "mont_back" stay as is because of operand zero extensioned

; on entry p5=0
; on exit  p0=0
;
p224r1_prod_redstep MACRO p4,p3,p2,p1,p0
   neg   p0
   mov   t2, p0
   mov   t3, p0
   xor   t0, t0
   xor   t1, t1
   shr   t3, 32
   shl   t2, 32
   sub   t0, t2
   sbb   t1, t3
   sbb   t2, 0
   sbb   t3, 0

   neg   p0
   adc   p1, t0
   adc   p2, t1
   adc   p3, t2
   adc   p4, t3
ENDM

ALIGN IPP_ALIGN_FACTOR
p224r1_mmull:

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13
acc6 equ r14
acc7 equ r15

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ rbp
t4 equ rbx

;        rdi   assumed as result
aPtr equ rsi
bPtr equ rbx

   xor   acc5, acc5

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[0]
   mov   rax, qword ptr[bPtr+sizeof(qword)*0]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   mov   acc0, rax
   mov   acc1, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*0]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc1, rax
   adc   rdx, 0
   mov   acc2, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*0]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc2, rax
   adc   rdx, 0
   mov   acc3, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*0]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc3, rax
   adc   rdx, 0
   mov   acc4, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 0
   p224r1_prod_redstep  acc4,acc3,acc2,acc1,acc0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[1]
   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc1, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc2, rcx
   adc   rdx, 0
   add   acc2, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc3, rcx
   adc   rdx, 0
   add   acc3, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc4, rcx
   adc   rdx, 0
   add   acc4, rax
   adc   rdx, 0
   mov   acc5, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 1
   p224r1_prod_redstep  acc5,acc4,acc3,acc2,acc1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[2]
   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc2, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc3, rcx
   adc   rdx, 0
   add   acc3, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc4, rcx
   adc   rdx, 0
   add   acc4, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc5, rcx
   adc   rdx, 0
   add   acc5, rax
   adc   rdx, 0
   mov   acc6, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 2
   p224r1_prod_redstep  acc6,acc5,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[3]
   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc3, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc4, rcx
   adc   rdx, 0
   add   acc4, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc5, rcx
   adc   rdx, 0
   add   acc5, rax
   adc   rdx, 0
   mov   rcx, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc6, rcx
   adc   rdx, 0
   add   acc6, rax
   adc   rdx, 0
   mov   acc7, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 3 (final)
   p224r1_prod_redstep  acc7,acc6,acc5,acc4,acc3
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov   acc0, acc4     ;; copy reducted result
   mov   acc1, acc5
   mov   acc2, acc6
   mov   acc3, acc7

   sub   acc4, t0       ;; test if it exceeds prime value
   sbb   acc5, t1
   sbb   acc6, t2
   sbb   acc7, t3

   cmovc  acc4, acc0
   cmovc  acc5, acc1
   cmovc  acc6, acc2
   cmovc  acc7, acc3

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc6
   mov   qword ptr[rdi+sizeof(qword)*3], acc7

   ret

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
p224r1_mmulx:

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13
acc6 equ r14
acc7 equ r15

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ rbp
t4 equ rbx

;        rdi   assumed as result
aPtr equ rsi
bPtr equ rbx

   xor   acc5, acc5

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[0]
   mov   rdx, qword ptr[bPtr+sizeof(qword)*0]
   mulx  acc1,acc0, qword ptr[aPtr+sizeof(qword)*0]
   mulx  acc2,t2,   qword ptr[aPtr+sizeof(qword)*1]
   add   acc1,t2
   mulx  acc3,t2,   qword ptr[aPtr+sizeof(qword)*2]
   adc   acc2,t2 
   mulx  acc4,t2,   qword ptr[aPtr+sizeof(qword)*3]
   adc   acc3,t2
   adc   acc4,0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 0
   p224r1_prod_redstep  acc4,acc3,acc2,acc1,acc0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[1]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*1]
   xor   t0, t0

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc1, t2
   adox  %acc2, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc2, t2
   adox  %acc3, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc3, t2
   adox  %acc4, t3

   mulx  acc5, t2, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc4, t2
   adox  %acc5, t0
   adc   acc5, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 1
   p224r1_prod_redstep  acc5,acc4,acc3,acc2,acc1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[2]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*2]
   xor   t0, t0

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc2, t2
   adox  %acc3, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc3, t2
   adox  %acc4, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc4, t2
   adox  %acc5, t3

   mulx  acc6, t2, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc5, t2
   adox  %acc6, t0
   adc   acc6, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 2
   p224r1_prod_redstep  acc6,acc5,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[3]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*3]
   xor   t0, t0

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc3, t2
   adox  %acc4, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc4, t2
   adox  %acc5, t3

   mulx  t3, t2, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc5, t2
   adox  %acc6, t3

   mulx  acc7, t2, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc6, t2
   adox  %acc7, t0
   adc   acc7, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 3 (final)
   p224r1_prod_redstep  acc7,acc6,acc5,acc4,acc3
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov   acc0, acc4     ;; copy reducted result
   mov   acc1, acc5
   mov   acc2, acc6
   mov   acc3, acc7

   sub   acc4, t0       ;; test if it exceeds prime value
   sbb   acc5, t1
   sbb   acc6, t2
   sbb   acc7, t3

   cmovc  acc4, acc0
   cmovc  acc5, acc1
   cmovc  acc6, acc2
   cmovc  acc7, acc3

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc6
   mov   qword ptr[rdi+sizeof(qword)*3], acc7

   ret
ENDIF

IPPASM p224r1_mul_montl PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi, r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  p224r1_mmull

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_mul_montl ENDP

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mul_montx PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  p224r1_mmulx

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_mul_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_to_mont(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_to_mont PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

   lea   rbx, LRR
   call  p224r1_mmull
   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_to_mont ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_sqr_montl(uint64_t res[4], uint64_t a[4]);
; void p224r1_sqr_montx(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_sqr_montl PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

   mov   rbx, rsi
   call  p224r1_mmull

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_sqr_montl ENDP

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_sqr_montx PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

   mov   rbx, rsi
   call  p224r1_mmulx

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_sqr_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_mont_back(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_mont_back PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13
acc6 equ r14
acc7 equ r15

t0 equ   rax
t1 equ   rdx
t2 equ   rcx
t3 equ   rsi

   mov   acc0, qword ptr[rsi+sizeof(qword)*0]
   mov   acc1, qword ptr[rsi+sizeof(qword)*1]
   mov   acc2, qword ptr[rsi+sizeof(qword)*2]
   mov   acc3, qword ptr[rsi+sizeof(qword)*3]
   xor   acc4, acc4
   xor   acc5, acc5
   xor   acc6, acc6
   xor   acc7, acc7

   p224r1_prod_redstep acc4,acc3,acc2,acc1,acc0
   p224r1_prod_redstep acc5,acc4,acc3,acc2,acc1
   p224r1_prod_redstep acc6,acc5,acc4,acc3,acc2
   p224r1_prod_redstep acc7,acc6,acc5,acc4,acc3

   mov   acc0, acc4
   mov   acc1, acc5
   mov   acc2, acc6
   mov   acc3, acc7

   sub   acc4, qword ptr Lpoly+sizeof(qword)*0
   sbb   acc5, qword ptr Lpoly+sizeof(qword)*1
   sbb   acc6, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc7, qword ptr Lpoly+sizeof(qword)*3

   cmovc acc4, acc0
   cmovc acc5, acc1
   cmovc acc6, acc2
   cmovc acc7, acc3

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc6
   mov   qword ptr[rdi+sizeof(qword)*3], acc7

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_mont_back ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_select_pp_w5(POINT *val, const POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_select_pp_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
   COMP_ABI 3


val   equ   rdi
in_t  equ   rsi
idx   equ   edx

ONE   equ   xmm0
INDEX equ   xmm1

Ra equ   xmm2
Rb equ   xmm3
Rc equ   xmm4
Rd equ   xmm5
Re equ   xmm6
Rf equ   xmm7

M0    equ xmm8
T0a   equ xmm9
T0b   equ xmm10
T0c   equ xmm11
T0d   equ xmm12
T0e   equ xmm13
T0f   equ xmm14
TMP0  equ xmm15

   movdqa   ONE, oword ptr LOne

   movdqa   M0, ONE

   movd     INDEX, idx
   pshufd   INDEX, INDEX, 0

   pxor     Ra, Ra
   pxor     Rb, Rb
   pxor     Rc, Rc
   pxor     Rd, Rd
   pxor     Re, Re
   pxor     Rf, Rf

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop_sse_w5:
      movdqa   TMP0, M0
      pcmpeqd  TMP0, INDEX
      paddd    M0, ONE

      movdqa   T0a, oword ptr[in_t+sizeof(oword)*0]
      movdqa   T0b, oword ptr[in_t+sizeof(oword)*1]
      movdqa   T0c, oword ptr[in_t+sizeof(oword)*2]
      movdqa   T0d, oword ptr[in_t+sizeof(oword)*3]
      movdqa   T0e, oword ptr[in_t+sizeof(oword)*4]
      movdqa   T0f, oword ptr[in_t+sizeof(oword)*5]
      add      in_t, sizeof(oword)*6

      pand     T0a, TMP0
      pand     T0b, TMP0
      pand     T0c, TMP0
      pand     T0d, TMP0
      pand     T0e, TMP0
      pand     T0f, TMP0

      por      Ra, T0a
      por      Rb, T0b
      por      Rc, T0c
      por      Rd, T0d
      por      Re, T0e
      por      Rf, T0f
      dec      rcx
      jnz      select_loop_sse_w5

   movdqu   oword ptr[val+sizeof(oword)*0], Ra
   movdqu   oword ptr[val+sizeof(oword)*1], Rb
   movdqu   oword ptr[val+sizeof(oword)*2], Rc
   movdqu   oword ptr[val+sizeof(oword)*3], Rd
   movdqu   oword ptr[val+sizeof(oword)*4], Re
   movdqu   oword ptr[val+sizeof(oword)*5], Rf

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_select_pp_w5 ENDP

IFNDEF _DISABLE_ECP_224R1_HARDCODED_BP_TBL_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p224r1_select_ap_w7(AF_POINT *val, const AF_POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p224r1_select_ap_w7 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
   COMP_ABI 3

val   equ   rdi
in_t  equ   rsi
idx   equ   edx

ONE   equ   xmm0
INDEX equ   xmm1

Ra equ   xmm2
Rb equ   xmm3
Rc equ   xmm4
Rd equ   xmm5

M0    equ xmm8
T0a   equ xmm9
T0b   equ xmm10
T0c   equ xmm11
T0d   equ xmm12
TMP0  equ xmm15

   movdqa   ONE, oword ptr LOne

   pxor     Ra, Ra
   pxor     Rb, Rb
   pxor     Rc, Rc
   pxor     Rd, Rd

   movdqa   M0, ONE

   movd     INDEX, idx
   pshufd   INDEX, INDEX, 0

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 64
select_loop_sse_w7:
      movdqa   TMP0, M0
      pcmpeqd  TMP0, INDEX
      paddd    M0, ONE

      movdqa   T0a, oword ptr[in_t+sizeof(oword)*0]
      movdqa   T0b, oword ptr[in_t+sizeof(oword)*1]
      movdqa   T0c, oword ptr[in_t+sizeof(oword)*2]
      movdqa   T0d, oword ptr[in_t+sizeof(oword)*3]
      add      in_t, sizeof(oword)*4

      pand     T0a, TMP0
      pand     T0b, TMP0
      pand     T0c, TMP0
      pand     T0d, TMP0

      por      Ra, T0a
      por      Rb, T0b
      por      Rc, T0c
      por      Rd, T0d
      dec      rcx
      jnz      select_loop_sse_w7

   movdqu   oword ptr[val+sizeof(oword)*0], Ra
   movdqu   oword ptr[val+sizeof(oword)*1], Rb
   movdqu   oword ptr[val+sizeof(oword)*2], Rc
   movdqu   oword ptr[val+sizeof(oword)*3], Rd

   REST_XMM
   REST_GPR
   ret
IPPASM p224r1_select_ap_w7 ENDP
ENDIF

ENDIF
END
