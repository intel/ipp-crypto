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
;               Message block processing according to SM3
; 
;     Content:
;        UpdateSM3
;

include asmdefs.inc
include ia_32e.inc
include pcpvariant.inc

IF (_ENABLE_ALG_SM3_)
IF ((_IPP32E GE _IPP32E_U8 ) AND (_IPP32E LT _IPP32E_E9 )) OR (_IPP32E EQ _IPP32E_N8 )

a  equ   r8d
b  equ   r9d
c  equ   r10d
d  equ   r11d
e  equ   r12d
f  equ   r13d
g  equ   r14d
h  equ   r15d

hPtr  equ   rdi
mPtr  equ   rsi
kPtr  equ   rcx

t0    equ   eax
t1    equ   ebx
t2    equ   ebp
t3    equ   edx

ctr   equ   hPtr


IF (_IPP32E GE _IPP32E_U8 )

ROTL MACRO x, n
   shld  x,x, n
ENDM

ELSE
ROTL MACRO x, n
   rol  x, n
ENDM
ENDIF

ROUND_00_15 MACRO a,b,c,d,e,f,g,h,i
   mov   t0, a
   mov   t1, [kPtr+ctr*sizeof(dword)+i*sizeof(dword)]
   ROTL  t0, 12   ; t0 = t
   add   t1, t0
   add   t1, e
   ROTL  t1, 7    ; t1 = SS1
   xor   t0, t1   ; t0 = SS2

   mov   t2, b
   mov   t3, f

   xor   t2, c
   xor   t3, g

   xor   t2, a     ; t2 = FF
   xor   t3, e     ; t3 = GG

   add   t0, t2    ; t0 = SS2 + FF
   add   t1, t3    ; t1 = SS1 + GG

   add   t0, d     ; t0 = SS2 + FF + d
   add   t1, h     ; t1 = SS1 + GG + h

   mov   t2, [rsp+ctr*sizeof(dword)+i*sizeof(dword)]     ; t2 = w[i]
   add   t1, t2                                          ; t1 = TT2
   xor   t2, [rsp+ctr*sizeof(dword)+(i+4)*sizeof(dword)] ; t2 = w[i] ^ w[i+4]

   add   t0, t2    ; t0 = TT1

   ROTL  b, 9
   ROTL  f, 19
   mov   h, t0

   mov   d, t1
   ROTL  d, 8
   xor   d, t1
   ROTL  d, 9
   xor   d, t1
ENDM

ROUND_16_63 MACRO a,b,c,d,e,f,g,h,i
   mov   t0, a
   mov   t1, [kPtr+ctr*sizeof(dword)+i*sizeof(dword)]
   ROTL  t0, 12
   add   t1, t0
   add   t1, e
   ROTL  t1, 7    ;; t1 = SS1
   xor   t0, t1   ;; t0 = SS2

   mov   t3, b
   mov   t2, b
   and   t3, c
   xor   t2, c
   and   t2, a
   add   t2, t3

   mov   t3, f
   xor   t3, g
   and   t3, e
   xor   t3, g

   add   t0, t2      ;; t0 = SS2 + FF
   add   t1, t3      ;; t1 = SS1 + GG

   add   t0, d       ;; t0 = SS2 + FF + d
   add   t1, h       ;; t1 = SS1 + GG + h

   mov   t2, [rsp+ctr*sizeof(dword)+i*sizeof(dword)]     ;; t2 = w[i]
   add   t1, t2                                          ;; t1 = TT2
   xor   t2, [rsp+ctr*sizeof(dword)+(i+4)*sizeof(dword)] ;; t2 = w[i] ^ w[i+4]

   add   t0, t2      ;; t0 = TT1

   ROTL  b, 9
   ROTL  f, 19
   mov   h, t0

   mov   d, t1
   ROTL  d, 8
   xor   d, t1
   ROTL  d, 9
   xor   d, t1
ENDM

