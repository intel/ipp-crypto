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

IFNDEF _PCPBNUSQR_INC_
_PCPBNUSQR_INC_ = 1

include pcpmulx.inc
include pcpbnusqrpp_basic.inc

IF _IPP32E EQ _IPP32E_K0
  sqr_8N_adcox EQU k0_sqr_8N_adcox
  sqr_N_adcox  EQU k0_sqr_N_adcox
ENDIF

IF _IPP32E EQ _IPP32E_N0
  sqr_8N_adcox EQU n0_sqr_8N_adcox
  sqr_N_adcox  EQU n0_sqr_N_adcox
ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (8*n) squarer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN 16
sqr_8N_adcox PROC PRIVATE
   push     rdi         ; save diagonal loop parameters
   push     rsi
   push     rdx

   push     rdi         ; save initial triangle product parameters
   push     rsi
   push     rdx
;
; init upper triangle product
;
   push     rdx
   call     sqr8_triangle
   pop      rdx

   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15
   add      rdi, sizeof(qword)*8

   sub      rdx, 8

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
initLoop:
   push     rdx
   call     mla_8x8
   pop      rdx
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   sub      rdx, 8
   jnz      initLoop

   mov      qword ptr[rdi+sizeof(qword)*0], r8
   mov      qword ptr[rdi+sizeof(qword)*1], r9
   mov      qword ptr[rdi+sizeof(qword)*2],r10
   mov      qword ptr[rdi+sizeof(qword)*3],r11
   mov      qword ptr[rdi+sizeof(qword)*4],r12
   mov      qword ptr[rdi+sizeof(qword)*5],r13
   mov      qword ptr[rdi+sizeof(qword)*6],r14
   mov      qword ptr[rdi+sizeof(qword)*7],r15
   jmp      update_Triangle

;
; update upper triangle product
;
outerLoop:
   push     rdi      ; update triangle product parameters
   push     rsi
   push     rdx

   xor      rax, rax    ; c-flag
   push     rax

   mov      r8,  qword ptr[rdi+sizeof(qword)*0]
   mov      r9,  qword ptr[rdi+sizeof(qword)*1]
   mov      r10, qword ptr[rdi+sizeof(qword)*2]
   mov      r11, qword ptr[rdi+sizeof(qword)*3]
   mov      r12, qword ptr[rdi+sizeof(qword)*4]
   mov      r13, qword ptr[rdi+sizeof(qword)*5]
   mov      r14, qword ptr[rdi+sizeof(qword)*6]
   mov      r15, qword ptr[rdi+sizeof(qword)*7]

innerLoop_entry:
   push     rdx
   call     sqr8_triangle
   pop      rdx

   mov      qword ptr[rdi+sizeof(qword)*7], r15
   xor      r15, r15
   add      rdi, sizeof(qword)*8

   sub      rdx, 8
   jz       skipInnerLoop

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
innerLoop:
   pop      rax      ; restore c-flag
   neg      rax
   op_reg_mem  adc,  r8,  qword ptr[rdi+sizeof(qword)*0], rax
   op_reg_mem  adc,  r9,  qword ptr[rdi+sizeof(qword)*1], rax
   op_reg_mem  adc,  r10, qword ptr[rdi+sizeof(qword)*2], rax
   op_reg_mem  adc,  r11, qword ptr[rdi+sizeof(qword)*3], rax
   op_reg_mem  adc,  r12, qword ptr[rdi+sizeof(qword)*4], rax
   op_reg_mem  adc,  r13, qword ptr[rdi+sizeof(qword)*5], rax
   op_reg_mem  adc,  r14, qword ptr[rdi+sizeof(qword)*6], rax
   op_reg_mem  adc,  r15, qword ptr[rdi+sizeof(qword)*7], rax
   sbb      rax, rax ; save c-flag
   push     rax

   push     rdx
   call     mla_8x8
   pop      rdx
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   sub      rdx, 8
   jnz      innerLoop

skipInnerLoop:
   pop      rax      ; restore c-flag
   neg      rax
   adc      r8, 0
   mov      qword ptr[rdi+sizeof(qword)*0], r8
   adc      r9, 0
   mov      qword ptr[rdi+sizeof(qword)*1], r9
   adc      r10,0
   mov      qword ptr[rdi+sizeof(qword)*2],r10
   adc      r11,0
   mov      qword ptr[rdi+sizeof(qword)*3],r11
   adc      r12,0
   mov      qword ptr[rdi+sizeof(qword)*4],r12
   adc      r13,0
   mov      qword ptr[rdi+sizeof(qword)*5],r13
   adc      r14,0
   mov      qword ptr[rdi+sizeof(qword)*6],r14
   adc      r15,0
   mov      qword ptr[rdi+sizeof(qword)*7],r15

update_Triangle:
   pop      rdx
   pop      rsi
   pop      rdi
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*(8*2)
   sub      rdx, 8
   jnz      outerLoop

;
; add diagonal terms
;
   pop      rcx
   pop      rsi
   pop      rdi
   call     finalize
   ret
