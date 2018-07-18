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
;               Message block processing according to SHA-256
; 
;     Content:
;        UpdateSHA256ni
; 
;
.686P
.387
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc
INCLUDE pcpvariant.inc

IF (_ENABLE_ALG_SHA256_)
IF (_SHA_NI_ENABLING_ EQ _FEATURE_ON_) OR (_SHA_NI_ENABLING_ EQ _FEATURE_TICKTOCK_)

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



IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR
CODE_DATA:
PSHUFFLE_BYTE_FLIP_MASK \
      DB     3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12

ALIGN IPP_ALIGN_FACTOR
;*****************************************************************************************
;* Purpose:     Update internal digest according to message block
;*
;* void UpdateSHA256ni(DigestSHA256 digest, const Ipp8u* msg, int mlen, const Ipp32u K_256[])
;*
;*****************************************************************************************

IFNDEF _VXWORKS

IPPASM UpdateSHA256ni PROC NEAR C PUBLIC \
USES  esi edi ebx,\
pDigest:PTR DWORD,\  ; pointer to the in/out digest
pMsg:   PTR BYTE,\   ; pointer to the inp message
msgLen: DWORD,\      ; message length
pTbl:   PTR DWORD    ; pointer to SHA256 table of constants

MBS_SHA256  equ   (64)  ; SHA-1 message block length (bytes)

HASH_PTR equ   edi   ; 1st arg
MSG_PTR  equ   esi   ; 2nd arg
MSG_LEN  equ   edx   ; 3rd arg
K256_PTR equ   ebx   ; 4rd arg

MSG      equ   xmm0
STATE0   equ   xmm1
STATE1   equ   xmm2
MSGTMP0  equ   xmm3
MSGTMP1  equ   xmm4
MSGTMP2  equ   xmm5
MSGTMP3  equ   xmm6
MSGTMP4  equ   xmm7

