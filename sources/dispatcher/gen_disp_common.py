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

def readNextFunction(header, curLine, headerID):    ## read next function with arguments
  ## find header ID macros
  FunName  = ''
  FunArg   = ''
  FunType  = ''
  success = False
  while (curLine < len(header) and success == False):
    if not headerID and re.match( '\s*#\s*if\s*!\s*defined\s*\(\s*__IPP', header[curLine]):
      headerID= re.sub( '.*__IPP', '__IPP', header[curLine] )
      headerID= re.sub( "\)", '', headerID)
      headerID= re.sub( '[\n\s]', '', headerID )
    
    if re.match( '^\s*IPPAPI\s*\(.*', header[curLine] ) :
      FunStr= header[curLine];
      FunStr= re.sub('\n','',FunStr)   ## remove EOL symbols
  
      while not re.match('.*\)\s*\)\s*$', FunStr):   ## concatinate strinng if string is not completed
        curLine= curLine+1
        FunStr= FunStr+header[curLine]
        FunStr= re.sub('\n','',FunStr)   ## remove EOL symbols
    
      FunStr= re.sub('\s+', ' ', FunStr)
    
      s= FunStr.split(',')
    
      ## Extract funtion name
      FunName= s[1]
      FunName= re.sub('\s', '', FunName)
    
      ## Extract function type
      FunType= re.sub( '.*\(', '', s[0] )
      #FunType= re.sub(' ', '', FunType )
    
      ## Extract function arguments
      FunArg= re.sub('.*\(.*,.+,\s*\(', '(', FunStr)
      FunArg= re.sub('\)\s*\)', ')', FunArg)
      success = True

    curLine = curLine + 1

  return {'curLine':curLine, 'FunType':FunType, 'FunName':FunName, 'FunArg':FunArg, 'success':success }