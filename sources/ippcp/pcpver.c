/*******************************************************************************
* Copyright 2002-2018 Intel Corporation
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
//               Intel(R) Integrated Performance Primitives
//                   Cryptographic Primitives (ippcp)
//
*/

#include "owndefs.h"
#include "ippcpdefs.h"
#include "owncp.h"
#include "pcpver.h"
#include "pcpname.h"

#ifdef _IPP_OMP_STATIC
#define LIB_THREADS " threaded"
#else 
#define LIB_THREADS ""
#endif

#define GET_LIBRARY_NAME( cpu, is ) #cpu, IPP_LIB_SHORTNAME() " " is " (" #cpu LIB_THREADS ")"

static const IppLibraryVersion ippcpLibVer = {
    /* major, minor, update (ex-majorBuild) */
    BASE_VERSION(),
#if defined IPP_REVISION
    IPP_REVISION,
#else
    -1,
#endif /* IPP_REVISION */
       /* targetCpu[4] */
#if ( _IPP_ARCH == _IPP_ARCH_IA32 ) || ( _IPP_ARCH == _IPP_ARCH_LP32 )
    #if ( _IPP == _IPP_M5 )             /* Intel(R) Quark(TM) processor - ia32 */
        GET_LIBRARY_NAME( m5, "586" )
    #elif ( _IPP == _IPP_H9 )           /* Intel(R) Advanced Vector Extensions 2 - ia32 */
        GET_LIBRARY_NAME( h9, "AVX2" )
    #elif ( _IPP == _IPP_G9 )           /* Intel(R) Advanced Vector Extensions - ia32 */
        GET_LIBRARY_NAME( g9, "AVX" )
    #elif ( _IPP == _IPP_P8 )           /* Intel(R) Streaming SIMD Extensions 4.2 - ia32 */
        GET_LIBRARY_NAME( p8, "SSE4.2" )
    #elif ( _IPP == _IPP_S8 )           /* Supplemental Streaming SIMD Extensions 3 + Intel(R) instruction MOVBE - ia32 */
        GET_LIBRARY_NAME( s8, "Atom" )
    #elif ( _IPP == _IPP_V8 )           /* Supplemental Streaming SIMD Extensions 3 - ia32 */
        GET_LIBRARY_NAME( v8, "SSSE3" )
    #elif ( _IPP == _IPP_W7 )           /* Intel(R) Streaming SIMD Extensions 2 - ia32 */
        GET_LIBRARY_NAME( w7, "SSE2" )
    #else
        GET_LIBRARY_NAME( px, "PX" )
    #endif

#elif ( _IPP_ARCH == _IPP_ARCH_EM64T ) || ( _IPP_ARCH == _IPP_ARCH_LP64 )
    #if ( _IPP32E == _IPP32E_K0 )       /* Intel(R) Advanced Vector Extensions 512 (formerly Skylake) - intel64 */
        GET_LIBRARY_NAME( k0, "AVX-512F/CD/BW/DQ/VL" )
    #elif ( _IPP32E == _IPP32E_N0 )     /* Intel(R) Advanced Vector Extensions 512 (formerly codenamed Knights Landing) - intel64 */
        GET_LIBRARY_NAME( n0, "AVX-512F/CD/ER/PF" )
    #elif ( _IPP32E == _IPP32E_E9 )     /* Intel(R) Advanced Vector Extensions - intel64 */
        GET_LIBRARY_NAME( e9, "AVX" )
    #elif ( _IPP32E == _IPP32E_L9 )     /* Intel(R) Advanced Vector Extensions 2 - intel64 */
        GET_LIBRARY_NAME( l9, "AVX2" )
    #elif ( _IPP32E == _IPP32E_Y8 )     /* Intel(R) Streaming SIMD Extensions 4.2 - intel64 */
        GET_LIBRARY_NAME( y8, "SSE4.2" )
    #elif ( _IPP32E == _IPP32E_N8 )     /* Supplemental Streaming SIMD Extensions 3 + Intel(R) instruction MOVBE - intel64 */
        GET_LIBRARY_NAME( n8, "Atom" )
    #elif ( _IPP32E == _IPP32E_U8 )     /* Supplemental Streaming SIMD Extensions 3 - intel64 */
        GET_LIBRARY_NAME( u8, "SSSE3" )
    #elif ( _IPP32E == _IPP32E_M7 )     /* Intel(R) Streaming SIMD Extensions 3 - intel64 */
        GET_LIBRARY_NAME( m7, "SSE3" )
    #else
        GET_LIBRARY_NAME( mx, "PX" )
    #endif
#endif
    ,STR_VERSION() /* release Version */
    ,__DATE__ //BuildDate
};

IPPFUN( const IppLibraryVersion*, ippcpGetLibVersion, ( void )){
    return &ippcpLibVer;
};

/*////////////////////////// End of file "pcpver.c" ////////////////////////// */