sqr_8N_adcox ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general case N>16 squarer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN 16
sqr_N_adcox PROC PRIVATE
   push     rdi         ; save diagonal loop parameters
   push     rsi
   push     rdx

   push     rdi         ; save initial triangle product parameters
   push     rsi
   push     rdx

   mov      rbp, rdx
   and      rbp, 7
   GET_EP   rax, mla_8xl_tail, rbp  ; get tail procedure
   push     rax

;
; init upper triangle product
;
   sub      rdx, 8

   push     rdx
   call     sqr8_triangle
   pop      rdx

   mov      qword ptr[rdi+sizeof(qword)*7], r15
   add      rdi, sizeof(qword)*8
   xor      r15, r15

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
   sub      rdx, 8

initLoop:
   push     rdx
   call     mla_8x8
   pop      rdx
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   sub      rdx, 8
   jnc      initLoop

   add      rdx, 8
;
; tail
;
   SWAP     rsi, rcx
   mov      rax, [rsp]  ; procedure
   push     rdx
   call     rax
   pop      rdx
   lea      rdi, [rdi+rdx*sizeof(qword)]

   mov      qword ptr[rdi+sizeof(qword)*0], r8
   mov      qword ptr[rdi+sizeof(qword)*1], r9
   mov      qword ptr[rdi+sizeof(qword)*2],r10
   mov      qword ptr[rdi+sizeof(qword)*3],r11
   mov      qword ptr[rdi+sizeof(qword)*4],r12
   mov      qword ptr[rdi+sizeof(qword)*5],r13
   mov      qword ptr[rdi+sizeof(qword)*6],r14
   mov      qword ptr[rdi+sizeof(qword)*7],r15
   jmp      update_Triangle

;
; update upper triangle product
;
outerLoop:
   push     rdi      ; update triangle product parameters
   push     rsi
   push     rdx
   push     rax      ; tail procedure

   xor      rax, rax    ; c-flag
   push     rax

   mov      r8,  qword ptr[rdi+sizeof(qword)*0]
   mov      r9,  qword ptr[rdi+sizeof(qword)*1]
   mov      r10, qword ptr[rdi+sizeof(qword)*2]
   mov      r11, qword ptr[rdi+sizeof(qword)*3]
   mov      r12, qword ptr[rdi+sizeof(qword)*4]
   mov      r13, qword ptr[rdi+sizeof(qword)*5]
   mov      r14, qword ptr[rdi+sizeof(qword)*6]
   mov      r15, qword ptr[rdi+sizeof(qword)*7]

   sub      rdx, 8

   push     rdx
   call     sqr8_triangle
   pop      rdx

   mov      qword ptr[rdi+sizeof(qword)*7], r15
   add      rdi, sizeof(qword)*8
   xor      r15, r15

   mov      rcx, rsi
   add      rsi, sizeof(qword)*8
   sub      rdx, 8

innerLoop:
   pop      rax      ; restore c-flag
   neg      rax
   op_reg_mem  adc,  r8,  qword ptr[rdi+sizeof(qword)*0], rax
   op_reg_mem  adc,  r9,  qword ptr[rdi+sizeof(qword)*1], rax
   op_reg_mem  adc,  r10, qword ptr[rdi+sizeof(qword)*2], rax
   op_reg_mem  adc,  r11, qword ptr[rdi+sizeof(qword)*3], rax
   op_reg_mem  adc,  r12, qword ptr[rdi+sizeof(qword)*4], rax
   op_reg_mem  adc,  r13, qword ptr[rdi+sizeof(qword)*5], rax
   op_reg_mem  adc,  r14, qword ptr[rdi+sizeof(qword)*6], rax
   op_reg_mem  adc,  r15, qword ptr[rdi+sizeof(qword)*7], rax
   sbb      rax, rax ; save c-flag
   push     rax

   push     rdx
   call     mla_8x8
   pop      rdx

   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*8
   sub      rdx, 8
   jnc      innerLoop

   add      rdx, 8
