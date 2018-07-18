/*******************************************************************************
* Copyright 2003-2018 Intel Corporation
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
//     ECC over Prime Finite Field (recommended ECC parameters)
// 
//  Contents:
//     secp112r1, secp112r2
//     secp128r1, secp128r2    (* Montgomery Friendly Modulus (+1) *)
//     secp160r1, secp160r2
//     secp192r1               (* Montgomery Friendly Modulus (+1) *)
//     secp224r1               (* Montgomery Friendly Modulus (-1) *)
//     secp256r1               (* Montgomery Friendly Modulus (+1) *)
//     secp384r1               (* Montgomery Friendly Modulus (0x0000000100000001) *)
//     secp521r1               (* Montgomery Friendly Modulus (+1) *)
//     tpm_BN_p256 (BN, TPM)
//     tpmSM2_p256_p (SM2)     (* Montgomery Friendly Modulus (+1) *)
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"

#include "pcpgfpstuff.h"

#if defined( _IPP_DATA )

/*
// Recommended Parameters secp112r1
*/
const BNU_CHUNK_T secp112r1_p[] = { // (2^128 -3)/76439
   LL(0xBEAD208B, 0x5E668076), LL(0x2ABF62E3, 0xDB7C)};
const BNU_CHUNK_T secp112r1_a[] = {
   LL(0xBEAD2088, 0x5E668076), LL(0x2ABF62E3, 0xDB7C)};
const BNU_CHUNK_T secp112r1_b[] = {
   LL(0x11702B22, 0x16EEDE89), LL(0xF8BA0439, 0x659E)};
const BNU_CHUNK_T secp112r1_gx[] = {
   LL(0xF9C2F098, 0x5EE76B55), LL(0x7239995A, 0x0948)};
const BNU_CHUNK_T secp112r1_gy[] = {
   LL(0x0FF77500, 0xC0A23E0E), LL(0xE5AF8724, 0xA89C)};
const BNU_CHUNK_T secp112r1_r[] = {
   LL(0xAC6561C5, 0x5E7628DF), LL(0x2ABF62E3, 0xDB7C)};
BNU_CHUNK_T secp112r1_h = 1;

/*
// Recommended Parameters secp112r2
*/
const BNU_CHUNK_T secp112r2_p[] = { // (2^128 -3)/76439
   LL(0xBEAD208B, 0x5E668076), LL(0x2ABF62E3, 0xDB7C)};
const BNU_CHUNK_T secp112r2_a[] = {
   LL(0x5C0EF02C, 0x8A0AAAF6), LL(0xC24C05F3, 0x6127)};
const BNU_CHUNK_T secp112r2_b[] = {
   LL(0x4C85D709, 0xED74FCC3), LL(0xF1815DB5, 0x51DE)};
const BNU_CHUNK_T secp112r2_gx[] = {
   LL(0xD0928643, 0xB4E1649D), LL(0x0AB5E892, 0x4BA3)};
const BNU_CHUNK_T secp112r2_gy[] = {
   LL(0x6E956E97, 0x3747DEF3), LL(0x46F5882E, 0xADCD)};
const BNU_CHUNK_T secp112r2_r[] = {
   LL(0x0520D04B, 0xD7597CA1), LL(0x0AAFD8B8, 0x36DF)};
BNU_CHUNK_T secp112r2_h = 4;

/*
// Recommended Parameters secp128r1
*/
const BNU_CHUNK_T h_secp128r1_p[] = { // halpf of secp128r1_p
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0x7FFFFFFE)};

