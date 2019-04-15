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
;        cpMontMul4n_avx2()
;        cpMontMul4n1_avx2()
;        cpMontMul4n2_avx2()
;        cpMontMul4n3_avx2()
;

include asmdefs.inc
include ia_32e.inc

IF (_IPP32E GE _IPP32E_L9)

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

DIGIT_BITS = 27
DIGIT_MASK = (1 SHL DIGIT_BITS) -1

;*************************************************************
;* void cpMontMul4n_avx2(Ipp64u* pR,
;*                 const Ipp64u* pA,
;*                 const Ipp64u* pB,
;*                 const Ipp64u* pModulo, int mSize,
;*                       Ipp64u m0,
;*                       Ipp64u* pBuffer)
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontMul4n_avx2 PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14
      LOCAL_FRAME = sizeof(qword)*5
      USES_XMM_AVX ymm6,ymm7,ymm8,ymm9,ymm10,ymm11,ymm12,ymm13
      COMP_ABI 7

      mov      rbp,rdx           ; pointer to B operand
      movsxd   r8, r8d           ; redLen value counter

;
; stack struct
;
pR       = 0                        ; pointer to result
pResult  = pR+sizeof(qword)         ; pointer to buffer
pA       = pResult+sizeof(qword)    ; pointer to A operand
pM       = pA+sizeof(qword)         ; pointer to modulus
redLen   = pM+sizeof(qword)         ; length

      mov      qword ptr[rsp+pR], rdi        ; save pointer to destination
      mov      qword ptr[rsp+pA], rsi        ;                 A operand
      mov      qword ptr[rsp+pM], rcx        ;                 modulus
      mov      qword ptr[rsp+redLen], r8     ;      modulus length

      mov      rdi, qword ptr[rsp+ARG_7]     ; buffer
      mov      [rsp+pResult], rdi

      vpxor    ymm0, ymm0, ymm0
      xor      rax, rax

;; expands A and M operands
      vmovdqu  ymmword ptr[rsi+r8*sizeof(qword)], ymm0
      vmovdqu  ymmword ptr[rcx+r8*sizeof(qword)], ymm0

;; clear result buffer of (redLen+4) qword length
      mov      r14, r8
ALIGN IPP_ALIGN_FACTOR
clearLoop:
      vmovdqu  ymmword ptr[rdi], ymm0
      add      rdi, sizeof(ymmword)
      sub      r14, sizeof(ymmword)/sizeof(qword)
      jg       clearLoop
      vmovdqu  ymmword ptr[rdi], ymm0

      lea      r14, [r8+sizeof(ymmword)/sizeof(qword)-1] ; a_counter = (redLen+3) & (-4)
      and      r14,-(sizeof(ymmword)/sizeof(qword))

ALIGN IPP_ALIGN_FACTOR
;;
;; process b[] by quadruples (b[j], b[j+1], b[j+2] and b[j+3]) per pass
;;
loop4_B:
      sub      r8, sizeof(ymmword)/sizeof(qword)
      jl       exit_loop4_B

      mov      rbx, qword ptr[rbp]                 ; rbx = b[j]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[j+1]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)*2] ; rbx = b[j+2]
      vpbroadcastq ymm6, qword ptr[rbp+sizeof(qword)*2]
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi]
      add      r12, rax
      mov      rdx, r12                            ; y2 = (ac2*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r13, rax
      vmovd    xmm10, edx
      vpbroadcastq ymm10, xmm10

      mov      rax, rdx                            ; ac2 += pn[0]*y2
      imul     rax, qword ptr[rcx]
      add      r12, rax
      shr      r12, DIGIT_BITS
      mov      rax, rdx                            ; ac3 += pn[1]*y2
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r13, rax
      add      r13, r12

      mov      rbx, qword ptr[rbp+sizeof(qword)*3] ; rbx = b[j+3]
      vpbroadcastq ymm7, qword ptr[rbp+sizeof(qword)*3]
      imul     rbx, qword ptr[rsi]                 ; ac3 += pa[0]*b[j+3]
      add      r13, rbx
      mov      rdx, r13                            ; y3 = (ac3*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      vmovd    xmm11, edx
      vpbroadcastq ymm11, xmm11

      imul     rdx, qword ptr[rcx]                 ; ac3 += pn[0]*y3
      add      r13, rdx
      shr      r13, DIGIT_BITS
      vmovq    xmm0, r13

      vpaddq   ymm0,  ymm0, ymmword ptr[rdi+sizeof(ymmword)]
      vmovdqu  ymmword ptr[rdi+sizeof(ymmword)], ymm0

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter

      ;; (vb0) ymm4 = {b0:b0:b0:b0}
      ;; (vb1) ymm5 = {b1:b1:b1:b1}
      ;; (vb2) ymm6 = {b2:b2:b2:b2}
      ;; (vb3) ymm7 = {b3:b3:b3:b3}

      ;; (vy0) ymm8 = {y0:y0:y0:y0}
      ;; (vy1) ymm9 = {y1:y1:y1:y1}
      ;; (vy2) ymm10= {y2:y2:y2:y2}
      ;; (vy3) ymm11= {y3:y3:y3:y3}

      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
loop16_A:
      sub      r11, 4*sizeof(ymmword)/sizeof(qword)
      jl       exit_loop16_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0
      vmovdqu  ymm1, ymmword ptr[rdi+sizeof(ymmword)]       ; r1
      vmovdqu  ymm2, ymmword ptr[rdi+sizeof(ymmword)*2]     ; r2
      vmovdqu  ymm3, ymmword ptr[rdi+sizeof(ymmword)*3]     ; r3

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                                     ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)]                     ; r1 += vb0 * (__m256i*)(pa)[j+1] + vy0 * (__m256i*)(pn)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*2]                   ; r2 += vb0 * (__m256i*)(pa)[j+2] + vy0 * (__m256i*)(pn)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*3]                   ; r3 += vb0 * (__m256i*)(pa)[j+3] + vy0 * (__m256i*)(pn)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]                       ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)]       ; r1 += vb1 * (__m256i*)(pa-1)[j+1] + vy1 * (__m256i*)(pn-1)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*2]     ; r2 += vb1 * (__m256i*)(pa-1)[j+2] + vy1 * (__m256i*)(pn-1)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*3]     ; r3 += vb1 * (__m256i*)(pa-1)[j+3] + vy1 * (__m256i*)(pn-1)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]                     ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)]     ; r1 += vb2 * (__m256i*)(pa-2)[j+1] + vy2 * (__m256i*)(pn-2)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*2]   ; r2 += vb2 * (__m256i*)(pa-2)[j+2] + vy2 * (__m256i*)(pn-2)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*3]   ; r3 += vb2 * (__m256i*)(pa-2)[j+3] + vy2 * (__m256i*)(pn-2)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3]                     ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)]     ; r1 += vb3 * (__m256i*)(pa-3)[j+1] + vy3 * (__m256i*)(pn-3)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*2]   ; r2 += vb3 * (__m256i*)(pa-3)[j+2] + vy3 * (__m256i*)(pn-3)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*3]   ; r3 += vb3 * (__m256i*)(pa-3)[j+3] + vy3 * (__m256i*)(pn-3)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)], ymm1
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*2], ymm2
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*3], ymm3

      add      rdi, sizeof(ymmword)*4
      add      rsi, sizeof(ymmword)*4
      add      rcx, sizeof(ymmword)*4
      jmp      loop16_A

