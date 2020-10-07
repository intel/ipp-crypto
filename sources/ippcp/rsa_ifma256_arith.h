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

#ifndef _RSA_IFMA256_ARITH_H_
#define _RSA_IFMA256_ARITH_H_

#include "owncp.h"

#if(_IPP32E>=_IPP32E_K0)

#define IFMA_PAD_L 0
#define IFMA_PAD_R 0
#define LEN52_20 (IFMA_PAD_L + 20 + IFMA_PAD_R)

#define SIMD_LEN 256
#include "internal/common/ifma_math.h"

/* Single Exponentiation kernels */
#define AMM52x20_v4_256 OWNAPI(AMM52x20_v4_256)
  IPP_OWN_DECL(void, AMM52x20_v4_256, (int64u out[LEN52_20],
                                 const int64u a  [LEN52_20],
                                 const int64u b  [LEN52_20],
                                 const int64u m  [LEN52_20],
                                       int64u k0))

#define AMS52x20_v4_256 OWNAPI(AMS52x20_v4_256)
  IPP_OWN_DECL(void, AMS52x20_v4_256, (int64u out[LEN52_20],
                                 const int64u a[LEN52_20],
                                 const int64u m[LEN52_20],
                                       int64u k0))


/* Dual Exponentiation kernels */
#define AMM2x52x20_S_256 OWNAPI(AMM2x52x20_S_256)
  IPP_OWN_DECL(void, AMM2x52x20_S_256, (int64u out[2][LEN52_20],
                                  const int64u a  [2][LEN52_20],
                                  const int64u b  [2][LEN52_20],
                                  const int64u m  [2][LEN52_20],
                                  const int64u k0 [2]))

#define AMS2x52x20_v4_256 OWNAPI(AMS2x52x20_v4_256)
  IPP_OWN_DECL(void, AMS2x52x20_v4_256, (int64u out[2][LEN52_20],
                                   const int64u a[2][LEN52_20],
                                   const int64u m[2][LEN52_20], const int64u k0[2]))

#define AMS5x2x52x20_v4_256 OWNAPI(AMS5x2x52x20_v4_256)
  IPP_OWN_DECL(void, AMS5x2x52x20_v4_256, (int64u out[2][LEN52_20],
                                     const int64u a[2][LEN52_20],
                                     const int64u m[2][LEN52_20],
                                     const int64u k0[2]))

#define AMS5x2x52x20_Select_256 OWNAPI(AMS5x2x52x20_Select_256)
  IPP_OWN_DECL(void, AMS5x2x52x20_Select_256, (int64u out[2][LEN52_20],
                                         const int64u a  [2][LEN52_20],
                                         const int64u m  [2][LEN52_20],
                                         const int64u k0 [2],
                                               int64u red_Y        [2][LEN52_20],
                                         const int64u red_table    [2][1U << 5U][LEN52_20],
                                               int    red_table_idx[2]))

#endif // #if(_IPP32E>=_IPP32E_K0)
#endif // #ifndef _RSA_IFMA256_ARITH_H_
