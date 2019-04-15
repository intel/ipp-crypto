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
;               Big Number Operations
; 
;     Content:
;        cpMontRedAdc_BNU()
; 
; 
;     History:
;      Extra reduction (R=A-M) has been added to perform MontReduction safe
; 
;

include asmdefs.inc
include ia_32e.inc
include pcpbnumulschool.inc
include pcpvariant.inc

IF (_ADCOX_NI_ENABLING_ EQ _FEATURE_OFF_) OR (_ADCOX_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)
IF (_IPP32E GE _IPP32E_M7) AND (_IPP32E LT _IPP32E_L9)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fixed size reduction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MREDUCE_FIX_STEP MACRO mSize, X7,X6,X5,X4,X3,X2,X1,X0, rSrc, U, rCarry
IF mSize GT 0
   mul   U
   xor   rCarry, rCarry
   add   X0, rax

IF mSize GT 1
   mov   rax, qword ptr [rSrc+sizeof(qword)]
   adc   rCarry, rdx
   mul   U
   add   X1, rCarry
   adc   rdx, 0
   xor   rCarry, rCarry
   add   X1, rax

IF mSize GT 2
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   adc   rCarry, rdx
   mul   U
   add   X2, rCarry
   adc   rdx, 0
   xor   rCarry, rCarry
   add   X2, rax

IF mSize GT 3
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   rCarry, rdx
   mul   U
   add   X3, rCarry
   adc   rdx, 0
   xor   rCarry, rCarry
   add   X3, rax
IF mSize  EQ 4
   adc   X4, rdx
   adc   rCarry, 0
   add   X4, qword ptr [rsp+carry]
ENDIF
ENDIF ;; mSize==4

IF mSize EQ 3
   adc   X3, rdx
   adc   rCarry, 0
   add   X3, qword ptr [rsp+carry]
ENDIF
ENDIF ;; mSize==3

IF mSize EQ 2
   adc   X2, rdx
   adc   rCarry, 0
   add   X2, qword ptr [rsp+carry]
ENDIF
ENDIF ;; mSize==2

IF mSize EQ 1
   adc   X1, rdx
   adc   rCarry, 0
   add   X1, qword ptr [rsp+carry]
ENDIF
ENDIF ;; mSize==1

   adc   rCarry, 0
   mov   qword ptr [rsp+carry], rCarry
ENDM

MREDUCE_FIX MACRO mSize, rDst, rSrc, M0, X7,X6,X5,X4,X3,X2,X1,X0, U,rCarry
IF mSize GT 0
   mov   U, X0
   imul  U, M0
   mov   rax, qword ptr [rSrc]
   MREDUCE_FIX_STEP mSize, X7,X6,X5,X4,X3,X2,X1,X0, rSrc, U, rCarry

IF mSize GT 1
   mov   U, X1
   imul  U, M0
   mov   rax, qword ptr [rSrc]
   MREDUCE_FIX_STEP mSize, X0,X7,X6,X5,X4,X3,X2,X1, rSrc, U, rCarry

IF mSize GT 2
   mov   U, X2
   imul  U, M0
   mov   rax, qword ptr [rSrc]
   MREDUCE_FIX_STEP mSize, X1,X0,X7,X6,X5,X4,X3,X2, rSrc, U, rCarry

IF mSize GT 3
   mov   U, X3
   imul  U, M0
   mov   rax, qword ptr [rSrc]
   MREDUCE_FIX_STEP mSize, X2,X1,X0,X7,X6,X5,X4,X3, rSrc, U, rCarry

   mov   X0, X4                              ; {X3:X2:X1:X0} = {X7:X6:X5:X4}
   sub   X4, qword ptr [rSrc]                ; {X7:X6:X5:X4}-= modulus
   mov   X1, X5
   sbb   X5, qword ptr [rSrc+sizeof(qword)]
   mov   X2, X6
   sbb   X6, qword ptr [rSrc+sizeof(qword)*2]
   mov   X3, X7
   sbb   X7, qword ptr [rSrc+sizeof(qword)*3]
   sbb   rCarry, 0

   cmovc X4, X0                              ; dst = borrow? {X3:X2:X1:X0} : {X7:X6:X5:X4}
   mov   qword ptr[rDst], X4
   cmovc X5, X1
   mov   qword ptr[rDst+sizeof(qword)], X5
   cmovc X6, X2
   mov   qword ptr[rDst+sizeof(qword)*2], X6
   cmovc X7, X3
   mov   qword ptr[rDst+sizeof(qword)*3], X7
   EXITM
