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
;               Low level Big Number squaring Support
; 
;

IFNDEF _PCPBNSQR_BASIC_ADCX_INC_
_PCPBNSQR_BASIC_ADCX_INC_ = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Fixed-size (1-8 qwords) squar operations
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; acc:a1 = src * mem + a1
MULADD1x MACRO    acc, a1, src, mem
IFDIFI <src>,<rdx>
   mov   rdx, src
ENDIF
gsmulx   acc, rax, mem
   add   a1, rax
   adc   acc, 0
ENDM

; acc:a1 = src * mem + a1 + acc
MULADDx  MACRO acc, a1, src, mem, H
IFDIFI <src>,<rdx>
   mov   rdx, src
ENDIF
gsmulx   H,rax, mem
   add   a1, rax
   adc   H, 0
   add   a1, acc
   adc   H, 0
   mov   acc, H
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; assignment
;;
pDst  equ   rdi
pSrc  equ   rsi
pA    equ   rsi

A     equ   rcx
x0    equ   r8
x1    equ   r9
x2    equ   r10
x3    equ   r11
x4    equ   r12
x5    equ   r13
x6    equ   r14
x7    equ   r15
x8    equ   rbx
t0    equ   rbp


;;
;; 1*qword squarer
;;
SQR_64   MACRO pDst, pA
   mov   rdx, qword ptr [pA]
gsmulx   rdx, rax, rdx
   mov   qword ptr [pDst], rax
   mov   qword ptr [pDst+sizeof(qword)], rdx
ENDM

ALIGN 16
sqr_1:
   SQR_64       pDst, pA
   ret


;;
;; 2*qword squarer
;;
SQR_128 MACRO  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   mov   rdx, qword ptr [pA]
gsmulx   x1,x0,qword ptr [rsi+sizeof(qword)*1]  ; a[0]*a[1]

gsmulx   x3,x2,rdx                           ; a[0]^2
   mov   rdx, qword ptr [pA+sizeof(qword)]   ; a[1]
gsmulx   rdx,rax,rdx                         ; a[1]^2

   xor   A, A
   add   x0, x0
   adc   x1, x1
   adc   A, 0

   mov   qword ptr[pDst+sizeof(qword)*0], x2
   add   x3, x0
   mov   qword ptr[pDst+sizeof(qword)*1], x3
   adc   rax, x1
   mov   qword ptr[pDst+sizeof(qword)*2], rax
   adc   rdx, A
   mov   qword ptr[pDst+sizeof(qword)*3], rdx
ENDM

ALIGN 16
sqr_2:
   SQR_128    pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 3*qword squarer
;;
SQR_192  MACRO pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]

   mov      rdx, qword ptr [pA+sizeof(qword)*1]
gsmulx      x3, rax, qword ptr [pA+sizeof(qword)*2]
   add      x2, rax
   adc      x3, 0

   mov      rdx, qword ptr [pA+ sizeof(qword)*0]

   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      A, A

   ;; add sqr(a[0]),...,sqr(a[2])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   adc      A, rax
   mov      [pDst+sizeof(qword)*5], A
ENDM

ALIGN 16
sqr_3:
   SQR_192  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 4*qword squarer
;;
SQR_256  MACRO pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]
   MULADD1x x3, x2, rdx, [pA+sizeof(qword)*3]

   mov      rdx, qword ptr [pA+sizeof(qword)*1]
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*2]
   xor      x4, x4
   add      x2, rax
   adc      x3, A
   adc      x4, 0
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*3]
   add      x3, rax
   adc      x4, A

   mov      rdx, qword ptr [pA+sizeof(qword)*2]
gsmulx      x5, rax, qword ptr [pA+sizeof(qword)*3]
   add      x4, rax
   adc      x5, 0

   mov      rdx, [pA+sizeof(qword)*0]

   ;; --- double x0...x5
   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, x5
   adc      A, 0

   ;; add sqr(a[0]),...,sqr(a[3])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   mov      rdx, [pA+sizeof(qword)*3]
   adc      x4, rax
   mov      [pDst+sizeof(qword)*5], x4

gsmulx      rax, rdx, rdx                 ; a[3]^2
   adc      x5, rdx
   mov      [pDst+sizeof(qword)*6], x5
   adc      A, rax
   mov      [pDst+sizeof(qword)*7], A
ENDM

ALIGN 16
sqr_4:
   SQR_256  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 5*qword squarer
;;
SQR_320  MACRO pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]
   MULADD1x x3, x2, rdx, [pA+sizeof(qword)*3]
   MULADD1x x4, x3, rdx, [pA+sizeof(qword)*4]

   mov      rdx, [pA + sizeof(qword)*1]
gsmulx      t0, rax, [pA+sizeof(qword)*2]
   add      x2, rax
   adc      t0, 0
   MULADDx  t0, x3, rdx, [pA+sizeof(qword)*3], A
   MULADDx  t0, x4, rdx, [pA+sizeof(qword)*4], A
   mov      x5, t0

   mov      rdx, qword ptr [pA+sizeof(qword)*2]
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*3]
   xor      x6, x6
   add      x4, rax
   adc      x5, A
   adc      x6, 0
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*4]
   add      x5, rax
   adc      x6, A

   mov      rdx, qword ptr [pA+sizeof(qword)*3]
gsmulx      x7, rax, qword ptr [pA+sizeof(qword)*4]
   add      x6, rax
   adc      x7, 0

   mov      rdx, [pA+sizeof(qword)*0]

   ;; --- double x0...x5
   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, x5
   adc      x6, x6
   adc      x7, x7
   adc      A, 0

   ;; add sqr(a[0]),...,sqr(a[4])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   mov      rdx, [pA+sizeof(qword)*3]
   adc      x4, rax
   mov      [pDst+sizeof(qword)*5], x4