exit_loop16_A:
      add      r11, 4*(sizeof(ymmword)/sizeof(qword))
      jz       exitA

loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exitA

      vmovdqu  ymm0, ymmword ptr[rdi]                          ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                   ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm5, ymmword ptr[rsi-sizeof(qword)]     ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm2

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]   ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm2

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      loop4_A

exitA:
      vpmuludq ymm1, ymm5, ymmword ptr[rsi-sizeof(qword)]   ; r1 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm1,  ymm1, ymm13

      vpmuludq ymm2, ymm6, ymmword ptr[rsi-sizeof(qword)*2] ; r2 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm2,  ymm2, ymm13

      vpmuludq ymm3, ymm7, ymmword ptr[rsi-sizeof(qword)*3] ; r3 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpaddq   ymm1,  ymm1, ymm2
      vpaddq   ymm1,  ymm1, ymm3
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm1

      jmp      loop4_B

exit_loop4_B:
      ;;
      ;; normalize
      ;;
      mov      rdi, qword ptr[rsp+pR]
      mov      rsi, qword ptr[rsp+pResult]
      mov      r8,  qword ptr[rsp+redLen]
      xor      rax, rax
norm_loop:
      add      rax, qword ptr[rsi]
      add      rsi, sizeof(qword)
      mov      rdx, DIGIT_MASK
      and      rdx, rax
      shr      rax, DIGIT_BITS
      mov      qword ptr[rdi], rdx
      add      rdi, sizeof(qword)
      sub      r8, 1
      jg       norm_loop
      mov      qword ptr[rdi], rax

   REST_XMM_AVX
   REST_GPR
   ret
IPPASM cpMontMul4n_avx2 ENDP

;*************************************************************
;* void cpMontMul4n1_avx2(Ipp64u* pR,
;*                  const Ipp64u* pA,
;*                  const Ipp64u* pB,
;*                  const Ipp64u* pModulo, int mSize,
;*                        Ipp64u m0,
;*                        Ipp64u* pBuffer)
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontMul4n1_avx2 PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14
      LOCAL_FRAME = sizeof(qword)*5
      USES_XMM_AVX ymm6,ymm7,ymm8,ymm9,ymm10,ymm11,ymm12,ymm13
      COMP_ABI 7

      mov      rbp,rdx     ; pointer to B operand
      movsxd   r8, r8d     ; redLen value counter

;
; stack struct
;
pR       = 0                        ; pointer to result
pResult  = pR+sizeof(qword)         ; pointer to buffer
pA       = pResult+sizeof(qword)    ; pointer to A operand
pM       = pA+sizeof(qword)         ; pointer to modulus
redLen   = pM+sizeof(qword)         ; length

      mov      qword ptr[rsp+pR], rdi        ; save pointer to destination
      mov      qword ptr[rsp+pA], rsi        ;                 A operand
      mov      qword ptr[rsp+pM], rcx        ;                 modulus
      mov      qword ptr[rsp+redLen], r8     ;      modulus length

      mov      rdi, qword ptr[rsp+ARG_7]     ; buffer
      mov      [rsp+pResult], rdi

      vpxor    ymm0, ymm0, ymm0
      xor      rax, rax

