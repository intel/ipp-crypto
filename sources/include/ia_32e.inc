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

;  Last version 04.12.04 for ML64 Version 8.00.41111 (PNI+x87+MMX(TM) technology supported)
; 
;  Bug for PMULUDQ fixed with MACRO substitution
; 
;  The latest version from 25.04.07: Kobby' mni macro substituted with IPP
;  realization (because of erroneous REX byte for addressing with sib byte,
;  high gpr set and scaling==1 - for instance [r8+r9]) also SNI support
;  added.
; 
;  26.01.2009 - USES_XMM_AVX & REST_XMM_AVX added - 'v' prefix instructions
;  are used now for save/restore XMM and YMM registers + automatic "vzeroupper"
;  in REST_XMM_AVX macro
; 
;  14.12.2009 - FMA macro added for AVX2.0 (ml10.0 support only)
;  10.02.2012 - the "f" declared local in USES_GPR, RES_GPR and IFSAME_XMM macros to avoid possible conflict
;  01.06.2012 - AVX2 vpsllvd/vq variable shifts added FMA macro fixed for ymm10-15 support
;  11.03.2013 - BDW adcx/adox added
.XLIST
;.LISTALL
;.LIST
;.LISTIF
;.LISTMACROALL

include asmdefs.inc

CurVer TEXTEQU @Version
IF @Version GT 900
  D_ML900 equ 1
ELSE
  ymmword equ oword
ENDIF

IF @Version GE 1100
  ML1100 equ 1
ENDIF

IF @Version GE 1200
  ML1200 equ 1
ENDIF

IF @Version GE 1400
  ML1400 equ 1
ENDIF

IFNDEF LINUX32E
 IFNDEF WIN32E
    .ERR <Platform is not defined { LINUX32E or WIN32E }>
     ECHO LINUX32E or WIN32E - Linux ABI (parameter passing in rdi, rsi, rdx, rcx, r8, r9...)
    END
 ENDIF
ENDIF

IFDEF LINUX32E
  IFDEF STACK_ABI
    IPP_ABI = 2
  ELSE
    IPP_ABI = 3
  ENDIF
ENDIF

IFDEF WIN32E
  IFDEF STACK_ABI
    IPP_ABI = 1
  ELSE
    IPP_ABI = 0
  ENDIF
ENDIF

IPPASM macro x:req, y:VARARG
 IFDEF _OWN_MERGED_BLD
  IF _IPP32E EQ _IPP32E_PX
    @CatStr(<mx_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_M7
    @CatStr(<m7_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_U8
    @CatStr(<u8_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_N8
    @CatStr(<n8_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_Y8
    @CatStr(<y8_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_E9
    @CatStr(<e9_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_L9 
    @CatStr(<l9_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_N0 
    @CatStr(<n0_>, <x>)
  ENDIF
  IF _IPP32E EQ _IPP32E_K0
    @CatStr(<k0_>, <x>)
  ENDIF
 ELSE
    @CatStr(<>, <x>)
 ENDIF
endm

DEFINED MACRO symbol:REQ
  IFDEF symbol
    EXITM <-1>
  ELSE
    EXITM <0>
  ENDIF
ENDM


IFSAME_GPR MACRO x, f
  LOCAL y
    FOR y,<rbx,rbp,r12,r13,r14,r15,RBX,RBP,R12,R13,R14,R15>
      IFIDN <y>,<x>
        f = 1
        EXITM
      ENDIF
    ENDM
    IF IPP_ABI LT 2
      FOR y,<rsi,RSI,rdi,RDI>
        IFIDN <y>,<x>
          f = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
ENDM

GPR_CUR textequ <>
XMM_CUR textequ <>

@ArgRev MACRO arglist:vararg
    LOCAL txt, arg
    txt TEXTEQU <>
    FOR arg, <arglist>
        txt CATSTR <arg>, <!,>, txt
    ENDM
    IF @SizeStr( %txt ) GT 0
      txt SUBSTR  txt, 1, @SizeStr( %txt ) - 1
    ENDIF
    txt CATSTR  <!<>, txt, <!>>
    EXITM txt
ENDM

USES_GPR MACRO z:vararg
  LOCAL y, f
  LOCAL_FRAME = 0
    GPR_FRAME = 0
    GPR_CUR textequ @ArgRev( z )
    f = 0
    FOR y,<z>
      IFSAME_GPR y,f
      IF f GT 0
        GPR_FRAME = GPR_FRAME + 8
        push y
        .PUSHREG y
        f = 0
      ENDIF
    ENDM
ENDM

REST_GPR MACRO z:vararg
    LOCAL u, f
    f = 0
    %FOR u, GPR_CUR
      IFSAME_GPR u,f
      IF f GT 0
        pop u
        f = 0
      ENDIF
    ENDM
ENDM

IFSAME_XMM MACRO x, isFound
  LOCAL y, isFound
    isFound = 0
    FOR y,<xmm6,XMM6,xmm7,XMM7,xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15>
      IFIDN <y>,<x>
        isFound = 1
        EXITM
      ENDIF
    ENDM
ENDM

USES_XMM MACRO z:vararg
  LOCAL y
  XMM_CUR TEXTEQU <>
  S_FRAME = 0
  LOCAL_FRAME = ( LOCAL_FRAME + 15 ) AND (-16)
  IF IPP_ABI LT 2
    T_FRAME = 0
    FOR y,<z>
      IFSAME_XMM y, isFound
      IF isFound GT 0
        XMM_CUR CATSTR <y>, <!,>, XMM_CUR
        T_FRAME = T_FRAME + 16
      ENDIF
    ENDM
    IF @SizeStr( %XMM_CUR ) GT 0
      XMM_CUR SUBSTR XMM_CUR, 1, @SizeStr( %XMM_CUR ) - 1
    ENDIF
    XMM_CUR CATSTR  <!<>, XMM_CUR, <!>>
    IF (( T_FRAME GT 0 ) OR ( LOCAL_FRAME GT 0 ))
      S_FRAME = T_FRAME + LOCAL_FRAME
      IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
        S_FRAME = S_FRAME + 8
      ENDIF
    ENDIF
    IF S_FRAME GT 0
      sub   rsp,S_FRAME
      .ALLOCSTACK S_FRAME
      T_FRAME = LOCAL_FRAME
      %FOR y, XMM_CUR
        IFSAME_XMM y, isFound
        IF isFound GT 0
          movdqa  [rsp+T_FRAME],y
          .SAVEXMM128 y,T_FRAME
          T_FRAME = T_FRAME + 16
        ENDIF
      ENDM
    ENDIF
  ELSE
    IF IPP_ABI EQ 2
      S_FRAME = 48 + LOCAL_FRAME   ;; 48 = 6 * 8 - stack frame for 6 register inputs
      IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
        S_FRAME = S_FRAME + 8
      ENDIF
      INP_FRAME = S_FRAME - 48 ;; for Linux32s-key stack-frame for 6 registers inputs...
    ELSE
      IF LOCAL_FRAME GT 0
        S_FRAME = LOCAL_FRAME
        IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
          S_FRAME = S_FRAME + 8
        ENDIF
      ENDIF
    ENDIF
    IF S_FRAME GT 0
      sub   rsp,S_FRAME
    ENDIF
  ENDIF
ENDM

REST_XMM MACRO z:vararg
  LOCAL y
  IF IPP_ABI LT 2
    IF S_FRAME GT 0
      T_FRAME = LOCAL_FRAME
      %FOR y, XMM_CUR
          movdqa  y,[rsp+T_FRAME]
          T_FRAME = T_FRAME + 16
      ENDM
      add   rsp,S_FRAME
    ENDIF
  ELSE
    IF S_FRAME GT 0
      add   rsp,S_FRAME
    ENDIF
  ENDIF
  IF _IPP32E GE _IPP32E_E9
    IF _IPP32E NE _IPP32E_N0
      vzeroupper
    ENDIF
  ENDIF
ENDM


SAVE_XMM textequ <!<xmm6,XMM6,xmm7,XMM7,xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15!>>
SAVE_YMM textequ <!<ymm6,YMM6,ymm7,YMM7,ymm8,YMM8,ymm9,YMM9,ymm10,YMM10,ymm11,YMM11,ymm12,YMM12,ymm13,YMM13,ymm14,YMM14,ymm15,YMM15!>>

IS_SAVEX MACRO x, f
    f = 0
    %FOR yrex,SAVE_XMM                  ; if xmm from 6-15 range and Windows - must be saved
      IFIDN   <yrex>,<x>
        f = 1
        EXITM
      ENDIF
    ENDM
ENDM

IS_SAVEY MACRO x, f
    f = 0
    %FOR yrex,SAVE_YMM                  ; if xmm from 6-15 range and Windows - must be saved
      IFIDN   <yrex>,<x>
        f = 1
        EXITM
      ENDIF
    ENDM
ENDM

USES_XMM_AVX MACRO z:vararg
  LOCAL y, f
  XMM_CUR TEXTEQU <>
  S_FRAME = 0
  LOCAL_FRAME = ( LOCAL_FRAME + 15 ) AND (-16)
  IF IPP_ABI LT 2
    T_FRAME = 0
    FOR y,<z>
      IS_SAVEX y, f
      IF f GT 0
        XMM_CUR CATSTR <y>, <!,>, XMM_CUR
        T_FRAME = T_FRAME + 16
      ENDIF
    ENDM
    FOR y,<z>
      IS_SAVEY y, f
      IF f GT 0
        XMM_CUR CATSTR <y>, <!,>, XMM_CUR
        T_FRAME = T_FRAME + 32
      ENDIF
    ENDM
    IF @SizeStr( %XMM_CUR ) GT 0
      XMM_CUR SUBSTR XMM_CUR, 1, @SizeStr( %XMM_CUR ) - 1
    ENDIF
    XMM_CUR CATSTR  <!<>, XMM_CUR, <!>>
    IF (( T_FRAME GT 0 ) OR ( LOCAL_FRAME GT 0 ))
      S_FRAME = T_FRAME + LOCAL_FRAME
      IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
        S_FRAME = S_FRAME + 8
      ENDIF
    ENDIF
    IF S_FRAME GT 0
      sub   rsp,S_FRAME
      .ALLOCSTACK S_FRAME
      T_FRAME = LOCAL_FRAME
      %FOR y, XMM_CUR
        IS_SAVEX y, f
        IF f GT 0
          vmovdqa  oword ptr [rsp+T_FRAME],y
          .SAVEXMM128 y,T_FRAME
          T_FRAME = T_FRAME + 16
        ENDIF
      ENDM
      %FOR y, XMM_CUR
        IS_SAVEY y, f
        IF f GT 0
           vmovdqu ymmword ptr [rsp+T_FRAME], y
           T_FRAME = T_FRAME + 32
;          vextractf128  oword ptr [rsp+T_FRAME],y,0
;          .SAVEXMM128 y,T_FRAME
;          T_FRAME = T_FRAME + 16
;          vextractf128  oword ptr [rsp+T_FRAME],y,1
;          .SAVEXMM128 y,T_FRAME
;          T_FRAME = T_FRAME + 16
        ENDIF
      ENDM
    ENDIF
  ELSE
    IF IPP_ABI EQ 2
      S_FRAME = 48 + LOCAL_FRAME   ;; 48 = 6 * 8 - stack frame for 6 register inputs
      IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
        S_FRAME = S_FRAME + 8
      ENDIF
      INP_FRAME = S_FRAME - 48 ;; for Linux32s-key stack-frame for 6 registers inputs...
    ELSE
      IF LOCAL_FRAME GT 0
        S_FRAME = LOCAL_FRAME
        IF (( S_FRAME + GPR_FRAME ) AND 8 ) EQ 0
          S_FRAME = S_FRAME + 8
        ENDIF
      ENDIF
    ENDIF
    IF S_FRAME GT 0
      sub   rsp,S_FRAME
    ENDIF
  ENDIF
ENDM

REST_XMM_AVX MACRO z:vararg
  LOCAL y, f
  IF IPP_ABI LT 2
    IF S_FRAME GT 0
      T_FRAME = LOCAL_FRAME
      %FOR y, XMM_CUR
        IS_SAVEX y, f
        IF f GT 0
          vmovdqa  y, oword ptr [rsp+T_FRAME]
          T_FRAME = T_FRAME + 16
        ENDIF
      ENDM
      %FOR y, XMM_CUR
        IS_SAVEY y, f
        IF f GT 0
          vmovdqu y, ymmword ptr [rsp+T_FRAME]
          T_FRAME = T_FRAME + 32
;          vinsertf128  y,y,oword ptr [rsp+T_FRAME],0
;          T_FRAME = T_FRAME + 16
;          vinsertf128  y,y,oword ptr [rsp+T_FRAME],1
;          T_FRAME = T_FRAME + 16
        ENDIF
      ENDM
      add   rsp,S_FRAME
    ENDIF
  ELSE
    IF S_FRAME GT 0
      add   rsp,S_FRAME
    ENDIF
  ENDIF
  IF _IPP32E NE _IPP32E_N0
    vzeroupper
  ENDIF
ENDM

COMP_ABI MACRO x
  IF IPP_ABI EQ 0                           ;; if defined win32e
    IF x GT 0
      mov   rdi,rcx                         ;; ARG_1
    ENDIF
    IF x GT 1
      mov   rsi,rdx                         ;; ARG_2
    ENDIF
    IF x GT 2
      mov   rdx,r8                          ;; ARG_3
    ENDIF
    IF x GT 3
      mov   rcx,r9                          ;; ARG_4
    ENDIF
    IF x GT 4
      mov   r8,[rsp+S_FRAME+GPR_FRAME+40]   ;; ARG_5
    ENDIF
    IF x GT 5
      mov   r9,[rsp+S_FRAME+GPR_FRAME+48]   ;; ARG_6
    ENDIF
    IF x GT 6
      FIRST_P = S_FRAME+GPR_FRAME+56        ;; ARG_7
      ARG_7   = S_FRAME+GPR_FRAME+56
    ENDIF
  ENDIF
  IF IPP_ABI EQ 1                           ;; if defined win32s
    FIRST_P = S_FRAME+GPR_FRAME+8
    IF x GT 0
      mov   [rsp+FIRST_P],rcx
      ARG_1 = FIRST_P
    ENDIF
    IF x GT 1
      mov   [rsp+FIRST_P+8],rdx
      ARG_2 = ARG_1+8
    ENDIF
    IF x GT 2
      mov   [rsp+FIRST_P+16],r8
      ARG_3 = ARG_2+8
    ENDIF
    IF x GT 3
      mov   [rsp+FIRST_P+24],r9
      ARG_4 = ARG_3+8
    ENDIF
    IF x GT 4
      ARG_5 = ARG_4+8
    ENDIF
    IF x GT 5
      ARG_6 = ARG_5+8
    ENDIF
    IF x GT 6
      ARG_7   = ARG_6+8                     ;; ARG_7
    ENDIF
  ENDIF
  IF IPP_ABI EQ 2                           ;; if defined linux32s
    FIRST_P = INP_FRAME
    IF x GT 0
      mov   [rsp+FIRST_P],rdi
      ARG_1 = FIRST_P
    ENDIF
    IF x GT 1
      mov   [rsp+FIRST_P+8],rsi
      ARG_2 = ARG_1+8
    ENDIF
    IF x GT 2
      mov   [rsp+FIRST_P+16],rdx
      ARG_3 = ARG_2+8
    ENDIF
    IF x GT 3
      mov   [rsp+FIRST_P+24],rcx
      ARG_4 = ARG_3+8
    ENDIF
    IF x GT 4
      mov   [rsp+FIRST_P+32],r8
      ARG_5 = ARG_4+8
    ENDIF
    IF x GT 5
      mov   [rsp+FIRST_P+40],r9
      ARG_6 = ARG_5+8
    ENDIF
    IF x GT 6
      ARG_7 = S_FRAME+GPR_FRAME+8
    ENDIF
  ENDIF
  IF IPP_ABI EQ 3
    IF x GT 6 ;; ARG_1 = rdi ARG_2 = rsi ARG_3 = rdx ARG_4 = rcx ARG_5 = r8 ARG_6 = r9
      FIRST_P = S_FRAME+GPR_FRAME+8         ;; ARG_7
      ARG_7   = S_FRAME+GPR_FRAME+8
    ENDIF
  ENDIF
  IF x GT 7
    ARG_8   = ARG_7+8                       ;; ARG_8
  ENDIF
  IF x GT 8
    ARG_9   = ARG_8+8                       ;; ARG_9
  ENDIF
  IF x GT 9
    ARG_10  = ARG_9+8                       ;; ARG_10
  ENDIF
  IF x GT 10
    ARG_11  = ARG_10+8                      ;; ARG_11
  ENDIF
  IF x GT 11
    ARG_12  = ARG_11+8                      ;; ARG_12
  ENDIF
  IF x GT 12
    ARG_13  = ARG_12+8                      ;; ARG_13
  ENDIF
  IF x GT 13
    ARG_14  = ARG_13+8                      ;; ARG_14
  ENDIF
  IF x GT 14
    ARG_15  = ARG_14+8                      ;; ARG_15
  ENDIF
  IF x GT 15
    ARG_16  = ARG_15+8                      ;; ARG_16
  ENDIF
  IF x GT 16
    ARG_17  = ARG_16+8                      ;; ARG_17
  ENDIF
  IF x GT 17
    ARG_18  = ARG_17+8                      ;; ARG_18
  ENDIF
;  IF IPP_ABI LT 2                           ;; Windows
  .ENDPROLOG
;  ENDIF
ENDM

; MNI (TNI) SNI (SSE4.1) STTNI (SSE4.2)

IF DEFINED (LINUX32E) OR DEFINED (_YASM)  ; MNI macro for Linux or for Windows

    sha1rnds4 MACRO op1:req, op2:req, imm8:req
        %ECHO @CatStr(<sha1rnds4 >, < op1,>, < op2,>, < imm8 >)
    endm
    sha1nexte MACRO op1:req, op2:req
        %ECHO @CatStr(<sha1nexte >, < op1,>, < op2 >)
    endm
    sha1msg1 MACRO op1:req, op2:req
        %ECHO @CatStr(<sha1msg1 >, < op1,>, < op2 >)
    endm
    sha1msg2 MACRO op1:req, op2:req
        %ECHO @CatStr(<sha1msg2 >, < op1,>, < op2 >)
    endm
    sha256msg1 MACRO op1:req, op2:req
        %ECHO @CatStr(<sha256msg1 >, < op1,>, < op2 >)
    endm
    sha256msg2 MACRO op1:req, op2:req
        %ECHO @CatStr(<sha256msg2 >, < op1,>, < op2 >)
    endm
    sha256rnds2 MACRO op1:req, op2:req
        %ECHO @CatStr(<sha256rnds2 >, < op1,>, < op2 >)
    endm

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MNI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 IFNDEF ML1200
  adcx macro x:req, z:req
    %ECHO @CatStr(<adcx >, < x,>, < z >)
  endm
  adox macro x:req, z:req
    %ECHO @CatStr(<adox >, < x,>, < z >)
  endm

 IFNDEF ML1100
 IFNDEF D_ML900

  phaddw macro x:req, y:req
    %ECHO @CatStr(<phaddw >, < x,>, < y >)
  endm
  phaddd macro x:req, y:req
    %ECHO @CatStr(<phaddd >, < x,>, < y >)
  endm
  phaddsw macro x:req, y:req
    %ECHO @CatStr(<phaddsw >, < x,>, < y >)
  endm
  phsubw macro x:req, y:req
    %ECHO @CatStr(<phsubw >, < x,>, < y >)
  endm
  phsubd macro x:req, y:req
    %ECHO @CatStr(<phsubd >, < x,>, < y >)
  endm
  phsubsw macro x:req, y:req
    %ECHO @CatStr(<phsubsw >, < x,>, < y >)
  endm
  pmaddubsw macro x:req, y:req
    %ECHO @CatStr(<pmaddubsw >, < x,>, < y >)
  endm
  pmulhrsw macro x:req, y:req
    %ECHO @CatStr(<pmulhrsw >, < x,>, < y >)
  endm
  pshufb macro x:req, y:req
    %ECHO @CatStr(<pshufb >, < x,>, < y >)
  endm
  psignb macro x:req, y:req
    %ECHO @CatStr(<psignb >, < x,>, < y >)
  endm
  psignw macro x:req, y:req
    %ECHO @CatStr(<psignw >, < x,>, < y >)
  endm
  psignd macro x:req, y:req
    %ECHO @CatStr(<psignd >, < x,>, < y >)
  endm
  palignr macro x:req, y:req, z:req
    %ECHO @CatStr(<palignr >, < x,>, < y,>, < z >)
  endm
  pabsb macro x:req, y:req
    %ECHO @CatStr(<pabsb >, < x,>, < y >)
  endm
  pabsw macro x:req, y:req
    %ECHO @CatStr(<pabsw >, < x,>, < y >)
  endm
  pabsd macro x:req, y:req
    %ECHO @CatStr(<pabsd >, < x,>, < y >)
  endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SNI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  blendpd macro x:req, y:req, z:req
    %ECHO @CatStr(<blendpd >, < x,>, < y,>, < z >)
  endm
  blendps macro x:req, y:req, z:req
    %ECHO @CatStr(<blendps >, < x,>, < y,>, < z >)
  endm
  blendvpd macro x:req, y:req, z
    %ECHO @CatStr(<blendvpd >, < x,>, < y>)
  endm
  blendvps macro x:req, y:req, z
    %ECHO @CatStr(<blendvps >, < x,>, < y>)
  endm
  dppd macro x:req, y:req, z:req
    %ECHO @CatStr(<dppd >, < x,>, < y,>, < z >)
  endm
  dpps macro x:req, y:req, z:req
    %ECHO @CatStr(<dpps >, < x,>, < y,>, < z >)
  endm
  extractps macro x:req, y:req, z:req
    %ECHO @CatStr(<extractps >, < x,>, < y,>, < z >)
  endm
  insertps macro x:req, y:req, z:req
    %ECHO @CatStr(<insertps >, < x,>, < y,>, < z >)
  endm
  movntdqa macro x:req, y:req
    %ECHO @CatStr(<movntdqa >, < x,>, < y>)
  endm
  mpsadbw macro x:req, y:req, z:req
    %ECHO @CatStr(<mpsadbw >, < x,>, < y,>, < z >)
  endm
  packusdw macro x:req, y:req
    %ECHO @CatStr(<packusdw >, < x,>, < y>)
  endm
  pblendvb macro x:req, y:req, z
    %ECHO @CatStr(<pblendvb >, < x,>, < y>)
  endm
  pblendw macro x:req, y:req, z:req
    %ECHO @CatStr(<pblendw >, < x,>, < y,>, < z >)
  endm
  pcmpeqq macro x:req, y:req
    %ECHO @CatStr(<pcmpeqq >, < x,>, < y>)
  endm
  pextrb macro x:req, y:req, z:req
    %ECHO @CatStr(<pextrb >, < x,>, < y,>, < z >)
  endm
  pextrd macro x:req, y:req, z:req
    %ECHO @CatStr(<pextrd >, < x,>, < y,>, < z >)
  endm
  pextrq macro x:req, y:req, z:req
    %ECHO @CatStr(<pextrq >, < x,>, < y,>, < z >)
  endm
IF _IPP32E GE _IPP32E_Y8
  OPTION NOKEYWORD:<pextrw>
  pextrw macro x:req, y:req, z:req
    %ECHO @CatStr(<pextrw >, < x,>, < y,>, < z >)
  endm
ENDIF
  phminposuw macro x:req, y:req
    %ECHO @CatStr(<phminposuw >, < x,>, < y>)
  endm
  pinsrb macro x:req, y:req, z:req
    %ECHO @CatStr(<pinsrb >, < x,>, < y,>, < z >)
  endm
  pinsrd macro x:req, y:req, z:req
    %ECHO @CatStr(<pinsrd >, < x,>, < y,>, < z >)
  endm
  pinsrq macro x:req, y:req, z:req
    %ECHO @CatStr(<pinsrq >, < x,>, < y,>, < z >)
  endm
  pmaxsb macro x:req, y:req
    %ECHO @CatStr(<pmaxsb >, < x,>, < y>)
  endm
  pmaxsd macro x:req, y:req
    %ECHO @CatStr(<pmaxsd >, < x,>, < y>)
  endm
  pmaxud macro x:req, y:req
    %ECHO @CatStr(<pmaxud >, < x,>, < y>)
  endm
  pmaxuw macro x:req, y:req
    %ECHO @CatStr(<pmaxuw >, < x,>, < y>)
  endm
  pminsb macro x:req, y:req
    %ECHO @CatStr(<pminsb >, < x,>, < y>)
  endm
  pminsd macro x:req, y:req
    %ECHO @CatStr(<pminsd >, < x,>, < y>)
  endm
  pminud macro x:req, y:req
    %ECHO @CatStr(<pminud >, < x,>, < y>)
  endm
  pminuw macro x:req, y:req
    %ECHO @CatStr(<pminuw >, < x,>, < y>)
  endm
  pmovsxbw macro x:req, y:req
    %ECHO @CatStr(<pmovsxbw >, < x,>, < y>)
  endm
  pmovsxbd macro x:req, y:req
    %ECHO @CatStr(<pmovsxbd >, < x,>, < y>)
  endm
  pmovsxbq macro x:req, y:req
    %ECHO @CatStr(<pmovsxbq >, < x,>, < y>)
  endm
  pmovsxwd macro x:req, y:req
    %ECHO @CatStr(<pmovsxwd >, < x,>, < y>)
  endm
  pmovsxwq macro x:req, y:req
    %ECHO @CatStr(<pmovsxwq >, < x,>, < y>)
  endm
  pmovsxdq macro x:req, y:req
    %ECHO @CatStr(<pmovsxdq >, < x,>, < y>)
  endm
  pmovzxbw macro x:req, y:req
    %ECHO @CatStr(<pmovzxbw >, < x,>, < y>)
  endm
  pmovzxbd macro x:req, y:req
    %ECHO @CatStr(<pmovzxbd >, < x,>, < y>)
  endm
  pmovzxbq macro x:req, y:req
    %ECHO @CatStr(<pmovzxbq >, < x,>, < y>)
  endm
  pmovzxwd macro x:req, y:req
    %ECHO @CatStr(<pmovzxwd >, < x,>, < y>)
  endm
  pmovzxwq macro x:req, y:req
    %ECHO @CatStr(<pmovzxwq >, < x,>, < y>)
  endm
  pmovzxdq macro x:req, y:req
    %ECHO @CatStr(<pmovzxdq >, < x,>, < y>)
  endm
  pmuldq macro x:req, y:req
    %ECHO @CatStr(<pmuldq >, < x,>, < y>)
  endm
  pmulld macro x:req, y:req
    %ECHO @CatStr(<pmulld >, < x,>, < y>)
  endm
  ptest macro x:req, y:req
    %ECHO @CatStr(<ptest >, < x,>, < y>)
  endm
  roundpd macro x:req, y:req, z:req
    %ECHO @CatStr(<roundpd >, < x,>, < y,>, < z >)
  endm
  roundps macro x:req, y:req, z:req
    %ECHO @CatStr(<roundps >, < x,>, < y,>, < z >)
  endm
  roundsd macro x:req, y:req, z:req
    %ECHO @CatStr(<roundsd >, < x,>, < y,>, < z >)
  endm
  roundss macro x:req, y:req, z:req
    %ECHO @CatStr(<roundss >, < x,>, < y,>, < z >)
  endm
; SSE4.2
  pcmpestri macro x:req, y:req, z:req
    %ECHO @CatStr(<pcmpestri >, < x,>, < y,>, < z >)
  endm
  pcmpestrm macro x:req, y:req, z:req
    %ECHO @CatStr(<pcmpestrm >, < x,>, < y,>, < z >)
  endm
  pcmpistri macro x:req, y:req, z:req
    %ECHO @CatStr(<pcmpistri >, < x,>, < y,>, < z >)
  endm
  pcmpistrm macro x:req, y:req, z:req
    %ECHO @CatStr(<pcmpistrm >, < x,>, < y,>, < z >)
  endm
  pcmpgtq macro x:req, y:req
    %ECHO @CatStr(<pcmpgtq >, < x,>, < y>)
  endm
  crc32 macro x:req, y:req
    %ECHO @CatStr(<crc32 >, < x,>, < y>)
  endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WSM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aesenc macro x:req, y:req
    %ECHO @CatStr(<aesenc >, < x,>, < y>)
  endm
aesenclast macro x:req, y:req
    %ECHO @CatStr(<aesenclast >, < x,>, < y>)
  endm
aesdec macro x:req, y:req
    %ECHO @CatStr(<aesdec >, < x,>, < y>)
  endm
aesdeclast macro x:req, y:req
    %ECHO @CatStr(<aesdeclast >, < x,>, < y>)
  endm
aesimc macro x:req, y:req
    %ECHO @CatStr(<aesimc >, < x,>, < y>)
  endm
aeskeygenassist macro x:req, y:req, z:req
    %ECHO @CatStr(<aeskeygenassist >, < x,>, < y,>, < z >)
  endm
pclmulqdq macro x:req, y:req, z:req
    %ECHO @CatStr(<pclmulqdq >, < x,>, < y,>, < z >)
  endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; AVX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vaesenc macro x:req, y:req, z:req
    %ECHO @CatStr(<vaesenc >, < x,>, < y,>, < z >)
  endm
vaesenclast macro x:req, y:req, z:req
    %ECHO @CatStr(<vaesenclast >, < x,>, < y,>, < z >)
  endm
vaesdec macro x:req, y:req, z:req
    %ECHO @CatStr(<vaesdec >, < x,>, < y,>, < z >)
  endm
vaesdeclast macro x:req, y:req, z:req
    %ECHO @CatStr(<vaesdeclast >, < x,>, < y,>, < z >)
  endm
vaesimc macro x:req, y:req
    %ECHO @CatStr(<vaesimc >, < x,>, < y>)
  endm
vaeskeygenassist macro x:req, y:req, z:req
    %ECHO @CatStr(<vaeskeygenassist >, < x,>, < y,>, < z >)
  endm
vaddpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddpd >, < x,>, < y,>, < z >)
  endm
vaddps macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddps >, < x,>, < y,>, < z >)
  endm
vaddsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddsd >, < x,>, < y,>, < z >)
  endm
vaddss macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddss >, < x,>, < y,>, < z >)
  endm
vaddsubpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddsubpd >, < x,>, < y,>, < z >)
  endm
vaddsubps macro x:req, y:req, z:req
    %ECHO @CatStr(<vaddsubps >, < x,>, < y,>, < z >)
  endm
vandpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vandpd >, < x,>, < y,>, < z >)
  endm
vandps macro x:req, y:req, z:req
    %ECHO @CatStr(<vandps >, < x,>, < y,>, < z >)
  endm
vandnpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vandnpd >, < x,>, < y,>, < z >)
  endm
