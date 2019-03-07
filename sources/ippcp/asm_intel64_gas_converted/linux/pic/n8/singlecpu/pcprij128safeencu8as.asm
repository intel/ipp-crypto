###############################################################################
# Copyright 2019 Intel Corporation
# All Rights Reserved.
#
# If this  software was obtained  under the  Intel Simplified  Software License,
# the following terms apply:
#
# The source code,  information  and material  ("Material") contained  herein is
# owned by Intel Corporation or its  suppliers or licensors,  and  title to such
# Material remains with Intel  Corporation or its  suppliers or  licensors.  The
# Material  contains  proprietary  information  of  Intel or  its suppliers  and
# licensors.  The Material is protected by  worldwide copyright  laws and treaty
# provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
# modified, published,  uploaded, posted, transmitted,  distributed or disclosed
# in any way without Intel's prior express written permission.  No license under
# any patent,  copyright or other  intellectual property rights  in the Material
# is granted to  or  conferred  upon  you,  either   expressly,  by implication,
# inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
# property rights must be express and approved by Intel in writing.
#
# Unless otherwise agreed by Intel in writing,  you may not remove or alter this
# notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
# suppliers or licensors in any way.
#
#
# If this  software  was obtained  under the  Apache License,  Version  2.0 (the
# "License"), the following terms apply:
#
# You may  not use this  file except  in compliance  with  the License.  You may
# obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
#
# Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
# distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the   License  for the   specific  language   governing   permissions  and
# limitations under the License.
###############################################################################

 
 .section .note.GNU-stack,"",%progbits 
 
.text
.p2align 4, 0x90
ENCODE_DATA: 
 
TransFwdLO:
.byte    0x0 
 

.byte    0x1 
 

.byte   0x2E 
 

.byte   0x2F 
 

.byte   0x49 
 

.byte   0x48 
 

.byte   0x67 
 

.byte   0x66 
 

.byte   0x43 
 

.byte   0x42 
 

.byte   0x6D 
 

.byte   0x6C 
 

.byte    0xA 
 

.byte    0xB 
 

.byte   0x24 
 

.byte   0x25 
 
TransFwdHI:
.byte    0x0 
 

.byte   0x35 
 

.byte   0xD0 
 

.byte   0xE5 
 

.byte   0x3D 
 

.byte    0x8 
 

.byte   0xED 
 

.byte   0xD8 
 

.byte   0xE9 
 

.byte   0xDC 
 

.byte   0x39 
 

.byte    0xC 
 

.byte   0xD4 
 

.byte   0xE1 
 

.byte    0x4 
 

.byte   0x31 
 
TransInvLO:
.byte    0x0 
 

.byte    0x1 
 

.byte   0x5C 
 

.byte   0x5D 
 

.byte   0xE0 
 

.byte   0xE1 
 

.byte   0xBC 
 

.byte   0xBD 
 

.byte   0x50 
 

.byte   0x51 
 

.byte    0xC 
 

.byte    0xD 
 

.byte   0xB0 
 

.byte   0xB1 
 

.byte   0xEC 
 

.byte   0xED 
 
TransInvHI:
.byte    0x0 
 

.byte   0x1F 
 

.byte   0xEE 
 

.byte   0xF1 
 

.byte   0x55 
 

.byte   0x4A 
 

.byte   0xBB 
 

.byte   0xA4 
 

.byte   0x6A 
 

.byte   0x75 
 

.byte   0x84 
 

.byte   0x9B 
 

.byte   0x3F 
 

.byte   0x20 
 

.byte   0xD1 
 

.byte   0xCE 
 
GF16_csize:
.byte    0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF, 0xF 
 
GF16_logTbl:
.byte   0xC0, 0x0, 0x1, 0x4, 0x2, 0x8, 0x5, 0xA, 0x3, 0xE, 0x9, 0x7, 0x6, 0xD, 0xB, 0xC 
 
GF16_expTbl:
.byte    0x1, 0x2, 0x4, 0x8, 0x3, 0x6, 0xC, 0xB, 0x5, 0xA, 0x7, 0xE, 0xF, 0xD, 0x9, 0x1 
 
GF16_sqr1:
.byte    0x0, 0x9, 0x2, 0xB, 0x8, 0x1, 0xA, 0x3, 0x6, 0xF, 0x4, 0xD, 0xE, 0x7, 0xC, 0x5 
 
GF16_invLog:
.byte   0xC0, 0x0, 0xE, 0xB, 0xD, 0x7, 0xA, 0x5, 0xC, 0x1, 0x6, 0x8, 0x9, 0x2, 0x4, 0x3 
 
GF16_expTbl_shift:
.byte   0x10, 0x20, 0x40, 0x80, 0x30, 0x60, 0xC0, 0xB0, 0x50, 0xA0, 0x70, 0xE0, 0xF0, 0xD0, 0x90, 0x10 
 
