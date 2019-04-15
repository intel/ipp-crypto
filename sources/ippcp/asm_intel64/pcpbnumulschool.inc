;===============================================================================
; Copyright 2010-2019 Intel Corporation
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
;               BNU multiplication support
; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; fixed multiplier macros
;;

;;
;; {x0,x7,x6,x5,x4,x3,x2,x1},DCT[0] = OP*SRC2[] + {x7,x6,x5,x4,x3,x2,x1,x0}
;;
;; uses rax, rdx
;;      OP=SRC1[i] should to be preloaded
;;      TMP is destoyed
;;
MLA_FIX  MACRO    N, pDst, SRC2, OP, TMP, X7, X6, X5, X4, X3, X2, X1, X0
   mov   rax, [SRC2+8*0]
   mul   OP                ; rdx:rax = OP * []
   add   X0, rax
   adc   rdx, 0
   mov   pDst, X0
   mov   TMP, rdx

   IF N GT 1
   mov   rax, [SRC2+8*1]
   mul   OP                ; rdx:rax = OP * []
   add   X1, rax
   adc   rdx, 0
   add   X1, TMP
   adc   rdx, 0
   IF N EQ 2
   mov   X2, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 2
   mov   rax, [SRC2+8*2]
   mul   OP                ; rdx:rax = OP * []
   add   X2, rax
   adc   rdx, 0
   add   X2, TMP
   adc   rdx, 0
   IF N EQ 3
   mov   X3, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 3
   mov   rax, [SRC2+8*3]
   mul   OP                ; rdx:rax = OP * []
   add   X3, rax
   adc   rdx, 0
   add   X3, TMP
   adc   rdx, 0
   IF N EQ 4
   mov   X4, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 4
   mov   rax, [SRC2+8*4]
   mul   OP                ; rdx:rax = OP * []
   add   X4, rax
   adc   rdx, 0
   add   X4, TMP
   adc   rdx, 0
   IF N EQ 5
   mov   X5, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 5
   mov   rax, [SRC2+8*5]
   mul   OP                ; rdx:rax = OP * []
   add   X5, rax
   adc   rdx, 0
   add   X5, TMP
   adc   rdx, 0
   IF N EQ 6
   mov   X6, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 6
   mov   rax, [SRC2+8*6]
   mul   OP                ; rdx:rax = OP * []
   add   X6, rax
   adc   rdx, 0
   add   X6, TMP
   adc   rdx, 0
   IF N EQ 7
   mov   X7, rdx
   ELSE
   mov   TMP, rdx
   ENDIF

   IF N GT 7
   mov   rax, [SRC2+8*7]
   mul   OP                ; rdx:rax = OP * []
   add   X7, rax
   adc   rdx, 0
   add   X7, TMP
   adc   rdx, 0
   mov   X0, rdx
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
ENDM