vandnps macro x:req, y:req, z:req
    %ECHO @CatStr(<vandnps >, < x,>, < y,>, < z >)
  endm
vblendpd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vblendpd >, < x,>, < y,>, < z,>, < imm>)
  endm
vblendps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vblendps >, < x,>, < y,>, < z,>, < imm>)
  endm
vblendvpd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vblendvpd >, < x,>, < y,>, < z,>, < imm>)
  endm
vblendvps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vblendvps >, < x,>, < y,>, < z,>, < imm>)
  endm
vbroadcastss macro x:req, y:req
    %ECHO @CatStr(<vbroadcastss >, < x,>, < y>)
  endm
vbroadcastsd macro x:req, y:req
    %ECHO @CatStr(<vbroadcastsd >, < x,>, < y>)
  endm
vbroadcastf128 macro x:req, y:req
    %ECHO @CatStr(<vbroadcastf128 >, < x,>, < y>)
  endm
vcmpeqpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpeqpd >, < x,>, < y,>, < z >)
  endm
vcmpltpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpltpd >, < x,>, < y,>, < z >)
  endm
vcmplepd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmplepd >, < x,>, < y,>, < z >)
  endm
vcmpunordpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpunordpd >, < x,>, < y,>, < z >)
  endm
vcmpneqpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpneqpd >, < x,>, < y,>, < z >)
  endm
vcmpnltpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnltpd >, < x,>, < y,>, < z >)
  endm
vcmpnlepd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnlepd >, < x,>, < y,>, < z >)
  endm
vcmpordpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpordpd >, < x,>, < y,>, < z >)
  endm
vcmppd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vcmppd >, < x,>, < y,>, < z,>, < imm>)
  endm
vcmpps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vcmpps >, < x,>, < y,>, < z,>, < imm>)
  endm
vcmpsd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vcmpsd >, < x,>, < y,>, < z,>, < imm>)
  endm
vcmpeqps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpeqps >, < x,>, < y,>, < z >)
  endm
vcmpltps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpltps >, < x,>, < y,>, < z >)
  endm
vcmpleps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpleps >, < x,>, < y,>, < z >)
  endm
vcmpunordps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpunordps >, < x,>, < y,>, < z >)
  endm
vcmpneqps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpneqps >, < x,>, < y,>, < z >)
  endm
vcmpnltps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnltps >, < x,>, < y,>, < z >)
  endm
vcmpnleps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnleps >, < x,>, < y,>, < z >)
  endm
vcmpordps macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpordps >, < x,>, < y,>, < z >)
  endm
vcmpeqsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpeqsd >, < x,>, < y,>, < z >)
  endm
vcmpltsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpltsd >, < x,>, < y,>, < z >)
  endm
vcmplesd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmplesd >, < x,>, < y,>, < z >)
  endm
vcmpunordsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpunordsd >, < x,>, < y,>, < z >)
  endm
vcmpneqsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpneqsd >, < x,>, < y,>, < z >)
  endm
vcmpnltsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnltsd >, < x,>, < y,>, < z >)
  endm
vcmpnlesd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnlesd >, < x,>, < y,>, < z >)
  endm
vcmpordsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpordsd >, < x,>, < y,>, < z >)
  endm
vcmpss macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vcmpss >, < x,>, < y,>, < z,>, < imm>)
  endm
vcmpeqss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpeqss >, < x,>, < y,>, < z >)
  endm
vcmpltss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpltss >, < x,>, < y,>, < z >)
  endm
vcmpless macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpless >, < x,>, < y,>, < z >)
  endm
vcmpunordss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpunordss >, < x,>, < y,>, < z >)
  endm
vcmpneqss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpneqss >, < x,>, < y,>, < z >)
  endm
vcmpnltss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnltss >, < x,>, < y,>, < z >)
  endm
vcmpnless macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpnless >, < x,>, < y,>, < z >)
  endm
vcmpordss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcmpordss >, < x,>, < y,>, < z >)
  endm
vcomisd macro x:req, y:req
    %ECHO @CatStr(<vcomisd >, < x,>, < y>)
  endm
vcomiss macro x:req, y:req
    %ECHO @CatStr(<vcomiss >, < x,>, < y>)
  endm
vcvtdq2pd macro x:req, y:req
    %ECHO @CatStr(<vcvtdq2pd >, < x,>, < y>)
  endm
vcvtdq2ps macro x:req, y:req
    %ECHO @CatStr(<vcvtdq2ps >, < x,>, < y>)
  endm
vcvtpd2dq macro x:req, y:req
    %ECHO @CatStr(<vcvtpd2dq >, < x,>, < y>)
  endm
vcvtpd2ps macro x:req, y:req
    %ECHO @CatStr(<vcvtpd2ps >, < x,>, < y>)
  endm
vcvtps2dq macro x:req, y:req
    %ECHO @CatStr(<vcvtps2dq >, < x,>, < y>)
  endm
vcvtps2pd macro x:req, y:req
    %ECHO @CatStr(<vcvtps2pd >, < x,>, < y>)
  endm
vcvtsd2si macro x:req, y:req
    %ECHO @CatStr(<vcvtsd2si >, < x,>, < y>)
  endm
vcvtsd2ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcvtsd2ss >, < x,>, < y,>, < z>)
  endm
vcvtsi2sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcvtsi2sd >, < x,>, < y,>, < z>)
  endm
vcvtsi2ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vcvtsi2ss >, < x,>, < y,>, < z>)
  endm
vcvtss2sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vcvtss2sd >, < x,>, < y,>, < z>)
  endm
vcvtss2si macro x:req, y:req
    %ECHO @CatStr(<vcvtss2si >, < x,>, < y>)
  endm
vcvttpd2dq macro x:req, y:req
    %ECHO @CatStr(<vcvttpd2dq >, < x,>, < y>)
  endm
vcvttps2dq macro x:req, y:req
    %ECHO @CatStr(<vcvttps2dq >, < x,>, < y>)
  endm
vcvttsd2si macro x:req, y:req
    %ECHO @CatStr(<vcvttsd2si >, < x,>, < y>)
  endm
vcvttss2si macro x:req, y:req
    %ECHO @CatStr(<vcvttss2si >, < x,>, < y>)
  endm
vdivpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vdivpd >, < x,>, < y,>, < z >)
  endm
vdivps macro x:req, y:req, z:req
    %ECHO @CatStr(<vdivps >, < x,>, < y,>, < z >)
  endm
vdivsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vdivsd >, < x,>, < y,>, < z >)
  endm
vdivss macro x:req, y:req, z:req
    %ECHO @CatStr(<vdivss >, < x,>, < y,>, < z >)
  endm
vdppd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vdppd >, < x,>, < y,>, < z,>, < imm>)
  endm
vdpps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vdpps >, < x,>, < y,>, < z,>, < imm>)
  endm
vextractf128 macro x:req, y:req, z:req
    %ECHO @CatStr(<vextractf128 >, < x,>, < y,>, < z >)
  endm
vextractps macro x:req, y:req, z:req
    %ECHO @CatStr(<vextractps >, < x,>, < y,>, < z >)
  endm
vhaddpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vhaddpd >, < x,>, < y,>, < z >)
  endm
vhaddps macro x:req, y:req, z:req
    %ECHO @CatStr(<vhaddps >, < x,>, < y,>, < z >)
  endm
vhsubpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vhsubpd >, < x,>, < y,>, < z >)
  endm
vhsubps macro x:req, y:req, z:req
    %ECHO @CatStr(<vhsubps >, < x,>, < y,>, < z >)
  endm
vinsertf128 macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vinsertf128 >, < x,>, < y,>, < z,>, < imm>)
  endm
vinsertps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vinsertps >, < x,>, < y,>, < z,>, < imm>)
  endm
vlddqu macro x:req, y:req
    %ECHO @CatStr(<vlddqu >, < x,>, < y>)
  endm
vldmxcsr macro x:req
    %ECHO @CatStr(<vldmxcsr >, < x>)
  endm
vmaskmovdqu macro x:req, y:req
    %ECHO @CatStr(<vmaskmovdqu >, < x,>, < y>)
  endm
vmaskmovpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaskmovpd >, < x,>, < y,>, < z >)
  endm
vmaskmovps macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaskmovps >, < x,>, < y,>, < z >)
  endm
vmaxpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaxpd >, < x,>, < y,>, < z >)
  endm
vmaxps macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaxps >, < x,>, < y,>, < z >)
  endm
vmaxsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaxsd >, < x,>, < y,>, < z >)
  endm
vmaxss macro x:req, y:req, z:req
    %ECHO @CatStr(<vmaxss >, < x,>, < y,>, < z >)
  endm
vminpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vminpd >, < x,>, < y,>, < z >)
  endm
