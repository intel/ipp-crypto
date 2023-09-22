/*******************************************************************************
 * Copyright 2023 Intel Corporation
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
#ifdef MBX_FIPS_MODE

#include <crypto_mb/fips_cert.h>
#include <internal/fips_cert/common.h>
#include <internal/rsa/ifma_rsa_method.h>

#include <crypto_mb/rsa.h>

/* KAT TEST (generated via internal tests) */
/* plaintext */
static const int8u plaintext[MBX_RSA4K_DATA_BYTE_LEN] = {
  0x54,0xaa,0x9a,0x6c,0xc8,0x5e,0xea,0xde,0xc2,0xe7,0xcc,0x9a,0x0f,0xe1,0x55,0xe4,
  0x3e,0xd8,0x1b,0x11,0x67,0xa5,0x52,0x1b,0x21,0x0e,0x29,0x42,0x9c,0xfd,0x66,0x66,
  0x03,0x82,0x80,0x66,0x10,0x6a,0x4a,0x98,0x85,0xf9,0x09,0x91,0x7b,0x8a,0xdb,0xc3,
  0x8a,0xf0,0x42,0x96,0x0a,0x9c,0x4e,0xa7,0xa0,0x10,0xe0,0xae,0x6e,0x71,0xe8,0x69,
  0x8f,0xb1,0x34,0x4e,0x3e,0xbf,0xde,0xd4,0x08,0x9d,0xeb,0x4a,0x0e,0xf1,0x56,0xec,
  0x38,0x54,0x27,0x94,0xbc,0xe0,0x76,0xc7,0xe9,0x22,0xff,0x6f,0xa6,0xd9,0xdb,0x2e,
  0x83,0xda,0x62,0xc2,0xfb,0x8b,0x63,0xbe,0xe4,0x19,0x5e,0x17,0x21,0x18,0x7d,0x5f,
  0x0d,0x51,0xca,0x03,0x39,0xbf,0x64,0x03,0xb3,0x90,0x08,0x67,0x31,0x1b,0xb4,0x7d,
  0xab,0x8f,0x87,0x77,0x1a,0x3d,0x97,0x58,0x24,0xa4,0x1e,0x83,0x2f,0x91,0xe1,0x8d,
  0x57,0xb7,0xd8,0xfc,0xfc,0x3c,0xd3,0x84,0xbb,0x15,0xd6,0xc1,0x70,0x6a,0xf3,0x26,
  0xe7,0x8b,0x33,0xfc,0x66,0x18,0x2d,0x89,0xed,0xae,0xbc,0x72,0xff,0x83,0xaf,0x33,
  0x03,0xf9,0xd8,0xa3,0xf4,0x1e,0xa4,0x2f,0xdc,0x21,0x27,0x0a,0x7c,0x9b,0x7c,0xf4,
  0xc5,0xe1,0xa1,0xc3,0x43,0x2f,0xcd,0xb4,0xb2,0xf5,0x5b,0x30,0x5f,0x00,0x59,0x5e,
  0x0d,0x9e,0x46,0x32,0x0f,0x0a,0x93,0x5c,0x03,0xb4,0x75,0x24,0x7e,0x74,0x7e,0x10,
  0x15,0x76,0x71,0x28,0x77,0x5b,0x13,0x3d,0xd9,0x3f,0xa5,0x06,0x1a,0xe5,0xe5,0x5e,
  0x82,0x58,0x6f,0x1d,0xc0,0xe1,0x5b,0xf3,0xe3,0x27,0xa4,0x99,0x74,0x84,0x61,0x1c,
  0xd3,0x77,0xff,0x08,0xf3,0xcd,0x84,0x28,0xa7,0x4f,0x95,0x15,0xeb,0xcc,0xa9,0xce,
  0xfb,0x77,0x34,0xcf,0xe7,0x82,0x21,0xcc,0xfb,0xda,0xdc,0x10,0xa1,0x41,0xc6,0x43,
  0x6d,0xa4,0xa8,0x16,0xe8,0x2f,0x13,0x79,0x5d,0x11,0xf7,0x27,0xba,0x0d,0x71,0xd6,
  0xde,0x8d,0x32,0xae,0x5d,0x48,0x38,0x46,0xdf,0x88,0xe6,0xa7,0x1d,0x08,0x01,0xb0,
  0xd3,0xc7,0x47,0x5f,0x94,0xde,0x06,0x04,0xf9,0x33,0xff,0x94,0x5c,0xbd,0xfa,0xa5,
  0x57,0x7b,0xde,0xc8,0xfb,0x94,0xda,0x78,0x61,0x18,0x35,0x50,0xf2,0xf3,0xf4,0x18,
  0x21,0xe0,0xf1,0xf5,0xe6,0x55,0x05,0xe2,0x8f,0xce,0xd4,0x91,0xd0,0x8a,0x80,0xd0,
  0xa0,0x74,0x42,0xf0,0x46,0x64,0x57,0x16,0x58,0x02,0xc4,0x78,0xcf,0xfe,0x4d,0xca,
  0xf1,0x80,0x9f,0x10,0xd9,0x12,0xe3,0x0e,0xe2,0x36,0xe6,0x55,0xfe,0x9f,0xee,0x2a,
  0xa3,0x85,0x47,0xa9,0x12,0xc6,0xb0,0x07,0x25,0xbf,0xd7,0xc3,0xca,0x5b,0xf1,0x2f,
  0x67,0xd7,0x97,0x25,0x60,0x9a,0x75,0x90,0xb2,0x5c,0x8a,0x72,0xc5,0xe0,0x6a,0xcc,
  0x98,0x1d,0x45,0xa3,0x17,0x22,0xce,0x8f,0x01,0xc4,0x37,0x79,0x90,0x7d,0x6f,0xce,
  0x00,0xaa,0x32,0x1d,0x2c,0xc7,0x88,0xfd,0xe8,0xbe,0x10,0x33,0x78,0x4d,0xa2,0xe8,
  0x40,0x6c,0xcc,0x42,0xec,0x4b,0xac,0x5e,0x30,0xd9,0x3e,0xfc,0x29,0x87,0x3c,0x49,
  0x19,0xb8,0xc7,0x9e,0xe5,0xea,0xeb,0x63,0x16,0xdb,0x3c,0x32,0x03,0xdb,0x13,0x45,
  0x3c,0xfa,0xbb,0xaf,0x9f,0x1b,0xa1,0xc0,0xd1,0x19,0x80,0x89,0xca,0xb6,0xc9,0x67};