;;; Inputs: pDst: Destination  (1024 bits, 16 qwords)
;;;         pA:   Multiplicand (512 bits, 8 qwords)
;;;         pB:   Multiplicand (512 bits, 8 qwords)
;;;
;;;
;;; Uses registers rax, rdx, args and rbp, rbx
;;;   B operand in [pB] and also in x7...x0
MUL_NxN    MACRO    N, pDst, pA, pB, OP, TMP, X7, X6, X5, X4, X3, X2, X1, X0
   mov   OP, [pA+8*0]

   mov   rax, X0
   mul   OP             ; rdx:rax = OP * []
   mov   [pDst+8*0], rax
   mov   X0, rdx

   IF N GT 1
   mov   rax, X1
   mul   OP             ; rdx:rax = OP * []
   add   X0, rax
   adc   rdx, 0
   mov   X1, rdx

   IF N GT 2
   mov   rax, X2
   mul   OP             ; rdx:rax = OP * []
   add   X1, rax
   adc   rdx, 0
   mov   X2, rdx

   IF N GT 3
   mov   rax, X3
   mul   OP             ; rdx:rax = OP * []
   add   X2, rax
   adc   rdx, 0
   mov   X3, rdx

   IF N GT 4
   mov   rax, X4
   mul   OP             ; rdx:rax = OP * []
   add   X3, rax
   adc   rdx, 0
   mov   X4, rdx

   IF N GT 5
   mov   rax, X5
   mul   OP             ; rdx:rax = OP * []
   add   X4, rax
   adc   rdx, 0
   mov   X5, rdx

   IF N GT 6
   mov   rax, X6
   mul   OP             ; rdx:rax = OP * []
   add   X5, rax
   adc   rdx, 0
   mov   X6, rdx

   IF N GT 7
   mov   rax, X7
   mul   OP             ; rdx:rax = OP * []
   add   X6, rax
   adc   rdx, 0
   mov   X7, rdx
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF

   IF N GT 1
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X0,X7,X6,X5,X4,X3,X2,X1},pDst[1] = pA[1]*pB[] + {X7,X6,X5,X4,X3,X2,X1,X0}
   mov      OP, [pA+sizeof(qword)*1]
   MLA_FIX  N, [pDst+sizeof(qword)*1], pB, OP, TMP, X7, X6, X5, X4, X3, X2, X1, X0

   IF N GT 2
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X1,X0,X7,X6,X5,X4,X3,X2},pDst[2] = pA[2]*pB[] + {X0,X7,X6,X5,X4,X3,X2,X1}
   mov      OP, [pA+sizeof(qword)*2]
   MLA_FIX  N, [pDst+sizeof(qword)*2], pB, OP, TMP, X0, X7, X6, X5, X4, X3, X2, X1

   IF N GT 3
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X2,X1,X0,X7,X6,X5,X4,X3},pDst[3] = pA[3]*pB[] + {X1,X0,X7,X6,X5,X4,X3,X2}
   mov      OP, [pA+sizeof(qword)*3]
   MLA_FIX  N, [pDst+sizeof(qword)*3], pB, OP, TMP, X1, X0, X7, X6, X5, X4, X3, X2

   IF N GT 4
   ; {X3,X2,X1,X0,X7,X6,X5,X4},pDst[4] = pA[4]*pB[] + {X2,X1,X0,X7,X6,X5,X4,X3}
   mov      OP, [pA+sizeof(qword)*4]
   MLA_FIX  N, [pDst+sizeof(qword)*4], pB, OP, TMP, X2, X1, X0, X7, X6, X5, X4, X3

   IF N GT 5
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X4,X3,X2,X1,X0,X7,X6,X5},pDst[5] = pA[5]*pB[] + {X3,X2,X1,X0,X7,X6,X5,X4}
   mov      OP, [pA+sizeof(qword)*5]
   MLA_FIX  N, [pDst+sizeof(qword)*5], pB, OP, TMP, X3, X2, X1, X0, X7, X6, X5, X4

   IF N GT 6
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X5,X4,X3,X2,X1,X0,X7,X6},pDst[6] = pA[6]*pB[] + {X4,X3,X2,X1,X0,X7,X6,X5}
   mov      OP, [pA+sizeof(qword)*6]
   MLA_FIX  N, [pDst+sizeof(qword)*6], pB, OP, TMP, X4, X3, X2, X1, X0, X7, X6, X5

   IF N GT 7
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ; {X6,X5,X4,X3,X2,X1,X0,X7},pDst[7] = pA[7]*pB[] + {X5,X4,X3,X2,X1,X0,X7,X6}
   mov      OP, [pA+sizeof(qword)*7]
   MLA_FIX  N, [pDst+sizeof(qword)*7], pB, OP, TMP, X5, X4, X3, X2, X1, X0, X7, X6

   mov   qword ptr [pDst+sizeof(qword)*8],  X7
   mov   qword ptr [pDst+sizeof(qword)*9],  X0
   mov   qword ptr [pDst+sizeof(qword)*10], X1
   mov   qword ptr [pDst+sizeof(qword)*11], X2
   mov   qword ptr [pDst+sizeof(qword)*12], X3
   mov   qword ptr [pDst+sizeof(qword)*13], X4
   mov   qword ptr [pDst+sizeof(qword)*14], X5
   mov   qword ptr [pDst+sizeof(qword)*15], X6
   EXITM
   ENDIF ;; N==8

   mov   qword ptr [pDst+sizeof(qword)*7],  X6
   mov   qword ptr [pDst+sizeof(qword)*8],  X7
   mov   qword ptr [pDst+sizeof(qword)*9],  X0
   mov   qword ptr [pDst+sizeof(qword)*10], X1
   mov   qword ptr [pDst+sizeof(qword)*11], X2
   mov   qword ptr [pDst+sizeof(qword)*12], X3
   mov   qword ptr [pDst+sizeof(qword)*13], X4
   EXITM
   ENDIF ;; N==7

   mov   qword ptr [pDst+sizeof(qword)*6],  X5
   mov   qword ptr [pDst+sizeof(qword)*7],  X6
   mov   qword ptr [pDst+sizeof(qword)*8],  X7
   mov   qword ptr [pDst+sizeof(qword)*9],  X0
   mov   qword ptr [pDst+sizeof(qword)*10], X1
   mov   qword ptr [pDst+sizeof(qword)*11], X2
   EXITM
   ENDIF ;; N==6

   mov   qword ptr [pDst+sizeof(qword)*5],  X4
   mov   qword ptr [pDst+sizeof(qword)*6],  X5
   mov   qword ptr [pDst+sizeof(qword)*7],  X6
   mov   qword ptr [pDst+sizeof(qword)*8],  X7
   mov   qword ptr [pDst+sizeof(qword)*9],  X0
   EXITM
   ENDIF ;; N==5

   mov   qword ptr [pDst+sizeof(qword)*4],  X3
   mov   qword ptr [pDst+sizeof(qword)*5],  X4
   mov   qword ptr [pDst+sizeof(qword)*6],  X5
   mov   qword ptr [pDst+sizeof(qword)*7],  X6
   EXITM
   ENDIF ;; N==4

   mov   qword ptr [pDst+sizeof(qword)*3],  X2
   mov   qword ptr [pDst+sizeof(qword)*4],  X3
   mov   qword ptr [pDst+sizeof(qword)*5],  X4
   EXITM
   ENDIF ;; N==3

   mov   qword ptr [pDst+sizeof(qword)*2],  X1
   mov   qword ptr [pDst+sizeof(qword)*3],  X2
   EXITM
   ENDIF ;; N==2

   mov   qword ptr [pDst+sizeof(qword)*1],  X0
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MULx1 genaral-case multiplier macros
;;

