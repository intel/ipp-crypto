;===============================================================================
; Copyright 2013-2019 Intel Corporation
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
;               Big Number macros
; 
;     Content:
;        SWAP
;        EXPAND_BNU
; 
;        COPY_BNU
;        FIX_BNU      CMP_BNU
; 
;        ADD_BNU      SUB_BNU
;        ECARRY       EBORROW
; 
;        MUL_BNU_D32  MAC_BNU_D32
;        MUL_BNU_D64  MAC_BNU_D64
; 
;        MAC          MAC2
; 
;        ADD_FIX_BNU  SUB_FIX_BNU
; 

;;
;; Swap values or addresses
;;
SWAP MACRO cc:REQ, dst:REQ,src:REQ,tmp:REQ
   cmov&cc  tmp,src
   cmov&cc  src,dst
   cmov&cc  dst,tmp
ENDM

;;
;; EXPAND_BNU  expands BNU by zero if one has odd size
;;
EXPAND_BNU MACRO rBNU:REQ, rLen:REQ
LOCAL expand_quit
   test  rLen,1
   jz    expand_quit
   mov   DWORD PTR[rBNU+rLen*4],0
   add   rLen,1
expand_quit:
ENDM

;;
;; COPY_BNU
;;
COPY_BNU MACRO rSrc:REQ, rDst:REQ, rLen:REQ, rIdx:REQ, rTmp:REQ
LOCAL copy_bnu
   xor      rIdx,rIdx
copy_bnu:
   mov      rTmp&d,[rSrc+rIdx*4]
   mov      [rDst+rIdx*4],rTmp&d
   add      rIdx,1
   cmp      rIdx,rLen
   jl       copy_bnu
ENDM

;;
;; FIX_BNU     returns actual length of BNU
;;
;; input
;;    rSrc     points BNU
;;    rLen     initial BNU size
;;
;; output
;;    rSrc     points BNU
;;    rLen     actual BNU size
;;
FIX_BNU MACRO rSrc,rLen, tmp
LOCAL fix_bnu_loop,fix_bnu_quit
fix_bnu_loop:
   mov      tmp&d,[rSrc+rLen*4-4]   ;; value
   test     tmp&d,tmp&d             ;; test BNU component
   jnz      fix_bnu_quit
   sub      rLen,1
   jg       fix_bnu_loop
   add      rLen,1
fix_bnu_quit:
ENDM

;;
;; CMP_BNU     comare BNUs
;;
;; input
;;    rSrc1    points BNU1
;;    rSrc2    points BNU2
;;    rLen     size of BNUs
;;
;; output
;;    rCode    -1/0/1
;;
CMP_BNU MACRO rCode, rSrc1,rSrc2,rLen
LOCAL cmp_bnu_loop,cmp_bnu_quit
cmp_bnu_loop:
   mov      rCode&d,[rSrc1+rLen*4-4]   ;; src1[]
   cmp      rCode&d,[rSrc2+rLen*4-4]   ;; src1[] ~  src2[]
   jnz      cmp_bnu_quit               ;; src1[] != src2[]
   sub      rLen,1
   jg       cmp_bnu_loop
cmp_bnu_quit:
   seta     rCode&b        ;; rCode = (src1[]>src2[])? 1:0
   setb     rLen&b         ;; rLen  = (src1[]<src2[])? 1:0
   sub      rCode&b,rLen&b
   movsx    rCode,rCode&b
ENDM


;;
;; ADD_BNU     add BNUs
;;
;; input
;;    rDst     points resultant BNU
;;    rSrc1    points source BNU
;;    rSrc2    points source BNU
;;    rLen     BNU size
;;    rIdx     source, resultant index
;;
;; output
;;    rCarry   carry value (byte)
;;
ADD_BNU MACRO rDst,rCarry, rSrc1,rSrc2,rLen, rIdx,tmp1,tmp2
LOCAL add_bnu_loop,short_bnu,add_bnu_exit
   xor      rCarry,rCarry           ;; carry=0
   xor      rIdx,rIdx               ;; index=0

   sub      rLen,2                  ;; test BNU size
   jl       short_bnu

   clc                              ;; CF=0