/* ciphertext */
static const int8u ciphertext[MBX_RSA4K_DATA_BYTE_LEN] = {
  0x71,0x49,0x42,0x84,0x78,0xd2,0x44,0x99,0xf0,0xb8,0x64,0x01,0x3a,0x1b,0x0c,0x68,
  0xd4,0x4f,0xc2,0x0f,0x73,0xf8,0x64,0xcb,0x0f,0xbf,0x7e,0x5d,0x31,0x62,0x33,0x77,
  0x8c,0xe4,0x61,0x4d,0xa1,0x35,0x47,0xb9,0xce,0x9b,0xf6,0x5e,0xd3,0x46,0x87,0x15,
  0x03,0xda,0xb4,0xc8,0x7f,0x75,0x22,0x30,0x80,0x97,0xed,0x6f,0x8f,0x5f,0xe9,0x05,
  0x95,0x07,0x3f,0xef,0x3a,0x79,0x73,0x75,0xb6,0x77,0xd5,0x6b,0xfc,0xc7,0x27,0x25,
  0xb1,0xb5,0xf6,0x43,0x21,0xcf,0x9d,0xf1,0xee,0xb0,0x1b,0x59,0x59,0xca,0xd6,0x16,
  0x97,0x38,0x8f,0x5a,0x43,0xc8,0xff,0xd2,0x11,0x3f,0x90,0x34,0xb2,0xcd,0x83,0x33,
  0x5a,0xde,0xe6,0x34,0x3b,0x34,0xc5,0x2b,0x3a,0xa0,0x19,0x89,0x13,0x6d,0xd0,0x62,
  0x28,0x2f,0x82,0x5e,0xa5,0x87,0x9c,0x3d,0x6e,0x0b,0xc6,0xa9,0xc4,0xf2,0xab,0x25,
  0xcf,0x6e,0x50,0xa3,0x14,0x21,0xec,0x4c,0x65,0x42,0x59,0xe7,0x05,0x47,0x70,0x19,
  0x00,0x16,0x0d,0xac,0x49,0x33,0x38,0x17,0xf0,0x11,0x88,0x6b,0xe6,0x0a,0xfa,0xd7,
  0x28,0x37,0x42,0x65,0xb9,0xfe,0x1e,0x9b,0x37,0x29,0xf4,0xa8,0x65,0xc1,0x16,0x5d,
  0x51,0x09,0xe9,0xab,0x0a,0x5b,0x3c,0x43,0x4f,0x14,0xc0,0xfb,0x41,0x6b,0x7d,0x31,
  0xbb,0x58,0x28,0x8e,0x2e,0xfb,0x89,0x1c,0x60,0xa1,0x76,0x28,0x14,0x27,0x29,0x92,
  0x6e,0xa7,0x96,0x9d,0x61,0x08,0xc6,0x8d,0x3d,0xb2,0x67,0x05,0x99,0x31,0xcd,0x08,
  0x83,0xc7,0xfd,0x73,0x8d,0x69,0x9b,0xc9,0x6d,0x88,0x59,0x47,0x2e,0x19,0x4d,0x62,
  0xe8,0x14,0x35,0x15,0x75,0x49,0x3e,0x2b,0x83,0x18,0xc4,0x16,0xda,0xd1,0x3d,0x06,
  0xaf,0x3b,0x3e,0x25,0x1e,0x1d,0xc3,0xfd,0xc0,0x26,0xf0,0x2a,0xe1,0x42,0xf3,0x24,
  0x1e,0x6a,0x63,0x8e,0xb7,0x25,0xe8,0x5c,0x01,0x12,0xda,0xa7,0x52,0xde,0x6a,0x65,
  0x7c,0x30,0xd3,0x93,0xa8,0x57,0x40,0x92,0x14,0xe5,0xda,0x4e,0xf0,0xbb,0x4b,0x11,
  0x03,0x12,0x29,0xb2,0x8b,0x3b,0x2d,0x7e,0x3d,0xad,0xbc,0x16,0x1b,0x22,0xd8,0x3a,
  0x91,0xba,0xef,0x71,0x2e,0x0e,0xda,0xb0,0x8c,0xc7,0xbd,0xc5,0x69,0x10,0x41,0x86,
  0x79,0x63,0xb3,0x65,0xa4,0x11,0x81,0x63,0x77,0xdb,0xa6,0xdb,0xfc,0x5a,0x7f,0x55,
  0x34,0xec,0x4b,0x79,0x8d,0x2f,0xf2,0x1f,0xfe,0x41,0x46,0xd0,0x70,0xc4,0xfe,0x1c,
  0x8d,0x2e,0x32,0x16,0x78,0xab,0x83,0xf2,0x87,0xef,0x6a,0x70,0x62,0xc0,0x07,0x7f,
  0x6d,0xe7,0x43,0xc6,0x56,0x0f,0x19,0xc1,0x7a,0x75,0xb6,0xd7,0xbb,0xe0,0x4f,0x14,
  0xc8,0x63,0xd2,0xab,0xa5,0xf3,0xdb,0x44,0x3c,0x0b,0x4f,0x9d,0xc9,0x49,0x74,0xaf,
  0x6e,0x9d,0x35,0xc9,0xef,0xa6,0x0d,0xb6,0x8a,0xef,0xfa,0xa0,0x80,0xa4,0x90,0xdc,
  0xef,0x91,0x4a,0x06,0x7b,0x8b,0xe1,0xd8,0xae,0x40,0xa6,0x42,0x78,0x30,0x58,0x40,
  0xbd,0xfe,0x03,0xe9,0x31,0x26,0x11,0x4c,0xa2,0x05,0xb8,0xb5,0xad,0x00,0x94,0x50,
  0x8f,0xad,0xd2,0x7b,0x8e,0xd8,0x88,0x51,0x1a,0x40,0x7a,0xc2,0x20,0x84,0x3a,0x97,
  0x19,0x14,0x10,0x84,0x20,0xfa,0xd4,0x46,0x91,0xbb,0x72,0xe2,0x8d,0x7c,0xc4,0xa9};
