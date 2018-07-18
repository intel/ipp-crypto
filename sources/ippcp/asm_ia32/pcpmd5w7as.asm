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
;               Message block processing according to MD5
;              (derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm)
; 
;     Content:
;        UpdateMD5
; 
;

.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc
INCLUDE pcpvariant.inc

IF (_ENABLE_ALG_MD5_)
IF _IPP GE _IPP_M5

;;
;; Magic functions defined in RFC 1321
;;
MAGIC_F MACRO F:REQ, X:REQ,Y:REQ,Z:REQ ;; ((Z) ^ ((X) & ((Y) ^ (Z))))
   mov      F,Z
   xor      F,Y
   and      F,X
   xor      F,Z
ENDM

MAGIC_G MACRO F:REQ, X:REQ,Y:REQ,Z:REQ ;; F((Z),(X),(Y))
   MAGIC_F  F,Z,X,Y
ENDM

MAGIC_H MACRO F:REQ, X:REQ,Y:REQ,Z:REQ ;; ((X) ^ (Y) ^ (Z))
   mov      F,Z
   xor      F,Y
   xor      F,X
ENDM

MAGIC_I MACRO F:REQ, X:REQ,Y:REQ,Z:REQ ;; ((Y) ^ ((X) | ~(Z)))
   mov      F,Z
   not      F
   or       F,X
   xor      F,Y
ENDM


;;
;; single MD5 step
;;
;; A = B +ROL32((A +MAGIC(B,C,D) +data +const), nrot)
;;
MD5_STEP MACRO MAGIC_FUN:REQ, A:REQ,B:REQ,C:REQ,D:REQ, FUN:REQ, data:REQ, MD5const:REQ, nrot:REQ
   add         A,MD5const
   add         A,[data]
   MAGIC_FUN   FUN, B,C,D
   add         A,FUN
   rol         A,nrot
   add         A,B
ENDM

MD5_RND MACRO MAGIC_FUN:REQ, A:REQ,B:REQ,C:REQ,D:REQ, FUN:REQ, MD5const:REQ, nrot:REQ, nextdata
   MAGIC_FUN   FUN, B,C,D
   lea         A,[A+ebp+MD5const]
   ifnb <nextdata>
      mov         ebp,[nextdata]
   endif
;  MAGIC_FUN   FUN, B,C,D
   add         A,FUN
   rol         A,nrot
   add         A,B
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)


;*****************************************************************************************
;* Purpose:    Update internal digest according to message block
;*
;* void UpdateMD5(DigestMD5digest, const Ipp32u* mblk, int mlen, const void* pParam)
;*
;*****************************************************************************************

;;
;; MD5 left rotations (number of bits)
;;
rot11 =  7
rot12 =  12
rot13 =  17
rot14 =  22
rot21 =  5
rot22 =  9
rot23 =  14
rot24 =  20
rot31 =  4
rot32 =  11
rot33 =  16
rot34 =  23
rot41 =  6
rot42 =  10
rot43 =  15
rot44 =  21

;;
;; Lib = W7
;;
;; Caller = ippsSHA1Update
;; Caller = ippsSHA1Final
;; Caller = ippsSHA1MessageDigest
;;
;; Caller = ippsHMACSHA1Update
;; Caller = ippsHMACSHA1Final
;; Caller = ippsHMACSHA1MessageDigest
;;

ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateMD5 PROC NEAR C PUBLIC \
      USES esi edi ebx ebp,\
      digest:   PTR DWORD,\    ; digest address
      mblk:     PTR BYTE,\     ; buffer address
      mlen:     DWORD,\        ; buffer length
      pParam:   PTR DWORD      ; dummy parameter

MBS_MD5  equ   (64)
   mov      eax, pParam       ; due to bug in ml12 - dummy instruction

   mov      edi,digest        ; digest address
   mov      esi,mblk          ; source data address
   mov      eax,mlen          ; data length

   sub      esp,2*sizeof(dword)
   mov      [esp+0*sizeof(dword)],edi  ; save digest address

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

md5_block_loop:
   mov      [esp+1*sizeof(dword)],eax  ; save data length

   mov      ebp,[esi+ 0*4]             ; preload data

;;
;; init A, B, C, D by the internal digest
;;
   mov      eax,[edi+0*4]     ; eax = digest[0] (A)
   mov      ebx,[edi+1*4]     ; ebx = digest[1] (B)
   mov      ecx,[edi+2*4]     ; ecx = digest[2] (C)
   mov      edx,[edi+3*4]     ; edx = digest[3] (D)

