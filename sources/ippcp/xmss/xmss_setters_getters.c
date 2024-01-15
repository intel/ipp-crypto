/*************************************************************************
* Copyright (C) 2023 Intel Corporation
*
* Licensed under the Apache License,  Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* 	http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law  or agreed  to  in  writing,  software
* distributed under  the License  is  distributed  on  an  "AS IS"  BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the  specific  language  governing  permissions  and
* limitations under the License.
*************************************************************************/

#include "owndefs.h"
#include "xmss_internal/xmss.h"

/*F*
//    Name: ippsXMSSSetPublicKeyState
//
// Purpose: Set XMSS public key.
//
// Returns:                Reason:
//    ippStsNullPtrErr        pRoot == NULL
//                            pSeed == NULL
//                            pState == NULL
//    ippStsBadArgErr         OIDAlgo > Max value for IppsXMSSAlgo
//    ippStsBadArgErr         OIDAlgo <= 0
//    ippStsNoErr             no errors
//
// Parameters:
//    OIDAlgo        id of XMSS set of parameters (algorithm)
//    pRoot          pointer to the XMSS public key root
//    pSeed          pointer to the XMSS public key seed
//    pState         pointer to the XMSS public key state
//
*F*/

IPPFUN(IppStatus, ippsXMSSSetPublicKeyState,( IppsXMSSAlgo OIDAlgo,
    const Ipp8u* pRoot,
    const Ipp8u* pSeed,
    IppsXMSSPublicKeyState* pState
))
{
    IPP_BAD_PTR1_RET(pRoot);
    IPP_BAD_PTR1_RET(pSeed);
    IPP_BAD_PTR1_RET(pState);
    IPP_BADARG_RET(OIDAlgo >  6, ippStsBadArgErr);
    IPP_BADARG_RET(OIDAlgo <= 0, ippStsBadArgErr);
    IppStatus status = ippStsNoErr;
    cpWOTSParams params;
    Ipp32s h = 0;
    status = setXMSSParams(OIDAlgo, &h, &params);
    Ipp32s n = params.n;

    pState->OIDAlgo = OIDAlgo;

    Ipp8u* ptr = (Ipp8u*)pState;

    /* allocate internal contexts */
    ptr += sizeof(IppsXMSSPublicKeyState);

    pState->pRoot = (Ipp8u*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(Ipp8u)) );
    CopyBlock(pRoot, pState->pRoot, n);
    ptr += n;

    pState->pSeed = (Ipp8u*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(Ipp8u)) );
    CopyBlock(pSeed, pState->pSeed, n);

    return status;
}

/*F*
//    Name: ippsXMSSSetSignatureState
//
// Purpose: Set XMSS signature.
//
// Returns:                Reason:
//    ippStsNullPtrErr        r == NULL
//                            pOTSSign == NULL
//                            pAuthPath == NULL
//                            pState == NULL
//    ippStsBadArgErr         OIDAlgo > Max value for IppsXMSSAlgo
//    ippStsBadArgErr         OIDAlgo <= 0
//    ippStsNoErr             no errors
//
// Parameters:
//    OIDAlgo        id of XMSS set of parameters (algorithm)
//    idx            index of XMSS leaf
//    r              pointer to the XMSS signature randomness variable
//    pOTSSign       pointer to the WOTS signature
//    pAuthPath      pointer to the XMSS authorization path
//    pState         pointer to the XMSS signature state
//
*F*/

IPPFUN(IppStatus, ippsXMSSSetSignatureState,( IppsXMSSAlgo OIDAlgo,
    Ipp32u idx,
    const Ipp8u* r,
    const Ipp8u* pOTSSign,
    const Ipp8u* pAuthPath,
    IppsXMSSSignatureState* pState
))
{
    IPP_BAD_PTR1_RET(r);
    IPP_BAD_PTR1_RET(pOTSSign);
    IPP_BAD_PTR1_RET(pAuthPath);
    IPP_BAD_PTR1_RET(pState);

    IPP_BADARG_RET(OIDAlgo >  6, ippStsBadArgErr);
    IPP_BADARG_RET(OIDAlgo <= 0, ippStsBadArgErr);
    IppStatus status = ippStsNoErr;
    cpWOTSParams params;
    Ipp32s h = 0;
    status = setXMSSParams(OIDAlgo, &h, &params);
    Ipp32s n = params.n;
    Ipp32s len = params.len;

    pState->idx = idx;
    Ipp8u* ptr = (Ipp8u*)pState;

    /* allocate internal contexts */
    ptr += sizeof(IppsXMSSSignatureState);

    pState->r = (Ipp8u*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(Ipp8u)) );
    CopyBlock(r, pState->r, n);
    ptr += n;

    pState->pOTSSign = (Ipp8u*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(Ipp8u)) );
    CopyBlock(pOTSSign, pState->pOTSSign, len * n);
    ptr += len * n;

    pState->pAuthPath = (Ipp8u*)( IPP_ALIGNED_PTR((ptr), (int)sizeof(Ipp8u)) );
    CopyBlock(pAuthPath, pState->pAuthPath, h * n);

    return status;
}

