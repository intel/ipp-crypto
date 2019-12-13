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
FunName = ""
FunArg = ""

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
    filename = "jmp_{}_{}".format(FunName, hashlib.sha512(FunName.encode('utf-8')).hexdigest()[:8])
    
    DISP= open( os.sep.join([OutDir, filename + ".asm"]), 'w' )
    
    for cpu in cpulist:
       DISP.write("extern "+cpu+"_"+FunName+"\n")
    
    DISP.write("extern ippcpJumpIndexForMergedLibs\n")
    DISP.write("extern ippcpSafeInit\n\n")
    
    DISP.write("segment data\n\n")
    
    DISP.write("    DQ in_"+FunName+"\n")
    DISP.write(FunName+"_arraddr:\n")
    
    for cpu in cpulist:
       DISP.write("    DQ "+cpu+"_"+FunName+"\n")
    
    DISP.write("""

segment text

global {FunName}

in_{FunName}:
   call    ippcpSafeInit
   align 16
{FunName}:
   movsxd  rax, dword [rel ippcpJumpIndexForMergedLibs]
   lea     r10, [rel {FunName}_arraddr]
   jmp     qword [r10+rax*8]

""".format(FunName=FunName))

    DISP.close()
