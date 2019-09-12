# Building usage examples of Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography library

## Build with library sources

Only merged library (cmake option `-DMERGED_BLD:BOOL=ON`) builds are supported for the examples.

1. Run cmake to generate a build procedure with the `-DBUILD_EXAMPLES:BOOL=ON` option.
   For other cmake build options, please refer to the library root README.md file.

2. On Linux*/macOS*, build with `make -j8 <target>`. You can use the following targets:

   - To build an invididual example, use targets started with the *example_* string (like *example_aes-256-ctr-encryption*).

   - To build all examples of a single specific category, use target *ippcp_examples_\<category\>* (like *ippcp_examples_aes*).

   - To build all examples, use target *ippcp_examples_all*.

3. On Windows* OS select the appropriate project (individual example, all
   examples by category or the whole set of examples) in the *examples* folder of
   project structure in IDE and run **Build**.

## Build with pre-built library

1. Navigate to the *examples* folder and run the cmake command below.

   On Linux*/macOS*:

   `cmake CMakeLists.txt -B_build`

   On Windows* OS it is required to specify a generator (`-G` option) and optionally a toolchain (`-T` option)
   to build with Intel(R) C++ Compiler:

   `cmake CMakeLists.txt -B_build -G"Visual Studio 15 2017 Win64" -T"Intel C++ Compiler 19.0"`

2. The build system will scan the system for the Intel(R) IPP Cryptography library.
   If it is found, you’ll see the following message:

   ```
   -- Found Intel(R) IPP Cryptography at: /home/user/intel/ippcp
   -- Configuring done
   ```

   If the library is not found automatically, you can specify the path to the library root folder
   (where the include/ and lib/ directories are located) using the `-DIPPCRYPTO_ROOT_DIR=<path>` option.

3. Run the build process as described in the [Build with library sources](#build-with-library-sources).


# How to add a new example into Intel(R) IPP Cryptography library:

1. Choose a category (a folder), where to put the example, and a filename. Use
   existing folders where applicable.
   The file name should be as follows: "\<category\>-\<key-size\>-\<mode\>-\<other-info\>.cpp"
   E.g.: "rsa-1k-oaep-sha1-type2-decryption.cpp" for the example of RSA category.

2. Write an example keeping its source code formatting consistent with other
   examples as much as possible.  The "aes/aes-256-ctr-encryption.cpp" can be used
   as a reference.

3. Use Doxygen annotations for the file description, global variables and
   macros. The *main()* function shall not use doxygen annotations inside
   (otherwise they disappear in the source code section of an example page in
   the generated documentation).

4. Add the example to the build: open *examples/CMakeLists.txt* file and add the
   new file to the *IPPCP_EXAMPLES* list.

5. Make sure it can be built using Intel(R) IPP Cryptography examples build procedure, and it
   works correctly.

You are ready to submit a pull request!
