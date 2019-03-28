# Intel(R) Integrated Performance Primitives Cryptography (Intel(R) IPP Cryptography)

This is a list of notable changes to Intel(R) IPP Cryptography, in reverse chronological order.

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
