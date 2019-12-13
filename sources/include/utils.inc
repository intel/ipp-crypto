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

%ifndef __UTILS_INC__
%define __UTILS_INC__ 1

; Helper macro that searches the input list for the specified element.
; Input:
; - First parameter - target element
; - Other parameters refer to the list where the search is processed.
; Output:
; - The macro is context dependent and upon the element is found, the context macro %$elem_exists will be defined.
%macro FIND_ELEM_IN_LIST 2-*.nolist
  %ifnctx _FIND_ELEM_IN_LIST_CTX_
    %fatal "Not in the context: _FIND_ELEM_IN_LIST_CTX_"
  %endif
  %define %%elem_to_check %1
  %rotate 1
  %undef %$elem_exists

  %rep %0-1
    %ifidni %%elem_to_check, %1
      %define %$elem_exists %1
      %exitrep
    %endif
  %rotate 1
  %endrep
%endmacro

; The macro searches intersection between two lists.
; Input:
; - The first list shall be provided as a parameters to the macro.
; - The second list shall be provided in the %$intersectable_list context macro.
; Output:
; - Intersection will be located in the %$instersection context macro (can be empty).
; - Count of intersection elements list will be stored in the %$cardinality context variable.
%macro INTERSECT 1-*.nolist
  %ifnctx _INTERSECT_CTX_
    %fatal "Not in the context: _INTERSECT_CTX_"
  %endif
  %ifndef %$intersectable_list
    %fatal "INTERSECT: no intersectable_list defined"
  %endif
  %define %$intersection
  %assign %$cardinality 0

  %push _FIND_ELEM_IN_LIST_CTX_
  %rep %0
    ; Compare with the reference list
    FIND_ELEM_IN_LIST %1,%$$intersectable_list
    %ifdef %$elem_exists
      ; Append element to the list
      %ifempty %$$intersection
        %define %$$intersection %1
      %else
        %define %$$intersection %[%$$intersection],%1
      %endif
      %assign %$$cardinality %$$cardinality + 1
    %endif
  %rotate 1
  %endrep
  %pop _FIND_ELEM_IN_LIST_CTX_
%endmacro

; Prepend specified instruction before each list element.
; The macro is context-dependent. The functor shall be provided in the %$mapfunc context macro.
; The order of list processing is managed by %$reverse_order context macro.
; Example: if %$mapfunc is 'pop' and list is 'r1,r2,r3', the macros will be expanded to:
;   pop r1
;   pop r2
;   pop r3
; If %$reverse_order is defined, the macros will be expanded to:
;   pop r3
;   pop r2
;   pop r1
%macro MAP 0-*.nolist
  %ifnctx _MAP_CTX_
    %fatal "Not in the context: _MAP_CTX_"
  %endif
  %ifndef %$mapfunc
    %fatal "MAP: no mapfunc is defined"
  %endif
  %ifndef %$reverse_order
    ; same order processing
    %rep %0
      %$mapfunc %1
    %rotate 1
    %endrep
  %else
    ; reverse order processing
    %rep %0
    %rotate -1
      %$mapfunc %1
    %endrep
  %endif
%endmacro

; Helper macro to concatenate two lists.
; The result will be stored in the 3rd parameter that must be a macro identifier.
%macro CONCATENATE 3.nolist
  %ifnid %3
    %fatal "CONCATENATE: 3rd parameter must be a macro identifier."
  %endif
  %define %3 %[%1]
  %ifnempty %3
    %ifnempty %2
      %define %3 %[%3],%[%2]
    %endif
  %else
    %define %3 %[%2]
  %endif
%endmacro

%endif
