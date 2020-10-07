 /*******************************************************************************
 * Copyright 2019-2020 Intel Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

#ifndef _RSA_IFMA256_H_
#define _RSA_IFMA256_H_

#include "owncp.h"

#if(_IPP32E>=_IPP32E_K0)

#include "rsa_ifma256_arith.h"

#define EXP52x20 OWNAPI(EXP52x20)
  IPP_OWN_DECL (void, EXP52x20, (Ipp64u *out,
                           const Ipp64u *base,
                           const Ipp64u *exp,
                           const Ipp64u *modulus,
                           const Ipp64u *toMont,
                           const Ipp64u k0))

#define DEXP52x20 OWNAPI(DEXP52x20)
  IPP_OWN_DECL (void, DEXP52x20, (int64u out[2][LEN52_20],
                            const int64u base[2][LEN52_20],
                            const int64u *exp[2], // 2x16
                            const int64u modulus[2][LEN52_20],
                            const int64u toMont[2][LEN52_20],
                            const int64u k0[2]))

#endif // #if(_IPP32E>=_IPP32E_K0)
#endif // #ifndef _RSA_IFMA256_H_