SCHED_16_67 MACRO i
   mov   t2, [rsp+ctr*sizeof(dword)+(i-3)*sizeof(dword)]    ;; t2 = w[i-3]
   ROTL  t2, 15                                             ;; t2 = rol(t2,15)
   xor   t2, [rsp+ctr*sizeof(dword)+(i-9)*sizeof(dword)]    ;; t2 ^= w[i-9]
   xor   t2, [rsp+ctr*sizeof(dword)+(i-16)*sizeof(dword)]   ;; t2 ^= w[i-16]

   mov   t3, t2
   ROTL  t3, 8
   xor   t3, t2
   ROTL  t3, 15
   xor   t3, t2      ;; t3 = P1

   mov   t2, [rsp+ctr*sizeof(dword)+(i-13)*sizeof(dword)]
   xor   t3, [rsp+ctr*sizeof(dword)+(i-6)*sizeof(dword)]
   ROTL  t2, 7
   xor   t3, t2
   mov   [rsp+ctr*sizeof(dword)+i*sizeof(dword)], t3
ENDM


IPPCODE SEGMENT 'CODE' ALIGN (IPP_ALIGN_FACTOR)

ALIGN IPP_ALIGN_FACTOR

bswap128 DB 3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12

;********************************************************************
;* void UpdateSM3(uint32_t hash[8],
;                const uint32_t msg[16], int msgLen,
;                const uint32_t* K_SM3)
;********************************************************************
ALIGN IPP_ALIGN_FACTOR
IPPASM UpdateSM3 PROC PUBLIC FRAME
      USES_GPR rbp,rbx,rsi,rdi,r12,r13,r14,r15
      LOCAL_FRAME = 68*sizeof(dword)+3*sizeof(qword)
      USES_XMM
      COMP_ABI 4

;; rdi = hash
;; rsi = data buffer
;; rdx = data buffer length (bytes)
;; rcx = address of SM3 constants

;; stack structure:
_w    = 0                     ; msg extension W0, ..., W67
_hash = _w+68*sizeof(dword)   ; hash
_msg  = _hash+sizeof(qword)   ; msg pointer
_len  = _msg+sizeof(qword)    ; msg length

MBS_SM3  equ   (64)

   movsxd   rdx, edx

   mov      qword ptr[rsp+_hash], hPtr ; save hash pointer
   mov      qword ptr[rsp+_len], rdx   ; save msg length

   mov   a, [hPtr+0*sizeof(dword)]     ; input hash value
   mov   b, [hPtr+1*sizeof(dword)]
   mov   c, [hPtr+2*sizeof(dword)]
   mov   d, [hPtr+3*sizeof(dword)]
   mov   e, [hPtr+4*sizeof(dword)]
   mov   f, [hPtr+5*sizeof(dword)]
   mov   g, [hPtr+6*sizeof(dword)]
   mov   h, [hPtr+7*sizeof(dword)]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; process data block
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIGN IPP_ALIGN_FACTOR
main_loop:
   xor  ctr, ctr     ; round

   movdqu   xmm0, oword ptr [mPtr+0*sizeof(oword)]
   movdqu   xmm1, oword ptr [mPtr+1*sizeof(oword)]
   movdqu   xmm2, oword ptr [mPtr+2*sizeof(oword)]
   movdqu   xmm3, oword ptr [mPtr+3*sizeof(oword)]
   add      mPtr, MBS_SM3
   mov      qword ptr[rsp+_msg], mPtr ; save msg pointer

   pshufb   xmm0, oword ptr bswap128
   pshufb   xmm1, oword ptr bswap128
   pshufb   xmm2, oword ptr bswap128
   pshufb   xmm3, oword ptr bswap128

   movdqu   oword ptr [rsp+0*sizeof(oword)], xmm0
   movdqu   oword ptr [rsp+1*sizeof(oword)], xmm1
   movdqu   oword ptr [rsp+2*sizeof(oword)], xmm2
   movdqu   oword ptr [rsp+3*sizeof(oword)], xmm3