const BNU_CHUNK_T secp128r1_p[] = { // 2^128 -2^97 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFD), LL(0, 0)};
const BNU_CHUNK_T secp128r1_a[] = {
   LL(0xFFFFFFFC, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFD)};
const BNU_CHUNK_T secp128r1_b[] = {
   LL(0x2CEE5ED3, 0xD824993C), LL(0x1079F43D, 0xE87579C1)};
const BNU_CHUNK_T secp128r1_gx[] = {
   LL(0xA52C5B86, 0x0C28607C), LL(0x8B899B2D, 0x161FF752)};
const BNU_CHUNK_T secp128r1_gy[] = {
   LL(0xDDED7A83, 0xC02DA292), LL(0x5BAFEB13, 0xCF5AC839)};
const BNU_CHUNK_T secp128r1_r[] = {
   LL(0x9038A115, 0x75A30D1B), LL(0x00000000, 0xFFFFFFFE)};
BNU_CHUNK_T secp128r1_h = 1;

/*
// Recommended Parameters secp128r2
*/
const BNU_CHUNK_T secp128r2_p[] = { // 2^128 -2^97 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFD), LL(0, 0)};
const BNU_CHUNK_T secp128r2_a[] = {
   LL(0xBFF9AEE1, 0xBF59CC9B), LL(0xD1B3BBFE, 0xD6031998)};
const BNU_CHUNK_T secp128r2_b[] = {
   LL(0xBB6D8A5D, 0xDC2C6558), LL(0x80D02919, 0x5EEEFCA3)};
const BNU_CHUNK_T secp128r2_gx[] = {
   LL(0xCDEBC140, 0xE6FB32A7), LL(0x5E572983, 0x7B6AA5D8)};
const BNU_CHUNK_T secp128r2_gy[] = {
   LL(0x5FC34B44, 0x7106FE80), LL(0x894D3AEE, 0x27B6916A)};
const BNU_CHUNK_T secp128r2_r[] = {
   LL(0x0613B5A3, 0xBE002472), LL(0x7FFFFFFF, 0x3FFFFFFF)};
BNU_CHUNK_T secp128r2_h = 4;

/*
// Recommended Parameters secp160r1
*/
const BNU_CHUNK_T secp160r1_p[] = { // 2^160 -2^31 -1
   LL(0x7FFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0xFFFFFFFF)};
const BNU_CHUNK_T secp160r1_a[] = {
   LL(0x7FFFFFFC, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0xFFFFFFFF)};
const BNU_CHUNK_T secp160r1_b[] = {
   LL(0xC565FA45, 0x81D4D4AD), LL(0x65ACF89F, 0x54BD7A8B), L_(0x1C97BEFC)};
const BNU_CHUNK_T secp160r1_gx[] = {
   LL(0x13CBFC82, 0x68C38BB9), LL(0x46646989, 0x8EF57328), L_(0x4A96B568)};
const BNU_CHUNK_T secp160r1_gy[] = {
   LL(0x7AC5FB32, 0x04235137), LL(0x59DCC912, 0x3168947D), L_(0x23A62855)};
const BNU_CHUNK_T secp160r1_r[] = {
   LL(0xCA752257, 0xF927AED3), LL(0x0001F4C8, 0x00000000), LL(0x00000000, 0x1)};
BNU_CHUNK_T secp160r1_h = 1;

/*
// Recommended Parameters secp160r2
*/
const BNU_CHUNK_T secp160r2_p[] = { // 2^160 -2^32 -2^14 -2^12 -2^9 -2^8 -2^7 -2^2 -1
   LL(0xFFFFAC73, 0xFFFFFFFE), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0xFFFFFFFF)};
const BNU_CHUNK_T secp160r2_a[] = {
   LL(0xFFFFAC70, 0xFFFFFFFE), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0xFFFFFFFF)};
const BNU_CHUNK_T secp160r2_b[] = {
   LL(0xF50388BA, 0x04664D5A), LL(0xAB572749, 0xFB59EB8B), L_(0xB4E134D3)};
const BNU_CHUNK_T secp160r2_gx[] = {
   LL(0x3144CE6D, 0x30F7199D), LL(0x1F4FF11B, 0x293A117E), L_(0x52DCB034)};
const BNU_CHUNK_T secp160r2_gy[] = {
   LL(0xA7D43F2E, 0xF9982CFE), LL(0xE071FA0D, 0xE331F296), L_(0xFEAFFEF2)};
const BNU_CHUNK_T secp160r2_r[] = {
   LL(0xF3A1A16B, 0xE786A818), LL(0x0000351E, 0x00000000), LL(0x00000000, 0x1)};
BNU_CHUNK_T secp160r2_h = 1;

/*
// Recommended Parameters secp192r1
*/
const BNU_CHUNK_T h_secp192r1_p[] = { // half of secp192r1_p
   LL(0xFFFFFFFF, 0x7FFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0x7FFFFFFF)};