/* p, q primes */
static const int8u p[MBX_RSA4K_DATA_BYTE_LEN / 2] = {
  0x95,0xef,0x9e,0x93,0xea,0x9c,0x13,0x41,0x6c,0xba,0xd0,0x91,0x72,0x4f,0xeb,0x18,
  0xcd,0x34,0xcf,0x6a,0x1e,0x55,0xed,0xec,0x12,0x41,0x5e,0x5e,0x2f,0xb8,0x16,0xb2,
  0x97,0x69,0x2a,0x51,0x11,0x94,0x20,0xb0,0x2e,0x0e,0x89,0x79,0xfa,0x2e,0xd1,0xb7,
  0x30,0x7c,0xab,0x77,0xd7,0xb9,0xc7,0x65,0x06,0xa0,0x23,0xb6,0x50,0x89,0xa1,0x06,
  0x75,0x0d,0x75,0x0e,0x5e,0x97,0x10,0xe0,0x37,0x0a,0x5a,0x0a,0x1f,0x5f,0x83,0x6d,
  0x24,0x8d,0x52,0x39,0x7d,0xbb,0x33,0x9d,0x6d,0xee,0x31,0x7f,0x4f,0x2f,0x8d,0x62,
  0x20,0xd6,0x8b,0x2a,0xd9,0x23,0x35,0x59,0x0a,0x54,0xe9,0x14,0x02,0x3f,0xad,0x0d,
  0xff,0x85,0xa1,0x11,0x92,0x8d,0xb9,0x82,0x23,0x54,0xb3,0x71,0x73,0x23,0x21,0x4e,
  0xa0,0x05,0x16,0x1e,0xe1,0x21,0xe2,0xd3,0xab,0xd9,0xc1,0x7b,0x90,0xf6,0xf5,0xa0,
  0xb3,0x8c,0xe9,0x30,0x38,0x8c,0x50,0x18,0x51,0xb1,0x53,0x2e,0xa9,0x59,0xaa,0x54,
  0x51,0xa9,0x4d,0x40,0x84,0x42,0xf3,0x76,0x0f,0x71,0xbd,0x7d,0xc9,0xd5,0x17,0x0f,
  0x05,0x3a,0x99,0x00,0x3e,0xec,0x7c,0x94,0x3f,0xad,0xdd,0x53,0x6a,0x0e,0xf4,0xa2,
  0x40,0x44,0xb9,0xaa,0xc7,0x95,0x7d,0x71,0x3e,0xcc,0x46,0xb5,0x36,0x91,0x09,0xce,
  0xdc,0x62,0x83,0xc2,0x8c,0x61,0x5d,0xa6,0x98,0xf3,0xbf,0x7e,0xfe,0x03,0x37,0xdf,
  0x30,0x8f,0xc8,0xb1,0xa5,0x75,0x9a,0xdf,0xb3,0x94,0x67,0x2f,0x16,0x93,0x75,0xd0,
  0x9f,0x80,0x85,0x06,0x7b,0x75,0x92,0xf7,0xe0,0x96,0x9b,0x74,0xf3,0x14,0xbf,0xe7};
