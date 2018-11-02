# Intel(R) Integrated Performance Primitives Cryptography (Intel(R) IPP Cryptography)

This is a list of notable changes to Intel(R) IPP Cryptography, in reverse chronological order.

## YYYY-MM-DD
- Added new functionality: the SM2 encryption scheme.
- Added the ability to build the Intel IPP Cryptography library with the Microsoft* Visual C++ Compiler 2017.
- Changed the range of the message being signed/verified by EC and DLP.
- Fixed a potential security problem in the DLP signing and key generation functions.
- Fixed a potential security problem in the AES-CTR cipher functions.

## 2018-09-07
- Deprecated the ARCFour functionality.
- Fixed a potential security problem in the signing functions over elliptic curves.
- Fixed a potential security problem in the key expansion function for AES Encryption.
- Fixed some of the compilation warnings observed when building the static dispatcher on Windows* OS.
- Fixed minor issues with DLP functions.


------------------------------------------------------------------------
Intel is a trademark of Intel Corporation or its subsidiaries in the U.S. and/or other countries.
* Other names and brands may be claimed as the property of others.