ALIGN IPP_ALIGN_FACTOR
rounds_00_15:
   SCHED_16_67 16
   ROUND_00_15 a,b,c,d,e,f,g,h,0
   SCHED_16_67 17
   ROUND_00_15 h,a,b,c,d,e,f,g,1
   SCHED_16_67 18
   ROUND_00_15 g,h,a,b,c,d,e,f,2
   SCHED_16_67 19
   ROUND_00_15 f,g,h,a,b,c,d,e,3
   SCHED_16_67 20
   ROUND_00_15 e,f,g,h,a,b,c,d,4
   SCHED_16_67 21
   ROUND_00_15 d,e,f,g,h,a,b,c,5
   SCHED_16_67 22
   ROUND_00_15 c,d,e,f,g,h,a,b,6
   SCHED_16_67 23
   ROUND_00_15 b,c,d,e,f,g,h,a,7
   add      ctr, 8
   cmp      ctr, 16
   jne      rounds_00_15

ALIGN IPP_ALIGN_FACTOR
rounds_16_47:
   SCHED_16_67 16
   ROUND_16_63 a,b,c,d,e,f,g,h,0
   SCHED_16_67 17
   ROUND_16_63 h,a,b,c,d,e,f,g,1
   SCHED_16_67 18
   ROUND_16_63 g,h,a,b,c,d,e,f,2
   SCHED_16_67 19
   ROUND_16_63 f,g,h,a,b,c,d,e,3
   SCHED_16_67 20
   ROUND_16_63 e,f,g,h,a,b,c,d,4
   SCHED_16_67 21
   ROUND_16_63 d,e,f,g,h,a,b,c,5
   SCHED_16_67 22
   ROUND_16_63 c,d,e,f,g,h,a,b,6
   SCHED_16_67 23
   ROUND_16_63 b,c,d,e,f,g,h,a,7
   add      ctr, 8
   cmp      ctr, 48
   jne      rounds_16_47

   SCHED_16_67 16
   SCHED_16_67 17
   SCHED_16_67 18
   SCHED_16_67 19

ALIGN IPP_ALIGN_FACTOR
rounds_48_63:
   ROUND_16_63 a,b,c,d,e,f,g,h,0
   ROUND_16_63 h,a,b,c,d,e,f,g,1
   ROUND_16_63 g,h,a,b,c,d,e,f,2
   ROUND_16_63 f,g,h,a,b,c,d,e,3
   ROUND_16_63 e,f,g,h,a,b,c,d,4
   ROUND_16_63 d,e,f,g,h,a,b,c,5
   ROUND_16_63 c,d,e,f,g,h,a,b,6
   ROUND_16_63 b,c,d,e,f,g,h,a,7
   add      ctr, 8
   cmp      ctr, 64
   jne      rounds_48_63

   mov      hPtr, [rsp+_hash]
   mov      mPtr, [rsp+_msg]

   xor      a, [hPtr+0*sizeof(dword)]
   xor      b, [hPtr+1*sizeof(dword)]
   xor      c, [hPtr+2*sizeof(dword)]
   xor      d, [hPtr+3*sizeof(dword)]
   xor      e, [hPtr+4*sizeof(dword)]
   xor      f, [hPtr+5*sizeof(dword)]
   xor      g, [hPtr+6*sizeof(dword)]
   xor      h, [hPtr+7*sizeof(dword)]

   mov      [hPtr+0*sizeof(dword)], a
   mov      [hPtr+1*sizeof(dword)], b
   mov      [hPtr+2*sizeof(dword)], c
   mov      [hPtr+3*sizeof(dword)], d
   mov      [hPtr+4*sizeof(dword)], e
   mov      [hPtr+5*sizeof(dword)], f
   mov      [hPtr+6*sizeof(dword)], g
   mov      [hPtr+7*sizeof(dword)], h

   sub      qword ptr [rsp+_len], MBS_SM3
   jne      main_loop

   REST_XMM
   REST_GPR
   ret
IPPASM UpdateSM3 ENDP

ENDIF    ;; ((_IPP32E GE _IPP32E_U8 ) AND (_IPP32E LT _IPP32E_E9 )) OR (_IPP32E EQ _IPP32E_N8 )
ENDIF    ;; _ENABLE_ALG_SM3_
END