static const int8u q[MBX_RSA4K_DATA_BYTE_LEN / 2] = {
  0xd5,0x16,0x05,0x04,0x67,0xd4,0x03,0x14,0x83,0x1e,0xb7,0xb2,0x92,0xb7,0xb4,0x11,
  0x17,0xc3,0xe1,0xa9,0x57,0xe5,0x77,0x1f,0x40,0x06,0xad,0x2e,0xa6,0x7f,0xf6,0x4b,
  0x92,0xd9,0xea,0x81,0xee,0xa3,0xd8,0x8b,0x11,0xbb,0x5a,0x7e,0xff,0xe0,0x16,0x8f,
  0xba,0x37,0x65,0xb7,0xf8,0xa6,0x00,0xc1,0xed,0x1f,0xaf,0x02,0xa3,0x5f,0xa5,0x63,
  0xfe,0x23,0x2a,0x2b,0x57,0x2c,0x31,0xfe,0x63,0xa9,0x0d,0x85,0xc5,0xd9,0x74,0x11,
  0xbb,0x76,0x0c,0x1e,0x13,0x2f,0xbe,0xf3,0xd2,0x2c,0xca,0x9f,0x21,0xc3,0x83,0x84,
  0xb6,0x25,0x62,0xa6,0xda,0xc0,0xff,0x5d,0xc2,0xe5,0x27,0x7c,0x26,0xa2,0x0f,0xf4,
  0xef,0x0f,0x28,0x34,0x2e,0x5a,0xbd,0x1a,0xd3,0x79,0x3a,0xac,0xaa,0x90,0x45,0x9b,
  0xb2,0xb2,0x6e,0xa8,0xb6,0x00,0x73,0x84,0xc5,0x06,0x25,0x95,0x2c,0x62,0x01,0x41,
  0x0e,0xc9,0xad,0xf4,0xff,0x31,0x0f,0x5c,0x19,0x6b,0xa7,0xc4,0x00,0xf1,0xce,0x1e,
  0xfa,0x76,0x72,0xf8,0x3c,0x78,0xc7,0x1c,0x27,0x4b,0x42,0xe0,0x19,0xbc,0xdd,0x78,
  0x9c,0x95,0x98,0xec,0x38,0xa8,0xf8,0x23,0xb0,0x8f,0x3b,0xc7,0xcf,0xbf,0x14,0xdc,
  0x39,0xef,0x35,0x83,0x85,0x78,0x9f,0xa6,0x88,0x49,0x2a,0x4b,0x9d,0xe2,0x31,0x87,
  0x69,0x7c,0x68,0xcf,0xdf,0x89,0x51,0xaf,0x81,0xbf,0xed,0x12,0x2f,0x67,0xf2,0x27,
  0xe7,0x7e,0xe9,0xdc,0x6f,0x9f,0x01,0x56,0x3d,0xa8,0x0f,0xcd,0xd4,0x3d,0x73,0x45,
  0x5e,0x83,0xb1,0xd3,0x76,0x44,0x02,0xc9,0xc7,0xe9,0xfb,0xe7,0xa4,0xd1,0x25,0xc5};
