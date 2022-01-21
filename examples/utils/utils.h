/*******************************************************************************
* Copyright 2021 Intel Corporation
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
#ifndef _UTILS_H_
#define _UTILS_H_

#include <stddef.h>

#define RSIZE_MAX_STR (4UL << 10) /* 4Kb */

/**
 * \brief 
 * The strnlen_s function computes the length of the string pointed to by dest.
 * \param[in] dest pointer to string
 * \param[in] dmax restricted maximum length. (default 4Kb)
 * \return size_t 
 * The function returns the string length, excluding  the terminating
 * null character.  If dest is NULL, then strnlen_s returns 0.
 */
size_t strlen_safe(const char* dest, size_t dmax = RSIZE_MAX_STR);

#endif // _UTILS_H_