;;
;; perform 0-63 steps
;;
;;          MAGIC    A,  B,  C,  D,   FUN,    cnt,     nrot,  pNextData (ebp)
;;          ------------------------------------------------------------
   MD5_RND MAGIC_F, eax,ebx,ecx,edx, edi, 0d76aa478h, rot11, <esi+ 1*4>
   MD5_RND MAGIC_F, edx,eax,ebx,ecx, edi, 0e8c7b756h, rot12, <esi+ 2*4>
   MD5_RND MAGIC_F, ecx,edx,eax,ebx, edi, 0242070dbh, rot13, <esi+ 3*4>
   MD5_RND MAGIC_F, ebx,ecx,edx,eax, edi, 0c1bdceeeh, rot14, <esi+ 4*4>
   MD5_RND MAGIC_F, eax,ebx,ecx,edx, edi, 0f57c0fafh, rot11, <esi+ 5*4>
   MD5_RND MAGIC_F, edx,eax,ebx,ecx, edi, 04787c62ah, rot12, <esi+ 6*4>
   MD5_RND MAGIC_F, ecx,edx,eax,ebx, edi, 0a8304613h, rot13, <esi+ 7*4>
   MD5_RND MAGIC_F, ebx,ecx,edx,eax, edi, 0fd469501h, rot14, <esi+ 8*4>
   MD5_RND MAGIC_F, eax,ebx,ecx,edx, edi, 0698098d8h, rot11, <esi+ 9*4>
   MD5_RND MAGIC_F, edx,eax,ebx,ecx, edi, 08b44f7afh, rot12, <esi+10*4>
   MD5_RND MAGIC_F, ecx,edx,eax,ebx, edi, 0ffff5bb1h, rot13, <esi+11*4>
   MD5_RND MAGIC_F, ebx,ecx,edx,eax, edi, 0895cd7beh, rot14, <esi+12*4>
   MD5_RND MAGIC_F, eax,ebx,ecx,edx, edi, 06b901122h, rot11, <esi+13*4>
   MD5_RND MAGIC_F, edx,eax,ebx,ecx, edi, 0fd987193h, rot12, <esi+14*4>
   MD5_RND MAGIC_F, ecx,edx,eax,ebx, edi, 0a679438eh, rot13, <esi+15*4>
   MD5_RND MAGIC_F, ebx,ecx,edx,eax, edi, 049b40821h, rot14, <esi+ 1*4>

   MD5_RND MAGIC_G, eax,ebx,ecx,edx, edi, 0f61e2562h, rot21, <esi+ 6*4>
   MD5_RND MAGIC_G, edx,eax,ebx,ecx, edi, 0c040b340h, rot22, <esi+11*4>
   MD5_RND MAGIC_G, ecx,edx,eax,ebx, edi, 0265e5a51h, rot23, <esi+ 0*4>
   MD5_RND MAGIC_G, ebx,ecx,edx,eax, edi, 0e9b6c7aah, rot24, <esi+ 5*4>
   MD5_RND MAGIC_G, eax,ebx,ecx,edx, edi, 0d62f105dh, rot21, <esi+10*4>
   MD5_RND MAGIC_G, edx,eax,ebx,ecx, edi, 002441453h, rot22, <esi+15*4>
   MD5_RND MAGIC_G, ecx,edx,eax,ebx, edi, 0d8a1e681h, rot23, <esi+ 4*4>
   MD5_RND MAGIC_G, ebx,ecx,edx,eax, edi, 0e7d3fbc8h, rot24, <esi+ 9*4>
   MD5_RND MAGIC_G, eax,ebx,ecx,edx, edi, 021e1cde6h, rot21, <esi+14*4>
   MD5_RND MAGIC_G, edx,eax,ebx,ecx, edi, 0c33707d6h, rot22, <esi+ 3*4>
   MD5_RND MAGIC_G, ecx,edx,eax,ebx, edi, 0f4d50d87h, rot23, <esi+ 8*4>
   MD5_RND MAGIC_G, ebx,ecx,edx,eax, edi, 0455a14edh, rot24, <esi+13*4>
   MD5_RND MAGIC_G, eax,ebx,ecx,edx, edi, 0a9e3e905h, rot21, <esi+ 2*4>
   MD5_RND MAGIC_G, edx,eax,ebx,ecx, edi, 0fcefa3f8h, rot22, <esi+ 7*4>
   MD5_RND MAGIC_G, ecx,edx,eax,ebx, edi, 0676f02d9h, rot23, <esi+12*4>
   MD5_RND MAGIC_G, ebx,ecx,edx,eax, edi, 08d2a4c8ah, rot24, <esi+ 5*4>

   MD5_RND MAGIC_H, eax,ebx,ecx,edx, edi, 0fffa3942h, rot31, <esi+ 8*4>
   MD5_RND MAGIC_H, edx,eax,ebx,ecx, edi, 08771f681h, rot32, <esi+11*4>
   MD5_RND MAGIC_H, ecx,edx,eax,ebx, edi, 06d9d6122h, rot33, <esi+14*4>
   MD5_RND MAGIC_H, ebx,ecx,edx,eax, edi, 0fde5380ch, rot34, <esi+ 1*4>
   MD5_RND MAGIC_H, eax,ebx,ecx,edx, edi, 0a4beea44h, rot31, <esi+ 4*4>
   MD5_RND MAGIC_H, edx,eax,ebx,ecx, edi, 04bdecfa9h, rot32, <esi+ 7*4>
   MD5_RND MAGIC_H, ecx,edx,eax,ebx, edi, 0f6bb4b60h, rot33, <esi+10*4>
   MD5_RND MAGIC_H, ebx,ecx,edx,eax, edi, 0bebfbc70h, rot34, <esi+13*4>
   MD5_RND MAGIC_H, eax,ebx,ecx,edx, edi, 0289b7ec6h, rot31, <esi+ 0*4>
   MD5_RND MAGIC_H, edx,eax,ebx,ecx, edi, 0eaa127fah, rot32, <esi+ 3*4>
   MD5_RND MAGIC_H, ecx,edx,eax,ebx, edi, 0d4ef3085h, rot33, <esi+ 6*4>
   MD5_RND MAGIC_H, ebx,ecx,edx,eax, edi, 004881d05h, rot34, <esi+ 9*4>
   MD5_RND MAGIC_H, eax,ebx,ecx,edx, edi, 0d9d4d039h, rot31, <esi+12*4>
   MD5_RND MAGIC_H, edx,eax,ebx,ecx, edi, 0e6db99e5h, rot32, <esi+15*4>
   MD5_RND MAGIC_H, ecx,edx,eax,ebx, edi, 01fa27cf8h, rot33, <esi+ 2*4>
   MD5_RND MAGIC_H, ebx,ecx,edx,eax, edi, 0c4ac5665h, rot34, <esi+ 0*4>

   MD5_RND MAGIC_I, eax,ebx,ecx,edx, edi, 0f4292244h, rot41, <esi+ 7*4>
   MD5_RND MAGIC_I, edx,eax,ebx,ecx, edi, 0432aff97h, rot42, <esi+14*4>
   MD5_RND MAGIC_I, ecx,edx,eax,ebx, edi, 0ab9423a7h, rot43, <esi+ 5*4>
   MD5_RND MAGIC_I, ebx,ecx,edx,eax, edi, 0fc93a039h, rot44, <esi+12*4>
   MD5_RND MAGIC_I, eax,ebx,ecx,edx, edi, 0655b59c3h, rot41, <esi+ 3*4>
   MD5_RND MAGIC_I, edx,eax,ebx,ecx, edi, 08f0ccc92h, rot42, <esi+10*4>
   MD5_RND MAGIC_I, ecx,edx,eax,ebx, edi, 0ffeff47dh, rot43, <esi+ 1*4>
   MD5_RND MAGIC_I, ebx,ecx,edx,eax, edi, 085845dd1h, rot44, <esi+ 8*4>
   MD5_RND MAGIC_I, eax,ebx,ecx,edx, edi, 06fa87e4fh, rot41, <esi+15*4>
   MD5_RND MAGIC_I, edx,eax,ebx,ecx, edi, 0fe2ce6e0h, rot42, <esi+ 6*4>
   MD5_RND MAGIC_I, ecx,edx,eax,ebx, edi, 0a3014314h, rot43, <esi+13*4>
   MD5_RND MAGIC_I, ebx,ecx,edx,eax, edi, 04e0811a1h, rot44, <esi+ 4*4>
   MD5_RND MAGIC_I, eax,ebx,ecx,edx, edi, 0f7537e82h, rot41, <esi+11*4>
   MD5_RND MAGIC_I, edx,eax,ebx,ecx, edi, 0bd3af235h, rot42, <esi+ 2*4>
   MD5_RND MAGIC_I, ecx,edx,eax,ebx, edi, 02ad7d2bbh, rot43, <esi+ 9*4>
   MD5_RND MAGIC_I, ebx,ecx,edx,eax, edi, 0eb86d391h, rot44, <esp>

;;
;; update digest
;;
   add      [ebp+0*4],eax     ; advance digest
   mov      eax, dword ptr[esp+1*sizeof(dword)]
   add      [ebp+1*4],ebx
   add      [ebp+2*4],ecx
   add      [ebp+3*4],edx

   mov      edi, ebp          ; restore hash address
   add      esi, MBS_MD5
   sub      eax, MBS_MD5
   jg       md5_block_loop

   add      esp,2*sizeof(dword)
   ret
IPPASM UpdateMD5 ENDP

ENDIF
ENDIF
END