gsmulx      rax, rdx, rdx                 ; a[3]^2
   adc      x5, rdx
   mov      [pDst+sizeof(qword)*6], x5
   mov      rdx, [pA+sizeof(qword)*4]
   adc      x6, rax
   mov      [pDst+sizeof(qword)*7], x6

gsmulx      rax, rdx, rdx                 ; a[4]^2
   adc      x7, rdx
   mov      [pDst+sizeof(qword)*8], x7
   mov      rdx, [pA+sizeof(qword)*5]
   adc      A, rax
   mov      [pDst+sizeof(qword)*9], A
ENDM

ALIGN 16
sqr_5:
   SQR_320  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 6*qword squarer
;;
SQR_384  MACRO pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]
   MULADD1x x3, x2, rdx, [pA+sizeof(qword)*3]
   MULADD1x x4, x3, rdx, [pA+sizeof(qword)*4]
   MULADD1x x5, x4, rdx, [pA+sizeof(qword)*5]

   mov      rdx, [pA + sizeof(qword)*1]
gsmulx      t0, rax, [pA+sizeof(qword)*2]
   add      x2, rax
   adc      t0, 0
   MULADDx  t0, x3, rdx, [pA+sizeof(qword)*3], A
   MULADDx  t0, x4, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*5], A
   mov      x6, t0

   mov      rdx, [pA+sizeof(qword)*2]
gsmulx      t0, rax, [pA+sizeof(qword)*3]
   add      x4, rax
   adc      t0, 0
   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x6, rdx, [pA+sizeof(qword)*5], A
   mov      x7, t0

   mov      rdx, qword ptr [pA+sizeof(qword)*3]
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*4]
   xor      x8, x8
   add      x6, rax
   adc      x7, A
   adc      x8, 0
gsmulx      A, rax, qword ptr [pA+sizeof(qword)*5]
   add      x7, rax
   adc      x8, A

   mov      rdx, qword ptr [pA+sizeof(qword)*4]
gsmulx      t0, rax, qword ptr [pA+sizeof(qword)*5]
   add      x8, rax
   adc      t0, 0

   mov      rdx, [pA+sizeof(qword)*0]

   ;; --- double x0...x7,x8,t0
   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, x5
   adc      x6, x6
   adc      x7, x7
   adc      x8, x8
   adc      t0, t0
   adc      A, 0

   ;; add sqr(a[0]),...,sqr(a[5])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   mov      rdx, [pA+sizeof(qword)*3]
   adc      x4, rax
   mov      [pDst+sizeof(qword)*5], x4

gsmulx      rax, rdx, rdx                 ; a[3]^2
   adc      x5, rdx
   mov      [pDst+sizeof(qword)*6], x5
   mov      rdx, [pA+sizeof(qword)*4]
   adc      x6, rax
   mov      [pDst+sizeof(qword)*7], x6

gsmulx      rax, rdx, rdx                 ; a[4]^2
   adc      x7, rdx
   mov      [pDst+sizeof(qword)*8], x7
   mov      rdx, [pA+sizeof(qword)*5]
   adc      x8, rax
   mov      [pDst+sizeof(qword)*9], x8

gsmulx      rax, rdx, rdx                 ; a[5]^2
   adc      t0, rdx
   mov      [pDst+sizeof(qword)*10], t0
   adc      A, rax
   mov      [pDst+sizeof(qword)*11], A
ENDM

ALIGN 16
sqr_6:
   SQR_384  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 7*qword squarer
;;
SQR_448  MACRO    pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ;; ------------------
   ;; first pass 01...06
   ;; ------------------
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]
   MULADD1x x3, x2, rdx, [pA+sizeof(qword)*3]
   MULADD1x x4, x3, rdx, [pA+sizeof(qword)*4]
   MULADD1x x5, x4, rdx, [pA+sizeof(qword)*5]
   MULADD1x x6, x5, rdx, [pA+sizeof(qword)*6]

   ;; ------------------
   ;; second pass 12...16
   ;; ------------------
   mov      rdx, [pA + sizeof(qword)*1]
gsmulx      t0, rax, [pA+sizeof(qword)*2]
   add      x2, rax
   adc      t0, 0

   MULADDx  t0, x3, rdx, [pA+sizeof(qword)*3], A
   MULADDx  t0, x4, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*5], A
   MULADDx  t0, x6, rdx, [pA+sizeof(qword)*6], A
   mov      x7, t0

   ;; ------------------
   ;; third pass 23...25
   ;; ------------------
   mov      rdx, [pA+sizeof(qword)*2]
gsmulx      t0, rax, [pA+sizeof(qword)*3]
   add      x4, rax
   adc      t0, 0

   xor      x8, x8
   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x6, rdx, [pA+sizeof(qword)*5], A
   add      x7, t0
   adc      x8, 0

   ;; ------------------
   ;; fourth pass 34
   ;; ------------------
   mov      rax, [pA+sizeof(qword)*3]
   mul      qword ptr[pA+sizeof(qword)*4]
   add      x6, rax
   adc      rdx, 0
   add      x7, rdx
   adc      x8, 0

   mov      rdx, [pA+sizeof(qword)*0]

   ;; --- double x0...x6
   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, x5
   adc      x6, x6
   adc      A, 0

   ;; add sqr(a[0]),...,sqr(a[3])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   mov      rdx, [pA+sizeof(qword)*3]
   adc      x4, rax
   mov      [pDst+sizeof(qword)*5], x4