;
; tail
;
   ; clear in advance
    pxor    xmm0, xmm0
    movdqu  xmmword ptr[rdi+rdx*sizeof(qword)], xmm0
    movdqu  xmmword ptr[rdi+rdx*sizeof(qword)+sizeof(qword)*2], xmm0
    movdqu  xmmword ptr[rdi+rdx*sizeof(qword)+sizeof(qword)*4], xmm0
    movdqu  xmmword ptr[rdi+rdx*sizeof(qword)+sizeof(qword)*6], xmm0

   ; updates registers before mla operation
   pop      rax      ; restore c-flag
   neg      rax
   op_reg_mem  adc,  r8,  qword ptr[rdi+sizeof(qword)*0], rax
   op_reg_mem  adc,  r9,  qword ptr[rdi+sizeof(qword)*1], rax
   op_reg_mem  adc,  r10, qword ptr[rdi+sizeof(qword)*2], rax
   op_reg_mem  adc,  r11, qword ptr[rdi+sizeof(qword)*3], rax
   op_reg_mem  adc,  r12, qword ptr[rdi+sizeof(qword)*4], rax
   op_reg_mem  adc,  r13, qword ptr[rdi+sizeof(qword)*5], rax
   op_reg_mem  adc,  r14, qword ptr[rdi+sizeof(qword)*6], rax
   op_reg_mem  adc,  r15, qword ptr[rdi+sizeof(qword)*7], rax

   ; store carry for future
   sbb      rax, rax
   neg      rax
   mov      qword ptr [rdi+sizeof(qword)*8], rax

   ; mla_8xn operation
   SWAP     rsi, rcx
   mov      rax, [rsp]  ; procedure
   push     rdx
   call     rax
   pop      rdx
   lea      rdi, [rdi+rdx*sizeof(qword)]

   ; updates registers before store
   xor      rax, rax
   mov      rax, qword ptr[rdi+sizeof(qword)*0]
   add      r8,  rax
   mov      qword ptr[rdi+sizeof(qword)*0], r8
   mov      rax, qword ptr[rdi+sizeof(qword)*1]
   adc      r9,  rax
   mov      qword ptr[rdi+sizeof(qword)*1], r9
   mov      rax, qword ptr[rdi+sizeof(qword)*2]
   adc      r10, rax
   mov      qword ptr[rdi+sizeof(qword)*2], r10
   mov      rax, qword ptr[rdi+sizeof(qword)*3]
   adc      r11, rax
   mov      qword ptr[rdi+sizeof(qword)*3], r11
   mov      rax, qword ptr[rdi+sizeof(qword)*4]
   adc      r12, rax
   mov      qword ptr[rdi+sizeof(qword)*4], r12
   mov      rax, qword ptr[rdi+sizeof(qword)*5]
   adc      r13, rax
   mov      qword ptr[rdi+sizeof(qword)*5], r13
   mov      rax, qword ptr[rdi+sizeof(qword)*6]
   adc      r14, rax
   mov      qword ptr[rdi+sizeof(qword)*6], r14
   mov      rax, qword ptr[rdi+sizeof(qword)*7]
   adc      r15, rax
   mov      qword ptr[rdi+sizeof(qword)*7], r15

update_Triangle:
   pop      rax                  ; tail procedure
   pop      rdx
   pop      rsi
   pop      rdi
   add      rsi, sizeof(qword)*8
   add      rdi, sizeof(qword)*(8*2)
   sub      rdx, 8
   cmp      rdx, 16
   jg       outerLoop

;
; tail
;
   mov      rbp, rdx
   sub      rbp, 8
   GET_EP   rax, sqrN_triangle, rbp    ; get triangle proc

   sub      rsp, sizeof(qword)*32
   push     rdi
   push     rdx

   mov      r8, qword ptr[rdi+sizeof(qword)*0]
   mov      r9, qword ptr[rdi+sizeof(qword)*1]
   mov      r10,qword ptr[rdi+sizeof(qword)*2]
   mov      r11,qword ptr[rdi+sizeof(qword)*3]
   mov      r12,qword ptr[rdi+sizeof(qword)*4]
   mov      r13,qword ptr[rdi+sizeof(qword)*5]
   mov      r14,qword ptr[rdi+sizeof(qword)*6]
   mov      r15,qword ptr[rdi+sizeof(qword)*7]

   lea      rdi, [rsp+sizeof(qword)*2]
   call     rax

   mov      rsi, rdi
   pop      rdx
   pop      rdi

   ; copy 8 terms
   movdqu  xmm0, xmmword ptr[rsi]
   movdqu  xmm1, xmmword ptr[rsi+sizeof(qword)*2]
   movdqu  xmm2, xmmword ptr[rsi+sizeof(qword)*4]
   movdqu  xmm3, xmmword ptr[rsi+sizeof(qword)*6]
   add      rsi, sizeof(qword)*8
   movdqu  xmmword ptr[rdi], xmm0
   movdqu  xmmword ptr[rdi+sizeof(qword)*2], xmm1
   movdqu  xmmword ptr[rdi+sizeof(qword)*4], xmm2
   movdqu  xmmword ptr[rdi+sizeof(qword)*6], xmm3
   add      rdi, sizeof(qword)*8

   ; update rdx-8 terms
   lea      rax, [rdx-8]
   xor      rbx, rbx
update1:
   mov      r8, qword ptr[rsi]
   mov      r9, qword ptr[rdi]
   add      rsi, sizeof(qword)
   neg      rbx
   adc      r8, r9
   sbb      rbx, rbx
   mov      qword ptr[rdi], r8
   add      rdi, sizeof(qword)
   sub      rax, 1
   jg       update1

   ; update rdx terms
update2:
   mov      r8, qword ptr[rsi]
   add      rsi, sizeof(qword)
   neg      rbx
   adc      r8, 0
   sbb      rbx, rbx
   mov      qword ptr[rdi], r8
   add      rdi, sizeof(qword)
   sub      rdx, 1
   jg       update2

   add      rsp, sizeof(qword)*32

;
; add diagonal terms
;
add_diagonals:
   pop      rcx
   pop      rsi
   pop      rdi
   call     finalize

quit:
   ret
sqr_N_adcox ENDP

ENDIF ;; _PCPBNUSQR_INC_
