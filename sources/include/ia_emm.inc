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

%include "asmdefs.inc"
%include "ia_common.inc"
%include "utils.inc"

; Decorates function name with appropriate CPU prefix (for the merged library).
; The macro is context-dependent and returns decorated name in the %$decorated_func_name
; context variable.
%macro CPU_PREFIX_DECORATE 1.nolist
  %ifnctx _CPU_PREFIX_DECORATE_CTX_
    %fatal "Not in the context: _CPU_PREFIX_DECORATE_CTX_"
  %endif

  ; Add CPU-specific suffix for the dispatched library
  %ifdef _OWN_MERGED_BLD
    %if (_IPP == _IPP_PX)
      %xdefine %%func_name px_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_W7)
      %xdefine %%func_name w7_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_V8)
      %xdefine %%func_name v8_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_S8)
      %xdefine %%func_name s8_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_P8)
      %xdefine %%func_name p8_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_G9)
      %xdefine %%func_name g9_%1
      %assign %%decoration_length 3
    %endif
    %if (_IPP == _IPP_H9)
      %xdefine %%func_name h9_%1
      %assign %%decoration_length 3
    %endif
  %else
    %xdefine %%func_name %1
    %assign %%decoration_length 0
  %endif

  %ifndef %%func_name
    %fatal "CPU_PREFIX_DECORATE: unknown decoration for: _IPP = " _IPP
  %endif
  %xdefine %$decorated_func_name %[%%func_name]
  %assign %$decoration_length %%decoration_length
%endmacro

%define NONVOLATILE_REGS_32_GPR ebp,ebx,esi,edi

; Saves non-volatile GPR registers on stack.
; Input - list of used registers.
%macro USES_GPR 1+.nolist
  %assign LOCAL_FRAME 0
  %assign GPR_FRAME 0
  %define GPR_CUR

  %push _INTERSECT_CTX_
  %define %$intersectable_list %[NONVOLATILE_REGS_32_GPR]
  INTERSECT %1
  ; List of non-volatile GPR registers in the order they will be pushed on stack
  %xdefine GPR_CUR %$intersection
  %assign GPR_FRAME %$cardinality * 4
  %pop _INTERSECT_CTX_

  ; Push non-volatile GPRs on stack
  %push _MAP_CTX_
  %define %$mapfunc push
  MAP GPR_CUR
  %pop _MAP_CTX_

  ; Set up offset of arguments from ESP
  %assign ARG_1 %[GPR_FRAME + 4]
%endmacro

; Restore preliminary saved by USES_GPR non-volatile GPR registers from the stack.
; The macro shall be called after function processing.
%macro REST_GPR 0.nolist
  %ifndef GPR_CUR
    %fatal "REST_GPR: no GPR_CUR defined"
  %endif
  %push _MAP_CTX_
  %define %$mapfunc pop
  ; Specify reverse order list processing
  %define %$reverse_order
  MAP GPR_CUR
  %pop _MAP_CTX_
%endmacro

%macro LD_ADDR 2.nolist
  %xdefine %%reg %1
  %xdefine %%addr %2

%ifdef IPP_PIC
  call  %%LABEL
%%LABEL:  pop      %%reg
  sub   %%reg, %%LABEL-%%addr
%else
  lea   %%reg, [%%addr]
%endif
%endmacro