;; expands A and M operands
      vmovdqu  ymmword ptr[rsi+r8*sizeof(qword)], ymm0
      vmovdqu  ymmword ptr[rcx+r8*sizeof(qword)], ymm0

;; clear result buffer of (redLen+4) qword length
      mov      r14, r8
ALIGN IPP_ALIGN_FACTOR
clearLoop:
      vmovdqu  ymmword ptr[rdi], ymm0
      add      rdi, sizeof(ymmword)
      sub      r14, sizeof(ymmword)/sizeof(qword)
      jg       clearLoop
      mov       qword ptr[rdi], rax

      lea      r14, [r8+sizeof(ymmword)/sizeof(qword)-1] ; a_counter = (redLen+3) & (-4)
      and      r14,-(sizeof(ymmword)/sizeof(qword))

ALIGN IPP_ALIGN_FACTOR
;;
;; process b[] by quadruples (b[j], b[j+1], b[j+2] and b[j+3]) per pass
;;
loop4_B:
      sub      r8, sizeof(ymmword)/sizeof(qword)
      jl       exit_loop4_B

      mov      rbx, qword ptr[rbp]                 ; rbx = b[j]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[j+1]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)*2] ; rbx = b[j+2]
      vpbroadcastq ymm6, qword ptr[rbp+sizeof(qword)*2]
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi]
      add      r12, rax
      mov      rdx, r12                            ; y2 = (ac2*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r13, rax
      vmovd    xmm10, edx
      vpbroadcastq ymm10, xmm10

      mov      rax, rdx                            ; ac2 += pn[0]*y2
      imul     rax, qword ptr[rcx]
      add      r12, rax
      shr      r12, DIGIT_BITS
      mov      rax, rdx                            ; ac3 += pn[1]*y2
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r13, rax
      add      r13, r12

      mov      rbx, qword ptr[rbp+sizeof(qword)*3] ; rbx = b[j+3]
      vpbroadcastq ymm7, qword ptr[rbp+sizeof(qword)*3]
      imul     rbx, qword ptr[rsi]                 ; ac3 += pa[0]*b[j+3]
      add      r13, rbx
      mov      rdx, r13                            ; y3 = (ac3*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      vmovd    xmm11, edx
      vpbroadcastq ymm11, xmm11

      imul     rdx, qword ptr[rcx]                 ; ac3 += pn[0]*y3
      add      r13, rdx
      shr      r13, DIGIT_BITS
      vmovq    xmm0, r13

      vpaddq   ymm0,  ymm0, ymmword ptr[rdi+sizeof(ymmword)]
      vmovdqu  ymmword ptr[rdi+sizeof(ymmword)], ymm0

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter

      ;; (vb0) ymm4 = {b0:b0:b0:b0}
      ;; (vb1) ymm5 = {b1:b1:b1:b1}
      ;; (vb2) ymm6 = {b2:b2:b2:b2}
      ;; (vb3) ymm7 = {b3:b3:b3:b3}

      ;; (vy0) ymm8 = {y0:y0:y0:y0}
      ;; (vy1) ymm9 = {y1:y1:y1:y1}
      ;; (vy2) ymm10= {y2:y2:y2:y2}
      ;; (vy3) ymm11= {y3:y3:y3:y3}

      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
loop16_A:
      sub      r11, 4*sizeof(ymmword)/sizeof(qword)
      jl       exit_loop16_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0
      vmovdqu  ymm1, ymmword ptr[rdi+sizeof(ymmword)]       ; r1
      vmovdqu  ymm2, ymmword ptr[rdi+sizeof(ymmword)*2]     ; r2
      vmovdqu  ymm3, ymmword ptr[rdi+sizeof(ymmword)*3]     ; r3

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                                     ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)]                     ; r1 += vb0 * (__m256i*)(pa)[j+1] + vy0 * (__m256i*)(pn)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*2]                   ; r2 += vb0 * (__m256i*)(pa)[j+2] + vy0 * (__m256i*)(pn)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*3]                   ; r3 += vb0 * (__m256i*)(pa)[j+3] + vy0 * (__m256i*)(pn)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]                       ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)]       ; r1 += vb1 * (__m256i*)(pa-1)[j+1] + vy1 * (__m256i*)(pn-1)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*2]     ; r2 += vb1 * (__m256i*)(pa-1)[j+2] + vy1 * (__m256i*)(pn-1)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*3]     ; r3 += vb1 * (__m256i*)(pa-1)[j+3] + vy1 * (__m256i*)(pn-1)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]                     ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)]     ; r1 += vb2 * (__m256i*)(pa-2)[j+1] + vy2 * (__m256i*)(pn-2)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*2]   ; r2 += vb2 * (__m256i*)(pa-2)[j+2] + vy2 * (__m256i*)(pn-2)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*3]   ; r3 += vb2 * (__m256i*)(pa-2)[j+3] + vy2 * (__m256i*)(pn-2)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3]                     ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)]     ; r1 += vb3 * (__m256i*)(pa-3)[j+1] + vy3 * (__m256i*)(pn-3)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*2]   ; r2 += vb3 * (__m256i*)(pa-3)[j+2] + vy3 * (__m256i*)(pn-3)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*3]   ; r3 += vb3 * (__m256i*)(pa-3)[j+3] + vy3 * (__m256i*)(pn-3)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)], ymm1
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*2], ymm2
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*3], ymm3

      add      rdi, sizeof(ymmword)*4
      add      rsi, sizeof(ymmword)*4
      add      rcx, sizeof(ymmword)*4
      jmp      loop16_A

