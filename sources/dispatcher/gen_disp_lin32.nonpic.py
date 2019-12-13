#===============================================================================
# Copyright 2017-2019 Intel Corporation
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

Header   = sys.argv[1]    ## Intel(R) IPP Crypto dispatcher will be generated for fucntions in Header
OutDir   = sys.argv[2]    ## Output folder for generated files
cpulist  = sys.argv[3]    ## Actual CPU list: semicolon separated string
compiler = sys.argv[4]

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
FunName = ""
FunArg = ""

if(compiler == "GNU"):
      while (isFunctionFound == True):

            result = readNextFunction(h, curLine, headerID)

            curLine         = result['curLine']
            FunName         = result['FunName']
            FunArg          = result['FunArg']
            isFunctionFound = result['success']

            if (isFunctionFound == True):

                  ##################################################
                  ## create dispatcher files ASM
                  ##################################################
                  ASMDISP= open( os.sep.join([OutDir, "jmp_" + FunName+"_" + hashlib.sha512(FunName.encode('utf-8')).hexdigest()[:8] +".asm"]), 'w' )

                  for cpu in cpulist:
                      ASMDISP.write("extern "+cpu+"_"+FunName+":function\n")

                  ASMDISP.write("extern ippcpJumpIndexForMergedLibs\n")
                  ASMDISP.write("extern ippcpInit:function\n\n")
                  ASMDISP.write("""
segment .data
align 4

dd  in_{FunName}
arraddr_{FunName}:

""".format(FunName=FunName))
                  size = 4
                  for cpu in cpulist:
                        size = size + 4
                        ASMDISP.write("    dd "+cpu+"_"+FunName+"\n")

                  ASMDISP.write("""

segment .text
global {FunName}:function ({FunName}.LEnd{FunName} - {FunName})
in_{FunName}:
    call  ippcpInit
    align 16
{FunName}:
      mov   eax, dword [ippcpJumpIndexForMergedLibs]
      jmp   dword [rel arraddr_{FunName} + eax*4]
.LEnd{FunName}:
""".format(FunName=FunName, size=size))
            ASMDISP.close()
else:
      while (isFunctionFound == True):

            result = readNextFunction(h, curLine, headerID)

            curLine         = result['curLine']
            FunName         = result['FunName']
            FunArg          = result['FunArg']
            isFunctionFound = result['success']

            if (isFunctionFound == True):

                  ##################################################
                  ## create dispatcher files: C file with inline asm
                  ##################################################
                  DISP= open( os.sep.join([OutDir, "jmp_"+FunName+"_" + hashlib.sha512(FunName.encode('utf-8')).hexdigest()[:8] + ".c"]), 'w' )

                  DISP.write("""#include "ippcpdefs.h"\n\n""")

                  DISP.write("typedef void (*IPP_PROC)(void);\n\n")
                  DISP.write("extern int ippcpJumpIndexForMergedLibs;\n")
                  DISP.write("extern IPP_STDCALL ippcpInit();\n\n")

                  DISP.write("extern IppStatus in_"+FunName+FunArg+";\n")

                  for cpu in cpulist:
                        DISP.write("extern IppStatus "+cpu+"_"+FunName+FunArg+";\n")

                  DISP.write("""
__asm( "  .data");
__asm( "    .align 4");
__asm( "arraddr:");
__asm( "    .long	in_{FunName}");""".format(FunName=FunName))
                  size = 4
                  for cpu in cpulist:
                        size = size + 4
                        DISP.write("""\n__asm( "    .long	{cpu}_{FunName}");""".format(FunName=FunName, cpu=cpu))

                  DISP.write("""
__asm( "    .type	arraddr,@object");
__asm( "    .size	arraddr,{size}");
__asm( "  .data");\n""".format(size=size))

                  DISP.write("""
#undef  IPPAPI
#define IPPAPI(type,name,arg) __declspec(naked) void name arg
IPPAPI(IppStatus, {FunName},{FunArg})
{{
    __asm( ".L0: mov ippcpJumpIndexForMergedLibs, %eax");
    __asm( "jmp *(arraddr+4)(,%eax,4)" );
    __asm( ".global in_{FunName}" );
    __asm( "in_{FunName}: call ippcpInit" );
    __asm( "jmp .L0" );
}};
""".format(FunName=FunName, FunArg=FunArg))

            DISP.close()