ENDIF ; mSize==4

   mov   X0, X3                              ; {X2:X1:X0} = {X5:X4:X3}
   sub   X3, qword ptr [rSrc]                ; {X5:X4:X3}-= modulus
   mov   X1, X4
   sbb   X4, qword ptr [rSrc+sizeof(qword)]
   mov   X2, X5
   sbb   X5, qword ptr [rSrc+sizeof(qword)*2]
   sbb   rCarry, 0

   cmovc X3, X0                              ; dst = borrow? {X2:X1:X0} : {X5:X4:X3}
   mov   qword ptr[rDst], X3
   cmovc X4, X1
   mov   qword ptr[rDst+sizeof(qword)], X4
   cmovc X5, X2
   mov   qword ptr[rDst+sizeof(qword)*2], X5
   EXITM
ENDIF ; mSize==3

   mov   X0, X2                              ; {X1:X0} = {X3:X2}
   sub   X2, qword ptr [rSrc]                ; {X3:X2}-= modulus
   mov   X1, X3
   sbb   X3, qword ptr [rSrc+sizeof(qword)]
   sbb   rCarry, 0

   cmovc X2, X0                              ; dst = borrow? {X1:X0} : {X3:X2}
   mov   qword ptr[rDst], X2
   cmovc X3, X1
   mov   qword ptr[rDst+sizeof(qword)], X3
   EXITM
ENDIF ; mSize==2

   mov   X0, X1                              ; X1 = X0
   sub   X1, qword ptr [rSrc]                ; X1 -= modulus
   sbb   rCarry, 0

   cmovc X1, X0                              ; dst = borrow? X0 : X1
   mov   qword ptr[rDst], X1
   EXITM
ENDIF ; mSize==1
ENDM


IF (_IPP32E LE _IPP32E_Y8)
;;
;; Pre- Sandy Brige specific code
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; product = + modulus * U0

;; main body: product = + modulus * U0
MLAx1 MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
LOCAL L_1
  ALIGN IPP_ALIGN_FACTOR
L_1:
   mul   U0
   xor   T2, T2
   add   T0, qword ptr [rDst+idx*sizeof(qword)-sizeof(qword)]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]
   adc   T2, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)-sizeof(qword)], T0

   mul   U0
   xor   T3, T3
   add   T1, qword ptr [rDst+idx*sizeof(qword)]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T3, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)], T1

   mul   U0
   xor   T0, T0
   add   T2, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)]
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T0, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T2

   mul   U0
   xor   T1, T1
   add   T3, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]
   adc   T1, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T3

   add   idx, 4
   jnc   L_1
ENDM

;; elipogue: product = modulus * U0, (srcLen=4*n+1)
MM_MLAx1_4N_1_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   xor   T3, T3
   add   T1, qword ptr [rDst]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   adc   T3, rdx
   mov   qword ptr [rDst], T1

   mul   U0
   xor   T0, T0
   add   T2, qword ptr [rDst+sizeof(qword)]
   adc   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T0, rdx
   mov   qword ptr [rDst+sizeof(qword)], T2

   mul   U0
   add   T3, qword ptr [rDst+sizeof(qword)*2]
   adc   T0, rax
   adc   rdx, 0
   xor   rax, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T3

   add   T0, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

;; elipogue: product = modulus * U0, (srcLen=4*n+4)
MM_MLAx1_4N_4_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   xor   T3, T0
   add   T1, qword ptr [rDst+sizeof(qword)]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T3, rdx
   mov   qword ptr [rDst+sizeof(qword)], T1

   mul   U0
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   adc   T3, rax
   adc   rdx, 0
   xor   rax, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T2

   add   T3, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T3
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

;; elipogue: product = modulus * U0, (srcLen=4*n+3)
MM_MLAx1_4N_3_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   add   T1, qword ptr [rDst+sizeof(qword)*2]
   adc   T2, rax
   adc   rdx, 0
   xor   rax, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T1

   add   T2, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T2
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

;; elipogue: product = modulus * U0, (srcLen=4*n+2)
MM_MLAx1_4N_2_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   idx, qword ptr [rsp+counter]
   xor   rax, rax

   add   T1, qword ptr [rDst+sizeof(qword)*3]
   adc   T2, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T1
   mov   qword ptr [rDst+sizeof(qword)*4], T2
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM
ENDIF


IF (_IPP32E GE _IPP32E_E9)
;;
;; Sandy Brige specific code
;;
MLAx1 MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
LOCAL L_1
  ALIGN IPP_ALIGN_FACTOR