;; dst = src * B (body)
MULx1 MACRO rDst, rSrc, idx, B, T0,T1,T2,T3
LOCAL L_1
   ALIGN   16
L_1:
   mul   B
   xor   T1, T1
   add   T0, rax
   mov   qword ptr [rDst+idx*sizeof(qword)], T0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]
   adc   T1, rdx

   mul   B
   xor   T2, T2
   add   T1, rax
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T2, rdx

   mul   B
   xor   T3, T3
   add   T2, rax
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T3, rdx

   mul   B
   xor   T0, T0
   add   T3, rax
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]
   adc   T0, rdx

   add   idx, 4
   jnc   L_1
ENDM

;; dst = src * B epilogue (srcLen=4*n+4)
MULx1_4N_4_ELOG   MACRO rDst, rSrc, B, T0,T1,T2,T3
   mul   B
   xor   T1, T1
   add   T0, rax
   mov   qword ptr [rDst], T0
   mov   rax, qword ptr [rSrc+sizeof(qword)]
   adc   T1, rdx

   mul   B
   xor   T2, T2
   add   T1, rax
   mov   qword ptr [rDst+sizeof(qword)], T1
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]
   adc   T2, rdx

   mul   B
   xor   T3, T3
   add   T2, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T3, rdx

   mul   B
   mov   idx, qword ptr [rsp+counterA]
   add   T3, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T3
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0
  ;mov   rbp, rax

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM

;; dst = src * B epilogue (srcLen=4*n+3)
MULx1_4N_3_ELOG   MACRO rDst, rSrc, B, T0,T1,T2,T3
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
   mov   idx, qword ptr [rsp+counterA]
   add   T2, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T2
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0
  ;mov   rbp, rax

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM

;; dst = src * B epilogue (srcLen=4*n+2)
MULx1_4N_2_ELOG   MACRO rDst, rSrc, B, T0,T1,T2,T3
   mul   B
   xor   T1, T1
   add   T0, rax
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]
   adc   T1, rdx

   mul   B
   mov   idx, qword ptr [rsp+counterA]
   add   T1, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T1
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0
  ;mov   rbp, rax

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM

;; dst = src * B epilogue (srcLen=4*n+1)
MULx1_4N_1_ELOG   MACRO rDst, rSrc, B, T0,T1,T2,T3
   mul   B
   mov   idx, qword ptr [rsp+counterA]
   add   T0, rax
   mov   qword ptr [rDst+sizeof(qword)*3], T0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, 0
  ;mov   rbp, rax

   mov   qword ptr [rDst+sizeof(qword)*4], rdx
   add   rDst, sizeof(qword)
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MULx2 genaral-case multiplier macros
;;

; dst = src*{B1:B0}
MULx2 MACRO rDst, rSrc, idx, B0,B1, T0,T1,T2,T3
LOCAL L_1
   ALIGN IPP_ALIGN_FACTOR
L_1:
   mul   B1                                                       ; {T2:T1} += a[i]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[i+1]*B0
   mov   qword ptr [rDst+idx*sizeof(qword)], T0
   add   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]
   adc   T2, rdx
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[i+1]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[i+2]*B0
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   add   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]
   adc   T3, rdx
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[i+2]*B1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]
   adc   T0, rdx

   mul   B0                                                       ; {T1:T0:T3} += a[i+3]*B0
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   add   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]
   adc   T0, rdx
   adc   T1, 0

   mul   B1                                                       ; {T1:T0} += a[i+3]*B1
   xor   T2, T2
   add   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]
   adc   T1, rdx

   mul   B0                                                       ; {T2:T1:T0} += a[i+4]*B0
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   add   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]
   adc   T1, rdx
   adc   T2, 0

   add   idx, 4
   jnc   L_1
ENDM

;; dst = src * {B1:B0} epilogue (srcLen=4*n+1)
MULx2_4N_1_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-1]*B1
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T0
   add   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T2

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T1
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = src * {B1:B0} epilogue (srcLen=4*n+2)
MULx2_4N_2_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-2]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[LenA-1]*B0
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T2, rdx
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-1]*B1
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T1
   add   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T3

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T2
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = src * {B1:B0} epilogue (srcLen=4*n+3)
MULx2_4N_3_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
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
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T2
   add   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T0

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T3
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = src * {B1:B0} epilogue (srcLen=4*n+4)
MULx2_4N_4_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-4]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[lenA-3]*B0
   mov   qword ptr [rDst], T0
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-3]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[aLen-2]*B0
   mov   qword ptr [rDst+sizeof(qword)], T1
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[lenA-2]*B1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T0, rdx

   mul   B0                                                       ; {T1:T0:T3} += a[lenA-1]*B0
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   add   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T0, rdx
   adc   T1, 0

   mul   B1                                                       ; {T1:T0} += a[lenA-1]*B1
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T3
   add   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T1

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T0
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MLAx2 genaral-case multiplier macros
;;

MLAx2_PLOG  MACRO B0,B1, dataB, T0,T1,T2,T3
   mov      B0, qword ptr [dataB]
   mul      B0                                        ; {T2:T1:T0} = a[0]*b[i]
   mov      B1, qword ptr [dataB+sizeof(qword)]
   xor      T2, T2
   mov      T0, rax
   mov      rax, qword ptr [rSrc+idx*sizeof(qword)]   ; a[i]
   mov      T1, rdx
ENDM


IF (_IPP32E LE _IPP32E_Y8)
;;
;; Pre- Sandy Bridge specific code
;;