add_bnu_loop:
   mov      tmp1,[rSrc1+rIdx*8]     ;; src1[]
   mov      tmp2,[rSrc2+rIdx*8]     ;; src2[]
   adc      tmp1,tmp2               ;; x = src1[]+src[2]+CF
   mov      [rDst+rIdx*8],tmp1      ;; dst[] = x

   inc      rIdx                    ;; advance index
   dec      rLen                    ;; decrease length
   dec      rLen
   jge      add_bnu_loop            ;; continue
   setc     rCarry&b                ;; save CF

   add      rIdx,rIdx               ;; restore ordinal index
   add      rLen,2                  ;; restore length
   jz       add_bnu_exit

short_bnu:
   shr      rCarry&d,1              ;; restore CF
   mov      tmp1&d,[rSrc1+rIdx*4]   ;; src1[]
   mov      tmp2&d,[rSrc2+rIdx*4]   ;; src2[]
   adc      tmp1&d,tmp2&d           ;; x = src1[]-src[2]-CF
   mov      [rDst+rIdx*4],tmp1&d    ;; dst[] = x
   setc     rCarry&b                ;; save CF
   add      rIdx,1                  ;; advance index
add_bnu_exit:
ENDM

;;
;; ECARRY  expand carry
;;
;; input
;;    rDst     points resultant BNU
;;    rCarry   contains borrow
;;    rSrc     points source BNU
;;    rLen     BNU size
;;    rIdx     source, resultant index
;;
;; output
;;    rCarry   carry  value (byte)
;;
ECARRY MACRO rDst,rCarry, rSrc,rLen, rIdx,tmp
LOCAL ecarry_loop
   shr      rCarry&d,1              ;; restore CF
ecarry_loop:
   mov      tmp&d,[rSrc+rIdx*4]     ;; a[i]
   adc      tmp&d,0                 ;; x = a[]+CF
   mov      [rDst+rIdx*4],tmp&d     ;; dst[] = x
   inc      rIdx                    ;; advance index
   dec      rLen                    ;; decrease length
   jge      ecarry_loop             ;; continue
   setc     rCarry&b                ;; save CF
ENDM


;;
;; SUB_BNU     sub BNUs
;;
;; input
;;    rDst     points resultant BNU
;;    rSrc1    points source BNU
;;    rSrc2    points source BNU
;;    rLen     BNU size
;;    rIdx     source, resultant index
;;
;; output
;;    rBorrow  borrow value (byte)
;;
SUB_BNU MACRO rDst,rBorrow, rSrc1,rSrc2,rLen, rIdx,tmp1,tmp2
LOCAL sub_bnu_loop,short_bnu,sub_bnu_exit
   xor      rBorrow,rBorrow         ;; borrow=0
   xor      rIdx,rIdx               ;; index=0

   sub      rLen,2                  ;; test BNU size
   jl       short_bnu

   clc                              ;; CF=0
sub_bnu_loop:
   mov      tmp1,[rSrc1+rIdx*8]     ;; src1[]
   mov      tmp2,[rSrc2+rIdx*8]     ;; src2[]
   sbb      tmp1,tmp2               ;; x = src1[]-src[2]-CF
   mov      [rDst+rIdx*8],tmp1      ;; dst[] = x

   inc      rIdx                    ;; advance index
   dec      rLen                    ;; decrease length
   dec      rLen
   jge      sub_bnu_loop            ;; continue
   setc     rBorrow&b               ;; save CF

   add      rIdx,rIdx               ;; restore ordinal index
   add      rLen,2                  ;; restore length
   jz       sub_bnu_exit

