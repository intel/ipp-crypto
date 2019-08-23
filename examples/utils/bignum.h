/*******************************************************************************
* Copyright 2019 Intel Corporation
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

#if !defined _BIGNUMBER_H_
#define _BIGNUMBER_H_

#include "ippcp.h"

#include <iostream>
#include <vector>
#include <iterator>

using namespace std;

class BigNumber
{
public:
   BigNumber(Ipp32u value=0);
   BigNumber(Ipp32s value);
   BigNumber(const IppsBigNumState* pBN);
   BigNumber(const Ipp32u* pData, int length=1, IppsBigNumSGN sgn=IppsBigNumPOS);
   BigNumber(const BigNumber& bn);
   BigNumber(const char *s);
   virtual ~BigNumber();

   // set value
   void Set(const Ipp32u* pData, int length=1, IppsBigNumSGN sgn=IppsBigNumPOS);
   // conversion to IppsBigNumState
   friend IppsBigNumState* BN(const BigNumber& bn) {return bn.m_pBN;}
   operator IppsBigNumState* () const { return m_pBN; }

   // some useful constatns
   static const BigNumber& Zero();
   static const BigNumber& One();
   static const BigNumber& Two();

   // arithmetic operators probably need
   BigNumber& operator = (const BigNumber& bn);
   BigNumber& operator += (const BigNumber& bn);
   BigNumber& operator -= (const BigNumber& bn);
   BigNumber& operator *= (Ipp32u n);
   BigNumber& operator *= (const BigNumber& bn);
   BigNumber& operator /= (const BigNumber& bn);
   BigNumber& operator %= (const BigNumber& bn);
   friend BigNumber operator + (const BigNumber& a, const BigNumber& b);
   friend BigNumber operator - (const BigNumber& a, const BigNumber& b);
   friend BigNumber operator * (const BigNumber& a, const BigNumber& b);
   friend BigNumber operator * (const BigNumber& a, Ipp32u);
   friend BigNumber operator % (const BigNumber& a, const BigNumber& b);
   friend BigNumber operator / (const BigNumber& a, const BigNumber& b);

   // modulo arithmetic
   BigNumber Modulo(const BigNumber& a) const;
   BigNumber ModAdd(const BigNumber& a, const BigNumber& b) const;
   BigNumber ModSub(const BigNumber& a, const BigNumber& b) const;
   BigNumber ModMul(const BigNumber& a, const BigNumber& b) const;
   BigNumber InverseAdd(const BigNumber& a) const;
   BigNumber InverseMul(const BigNumber& a) const;

   // comparisons
   friend bool operator < (const BigNumber& a, const BigNumber& b);
   friend bool operator > (const BigNumber& a, const BigNumber& b);
   friend bool operator == (const BigNumber& a, const BigNumber& b);
   friend bool operator != (const BigNumber& a, const BigNumber& b);
   friend bool operator <= (const BigNumber& a, const BigNumber& b) {return !(a>b);}
   friend bool operator >= (const BigNumber& a, const BigNumber& b) {return !(a<b);}

   // easy tests
   bool IsOdd() const;
   bool IsEven() const { return !IsOdd(); }

   // size of BigNumber
   int MSB() const;
   int LSB() const;
   int BitSize() const { return MSB()+1; }
   int DwordSize() const { return (BitSize()+31)>>5;}
   friend int Bit(const vector<Ipp32u>& v, int n);

   // conversion and output
   void num2hex( string& s ) const; // convert to hex string
   void num2vec( vector<Ipp32u>& v ) const; // convert to 32-bit word vector
   friend ostream& operator << (ostream& os, const BigNumber& a);

protected:
   bool create(const Ipp32u* pData, int length, IppsBigNumSGN sgn=IppsBigNumPOS);
   int compare(const BigNumber& ) const;
   IppsBigNumState* m_pBN;
};

// convert bit size into 32-bit words
#define BITSIZE_WORD(n) ((((n)+31)>>5))

#endif // _BIGNUMBER_H_