/* p's, q's CRT private exponent */
static const int8u dp[MBX_RSA4K_DATA_BYTE_LEN / 2] = {
  0x81,0xc8,0x46,0x8f,0x46,0x92,0x80,0x8a,0x34,0xff,0xf3,0x06,0x18,0x67,0x02,0x6f,
  0x16,0x73,0x0f,0xc6,0x92,0xdc,0x5d,0x0a,0x2c,0xe1,0xc8,0x3d,0xfe,0x02,0x4a,0x98,
  0xe9,0x78,0xe1,0x04,0x74,0x53,0xf9,0xc9,0x0d,0x06,0x8a,0xf2,0xb6,0xe1,0x0d,0x05,
  0x60,0x1c,0x3f,0x3e,0x9c,0xaa,0xc2,0x56,0x77,0x73,0x2e,0x44,0xc7,0xf0,0x43,0x01,
  0xb7,0xdc,0x2c,0xa3,0x9e,0x0d,0xbb,0x96,0x55,0x4b,0xc6,0x25,0x7f,0xe9,0xfd,0xf7,
  0x25,0x59,0x97,0x5f,0x92,0x89,0xc2,0x0f,0x59,0x5b,0xfc,0xfc,0xf9,0xa0,0x62,0x1f,
  0x30,0xb0,0x98,0xaf,0xee,0xf2,0x38,0x8b,0xfc,0xd9,0x26,0xee,0xf2,0x06,0xce,0x91,
  0x65,0xea,0xb7,0xe6,0x76,0x17,0xc5,0x12,0xae,0x5c,0xbc,0x6f,0xf3,0xbc,0x97,0x48,
  0x44,0xb1,0x0e,0x38,0xfc,0x63,0xbe,0xc0,0x69,0xf2,0x1c,0x2a,0x83,0x02,0x99,0xce,
  0x4f,0xf3,0xad,0x64,0x01,0xd4,0x39,0xb5,0x33,0x9b,0x48,0x8f,0x4d,0x66,0x08,0xc3,
  0x47,0x9e,0x37,0x1c,0x46,0x24,0x36,0xab,0x71,0x48,0x50,0xd8,0x7d,0xa7,0xb2,0x63,
  0xa6,0x46,0x35,0x98,0xb5,0x40,0xe3,0x32,0x08,0xb7,0x90,0x2e,0x26,0x51,0x62,0x37,
  0x35,0x5e,0x83,0xb7,0xa0,0x45,0x67,0x7d,0x19,0x7b,0xcb,0x73,0xac,0x7a,0x94,0xf2,
  0x90,0x14,0xf8,0xed,0xf3,0x13,0x77,0xcc,0x14,0xc9,0x72,0xab,0xc3,0x68,0xba,0x5b,
  0xb9,0xb0,0x56,0x0c,0x87,0x6f,0xa3,0x27,0xcc,0xab,0x2e,0xaf,0xd4,0x65,0x72,0x7f,
  0x40,0x37,0xdc,0xe2,0xd6,0xa8,0x47,0xb1,0xfc,0xff,0x19,0x08,0x66,0x95,0xd6,0x40};
