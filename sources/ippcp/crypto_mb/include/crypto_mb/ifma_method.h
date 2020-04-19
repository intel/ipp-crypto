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

#ifndef IFMA_METHODS_H
#define IFMA_METHODS_H

#include "ifma_internal_method.h"

//typedef struct _ifma_rsa_method_rsa ifma_RSA_Method;

/*
// cp methods
*/

/* rsa public key opertaion */
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA1K_pub65537_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA2K_pub65537_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA3K_pub65537_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA4K_pub65537_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA_pub65537_Method(int rsaBitsize);

/* rsa private key opertaion */
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA1K_private_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA2K_private_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA3K_private_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA4K_private_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA_private_Method(int rsaBitsize);

/* rsa private key opertaion (ctr) */
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA1K_private_ctr_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA2K_private_ctr_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA3K_private_ctr_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA4K_private_ctr_Method(void);
EXTERN_C const ifma_RSA_Method* ifma_cp_RSA_private_ctr_Method(int rsaBitsize);

EXTERN_C int ifma_RSA_Method_BufSize(const ifma_RSA_Method* m);

#endif /* IFMA_METHODS_H */
