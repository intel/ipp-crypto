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
;     Purpose:  EM64T Cryptography Primitive.
;               Emulation of Intel(R) instructions MULX, ADCX, ADOX (for debug only)
; 
;
IFNDEF _PCPMULX_INC_
_PCPMULX_INC_ = 1

IFNDEF _EMULATION_
gsmulx MACRO resH,resL,src
   mulx  resH,resL,src
ENDM
ENDIF

IFDEF _EMULATION_
gsmulx MACRO resH,resL,src
   pushf                            ;; store flags

   sub   rsp, sizeof(qword)*4
   mov   [rsp-sizeof(qword)*3], rax ;; store RAX
   mov   [rsp-sizeof(qword)*2], rdx ;; store RDX
   mov   rax,rdx
   mov   rdx, src

   mul   rdx

   mov   [rsp-sizeof(qword)*1], rax ;; store Low product
   mov   [rsp-sizeof(qword)*0], rdx ;; store Hig product

   mov   rax, [rsp-sizeof(qword)*3] ;; re-store RAX
   mov   rdx, [rsp-sizeof(qword)*2] ;; re-store RDX
   mov   resL, [rsp-sizeof(qword)*1];; load Low product
   mov   resH, [rsp-sizeof(qword)*0];; load Hig product
   add   rsp, sizeof(qword)*4

   popf                             ;; re-store flags
ENDM
ENDIF

IFNDEF _EMULATION_
gsadcx MACRO rdst,rsrc
   adcx     rdst, rsrc
ENDM
ENDIF

IFDEF _EMULATION_
gsadcx MACRO rdst,src
   push  rdst        ;; slot for result
   push  rax         ;; save rax
   pushfq            ;; flags before adc

   adc   rdst, src
   mov   [rsp+2*sizeof(qword)], rdst

   pushfq            ;; rsrc = flags after operation
   pop   rax
   and   rax, 1      ;; cf after operation
   and   qword ptr[rsp], (-2)   ;; clear cf before operation
   or    [rsp], rax  ;; new psw
   popfq

   pop   rax
   pop   rdst
ENDM
ENDIF

IFNDEF _EMULATION_
gsadox MACRO rdst,rsrc
   adox     rdst, rsrc
ENDM
ENDIF

IFDEF _EMULATION_
gsadox MACRO rdst,src
   push  rdst
   push  rax         ;; save rax

   pushfq            ;; rax = flags before adc
   mov   rax, [rsp]
   and   rax, 800h   ;; of
   xor   [rsp], rax  ;; clear of

   shr   rax, 11     ;; mov of to cf position
   push  rax         ;; new psw
   popfq

IFIDNI <src>,<rax>
   mov   rax, [rsp+sizeof(qword)]
ENDIF
IFIDNI <rdst>,<rax>
   mov   rdst, [rsp+2*sizeof(qword)]
ENDIF

   adc   rdst, src
   mov   [rsp+2*sizeof(qword)], rdst

   pushfq            ;; rsrc = flags after operation
   pop   rax
   and   rax, 1      ;; cf after operation

   shl   rax, 11     ;; mov cf into of position
   or    [rsp], rax  ;; new psw
   popfq

   pop   rax
   pop   rdst
ENDM
ENDIF

ENDIF ;; _PCPMULX_INC_
