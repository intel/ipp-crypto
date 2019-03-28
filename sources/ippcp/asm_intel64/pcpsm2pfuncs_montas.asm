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
;               SM2 specific implementation
; 

include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

_xEMULATION_ = 1
_ADCX_ADOX_ = 1

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

;; The SM2 polynomial
Lpoly DQ 0FFFFFFFFFFFFFFFFh,0FFFFFFFF00000000h,0FFFFFFFFFFFFFFFFh,0FFFFFFFEFFFFFFFFh
 
;; 2^512 mod P precomputed for SM2 polynomial
LRR   DQ 00000000200000003h,000000002ffffffffh,00000000100000001h,00000000400000002h

LOne     DD    1,1,1,1,1,1,1,1
LTwo     DD    2,2,2,2,2,2,2,2
LThree   DD    3,3,3,3,3,3,3,3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_mul_by_2(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_mul_by_2 PROC PUBLIC FRAME
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
IPPASM sm2_mul_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_div_by_2(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_div_by_2 PROC PUBLIC FRAME
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
IPPASM sm2_div_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_mul_by_3(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_mul_by_3 PROC PUBLIC FRAME
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
IPPASM sm2_mul_by_3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_add(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_add PROC PUBLIC FRAME
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
IPPASM sm2_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_sub(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_sub PROC PUBLIC FRAME
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
IPPASM sm2_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_neg(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_neg PROC PUBLIC FRAME
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
IPPASM sm2_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_mul_montl(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; on entry p5=0
; on exit  p0=0, p5=0/1
;
sm2_mul_redstep MACRO p5,p4,p3,p2,p1,p0
   mov   acc6, p0   ;; (u1:u0) = p0*2^32
   shl   acc6, 32
   mov   acc7, p0
   shr   acc7, 32

   mov   t0, p0
   mov   t4, p0
   xor   t1, t1
   xor   t3, t3

   sub   t0, acc6 ;; (t3:t2:t1:t0) = p0*2^256 -p0*2^224 +p0*2^64 -p0*2^96
   sbb   t1, acc7
   sbb   t3, acc6
   sbb   t4, acc7

   add   p1, t0   ;; (p5:p4:p3:p2:p1) -= (t3:t2:t1:t0)
   adc   p2, t1
   adc   p3, t3
   adc   p4, t4
   adc   p5, 0    ;; p5 extension
   xor   p0, p0   ;; p0 = 0;
ENDM

ALIGN IPP_ALIGN_FACTOR
sm2_mmull:

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
t5 equ r14

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
   ;; 1-st reduction step
   sm2_mul_redstep acc5,acc4,acc3,acc2,acc1,acc0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[1]
   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc1, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc2, t0
   adc   rdx, 0
   add   acc2, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc3, t0
   adc   rdx, 0
   add   acc3, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*1]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc4, t0
   adc   rdx, 0
   add   acc4, rax
   adc   acc5, rdx
   adc   acc0, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; 2-ndt reduction step
   sm2_mul_redstep acc0,acc5,acc4,acc3,acc2,acc1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[2]
   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc2, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc3, t0
   adc   rdx, 0
   add   acc3, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc4, t0
   adc   rdx, 0
   add   acc4, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*2]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc5, t0
   adc   rdx, 0
   add   acc5, rax
   adc   acc0, rdx
   adc   acc1, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; 3-rd reduction step
   sm2_mul_redstep acc1,acc0,acc5,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[3]
   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*0]
   add   acc3, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*1]
   add   acc4, t0
   adc   rdx, 0
   add   acc4, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*2]
   add   acc5, t0
   adc   rdx, 0
   add   acc5, rax
   adc   rdx, 0
   mov   t0, rdx

   mov   rax, qword ptr[bPtr+sizeof(qword)*3]
   mul   qword ptr[aPtr+sizeof(qword)*3]
   add   acc0, t0
   adc   rdx, 0
   add   acc0, rax
   adc   acc1, rdx
   adc   acc2, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; final reduction step
   sm2_mul_redstep acc2,acc1,acc0,acc5,acc4,acc3

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov   t4, acc4
   mov   acc3, acc5
   mov   acc6, acc0
   mov   acc7, acc1

   sub   t4,   t0       ;; test if it exceeds prime value
   sbb   acc3, t1
   sbb   acc6, t2
   sbb   acc7, t3
   sbb   acc2, 0

   cmovnc acc4, t4
   cmovnc acc5, acc3
   cmovnc acc0, acc6
   cmovnc acc1, acc7

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc0
   mov   qword ptr[rdi+sizeof(qword)*3], acc1

   ret

ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_mul_montl PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  sm2_mmull

   REST_XMM
   REST_GPR
   ret
IPPASM sm2_mul_montl ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_to_mont(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_to_mont PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

   lea   rbx, LRR
   call  sm2_mmull
   REST_XMM
   REST_GPR
   ret
IPPASM sm2_to_mont ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_mul_montx(uint64_t res[4], uint64_t a[4], uint64_t b[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
sm2_mmulx:

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
t3 equ rcx
t4 equ rbp
t2 equ rbx

;        rdi   assumed as result
aPtr equ rsi
bPtr equ rbx

   xor   acc5, acc5

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[0]
   xor   rdx, rdx
   mov   rdx, qword ptr[bPtr+sizeof(qword)*0]
   mulx  acc1,acc0, qword ptr[aPtr+sizeof(qword)*0]
   mulx  acc2,t3,   qword ptr[aPtr+sizeof(qword)*1]
   add   acc1,t3
   mulx  acc3,t3,   qword ptr[aPtr+sizeof(qword)*2]
   adc   acc2,t3 
   mulx  acc4,t3,   qword ptr[aPtr+sizeof(qword)*3]
   adc   acc3,t3
   adc   acc4,0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 0
   sm2_mul_redstep acc5,acc4,acc3,acc2,acc1,acc0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[1]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*1]

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc1, t3
   adox  %acc2, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc2, t3
   adox  %acc3, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc3, t3
   adox  %acc4, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc4, t3
   adox  %acc5, t4

   adcx  %acc5, acc0
   adox  %acc0, acc0
   adc   acc0, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 1
   sm2_mul_redstep acc0,acc5,acc4,acc3,acc2,acc1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[2]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*2]

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc2, t3
   adox  %acc3, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc3, t3
   adox  %acc4, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc4, t3
   adox  %acc5, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc5, t3
   adox  %acc0, t4

   adcx  %acc0, acc1
   adox  %acc1, acc1
   
   adc   acc1, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 2
   sm2_mul_redstep acc1,acc0,acc5,acc4,acc3,acc2

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; * b[3]
   mov   rdx,    qword ptr[bPtr+sizeof(qword)*3]

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*0]
   adcx  %acc3, t3
   adox  %acc4, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*1]
   adcx  %acc4, t3
   adox  %acc5, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc5, t3
   adox  %acc0, t4

   mulx  t4, t3, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc0, t3
   adox  %acc1, t4

   adcx  %acc1, acc2
   adox  %acc2, acc2
   adc   acc2, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; reduction step 3 (final)
   sm2_mul_redstep acc2,acc1,acc0,acc5,acc4,acc3

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov   t4,   acc4     ;; copy reducted result
   mov   acc3, acc5
   mov   acc6, acc0
   mov   acc7, acc1

   sub   t4,   t0       ;; test if it exceeds prime value
   sbb   acc3, t1
   sbb   acc6, t2
   sbb   acc7, t3
   sbb   acc2, 0

   cmovnc acc4, t4
   cmovnc acc5, acc3
   cmovnc acc0, acc6
   cmovnc acc1, acc7

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc0
   mov   qword ptr[rdi+sizeof(qword)*3], acc1

   ret
ENDIF

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_mul_montx PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

bPtr equ rbx

   mov   bPtr, rdx
   call  sm2_mmulx

   REST_XMM
   REST_GPR
   ret
IPPASM sm2_mul_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_sqr_montl(uint64_t res[4], uint64_t a[4]);
; void sm2_sqr_montx(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sm2_prod_redstep MACRO e,p4,p3,p2,p1,p0
   mov   t4, p0
   mov   t0, p0
   mov   t3, p0
   xor   t1, t1
   xor   t2, t2
   shl   p0, 32
   shr   t4, 32  ;; (t4:p0) = p0*2^32

   sub   t0, p0   ;; (t3:t2:t1:t0) = p0*2^256 -p0*2^224 +p0*2^64 -p0*2^96
   sbb   t1, t4  
   sbb   t2, p0
   sbb   t3, t4

   xor   p0, p0
   add   p1, t0   ;; (p5:p4:p3:p2:p1) -= (t3:t2:t1:t0)
   adc   p2, t1
   adc   p3, t2
   adc   p4, t3
   adc   p0, 0

   IFNB <e>
   add   p4, e
   adc   p0, 0
   ENDIF
   
ENDM

ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_sqr_montl PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
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

t0 equ rcx
t1 equ rbp
t2 equ rbx
t3 equ rdx
t4 equ rax

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
   mov   rax,qword ptr[aPtr+sizeof(qword)*3]
   mul   t2
   add   acc3, rax
   adc   rdx, 0
   mov   acc4, rdx
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[aPtr+sizeof(qword)*1]
   mov   rax,qword ptr[aPtr+sizeof(qword)*2]
   mul   t2
   add   acc3, rax
   adc   rdx, 0
   mov   t1, rdx
   mov   rax,qword ptr[aPtr+sizeof(qword)*3]
   mul   t2
   add   acc4, rax
   adc   rdx, 0
   add   acc4, t1
   adc   rdx, 0
   mov   acc5, rdx
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   t2, qword ptr[aPtr+sizeof(qword)*2]
   mov   rax,qword ptr[aPtr+sizeof(qword)*3]
   mul   t2
   add   acc5, rax
   adc   rdx, 0
   mov   acc6, rdx

   xor   acc7, acc7
   shld  acc7, acc6, 1
   shld  acc6, acc5, 1
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
   adc   acc6, 0
   mov   rax,qword ptr[aPtr+sizeof(qword)*3]
   mul   rax
   add   acc6, rax
   adc   acc7, rdx

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   sm2_prod_redstep      ,acc4,acc3,acc2,acc1,acc0
   sm2_prod_redstep  acc0,acc5,acc4,acc3,acc2,acc1
   sm2_prod_redstep  acc1,acc6,acc5,acc4,acc3,acc2
   sm2_prod_redstep  acc2,acc7,acc6,acc5,acc4,acc3
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov     t4, acc4
   mov   acc0, acc5
   mov   acc1, acc6
   mov   acc2, acc7

   sub     t4, t0
   sbb   acc0, t1
   sbb   acc1, t2
   sbb   acc2, t3
   sbb   acc3, 0

   cmovnc acc4, t4
   cmovnc acc5, acc0
   cmovnc acc6, acc1
   cmovnc acc7, acc2

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc6
   mov   qword ptr[rdi+sizeof(qword)*3], acc7

   REST_XMM
   REST_GPR
   ret
IPPASM sm2_sqr_montl ENDP

IF _IPP32E GE _IPP32E_L9
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_sqr_montx PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
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

t0 equ rcx
t1 equ rbp
t2 equ rbx
t3 equ rdx
t4 equ rax

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   rdx,  qword ptr[aPtr+sizeof(qword)*0]
   mulx  acc2, acc1, qword ptr[aPtr+sizeof(qword)*1]
   mulx  acc3, t0,   qword ptr[aPtr+sizeof(qword)*2]
   add   acc2, t0
   mulx  acc4, t0,   qword ptr[aPtr+sizeof(qword)*3]
   adc   acc3, t0
   adc   acc4, 0
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   rdx, qword ptr[aPtr+sizeof(qword)*1]
   xor   acc5, acc5
   mulx  t1, t0, qword ptr[aPtr+sizeof(qword)*2]
   adcx  %acc3, t0
   adox  %acc4, t1
   mulx  t1, t0, qword ptr[aPtr+sizeof(qword)*3]
   adcx  %acc4, t0
   adox  %acc5, t1
   adc   acc5, 0
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   mov   rdx, qword ptr[aPtr+sizeof(qword)*2]
   mulx  acc6, t0, qword ptr[aPtr+sizeof(qword)*3]
   add   acc5, t0
   adc   acc6, 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   xor   acc7, acc7
   shld  acc7, acc6, 1
   shld  acc6, acc5, 1
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
   mov   rdx, qword ptr[aPtr+sizeof(qword)*3]
   mulx  t1, t0, rdx
   adcx  %acc6, t0
   adcx  %acc7, t1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   sm2_prod_redstep      ,acc4,acc3,acc2,acc1,acc0
   sm2_prod_redstep  acc0,acc5,acc4,acc3,acc2,acc1
   sm2_prod_redstep  acc1,acc6,acc5,acc4,acc3,acc2
   sm2_prod_redstep  acc2,acc7,acc6,acc5,acc4,acc3
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   mov   t0, qword ptr Lpoly+sizeof(qword)*0
   mov   t1, qword ptr Lpoly+sizeof(qword)*1
   mov   t2, qword ptr Lpoly+sizeof(qword)*2
   mov   t3, qword ptr Lpoly+sizeof(qword)*3

   mov     t4, acc4
   mov   acc0, acc5
   mov   acc1, acc6
   mov   acc2, acc7

   sub     t4, t0
   sbb   acc0, t1
   sbb   acc1, t2
   sbb   acc2, t3
   sbb   acc3, 0

   cmovnc acc4, t4
   cmovnc acc5, acc0
   cmovnc acc6, acc1
   cmovnc acc7, acc2

   mov   qword ptr[rdi+sizeof(qword)*0], acc4
   mov   qword ptr[rdi+sizeof(qword)*1], acc5
   mov   qword ptr[rdi+sizeof(qword)*2], acc6
   mov   qword ptr[rdi+sizeof(qword)*3], acc7

   REST_XMM
   REST_GPR
   ret
IPPASM sm2_sqr_montx ENDP
ENDIF ;; _IPP32E_L9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_mont_back(uint64_t res[4], uint64_t a[4]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_mont_back PROC PUBLIC FRAME
   USES_GPR rbp,rbx, rsi,rdi,r12,r13,r14,r15
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

t0 equ rcx
t1 equ rbp
t2 equ rbx
t3 equ rdx
t4 equ rax

   mov   acc2, qword ptr[rsi+sizeof(qword)*0]
   mov   acc3, qword ptr[rsi+sizeof(qword)*1]
   mov   acc4, qword ptr[rsi+sizeof(qword)*2]
   mov   acc5, qword ptr[rsi+sizeof(qword)*3]
   xor   acc0, acc0
   xor   acc1, acc1

   sm2_mul_redstep acc1,acc0,acc5,acc4,acc3,acc2
   sm2_mul_redstep acc2,acc1,acc0,acc5,acc4,acc3
   sm2_mul_redstep acc3,acc2,acc1,acc0,acc5,acc4
   sm2_mul_redstep acc4,acc3,acc2,acc1,acc0,acc5

   mov   t0, acc0
   mov   t1, acc1
   mov   t2, acc2
   mov   t3, acc3

   sub   t0, qword ptr Lpoly+sizeof(qword)*0
   sbb   t1, qword ptr Lpoly+sizeof(qword)*1
   sbb   t2, qword ptr Lpoly+sizeof(qword)*2
   sbb   t3, qword ptr Lpoly+sizeof(qword)*3
   sbb   acc4, 0

   cmovnc acc0, t0
   cmovnc acc1, t1
   cmovnc acc2, t2
   cmovnc acc3, t3

   mov   qword ptr[rdi+sizeof(qword)*0], acc0
   mov   qword ptr[rdi+sizeof(qword)*1], acc1
   mov   qword ptr[rdi+sizeof(qword)*2], acc2
   mov   qword ptr[rdi+sizeof(qword)*3], acc3

   REST_XMM
   REST_GPR
   ret
IPPASM sm2_mont_back ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_select_pp_w5(SM2_POINT *val, const SM2_POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_select_pp_w5 PROC PUBLIC FRAME
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
IPPASM sm2_select_pp_w5 ENDP

IF _IPP32E LT _IPP32E_L9
IFNDEF _DISABLE_ECP_SM2_HARDCODED_BP_TBL_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void sm2_select_ap_w7(SM2_POINT *val, const SM2_POINT *in_t, int index);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM sm2_select_ap_w7 PROC PUBLIC FRAME
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
IPPASM sm2_select_ap_w7 ENDP
ENDIF
ENDIF ;; _IPP32E < _IPP32E_L9

ENDIF ;; _IPP32E>=_IPP32E_M7
END
