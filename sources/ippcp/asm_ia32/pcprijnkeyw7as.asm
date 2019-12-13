;===============================================================================
; Copyright 2014-2019 Intel Corporation
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
;               Rijndael Key Expansion Support
;
;     Content:
;        SubsDword_8uT()
;
;




%include "asmdefs.inc"
%include "ia_emm.inc"

%if (_IPP >= _IPP_W7)

segment .text align=IPP_ALIGN_FACTOR


%xdefine CACHE_LINE_SIZE  (64)

;***************************************************************
;* Purpose:    Mitigation of the Key Expansion procedure
;*
;* Ipp32u Touch_SubsDword_8uT(Ipp32u inp,
;*                      const Ipp8u* pTbl,
;*                            int tblBytes)
;***************************************************************
align IPP_ALIGN_FACTOR
IPPASM Touch_SubsDword_8uT,PUBLIC
  USES_GPR esi,edi,ebx

%xdefine inp    [esp + ARG_1 + 0*sizeof(dword)] ; input dword
%xdefine pTbl   [esp + ARG_1 + 1*sizeof(dword)] ; Rijndael's S-box
%xdefine tblLen [esp + ARG_1 + 2*sizeof(dword)] ; length of table (bytes)

   mov      esi, pTbl   ; tbl address and
   mov      edx, tblLen ; length
   xor      ecx, ecx
.touch_tbl:
   mov      eax, [esi+ecx]
   add      ecx, CACHE_LINE_SIZE
   cmp      ecx, edx
   jl       .touch_tbl

   mov      edx, inp

   mov      eax, edx
   and      eax, 0FFh         ; b[0]
   movzx    eax, BYTE [esi+eax]

   shr      edx, 8
   mov      ebx, edx
   and      ebx, 0FFh         ; b[1]
   movzx    ebx, BYTE [esi+ebx]
   shl      ebx, 8

   shr      edx, 8
   mov      ecx, edx
   and      ecx, 0FFh         ; b[2]
   movzx    ecx, BYTE [esi+ecx]
   shl      ecx, 16

   shr      edx, 8
   movzx    edx, BYTE [esi+edx]
   shl      edx, 24

   or       eax, ebx
   or       eax, ecx
   or       eax, edx
   REST_GPR
   ret
ENDFUNC Touch_SubsDword_8uT

%endif

