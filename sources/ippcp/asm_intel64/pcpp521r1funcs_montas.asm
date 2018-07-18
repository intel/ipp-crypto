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
;               secp p521r1 specific implementation
; 


include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

_xEMULATION_ = 1
_ADCX_ADOX_ = 1

.LIST
IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

LOne     DD    1,1,1,1,1,1,1,1
LTwo     DD    2,2,2,2,2,2,2,2
LThree   DD    3,3,3,3,3,3,3,3

;; The p521r1 polynomial
Lpoly DQ 0ffffffffffffffffh,0ffffffffffffffffh,0ffffffffffffffffh
      DQ 0ffffffffffffffffh,0ffffffffffffffffh,0ffffffffffffffffh
      DQ 0ffffffffffffffffh,0ffffffffffffffffh,000000000000001ffh


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_mul_by_2(uint64_t res[9], uint64_t a[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_mul_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   xor   ex, ex

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]

   shld  ex, a8, 1
   shld  a8, a7, 1
   shld  a7, a6, 1
   shld  a6, a5, 1
   shld  a5, a4, 1
   shld  a4, a3, 1
   shld  a3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0,     1

   mov   qword ptr[rdi+sizeof(qword)*8], a8
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*0], a0

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   a6, qword ptr Lpoly+sizeof(qword)*6
   sbb   a7, qword ptr Lpoly+sizeof(qword)*7
   sbb   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov      t, qword ptr[rdi+sizeof(qword)*6]
   cmovnz   a6, t
   mov      t, qword ptr[rdi+sizeof(qword)*7]
   cmovnz   a7, t
   mov      t, qword ptr[rdi+sizeof(qword)*8]
   cmovnz   a8, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_mul_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_div_by_2(uint64_t res[9], uint64_t a[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_div_by_2 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]

   xor   t,  t
   xor   ex, ex
   add   a0, qword ptr Lpoly+sizeof(qword)*0
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5
   adc   a6, qword ptr Lpoly+sizeof(qword)*6
   adc   a7, qword ptr Lpoly+sizeof(qword)*7
   adc   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov      t,  qword ptr[rsi+sizeof(qword)*6]
   cmovnz   a6, t
   mov      t,  qword ptr[rsi+sizeof(qword)*7]
   cmovnz   a7, t
   mov      t,  qword ptr[rsi+sizeof(qword)*8]
   cmovnz   a8, t

   shrd  a0, a1, 1
   shrd  a1, a2, 1
   shrd  a2, a3, 1
   shrd  a3, a4, 1
   shrd  a4, a5, 1
   shrd  a5, a6, 1
   shrd  a6, a7, 1
   shrd  a7, a8, 1
   shrd  a8, ex, 1

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_div_by_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_mul_by_3(uint64_t res[9], uint64_t a[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_mul_by_3 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = sizeof(qword)*9
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]

   xor   ex, ex
   shld  ex, a8, 1
   shld  a8, a7, 1
   shld  a7, a6, 1
   shld  a6, a5, 1
   shld  a5, a4, 1
   shld  a4, a3, 1
   shld  a3, a2, 1
   shld  a2, a1, 1
   shld  a1, a0, 1
   shl   a0,     1

   mov   qword ptr[rsp+sizeof(qword)*8], a8
   mov   qword ptr[rsp+sizeof(qword)*7], a7
   mov   qword ptr[rsp+sizeof(qword)*6], a6
   mov   qword ptr[rsp+sizeof(qword)*5], a5
   mov   qword ptr[rsp+sizeof(qword)*4], a4
   mov   qword ptr[rsp+sizeof(qword)*3], a3
   mov   qword ptr[rsp+sizeof(qword)*2], a2
   mov   qword ptr[rsp+sizeof(qword)*1], a1
   mov   qword ptr[rsp+sizeof(qword)*0], a0

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   a6, qword ptr Lpoly+sizeof(qword)*6
   sbb   a7, qword ptr Lpoly+sizeof(qword)*7
   sbb   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov      t, qword ptr[rsp+sizeof(qword)*6]
   cmovb    a6, t
   mov      t, qword ptr[rsp+sizeof(qword)*7]
   cmovb    a7, t
   mov      t, qword ptr[rsp+sizeof(qword)*8]
   cmovb    a8, t

   xor   ex, ex
   add   a0, qword ptr[rsi+sizeof(qword)*0]
   adc   a1, qword ptr[rsi+sizeof(qword)*1]
   adc   a2, qword ptr[rsi+sizeof(qword)*2]
   adc   a3, qword ptr[rsi+sizeof(qword)*3]
   adc   a4, qword ptr[rsi+sizeof(qword)*4]
   adc   a5, qword ptr[rsi+sizeof(qword)*5]
   adc   a6, qword ptr[rsi+sizeof(qword)*6]
   adc   a7, qword ptr[rsi+sizeof(qword)*7]
   adc   a8, qword ptr[rsi+sizeof(qword)*8]
   adc   ex, 0

   mov   qword ptr[rsp+sizeof(qword)*0], a0
   mov   qword ptr[rsp+sizeof(qword)*1], a1
   mov   qword ptr[rsp+sizeof(qword)*2], a2
   mov   qword ptr[rsp+sizeof(qword)*3], a3
   mov   qword ptr[rsp+sizeof(qword)*4], a4
   mov   qword ptr[rsp+sizeof(qword)*5], a5
   mov   qword ptr[rsp+sizeof(qword)*6], a6
   mov   qword ptr[rsp+sizeof(qword)*7], a7
   mov   qword ptr[rsp+sizeof(qword)*8], a8

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   a6, qword ptr Lpoly+sizeof(qword)*6
   sbb   a7, qword ptr Lpoly+sizeof(qword)*7
   sbb   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov      t, qword ptr[rsp+sizeof(qword)*6]
   cmovb    a6, t
   mov      t, qword ptr[rsp+sizeof(qword)*7]
   cmovb    a7, t
   mov      t, qword ptr[rsp+sizeof(qword)*8]
   cmovb    a8, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_mul_by_3 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_add(uint64_t res[9], uint64_t a[9], uint64_t b[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_add PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]

   xor   ex,  ex
   add   a0, qword ptr[rdx+sizeof(qword)*0]
   adc   a1, qword ptr[rdx+sizeof(qword)*1]
   adc   a2, qword ptr[rdx+sizeof(qword)*2]
   adc   a3, qword ptr[rdx+sizeof(qword)*3]
   adc   a4, qword ptr[rdx+sizeof(qword)*4]
   adc   a5, qword ptr[rdx+sizeof(qword)*5]
   adc   a6, qword ptr[rdx+sizeof(qword)*6]
   adc   a7, qword ptr[rdx+sizeof(qword)*7]
   adc   a8, qword ptr[rdx+sizeof(qword)*8]
   adc   ex, 0

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   sub   a0, qword ptr Lpoly+sizeof(qword)*0
   sbb   a1, qword ptr Lpoly+sizeof(qword)*1
   sbb   a2, qword ptr Lpoly+sizeof(qword)*2
   sbb   a3, qword ptr Lpoly+sizeof(qword)*3
   sbb   a4, qword ptr Lpoly+sizeof(qword)*4
   sbb   a5, qword ptr Lpoly+sizeof(qword)*5
   sbb   a6, qword ptr Lpoly+sizeof(qword)*6
   sbb   a7, qword ptr Lpoly+sizeof(qword)*7
   sbb   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov   t, qword ptr[rdi+sizeof(qword)*6]
   cmovb a6, t
   mov   t, qword ptr[rdi+sizeof(qword)*7]
   cmovb a7, t
   mov   t, qword ptr[rdi+sizeof(qword)*8]
   cmovb a8, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_add ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_sub(uint64_t res[9], uint64_t a[9], uint64_t b[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_sub PROC PUBLIC FRAME
   USES_GPR rbx,rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 3

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   mov   a0, qword ptr[rsi+sizeof(qword)*0]  ; a
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]

   xor   ex, ex
   sub   a0, qword ptr[rdx+sizeof(qword)*0]  ; a-b
   sbb   a1, qword ptr[rdx+sizeof(qword)*1]
   sbb   a2, qword ptr[rdx+sizeof(qword)*2]
   sbb   a3, qword ptr[rdx+sizeof(qword)*3]
   sbb   a4, qword ptr[rdx+sizeof(qword)*4]
   sbb   a5, qword ptr[rdx+sizeof(qword)*5]
   sbb   a6, qword ptr[rdx+sizeof(qword)*6]
   sbb   a7, qword ptr[rdx+sizeof(qword)*7]
   sbb   a8, qword ptr[rdx+sizeof(qword)*8]
   sbb   ex, 0                               ; ex = a>=b? 0 : -1

   mov   qword ptr[rdi+sizeof(qword)*0], a0  ; store (a-b)
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   add   a0, qword ptr Lpoly+sizeof(qword)*0 ; (a-b) +poly
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5
   adc   a6, qword ptr Lpoly+sizeof(qword)*6
   adc   a7, qword ptr Lpoly+sizeof(qword)*7
   adc   a8, qword ptr Lpoly+sizeof(qword)*8

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
   mov      t, qword ptr[rdi+sizeof(qword)*6]
   cmovz    a6, t
   mov      t, qword ptr[rdi+sizeof(qword)*7]
   cmovz    a7, t
   mov      t, qword ptr[rdi+sizeof(qword)*8]
   cmovz    a8, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_sub ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; void p521r1_neg(uint64_t res[9], uint64_t a[9]);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_neg PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

t  equ rdx

   xor   a0, a0
   xor   a1, a1
   xor   a2, a2
   xor   a3, a3
   xor   a4, a4
   xor   a5, a5
   xor   a6, a6
   xor   a7, a7
   xor   a8, a8

   xor   ex, ex
   sub   a0, qword ptr[rsi+sizeof(qword)*0]
   sbb   a1, qword ptr[rsi+sizeof(qword)*1]
   sbb   a2, qword ptr[rsi+sizeof(qword)*2]
   sbb   a3, qword ptr[rsi+sizeof(qword)*3]
   sbb   a4, qword ptr[rsi+sizeof(qword)*4]
   sbb   a5, qword ptr[rsi+sizeof(qword)*5]
   sbb   a6, qword ptr[rsi+sizeof(qword)*6]
   sbb   a7, qword ptr[rsi+sizeof(qword)*7]
   sbb   a8, qword ptr[rsi+sizeof(qword)*8]
   sbb   ex, 0

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   add   a0, qword ptr Lpoly+sizeof(qword)*0
   adc   a1, qword ptr Lpoly+sizeof(qword)*1
   adc   a2, qword ptr Lpoly+sizeof(qword)*2
   adc   a3, qword ptr Lpoly+sizeof(qword)*3
   adc   a4, qword ptr Lpoly+sizeof(qword)*4
   adc   a5, qword ptr Lpoly+sizeof(qword)*5
   adc   a6, qword ptr Lpoly+sizeof(qword)*6
   adc   a7, qword ptr Lpoly+sizeof(qword)*7
   adc   a8, qword ptr Lpoly+sizeof(qword)*8
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
   mov      t, qword ptr[rdi+sizeof(qword)*6]
   cmovz    a6, t
   mov      t, qword ptr[rdi+sizeof(qword)*7]
   cmovz    a7, t
   mov      t, qword ptr[rdi+sizeof(qword)*8]
   cmovz    a8, t

   mov   qword ptr[rdi+sizeof(qword)*0], a0
   mov   qword ptr[rdi+sizeof(qword)*1], a1
   mov   qword ptr[rdi+sizeof(qword)*2], a2
   mov   qword ptr[rdi+sizeof(qword)*3], a3
   mov   qword ptr[rdi+sizeof(qword)*4], a4
   mov   qword ptr[rdi+sizeof(qword)*5], a5
   mov   qword ptr[rdi+sizeof(qword)*6], a6
   mov   qword ptr[rdi+sizeof(qword)*7], a7
   mov   qword ptr[rdi+sizeof(qword)*8], a8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_neg ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; p521r1_mred(uint64_t res[9], const uint64_t product[9*2]);
;
; modulus = 2^521 -1
;           [17]  [0]
; m0 = 1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mred_step MACRO EX,X8,X7,X6,X5,X4,X3,X2,X1,X0, T,CF
   mov   T, X0                   ;; u0 = X0
   shr   T,  (64-(521-512))      ;; (T:X0) = u0<<9
   shl   X0, (521-512)
   add   T, CF

   add   X8, X0
   adc   EX, T
   mov   CF, 0
   adc   CF, 0
ENDM

ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_mred PROC PUBLIC FRAME
   USES_GPR rbx, rsi,rdi, r12,r13,r14,r15
   LOCAL_FRAME = 0
   USES_XMM
   COMP_ABI 2

a0 equ r8
a1 equ r9
a2 equ r10
a3 equ r11
a4 equ r12
a5 equ r13
a6 equ r14
a7 equ r15
a8 equ rax
ex equ rcx

   mov   a0, qword ptr[rsi+sizeof(qword)*0]
   mov   a1, qword ptr[rsi+sizeof(qword)*1]
   mov   a2, qword ptr[rsi+sizeof(qword)*2]
   mov   a3, qword ptr[rsi+sizeof(qword)*3]
   mov   a4, qword ptr[rsi+sizeof(qword)*4]
   mov   a5, qword ptr[rsi+sizeof(qword)*5]
   mov   a6, qword ptr[rsi+sizeof(qword)*6]
   mov   a7, qword ptr[rsi+sizeof(qword)*7]
   mov   a8, qword ptr[rsi+sizeof(qword)*8]
   mov   ex, qword ptr[rsi+sizeof(qword)*9]

t     equ rbx
carry equ rdx

   xor         carry, carry
   mred_step   ex,a8,a7,a6,a5,a4,a3,a2,a1,a0, t,carry ;; step 0   {rcx,rax,r15,r14,r13,r12,r11,r10,r9,r8} -> {rcx,rax,r15,r14,r13,r12,r11,r10,r9,--}

   mov         a0, qword ptr[rsi+sizeof(qword)*10]
   mred_step   a0,ex,a8,a7,a6,a5,a4,a3,a2,a1, t,carry ;; step 1   {r8,rcx,rax,r15,r14,r13,r12,r11,r10,r9} -> {r8,rcx,rax,r15,r14,r13,r12,r11,r10,--}

   mov         a1, qword ptr[rsi+sizeof(qword)*11]
   mred_step   a1,a0,ex,a8,a7,a6,a5,a4,a3,a2, t,carry ;; step 2   {r9,r8,rcx,rax,r15,r14,r13,r12,r11,r10} -> {r9,r8,rcx,rax,r15,r14,r13,r12,r11, --}

   mov         a2, qword ptr[rsi+sizeof(qword)*12]
   mred_step   a2,a1,a0,ex,a8,a7,a6,a5,a4,a3, t,carry ;; step 3   {r10,r9,r8,rcx,rax,r15,r14,r13,r12,r11} -> {r10,r9,r8,rcx,rax,r15,r14,r13,r12, --}

   mov         a3, qword ptr[rsi+sizeof(qword)*13]
   mred_step   a3,a2,a1,a0,ex,a8,a7,a6,a5,a4, t,carry ;; step 4   {r11,r10,r9,r8,rcx,rax,r15,r14,r13,r12} -> {r11,r10,r9,r8,rcx,rax,r15,r14,r13, --}

   mov         a4, qword ptr[rsi+sizeof(qword)*14]
   mred_step   a4,a3,a2,a1,a0,ex,a8,a7,a6,a5, t,carry ;; step 5   {r12,r11,r10,r9,r8,rcx,rax,r15,r14,r13} -> {r12,r11,r10,r9,r8,rcx,rax,r15,r14, --}

   mov         a5, qword ptr[rsi+sizeof(qword)*15]
   mred_step   a5,a4,a3,a2,a1,a0,ex,a8,a7,a6, t,carry ;; step 6   {r13,r12,r11,r10,r9,r8,rcx,rax,r15,r14} -> {r13,r12,r11,r10,r9,r8,rcx,rax,r15, --}

   mov         a6, qword ptr[rsi+sizeof(qword)*16]
   mred_step   a6,a5,a4,a3,a2,a1,a0,ex,a8,a7, t,carry ;; step 7   {r14,r13,r12,r11,r10,r9,r8,rcx,rax,r15} -> {r14,r13,r12,r11,r10,r9,r8,rcx,rax, --}

   mov         a7, qword ptr[rsi+sizeof(qword)*17]
   mred_step   a7,a6,a5,a4,a3,a2,a1,a0,ex,a8, t,carry ;; step 8   {r15,r14,r13,r12,r11,r10,r9,r8,rcx,rax} -> {r15,r14,r13,r12,r11,r10,r9,r8,rcx, --}

   ;; temporary result: a8,a7,a6,a5,a4,a3,a2,a1,a0,ex
   mov   qword ptr[rdi+sizeof(qword)*0], ex
   mov   qword ptr[rdi+sizeof(qword)*1], a0
   mov   qword ptr[rdi+sizeof(qword)*2], a1
   mov   qword ptr[rdi+sizeof(qword)*3], a2
   mov   qword ptr[rdi+sizeof(qword)*4], a3
   mov   qword ptr[rdi+sizeof(qword)*5], a4
   mov   qword ptr[rdi+sizeof(qword)*6], a5
   mov   qword ptr[rdi+sizeof(qword)*7], a6
   mov   qword ptr[rdi+sizeof(qword)*8], a7

   ;; sub modulus
   sub   ex, qword ptr Lpoly+sizeof(qword)*0
   sbb   a0, qword ptr Lpoly+sizeof(qword)*1
   sbb   a1, qword ptr Lpoly+sizeof(qword)*2
   sbb   a2, qword ptr Lpoly+sizeof(qword)*3
   sbb   a3, qword ptr Lpoly+sizeof(qword)*4
   sbb   a4, qword ptr Lpoly+sizeof(qword)*5
   sbb   a5, qword ptr Lpoly+sizeof(qword)*6
   sbb   a6, qword ptr Lpoly+sizeof(qword)*7
   sbb   a7, qword ptr Lpoly+sizeof(qword)*8

   ;; masked copy
   mov   t, qword ptr[rdi+sizeof(qword)*0]
   cmovb ex, t
   mov   t, qword ptr[rdi+sizeof(qword)*1]
   cmovb a0, t
   mov   t, qword ptr[rdi+sizeof(qword)*2]
   cmovb a1, t
   mov   t, qword ptr[rdi+sizeof(qword)*3]
   cmovb a2, t
   mov   t, qword ptr[rdi+sizeof(qword)*4]
   cmovb a3, t
   mov   t, qword ptr[rdi+sizeof(qword)*5]
   cmovb a4, t
   mov   t, qword ptr[rdi+sizeof(qword)*6]
   cmovb a5, t
   mov   t, qword ptr[rdi+sizeof(qword)*7]
   cmovb a6, t
   mov   t, qword ptr[rdi+sizeof(qword)*8]
   cmovb a7, t

   ;; store result: a7,a6,a5,a4,a3,a2,a1,a0,ex
   mov   qword ptr[rdi+sizeof(qword)*0], ex
   mov   qword ptr[rdi+sizeof(qword)*1], a0
   mov   qword ptr[rdi+sizeof(qword)*2], a1
   mov   qword ptr[rdi+sizeof(qword)*3], a2
   mov   qword ptr[rdi+sizeof(qword)*4], a3
   mov   qword ptr[rdi+sizeof(qword)*5], a4
   mov   qword ptr[rdi+sizeof(qword)*6], a5
   mov   qword ptr[rdi+sizeof(qword)*7], a6
   mov   qword ptr[rdi+sizeof(qword)*8], a7

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_mred ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; projective point selector
;
; void p521r1_select_pp_w5(P521_POINT* val, const P521_POINT* tbl, int idx);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_select_pp_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = sizeof(oword)*2
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
   COMP_ABI 3

val   equ   rdi
tbl   equ   rsi
idx   equ   edx

;
; stack structure
;
REQ_IDX_OFF =  0                          ; being requested table entry
CUR_IDX_OFF =  REQ_IDX_OFF+sizeof(oword)  ; current table index

   movd     xmm15, idx
   pshufd   xmm15, xmm15, 0
   movdqa   oword ptr[rsp+REQ_IDX_OFF], xmm15

   movdqa   xmm14, oword ptr LOne
   movdqa   oword ptr[rsp+CUR_IDX_OFF], xmm14

   pxor     xmm0, xmm0
   pxor     xmm1, xmm1
   pxor     xmm2, xmm2
   pxor     xmm3, xmm3
   pxor     xmm4, xmm4
   pxor     xmm5, xmm5
   pxor     xmm6, xmm6
   pxor     xmm7, xmm7
   pxor     xmm8, xmm8
   pxor     xmm9, xmm9
   pxor     xmm10,xmm10
   pxor     xmm11,xmm11
   pxor     xmm12,xmm12
   pxor     xmm13,xmm13

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop:
      movdqa   xmm15, oword ptr[rsp+CUR_IDX_OFF]  ; MASK = CUR_IDX==REQ_IDX? 0xFF : 0x00
      movdqa   xmm14, xmm15
      pcmpeqd  xmm15, oword ptr[rsp+REQ_IDX_OFF]  ;
      paddd    xmm14, oword ptr LOne
      movdqa   oword ptr[rsp+CUR_IDX_OFF], xmm14

      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*0]  ; read and mask X, Y and Z
      pand     xmm14, xmm15
      por      xmm0, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*1]
      pand     xmm14, xmm15
      por      xmm1, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*2]
      pand     xmm14, xmm15
      por      xmm2, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*3]
      pand     xmm14, xmm15
      por      xmm3, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*4]
      pand     xmm14, xmm15
      por      xmm4, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*5]
      pand     xmm14, xmm15
      por      xmm5, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*6]
      pand     xmm14, xmm15
      por      xmm6, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*7]
      pand     xmm14, xmm15
      por      xmm7, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*8]
      pand     xmm14, xmm15
      por      xmm8, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*9]
      pand     xmm14, xmm15
      por      xmm9, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*10]
      pand     xmm14, xmm15
      por      xmm10, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*11]
      pand     xmm14, xmm15
      por      xmm11, xmm14
      movdqu   xmm14, oword ptr[tbl+sizeof(oword)*12]
      pand     xmm14, xmm15
      por      xmm12, xmm14
      movd     xmm14, dword ptr[tbl+sizeof(oword)*13]
      pand     xmm14, xmm15
      por      xmm13, xmm14

      add      tbl, sizeof(qword)*(9*3)
      dec      rcx
      jnz      select_loop

   movdqu   oword ptr[val+sizeof(oword)*0], xmm0
   movdqu   oword ptr[val+sizeof(oword)*1], xmm1
   movdqu   oword ptr[val+sizeof(oword)*2], xmm2
   movdqu   oword ptr[val+sizeof(oword)*3], xmm3
   movdqu   oword ptr[val+sizeof(oword)*4], xmm4
   movdqu   oword ptr[val+sizeof(oword)*5], xmm5
   movdqu   oword ptr[val+sizeof(oword)*6], xmm6
   movdqu   oword ptr[val+sizeof(oword)*7], xmm7
   movdqu   oword ptr[val+sizeof(oword)*8], xmm8
   movdqu   oword ptr[val+sizeof(oword)*9], xmm9
   movdqu   oword ptr[val+sizeof(oword)*10],xmm10
   movdqu   oword ptr[val+sizeof(oword)*11],xmm11
   movdqu   oword ptr[val+sizeof(oword)*12],xmm12
   movq     qword ptr[val+sizeof(oword)*13],xmm13

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_select_pp_w5 ENDP

