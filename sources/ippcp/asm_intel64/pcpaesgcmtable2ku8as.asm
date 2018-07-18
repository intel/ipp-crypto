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
;               Encrypt/Decrypt byte data stream according to Rijndael128 (GCM mode)
; 
;     Content:
;      AesGcmMulGcm_table2K()
;      AesGcmAuth_table2K()
;

include asmdefs.inc
include ia_32e.inc


IF _IPP32E GE _IPP32E_U8

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;
; void AesGcmMulGcm_table2K(Ipp8u* pHash, const Ipp8u* pPrecomputedData, const void* pParam)
;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmMulGcm_table2K PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx
      USES_XMM
      COMP_ABI 3

   movdqu   xmm0, [rdi]                ; hash value
   mov      r8, rsi                    ; precomputed data pointer

   mov      r9, rdx                    ; pointer to the fixed table (AesGcmConst_table)

   movd     ebx, xmm0         ; ebx = hash.0
   mov      eax, 0f0f0f0f0h
   and      eax, ebx          ; eax = 4 x 4_bits
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h   ; ebx = 4 x 4_bits (another)
   movzx    ecx, ah
   movdqa   xmm5, oword ptr [r8+1024+rcx]
   movzx    ecx, al
   movdqa   xmm4, oword ptr [r8+1024+rcx]
   shr      eax, 16
   movzx    ecx, ah
   movdqa   xmm3, oword ptr [r8+1024+rcx]
   movzx    ecx, al
   movdqa   xmm2, oword ptr [r8+1024+rcx]

   psrldq   xmm0, 4           ; shift xmm0
   movd     eax, xmm0         ; eax = hash[1]
   and      eax, 0f0f0f0f0h   ; eax = 4 x 4_bits

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (1-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (1-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (1-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (1-1)*256 + rcx]

   movd     ebx, xmm0         ; ebx = hash[1]
   shl      ebx, 4            ; another 4 x 4_bits
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 1*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 1*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 1*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 1*256 + rcx]
   psrldq   xmm0, 4

   movd     eax, xmm0            ; eax = hash.2
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (2-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (2-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (2-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (2-1)*256 + rcx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 2*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 2*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 2*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 2*256 + rcx]

   psrldq   xmm0, 4
   movd     eax, xmm0         ; eax = hash.3
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (3-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (3-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (3-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (3-1)*256 + rcx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 3*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 3*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 3*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 3*256 + rcx]

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ 3*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ 3*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ 3*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ 3*256 + rcx]

   movdqa   xmm0, xmm3
   pslldq   xmm3, 1
   pxor     xmm2, xmm3
   movdqa   xmm1, xmm2
   pslldq   xmm2, 1
   pxor     xmm5, xmm2
   psrldq   xmm0, 15

   movd     ecx, xmm0
   movzx    eax, word ptr [r9 + rcx*sizeof(word)]
   shl      eax, 8
   movdqa   xmm0, xmm5
   pslldq   xmm5, 1
   pxor     xmm4, xmm5
   psrldq   xmm1, 15
   movd     ecx, xmm1
   xor      ax, word ptr [r9 + rcx*sizeof(word)]
   shl      eax, 8
   psrldq   xmm0, 15
   movd     ecx, xmm0
   xor      ax, word ptr [r9 + rcx*sizeof(word)]
   movd     xmm0, eax
   pxor     xmm0, xmm4

   movdqu   oword ptr[rdi], xmm0    ; store hash value

   REST_XMM
   REST_GPR
   ret
IPPASM AesGcmMulGcm_table2K ENDP

;
; void AesGcmAuth_table2K(Ipp8u* pHash, const Ipp8u* pSrc, int len, const Ipp8u* pPrecomputedData, const void* pParam)
;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmAuth_table2K PROC PUBLIC FRAME
      USES_GPR rsi,rdi,rbx
      USES_XMM
      COMP_ABI 5

   mov      r9, r8                     ; pointer to the fixed table (pParam)

   movdqu   xmm0, [rdi]                ; hash value
   mov      r8, rcx                    ; precomputed data pointer

ALIGN IPP_ALIGN_FACTOR
auth_loop:
   movdqu   xmm4, [rsi]       ; get src[]
   pxor     xmm0, xmm4        ; hash ^= src[]

   movd     ebx, xmm0         ; ebx = hash.0
   mov      eax, 0f0f0f0f0h
   and      eax, ebx          ; eax = 4 x 4_bits
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h   ; ebx = 4 x 4_bits (another)
   movzx    ecx, ah
   movdqa   xmm5, oword ptr [r8+1024+rcx]
   movzx    ecx, al
   movdqa   xmm4, oword ptr [r8+1024+rcx]
   shr      eax, 16
   movzx    ecx, ah
   movdqa   xmm3, oword ptr [r8+1024+rcx]
   movzx    ecx, al
   movdqa   xmm2, oword ptr [r8+1024+rcx]

   psrldq   xmm0, 4           ; shift xmm0
   movd     eax, xmm0         ; eax = hash[1]
   and      eax, 0f0f0f0f0h   ; eax = 4 x 4_bits

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (1-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (1-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (1-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (1-1)*256 + rcx]

   movd     ebx, xmm0         ; ebx = hash[1]
   shl      ebx, 4            ; another 4 x 4_bits
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 1*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 1*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 1*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 1*256 + rcx]

   psrldq   xmm0, 4
   movd     eax, xmm0            ; eax = hash[2]
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (2-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (2-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (2-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (2-1)*256 + rcx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 2*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 2*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 2*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 2*256 + rcx]

   psrldq   xmm0, 4
   movd     eax, xmm0         ; eax = hash[3]
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ (3-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ (3-1)*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ (3-1)*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ (3-1)*256 + rcx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [r8+1024+ 3*256 + rcx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [r8+1024+ 3*256 + rcx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [r8+1024+ 3*256 + rcx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [r8+1024+ 3*256 + rcx]

   movzx    ecx, bh
   pxor     xmm5, oword ptr [r8+ 3*256 + rcx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [r8+ 3*256 + rcx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [r8+ 3*256 + rcx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [r8+ 3*256 + rcx]

   movdqa   xmm0, xmm3
   pslldq   xmm3, 1
   pxor     xmm2, xmm3
   movdqa   xmm1, xmm2
   pslldq   xmm2, 1
   pxor     xmm5, xmm2
   psrldq   xmm0, 15

   movd     ecx, xmm0
   movzx    eax, word ptr [r9 + rcx*sizeof(word)]
   shl      eax, 8
   movdqa   xmm0, xmm5
   pslldq   xmm5, 1
   pxor     xmm4, xmm5
   psrldq   xmm1, 15
   movd     ecx, xmm1
   xor      ax, word ptr [r9 + rcx*sizeof(word)]
   shl      eax, 8
   psrldq   xmm0, 15
   movd     ecx, xmm0
   xor      ax, word ptr [r9 + rcx*sizeof(word)]
   movd     xmm0, eax
   pxor     xmm0, xmm4

   add      rsi, sizeof(oword)      ; advance src address
   sub      rdx, sizeof(oword)      ; decrease counter
   jnz      auth_loop               ; process next block

   movdqu   oword ptr[rdi], xmm0    ; store hash value

   REST_XMM
   REST_GPR
   ret
IPPASM AesGcmAuth_table2K ENDP

ENDIF
END
