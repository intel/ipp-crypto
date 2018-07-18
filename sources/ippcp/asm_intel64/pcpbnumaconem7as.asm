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
;               Big Number Operations
; 
;     Content:
;        cpMulDgt_BNU()
;        cpAddMulDgt_BNU()
;        cpSubMulDgt_BNU()
;        cpAddMulDgt_BNU()
; 
;

include asmdefs.inc
include ia_32e.inc
include ia_32e_regs.inc
include pcpbnumulschool.inc

IF _IPP32E GE _IPP32E_M7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;*************************************************************
; Ipp64u cpAddMulDgt_BNU(Ipp64u* pDst,
;                  const Ipp64u* pSrcA,
;                        int    len,
;                        Ipp64u B )
;*************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM cpAddMulDgt_BNU PROC PUBLIC FRAME
    USES_GPR rbx,rsi,rdi,r11,r12
    LOCAL_FRAME = 0
    USES_XMM
    COMP_ABI 4

; rdi = pDst
; rsi = pSrc
; rdx = len
; rcx = B

B0 equ   rcx   ; b

T0 equ   r8    ; temporary
T1 equ   r9
T2 equ   r10
T3 equ   r11

idx equ  rbx   ; index
rDst equ rdi
rSrc equ rsi

   mov   edx, edx       ; unsigned length

   mov   rax, qword ptr [rsi]
   cmp   rdx, 1
   jnz   general_case

   mul   rcx
   add   qword ptr [rdi], rax
   adc   rdx, 0
   mov   rax, rdx
   REST_XMM
   REST_GPR
   ret

general_case:
   lea   rSrc, [rSrc+rdx*sizeof(qword)-sizeof(qword)*5]
   lea   rDst, [rDst+rdx*sizeof(qword)-sizeof(qword)*5]
   mov   idx, 5
   sub   idx, rdx       ; negative counter -(len-5)

   mul   rcx            ; {T1:T0} = a[0]*B
   mov   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]
   mov   T1, rdx

   cmp   idx, 0
   jge   skip_muladd_loop4

ALIGN IPP_ALIGN_FACTOR
muladd_loop4:
   mul   rcx                     ; a[4*i+1]*B
   xor   T2, T2
   add   qword ptr [rDst+idx*sizeof(qword)], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T2, rdx

   mul   rcx                     ; a[4*i+2]*B
   xor   T3, T3
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc    T2, rax
   mov    rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc    T3, rdx

   mul   rcx                     ; a[4*i+3]*B
   xor   T0, T0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]
   adc   T0, rdx

   mul   rcx                     ; a[4*i+4]*B
   xor   T1, T1
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   adc   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*5]
   adc   T1, rdx

   add   idx, 4
   jnc   muladd_loop4

skip_muladd_loop4:
   mul   rcx
   xor   T2, T2
   add   qword ptr [rDst+idx*sizeof(qword)], T0
   adc   T1, rax
   adc   T2, rdx

   cmp   idx, 2
   ja    fin_mul1x4n_2   ; idx=3
   jz    fin_mul1x4n_3   ; idx=2
   jp    fin_mul1x4n_4   ; idx=1
   ;     fin_mul1x4n_1   ; idx=0

fin_mul1x4n_1:
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   mul   rcx
   xor   T3, T3
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T3, rdx

   mul   rcx
   xor   T0, T0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]
   adc   T0, rdx

   mul   rcx
   xor   T1, T1
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   adc   T0, rax
   adc   rdx, 0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*4], T0
   adc   rdx, 0
   mov   rax, rdx
   jmp   exit

fin_mul1x4n_4:
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   mul   rcx
   xor   T3, T3
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T3, rdx

   mul   rcx
   xor   T0, T0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   T3, rax
   adc   rdx, 0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   adc   rdx, 0
   mov   rax, rdx
   jmp   exit

fin_mul1x4n_3:
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   mul   rcx
   xor   T3, T3
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T2, rax
   adc   rdx, 0
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   rdx, 0
   mov   rax, rdx
   jmp   exit

fin_mul1x4n_2:
   add   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T2, 0
   mov   rax, T2

exit:
    REST_XMM
    REST_GPR
    ret
IPPASM cpAddMulDgt_BNU ENDP

ENDIF
END