IFNDEF _DISABLE_ECP_521R1_HARDCODED_BP_TBL_
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; affine point selector
;
; void p521r1_select_ap_w5(AF_POINT *val, const AF_POINT *tbl, int idx);
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
IPPASM p521r1_select_ap_w5 PROC PUBLIC FRAME
   USES_GPR rsi,rdi,r12,r13
   LOCAL_FRAME = 0
   USES_XMM xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm14
   COMP_ABI 3

val   equ   rdi
in_t  equ   rsi
idx   equ   edx

xyz0  equ   xmm0
xyz1  equ   xmm1
xyz2  equ   xmm2
xyz3  equ   xmm3
xyz4  equ   xmm4
xyz5  equ   xmm5
xyz6  equ   xmm6
xyz7  equ   xmm7
xyz8  equ   xmm8

REQ_IDX  equ   xmm9
CUR_IDX  equ   xmm10
MASKDATA equ   xmm11
TMP      equ   xmm12

   movdqa   CUR_IDX, oword ptr LOne

   movd     REQ_IDX, idx
   pshufd   REQ_IDX, REQ_IDX, 0

   pxor     xyz0, xyz0
   pxor     xyz1, xyz1
   pxor     xyz2, xyz2
   pxor     xyz3, xyz3
   pxor     xyz4, xyz4
   pxor     xyz5, xyz5
   pxor     xyz6, xyz6
   pxor     xyz7, xyz7
   pxor     xyz8, xyz8

   ; Skip index = 0, is implicictly infty -> load with offset -1
   mov      rcx, 16
