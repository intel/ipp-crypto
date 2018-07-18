;===============================================================================
; Copyright 2014-2018 Intel Corporation
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

;  07.06.2012 ml 11.0 support added

; This macro package requires an assembler vesion 7.10 or later.
;.NOLIST
.LISTALL
.686
.XMM

include asmdefs.inc

MM2WORD TEXTEQU <QWORD>        ; used only by the compiler, obsolete

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; beginning of the MACRO section :       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEFINED MACRO symbol:REQ
  IFDEF symbol
    EXITM <-1>
  ELSE
    EXITM <0>
  ENDIF
ENDM


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

if 1
CALLASM macro x:req
 IFDEF _OWN_MERGED_BLD
  IF _IPP EQ _IPP_PX
    @CatStr(<call px_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_W7
    @CatStr(<call w7_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_V8
    @CatStr(<call v8_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_S8
    @CatStr(<call s8_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_P8
    @CatStr(<call p8_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_G9
    @CatStr(<call g9_>, <x>)
  ENDIF
  IF _IPP EQ _IPP_H9 
    @CatStr(<call h9_>, <x>)
  ENDIF
 ELSE
    @CatStr(<call >, <x>)
 ENDIF
endm
endif

if 1
IPPASM macro x:req, y:VARARG
 IFDEF _OWN_MERGED_BLD
  IF _IPP EQ _IPP_PX
    @CatStr(<px_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_W7
    @CatStr(<w7_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_V8
    @CatStr(<v8_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_S8
    @CatStr(<s8_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_P8
    @CatStr(<p8_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_G9
    @CatStr(<g9_>, <x>, < y>)
  ENDIF
  IF _IPP EQ _IPP_H9 
    @CatStr(<h9_>, <x>, < y>)
  ENDIF
 ELSE
    @CatStr(<>, <x>, < y>)
 ENDIF
endm
endif 

IF DEFINED (OSX32) OR DEFINED (_YASM)  OR DEFINED (LINUX32); MNI macro for Linux or for Windows

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

 IFNDEF ML1200
  adcx macro x:req, z:req
    %ECHO @CatStr(<adcx >, < x,>, < z >)
  endm
  adox macro x:req, z:req
    %ECHO @CatStr(<adox >, < x,>, < z >)
  endm
ENDIF; IFNDEF ML1200

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MNI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
IF _IPP GE _IPP_P8
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
vpxor macro x:req, y:req, z:req
    %ECHO @CatStr(<vpxor >, < x,>, < y,>, < z >)
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
 ENDIF ;  IF D_ML900 GT 0
 ENDIF ; IFNDEF ML1100
ELSE ; if not OSX or Linux - so all below is for Windows
  IFNDEF ML1200

  ENDIF ; IFNDEF ML1200
  IFNDEF ML1100
        ; MNI (TNI)

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

        IFMMX_REG MACRO x, f
          f = 0
          FOR y,<mm0,MM0,mm1,MM1,mm2,MM2,mm3,MM3,mm4,MM4,mm5,MM5,mm6,MM6,mm7,MM7>
            IFIDN <y>,<x>
              f = 1
              EXITM
            ENDIF
          ENDM
        ENDM

        mni_instruction macro dst:req, src:req, nis:req, opc:req
          local x, y
            IFMMX_REG <dst>,f
            IF f GT 0
                db  reg_mmx
              x:
                pand dst, src
              y:
                org x
                db  nis
                db  opc
                org y
            ELSE
                db reg_xmm
              x:
                pand dst, src
              y:
                org x
                db  reg_mmx
                db  nis
                db  opc
                org y
            ENDIF
        endm

        ;IF @Version LT 900
        IFNDEF D_ML900

        ;  OPTION NOKEYWORD:<phaddw>
        ; 66 0F 38 01 /r phaddw    xmm1, xmm2/m128
        ;    0F 38 01 /r phaddw    mm1, mm2/m64
        phaddw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phaddw
        endm

        ;  OPTION NOKEYWORD:<phaddd>
        ;    0F 38 02 /r phaddd    mm1, mm2/m64
        ; 66 0F 38 02 /r phaddd    xmm1, xmm2/m128
        phaddd macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phaddd
        endm

        ;  OPTION NOKEYWORD:<phaddsw>
        ;    0F 38 03 /r phaddsw   mm1, mm2/m64
        ; 66 0F 38 03 /r phaddsw   xmm1, xmm2/m128
        phaddsw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phaddsw
        endm

        ;  OPTION NOKEYWORD:<phsubw>
        ;    0F 38 05 /r phsubw    mm1, mm2/m64
        ; 66 0F 38 05 /r phsubw    xmm1, xmm2/m128
        phsubw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phsubw
        endm

        ;  OPTION NOKEYWORD:<phsubd>
        ;    0F 38 06 /r phsubd    mm1, mm2/m64
        ; 66 0F 38 06 /r phsubd    xmm1, xmm2/m128
        phsubd macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phsubd
        endm

        ;  OPTION NOKEYWORD:<phsubsw>
        ;    0F 38 07 /r phsubsw   mm1, mm2/m64
        ; 66 0F 38 07 /r phsubsw   xmm1, xmm2/m128
        phsubsw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_phsubsw
        endm

        ;  OPTION NOKEYWORD:<pmaddubsw>
        ;    0F 38 04 /r pmaddubsw mm1, mm2/m64
        ; 66 0F 38 04 /r pmaddubsw xmm1, xmm2/m128
        pmaddubsw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pmaddubsw
        endm

        ;  OPTION NOKEYWORD:<pmulhrsw>
        ;    0F 38 0B /r pmulhrsw  mm1, mm2/m64
        ; 66 0F 38 0B /r pmulhrsw  xmm1, xmm2/m128
        pmulhrsw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pmulhrsw
        endm

        ;  OPTION NOKEYWORD:<pshufb>
        ;    0F 38 00 /r pshufb    mm1, mm2/m64
        ; 66 0F 38 00 /r pshufb    xmm1, xmm2/m128
        pshufb macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pshufb
        endm

        ;  OPTION NOKEYWORD:<psignb>
        ;    0F 38 08 /r psignb    mm1, mm2/m64
        ; 66 0F 38 08 /r psignb    xmm1, xmm2/m128
        psignb macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_psignb
        endm

        ;  OPTION NOKEYWORD:<psignw>
        ;    0F 38 09 /r psignw    mm1, mm2/m64
        ; 66 0F 38 09 /r psignw    xmm1, xmm2/m128
        psignw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_psignw
        endm

        ;  OPTION NOKEYWORD:<psignd>
        ;    0F 38 0A /r psignd    mm1, mm2/m64
        ; 66 0F 38 0A /r psignd    xmm1, xmm2/m128
        psignd macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_psignd
        endm

        ;  OPTION NOKEYWORD:<palignr>
        ;    0F 3A 0F /r palignr   mm1, mm2/m64
        ; 66 0F 3A 0F /r palignr   xmm1, xmm2/m128
        palignr macro dst:req, src:req, imm8:req
          mni_instruction dst, src, nis_mnia, opc_palignr
          db imm8
        endm

        ;  OPTION NOKEYWORD:<pabsb>
        ;    0F 38 1C /r pabsb     mm1, mm2/m64
        ; 66 0F 38 1C /r pabsb     xmm1, xmm2/m128
        pabsb macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pabsb
        endm

        ;  OPTION NOKEYWORD:<pabsw>
        ;    0F 38 1D /r pabsw     mm1, mm2/m64
        ; 66 0F 38 1D /r pabsw     xmm1, xmm2/m128
        pabsw macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pabsw
        endm

        ;  OPTION NOKEYWORD:<pabsd>
        ;    0F 38 1E /r pabsd     mm1, mm2/m64
        ; 66 0F 38 1E /r pabsd     xmm1, xmm2/m128
        pabsd macro dst:req, src:req
          mni_instruction dst, src, nis_mni, opc_pabsd
        endm

        ENDIF

        ; SNI (Swing new instructions or SSE4)

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

        sni_instruction macro dst:req, src:req, nis:req, opc:req
          local x, y
            db reg_xmm
          x:
            pand dst, src
          y:
            org x
            db  reg_mmx
            db  nis
            db  opc
            org y
        endm

        sni_instr_src_m64 macro dst:req, src:req, nis:req, opc:req
          local x, y
            db reg_xmm
          x:
            movsd dst, src
          y:
            org x
            db  reg_mmx
            db  nis
            db  opc
            org y
        endm

        sni_instr_src_m32 macro dst:req, src:req, nis:req, opc:req
          local x, y
            db reg_xmm
          x:
            movss dst, src
          y:
            org x
            db  reg_mmx
            db  nis
            db  opc
            org y
        endm

          SUBST_DWORD MACRO x
            LOCAL posx, f1, f2, xret
            xret textequ <x>
            FOR y,<byte,Byte,BYTE,word,Word,WORD,qword,Qword,QWORD>
              posx INSTR <x>,<y>
              IF posx GT 0
                  f1 SUBSTR <x>, 1, posx-1
                  f2 SUBSTR <x>, posx + @SizeStr( y )
                  xret CATSTR <f1>, < dword >, <f2>
                  EXITM xret
              ENDIF
            ENDM
            EXITM <xret>
          ENDM

        sni_instr_src_m16 macro dst:req, src:req, nis:req, opc:req
          local x, y, tmpsrc
            tmpsrc textequ SUBST_DWORD( src )
            db reg_xmm
          x:
            movss dst, tmpsrc
          y:
            org x
            db  reg_mmx
            db  nis
            db  opc
            org y
        endm

        ;IF @Version lt 900
        IFNDEF D_ML900

        ;  OPTION NOKEYWORD:<blendpd>
        ; 66 0F 3A 0D  blendpd     xmm1, xmm2/m128, imm8
        blendpd macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_snia, opc_blendpd
          db imm8
        endm

        ;  OPTION NOKEYWORD:<blendps>
        ; 66 0F 3A 0C  blendps     xmm1, xmm2/m128, imm8
        blendps macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_snia, opc_blendps
          db imm8
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
          %sni_instruction dst, src, nis_snia, opc_dppd
          db imm8
        endm

        ;  OPTION NOKEYWORD:<dpps>
        ; 66 0F 3A 40  dpps     xmm1, xmm2/m128, imm8
        dpps macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_snia, opc_dpps
          db imm8
        endm

        ;  OPTION NOKEYWORD:<extractps>
        ; 66 0F 3A 17  extractps     r/m32, xmm2, imm8
        extractps macro dst:req, src:req, imm8:req
        ;  %sni_instruction dst, src, nis_snia, opc_extractps
          local x, y
            db reg_xmm
          x:
            movd dst, src
          y:
            org x
            db  reg_mmx
            db  nis_snia
            db  opc_extractps
            org y
          db imm8
        endm

        ;  OPTION NOKEYWORD:<insertps>
        ; 66 0F 3A 21  insertps    xmm1, xmm2/m32, imm8
        insertps macro dst:req, src:req, imm8:req
          %sni_instr_src_m32 dst, src, nis_snia, opc_insertps
          db imm8
        endm

        ;  OPTION NOKEYWORD:<movntdqa>
        ; 66 0F 38 2A  movntdqa     xmm1, m128
        movntdqa macro dst:req, src:req
          %sni_instruction dst, src, nis_sni, opc_movntdqa
        endm

        ;  OPTION NOKEYWORD:<mpsadbw>
        ; 66 0F 3A 42  mpsadbw    xmm1, xmm2/m32, imm8
        mpsadbw macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_snia, opc_mpsadbw
          db imm8
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
          %sni_instruction dst, src, nis_snia, opc_pblendw
          db imm8
        endm

        ;  OPTION NOKEYWORD:<pcmpeqq>
        ; 66 0F 38 29  pcmpeqq     xmm1, xmm2/m128
        pcmpeqq macro dst:req, src:req
          %sni_instruction dst, src, nis_sni, opc_pcmpeqq
        endm

        ALL_MMX     textequ <!<mm0,MM0,mm1,MM1,mm2,MM2,mm3,MM3,mm4,MM4,mm5,MM5,mm6,MM6,mm7,MM7!>>
        ALL_GPR     textequ <!<eax,EAX,ecx,ECX,edx,EDX,ebx,EBX,esp,ESP,ebp,EBP,esi,ESI,edi,EDI!>>

        REPLACE_MMX MACRO x             ; this macro substites any mmx register (in order to use mov r32,r32 instr)
          xretgpr textequ <x>           ; with the gpr equivalent (with the same index in mod/r/m byte) for pextrX instr
          qgpr = 0
          %FOR ygpr,ALL_MMX
            posgpr INSTR <x>,<ygpr>
            IF posgpr GT 0
              fgpr = 0
              %FOR zgpr,ALL_GPR
                IF fgpr EQ qgpr
                  xretgpr textequ <zgpr>
                 EXITM xretgpr
                ENDIF ; if f == q
                fgpr = fgpr + 1
              ENDM ; for z
            ENDIF ; if posx > 0
            qgpr = qgpr + 1
          ENDM ; for y
          EXITM xretgpr
        ENDM

        ;  OPTION NOKEYWORD:<pextrb>
        ; 66 0F 3A 14  pextrb     r32/m8, xmm2, imm8
        pextrb macro dst:req, src:req, imm8:req
          local x, y, dstop
            dstop textequ SUBST_DWORD( dst )
           db reg_xmm
          x:
            movd dstop, src
          y:
            org x
            db  reg_mmx
            db  nis_snia
            db  opc_pextrb
            org y
          db imm8
        endm

        ;  OPTION NOKEYWORD:<pextrd>
        ; 66 0F 3A 16  pextrd     r32/m32, xmm2, imm8
        pextrd macro dst:req, src:req, imm8:req
          local x, y, dstop
           db reg_xmm
          x:
            movd dst, src
          y:
            org x
            db  reg_mmx
            db  nis_snia
            db  opc_pextrd
            org y
          db imm8
        endm

        ENDIF

        ;IF @Version lt 900
        IFNDEF D_ML900
          IF _IPP GE _IPP_P8
              OPTION NOKEYWORD:<pextrw>

            ; 66 0F 3A 15  pextrw     r32/m16, xmm2, imm8
            pextrw macro dst:req, src:req, imm8:req
              local x, y, x1, y1
               IFMMX_REG src, f                     ; NO MEMORY as DESTINATION!
               IF f GT 0
                  s2rc textequ REPLACE_MMX( src )   ; substite source mmx register with gpr that has the same index in mod/r/m byte
                x:
                  nop
                  mov dst, s2rc                     ; 90 8B /r
                y:
                  org x
                  db  0Fh
                  db  0C5h                          ; 0F C5 /r
                  org y
                  db imm8                           ; 0F C5 /r imm8
               ELSE
                  db reg_xmm
                x1:
                  pinsrw src, dst, imm8             ; 66 66 0F C4 /r ib
                y1:
                  org x1
                  db  0Fh
                  db  3Ah
                  db  15h
                  org y1                            ; 66 0F 3A 15 /r ib
               ENDIF
            endm
          ENDIF ; if _IPP GE _IPP_P8
        ENDIF ; ifndef D_ML900

        ;IF @Version lt 900
        IFNDEF D_ML900

        ;  OPTION NOKEYWORD:<phminposuw>
        ; 66 0F 38 41  phminposuw     xmm1, xmm2/m128
        phminposuw macro dst:req, src:req
          %sni_instruction dst, src, nis_sni, opc_phminposuw
        endm

          IFMEM_INS MACRO x
            LOCAL posx, f1, f2, xret
            xret textequ <x>
            FOR y,<byte,Byte,BYTE,dword,Dword,DWORD,qword,Qword,QWORD>
              posx INSTR <x>,<y>
              IF posx GT 0
                  f1 SUBSTR <x>, 1, posx-1
                  f2 SUBSTR <x>, posx + @SizeStr( y )
                  xret CATSTR <f1>, < word >, <f2>
                  EXITM xret
              ENDIF
            ENDM
            EXITM <xret>
          ENDM

        ;  OPTION NOKEYWORD:<pinsrb>
        ; 66 0F 3A 20  pinsrb     xmm1, r32/m8, imm8
        pinsrb macro dst:req, src:req, imm8:req
          local x, y, srcop
            srcop textequ IFMEM_INS( src )
           db reg_xmm
          x:
            pinsrw dst, srcop, imm8
          y:
            org x
            db  reg_mmx
            db  nis_snia
            db  opc_pinsrb
            org y
        endm

        ;  OPTION NOKEYWORD:<pinsrd>
        ; 66 0F 3A 22  pinsrd     xmm1, r32/m32, imm8
        pinsrd macro dst:req, src:req, imm8:req
          local x, y, srcop
            srcop textequ IFMEM_INS( src )
           db reg_xmm
          x:
            pinsrw dst, srcop, imm8
          y:
            org x
            db  reg_mmx
            db  nis_snia
            db  opc_pinsrd
            org y
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
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovsxbw
        endm

        ;  OPTION NOKEYWORD:<pmovsxbd>
        ; 66 0F 38 21  pmovsxbd     xmm1, xmm2/m32
        pmovsxbd macro dst:req, src:req
          %sni_instr_src_m32 dst, src, nis_sni, opc_pmovsxbd
        endm

        ;  OPTION NOKEYWORD:<pmovsxbq>
        ; 66 0F 38 22  pmovsxbq     xmm1, xmm2/m16
        pmovsxbq macro dst:req, src:req
          %sni_instr_src_m16 dst, src, nis_sni, opc_pmovsxbq
        endm

        ;  OPTION NOKEYWORD:<pmovsxwd>
        ; 66 0F 38 23  pmovsxwd     xmm1, xmm2/m64
        pmovsxwd macro dst:req, src:req
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovsxwd
        endm

        ;  OPTION NOKEYWORD:<pmovsxwq>
        ; 66 0F 38 24  pmovsxwq     xmm1, xmm2/m32
        pmovsxwq macro dst:req, src:req
          %sni_instr_src_m32 dst, src, nis_sni, opc_pmovsxwq
        endm

        ;  OPTION NOKEYWORD:<pmovsxdq>
        ; 66 0F 38 25  pmovsxdq     xmm1, xmm2/m64
        pmovsxdq macro dst:req, src:req
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovsxdq
        endm

        ;  OPTION NOKEYWORD:<pmovzxbw>
        ; 66 0F 38 30  pmovzxbw     xmm1, xmm2/m64
        pmovzxbw macro dst:req, src:req
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovzxbw
        endm

        ;  OPTION NOKEYWORD:<pmovzxbd>
        ; 66 0F 38 31  pmovzxbd     xmm1, xmm2/m32
        pmovzxbd macro dst:req, src:req
          %sni_instr_src_m32 dst, src, nis_sni, opc_pmovzxbd
        endm

        ;  OPTION NOKEYWORD:<pmovzxbq>
        ; 66 0F 38 32  pmovzxbq     xmm1, xmm2/m16
        pmovzxbq macro dst:req, src:req
          %sni_instr_src_m16 dst, src, nis_sni, opc_pmovzxbq
        endm

        ;  OPTION NOKEYWORD:<pmovzxwd>
        ; 66 0F 38 33  pmovzxwd     xmm1, xmm2/m64
        pmovzxwd macro dst:req, src:req
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovzxwd
        endm

        ;  OPTION NOKEYWORD:<pmovzxwq>
        ; 66 0F 38 34  pmovzxwq     xmm1, xmm2/m32
        pmovzxwq macro dst:req, src:req
          %sni_instr_src_m32 dst, src, nis_sni, opc_pmovzxwq
        endm

        ;  OPTION NOKEYWORD:<pmovzxdq>
        ; 66 0F 38 35  pmovzxdq     xmm1, xmm2/m64
        pmovzxdq macro dst:req, src:req
          %sni_instr_src_m64 dst, src, nis_sni, opc_pmovzxdq
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
          %sni_instruction dst, src, nis_snia, opc_roundpd
          db imm8
        endm

        ;  OPTION NOKEYWORD:<roundps>
        ; 66 0F 3A 08  roundps     xmm1, xmm2/m128, imm8
        roundps macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_snia, opc_roundps
          db imm8
        endm

        ;  OPTION NOKEYWORD:<roundsd>
        ; 66 0F 3A 0B  roundsd     xmm1, xmm2/m64, imm8
        roundsd macro dst:req, src:req, imm8:req
          %sni_instr_src_m64 dst, src, nis_snia, opc_roundsd
          db imm8
        endm

        ;  OPTION NOKEYWORD:<roundss>
        ; 66 0F 3A 0A  roundss     xmm1, xmm2/m32, imm8
        roundss macro dst:req, src:req, imm8:req
          %sni_instr_src_m32 dst, src, nis_snia, opc_roundss
          db imm8
        endm

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
          %sni_instruction dst, src, nis_sttnia, opc_pcmpestri
          db  imm8
        endm

        ; 66 0F 3A 60  pcmpestrm     xmm1, xmm2/m128, imm8
        pcmpestrm macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_sttnia, opc_pcmpestrm
          db imm8
        endm

        ; 66 0F 3A 63  pcmpistri     xmm1, xmm2/m128, imm8
        pcmpistri macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_sttnia, opc_pcmpistri
          db imm8
        endm

        ; 66 0F 3A 62  pcmpistrm     xmm1, xmm2/m128, imm8
        pcmpistrm macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_sttnia, opc_pcmpistrm
          db imm8
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
          %sni_instruction dst, src, nis_sttnia, opc_aeskeygenassist
          db imm8
        endm

        ; 66 0F 3A 44  pclmulqdq     xmm1, xmm2/m128, imm8
        pclmulqdq macro dst:req, src:req, imm8:req
          %sni_instruction dst, src, nis_sttnia, opc_pclmulqdq
          db imm8
        endm

  ENDIF ;   IFNDEF ML1100

  IFNDEF ML1200

  ENDIF ; IFNDEF ML1200


IF @InStr(1,%CurVer,<710>) EQ 1

; PNI for old ml versions

opc_Addsubpd        = 0D0H
opc_Addsubps        = 0D0H
opc_Haddpd          = 07CH
opc_Haddps          = 07CH
opc_Hsubpd          = 07DH
opc_Hsubps          = 07DH
opc_Lddqu           = 0F0H
opc_Monitor         = 0C8H
opc_Movddup         = 012H
opc_Movshdup        = 016H
opc_Movsldup        = 012H
opc_Mwait           = 0C9H


MMWORD  TEXTEQU <QWORD>        ; used only by the compiler, obsolete
XMMWORD TEXTEQU <OWORD>        ; 128 bit memory operands for xmm regs inst

; 66 0F C2 /r 0  cmpeqpd xmm1, xmm2
cmpeqpd  macro   dst:req, src:req
    cmppd dst, src, 0
endm

; 66 0F C2 /r 1  cmpltpd xmm1, xmm2
cmpltpd  macro   dst:req, src:req
    cmppd dst, src, 1
endm

; 66 0F C2 /r 2  cmplepd xmm1, xmm2
cmplepd  macro   dst:req, src:req
    cmppd dst, src, 2
endm

; 66 0F C2 /r 3  cmpunordpd xmm1, xmm2
cmpunordpd  macro   dst:req, src:req
    cmppd dst, src, 3
endm

; 66 0F C2 /r 4  cmpneqpd xmm1, xmm2
cmpneqpd  macro   dst:req, src:req
    cmppd dst, src, 4
endm

; 66 0F C2 /r 5  cmpltpd xmm1, xmm2
cmpnltpd  macro   dst:req, src:req
    cmppd dst, src, 5
endm

; 66 0F C2 /r 6  cmpnlepd xmm1, xmm2
cmpnlepd  macro   dst:req, src:req
    cmppd dst, src, 6
endm

; 66 0F C2 /r 7  cmpordpd xmm1, xmm2
cmpordpd  macro   dst:req, src:req
    cmppd dst, src, 7
endm

;F2 0F C2 /r 0  cmpeqsd xmm1, xmm2
cmpeqsd  macro   dst:req, src:req
        cmpsd1  dst, src, 0
endm

;F2 0F C2 /r 1  cmpltsd xmm1, xmm2
cmpltsd  macro   dst:req, src:req
        cmpsd1  dst, src, 1
endm

;F2 0F C2 /r 2  cmplesd xmm1, xmm2
cmplesd  macro   dst:req, src:req
        cmpsd1  dst, src, 2
endm

;F2 0F C2 /r 3  cmpunordsd xmm1, xmm2
cmpunordsd  macro   dst:req, src:req
        cmpsd1  dst, src, 3
endm

;F2 0F C2 /r 4  cmpneqsd xmm1, xmm2
cmpneqsd  macro   dst:req, src:req
        cmpsd1  dst, src, 4
endm

;F2 0F C2 /r 5  cmpnltsd xmm1, xmm2
cmpnltsd  macro   dst:req, src:req
        cmpsd1  dst, src, 5
endm

;F2 0F C2 /r 6  cmpnlesd xmm1, xmm2
cmpnlesd  macro   dst:req, src:req
        cmpsd1  dst, src, 6
endm

;F2 0F C2 /r 7  cmpordsd xmm1, xmm2
cmpordsd  macro   dst:req, src:req
        cmpsd1  dst, src, 7
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PNI ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;66 0F D0 /r  addsubpd xmm1, xmm2/m128
  addsubpd macro dst:req, src:req
        local x, y
    x:
        addpd dst, src
    y:
        org x+2
        db opc_Addsubpd
        org y
  endm

  ;;F2 0F D0 /r  addsubps xmm1, xmm2/m128
  addsubps macro dst:req, src:req
        local x, y
        db 0F2h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Addsubps
        org y
  endm

  ;;66 0F 7C /r  haddpd xmm1, xmm2/m128
  haddpd macro dst:req, src:req
        local x, y
    x:
        addpd dst, src
    y:
        org x+2
        db opc_Haddpd
        org y
  endm

  ;;F2 0F 7C /r  haddps xmm1, xmm2/m128
  haddps macro dst:req, src:req
        local x, y
        db 0F2h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Haddps
        org y
  endm

  ;;66 0F 7D /r  hsubpd xmm1, xmm2/m128
  hsubpd macro dst:req, src:req
        local x, y
    x:
        addpd dst, src
    y:
        org x+2
        db opc_Hsubpd
        org y
  endm

  ;;F2 0F 7D /r  hsubps xmm1, xmm2/m128
  hsubps macro dst:req, src:req
        local x, y
        db 0F2h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Hsubps
        org y
  endm

  ;;F2 0F F0 /r  lddqu xmm1, m128
  lddqu macro dst:req, src:req
        local x, y
        db 0F2h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Lddqu
        org y
  endm

  ;;F2 0F 12 /r  movddup xmm1, xmm2/m128
  movddup macro dst:req, src:req
        local x, y
        db 0F2h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Movddup
        org y
  endm

  ;;F3 0F 16 /r  movshdup xmm1, xmm2/m128
  movshdup macro dst:req, src:req
        local x, y
        db 0F3h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Movshdup
        org y
  endm

  ;;F3 0F 12 /r  movsldup xmm1, xmm2/m128
  movsldup macro dst:req, src:req
        local x, y
        db 0F3h
    x:
        addps dst, src
    y:
        org x+1
        db opc_Movsldup
        org y
  endm

  ;;0F 01 C8       monitor
  monitor         macro
        db 0Fh, 01h, 0C8h
  endm

  ;;0F 01 C9       mwait
  mwait           macro
        db 0Fh, 01h, 0C9h
  endm
ENDIF
 ENDIF ; IFNDEF ML1100

IFDEF ML1200
  OPTION NOKEYWORD:<adox>
  OPTION NOKEYWORD:<adcx>
ENDIF
 
 ;;66 0F 38 F6 /r    adcx
 adcx macro op1:req, op2:req
  local x1, x2
    db 66h
    db 0Fh
  x1:
    bsf op1, op2
  x2:
    org x1
    db 38H
    db 0F6H
    org x2
 endm

 ;;66 0F 38 F6 /r    adcx
 adox macro op1:req, op2:req
  local x1, x2
    db F3h
    db 0Fh
  x1:
    bsf op1, op2
  x2:
    org x1
    db 38H
    db 0F6H
    org x2
 endm

;ENDIF ; IFNDEF ML1200

IFDEF ML1400
  OPTION NOKEYWORD:<sha1rnds4>
  OPTION NOKEYWORD:<sha1nexte>
  OPTION NOKEYWORD:<sha1msg1>
  OPTION NOKEYWORD:<sha1msg2>
  OPTION NOKEYWORD:<sha256rnds2>
  OPTION NOKEYWORD:<sha256msg1>
  OPTION NOKEYWORD:<sha256msg2>
ENDIF
;IFNDEF ML1400

sha_instruction macro dst:req, src:req, nis:req, opc:req, imm8
  local x0, x1
      db 0FH
  x0:
      movaps dst, src             ; 0F 0F 28 /r m32
  x1:
      org x0
      db nis
      db opc
      org x1
      IFNB <imm8>
        db   imm8
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

;ENDIF ; IFNDEF ML1400

ENDIF ; macro for Windows

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
        sub     esp, 40
        mov     [esp + 16], eax
        mov     [esp + 20], ebx
        mov     [esp + 24], ecx
        mov     [esp + 28], edx
        mov     [esp + 32], ebp
        mov     [esp + 36], reg   ; Pointers to the TableCacheSize

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
        mov     ebp, esp
        test    eax, eax
        jz      CacheSizeMacro04
        mov     [ebp], eax
        add     ebp, 4
        mov     eax, 3
CacheSizeMacro04:
        test    ebx, ebx
        jz      CacheSizeMacro05
        mov     [ebp], ebx
        add     ebp, 4
        add     eax, 4
CacheSizeMacro05:
        test    ecx, ecx
        jz      CacheSizeMacro06
        mov     [ebp], ecx
        add     ebp, 4
        add     eax, 4
CacheSizeMacro06:
        test    edx, edx
        jz      CacheSizeMacro07
        mov     [ebp], edx
        add     eax, 4

CacheSizeMacro07:
        mov     ebx, [esp + 36]         ; ebx: Pointers to the TableCacheSize

        test    eax, eax
        jz      CacheSizeMacro11
CacheSizeMacro08:
        movzx   edx, BYTE PTR [ebx]
        test    edx, edx
        jz      CacheSizeMacro11
        add     ebx, 2
        mov     ecx, eax
CacheSizeMacro09:
        cmp     dl, BYTE PTR [esp + ecx]
        je      CacheSizeMacro10
        sub     ecx, 1
        jnz     CacheSizeMacro09
        jmp     CacheSizeMacro08

CacheSizeMacro10:
        movzx   ebx, BYTE PTR [ebx - 1]
        mov     ecx, ebx
        shr     ebx, 4
        and     ecx, 0fh
        add     ecx, 18
        shl     ebx, cl                 ; ebx: CacheSize
        mov     [esp + 36], ebx
        jmp     CacheSizeMacro12

CacheSizeMacro11:
        mov     DWORD PTR [esp + 36], -1

CacheSizeMacro12:
        mov     eax, [esp + 16]
        mov     ebx, [esp + 20]
        mov     ecx, [esp + 24]
        mov     edx, [esp + 28]
        mov     ebp, [esp + 32]
        mov     reg, [esp + 36]
        add     esp, 40
;=========================================
ENDM

GET_CACHE_SIZE_CORE MACRO reg:REQ
;=========================================
        sub     esp, 44
        mov     [esp + 16], eax
        mov     [esp + 20], ebx
        mov     [esp + 24], ecx
        mov     [esp + 28], edx
        mov     [esp + 32], ebp
        mov     [esp + 36], reg   ; Pointers to the TableCacheSize

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
        mov     [esp + 40], eax         ; cores
        jmp     CacheSizeMacro

CoreMacro00:
        mov     DWORD PTR [esp + 40], 1

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
        mov     ebp, esp
        test    eax, eax
        jz      CacheSizeMacro04
        mov     [ebp], eax
        add     ebp, 4
        mov     eax, 3
CacheSizeMacro04:
        test    ebx, ebx
        jz      CacheSizeMacro05
        mov     [ebp], ebx
        add     ebp, 4
        add     eax, 4
CacheSizeMacro05:
        test    ecx, ecx
        jz      CacheSizeMacro06
        mov     [ebp], ecx
        add     ebp, 4
        add     eax, 4
CacheSizeMacro06:
        test    edx, edx
        jz      CacheSizeMacro07
        mov     [ebp], edx
        add     eax, 4

CacheSizeMacro07:
        mov     ebx, [esp + 36]         ; ebx: Pointers to the TableCacheSize

        test    eax, eax
        jz      CacheSizeMacro11
CacheSizeMacro08:
        movzx   edx, BYTE PTR [ebx]
        test    edx, edx
        jz      CacheSizeMacro11
        add     ebx, 2
        mov     ecx, eax
CacheSizeMacro09:
        cmp     dl, BYTE PTR [esp + ecx]
        je      CacheSizeMacro10
        sub     ecx, 1
        jnz     CacheSizeMacro09
        jmp     CacheSizeMacro08

CacheSizeMacro10:
        movzx   eax, BYTE PTR [ebx - 1]
        mov     ecx, eax
        shr     eax, 4
        and     ecx, 0fh
        add     ecx, 18
        shl     eax, cl                 ; eax: CacheSize
        mov     ecx, [esp + 40]         ; ecx: cores
        xor     edx, edx
        div     ecx
        mov     [esp + 36], eax
        jmp     CacheSizeMacro12

CacheSizeMacro11:
        mov     DWORD PTR [esp + 36], -1

CacheSizeMacro12:
        mov     eax, [esp + 16]
        mov     ebx, [esp + 20]
        mov     ecx, [esp + 24]
        mov     edx, [esp + 28]
        mov     ebp, [esp + 32]
        mov     reg, [esp + 36]
        add     esp, 44
;=========================================
ENDM

.LIST