L_1:
   mul   U0
   xor   T2, T2
   add   T0, qword ptr [rDst+idx*sizeof(qword)-sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)-sizeof(qword)], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]
   adc   T2, rdx

   mul   U0
   xor   T3, T3
   add   T1, qword ptr [rDst+idx*sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T3, rdx

   mul   U0
   xor   T0, T0
   add   T2, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T0, rdx

   mul   U0
   xor   T1, T1
   add   T3, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T3
   adc   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]
   adc   T1, rdx

   add   idx, 4
   jnc   L_1
ENDM

MM_MLAx1_4N_1_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   xor   T3, T3
   add   T1, qword ptr [rDst]
   mov   qword ptr [rDst], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   adc   T3, rdx

   mul   U0
   xor   T0, T0
   add   T2, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T0, rdx

   mul   U0
   add   T3, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T3
   adc   T0, rax
   adc   rdx, 0
   xor   rax, rax

   add   T0, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

MM_MLAx1_4N_4_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   xor   T3, T0
   add   T1, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T3, rdx

   mul   U0
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   adc   T3, rax
   adc   rdx, 0
   xor   rax, rax

   add   T3, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T3
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

MM_MLAx1_4N_3_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   mov   idx, qword ptr [rsp+counter]

   mul   U0
   add   T1, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T1
   adc   T2, rax
   adc   rdx, 0
   xor   rax, rax

   add   T2, qword ptr [rDst+sizeof(qword)*3]
   adc   rdx, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T2
   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM

MM_MLAx1_4N_2_ELOG   MACRO rDst, rSrc, idx, U0, T0,T1,T2,T3
   mov   idx, qword ptr [rsp+counter]
   xor   rax, rax

   add   T1, qword ptr [rDst+sizeof(qword)*3]
   adc   T2, qword ptr [rDst+sizeof(qword)*4]
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*3], T1
   mov   qword ptr [rDst+sizeof(qword)*4], T2
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)
ENDM
ENDIF

;
; prologue:
; pre-compute:
;  - u0 = product[0]*m0
;  - u1 = (product[1] + LO(modulo[1]*u0) + HI(modulo[0]*u0) carry(product[0]+LO(modulo[0]*u0)))*m0
;
MMx2_PLOG MACRO rDst, rSrc, idx, m0, U0,U1, T0,T1,T2,T3
   mov   U0, qword ptr [rDst+idx*sizeof(qword)]                ; product[0]
   imul  U0, m0                                                ; u0 = product[0]*m0

   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]               ; modulo[0]*u0
   mul   U0

   mov   U1, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]  ; modulo[1]*u0
   imul  U1, U0

   mov   T0, rax                                               ; save  modulo[0]*u0
   mov   T1, rdx

   add   rax, qword ptr [rdi+idx*sizeof(qword)]                ; a[1] = product[1] + LO(modulo[1]*u0)
   adc   rdx, qword ptr [rdi+idx*sizeof(qword)+sizeof(qword)]  ;      + HI(modulo[0]*u0)
   add   U1, rdx                                               ;      + carry(product[0]+LO(modulo[0]*u0))
   imul  U1, m0                                                ; u1 = a[1]*m0

   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   xor   T2, T2
ENDM


IF (_IPP32E LE _IPP32E_Y8)
;;
;; Pre- Sandy Brige specific code
;;
MM_MLAx2_4N_1_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += modulus[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T0, qword ptr [rDst+sizeof(qword)*3]
   adc   T1, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   adc   T2, rdx
   xor   rax, rax

   add   T1, qword ptr [rDst+sizeof(qword)*4]
   adc   T2, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T1, qword ptr [rsp+carry]
   adc   T2, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T1
   mov   qword ptr [rDst+sizeof(qword)*5], T2
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM

MM_MLAx2_4N_2_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-2]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-1]*U0 + r[mSize-2]
   add   T0, qword ptr [rDst+sizeof(qword)*2]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T2, rdx
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-1]*B1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T1, qword ptr [rDst+sizeof(qword)*3]
   adc   T2, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T1
   adc   T3, rdx
   xor   rax, rax

   add   T2, qword ptr [rDst+sizeof(qword)*4]
   adc   T3, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T2, qword ptr [rsp+carry]
   adc   T3, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T2
   mov   qword ptr [rDst+sizeof(qword)*5], T3
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM

MM_MLAx2_4N_3_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-3]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-2]*U0 + r[mSize-3]
   add   T0, qword ptr [rDst+sizeof(qword)]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T2, rdx
   mov   qword ptr [rDst+sizeof(qword)], T0
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-2]*U1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T3, rdx

   mul   U0                                                       ; {T0:T3:T2} += a[mSize-1]*U0 + r[mSize-2]
   add   T1, qword ptr [rdi+sizeof(qword)*2]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T3, rdx
   mov   qword ptr [rdi+sizeof(qword)*2], T1
   adc   T0, 0

   mul   U1                                                       ; {T0:T3} += a[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T2, qword ptr [rdi+sizeof(qword)*3]
   adc   T3, rax
   mov   qword ptr [rdi+sizeof(qword)*3], T2
   adc   T0, rdx
   xor   rax, rax

   add   T3, qword ptr [rdi+sizeof(qword)*4]
   adc   T0, qword ptr [rdi+sizeof(qword)*5]
   adc   rax, 0
   add   T3, qword ptr [rsp+carry]
   adc   T0, 0
   adc   rax, 0
   mov   qword ptr [rdi+sizeof(qword)*4], T3
   mov   qword ptr [rdi+sizeof(qword)*5], T0
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM

MM_MLAx2_4N_4_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-4]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-3]*U0 + r[mSize-4]
   add   T0, qword ptr [rDst]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[mSize-3]
   adc   T2, rdx
   mov   qword ptr [rDst], T0
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-3]*U1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T3, rdx

   mul   U0                                                       ; {T0:T3:T2} += a[mSize-2]*U0 + r[mSize-3]
   add   T1, qword ptr [rDst+sizeof(qword)]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx
   mov   qword ptr [rDst+sizeof(qword)], T1
   adc   T0, 0

   mul   U1                                                       ; {T0:T3} += a[mSize-2]*U1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T0, rdx

   mul   U0                                                       ; {T1:T0:T3} += a[mSize-1]*U0 + r[mSize-2]
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   adc   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T0, rdx
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   adc   T1, 0

   mul   U1                                                       ; {T1:T0} += a[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T3, qword ptr [rDst+sizeof(qword)*3]
   adc   T0, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T3
   adc   T1, rdx
   xor   rax, rax

   add   T0, qword ptr [rDst+sizeof(qword)*4]
   adc   T1, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T0, qword ptr [rsp+carry]
   adc   T1, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T0
   mov   qword ptr [rDst+sizeof(qword)*5], T1
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM
ENDIF

IF (_IPP32E GE _IPP32E_E9)
;;
;; Sandy Brige specific code
;;
MM_MLAx2_4N_1_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += modulus[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T0, qword ptr [rDst+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   adc   T1, rax
   adc   T2, rdx
   xor   rax, rax

   add   T1, qword ptr [rDst+sizeof(qword)*4]
   adc   T2, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T1, qword ptr [rsp+carry]
   adc   T2, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T1
   mov   qword ptr [rDst+sizeof(qword)*5], T2
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM


MM_MLAx2_4N_2_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-2]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-1]*U0 + r[mSize-2]
   add   T0, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T2, rdx
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-1]*B1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T1, qword ptr [rDst+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T1
   adc   T2, rax
   adc   T3, rdx
   xor   rax, rax

   add   T2, qword ptr [rDst+sizeof(qword)*4]
   adc   T3, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T2, qword ptr [rsp+carry]
   adc   T3, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T2
   mov   qword ptr [rDst+sizeof(qword)*5], T3
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM

MM_MLAx2_4N_3_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-3]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-2]*U0 + r[mSize-3]
   add   T0, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T2, rdx
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-2]*U1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T3, rdx

   mul   U0                                                       ; {T0:T3:T2} += a[mSize-1]*U0 + r[mSize-2]
   add   T1, qword ptr [rdi+sizeof(qword)*2]
   mov   qword ptr [rdi+sizeof(qword)*2], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T3, rdx
   adc   T0, 0

   mul   U1                                                       ; {T0:T3} += a[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T2, qword ptr [rdi+sizeof(qword)*3]
   mov   qword ptr [rdi+sizeof(qword)*3], T2
   adc   T3, rax
   adc   T0, rdx
   xor   rax, rax

   add   T3, qword ptr [rdi+sizeof(qword)*4]
   adc   T0, qword ptr [rdi+sizeof(qword)*5]
   adc   rax, 0
   add   T3, qword ptr [rsp+carry]
   adc   T0, 0
   adc   rax, 0
   mov   qword ptr [rdi+sizeof(qword)*4], T3
   mov   qword ptr [rdi+sizeof(qword)*5], T0
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM

MM_MLAx2_4N_4_ELOG   MACRO rDst, rSrc, idx, U0,U1, T0,T1,T2,T3
   mul   U1                                                       ; {T2:T1} += a[mSize-4]*U1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx

   mul   U0                                                       ; {T3:T2:T1} += a[mSize-3]*U0 + r[mSize-4]
   add   T0, qword ptr [rDst]
   mov   qword ptr [rDst], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[mSize-3]
   adc   T2, rdx
   adc   T3, 0

   mul   U1                                                       ; {T3:T2} += a[mSize-3]*U1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[mSize-2]
   adc   T3, rdx

   mul   U0                                                       ; {T0:T3:T2} += a[mSize-2]*U0 + r[mSize-3]
   add   T1, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx
   adc   T0, 0

   mul   U1                                                       ; {T0:T3} += a[mSize-2]*U1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T0, rdx

   mul   U0                                                       ; {T1:T0:T3} += a[mSize-1]*U0 + r[mSize-2]
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[mSize-1]
   adc   T0, rdx
   adc   T1, 0

   mul   U1                                                       ; {T1:T0} += a[mSize-1]*U1 + r[mSize-1]
   mov   idx, qword ptr [rsp+counter]
   add   T3, qword ptr [rDst+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T3
   adc   T0, rax
   adc   T1, rdx
   xor   rax, rax

   add   T0, qword ptr [rDst+sizeof(qword)*4]
   adc   T1, qword ptr [rDst+sizeof(qword)*5]
   adc   rax, 0
   add   T0, qword ptr [rsp+carry]
   adc   T1, 0
   adc   rax, 0
   mov   qword ptr [rDst+sizeof(qword)*4], T0
   mov   qword ptr [rDst+sizeof(qword)*5], T1
   mov   qword ptr [rsp+carry], rax

   add   rDst, sizeof(qword)*2
ENDM
ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SBB_x4   MACRO rDst, rSrc1, rSrc2, idx, T0,T1,T2,T3, rcf
LOCAL L_1
  ALIGN IPP_ALIGN_FACTOR
L_1:
   add   rcf, rcf    ; restore cf

   mov   T0, qword ptr [rSrc1+idx*sizeof(qword)]
   sbb   T0, qword ptr [rSrc2+idx*sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)], T0

   mov   T1, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)]
   sbb   T1, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1

   mov   T2, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)*2]
   sbb   T2, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)*2]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2

   mov   T3, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)*3]
   sbb   T3, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)*3]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3

   sbb   rcf, rcf    ; save cf
   add   idx, 4
   jnc   L_1
