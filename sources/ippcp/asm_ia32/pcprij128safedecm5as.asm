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
;               Rijndael-128 (AES) inverse cipher functions.
;               (It's the special free from Sbox/tables implementation)
; 
;     Content:
;        SafeDecrypt_RIJ128()
; 
;     History:
; 
;   Notes.
;   The implementation is based on compact S-box usage.
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc

IF (_IPP EQ _IPP_M5)

;;
;; transpose 16x16 martix to [dst]
;; eax,ebx,ecx,edx constins matrix rows
;;
TRANSPOSE MACRO dst:REQ
   mov   byte ptr [dst+0 ], al
   shr   eax, 8
   mov   byte ptr [dst+1 ], bl
   shr   ebx, 8
   mov   byte ptr [dst+2 ], cl
   shr   ecx, 8
   mov   byte ptr [dst+3 ], dl
   shr   edx, 8

   mov   byte ptr [dst+4 ], al
   shr   eax, 8
   mov   byte ptr [dst+5 ], bl
   shr   ebx, 8
   mov   byte ptr [dst+6 ], cl
   shr   ecx, 8
   mov   byte ptr [dst+7 ], dl
   shr   edx, 8

   mov   byte ptr [dst+8 ], al
   shr   eax, 8
   mov   byte ptr [dst+9 ], bl
   shr   ebx, 8
   mov   byte ptr [dst+10], cl
   shr   ecx, 8
   mov   byte ptr [dst+11], dl
   shr   edx, 8

   mov   byte ptr [dst+12], al
   shr   eax, 8
   mov   byte ptr [dst+13], bl
   shr   ebx, 8
   mov   byte ptr [dst+14], cl
   shr   ecx, 8
   mov   byte ptr [dst+15], dl
   shr   edx, 8
ENDM

;;
;; SubBute
;;
SBOX_ZERO MACRO inpb
   mov   al, byte ptr[esi+inpb]
ENDM

SBOX_QUAD MACRO inpb
   mov      eax, 03Fh
   and      eax, inpb                        ; x%64
   shr      inpb, 6                          ; x/64
   add      esi, eax                         ; &Sbox[x%64]

   mov      al, byte ptr[esi+64*0]
   mov      bl, byte ptr[esi+64*1]
   mov      cl, byte ptr[esi+64*2]
   mov      dl, byte ptr[esi+64*3]
   mov      byte ptr[esp+oBuffer+1*0], al
   mov      byte ptr[esp+oBuffer+1*1], bl
   mov      byte ptr[esp+oBuffer+1*2], cl
   mov      byte ptr[esp+oBuffer+1*3], dl

   mov      al, byte ptr[esp+oBuffer+inpb]
ENDM

SBOX_FULL MACRO inpb
   mov      eax, 0Fh
   and      eax, inpb                        ; x%16
   shr      inpb, 4                          ; x/16
   add      esi, eax                         ; &Sbox[x%16]

   movzx    eax, byte ptr[esi+16*15]
   movzx    ebx, byte ptr[esi+16*14]
   movzx    ecx, byte ptr[esi+16*13]
   movzx    edx, byte ptr[esi+16*12]
   push     eax
   push     ebx
   push     ecx
   push     edx

   movzx    eax, byte ptr[esi+16*11]
   movzx    ebx, byte ptr[esi+16*10]
   movzx    ecx, byte ptr[esi+16*9]
   movzx    edx, byte ptr[esi+16*8]
   push     eax
   push     ebx
   push     ecx
   push     edx

   movzx    eax, byte ptr[esi+16*7]
   movzx    ebx, byte ptr[esi+16*6]
   movzx    ecx, byte ptr[esi+16*5]
   movzx    edx, byte ptr[esi+16*4]
   push     eax
   push     ebx
   push     ecx
   push     edx

   movzx    eax, byte ptr[esi+16*3]
   movzx    ebx, byte ptr[esi+16*2]
   movzx    ecx, byte ptr[esi+16*1]
   movzx    edx, byte ptr[esi+16*0]
   push     eax
   push     ebx
   push     ecx
   push     edx

   mov      eax, dword ptr[esp+inpb*sizeof(dword)]
   add      esp, 16*sizeof(dword)
ENDM

;;
;; AddRoundKey
;;
ADD_ROUND_KEY MACRO x0:REQ, x1:REQ, x2:REQ, x3:REQ, key:REQ
   xor   x0, dword ptr[key+sizeof(dword)*0]
   xor   x1, dword ptr[key+sizeof(dword)*1]
   xor   x2, dword ptr[key+sizeof(dword)*2]
   xor   x3, dword ptr[key+sizeof(dword)*3]
ENDM

;;
;; GFMULx   x, t0,t1
;;
;; mask  = x & 0x80808080
;; mask = (mask<<1) - (mask>>7)
;;
;; x = (x<<=1) & 0xFEFEFEFE
;; x ^= msk & 0x1B1B1B1B
;;
GFMULx MACRO x:REQ, msk:REQ, t:REQ
   mov   t, x
   add   x, x              ;; mul: x = (x<<=1) & 0xFEFEFEFE
   and   t, 080808080h     ;; mask: t = x & 0x80808080
   and   x, 0FEFEFEFEh     ;;
   lea   msk, [t+t]        ;; mask: msk = (t<<1) - (t>>7)
   shr   t, 7              ;; mask:
   sub   msk, t            ;; mask:
   and   msk, 01B1B1B1Bh   ;; mul: x ^= msk & 0x1B1B1B1B
   xor   x, msk
ENDM

;;
;; MixColumn
;;
MIX_COLUMNS MACRO x0:REQ, x1:REQ, x2:REQ, x3:REQ, t0:REQ, t1:REQ
   ;; Ipp32u y0 = state[1] ^ state[2] ^ state[3];
   ;; Ipp32u y1 = state[0] ^ state[2] ^ state[3];
   ;; Ipp32u y2 = state[0] ^ state[1] ^ state[3];
   ;; Ipp32u y3 = state[0] ^ state[1] ^ state[2];
   mov   t0, x1
   xor   t0, x2
   xor   t0, x3
   mov   t1, x0
   xor   t1, x2
   xor   t1, x3
   mov   dword ptr [esp+oBuffer+sizeof(dword)*0], t0
   mov   dword ptr [esp+oBuffer+sizeof(dword)*1], t1
   mov   t0, x0
   xor   t0, x1
   xor   t0, x3
   mov   t1, x0
   xor   t1, x1
   xor   t1, x2
   mov   dword ptr [esp+oBuffer+sizeof(dword)*2], t0
   mov   dword ptr [esp+oBuffer+sizeof(dword)*3], t1

   ;; state[0] = xtime4(state[0]);
   ;; state[1] = xtime4(state[1]);
   ;; state[2] = xtime4(state[2]);
   ;; state[3] = xtime4(state[3]);
   GFMULx   x0, t0,t1
   GFMULx   x1, t0,t1
   GFMULx   x2, t0,t1
   GFMULx   x3, t0,t1

   ;; y0 ^= state[0] ^ state[1];
   ;; y1 ^= state[1] ^ state[2];
   ;; y2 ^= state[2] ^ state[3];
   ;; y3 ^= state[3] ^ state[0];
   mov   t0, dword ptr [esp+oBuffer+sizeof(dword)*0]
   mov   t1, dword ptr [esp+oBuffer+sizeof(dword)*1]
   xor   t0, x0
   xor   t1, x1
   xor   t0, x1
   xor   t1, x2
   mov   dword ptr [esp+oBuffer+sizeof(dword)*0], t0
   mov   dword ptr [esp+oBuffer+sizeof(dword)*1], t1

   mov   t0, dword ptr [esp+oBuffer+sizeof(dword)*2]
   mov   t1, dword ptr [esp+oBuffer+sizeof(dword)*3]
   xor   t0, x2
   xor   t1, x3
   xor   t0, x3
   xor   t1, x0
   mov   dword ptr [esp+oBuffer+sizeof(dword)*2], t0
   mov   dword ptr [esp+oBuffer+sizeof(dword)*3], t1

   ;; t02 = state[0] ^ state[2];
   ;; t13 = state[1] ^ state[3];
   ;; t02 = xtime4(t02);
   ;; t13 = xtime4(t13);
   mov      t0, x0
   mov      t1, x1
   xor      t0, x2
   xor      t1, x3
   GFMULx   t0, x0,x1   ;; t02
   GFMULx   t1, x0,x1   ;; t13

   ;; t0123 = t02^t13;
   ;; t0123 = xtime4(t0123);
   mov      x0, t0
   xor      x0, t1
   GFMULx   x0, x1,x2

   ;; state[0] = y0 ^t02 ^t0123;
   ;; state[1] = y1 ^t13 ^t0123;
   ;; state[2] = y2 ^t02 ^t0123;
   ;; state[3] = y3 ^t13 ^t0123;
   xor   t0, x0   ;; t02^t0123
   xor   t1, x0   ;; t13^t0123
   mov   x0, dword ptr [esp+oBuffer+sizeof(dword)*0]
   mov   x1, dword ptr [esp+oBuffer+sizeof(dword)*1]
   mov   x2, dword ptr [esp+oBuffer+sizeof(dword)*2]
   mov   x3, dword ptr [esp+oBuffer+sizeof(dword)*3]
   xor   x0, t0
   xor   x1, t1
   xor   x2, t0
   xor   x3, t1
ENDM

IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

IPPASM Safe2Decrypt_RIJ128 PROC NEAR C PUBLIC \
USES esi edi ebx,\
pInp:PTR BYTE,\      ; input buffer
pOut:PTR BYTE,\      ; outpu buffer
nrounds:DWORD,\      ; number of rounds
pRK:PTR BYTE,\       ; round keys
pSbox:PTR BYTE       ; S-box

;; stack
oState   = 0                        ; 4*dword state
oBuffer  = oState+sizeof(dword)*4   ; 4*dword buffer
oSbox    = oBuffer+sizeof(dword)*4  ; S-box address
oSaveEBP = oSbox+sizeof(dword)      ; save EBP slot

stackSize = oSaveEBP+sizeof(dword)  ; stack size

   sub      esp, stackSize    ; state on the stack

   mov      edi, nrounds

   ; read input block and transpose one
   mov      esi, pInp
   mov      eax, dword ptr[esi+sizeof(dword)*0]
   mov      ebx, dword ptr[esi+sizeof(dword)*1]
   mov      ecx, dword ptr[esi+sizeof(dword)*2]
   mov      edx, dword ptr[esi+sizeof(dword)*3]
   TRANSPOSE <esp+oState>

   shl      edi, 4      ; nrounds*16
   mov      esi, pRK
   add      esi, edi

   ; read input block
   mov      eax, dword ptr[esp+oState+sizeof(dword)*0]
   mov      ebx, dword ptr[esp+oState+sizeof(dword)*1]
   mov      ecx, dword ptr[esp+oState+sizeof(dword)*2]
   mov      edx, dword ptr[esp+oState+sizeof(dword)*3]

   ; add round key
   ADD_ROUND_KEY  eax,ebx,ecx,edx, esi ; add round key
   sub      esi, sizeof(byte)*16
   mov      pRK, esi
   mov      dword ptr[esp+oState+sizeof(dword)*0], eax
   mov      dword ptr[esp+oState+sizeof(dword)*1], ebx
   mov      dword ptr[esp+oState+sizeof(dword)*2], ecx
   mov      dword ptr[esp+oState+sizeof(dword)*3], edx

   dec      nrounds
   mov      esi, pSbox
   mov      dword ptr[esp+oSbox], esi
   mov      dword ptr[esp+oSaveEBP], ebp

   ;; regular rounds
next_aes_round:

   ;; shift rows
   ror      ebx, 24
   ror      ecx, 16
   ror      edx, 8
   mov      dword ptr[esp+oState+sizeof(dword)*0], eax
   mov      dword ptr[esp+oState+sizeof(dword)*1], ebx
   mov      dword ptr[esp+oState+sizeof(dword)*2], ecx
   mov      dword ptr[esp+oState+sizeof(dword)*3], edx

   ;; sub bytes
   xor      ebp, ebp
sub_byte_loop:
   mov      esi, dword ptr[esp+oSbox]        ; Sbox address
   movzx    edi, byte ptr[esp+oState+ebp]    ; x input byte
   add      ebp, 1
   SBOX_FULL edi
   ;;SBOX_QUAD edi
   ;;SBOX_ZERO edi
   mov      byte ptr[esp+oState+ebp-1], al
   cmp      ebp, 16
   jl       sub_byte_loop

   ;; add round key
   mov      ebp, dword ptr[esp+oSaveEBP]
   mov      esi, pRK

   mov      eax, dword ptr[esp+oState+sizeof(dword)*0]
   mov      ebx, dword ptr[esp+oState+sizeof(dword)*1]
   mov      ecx, dword ptr[esp+oState+sizeof(dword)*2]
   mov      edx, dword ptr[esp+oState+sizeof(dword)*3]
   ADD_ROUND_KEY  eax,ebx,ecx,edx, esi    ; add round key
   sub      esi, sizeof(byte)*16
   mov      pRK, esi

   ;; mix columns
   MIX_COLUMNS eax,ebx,ecx,edx, esi, edi  ; mix columns

   sub      nrounds, 1
   jne      next_aes_round

   ;; irregular round: shift rows
   ror      ebx, 24
   ror      ecx, 16
   ror      edx, 8
   mov      dword ptr[esp+oState+sizeof(dword)*0], eax
   mov      dword ptr[esp+oState+sizeof(dword)*1], ebx
   mov      dword ptr[esp+oState+sizeof(dword)*2], ecx
   mov      dword ptr[esp+oState+sizeof(dword)*3], edx

   ;; irregular round: sub bytes
   xor      ebp, ebp
sub_byte_irr_loop:
   mov      esi, dword ptr[esp+oSbox]
   movzx    edi, byte ptr[esp+oState+ebp]    ; x input byte
   add      ebp, 1
   SBOX_FULL edi
   ;;SBOX_QUAD edi
   ;;SBOX_ZERO edi
   mov      byte ptr[esp+oState+ebp-1], al
   cmp      ebp, 16
   jl       sub_byte_irr_loop

   ;; irregular round: add round key
   mov      ebp, dword ptr[esp+oSaveEBP]
   mov      esi, pRK

   mov      eax, dword ptr[esp+oState+sizeof(dword)*0]
   mov      ebx, dword ptr[esp+oState+sizeof(dword)*1]
   mov      ecx, dword ptr[esp+oState+sizeof(dword)*2]
   mov      edx, dword ptr[esp+oState+sizeof(dword)*3]
   ADD_ROUND_KEY  eax,ebx,ecx,edx, esi    ; add round key

   mov      edi, pOut
   TRANSPOSE edi

   add      esp, stackSize ; remove state
   ret
IPPASM Safe2Decrypt_RIJ128 ENDP


ENDIF    ; _IPP EQ _IPP_M5
END
