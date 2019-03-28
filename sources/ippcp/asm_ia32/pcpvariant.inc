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
;               Intel(R) Integrated Performance Primitives
;                   Cryptographic Primitives (ippcp)
; 
;      Purpose:
;         Define ippCP variant
; 
;  do not change definitions below!
; 

;;
;; modes of the feature
;;
_FEATURE_OFF_      =0   ;; feature is OFF
_FEATURE_ON_       =1   ;; feature is ON
_FEATURE_TICKTOCK_ =2   ;; dectect is feature OFF/ON

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;_XMM7560_ = 1
IFDEF _XMM7560_
include pcpvariant_xmm7560.inc
endif

;;_TXT_ACM_ = 1
IFDEF _TXT_ACM_
include pcpvariant_txt_acm.inc
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; it possible to force use of C-version of some implementtaions
;; instead of ASM one
;;
IFNDEF _USE_C_cpAdd_BNU_
_USE_C_cpAdd_BNU_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpSub_BNU_
_USE_C_cpSub_BNU_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpInc_BNU_
_USE_C_cpInc_BNU_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpAddMulDgt_BNU_
_USE_C_cpAddMulDgt_BNU_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpMulAdc_BNU_school_
_USE_C_cpMulAdc_BNU_school_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpSqrAdc_BNU_school_
_USE_C_cpSqrAdc_BNU_school_ = _FEATURE_OFF_
ENDIF

IFNDEF _USE_C_cpMontRedAdc_BNU_
_USE_C_cpMontRedAdc_BNU_ = _FEATURE_OFF_
ENDIF

;;
;; if there is no outside assignment
;; set _SHA_NI_ENABLING_  based on CPU specification
;;
IFNDEF _SHA_NI_ENABLING_
   IF (_IPP GE _IPP_P8 )
      _SHA_NI_ENABLING_ = _FEATURE_TICKTOCK_
   ELSE
      _SHA_NI_ENABLING_ = _FEATURE_OFF_
   ENDIF
ENDIF

;;
;; select Hash algorithm
;;
IFNDEF _DISABLE_ALG_SHA1_
   _ENABLE_ALG_SHA1_   = _FEATURE_ON_  ;; SHA1 on
ELSE
   _ENABLE_ALG_SHA1_   = _FEATURE_OFF_ ;; SHA1 on
ENDIF

IFNDEF _DISABLE_ALG_SHA256_
   _ENABLE_ALG_SHA256_ = _FEATURE_ON_  ;; SHA256 on
ELSE
   _ENABLE_ALG_SHA256_ = _FEATURE_OFF_ ;; SHA256 off
ENDIF

IFNDEF _DISABLE_ALG_SHA521_
   _ENABLE_ALG_SHA512_ = _FEATURE_ON_  ;; SHA512 on
ELSE
   _ENABLE_ALG_SHA512_ = _FEATURE_OFF_ ;; SHA512 off
ENDIF

IFNDEF _DISABLE_ALG_MD5_
   _ENABLE_ALG_MD5_    = _FEATURE_ON_  ;; MD5 on
ELSE
   _ENABLE_ALG_MD5_    = _FEATURE_OFF_ ;; MD5 off
ENDIF

IFNDEF _DISABLE_ALG_SM3_
   _ENABLE_ALG_SM3_    = _FEATURE_ON_  ;; SM3 on
ELSE
   _ENABLE_ALG_SM3_    = _FEATURE_OFF_ ;; SM3 off
ENDIF


_ENABLE_KARATSUBA_ = 0     ;; not use Karatsuba method for multiplication

_NUSE    = 0   ;; do not use use
_USE     = 1   ;; do use

;; ~ 5.0
_USE_NN_MUL_BNU_FS_  = _NUSE  ;; use/not use NN version of full-size multiplication
_USE_NN_MONTMUL_     = _NUSE  ;; use/not use NN version of Montgomery multiplication

