;===============================================================================
; Copyright 2009-2019 Intel Corporation
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
;     Purpose:  x86 Cryptography Primitive.
; 
; 
;

my_pclmulqdq   MACRO xxDst, xxSrc, xxOp
IF (my_emulator EQ 0)
   pclmulqdq   xxDst, xxSrc, xxOp
ELSE
;;;; esp => &p1
;; +4  => &p2
;; +8  => p3
;; +12 => p2 (16 bytes)
;; +28 => p1 (16 bytes)
;; +44 => eax

   stackSize = (4+4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+44], eax    ;; save eax
   mov      dword ptr [esp+48], ebx    ;; save ebx
   mov      dword ptr [esp+52], ecx    ;; save ecx
   mov      dword ptr [esp+56], edx    ;; save edx
   mov      dword ptr [esp+60], esi    ;; save esi
   mov      dword ptr [esp+64], edi    ;; save edi

   movdqu   oword ptr [esp+28], xxDst  ;; store mmDst
   movdqu   oword ptr [esp+12], xxSrc  ;; store mmSrc
   mov      dword ptr [esp+8],  xxOp   ;; put p3 (mmOp) into the stack
   lea      eax, [esp+28]              ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+12]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_pclmulqdq
   movdqu   xxDst, oword ptr[esp+28]   ;; load result

   mov      eax, dword ptr [esp+44]    ;; restore eax
   mov      ebx, dword ptr [esp+48]    ;; restore ebx
   mov      ecx, dword ptr [esp+52]    ;; restore ecx
   mov      edx, dword ptr [esp+56]    ;; restore edx
   mov      esi, dword ptr [esp+60]    ;; restore esi
   mov      edi, dword ptr [esp+64]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM

my_palignr MACRO xxDst, xxSrc, xxOp
IF (my_emulator EQ 0)
   palignr xxDst, xxSrc, xxOp
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p3
;; +12 => p2 (16 bytes)
;; +28 => p1 (16 bytes)
;; +44 => eax

   stackSize = (4+4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+44], eax    ;; save eax
   mov      dword ptr [esp+48], ebx    ;; save ebx
   mov      dword ptr [esp+52], ecx    ;; save ecx
   mov      dword ptr [esp+56], edx    ;; save edx
   mov      dword ptr [esp+60], esi    ;; save esi
   mov      dword ptr [esp+64], edi    ;; save edi

   movdqu   oword ptr [esp+28], xxDst  ;; store mmDst
   movdqu   oword ptr [esp+12], xxSrc  ;; store mmSrc
   mov      dword ptr [esp+8],  xxOp   ;; put p3 (mmOp) into the stack
   lea      eax, [esp+28]              ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+12]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_palignr
   movdqu   xxDst, oword ptr[esp+28]   ;; load result

   mov      eax, dword ptr [esp+44]    ;; restore eax
   mov      ebx, dword ptr [esp+48]    ;; restore ebx
   mov      ecx, dword ptr [esp+52]    ;; restore ecx
   mov      edx, dword ptr [esp+56]    ;; restore edx
   mov      esi, dword ptr [esp+60]    ;; restore esi
   mov      edi, dword ptr [esp+64]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM

my_pshufd MACRO xxDst, xxSrc, xxOp
IF (my_emulator EQ 0)
   pshufd xxDst, xxSrc, xxOp
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p3
;; +12 => p2 (16 bytes)
;; +28 => p1 (16 bytes)
;; +44 => eax

   stackSize = (4+4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+44], eax    ;; save eax
   mov      dword ptr [esp+48], ebx    ;; save ebx
   mov      dword ptr [esp+52], ecx    ;; save ecx
   mov      dword ptr [esp+56], edx    ;; save edx
   mov      dword ptr [esp+60], esi    ;; save esi
   mov      dword ptr [esp+64], edi    ;; save edi

   movdqu   oword ptr [esp+28], xxDst  ;; store mmDst
   movdqu   oword ptr [esp+12], xxSrc  ;; store mmSrc
   mov      dword ptr [esp+8],  xxOp   ;; put p3 (mmOp) into the stack
   lea      eax, [esp+28]              ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+12]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_pshufd
   movdqu   xxDst, oword ptr[esp+28]   ;; load result

   mov      eax, dword ptr [esp+44]    ;; restore eax
   mov      ebx, dword ptr [esp+48]    ;; restore ebx
   mov      ecx, dword ptr [esp+52]    ;; restore ecx
   mov      edx, dword ptr [esp+56]    ;; restore edx
   mov      esi, dword ptr [esp+60]    ;; restore esi
   mov      edi, dword ptr [esp+64]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM


