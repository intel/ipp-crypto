;===============================================================================
; Copyright 2014-2018 Intel Corporation
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
;               secp p384r1 specific implementation
; 


include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

_xEMULATION_ = 1
_ADCX_ADOX_ = 1

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

;; The p384r1 polynomial
Lpoly DQ 000000000ffffffffh,0ffffffff00000000h,0fffffffffffffffeh
      DQ 0ffffffffffffffffh,0ffffffffffffffffh,0ffffffffffffffffh

;; 2^(2*384) mod P precomputed for p384r1 polynomial
;LRR   DQ 0fffffffe00000001h,00000000200000000h,0fffffffe00000000h
;      DQ 00000000200000000h,00000000000000001h,00000000000000000h

LOne     DD    1,1,1,1,1,1,1,1
LTwo     DD    2,2,2,2,2,2,2,2
LThree   DD    3,3,3,3,3,3,3,3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_mul_by_2(uint64_t res[6], uint64_t a[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mul_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ rax
a1 equ rcx
a2 equ rdx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   xor   ex, ex

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]

   shld  ex, a5, 1
   shld  a5, a4, 1
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   shld  a4, a3, 1
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   shld  a3, a2, 1
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   shld  a2, a1, 1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   shld  a1, a0, 1
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   shl   a0, 1
   mov   qword ptr[rdi+sizeof(qword)*0], a0

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   ex, 0

   mov      t, qword ptr[rdi+sizeof(qword)*0]
   cmovnz   a0, t
   mov      t, qword ptr[rdi+sizeof(qword)*1]
   cmovnz   a1, t
   mov      t, qword ptr[rdi+sizeof(qword)*2]
   cmovnz   a2, t
   mov      t, qword ptr[rdi+sizeof(qword)*3]
   cmovnz   a3, t
   mov      t, qword ptr[rdi+sizeof(qword)*4]
   cmovnz   a4, t
   mov      t, qword ptr[rdi+sizeof(qword)*5]
   cmovnz   a5, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_mul_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_div_by_2(uint64_t res[6], uint64_t a[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_div_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ rax
a1 equ rcx
a2 equ rdx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]

   xor   t,  t
   xor   ex, ex
   add   a0, qword ptr Lpoly+sizeof(qword)*0
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5
   adc   ex, 0

   test  a0, 1
   cmovnz   ex, t
   mov      t,  qword ptr[rsi+sizeof(qword)*0]
   cmovnz   a0, t
   mov      t,  qword ptr[rsi+sizeof(qword)*1]
   cmovnz   a1, t
   mov      t,  qword ptr[rsi+sizeof(qword)*2]
   cmovnz   a2, t
   mov      t,  qword ptr[rsi+sizeof(qword)*3]
   cmovnz   a3, t
   mov      t,  qword ptr[rsi+sizeof(qword)*4]
   cmovnz   a4, t
   mov      t,  qword ptr[rsi+sizeof(qword)*5]
   cmovnz   a5, t

   shrd  a0, a1, 1
   shrd  a1, a2, 1
   shrd  a2, a3, 1
   shrd  a3, a4, 1
   shrd  a4, a5, 1
   shrd  a5, ex, 1

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_div_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_mul_by_3(uint64_t res[6], uint64_t a[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mul_by_3 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = sizeof(qword)*6
   USES_XMM
   COMP_ABI 2

a0 equ rax
a1 equ rcx
a2 equ rdx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   xor   ex, ex

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]

   shld  ex, a5, 1
   shld  a5, a4, 1
   mov   qword ptr[rsp+sizeof(qword)*5], a5
   shld  a4, a3, 1
   mov   qword ptr[rsp+sizeof(qword)*4], a4
   shld  a3, a2, 1
   mov   qword ptr[rsp+sizeof(qword)*3], a3
   shld  a2, a1, 1
   mov   qword ptr[rsp+sizeof(qword)*2], a2
   shld  a1, a0, 1
   mov   qword ptr[rsp+sizeof(qword)*1], a1
   shl   a0, 1
   mov   qword ptr[rsp+sizeof(qword)*0], a0

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   ex, 0

   mov      t, qword ptr[rsp+0*sizeof(qword)]
   cmovb    a0, t
   mov      t, qword ptr[rsp+1*sizeof(qword)]
   cmovb    a1, t
   mov      t, qword ptr[rsp+2*sizeof(qword)]
   cmovb    a2, t
   mov      t, qword ptr[rsp+3*sizeof(qword)]
   cmovb    a3, t
   mov      t, qword ptr[rsp+4*sizeof(qword)]
   cmovb    a4, t
   mov      t, qword ptr[rsp+5*sizeof(qword)]
   cmovb    a5, t

   xor   ex, ex
   add   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   qword ptr[rsp+sizeof(qword)*0], a0
   adc   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   qword ptr[rsp+sizeof(qword)*1], a1
   adc   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   qword ptr[rsp+sizeof(qword)*2], a2
   adc   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   qword ptr[rsp+sizeof(qword)*3], a3
   adc   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   qword ptr[rsp+sizeof(qword)*4], a4
   adc   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   qword ptr[rsp+sizeof(qword)*5], a5
   adc   ex, 0

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   ex, 0

   mov      t, qword ptr[rsp+sizeof(qword)*0]
   cmovb    a0, t
   mov      t, qword ptr[rsp+sizeof(qword)*1]
   cmovb    a1, t
   mov      t, qword ptr[rsp+sizeof(qword)*2]
   cmovb    a2, t
   mov      t, qword ptr[rsp+sizeof(qword)*3]
   cmovb    a3, t
   mov      t, qword ptr[rsp+sizeof(qword)*4]
   cmovb    a4, t
   mov      t, qword ptr[rsp+sizeof(qword)*5]
   cmovb    a5, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_mul_by_3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_add(uint64_t res[6], uint64_t a[6], uint64_t b[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_add PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ rax
a1 equ rcx
a2 equ rbx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   xor   ex,  ex

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]

   add   a0, qword ptr[rdx+sizeof(qword)*0]
   adc   a1, qword ptr[rdx+sizeof(qword)*1]
   adc   a2, qword ptr[rdx+sizeof(qword)*2]
   adc   a3, qword ptr[rdx+sizeof(qword)*3]
   adc   a4, qword ptr[rdx+sizeof(qword)*4]
   adc   a5, qword ptr[rdx+sizeof(qword)*5]
   adc   ex, 0

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   ex, 0

   mov   t, qword ptr[rdi+sizeof(qword)*0]
   cmovb a0, t
   mov   t, qword ptr[rdi+sizeof(qword)*1]
   cmovb a1, t
   mov   t, qword ptr[rdi+sizeof(qword)*2]
   cmovb a2, t
   mov   t, qword ptr[rdi+sizeof(qword)*3]
   cmovb a3, t
   mov   t, qword ptr[rdi+sizeof(qword)*4]
   cmovb a4, t
   mov   t, qword ptr[rdi+sizeof(qword)*5]
   cmovb a5, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_sub(uint64_t res[6], uint64_t a[6], uint64_t b[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_sub PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ rax
a1 equ rcx
a2 equ rbx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   xor   ex, ex

   mov   a0, qword ptr[rsi+sizeof(qword)*0]  ; a
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]

   sub   a0, qword ptr[rdx+sizeof(qword)*0]  ; a-b
   sbb   a1, qword ptr[rdx+sizeof(qword)*1]
   sbb   a2, qword ptr[rdx+sizeof(qword)*2]
   sbb   a3, qword ptr[rdx+sizeof(qword)*3]
   sbb   a4, qword ptr[rdx+sizeof(qword)*4]
   sbb   a5, qword ptr[rdx+sizeof(qword)*5]

   sbb   ex, 0                               ; ex = a>=b? 0 : -1

   mov   qword ptr[rdi+sizeof(qword)*0], a0  ; store (a-b)
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   add   a0, qword ptr Lpoly+sizeof(qword)*0 ; (a-b) +poly
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5

   test  ex, ex                              ; r = (ex)? ((a-b)+poly) : (a-b)

   mov      t, qword ptr[rdi+sizeof(qword)*0]
   cmovz    a0, t
   mov      t, qword ptr[rdi+sizeof(qword)*1]
   cmovz    a1, t
   mov      t, qword ptr[rdi+sizeof(qword)*2]
   cmovz    a2, t
   mov      t, qword ptr[rdi+sizeof(qword)*3]
   cmovz    a3, t
   mov      t, qword ptr[rdi+sizeof(qword)*4]
   cmovz    a4, t
   mov      t, qword ptr[rdi+sizeof(qword)*5]
   cmovz    a5, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p384r1_neg(uint64_t res[6], uint64_t a[6]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_neg PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ rax
a1 equ rcx
a2 equ rdx
a3 equ r8
a4 equ r9
a5 equ r10
ex equ r11

t  equ r12

   xor   ex, ex

   xor   a0, a0
   xor   a1, a1
   xor   a2, a2
   xor   a3, a3
   xor   a4, a4
   xor   a5, a5

   sub   a0, qword ptr[rsi+sizeof(qword)*0]
   sbb   a1, qword ptr[rsi+sizeof(qword)*1]
   sbb   a2, qword ptr[rsi+sizeof(qword)*2]
   sbb   a3, qword ptr[rsi+sizeof(qword)*3]
   sbb   a4, qword ptr[rsi+sizeof(qword)*4]
   sbb   a5, qword ptr[rsi+sizeof(qword)*5]
   sbb   ex, 0

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   add   a0, qword ptr Lpoly+sizeof(qword)*0
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5
   test  ex, ex

   mov      t, qword ptr[rdi+sizeof(qword)*0]
   cmovz    a0, t
   mov      t, qword ptr[rdi+sizeof(qword)*1]
   cmovz    a1, t
   mov      t, qword ptr[rdi+sizeof(qword)*2]
   cmovz    a2, t
   mov      t, qword ptr[rdi+sizeof(qword)*3]
   cmovz    a3, t
   mov      t, qword ptr[rdi+sizeof(qword)*4]
   cmovz    a4, t
   mov      t, qword ptr[rdi+sizeof(qword)*5]
   cmovz    a5, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; projective point selector
;
; void p384r1_mred(Ipp464u* res, Ipp64u product);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mred_step MACRO a6,a5,a4,a3,a2,a1,a0, t2,t1
   mov   rax, a0     ;; u = (m0*a0) mod 2^64= ((2^32+1)*a0) mod 2^64
   shl   rax, 32
   add   rax, a0

   mov   t2, rax     ;; (t2:t1) = u*2^32, store
   shr   t2, (64-32)
   push  t2
   mov   t1, rax
   shl   t1, 32
   push  t1

   sub   t1, rax     ;; {t2:t1} = (2^32 -1)*u
   sbb   t2, 0

   add   a0, t1      ;; {a0:a1} += {t2:t1}
   pop   t1          ;; restore {t2:t1} = u*2^32
   adc   a1, t2      ;; and accomodate carry
   pop   t2
   sbb   t2, 0

   sub   a1, t1      ;; {a1:a2} -= {t1:t2}
   mov   t1, 0
   sbb   a2, t2
   adc   t1, 0

   sub   a2, rax     ;; a2 -= u
   adc   t1, 0

   sub   a3, t1      ;; a3 -= borrow
   sbb   a4, 0       ;; a4 -= borrow
   sbb   a5, 0       ;; a5 -= borrow

   sbb   rax, 0
   add   rax, rdx
   mov   rdx, 0
   adc   rdx, 0
   add   a6, rax
   adc   rdx, 0
ENDM

ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_mred PROC PUBLIC FRAME
      USES_GPR rsi,rdi,r12,r13,r14,r15
      USES_XMM
      COMP_ABI 2

;; rdi = result
;; rsi = product buffer

   xor   rdx, rdx
   mov   r8,  qword ptr[rsi]
   mov   r9,  qword ptr[rsi+sizeof(qword)]
   mov   r10, qword ptr[rsi+sizeof(qword)*2]
   mov   r11, qword ptr[rsi+sizeof(qword)*3]
   mov   r12, qword ptr[rsi+sizeof(qword)*4]
   mov   r13, qword ptr[rsi+sizeof(qword)*5]
   mov   r14, qword ptr[rsi+sizeof(qword)*6]
   mred_step   r14,r13,r12,r11,r10,r9,r8, r15,rcx
  ;mov   qword ptr[rdi+sizeof(qword)*0], r9
  ;mov   qword ptr[rdi+sizeof(qword)*1], r10
  ;mov   qword ptr[rdi+sizeof(qword)*2], r11
  ;mov   qword ptr[rdi+sizeof(qword)*3], r12
  ;mov   qword ptr[rdi+sizeof(qword)*4], r13
  ;mov   qword ptr[rdi+sizeof(qword)*5], r14

   mov   r8, qword ptr[rsi+sizeof(qword)*7]
   mred_step   r8,r14,r13,r12,r11,r10,r9, r15,rcx
  ;mov   qword ptr[rdi+sizeof(qword)*0], r10
  ;mov   qword ptr[rdi+sizeof(qword)*1], r11
  ;mov   qword ptr[rdi+sizeof(qword)*2], r12
  ;mov   qword ptr[rdi+sizeof(qword)*3], r13
  ;mov   qword ptr[rdi+sizeof(qword)*4], r14
  ;mov   qword ptr[rdi+sizeof(qword)*5], r8

   mov   r9, qword ptr[rsi+sizeof(qword)*8]
   mred_step   r9,r8,r14,r13,r12,r11,r10, r15,rcx
  ;mov   qword ptr[rdi+sizeof(qword)*0], r11
  ;mov   qword ptr[rdi+sizeof(qword)*1], r12
  ;mov   qword ptr[rdi+sizeof(qword)*2], r13
  ;mov   qword ptr[rdi+sizeof(qword)*3], r14
  ;mov   qword ptr[rdi+sizeof(qword)*4], r8
  ;mov   qword ptr[rdi+sizeof(qword)*5], r9

   mov   r10, qword ptr[rsi+sizeof(qword)*9]
   mred_step   r10,r9,r8,r14,r13,r12,r11, r15,rcx
  ;mov   qword ptr[rdi+sizeof(qword)*0], r12
  ;mov   qword ptr[rdi+sizeof(qword)*1], r13
  ;mov   qword ptr[rdi+sizeof(qword)*2], r14
  ;mov   qword ptr[rdi+sizeof(qword)*3], r8
  ;mov   qword ptr[rdi+sizeof(qword)*4], r9
  ;mov   qword ptr[rdi+sizeof(qword)*5], r10

   mov   r11, qword ptr[rsi+sizeof(qword)*10]
   mred_step   r11,r10,r9,r8,r14,r13,r12, r15,rcx
  ;mov   qword ptr[rdi+sizeof(qword)*0], r13
  ;mov   qword ptr[rdi+sizeof(qword)*1], r14
  ;mov   qword ptr[rdi+sizeof(qword)*2], r8
  ;mov   qword ptr[rdi+sizeof(qword)*3], r9
  ;mov   qword ptr[rdi+sizeof(qword)*4], r10
  ;mov   qword ptr[rdi+sizeof(qword)*5], r11

   mov   r12, qword ptr[rsi+sizeof(qword)*11]
   mred_step   r12,r11,r10,r9,r8,r14,r13, r15,rcx     ; {r12,r11,r10,r9,r8,r14} - result
   mov   qword ptr[rdi+sizeof(qword)*0], r14
   mov   qword ptr[rdi+sizeof(qword)*1], r8
   mov   qword ptr[rdi+sizeof(qword)*2], r9
   mov   qword ptr[rdi+sizeof(qword)*3], r10
   mov   qword ptr[rdi+sizeof(qword)*4], r11
   mov   qword ptr[rdi+sizeof(qword)*5], r12

   sub   r14, qword ptr Lpoly+sizeof(qword)*0
   sbb   r8,  qword ptr Lpoly+sizeof(qword)*1
   sbb   r9,  qword ptr Lpoly+sizeof(qword)*2
   sbb   r10, qword ptr Lpoly+sizeof(qword)*3
   sbb   r11, qword ptr Lpoly+sizeof(qword)*4
   sbb   r12, qword ptr Lpoly+sizeof(qword)*5
   sbb   rdx, 0

   mov      rax, qword ptr[rdi+sizeof(qword)*0]
   cmovnz   r14, rax
   mov      rax, qword ptr[rdi+sizeof(qword)*1]
   cmovnz   r8,  rax
   mov      rax, qword ptr[rdi+sizeof(qword)*2]
   cmovnz   r9,  rax
   mov      rax, qword ptr[rdi+sizeof(qword)*3]
   cmovnz   r10, rax
   mov      rax, qword ptr[rdi+sizeof(qword)*4]
   cmovnz   r11, rax
   mov      rax, qword ptr[rdi+sizeof(qword)*5]
   cmovnz   r12, rax

   mov   qword ptr[rdi+sizeof(qword)*0], r14
   mov   qword ptr[rdi+sizeof(qword)*1], r8
   mov   qword ptr[rdi+sizeof(qword)*2], r9
   mov   qword ptr[rdi+sizeof(qword)*3], r10
   mov   qword ptr[rdi+sizeof(qword)*4], r11
   mov   qword ptr[rdi+sizeof(qword)*5], r12

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_mred ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; projective point selector
;
; void p384r1_select_pp_w5(P384_POINT* val, const P384_POINT* tbl, int idx);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_select_pp_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12
   COMP_ABI 3

val   equ   rdi
tbl   equ   rsi
idx   equ   edx

Xa equ   xmm0
Xb equ   xmm1
Xc equ   xmm2
Ya equ   xmm3
Yb equ   xmm4
Yc equ   xmm5
Za equ   xmm6
Zb equ   xmm7
Zc equ   xmm8

REQ_IDX  equ   xmm9
CUR_IDX  equ   xmm10
MASKDATA equ   xmm11
TMP      equ   xmm12

   movdqa   CUR_IDX, oword ptr LOne

   movd     REQ_IDX, idx
   pshufd   REQ_IDX, REQ_IDX, 0

   pxor     Xa, Xa
   pxor     Xb, Xb
   pxor     Xc, Xc
   pxor     Ya, Ya
   pxor     Yb, Yb
   pxor     Yc, Yc
   pxor     Za, Za
   pxor     Zb, Zb
   pxor     Zc, Zc

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop:
      movdqa   MASKDATA, CUR_IDX  ; MASK = CUR_IDX==REQ_IDX? 0xFF : 0x00
      pcmpeqd  MASKDATA, REQ_IDX  ;
      paddd    CUR_IDX, oword ptr LOne

      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*0]
      por      Xa, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*1]
      por      Xb, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*2]
      por      Xc, TMP

      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*3]
      por      Ya, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*4]
      por      Yb, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*5]
      por      Yc, TMP

      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*6]
      por      Za, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*7]
      por      Zb, TMP
      movdqa   TMP, MASKDATA
      pand     TMP, oword ptr[tbl+sizeof(oword)*8]
      por      Zc, TMP

      add      tbl, sizeof(oword)*9
      dec      rcx
      jnz      select_loop

   movdqu   oword ptr[val+sizeof(oword)*0], Xa
   movdqu   oword ptr[val+sizeof(oword)*1], Xb
   movdqu   oword ptr[val+sizeof(oword)*2], Xc
   movdqu   oword ptr[val+sizeof(oword)*3], Ya
   movdqu   oword ptr[val+sizeof(oword)*4], Yb
   movdqu   oword ptr[val+sizeof(oword)*5], Yc
   movdqu   oword ptr[val+sizeof(oword)*6], Za
   movdqu   oword ptr[val+sizeof(oword)*7], Zb
   movdqu   oword ptr[val+sizeof(oword)*8], Zc

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_select_pp_w5 ENDP