exit_loop16_A:
      add      r11, 4*(sizeof(ymmword)/sizeof(qword))
      jz       exitA

loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exitA

      vmovdqu  ymm0, ymmword ptr[rdi]                          ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                   ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm5, ymmword ptr[rsi-sizeof(qword)]     ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm2

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]   ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm2

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      loop4_A

exitA:
      jmp      loop4_B

;;
;; process latest b[redLen-1]
;;
exit_loop4_B:
      mov      rbx, qword ptr[rbp]                 ; rbx = b[redLen-1]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax

      mov      qword ptr[rdi], r11                 ; pr[0] = ac1
      mov      qword ptr[rdi+sizeof(qword)], r12   ; pr[1] = ac2
      mov      qword ptr[rdi+sizeof(qword)*2], r13 ; pr[2] = ac3

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter
      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
rem_loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exit_rem_loop4_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vmovdqu  ymmword ptr[rdi+3*sizeof(qword)-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      rem_loop4_A

exit_rem_loop4_A:

      ;;
      ;; normalize
      ;;
      mov      rdi, qword ptr[rsp+pR]
      mov      rsi, qword ptr[rsp+pResult]
      mov      r8,  qword ptr[rsp+redLen]
      xor      rax, rax
norm_loop:
      add      rax, qword ptr[rsi]
      add      rsi, sizeof(qword)
      mov      rdx, DIGIT_MASK
      and      rdx, rax
      shr      rax, DIGIT_BITS
      mov      qword ptr[rdi], rdx
      add      rdi, sizeof(qword)
      sub      r8, 1
      jg       norm_loop
      mov      qword ptr[rdi], rax

   REST_XMM_AVX
   REST_GPR
   ret
IPPASM cpMontMul4n1_avx2 ENDP

;*************************************************************
;* void cpMontMul4n2_avx2(Ipp64u* pR,
;*                  const Ipp64u* pA,
;*                  const Ipp64u* pB,
;*                  const Ipp64u* pModulo, int mSize,
;*                        Ipp64u m0,
;*                        Ipp64u* pBuffer)
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontMul4n2_avx2 PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14
      LOCAL_FRAME = sizeof(qword)*5
      USES_XMM_AVX ymm6,ymm7,ymm8,ymm9,ymm10,ymm11,ymm12,ymm13
      COMP_ABI 7

      mov      rbp,rdx     ; pointer to B operand
      movsxd   r8, r8d     ; redLen value counter

;
; stack struct
;
pR       = 0                        ; pointer to result
pResult  = pR+sizeof(qword)         ; pointer to buffer
pA       = pResult+sizeof(qword)    ; pointer to A operand
pM       = pA+sizeof(qword)         ; pointer to modulus
redLen   = pM+sizeof(qword)         ; length

      mov      qword ptr[rsp+pR], rdi        ; save pointer to destination
      mov      qword ptr[rsp+pA], rsi        ;                 A operand
      mov      qword ptr[rsp+pM], rcx        ;                 modulus
      mov      qword ptr[rsp+redLen], r8     ;      modulus length

      mov      rdi, qword ptr[rsp+ARG_7]     ; buffer
      mov      [rsp+pResult], rdi

      vpxor    ymm0, ymm0, ymm0
      xor      rax, rax

;; expands A and M operands
      vmovdqu  ymmword ptr[rsi+r8*sizeof(qword)], ymm0
      vmovdqu  ymmword ptr[rcx+r8*sizeof(qword)], ymm0

;; clear result buffer of (redLen+4) qword length
      mov      r14, r8
ALIGN IPP_ALIGN_FACTOR
clearLoop:
      vmovdqu  ymmword ptr[rdi], ymm0
      add      rdi, sizeof(ymmword)
      sub      r14, sizeof(ymmword)/sizeof(qword)
      jg       clearLoop
      vmovdqu  xmmword ptr[rdi], xmm0

      lea      r14, [r8+sizeof(ymmword)/sizeof(qword)-1] ; a_counter = (redLen+3) & (-4)
      and      r14,-(sizeof(ymmword)/sizeof(qword))

ALIGN IPP_ALIGN_FACTOR
;;
;; process b[] by quadruples (b[j], b[j+1], b[j+2] and b[j+3]) per pass
;;
loop4_B:
      sub      r8, sizeof(ymmword)/sizeof(qword)
      jl       exit_loop4_B

      mov      rbx, qword ptr[rbp]                 ; rbx = b[j]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[j+1]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)*2] ; rbx = b[j+2]
      vpbroadcastq ymm6, qword ptr[rbp+sizeof(qword)*2]
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi]
      add      r12, rax
      mov      rdx, r12                            ; y2 = (ac2*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r13, rax
      vmovd    xmm10, edx
      vpbroadcastq ymm10, xmm10

      mov      rax, rdx                            ; ac2 += pn[0]*y2
      imul     rax, qword ptr[rcx]
      add      r12, rax
      shr      r12, DIGIT_BITS
      mov      rax, rdx                            ; ac3 += pn[1]*y2
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r13, rax
      add      r13, r12

      mov      rbx, qword ptr[rbp+sizeof(qword)*3] ; rbx = b[j+3]
      vpbroadcastq ymm7, qword ptr[rbp+sizeof(qword)*3]
      imul     rbx, qword ptr[rsi]                 ; ac3 += pa[0]*b[j+3]
      add      r13, rbx
      mov      rdx, r13                            ; y3 = (ac3*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      vmovd    xmm11, edx
      vpbroadcastq ymm11, xmm11

      imul     rdx, qword ptr[rcx]                 ; ac3 += pn[0]*y3
      add      r13, rdx
      shr      r13, DIGIT_BITS
      vmovq    xmm0, r13

      vpaddq   ymm0,  ymm0, ymmword ptr[rdi+sizeof(ymmword)]
      vmovdqu  ymmword ptr[rdi+sizeof(ymmword)], ymm0

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter

      ;; (vb0) ymm4 = {b0:b0:b0:b0}
      ;; (vb1) ymm5 = {b1:b1:b1:b1}
      ;; (vb2) ymm6 = {b2:b2:b2:b2}
      ;; (vb3) ymm7 = {b3:b3:b3:b3}

      ;; (vy0) ymm8 = {y0:y0:y0:y0}
      ;; (vy1) ymm9 = {y1:y1:y1:y1}
      ;; (vy2) ymm10= {y2:y2:y2:y2}
      ;; (vy3) ymm11= {y3:y3:y3:y3}

      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
loop16_A:
      sub      r11, 4*sizeof(ymmword)/sizeof(qword)
      jl       exit_loop16_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0
      vmovdqu  ymm1, ymmword ptr[rdi+sizeof(ymmword)]       ; r1
      vmovdqu  ymm2, ymmword ptr[rdi+sizeof(ymmword)*2]     ; r2
      vmovdqu  ymm3, ymmword ptr[rdi+sizeof(ymmword)*3]     ; r3

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                                     ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)]                     ; r1 += vb0 * (__m256i*)(pa)[j+1] + vy0 * (__m256i*)(pn)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*2]                   ; r2 += vb0 * (__m256i*)(pa)[j+2] + vy0 * (__m256i*)(pn)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*3]                   ; r3 += vb0 * (__m256i*)(pa)[j+3] + vy0 * (__m256i*)(pn)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]                       ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)]       ; r1 += vb1 * (__m256i*)(pa-1)[j+1] + vy1 * (__m256i*)(pn-1)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*2]     ; r2 += vb1 * (__m256i*)(pa-1)[j+2] + vy1 * (__m256i*)(pn-1)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*3]     ; r3 += vb1 * (__m256i*)(pa-1)[j+3] + vy1 * (__m256i*)(pn-1)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]                     ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)]     ; r1 += vb2 * (__m256i*)(pa-2)[j+1] + vy2 * (__m256i*)(pn-2)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*2]   ; r2 += vb2 * (__m256i*)(pa-2)[j+2] + vy2 * (__m256i*)(pn-2)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*3]   ; r3 += vb2 * (__m256i*)(pa-2)[j+3] + vy2 * (__m256i*)(pn-2)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3]                     ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)]     ; r1 += vb3 * (__m256i*)(pa-3)[j+1] + vy3 * (__m256i*)(pn-3)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*2]   ; r2 += vb3 * (__m256i*)(pa-3)[j+2] + vy3 * (__m256i*)(pn-3)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*3]   ; r3 += vb3 * (__m256i*)(pa-3)[j+3] + vy3 * (__m256i*)(pn-3)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)], ymm1
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*2], ymm2
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*3], ymm3

      add      rdi, sizeof(ymmword)*4
      add      rsi, sizeof(ymmword)*4
      add      rcx, sizeof(ymmword)*4
      jmp      loop16_A