gsmulx      rax, rdx, rdx                 ; a[3]^2
   adc      x5, rdx
   mov      [pDst+sizeof(qword)*6], x5
   adc      x6, rax
   mov      [pDst+sizeof(qword)*7], x6
   adc      A, 0

   ;; ------------------
   ;; third pass complete 26
   ;; ------------------
   mov      rax, [pA+sizeof(qword)*2]
   xor      x0, x0

   mul      qword ptr[pA+sizeof(qword)*6]
   add      x7, rax
   adc      rdx, 0
   add      x8, rdx
   adc      x0, 0

   ;; ------------------
   ;; forth pass complete 35...36
   ;; ------------------
   mov      rdx, [pA+sizeof(qword)*3]
gsmulx      x6, rax, [pA+sizeof(qword)*5]
   add      x7, rax
   adc      x8, x6
   adc      x0, 0
gsmulx      x6, rax, [pA+sizeof(qword)*6]
   add      x8, rax
   adc      x0, x6

   ;; ------------------
   ;; fifth pass 45...46
   ;; ------------------
   mov      rdx, [pA+sizeof(qword)*4]
gsmulx      x6, rax, [pA+sizeof(qword)*5]
   xor      x1, x1
   add      x8, rax
   adc      x0, x6
   adc      x1, 0
gsmulx      x6, rax, [pA+sizeof(qword)*6]
   add      x0, rax
   adc      x1, x6

   ;; ------------------
   ;; six pass 56
   ;; ------------------
   mov      rax, [pA+sizeof(qword)*5]
   xor      x2, x2
   mul      qword ptr [pA + sizeof(qword)*6]
   add      x1, rax
   adc      x2, rdx

   mov      rdx, [pA+sizeof(qword)*4]

   ;; --- double x7, x8, x0, x1, x2
   xor      x3, x3
   add      x7, x7
   adc      x8, x8
   adc      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, 0

gsmulx      rax, rdx, rdx                 ; a[4]^2
   add      rdx, A
   adc      rax, 0
   add      x7, rdx
   mov      rdx, [pA+sizeof(qword)*5]
   mov      [pDst+sizeof(qword)*8], x7
   adc      x8, rax
   mov      [pDst+sizeof(qword)*9], x8

gsmulx      rax, rdx, rdx                 ; a[5]^2
   adc      x0, rdx
   mov      [pDst+sizeof(qword)*10], x0
   mov      rdx, [pA+sizeof(qword)*6]
   adc      x1, rax
   mov      [pDst+sizeof(qword)*11], x1

gsmulx      rax, rdx, rdx                 ; a[6]^2
   adc      x2, rdx
   mov      [pDst+sizeof(qword)*12], x2
   adc      x3, rax
   mov      [pDst+sizeof(qword)*13], x3
ENDM

ALIGN 16
sqr_7:
   SQR_448  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;
;; 8*qword squarer
;;
SQR_512  MACRO    pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ;; ----------------------------------
   ;; first pass a[0]*a[1],...,a[0]*a[7]
   ;; ----------------------------------
   mov      rdx, [pA]
gsmulx      x1,x0, [pA+sizeof(qword)*1]
   MULADD1x x2, x1, rdx, [pA+sizeof(qword)*2]
   MULADD1x x3, x2, rdx, [pA+sizeof(qword)*3]
   MULADD1x x4, x3, rdx, [pA+sizeof(qword)*4]
   MULADD1x x5, x4, rdx, [pA+sizeof(qword)*5]
   MULADD1x x6, x5, rdx, [pA+sizeof(qword)*6]
   MULADD1x x7, x6, rdx, [pA+sizeof(qword)*7]

   ;; -----------------------------------
   ;; second pass a[1]*a[2],...,a[1]*a[6]
   ;; -----------------------------------
   mov      rdx, [pA + sizeof(qword)*1]
gsmulx      t0, rax, [pA+sizeof(qword)*2]
   add      x2, rax
   adc      t0, 0
   xor      x8, x8

   MULADDx  t0, x3, rdx, [pA+sizeof(qword)*3], A
   MULADDx  t0, x4, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*5], A
   MULADDx  t0, x6, rdx, [pA+sizeof(qword)*6], A
   add      x7, t0
   adc      x8, 0

   ;; ----------------------------------
   ;; third pass a[2]*a[3],...,a[2]*a[5]
   ;; ----------------------------------
   mov      rdx, [pA+sizeof(qword)*2]
gsmulx      t0, rax, [pA+sizeof(qword)*3]
   add      x4, rax
   adc      t0, 0

   MULADDx  t0, x5, rdx, [pA+sizeof(qword)*4], A
   MULADDx  t0, x6, rdx, [pA+sizeof(qword)*5], A
   add      x7, t0
   adc      x8, 0

   ;; ---------------------
   ;; fourth pass a[3]*a[4]
   ;; ---------------------
   mov      rax, [pA+sizeof(qword)*3]
   mul      qword ptr [pA+sizeof(qword)*4]
   add      x6, rax
   adc      rdx, 0
   add      x7, rdx
   adc      x8, 0

   mov      rdx, [pA+sizeof(qword)*0]

   ;; double x0,...,x6
   xor      A, A
   add      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, x5
   adc      x6, x6
   adc      A, 0

   ;; add sqr(a[0]),...,sqr(a[3])
gsmulx      rax, rdx, rdx                 ; a[0]^2
   mov      [pDst+sizeof(qword)*0], rdx
   mov      rdx, [pA+sizeof(qword)*1]
   add      x0, rax
   mov      [pDst+sizeof(qword)*1], x0