MLAx2 MACRO rDst, rSrc, idx, B0,B1, T0,T1,T2,T3
LOCAL L_1
ALIGN IPP_ALIGN_FACTOR
L_1:
   mul   B1                                                       ; {T2:T1} += a[i]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[i+1]*B0 + r[i]
   add   T0, qword ptr [rDst+idx*sizeof(qword)]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]
   adc   T2, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)], T0
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[i+1]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[i+2]*B0 + r[i+1]
   add   T1, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]
   adc   T3, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[i+2]*B1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]
   adc   T0, rdx

   mul   B0                                                       ; {T1:T0:T3} += a[i+3]*B0 + r[i+2]
   add   T2, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2]
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]
   adc   T0, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   T1, 0

   mul   B1                                                       ; {T1:T0} += a[i+3]*B1
   xor   T2, T2
   add   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]
   adc   T1, rdx

   mul   B0                                                       ; {T2:T1:T0} += a[i+4]*B0 + r[i+3]
   add   T3, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3]
   adc   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]
   adc   T1, rdx
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   adc   T2, 0

   add   idx, 4
   jnc   L_1
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+1)
MLAx2_4N_1_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T0, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T0
   adc   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T2

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T1
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = dst + src * {B1:B0} epilogue (srcLen=4*n+2)
MLAx2_4N_2_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-2]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[lenA-1]*B0 + r[lenA-2]
   add   T0, qword ptr [rDst+sizeof(qword)*2]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T2, rdx
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T1, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T1
   adc   T2, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T3

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T2
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+3)
MLAx2_4N_3_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-3]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[LenA-2]*B0 + r[len-3]
   add   T0, qword ptr [rDst+sizeof(qword)]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a[lenA-2]
   adc   T2, rdx
   mov   qword ptr [rDst+sizeof(qword)], T0
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-2]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[lenA-1]*B0 + r[lenA-2]
   add   T1, qword ptr [rDst+sizeof(qword)*2]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T3, rdx
   mov   qword ptr [rDst+sizeof(qword)*2], T1
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T2, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T2
   adc   T3, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T0

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T3
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+4)
MLAx2_4N_4_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-4]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[lenA-3]*B0 + r[lenA-4]
   add   T0, qword ptr [rDst]
   adc   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx
   mov   qword ptr [rDst], T0
   adc   T3, 0

   mul   B1                                                       ; {T3:T2} += a[lenA-3]*B1
   xor   T0, T0
   add   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx

   mul   B0                                                       ; {T0:T3:T2} += a[aLen-2]*B0 + r[lenA-3]
   add   T1, qword ptr [rDst+sizeof(qword)]
   adc   T2, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]
   adc   T3, rdx
   mov   qword ptr [rDst+sizeof(qword)], T1
   adc   T0, 0

   mul   B1                                                       ; {T0:T3} += a[lenA-2]*B1
   xor   T1, T1
   add   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T0, rdx

   mul   B0                                                       ; {T1:T0:T3} += a[lenA-1]*B0 + r[lenA-2]
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   adc   T3, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T0, rdx
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   adc   T1, 0

   mul   B1                                                       ; {T1:T0} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T3, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T3
   adc   T0, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]
   adc   rdx, T1

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T0
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM
ENDIF