ENDM

SBB_TAIL MACRO N, rDst, rSrc1, rSrc2, T0,T1,T2,T3, rcf
   add   rcf, rcf                      ; restore cf
   mov   idx, qword ptr [rsp+counter]  ; restore counter

IF N GT 3
   mov   T0, qword ptr [rSrc1]
   sbb   T0, qword ptr [rSrc2]
   mov   qword ptr [rDst], T0
ENDIF

IF N GT 2
   mov   T1, qword ptr [rSrc1+sizeof(qword)]
   sbb   T1, qword ptr [rSrc2+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T1
ENDIF

IF N GT 1
   mov   T2, qword ptr [rSrc1+sizeof(qword)*2]
   sbb   T2, qword ptr [rSrc2+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T2
ENDIF

IF N GT 0
   mov   T3, qword ptr [rSrc1+sizeof(qword)*3]
   sbb   T3, qword ptr [rSrc2+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T3
ENDIF

   sbb   rax, 0
   sbb   rcf, rcf    ; set cf
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; dst[] = cf? src1[] : src2[]
CMOV_x4   MACRO rDst, rSrc1, rSrc2, idx, T0,T1,T2,T3, rcf
LOCAL L_1
   mov   T3, rcf                 ; copy cf
  ALIGN IPP_ALIGN_FACTOR
L_1:
   add   T3, T3                  ; restore cf

   mov   T0, qword ptr [rSrc2+idx*sizeof(qword)]
   mov   T1, qword ptr [rSrc1+idx*sizeof(qword)]
   mov   T2, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)]
   mov   T3, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)]
   cmovc T0, T1
   mov   qword ptr [rDst+idx*sizeof(qword)], T0
   cmovc T2, T3
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T2

   mov   T0, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)*2]
   mov   T1, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)*2]
   mov   T2, qword ptr [rSrc2+idx*sizeof(qword)+sizeof(qword)*3]
   mov   T3, qword ptr [rSrc1+idx*sizeof(qword)+sizeof(qword)*3]
   cmovc T0, T1
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T0
   cmovc T2, T3
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T2

   mov   T3, rcf                 ; copy cf
   add   idx, 4
   jnc   L_1
ENDM