exit_loop16_A:
      add      r11, 4*(sizeof(ymmword)/sizeof(qword))
      jz       exitA

loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exitA

      vmovdqu  ymm0, ymmword ptr[rdi]                          ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                   ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm5, ymmword ptr[rsi-sizeof(qword)]     ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm2

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]   ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm2

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      loop4_A

exitA:
      vpmuludq ymm0,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpmuludq ymm1,  ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm1
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0

      jmp      loop4_B

;;
;; process latest b[redLen-2] and b[redLen-1]
;;
exit_loop4_B:
      mov      rbx, qword ptr[rbp]                 ; rbx = b[redLen-2]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[j+1]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax

      mov      qword ptr[rdi], r12                 ; pr[0] = ac2
      mov      qword ptr[rdi+sizeof(qword)], r13   ; pr[1] = ac3

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter
      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
rem_loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exit_rem_loop4_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]  ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13

      vmovdqu  ymmword ptr[rdi+sizeof(qword)*2-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      rem_loop4_A

exit_rem_loop4_A:

      ;;
      ;; normalize
      ;;
      mov      rdi, qword ptr[rsp+pR]
      mov      rsi, qword ptr[rsp+pResult]
      mov      r8,  qword ptr[rsp+redLen]
      xor      rax, rax
norm_loop:
      add      rax, qword ptr[rsi]
      add      rsi, sizeof(qword)
      mov      rdx, DIGIT_MASK
      and      rdx, rax
      shr      rax, DIGIT_BITS
      mov      qword ptr[rdi], rdx
      add      rdi, sizeof(qword)
      sub      r8, 1
      jg       norm_loop
      mov      qword ptr[rdi], rax

   REST_XMM_AVX
   REST_GPR
   ret
IPPASM cpMontMul4n2_avx2 ENDP

;*************************************************************
;* void cpMontMul4n3_avx2(Ipp64u* pR,
;*                  const Ipp64u* pA,
;*                  const Ipp64u* pB,
;*                  const Ipp64u* pModulo, int mSize,
;*                        Ipp64u m0,
;*                        Ipp64u* pBuffer)
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpMontMul4n3_avx2 PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx,rbp,r12,r13,r14
      LOCAL_FRAME = sizeof(qword)*5
      USES_XMM_AVX ymm6,ymm7,ymm8,ymm9,ymm10,ymm11,ymm12,ymm13
      COMP_ABI 7

      mov      rbp,rdx     ; pointer to B operand
      movsxd   r8, r8d     ; redLen value counter

;
; stack struct
;
pR       = 0                        ; pointer to result
pResult  = pR+sizeof(qword)         ; pointer to buffer
pA       = pResult+sizeof(qword)    ; pointer to A operand
pM       = pA+sizeof(qword)         ; pointer to modulus
redLen   = pM+sizeof(qword)         ; length

      mov      qword ptr[rsp+pR], rdi        ; save pointer to destination
      mov      qword ptr[rsp+pA], rsi        ;                 A operand
      mov      qword ptr[rsp+pM], rcx        ;                 modulus
      mov      qword ptr[rsp+redLen], r8     ;      modulus length

      mov      rdi, qword ptr[rsp+ARG_7]     ; buffer
      mov      [rsp+pResult], rdi

      vpxor    ymm0, ymm0, ymm0
      xor      rax, rax

;; expands A and M operands
      vmovdqu  ymmword ptr[rsi+r8*sizeof(qword)], ymm0
      vmovdqu  ymmword ptr[rcx+r8*sizeof(qword)], ymm0

;; clear result buffer of (redLen+4) qword length
      mov      r14, r8
ALIGN IPP_ALIGN_FACTOR
clearLoop:
      vmovdqu  ymmword ptr[rdi], ymm0
      add      rdi, sizeof(ymmword)
      sub      r14, sizeof(ymmword)/sizeof(qword)
      jg       clearLoop
      vmovdqu  xmmword ptr[rdi], xmm0
      mov      qword ptr[rdi+sizeof(xmmword)], rax

      lea      r14, [r8+sizeof(ymmword)/sizeof(qword)-1] ; a_counter = (redLen+3) & (-4)
      and      r14,-(sizeof(ymmword)/sizeof(qword))

ALIGN IPP_ALIGN_FACTOR
;;
;; process b[] by quadruples (b[j], b[j+1], b[j+2] and b[j+3]) per pass
;;
loop4_B:
      sub      r8, sizeof(ymmword)/sizeof(qword)
      jl       exit_loop4_B

      mov      rbx, qword ptr[rbp]                 ; rbx = b[j]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[j+1]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)*2] ; rbx = b[j+2]
      vpbroadcastq ymm6, qword ptr[rbp+sizeof(qword)*2]
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi]
      add      r12, rax
      mov      rdx, r12                            ; y2 = (ac2*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r13, rax
      vmovd    xmm10, edx
      vpbroadcastq ymm10, xmm10

      mov      rax, rdx                            ; ac2 += pn[0]*y2
      imul     rax, qword ptr[rcx]
      add      r12, rax
      shr      r12, DIGIT_BITS
      mov      rax, rdx                            ; ac3 += pn[1]*y2
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r13, rax
      add      r13, r12

      mov      rbx, qword ptr[rbp+sizeof(qword)*3] ; rbx = b[j+3]
      vpbroadcastq ymm7, qword ptr[rbp+sizeof(qword)*3]
      imul     rbx, qword ptr[rsi]                 ; ac3 += pa[0]*b[j+3]
      add      r13, rbx
      mov      rdx, r13                            ; y3 = (ac3*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      vmovd    xmm11, edx
      vpbroadcastq ymm11, xmm11

      imul     rdx, qword ptr[rcx]                 ; ac3 += pn[0]*y3
      add      r13, rdx
      shr      r13, DIGIT_BITS
      vmovq    xmm0, r13

      vpaddq   ymm0,  ymm0, ymmword ptr[rdi+sizeof(ymmword)]
      vmovdqu  ymmword ptr[rdi+sizeof(ymmword)], ymm0

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter

      ;; (vb0) ymm4 = {b0:b0:b0:b0}
      ;; (vb1) ymm5 = {b1:b1:b1:b1}
      ;; (vb2) ymm6 = {b2:b2:b2:b2}
      ;; (vb3) ymm7 = {b3:b3:b3:b3}

      ;; (vy0) ymm8 = {y0:y0:y0:y0}
      ;; (vy1) ymm9 = {y1:y1:y1:y1}
      ;; (vy2) ymm10= {y2:y2:y2:y2}
      ;; (vy3) ymm11= {y3:y3:y3:y3}

      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
loop16_A:
      sub      r11, 4*sizeof(ymmword)/sizeof(qword)
      jl       exit_loop16_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0
      vmovdqu  ymm1, ymmword ptr[rdi+sizeof(ymmword)]       ; r1
      vmovdqu  ymm2, ymmword ptr[rdi+sizeof(ymmword)*2]     ; r2
      vmovdqu  ymm3, ymmword ptr[rdi+sizeof(ymmword)*3]     ; r3

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                                     ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)]                     ; r1 += vb0 * (__m256i*)(pa)[j+1] + vy0 * (__m256i*)(pn)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*2]                   ; r2 += vb0 * (__m256i*)(pa)[j+2] + vy0 * (__m256i*)(pn)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm4, ymmword ptr[rsi+sizeof(ymmword)*3]                   ; r3 += vb0 * (__m256i*)(pa)[j+3] + vy0 * (__m256i*)(pn)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]                       ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)]       ; r1 += vb1 * (__m256i*)(pa-1)[j+1] + vy1 * (__m256i*)(pn-1)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*2]     ; r2 += vb1 * (__m256i*)(pa-1)[j+2] + vy1 * (__m256i*)(pn-1)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)+sizeof(ymmword)*3]     ; r3 += vb1 * (__m256i*)(pa-1)[j+3] + vy1 * (__m256i*)(pn-1)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]                     ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)]     ; r1 += vb2 * (__m256i*)(pa-2)[j+1] + vy2 * (__m256i*)(pn-2)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*2]   ; r2 += vb2 * (__m256i*)(pa-2)[j+2] + vy2 * (__m256i*)(pn-2)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2+sizeof(ymmword)*3]   ; r3 += vb2 * (__m256i*)(pa-2)[j+3] + vy2 * (__m256i*)(pn-2)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3]                     ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)]     ; r1 += vb3 * (__m256i*)(pa-3)[j+1] + vy3 * (__m256i*)(pn-3)[j+1]
      vpaddq   ymm1,  ymm1, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)]
      vpaddq   ymm1,  ymm1, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*2]   ; r2 += vb3 * (__m256i*)(pa-3)[j+2] + vy3 * (__m256i*)(pn-3)[j+2]
      vpaddq   ymm2,  ymm2, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*2]
      vpaddq   ymm2,  ymm2, ymm13
      vpmuludq ymm12, ymm7, ymmword ptr[rsi-sizeof(qword)*3+sizeof(ymmword)*3]   ; r3 += vb3 * (__m256i*)(pa-3)[j+3] + vy3 * (__m256i*)(pn-3)[j+3]
      vpaddq   ymm3,  ymm3, ymm12
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3+sizeof(ymmword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)], ymm1
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*2], ymm2
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)+sizeof(ymmword)*3], ymm3

      add      rdi, sizeof(ymmword)*4
      add      rsi, sizeof(ymmword)*4
      add      rcx, sizeof(ymmword)*4
      jmp      loop16_A