/*F*
//    Name: ippsXMSSSignatureStateGetSize
//
// Purpose: Get the XMSS signature state size (bytes).
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSize == NULL
//    ippStsBadArgErr         OIDAlgo > Max value for IppsXMSSAlgo
//    ippStsBadArgErr         OIDAlgo <= 0
//    ippStsNoErr             no errors
//
// Parameters:
//    pSize         pointer to the size
//    OIDAlgo       id of XMSS set of parameters (algorithm)
//
*F*/

IPPFUN(IppStatus, ippsXMSSSignatureStateGetSize,( Ipp32s* pSize, IppsXMSSAlgo OIDAlgo))
{
    IPP_BAD_PTR1_RET(pSize);
    IPP_BADARG_RET(OIDAlgo >  6, ippStsBadArgErr);
    IPP_BADARG_RET(OIDAlgo <= 0, ippStsBadArgErr);
    IppStatus status = ippStsNoErr;
    cpWOTSParams params;
    Ipp32s h = 0;
    status = setXMSSParams(OIDAlgo, &h, &params);
    Ipp32s n = params.n;
    Ipp32s len = params.len;

    *pSize = (Ipp32s)sizeof(IppsXMSSSignatureState) +
        /*r*/n +
        /*pOTSSign*/len * n +
        /*pAuthPath*/h * n;
    return status;
}

/*F*
//    Name: ippsXMSSPublicKeyStateGetSize
//
// Purpose: Get the XMSS public key state size (bytes).
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSize == NULL
//    ippStsBadArgErr         OIDAlgo > Max value for IppsXMSSAlgo
//    ippStsBadArgErr         OIDAlgo <= 0
//    ippStsNoErr             no errors
//
// Parameters:
//    pSize         pointer to the size
//    OIDAlgo       id of XMSS set of parameters (algorithm)
//
*F*/

IPPFUN(IppStatus, ippsXMSSPublicKeyStateGetSize,( Ipp32s* pSize, IppsXMSSAlgo OIDAlgo))
{
    IPP_BAD_PTR1_RET(pSize);
    IPP_BADARG_RET(OIDAlgo >  6, ippStsBadArgErr);
    IPP_BADARG_RET(OIDAlgo <= 0, ippStsBadArgErr);
    IppStatus status = ippStsNoErr;
    cpWOTSParams params;
    Ipp32s h = 0;
    status = setXMSSParams(OIDAlgo, &h, &params);
    Ipp32s n = params.n;

    *pSize = (Ipp32s)sizeof(IppsXMSSPublicKeyState) +
        /*pRoot*/n +
        /*pSeed*/n;
    return status;
}

/*F*
//    Name: ippsXMSSBufferGetSize
//
// Purpose: Get the XMSS temporary buffer size (bytes).
//
// Returns:                Reason:
//    ippStsNullPtrErr        pSize == NULL
//    ippStsBadArgErr         OIDAlgo > Max value for IppsXMSSAlgo
//    ippStsBadArgErr         OIDAlgo <= 0
//    ippStsLengthErr         maxMessageLength < 1
//    ippStsLengthErr         maxMessageLength > IPP_MAX_32S - (numTempBufs + len) * n
//    ippStsNoErr             no errors
//
// Parameters:
//    pSize             pointer to the size
//    maxMessageLength  maximum length of the message
//    OIDAlgo           id of XMSS set of parameters (algorithm)
//
*F*/

IPPFUN(IppStatus, ippsXMSSBufferGetSize,( Ipp32s* pSize, Ipp32s maxMessageLength, IppsXMSSAlgo OIDAlgo))
{
    IppStatus status = ippStsNoErr;

    IPP_BAD_PTR1_RET(pSize);
    IPP_BADARG_RET(OIDAlgo >  6, ippStsBadArgErr);
    IPP_BADARG_RET(OIDAlgo <= 0, ippStsBadArgErr);
    IPP_BADARG_RET(maxMessageLength < 1, ippStsLengthErr);

    /* Set XMSS parameters */
    Ipp32s h = 0;
    cpWOTSParams params;
    status = setXMSSParams(OIDAlgo, &h, &params);
    IPP_BADARG_RET((ippStsNoErr != status), status)

    const Ipp32s numTempBufs = 10;

    Ipp32s n = params.n;
    Ipp32s len = params.len;
    // this restriction is needed to avoid overflow of Ipp32s
    IPP_BADARG_RET(maxMessageLength > (Ipp32s)(IPP_MAX_32S) - (numTempBufs + len) * n, ippStsLengthErr);

    *pSize = (numTempBufs + len) * n + maxMessageLength;
    return status;
}