static const int8u dq[MBX_RSA4K_DATA_BYTE_LEN / 2] = {
  0x21,0x2b,0xb5,0x06,0x56,0xa1,0x68,0xec,0xcc,0x6f,0xb5,0xdf,0x1b,0xa4,0x90,0xbe,
  0x82,0xce,0xfb,0x5e,0x20,0xb9,0xa3,0x0a,0xe2,0x12,0x59,0x7b,0xd0,0x76,0xe9,0x58,
  0x67,0x6f,0x83,0x82,0x37,0x28,0xe2,0x4f,0xed,0x5e,0x13,0x79,0x69,0x20,0x36,0x47,
  0xde,0xb2,0xa6,0xb9,0xa0,0x0d,0x10,0xad,0x12,0x48,0x58,0xa2,0xec,0xf4,0x0f,0x86,
  0xc7,0xeb,0xcf,0x03,0x1d,0x9e,0x01,0x93,0x6a,0x86,0x13,0x49,0x19,0x3b,0x67,0x01,
  0x45,0x5f,0xe5,0xb5,0xef,0x45,0x05,0x7c,0x13,0x01,0x81,0xf8,0x09,0xc3,0xc5,0x9c,
  0x7f,0x19,0x09,0xd3,0xa6,0xa6,0x47,0x02,0x8e,0x07,0xc2,0xcf,0x13,0xcf,0xea,0x10,
  0x3f,0xa3,0xc9,0xf8,0x3c,0x43,0xe3,0xfe,0x92,0x0a,0x20,0x61,0xb7,0x39,0xc2,0x47,
  0x6f,0x86,0xc1,0x1d,0x89,0x54,0x03,0x2b,0x18,0xe1,0xf1,0x0b,0xa0,0x41,0x05,0x8e,
  0x71,0xf2,0x97,0xa1,0x23,0x2d,0x4d,0xe6,0x68,0x28,0x2c,0x35,0xd7,0x08,0x53,0xd1,
  0x2f,0x9e,0xf1,0xf1,0x3d,0xa1,0xcf,0x12,0x01,0x86,0xb8,0xe5,0xc9,0x5f,0x4c,0x32,
  0x9b,0x19,0xe4,0xda,0x57,0xc4,0x3c,0x09,0x4a,0x86,0x83,0xbc,0xa1,0xdd,0xf6,0xd4,
  0x13,0x7d,0x7b,0x84,0x7c,0x2d,0x59,0x9c,0x8d,0x97,0x3d,0x5c,0x34,0x8f,0x51,0x9e,
  0xb8,0x91,0x74,0xf8,0x1a,0xfd,0x7b,0xfb,0xcb,0xe0,0x2b,0x8c,0xca,0x50,0x92,0x69,
  0x7e,0x26,0x9e,0x5c,0xf4,0x80,0x8c,0x1d,0x1c,0x00,0x91,0x48,0x83,0x91,0xe0,0x9c,
  0x95,0xe8,0x46,0x6e,0xdb,0x7e,0x1e,0xaa,0xf9,0x9a,0xe9,0x2f,0xae,0x6d,0x11,0x16};
/* CRT coefficient */
static const int8u inv_q[MBX_RSA4K_DATA_BYTE_LEN / 2] = {
  0xbb,0xc0,0x69,0x44,0x4a,0xc2,0xbf,0x33,0x40,0xe0,0x7e,0x1a,0x86,0xf1,0xd6,0xa6,
  0xfc,0x71,0x40,0x19,0x83,0xd8,0x9d,0xd0,0xec,0x72,0x16,0xbc,0x8e,0x78,0xc6,0x39,
  0x29,0x0b,0xf1,0x24,0x8f,0xfb,0xec,0x51,0xc2,0x98,0xb5,0x99,0x40,0x3d,0x3f,0x2b,
  0xbb,0xd8,0x80,0x10,0x87,0x6e,0x26,0x82,0x72,0x36,0x2f,0xf6,0x2a,0x05,0x08,0x5c,
  0x48,0xe0,0x08,0x7e,0xce,0xe9,0xdc,0x34,0x15,0xef,0x95,0x34,0xc1,0xb3,0x58,0xbd,
  0x5c,0x35,0x0e,0xaf,0x0e,0xbd,0xb9,0x87,0xe2,0xea,0xec,0x12,0xde,0xf4,0xd5,0xd2,
  0x2b,0x5e,0x69,0xb8,0x1e,0x8c,0x80,0xc2,0xbc,0x11,0x06,0x5a,0xf0,0xed,0x4f,0x18,
  0x19,0x2b,0xcc,0xf4,0x1d,0x03,0x34,0x49,0x6f,0x9a,0x30,0x42,0x05,0xb2,0x48,0xe8,
  0xca,0xa3,0x6e,0xbd,0x95,0x51,0x60,0xc3,0xf5,0x3f,0x58,0xa5,0xcc,0x6a,0xe0,0xaa,
  0x47,0x9e,0xfd,0x61,0x86,0x06,0x54,0x00,0x63,0xa6,0x69,0x57,0x94,0xef,0x9a,0xaa,
  0x7a,0x85,0x6f,0x71,0x61,0x7a,0x2e,0xd6,0x0d,0x12,0xba,0x5f,0xb9,0x18,0xce,0x6b,
  0x79,0x4c,0x52,0x9e,0x6a,0x71,0xf8,0xb0,0x86,0xea,0xed,0x16,0xc1,0xe3,0x47,0x0e,
  0x3b,0x67,0x13,0xfa,0xdc,0xe2,0xb8,0xbb,0xd1,0x1a,0x55,0xf1,0xde,0xad,0xb5,0x1c,
  0xa6,0x61,0x03,0xac,0x49,0xb7,0x3d,0xd4,0x99,0x23,0x48,0x2d,0xe2,0xc5,0x64,0x75,
  0x7f,0x66,0x04,0xf5,0xe5,0x91,0xfe,0x14,0x85,0x12,0x8a,0x49,0x2b,0x69,0xc6,0xb2,
  0x0e,0xac,0xa4,0x94,0x2c,0x10,0xc1,0xfc,0x08,0x98,0xa7,0x56,0x0c,0x27,0xf0,0x66};