;
; stack frame
;
mask_save   equ   eax
abef_save   equ   eax+sizeof(oword)
cdgh_save   equ   eax+sizeof(oword)*2
frame_size  equ   sizeof(oword)+sizeof(oword)+sizeof(oword)

   sub      esp, (frame_size+16)
   lea      eax, [esp+16]
   and      eax, -16

   mov      MSG_LEN, msgLen   ; message length
   test     MSG_LEN, MSG_LEN
   jz       quit

   mov      HASH_PTR, pDigest
   mov      MSG_PTR, pMsg
   mov      K256_PTR, pTbl

   ;; load input hash value, reorder these appropriately
   movdqu   STATE0, oword ptr[HASH_PTR+0*sizeof(oword)]
   movdqu   STATE1, oword ptr[HASH_PTR+1*sizeof(oword)]

   pshufd   STATE0,  STATE0,  0B1h  ; CDAB
   pshufd   STATE1,  STATE1,  01Bh  ; EFGH
   movdqa   MSGTMP4, STATE0
   palignr  STATE0,  STATE1,  8     ; ABEF
   pblendw  STATE1,  MSGTMP4, 0F0h  ; CDGH

   ;; copy byte_flip_mask to stack
   mov      ecx, 000010203h            ;; DB     3,2,1,0, 7,6,5,4, 11,10,9,8, 15,14,13,12
   mov      dword ptr[mask_save], ecx
   mov      ecx, 004050607h
   mov      dword ptr[mask_save+1*sizeof(dword)], ecx
   mov      ecx, 008090a0bh
   mov      dword ptr[mask_save+2*sizeof(dword)], ecx
   mov      ecx, 00c0d0e0fh
   mov      dword ptr[mask_save+3*sizeof(dword)], ecx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sha256_block_loop:
   movdqa   oword ptr[abef_save], STATE0 ; save for addition after rounds
   movdqa   oword ptr[cdgh_save], STATE1

   ;; rounds 0-3
   movdqu      MSG, oword ptr[MSG_PTR + 0*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP0, MSG
   paddd       MSG, oword ptr[K256_PTR + 0*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1

   ;; rounds 4-7
   movdqu      MSG, oword ptr[MSG_PTR + 1*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP1, MSG
   paddd       MSG, oword ptr[K256_PTR + 1*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 8-11
   movdqu      MSG, oword ptr[MSG_PTR + 2*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP2, MSG
   paddd       MSG, oword ptr[K256_PTR + 2*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 12-15
   movdqu      MSG, oword ptr[MSG_PTR + 3*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP3, MSG
   paddd       MSG, oword ptr[K256_PTR + 3*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP2, MSGTMP3
   ;; rounds 16-19
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 4*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 20-23
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 5*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 24-27
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 6*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 28-31
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 7*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP2, MSGTMP3

   ;; rounds 32-35
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 8*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 36-39
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 9*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 40-43
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 10*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 44-47
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 11*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP2, MSGTMP3

   ;; rounds 48-51
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 12*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1
   sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 52-55
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 13*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1

   ;; rounds 56-59
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 14*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1

   ;; rounds 60-63
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 15*sizeof(oword)]
   sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   sha256rnds2 STATE0, STATE1

   paddd       STATE0, oword ptr[abef_save]  ; update previously saved hash
   paddd       STATE1, oword ptr[cdgh_save]

   add         MSG_PTR, MBS_SHA256
   sub         MSG_LEN, MBS_SHA256
   jg          sha256_block_loop

   ; reorder hash
   pshufd      STATE0,  STATE0,  01Bh  ; FEBA
   pshufd      STATE1,  STATE1,  0B1h  ; DCHG
   movdqa      MSGTMP4, STATE0
   pblendw     STATE0,  STATE1,  0F0h  ; DCBA
   palignr     STATE1,  MSGTMP4, 8     ; HGFE

   ; and store it back
   movdqu      oword ptr[HASH_PTR + 0*sizeof(oword)], STATE0
   movdqu      oword ptr[HASH_PTR + 1*sizeof(oword)], STATE1

quit:
   add   esp, (frame_size+16)
   ret
IPPASM UpdateSHA256ni ENDP

ELSE ;; no sha ni support in VxWorks - therefore we temporary use db

IPPASM UpdateSHA256ni PROC NEAR C PUBLIC \
USES esi edi ebx,\
pDigest:PTR DWORD,\  ; pointer to the in/out digest
pMsg:   PTR BYTE,\   ; pointer to the inp message
msgLen: DWORD,\      ; message length
pTbl:   PTR DWORD    ; pointer to SHA256 table of constants

MBS_SHA256  equ   (64)  ; SHA-1 message block length (bytes)

HASH_PTR equ   edi   ; 1st arg
MSG_PTR  equ   esi   ; 2nd arg
MSG_LEN  equ   edx   ; 3rd arg
K256_PTR equ   ebx   ; 4rd arg

MSG      equ   xmm0
STATE0   equ   xmm1
STATE1   equ   xmm2
MSGTMP0  equ   xmm3
MSGTMP1  equ   xmm4
MSGTMP2  equ   xmm5
MSGTMP3  equ   xmm6
MSGTMP4  equ   xmm7

;
; stack frame
;
mask_save   equ   eax
abef_save   equ   eax+sizeof(oword)
cdgh_save   equ   eax+sizeof(oword)*2
frame_size  equ   sizeof(oword)+sizeof(oword)+sizeof(oword)

   sub      esp, (frame_size+16)
   lea      eax, [esp+16]
   and      eax, -16

   mov      MSG_LEN, msgLen   ; message length
   test     MSG_LEN, MSG_LEN
   jz       quit

   mov      HASH_PTR, pDigest
   mov      MSG_PTR, pMsg
   mov      K256_PTR, pTbl

   ;; load input hash value, reorder these appropriately
   movdqu   STATE0, oword ptr[HASH_PTR+0*sizeof(oword)]
   movdqu   STATE1, oword ptr[HASH_PTR+1*sizeof(oword)]

   pshufd   STATE0,  STATE0,  0B1h  ; CDAB
   pshufd   STATE1,  STATE1,  01Bh  ; EFGH
   movdqa   MSGTMP4, STATE0
   palignr  STATE0,  STATE1,  8     ; ABEF
   pblendw  STATE1,  MSGTMP4, 0F0h  ; CDGH

   ;; copy byte_flip_mask to stack
  ;movdqa   MSGTMP4, oword ptr[PSHUFFLE_BYTE_FLIP_MASK]
   LD_ADDR  ecx, CODE_DATA
   movdqa   MSGTMP4, oword ptr[ecx+(PSHUFFLE_BYTE_FLIP_MASK-CODE_DATA)]
   movdqa   oword ptr[mask_save], MSGTMP4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process next data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sha256_block_loop:
   movdqa   oword ptr[abef_save], STATE0 ; save for addition after rounds
   movdqa   oword ptr[cdgh_save], STATE1

   ;; rounds 0-3
   movdqu      MSG, oword ptr[MSG_PTR + 0*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP0, MSG
   paddd       MSG, oword ptr[K256_PTR + 0*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1

   ;; rounds 4-7
   movdqu      MSG, oword ptr[MSG_PTR + 1*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP1, MSG
   paddd       MSG, oword ptr[K256_PTR + 1*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0DCH ;; sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 8-11
   movdqu      MSG, oword ptr[MSG_PTR + 2*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP2, MSG
   paddd       MSG, oword ptr[K256_PTR + 2*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0E5H ;; sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 12-15
   movdqu      MSG, oword ptr[MSG_PTR + 3*sizeof(oword)]
   pshufb      MSG, oword ptr[mask_save]
   movdqa      MSGTMP3, MSG
   paddd       MSG, oword ptr[K256_PTR + 3*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   db 0FH,038H,0CDH,0DEH ;; sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0EEH ;; sha256msg1  MSGTMP2, MSGTMP3
   ;; rounds 16-19
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 4*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   db 0FH,038H,0CDH,0E3H ;; sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0F3H ;; sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 20-23
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 5*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   db 0FH,038H,0CDH,0ECH ;; sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0DCH ;; sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 24-27
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 6*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   db 0FH,038H,0CDH,0F5H ;; sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0E5H ;; sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 28-31
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 7*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   db 0FH,038H,0CDH,0DEH ;; sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0EEH ;; sha256msg1  MSGTMP2, MSGTMP3

   ;; rounds 32-35
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 8*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   db 0FH,038H,0CDH,0E3H ;; sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0F3H ;; sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 36-39
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 9*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   db 0FH,038H,0CDH,0ECH ;; sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0DCH ;; sha256msg1  MSGTMP0, MSGTMP1

   ;; rounds 40-43
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 10*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   db 0FH,038H,0CDH,0F5H ;; sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0E5H ;; sha256msg1  MSGTMP1, MSGTMP2

   ;; rounds 44-47
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 11*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP3
   palignr     MSGTMP4, MSGTMP2, 4
   paddd       MSGTMP0, MSGTMP4
   db 0FH,038H,0CDH,0DEH ;; sha256msg2  MSGTMP0, MSGTMP3
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0EEH ;; sha256msg1  MSGTMP2, MSGTMP3

   ;; rounds 48-51
   movdqa      MSG, MSGTMP0
   paddd       MSG, oword ptr[K256_PTR + 12*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP0
   palignr     MSGTMP4, MSGTMP3, 4
   paddd       MSGTMP1, MSGTMP4
   db 0FH,038H,0CDH,0E3H ;; sha256msg2  MSGTMP1, MSGTMP0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1
   db 0FH,038H,0CCH,0F3H ;; sha256msg1  MSGTMP3, MSGTMP0

   ;; rounds 52-55
   movdqa      MSG, MSGTMP1
   paddd       MSG, oword ptr[K256_PTR + 13*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP1
   palignr     MSGTMP4, MSGTMP0, 4
   paddd       MSGTMP2, MSGTMP4
   db 0FH,038H,0CDH,0ECH ;; sha256msg2  MSGTMP2, MSGTMP1
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1

   ;; rounds 56-59
   movdqa      MSG, MSGTMP2
   paddd       MSG, oword ptr[K256_PTR + 14*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   movdqa      MSGTMP4, MSGTMP2
   palignr     MSGTMP4, MSGTMP1, 4
   paddd       MSGTMP3, MSGTMP4
   db 0FH,038H,0CDH,0F5H ;; sha256msg2  MSGTMP3, MSGTMP2
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1

   ;; rounds 60-63
   movdqa      MSG, MSGTMP3
   paddd       MSG, oword ptr[K256_PTR + 15*sizeof(oword)]
   db 0FH,038H,0CBH,0D1H ;; sha256rnds2 STATE1, STATE0
   pshufd      MSG, MSG, 0Eh
   db 0FH,038H,0CBH,0CAH ;; sha256rnds2 STATE0, STATE1

   paddd       STATE0, oword ptr[abef_save]  ; update previously saved hash
   paddd       STATE1, oword ptr[cdgh_save]

   add         MSG_PTR, MBS_SHA256
   sub         MSG_LEN, MBS_SHA256
   jg          sha256_block_loop

   ; reorder hash
   pshufd      STATE0,  STATE0,  01Bh  ; FEBA
   pshufd      STATE1,  STATE1,  0B1h  ; DCHG
   movdqa      MSGTMP4, STATE0
   pblendw     STATE0,  STATE1,  0F0h  ; DCBA
   palignr     STATE1,  MSGTMP4, 8     ; HGFE

   ; and store it back
   movdqu      oword ptr[HASH_PTR + 0*sizeof(oword)], STATE0
   movdqu      oword ptr[HASH_PTR + 1*sizeof(oword)], STATE1

quit:
   add   esp, (frame_size+16)
   ret
IPPASM UpdateSHA256ni ENDP

ENDIF ;; VxWorks

ENDIF    ;; _FEATURE_ON_ / _FEATURE_TICKTOCK_
ENDIF    ;; _ENABLE_ALG_SHA256_
END