const BNU_CHUNK_T secp192r1_p[] = { // 2^192 -2^64 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFE, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0x0, 0x0)};
const BNU_CHUNK_T secp192r1_a[] = {
   LL(0xFFFFFFFC, 0xFFFFFFFF), LL(0xFFFFFFFE, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF)};
const BNU_CHUNK_T secp192r1_b[] = {
   LL(0xC146B9B1, 0xFEB8DEEC), LL(0x72243049, 0x0FA7E9AB), LL(0xE59C80E7, 0x64210519)};
const BNU_CHUNK_T secp192r1_gx[] = {
   LL(0x82FF1012, 0xF4FF0AFD), LL(0x43A18800, 0x7CBF20EB), LL(0xB03090F6, 0x188DA80E)};
const BNU_CHUNK_T secp192r1_gy[] = {
   LL(0x1E794811, 0x73F977A1), LL(0x6B24CDD5, 0x631011ED), LL(0xFFC8DA78, 0x07192B95)};
const BNU_CHUNK_T secp192r1_r[] = {
   LL(0xB4D22831, 0x146BC9B1), LL(0x99DEF836, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF)};
BNU_CHUNK_T secp192r1_h = 1;

/*
// Recommended Parameters secp224r1
*/
const BNU_CHUNK_T h_secp224r1_p[] = { // half of secp224r1_p
   LL(0x00000000, 0x00000000), LL(0x80000000, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0x7FFFFFFF, 0x0)};

const BNU_CHUNK_T secp224r1_p[] = { // 2^224 -2^96 +1
   LL(0x00000001, 0x00000000), LL(0x00000000, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0x0)};
const BNU_CHUNK_T secp224r1_a[] = {
   LL(0xFFFFFFFE, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFE), LL(0xFFFFFFFF, 0xFFFFFFFF),
   L_(0xFFFFFFFF)};
const BNU_CHUNK_T secp224r1_b[] = {
   LL(0x2355FFB4, 0x270B3943), LL(0xD7BFD8BA, 0x5044B0B7), LL(0xF5413256, 0x0C04B3AB),
   L_(0xB4050A85)};
const BNU_CHUNK_T secp224r1_gx[] = {
   LL(0x115C1D21, 0x343280D6), LL(0x56C21122, 0x4A03C1D3), LL(0x321390B9, 0x6BB4BF7F),
   L_(0xB70E0CBD)};
const BNU_CHUNK_T secp224r1_gy[] = {
   LL(0x85007E34, 0x44D58199), LL(0x5A074764, 0xCD4375A0), LL(0x4C22DFE6, 0xB5F723FB),
   L_(0xBD376388)};
const BNU_CHUNK_T secp224r1_r[] = {
   LL(0x5C5C2A3D, 0x13DD2945), LL(0xE0B8F03E, 0xFFFF16A2), LL(0xFFFFFFFF, 0xFFFFFFFF),
   L_(0xFFFFFFFF)};
BNU_CHUNK_T secp224r1_h = 1;

/*
// Recommended Parameters secp256r1
*/
const BNU_CHUNK_T h_secp256r1_p[] = { // half of secp256r1_p
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0x7FFFFFFF, 0x00000000), LL(0x00000000, 0x80000000),
   LL(0x80000000, 0x7FFFFFFF)};

const BNU_CHUNK_T secp256r1_p[] = { // 2^256 -2^224 +2^192 +2^96 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0x00000000), LL(0x00000000, 0x00000000),
   LL(0x00000001, 0xFFFFFFFF), LL(0x0, 0x0)};
const BNU_CHUNK_T secp256r1_a[] = {
   LL(0xFFFFFFFC, 0xFFFFFFFF), LL(0xFFFFFFFF, 0x00000000), LL(0x00000000, 0x00000000),
   LL(0x00000001, 0xFFFFFFFF)};
const BNU_CHUNK_T secp256r1_b[] = {
   LL(0x27D2604B, 0x3BCE3C3E), LL(0xCC53B0F6, 0x651D06B0), LL(0x769886BC, 0xB3EBBD55),
   LL(0xAA3A93E7, 0x5AC635D8)};
const BNU_CHUNK_T secp256r1_gx[] = {
   LL(0xD898C296, 0xF4A13945), LL(0x2DEB33A0, 0x77037D81), LL(0x63A440F2, 0xF8BCE6E5),
   LL(0xE12C4247, 0x6B17D1F2)};
const BNU_CHUNK_T secp256r1_gy[] = {
   LL(0x37BF51F5, 0xCBB64068), LL(0x6B315ECE, 0x2BCE3357), LL(0x7C0F9E16, 0x8EE7EB4A),
   LL(0xFE1A7F9B, 0x4FE342E2)};
const BNU_CHUNK_T secp256r1_r[] = {
   LL(0xFC632551, 0xF3B9CAC2), LL(0xA7179E84, 0xBCE6FAAD), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0x00000000, 0xFFFFFFFF)};
BNU_CHUNK_T secp256r1_h = 1;

/*
// Recommended Parameters secp384r1
*/
const BNU_CHUNK_T h_secp384r1_p[] = { // half of secp384r1_p
   LL(0x7FFFFFFF, 0x00000000), LL(0x80000000, 0x7FFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0x7FFFFFFF)};

const BNU_CHUNK_T secp384r1_p[] = { // 2^384 -2^128 -2^96 +2^32 -1
   LL(0xFFFFFFFF, 0x00000000), LL(0x00000000, 0xFFFFFFFF), LL(0xFFFFFFFE, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0x0, 0x0)};