DLL_PUBLIC
fips_test_status fips_selftest_mbx_rsa4k_private_crt_mb8(void) {
  fips_test_status test_result = MBX_ALGO_SELFTEST_OK;

  /* output plaintext */
  int8u out_plaintext[MBX_LANES][MBX_RSA4K_DATA_BYTE_LEN];
  /* key operation */
  const mbx_RSA_Method* method = mbx_RSA4K_private_crt_Method();

  /* function input parameters */
  // ciphertext
  const int8u *pa_ciphertext[MBX_LANES] = {
    ciphertext, ciphertext, ciphertext, ciphertext,
    ciphertext, ciphertext, ciphertext, ciphertext};
  // plaintext
  int8u *pa_plaintext[MBX_LANES] = {
    out_plaintext[0], out_plaintext[1], out_plaintext[2], out_plaintext[3],
    out_plaintext[4], out_plaintext[5], out_plaintext[6], out_plaintext[7]};
  // p, q primes
  const int64u *pa_p[MBX_LANES]= {
    (int64u *)p, (int64u *)p, (int64u *)p, (int64u *)p,
    (int64u *)p, (int64u *)p, (int64u *)p, (int64u *)p};
  const int64u *pa_q[MBX_LANES]= {
    (int64u *)q, (int64u *)q, (int64u *)q, (int64u *)q,
    (int64u *)q, (int64u *)q, (int64u *)q, (int64u *)q};
  // p's, q's CRT private exponent
  const int64u *pa_dp[MBX_LANES]= {
    (int64u *)dp, (int64u *)dp, (int64u *)dp, (int64u *)dp,
    (int64u *)dp, (int64u *)dp, (int64u *)dp, (int64u *)dp};
  const int64u *pa_dq[MBX_LANES]= {
    (int64u *)dq, (int64u *)dq, (int64u *)dq, (int64u *)dq,
    (int64u *)dq, (int64u *)dq, (int64u *)dq, (int64u *)dq};
  // CRT coefficient
  const int64u *pa_inv_q[MBX_LANES]= {
    (int64u *)inv_q, (int64u *)inv_q, (int64u *)inv_q, (int64u *)inv_q,
    (int64u *)inv_q, (int64u *)inv_q, (int64u *)inv_q, (int64u *)inv_q};

  /* test function */
  mbx_status expected_status_mb8 = MBX_SET_STS_ALL(MBX_STATUS_OK);

  mbx_status sts;
  sts = mbx_rsa_private_crt_mb8(pa_ciphertext, pa_plaintext, pa_p, pa_q, pa_dp, pa_dq, pa_inv_q, 
    MBX_RSA4K_DATA_BIT_LEN, method, NULL);
  if (expected_status_mb8 != sts) {
    test_result = MBX_ALGO_SELFTEST_BAD_ARGS_ERR;
  }
  // compare output plaintext to known answer
  int output_status;
  for (int i = 0; (i < MBX_LANES) && (MBX_ALGO_SELFTEST_OK == test_result); ++i) {
    output_status = mbx_is_mem_eq(pa_plaintext[i], MBX_RSA4K_DATA_BYTE_LEN, plaintext, MBX_RSA4K_DATA_BYTE_LEN);
    if (!output_status) { // wrong output
      test_result = MBX_ALGO_SELFTEST_KAT_ERR;
    }
  }

  return test_result;
}

#ifndef BN_OPENSSL_DISABLE

// memory free macro
#define MEM_FREE(BN_PTR1, BN_PTR2, BN_PTR3, BN_PTR4, BN_PTR5) { \
  BN_free(BN_PTR1);                                             \
  BN_free(BN_PTR2);                                             \
  BN_free(BN_PTR3);                                             \
  BN_free(BN_PTR4);                                             \
  BN_free(BN_PTR5); }

