;===============================================================================
; Copyright 2022 Intel Corporation
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;===============================================================================

;
;
;     Purpose:  Delay function, ia32 version
;
;     Content:
;       _ippcpDelay()
;

%include "asmdefs.inc"
%include "ia_emm.inc"

segment .text align=IPP_ALIGN_FACTOR

;***************************************************************
;* Purpose:    delay
;*
;* void _ippcpDelay(Ipp32u value)
;*
;* Caller = cpAESRandomNoise
;***************************************************************
align IPP_ALIGN_FACTOR
IPPASM _ippcpDelay,PUBLIC

%xdefine delayVal [esp + 4] ; indent through the return address

    mov ecx,delayVal

.Loop:
    mov eax,ecx
    dec ecx
    test eax,eax
    jnz .Loop

    ret
ENDFUNC _ippcpDelay