exit_loop16_A:
      add      r11, 4*(sizeof(ymmword)/sizeof(qword))
      jz       exitA

loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exitA

      vmovdqu  ymm0, ymmword ptr[rdi]                          ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                   ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm5, ymmword ptr[rsi-sizeof(qword)]     ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm2

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]   ; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm1,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r0 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpaddq   ymm0,  ymm0, ymm1
      vpmuludq ymm2,  ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm0,  ymm0, ymm2

      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      loop4_A

exitA:
      vpmuludq ymm2,  ymm6, ymmword ptr[rsi-sizeof(qword)*2]   ; r2 += vb3 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpmuludq ymm12, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm2,  ymm2, ymm12

      vpmuludq ymm3,  ymm7, ymmword ptr[rsi-sizeof(qword)*3]   ; r3 += vb3 * (__m256i*)(pa-3)[j] + vy3 * (__m256i*)(pn-3)[j]
      vpmuludq ymm13, ymm11,ymmword ptr[rcx-sizeof(qword)*3]
      vpaddq   ymm3,  ymm3, ymm13

      vpaddq   ymm2,  ymm2, ymm3
      vmovdqu  ymmword ptr[rdi-sizeof(ymmword)], ymm2

      jmp      loop4_B

;;
;; process latest b[redLen-3], b[redLen-2] and b[redLen-1]
;;
exit_loop4_B:
      mov      rbx, qword ptr[rbp]                 ; rbx = b[redLen-3]
      vpbroadcastq ymm4, qword ptr[rbp]

      mov      rdi, qword ptr[rsp+pResult]         ; restore pointer to destination
      mov      rsi, qword ptr[rsp+pA]              ;                    A operand
      mov      rcx, qword ptr[rsp+pM]              ;                    modulus

      mov      r10, qword ptr[rdi]
      mov      r11, qword ptr[rdi+sizeof(qword)]
      mov      r12, qword ptr[rdi+sizeof(qword)*2]
      mov      r13, qword ptr[rdi+sizeof(qword)*3]

      mov      rax, rbx                            ; ac0 = pa[0]*b[j]+pr[0]
      imul     rax, qword ptr[rsi]
      add      r10, rax
      mov      rdx, r10                            ; y0 = (ac0*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac1 = pa[1]*b[j]+pr[1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r11, rax
      mov      rax, rbx                            ; ac2 = pa[2]*b[j]+pr[2]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rbx                            ; ac3 = pa[3]*b[j]+pr[3]
      imul     rax, qword ptr[rsi+sizeof(qword)*3]
      add      r13, rax
      vmovd    xmm8, edx
      vpbroadcastq ymm8, xmm8

      mov      rax, rdx                            ; ac0 += pn[0]*y0
      imul     rax, qword ptr[rcx]
      add      r10, rax
      shr      r10, DIGIT_BITS
      mov      rax, rdx                            ; ac1 += pn[1]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r11, rax
      add      r11, r10
      mov      rax, rdx                            ; ac2 += pn[2]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r12, rax
      mov      rax, rdx                            ; ac3 += pn[3]*y0
      imul     rax, qword ptr[rcx+sizeof(qword)*3]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)]   ; rbx = b[redLen-2]
      vpbroadcastq ymm5, qword ptr[rbp+sizeof(qword)]
      mov      rax, rbx                            ; ac1 += pa[0]*b[j+1]
      imul     rax, qword ptr[rsi]
      add      r11, rax
      mov      rdx, r11                            ; y1 = (ac1*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[1]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r12, rax
      mov      rax, rbx                            ; ac3 += pa[2]*b[j+1]
      imul     rax, qword ptr[rsi+sizeof(qword)*2]
      add      r13, rax
      vmovd    xmm9, edx
      vpbroadcastq ymm9, xmm9

      mov      rax, rdx                            ; ac1 += pn[0]*y1
      imul     rax, qword ptr[rcx]
      add      r11, rax
      shr      r11, DIGIT_BITS
      mov      rax, rdx                            ; ac2 += pn[1]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r12, rax
      add      r12, r11
      mov      rax, rdx                            ; ac3 += pn[2]*y1
      imul     rax, qword ptr[rcx+sizeof(qword)*2]
      add      r13, rax


      mov      rbx, qword ptr[rbp+sizeof(qword)*2] ; rbx = b[redLen-1]
      vpbroadcastq ymm6, qword ptr[rbp+sizeof(qword)*2]
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi]
      add      r12, rax
      mov      rdx, r12                            ; y2 = (ac2*m0) & DIGIT_MASK
      imul     edx, r9d
      and      edx, DIGIT_MASK
      mov      rax, rbx                            ; ac2 += pa[0]*b[j+2]
      imul     rax, qword ptr[rsi+sizeof(qword)]
      add      r13, rax
      vmovd    xmm10, edx
      vpbroadcastq ymm10, xmm10

      mov      rax, rdx                            ; ac2 += pn[0]*y2
      imul     rax, qword ptr[rcx]
      add      r12, rax
      shr      r12, DIGIT_BITS
      mov      rax, rdx                            ; ac3 += pn[1]*y2
      imul     rax, qword ptr[rcx+sizeof(qword)]
      add      r13, rax
      add      r13, r12

      mov      qword ptr[rdi], r13                 ; pr[0] = ac3

      add      rbp, sizeof(qword)*4
      add      rsi, sizeof(qword)*4
      add      rcx, sizeof(qword)*4
      add      rdi, sizeof(ymmword)

      mov      r11, r14                            ; init a_counter
      sub      r11, sizeof(ymmword)/sizeof(qword)