IF (_IPP32E GE _IPP32E_E9)
;;
;; Sandy Bridge specific code
;;
MLAx2 MACRO rDst, rSrc, idx, B0,B1, T0,T1,T2,T3
LOCAL L_1
ALIGN IPP_ALIGN_FACTOR
L_1:
   mul   B1                                                       ; {T2:T1} += a[i]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[i+1]*B0 + r[i]
   add   T0, qword ptr [rDst+idx*sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)], T0
   adc   T1, rax
   adc   T2, rdx
   adc   T3, 0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)]    ; a[i+1]

   mul   B1                                                       ; {T3:T2} += a[i+1]*B1
   xor   T0, T0
   add   T2, rax
   adc   T3, rdx
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]

   mul   B0                                                       ; {T0:T3:T2} += a[i+2]*B0 + r[i+1]
   add   T1, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)], T1
   adc   T2, rax
   adc   T3, rdx
   adc   T0, 0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*2]  ; a[i+2]

   mul   B1                                                       ; {T0:T3} += a[i+2]*B1
   xor   T1, T1
   add   T3, rax
   adc   T0, rdx
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]

   mul   B0                                                       ; {T1:T0:T3} += a[i+3]*B0 + r[i+2]
   add   T2, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*2], T2
   adc   T3, rax
   adc   T0, rdx
   adc   T1, 0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*3]  ; a[i+3]

   mul   B1                                                       ; {T1:T0} += a[i+3]*B1
   xor   T2, T2
   add   T0, rax
   adc   T1, rdx
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]

   mul   B0                                                       ; {T2:T1:T0} += a[i+4]*B0 + r[i+3]
   add   T3, qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3]
   mov   qword ptr [rDst+idx*sizeof(qword)+sizeof(qword)*3], T3
   adc   T0, rax
   adc   T1, rdx
   adc   T2, 0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)+sizeof(qword)*4]  ; a[i+4]

   add   idx, 4
   jnc   L_1
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+1)
MLAx2_4N_1_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T0, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T0
   adc   T1, rax
   adc   rdx, T2
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T1
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = dst + src * {B1:B0} epilogue (srcLen=4*n+2)
MLAx2_4N_2_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-2]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[lenA-1]*B0 + r[lenA-2]
   add   T0, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T0
   adc   T1, rax
   adc   T2, rdx
   adc   T3, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]

   mul   B1                                                       ; {T3:T2} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T1, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T1
   adc   T2, rax
   adc   rdx, T3
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T2
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+3)
MLAx2_4N_3_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
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
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T2, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T2
   adc   T3, rax
   adc   rdx, T0
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T3
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM

;; dst = + src * {B1:B0} epilogue (srcLen=4*n+4)
MLAx2_4N_4_ELOG   MACRO rDst, rSrc, B0,B1, T0,T1,T2,T3
   mul   B1                                                       ; {T2:T1} += a[lenA-4]*B1
   xor   T3, T3
   add   T1, rax
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]
   adc   T2, rdx

   mul   B0                                                       ; {T3:T2:T1} += a[lenA-3]*B0 + r[lenA-4]
   add   T0, qword ptr [rDst]
   mov   qword ptr [rDst], T0
   adc   T1, rax
   adc   T2, rdx
   adc   T3, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)]                      ; a[lenA-3]

   mul   B1                                                       ; {T3:T2} += a[lenA-3]*B1
   xor   T0, T0
   add   T2, rax
   adc   T3, rdx
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]

   mul   B0                                                       ; {T0:T3:T2} += a[aLen-2]*B0 + r[lenA-3]
   add   T1, qword ptr [rDst+sizeof(qword)]
   mov   qword ptr [rDst+sizeof(qword)], T1
   adc   T2, rax
   adc   T3, rdx
   adc   T0, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)*2]                    ; a{lenA-2]

   mul   B1                                                       ; {T0:T3} += a[lenA-2]*B1
   xor   T1, T1
   add   T3, rax
   adc   T0, rdx
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]

   mul   B0                                                       ; {T1:T0:T3} += a[lenA-1]*B0 + r[lenA-2]
   add   T2, qword ptr [rDst+sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*2], T2
   adc   T3, rax
   adc   T0, rdx
   adc   T1, 0
   mov   rax, qword ptr [rSrc+sizeof(qword)*3]                    ; a[lenA-1]

   mul   B1                                                       ; {T1:T0} += a[lenA-1]*B1 + r[lenA-1]
   add   rDst, sizeof(qword)*2
   mov   idx, [rsp+counterA]
   add   T3, qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2]
   mov   qword ptr [rDst+sizeof(qword)*3-sizeof(qword)*2], T3
   adc   T0, rax
   adc   rdx, T1
   mov   rax, qword ptr [rSrc+idx*sizeof(qword)]

   mov   qword ptr [rDst+sizeof(qword)*4-sizeof(qword)*2], T0
   mov   qword ptr [rDst+sizeof(qword)*5-sizeof(qword)*2], rdx
ENDM
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