vminps macro x:req, y:req, z:req
    %ECHO @CatStr(<vminps >, < x,>, < y,>, < z >)
  endm
vminsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vminsd >, < x,>, < y,>, < z >)
  endm
vminss macro x:req, y:req, z:req
    %ECHO @CatStr(<vminss >, < x,>, < y,>, < z >)
  endm
vmovapd macro x:req, y:req
    %ECHO @CatStr(<vmovapd >, < x,>, < y>)
  endm
vmovaps macro x:req, y:req
    %ECHO @CatStr(<vmovaps >, < x,>, < y>)
  endm
vmovd macro x:req, y:req
    %ECHO @CatStr(<vmovd >, < x,>, < y>)
  endm
vmovddup macro x:req, y:req
    %ECHO @CatStr(<vmovddup >, < x,>, < y>)
  endm
vmovdqa macro x:req, y:req
    %ECHO @CatStr(<vmovdqa >, < x,>, < y>)
  endm
vmovdqu macro x:req, y:req, z:req
    %ECHO @CatStr(<vmovdqu >, < x,>, < y>)
  endm
vmovhlps macro x:req, y:req, z:req
    %ECHO @CatStr(<vmovhlps >, < x,>, < y,>, < z>)
  endm
vmovhpd macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovhpd >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovhpd >, < x,>, < y>)
  ENDIF
endm
vmovhps macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovhps >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovhps >, < x,>, < y>)
  ENDIF
endm
vmovlhps macro x:req, y:req, z:req
    %ECHO @CatStr(<vmovlhps >, < x,>, < y,>, < z>)
  endm
vmovlpd macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovlpd >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovlpd >, < x,>, < y>)
  ENDIF
endm
vmovlps macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovlps >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovlps >, < x,>, < y>)
  ENDIF
endm
vmovmskpd macro x:req, y:req
    %ECHO @CatStr(<vmovmskpd >, < x,>, < y>)
  endm
vmovmskps macro x:req, y:req
    %ECHO @CatStr(<vmovmskps >, < x,>, < y>)
  endm
vmovntdq macro x:req, y:req
    %ECHO @CatStr(<vmovntdq >, < x,>, < y>)
  endm
vmovntdqa macro x:req, y:req
    %ECHO @CatStr(<vmovntdqa >, < x,>, < y>)
  endm
vmovntpd macro x:req, y:req
    %ECHO @CatStr(<vmovntpd >, < x,>, < y>)
  endm
vmovntps macro x:req, y:req
    %ECHO @CatStr(<vmovntps >, < x,>, < y>)
  endm
vmovntq macro x:req, y:req
    %ECHO @CatStr(<vmovntq >, < x,>, < y>)
  endm
vmovq macro x:req, y:req
    %ECHO @CatStr(<vmovq >, < x,>, < y>)
  endm
vmovsd macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovsd >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovsd >, < x,>, < y>)
  ENDIF
endm
vmovshdup macro x:req, y:req
    %ECHO @CatStr(<vmovshdup >, < x,>, < y>)
  endm
vmovsldup macro x:req, y:req
    %ECHO @CatStr(<vmovsldup >, < x,>, < y>)
  endm
vmovss macro x:req, y:req, z
  IFNB <z>
    %ECHO @CatStr(<vmovss >, < x,>, < y,>, < z>)
  ELSE
    %ECHO @CatStr(<vmovss >, < x,>, < y>)
  ENDIF
endm
vmovupd macro x:req, y:req
    %ECHO @CatStr(<vmovupd >, < x,>, < y>)
  endm
vmovups macro x:req, y:req
    %ECHO @CatStr(<vmovups >, < x,>, < y>)
  endm
vmpsadbw macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vmpsadbw >, < x,>, < y,>, < z,>, < imm>)
  endm
vmulpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vmulpd >, < x,>, < y,>, < z >)
  endm
vmulps macro x:req, y:req, z:req
    %ECHO @CatStr(<vmulps >, < x,>, < y,>, < z >)
  endm
vmulsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vmulsd >, < x,>, < y,>, < z >)
  endm
vmulss macro x:req, y:req, z:req
    %ECHO @CatStr(<vmulss >, < x,>, < y,>, < z >)
  endm
vorpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vorpd >, < x,>, < y,>, < z >)
  endm
vorps macro x:req, y:req, z:req
    %ECHO @CatStr(<vorps >, < x,>, < y,>, < z >)
  endm

vpabsb macro x:req, y:req
    %ECHO @CatStr(<vpabsb >, < x,>, < y>)
  endm
vpabsw macro x:req, y:req
    %ECHO @CatStr(<vpabsw >, < x,>, < y>)
  endm
vpabsd macro x:req, y:req
    %ECHO @CatStr(<vpabsd >, < x,>, < y>)
  endm
vpackssdw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpackssdw >, < x,>, < y,>, < z >)
  endm
vpacksswb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpacksswb >, < x,>, < y,>, < z >)
  endm
vpackuswb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpackuswb >, < x,>, < y,>, < z >)
  endm
vpackusdw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpackusdw >, < x,>, < y,>, < z >)
  endm
vpaddb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddb >, < x,>, < y,>, < z >)
  endm
vpaddd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddd >, < x,>, < y,>, < z >)
  endm
vpaddq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddq >, < x,>, < y,>, < z >)
  endm
vpaddsb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddsb >, < x,>, < y,>, < z >)
  endm
vpaddsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddsw >, < x,>, < y,>, < z >)
  endm
vpaddusb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddusb >, < x,>, < y,>, < z >)
  endm
vpaddusw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddusw >, < x,>, < y,>, < z >)
  endm
vpaddw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddw >, < x,>, < y,>, < z >)
  endm
vpand macro x:req, y:req, z:req
    %ECHO @CatStr(<vpand >, < x,>, < y,>, < z >)
  endm
vpandn macro x:req, y:req, z:req
    %ECHO @CatStr(<vpandn >, < x,>, < y,>, < z >)
  endm
vpavgb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpavgb >, < x,>, < y,>, < z >)
  endm
vpavgw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpavgw >, < x,>, < y,>, < z >)
  endm
vpalignr macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpalignr >, < x,>, < y,>, < z,>, < imm>)
  endm
vpblendvb macro x:req, y:req, z:req, q:req
    %ECHO @CatStr(<vpblendvb >, < x,>, < y,>, < z,>, < q>)
  endm
vpblendw macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpblendw >, < x,>, < y,>, < z,>, < imm>)
  endm
vpclmulqdq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpclmulqdq >, < x,>, < y,>, < z >)
  endm
vpcmpestri macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpestri >, < x,>, < y,>, < z >)
  endm
vpcmpestrm macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpestrm >, < x,>, < y,>, < z >)
  endm
vpcmpistri macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpistri >, < x,>, < y,>, < z >)
  endm
vpcmpistrm macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpistrm >, < x,>, < y,>, < z >)
  endm
vpcmpeqb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpeqb >, < x,>, < y,>, < z >)
  endm
vpcmpeqd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpeqd >, < x,>, < y,>, < z >)
  endm
vpcmpeqw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpeqw >, < x,>, < y,>, < z >)
  endm
vpcmpeqq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpeqq >, < x,>, < y,>, < z >)
  endm
vpcmpgtb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpgtb >, < x,>, < y,>, < z >)
  endm
vpcmpgtd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpgtd >, < x,>, < y,>, < z >)
  endm
vpcmpgtw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpgtw >, < x,>, < y,>, < z >)
  endm
vpcmpgtq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpcmpgtq >, < x,>, < y,>, < z >)
  endm
vpermilpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermilpd >, < x,>, < y,>, < z >)
  endm
vpermil2pd macro x:req, y:req, z:req, v:req, imm:req
    %ECHO @CatStr(<vpermil2pd >, < x,>, < y,>, < z,>, < v,>, < imm>)
  endm
vpermilps macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermilps >, < x,>, < y,>, < z >)
  endm
vpermil2ps macro x:req, y:req, z:req, v:req, imm:req
    %ECHO @CatStr(<vpermil2ps >, < x,>, < y,>, < z,>, < v,>, < imm>)
  endm
vperm2f128 macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vperm2f128 >, < x,>, < y,>, < z,>, < imm>)
  endm
vpextrb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpextrb >, < x,>, < y,>, < z >)
  endm
vpextrd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpextrd >, < x,>, < y,>, < z >)
  endm
vpextrq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpextrq >, < x,>, < y,>, < z >)
  endm
vpextrw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpextrw >, < x,>, < y,>, < z >)
  endm
vphaddw macro x:req, y:req, z:req
    %ECHO @CatStr(<vphaddw >, < x,>, < y,>, < z >)
  endm
vphaddd macro x:req, y:req, z:req
    %ECHO @CatStr(<vphaddd >, < x,>, < y,>, < z >)
  endm
vphaddsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vphaddsw >, < x,>, < y,>, < z >)
  endm
vphminposuw macro x:req, y:req
    %ECHO @CatStr(<vphminposuw >, < x,>, < y>)
  endm
vphsubw macro x:req, y:req, z:req
    %ECHO @CatStr(<vphsubw >, < x,>, < y,>, < z >)
  endm
vphsubd macro x:req, y:req, z:req
    %ECHO @CatStr(<vphsubd >, < x,>, < y,>, < z >)
  endm
vphsubsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vphsubsw >, < x,>, < y,>, < z >)
  endm
vpinsrb macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpinsrb >, < x,>, < y,>, < z,>, < imm>)
  endm
vpinsrd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpinsrd >, < x,>, < y,>, < z,>, < imm>)
  endm
vpinsrq macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpinsrq >, < x,>, < y,>, < z,>, < imm>)
  endm
vpinsrw macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vpinsrw >, < x,>, < y,>, < z,>, < imm>)
  endm
vpmaddwd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaddwd >, < x,>, < y,>, < z >)
  endm
vpmaddubsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaddubsw >, < x,>, < y,>, < z >)
  endm
vpmaxsb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxsb >, < x,>, < y,>, < z >)
  endm
vpmaxsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxsd >, < x,>, < y,>, < z >)
  endm
vpmaxsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxsw >, < x,>, < y,>, < z >)
  endm
vpmaxub macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxub >, < x,>, < y,>, < z >)
  endm
vpmaxud macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxud >, < x,>, < y,>, < z >)
  endm
vpmaxuw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaxuw >, < x,>, < y,>, < z >)
  endm
vpminsb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminsb >, < x,>, < y,>, < z >)
  endm
vpminsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminsd >, < x,>, < y,>, < z >)
  endm
vpminsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminsw >, < x,>, < y,>, < z >)
  endm
vpminub macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminub >, < x,>, < y,>, < z >)
  endm
vpminud macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminud >, < x,>, < y,>, < z >)
  endm
vpminuw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpminuw >, < x,>, < y,>, < z >)
  endm
vpmovmskb macro x:req, y:req
    %ECHO @CatStr(<vpmovmskb >, < x,>, < y>)
  endm
vpmovsxbw macro x:req, y:req
    %ECHO @CatStr(<vpmovsxbw >, < x,>, < y>)
  endm
vpmovsxbd macro x:req, y:req
    %ECHO @CatStr(<vpmovsxbd >, < x,>, < y>)
  endm
vpmovsxbq macro x:req, y:req
    %ECHO @CatStr(<vpmovsxbq >, < x,>, < y>)
  endm
vpmovsxwd macro x:req, y:req
    %ECHO @CatStr(<vpmovsxwd >, < x,>, < y>)
  endm
vpmovsxwq macro x:req, y:req
    %ECHO @CatStr(<vpmovsxwq >, < x,>, < y>)
  endm
vpmovsxdq macro x:req, y:req
    %ECHO @CatStr(<vpmovsxdq >, < x,>, < y>)
  endm
vpmovzxbw macro x:req, y:req
    %ECHO @CatStr(<vpmovzxbw >, < x,>, < y>)
  endm
vpmovzxbd macro x:req, y:req
    %ECHO @CatStr(<vpmovzxbd >, < x,>, < y>)
  endm
vpmovzxbq macro x:req, y:req
    %ECHO @CatStr(<vpmovzxbq >, < x,>, < y>)
  endm
vpmovzxwd macro x:req, y:req
    %ECHO @CatStr(<vpmovzxwd >, < x,>, < y>)
  endm
vpmovzxwq macro x:req, y:req
    %ECHO @CatStr(<vpmovzxwq >, < x,>, < y>)
  endm
vpmovzxdq macro x:req, y:req
    %ECHO @CatStr(<vpmovzxdq >, < x,>, < y>)
  endm
vpmulhuw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmulhuw >, < x,>, < y,>, < z >)
  endm
vpmulhrsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmulhrsw >, < x,>, < y,>, < z >)
  endm
vpmulhw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmulhw >, < x,>, < y,>, < z >)
  endm
vpmullw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmullw >, < x,>, < y,>, < z >)
  endm
vpmulld macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmulld >, < x,>, < y,>, < z >)
  endm
vpmuludq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmuludq >, < x,>, < y,>, < z >)
  endm
vpmuldq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmuldq >, < x,>, < y,>, < z >)
  endm
vpor macro x:req, y:req, z:req
    %ECHO @CatStr(<vpor >, < x,>, < y,>, < z >)
  endm
vpsadbw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsadbw >, < x,>, < y,>, < z >)
  endm
vpshufb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpshufb >, < x,>, < y,>, < z >)
  endm
vpshufd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpshufd >, < x,>, < y,>, < z >)
  endm
vpshufhw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpshufhw >, < x,>, < y,>, < z >)
  endm
vpshuflw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpshuflw >, < x,>, < y,>, < z >)
  endm
vpsignb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsignb >, < x,>, < y,>, < z >)
  endm
vpsignw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsignw >, < x,>, < y,>, < z >)
  endm
vpsignd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsignd >, < x,>, < y,>, < z >)
  endm
vpslld macro x:req, y:req, z:req
    %ECHO @CatStr(<vpslld >, < x,>, < y,>, < z >)
  endm
vpslldq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpslldq >, < x,>, < y,>, < z >)
  endm
vpsllq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsllq >, < x,>, < y,>, < z >)
  endm
vpsllw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsllw >, < x,>, < y,>, < z >)
  endm
vpsrad macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrad >, < x,>, < y,>, < z >)
  endm
vpsraw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsraw >, < x,>, < y,>, < z >)
  endm
vpsrld macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrld >, < x,>, < y,>, < z >)
  endm
vpsrldq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrldq >, < x,>, < y,>, < z >)
  endm
vpsrlq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrlq >, < x,>, < y,>, < z >)
  endm
vpsrlw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrlw >, < x,>, < y,>, < z >)
  endm
vptest macro x:req, y:req
    %ECHO @CatStr(<vptest >, < x,>, < y>)
  endm
vpsubb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubb >, < x,>, < y,>, < z >)
  endm
vpsubd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubd >, < x,>, < y,>, < z >)
  endm
vpsubq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubq >, < x,>, < y,>, < z >)
  endm
vpsubsb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubsb >, < x,>, < y,>, < z >)
  endm
vpsubsw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubsw >, < x,>, < y,>, < z >)
  endm
vpsubusb macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubusb >, < x,>, < y,>, < z >)
  endm
vpsubusw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubusw >, < x,>, < y,>, < z >)
  endm
vpsubw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsubw >, < x,>, < y,>, < z >)
  endm
vpunpckhbw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpckhbw >, < x,>, < y,>, < z >)
  endm
vpunpckhdq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpckhdq >, < x,>, < y,>, < z >)
  endm
vpunpckhqdq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpckhqdq >, < x,>, < y,>, < z >)
  endm
vpunpckhwd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpckhwd >, < x,>, < y,>, < z >)
  endm
vpunpcklbw macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpcklbw >, < x,>, < y,>, < z >)
  endm
vpunpckldq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpckldq >, < x,>, < y,>, < z >)
  endm
vpunpcklqdq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpcklqdq >, < x,>, < y,>, < z >)
  endm
vpunpcklwd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpunpcklwd >, < x,>, < y,>, < z >)
  endm
vrcpps macro x:req, y:req
    %ECHO @CatStr(<vrcpps >, < x,>, < y>)
  endm
vrcpss macro x:req, y:req, z:req
    %ECHO @CatStr(<vrcpss >, < x,>, < y>)
  endm
vrsqrtps macro x:req, y:req
    %ECHO @CatStr(<vrsqrtps >, < x,>, < y>)
  endm
vrsqrtss macro x:req, y:req
    %ECHO @CatStr(<vrsqrtss >, < x,>, < y>)
  endm
vroundpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vroundpd >, < x,>, < y,>, < z >)
  endm
vroundps macro x:req, y:req, z:req
    %ECHO @CatStr(<vroundps >, < x,>, < y,>, < z >)
  endm
vroundsd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vroundsd >, < x,>, < y,>, < z,>, < imm>)
  endm
vroundss macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vroundss >, < x,>, < y,>, < z,>, < imm>)
  endm
vshufpd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vshufpd >, < x,>, < y,>, < z,>, < imm>)
  endm
vshufps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vshufps >, < x,>, < y,>, < z,>, < imm>)
  endm
vsqrtpd macro x:req, y:req
    %ECHO @CatStr(<vsqrtpd >, < x,>, < y>)
  endm
vsqrtps macro x:req, y:req
    %ECHO @CatStr(<vsqrtps >, < x,>, < y>)
  endm
vsqrtsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vsqrtsd >, < x,>, < y,>, < z >)
  endm
vsqrtss macro x:req, y:req, z:req
    %ECHO @CatStr(<vsqrtss >, < x,>, < y,>, < z >)
  endm
vstmxcsr macro x:req
    %ECHO @CatStr(<vstmxcsr >, < x>)
  endm
vsubpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vsubpd >, < x,>, < y,>, < z >)
  endm
vsubps macro x:req, y:req, z:req
    %ECHO @CatStr(<vsubps >, < x,>, < y,>, < z >)
  endm
vsubsd macro x:req, y:req, z:req
    %ECHO @CatStr(<vsubsd >, < x,>, < y,>, < z >)
  endm
vsubss macro x:req, y:req, z:req
    %ECHO @CatStr(<vsubss >, < x,>, < y,>, < z >)
  endm
vucomisd macro x:req, y:req
    %ECHO @CatStr(<vucomisd >, < x,>, < y>)
  endm
vucomiss macro x:req, y:req
    %ECHO @CatStr(<vucomiss >, < x,>, < y>)
  endm
vunpckhpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vunpckhpd >, < x,>, < y,>, < z >)
  endm
vunpckhps macro x:req, y:req, z:req
    %ECHO @CatStr(<vunpckhps >, < x,>, < y,>, < z >)
  endm
vunpcklpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vunpcklpd >, < x,>, < y,>, < z >)
  endm
vunpcklps macro x:req, y:req, z:req
    %ECHO @CatStr(<vunpcklps >, < x,>, < y,>, < z >)
  endm
vxorpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vxorpd >, < x,>, < y,>, < z >)
  endm
vxorps macro x:req, y:req, z:req
    %ECHO @CatStr(<vxorps >, < x,>, < y,>, < z >)
  endm
vzeroall macro
    %ECHO @CatStr(<vzeroall>)
  endm
vzeroupper macro
    %ECHO @CatStr(<vzeroupper>)
  endm
 ELSE
  OPTION NOKEYWORD:<blendvpd>
  blendvpd macro x:req, y:req, z
    %ECHO @CatStr(<blendvpd >, < x,>, < y>)
  endm
  OPTION NOKEYWORD:<blendvps>
  blendvps macro x:req, y:req, z
    %ECHO @CatStr(<blendvps >, < x,>, < y>)
  endm
  OPTION NOKEYWORD:<pblendvb>
  pblendvb macro x:req, y:req, z
    %ECHO @CatStr(<pblendvb >, < x,>, < y>)
  endm

