# RSA IFMA Muti-buffer Library

It is a library separate from Intel IPP Cryptography. The library provides optimized version of RSA multi-buffer based on Intel(R) Advanced Vector Extensions 512 (Intel(R) AVX-512) Integer Fused Multiply Add (IFMA). Currently, the library is compatible with OpenSSL\* only.

## System Requirements

The library build process was tested on the following operating systems and tools:
- Linux\* OS
- GCC\* 8.2
- CMake\* 3.12
- Python\* 2.7.16
- OpenSSL\* 1.1.0

## Building from Source

1. Clone the repository and navigate to the `sources/ippcp/ifma_rsa_mb` folder.

2. Run CMake on the command line. Example CMake lines and avaliable options:

Use `-B` to specify path to the resulting project. Do not specify any additional options to use Python and OpenSSL from default system paths:
```
cmake . -B../build
```

Use `PYTHON_EXECUTABLE` variable to override path to Python:
```
cmake . -B../build -DPYTHON_EXECUTABLE=/path/to/python27
```

Use `OPENSSL_INCLUDE_DIR`, `OPENSSL_LIBRARIES` and `OPENSSL_ROOT_DIR` variables to override path to OpenSSL:
```
cmake . -B../build -DOPENSSL_INCLUDE_DIR=/path/to/openssl/include -DOPENSSL_LIBRARIES=/path/to/openssl/lib -DOPENSSL_ROOT_DIR=/path/to/openssl
```

3. Go to the project folder that was specified with `-B` and run `make` to build the library (`librsa_ifma` target) and, optionally, tests (`vfy_ifma_rsa_mb`, `vfy_ifma_cp_rsa_mb` targets). The resulting binaries will be placed in the `bin` subfolder inside the build folder.

Example:
```
make -j8
./bin/vfy_ifma_rsa_mb
```