FwdAffineLO:
.byte    0x0 
 

.byte   0x10 
 

.byte   0x22 
 

.byte   0x32 
 

.byte   0x55 
 

.byte   0x45 
 

.byte   0x77 
 

.byte   0x67 
 

.byte   0x82 
 

.byte   0x92 
 

.byte   0xA0 
 

.byte   0xB0 
 

.byte   0xD7 
 

.byte   0xC7 
 

.byte   0xF5 
 

.byte   0xE5 
 
FwdAffineHI:
.byte    0x0 
 

.byte   0x41 
 

.byte   0x34 
 

.byte   0x75 
 

.byte   0x40 
 

.byte    0x1 
 

.byte   0x74 
 

.byte   0x35 
 

.byte   0x2A 
 

.byte   0x6B 
 

.byte   0x1E 
 

.byte   0x5F 
 

.byte   0x6A 
 

.byte   0x2B 
 

.byte   0x5E 
 

.byte   0x1F 
 
FwdAffineCnt:
.quad   0xC2C2C2C2C2C2C2C2, 0xC2C2C2C2C2C2C2C2 
 
FwdShiftRows:
.byte  0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11 
 
GF16mul_E_2x:
.byte    0x0, 0x2E, 0x4F, 0x61, 0x8D, 0xA3, 0xC2, 0xEC, 0x39, 0x17, 0x76, 0x58, 0xB4, 0x9A, 0xFB, 0xD5 
 
GF16mul_1_Cx:
.byte    0x0, 0xC1, 0xB2, 0x73, 0x54, 0x95, 0xE6, 0x27, 0xA8, 0x69, 0x1A, 0xDB, 0xFC, 0x3D, 0x4E, 0x8F 
 
ColumnROR:
.byte  1,2,3,0,5,6,7,4,9,10,11,8,13,14,15,12 
.p2align 4, 0x90
 
.globl TransformNative2Composite
.type TransformNative2Composite, @function
 
TransformNative2Composite:
 
    movdqu       (%rsi), %xmm0
    movdqa       GF16_csize(%rip), %xmm7
    movdqa       TransFwdLO(%rip), %xmm1
    movdqa       TransFwdHI(%rip), %xmm2
    movdqa       %xmm0, %xmm3
    psrlw        $(4), %xmm0
    pand         %xmm7, %xmm3
    pand         %xmm7, %xmm0
    pshufb       %xmm3, %xmm1
    pshufb       %xmm0, %xmm2
    pxor         %xmm2, %xmm1
    movdqu       %xmm1, (%rdi)
 
    ret
.Lfe1:
.size TransformNative2Composite, .Lfe1-(TransformNative2Composite)
.p2align 4, 0x90
 
.globl SafeEncrypt_RIJ128
.type SafeEncrypt_RIJ128, @function
 
SafeEncrypt_RIJ128:
 
    movdqu       (%rdi), %xmm1
    movdqa       GF16_csize(%rip), %xmm7
    movdqa       TransFwdLO(%rip), %xmm0
    movdqa       TransFwdHI(%rip), %xmm2
    movdqa       %xmm1, %xmm3
    psrlw        $(4), %xmm1
    pand         %xmm7, %xmm3
    pand         %xmm7, %xmm1
    pshufb       %xmm3, %xmm0
    pshufb       %xmm1, %xmm2
    pxor         %xmm2, %xmm0
    pxor         (%rcx), %xmm0
    add          $(16), %rcx
    sub          $(1), %rdx
