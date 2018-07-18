/*******************************************************************************
* Copyright 2005-2018 Intel Corporation
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
//   Purpose:
//     Define ippCP variant
// 
// 
*/

#if !defined(_CP_VARIANT_H)
#define _CP_VARIANT_H

/*
// set _AES_NI_ENABLING_
*/
#if defined _IPP_AES_NI_
   #if (_IPP_AES_NI_ == 0)
      #define _AES_NI_ENABLING_  _FEATURE_OFF_
   #elif  (_IPP_AES_NI_ == 1)
      #define _AES_NI_ENABLING_  _FEATURE_ON_
   #else
      #error Define _IPP_AES_NI_=0 or 1 or omit _IPP_AES_NI_ at all
   #endif
#else
   #if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
      #define _AES_NI_ENABLING_  _FEATURE_TICKTOCK_
   #else
      #define _AES_NI_ENABLING_  _FEATURE_OFF_
   #endif
#endif

/*
// select AES safe implementation
*/
#define _ALG_AES_SAFE_COMPACT_SBOX_ (1)
#define _ALG_AES_SAFE_COMPOSITE_GF_ (2)

#if (_AES_NI_ENABLING_==_FEATURE_ON_)
   #define _ALG_AES_SAFE_   _FEATURE_OFF_
#else
   #if (_IPP>=_IPP_V8) || (_IPP32E>=_IPP32E_U8)
      #define _ALG_AES_SAFE_   _ALG_AES_SAFE_COMPOSITE_GF_
   #else
      #define _ALG_AES_SAFE_   _ALG_AES_SAFE_COMPACT_SBOX_
      //#define _ALG_AES_SAFE_   _ALG_AES_SAFE_COMPOSITE_GF_
   #endif
#endif


/*
// if there is no outside assignment
// set _SHA_NI_ENABLING_ based on CPU specification
*/
#if !defined(_SHA_NI_ENABLING_)
#if (_IPP>=_IPP_P8) || (_IPP32E>=_IPP32E_Y8)
   #define _SHA_NI_ENABLING_  _FEATURE_TICKTOCK_
#else
   #define _SHA_NI_ENABLING_  _FEATURE_OFF_
#endif
#endif

/*
// set/reset _ADCOX_NI_ENABLING_
*/
#if (_IPP32E>=_IPP32E_L9)
   #if !defined(_ADCOX_NI_ENABLING_)
      #define _ADCOX_NI_ENABLING_  _FEATURE_TICKTOCK_
   #endif
#else
   #undef  _ADCOX_NI_ENABLING_
   #define _ADCOX_NI_ENABLING_  _FEATURE_OFF_
#endif

/*
// Intel(R) Integrated Performance Primitives (Intel(R) IPP) supports several hash algorithms by default:
//    SHA-1
//    SHA-256
//    SHA-224  (or SHA256/224 by the FIPS180-4 classification)
//    SHA-512
//    SHA-384  (or SHA512/384 by the FIPS180-4 classification)
//    MD5
//    SM3
//
// By default all hash algorithms are included in Intel(R) IPP Crypto.
//
// If one need excludes code of particular hash, just define
// suitable _DISABLE_ALG_XXX, where XXX name of the hash algorithm
//
*/
#if !defined(_DISABLE_ALG_SHA1_)
#define _ENABLE_ALG_SHA1_          /* SHA1        on  */
#else
#  undef  _ENABLE_ALG_SHA1_        /* SHA1        off */
#endif

#if !defined(_DISABLE_ALG_SHA256_)
#  define _ENABLE_ALG_SHA256_      /* SHA256      on  */
#else
#  undef  _ENABLE_ALG_SHA256_      /* SHA256      off */
#endif

#if !defined(_DISABLE_ALG_SHA224_)
#  define _ENABLE_ALG_SHA224_      /* SHA224      on  */
#else
#  undef  _ENABLE_ALG_SHA224_      /* SHA224      off */
#endif

#if !defined(_DISABLE_ALG_SHA512_)
#  define _ENABLE_ALG_SHA512_      /* SHA512      on  */
#else
#  undef  _ENABLE_ALG_SHA512_      /* SHA512      off */
#endif

#if !defined(_DISABLE_ALG_SHA384_)
#  define _ENABLE_ALG_SHA384_      /* SHA384      on  */
#else
#  undef  _ENABLE_ALG_SHA384_      /* SHA384      off */
#endif