gsmulx      rax, rdx, rdx                 ; a[1]^2
   adc      x1, rdx
   mov      [pDst+sizeof(qword)*2], x1
   mov      rdx, [pA+sizeof(qword)*2]
   adc      x2, rax
   mov      [pDst+sizeof(qword)*3], x2

gsmulx      rax, rdx, rdx                 ; a[2]^2
   adc      x3, rdx
   mov      [pDst+sizeof(qword)*4], x3
   mov      rdx, [pA+sizeof(qword)*3]
   adc      x4, rax
   mov      [pDst+sizeof(qword)*5], x4

gsmulx      rax, rdx, rdx                 ; a[3]^2
   adc      x5, rdx
   mov      [pDst+sizeof(qword)*6], x5
   adc      x6, rax
   mov      [pDst+sizeof(qword)*7], x6
   adc      A, 0

   ;; ----------------------------
   ;; second pass (cont) a[1]*a[7]
   ;; ----------------------------
   mov      rax, [pA+sizeof(qword)*1]
   xor      x0, x0
   mul      qword ptr[pA+sizeof(qword)*7]
   add      x7, rax
   adc      rdx, 0
   add      x8, rdx
   adc      x0, 0

   ;; -----------------------------------------
   ;; third pass (cont) a[2]*a[6],...,a[2]*a[7]
   ;; -----------------------------------------
   mov      rdx, [pA+sizeof(qword)*2]
gsmulx      x6, rax, [pA+sizeof(qword)*6]
   add      x7, rax
   adc      x8, x6
   adc      x0, 0
gsmulx      x6, rax, [pA+sizeof(qword)*7]
   xor      x1, x1
   add      x8, rax
   adc      x0, x6
   adc      x1, 0

   ;; -----------------------------------
   ;; fourth pass a[3]*a[5],...,a[3]*a[7]
   ;; -----------------------------------
   mov      rdx, [pA+sizeof(qword)*3]
gsmulx      x6, rax, [pA+sizeof(qword)*5]
   add      x7, rax
   adc      x6, 0
   add      x8, x6
   adc      x0, 0
   adc      x1, 0
gsmulx      x6, rax, [pA+sizeof(qword)*6]
   add      x8, rax
   adc      x6, 0
   add      x0, x6
   adc      x1, 0
gsmulx      x6, rax, [pA+sizeof(qword)*7]
   add      x0, rax
   adc      x6, 0
   add      x1, x6
   ;; carry out should be 0

   ;; -----------------------------------
   ;; fifth pass a[4]*a[5],...,a[4]*a[7]
   ;; -----------------------------------
   mov      rdx, [pA+sizeof(qword)*4]

gsmulx      x2, rax, [pA+sizeof(qword)*5]
   add      x8, rax
   adc      x2, 0

   MULADDx  x2, x0, rdx, [pA+sizeof(qword)*6], x6
   MULADDx  x2, x1, rdx, [pA+sizeof(qword)*7], x6

   ;; -----------------------------------------------------------
   ;; sixth pass a[5]*a[6],...,a[5]*a[7] & seventh pass a[6]*a[7]
   ;; -----------------------------------------------------------
   mov      rdx, [pA+sizeof(qword)*5]

gsmulx      x3, rax, [pA+sizeof(qword)*6]
   add      x1, rax
   adc      x3, 0

   MULADDx  x3, x2, rdx, [pA+sizeof(qword)*7], x6

   mov      rax, [pA+sizeof(qword)*6]
   mul      qword ptr[pA+sizeof(qword)*7]
   add      x3, rax
   adc      rdx, 0
   mov      x4, rdx

   mov      rdx, [pA+sizeof(qword)*4]

   ;; --- double x7, x8, x0, ..., x4
   xor      x5, x5
   add      x7, x7
   adc      x8, x8
   adc      x0, x0
   adc      x1, x1
   adc      x2, x2
   adc      x3, x3
   adc      x4, x4
   adc      x5, 0

   ;; add sqr(a[4]),...,sqr(a[7])
gsmulx      rax, rdx, rdx                 ; a[4]^2
   add      rdx, A
   adc      rax, 0
   add      x7, rdx
   mov      rdx, [pA+sizeof(qword)*5]
   mov      [pDst+sizeof(qword)*8], x7
   adc      x8, rax
   mov      [pDst+sizeof(qword)*9], x8

gsmulx      rax, rdx, rdx                 ; a[5]^2
   adc      x0, rdx
   mov      [pDst+sizeof(qword)*10], x0
   mov      rdx, [pA+sizeof(qword)*6]
   adc      x1, rax
   mov      [pDst+sizeof(qword)*11], x1

gsmulx      rax, rdx, rdx                 ; a[6]^2
   adc      x2, rdx
   mov      [pDst+sizeof(qword)*12], x2
   mov      rdx, [pA+sizeof(qword)*7]
   adc      x3, rax
   mov      [pDst+sizeof(qword)*13], x3

gsmulx      rax, rdx, rdx                 ; a[7]^2
   adc      x4, rdx
   mov      [pDst+sizeof(qword)*14], x4
   adc      x5, rax
   mov      [pDst+sizeof(qword)*15], x5
ENDM

ALIGN 16
sqr_8:
   SQR_512  pDst, pA, x7, x6, x5, x4, x3, x2, x1, x0, A, x8, t0
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SQR_512_TRIANGLE_STEP
; executes single line of upper tpiangle
;
; Inp:partial sum:   x7 x6 x5 x4 x3 x2 x1 x0
;   rdx * pA[]     p  p  p  p  p  p  p  p  p
; Out:            x0 x7 x6 x5 x4 x3 x2 x1
;                                        [dst]

