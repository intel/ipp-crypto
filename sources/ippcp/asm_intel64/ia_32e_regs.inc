;===============================================================================
; Copyright 2012-2019 Intel Corporation
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
; 
; 
;

;;
;; Just for unify GPRs usage
;;

r0  equ   rax     ;; 64-bits GPRs
r1  equ   rbx
r2  equ   rcx
r3  equ   rdx
r4  equ   rdi
r5  equ   rsi
r6  equ   rbp
r7  equ   rsp

r0d equ   eax     ;; 32-bits GPRs
r1d equ   ebx
r2d equ   ecx
r3d equ   edx
r4d equ   edi
r5d equ   esi
r6d equ   ebp
r7d equ   esp

raxd equ  eax
rbxd equ  ebx
rcxd equ  ecx
rdxd equ  edx
rdid equ  edi
rsid equ  esi
rbpd equ  ebp

r0w equ    ax     ;; 16-bits GPRs
r1w equ    bx
r2w equ    cx
r3w equ    dx
r4w equ    di
r5w equ    si
r6w equ    bp
r7w equ    sp

raxw equ   ax
rbxw equ   bx
rcxw equ   cx
rdxw equ   dx
rdiw equ   di
rsiw equ   si
rbpw equ   bp

r0b equ    al     ;;  8-bits GPRs
r1b equ    bl
r2b equ    cl
r3b equ    dl
r4b equ    dil
r5b equ    sil
r6b equ    bpl
r7b equ    spl

raxb equ   al
rbxb equ   bl
rcxb equ   cl
rdxb equ   dl
rdib equ   dil
rsib equ   sil
rbpb equ   bpl

raxbl equ   al
rbxbl equ   bl
rcxbl equ   cl
rdxbl equ   dl
raxbh equ   ah
rbxbh equ   bh
rcxbh equ   ch
rdxbh equ   dh

;;
;; Register Parameters (depend on used OS)
;;
IFDEF WIN32E
rpar1 equ rcx
rpar2 equ rdx
rpar3 equ r8
rpar4 equ r9
rpar5 equ [rsp+ARG_5]
rpar6 equ [rsp+ARG_6]
ENDIF

IFDEF LINUX32E
rpar1 equ rdi
rpar2 equ rsi
rpar3 equ rdx
rpar4 equ rcx
rpar5 equ r8
rpar6 equ r9
ENDIF

;; use GPR implementation everywhere possible
GPR_version = 1

