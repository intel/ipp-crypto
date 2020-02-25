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

/*!
 *
 *  \file
 *
 *  \brief RSA multi buffer encryption and decryption algorithms usage example.
 *
 *  This example demonstrates message encryption and decryption according to
 *  RSA algorithm with 1024-bit RSA modulus.
 *  It shows a possible way to process a queue of encryption requests on one 
 *  host and decryption requests on another.
 *
 *  The RSA encryption and decryption algorithms are implemented according to the PKCS#1 v2.1: RSA Cryptography Standard (June 2002),
 *  available at:
 *
 *  https://tools.ietf.org/html/rfc3447.
 *
 */

#include <cstring>
#include <cstdlib>

#include "ippcp.h"
#include "examples_common.h"
#include "bignum.h"
#include "rsa_mb_data.h"
#include "requests.h"

/*! Check compatibility of encryption requests */
static bool CheckEncRequestsCompatibility(Request* request1, Request* request2) {
    bool compatibilityStatus = (request1->GetValueE() == request2->GetValueE()) && (request1->GetBitSizeN() == request2->GetBitSizeN());

    return compatibilityStatus;
}

/*! Check compatibility of decryption requests */
static bool CheckDecRequestsCompatibility(Request* request1, Request* request2) {
    bool compatibilityStatus = request1->GetBitSizeN() == request2->GetBitSizeN();
   
    return compatibilityStatus;
}

/*! Check matching of the private key types */
static bool CheckPrivateKeyCompatibility(IppsRSAPrivateKeyState* pPrivKey1, IppsRSAPrivateKeyState* pPrivKey2) {
    /* Inside ippsRSA_GetPrivateKeyType1 and ippsRSA_GetPrivateKeyType2 there is a check of the pPrivKey type */
    bool isMatched = (ippsRSA_GetPrivateKeyType1(NULL, NULL, pPrivKey1) == ippStsNoErr) &&
                    (ippsRSA_GetPrivateKeyType1(NULL, NULL, pPrivKey2) == ippStsNoErr);

    /* Check for belonging to the Type2 only if the type of both keys is not Type1 */
    if(!isMatched)
        isMatched = (ippsRSA_GetPrivateKeyType2(NULL, NULL, NULL, NULL, NULL, pPrivKey1) == ippStsNoErr) &&
                   (ippsRSA_GetPrivateKeyType2(NULL, NULL, NULL, NULL, NULL, pPrivKey2) == ippStsNoErr);

    return isMatched;
}


