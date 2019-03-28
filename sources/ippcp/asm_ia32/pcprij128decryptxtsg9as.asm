;===============================================================================
; Copyright 2016-2019 Intel Corporation
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
;               AES function
; 
;     Content:
;        cpAESDecryptXTS_AES_NI()
; 
;
.686P
.XMM
.MODEL FLAT,C

INCLUDE asmdefs.inc
INCLUDE ia_emm.inc


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

MUL_X MACRO y, x, t, cnt
   pxor     t, t
   movdqa   y, x
   pcmpgtq  t, x
   paddq    y, y
   palignr  t, t, sizeof(qword)
   pand     t, cnt
   pxor     y, t
ENDM

;***************************************************************
;* Purpose:    AES-XTS decryption
;*
;* void cpAESDecryptXTS_AES_NI(Ipp8u* outBlk,
;*                       const Ipp8u* inpBlk,
;*                             int length,
;*                       const Ipp8u* pRKey,
;*                             int nr,
;*                       const Ipp8u* pTweak)
;***************************************************************

IF (_IPP GE _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsAESDecryptXTS
;;
ALIGN IPP_ALIGN_FACTOR
IPPASM cpAESDecryptXTS_AES_NI PROC NEAR C PUBLIC \
USES esi edi ebx,\
pOutBlk:PTR DWORD,\    ; output block address
pInpBlk:PTR DWORD,\    ; input  block address
blks:DWORD,\           ; length(blocks)
pKey:PTR DWORD,\       ; key material address
nr:DWORD,\             ; number of rounds
pTweak:PTR DWORD       ; tweaks

SC        equ (4)
BLKS_PER_LOOP = (4)
BYTES_PER_BLK = (16)
BYTES_PER_LOOP = (BYTES_PER_BLK*BLKS_PER_LOOP)

   mov      esi,pInpBlk       ; input data address
   mov      edi,pOutBlk       ; output data address

;
; stack layout:
;
_tweakCnt= 0                           ; constant
_tweak0  = _tweakCnt+sizeof(oword)     ; * alpha
_tweak1  = _tweak0+sizeof(oword)       ; * alpha^2
_tweak2  = _tweak1+sizeof(oword)       ; * alpha^3
_tweak3  = _tweak2+sizeof(oword)       ; * alpha^4
_tkey    = _tweak3+sizeof(oword)       ; decryption keys (top)
_bkey    = _tkey+sizeof(dword)         ; decryption keys (bottom)
_nr      = _bkey+sizeof(dword)         ; # rounds
_sp      = _nr+sizeof(dword)           ; esp
stackSize= _sp+sizeof(dword)           ; stack size

   mov      eax, esp
   sub      esp, stackSize             ; aligned stack
   and      esp, (-16)
   mov      dword ptr[esp+_sp], eax    ; store esp

   mov      eax, pTweak
   movdqu   xmm4, oword ptr[eax]       ; initial tweak
   movdqa   xmm7, xmm4

   mov      eax, 087h         ; create tweakCnt = {0x01:0x87}
   mov      ecx, 1
   movd     xmm0, eax
   movd     xmm1, ecx
   punpcklqdq xmm0, xmm1

   mov      ecx,pKey          ; key material address
   mov      eax,nr            ; num of rounds
   mov      edx,blks          ; num of blocks

   ; move parameters to local stack frame
   movdqa   oword ptr[esp+_tweakCnt], xmm0
   mov      dword ptr[esp+_tkey], ecx
   lea      ebx, [eax*SC]
   lea      ecx, [ecx+ebx*sizeof(dword)]
   mov      dword ptr[esp+_bkey], ecx
   mov      dword ptr[esp+_nr],  eax

   sub      edx, BLKS_PER_LOOP
   jl       short_input
   jmp      blks_loop_ep

;;
;; pipelined processing
;;
blks_loop:
   MUL_X    xmm4, xmm7, xmm1, xmm0
blks_loop_ep:
   movdqa   oword ptr[esp+_tweak0], xmm4
   MUL_X    xmm5, xmm4, xmm1, xmm0
   movdqa   oword ptr[esp+_tweak1], xmm5
   MUL_X    xmm6, xmm5, xmm1, xmm0
   movdqa   oword ptr[esp+_tweak2], xmm6
   MUL_X    xmm7, xmm6, xmm1, xmm0
   movdqa   oword ptr[esp+_tweak3], xmm7

   movdqu   xmm0, oword ptr[esi+0*BYTES_PER_BLK]  ; get input blocks
   movdqu   xmm1, oword ptr[esi+1*BYTES_PER_BLK]
   movdqu   xmm2, oword ptr[esi+2*BYTES_PER_BLK]
   movdqu   xmm3, oword ptr[esi+3*BYTES_PER_BLK]
   add      esi, BYTES_PER_BLK*BLKS_PER_LOOP

   pxor     xmm0, xmm4              ; tweak pre-whitening
   pxor     xmm1, xmm5
   pxor     xmm2, xmm6
   pxor     xmm3, xmm7

   movdqa   xmm4, oword ptr[ecx]    ; keys for whitening
   lea      ebx, [ecx-BYTES_PER_BLK]; pointer to the round's key material

   pxor     xmm0, xmm4              ; whitening
   pxor     xmm1, xmm4
   pxor     xmm2, xmm4
   pxor     xmm3, xmm4

   movdqa   xmm4, oword ptr[ebx]    ; pre load round keys
   sub      ebx, BYTES_PER_BLK
   sub      eax, 1
cipher_loop:
   aesdec      xmm0, xmm4           ; regular round
   aesdec      xmm1, xmm4
   aesdec      xmm2, xmm4
   aesdec      xmm3, xmm4
   movdqa      xmm4, oword ptr[ebx]
   sub         ebx, BYTES_PER_BLK
   dec         eax
   jnz         cipher_loop

   aesdeclast  xmm0, xmm4           ; irregular round
   aesdeclast  xmm1, xmm4
   aesdeclast  xmm2, xmm4
   aesdeclast  xmm3, xmm4

   movdqa   xmm4, oword ptr[esp+_tweak0]  ; tweak post-whitening
   movdqa   xmm5, oword ptr[esp+_tweak1]
   movdqa   xmm6, oword ptr[esp+_tweak2]
   movdqa   xmm7, oword ptr[esp+_tweak3]
   pxor     xmm0, xmm4
   pxor     xmm1, xmm5
   pxor     xmm2, xmm6
   pxor     xmm3, xmm7

   movdqu   oword ptr[edi+0*BYTES_PER_BLK], xmm0   ; store output blocks
   movdqu   oword ptr[edi+1*BYTES_PER_BLK], xmm1
   movdqu   oword ptr[edi+2*BYTES_PER_BLK], xmm2
   movdqu   oword ptr[edi+3*BYTES_PER_BLK], xmm3
   add      edi, BYTES_PER_BLK*BLKS_PER_LOOP

   movdqa   xmm0, oword ptr[esp+_tweakCnt]         ; restore tweak const
   mov      eax, dword ptr[esp+_nr]                ;         number of rounds
   sub      edx, BLKS_PER_LOOP
   jge      blks_loop

;;
;; block-by-block processing
;;
short_input:
   add      edx, BLKS_PER_LOOP
   jz       quit

   mov      ecx, dword ptr[esp+_tkey]
   mov      ebx, dword ptr[esp+_bkey]
   mov      eax, dword ptr[esp+_nr]
   jmp      single_blk_loop_ep

single_blk_loop:
   MUL_X    xmm7, xmm7, xmm1, xmm0

single_blk_loop_ep:
   movdqu   xmm1, oword ptr[esi]       ; input block
   add      esi, BYTES_PER_BLK
   pxor     xmm1, xmm7                 ; tweak pre-whitening
   pxor     xmm1, oword ptr[ebx]       ; AES whitening

   cmp      eax,12                     ; switch according to number of rounds
   jl       key_128_s

key_256_s:
   aesdec   xmm1,oword ptr[ecx+9*SC*4+4*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4+3*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4+2*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4+1*SC*4]
key_128_s:
   aesdec   xmm1,oword ptr[ecx+9*SC*4-0*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-1*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-2*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-3*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-4*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-5*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-6*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-7*SC*4]
   aesdec   xmm1,oword ptr[ecx+9*SC*4-8*SC*4]
   aesdeclast  xmm1,oword ptr[ecx+9*SC*4-9*SC*4]

   pxor     xmm1, xmm7                 ; tweak post-whitening
   movdqu   oword ptr[edi], xmm1       ; output block
   add      edi, BYTES_PER_BLK

   sub      edx, 1
   jnz      single_blk_loop

quit:
   mov      eax, pTweak                ; save tweak
   movdqu   oword ptr[eax], xmm7

   mov      esp, [esp+_sp]
   ret
IPPASM cpAESDecryptXTS_AES_NI ENDP
ENDIF

END