short_bnu:
   shr      rBorrow&d,1             ;; restore CF
   mov      tmp1&d,[rSrc1+rIdx*4]   ;; src1[]
   mov      tmp2&d,[rSrc2+rIdx*4]   ;; src2[]
   sbb      tmp1&d,tmp2&d           ;; x = src1[]-src[2]-CF
   mov      [rDst+rIdx*4],tmp1&d    ;; dst[] = x
   setc     rBorrow&b               ;; save CF
   add      rIdx,1                  ;; advance index
sub_bnu_exit:
ENDM

;;
;; EBORROW  expand borrow
;;
;; input
;;    rDst     points resultant BNU
;;    rBorrow  contains borrow
;;    rSrc     points source BNU
;;    rLen     BNU size
;;    rIdx     source, resultant index
;;
;; output
;;    rBorrow  borrow value (byte)
;;
EBORROW MACRO rDst,rBorrow, rSrc,rLen, rIdx,tmp
LOCAL eborrow_loop
   shr      rBorrow,1               ;; restore CF
eborrow_loop:
   mov      tmp&d,[rSrc+rIdx*4]     ;; a[i]
   sbb      tmp&d,0                 ;; x = a[]-CF
   mov      [rDst+rIdx*4],tmp&d     ;; dst[] = x
   inc      rIdx                    ;; advance index
   dec      rLen                    ;; decrease length
   jge      eborrow_loop            ;; continue
   setc     rBorrow&b               ;; save CF
ENDM


;;
;; MUL_BNU_D32 multiplay BNU by 32-bit Digit
;;
;; input
;;    rSrc     points source BNU
;;    rDgt     32-bit digit value
;;    rDst     points resultant BNU
;;    rLen     BNU size
;;    rIdx     (scratch) source/target index
;;    rExp     (scratch) expansion
;;
;; output
;;    rDgt     32-bit expansion
;;
;; Note
;;    rdx and rax used in mul instruction,
;;    this mean any macro argument may be neither rax nor rdx
;;
MUL_BNU_D32 MACRO rSrc, rDgt, rDst, rLen, rIdx,rExp
LOCAL mul_bnu_loop,mul_bn_short,mul_bn_quit
   xor      rIdx,rIdx               ;; index = 0
   xor      rExp,rExp               ;; expansion = 0

   sub      rLen,2                  ;; test source size
   jl       mul_bn_short
mul_bnu_loop:
   mov      rax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;; x+= expansion
   adc      edx,0
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)
   mov      rExp&d,edx              ;; 32 bit expansion = HI32(x)

   add      rIdx,2                  ;; advance index
   sub      rLen,2                  ;; decrease length
   jge      mul_bnu_loop

   add      rLen,2                  ;; source size remainder
   jz       mul_bn_quit             ;; edx contains 32 bit expansion

mul_bn_short:
   mov      eax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt&d                  ;; x = a*digit
   add      eax,rExp&d              ;; x+= expansion
   adc      edx,0
   mov      [rDst+rIdx*4],eax       ;; pDst[i] = LO32(x)

mul_bn_quit:
   mov      rDgt&d,edx              ;; 32 bit expansion
ENDM

;;
;; MAC_BNU_D32 multiplay BNU by 32-bit Digit and accumulate
;;
;; input
;;    rSrc     points source BNU
;;    rDgt     32-bit digit value
;;    rDst     points accumulator (resultant) BNU
;;    rLen     BNU size
;;    rIdx     (scratch) source/target index
;;    rExp     (scratch) expansion
;;
;; output
;;    rDgt     32-bit expansion
;;
;; Note
;;    rdx and rax used in mul instruction,
;;    this mean any macro argument may be neither rax nor rdx
;;
MAC_BNU_D32 MACRO rSrc, rDgt, rDst, rLen, rIdx,rExp
LOCAL mac_bnu_loop,mac_bn_short,mac_bn_quit
   xor      rIdx,rIdx               ;; index = 0
   xor      rExp,rExp               ;; expansion = 0

   sub      rLen,2                  ;; test source size
   jl       mac_bn_short
