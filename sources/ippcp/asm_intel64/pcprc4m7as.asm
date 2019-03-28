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
;               ARCFour
; 
;     Content:
;        ARCFourKernel()
; 
;

include asmdefs.inc
include ia_32e.inc

IF _IPP32E GE _IPP32E_M7

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;***************************************************************
;* Purpose:     RC4 kernel
;*
;* void ARCFourProcessData(const Ipp8u *pSrc, Ipp8u *pDst, int len,
;*                         IppsARCFourState* pCtx)
;*
;***************************************************************

;;
;; Lib = M7
;;
;; Caller = ippsARCFourEncrypt
;; Caller = ippsARCFourDecrypt
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM ARCFourProcessData PROC PUBLIC FRAME
      USES_GPR  rsi,rdi,rbx,rbp
      USES_XMM
      COMP_ABI 4
;; rdi:  pSrc:  PTR BYTE,    ; input  stream
;; rsi:  pDst:  PTR BYTE,    ; output stream
;; rdx:  len:      DWORD,    ; stream length
;; rcx:  pCtx:  PTR BYTE     ; context

   movsxd   r8, edx
   test     r8, r8      ; test length
   mov      rbp, rcx    ; copy pointer context
   jz       quit

   movzx    rax, byte ptr[rbp+4]       ; extract x
   movzx    rbx, byte ptr[rbp+8]       ; extract y

   lea      rbp, [rbp+12]              ; sbox

   add      rax,1                      ; x = (x+1)&0xFF
   movzx    rax, al
   movzx    rcx, byte ptr [rbp+rax*4]  ; tx = S[x]

;;
;; main code
;;
ALIGN IPP_ALIGN_FACTOR
main_loop:
   add      rbx, rcx                   ; y = (x+tx)&0xFF
   movzx    rbx, bl
   add      rdi, 1
   add      rsi, 1
   movzx    rdx, byte ptr [rbp+rbx*4]  ; ty = S[y]

   mov      dword ptr [rbp+rbx*4],ecx  ; S[y] = tx
   add      rcx, rdx                   ; tmp_idx = (tx+ty)&0xFF
   movzx    rcx, cl
   mov      dword ptr [rbp+rax*4],edx  ; S[x] = ty

   mov      dl, byte ptr [rbp+rcx*4]   ; byte of gamma
   add      rax, 1                     ; next x = (x+1)&0xFF
   movzx    rax, al

   xor      dl,byte ptr [rdi-1]        ; gamma ^= src
   sub      r8, 1
   movzx    rcx, byte ptr [rbp+rax*4]  ; next tx = S[x]
   mov      byte ptr [rsi-1],dl        ; store result
   jne      main_loop

   lea      rbp, [rbp-12]           ; pointer to context

   sub      rax, 1                  ; actual new x counter
   movzx    rax, al
   mov      dword ptr[rbp+4], eax   ; update x conter
   mov      dword ptr[rbp+8], ebx   ; updtae y counter

quit:
   REST_XMM
   REST_GPR
   ret
IPPASM ARCFourProcessData ENDP

ENDIF
END
