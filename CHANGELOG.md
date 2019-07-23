# Intel(R) Integrated Performance Primitives Cryptography (Intel(R) IPP Cryptography)

This is a list of notable changes to Intel(R) IPP Cryptography, in reverse chronological order.

## 2019-07-23
- Added Microsoft* Visual Studio* 2019 build support
- Added Intel(R) IPP Custom Library Tool

## 2019-06-24
- AES-GCM was enabled with vector extensions of Intel(R) AES New Instructions (Intel(R) AES-NI).
- A dynamic dispatcher library and a set of CPU-optimized dynamic libraries were replaced by a single merged dynamic library with an internal dispatcher.
- Removed deprecated multi-threaded version of the library.
- Removed Supplemental Streaming SIMD Extensions 3 (SSSE3) support on macOS.

## 2019-05-29
- AES-XTS was enabled with vector extensions of Intel(R) AES New Instructions (Intel(R) AES-NI).

## 2019-05-22
- Fixed GCC* and MSVC* builds of IA32 generic CPU code (pure C) with -DMERGED_BLD:BOOL=off option.
- Added single-CPU headers generation.
- Aligned structure of the build output directory across all supported operation systems.

## 2019-04-23
- AES-CFB was enabled with vector extensions of Intel(R) AES New Instructions (Intel(R) AES-NI).
- ippsGFpECGetPointOctString and ippsGFpECSetPointOctString now support elliptic curves over both prime and extended finite fields.

## 2019-04-01
- 1024, 2048, 3072 and 4096 bit RSA were enabled with AVX512 IFMA instructions.
- AES-ECB, AES-CBC and AES-CTR were enabled with vector extensions of Intel(R) AES New Instructions (Intel(R) AES-NI).
- Improved optimization of Intel(R) AES-NI based CMAC.
- Added the ippsGFpGetInfo function, which returns information about a finite field.
- Added the ippsHashGetInfo_rmf function, which returns information about a hash algorithm.
- Added the ability to build the Intel(R) IPP Cryptography library with GCC* 8.2.
- Fixed selection of CPU-specific code in dynamic/shared libraries.

## 2018-10-15
- Added the new SM2 encryption scheme.
- Added the ability to build the Intel(R) IPP Cryptography library with the Microsoft* Visual C++ Compiler 2017.
- Added the ability to build the Intel(R) IPP Cryptography library with the Intel(R) C++ Compiler 19.
- Changed the range of the message being signed or verified by EC and DLP.
- Fixed a potential security problem in the DLP signing and key generation functions.
- Fixed a potential security problem in the AES-CTR cipher functions.
- Fixed a potential security problem in the AES-GCM cipher functions.

## 2018-09-07
- Deprecated the ARCFour functionality.
- Fixed a potential security problem in the signing functions over elliptic curves.
- Fixed a potential security problem in the key expansion function for AES Encryption.
- Fixed some of the compilation warnings observed when building the static dispatcher on Windows* OS.
- Fixed minor issues with DLP functions.


------------------------------------------------------------------------
Intel is a trademark of Intel Corporation or its subsidiaries in the U.S. and/or other countries.
* Other names and brands may be claimed as the property of others.
