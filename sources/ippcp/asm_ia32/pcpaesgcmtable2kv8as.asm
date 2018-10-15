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

.686P
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc


IFDEF IPP_PIC
LD_ADDR MACRO reg:REQ, addr:REQ
LOCAL LABEL
        call     LABEL
LABEL:  pop      reg
        sub      reg, LABEL-addr
ENDM
ELSE
LD_ADDR MACRO reg:REQ, addr:REQ
        lea      reg, addr
ENDM
ENDIF

IF _IPP GE _IPP_V8

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

;
; getAesGcmConst_table_ct provides c-e-t access to pre-computed Ipp16u AesGcmConst_table[256]
;
;  input:
;  edx: address of the AesGcmConst_table
;  ecx: index in the table
;
;  output:
;  eax
;
;  register  ecx destoyed
;  registers mmx2, mmx3, mmx6, and mmx7 destoyed
;
ALIGN IPP_ALIGN_FACTOR
_CONST_DATA:
_INIT_IDX   DW    000h,001h,002h,003h,004h,005h,006h,007h   ;; initial search inx = {0:1:2:3:4:5:6:7}
_INCR_IDX   DW    008h,008h,008h,008h,008h,008h,008h,008h   ;; index increment = {8:8:8:8:8:8:8:8}

INIT_IDX equ [ebx+(_INIT_IDX - _CONST_DATA)]
INCR_IDX equ [ebx+(_INCR_IDX - _CONST_DATA)]

ALIGN IPP_ALIGN_FACTOR
IPPASM getAesGcmConst_table_ct PROC NEAR PRIVATE
   push     ebx
   LD_ADDR  ebx, _CONST_DATA

   pxor     xmm2, xmm2                 ;; accumulator xmm2 = 0

   mov      eax, ecx                   ;; broadcast inx into dword
   shl      ecx, 16
   or       ecx, eax
   movd     xmm3, ecx
   pshufd   xmm3, xmm3, 00b            ;; search index xmm3 = broadcast(idx)

   movdqa   xmm6, xmmword ptr INIT_IDX ;; current indexes

   xor      eax, eax
ALIGN IPP_ALIGN_FACTOR
search_loop:
   movdqa   xmm7, xmm6                             ;; copy current indexes
   paddw    xmm6, xmmword ptr INCR_IDX             ;; advance current indexes

   pcmpeqw  xmm7, xmm3                             ;; selection mask
   pand     xmm7, xmmword ptr[edx+eax*sizeof(word)];; mask data

   add      eax, 8
   cmp      eax, 256

   por      xmm2, xmm7                             ;; and accumulate
   jl       search_loop

   movdqa   xmm3, xmm2                 ;; pack result in qword
   psrldq   xmm2, sizeof(xmmword)/2
   por      xmm2, xmm3
   movdqa   xmm3, xmm2                 ;; pack result in dword
   psrldq   xmm2, sizeof(xmmword)/4
   por      xmm2, xmm3
   movd     eax, xmm2

   pop      ebx

   and      ecx, 3                     ;; select tbl[idx] value
   shl      ecx, 4                     ;; rcx *=16 = sizeof(word)*8
   shr      eax, cl
   ret
IPPASM getAesGcmConst_table_ct ENDP

