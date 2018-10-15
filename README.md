Intel(R) Integrated Performance Primitives Cryptography
=======================================================

Intel(R) Integrated Performance Primitives (Intel(R) IPP) Cryptography
is a software library that provides a broad range of secure and
efficient cryptographic algorithm implementations:

-   Symmetric Cryptography Primitive Functions (AES, SM4, TDES, RC4)

-   One-Way Hash Primitives (SHA, MD5, SM3)

-   Data Authentication Primitive Functions (HMAC, CMAC)

-   Public Key Cryptography Functions (RSA, DLP, ECC)

-   Finite Field Arithmetic Functions

Intel(R) IPP Cryptography provides multiple function implementations
optimized for various Intel(R) CPUs, and can be set up to use dispatching
to select the CPU-specific implementation at run time. Dispatching refers to
the detection of features supported by the underlying CPU and selecting
the corresponding Intel IPP Cryptography binary path.

License
-------

Intel IPP Cryptography is licensed under Apache License 2.0.

Online Documentation
--------------------

You can find the latest Intel IPP Cryptography documentation on
the [Intel(R) Integrated Performance Primitives
Documentation](https://software.intel.com/en-us/intel-ipp/documentation) web
page.

How to Contribute
-----------------

We welcome community contributions to Intel IPP Cryptography. If you
have an idea how to improve the product, let us know about your proposal via
the [Intel IPP
Forum](https://software.intel.com/en-us/forums/intel-integrated-performance-primitives).

Intel IPP Cryptography is licensed under [Apache License, Version
2.0](http://www.apache.org/licenses/LICENSE-2.0). By
contributing to the project, you agree to the license and copyright
terms therein and release your contribution under these terms.

System Requirements to Build Intel(R) IPP Cryptography
----------------------------------------------------

The list below contains the system requirements necessary to build Intel
IPP Cryptography. We tested the build process of Intel IPP Cryptography
only on the operating systems and tools listed below:

### Operating Systems to Build Intel IPP Cryptography:

-   Windows Server\* 2012

-   Red Hat\* Enterprise Linux\* 6

-   macOS\* 10.12\*

### C/C++\* Compilers for Windows\* OS:

-   Intel(R) C++ Compiler 18.0 for Windows\* OS

-   Intel(R) C++ Compiler 19.0 for Windows\* OS

-   Microsoft Visual C++ Compiler\* version 14.14 or higher
    provided by Microsoft Visual Studio\* 2017 version 15.7 or higher

### C/C++\* Compilers for Linux\* OS:

-   Intel(R) C++ Compiler 18.0 for Linux\* OS

-   Intel(R) C++ Compiler 19.0 for Linux\* OS

### C/C++\* Compilers for macOS\*:

-   Intel(R) C++ Compiler 18.0 for OS X\*

-   Intel(R) C++ Compiler 19.0 for OS X\* OS

### Assembly Compilers for Windows\* OS:

Microsoft Macro Assembler 11

### Assembly Compilers for Linux\* OS:

GNU as from GNU binutils 2.27

### Assembly Compilers for macOS\*:

Yasm 1.2.2

### Binary Tools for Windows\* OS:

-   Microsoft Visual Studio\* 2013

-   Microsoft Visual Studio\* 2015

-   Microsoft Visual Studio\* 2017

### Binary Tools for Linux\* OS:

GNU binutils 2.27

### Binary Tools for macOS\*:

GNU binutils 1.38

### CMake\* Version:

CMake 3.0 or higher

### Python\* Version:

Python 2.7

### Android\* NDK Version:

Android NDK, Revision 10

Building from Source
--------------------

### Required Software

-   C/C++ compiler (see [System Requirements](#system-requirements))

-   Assembly compiler (see [System Requirements](#system-requirements))

-   CMake (see [System Requirements](#system-requirements))

-   Python (see [System Requirements](#system-requirements))

-   Microsoft Visual Studio\* (Windows\* OS only)

-   Android NDK (only for cross-platform build for Android\* OS on Linux\* OS)

### Build Steps

Note that we tested only the build process defined in `CMakeLists.txt`
with the options described in [CMake Arguments](#cmake-arguments).

1.  Download and install all [Required Software](#required-software).

2.  Clone the source code from GitHub\* as follows:
    ```
    git clone --recursive <repo>
    ```
3.  Set the environment variables for one of the supported C/C++
    compilers; for Intel(R)Compiler please refer to
    https://software.intel.com/en-us/cpp-compiler-18.0-developer-guide-and-reference-specifying-the-location-of-compiler-components-with-compilervars

4.  Run CMake\* on the command line. Example CMake lines for different
    operating systems:

    **Windows\* OS**:

    ```
    cmake CMakeLists.txt -Bbuild -G"Visual Studio 14 2015 Win64" -T"Intel C++ Compiler 18.0"
    ```

    **Linux\* OS**:

    ```
    CC=icc CXX=icpc cmake CMakeLists.txt -Bbuild -DARCH=intel64
    ```

    **macOS\***:

    ```
    CC=icc CXX=icpc cmake CMakeLists.txt -Bbuild -DARCH=intel64 -DUSEYASM=<path to Yasm compiler>
    ```

    The list of supported CMake arguments is available in the
    [CMake Arguments](#cmake-arguments) section.

5.  Go to the build folder specified when running CMake, then do one of
    the following:

    -   On Windows\* OS: open the Microsoft Visual Studio\* solution and
        run a build.

        **Important:** the process used to build the Microsoft Visual Studio solutions results
        in debug information being generated for assembly files by default for both Debug and
        Release configurations. To build Intel IPP Cryptography library binaries without debug
        information in the Release configuration, follow these steps:

        1. Right-click a project file and select **Properties**.
        2. In the **Configuration** drop-down list, select **Release**.
        3. Select the **Microsoft Macro Assembler** tab.
        4. Set the value of the **Generate Debug Information** option to **No**.
        5. Repeat steps 1-3 for all projects you want to build.

    -   On Linux\* OS or macOS\*: start a build using makefiles.

    At this point, you can shoose to build either static or dynamic libraries.
    Depending on the value of the `-DMERGED_BLD:BOOL` option in the `cmake` call in
    step 4, you will get a set of separate self-contained libraries optimized
    for particular platforms, or a dispatched library with all optimizations.
    See the description of `-DMERGED_BLD:BOOL` in [CMake Arguments](#cmake-arguments)
    for more information.

    Built libraries are located in
    the `<build_dir>/.build/lib` directory.

### CMake Arguments

#### Common CMake Arguments for All Supported Operating Systems:

-   `-B<build-dir>` - defines the build directory. This is the directory
    where CMake puts the generated Microsoft Visual Studio\* solution or
    makefiles.

-   `-DARCH=<ia32|intel64>` - on Linux* OS and macOS*, defines the target architecture
    for the build of the Intel IPP Cryptography library. On Windows* OS, use `-G`
    instead. See the description of the `-G` option [below](#windows-os-cmake-arguments)
    for details.

-   `-DMERGED_BLD:BOOL=<on|off>` - optional. Defines the configuration
    of the Intel IPP Cryptography library to build:

    -   `-DMERGED_BLD:BOOL=on`: default configuration. Build of a dispatched
        static library with all available optimizations; build of dynamic
        libraries with a dynamic dispatcher library.

    -   `-DMERGED_BLD:BOOL=off`: build of one static library per
        optimization; build of one dynamic library per optimization.

-   `-DTHREADED_LIB:BOOL=<off|on>` - optional. Defines the threading
    configuration of the Intel IPP Cryptography library to build:

    -   `-DTHREADED_LIB:BOOL=off`: default. Build single-threaded Intel IPP
        Cryptography library

    -   `-DTHREADED_LIB:BOOL=on`: build multi-threaded Intel IPP Cryptography
        library.

-   `-DPLATFORM_LIST="<platform list>"` - optional, works only if
    `-DMERGED_BLD:BOOL=off` is set. Sets target platforms for the code
    to be compiled. See the supported platform list at
    <https://software.intel.com/en-us/ipp-dev-guide-dispatching>.

    -   example for Linux\* OS and the IA-32 architecture:
        `-DPLATFORM_LIST="m7;s8;p8;g9;h9"`

    -   example for Linux\* OS and the Intel(R) 64 architecture:
        `-DPLATFORM_LIST="w7;n8;y8;e9;l9;n0;k0"`

**Note:** you can set C/C++ compilers for Linux\* OS and macOS\* using the
`CC` and `CXX` variables before calling `cmake`. For example:

```
CC=<path to C compiler> CXX=<path to C++ compiler> cmake <Arguments>
```

#### Windows\* OS CMake Arguments:

-   `-G"<tool-chain-generator>"` - defines the native build system CMake
    will generate from the input files. For example, `-G"Visual Studio
    12 2013"` will generate a solution for the Microsoft Visual Studio\*
    2013 IDE, `-G"Visual Studio 12 2013 Win64"` will generate a solution
    for the Microsoft Visual Studio\* 2013 IDE for the Intel(R) 64
    architecture.

-   `-T<Compiler>` - defines the compiler for building, for example,
    `-T"Intel C++ Compiler 18.0"` defines Intel(R) Compiler 18.0 for
    building.

**Note:** Refer to CMake documentation for more information on these options.

#### Linux\* OS CMake Arguments:

-   `-DNONPIC_LIB:BOOL=<off|on>` - optional. Defines whether the built
    library will be position-dependent or not:

    -   `-DNONPIC_LIB:BOOL=off:` default. Position-independent code.

    -   `-DNONPIC_LIB:BOOL=on:` position-dependent code.

    This parameter does not work together with the `--DANDROID` parameter.

-   `-DANDROID:BOOL=on` defines cross-platform build for Android\* OS.

-   `-D_CMAKE_TOOLCHAIN_PREFIX=<GNU toolchain prefix>` - used only
    for cross-platform build for Android\* OS. Defines the GNU toolchain
    prefix to compiler tools. For example, `"i686-linux-android-"`
    defines the prefix for i686 GNU\* compiler tools, and
    `"x86_64-linux-android-"` defines the prefix for x86_64 GNU compiler
    tools.

    **Note:** Before running CMake scripts for cross-platform build for
    Android\* OS, you need to do the following:

    1.  Set the following environment variables for Android\* NDK:

        -   ANDROID_NDK_ROOT defines the path to the Android\* NDK Root.

        -   ANDROID_SYSROOT defines the path to the Android\* NDK System
            Root.

        -   ANDROID_GNU_X86_TOOLCHAIN defines the path to the Android\*
            GNU toolchain.

        -   ANDROID_GNU_X86_LIBPATH defines the path to the Android\* GNU
            toolchain libraries.

    2.  Add `'$ANDROID_GNU_X86_TOOLCHAIN/bin'` to the `PATH`
        environment variable.

#### macOS\* CMake Arguments:

-   `-DUSEYASM=<path to Yasm* assembly>` - defines the path to the
    Yasm\* assembly compiler.


See Also
--------

-   [Intel(R) Integrated Performance Primitives Product Page](https://software.intel.com/en-us/intel-ipp)

-   [Intel(R) IPP Forum](https://software.intel.com/en-us/forums/intel-integrated-performance-primitives)

Legal Information
-----------------
No license (express or implied, by estoppel or otherwise) to any intellectual property rights is granted by this document.
Intel disclaims all express and implied warranties, including without limitation, the implied warranties of merchantability, fitness for a particular purpose, and non-infringement, as well as any warranty arising from course of performance, course of dealing, or usage in trade.

This document contains information on products, services and/or processes in development.  All information provided here is subject to change without notice. Contact your Intel representative to obtain the latest forecast, schedule, specifications and roadmaps.

The products and services described may contain defects or errors known as errata which may cause deviations from published specifications. Current characterized errata are available on request.

Intel, and the Intel logo are trademarks of Intel Corporation in the U.S. and/or other countries.

*Other names and brands may be claimed as the property of others.

© 2018 Intel Corporation.

|Optimization Notice|
|:------------------|
|Intel's compilers may or may not optimize to the same degree for non-Intel microprocessors for optimizations that are not unique to Intel microprocessors. These optimizations include SSE2, SSE3, and SSSE3 instruction sets and other optimizations. Intel does not guarantee the availability, functionality, or effectiveness of any optimization on microprocessors not manufactured by Intel. Microprocessor-dependent optimizations in this product are intended for use with Intel microprocessors. Certain optimizations not specific to Intel microarchitecture are reserved for Intel microprocessors. Please refer to the applicable product User and Reference Guides for more information regarding the specific instruction sets covered by this notice. <br><br> Notice revision #20110804|