SQR_512_TRIANGLE_STEP   MACRO    HEAD_X, X7, X6, X5, X4, X3, X2, X1, X0, TAIL_X, pDst, pA, TMP1, TMP2
IFNB <X0>
gsmulx   TMP1, rax, [pA+sizeof(qword)*0]     ; TMP1:rax = rdx * pA[0]
   add   X0, rax
   adc   TMP1, 0
ENDIF

IFNB <TAIL_X>
   mov   pDst, TAIL_X
ENDIF

IFNB <X1>
gsmulx   TMP2, rax, [pA+sizeof(qword)*1]   ; TMP2:rax = rdx * pA[1]
   add   X1, rax
   adc   TMP2, 0
IFNB <X0>
   add   X1, TMP1
   adc   TMP2, 0
ENDIF
ENDIF

IFNB <X2>
gsmulx   TMP1, rax, [pA+sizeof(qword)*2]     ; TMP1:rax = rdx * pA[2]
   add   X2, rax
   adc   TMP1, 0
IFNB <X1>
   add   X2, TMP2
   adc   TMP1, 0
ENDIF
ENDIF

IFNB <X3>
gsmulx   TMP2, rax, [pA+sizeof(qword)*3]     ; TMP2:rax = rdx * pA[3]
   add   X3, rax
   adc   TMP2, 0
IFNB <X2>
   add   X3, TMP1
   adc   TMP2, 0
ENDIF
ENDIF

IFNB <X4>
gsmulx   TMP1, rax, [pA+sizeof(qword)*4]     ; TMP1:rax = rdx * pA[4]
   add   X4, rax
   adc   TMP1, 0
IFNB <X3>
   add   X4, TMP2
   adc   TMP1, 0
ENDIF
ENDIF

IFNB <X5>
gsmulx   TMP2, rax, [pA+sizeof(qword)*5]     ; TMP2:rax = rdx * pA[5]
   add   X5, rax
   adc   TMP2, 0
IFNB <X4>
   add   X5, TMP1
   adc   TMP2, 0
ENDIF
ENDIF

IFNB <X6>
gsmulx   TMP1, rax, [pA+sizeof(qword)*6]     ; TMP1:rax = rdx * pA[6]
   add   X6, rax
   adc   TMP1, 0
IFNB <X5>
   add   X6, TMP2
   adc   TMP1, 0
ENDIF
ENDIF

IFNB <X7>
gsmulx   HEAD_X, rax, [pA+sizeof(qword)*7]   ; X0:rax = rdx * pA[7]
   add   X7, rax
   adc   HEAD_X, 0
IFNB <X6>
   add   X7, TMP1
   adc   HEAD_X, 0
ENDIF
ENDIF
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; square and add diagonal terms

ADD_DIAG  MACRO   N, pDst, pSrc
   mov      r8, qword ptr[pDst+sizeof(qword)*0]
   mov      r9, qword ptr[pDst+sizeof(qword)*1]
IF N GT 1
   mov      r10,qword ptr[pDst+sizeof(qword)*2]
   mov      r11,qword ptr[pDst+sizeof(qword)*3]
IF N GT 2
   mov      r12,qword ptr[pDst+sizeof(qword)*4]
   mov      r13,qword ptr[pDst+sizeof(qword)*5]
IF N GT 3
   mov      r14,qword ptr[pDst+sizeof(qword)*6]
   mov      r15,qword ptr[pDst+sizeof(qword)*7]
ENDIF
ENDIF
ENDIF

   xor      rbp, rbp
   add      r8, r8
   adc      r9, r9
IF N GT 1
   adc      r10,r10
   adc      r11,r11
IF N GT 2
   adc      r12,r12
   adc      r13,r13
IF N GT 3
   adc      r14,r14
   adc      r15,r15
ENDIF
ENDIF
ENDIF
   adc      rbp, 0

   mov      rdx, [pSrc+sizeof(qword)*0]
gsmulx      rdx, rax, rdx
   add      rax, rbx
   adc      rdx, 0
   add      r8, rax
   mov      rbx, rbp
   adc      r9, rdx

IF N GT 1
   mov      rdx, [pSrc+sizeof(qword)*1]
gsmulx      rdx, rax, rdx
   adc      r10,rax
   adc      r11,rdx

IF N GT 2
   mov      rdx, [pSrc+sizeof(qword)*2]
gsmulx      rdx, rax, rdx
   adc      r12,rax
   adc      r13,rdx

IF N GT 3
   mov      rdx, [pSrc+sizeof(qword)*3]
gsmulx      rdx, rax, rdx
   adc      r14,rax
   adc      r15,rdx
ENDIF
ENDIF
ENDIF

   adc      rbx, 0
   mov      qword ptr[pDst+sizeof(qword)*0], r8
   mov      qword ptr[pDst+sizeof(qword)*1], r9
IF N GT 1
   mov      qword ptr[pDst+sizeof(qword)*2], r10
   mov      qword ptr[pDst+sizeof(qword)*3], r11
IF N GT 2
   mov      qword ptr[pDst+sizeof(qword)*4], r12
   mov      qword ptr[pDst+sizeof(qword)*5], r13
IF N GT 3
   mov      qword ptr[pDst+sizeof(qword)*6], r14
   mov      qword ptr[pDst+sizeof(qword)*7], r15
ENDIF
ENDIF
ENDIF
ENDM

IF _IPP32E EQ _IPP32E_K0
  add_diag_4 EQU k0_add_diag_4
ENDIF
IF _IPP32E EQ _IPP32E_N0
  add_diag_4 EQU n0_add_diag_4
ENDIF

;; rbp = local carry
;; rbx = global carry
ALIGN 16
add_diag_4: ; PROC PRIVATE
   ADD_DIAG 4, rdi, rsi
   ret