#if !defined(_DISABLE_ALG_SHA512_224_)
#  define _ENABLE_ALG_SHA512_224_  /* SHA512/224  on  */
#else
#  undef  _ENABLE_ALG_SHA512_224_  /* SHA512/224  off */
#endif

#if !defined(_DISABLE_ALG_SHA512_256_)
#  define _ENABLE_ALG_SHA512_256_  /* SHA512/256  on  */
#else
#  undef  _ENABLE_ALG_SHA512_256_  /* SHA512/256  off */
#endif

#if !defined(_DISABLE_ALG_MD5_)
#  define _ENABLE_ALG_MD5_         /* MD5         on  */
#else
#  undef  _ENABLE_ALG_MD5_         /* MD5         off */
#endif

#if !defined(_DISABLE_ALG_SM3_)
#  define _ENABLE_ALG_SM3_         /* SM3         on  */
#else
#  undef  _ENABLE_ALG_SM3_         /* SM3         off */
#endif

/*
// SHA1 plays especial role in Intel(R) IPP. Thus Intel(R) IPP random generator
// and therefore prime number generator are based on SHA1.
// So, do no exclude SHA1 from the active list of hash algorithms
*/
#if defined(_DISABLE_ALG_SHA1_)
#undef _DISABLE_ALG_SHA1_
#endif

/*
// Because of performane reason hash algorithms are implemented in form
// of unroller cycle and therefore these implementations are big enough.
// Intel(R) IPP supports "compact" implementation of some basic hash algorithms:
//    SHA-1
//    SHA-256
//    SHA-512
//    SM3
//
// Define any
//    _ALG_SHA1_COMPACT_
//    _ALG_SHA256_COMPACT_
//    _ALG_SHA512_COMPACT_
//    _ALG_SM3_COMPACT_
//
// to select "compact" implementation of particular hash algorithm.
// Intel(R) IPP does not define "compact" implementation by default.
//
// Don't know what performance degradation leads "compact"
// in comparison with default Intel(R) IPP implementation.
//
// Note: the definition like _ALG_XXX_COMPACT_ has effect
// if and only if Intel(R) IPP instance is _PX or _MX
*/
//#define _ALG_SHA1_COMPACT_
//#define _ALG_SHA256_COMPACT_
//#define _ALG_SHA512_COMPACT_
//#define _ALG_SM3_COMPACT_
//#undef _ALG_SHA1_COMPACT_
//#undef _ALG_SHA256_COMPACT_
//#undef _ALG_SHA512_COMPACT_
//#undef _ALG_SM3_COMPACT_


/*
// BN arithmetic:
//    - do/don't use special implementation of sqr instead of usual multication
//    - do/don't use Karatsuba multiplication alg
*/
#define _USE_SQR_          /*     use implementaton of sqr */
#if !defined(_DISABLE_WINDOW_EXP_)
   #define _USE_WINDOW_EXP_   /*     use fixed window exponentiation */
#endif


/*
// RSA:
//    - do/don't use version 1 style mitigation of CBA
//    - do/don't use own style mitigation of CBA
//    - do/don't use Folding technique for RSA-1204 implementation
*/
#define xUSE_VERSION1_CBA_MITIGATION_   /* not use (version 1)  mitigation of CBA */
#define _USE_IPP_OWN_CBA_MITIGATION_    /*     use (own) mitigation of CBA */
#define xUSE_FOLD_MONT512_              /*     use folding technique in RSA-1024 case */