mac_bnu_loop:
   mov      rax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;;
   adc      edx,0                   ;;
   add      rax,[rDst+rIdx*4]       ;; x = expansion + pDst[i] + x
   adc      edx,0                   ;;
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)
   mov      rExp&d,edx              ;; expansion = HI32(x)

   add      rIdx,2                  ;; advance index
   sub      rLen,2                  ;; decrease length
   jge      mac_bnu_loop

   add      rLen,2                  ;; source size remainder
   jz       mac_bn_quit             ;; edx contains 32 bit expansion

mac_bn_short:
   mov      eax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt&d                  ;; x = a*digit
   add      eax,rExp&d              ;;
   adc      edx,0                   ;;
   add      eax,dword ptr[rDst+rIdx*4] ;; x = expansion + pDst[i] + x
   adc      edx,0                   ;;
   mov      [rDst+rIdx*4],eax       ;; pDst[i]   = LO64(x)

mac_bn_quit:
   mov      rDgt&d,edx              ;; 32 bit expansion
ENDM


;;
;; MUL_BNU_D64 multiplay BNU by 64-bit Digit
;;
;; input
;;    rSrc     points source BNU
;;    rDgt     64-bit digit value
;;    rDst     points resultant BNU
;;    rLen     BNU size
;;    rIdx     (scratch) source/target index
;;    rExp     (scratch) expansion
;;
;; output
;;    rDgt     32-bit expansion (because of origin API)
;;
;; Note
;;    rdx and rax used in mul instruction,
;;    this mean any macro argument may be neither rax nor rdx
;;
MUL_BNU_D64 MACRO rSrc, rDgt, rDst, rLen, rIdx,rExp
LOCAL mul_bnu_loop,mul_bn_short,mul_bn_quit
   xor      rIdx,rIdx               ;; index = 0
   xor      rExp,rExp               ;; expansion = 0

   sub      rLen,2                  ;; test source size
   jl       mul_bn_short
mul_bnu_loop:
   mov      rax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;; x+= expansion
   adc      rdx,0
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)
   mov      rExp,rdx                ;; expansion = HI64(x)

   add      rIdx,2                  ;; advance index
   sub      rLen,2                  ;; decrease length
   jge      mul_bnu_loop

   add      rLen,2                  ;; source size remainder
   jnz      mul_bn_short            ;; BNU of odd length

   shr      rdx,32                  ;; extract 32 bit expansion
   mov      [rDst+rIdx*4],rExp&d    ;; store
   jmp      mul_bn_quit

mul_bn_short:
   mov      eax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;; x+= expansion
   adc      rdx,0
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)

mul_bn_quit:
   mov      rDgt&d,edx              ;; 32 bit expansion
ENDM

;;
;; MAC_BNU_D64 multiplay BNU by 64-bit Digit and accumulate
;;
;; input
;;    rSrc     points source BNU
;;    rDgt     64-bit digit value
;;    rDst     points accumulator (resultant) BNU
;;    rLen     BNU size
;;    rIdx     (scratch) source/target index
;;    rExp     (scratch) expansion
;;
;; output
;;    rDgt     32-bit expansion (because of origin API)
;;
;; Note
;;    rdx and rax used in mul instruction,
;;    this mean any macro argument may be neither rax nor rdx
;;
MAC_BNU_D64 MACRO rSrc, rDgt, rDst, rLen, rIdx,rExp
LOCAL mac_bnu_loop,mac_bn_short,mac_bn_quit
   xor      rIdx,rIdx               ;; index = 0
   xor      rExp,rExp               ;; expansion = 0

   sub      rLen,2                  ;; test source size
   jl       mac_bn_short