;;  OPTION NOKEYWORD:<vpbroadcastq>
    vpbroadcastq macro x:req, y:req
      %ECHO @CatStr(<vpbroadcastq >, <x, >, <y >)
    endm
  OPTION NOKEYWORD:<vpaddq>
  vpaddq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpaddq >, < x,>, < y,>, < z >)
  endm
  OPTION NOKEYWORD:<vpmuludq>
  vpmuludq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmuludq >, < x,>, < y,>, < z >)
  endm

  OPTION NOKEYWORD:<vpxor>
  vpxor macro x:req, y:req, z:req
    %ECHO @CatStr(<vpxor >, < x,>, < y,>, < z >)
  endm

ENDIF ;IFNDEF D_ML900


vfmadd132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd132pd >, < x,>, < y,>, < z >)
  endm
vfmadd213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd213pd >, < x,>, < y,>, < z >)
  endm
vfmadd231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd231pd >, < x,>, < y,>, < z >)
  endm
vfmaddrnd231pd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vfmaddrnd231pd >, < x,>, < y,>, < z,>, < imm>)
  endm
vfmadd132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd132ps >, < x,>, < y,>, < z >)
  endm
vfmadd213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd213ps >, < x,>, < y,>, < z >)
  endm
vfmadd231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd231ps >, < x,>, < y,>, < z >)
  endm
vfmaddrnd231ps macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vfmaddrnd231ps >, < x,>, < y,>, < z,>, < imm>)
  endm
vfmadd132sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd132sd >, < x,>, < y,>, < z >)
  endm
vfmadd213sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd213sd >, < x,>, < y,>, < z >)
  endm
vfmadd231sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd231sd >, < x,>, < y,>, < z >)
  endm
vfmaddrnd231sd macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vfmaddrnd231sd >, < x,>, < y,>, < z,>, < imm>)
  endm
vfmadd132ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd132ss >, < x,>, < y,>, < z >)
  endm
vfmadd213ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd213ss >, < x,>, < y,>, < z >)
  endm
vfmadd231ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmadd231ss >, < x,>, < y,>, < z >)
  endm
vfmaddrnd231ss macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vfmaddrnd231ss >, < x,>, < y,>, < z,>, < imm>)
  endm
vfmaddsub132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub132pd >, < x,>, < y,>, < z >)
  endm
vfmaddsub213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub213pd >, < x,>, < y,>, < z >)
  endm
vfmaddsub231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub231pd >, < x,>, < y,>, < z >)
  endm
vfmaddsub132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub132ps >, < x,>, < y,>, < z >)
  endm
vfmaddsub213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub213ps >, < x,>, < y,>, < z >)
  endm
vfmaddsub231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmaddsub231ps >, < x,>, < y,>, < z >)
  endm
vfmsubadd132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd132pd >, < x,>, < y,>, < z >)
  endm
vfmsubadd213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd213pd >, < x,>, < y,>, < z >)
  endm
vfmsubadd231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd231pd >, < x,>, < y,>, < z >)
  endm
vfmsubadd132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd132ps >, < x,>, < y,>, < z >)
  endm
vfmsubadd213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd213ps >, < x,>, < y,>, < z >)
  endm
vfmsubadd231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsubadd231ps >, < x,>, < y,>, < z >)
  endm
vfmsub132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub132pd >, < x,>, < y,>, < z >)
  endm
vfmsub213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub213pd >, < x,>, < y,>, < z >)
  endm
vfmsub231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub231pd >, < x,>, < y,>, < z >)
  endm
vfmsub132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub132ps >, < x,>, < y,>, < z >)
  endm
vfmsub213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub213ps >, < x,>, < y,>, < z >)
  endm
vfmsub231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub231ps >, < x,>, < y,>, < z >)
  endm
vfmsub132sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub132sd >, < x,>, < y,>, < z >)
  endm
vfmsub213sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub213sd >, < x,>, < y,>, < z >)
  endm
vfmsub231sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub231sd >, < x,>, < y,>, < z >)
  endm
vfmsub132ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub132ss >, < x,>, < y,>, < z >)
  endm
vfmsub213ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub213ss >, < x,>, < y,>, < z >)
  endm
vfmsub231ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfmsub231ss >, < x,>, < y,>, < z >)
  endm
vfnmadd132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd132pd >, < x,>, < y,>, < z >)
  endm
vfnmadd213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd213pd >, < x,>, < y,>, < z >)
  endm
vfnmadd231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd231pd >, < x,>, < y,>, < z >)
  endm
vfnmadd132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd132ps >, < x,>, < y,>, < z >)
  endm
vfnmadd213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd213ps >, < x,>, < y,>, < z >)
  endm
vfnmadd231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd231ps >, < x,>, < y,>, < z >)
  endm
vfnmadd132sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd132sd >, < x,>, < y,>, < z >)
  endm
vfnmadd213sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd213sd >, < x,>, < y,>, < z >)
  endm
vfnmadd231sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd231sd >, < x,>, < y,>, < z >)
  endm
vfnmadd132ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd132ss >, < x,>, < y,>, < z >)
  endm
vfnmadd213ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd213ss >, < x,>, < y,>, < z >)
  endm
vfnmadd231ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmadd231ss >, < x,>, < y,>, < z >)
  endm
vfnmsub132pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub132pd >, < x,>, < y,>, < z >)
  endm
vfnmsub213pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub213pd >, < x,>, < y,>, < z >)
  endm
vfnmsub231pd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub231pd >, < x,>, < y,>, < z >)
  endm
vfnmsub132ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub132ps >, < x,>, < y,>, < z >)
  endm
vfnmsub213ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub213ps >, < x,>, < y,>, < z >)
  endm
vfnmsub231ps macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub231ps >, < x,>, < y,>, < z >)
  endm
vfnmsub132sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub132sd >, < x,>, < y,>, < z >)
  endm
vfnmsub213sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub213sd >, < x,>, < y,>, < z >)
  endm
vfnmsub231sd macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub231sd >, < x,>, < y,>, < z >)
  endm
vfnmsub132ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub132ss >, < x,>, < y,>, < z >)
  endm
vfnmsub213ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub213ss >, < x,>, < y,>, < z >)
  endm
vfnmsub231ss macro x:req, y:req, z:req
    %ECHO @CatStr(<vfnmsub231ss >, < x,>, < y,>, < z >)
  endm

; AVX2 (HSW)

vpsllvd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsllvd >, < x,>, < y,>, < z >)
  endm
vpsllvq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsllvq >, < x,>, < y,>, < z >)
  endm
vcvtph2ps macro x:req, z:req
    %ECHO @CatStr(<vcvtph2ps >, < x,>, < z >)
  endm
andn macro x:req, y:req, z:req
    %ECHO @CatStr(<andn >, < x,>, < y,>, < z >)
  endm
bextr macro x:req, y:req, z:req
    %ECHO @CatStr(<bextr >, < x,>, < y,>, < z >)
  endm
blsi macro x:req, z:req
    %ECHO @CatStr(<blsi >, < x,>, < z >)
  endm
blsmsk macro x:req, z:req
    %ECHO @CatStr(<blmsk >, < x,>, < z >)
  endm
blsr macro x:req, z:req
    %ECHO @CatStr(<blsr >, < x,>, < z >)
  endm
bzhi macro x:req, y:req, z:req
    %ECHO @CatStr(<bzhi >, < x,>, < y,>, < z >)
  endm
;lzcnt macro x:req, z:req
;    %ECHO @CatStr(<lzcnt >, < x,>, < z >)
;  endm
mulx macro x:req, y:req, z:req
    %ECHO @CatStr(<mulx >, < x,>, < y,>, < z >)
  endm
pdep macro x:req, y:req, z:req
    %ECHO @CatStr(<pdep >, < x,>, < y,>, < z >)
  endm
pext macro x:req, y:req, z:req
    %ECHO @CatStr(<pext >, < x,>, < y,>, < z >)
  endm
rorx macro x:req, y:req, z:req
    %ECHO @CatStr(<rorx >, < x,>, < y,>, < z >)
  endm
sarx macro x:req, y:req, z:req
    %ECHO @CatStr(<sarx >, < x,>, < y,>, < z >)
  endm
shlx macro x:req, y:req, z:req
    %ECHO @CatStr(<shlx >, < x,>, < y,>, < z >)
  endm
shrx macro x:req, y:req, z:req
    %ECHO @CatStr(<shrx >, < x,>, < y,>, < z >)
  endm
tzcnt macro x:req, z:req
    %ECHO @CatStr(<tzcnt >, < x,>, < z >)
  endm
invpcid macro x:req, z:req
    %ECHO @CatStr(<invpcid >, < x,>, < z >)
  endm
rdrand macro x:req
    %ECHO @CatStr(<rdrand >, < x >)
  endm
rdseed macro x:req
    %ECHO @CatStr(<rdseed >, < x >)
  endm
adcx macro x:req, z:req
    %ECHO @CatStr(<adcx >, < x,>, < z >)
  endm
adox macro x:req, z:req
    %ECHO @CatStr(<adox >, < x,>, < z >)
  endm
;prefetchw macro x:req
;    %ECHO @CatStr(<prefetchw >, < x >)
;  endm
vpbroadcast macro x:req, y:req, z:req
    %ECHO @CatStr(<vpbroadcast >, < x,>, < y,>, < z >)
  endm
vpbroadcastb macro x:req, y:req
  %ECHO @CatStr(<vpbroadcastb >, <x, >, <y >)
endm
vpbroadcastw macro x:req, y:req
  %ECHO @CatStr(<vpbroadcastw >, <x, >, <y >)
endm
vpbroadcastd macro x:req, y:req
  %ECHO @CatStr(<vpbroadcastd >, <x, >, <y >)
endm
vpermd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermd >, < x,>, < y,>, < z >)
  endm
vpermpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermpd >, < x,>, < y,>, < z >)
  endm
vpermps macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermps >, < x,>, < y,>, < z >)
  endm
vpermq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpermq >, < x,>, < y,>, < z >)
  endm
vperm2i128 macro x:req, y:req, z:req
    %ECHO @CatStr(<vperm2i128 >, < x,>, < y,>, < z >)
  endm
vextracti128 macro x:req, y:req, z:req
    %ECHO @CatStr(<vextracti128 >, < x,>, < y,>, < z >)
  endm
vinserti128 macro x:req, y:req, z:req, imm:req
    %ECHO @CatStr(<vinserti128 >, < x,>, < y,>, < z,>, < imm>)
  endm
vpmaskmov macro x:req, y:req, z:req
    %ECHO @CatStr(<vpmaskmov >, < x,>, < y,>, < z >)
  endm
vpsravd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsravd >, < x,>, < y,>, < z >)
  endm
vpsrlvd macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrlvd >, < x,>, < y,>, < z >)
  endm
vpsrlvq macro x:req, y:req, z:req
    %ECHO @CatStr(<vpsrlvq >, < x,>, < y,>, < z >)
  endm
vgatherdpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherdpd >, < x,>, < y,>, < z >)
  endm
vgatherqpd macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherqpd >, < x,>, < y,>, < z >)
  endm
vgatherdps macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherdps >, < x,>, < y,>, < z >)
  endm
vgatherqps macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherqps >, < x,>, < y,>, < z >)
  endm
vgatherdd macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherdd >, < x,>, < y,>, < z >)
  endm
vgatherqd macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherqd >, < x,>, < y,>, < z >)
  endm
vgatherdq macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherdq >, < x,>, < y,>, < z >)
  endm
vgatherqq macro x:req, y:req, z:req
    %ECHO @CatStr(<vgatherqq >, < x,>, < y,>, < z >)
  endm
;vpmaddubsw macro x:req, y:req, z:req
;    %ECHO @CatStr(<vpmaddubsw >, < x,>, < y,>, < z >)
;  endm
;vmpsadbw macro x:req, y:req, z:req
;    %ECHO @CatStr(<vmpsadbw >, < x,>, < y,>, < z >)
;  endm

ENDIF ; IFNDEF ML1100
ENDIF ; IFNDEF ML1200

ELSE  ; MNI & SNI macro for Linux or for Windows

IFNDEF ML1100

  IF IPP_ABI LE 1
  OPTION NOKEYWORD:<pmuludq>
  IFHIGH_REG MACRO x, f
    f = 0
    FOR y,<xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15>
      IFIDN   <y>,<x>
        f = 1
        EXITM
      ENDIF
    ENDM
    IF f EQ 0
      FOR y,<r8,R8,r9,R9,r10,R10,r11,R11,r12,R12,r13,R13,r14,R14,r15,R15>
          IF @InStr( , x, y ) NE 0
            f = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
  ENDM
  IFMMX_REG MACRO x, f
    f = 0
    FOR y,<mm0,MM0,mm1,MM1,mm2,MM2,mm3,MM3,mm4,MM4,mm5,MM5,mm6,MM6,mm7,MM7>
      IFIDN   <y>,<x>
        f = 1
        EXITM
      ENDIF
    ENDM
  ENDM

  ;;66/REX 0F F4 /r  pmuludq xmm1, xmm2/m128
  pmuludq macro dst:req, src:req
        local x, y
    IFMMX_REG <dst>,f
    IF f GT 0
    x:
        paddq dst, src
    y:
        org x+1
        db 0F4h
        org y
    ELSE
    x:
        addpd dst, src
    y:
        IFHIGH_REG <dst>,f
        IF f EQ 0
          IFHIGH_REG <src>,f
        ENDIF
        IF f GT 0
            org x+3
        ELSE
            org x+2
        ENDIF
        db 0F4h
        org y
    ENDIF
  endm

  ENDIF

nis_mni             = 38h ;new instruction set
nis_mnia            = 3Ah ;new instruction set 'a'
reg_mmx             = 0Fh ;media registers type
reg_xmm             = 66h ;media registers type

opc_phaddw          = 01h
opc_phaddd          = 02h
opc_phaddsw         = 03h
opc_phsubw          = 05h
opc_phsubd          = 06h
opc_phsubsw         = 07h
opc_pmaddubsw       = 04h
opc_pmulhrsw        = 0Bh
opc_pshufb          = 00h
opc_psignb          = 08h
opc_psignw          = 09h
opc_psignd          = 0Ah
opc_palignr         = 0Fh
opc_pabsb           = 1Ch
opc_pabsw           = 1Dh
opc_pabsd           = 1Eh

HIGHQ_GPR  textequ <!<r8,R8,r9,R9,r10,R10,r11,R11,r12,R12,r13,R13,r14,R14,r15,R15!>>
LOWQ_GPR   textequ <!<rax,RAX,rcx,RCX,rdx,RDX,rbx,RBX,rsp,RSP,rbp,RBP,rsi,RSI,rdi,RDI!>>
HIGH_XMM   textequ <!<xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15!>>
LOW_XMM    textequ <!<xmm0,XMM0,xmm1,XMM1,xmm2,XMM2,xmm3,XMM3,xmm4,XMM4,xmm5,XMM5,xmm6,XMM6,xmm7,XMM7!>>
ALL_MMX    textequ <!<mm0,MM0,mm1,MM1,mm2,MM2,mm3,MM3,mm4,MM4,mm5,MM5,mm6,MM6,mm7,MM7!>>
HIGHDQ_GPR textequ <!<R8D,r8d,R8,r8,R9D,r9d,R9,r9,R10D,r10d,R10,r10,R11D,r11d,R11,r11,R12D,r12d,R12,r12,R13D,r13d,R13,r13,R14D,r14d,R14,r14,R15D,r15d,R15,r15!>>
LOWDQ_GPR  textequ <!<EAX,eax,RAX,rax,ECX,ecx,RCX,rcx,EDX,edx,RDX,rdx,EBX,ebx,RBX,rbx,ESP,esp,RSP,rsp,EBP,ebp,RBP,rbp,ESI,esi,RSI,rsi,EDI,edi,RDI,rdi!>>
LOWD_GPR   textequ <!<eax,EAX,ecx,ECX,edx,EDX,ebx,EBX,esp,ESP,ebp,EBP,esi,ESI,edi,EDI!>>
HIGHD_GPR  textequ <!<r8d,R8D,r9d,R9D,r10d,R10D,r11d,R11D,r12d,R12D,r13d,R13D,r14d,R14D,r15d,R15D!>>
LOWW_GPR   textequ <!<ax,AX,cx,CX,dx,DX,bx,BX,sp,SP,bp,BP,si,SI,di,DI!>>
HIGHW_GPR  textequ <!<r8w,R8W,r9w,R9W,r10w,R10W,r11w,R11W,r12w,R12W,r13w,R13W,r14w,R14W,r15w,R15W!>>
LOWB_GPR   textequ <!<al,AL,cl,CL,dl,DL,bl,BL,ah,AH,ch,CH,dh,DH,bh,BH!>>
HIGHB_GPR  textequ <!<r8b,R8B,r9b,R9B,r10b,R10B,r11b,R11B,r12b,R12B,r13b,R13B,r14b,R14B,r15b,R15B,spl,SPL,bpl,BPL,sil,SIL,dil,DIL!>>
ALL_NUM    textequ <!<15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0!>>

IS_REX MACRO x, REX
    REX = 0
    %FOR yrex,HIGH_XMM                  ; if xmm from 8-15 range - REX byte is required
      IFIDN   <yrex>,<x>
        REX = 1
        EXITM
      ENDIF
    ENDM
    IF REX EQ 0
      %FOR yrex,HIGHDQ_GPR              ; if gpr from 8-15 range - REX byte is required
          IF @InStr( , x, yrex ) NE 0
            REX = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
ENDM

IS_MMX MACRO x, MMX
    MMX = 0
    %FOR ymmx,ALL_MMX                   ; test if operand is a mmx register
      IFIDN   <ymmx>,<x>
        MMX = 1
        EXITM
      ENDIF
    ENDM
ENDM

SUBST_GPR MACRO x                       ; this macro substites any gpr from the high half (8-15)
  xretgpr textequ <x>                   ; with the gpr from the low half wich produces the same
  qgpr = 0                              ; index in the mod/r/m and sib bytes
  %FOR ygpr,HIGHDQ_GPR
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
      fgpr = 0
      %FOR zgpr,LOWDQ_GPR
        IF fgpr EQ qgpr
          f1gpr SUBSTR <x>, 1, posgpr-1
          f2gpr SUBSTR <x>, posgpr + @SizeStr( ygpr )
          xretgpr CATSTR <f1gpr>, < zgpr >, <f2gpr>
          EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
    ENDIF ; if posx > 0
    qgpr = qgpr + 1
  ENDM ; for y
  EXITM xretgpr
ENDM

SUBST_XMM MACRO x                       ; this macro substites any xmm from the high half (8-15)
  xretxmm textequ <x>                   ; with the xmm from the low half wich produces the same
  lxmm = 0                              ; index in the mod/r/m byte
  %FOR yxmm,HIGH_XMM
    posxmm INSTR <x>,<yxmm>
    IF posxmm GT 0
      fxmm = 0
      %FOR zxmm,LOW_XMM
        IF fxmm EQ lxmm
          xretxmm textequ <zxmm>
         EXITM xretxmm
        ENDIF ; if f == l
        fxmm = fxmm + 1
      ENDM ; for z
    ENDIF ; if posx > 0
    lxmm = lxmm + 1
  ENDM ; for y
  EXITM xretxmm
ENDM

SUBST_HIGH MACRO x                      ; a wrapper for macros that substitute up-half registers
  xs  textequ SUBST_GPR( x )            ; with their ia32 analogues that have the same index in
  xs1 textequ SUBST_GPR( %xs )          ; the mod/r/m byte
  xs2 textequ SUBST_XMM( %xs1 )
  EXITM xs2
ENDM