/*
// Intel(R) IPP supports different implementation of NIST's (standard) EC over GF(0):
//    P-128 (IppECCPStd128r1, IppECCPStd128r2)
//    P-192 (IppECCPStd192r1)
//    P-224 (IppECCPStd224r1)
//    P-256 (IppECCPStd256r1)
//    P-384 (IppECCPStd384r1)
//    P-521 (IppECCPStd521r1)
//
// If one need replace the particular implementation by abritrary one
// assign _ECP_IMP_ARBIRTRARY_ to suitable symbol
//
// _ECP_IMPL_ARBIRTRARY_   means that implementtaion does not use any curve specific,
//                         provide the same (single) code for any type curve
//
// _ECP_IMPL_SPECIFIC_     means that implementation uses specific modular reduction
//                         based on prime structure;
//                         most of NIST's cures (p128, p192, p224, p256, p384, p521) are uses
//                         such kind of reduction procedure;
//                         in contrast with _ECP_IMPL_ARBIRTRARY_ and _ECP_IMPL_MFM_
//                         this type of implementation uses point representation in REGULAR residual
//                         (not Montgometry!!) domain
//
// _ECP_IMPL_MFM_          means that implementation uses "Montgomary Friendly Modulus" (primes);
//                         p256 and sm2 are using such kind of optimization
*/
#define _ECP_IMPL_NONE_        0
#define _ECP_IMPL_ARBIRTRARY_  1
#define _ECP_IMPL_SPECIFIC_    2
#define _ECP_IMPL_MFM_         3

#if !defined(_ECP_112R1_)
#if !defined(_DISABLE_ECP_112R1_)
#  define _ECP_112R1_    _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_112R1_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_112R2_)
#if !defined(_DISABLE_ECP_112R2_)
#  define _ECP_112R2_    _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_112R2_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_160R1_)
#if !defined(_DISABLE_ECP_160R1_)
#  define _ECP_160R1_    _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_160R1_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_160R2_)
#if !defined(_DISABLE_ECP_160R2_)
#  define _ECP_160R2_    _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_160R2_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_128R1_)
#if !defined(_DISABLE_ECP_128R1_)
#  define _ECP_128R1_    _ECP_IMPL_SPECIFIC_
#else
#  define _ECP_128R1_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_128R2_)
#if !defined(_DISABLE_ECP_128R2_)
#  define _ECP_128R2_    _ECP_IMPL_SPECIFIC_
#else
#  define _ECP_128R2_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_192_)
#if !defined(_DISABLE_ECP_192_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_192_    _ECP_IMPL_MFM_
#  else
#     define _ECP_192_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_192_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_224_)
#if !defined(_DISABLE_ECP_224_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_224_    _ECP_IMPL_MFM_
#  else
#     define _ECP_224_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_224_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_256_)
#if !defined(_DISABLE_ECP_256_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_256_    _ECP_IMPL_MFM_
#  else
#     define _ECP_256_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_256_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_384_)
#if !defined(_DISABLE_ECP_384_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_384_    _ECP_IMPL_MFM_
#  else
#     define _ECP_384_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_384_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_521_)
#if !defined(_DISABLE_ECP_521_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_521_    _ECP_IMPL_MFM_
#  else
#     define _ECP_521_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_521_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_SM2_)
#if !defined(_DISABLE_ECP_SM2_)
#  if (_IPP32E >= _IPP32E_M7) || (_IPP >= _IPP_P8)
#     define _ECP_SM2_    _ECP_IMPL_MFM_
#  else
#     define _ECP_SM2_    _ECP_IMPL_SPECIFIC_
#  endif
#else
#  define _ECP_SM2_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_ECP_BN_)
#if !defined(_DISABLE_ECP_BN_)
#  define _ECP_BN_    _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_BN_    _ECP_IMPL_NONE_
#endif
#endif

#if !defined(_DISABLE_ECP_GENERAL_)
#  define _ECP_GENERAL_ _ECP_IMPL_ARBIRTRARY_
#else
#  define _ECP_GENERAL_ _ECP_IMPL_NONE_
#endif


/*
// EC over GF(p):
//    - do/don't use mitigation of CBA
*/
#define _USE_ECCP_SSCM_             /*     use SSCM ECCP */


#if defined ( _OPENMP )
#define DEFAULT_CPU_NUM    (8)

#define     BF_MIN_BLK_PER_THREAD (32)
#define     TF_MIN_BLK_PER_THREAD (16)

#define    DES_MIN_BLK_PER_THREAD (32)
#define   TDES_MIN_BLK_PER_THREAD (16)

#define  RC5_64_MIN_BLK_PER_THREAD (16)
#define RC5_128_MIN_BLK_PER_THREAD (32)

#define RIJ128_MIN_BLK_PER_THREAD (32)
#define RIJ192_MIN_BLK_PER_THREAD (16)
#define RIJ256_MIN_BLK_PER_THREAD (16)

#define AESNI128_MIN_BLK_PER_THREAD (256)
#endif

#endif /* _CP_VARIANT_H */