;
; void AesGcmMulGcm_table2K(Ipp8u* pHash, const Ipp8u* pPrecomputedData, , const void* pParam))
;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmMulGcm_table2K PROC NEAR C PUBLIC \
      USES     esi edi ebx,\
      pHash:   PTR BYTE,\
      pMulTbl: PTR BYTE,\
      pParam:  PTR WORD

   mov      edi, pHash
   movdqu   xmm0, [edi]                ; hash value

   mov      esi, pMulTbl
   mov      edx, pParam                ; pointer to the fixed table

   movd     ebx, xmm0         ; ebx = hash.0
   mov      eax, 0f0f0f0f0h
   and      eax, ebx          ; eax = 4 x 4_bits
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h   ; ebx = 4 x 4_bits (another)
   movzx    ecx, ah
   movdqa   xmm5, oword ptr [esi+1024+ecx]
   movzx    ecx, al
   movdqa   xmm4, oword ptr [esi+1024+ecx]
   shr      eax, 16
   movzx    ecx, ah
   movdqa   xmm3, oword ptr [esi+1024+ecx]
   movzx    ecx, al
   movdqa   xmm2, oword ptr [esi+1024+ecx]

   psrldq   xmm0, 4           ; shift xmm0
   movd     eax, xmm0         ; eax = hash[1]
   and      eax, 0f0f0f0f0h   ; eax = 4 x 4_bits

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 0*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 0*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 0*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 0*256 + ecx]

   movd     ebx, xmm0         ; ebx = hash[1]
   shl      ebx, 4            ; another 4 x 4_bits
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 1*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 1*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 1*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 1*256 + ecx]
   psrldq   xmm0, 4

   movd     eax, xmm0            ; eax = hash.2
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 1*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 1*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 1*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 1*256 + ecx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 2*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 2*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 2*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 2*256 + ecx]

   psrldq   xmm0, 4
   movd     eax, xmm0         ; eax = hash.3
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 2*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 2*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 2*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 2*256 + ecx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 3*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 3*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 3*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 3*256 + ecx]

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 3*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 3*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 3*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 3*256 + ecx]

   movdqa   xmm0, xmm3
   pslldq   xmm3, 1
   pxor     xmm2, xmm3
   movdqa   xmm1, xmm2
   pslldq   xmm2, 1
   pxor     xmm5, xmm2

   psrldq   xmm0, 15
   movd     ecx, xmm0
   CALLASM  getAesGcmConst_table_ct ;;movzx    eax, word ptr [edx + ecx*sizeof(word)]
   shl      eax, 8

   movdqa   xmm0, xmm5
   pslldq   xmm5, 1
   pxor     xmm4, xmm5

   psrldq   xmm1, 15
   movd     ecx, xmm1
   mov      ebx, eax                ;;xor      ax, word ptr [edx + ecx*sizeof(word)]
   CALLASM  getAesGcmConst_table_ct ;;
   xor      eax, ebx                ;;
   shl      eax, 8

   psrldq   xmm0, 15
   movd     ecx, xmm0
   mov      ebx, eax                ;;xor      ax, word ptr [edx + ecx*sizeof(word)]
   CALLASM  getAesGcmConst_table_ct ;;
   xor      eax, ebx                ;;

   movd     xmm0, eax
   pxor     xmm0, xmm4

   movdqu   oword ptr[edi], xmm0    ; store hash value

   ret
IPPASM AesGcmMulGcm_table2K ENDP

;
; void AesGcmAuth_table2K(Ipp8u* pHash, const Ipp8u* pSrc, int len, const Ipp8u* pPrecomputedData, const void* pParam)
;
ALIGN IPP_ALIGN_FACTOR
IPPASM AesGcmAuth_table2K PROC NEAR C PUBLIC \
      USES     esi edi ebx,\
      pHash:   PTR BYTE,\
      pSrc:    PTR BYTE,\
      len:     DWORD,\
      pMulTbl: PTR BYTE,\
      pParam:  PTR WORD

   mov      edi, pHash
   movdqu   xmm0, [edi]                ; hash value

   mov      esi, pMulTbl
   mov      edi, pSrc

   mov      edx, pParam                ; pointer to the fixed table