IFNDEF _DISABLE_ECP_384R1_HARDCODED_BP_TBL_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; affine point selector
;
; void p384r1_select_ap_w5(AF_POINT *val, const AF_POINT *tbl, int idx);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p384r1_select_ap_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14
   COMP_ABI 3

val   equ   rdi
in_t  equ   rsi
idx   equ   edx

Xa equ   xmm0
Xb equ   xmm1
Xc equ   xmm2
Ya equ   xmm3
Yb equ   xmm4
Yc equ   xmm5

TXa   equ   xmm6
TXb   equ   xmm7
TXc   equ   xmm8
TYa   equ   xmm9
TYb   equ   xmm10
TYc   equ   xmm11

REQ_IDX  equ   xmm12
CUR_IDX  equ   xmm13
MASKDATA equ   xmm14

   movdqa   CUR_IDX, oword ptr LOne

   movd     REQ_IDX, idx
   pshufd   REQ_IDX, REQ_IDX, 0

   pxor     Xa, Xa
   pxor     Xb, Xb
   pxor     Xc, Xc
   pxor     Ya, Ya
   pxor     Yb, Yb
   pxor     Yc, Yc

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop:
      movdqa   MASKDATA, CUR_IDX  ; MASK = CUR_IDX==REQ_IDX? 0xFF : 0x00
      pcmpeqd  MASKDATA, REQ_IDX  ;
      paddd    CUR_IDX, oword ptr LOne

      movdqa   TXa, oword ptr[in_t+sizeof(oword)*0]
      movdqa   TXb, oword ptr[in_t+sizeof(oword)*1]
      movdqa   TXc, oword ptr[in_t+sizeof(oword)*2]
      movdqa   TYa, oword ptr[in_t+sizeof(oword)*3]
      movdqa   TYb, oword ptr[in_t+sizeof(oword)*4]
      movdqa   TYc, oword ptr[in_t+sizeof(oword)*5]
      add      tbl, sizeof(oword)*6

      pand     TXa, MASKDATA
      pand     TXb, MASKDATA
      pand     TXc, MASKDATA
      pand     TYa, MASKDATA
      pand     TYb, MASKDATA
      pand     TYc, MASKDATA

      por      Xa, TXa
      por      Xb, TXb
      por      Xc, TXc
      por      Ya, TYa
      por      Yb, TYb
      por      Yc, TYc

      dec      rcx
      jnz      select_loop

   movdqu   oword ptr[val+sizeof(oword)*0], Xa
   movdqu   oword ptr[val+sizeof(oword)*1], Xb
   movdqu   oword ptr[val+sizeof(oword)*2], Xc
   movdqu   oword ptr[val+sizeof(oword)*3], Ya
   movdqu   oword ptr[val+sizeof(oword)*4], Yb
   movdqu   oword ptr[val+sizeof(oword)*5], Yc

   REST_XMM
   REST_GPR
   ret
IPPASM p384r1_select_ap_w5 ENDP
ENDIF

ENDIF ;; _IPP32E_M7
END
