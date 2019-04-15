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
;               secp p192r1 specific implementation
; 
 

include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

_xEMULATION_ = 1
_ADCX_ADOX_ = 1

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

;; The p192r1 polynomial
Lpoly DQ 0FFFFFFFFFFFFFFFFh,0FFFFFFFFFFFFFFFEh,0FFFFFFFFFFFFFFFFh

;; 2^(192*2) mod P precomputed for p192r1 polynomial
LRR   DQ 00000000000000001h,00000000000000002h,00000000000000001h

LOne     DD    1,1,1,1,1,1,1,1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_mul_by_2(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_mul_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   xor   t3, t3

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]

   shld  t3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0, 1

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_mul_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_div_by_2(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_div_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]

   xor   t3,  t3
   xor   r13, r13

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   adc   t3, 0
   test  a0, 1

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2
   cmovnz r13,t3

   shrd  a0, a1, 1
   shrd  a1, a2, 1
   shrd  a2, r13,1

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_div_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_mul_by_3(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_mul_by_3 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   xor   t3, t3

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]

   shld  t3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0, 1

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2

   xor   t3, t3
   add   a0, qword ptr[rsi+sizeof(qword)*0]
   adc   a1, qword ptr[rsi+sizeof(qword)*1]
   adc   a2, qword ptr[rsi+sizeof(qword)*2]
   adc   t3, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, 0

   cmovz   a0, t0
   cmovz   a1, t1
   cmovz   a2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_mul_by_3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_add(uint64_t res[3], uint64_t a[3], uint64_t b[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_add PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   xor   t3,  t3

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]

   add   a0, qword ptr[rdx+sizeof(qword)*0]
   adc   a1, qword ptr[rdx+sizeof(qword)*1]
   adc   a2, qword ptr[rdx+sizeof(qword)*2]
   adc   t3, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, 0

   cmovz a0, t0
   cmovz a1, t1
   cmovz a2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_sub(uint64_t res[3], uint64_t a[3], uint64_t b[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_sub PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   xor   t3,  t3

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]

   sub   a0, qword ptr[rdx+sizeof(qword)*0]
   sbb   a1, qword ptr[rdx+sizeof(qword)*1]
   sbb   a2, qword ptr[rdx+sizeof(qword)*2]
   sbb   t3, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   test  t3, t3

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_neg(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_neg PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10

t0 equ rax
t1 equ rdx
t2 equ rcx
t3 equ r12

   xor   t3, t3

   xor   a0, a0
   xor   a1, a1
   xor   a2, a2

   sub   a0, qword ptr[rsi+sizeof(qword)*0]
   sbb   a1, qword ptr[rsi+sizeof(qword)*1]
   sbb   a2, qword ptr[rsi+sizeof(qword)*2]
   sbb   t3, 0

   mov   t0, a0
   mov   t1, a1
   mov   t2, a2

   add   t0, qword ptr Lpoly+sizeof(qword)*0
   adc   t1, qword ptr Lpoly+sizeof(qword)*1
   adc   t2, qword ptr Lpoly+sizeof(qword)*2
   test  t3, t3

   cmovnz a0, t0
   cmovnz a1, t1
   cmovnz a2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_mul_montl(uint64_t res[3], uint64_t a[3], uint64_t b[3]);
; void p192r1_mul_montx(uint64_t res[3], uint64_t a[3], uint64_t b[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; product = {p3,p2,p1,p0}, p4=0
; product += 2^192*p0 -2^64*p0 -p0
;
; on entry p4=0
; on exit  p0=0
;
p192r1_mul_redstep MACRO p4,p3,p2,p1,p0
   sub   p1, p0
   sbb   p2, 0
   sbb   p0, 0
   add   p3, p0
   adc   p4, 0
   xor   p0, p0
ENDM

ALIGN IPP_ALIGN_FACTOR
p192r1_mmull:

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12

t0 equ rax
t1 equ rdx
t2 equ rcx

;        rdi   assumed as result
aPtr equ rsi
bPtr equ rbx

   xor   acc4, acc4

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

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 0
   p192r1_mul_redstep acc4,acc3,acc2,acc1,acc0

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
   adc   acc4, rdx
   adc   acc0, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 1
   p192r1_mul_redstep acc0,acc4,acc3,acc2,acc1

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
   adc   acc0, rdx
   adc   acc1, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 2 (final)
   p192r1_mul_redstep acc1,acc0,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t0, acc3     ;; copy reducted result
   mov   t1, acc4
   mov   t2, acc0

   sub   t0, qword ptr Lpoly+sizeof(qword)*0 ;; test if it exceeds prime value
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc1, 0

   cmovnc acc3, t0
   cmovnc acc4, t1
   cmovnc acc0, t2

   mov   qword ptr[rdi+sizeof(qword)*0], acc3
   mov   qword ptr[rdi+sizeof(qword)*1], acc4
   mov   qword ptr[rdi+sizeof(qword)*2], acc0

   ret

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
p192r1_mmulx:

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12

t0 equ rax
t1 equ rdx
t2 equ rcx

;        rdi   assumed as result
aPtr equ rsi
bPtr equ rbx

   xor   acc4, acc4

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[0]
   xor   rdx, rdx
   mov   rdx, qword ptr[bPtr+sizeof(qword)*0]
   mulx  acc1,acc0, qword ptr[aPtr+sizeof(qword)*0]
   mulx  acc2,t2,   qword ptr[aPtr+sizeof(qword)*1]
   add   acc1,t2
   mulx  acc3,t2,   qword ptr[aPtr+sizeof(qword)*2]
   adc   acc2,t2 
   adc   acc3,0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 0
   p192r1_mul_redstep acc4,acc3,acc2,acc1,acc0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[1]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*1]

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc1, t2
   adox  %acc2, t0

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc2, t2
   adox  %acc3, t0

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc3, t2
   adox  %acc4, t0

   adcx  %acc4, acc0
   adox  %acc0, acc0
   adc   acc0, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 1
   p192r1_mul_redstep acc0,acc4,acc3,acc2,acc1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[2]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*2]

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc2, t2
   adox  %acc3, t0

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc3, t2
   adox  %acc4, t0

   mulx  t0, t2, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc4, t2
   adox  %acc0, t0

   adcx  %acc0, acc1
   adox  %acc1, acc1
   adc   acc1, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 2 (final)
   p192r1_mul_redstep acc1,acc0,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t0, acc3     ;; copy reducted result
   mov   t1, acc4
   mov   t2, acc0

   sub   t0, qword ptr Lpoly+sizeof(qword)*0 ;; test if it exceeds prime value
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc1, 0

   cmovnc acc3, t0
   cmovnc acc4, t1
   cmovnc acc0, t2

   mov   qword ptr[rdi+sizeof(qword)*0], acc3
   mov   qword ptr[rdi+sizeof(qword)*1], acc4
   mov   qword ptr[rdi+sizeof(qword)*2], acc0

   ret
ENDIF

ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_mul_montl PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  p192r1_mmull

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_mul_montl ENDP

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_mul_montx PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  p192r1_mmulx

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_mul_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_to_mont(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_to_mont PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

   lea   rbx, LRR
   call  p192r1_mmull
   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_to_mont ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_sqr_montl(uint64_t res[3], uint64_t a[3]);
; void p192r1_sqr_montx(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; on entry e = expasion (previous step)
; on exit  p0= expasion (next step)
;
p192r1_prod_redstep MACRO e,p3,p2,p1,p0
   sub   p1, p0
   sbb   p2, 0
   sbb   p0, 0
   add   p3, p0
   mov   p0, 0
   adc   p0, 0

   IFNB <e>
   add   p3, e
   adc   p0, 0
   ENDIF
ENDM

ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_sqr_montl PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13

t0 equ rax
t1 equ rdx
t2 equ rcx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[aPtr+sizeof(qword)*0]
   mov   rax,qword ptr[aPtr+sizeof(qword)*1]
   mul   t2
   mov   acc1, rax
   mov   acc2, rdx
   mov   rax,qword ptr[aPtr+sizeof(qword)*2]
   mul   t2
   add   acc2, rax
   adc   rdx, 0
   mov   acc3, rdx
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[aPtr+sizeof(qword)*1]
   mov   rax,qword ptr[aPtr+sizeof(qword)*2]
   mul   t2
   add   acc3, rax
   adc   rdx, 0
   mov   acc4, rdx

   xor   acc5, acc5
   shld  acc5, acc4, 1
   shld  acc4, acc3, 1
   shld  acc3, acc2, 1
   shld  acc2, acc1, 1
   shl   acc1, 1

   mov   rax,qword ptr[aPtr+sizeof(qword)*0]
   mul   rax
   mov   acc0, rax
   add   acc1, rdx
   adc   acc2, 0
   mov   rax,qword ptr[aPtr+sizeof(qword)*1]
   mul   rax
   add   acc2, rax
   adc   acc3, rdx
   adc   acc4, 0
   mov   rax,qword ptr[aPtr+sizeof(qword)*2]
   mul   rax
   add   acc4, rax
   adc   acc5, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   p192r1_prod_redstep      ,acc3,acc2,acc1,acc0
   p192r1_prod_redstep  acc0,acc4,acc3,acc2,acc1
   p192r1_prod_redstep  acc1,acc5,acc4,acc3,acc2
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, acc3
   mov   t1, acc4
   mov   t2, acc5

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc2, 0

   cmovnc acc3, t0
   cmovnc acc4, t1
   cmovnc acc5, t2

   mov   qword ptr[rdi+sizeof(qword)*0], acc3
   mov   qword ptr[rdi+sizeof(qword)*1], acc4
   mov   qword ptr[rdi+sizeof(qword)*2], acc5

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_sqr_montl ENDP

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_sqr_montx PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12
acc5 equ r13

t0 equ rcx
t1 equ rax
t2 equ rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   rdx,  qword ptr[aPtr+sizeof(qword)*0]
   mulx  acc2, acc1, qword ptr[aPtr+sizeof(qword)*1]
   mulx  acc3, t0,   qword ptr[aPtr+sizeof(qword)*2]
   add   acc2, t0
   adc   acc3, 0
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   rdx, qword ptr[aPtr+sizeof(qword)*1]
   mulx  acc4, t0, qword ptr[aPtr+sizeof(qword)*2]
   add   acc3, t0
   adc   acc4, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   xor   acc5, acc5
   shld  acc5, acc4, 1
   shld  acc4, acc3, 1
   shld  acc3, acc2, 1
   shld  acc2, acc1, 1
   shl   acc1, 1

   xor   acc0, acc0
   mov   rdx, qword ptr[aPtr+sizeof(qword)*0]
   mulx  t1, acc0, rdx
   adcx  %acc1, t1
   mov   rdx, qword ptr[aPtr+sizeof(qword)*1]
   mulx  t1, t0, rdx
   adcx  %acc2, t0
   adcx  %acc3, t1
   mov   rdx, qword ptr[aPtr+sizeof(qword)*2]
   mulx  t1, t0, rdx
   adcx  %acc4, t0
   adcx  %acc5, t1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   p192r1_prod_redstep      ,acc3,acc2,acc1,acc0
   p192r1_prod_redstep  acc0,acc4,acc3,acc2,acc1
   p192r1_prod_redstep  acc1,acc5,acc4,acc3,acc2
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, acc3
   mov   t1, acc4
   mov   t2, acc5

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc2, 0

   cmovnc acc3, t0
   cmovnc acc4, t1
   cmovnc acc5, t2

   mov   qword ptr[rdi+sizeof(qword)*0], acc3
   mov   qword ptr[rdi+sizeof(qword)*1], acc4
   mov   qword ptr[rdi+sizeof(qword)*2], acc5

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_sqr_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_mont_back(uint64_t res[3], uint64_t a[3]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_mont_back PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

acc0 equ r8
acc1 equ r9
acc2 equ r10
acc3 equ r11
acc4 equ r12

t0 equ   rax
t1 equ   rdx
t2 equ   rcx
t3 equ   rsi

   mov   acc2, qword ptr[rsi+sizeof(qword)*0]
   mov   acc3, qword ptr[rsi+sizeof(qword)*1]
   mov   acc4, qword ptr[rsi+sizeof(qword)*2]
   xor   acc0, acc0
   xor   acc1, acc1

   p192r1_mul_redstep acc1,acc0,acc4,acc3,acc2
   p192r1_mul_redstep acc2,acc1,acc0,acc4,acc3
   p192r1_mul_redstep acc3,acc2,acc1,acc0,acc4

   mov   t0, acc0
   mov   t1, acc1
   mov   t2, acc2

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   acc4, 0

   cmovnc acc0, t0
   cmovnc acc1, t1
   cmovnc acc2, t2

   mov   qword ptr[rdi+sizeof(qword)*0], acc0
   mov   qword ptr[rdi+sizeof(qword)*1], acc1
   mov   qword ptr[rdi+sizeof(qword)*2], acc2

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_mont_back ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_select_pp_w5(POINT *val, const POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_select_pp_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13
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

T0a   equ xmm7
T0b   equ xmm8
T0c   equ xmm9
T0d   equ xmm10
T0e   equ xmm11

M0    equ xmm12
TMP0  equ xmm13

   movdqa   ONE, oword ptr LOne

   movdqa   M0, ONE

   movd     INDEX, idx
   pshufd   INDEX, INDEX, 0

   pxor     Ra, Ra
   pxor     Rb, Rb
   pxor     Rc, Rc
   pxor     Rd, Rd
   pxor     Re, Re

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop_sse_w5:
      movdqa   TMP0, M0
      pcmpeqd  TMP0, INDEX
      paddd    M0, ONE

      movdqu   T0a, oword ptr[in_t+sizeof(oword)*0]
      movdqu   T0b, oword ptr[in_t+sizeof(oword)*1]
      movdqu   T0c, oword ptr[in_t+sizeof(oword)*2]
      movdqu   T0d, oword ptr[in_t+sizeof(oword)*3]
      movq     T0e, qword ptr[in_t+sizeof(oword)*4]
      add      in_t, sizeof(qword)*3*3

      pand     T0a, TMP0
      pand     T0b, TMP0
      pand     T0c, TMP0
      pand     T0d, TMP0
      pand     T0e, TMP0

      por      Ra, T0a
      por      Rb, T0b
      por      Rc, T0c
      por      Rd, T0d
      por      Re, T0e
      dec      rcx
      jnz      select_loop_sse_w5

   movdqu   oword ptr[val+sizeof(oword)*0], Ra
   movdqu   oword ptr[val+sizeof(oword)*1], Rb
   movdqu   oword ptr[val+sizeof(oword)*2], Rc
   movdqu   oword ptr[val+sizeof(oword)*3], Rd
   movq     qword ptr[val+sizeof(oword)*4], Re

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_select_pp_w5 ENDP

IFNDEF _DISABLE_ECP_192R1_HARDCODED_BP_TBL_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p192r1_select_ap_w7(AF_POINT *val, const AF_POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p192r1_select_ap_w7 PROC PUBLIC FRAME
   USES_GPR rsi,rdi
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9
   COMP_ABI 3

val   equ   rdi
in_t  equ   rsi
idx   equ   edx

ONE   equ   xmm0
INDEX equ   xmm1

Ra equ   xmm2
Rb equ   xmm3
Rc equ   xmm4

T0a   equ xmm5
T0b   equ xmm6
T0c   equ xmm7

M0    equ xmm8
TMP0  equ xmm9

   movdqa   ONE, oword ptr LOne

   pxor     Ra, Ra
   pxor     Rb, Rb
   pxor     Rc, Rc

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
      add      in_t, sizeof(oword)*3

      pand     T0a, TMP0
      pand     T0b, TMP0
      pand     T0c, TMP0

      por      Ra, T0a
      por      Rb, T0b
      por      Rc, T0c
      dec      rcx
      jnz      select_loop_sse_w7

   movdqu   oword ptr[val+sizeof(oword)*0], Ra
   movdqu   oword ptr[val+sizeof(oword)*1], Rb
   movdqu   oword ptr[val+sizeof(oword)*2], Rc

   REST_XMM
   REST_GPR
   ret
IPPASM p192r1_select_ap_w7 ENDP
ENDIF

ENDIF ;; _IPP32E_M7
END