const BNU_CHUNK_T secp384r1_a[] = {
   LL(0xFFFFFFFC, 0x00000000), LL(0x00000000, 0xFFFFFFFF), LL(0xFFFFFFFE, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF)};
const BNU_CHUNK_T secp384r1_b[] = {
   LL(0xD3EC2AEF, 0x2A85C8ED), LL(0x8A2ED19D, 0xC656398D), LL(0x5013875A, 0x0314088F),
   LL(0xFE814112, 0x181D9C6E), LL(0xE3F82D19, 0x988E056B), LL(0xE23EE7E4, 0xB3312FA7)};
const BNU_CHUNK_T secp384r1_gx[] = {
   LL(0x72760AB7, 0x3A545E38), LL(0xBF55296C, 0x5502F25D), LL(0x82542A38, 0x59F741E0),
   LL(0x8BA79B98, 0x6E1D3B62), LL(0xF320AD74, 0x8EB1C71E), LL(0xBE8B0537, 0xAA87CA22)};
const BNU_CHUNK_T secp384r1_gy[] = {
   LL(0x90EA0E5F, 0x7A431D7C), LL(0x1D7E819D, 0x0A60B1CE), LL(0xB5F0B8C0, 0xE9DA3113),
   LL(0x289A147C, 0xF8F41DBD), LL(0x9292DC29, 0x5D9E98BF), LL(0x96262C6F, 0x3617DE4A)};
const BNU_CHUNK_T secp384r1_r[] = {
   LL(0xCCC52973, 0xECEC196A), LL(0x48B0A77A, 0x581A0DB2), LL(0xF4372DDF, 0xC7634D81),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF)};
BNU_CHUNK_T secp384r1_h = 1;

/*
// Recommended Parameters secp521r1
*/
const BNU_CHUNK_T h_secp521r1_p[] = { // half of secp521r1_p
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0x000000FF)};

const BNU_CHUNK_T secp521r1_p[] = { // 2^521 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0x000001FF)};
const BNU_CHUNK_T secp521r1_a[] = {
   LL(0xFFFFFFFC, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0x000001FF)};
const BNU_CHUNK_T secp521r1_b[] = {
   LL(0x6B503F00, 0xEF451FD4), LL(0x3D2C34F1, 0x3573DF88), LL(0x3BB1BF07, 0x1652C0BD),
   LL(0xEC7E937B, 0x56193951), LL(0x8EF109E1, 0xB8B48991), LL(0x99B315F3, 0xA2DA725B),
   LL(0xB68540EE, 0x929A21A0), LL(0x8E1C9A1F, 0x953EB961), L_(0x00000051)};
const BNU_CHUNK_T secp521r1_gx[] = {
   LL(0xC2E5BD66, 0xF97E7E31), LL(0x856A429B, 0x3348B3C1), LL(0xA2FFA8DE, 0xFE1DC127),
   LL(0xEFE75928, 0xA14B5E77), LL(0x6B4D3DBA, 0xF828AF60), LL(0x053FB521, 0x9C648139),
   LL(0x2395B442, 0x9E3ECB66), LL(0x0404E9CD, 0x858E06B7), L_(0x000000C6)};
const BNU_CHUNK_T secp521r1_gy[] = {
   LL(0x9FD16650, 0x88BE9476), LL(0xA272C240, 0x353C7086), LL(0x3FAD0761, 0xC550B901),
   LL(0x5EF42640, 0x97EE7299), LL(0x273E662C, 0x17AFBD17), LL(0x579B4468, 0x98F54449),
   LL(0x2C7D1BD9, 0x5C8A5FB4), LL(0x9A3BC004, 0x39296A78), L_(0x00000118)};
const BNU_CHUNK_T secp521r1_r[] = {
   LL(0x91386409, 0xBB6FB71E), LL(0x899C47AE, 0x3BB5C9B8), LL(0xF709A5D0, 0x7FCC0148),
   LL(0xBF2F966B, 0x51868783), LL(0xFFFFFFFA, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF),
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), L_(0x000001FF)};
BNU_CHUNK_T secp521r1_h = 1;

/*
// Recommended Parameters tpm_BN_p256 (Barreto-Naehrig)
*/
const BNU_CHUNK_T tpmBN_p256p_p[] = {
   LL(0xAED33013, 0xD3292DDB), LL(0x12980A82, 0x0CDC65FB), LL(0xEE71A49F, 0x46E5F25E),
   LL(0xFFFCF0CD, 0xFFFFFFFF)};
