;===============================================================================
; Copyright 2015-2018 Intel Corporation
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

IFNDEF __ASMDEFS_INC__
  __ASMDEFS_INC__=1

_IPP_PX=0    ; pure C-code ia32
_IPP_M5=1    ; Intel(R) Quark(TM) processor - ia32
_IPP_W7=8    ; Intel(R) Streaming SIMD Extensions 2 - ia32
_IPP_T7=16   ; Intel(R) Streaming SIMD Extensions 3 - ia32
_IPP_V8=32   ; Supplemental Streaming SIMD Extensions 3 (SSSE3)
_IPP_S8=33   ; SSSE3 + MOVBE instruction - ia32
_IPP_P8=64   ; Intel(R) Streaming SIMD Extensions 4.2 - ia32
_IPP_G9=128  ; Intel(R) Advanced Vector Extensions - ia32
_IPP_H9=256  ; Intel(R) Advanced Vector Extensions 2 - ia32
_IPP_I0=512  ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon Phi(TM) processor (formerly Knight Landing) - ia32
_IPP_S0=1024 ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon(R) processor (formerly Skylake) - ia32

_IPP32E_PX=_IPP_PX ; pure C-code x64
_IPP32E_M7=32   ; Intel(R) Streaming SIMD Extensions 3 - intel64
_IPP32E_U8=64   ; Supplemental Streaming SIMD Extensions 3 (SSSE3) - intel64
_IPP32E_N8=65   ; SSSE3 + MOVBE instruction - intel64
_IPP32E_Y8=128  ; Intel(R) Streaming SIMD Extensions 4.2 - intel64
_IPP32E_E9=256  ; Intel(R) Advanced Vector Extensions - intel64
_IPP32E_L9=512  ; Intel(R) Advanced Vector Extensions 2 - intel64
_IPP32E_N0=1024 ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon Phi(TM) processor (formerly Knight Landing) - intel64
_IPP32E_K0=2048 ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon(R) processor (formerly Skylake) - intel64

_IPP=_IPP_PX
_IPP32E=_IPP32E_PX


IFDEF _M5 ; Intel(R) Quark(TM) processor - ia32
    _IPP=_IPP_M5
ELSEIFDEF _W7 ; Intel(R) Streaming SIMD Extensions 2 - ia32
    _IPP=_IPP_W7
ELSEIFDEF _T7 ; Intel(R) Streaming SIMD Extensions 3 - ia32
    _IPP=_IPP_T7
ELSEIFDEF _V8 ; Supplemental Streaming SIMD Extensions 3 (SSSE3)
    _IPP=_IPP_V8
ELSEIFDEF _S8 ; SSSE3 + MOVBE instruction - ia32
    _IPP=_IPP_S8
ELSEIFDEF _P8 ; Intel(R) Streaming SIMD Extensions 4.2 - ia32
    _IPP=_IPP_P8
ELSEIFDEF _G9 ; Intel(R) Advanced Vector Extensions - ia32
     IPP_ALIGN_FACTOR EQU 32
    _IPP=_IPP_G9
ELSEIFDEF _H9 ; Intel(R) Advanced Vector Extensions 2 - ia32
     IPP_ALIGN_FACTOR EQU 32
    _IPP=_IPP_H9
ELSEIFDEF _S0 ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon(R) processor (formerly Skylake) - ia32
     IPP_ALIGN_FACTOR EQU 64
    _IPP=_IPP_S0
ELSEIFDEF _M7 ; Intel(R) Streaming SIMD Extensions 3 - intel64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_M7
ELSEIFDEF _U8 ; Supplemental Streaming SIMD Extensions 3 (SSSE3) - intel64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_U8
ELSEIFDEF _N8 ; SSSE3 + MOVBE instruction - intel64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_N8
ELSEIFDEF _Y8 ; Intel(R) Streaming SIMD Extensions 4.2 - intel64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_Y8
ELSEIFDEF _E9 ; Intel(R) Advanced Vector Extensions - intel64
     IPP_ALIGN_FACTOR EQU 32
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_E9
ELSEIFDEF _L9 ; Intel(R) Advanced Vector Extensions 2 - intel64
     IPP_ALIGN_FACTOR EQU 32
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_L9
ELSEIFDEF _N0 ; Intel(R) Advanced Vector Extensions 512 (formerly Knights Landing) - intel64
     IPP_ALIGN_FACTOR EQU 64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_N0
ELSEIFDEF _K0 ; Intel(R) Advanced Vector Extensions 512 - Intel(R) Xeon(R) processor (formerly Skylake) - intel64
     IPP_ALIGN_FACTOR EQU 64
    _IPP=_IPP_PX
    _IPP32E=_IPP32E_K0
ELSE
    _IPP=_IPP_PX ; pure C-code
ENDIF

IF (_IPP GT _IPP_H9)OR(_IPP32E GT _IPP32E_L9)
     IPP_ALIGN_FACTOR EQU 64
ELSEIF (_IPP GT _IPP_P8)OR(_IPP32E GT _IPP32E_Y8)
     IPP_ALIGN_FACTOR EQU 32
ELSE
     IPP_ALIGN_FACTOR EQU 16
ENDIF

IFDEF LINUX32
  IFNDEF OSX32
%ECHO .section .note.GNU-stack,"",%progbits
  ENDIF
ENDIF 

IFDEF LINUX32E
  IFNDEF OSXEM64T
    IFNDEF _ARCH_KNC
%ECHO .section .note.GNU-stack,"",%progbits
    ENDIF
  ENDIF
ENDIF 

ENDIF ; IFNDEF __ASMDEFS_INC__

;;;;;;;;;;;;;;;;;;;;;;;;;; End of file "asmdefs.inc" ;;;;;;;;;;;;;;;;;;;;;;;;;;
