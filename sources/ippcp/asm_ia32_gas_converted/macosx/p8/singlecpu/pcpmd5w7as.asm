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

 
.text
 
.p2align 4, 0x90
 
.globl _UpdateMD5

 
_UpdateMD5:
    push         %ebp
    mov          %esp, %ebp
    push         %ebx
    push         %esi
    push         %edi
    push         %ebp
 
    movl         (20)(%ebp), %eax
    movl         (8)(%ebp), %edi
    movl         (12)(%ebp), %esi
    movl         (16)(%ebp), %eax
    sub          $(8), %esp
    mov          %edi, (%esp)
.Lmd5_block_loopgas_1: 
    mov          %eax, (4)(%esp)
    mov          (%esi), %ebp
    mov          (%edi), %eax
    mov          (4)(%edi), %ebx
    mov          (8)(%edi), %ecx
    mov          (12)(%edi), %edx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    lea          (3614090360)(%ebp,%eax), %eax
    mov          (4)(%esi), %ebp
    add          %edi, %eax
    rol          $(7), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    lea          (3905402710)(%ebp,%edx), %edx
    mov          (8)(%esi), %ebp
    add          %edi, %edx
    rol          $(12), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %ebx, %edi
    lea          (606105819)(%ebp,%ecx), %ecx
    mov          (12)(%esi), %ebp
    add          %edi, %ecx
    rol          $(17), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ecx, %edi
    xor          %eax, %edi
    lea          (3250441966)(%ebp,%ebx), %ebx
    mov          (16)(%esi), %ebp
    add          %edi, %ebx
    rol          $(22), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    lea          (4118548399)(%ebp,%eax), %eax
    mov          (20)(%esi), %ebp
    add          %edi, %eax
    rol          $(7), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    lea          (1200080426)(%ebp,%edx), %edx
    mov          (24)(%esi), %ebp
    add          %edi, %edx
    rol          $(12), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %ebx, %edi
    lea          (2821735955)(%ebp,%ecx), %ecx
    mov          (28)(%esi), %ebp
    add          %edi, %ecx
    rol          $(17), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ecx, %edi
    xor          %eax, %edi
    lea          (4249261313)(%ebp,%ebx), %ebx
    mov          (32)(%esi), %ebp
    add          %edi, %ebx
    rol          $(22), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    lea          (1770035416)(%ebp,%eax), %eax
    mov          (36)(%esi), %ebp
    add          %edi, %eax
    rol          $(7), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    lea          (2336552879)(%ebp,%edx), %edx
    mov          (40)(%esi), %ebp
    add          %edi, %edx
    rol          $(12), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %ebx, %edi
    lea          (4294925233)(%ebp,%ecx), %ecx
    mov          (44)(%esi), %ebp
    add          %edi, %ecx
    rol          $(17), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ecx, %edi
    xor          %eax, %edi
    lea          (2304563134)(%ebp,%ebx), %ebx
    mov          (48)(%esi), %ebp
    add          %edi, %ebx
    rol          $(22), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %ebx, %edi
    xor          %edx, %edi
    lea          (1804603682)(%ebp,%eax), %eax
    mov          (52)(%esi), %ebp
    add          %edi, %eax
    rol          $(7), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %eax, %edi
    xor          %ecx, %edi
    lea          (4254626195)(%ebp,%edx), %edx
    mov          (56)(%esi), %ebp
    add          %edi, %edx
    rol          $(12), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %edx, %edi
    xor          %ebx, %edi
    lea          (2792965006)(%ebp,%ecx), %ecx
    mov          (60)(%esi), %ebp
    add          %edi, %ecx
    rol          $(17), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ecx, %edi
    xor          %eax, %edi
    lea          (1236535329)(%ebp,%ebx), %ebx
    mov          (4)(%esi), %ebp
    add          %edi, %ebx
    rol          $(22), %ebx
    add          %ecx, %ebx
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %edx, %edi
    xor          %ecx, %edi
    lea          (4129170786)(%ebp,%eax), %eax
    mov          (24)(%esi), %ebp
    add          %edi, %eax
    rol          $(5), %eax
    add          %ebx, %eax
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %ecx, %edi
    xor          %ebx, %edi
    lea          (3225465664)(%ebp,%edx), %edx
    mov          (44)(%esi), %ebp
    add          %edi, %edx
    rol          $(9), %edx
    add          %eax, %edx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %eax, %edi
    lea          (643717713)(%ebp,%ecx), %ecx
    mov          (%esi), %ebp
    add          %edi, %ecx
    rol          $(14), %ecx
    add          %edx, %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %edx, %edi
    lea          (3921069994)(%ebp,%ebx), %ebx
    mov          (20)(%esi), %ebp
    add          %edi, %ebx
    rol          $(20), %ebx
    add          %ecx, %ebx
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %edx, %edi
    xor          %ecx, %edi
    lea          (3593408605)(%ebp,%eax), %eax
    mov          (40)(%esi), %ebp
    add          %edi, %eax
    rol          $(5), %eax
    add          %ebx, %eax
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %ecx, %edi
    xor          %ebx, %edi
    lea          (38016083)(%ebp,%edx), %edx
    mov          (60)(%esi), %ebp
    add          %edi, %edx
    rol          $(9), %edx
    add          %eax, %edx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %eax, %edi
    lea          (3634488961)(%ebp,%ecx), %ecx
    mov          (16)(%esi), %ebp
    add          %edi, %ecx
    rol          $(14), %ecx
    add          %edx, %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %edx, %edi
    lea          (3889429448)(%ebp,%ebx), %ebx
    mov          (36)(%esi), %ebp
    add          %edi, %ebx
    rol          $(20), %ebx
    add          %ecx, %ebx
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %edx, %edi
    xor          %ecx, %edi
    lea          (568446438)(%ebp,%eax), %eax
    mov          (56)(%esi), %ebp
    add          %edi, %eax
    rol          $(5), %eax
    add          %ebx, %eax
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %ecx, %edi
    xor          %ebx, %edi
    lea          (3275163606)(%ebp,%edx), %edx
    mov          (12)(%esi), %ebp
    add          %edi, %edx
    rol          $(9), %edx
    add          %eax, %edx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %eax, %edi
    lea          (4107603335)(%ebp,%ecx), %ecx
    mov          (32)(%esi), %ebp
    add          %edi, %ecx
    rol          $(14), %ecx
    add          %edx, %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %edx, %edi
    lea          (1163531501)(%ebp,%ebx), %ebx
    mov          (52)(%esi), %ebp
    add          %edi, %ebx
    rol          $(20), %ebx
    add          %ecx, %ebx
    mov          %ecx, %edi
    xor          %ebx, %edi
    and          %edx, %edi
    xor          %ecx, %edi
    lea          (2850285829)(%ebp,%eax), %eax
    mov          (8)(%esi), %ebp
    add          %edi, %eax
    rol          $(5), %eax
    add          %ebx, %eax
    mov          %ebx, %edi
    xor          %eax, %edi
    and          %ecx, %edi
    xor          %ebx, %edi
    lea          (4243563512)(%ebp,%edx), %edx
    mov          (28)(%esi), %ebp
    add          %edi, %edx
    rol          $(9), %edx
    add          %eax, %edx
    mov          %eax, %edi
    xor          %edx, %edi
    and          %ebx, %edi
    xor          %eax, %edi
    lea          (1735328473)(%ebp,%ecx), %ecx
    mov          (48)(%esi), %ebp
    add          %edi, %ecx
    rol          $(14), %ecx
    add          %edx, %ecx
    mov          %edx, %edi
    xor          %ecx, %edi
    and          %eax, %edi
    xor          %edx, %edi
    lea          (2368359562)(%ebp,%ebx), %ebx
    mov          (20)(%esi), %ebp
    add          %edi, %ebx
    rol          $(20), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    lea          (4294588738)(%ebp,%eax), %eax
    mov          (32)(%esi), %ebp
    add          %edi, %eax
    rol          $(4), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    lea          (2272392833)(%ebp,%edx), %edx
    mov          (44)(%esi), %ebp
    add          %edi, %edx
    rol          $(11), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %edx, %edi
    lea          (1839030562)(%ebp,%ecx), %ecx
    mov          (56)(%esi), %ebp
    add          %edi, %ecx
    rol          $(16), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    lea          (4259657740)(%ebp,%ebx), %ebx
    mov          (4)(%esi), %ebp
    add          %edi, %ebx
    rol          $(23), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    lea          (2763975236)(%ebp,%eax), %eax
    mov          (16)(%esi), %ebp
    add          %edi, %eax
    rol          $(4), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    lea          (1272893353)(%ebp,%edx), %edx
    mov          (28)(%esi), %ebp
    add          %edi, %edx
    rol          $(11), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %edx, %edi
    lea          (4139469664)(%ebp,%ecx), %ecx
    mov          (40)(%esi), %ebp
    add          %edi, %ecx
    rol          $(16), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    lea          (3200236656)(%ebp,%ebx), %ebx
    mov          (52)(%esi), %ebp
    add          %edi, %ebx
    rol          $(23), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    lea          (681279174)(%ebp,%eax), %eax
    mov          (%esi), %ebp
    add          %edi, %eax
    rol          $(4), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    lea          (3936430074)(%ebp,%edx), %edx
    mov          (12)(%esi), %ebp
    add          %edi, %edx
    rol          $(11), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %edx, %edi
    lea          (3572445317)(%ebp,%ecx), %ecx
    mov          (24)(%esi), %ebp
    add          %edi, %ecx
    rol          $(16), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    lea          (76029189)(%ebp,%ebx), %ebx
    mov          (36)(%esi), %ebp
    add          %edi, %ebx
    rol          $(23), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    xor          %ecx, %edi
    xor          %ebx, %edi
    lea          (3654602809)(%ebp,%eax), %eax
    mov          (48)(%esi), %ebp
    add          %edi, %eax
    rol          $(4), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    xor          %ebx, %edi
    xor          %eax, %edi
    lea          (3873151461)(%ebp,%edx), %edx
    mov          (60)(%esi), %ebp
    add          %edi, %edx
    rol          $(11), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    xor          %eax, %edi
    xor          %edx, %edi
    lea          (530742520)(%ebp,%ecx), %ecx
    mov          (8)(%esi), %ebp
    add          %edi, %ecx
    rol          $(16), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    xor          %edx, %edi
    xor          %ecx, %edi
    lea          (3299628645)(%ebp,%ebx), %ebx
    mov          (%esi), %ebp
    add          %edi, %ebx
    rol          $(23), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    not          %edi
    or           %ebx, %edi
    xor          %ecx, %edi
    lea          (4096336452)(%ebp,%eax), %eax
    mov          (28)(%esi), %ebp
    add          %edi, %eax
    rol          $(6), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    not          %edi
    or           %eax, %edi
    xor          %ebx, %edi
    lea          (1126891415)(%ebp,%edx), %edx
    mov          (56)(%esi), %ebp
    add          %edi, %edx
    rol          $(10), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    not          %edi
    or           %edx, %edi
    xor          %eax, %edi
    lea          (2878612391)(%ebp,%ecx), %ecx
    mov          (20)(%esi), %ebp
    add          %edi, %ecx
    rol          $(15), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    not          %edi
    or           %ecx, %edi
    xor          %edx, %edi
    lea          (4237533241)(%ebp,%ebx), %ebx
    mov          (48)(%esi), %ebp
    add          %edi, %ebx
    rol          $(21), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    not          %edi
    or           %ebx, %edi
    xor          %ecx, %edi
    lea          (1700485571)(%ebp,%eax), %eax
    mov          (12)(%esi), %ebp
    add          %edi, %eax
    rol          $(6), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    not          %edi
    or           %eax, %edi
    xor          %ebx, %edi
    lea          (2399980690)(%ebp,%edx), %edx
    mov          (40)(%esi), %ebp
    add          %edi, %edx
    rol          $(10), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    not          %edi
    or           %edx, %edi
    xor          %eax, %edi
    lea          (4293915773)(%ebp,%ecx), %ecx
    mov          (4)(%esi), %ebp
    add          %edi, %ecx
    rol          $(15), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    not          %edi
    or           %ecx, %edi
    xor          %edx, %edi
    lea          (2240044497)(%ebp,%ebx), %ebx
    mov          (32)(%esi), %ebp
    add          %edi, %ebx
    rol          $(21), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    not          %edi
    or           %ebx, %edi
    xor          %ecx, %edi
    lea          (1873313359)(%ebp,%eax), %eax
    mov          (60)(%esi), %ebp
    add          %edi, %eax
    rol          $(6), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    not          %edi
    or           %eax, %edi
    xor          %ebx, %edi
    lea          (4264355552)(%ebp,%edx), %edx
    mov          (24)(%esi), %ebp
    add          %edi, %edx
    rol          $(10), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    not          %edi
    or           %edx, %edi
    xor          %eax, %edi
    lea          (2734768916)(%ebp,%ecx), %ecx
    mov          (52)(%esi), %ebp
    add          %edi, %ecx
    rol          $(15), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    not          %edi
    or           %ecx, %edi
    xor          %edx, %edi
    lea          (1309151649)(%ebp,%ebx), %ebx
    mov          (16)(%esi), %ebp
    add          %edi, %ebx
    rol          $(21), %ebx
    add          %ecx, %ebx
    mov          %edx, %edi
    not          %edi
    or           %ebx, %edi
    xor          %ecx, %edi
    lea          (4149444226)(%ebp,%eax), %eax
    mov          (44)(%esi), %ebp
    add          %edi, %eax
    rol          $(6), %eax
    add          %ebx, %eax
    mov          %ecx, %edi
    not          %edi
    or           %eax, %edi
    xor          %ebx, %edi
    lea          (3174756917)(%ebp,%edx), %edx
    mov          (8)(%esi), %ebp
    add          %edi, %edx
    rol          $(10), %edx
    add          %eax, %edx
    mov          %ebx, %edi
    not          %edi
    or           %edx, %edi
    xor          %eax, %edi
    lea          (718787259)(%ebp,%ecx), %ecx
    mov          (36)(%esi), %ebp
    add          %edi, %ecx
    rol          $(15), %ecx
    add          %edx, %ecx
    mov          %eax, %edi
    not          %edi
    or           %ecx, %edi
    xor          %edx, %edi
    lea          (3951481745)(%ebp,%ebx), %ebx
    mov          (%esp), %ebp
    add          %edi, %ebx
    rol          $(21), %ebx
    add          %ecx, %ebx
    add          %eax, (%ebp)
    movl         (4)(%esp), %eax
    add          %ebx, (4)(%ebp)
    add          %ecx, (8)(%ebp)
    add          %edx, (12)(%ebp)
    mov          %ebp, %edi
    add          $(64), %esi
    sub          $(64), %eax
    jg           .Lmd5_block_loopgas_1
    add          $(8), %esp
    pop          %ebp
    pop          %edi
    pop          %esi
    pop          %ebx
    pop          %ebp
    ret
 