/*! Main function */
int main(void)
{
    /* The queue of requests, NUMBER_OF_REQUESTS may not be a multiple of eight */
    Request* requestQueue[NUMBER_OF_REQUESTS];

    /* Forming the request queue from pre-generated data */
    int randomIndex;
    for (int queueIndex = 0; queueIndex < NUMBER_OF_REQUESTS; queueIndex++)
    {
        randomIndex = rand() % (NUMBER_OF_CRYPTOSYSTEMS);
        requestQueue[queueIndex] = new Request(plainTextArray[randomIndex], moduloArray[randomIndex], E, privateExpArray[randomIndex]);
    }

    /* Internal function status and array of statuses for each buffer */
    IppStatus status = ippStsNoErr;
    IppStatus statusesArray[NUMBER_OF_BUFFERS];

    /* Size in bits of RSA modulus, public and private exponent */
    int bitSizeN, bitSizeE, bitSizeD;
    int bufferIndex = 0;

    /* Arrays of eight pointers to public and private keys, plain texts, ciphertexts and deciphertexts */
    IppsRSAPublicKeyState* pPubKey[NUMBER_OF_BUFFERS];
    IppsRSAPrivateKeyState* pPrivKey[NUMBER_OF_BUFFERS];
    IppsBigNumState* mbPlainTextArray[NUMBER_OF_BUFFERS];
    IppsBigNumState* mbCipherTextArray[NUMBER_OF_BUFFERS];
    IppsBigNumState* mbDecipherTextArray[NUMBER_OF_BUFFERS];

    /* 
     *  This loop emulates batch encryption performed on the first host with processing requests from arbitrary queue.
     *  The idea is to accumulate eight compatible requests from the requests queue and call single encryption operation 
     *  for all eight using ippsRSA_MB_Encrypt. The tail with less than eight requests is handled separately. 
     */

    for (int queueIndex = 0; queueIndex < NUMBER_OF_REQUESTS; queueIndex++)
    {
        /* These values should be the same for all eight buffers */
        bitSizeN = requestQueue[queueIndex]->GetBitSizeN();
        bitSizeE = E.BitSize();
        
        /* Check encryption requests compatibility of each eight buffers, if the request is incompatible take another request */
        if (bufferIndex > 0 && !CheckEncRequestsCompatibility(requestQueue[queueIndex - 1], requestQueue[queueIndex]))
        {
            requestQueue[queueIndex]->SetCompatibilityStatus(false);
            continue;
        }
        
        /* Allocate memory for public key */
        int keySize = 0;
        ippsRSA_GetSizePublicKey(bitSizeN, bitSizeE, &keySize);
        pPubKey[bufferIndex] = (IppsRSAPublicKeyState*)(new Ipp8u[keySize]);

        /* Prepare key to operation */
        ippsRSA_InitPublicKey(bitSizeN, bitSizeE, pPubKey[bufferIndex], keySize);
        ippsRSA_SetPublicKey(requestQueue[queueIndex]->GetValueN(), E, pPubKey[bufferIndex]);

        /* Forming the array of plain and cipher texts */
        mbCipherTextArray[bufferIndex] = requestQueue[queueIndex]->GetCipherText();
        mbPlainTextArray[bufferIndex] = requestQueue[queueIndex]->GetPlainText();
        
        bufferIndex++;

        /* Handling the case when the number of requests in the queue is not a multiple of eight, initializing insufficient data with zeros */
        int numberOfInitilasedBuffers = NUMBER_OF_BUFFERS;
        if (NUMBER_OF_REQUESTS % NUMBER_OF_BUFFERS != 0 && queueIndex == NUMBER_OF_REQUESTS - 1)
        {
            numberOfInitilasedBuffers = NUMBER_OF_REQUESTS % NUMBER_OF_BUFFERS;
            while (bufferIndex != NUMBER_OF_BUFFERS)
            {
                pPubKey[bufferIndex] = NULL;
                mbCipherTextArray[bufferIndex] = NULL;
                mbPlainTextArray[bufferIndex] = NULL;
                bufferIndex++;
            }
        }

        /* Check if there are enough requests for the operation */
        if (bufferIndex == NUMBER_OF_BUFFERS) {
            /* Calculate temporary buffer size */
            int pubBufSize = 0;
            status = ippsRSA_MB_GetBufferSizePublicKey(&pubBufSize, pPubKey);
            if (!checkStatus("ippsRSA_MB_GetBufferSizePublicKey", ippStsNoErr, status))
            {
                for (int i = 0; i < numberOfInitilasedBuffers; i++)
                    delete[](Ipp8u*)pPubKey[i];
                break;
            }
                
            /* Allocate memory for temporary buffer */
            Ipp8u* pScratchBuffer = new Ipp8u[pubBufSize];

            /* Encrypt message */
            status = ippsRSA_MB_Encrypt(mbPlainTextArray, mbCipherTextArray,
                                        pPubKey, statusesArray,
                                        pScratchBuffer);

            delete[] pScratchBuffer;

            
            /* Handling the ippStsMbWarning status when the number of requests in the queue is not a multiple of eight */
            if (numberOfInitilasedBuffers != NUMBER_OF_BUFFERS && status == ippStsMbWarning)
            {
                /* If ippStsNullPtrErr status is in the initially unspecified buffers, then we consider that the status of the operation is ippStsNoErr */
                status = ippStsNoErr;
                for (int i = 0; i < numberOfInitilasedBuffers; i++)
                    if (statusesArray[i] != ippStsNoErr)
                        status = ippStsMbWarning;
                for (int i = numberOfInitilasedBuffers; i < NUMBER_OF_BUFFERS; i++)
                    if (statusesArray[i] != ippStsNullPtrErr)
                        status = ippStsMbWarning;
            }

            for (int i = 0; i < numberOfInitilasedBuffers; i++)
                delete[](Ipp8u*)pPubKey[i];

            bufferIndex = 0;
            
            if (!checkStatus("ippsRSA_MB_Encrypt", ippStsNoErr, status))
                break;
        }
    }

    if (status != ippStsNoErr)
    {
        PRINT_EXAMPLE_STATUS("ippsRSA_MB_Encrypt, ippsRSA_MB_Decrypt", "RSA MULTI BUFFER 1024 Encryption and Decryption", ippStsNoErr == status);
        return status;
    }

    /*
     *  This loop emulates batch decryption performed on the second host with processing requests from the queue of requests
     *  that were encrypted on the first host. The idea is to accumulate eight compatible requests from the requests queue 
     *  and call single decryption operation for all eight using ippsRSA_MB_Decrypt.
     */

    for (int queueIndex = 0; queueIndex < NUMBER_OF_REQUESTS; queueIndex++)
    {
        /* Don't process request that did not pass the compatibility check at the encryption stage */
        if (!requestQueue[queueIndex]->IsCompatible())
            continue;

        bitSizeD = requestQueue[queueIndex]->GetBitSizeD();

        /* This value should be the same for all eight buffers */
        bitSizeN = requestQueue[queueIndex]->GetBitSizeN();

        /* Allocate memory for private key Type1, all keys should be of the same type */
        int keySize = 0;
        ippsRSA_GetSizePrivateKeyType1(bitSizeN, bitSizeD, &keySize);
        pPrivKey[bufferIndex] = (IppsRSAPrivateKeyState*)(new Ipp8u[keySize]);

        /* Prepare key to operation */
        ippsRSA_InitPrivateKeyType1(bitSizeN, bitSizeD, pPrivKey[bufferIndex], keySize);
        ippsRSA_SetPrivateKeyType1(requestQueue[queueIndex]->GetValueN(), requestQueue[queueIndex]->GetValueD(), pPrivKey[bufferIndex]);

        /* Check decryption requests and pPrivKey types compatibility of each eight buffers, if the request is incompatible, mark it as not processed and take another request */
        if (bufferIndex > 0 && (!CheckDecRequestsCompatibility(requestQueue[queueIndex-1], requestQueue[queueIndex]) || !CheckPrivateKeyCompatibility(pPrivKey[bufferIndex-1], pPrivKey[bufferIndex])))
        {
            requestQueue[queueIndex]->SetCompatibilityStatus(false);
            delete[](Ipp8u*)pPrivKey[bufferIndex];
            continue;
        }

        /* Forming the array of cipher and decipher texts */
        mbDecipherTextArray[bufferIndex] = requestQueue[queueIndex]->GetDecipherText();
        mbCipherTextArray[bufferIndex] = requestQueue[queueIndex]->GetCipherText();

        bufferIndex++;

        /* Handling the case when the number of requests in the queue is not a multiple of eight, initializing insufficient data with zeros */
        int numberOfInitilasedBuffers = NUMBER_OF_BUFFERS;
        if (NUMBER_OF_REQUESTS % NUMBER_OF_BUFFERS != 0 && queueIndex == NUMBER_OF_REQUESTS - 1)
        {
            numberOfInitilasedBuffers = NUMBER_OF_REQUESTS % NUMBER_OF_BUFFERS;
            while (bufferIndex != NUMBER_OF_BUFFERS)
            {
                pPrivKey[bufferIndex] = NULL;
                mbCipherTextArray[bufferIndex] = NULL;
                mbDecipherTextArray[bufferIndex] = NULL;
                bufferIndex++;
            }
        }

        /* Check if there are enough requests for the operation */
        if (bufferIndex == NUMBER_OF_BUFFERS) {
            /* Calculate temporary buffer size */
            int privBufSize = 0;
            status = ippsRSA_MB_GetBufferSizePrivateKey(&privBufSize, pPrivKey);
            if (!checkStatus("ippsRSA_MB_GetBufferSizePrivateKey", ippStsNoErr, status))
            {
                for (int i = 0; i < numberOfInitilasedBuffers; i++)
                    delete[](Ipp8u*)pPrivKey[i];
                break;
            }

            /* Allocate memory for temporary buffer */
            Ipp8u* pScratchBuffer = new Ipp8u[privBufSize];

            /* Decrypt message */
            status = ippsRSA_MB_Decrypt(mbCipherTextArray, mbDecipherTextArray,
                pPrivKey, statusesArray,
                pScratchBuffer);

            delete[] pScratchBuffer;

            /* Handling the ippStsMbWarning status when the number of requests in the queue is not a multiple of eight */
            if (numberOfInitilasedBuffers != NUMBER_OF_BUFFERS && status == ippStsMbWarning)
            {
                /* If ippStsNullPtrErr status is in the initially unspecified buffers, then we consider that the status of the operation is ippStsNoErr */
                status = ippStsNoErr;
                for (int i = 0; i < numberOfInitilasedBuffers; i++)
                    if (statusesArray[i] != ippStsNoErr)
                        status = ippStsMbWarning;
                for (int i = numberOfInitilasedBuffers; i < NUMBER_OF_BUFFERS; i++)
                    if (statusesArray[i] != ippStsNullPtrErr)
                        status = ippStsMbWarning;
            }

            for (int i = 0; i < numberOfInitilasedBuffers; i++)
                delete[](Ipp8u*)pPrivKey[i];

            bufferIndex = 0;

            if (!checkStatus("ippsRSA_MB_Decrypt", ippStsNoErr, status))
                break; 
        }
    }

    if (status == ippStsNoErr) {
        /* Checking for equality of multi buffer decrypted messages and the reference plaintexts */
        Ipp32u isDifferent;
        for (int queueIndex = 0; queueIndex < NUMBER_OF_REQUESTS; queueIndex++) {
            /* Validate only processed requests */
            if (requestQueue[queueIndex]->IsCompatible()) {
                ippsCmp_BN(requestQueue[queueIndex]->GetPlainText(), requestQueue[queueIndex]->GetDecipherText(), &isDifferent);
                if (isDifferent) {
                    printf("Error: plain text and decipher text do not match\n");
                    status = ippStsErr;
                    break;
                }
            } 
        }
    }

    for (int queueIndex = 0; queueIndex < NUMBER_OF_REQUESTS; queueIndex++)
        delete requestQueue[queueIndex];


    PRINT_EXAMPLE_STATUS("ippsRSA_MB_Encrypt, ippsRSA_MB_Decrypt", "RSA MULTI BUFFER 1024 Encryption and Decryption", ippStsNoErr == status);
    return status;
}