/*******************************************************************************
* Copyright 2017-2021 Intel Corporation
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

#include "owndefs.h"

#if (_IPP32E >= _IPP32E_K1)

#include "ecnist/ifma_arith_method.h"
#include "ecnist/ifma_arith_p384.h"

IPP_OWN_DEFN(ifmaArithMethod *, gsArithGF_p384r1_avx512, (void))
{
   static ifmaArithMethod m = {
      convert_radix_to_52x8,
      convert_radix_to_64x6,
      ifma_tomont52_p384,
      ifma_frommont52_p384,
      ifma_amm52_p384,
      ifma_amm52_dual_p384,
      ifma_ams52_p384,
      ifma_ams52_dual_p384,
      ifma_norm52_p384,
      ifma_norm52_dual_p384,
      ifma_lnorm52_p384,
      ifma_lnorm52_dual_p384,
      0,
      ifma_neg52_p384,
      ifma_half52_p384,
      ifma_aminv52_p384,
      0
   };

   return &m;
}

#endif /* #if (_IPP32E >= _IPP32E_K1) */
