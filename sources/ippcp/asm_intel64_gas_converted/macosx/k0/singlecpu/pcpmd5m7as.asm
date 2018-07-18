###############################################################################
# Copyright 2018 Intel Corporation
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

 
.text
 
.p2align 6, 0x90
.p2align 6, 0x90
 
.globl _UpdateMD5

 
_UpdateMD5:
 
    push         %rbx
 
    push         %r12
 
    movslq       %edx, %r12
.Lmd5_block_loopgas_1: 
    mov          (%rdi), %r8d
    mov          (4)(%rdi), %r9d
    mov          (8)(%rdi), %r10d
    mov          (12)(%rdi), %r11d
    mov          (%rsi), %ecx
    add          $(3614090360), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %edx, %r8d
    rorx         $(25), %r8d, %r8d
    add          %r9d, %r8d
    mov          (4)(%rsi), %ecx
    add          $(3905402710), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %edx, %r11d
    rorx         $(20), %r11d, %r11d
    add          %r8d, %r11d
    mov          (8)(%rsi), %ecx
    add          $(606105819), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r11d, %edx
    xor          %r9d, %edx
    add          %edx, %r10d
    rorx         $(15), %r10d, %r10d
    add          %r11d, %r10d
    mov          (12)(%rsi), %ecx
    add          $(3250441966), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r10d, %edx
    xor          %r8d, %edx
    add          %edx, %r9d
    rorx         $(10), %r9d, %r9d
    add          %r10d, %r9d
    mov          (16)(%rsi), %ecx
    add          $(4118548399), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %edx, %r8d
    rorx         $(25), %r8d, %r8d
    add          %r9d, %r8d
    mov          (20)(%rsi), %ecx
    add          $(1200080426), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %edx, %r11d
    rorx         $(20), %r11d, %r11d
    add          %r8d, %r11d
    mov          (24)(%rsi), %ecx
    add          $(2821735955), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r11d, %edx
    xor          %r9d, %edx
    add          %edx, %r10d
    rorx         $(15), %r10d, %r10d
    add          %r11d, %r10d
    mov          (28)(%rsi), %ecx
    add          $(4249261313), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r10d, %edx
    xor          %r8d, %edx
    add          %edx, %r9d
    rorx         $(10), %r9d, %r9d
    add          %r10d, %r9d
    mov          (32)(%rsi), %ecx
    add          $(1770035416), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %edx, %r8d
    rorx         $(25), %r8d, %r8d
    add          %r9d, %r8d
    mov          (36)(%rsi), %ecx
    add          $(2336552879), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %edx, %r11d
    rorx         $(20), %r11d, %r11d
    add          %r8d, %r11d
    mov          (40)(%rsi), %ecx
    add          $(4294925233), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r11d, %edx
    xor          %r9d, %edx
    add          %edx, %r10d
    rorx         $(15), %r10d, %r10d
    add          %r11d, %r10d
    mov          (44)(%rsi), %ecx
    add          $(2304563134), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r10d, %edx
    xor          %r8d, %edx
    add          %edx, %r9d
    rorx         $(10), %r9d, %r9d
    add          %r10d, %r9d
    mov          (48)(%rsi), %ecx
    add          $(1804603682), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r9d, %edx
    xor          %r11d, %edx
    add          %edx, %r8d
    rorx         $(25), %r8d, %r8d
    add          %r9d, %r8d
    mov          (52)(%rsi), %ecx
    add          $(4254626195), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r8d, %edx
    xor          %r10d, %edx
    add          %edx, %r11d
    rorx         $(20), %r11d, %r11d
    add          %r8d, %r11d
    mov          (56)(%rsi), %ecx
    add          $(2792965006), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r11d, %edx
    xor          %r9d, %edx
    add          %edx, %r10d
    rorx         $(15), %r10d, %r10d
    add          %r11d, %r10d
    mov          (60)(%rsi), %ecx
    add          $(1236535329), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r10d, %edx
    xor          %r8d, %edx
    add          %edx, %r9d
    rorx         $(10), %r9d, %r9d
    add          %r10d, %r9d
    mov          (4)(%rsi), %ecx
    add          $(4129170786), %r8d
    add          %ecx, %r8d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(27), %r8d, %r8d
    add          %r9d, %r8d
    mov          (24)(%rsi), %ecx
    add          $(3225465664), %r11d
    add          %ecx, %r11d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(23), %r11d, %r11d
    add          %r8d, %r11d
    mov          (44)(%rsi), %ecx
    add          $(643717713), %r10d
    add          %ecx, %r10d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(18), %r10d, %r10d
    add          %r11d, %r10d
    mov          (%rsi), %ecx
    add          $(3921069994), %r9d
    add          %ecx, %r9d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(12), %r9d, %r9d
    add          %r10d, %r9d
    mov          (20)(%rsi), %ecx
    add          $(3593408605), %r8d
    add          %ecx, %r8d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(27), %r8d, %r8d
    add          %r9d, %r8d
    mov          (40)(%rsi), %ecx
    add          $(38016083), %r11d
    add          %ecx, %r11d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(23), %r11d, %r11d
    add          %r8d, %r11d
    mov          (60)(%rsi), %ecx
    add          $(3634488961), %r10d
    add          %ecx, %r10d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(18), %r10d, %r10d
    add          %r11d, %r10d
    mov          (16)(%rsi), %ecx
    add          $(3889429448), %r9d
    add          %ecx, %r9d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(12), %r9d, %r9d
    add          %r10d, %r9d
    mov          (36)(%rsi), %ecx
    add          $(568446438), %r8d
    add          %ecx, %r8d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(27), %r8d, %r8d
    add          %r9d, %r8d
    mov          (56)(%rsi), %ecx
    add          $(3275163606), %r11d
    add          %ecx, %r11d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(23), %r11d, %r11d
    add          %r8d, %r11d
    mov          (12)(%rsi), %ecx
    add          $(4107603335), %r10d
    add          %ecx, %r10d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(18), %r10d, %r10d
    add          %r11d, %r10d
    mov          (32)(%rsi), %ecx
    add          $(1163531501), %r9d
    add          %ecx, %r9d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(12), %r9d, %r9d
    add          %r10d, %r9d
    mov          (52)(%rsi), %ecx
    add          $(2850285829), %r8d
    add          %ecx, %r8d
    mov          %r10d, %edx
    xor          %r9d, %edx
    and          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(27), %r8d, %r8d
    add          %r9d, %r8d
    mov          (8)(%rsi), %ecx
    add          $(4243563512), %r11d
    add          %ecx, %r11d
    mov          %r9d, %edx
    xor          %r8d, %edx
    and          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(23), %r11d, %r11d
    add          %r8d, %r11d
    mov          (28)(%rsi), %ecx
    add          $(1735328473), %r10d
    add          %ecx, %r10d
    mov          %r8d, %edx
    xor          %r11d, %edx
    and          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(18), %r10d, %r10d
    add          %r11d, %r10d
    mov          (48)(%rsi), %ecx
    add          $(2368359562), %r9d
    add          %ecx, %r9d
    mov          %r11d, %edx
    xor          %r10d, %edx
    and          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(12), %r9d, %r9d
    add          %r10d, %r9d
    mov          (20)(%rsi), %ecx
    add          $(4294588738), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r8d
    rorx         $(28), %r8d, %r8d
    add          %r9d, %r8d
    mov          (32)(%rsi), %ecx
    add          $(2272392833), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r11d
    rorx         $(21), %r11d, %r11d
    add          %r8d, %r11d
    mov          (44)(%rsi), %ecx
    add          $(1839030562), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r10d
    rorx         $(16), %r10d, %r10d
    add          %r11d, %r10d
    mov          (56)(%rsi), %ecx
    add          $(4259657740), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r9d
    rorx         $(9), %r9d, %r9d
    add          %r10d, %r9d
    mov          (4)(%rsi), %ecx
    add          $(2763975236), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r8d
    rorx         $(28), %r8d, %r8d
    add          %r9d, %r8d
    mov          (16)(%rsi), %ecx
    add          $(1272893353), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r11d
    rorx         $(21), %r11d, %r11d
    add          %r8d, %r11d
    mov          (28)(%rsi), %ecx
    add          $(4139469664), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r10d
    rorx         $(16), %r10d, %r10d
    add          %r11d, %r10d
    mov          (40)(%rsi), %ecx
    add          $(3200236656), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r9d
    rorx         $(9), %r9d, %r9d
    add          %r10d, %r9d
    mov          (52)(%rsi), %ecx
    add          $(681279174), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r8d
    rorx         $(28), %r8d, %r8d
    add          %r9d, %r8d
    mov          (%rsi), %ecx
    add          $(3936430074), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r11d
    rorx         $(21), %r11d, %r11d
    add          %r8d, %r11d
    mov          (12)(%rsi), %ecx
    add          $(3572445317), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r10d
    rorx         $(16), %r10d, %r10d
    add          %r11d, %r10d
    mov          (24)(%rsi), %ecx
    add          $(76029189), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r9d
    rorx         $(9), %r9d, %r9d
    add          %r10d, %r9d
    mov          (36)(%rsi), %ecx
    add          $(3654602809), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    xor          %r10d, %edx
    xor          %r9d, %edx
    add          %edx, %r8d
    rorx         $(28), %r8d, %r8d
    add          %r9d, %r8d
    mov          (48)(%rsi), %ecx
    add          $(3873151461), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    xor          %r9d, %edx
    xor          %r8d, %edx
    add          %edx, %r11d
    rorx         $(21), %r11d, %r11d
    add          %r8d, %r11d
    mov          (60)(%rsi), %ecx
    add          $(530742520), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    xor          %r8d, %edx
    xor          %r11d, %edx
    add          %edx, %r10d
    rorx         $(16), %r10d, %r10d
    add          %r11d, %r10d
    mov          (8)(%rsi), %ecx
    add          $(3299628645), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    xor          %r11d, %edx
    xor          %r10d, %edx
    add          %edx, %r9d
    rorx         $(9), %r9d, %r9d
    add          %r10d, %r9d
    mov          (%rsi), %ecx
    add          $(4096336452), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    not          %edx
    or           %r9d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(26), %r8d, %r8d
    add          %r9d, %r8d
    mov          (28)(%rsi), %ecx
    add          $(1126891415), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    not          %edx
    or           %r8d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(22), %r11d, %r11d
    add          %r8d, %r11d
    mov          (56)(%rsi), %ecx
    add          $(2878612391), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    not          %edx
    or           %r11d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(17), %r10d, %r10d
    add          %r11d, %r10d
    mov          (20)(%rsi), %ecx
    add          $(4237533241), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    not          %edx
    or           %r10d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(11), %r9d, %r9d
    add          %r10d, %r9d
    mov          (48)(%rsi), %ecx
    add          $(1700485571), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    not          %edx
    or           %r9d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(26), %r8d, %r8d
    add          %r9d, %r8d
    mov          (12)(%rsi), %ecx
    add          $(2399980690), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    not          %edx
    or           %r8d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(22), %r11d, %r11d
    add          %r8d, %r11d
    mov          (40)(%rsi), %ecx
    add          $(4293915773), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    not          %edx
    or           %r11d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(17), %r10d, %r10d
    add          %r11d, %r10d
    mov          (4)(%rsi), %ecx
    add          $(2240044497), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    not          %edx
    or           %r10d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(11), %r9d, %r9d
    add          %r10d, %r9d
    mov          (32)(%rsi), %ecx
    add          $(1873313359), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    not          %edx
    or           %r9d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(26), %r8d, %r8d
    add          %r9d, %r8d
    mov          (60)(%rsi), %ecx
    add          $(4264355552), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    not          %edx
    or           %r8d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(22), %r11d, %r11d
    add          %r8d, %r11d
    mov          (24)(%rsi), %ecx
    add          $(2734768916), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    not          %edx
    or           %r11d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(17), %r10d, %r10d
    add          %r11d, %r10d
    mov          (52)(%rsi), %ecx
    add          $(1309151649), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    not          %edx
    or           %r10d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(11), %r9d, %r9d
    add          %r10d, %r9d
    mov          (16)(%rsi), %ecx
    add          $(4149444226), %r8d
    add          %ecx, %r8d
    mov          %r11d, %edx
    not          %edx
    or           %r9d, %edx
    xor          %r10d, %edx
    add          %edx, %r8d
    rorx         $(26), %r8d, %r8d
    add          %r9d, %r8d
    mov          (44)(%rsi), %ecx
    add          $(3174756917), %r11d
    add          %ecx, %r11d
    mov          %r10d, %edx
    not          %edx
    or           %r8d, %edx
    xor          %r9d, %edx
    add          %edx, %r11d
    rorx         $(22), %r11d, %r11d
    add          %r8d, %r11d
    mov          (8)(%rsi), %ecx
    add          $(718787259), %r10d
    add          %ecx, %r10d
    mov          %r9d, %edx
    not          %edx
    or           %r11d, %edx
    xor          %r8d, %edx
    add          %edx, %r10d
    rorx         $(17), %r10d, %r10d
    add          %r11d, %r10d
    mov          (36)(%rsi), %ecx
    add          $(3951481745), %r9d
    add          %ecx, %r9d
    mov          %r8d, %edx
    not          %edx
    or           %r10d, %edx
    xor          %r11d, %edx
    add          %edx, %r9d
    rorx         $(11), %r9d, %r9d
    add          %r10d, %r9d
    add          %r8d, (%rdi)
    add          %r9d, (4)(%rdi)
    add          %r10d, (8)(%rdi)
    add          %r11d, (12)(%rdi)
    add          $(64), %rsi
    sub          $(64), %r12
    jg           .Lmd5_block_loopgas_1
vzeroupper 
 
    pop          %r12
 
    pop          %rbx
 
    ret
 