DLL_PUBLIC
fips_test_status fips_selftest_mbx_rsa4k_private_crt_ssl_mb8(void) {

  fips_test_status test_result = MBX_ALGO_SELFTEST_OK;

  /* output plaintext */
  int8u out_plaintext[MBX_LANES][MBX_RSA4K_DATA_BYTE_LEN];
  /* ssl parameters */
  // p, q primes
  BIGNUM* BN_p  = BN_new();
  BIGNUM* BN_q  = BN_new();
  // p's, q's CRT private exponent
  BIGNUM* BN_dp = BN_new();
  BIGNUM* BN_dq = BN_new();
  // CRT coefficient
  BIGNUM* BN_inv_q = BN_new();
  /* check if allocated memory is valid */
  if(NULL == BN_p || NULL == BN_q || NULL == BN_dp || NULL == BN_dq || NULL == BN_inv_q) {
    test_result = MBX_ALGO_SELFTEST_BAD_ARGS_ERR;
    MEM_FREE(BN_p, BN_q, BN_dp, BN_dq, BN_inv_q)
    return test_result;
  }

  /* function status and expected status */
  mbx_status sts;
  mbx_status expected_status_mb8 = MBX_SET_STS_ALL(MBX_STATUS_OK);
  /* output validity status */
  int output_status;

  /* set ssl parameters */
  BN_lebin2bn(p, MBX_RSA4K_DATA_BYTE_LEN / 2, BN_p);
  BN_lebin2bn(q, MBX_RSA4K_DATA_BYTE_LEN / 2, BN_q);
  BN_lebin2bn(dp, MBX_RSA4K_DATA_BYTE_LEN / 2, BN_dp);
  BN_lebin2bn(dq, MBX_RSA4K_DATA_BYTE_LEN / 2, BN_dq);
  BN_lebin2bn(inv_q, MBX_RSA4K_DATA_BYTE_LEN / 2, BN_inv_q);

  /* function input parameters */
  // ciphertext
  const int8u *pa_ciphertext[MBX_LANES] = {
    ciphertext, ciphertext, ciphertext, ciphertext,
    ciphertext, ciphertext, ciphertext, ciphertext};
  // plaintext
  int8u *pa_plaintext[MBX_LANES] = {
    out_plaintext[0], out_plaintext[1], out_plaintext[2], out_plaintext[3],
    out_plaintext[4], out_plaintext[5], out_plaintext[6], out_plaintext[7]};
  // p, q primes
  const BIGNUM *pa_p[MBX_LANES] = {
    (const BIGNUM *)BN_p, (const BIGNUM *)BN_p, (const BIGNUM *)BN_p, (const BIGNUM *)BN_p,
    (const BIGNUM *)BN_p, (const BIGNUM *)BN_p, (const BIGNUM *)BN_p, (const BIGNUM *)BN_p};
  const BIGNUM *pa_q[MBX_LANES] = {
    (const BIGNUM *)BN_q, (const BIGNUM *)BN_q, (const BIGNUM *)BN_q, (const BIGNUM *)BN_q,
    (const BIGNUM *)BN_q, (const BIGNUM *)BN_q, (const BIGNUM *)BN_q, (const BIGNUM *)BN_q};
  // p's, q's CRT private exponent
  const BIGNUM *pa_dp[MBX_LANES] = {
    (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp,
    (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp, (const BIGNUM *)BN_dp};
  const BIGNUM *pa_dq[MBX_LANES] = {
    (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq,
    (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq, (const BIGNUM *)BN_dq};
  // CRT coefficient
  const BIGNUM *pa_inv_q[MBX_LANES] = {
    (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q,
    (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q, (const BIGNUM *)BN_inv_q};

  /* test function */
  sts = mbx_rsa_private_crt_ssl_mb8(pa_ciphertext, pa_plaintext,
    pa_p, pa_q, pa_dp, pa_dq, pa_inv_q, MBX_RSA4K_DATA_BIT_LEN);
  if (expected_status_mb8 != sts) {
    test_result = MBX_ALGO_SELFTEST_BAD_ARGS_ERR;
  }
  // compare output signature to known answer
  for (int i = 0; (i < MBX_LANES) && (MBX_ALGO_SELFTEST_OK == test_result); ++i) {
    output_status = mbx_is_mem_eq(pa_plaintext[i], MBX_RSA4K_DATA_BYTE_LEN, plaintext, MBX_RSA4K_DATA_BYTE_LEN);
    if (!output_status) { // wrong output
      test_result = MBX_ALGO_SELFTEST_KAT_ERR;
    }
  }

  // memory free
  MEM_FREE(BN_p, BN_q, BN_dp, BN_dq, BN_inv_q)

  return test_result;
}

#endif // BN_OPENSSL_DISABLE
#endif // MBX_FIPS_MODE