.Lencode_roundgas_2: 
    movdqa       %xmm0, %xmm1
    pand         %xmm7, %xmm0
    psrlw        $(4), %xmm1
    pand         %xmm7, %xmm1
    movdqa       GF16_logTbl(%rip), %xmm5
    pshufb       %xmm0, %xmm5
    pxor         %xmm1, %xmm0
    movdqa       GF16_logTbl(%rip), %xmm2
    pshufb       %xmm0, %xmm2
    movdqa       GF16_sqr1(%rip), %xmm4
    pshufb       %xmm1, %xmm4
    movdqa       GF16_logTbl(%rip), %xmm3
    pshufb       %xmm1, %xmm3
    paddb        %xmm2, %xmm5
    movdqa       %xmm5, %xmm0
    pcmpgtb      %xmm7, %xmm5
    psubb        %xmm5, %xmm0
    movdqa       GF16_expTbl(%rip), %xmm5
    pshufb       %xmm0, %xmm5
    pxor         %xmm5, %xmm4
    movdqa       GF16_invLog(%rip), %xmm5
    pshufb       %xmm4, %xmm5
    paddb        %xmm5, %xmm2
    paddb        %xmm5, %xmm3
    movdqa       %xmm2, %xmm5
    pcmpgtb      %xmm7, %xmm2
    psubb        %xmm2, %xmm5
    movdqa       GF16_expTbl(%rip), %xmm0
    pshufb       %xmm5, %xmm0
    movdqa       %xmm3, %xmm5
    pcmpgtb      %xmm7, %xmm3
    psubb        %xmm3, %xmm5
    movdqa       GF16_expTbl(%rip), %xmm1
    pshufb       %xmm5, %xmm1
    movdqa       FwdAffineLO(%rip), %xmm3
    movdqa       FwdAffineHI(%rip), %xmm2
    movdqa       FwdAffineCnt(%rip), %xmm4
    pshufb       %xmm0, %xmm3
    pshufb       %xmm1, %xmm2
    pxor         %xmm4, %xmm3
    pxor         %xmm2, %xmm3
    pshufb       FwdShiftRows(%rip), %xmm3
    movdqa       %xmm3, %xmm1
    movdqa       %xmm3, %xmm2
    pxor         %xmm4, %xmm4
    psrlw        $(4), %xmm2
    pand         %xmm7, %xmm1
    movdqa       GF16mul_E_2x(%rip), %xmm0
    pshufb       %xmm1, %xmm0
    pand         %xmm7, %xmm2
    movdqa       GF16mul_1_Cx(%rip), %xmm1
    pshufb       %xmm2, %xmm1
    pxor         %xmm1, %xmm0
    pshufb       ColumnROR(%rip), %xmm3
    pxor         %xmm3, %xmm4
    pshufb       ColumnROR(%rip), %xmm3
    pxor         %xmm3, %xmm4
    movdqa       %xmm0, %xmm2
    pshufb       ColumnROR(%rip), %xmm2
    pxor         %xmm2, %xmm0
    pshufb       ColumnROR(%rip), %xmm3
    pxor         %xmm3, %xmm4
    pxor         %xmm4, %xmm0
    pxor         (%rcx), %xmm0
    add          $(16), %rcx
    sub          $(1), %rdx
    jg           .Lencode_roundgas_2
    movdqa       %xmm0, %xmm1
    pand         %xmm7, %xmm0
    psrlw        $(4), %xmm1
    pand         %xmm7, %xmm1
    movdqa       GF16_logTbl(%rip), %xmm5
    pshufb       %xmm0, %xmm5
    pxor         %xmm1, %xmm0
    movdqa       GF16_logTbl(%rip), %xmm2
    pshufb       %xmm0, %xmm2
    movdqa       GF16_sqr1(%rip), %xmm4
    pshufb       %xmm1, %xmm4
    movdqa       GF16_logTbl(%rip), %xmm3
    pshufb       %xmm1, %xmm3
    paddb        %xmm2, %xmm5
    movdqa       %xmm5, %xmm0
    pcmpgtb      %xmm7, %xmm5
    psubb        %xmm5, %xmm0
    movdqa       GF16_expTbl(%rip), %xmm5
    pshufb       %xmm0, %xmm5
    pxor         %xmm5, %xmm4
    movdqa       GF16_invLog(%rip), %xmm5
    pshufb       %xmm4, %xmm5
    paddb        %xmm5, %xmm2
    paddb        %xmm5, %xmm3
    movdqa       %xmm2, %xmm5
    pcmpgtb      %xmm7, %xmm2
    psubb        %xmm2, %xmm5
    movdqa       GF16_expTbl(%rip), %xmm0
    pshufb       %xmm5, %xmm0
    movdqa       %xmm3, %xmm5
    pcmpgtb      %xmm7, %xmm3
    psubb        %xmm3, %xmm5
    movdqa       GF16_expTbl(%rip), %xmm1
    pshufb       %xmm5, %xmm1
    movdqa       FwdAffineLO(%rip), %xmm3
    movdqa       FwdAffineHI(%rip), %xmm2
    movdqa       FwdAffineCnt(%rip), %xmm4
    pshufb       %xmm0, %xmm3
    pshufb       %xmm1, %xmm2
    pxor         %xmm4, %xmm3
    pxor         %xmm2, %xmm3
    pshufb       FwdShiftRows(%rip), %xmm3
    pxor         (%rcx), %xmm3
    movdqa       TransInvLO(%rip), %xmm0
    movdqa       TransInvHI(%rip), %xmm2
    movdqa       %xmm3, %xmm1
    psrlw        $(4), %xmm3
    pand         %xmm7, %xmm1
    pand         %xmm7, %xmm3
    pshufb       %xmm1, %xmm0
    pshufb       %xmm3, %xmm2
    pxor         %xmm2, %xmm0
    movdqu       %xmm0, (%rsi)
 
    ret
.Lfe2:
.size SafeEncrypt_RIJ128, .Lfe2-(SafeEncrypt_RIJ128)
 