mac_bnu_loop:
   mov      rax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;;
   adc      rdx,0                   ;;
   add      rax,[rDst+rIdx*4]       ;; x = expansion + pDst[i] + x
   adc      rdx,0                   ;;
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)
   mov      rExp,rdx                ;; expansion = HI64(x)

   add      rIdx,2                  ;; advance index
   sub      rLen,2                  ;; decrease length
   jge      mac_bnu_loop

   add      rLen,2                  ;; source size remainder
   jnz      mac_bn_short            ;; BNU of odd length

   shr      rdx,32                  ;; extract 32 bit expansion
   mov      [rDst+rIdx*4],rExp&d    ;; store
   jmp      mac_bn_quit

mac_bn_short:
   mov      eax,[rSrc+rIdx*4]       ;; a = pSrc[i]
   mul      rDgt                    ;; x = a*digit
   add      rax,rExp                ;;
   adc      rdx,0                   ;;
   mov      rDgt&d,[rDst+rIdx*4]    ;; x = expansion + pDst[i] + x
   add      rax,rDgt                ;;
   adc      rdx,0                   ;;
   mov      [rDst+rIdx*4],rax       ;; pDst[i]   = LO64(x)

mac_bn_quit:
   mov      rDgt&d,edx              ;; 32 bit expansion
ENDM


;;
;; Multiply 64-bit operands and accumulate
;;
MAC MACRO hAcc,mAcc,lAcc, a,b
IFDIF <a>,<rax>
   mov   rax,a
ENDIF
   mul   b
   add   lAcc,rax
   adc   mAcc,rdx
IFNB <hAcc>
   adc   hAcc,0
ENDIF
ENDM

;;
;; Multiply 64-bit operands and accumulate twice
;;
MAC2 MACRO hAcc,mAcc,lAcc, a,b
IFDIF <a>,<rax>
   mov   rax,a
ENDIF
   mul   b
   add   lAcc,rax
   adc   mAcc,rdx
IFNB <hAcc>
   adc   hAcc,0
ENDIF
   add   lAcc,rax
   adc   mAcc,rdx
IFNB <hAcc>
   adc   hAcc,0
ENDIF
ENDM

;;
;; SUB_FIX_BNU subtract fixed size BNUs
;;
;; input
;;    rVal     points src/dst BNU
;;    rSrc     points source BNU
;;    immLen   BNU size
;;
SUB_FIX_BNU MACRO rVal:REQ,rSrc:REQ,immLen:REQ, tmp:REQ
   limit = immLen/2

   i = 0
   repeat limit
   mov   tmp,[rVal+i*4]
      if i eq 0
   sub   tmp,[rSrc+i*4]
      else
   sbb   tmp,[rSrc+i*4]
      endif
   mov   qword ptr[rVal+i*4],tmp
   i = i+2
   endm

   if (immLen AND 1) ne 0
   mov   tmp&d,[rVal+immLen*4-4]
      if i eq 0
   sub   tmp&d,[rSrc+immLen*4-4]
      else
   sbb   tmp&d,[rSrc+immLen*4-4]
      endif
   mov   [rVal+immLen*4-4],tmp&d
   endif
ENDM

;;
;; ADD_FIX_BNU add fixed size BNUs
;;
;; input
;;    rVal     points src/dst BNU
;;    rSrc     points source BNU
;;    immLen   BNU size
;;
ADD_FIX_BNU MACRO rVal:REQ,rSrc:REQ,immLen:REQ, tmp:REQ
   limit = immLen/2

   i = 0
   repeat limit
   mov   tmp,[rVal+i*4]
      if i eq 0
   add   tmp,[rSrc+i*4]
      else
   adc   tmp,[rSrc+i*4]
      endif
   mov   qword ptr[rVal+i*4],tmp
   i = i+2
   endm

   if (immLen AND 1) ne 0
   mov   tmp&d,[rVal+immLen*4-4]
      if i eq 0
   add   tmp&d,[rSrc+immLen*4-4]
      else
   adc   tmp&d,[rSrc+immLen*4-4]
      endif
   mov   [rVal+immLen*4-4],tmp&d
   endif
ENDM