select_loop:
      movdqa   MASKDATA, CUR_IDX  ; MASK = CUR_IDX==REQ_IDX? 0xFF : 0x00
      pcmpeqd  MASKDATA, REQ_IDX  ;
      paddd    CUR_IDX, oword ptr LOne

      movdqa   TMP, oword ptr[in_t+sizeof(oword)*0]
      pand     TMP, MASKDATA
      por      xyz0, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*1]
      pand     TMP, MASKDATA
      por      xyz1, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*2]
      pand     TMP, MASKDATA
      por      xyz2, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*3]
      pand     TMP, MASKDATA
      por      xyz3, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*4]
      pand     TMP, MASKDATA
      por      xyz4, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*5]
      pand     TMP, MASKDATA
      por      xyz5, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*6]
      pand     TMP, MASKDATA
      por      xyz6, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*7]
      pand     TMP, MASKDATA
      por      xyz7, TMP
      movdqa   TMP, oword ptr[in_t+sizeof(oword)*8]
      pand     TMP, MASKDATA
      por      xyz8, TMP

      add      tbl, sizeof(qword)*(9*2)
      dec      rcx
      jnz      select_loop

   movdqu   oword ptr[val+sizeof(oword)*0], xyz0
   movdqu   oword ptr[val+sizeof(oword)*1], xyz1
   movdqu   oword ptr[val+sizeof(oword)*2], xyz2
   movdqu   oword ptr[val+sizeof(oword)*3], xyz3
   movdqu   oword ptr[val+sizeof(oword)*4], xyz4
   movdqu   oword ptr[val+sizeof(oword)*5], xyz5
   movdqu   oword ptr[val+sizeof(oword)*6], xyz6
   movdqu   oword ptr[val+sizeof(oword)*7], xyz7
   movdqu   oword ptr[val+sizeof(oword)*8], xyz8

   REST_XMM
   REST_GPR
   ret
IPPASM p521r1_select_ap_w5 ENDP
ENDIF

ENDIF ;; _IPP32E_M7
END
