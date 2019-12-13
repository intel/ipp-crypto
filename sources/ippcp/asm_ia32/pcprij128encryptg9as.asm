;===============================================================================
; Copyright 2014-2019 Intel Corporation
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
;               Rijndael Cipher function
;
;     Content:
;        Encrypt_RIJ128_AES_NI()
;
;




%include "asmdefs.inc"
%include "ia_emm.inc"

segment .text align=IPP_ALIGN_FACTOR


;***************************************************************
;* Purpose:    single block RIJ128 Cipher
;*
;* void Encrypt_RIJ128_AES_NI(const Ipp32u* inpBlk,
;*                                  Ipp32u* outBlk,
;*                                  int nr,
;*                            const Ipp32u* pRKey,
;*                            const Ipp32u Tables[][256])
;*
;***************************************************************

;%if (_IPP >= _IPP_P8) && (_IPP < _IPP_G9)
%if (_IPP >= _IPP_P8)
;;
;; Lib = P8
;;
;; Caller = ippsRijndael128EncryptECB
;; Caller = ippsRijndael128EncryptCBC
;; Caller = ippsRijndael128EncryptCFB
;; Caller = ippsRijndael128DecryptCFB
;;
;; Caller = ippsDAARijndael128Update
;; Caller = ippsDAARijndael128Final
;; Caller = ippsDAARijndael128MessageDigest
;;
align IPP_ALIGN_FACTOR
IPPASM Encrypt_RIJ128_AES_NI,PUBLIC
  USES_GPR esi,edi

%xdefine pInpBlk [esp + ARG_1 + 0*sizeof(dword)] ; input  block address
%xdefine pOutBlk [esp + ARG_1 + 1*sizeof(dword)] ; output block address
%xdefine nr      [esp + ARG_1 + 2*sizeof(dword)] ; number of rounds
%xdefine pKey    [esp + ARG_1 + 3*sizeof(dword)] ; key material address

%xdefine SC    (4)

   mov      esi,pInpBlk       ; input data address
   mov      ecx,pKey          ; key material address
   mov      eax,nr            ; number of rounds
   mov      edi,pOutBlk       ; output data address

   movdqu   xmm0, oword [esi] ; input block
   pxor     xmm0, oword [ecx] ; whitening

   ; get actual address of key material: pRKeys += (nr-9) * SC
   lea      edx,[eax*4]
   lea      ecx,[ecx+edx*4-9*(SC)*4]; AES-128-keys

   cmp      eax,12            ; switch according to number of rounds
   jl       .key_128
   jz       .key_192

   ;;
   ;; regular rounds
   ;;
.key_256:
   aesenc      xmm0,oword [ecx-4*4*SC]
   aesenc      xmm0,oword [ecx-3*4*SC]
.key_192:
   aesenc      xmm0,oword [ecx-2*4*SC]
   aesenc      xmm0,oword [ecx-1*4*SC]
.key_128:
   aesenc      xmm0,oword [ecx+0*4*SC]
   aesenc      xmm0,oword [ecx+1*4*SC]
   aesenc      xmm0,oword [ecx+2*4*SC]
   aesenc      xmm0,oword [ecx+3*4*SC]
   aesenc      xmm0,oword [ecx+4*4*SC]
   aesenc      xmm0,oword [ecx+5*4*SC]
   aesenc      xmm0,oword [ecx+6*4*SC]
   aesenc      xmm0,oword [ecx+7*4*SC]
   aesenc      xmm0,oword [ecx+8*4*SC]
   ;;
   ;; last rounds
   ;;
   aesenclast  xmm0,oword [ecx+9*4*SC]

   movdqu   oword [edi], xmm0 ; output block

   REST_GPR
   ret
ENDFUNC Encrypt_RIJ128_AES_NI
%endif