SUBST_MIMM MACRO x, y                   ; if "x" contains direct reference to memory operand (by
  zimm = ( OPATTR( x )) AND 0011110111y ; name defined in code or data section) it is substituted
  IF zimm EQ 0                          ; by "y" operand in order to produce right REX byte, but
    ximm textequ <y>                    ; don't produce relocation record (because current address
  ELSE                                  ; for relocation due to different instruction length is wrong)
    ximm textequ <x>
  ENDIF
  EXITM ximm
ENDM

IS_NAME MACRO x                         ; if "x" contains direct reference to memory operand (by
  znam = ( OPATTR( x )) AND 0011110111y ; name defined in code or data section) 1 is returned
  IF znam EQ 0                          ; else 0
    xnam = 1
  ELSE
    xnam = 0
  ENDIF
  EXITM %xnam
ENDM


mni_instruction macro dst:req, src:req, nis:req, opc:req, imm8
  local x0, x1, x2, x3, x4, x5, x6, x7

    IS_REX <src>,REX                    ; do we need REX byte due to src operand?
    REXS = REX
    IF REXS EQ 1                        ; if yes - we have to prepare substitution in order
      s1rc textequ SUBST_HIGH( src )    ; to work correctly with direct memory operands
    ELSE
      s1rc textequ <src>                ; else substitution is not required
    ENDIF
    IS_REX <dst>,REX                    ; do we need REX byte due to dst operand?
    REXD = REX
    IF REXD EQ 1                        ; if yes - we have to prepare substitution in order
      d1st textequ SUBST_HIGH( dst )    ; to work correctly with direct memory operands
    ELSE
      d1st textequ <dst>                ; else substitution is not required
    ENDIF
    REX = REXS + REXD
    NAMS = IS_NAME( src )
    NAMD = IS_NAME( dst )
    isname = NAMS + NAMD
    IS_MMX <dst>,MMX                    ; the same instruction set for both MMX and SSE
    IF MMX GT 0                         ; we need to separate them because of different length (in bytes)
      s2rc textequ SUBST_MIMM( src, mm0 )
      d2st textequ SUBST_MIMM( dst, mm0 )
      IF isname GT 0                    ; if src or dst contains direct reference to memory operand
        IF REX GT 0
          x0:
            nop
            nop
            pand d1st,s1rc              ; 90 90 0F DB /r m32
          x1:
            org x0
            pand d2st,s2rc              ; REX 0F DB /r /r m32
            org x0+2
            db   nis
            db   opc
          IFNB <imm8>
            org  x0+5
            dd   0FFFFFFFFH
            org  x1                     ; 66 REX 0F nis opc /r m32
            db imm8
          ELSE
            org  x1
          ENDIF
        ELSE
            db  reg_mmx                 ; MMX processing
          x2:
            pand dst, src               ; 0F 0F DB /r m32
          x3:
            org  x2
            db   nis
            db   opc
          IFNB <imm8>
            org  x2+3
            dd   0FFFFFFFFH
            org  x3                     ; 0F nis opc /r m32
            db imm8
          ELSE
            org  x3
          ENDIF
        ENDIF
      ELSE                              ; if src or dst doesn't contain direct reference to memory operand
        IF REX GT 0
          x0:
            pand dst,src                ; REX 0F DB /r
            org x0+1
            pand dst,src                ; REX REX 0F DB /r
          x1:
            org x0+1
            db   reg_mmx
            db   nis
            db   opc
            org  x1                     ; REX reg_mmx nis opc /r
          IFNB <imm8>
            db imm8
          ENDIF
        ELSE
            db  reg_mmx                 ; MMX processing
          x2:
            pand dst, src               ; reg_mmx 0F DB /r
          x3:
            org  x2
            db   nis
            db   opc
            org  x3                     ; reg_mmx nis opc /r
          IFNB <imm8>
            db imm8
          ENDIF
        ENDIF
      ENDIF
    ELSE                                ; SSE processing
      s2rc textequ SUBST_MIMM( src, xmm0 )
      d2st textequ SUBST_MIMM( dst, xmm0 )
      IF isname GT 0                    ; if src or dst contains direct reference to memory operand
        IF REX GT 0
            db reg_xmm
          x4:
            nop
            nop
            mulps d1st,s1rc             ; 66 90 90 0F 59 /r m32
          x5:
            org x4
            mulps d2st,s2rc             ; 66 REX 0F 59 /r /r m32
            org  x4+2
            db   nis
            db   opc
          IFNB <imm8>
            org  x4+5
            dd   0FFFFFFFFH
            org  x5                     ; 66 REX 0F nis opc /r m32
            db imm8
          ELSE
            org  x5
          ENDIF
        ELSE
            db reg_xmm
          x6:
            nop
            mulps dst, src              ; 66 90 0F 59 /r m32
          x7:
            org  x6
            db   reg_mmx
            db   nis
            db   opc
          IFNB <imm8>
            org  x6+4
            dd   0FFFFFFFFH
            org  x7                     ; 66 0F nis opc /r m32
            db imm8
          ELSE
            org  x7
          ENDIF
        ENDIF
      ELSE                              ; if src or dst doesn't contain direct reference to memory operand
        IF REX GT 0
            db reg_xmm
          x4:
            mulps dst,src               ; 66 REX 0F 59 /r
            org x4+1
            mulps dst,src               ; 66 REX REX 0F 59 /r
          x5:
            org  x4+1
            db   reg_mmx
            db   nis
            db   opc
            org  x5                     ; 66 REX 0F nis opc /r
          IFNB <imm8>
            db imm8
          ENDIF
        ELSE
            db reg_xmm
          x6:
            nop
            mulps dst, src              ; 66 90 0F 59 /r
          x7:
            org  x6
            db   reg_mmx
            db   nis
            db   opc
            org  x7                     ; 66 0F nis opc /r
          IFNB <imm8>
            db imm8
          ENDIF
        ENDIF
      ENDIF
    ENDIF
endm

;IF @Version LT 900
IFNDEF D_ML900

;  OPTION NOKEYWORD:<phaddw>
;    0F 38 01 /r phaddw    mm1, mm2/m64
; 66 0F 38 01 /r phaddw    xmm1, xmm2/m128
phaddw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phaddw
endm

;  OPTION NOKEYWORD:<phaddd>
;    0F 38 02 /r phaddd    mm1, mm2/m64
; 66 0F 38 02 /r phaddd    xmm1, xmm2/m128
phaddd macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phaddd
endm

;  OPTION NOKEYWORD:<phaddsw>
;    0F 38 03 /r phaddsw   mm1, mm2/m64
; 66 0F 38 03 /r phaddsw   xmm1, xmm2/m128
phaddsw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phaddsw
endm

;  OPTION NOKEYWORD:<phsubw>
;    0F 38 05 /r phsubw    mm1, mm2/m64
; 66 0F 38 05 /r phsubw    xmm1, xmm2/m128
phsubw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phsubw
endm

;  OPTION NOKEYWORD:<phsubd>
;    0F 38 06 /r phsubd    mm1, mm2/m64
; 66 0F 38 06 /r phsubd    xmm1, xmm2/m128
phsubd macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phsubd
endm

;  OPTION NOKEYWORD:<phsubsw>
;    0F 38 07 /r phsubsw   mm1, mm2/m64
; 66 0F 38 07 /r phsubsw   xmm1, xmm2/m128
phsubsw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_phsubsw
endm

;  OPTION NOKEYWORD:<pmaddubsw>
;    0F 38 04 /r pmaddubsw mm1, mm2/m64
; 66 0F 38 04 /r pmaddubsw xmm1, xmm2/m128
pmaddubsw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pmaddubsw
endm

;  OPTION NOKEYWORD:<pmulhrsw>
;    0F 38 0B /r pmulhrsw  mm1, mm2/m64
; 66 0F 38 0B /r pmulhrsw  xmm1, xmm2/m128
pmulhrsw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pmulhrsw
endm

;  OPTION NOKEYWORD:<pshufb>
;    0F 38 00 /r pshufb    mm1, mm2/m64
; 66 0F 38 00 /r pshufb    xmm1, xmm2/m128
pshufb macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pshufb
endm

;  OPTION NOKEYWORD:<psignb>
;    0F 38 08 /r psignb    mm1, mm2/m64
; 66 0F 38 08 /r psignb    xmm1, xmm2/m128
psignb macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_psignb
endm

;  OPTION NOKEYWORD:<psignw>
;    0F 38 09 /r psignw    mm1, mm2/m64
; 66 0F 38 09 /r psignw    xmm1, xmm2/m128
psignw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_psignw
endm

;  OPTION NOKEYWORD:<psignd>
;    0F 38 0A /r psignd    mm1, mm2/m64
; 66 0F 38 0A /r psignd    xmm1, xmm2/m128
psignd macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_psignd
endm

;  OPTION NOKEYWORD:<palignr>
;    0F 3A 0F /r palignr   mm1, mm2/m64
; 66 0F 3A 0F /r palignr   xmm1, xmm2/m128
palignr macro dst:req, src:req, imm8:req
  %mni_instruction dst, src, nis_mnia, opc_palignr, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pabsb>
;    0F 38 1C /r pabsb     mm1, mm2/m64
; 66 0F 38 1C /r pabsb     xmm1, xmm2/m128
pabsb macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pabsb
endm

;  OPTION NOKEYWORD:<pabsw>
;    0F 38 1D /r pabsw     mm1, mm2/m64
; 66 0F 38 1D /r pabsw     xmm1, xmm2/m128
pabsw macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pabsw
endm

;  OPTION NOKEYWORD:<pabsd>
;    0F 38 1E /r pabsd     mm1, mm2/m64
; 66 0F 38 1E /r pabsd     xmm1, xmm2/m128
pabsd macro dst:req, src:req
  %mni_instruction dst, src, nis_mni, opc_pabsd
endm

ENDIF
; The End of @Version < 900

; SNI (Swing new instructions or SSE4.1)

nis_sni             = 38h ; new instruction set
nis_snia            = 3Ah ; new instruction set 'a' (with imm8)

opc_blendpd         = 0Dh
opc_blendps         = 0Ch
opc_blendvpd        = 15h
opc_blendvps        = 14h
opc_dppd            = 41h
opc_dpps            = 40h
opc_extractps       = 17h
opc_insertps        = 21h
opc_movntdqa        = 2Ah
opc_mpsadbw         = 42h
opc_pblendvb        = 10h
opc_pblendw         = 0Eh
opc_pcmpeqq         = 29h
opc_pextrb          = 14h
opc_pextrd          = 16h
opc_pextrw          = 15h
opc_phminposuw      = 41h
opc_packusdw        = 2Bh
opc_pinsrb          = 20h
opc_pinsrd          = 22h
opc_pmaxsb          = 3Ch
opc_pmaxsd          = 3Dh
opc_pmaxud          = 3Fh
opc_pmaxuw          = 3Eh
opc_pminsb          = 38h
opc_pminsd          = 39h
opc_pminud          = 3Bh
opc_pminuw          = 3Ah
opc_pmovsxbw        = 20h
opc_pmovsxbd        = 21h
opc_pmovsxbq        = 22h
opc_pmovsxwd        = 23h
opc_pmovsxwq        = 24h
opc_pmovsxdq        = 25h
opc_pmovzxbw        = 30h
opc_pmovzxbd        = 31h
opc_pmovzxbq        = 32h
opc_pmovzxwd        = 33h
opc_pmovzxwq        = 34h
opc_pmovzxdq        = 35h
opc_pmuldq          = 28h
opc_pmulld          = 40h
opc_ptest           = 17h
opc_roundpd         = 09h
opc_roundps         = 08h
opc_roundsd         = 0Bh
opc_roundss         = 0Ah

