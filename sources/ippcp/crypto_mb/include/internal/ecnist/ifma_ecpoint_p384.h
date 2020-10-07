/*******************************************************************************
* Copyright 2002-2020 Intel Corporation
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

#ifndef IFMA_ECPOINT_P384_H
#define IFMA_ECPOINT_P384_H

#include <internal/ecnist/ifma_arith_p384.h>

typedef struct {
   U64 X[P384_LEN52];
   U64 Y[P384_LEN52];
   U64 Z[P384_LEN52];
} P384_POINT;

typedef struct {
   U64 x[P384_LEN52];
   U64 y[P384_LEN52];
} P384_POINT_AFFINE;

typedef struct {
   int64u x[P384_LEN52];
   int64u y[P384_LEN52];
} SINGLE_P384_POINT_AFFINE;



/* check if coodinate is zero */
__INLINE __mb_mask MB_FUNC_NAME(is_zero_point_cordinate_)(const U64 T[])
{
   return MB_FUNC_NAME(is_zero_FE384_)(T);
}

/* set point to infinity */
__INLINE void MB_FUNC_NAME(set_point_to_infinity_)(P384_POINT* r)
{
   r->X[0] = r->X[1] = r->X[2] = r->X[3] = r->X[4] = r->X[5] = r->X[6] = r->X[7] = get_zero64();
   r->Y[0] = r->Y[1] = r->Y[2] = r->Y[3] = r->Y[4] = r->Y[5] = r->Y[6] = r->Y[7] = get_zero64();
   r->Z[0] = r->Z[1] = r->Z[2] = r->Z[3] = r->Z[4] = r->Z[5] = r->Z[6] = r->Z[7] = get_zero64();
}

/* set affine point to infinity */
__INLINE void MB_FUNC_NAME(set_point_affine_to_infonity_)(P384_POINT_AFFINE* r)
{
   r->x[0] = r->x[1] = r->x[2] = r->x[3] = r->x[4] = r->x[5] = r->x[6] = r->x[7] = get_zero64();
   r->y[0] = r->y[1] = r->y[2] = r->y[3] = r->y[4] = r->y[5] = r->y[6] = r->y[7] = get_zero64();
}

EXTERN_C void MB_FUNC_NAME(ifma_ec_nistp384_dbl_point_)(P384_POINT* r, const P384_POINT* p);
EXTERN_C void MB_FUNC_NAME(ifma_ec_nistp384_add_point_)(P384_POINT* r, const P384_POINT* p, const P384_POINT* q);
EXTERN_C void MB_FUNC_NAME(ifma_ec_nistp384_add_point_affine_)(P384_POINT* r, const P384_POINT* p, const P384_POINT_AFFINE* q);
EXTERN_C void MB_FUNC_NAME(ifma_ec_nistp384_mul_point_)(P384_POINT* r, const P384_POINT* p, const U64* scalar);
EXTERN_C void MB_FUNC_NAME(ifma_ec_nistp384_mul_pointbase_)(P384_POINT* r, const U64* scalar);
EXTERN_C void MB_FUNC_NAME(get_nistp384_ec_projective_coords_)(U64 x[], U64 y[], const P384_POINT* P);
EXTERN_C const U64* MB_FUNC_NAME(ifma_ec_nistp384_coord_one_)(void);

#endif  /* IFMA_ECPOINT_P384_H */
