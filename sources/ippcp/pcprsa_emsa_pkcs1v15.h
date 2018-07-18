/*******************************************************************************
* Copyright 2013-2018 Intel Corporation
* All Rights Reserved.
*
* If this  software was obtained  under the  Intel Simplified  Software License,
* the following terms apply:
*
* The source code,  information  and material  ("Material") contained  herein is
* owned by Intel Corporation or its  suppliers or licensors,  and  title to such
* Material remains with Intel  Corporation or its  suppliers or  licensors.  The
* Material  contains  proprietary  information  of  Intel or  its suppliers  and
* licensors.  The Material is protected by  worldwide copyright  laws and treaty
* provisions.  No part  of  the  Material   may  be  used,  copied,  reproduced,
* modified, published,  uploaded, posted, transmitted,  distributed or disclosed
* in any way without Intel's prior express written permission.  No license under
* any patent,  copyright or other  intellectual property rights  in the Material
* is granted to  or  conferred  upon  you,  either   expressly,  by implication,
* inducement,  estoppel  or  otherwise.  Any  license   under such  intellectual
* property rights must be express and approved by Intel in writing.
*
* Unless otherwise agreed by Intel in writing,  you may not remove or alter this
* notice or  any  other  notice   embedded  in  Materials  by  Intel  or Intel's
* suppliers or licensors in any way.
*
*
* If this  software  was obtained  under the  Apache License,  Version  2.0 (the
* "License"), the following terms apply:
*
* You may  not use this  file except  in compliance  with  the License.  You may
* obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
*
*
* Unless  required  by   applicable  law  or  agreed  to  in  writing,  software
* distributed under the License  is distributed  on an  "AS IS"  BASIS,  WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*
* See the   License  for the   specific  language   governing   permissions  and
* limitations under the License.
*******************************************************************************/

/*
//
//  Purpose:
//     Cryptography Primitive.
//     RSASSA-PKCS-v1_5
//
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpngrsa.h"
#include "pcphash.h"
#include "pcptool.h"

static int EMSA_PKCSv15(const Ipp8u* msgDg, int lenMsgDg,
    const Ipp8u* fixPS, int lenFixPS,
    Ipp8u*   pEM, int lenEM)
{
    /*
    // encoded message format:
    //    EM = 00 || 01 || PS=(FF..FF) || 00 || T
    //    T = fixPS || msgDg
    //    len(PS) >= 8
    */
    int  tLen = lenFixPS + lenMsgDg;

    if (lenEM >= tLen + 11) {
        int psLen = lenEM - 3 - tLen;

        PaddBlock(0xFF, pEM, lenEM);
        pEM[0] = 0x00;
        pEM[1] = 0x01;
        pEM[2 + psLen] = 0x00;
        CopyBlock(fixPS, pEM + 3 + psLen, lenFixPS);
        CopyBlock(msgDg, pEM + 3 + psLen + lenFixPS, lenMsgDg);
        return 1;
    }
    else
        return 0; /* encoded message length too long */
}