sni_instruction macro dst:req, src:req, nis:req, opc:req, imm8
  local x0, x1, x2, x3, x4, x5, x6, x7

  bracket INSTR <src>,<[>
  IF bracket GT 0
    memtype INSTR <src>,<oword>
    IF memtype EQ 0
      memtype INSTR <src>,<OWORD>
    ENDIF
    IF memtype EQ 0
      .ERR <src must contain: oword ptr >
      EXITM
    ENDIF
  ENDIF
  bracket INSTR <dst>,<[>
  IF bracket GT 0
    memtype INSTR <dst>,<oword>
    IF memtype EQ 0
      memtype INSTR <dst>,<OWORD>
    ENDIF
    IF memtype EQ 0
      .ERR <dst must contain: oword ptr >
      EXITM
    ENDIF
  ENDIF
  IS_REX <src>,REX                  ; do we need REX byte due to src operand?
  REXS = REX
  IF REXS EQ 1                      ; if yes - we have to prepare substitution in order
    s1rc textequ SUBST_HIGH( src )  ; to work correctly with direct memory operands
  ELSE
    s1rc textequ <src>              ; else substitution is not required
  ENDIF
  IS_REX <dst>,REX                  ; do we need REX byte due to dst operand?
  REXD = REX
  IF REXD EQ 1                      ; if yes - we have to prepare substitution in order
    d1st textequ SUBST_HIGH( dst )  ; to work correctly with direct memory operands
  ELSE
    d1st textequ <dst>              ; else substitution is not required
  ENDIF
  REX = REXS + REXD
  NAMS = IS_NAME( src )             ; is there the direct memory operand (defined by name in code
  NAMD = IS_NAME( dst )             ; or data section)? if yes - then another algorithm for macro
  isname = NAMS + NAMD              ; substitution due to bug in ml with relocations definition
  s2rc textequ SUBST_MIMM( src, xmm0 )
  d2st textequ SUBST_MIMM( dst, xmm0 )
  IF isname GT 0                    ; if src or dst contains direct reference to memory operand
    IF REX GT 0
        db reg_xmm
      x0:
        nop
        nop
        movaps d1st,s1rc            ; 66 90 90 0F 28 /r m32
      x1:
        org x0
        movaps d2st,s2rc            ; 66 REX 0F 28 /r /r m32
        org  x0+2
        db   nis
        db   opc
     IFNB <imm8>
        org  x0+5
        dd   0FFFFFFFFH
        org  x1                     ; 66 REX 0F nis opc /r m32
        db imm8
      ELSE
        org  x1
      ENDIF
    ELSE
        db reg_xmm
      x2:
        nop
        movaps dst, src             ; 66 90 0F 28 /r m32
      x3:
        org  x2
        db   reg_mmx
        db   nis
        db   opc
      IFNB <imm8>
        org  x2+4
        dd   0FFFFFFFFH
        org  x3                     ; 66 0F nis opc /r m32
        db   imm8
      ELSE
        org  x3
      ENDIF
    ENDIF
  ELSE                              ; if src or dst doesn't contain direct reference to memory operand
    IF REX GT 0
        db reg_xmm
      x4:
        movaps dst,src              ; 66 REX 0F 28 /r
        org x4+1
        movaps dst,src              ; 66 REX REX 0F 28 /r
      x5:
        org  x4+1
        db   reg_mmx
        db   nis
        db   opc
        org  x5                     ; 66 REX 0F nis opc /r
      IFNB <imm8>
        db   imm8
      ENDIF
    ELSE
        db reg_xmm
      x6:
        nop
        movaps dst, src             ; 66 90 0F 28 /r
      x7:
        org  x6
        db   reg_mmx
        db   nis
        db   opc
        org  x7                     ; 66 0F nis opc /r
      IFNB <imm8>
        db   imm8
      ENDIF
    ENDIF
  ENDIF
endm

DO_NEED_REX MACRO x, gpr32_64, rexbyte  ; test if REX required for pextrw instr (old form)
  gpr32_64 = 0                          ; gpr32_64 shows what gpr is required for substitution - 32bit or 64bit
  rexbyte = 0                           ; if REX is required than rexbyte = 1
  %FOR ygpr,HIGHD_GPR
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
      gpr32_64 = 0
      rexbyte = 1
      EXITM
    ENDIF ; if posgpr > 0
  ENDM ; for ygpr
  IF rexbyte GT 0
    EXITM
  ENDIF
  %FOR ygpr,HIGHQ_GPR
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
      gpr32_64 = 1
      rexbyte = 1
      EXITM
    ENDIF ; if posgpr > 0
  ENDM ; for ygpr
  IF rexbyte GT 0
    EXITM
  ENDIF
  %FOR ygpr,LOWQ_GPR
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
      gpr32_64 = 1
      rexbyte = 1
      EXITM
    ENDIF ; if posgpr > 0
  ENDM ; for ygpr
ENDM

REPLACE_MMX MACRO x, gpr32_64           ; this macro substites any mmx register (in order to use mov r32/64,r32/64 instr)
  xretgpr textequ <x>                   ; with the gpr equivalent (with the same index in mod/r/m byte) for pextrw instr
  qgpr = 0
  %FOR ygpr,ALL_MMX
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
     IF gpr32_64 GT 0
      fgpr = 0
      %FOR zgpr,LOWQ_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ELSE  ; gpr 32 or 64
      fgpr = 0
      %FOR zgpr,LOWD_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ENDIF ; gpr 32 or 64
    ENDIF ; if posx > 0
    qgpr = qgpr + 1
  ENDM ; for y
  EXITM xretgpr
ENDM

REPLACE_XMM MACRO x, gpr32_64           ; this macro substites any xmm register (in order to use mov r32/64,r32/64 instr)
  xretgpr textequ <x>                   ; with the gpr equivalent (with the same index in mod/r/m byte) for extr/insr instr
  yesfound = 0
  qgpr = 0
  %FOR ygpr,LOW_XMM
    IFIDN   <ygpr>,<x>
     IF gpr32_64 GT 0
      fgpr = 0
      %FOR zgpr,LOWQ_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
          yesfound = 1
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ELSE  ; gpr 32 or 64
      fgpr = 0
      %FOR zgpr,LOWD_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
          yesfound = 1
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ENDIF ; gpr 32 or 64
    ENDIF ; if posx > 0
    qgpr = qgpr + 1
  ENDM ; for y
  IF yesfound GT 0
    EXITM xretgpr
  ENDIF
  qgpr = 0
  %FOR ygpr,HIGH_XMM
    IFIDN   <ygpr>,<x>
     IF gpr32_64 GT 0
      fgpr = 0
      %FOR zgpr,HIGHQ_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
          yesfound = 1
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ELSE  ; gpr 32 or 64
      fgpr = 0
      %FOR zgpr,HIGHD_GPR
        IF fgpr EQ qgpr
          xretgpr textequ <zgpr>
          yesfound = 1
         EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
     ENDIF ; gpr 32 or 64
    ENDIF ; if posx > 0
    qgpr = qgpr + 1
  ENDM ; for y
  EXITM xretgpr
ENDM

sni_instr_gpr_new macro dst:req, src:req, nis:req, opc:req, imm8
  local x1, y1, x2, y2
     gpr32_64_d = 0                        ; 32-bit or 64-bit form is used?
     rexbyte_d = 0
     gpr32_64_s = 0                        ; 32-bit or 64-bit form is used?
     rexbyte_s = 0
     DO_NEED_REX dst, gpr32_64_d, rexbyte_d  ; test for if REX byte is required
     IS_REX <dst>,REX                  ; do we need REX byte due to dst operand?
     REXD = REX + rexbyte_d
     DO_NEED_REX src, gpr32_64_s, rexbyte_s  ; test for if REX byte is required
     IS_REX <src>,REX                  ; do we need REX byte due to dst operand?
     REXS = REX + rexbyte_s
     REX = REXS + REXD
     gpr32_64 = gpr32_64_s + gpr32_64_d
     s2rc textequ REPLACE_XMM( src, gpr32_64 ) ; substite src xmm register with gpr that has the same index in mod/r/m byte
     d2st textequ REPLACE_XMM( dst, gpr32_64 ) ; substite dst xmm register with gpr that has the same index in mod/r/m byte
     IF REX GT 0
        db  66h
      x1:
;%echo @CatStr( <r in d1= >,<dst>,< s1=>,<src>)
;%echo @CatStr( <r out d1= >,<d2st>,< s1=>,<s2rc>)
       mov d2st, s2rc                    ; 66 REX 8B /r
        org x1+2
        mov d2st, s2rc                   ; 66 REX 8B REX 8B /r
      y1:
        org x1+1
        db  0Fh
        db  nis
        db  opc                          ; 66 REX 0F nis opc /r
        org y1
     ELSE
        db  66h
        db  0Fh
        db  nis
      x2:
;%echo @CatStr( <nr in d1= >,<dst>,< s1=>,<src>)
;%echo @CatStr( <nr out d1= >,<d2st>,< s1=>,<s2rc>)
        mov d2st, s2rc                   ; 66 0F nis 8B /r
      y2:
        org x2
        db  opc                          ; 66 0F nis opc /r
        org y2
     ENDIF
     db imm8                             ; 66 <REX> 0F nis opc /r
endm

IS_GPRDQ MACRO x, GPRDQ
    GPRDQ = 0
    %FOR ygprdq,HIGHDQ_GPR
      IF @InStr( , x, ygprdq ) NE 0
        GPRDQ = 1
        EXITM
      ENDIF
    ENDM
    IF GPRDQ EQ 0
      %FOR ygprdq,LOWDQ_GPR
        IF @InStr( , x, ygprdq ) NE 0
          GPRDQ = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
ENDM

IS_XMMALL MACRO x, GPRDQ
    GPRDQ = 0
    %FOR yxmmall,HIGH_XMM
      IFIDN   <yxmmall>,<x>
        GPRDQ = 1
        EXITM
      ENDIF
    ENDM
    IF GPRDQ EQ 0
      %FOR yxmmall,LOW_XMM
        IFIDN   <yxmmall>,<x>
          GPRDQ = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
ENDM

sni_instr_src_m_gpr macro dst:req, src:req, nis:req, opc:req, mem:req, imm8
    IFIDN <mem>,<m8>
      memlc textequ <byte>
      memuc textequ <BYTE>
    ENDIF
    IFIDN <mem>,<m16>
      memlc textequ <word>
      memuc textequ <WORD>
    ENDIF
    IFIDN <mem>,<m32>
      memlc textequ <dword>
      memuc textequ <DWORD>
    ENDIF
    IFIDN <mem>,<m64>
      memlc textequ <qword>
      memuc textequ <QWORD>
    ENDIF
    src_dup textequ <src>
    bracket INSTR <src>,<[>
    IF bracket EQ 0
      bracket INSTR <src>,<ptr>
    ENDIF
    IF bracket EQ 0
      bracket INSTR <src>,<PTR>
    ENDIF
    IF bracket GT 0
      memtype INSTR <src>,memlc
      IF memtype EQ 0
        memtype INSTR <src>,memuc
      ENDIF
      IF memtype GT 0
        f1mem SUBSTR <src>, 1, memtype - 1
        f2mem SUBSTR <src>, memtype + @SizeStr( memlc )
        src_dup CATSTR <f1mem>, < oword >, <f2mem>
        sni_instruction dst, %src_dup, nis, opc, imm8
      ELSE
        .ERR <must be: &memlc ptr >
        EXITM
      ENDIF
    ELSE
      IS_GPRDQ src, GPRDQ
      IF GPRDQ EQ 0
        .ERR <bad source operand>
      ELSE
        sni_instr_gpr_new dst, src, nis, opc, imm8
      ENDIF
    ENDIF
endm

sni_instr_src_m_xmm macro dst:req, src:req, nis:req, opc:req, mem:req, imm8
    IFIDN <mem>,<m8>
      memlc textequ <byte>
      memuc textequ <BYTE>
    ENDIF
    IFIDN <mem>,<m16>
      memlc textequ <word>
      memuc textequ <WORD>
    ENDIF
    IFIDN <mem>,<m32>
      memlc textequ <dword>
      memuc textequ <DWORD>
    ENDIF
    IFIDN <mem>,<m64>
      memlc textequ <qword>
      memuc textequ <QWORD>
    ENDIF
    src_dup textequ <src>
    bracket INSTR <src>,<[>
    IF bracket EQ 0
      bracket INSTR <src>,<ptr>
    ENDIF
    IF bracket EQ 0
      bracket INSTR <src>,<PTR>
    ENDIF
    IF bracket GT 0
      memtype INSTR <src>,memlc
      IF memtype EQ 0
        memtype INSTR <src>,memuc
      ENDIF
      IF memtype GT 0
        f1mem SUBSTR <src>, 1, memtype - 1
        f2mem SUBSTR <src>, memtype + @SizeStr( memlc )
        src_dup CATSTR <f1mem>, < oword >, <f2mem>
        sni_instruction dst, %src_dup, nis, opc, imm8
      ELSE
        .ERR <must be: &memlc ptr >
        EXITM
      ENDIF
    ELSE
      IS_XMMALL src, GPRDQ
      IF GPRDQ EQ 0
        .ERR <bad source operand>
      ELSE
        sni_instruction dst, src, nis, opc, imm8
      ENDIF
    ENDIF
endm

sni_instr_dst_m_gpr macro dst:req, src:req, nis:req, opc:req, mem:req, imm8
    IFIDN <mem>,<m8>
      memlc textequ <byte>
      memuc textequ <BYTE>
    ENDIF
    IFIDN <mem>,<m16>
      memlc textequ <word>
      memuc textequ <WORD>
    ENDIF
    IFIDN <mem>,<m32>
      memlc textequ <dword>
      memuc textequ <DWORD>
    ENDIF
    IFIDN <mem>,<m64>
      memlc textequ <qword>
      memuc textequ <QWORD>
    ENDIF
    dst_dup textequ <dst>
    bracket INSTR <dst>,<[>
    IF bracket EQ 0
      bracket INSTR <dst>,<ptr>
    ENDIF
    IF bracket EQ 0
      bracket INSTR <dst>,<PTR>
    ENDIF
    IF bracket GT 0
      memtype INSTR <dst>,memlc
      IF memtype EQ 0
        memtype INSTR <dst>,memuc
      ENDIF
      IF memtype GT 0
        f1mem SUBSTR <dst>, 1, memtype - 1
        f2mem SUBSTR <dst>, memtype + @SizeStr( memlc )
        dst_dup CATSTR <f1mem>, < oword >, <f2mem>
        sni_instruction src, %dst_dup, nis, opc, imm8
      ELSE
        .ERR <must be: &memlc ptr >
        EXITM
      ENDIF
    ELSE
      IS_GPRDQ dst, GPRDQ
      IF GPRDQ EQ 0
        .ERR <bad destination operand>
      ELSE
        sni_instr_gpr_new src, dst, nis, opc, imm8
      ENDIF
    ENDIF
endm

;IF @Version LT 900
IFNDEF D_ML900

;  OPTION NOKEYWORD:<blendpd>
; 66 0F 3A 0D  blendpd     xmm1, xmm2/m128, imm8
blendpd macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_blendpd, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<blendps>
; 66 0F 3A 0C  blendps     xmm1, xmm2/m128, imm8
blendps macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_blendps, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<blendvpd>
; 66 0F 38 15  blendvpd    xmm1, xmm2/m128, XMM0
blendvpd macro dst:req, src:req, z
  %sni_instruction dst, src, nis_sni, opc_blendvpd
endm

;  OPTION NOKEYWORD:<blendvps>
; 66 0F 38 14  blendvps    xmm1, xmm2/m128, XMM0
blendvps macro dst:req, src:req, z
  %sni_instruction dst, src, nis_sni, opc_blendvps
endm

;  OPTION NOKEYWORD:<dppd>
; 66 0F 3A 41  dppd     xmm1, xmm2/m128, imm8
dppd macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_dppd, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<dpps>
; 66 0F 3A 40  dpps     xmm1, xmm2/m128, imm8
dpps macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_dpps, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<extractps>
; 66 0F 3A 17  extractps     r/m32, xmm2, imm8
extractps macro dst:req, src:req, imm8:req
  %sni_instr_dst_m_gpr dst, src, nis_snia, opc_extractps, m32, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<insertps>
; 66 0F 3A 21  insertps    xmm1, xmm2/m32, imm8
insertps macro dst:req, src:req, imm8:req
  %sni_instr_src_m_xmm dst, src, nis_snia, opc_insertps, m32, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<movntdqa>
; 66 0F 38 2A  movntdqa     xmm1, m128
movntdqa macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_movntdqa
endm

;  OPTION NOKEYWORD:<mpsadbw>
; 66 0F 3A 42  mpsadbw    xmm1, xmm2/m32, imm8
mpsadbw macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_mpsadbw, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<packusdw>
; 66 0F 38 2B  packusdw     xmm1, xmm2/m128
packusdw macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_packusdw
endm

;  OPTION NOKEYWORD:<pblendvb>
; 66 0F 38 10  pblendvb    xmm1, xmm2/m128, XMM0
pblendvb macro dst:req, src:req, z
  %sni_instruction dst, src, nis_sni, opc_pblendvb
endm

;  OPTION NOKEYWORD:<pblendw>
; 66 0F 3A 0E  pblendw     xmm1, xmm2/m128, imm8
pblendw macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_pblendw, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pcmpeqq>
; 66 0F 38 29  pcmpeqq     xmm1, xmm2/m128
pcmpeqq macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pcmpeqq
endm

;  OPTION NOKEYWORD:<pextrb>
; 66 0F 3A 14  pextrb     r32/m8, xmm2, imm8
pextrb macro dst:req, src:req, imm8:req
  %sni_instr_dst_m_gpr dst, src, nis_snia, opc_pextrb, m8, imm8
;  db imm8
endm


IF _IPP32E GE _IPP32E_Y8


  OPTION NOKEYWORD:<pextrw>
; 66 0F 3A 15  pextrw     r32/m16, xmm2, imm8
pextrw macro dst:req, src:req, imm8:req
  local x1, y1, x2, y2
   IFMMX_REG src, f                      ; if mmx register - old (P4) coding should be used
   IF f GT 0
     gpr32_64 = 0                        ; 32-bit or 64-bit form is used?
     rexbyte = 0
     DO_NEED_REX dst, gpr32_64, rexbyte  ; test for if REX byte is required
     s2rc textequ REPLACE_MMX( src, gpr32_64 ) ; substite source mmx register with gpr that has the same index in mod/r/m byte
     IF rexbyte GT 0
      x1:
        mov dst, s2rc                    ; REX 8B /r
        org x1+1
        mov dst, s2rc                    ; REX REX 8B /r
      y1:
        org x1+1
        db  0Fh
        db  0C5h                         ; REX 0F C5 /r
        org y1
     ELSE
      x2:
        nop
        mov dst, s2rc                    ; 90 8B /r
      y2:
        org x2
        db  0Fh
        db  0C5h                         ; 0F C5 /r
        org y2
     ENDIF
     db imm8                             ; 0F C5 /r imm8
   ELSE
     %sni_instr_dst_m_gpr dst, src, nis_snia, opc_pextrw, m16, imm8
   ENDIF
endm
ENDIF

;  OPTION NOKEYWORD:<pextrd>
; 66 0F 3A 16  pextrd     r32/m32, xmm2, imm8
pextrd macro dst:req, src:req, imm8:req
  %sni_instr_dst_m_gpr dst, src, nis_snia, opc_pextrd, m32, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pextrq>
; 66 REX 0F 3A 16  pextrq     r64/m64, xmm2, imm8
pextrq macro dst:req, src:req, imm8:req
  %sni_instr_dst_m_gpr dst, src, nis_snia, opc_pextrd, m64, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<phminposuw>
; 66 0F 38 41  phminposuw     xmm1, xmm2/m128
phminposuw macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_phminposuw
endm

;  OPTION NOKEYWORD:<pinsrb>
; 66 0F 3A 20  pinsrb     xmm1, r32/m8, imm8
pinsrb macro dst:req, src:req, imm8:req
  %sni_instr_src_m_gpr dst, src, nis_snia, opc_pinsrb, m8, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pinsrd>
; 66 0F 3A 22  pinsrd     xmm1, r32/m32, imm8
pinsrd macro dst:req, src:req, imm8:req
  %sni_instr_src_m_gpr dst, src, nis_snia, opc_pinsrd, m32, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pinsrq>
; 66 REX 0F 3A 22  pinsrq     xmm1, r64/m64, imm8
pinsrq macro dst:req, src:req, imm8:req
  %sni_instr_src_m_gpr dst, src, nis_snia, opc_pinsrd, m64, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<pmaxsb>
; 66 0F 38 3C  pmaxsb     xmm1, xmm2/m128
pmaxsb macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmaxsb
endm

;  OPTION NOKEYWORD:<pmaxsd>
; 66 0F 38 3D  pmaxsd     xmm1, xmm2/m128
pmaxsd macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmaxsd
endm

;  OPTION NOKEYWORD:<pmaxud>
; 66 0F 38 3F  pmaxud     xmm1, xmm2/m128
pmaxud macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmaxud
endm

;  OPTION NOKEYWORD:<pmaxuw>
; 66 0F 38 3E  pmaxuw     xmm1, xmm2/m128
pmaxuw macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmaxuw
endm

;  OPTION NOKEYWORD:<pminsb>
; 66 0F 38 38  pminsb     xmm1, xmm2/m128
pminsb macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pminsb
endm

;  OPTION NOKEYWORD:<pminsd>
; 66 0F 38 39  pminsd     xmm1, xmm2/m128
pminsd macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pminsd
endm

;  OPTION NOKEYWORD:<pminud>
; 66 0F 38 3B  pminud     xmm1, xmm2/m128
pminud macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pminud
endm

;  OPTION NOKEYWORD:<pminuw>
; 66 0F 38 3A  pminuw     xmm1, xmm2/m128
pminuw macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pminuw
endm

;  OPTION NOKEYWORD:<pmovsxbw>
; 66 0F 38 20  pmovsxbw     xmm1, xmm2/m64
pmovsxbw macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxbw, m64
endm

;  OPTION NOKEYWORD:<pmovsxbd>
; 66 0F 38 21  pmovsxbd     xmm1, xmm2/m32
pmovsxbd macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxbd, m32
endm

;  OPTION NOKEYWORD:<pmovsxbq>
; 66 0F 38 22  pmovsxbq     xmm1, xmm2/m16
pmovsxbq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxbq, m16
endm

;  OPTION NOKEYWORD:<pmovsxwd>
; 66 0F 38 23  pmovsxwd     xmm1, xmm2/m64
pmovsxwd macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxwd, m64
endm

;  OPTION NOKEYWORD:<pmovsxwq>
; 66 0F 38 24  pmovsxwq     xmm1, xmm2/m32
pmovsxwq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxwq, m32
endm

;  OPTION NOKEYWORD:<pmovsxdq>
; 66 0F 38 25  pmovsxdq     xmm1, xmm2/m64
pmovsxdq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovsxdq, m64
endm

;  OPTION NOKEYWORD:<pmovzxbw>
; 66 0F 38 30  pmovzxbw     xmm1, xmm2/m64
pmovzxbw macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxbw, m64
endm

;  OPTION NOKEYWORD:<pmovzxbd>
; 66 0F 38 31  pmovzxbd     xmm1, xmm2/m32
pmovzxbd macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxbd, m32
endm

;  OPTION NOKEYWORD:<pmovzxbq>
; 66 0F 38 32  pmovzxbq     xmm1, xmm2/m16
pmovzxbq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxbq, m16
endm

;  OPTION NOKEYWORD:<pmovzxwd>
; 66 0F 38 33  pmovzxwd     xmm1, xmm2/m64
pmovzxwd macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxwd, m64
endm

;  OPTION NOKEYWORD:<pmovzxwq>
; 66 0F 38 34  pmovzxwq     xmm1, xmm2/m32
pmovzxwq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxwq, m32
endm

;  OPTION NOKEYWORD:<pmovzxdq>
; 66 0F 38 35  pmovzxdq     xmm1, xmm2/m64
pmovzxdq macro dst:req, src:req
  %sni_instr_src_m_xmm dst, src, nis_sni, opc_pmovzxdq, m64
endm

;  OPTION NOKEYWORD:<pmuldq>
; 66 0F 38 28  pmuldq     xmm1, xmm2/m128
pmuldq macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmuldq
endm

;  OPTION NOKEYWORD:<pmulld>
; 66 0F 38 40  pmulld     xmm1, xmm2/m128
pmulld macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_pmulld
endm

;  OPTION NOKEYWORD:<ptest>
; 66 0F 38 17  ptest     xmm1, xmm2/m128
ptest macro dst:req, src:req
  %sni_instruction dst, src, nis_sni, opc_ptest
endm

;  OPTION NOKEYWORD:<roundpd>
; 66 0F 3A 09  roundpd     xmm1, xmm2/m128, imm8
roundpd macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_roundpd, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<roundps>
; 66 0F 3A 08  roundps     xmm1, xmm2/m128, imm8
roundps macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_snia, opc_roundps, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<roundsd>
; 66 0F 3A 0B  roundsd     xmm1, xmm2/m64, imm8
roundsd macro dst:req, src:req, imm8:req
  %sni_instr_src_m_xmm dst, src, nis_snia, opc_roundsd, m64, imm8
;  db imm8
endm

;  OPTION NOKEYWORD:<roundss>
; 66 0F 3A 0A  roundss     xmm1, xmm2/m32, imm8
roundss macro dst:req, src:req, imm8:req
  %sni_instr_src_m_xmm dst, src, nis_snia, opc_roundss, m32, imm8
;  db imm8
endm

; STTNI (SSE4.2)

nis_sttni           = 38h ; new instruction set
nis_sttnia          = 3Ah ; new instruction set 'a' (with imm8)

opc_pcmpestri       = 61h
opc_pcmpestrm       = 60h
opc_pcmpistri       = 63h
opc_pcmpistrm       = 62h
opc_pcmpgtq         = 37h
opc_crc32_m8        = 0F0h
opc_crc32           = 0F1h

; 66 0F 3A 61  pcmpestri     xmm1, xmm2/m128, imm8
pcmpestri macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_pcmpestri, imm8
endm

; 66 0F 3A 60  pcmpestrm     xmm1, xmm2/m128, imm8
pcmpestrm macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_pcmpestrm, imm8
endm

; 66 0F 3A 63  pcmpistri     xmm1, xmm2/m128, imm8
pcmpistri macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_pcmpistri, imm8
endm

; 66 0F 3A 62  pcmpistrm     xmm1, xmm2/m128, imm8
pcmpistrm macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_pcmpistrm, imm8
endm

; 66 0F 38 37  pcmpgtq     xmm1, xmm2/m128
pcmpgtq macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_pcmpgtq
endm


; WSM (AES NI)

opc_aesenc          = 0DCh
opc_aesenclast      = 0DDh
opc_aesdec          = 0DEh
opc_aesdeclast      = 0DFh
opc_aesimc          = 0DBh
opc_aeskeygenassist = 0DFh
opc_pclmulqdq       = 044h

; 66 0F 38 DC  aesenc     xmm1, xmm2/m128
aesenc macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_aesenc
endm

; 66 0F 38 DD  aesenclast     xmm1, xmm2/m128
aesenclast macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_aesenclast
endm

; 66 0F 38 DE  aesdec     xmm1, xmm2/m128
aesdec macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_aesdec
endm

; 66 0F 38 DF  aesdeclast     xmm1, xmm2/m128
aesdeclast macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_aesdeclast
endm

; 66 0F 38 DB  aesimc     xmm1, xmm2/m128
aesimc macro dst:req, src:req
  %sni_instruction dst, src, nis_sttni, opc_aesimc
endm

; 66 0F 3A DF  aeskeygenassist     xmm1, xmm2/m128, imm8
aeskeygenassist macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_aeskeygenassist, imm8
endm

; 66 0F 3A 44  pclmulqdq     xmm1, xmm2/m128, imm8
pclmulqdq macro dst:req, src:req, imm8:req
  %sni_instruction dst, src, nis_sttnia, opc_pclmulqdq, imm8
endm

ENDIF

; AVX 2.0 NI

get3rdbyte MACRO reg:req, opc3:req
  IS_XMMALL reg, x
  IF x EQ 0
    opc3 = 085H
  ELSE
    opc3 = 081H
  ENDIF
  %FOR num,ALL_NUM
    IF @InStr( , reg, num ) NE 0
      EXITM
    ENDIF
   opc3 = opc3 + 8
  ENDM
endm

avx20_double MACRO op1:req, op2:req, op3:req, opc:req
  local x0, x1
  x0:
     vpermilpd op1, op2, op3
  x1:
     org x0+2
     get3rdbyte <op2>, opc3
     db opc3
     db opc
     org x1
endm

avx20_float MACRO op1:req, op2:req, op3:req, opc:req
local x0, x1
  x0:
     vpermilps op1, op2, op3
  x1:
     org x0+3
     db opc
     org x1
endm

; VEX.DDS.128/256.66.0F38.W1 98 /r  VFMADD132PD xmm0, xmm1, xmm2/m128
vfmadd132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 98H
endm
; VEX.DDS.128/256.66.0F38.W1 A8 /r  VFMADD213PD xmm0, xmm1, xmm2/m128
vfmadd213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0A8H
endm
; VEX.DDS.128/256.66.0F38.W1 B8 /r  VFMADD231PD xmm0, xmm1, xmm2/m128
vfmadd231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0B8H
endm
; VEX.DDS.128/256.66.0F38.W0 98 /r  VFMADD132PS xmm0, xmm1, xmm2/m128
vfmadd132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 98H
endm
; VEX.DDS.128/256.66.0F38.W0 A8 /r  VFMADD213PS xmm0, xmm1, xmm2/m128
vfmadd213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0A8H
endm
; VEX.DDS.128/256.66.0F38.W0 B8 /r  VFMADD231PS xmm0, xmm1, xmm2/m128
vfmadd231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0B8H
endm

; VEX.DDS.128/256.66.0F38.W1 99 /r  VFMADD132SD xmm0, xmm1, xmm2/m128
vfmadd132sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 99H
endm
; VEX.DDS.128/256.66.0F38.W1 A9 /r  VFMADD213SD xmm0, xmm1, xmm2/m128
vfmadd213sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0A9H
endm
; VEX.DDS.128/256.66.0F38.W1 B9 /r  VFMADD231SD xmm0, xmm1, xmm2/m128
vfmadd231sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0B9H
endm

; VEX.DDS.128/256.66.0F38.W0 99 /r  VFMADD132SS xmm0, xmm1, xmm2/m128
vfmadd132ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 99H
endm
; VEX.DDS.128/256.66.0F38.W0 A9 /r  VFMADD213SS xmm0, xmm1, xmm2/m128
vfmadd213ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0A9H
endm
; VEX.DDS.128/256.66.0F38.W0 B9 /r  VFMADD231SS xmm0, xmm1, xmm2/m128
vfmadd231ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0B9H
endm

; VEX.DDS.128/256.66.0F38.W1 96 /r  VFMADDSUB132PD xmm0, xmm1, xmm2/m128
vfmaddsub132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 96H
endm
; VEX.DDS.128/256.66.0F38.W1 A6 /r  VFMADDSUB213PD xmm0, xmm1, xmm2/m128
vfmaddsub213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0A6H
endm
; VEX.DDS.128/256.66.0F38.W1 B6 /r  VFMADDSUB231PD xmm0, xmm1, xmm2/m128
vfmaddsub231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0B6H
endm

; VEX.DDS.128/256.66.0F38.W0 96 /r  VFMADDSUB132PS xmm0, xmm1, xmm2/m128
vfmaddsub132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 96H
endm
; VEX.DDS.128/256.66.0F38.W0 A6 /r  VFMADDSUB213PS xmm0, xmm1, xmm2/m128
vfmaddsub213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0A6H
endm
; VEX.DDS.128/256.66.0F38.W0 B6 /r  VFMADDSUB231PS xmm0, xmm1, xmm2/m128
vfmaddsub231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0B6H
endm

; VEX.DDS.128/256.66.0F38.W1 97 /r  VFMSUBADD132PD xmm0, xmm1, xmm2/m128
vfmsubadd132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 97H
endm
; VEX.DDS.128/256.66.0F38.W1 A7 /r  VFMSUBADD213PD xmm0, xmm1, xmm2/m128
vfmsubadd213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0A7H
endm
; VEX.DDS.128/256.66.0F38.W1 B7 /r  VFMSUBADD231PD xmm0, xmm1, xmm2/m128
vfmsubadd231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0B7H
endm

; VEX.DDS.128/256.66.0F38.W0 97 /r  VFMSUBADD132PS xmm0, xmm1, xmm2/m128
vfmsubadd132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 97H
endm
; VEX.DDS.128/256.66.0F38.W0 A7 /r  VFMSUBADD213PS xmm0, xmm1, xmm2/m128
vfmsubadd213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0A7H
endm
; VEX.DDS.128/256.66.0F38.W0 B7 /r  VFMSUBADD231PS xmm0, xmm1, xmm2/m128
vfmsubadd231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0B7H
endm

; VEX.DDS.128/256.66.0F38.W1 9A /r  VFMSUB132PD xmm0, xmm1, xmm2/m128
vfmsub132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9AH
endm
; VEX.DDS.128/256.66.0F38.W1 AA /r  VFMSUB213PD xmm0, xmm1, xmm2/m128
vfmsub213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0AAH
endm
; VEX.DDS.128/256.66.0F38.W1 BA /r  VFMSUB231PD xmm0, xmm1, xmm2/m128
vfmsub231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BAH
endm

; VEX.DDS.128/256.66.0F38.W0 9A /r  VFMSUB132PS xmm0, xmm1, xmm2/m128
vfmsub132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 9AH
endm
; VEX.DDS.128/256.66.0F38.W0 AA /r  VFMSUB213PS xmm0, xmm1, xmm2/m128
vfmsub213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0AAH
endm
; VEX.DDS.128/256.66.0F38.W0 BA /r  VFMSUB231PS xmm0, xmm1, xmm2/m128
vfmsub231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BAH
endm

; VEX.DDS.128/256.66.0F38.W1 9B /r  VFMSUB132SD xmm0, xmm1, xmm2/m128
vfmsub132sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9BH
endm
; VEX.DDS.128/256.66.0F38.W1 AB /r  VFMSUB213SD xmm0, xmm1, xmm2/m128
vfmsub213sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0ABH
endm
; VEX.DDS.128/256.66.0F38.W1 BB /r  VFMSUB231SD xmm0, xmm1, xmm2/m128
vfmsub231sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BBH
endm

; VEX.DDS.128/256.66.0F38.W0 9B /r  VFMSUB132SS xmm0, xmm1, xmm2/m128
vfmsub132ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 9BH
endm
; VEX.DDS.128/256.66.0F38.W0 AB /r  VFMSUB213SS xmm0, xmm1, xmm2/m128
vfmsub213ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0ABH
endm
; VEX.DDS.128/256.66.0F38.W0 BB /r  VFMSUB231SS xmm0, xmm1, xmm2/m128
vfmsub231ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BBH
endm

; VEX.DDS.128/256.66.0F38.W1 9C /r  VFNMADD132PD xmm0, xmm1, xmm2/m128
vfnmadd132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9CH
endm
; VEX.DDS.128/256.66.0F38.W1 AC /r  VFNMADD213PD xmm0, xmm1, xmm2/m128
vfnmadd213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0ACH
endm
; VEX.DDS.128/256.66.0F38.W1 BC /r  VFNMADD231PD xmm0, xmm1, xmm2/m128
vfnmadd231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BCH
endm
; VEX.DDS.128/256.66.0F38.W0 9C /r  VFNMADD132PS xmm0, xmm1, xmm2/m128
vfnmadd132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 9CH
endm
; VEX.DDS.128/256.66.0F38.W0 AC /r  VFNMADD213PS xmm0, xmm1, xmm2/m128
vfnmadd213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0ACH
endm
; VEX.DDS.128/256.66.0F38.W0 BC /r  VFNMADD231PS xmm0, xmm1, xmm2/m128
vfnmadd231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BCH
endm

; VEX.DDS.128/256.66.0F38.W1 9D /r  VFNMADD132SD xmm0, xmm1, xmm2/m128
vfnmadd132sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9DH
endm
; VEX.DDS.128/256.66.0F38.W1 AD /r  VFNMADD213SD xmm0, xmm1, xmm2/m128
vfnmadd213sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0ADH
endm
; VEX.DDS.128/256.66.0F38.W1 BD /r  VFNMADD231SD xmm0, xmm1, xmm2/m128
vfnmadd231sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BDH
endm

; VEX.DDS.128/256.66.0F38.W0 9D /r  VFNMADD132SS xmm0, xmm1, xmm2/m128
vfnmadd132ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 9DH
endm
; VEX.DDS.128/256.66.0F38.W0 AD /r  VFNMADD213SS xmm0, xmm1, xmm2/m128
vfnmadd213ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0ADH
endm
; VEX.DDS.128/256.66.0F38.W0 BD /r  VFNMADD231SS xmm0, xmm1, xmm2/m128
vfnmadd231ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BDH
endm

; VEX.DDS.128/256.66.0F38.W1 9E /r  VFNMSUB132PD xmm0, xmm1, xmm2/m128
vfnmsub132pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9EH
endm
; VEX.DDS.128/256.66.0F38.W1 AE /r  VFNMSUB213PD xmm0, xmm1, xmm2/m128
vfnmsub213pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0AEH
endm
; VEX.DDS.128/256.66.0F38.W1 BE /r  VFNMSUB231PD xmm0, xmm1, xmm2/m128
vfnmsub231pd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BEH
endm

; VEX.DDS.128/256.66.0F38.W0 9E /r  VFNMSUB132PS xmm0, xmm1, xmm2/m128
vfnmsub132ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 9EH
endm
; VEX.DDS.128/256.66.0F38.W0 AE /r  VFNMSUB213PS xmm0, xmm1, xmm2/m128
vfnmsub213ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0AEH
endm
; VEX.DDS.128/256.66.0F38.W0 BE /r  VFNMSUB231PS xmm0, xmm1, xmm2/m128
vfnmsub231ps macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BEH
endm

; VEX.DDS.128/256.66.0F38.W1 9F /r  VFNMSUB132SD xmm0, xmm1, xmm2/m128
vfnmsub132sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 9FH
endm
; VEX.DDS.128/256.66.0F38.W1 AF /r  VFNMSUB213SD xmm0, xmm1, xmm2/m128
vfnmsub213sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0AFH
endm
; VEX.DDS.128/256.66.0F38.W1 BF /r  VFNMSUB231SD xmm0, xmm1, xmm2/m128
vfnmsub231sd macro x:req, y:req, z:req
  %avx20_double x, y, z, 0BFH
endm

; VEX.DDS.128/256.66.0F38.W0 9F /r  VFNMSUB132SS xmm0, xmm1, xmm2/m128
vfnmsub132ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 9FH
endm
; VEX.DDS.128/256.66.0F38.W0 AF /r  VFNMSUB213SS xmm0, xmm1, xmm2/m128
vfnmsub213ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0AFH
endm
; VEX.DDS.128/256.66.0F38.W0 BF /r  VFNMSUB231SS xmm0, xmm1, xmm2/m128
vfnmsub231ss macro x:req, y:req, z:req
  %avx20_float x, y, z, 0BFH
endm

; substitution because of a bug in ml10.0 version 10.00.30128.01
; VEX.256.66.0F3A 19 /r ib
  OPTION NOKEYWORD:< vextractf128>
  vextractf128 macro xx:req, yy:req, imm:req
      local x1, x2, q, f, z, memoprndl, memoprndu, memopl, memopu
    memoprndl textequ <word>
    memoprndu textequ <WORD>
    memopl INSTR <xx>, memoprndl
    memopu INSTR <xx>, memoprndu
    IF (memopl+memopu) GT 0
          q textequ <ymm>
          f SUBSTR <xx>, 2
          z CATSTR q, f
    ELSE
          q textequ <y>
          f SUBSTR <xx>, 2
          z CATSTR q, f
    ENDIF
    x1:
    vpermilpd yy, z, imm
    x2:
     org x1+3
     db 19H
     org x2
  endm
; AVX2 (HSW)

getW0W1 MACRO reg:req, opc3:req, w0w1:req
  IS_XMMALL reg, x
  IF x EQ 0
    opc3 = 085H
  ELSE
    opc3 = 081H
  ENDIF
  %FOR num,ALL_NUM
    IF @InStr( , reg, num ) NE 0
      EXITM
    ENDIF
   opc3 = opc3 + 8
  ENDM
  IF w0w1 EQ 0
    opc3 = opc3 - 80H
  ENDIF
endm

;VEX.NDS.128.66.0F38.W0 47 /r
vpsllvd MACRO op1:req, op2:req, op3:req
local x0, x1
  x0:
     vpermilps op1, op2, op3
  x1:
     org x0+3
     db 47H
     org x1
endm

;VEX.NDS.128.66.0F38.W1 47 /r
vpsllvq MACRO op1:req, op2:req, op3:req
local x0, x1
  x0:
     vpermilps op1, op2, op3
  x1:
     org x0+2
     getW0W1 <op2>, opc3, 1
     db opc3
     db 47H
     org x1
endm
ENDIF ; IFNDEF ML1100

;IFNDEF ML1200
; BDW MACRO for ML1100 adox & adcx

ALL_XMM textequ <!<xmm0,XMM0,xmm1,XMM1,xmm2,XMM2,xmm3,XMM3,xmm4,XMM4,xmm5,XMM5,xmm6,XMM6,xmm7,XMM7,xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15!>>
ALL_GPR textequ <!<ax,AX,cx,CX,dx,DX,bx,BX,sp,SP,bp,BP,si,SI,di,DI,r8,R8,r9,R9,r10,R10,r11,R11,r12,R12,r13,R13,r14,R14,r15,R15!>>
REX_GPR textequ <!<r8,R8,r9,R9,r10,R10,r11,R11,r12,R12,r13,R13,r14,R14,r15,R15!>>
DD_GPR textequ <!<eax,EAX,ecx,ECX,edx,EDX,ebx,EBX,esp,ESP,ebp,EBP,esi,ESI,edi,EDI,r8d,R8D,r9d,R9D,r10d,R10D,r11d,R11D,r12d,R12D,r13d,R13D,r14d,R14D,r15d,R15D!>>

REPLACE_GPR MACRO x           ; this macro substites any GPR register 
  xretxmm textequ <>          ; with XMM equivalent (with the same index in mod/r/m byte)
  gpridx = 0
  %FOR igpr,ALL_GPR
    IF @InStr(,x,igpr) NE 0
      xmmidx = 0
      %FOR ixmm,ALL_XMM
        IF xmmidx EQ gpridx
          xretxmm textequ <ixmm>
         EXITM xretxmm
        ENDIF ; if idx xmm & gpr is EQ
        xmmidx = xmmidx + 1
      ENDM ; for ixmm
      IF @SizeStr(%xretxmm) GT 0
        EXITM xretxmm
      ENDIF
    ENDIF
    gpridx = gpridx + 1
  ENDM ; for igpr
  EXITM xretxmm ; if replacement has not been found - return empty string that will cause ASM error
ENDM

TEST_REX MACRO x:req, y:req, rex:req, bit64:req
  rex = 0
  %FOR igpr,REX_GPR
    IF @InStr(,x,igpr) NE 0
      rex = 1
      EXITM
    ENDIF
    IF @InStr(,y,igpr) NE 0
      rex = 1
      EXITM
    ENDIF
  ENDM ; for igpr
  bit64 = 1
  %FOR igpr,DD_GPR
    IFIDN <igpr>, <x>
      bit64 = 0
      EXITM
    ENDIF
  ENDM ; for igpr
ENDM

IFDEF ML1200

OPTION NOKEYWORD:<adcx>
OPTION NOKEYWORD:<adox>

ENDIF

; REX.W 66.0F38.F6/r
adcx MACRO op1:req, op2:req
  local x0, x1, rex
  op1subst textequ REPLACE_GPR( op1 )
  TEST_REX op1, op2, rex, bit64
  rex = rex + 2
  if bit64 GT 0
    x0:
      pinsrq op1subst, op2, 0
    x1:
      org x0 + 3
      db 038H
      db 0F6H
      org x1 - 1
  else
    x0:
      pinsrd op1subst, op2, 0
    x1:
      org x0 + rex
      db 038H
      db 0F6H
      org x1 - 1
  endif
endm

; REX.W F3.0F38.F6/r
adox MACRO op1:req, op2:req
  local x0, x1, rex
  op1subst textequ REPLACE_GPR( op1 )
  TEST_REX op1, op2, rex, bit64
  rex = rex + 2
  if bit64 GT 0
    x0:
      pinsrq op1subst, op2, 0
    x1:
      org x0
      db 0F3H
      org x0 + 3
      db 038H
      db 0F6H
      org x1 - 1
  else
    x0:
      pinsrd op1subst, op2, 0
    x1:
      org x0
      db 0F3H
      org x0 + rex
      db 038H
      db 0F6H
      org x1 - 1
  endif
endm
;ENDIF ; IFNDEF ML1200


;IFNDEF ML1400
IFDEF ML1400
  OPTION NOKEYWORD:<sha1rnds4>
  OPTION NOKEYWORD:<sha1nexte>
  OPTION NOKEYWORD:<sha1msg1>
  OPTION NOKEYWORD:<sha1msg2>
  OPTION NOKEYWORD:<sha256rnds2>
  OPTION NOKEYWORD:<sha256msg1>
  OPTION NOKEYWORD:<sha256msg2>
ENDIF

HIGHQ_GPR  textequ <!<r8,R8,r9,R9,r10,R10,r11,R11,r12,R12,r13,R13,r14,R14,r15,R15!>>
LOWQ_GPR   textequ <!<rax,RAX,rcx,RCX,rdx,RDX,rbx,RBX,rsp,RSP,rbp,RBP,rsi,RSI,rdi,RDI!>>
HIGH_XMM   textequ <!<xmm8,XMM8,xmm9,XMM9,xmm10,XMM10,xmm11,XMM11,xmm12,XMM12,xmm13,XMM13,xmm14,XMM14,xmm15,XMM15!>>
LOW_XMM    textequ <!<xmm0,XMM0,xmm1,XMM1,xmm2,XMM2,xmm3,XMM3,xmm4,XMM4,xmm5,XMM5,xmm6,XMM6,xmm7,XMM7!>>
HIGHDQ_GPR textequ <!<R8D,r8d,R8,r8,R9D,r9d,R9,r9,R10D,r10d,R10,r10,R11D,r11d,R11,r11,R12D,r12d,R12,r12,R13D,r13d,R13,r13,R14D,r14d,R14,r14,R15D,r15d,R15,r15!>>
LOWDQ_GPR  textequ <!<EAX,eax,RAX,rax,ECX,ecx,RCX,rcx,EDX,edx,RDX,rdx,EBX,ebx,RBX,rbx,ESP,esp,RSP,rsp,EBP,ebp,RBP,rbp,ESI,esi,RSI,rsi,EDI,edi,RDI,rdi!>>
LOWD_GPR   textequ <!<eax,EAX,ecx,ECX,edx,EDX,ebx,EBX,esp,ESP,ebp,EBP,esi,ESI,edi,EDI!>>
HIGHD_GPR  textequ <!<r8d,R8D,r9d,R9D,r10d,R10D,r11d,R11D,r12d,R12D,r13d,R13D,r14d,R14D,r15d,R15D!>>
LOWW_GPR   textequ <!<ax,AX,cx,CX,dx,DX,bx,BX,sp,SP,bp,BP,si,SI,di,DI!>>
HIGHW_GPR  textequ <!<r8w,R8W,r9w,R9W,r10w,R10W,r11w,R11W,r12w,R12W,r13w,R13W,r14w,R14W,r15w,R15W!>>
LOWB_GPR   textequ <!<al,AL,cl,CL,dl,DL,bl,BL,ah,AH,ch,CH,dh,DH,bh,BH!>>
HIGHB_GPR  textequ <!<r8b,R8B,r9b,R9B,r10b,R10B,r11b,R11B,r12b,R12B,r13b,R13B,r14b,R14B,r15b,R15B,spl,SPL,bpl,BPL,sil,SIL,dil,DIL!>>
ALL_NUM    textequ <!<15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0!>>

YES_REX MACRO x, REX
    REX = 0
    %FOR yrex,HIGH_XMM                  ; if xmm from 8-15 range - REX byte is required
      IFIDN   <yrex>,<x>
        REX = 1
        EXITM
      ENDIF
    ENDM
    IF REX EQ 0
      %FOR yrex,HIGHDQ_GPR              ; if gpr from 8-15 range - REX byte is required
          IF @InStr( , x, yrex ) NE 0
            REX = 1
          EXITM
        ENDIF
      ENDM
    ENDIF
ENDM

CVT_GPR MACRO x                       ; this macro substites any gpr from the high half (8-15)
  xretgpr textequ <x>                   ; with the gpr from the low half wich produces the same
  qgpr = 0                              ; index in the mod/r/m and sib bytes
  %FOR ygpr,HIGHDQ_GPR
    posgpr INSTR <x>,<ygpr>
    IF posgpr GT 0
      fgpr = 0
      %FOR zgpr,LOWDQ_GPR
        IF fgpr EQ qgpr
          f1gpr SUBSTR <x>, 1, posgpr-1
          f2gpr SUBSTR <x>, posgpr + @SizeStr( ygpr )
          xretgpr CATSTR <f1gpr>, < zgpr >, <f2gpr>
          EXITM xretgpr
        ENDIF ; if f == q
        fgpr = fgpr + 1
      ENDM ; for z
    ENDIF ; if posx > 0
    qgpr = qgpr + 1
  ENDM ; for y
  EXITM xretgpr
ENDM

CVT_XMM MACRO x                       ; this macro substites any xmm from the high half (8-15)
  xretxmm textequ <x>                   ; with the xmm from the low half wich produces the same
  lxmm = 0                              ; index in the mod/r/m byte
  %FOR yxmm,HIGH_XMM
    posxmm INSTR <x>,<yxmm>
    IF posxmm GT 0
      fxmm = 0
      %FOR zxmm,LOW_XMM
        IF fxmm EQ lxmm
          xretxmm textequ <zxmm>
         EXITM xretxmm
        ENDIF ; if f == l
        fxmm = fxmm + 1
      ENDM ; for z
    ENDIF ; if posx > 0
    lxmm = lxmm + 1
  ENDM ; for y
  EXITM xretxmm
ENDM

CVT_HIGH MACRO x                      ; a wrapper for macros that substitute up-half registers
  xs  textequ CVT_GPR( x )            ; with their ia32 analogues that have the same index in
  xs1 textequ CVT_GPR( %xs )          ; the mod/r/m byte
  xs2 textequ CVT_XMM( %xs1 )
  EXITM xs2
ENDM

YES_NAME MACRO x                         ; if "x" contains direct reference to memory operand (by
  znam = ( OPATTR( x )) AND 0011110111y ; name defined in code or data section) 1 is returned
  IF znam EQ 0                          ; else 0
    xnam = 1
  ELSE
    xnam = 0
  ENDIF
  EXITM %xnam
ENDM

CVT_MIMM MACRO x, y                   ; if "x" contains direct reference to memory operand (by
  zimm = ( OPATTR( x )) AND 0011110111y ; name defined in code or data section) it is substituted
  IF zimm EQ 0                          ; by "y" operand in order to produce right REX byte, but
    ximm textequ <y>                    ; don't produce relocation record (because current address
  ELSE                                  ; for relocation due to different instruction length is wrong)
    ximm textequ <x>
  ENDIF
  EXITM ximm
ENDM

sha_instruction macro dst:req, src:req, nis:req, opc:req, imm8
  local x0, x1, x2, x3, x4, x5, x6, x7

  bracket INSTR <src>,<[>
  IF bracket GT 0
    memtype INSTR <src>,<oword>
    IF memtype EQ 0
      memtype INSTR <src>,<OWORD>
    ENDIF
    IF memtype EQ 0
      .ERR <src must contain: oword ptr >
      EXITM
    ENDIF
  ENDIF
  bracket INSTR <dst>,<[>
  IF bracket GT 0
    memtype INSTR <dst>,<oword>
    IF memtype EQ 0
      memtype INSTR <dst>,<OWORD>
    ENDIF
    IF memtype EQ 0
      .ERR <dst must contain: oword ptr >
      EXITM
    ENDIF
  ENDIF
  YES_REX <src>,REX                  ; do we need REX byte due to src operand?
  REXS = REX
  IF REXS EQ 1                      ; if yes - we have to prepare substitution in order
    s1rc textequ CVT_HIGH( src )  ; to work correctly with direct memory operands
  ELSE
    s1rc textequ <src>              ; else substitution is not required
  ENDIF
  YES_REX <dst>,REX                  ; do we need REX byte due to dst operand?
  REXD = REX
  IF REXD EQ 1                      ; if yes - we have to prepare substitution in order
    d1st textequ CVT_HIGH( dst )  ; to work correctly with direct memory operands
  ELSE
    d1st textequ <dst>              ; else substitution is not required
  ENDIF
  REX = REXS + REXD
  NAMS = YES_NAME( src )             ; is there the direct memory operand (defined by name in code
  NAMD = YES_NAME( dst )             ; or data section)? if yes - then another algorithm for macro
  isname = NAMS + NAMD              ; substitution due to bug in ml with relocations definition
  s2rc textequ CVT_MIMM( src, xmm0 )
  d2st textequ CVT_MIMM( dst, xmm0 )
  IF isname GT 0                    ; if src or dst contains direct reference to memory operand
    IF REX GT 0
      x0:
        nop
        nop
        movaps d1st,s1rc            ; 90 90 0F 28 /r m32
      x1:
        org x0
        movaps d2st,s2rc            ; REX 0F 28 /r /r m32
        org  x0+2
        db   nis
        db   opc
     IFNB <imm8>
        org  x0+5
        dd   0FFFFFFFFH
        org  x1                     ; REX 0F nis opc /r m32
        db imm8
      ELSE
        org  x1
      ENDIF
    ELSE
      x2:
        nop
        movaps dst, src             ; 90 0F 28 /r m32
      x3:
        org  x2
        db   0FH
        db   nis
        db   opc
      IFNB <imm8>
        org  x2+4
        dd   0FFFFFFFFH
        org  x3                     ; 0F nis opc /r m32
        db   imm8
      ELSE
        org  x3
      ENDIF
    ENDIF
  ELSE                              ; if src or dst doesn't contain direct reference to memory operand
    IF REX GT 0
      x4:
        movaps dst,src              ; REX 0F 28 /r
        org x4+1
        movaps dst,src              ; REX REX 0F 28 /r
      x5:
        org  x4+1
        db   0FH
        db   nis
        db   opc
        org  x5                     ; REX 0F nis opc /r
      IFNB <imm8>
        db   imm8
      ENDIF
    ELSE
      x6:
        nop
        movaps dst, src             ; 90 0F 28 /r
      x7:
        org  x6
        db   0FH
        db   nis
        db   opc
        org  x7                     ; 0F nis opc /r
      IFNB <imm8>
        db   imm8
      ENDIF
    ENDIF
  ENDIF
endm

; 0F 3A CC /r ib
sha1rnds4 MACRO op1:req, op2:req, imm8:req
  sha_instruction op1, op2, 3AH, 0CCH, imm8
endm

; 0F 38 C8 /r
sha1nexte MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0C8H,
endm

; 0F 38 C9 /r 
sha1msg1 MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0C9H,
endm

; 0F 38 CA /r 
sha1msg2 MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0CAH,
endm

; 0F 38 CB /r <xmm0>
sha256rnds2 MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0CBH,
endm

; 0F 38 CC /r 
sha256msg1 MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0CCH,
endm

; 0F 38 CD /r 
sha256msg2 MACRO op1:req, op2:req
  sha_instruction op1, op2, 38H, 0CDH,
endm

;ENDIF ;ML1400

ENDIF ; MNI & SNI macro for Linux or for Windows


IF 0
;; The example of macro usage:
.code

my PROC NEAR PUBLIC
        ;; The GPRs (general purpose registers) to be preserved (if used):
        ;; rbp, rbx, rsi, rdi, r12, r13, r14, r15.
    USES_GPR rbx, rsi, rdi, rbp, rax, r12
        ;; Local frame must be allways set (to zero, if it is not used).
    LOCAL_FRAME = 100
        ;; The XMM registers to be preserved (if used):
        ;; XMM6, XMM7, XMM8, XMM9, XMM10, XMM11, XMM12, XMM13, XMM14, XMM15
    USES_XMM xmm4,xmm7,xmm11
        ;; Number of input parameters.
    COMP_ABI 9
    nop
        ;; Restore all saved XMMs.
    REST_XMM
        ;; Restore all saved GPRs.
    REST_GPR
    ret
my ENDP

END
ENDIF

CACHE_SIZE_TABLE MACRO
TableCacheSize:
;=========================================
; Code: bits [7-4] - code_of_size
; Code: bits [3-0] - shift
; CACHE_SIZE = code_of_size << (shift + 18)
;  |Value| |Code|
;=========================================
db  0ech,   0c3h  ;  24M 24, 64, L3   ; from doc cpuid for Nehalem
db  0ebh,   093h  ;  18M 24, 64, L3   ; from doc cpuid for Nehalem
db  04dh,   016h  ;  16M 16, 64, L3
db  0eah,   034h  ;  12M 24, 64, L3   ; from doc cpuid for Nehalem
db  04ch,   034h  ;  12M 12, 64, L3
db  0e4h,   015h  ;   8M 16, 64, L3   ; from doc cpuid for Nehalem
db  0deh,   015h  ;   8M 12, 64, L3   ; from doc cpuid for Nehalem
db  04bh,   015h  ;   8M 16, 64, L3
db  047h,   015h  ;   8M  8, 64, L3
db  04eh,   033h  ;   6M 24, 64, L3
db  04ah,   033h  ;   6M 12, 64, L3
db  0e3h,   014h  ;   4M 16, 64, L3   ; from doc cpuid for Nehalem
db  0ddh,   014h  ;   4M 12, 64, L3   ; from doc cpuid for Nehalem
db  0d8h,   014h  ;   4M  8, 64, L3   ; from doc cpuid for Nehalem
db  049h,   014h  ;   4M 16, 64, L3
db  029h,   014h  ;   4M  8, 64, L3
db  046h,   014h  ;   4M  4, 64, L3
db  048h,   032h  ;   3M 12, 64, L3
db  0e2h,   013h  ;   2M 16, 64, L3   ; from doc cpuid for Nehalem
db  0dch,   013h  ;   2M 12, 64, L3   ; from doc cpuid for Nehalem
db  0d7h,   013h  ;   2M  8, 64, L3   ; from doc cpuid for Nehalem
db  0d2h,   013h  ;   2M  4, 64, L3   ; from doc cpuid for Nehalem
db  025h,   013h  ;   2M  8, 64, L3
db  07dh,   013h  ;   2M  8, 64, L2
db  085h,   013h  ;   2M  8, 32, L2
db  045h,   013h  ;   2M  4, 32, L2
db  0d6h,   012h  ;   1M  8, 64, L3   ; from doc cpuid for Nehalem
db  0d1h,   012h  ;   1M  4, 64, L3   ; from doc cpuid for Nehalem
db  023h,   012h  ;   1M  8, 64, L3
db  087h,   012h  ;   1M  8, 64, L2
db  07ch,   012h  ;   1M  8, 64, L2
db  078h,   012h  ;   1M  4, 64, L2
db  084h,   012h  ;   1M  8, 32, L2
db  044h,   012h  ;   1M  4, 32, L2
db  0d0h,   011h  ; 512K  4, 64, L3   ; from doc cpuid for Nehalem
db  022h,   011h  ; 512K  4, 64, L3
db  07bh,   011h  ; 512K  8, 64, L2
db  080h,   011h  ; 512K  8, 64, L2
db  086h,   011h  ; 512K  4, 64, L2
db  03eh,   011h  ; 512K  4, 64, L2
db  07fh,   011h  ; 512K  2, 64, L2
db  083h,   011h  ; 512K  8, 32, L2
db  043h,   011h  ; 512K  4, 32, L2
db  0
;=========================================
ENDM

GET_CACHE_SIZE MACRO reg:REQ
;=========================================
        sub     rsp, 64
        mov     [rsp + 16], rax
        mov     [rsp + 24], rbx
        mov     [rsp + 32], rcx
        mov     [rsp + 40], rdx
        mov     [rsp + 48], r8
        mov     [rsp + 56], reg   ; Pointers to the TableCacheSize

        xor     eax, eax
        cpuid

        cmp     ebx, 756E6547h
        jne     CacheSizeMacro11        ; Not Intel
        cmp     edx, 49656E69h
        jne     CacheSizeMacro11        ; Not Intel
        cmp     ecx, 6c65746eh
        jne     CacheSizeMacro11        ; Not Intel

        mov     eax, 2
        cpuid

        cmp     al, 1
        jne     CacheSizeMacro11

        test    eax, 080000000h
        jz      CacheSizeMacro00
        xor     eax, eax
CacheSizeMacro00:
        test    ebx, 080000000h
        jz      CacheSizeMacro01
        xor     ebx, ebx
CacheSizeMacro01:
        test    ecx, 080000000h
        jz      CacheSizeMacro02
        xor     ecx, ecx
CacheSizeMacro02:
        test    edx, 080000000h
        jz      CacheSizeMacro03
        xor     edx, edx

CacheSizeMacro03:
        mov     r8, rsp
        test    eax, eax
        jz      CacheSizeMacro04
        mov     [r8], eax
        add     r8, 4
        mov     eax, 3
CacheSizeMacro04:
        test    ebx, ebx
        jz      CacheSizeMacro05
        mov     [r8], ebx
        add     r8, 4
        add     eax, 4
CacheSizeMacro05:
        test    ecx, ecx
        jz      CacheSizeMacro06
        mov     [r8], ecx
        add     r8, 4
        add     eax, 4
CacheSizeMacro06:
        test    edx, edx
        jz      CacheSizeMacro07
        mov     [r8], edx
        add     eax, 4

CacheSizeMacro07:
        mov     rbx, [rsp + 56]         ; rbx: Pointers to the TableCacheSize

        test    eax, eax
        jz      CacheSizeMacro11
CacheSizeMacro08:
        movzx   edx, BYTE PTR [rbx]
        test    edx, edx
        jz      CacheSizeMacro11
        add     rbx, 2
        mov     ecx, eax
CacheSizeMacro09:
        cmp     dl, BYTE PTR [rsp + rcx]
        je      CacheSizeMacro10
        sub     ecx, 1
        jnz     CacheSizeMacro09
        jmp     CacheSizeMacro08

CacheSizeMacro10:
        movzx   ebx, BYTE PTR [rbx - 1]
        mov     ecx, ebx
        shr     ebx, 4
        and     ecx, 0fh
        add     ecx, 18
        shl     rbx, cl                 ; ebx: CacheSize
        mov     [rsp + 56], rbx
        jmp     CacheSizeMacro12

CacheSizeMacro11:
        mov     QWORD PTR [rsp + 56], -1

CacheSizeMacro12:
        mov     rax, [rsp + 16]
        mov     rbx, [rsp + 24]
        mov     rcx, [rsp + 32]
        mov     rdx, [rsp + 40]
        mov     r8,  [rsp + 48]
        mov     reg, [rsp + 56]
        add     rsp, 64
;=========================================
ENDM

GET_CACHE_SIZE_CORE MACRO reg:REQ
;=========================================
        sub     rsp, 72
        mov     [rsp + 16], rax
        mov     [rsp + 24], rbx
        mov     [rsp + 32], rcx
        mov     [rsp + 40], rdx
        mov     [rsp + 48], r8
        mov     [rsp + 56], reg   ; Pointers to the TableCacheSize

        xor     eax, eax
        cpuid

        cmp     ebx, 756E6547h
        jne     CacheSizeMacro11        ; Not Intel
        cmp     edx, 49656E69h
        jne     CacheSizeMacro11        ; Not Intel
        cmp     ecx, 6c65746eh
        jne     CacheSizeMacro11        ; Not Intel

        cmp     eax, 4
        jl      CoreMacro00

        mov     eax, 4
        xor     ecx, ecx
        cpuid
        shr     eax, 26
        add     eax, 1
        mov     [rsp + 64], rax         ; cores
        jmp     CacheSizeMacro

CoreMacro00:
        mov     QWORD PTR [rsp + 64], 1

CacheSizeMacro:
        mov     eax, 2
        cpuid

        cmp     al, 1
        jne     CacheSizeMacro11

        test    eax, 080000000h
        jz      CacheSizeMacro00
        xor     eax, eax
CacheSizeMacro00:
        test    ebx, 080000000h
        jz      CacheSizeMacro01
        xor     ebx, ebx
CacheSizeMacro01:
        test    ecx, 080000000h
        jz      CacheSizeMacro02
        xor     ecx, ecx
CacheSizeMacro02:
        test    edx, 080000000h
        jz      CacheSizeMacro03
        xor     edx, edx

CacheSizeMacro03:
        mov     r8, rsp
        test    eax, eax
        jz      CacheSizeMacro04
        mov     [r8], eax
        add     r8, 4
        mov     eax, 3
CacheSizeMacro04:
        test    ebx, ebx
        jz      CacheSizeMacro05
        mov     [r8], ebx
        add     r8, 4
        add     eax, 4
CacheSizeMacro05:
        test    ecx, ecx
        jz      CacheSizeMacro06
        mov     [r8], ecx
        add     r8, 4
        add     eax, 4
CacheSizeMacro06:
        test    edx, edx
        jz      CacheSizeMacro07
        mov     [r8], edx
        add     eax, 4

CacheSizeMacro07:
        mov     rbx, [rsp + 56]         ; rbx: Pointers to the TableCacheSize

        test    eax, eax
        jz      CacheSizeMacro11
CacheSizeMacro08:
        movzx   edx, BYTE PTR [rbx]
        test    edx, edx
        jz      CacheSizeMacro11
        add     rbx, 2
        mov     ecx, eax
CacheSizeMacro09:
        cmp     dl, BYTE PTR [rsp + rcx]
        je      CacheSizeMacro10
        sub     ecx, 1
        jnz     CacheSizeMacro09
        jmp     CacheSizeMacro08

CacheSizeMacro10:
        movzx   eax, BYTE PTR [rbx - 1]
        mov     ecx, eax
        shr     eax, 4
        and     ecx, 0fh
        add     ecx, 18
        shl     rax, cl                 ; rax: CacheSize
        mov     rcx, [rsp + 64]         ; rcx: cores
        xor     edx, edx
        div     rcx
        mov     [rsp + 56], rax
        jmp     CacheSizeMacro12

CacheSizeMacro11:
        mov     QWORD PTR [rsp + 56], -1

CacheSizeMacro12:
        mov     rax, [rsp + 16]
        mov     rbx, [rsp + 24]
        mov     rcx, [rsp + 32]
        mov     rdx, [rsp + 40]
        mov     r8,  [rsp + 48]
        mov     reg, [rsp + 56]
        add     rsp, 72
;=========================================
ENDM

.LIST

