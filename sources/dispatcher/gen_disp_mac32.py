#===============================================================================
# Copyright 2017-2018 Intel Corporation
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
#===============================================================================

#
# Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography
#

import re
import sys
import os
import hashlib

Header  = sys.argv[1]    ## Intel(R) IPP Crypto dispatcher will be generated for fucntions in Header 
OutDir  = sys.argv[2]    ## Output folder for generated files
cpulist = sys.argv[3]    ## Actual CPU list: semicolon separated string

cpulist = cpulist.split(';')

headerID= False      ## Header ID define to avoid multiple include like: #if !defined( __IPPCP_H__ )

from gen_disp_common import readNextFunction

HDR= open( Header, 'r' )
h= HDR.readlines()
HDR.close()


## keep filename only
(incdir, Header)= os.path.split(Header)

## original header name to declare external functions as internal for dispatcher
OrgH= Header

isFunctionFound = True
curLine = 0
FunType = ""
FunName = ""
FunArg = ""

while (isFunctionFound == True):

  result = readNextFunction(h, curLine, headerID)
  
  curLine         = result['curLine']
  FunType         = result['FunType']
  FunName         = result['FunName']
  FunArg          = result['FunArg']
  isFunctionFound = result['success']

  if (isFunctionFound == True):

      ##################################################
      ## create dispatcher files: C file with inline asm
      ##################################################
      DISP= open( os.sep.join([OutDir, "jmp_"+FunName+"_" + hashlib.sha512(FunName.encode('utf-8')).hexdigest()[:8] + ".c"]), 'w' )

      DISP.write("""#include "ippcp.h"\n\n""")

      DISP.write("typedef "+FunType+" (*IPP_PROC)"+FunArg+";\n\n")
      DISP.write("extern int ippcpJumpIndexForMergedLibs;\n")
      DISP.write("extern IppStatus ippcpSafeInit( void );\n\n")

      DISP.write("extern "+FunType+" in_"+FunName+FunArg+";\n")

      for cpu in cpulist:
         DISP.write("extern "+FunType+" "+cpu+"_"+FunName+FunArg+";\n")

      DISP.write("static IPP_PROC arraddr[] =\n{{\n	(IPP_PROC)in_{}".format(FunName))

      for cpu in cpulist:
         DISP.write(",\n	(IPP_PROC)"+cpu+"_"+FunName+"")

      DISP.write("\n};")

      DISP.write("""
#undef  IPPAPI
#define IPPAPI(type,name,arg) __declspec(naked) type IPP_STDCALL name arg
IPPAPI({FunType}, {FunName},{FunArg})
{{
    __asm( "call L1");
    __asm( "L1: popl %eax");
    __asm( "movl L_ippcpJumpIndexForMergedLibs$non_lazy_ptr-L1(%eax), %edx" );
    __asm( "movl (%edx), %edx" );
    __asm( "jmp  *(_arraddr-L1+4)(%eax,%edx,4)");
    return &(arraddr) + ippcpJumpIndexForMergedLibs;
}};
IPPAPI({FunType}, in_{FunName},{FunArg})
{{
    __asm( "pushl %esi" );
    __asm( "pushl %edi" );
    __asm( "pushl %ebp" );
    __asm( "call _ippcpInit" );
    __asm( "popl %ebp" );
    __asm( "popl %edi" );
    __asm( "popl %esi" );
    __asm( "call L2");
    __asm( "L2: popl %eax");
    __asm( "movl L_ippcpJumpIndexForMergedLibs$non_lazy_ptr-L2(%eax), %edx" );
    __asm( "movl (%edx), %edx" );
    __asm( "jmp  *(_arraddr-L2+4)(%eax,%edx,4)");
    return &(arraddr) + ippcpJumpIndexForMergedLibs;
}};
""".format(FunType=FunType, FunName=FunName, FunArg=FunArg))

      DISP.close()