ALIGN IPP_ALIGN_FACTOR
rem_loop4_A:
      sub      r11, sizeof(ymmword)/sizeof(qword)
      jl       exit_rem_loop4_A

      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0

      vpmuludq ymm12, ymm4, ymmword ptr[rsi]                ; r0 += vb0 * (__m256i*)(pa)[j] + vy0 * (__m256i*)(pn)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm8, ymmword ptr[rcx]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm12, ymm5, ymmword ptr[rsi-sizeof(qword)]  ; r0 += vb1 * (__m256i*)(pa-1)[j] + vy1 * (__m256i*)(pn-1)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm9, ymmword ptr[rcx-sizeof(qword)]
      vpaddq   ymm0,  ymm0, ymm13

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vmovdqu  ymmword ptr[rdi+sizeof(qword)-sizeof(ymmword)], ymm0

      add      rdi, sizeof(ymmword)
      add      rsi, sizeof(ymmword)
      add      rcx, sizeof(ymmword)
      jmp      rem_loop4_A

exit_rem_loop4_A:
      vmovdqu  ymm0, ymmword ptr[rdi]                       ; r0

      vpmuludq ymm12, ymm6, ymmword ptr[rsi-sizeof(qword)*2]; r0 += vb2 * (__m256i*)(pa-2)[j] + vy2 * (__m256i*)(pn-2)[j]
      vpaddq   ymm0,  ymm0, ymm12
      vpmuludq ymm13, ymm10,ymmword ptr[rcx-sizeof(qword)*2]
      vpaddq   ymm0,  ymm0, ymm13

      vmovdqu  ymmword ptr[rdi+sizeof(qword)-sizeof(ymmword)], ymm0

      ;;
      ;; normalize
      ;;
      mov      rdi, qword ptr[rsp+pR]
      mov      rsi, qword ptr[rsp+pResult]
      mov      r8,  qword ptr[rsp+redLen]
      xor      rax, rax
norm_loop:
      add      rax, qword ptr[rsi]
      add      rsi, sizeof(qword)
      mov      rdx, DIGIT_MASK
      and      rdx, rax
      shr      rax, DIGIT_BITS
      mov      qword ptr[rdi], rdx
      add      rdi, sizeof(qword)
      sub      r8, 1
      jg       norm_loop
      mov      qword ptr[rdi], rax

   REST_XMM_AVX
   REST_GPR
   ret
IPPASM cpMontMul4n3_avx2 ENDP

ENDIF       ;  _IPP32E_L9
END