my_pshufb MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   pshufb xxDst, xxSrc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p2 (16 bytes)
;; +24 => p1 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+24], xxDst  ;; store mmDst
   movdqu   oword ptr [esp+8],  xxSrc  ;; store mmSrc
   lea      eax, [esp+24]              ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+8]               ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_pshufb
   movdqu   xxDst, oword ptr[esp+24]   ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM

my_pshufbM MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   pshufb xxDst, xxSrc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p2 (16 bytes)
;; +24 => p1 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+24], xxDst  ;; store mmDst
   movdqu   xxDst, xxSrc
   movdqu   oword ptr [esp+8],  xxDst  ;; store mmSrc
   lea      eax, [esp+24]              ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+8]               ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_pshufb
   movdqu   xxDst, oword ptr[esp+24]   ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM

my_aesenc MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   aesenc xxDst, xxSRc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p1 (16 bytes)
;; +24 => p2 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+8],  xxDst  ;; store mmDst
   movdqu   oword ptr [esp+24], xxSrc  ;; store mmSrc
   lea      eax, [esp+8]               ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+24]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_aesenc
   movdqu   xxDst, oword ptr[esp+8]    ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM


my_aesenclast MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   aesenclast xxDst, xxSRc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p1 (16 bytes)
;; +24 => p2 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+8],  xxDst  ;; store mmDst
   movdqu   oword ptr [esp+24], xxSrc  ;; store mmSrc
   lea      eax, [esp+8]               ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+24]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_aesenclast
   movdqu   xxDst, oword ptr[esp+8]    ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM


my_aesdec MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   aesdec xxDst, xxSRc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p1 (16 bytes)
;; +24 => p2 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+8],  xxDst  ;; store mmDst
   movdqu   oword ptr [esp+24], xxSrc  ;; store mmSrc
   lea      eax, [esp+8]               ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+24]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_aesdec
   movdqu   xxDst, oword ptr[esp+8]    ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM

my_aesdeclast MACRO xxDst, xxSrc
IF (my_emulator EQ 0)
   aesdeclast xxDst, xxSRc
ELSE
;;
;; esp => &p1
;; +4  => &p2
;; +8  => p1 (16 bytes)
;; +24 => p2 (16 bytes)
;; +40 => eax

   stackSize = (4+4)+(16+16)+(4+4+4+4+4+4)
   sub      esp,stackSize

   mov      dword ptr [esp+40], eax    ;; save eax
   mov      dword ptr [esp+44], ebx    ;; save ebx
   mov      dword ptr [esp+48], ecx    ;; save ecx
   mov      dword ptr [esp+52], edx    ;; save edx
   mov      dword ptr [esp+56], esi    ;; save esi
   mov      dword ptr [esp+60], edi    ;; save edi

   movdqu   oword ptr [esp+8],  xxDst  ;; store mmDst
   movdqu   oword ptr [esp+24], xxSrc  ;; store mmSrc
   lea      eax, [esp+8]               ;; &p1 (&mmSrc)
   mov      dword ptr [esp], eax       ;; put &p1 into the stack
   lea      eax, [esp+24]              ;; &p2
   mov      dword ptr [esp+4], eax     ;; put &p2 into the stack

   call     emu_aesdeclast
   movdqu   xxDst, oword ptr[esp+8]    ;; load result

   mov      eax, dword ptr [esp+40]    ;; restore eax
   mov      ebx, dword ptr [esp+44]    ;; restore ebx
   mov      ecx, dword ptr [esp+48]    ;; restore ecx
   mov      edx, dword ptr [esp+52]    ;; restore edx
   mov      esi, dword ptr [esp+56]    ;; restore esi
   mov      edi, dword ptr [esp+60]    ;; restore edi
   add      esp, stackSize
ENDIF
ENDM


 IF (my_emulator NE 0)
extern emu_pclmulqdq:   proc
extern emu_palignr:     proc
extern emu_pshufd:      proc
extern emu_pshufb:      proc
extern emu_aesenc:      proc
extern emu_aesenclast:  proc
extern emu_aesdec:      proc
extern emu_aesdeclast:  proc
ENDIF