const BNU_CHUNK_T tpmBN_p256p_a[] = {
   LL(0, 0)};
const BNU_CHUNK_T tpmBN_p256p_b[] = {
   LL(3, 0)};
const BNU_CHUNK_T tpmBN_p256p_gx[] = {
   LL(1, 0)};
const BNU_CHUNK_T tpmBN_p256p_gy[] = {
   LL(2, 0)};
const BNU_CHUNK_T tpmBN_p256p_r[] = {
   LL(0xD10B500D, 0xF62D536C), LL(0x1299921A, 0x0CDC65FB), LL(0xEE71A49E, 0x46E5F25E),
   LL(0xFFFCF0CD, 0xFFFFFFFF)};
BNU_CHUNK_T tpmBN_p256p_h = 1;

/*
// Recommended Parameters tpm_SM2_p256
*/
#ifdef _SM2_SIGN_DEBUG_
const BNU_CHUNK_T tpmSM2_p256_p[] = {
   LL(0x08F1DFC3, 0x722EDB8B), LL(0x5C45517D, 0x45728391), LL(0xBF6FF7DE, 0xE8B92435), LL(0x4C044F18, 0x8542D69E), LL(0x0, 0x0)};
const BNU_CHUNK_T tpmSM2_p256_a[] = {
   LL(0x3937E498, 0xEC65228B), LL(0x6831D7E0, 0x2F3C848B), LL(0x73BBFEFF, 0x2417842E), LL(0xFA32C3FD, 0x787968B4)};
const BNU_CHUNK_T tpmSM2_p256_b[] = {
   LL(0x27C5249A, 0x6E12D1DA), LL(0xB16BA06E, 0xF61D59A5), LL(0x484BFE48, 0x9CF84241), LL(0xB23B0C84, 0x63E4C6D3)};
const BNU_CHUNK_T tpmSM2_p256_gx[] = {
   LL(0x7FEDD43D, 0x4C4E6C14), LL(0xADD50BDC, 0x32220B3B), LL(0xC3CC315E, 0x746434EB), LL(0x1B62EAB6, 0x421DEBD6)};
const BNU_CHUNK_T tpmSM2_p256_gy[] = {
   LL(0xE46E09A2, 0xA85841B9), LL(0xBFA36EA1, 0xE5D7FDFC), LL(0x153B70C4, 0xD47349D2), LL(0xCBB42C07, 0x0680512B)};
const BNU_CHUNK_T tpmSM2_p256_r[] = {
   LL(0xC32E79B7, 0x5AE74EE7), LL(0x0485628D, 0x29772063), LL(0xBF6FF7DD, 0xE8B92435), LL(0x4C044F18, 0x8542D69E)};
#else
const BNU_CHUNK_T h_tpmSM2_p256_p[] = { // half of tpmSM2_p256_p
   LL(0xFFFFFFFF, 0x7FFFFFFF), LL(0x80000000, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0x7FFFFFFF, 0x7FFFFFFF)};

const BNU_CHUNK_T tpmSM2_p256_p[] = { // 2^256 -2^224 -2^96 +2^64 -1
   LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0x00000000, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFE), LL(0x0, 0x0)};
const BNU_CHUNK_T tpmSM2_p256_a[] = {
   LL(0xFFFFFFFC, 0xFFFFFFFF), LL(0x00000000, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFE)};
const BNU_CHUNK_T tpmSM2_p256_b[] = {
   LL(0x4D940E93, 0xDDBCBD41), LL(0x15AB8F92, 0xF39789F5), LL(0xCF6509A7, 0x4D5A9E4B), LL(0x9D9F5E34, 0x28E9FA9E)};
const BNU_CHUNK_T tpmSM2_p256_gx[] = {
   LL(0x334C74C7, 0x715A4589), LL(0xF2660BE1, 0x8FE30BBF), LL(0x6A39C994, 0x5F990446), LL(0x1F198119, 0x32C4AE2C)};
const BNU_CHUNK_T tpmSM2_p256_gy[] = {
   LL(0x2139F0A0, 0x02DF32E5), LL(0xC62A4740, 0xD0A9877C), LL(0x6B692153, 0x59BDCEE3), LL(0xF4F6779C, 0xBC3736A2)};
const BNU_CHUNK_T tpmSM2_p256_r[] = {
   LL(0x39D54123, 0x53BBF409), LL(0x21C6052B, 0x7203DF6B), LL(0xFFFFFFFF, 0xFFFFFFFF), LL(0xFFFFFFFF, 0xFFFFFFFE)};
#endif
BNU_CHUNK_T tpmSM2_p256_h = 1;

#endif /* _IPP_DATA */
