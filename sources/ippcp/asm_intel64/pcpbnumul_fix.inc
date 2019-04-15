;===============================================================================
; Copyright 2013-2019 Intel Corporation
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
;               Low level Big Number multiplication Support
; 
;

IFNDEF _PCPBNUMUL_FIX_ADCX_INC_
_PCPBNUMUL_FIX_ADCX_INC_ = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro used to replace op reg, mem instructions
SWAP  MACRO r1, r2
   xor      r1, r2
   xor      r2, r1
   xor      r1, r2
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro used extract proc ep from the table
GET_EP   MACRO    regEp:REQ, Table:REQ, regIdx:REQ, tmp
   lea   regEp, Table
   IFNB <tmp>
   mov   tmp, [regEp+regIdx*sizeof(qword)-sizeof(qword)]
   add   regEp, tmp
   ELSE
   mov   regIdx, [regEp+regIdx*sizeof(qword)-sizeof(qword)]
   add   regEp, regIdx
   ENDIF
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; op DST, mem_src
op_reg_mem MACRO opCode, dst, mem_src, tmp
   mov      tmp, mem_src
   opCode   dst, tmp
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MEM_DST = (op src1, mem_src2)
op_mem_reg_mem MACRO opCode, mem_dst, src1, mem_src2, tmp
   op_reg_mem  opCode, src1, mem_src2, tmp
   mov         mem_dst, src1
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MEM_DST = op mem_src1, mem_src2
op_mem_mem MACRO opCode, mem_dst, mem_src1, mem_src2, tmp
   mov         tmp, mem_src1
   opCode      tmp, mem_src2
   mov         mem_dst, tmp
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Inputs: pDst: Destination  (upto 1024 bits, 16 qwords)
;;;         pA:   Multiplicand (upto 512 bits, 8 qwords)
;;;
;;;
;;; Uses registers:
;;;   rdx      - implicit multiplicand
;;;   (HIP:LOP)- 64x64-bit product (mulx)
;;;   X7,,X0   - high result
;;;
MUL_FIX  MACRO    N, pDst, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7
 gsmulx  X0, LOP, [pA]                 ; (X0:LO) = a[0]*b
   IFNB  <pDst>
   mov   [pDst], LOP
   ENDIF

   IF N GT 1
 gsmulx  X1, HIP, [pA+sizeof(qword)]   ; (X1:LO) = a[1]*b
   add   X0, HIP
   IF N EQ 2
   adc   X1, 0
   ENDIF

   IF N GT 2
 gsmulx  X2, LOP, [pA+sizeof(qword)*2] ; (X2:LO) = a[2]*b
   adc   X1, LOP
   IF N EQ 3
   adc   X2, 0
   ENDIF

   IF N GT 3
 gsmulx  X3, HIP, [pA+sizeof(qword)*3] ; (X3:LO) = a[3]*b
   adc   X2, HIP
   IF N EQ 4
   adc   X3, 0
   ENDIF

   IF N GT 4
 gsmulx  X4, LOP, [pA+sizeof(qword)*4] ; (X4:LO) = a[4]*b
   adc   X3, LOP
   IF N EQ 5
   adc   X4, 0
   ENDIF

   IF N GT 5
 gsmulx  X5, HIP, [pA+sizeof(qword)*5] ; (X5:LO) = a[5]*b
   adc   X4, HIP
   IF N EQ 6
   adc   X5, 0
   ENDIF

   IF N GT 6
 gsmulx  X6, LOP, [pA+sizeof(qword)*6] ; (X6:LO) = a[6]*b
   adc   X5, LOP
   IF N EQ 7
   adc   X6, 0
   ENDIF

   IF N GT 7
 gsmulx  X7, HIP, [pA+sizeof(qword)*7] ; (X7:LO) = a[7]*b
   adc   X6, HIP
   adc   X7, 0
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; {x7,x6,x5,x4,x3,x2,x1,x0},DCT[0] = {x7,x6,x5,x4,x3,x2,x1,x0} + A[7:0]*B[i]
;;
;; uses rax, rdx
;;    rdx      - implicit multiplicand B[i] (should to be preloaded)
;;    rax      - temporary product
;;    (HIP:LOP)- 64x64-bit product (mulx)
;;    X7,,X0   - high result
;;
MLA_FIX  MACRO    N, pDst, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7
 gsmulx  HIP, rax, [pA]                ; (HI:rax) = a[0]*b[i]
   add   rax, X0
   adc   HIP, 0
   IFNB  <pDst>
   mov   [pDst], rax
   ENDIF
   IF N EQ 1
   mov   X0, HIP
   ENDIF

   IF N GT 1
 gsmulx  LOP,X0, [pA+sizeof(qword)]    ; (LO:X0) = a[1]*b[i]
   add   X0, X1
   adc   LOP, 0
   add   X0, HIP
   adc   LOP, 0
   IF N EQ 2
   mov   X1, LOP
   ENDIF

   IF N GT 2
 gsmulx  HIP,X1, [pA+sizeof(qword)*2]  ; (HI:X1) = a[2]*b[i]
   add   X1, X2
   adc   HIP, 0
   add   X1, LOP
   adc   HIP, 0
   IF N EQ 3
   mov   X2, HIP
   ENDIF

   IF N GT 3
 gsmulx  LOP,X2, [pA+sizeof(qword)*3]  ; (LO,X2) = a[3]*b[i]
   add   X2, X3
   adc   LOP, 0
   add   X2, HIP
   adc   LOP, 0
   IF N EQ 4
   mov   X3, LOP
   ENDIF

   IF N GT 4
 gsmulx  HIP,X3, [pA+sizeof(qword)*4]  ; (HI:X3) = a[4]*b[i]
   add   X3, X4
   adc   HIP, 0
   add   X3, LOP
   adc   HIP, 0
   IF N EQ 5
   mov   X4, HIP
   ENDIF

   IF N GT 5
 gsmulx  LOP,X4, [pA+sizeof(qword)*5]  ; (LO:X4) = a[5]*b[i]
   add   X4, X5
   adc   LOP, 0
   add   X4, HIP
   adc   LOP, 0
   IF N EQ 6
   mov   X5, LOP
   ENDIF

   IF N GT 6
 gsmulx  HIP,X5, [pA+sizeof(qword)*6]  ; (HI:X5) = a[6]*b[i]
   add   X5, X6
   adc   HIP, 0
   add   X5, LOP
   adc   HIP, 0
   IF N EQ 7
   mov   X6, HIP
   ENDIF

   IF N GT 7
 gsmulx  LOP, X6, [pA+sizeof(qword)*7]  ; (LO:X6) = a[7]*b[i]
   add   X6, X7 
   adc   LOP, 0
   add   X6, HIP
   adc   LOP, 0
   mov   X7, LOP
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
   ENDIF
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Inputs: pDst: Destination  (upto 1024 bits, 16 qwords)
;;;         pA:   Multiplicand (upto 512 bits, 8 qwords)
;;;         pB:   Multiplicand (upto 512 bits, 8 qwords)
;;;
;;;
;;; Uses registers:
;;;   rdx      - implicit multiplicand
;;;   (HIP:LOP)- 64x64-bit product (mulx)
;;;   X0,,X7   - high result
;;;
MUL_NxN    MACRO    N, pDst, pA, pB, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7
   mov      rdx, [pB]
   MUL_FIX  N, pDst, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 1
   mov      rdx, [pB+sizeof(qword)*1]
   MLA_FIX  N, <pDst+sizeof(qword)*1>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 2
   mov      rdx, [pB+sizeof(qword)*2]
   MLA_FIX  N, <pDst+sizeof(qword)*2>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 3
   mov      rdx, [pB+sizeof(qword)*3]
   MLA_FIX  N, <pDst+sizeof(qword)*3>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 4
   mov      rdx, [pB+sizeof(qword)*4]
   MLA_FIX  N, <pDst+sizeof(qword)*4>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 5
   mov      rdx, [pB+sizeof(qword)*5]
   MLA_FIX  N, <pDst+sizeof(qword)*5>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 6
   mov      rdx, [pB+sizeof(qword)*6]
   MLA_FIX  N, <pDst+sizeof(qword)*6>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   IF N GT 7
   mov      rdx, [pB+sizeof(qword)*7]
   MLA_FIX  N, <pDst+sizeof(qword)*7>, pA, HIP,LOP, X0,X1,X2,X3,X4,X5,X6,X7

   mov   qword ptr [pDst+sizeof(qword)*8],  X0
   mov   qword ptr [pDst+sizeof(qword)*9],  X1
   mov   qword ptr [pDst+sizeof(qword)*10], X2
   mov   qword ptr [pDst+sizeof(qword)*11], X3
   mov   qword ptr [pDst+sizeof(qword)*12], X4
   mov   qword ptr [pDst+sizeof(qword)*13], X5
   mov   qword ptr [pDst+sizeof(qword)*14], X6
   mov   qword ptr [pDst+sizeof(qword)*15], X7
   EXITM
   ENDIF ;; N==8

   mov   qword ptr [pDst+sizeof(qword)*7],  X0
   mov   qword ptr [pDst+sizeof(qword)*8],  X1
   mov   qword ptr [pDst+sizeof(qword)*9],  X2
   mov   qword ptr [pDst+sizeof(qword)*10], X3
   mov   qword ptr [pDst+sizeof(qword)*11], X4
   mov   qword ptr [pDst+sizeof(qword)*12], X5
   mov   qword ptr [pDst+sizeof(qword)*13], X6
   EXITM
   ENDIF ;; N==7

   mov   qword ptr [pDst+sizeof(qword)*6],  X0
   mov   qword ptr [pDst+sizeof(qword)*7],  X1
   mov   qword ptr [pDst+sizeof(qword)*8],  X2
   mov   qword ptr [pDst+sizeof(qword)*9],  X3
   mov   qword ptr [pDst+sizeof(qword)*10], X4
   mov   qword ptr [pDst+sizeof(qword)*11], X5
   EXITM
   ENDIF ;; N==6

   mov   qword ptr [pDst+sizeof(qword)*5],  X0
   mov   qword ptr [pDst+sizeof(qword)*6],  X1
   mov   qword ptr [pDst+sizeof(qword)*7],  X2
   mov   qword ptr [pDst+sizeof(qword)*8],  X3
   mov   qword ptr [pDst+sizeof(qword)*9],  X4
   EXITM
   ENDIF ;; N==5

   mov   qword ptr [pDst+sizeof(qword)*4],  X0
   mov   qword ptr [pDst+sizeof(qword)*5],  X1
   mov   qword ptr [pDst+sizeof(qword)*6],  X2
   mov   qword ptr [pDst+sizeof(qword)*7],  X3
   EXITM
   ENDIF ;; N==4

   mov   qword ptr [pDst+sizeof(qword)*3],  X0
   mov   qword ptr [pDst+sizeof(qword)*4],  X1
   mov   qword ptr [pDst+sizeof(qword)*5],  X2
   EXITM
   ENDIF ;; N==3

   mov   qword ptr [pDst+sizeof(qword)*2],  X0
   mov   qword ptr [pDst+sizeof(qword)*3],  X1
   EXITM
   ENDIF ;; N==2

   mov   qword ptr [pDst+sizeof(qword)*1],  X0
ENDM

ENDIF ;; _PCPBNUMUL_FIX_ADCX_INC_