CMOV_TAIL MACRO N, rDst, rSrc1, rSrc2, T0,T1,T2,T3, rcf
   add   rcf, rcf                      ; restore cf
   mov   idx, qword ptr [rsp+counter]  ; restore counter

IF N GT 3
   mov   T0, qword ptr [rSrc2]
   mov   T1, qword ptr [rSrc1]
   cmovc T0, T1
   mov   qword ptr [rDst], T0
ENDIF

IF N GT 2
   mov   T2, qword ptr [rSrc2+sizeof(qword)]
   mov   T3, qword ptr [rSrc1+sizeof(qword)]
   cmovc T2, T3
   mov   qword ptr [rDst+sizeof(qword)], T2
ENDIF

IF N GT 1
   mov   T0, qword ptr [rSrc2+sizeof(qword)*2]
   mov   T1, qword ptr [rSrc1+sizeof(qword)*2]
   cmovc T0, T1
   mov   qword ptr [rDst+sizeof(qword)*2], T0
ENDIF

IF N GT 0
   mov   T2, qword ptr [rSrc2+sizeof(qword)*3]
   mov   T3, qword ptr [rSrc1+sizeof(qword)*3]
   cmovc T2, T3
   mov   qword ptr [rDst+sizeof(qword)*3], T2
ENDIF
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;*************************************************************
;* void cpMontRedAdc_BNU(Ipp64u* pR,
;*                       Ipp64u* pBuffer,
;*                 const Ipp64u* pModulo, int mSize, Ipp64u m0)
;*
;*************************************************************

;;
;; Lib = M7
;;
;; Caller = ippsMontMul
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontRedAdc_BNU PROC PUBLIC FRAME
      USES_GPR rbx,rbp,rsi,rdi,r12,r13,r14,r15
      LOCAL_FRAME = (1+1+1+1)*sizeof(qword)
      USES_XMM
      COMP_ABI 5

;pR        (rdi) address of the reduction
;pBuffer   (rsi) address of the temporary product
;pModulo   (rdx) address of the modulus
;mSize     (rcx) size    of the modulus
;m0        (r8)  helper

;;
;; stack structure:
pR       = (0)                   ; reduction address
mSize    = (pR+sizeof(qword))    ; modulus length (qwords)
carry    = (mSize+sizeof(qword)) ; carry from previous MLAx1 or MLAx2 operation
counter  = (carry+sizeof(qword)) ; counter = 4-mSize

   mov      qword ptr [rsp+carry], 0   ; clear carry
   movsxd   rcx, ecx                   ; expand modulus length
   mov      r15, r8                    ; helper m0

   cmp   rcx, 5
   jge   general_case

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; reducer of the fixed sizes
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   cmp   rcx, 3
   ja    mSize_4     ; rcx=4
   jz    mSize_3     ; rcx=3
   jp    mSize_2     ; rcx=2
   ;     mSize_1     ; rcx=1

X0    equ   r8
X1    equ   r9
X2    equ   r10
X3    equ   r11
X4    equ   r12
X5    equ   r13
X6    equ   r14
X7    equ   rcx

  ALIGN IPP_ALIGN_FACTOR
mSize_1:
   mov   X0, qword ptr [rsi]
   mov   X1, qword ptr [rsi+sizeof(qword)]
   mov   rsi, rdx
                ; rDst,rSrc, U,  M0,  T0
   MREDUCE_FIX 1, rdi, rsi, r15, X7, X6, X5, X4, X3, X2, X1,X0, rbp,rbx
   jmp   quit

  ALIGN IPP_ALIGN_FACTOR
mSize_2:
   mov   X0, qword ptr [rsi]
   mov   X1, qword ptr [rsi+sizeof(qword)]
   mov   X2, qword ptr [rsi+sizeof(qword)*2]
   mov   X3, qword ptr [rsi+sizeof(qword)*3]
   mov   rsi, rdx
   MREDUCE_FIX 2, rdi, rsi, r15, X7, X6, X5, X4, X3, X2, X1,X0, rbp,rbx
   jmp   quit

  ALIGN IPP_ALIGN_FACTOR
mSize_3:
   mov   X0, qword ptr [rsi]
   mov   X1, qword ptr [rsi+sizeof(qword)]
   mov   X2, qword ptr [rsi+sizeof(qword)*2]
   mov   X3, qword ptr [rsi+sizeof(qword)*3]
   mov   X4, qword ptr [rsi+sizeof(qword)*4]
   mov   X5, qword ptr [rsi+sizeof(qword)*5]
   mov   rsi, rdx
   MREDUCE_FIX 3, rdi, rsi, r15, X7, X6, X5, X4, X3, X2, X1,X0, rbp,rbx
   jmp   quit

  ALIGN IPP_ALIGN_FACTOR