ALIGN IPP_ALIGN_FACTOR
auth_loop:
   movdqu   xmm4, [edi]       ; get src[]
   pxor     xmm0, xmm4        ; hash ^= src[]

   movd     ebx, xmm0         ; ebx = hash.0
   mov      eax, 0f0f0f0f0h
   and      eax, ebx          ; eax = 4 x 4_bits
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h   ; ebx = 4 x 4_bits (another)
   movzx    ecx, ah
   movdqa   xmm5, oword ptr [esi+1024+ecx]
   movzx    ecx, al
   movdqa   xmm4, oword ptr [esi+1024+ecx]
   shr      eax, 16
   movzx    ecx, ah
   movdqa   xmm3, oword ptr [esi+1024+ecx]
   movzx    ecx, al
   movdqa   xmm2, oword ptr [esi+1024+ecx]

   psrldq   xmm0, 4           ; shift xmm0
   movd     eax, xmm0         ; eax = hash[1]
   and      eax, 0f0f0f0f0h   ; eax = 4 x 4_bits

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 0*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 0*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 0*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 0*256 + ecx]

   movd     ebx, xmm0         ; ebx = hash[1]
   shl      ebx, 4            ; another 4 x 4_bits
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 1*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 1*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 1*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 1*256 + ecx]

   psrldq   xmm0, 4
   movd     eax, xmm0            ; eax = hash[2]
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 1*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 1*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 1*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 1*256 + ecx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 2*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 2*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 2*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 2*256 + ecx]

   psrldq   xmm0, 4
   movd     eax, xmm0         ; eax = hash[3]
   and      eax, 0f0f0f0f0h

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 2*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 2*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 2*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 2*256 + ecx]

   movd     ebx, xmm0
   shl      ebx, 4
   and      ebx, 0f0f0f0f0h

   movzx    ecx, ah
   pxor     xmm5, oword ptr [esi+1024+ 3*256 + ecx]
   movzx    ecx, al
   pxor     xmm4, oword ptr [esi+1024+ 3*256 + ecx]
   shr      eax, 16
   movzx    ecx, ah
   pxor     xmm3, oword ptr [esi+1024+ 3*256 + ecx]
   movzx    ecx, al
   pxor     xmm2, oword ptr [esi+1024+ 3*256 + ecx]

   movzx    ecx, bh
   pxor     xmm5, oword ptr [esi+ 3*256 + ecx]
   movzx    ecx, bl
   pxor     xmm4, oword ptr [esi+ 3*256 + ecx]
   shr      ebx, 16
   movzx    ecx, bh
   pxor     xmm3, oword ptr [esi+ 3*256 + ecx]
   movzx    ecx, bl
   pxor     xmm2, oword ptr [esi+ 3*256 + ecx]

   movdqa   xmm0, xmm3
   pslldq   xmm3, 1
   pxor     xmm2, xmm3
   movdqa   xmm1, xmm2
   pslldq   xmm2, 1
   pxor     xmm5, xmm2
   psrldq   xmm0, 15

   movd     ecx, xmm0
   CALLASM  getAesGcmConst_table_ct ;;movzx    eax, word ptr [edx + ecx*sizeof(word)]
   shl      eax, 8

   movdqa   xmm0, xmm5
   pslldq   xmm5, 1
   pxor     xmm4, xmm5

   psrldq   xmm1, 15
   movd     ecx, xmm1
   mov      ebx, eax                ;;xor      ax, word ptr [edx + ecx*sizeof(word)]
   CALLASM  getAesGcmConst_table_ct ;;
   xor      eax, ebx                ;;
   shl      eax, 8

   psrldq   xmm0, 15
   movd     ecx, xmm0
   mov      ebx, eax                ;;xor      ax, word ptr [edx + ecx*sizeof(word)]
   CALLASM  getAesGcmConst_table_ct ;;
   xor      eax, ebx                ;;

   movd     xmm0, eax
   pxor     xmm0, xmm4

   add      edi, sizeof(oword)      ; advance src address
   sub      len, sizeof(oword)      ; decrease counter
   jnz      auth_loop               ; process next block

   mov      edi, pHash
   movdqu   oword ptr[edi], xmm0    ; store hash value

   ret
IPPASM AesGcmAuth_table2K ENDP

ENDIF
END