;add_diag_4 ENDP


;;
;; 8*qword triangle
;;
ALIGN 16
sqr8_triangle:
   ;; A[0]*A[1..7]
   mov      rdx, [rsi+sizeof(qword)*0]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,r11,r10, r9,   , r8,  [rdi+sizeof(qword)*0],rsi, rbx,rbp

   ;; A[1]*A[2..7]
   mov      rdx, [rsi+sizeof(qword)*1]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,r13,r12,r11,   ,   , r9,  [rdi+sizeof(qword)*1],rsi, rbx,rbp

   ;; A[2]*A[3..7]
   mov      rdx, [rsi+sizeof(qword)*2]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,r15,r14,r13,   ,   ,   , r10, [rdi+sizeof(qword)*2],rsi, rbx,rbp

   ;; A[3]*A[4..7]
   mov      rdx, [rsi+sizeof(qword)*3]
   SQR_512_TRIANGLE_STEP   r11, r10, r9, r8,r15,   ,   ,   ,   , r11, [rdi+sizeof(qword)*3],rsi, rbx,rbp

   ;; A[4]*A[5..7]
   mov      rdx, [rsi+sizeof(qword)*4]
   SQR_512_TRIANGLE_STEP   r12, r11,r10, r9,   ,   ,   ,   ,   , r12, [rdi+sizeof(qword)*4],rsi, rbx,rbp

   ;; A[5]*A[6..7]
   mov      rdx, [rsi+sizeof(qword)*5]
   SQR_512_TRIANGLE_STEP   r13, r12,r11,   ,   ,   ,   ,   ,   , r13, [rdi+sizeof(qword)*5],rsi, rbx,rbp

   ;; A[6]*A[7]
   mov      rdx, [rsi+sizeof(qword)*6]
   SQR_512_TRIANGLE_STEP   r14, r13,   ,   ,   ,   ,   ,   ,   , r14, [rdi+sizeof(qword)*6],rsi, rbx,rbp
   ret