mSize_4:
   mov   X0, qword ptr [rsi]
   mov   X1, qword ptr [rsi+sizeof(qword)]
   mov   X2, qword ptr [rsi+sizeof(qword)*2]
   mov   X3, qword ptr [rsi+sizeof(qword)*3]
   mov   X4, qword ptr [rsi+sizeof(qword)*4]
   mov   X5, qword ptr [rsi+sizeof(qword)*5]
   mov   X6, qword ptr [rsi+sizeof(qword)*6]
   mov   X7, qword ptr [rsi+sizeof(qword)*7]
   mov   rsi, rdx
   MREDUCE_FIX 4, rdi, rsi, r15, X7, X6, X5, X4, X3, X2, X1,X0, rbp,rbx
   jmp   quit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; general case reducer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
U0 equ   r9    ; u0, u1
U1 equ   r10

T0 equ   r11   ; temporary
T1 equ   r12
T2 equ   r13
T3 equ   r14

idx equ  rbx   ; index
rDst equ rdi
rSrc equ rsi

  ALIGN IPP_ALIGN_FACTOR
general_case:
   lea   rdi, [rdi+rcx*sizeof(qword)-sizeof(qword)*4] ; save pR+mSzie-4
   mov   qword ptr [rsp+pR], rdi       ; save pR
  ;mov   qword ptr [rsp+mSize], rcx    ; save length of modulus

   mov   rdi, rsi                ; rdi = pBuffer
   mov   rsi, rdx                ; rsi = pModulo

   lea   rdi, [rdi+rcx*sizeof(qword)-sizeof(qword)*4] ; rdi = pBuffer
   lea   rsi, [rsi+rcx*sizeof(qword)-sizeof(qword)*4] ; rsi = pModulus

   mov   idx, 4                                       ; init negative counter
   sub   idx, rcx
   mov   qword ptr [rsp+counter], idx
   mov   rdx, 3
   and   rdx, rcx

   test  rcx,1
   jz    even_len_Modulus

;
; modulus of odd length
;
odd_len_Modulus:
   mov   U0, qword ptr [rDst+idx*sizeof(qword)]       ; pBuffer[0]
   imul  U0, r15                                      ; u0 = pBuffer[0]*m0

   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]      ; pModulo[0]

   mul   U0                                           ; prologue
   mov   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]
   mov   T1, rdx

   add   idx, 1
   jz    skip_mlax1

   MLAx1 rdi, rsi, idx, U0, T0,T1,T2,T3               ; pBuffer[] += pModulo[]*u

skip_mlax1:
   mul   U0
   xor   T2, T2
   add   qword ptr [rDst+idx*sizeof(qword)-sizeof(qword)], T0
   adc   T1, rax
   adc   T2, rdx

   cmp      idx, 2
   ja    fin_mla1x4n_2   ; idx=3
   jz    fin_mla1x4n_3   ; idx=2
   jp    fin_mla1x4n_4   ; idx=1
   ;     fin_mla1x4n_1   ; idx=0

fin_mla1x4n_1:
   MM_MLAx1_4N_1_ELOG rdi, rsi, idx, U0, T0,T1,T2,T3  ; [rsp+carry] = rax = cf = pBuffer[]+pModulo[]*u
   sub   rcx, 1
   jmp   mla2x4n_1

fin_mla1x4n_4:
   MM_MLAx1_4N_4_ELOG rdi, rsi, idx, U0, T0,T1,T2,T3  ; [rsp+carry] = rax = cf = pBuffer[]+pModulo[]*u
   sub   rcx, 1
   jmp   mla2x4n_4

fin_mla1x4n_3:
   MM_MLAx1_4N_3_ELOG rdi, rsi, idx, U0, T0,T1,T2,T3  ; [rsp+carry] = rax = cf = pBuffer[]+pModulo[]*u
   sub   rcx, 1
   jmp   mla2x4n_3

fin_mla1x4n_2:
   MM_MLAx1_4N_2_ELOG rdi, rsi, idx, U0, T0,T1,T2,T3  ; [rsp+carry] = rax = cf = pBuffer[]+pModulo[]*u
   sub   rcx, 1
   jmp   mla2x4n_2

ALIGN IPP_ALIGN_FACTOR
;
; modulus of even length
;
even_len_Modulus:
   xor   rax, rax    ; clear carry
   cmp   rdx, 2
   ja    mla2x4n_1   ; rdx=1
   jz    mla2x4n_2   ; rdx=2
   jp    mla2x4n_3   ; rdx=3
   ;     mla2x4n_4   ; rdx=0

  ALIGN IPP_ALIGN_FACTOR
