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
//     Internal ECC (prime) Resource List Function
// 
// 
*/

#include "owndefs.h"
#include "owncp.h"
#include "pcpbnresource.h"
#include "pcpbn.h"



/*F*
//    Name: cpBigNumListGetSize
//
// Purpose: Size of BigNum List Buffer
//
// Returns:
//    Size of List Buffer
//
// Parameters:
//    feBitSize size in bits
//    nodes     number of nodes
//
*F*/

int cpBigNumListGetSize(int feBitSize, int nodes)
{
   /* size of buffer per single big number */
   int bnSize;
   ippsBigNumGetSize(BITS2WORD32_SIZE(feBitSize), &bnSize);

   /* size of buffer for whole list */
   return (ALIGN_VAL-1) + (sizeof(BigNumNode) + bnSize) * nodes;
}

/*F*
//    Name: cpBigNumListInit
//
// Purpose: Init list
//
//
// Parameters:
//    feBitSize size in bit
//    nodes     number of nodes
//    pList     pointer to list
//
// Note: buffer for BN list must have appropriate alignment
//
*F*/
void cpBigNumListInit(int feBitSize, int nodes, BigNumNode* pList)
{
   int itemSize;
   /* length of Big Num */
   int bnLen = BITS2WORD32_SIZE(feBitSize);
   /* size of buffer per single big number */
   ippsBigNumGetSize(bnLen, &itemSize);
   /* size of list item */
   itemSize += sizeof(BigNumNode);

   {
      int n;
      /* init all nodes */
      BigNumNode* pNode = (BigNumNode*)( (Ipp8u*)pList + (nodes-1)*itemSize );
      BigNumNode* pNext = NULL;
      for(n=0; n<nodes; n++) {
         Ipp8u* tbnPtr = (Ipp8u*)pNode + sizeof(BigNumNode);
         pNode->pNext = pNext;
         pNode->pBN = (IppsBigNumState*)( IPP_ALIGNED_PTR(tbnPtr, ALIGN_VAL) );
         ippsBigNumInit(bnLen, pNode->pBN);
         pNext = pNode;
         pNode = (BigNumNode*)( (Ipp8u*)pNode - itemSize);
      }
   }
}


/*F*
//    Name: cpBigNumListGet
//
// Purpose: Get BigNum reference
//
// Returns:
//    BigNum reference
//
// Parameters:
//    ppList pointer to pointer to List
//
*F*/

IppsBigNumState* cpBigNumListGet(BigNumNode** ppList)
{
   if(*ppList) {
      IppsBigNumState* ret = (*ppList)->pBN;
      *ppList = (*ppList)->pNext;
      return ret;
   }
   else
      return NULL;
}
