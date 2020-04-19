;===============================================================================
; Copyright 2020 Intel Corporation
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

%ifndef OS_ASM_FILE
%define OS_ASM_FILE

%ifndef WIN_ABI
%ifidn __OUTPUT_FORMAT__, win64
%define WIN_ABI
%endif
%endif

%ifndef LINUX
%ifidn __OUTPUT_FORMAT__, elf64
%define LINUX
%endif
%endif

%ifdef LINUX
;;; macro to declare global symbols
;;;  - name : symbol name
;;;  - type : funtion or data
;;;  - scope : internal, private, default
%macro MKGLOBAL 2-3
   %xdefine %%name %1
   %xdefine %%type %2
   %xdefine %%scope %3

   %if (%0 == 3)
       global %%name:%%type %%scope
   %else
       global %%name:%%type
   %endif
%endmacro
%endif                          ; LINUX

%ifdef WIN_ABI
;;; macro to declare global symbols
;;;  - name : symbol name
;;;  - type : funtion or data
;;;  - scope : internal, private, default (ignored in win64 coff format)
%define MKGLOBAL(name,type,scope) global name
%endif                          ; WIN_ABI

%endif                          ; OS_ASM_FILE