mla2x4n_4:
   MMx2_PLOG            rdi, rsi, idx, r15, U0,U1,T0,T1,T2,T3  ; pre-compute u0 and u1
   MLAx2                rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; rax = cf = product[]+modulo[]*{u1:u0}
   MM_MLAx2_4N_4_ELOG   rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; [rsp+carry] = rax = cf
   sub               rcx, 2
   jnz               mla2x4n_4

   ; (borrow, pR) = (carry,product) - modulo
   mov      rdx, qword ptr [rsp+pR]
   xor      rcx, rcx
   SBB_x4      rdx, rdi, rsi, idx, T0,T1,T2,T3, rcx
   SBB_TAIL 4, rdx, rdi, rsi, T0,T1,T2,T3, rcx

   ; pR = borrow? product : pR
   CMOV_x4     rdx, rdi, rdx, idx, T0,T1,T2,T3, rcx
   CMOV_TAIL   4, rdx, rdi, rdx, T0,T1,T2,T3, rcx
   jmp      quit

  ALIGN IPP_ALIGN_FACTOR
mla2x4n_3:
   MMx2_PLOG            rdi, rsi, idx, r15, U0,U1,T0,T1,T2,T3  ; pre-compute u0 and u1
   MLAx2                rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; rax = cf = product[]+modulo[]*{u1:u0}
   MM_MLAx2_4N_3_ELOG   rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; [rsp+carry] = rax = cf
   sub               rcx, 2
   jnz               mla2x4n_3

   ; (borrow, pR) = (carry,product) - modulo
   mov      rdx, qword ptr [rsp+pR]
   xor      rcx, rcx
   SBB_x4      rdx, rdi, rsi, idx, T0,T1,T2,T3, rcx
   SBB_TAIL 3, rdx, rdi, rsi, T0,T1,T2,T3, rcx

   ; pR = borrow? product : pR
   CMOV_x4     rdx, rdi, rdx, idx, T0,T1,T2,T3, rcx
   CMOV_TAIL   3, rdx, rdi, rdx, T0,T1,T2,T3, rcx
   jmp      quit

  ALIGN IPP_ALIGN_FACTOR
mla2x4n_2:
   MMx2_PLOG            rdi, rsi, idx, r15, U0,U1,T0,T1,T2,T3  ; pre-compute u0 and u1
   MLAx2                rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; rax = cf = product[]+modulo[]*{u1:u0}
   MM_MLAx2_4N_2_ELOG   rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; [rsp+carry] = rax = cf
   sub               rcx, 2
   jnz               mla2x4n_2

   ; (borrow, pR) = (carry,product) - modulo
   mov      rdx, qword ptr [rsp+pR]
   xor      rcx, rcx
   SBB_x4      rdx, rdi, rsi, idx, T0,T1,T2,T3, rcx
   SBB_TAIL 2, rdx, rdi, rsi, T0,T1,T2,T3, rcx

   ; pR = borrow? product : pR
   CMOV_x4     rdx, rdi, rdx, idx, T0,T1,T2,T3, rcx
   CMOV_TAIL   2, rdx, rdi, rdx, T0,T1,T2,T3, rcx
   jmp      quit


  ALIGN IPP_ALIGN_FACTOR
mla2x4n_1:
   MMx2_PLOG            rdi, rsi, idx, r15, U0,U1,T0,T1,T2,T3  ; pre-compute u0 and u1
   MLAx2                rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ; rax = cf = product[]+modulo[]*{u1:u0}
   MM_MLAx2_4N_1_ELOG   rdi, rsi, idx, U0,U1, T0,T1,T2,T3      ;  [rsp+carry] = rax = cf
   sub               rcx, 2
   jnz               mla2x4n_1

   ; (borrow, pR) = (carry,product) - modulo
   mov      rdx, qword ptr [rsp+pR]
   xor      rcx, rcx
   SBB_x4      rdx, rdi, rsi, idx, T0,T1,T2,T3, rcx
   SBB_TAIL 1, rdx, rdi, rsi, T0,T1,T2,T3, rcx

   ; pR = borrow? product : pR
   CMOV_x4     rdx, rdi, rdx, idx, T0,T1,T2,T3, rcx
   CMOV_TAIL   1, rdx, rdi, rdx, T0,T1,T2,T3, rcx

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM cpMontRedAdc_BNU ENDP

ENDIF

ENDIF ;; _ADCOX_NI_ENABLING_
END