;;
;; 9*qword squarer
;;
ALIGN 16
sqr_9:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x1

   mov      qword ptr[rdi+sizeof(qword)*(1+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(1+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(1+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(1+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(1+4)], r12
   mov      qword ptr[rdi+sizeof(qword)*(1+5)], r13
   mov      qword ptr[rdi+sizeof(qword)*(1+6)], r14
   mov      qword ptr[rdi+sizeof(qword)*(1+7)], r15

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(1+8)], rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 1, rdi, rsi

   sub      rsi, sizeof(qword)*8
   sub      rdi, sizeof(qword)*16
   ret


;;
;; 10*qword squarer
;;
ALIGN 16
sqr_10:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x2

   mov      qword ptr[rdi+sizeof(qword)*(2+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(2+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(2+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(2+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(2+4)], r12
   mov      qword ptr[rdi+sizeof(qword)*(2+5)], r13
   mov      qword ptr[rdi+sizeof(qword)*(2+6)], r14

   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP  r8, r15, , , , , , , , , , <rsi+sizeof(qword)*2>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(2+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(2+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(2+9)], rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 2, rdi, rsi

   sub      rsi, sizeof(qword)*8
   sub      rdi, sizeof(qword)*16
   ret


;;
;; 10*qword squarer
;;
ALIGN 16
sqr_11:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x1
   add      rdi, sizeof(qword)*1
   add      rcx, sizeof(qword)*1
   call     mla_8x2
   sub      rdi, sizeof(qword)*1
   sub      rcx, sizeof(qword)*1

   mov      qword ptr[rdi+sizeof(qword)*(3+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(3+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(3+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(3+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(3+4)], r12


;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(3+5)],<rsi+sizeof(qword)*3>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(3+6)],<rsi+sizeof(qword)*3>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(3+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(3+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(3+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(3+10)],rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 3, rdi, rsi

   sub      rsi, sizeof(qword)*(4*2)
   sub      rdi, sizeof(qword)*(8*2)
   ret


;;
;; 12*qword squarer
;;
ALIGN 16
sqr_12:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   sub      rdi, sizeof(qword)*2
   sub      rcx, sizeof(qword)*2

   mov      qword ptr[rdi+sizeof(qword)*(4+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(4+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(4+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(4+3)], r11

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(4+4)],<rsi+sizeof(qword)*4>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(4+5)],<rsi+sizeof(qword)*4>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(4+6)],<rsi+sizeof(qword)*4>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(4+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(4+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(4+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(4+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(4+11)],rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4

   sub      rsi, sizeof(qword)*(4*2)
   sub      rdi, sizeof(qword)*(8*2)
   ret


;;
;; 13*qword squarer
;;
ALIGN 16
sqr_13:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x1
   add      rdi, sizeof(qword)
   add      rcx, sizeof(qword)
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   sub      rdi, sizeof(qword)*3
   sub      rcx, sizeof(qword)*3

   mov      qword ptr[rdi+sizeof(qword)*(5+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(5+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(5+2)], r10

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(5+3)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(5+4)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(5+5)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(5+6)],<rsi+sizeof(qword)*5>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(5+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(5+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(5+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(5+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(5+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(5+12)],rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 1, rdi, rsi

   sub      rsi, sizeof(qword)*(4*3)
   sub      rdi, sizeof(qword)*(8*3)
   ret


;;
;; 14*qword squarer
;;
ALIGN 16
sqr_14:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   sub      rdi, sizeof(qword)*4
   sub      rcx, sizeof(qword)*4

   mov      qword ptr[rdi+sizeof(qword)*(6+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(6+1)], r9

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,r11,   ,   ,   ,  r10,[rdi+sizeof(qword)*(6+2)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,r13,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(6+3)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,r15,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(6+4)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10, r9,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(6+5)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*12]
   SQR_512_TRIANGLE_STEP   r12, r11,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(6+6)],<rsi+sizeof(qword)*6>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(6+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(6+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(6+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(6+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(6+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(6+12)],r12
   mov      qword ptr[rdi+sizeof(qword)*(6+13)],rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 2, rdi, rsi

   sub      rsi, sizeof(qword)*(4*3)
   sub      rdi, sizeof(qword)*(8*3)
   ret


;;
;; 15*qword squarer
;;
ALIGN 16
sqr_15:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call     mla_8x1
   add      rdi, sizeof(qword)
   add      rcx, sizeof(qword)
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2
   sub      rdi, sizeof(qword)*5
   sub      rcx, sizeof(qword)*5

   mov      qword ptr[rdi+sizeof(qword)*(7+0)], r8

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,r11,r10,   ,   ,  r9, [rdi+sizeof(qword)*(7+1)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,r13,r12,   ,   ,   ,  r10,[rdi+sizeof(qword)*(7+2)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,r15,r14,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(7+3)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10, r9, r8,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(7+4)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*12]
   SQR_512_TRIANGLE_STEP   r12, r11,r10,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(7+5)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*13]
   SQR_512_TRIANGLE_STEP   r13, r12,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(7+6)],<rsi+sizeof(qword)*7>, rbx,rbp

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*(7+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(7+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(7+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(7+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(7+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(7+12)],r12
   mov      qword ptr[rdi+sizeof(qword)*(7+13)],r13
   mov      qword ptr[rdi+sizeof(qword)*(7+14)],rbx

   sub      rdi, sizeof(qword)*8

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   ADD_DIAG 3, rdi, rsi

   sub      rsi, sizeof(qword)*(4*3)
   sub      rdi, sizeof(qword)*(8*3)
   ret


;;
;; 16*qword squarer
;;
ALIGN 16
sqr_16:
   call     sqr8_triangle

   mov      qword ptr[rdi+sizeof(qword)*7], r15

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   xor      r15, r15
   call   mla_8x2

   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2

   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2

   add      rdi, sizeof(qword)*2
   add      rcx, sizeof(qword)*2
   call     mla_8x2

   sub      rdi, sizeof(qword)*6
   sub      rcx, sizeof(qword)*6

   add      rdi, sizeof(qword)*8
   call     sqr8_triangle

   xor      rbx, rbx
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   mov      qword ptr[rdi+sizeof(qword)*8], r8
   mov      qword ptr[rdi+sizeof(qword)*9], r9
   mov      qword ptr[rdi+sizeof(qword)*10],r10
   mov      qword ptr[rdi+sizeof(qword)*11],r11
   mov      qword ptr[rdi+sizeof(qword)*12],r12
   mov      qword ptr[rdi+sizeof(qword)*13],r13
   mov      qword ptr[rdi+sizeof(qword)*14],r14
   mov      qword ptr[rdi+sizeof(qword)*15],rbx

   sub      rsi, sizeof(qword)*8
   sub      rdi, sizeof(qword)*16

   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4
   add      rdi, sizeof(qword)*8
   add      rsi, sizeof(qword)*4
   call     add_diag_4

   sub      rsi, sizeof(qword)*12
   sub      rdi, sizeof(qword)*24
   ret



;;
;; 9*qword triangle
;;
ALIGN 16
sqr9_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x1

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(1+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(1+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(1+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(1+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(1+4)], r12
   mov      qword ptr[rdi+sizeof(qword)*(1+5)], r13
   mov      qword ptr[rdi+sizeof(qword)*(1+6)], r14
   mov      qword ptr[rdi+sizeof(qword)*(1+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(1+8)], rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 10*qword triangle
;;
ALIGN 16
sqr10_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x2

   mov      qword ptr[rdi+sizeof(qword)*(2+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(2+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(2+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(2+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(2+4)], r12
   mov      qword ptr[rdi+sizeof(qword)*(2+5)], r13
   mov      qword ptr[rdi+sizeof(qword)*(2+6)], r14

   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP  r8, r15, , , , , , , , , , <rsi+sizeof(qword)*2>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(2+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(2+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(2+9)], rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 11*qword triangle
;;
ALIGN 16
sqr11_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x3

   mov      qword ptr[rdi+sizeof(qword)*(3+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(3+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(3+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(3+3)], r11
   mov      qword ptr[rdi+sizeof(qword)*(3+4)], r12

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(3+5)],<rsi+sizeof(qword)*3>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(3+6)],<rsi+sizeof(qword)*3>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(3+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(3+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(3+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(3+10)],rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 12*qword triangle
;;
ALIGN 16
sqr12_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x4

   mov      qword ptr[rdi+sizeof(qword)*(4+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(4+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(4+2)], r10
   mov      qword ptr[rdi+sizeof(qword)*(4+3)], r11

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(4+4)],<rsi+sizeof(qword)*4>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(4+5)],<rsi+sizeof(qword)*4>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(4+6)],<rsi+sizeof(qword)*4>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(4+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(4+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(4+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(4+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(4+11)],rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 13*qword triangle
;;
ALIGN 16
sqr13_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x5

   mov      qword ptr[rdi+sizeof(qword)*(5+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(5+1)], r9
   mov      qword ptr[rdi+sizeof(qword)*(5+2)], r10

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(5+3)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(5+4)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(5+5)],<rsi+sizeof(qword)*5>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(5+6)],<rsi+sizeof(qword)*5>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(5+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(5+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(5+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(5+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(5+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(5+12)],rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 14*qword triangle
;;
ALIGN 16
sqr14_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x6

   mov      qword ptr[rdi+sizeof(qword)*(6+0)], r8
   mov      qword ptr[rdi+sizeof(qword)*(6+1)], r9

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,r11,   ,   ,   ,  r10,[rdi+sizeof(qword)*(6+2)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,r13,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(6+3)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,r15,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(6+4)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10, r9,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(6+5)],<rsi+sizeof(qword)*6>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*12]
   SQR_512_TRIANGLE_STEP   r12, r11,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(6+6)],<rsi+sizeof(qword)*6>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(6+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(6+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(6+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(6+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(6+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(6+12)],r12
   mov      qword ptr[rdi+sizeof(qword)*(6+13)],rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 15*qword triangle
;;
ALIGN 16
sqr15_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   lea      rcx, [rsi+sizeof(qword)*8]
   add      rdi, sizeof(qword)*8
   call     mla_8x7

   mov      qword ptr[rdi+sizeof(qword)*(7+0)], r8

;  SQR_512_TRIANGLE_STEP     H,  p7, p6, p5, p4, p3, p2, p1, p0,  T, <dst>,<src>, rbx,rbp
;                          ------------------------------
   mov      rdx, qword ptr[rsi+sizeof(qword)*8]
   SQR_512_TRIANGLE_STEP    r8, r15,r14,r13,r12,r11,r10,   ,   ,  r9, [rdi+sizeof(qword)*(7+1)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*9]
   SQR_512_TRIANGLE_STEP    r9,  r8,r15,r14,r13,r12,   ,   ,   ,  r10,[rdi+sizeof(qword)*(7+2)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*10]
   SQR_512_TRIANGLE_STEP   r10,  r9, r8,r15,r14,   ,   ,   ,   ,  r11,[rdi+sizeof(qword)*(7+3)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*11]
   SQR_512_TRIANGLE_STEP   r11, r10, r9, r8,   ,   ,   ,   ,   ,  r12,[rdi+sizeof(qword)*(7+4)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*12]
   SQR_512_TRIANGLE_STEP   r12, r11,r10,   ,   ,   ,   ,   ,   ,  r13,[rdi+sizeof(qword)*(7+5)],<rsi+sizeof(qword)*7>, rbx,rbp
   mov      rdx, qword ptr[rsi+sizeof(qword)*13]
   SQR_512_TRIANGLE_STEP   r13, r12,   ,   ,   ,   ,   ,   ,   ,  r14,[rdi+sizeof(qword)*(7+6)],<rsi+sizeof(qword)*7>, rbx,rbp

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*(7+7)], r15
   mov      qword ptr[rdi+sizeof(qword)*(7+8)], r8
   mov      qword ptr[rdi+sizeof(qword)*(7+9)], r9
   mov      qword ptr[rdi+sizeof(qword)*(7+10)],r10
   mov      qword ptr[rdi+sizeof(qword)*(7+11)],r11
   mov      qword ptr[rdi+sizeof(qword)*(7+12)],r12
   mov      qword ptr[rdi+sizeof(qword)*(7+13)],r13
   mov      qword ptr[rdi+sizeof(qword)*(7+14)],rax

   sub      rdi, sizeof(qword)*8
   ret

;;
;; 16*qword triangle
;;
ALIGN 16
sqr16_triangle:
   call     sqr8_triangle
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   call     mla_8x8

   add      rdi, sizeof(qword)*8
   call     sqr8_triangle

   xor      rax, rax
   mov      qword ptr[rdi+sizeof(qword)*7], r15
   mov      qword ptr[rdi+sizeof(qword)*8], r8
   mov      qword ptr[rdi+sizeof(qword)*9], r9
   mov      qword ptr[rdi+sizeof(qword)*10],r10
   mov      qword ptr[rdi+sizeof(qword)*11],r11
   mov      qword ptr[rdi+sizeof(qword)*12],r12
   mov      qword ptr[rdi+sizeof(qword)*13],r13
   mov      qword ptr[rdi+sizeof(qword)*14],r14
   mov      qword ptr[rdi+sizeof(qword)*15],rax

   sub      rsi, sizeof(qword)*8
   sub      rdi, sizeof(qword)*16
   ret


sqr_l_basic    DQ    sqr_1 - sqr_l_basic
               DQ    sqr_2 - sqr_l_basic
               DQ    sqr_3 - sqr_l_basic
               DQ    sqr_4 - sqr_l_basic
               DQ    sqr_5 - sqr_l_basic
               DQ    sqr_6 - sqr_l_basic
               DQ    sqr_7 - sqr_l_basic
               DQ    sqr_8 - sqr_l_basic
               DQ    sqr_9 - sqr_l_basic
               DQ    sqr_10- sqr_l_basic
               DQ    sqr_11- sqr_l_basic
               DQ    sqr_12- sqr_l_basic
               DQ    sqr_13- sqr_l_basic
               DQ    sqr_14- sqr_l_basic
               DQ    sqr_15- sqr_l_basic
               DQ    sqr_16- sqr_l_basic

sqrN_triangle  DQ    sqr9_triangle  - sqrN_triangle
               DQ    sqr10_triangle - sqrN_triangle
               DQ    sqr11_triangle - sqrN_triangle
               DQ    sqr12_triangle - sqrN_triangle
               DQ    sqr13_triangle - sqrN_triangle
               DQ    sqr14_triangle - sqrN_triangle
               DQ    sqr15_triangle - sqrN_triangle
               DQ    sqr16_triangle - sqrN_triangle

ENDIF ;; _PCPBNSQR_BASIC_ADCX_INC_
