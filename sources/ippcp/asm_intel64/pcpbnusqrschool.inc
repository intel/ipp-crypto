;===============================================================================
; Copyright 2010-2018 Intel Corporation
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
;               BNU squaring support
; 
; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MULx1 genaral-case squarer macros
;;

;; dst = src * B epilogue (srcLen=4*n+3)
sMULx1_4N_3_ELOG   MACRO rDst, rSrc, update_idx, B, T0,T1,T2,T3
   mul   B
   xor   T1, T1
   add   T0, rax
   mov   qword ptr [rDst+sizeof(qword)], T0
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   adc   T1, rdx

   mul   B
   xor   T2, T2
   add   T1, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T1
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T2, rdx

   mul   B
   update_idx
   add   T2, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T2
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM

;; dst = src * B epilogue (srcLen=4*n+1)
sMULx1_4N_1_ELOG   MACRO rDst, rSrc, update_idx, B, T0,T1,T2,T3
   mul   B
   update_idx
   add   T0, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T0
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MULx2 genaral-case multiplier macros
;;

;; dst = src * {B1:B0} epilogue (srcLen=4*n+1)
sMULx2_4N_1_ELOG   MACRO rDst, rSrc, update_idx, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-1]*B1
  ;add   rDst, sizeof(qword)*2
   update_idx
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   add   T1, rax
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T2

   mov   qword ptr [rDst+sizeof(qword)*4], T1
   mov   qword ptr [rDst+sizeof(qword)*5], rdx
ENDM

;; dst = src * {B1:B0} epilogue (srcLen=4*n+3)
sMULx2_4N_3_ELOG   MACRO rDst, rSrc, update_idx, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-3]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[LenA-2]*B0
   mov   qword ptr [rDst+sizeof(qword)], T0
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]
   adc   T2, rdx
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-2]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[lenA-1]*B0
   mov   qword ptr [rDst+sizeof(qword)*2], T1
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T3, rdx
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[lenA-1]*B1
  ;add   rDst, sizeof(qword)*2
   update_idx
   mov   qword ptr [rDst+sizeof(qword)*3], T2
   add   T3, rax
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T0

   mov   qword ptr [rDst+sizeof(qword)*4], T3
   mov   qword ptr [rDst+sizeof(qword)*5], rdx
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MLAx2 genaral-case multiplier macros
;;

;;
;; B0 = rSrc[-2]
;; B1 = rSrc[-1]
;; inp_vector = rSrc
;; out_vector = rDst
sMLAx2_PLOG  MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mov      B0, qword ptr [rSrc-2*sizeof(qword)]   ; preload a[-2]
   mov      B1, qword ptr [rSrc-sizeof(qword)]     ; and a[i-1]

   mov      rax, B1
   mul      B0                                     ; a[-2]*a[i-1]
   xor      T0, T0

   add      qword ptr [rDst-sizeof(qword)], rax
   mov      rax, qword ptr [rSrc]                  ; a[i]
   adc      T0, rdx

   mul      B0                                     ; B0*a[i]
   xor      T1, T1
   xor      T2, T2
   add      T0, rax
   mov      rax, qword ptr [rSrc]                  ; a[i]
   adc      T1, rdx
ENDM


;; dst = + src * {B1:B0} epilogue (srcLen=4*n+1)
sMLAx2_4N_1_ELOG   MACRO rDst, rSrc, update_idx, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-1]*B1 + r[lenA-1]
  ;add   rDst, sizeof(qword)*2
   update_idx
   add   T0, qword ptr [rDst+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   adc   T1, rax
   adc   rdx, T2
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4], T1
   mov   qword ptr [rDst+sizeof(qword)*5], rdx
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+3)
sMLAx2_4N_3_ELOG   MACRO rDst, rSrc, update_idx, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-3]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[LenA-2]*B0 + r[len-3]
   add   T0, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T0
   adc   T1, rax
   adc   T2, rdx
   adc   T3, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]

   mul   B1                                                       ; {T3:T2} += a[lenA-2]*B1
   xor   T0, T0
   add   T2, rax
   adc   T3, rdx
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]

   mul   B0                                                       ; {T0:T3:T2} += a[lenA-1]*B0 + r[lenA-2]
   add   T1, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T1
   adc   T2, rax
   adc   T3, rdx
   adc   T0, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]

   mul   B1                                                       ; {T0:T3} += a[lenA-1]*B1 + r[lenA-1]
  ;add   rDst, sizeof(qword)*2
   update_idx
   add   T2, qword ptr [rDst+sizeof(qword)*3]
   mov   qword ptr [rDst+sizeof(qword)*3], T2
   adc   T3, rax
   adc   rdx, T0
  ;mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4], T3
   mov   qword ptr [rDst+sizeof(qword)*5], rdx
ENDM
