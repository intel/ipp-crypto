# How to build usage examples of Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography library

## Build with library sources

Only merged library (`-DMERGED_BLD:BOOL=on`) builds are supported to build the examples.

1. Run cmake to generate a build procedure with the `-DBUILD_EXAMPLES:BOOL=ON` option.
   Note, for other cmake project properties, please see library root README.md.

2. On Linux*/macOS* choose the Makefile target:

   - To build an invididual example, use targets started with `example_` string (like `example_aes-256-ctr-encrypt`).

   - To build all examples of single specific category, use target `ippcp_examples_<category>`

   - To build all examples, use target `ippcp_examples`.

   Run build: `make -j8 <target>`

3. On Windows* OS select the appropriate project (individual example, all
   examples by category or the whole set of examples) in the `examples` folder of
   project structure in IDE and run `Build`.

## Build with pre-built library

1. Navigate to the `examples` folder and run cmake:

    `cmake CMakeLists.txt -B_build`

2. The build system will search the system and try to find the Intel(R) IPP Cryptography library.
   If it is found, the following message will appear:

   ```
   -- Found Intel(R) IPP Cryptography at: /home/user/intel/ippcp
   -- Configuring done
   ```

   If the library is not found automatically, it is possible to specify path to the library root folder
   (where the include/ and lib/ directories located) using option `-DIPPCRYPTO_ROOT_DIR=<path>`.

3. Run examples build as described in the [Build with library sources](#build-with-library-sources).


# How to add a new example into Intel(R) IPP Cryptography library:

1. Choose category (a folder), where to put the example, and a filename. Use
   existing folders where applicable.  The file name should be as follows:
   <category>-<problem_size>-<mode>-<other_info>.{c,cpp}
   E.g.: aes-256-ctr-encrypt.c for the example of AES category.

2. Write an example keeping its source code formatting consistent with other
   examples as much as possible.  The "aes/aes-256-ctr-encrypt.c" can be used
   as a reference.

3. Use Doxygen annotations for file description and global variables and
   macros.  main() function shall not use doxygen annotations inside (otherwise
   they disappear in the source code section of example page in the generated
   documentation).

4. Add the example to the build: open examples/CMakeLists.txt file and add a
   new file to the IPPCP_EXAMPLES list.

5. Make sure it can be built using IPP Crypto examples build procedure and it
   works correctly.

6. You are ready to submit a pull request!
