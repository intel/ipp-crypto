Intel(R) Integrated Performance Primitives Cryptography
--------------------

- [Overview](#overview)
  - [Product description](#product-description)
  - [Branches description](#branches-description)
  - [License](#license)
  - [Online Documentation](#online-documentation)
- [System Requirements to Build Intel(R) IPP Cryptography](#system-requirements-to-build-intelr-ipp-cryptography)
  - [Common Requirements for All Supported Operating Systems](#common-requirements-for-all-supported-operating-systems)
  - [Windows\* OS](#windows-os)
    - [C/C++\* Compilers](#cc-compilers)
    - [Assembly Compilers](#assembly-compilers)
  - [Linux\* OS](#linux-os)
    - [C/C++\* Compilers](#cc-compilers-1)
    - [Binary Tools](#binary-tools)
    - [Android\* NDK Version:](#android-ndk-version)
  - [macOS\*](#macos)
    - [C/C++\* Compilers](#cc-compilers-2)
    - [Assembly Compilers](#assembly-compilers-1)
- [Building from Source](#building-from-source)
  - [Required Software](#required-software)
  - [Build Steps](#build-steps)
  - [CMake Arguments](#cmake-arguments)
    - [Common Arguments for All Supported Operating Systems](#common-arguments-for-all-supported-operating-systems)
    - [Windows\* OS](#windows-os-1)
    - [Linux\* OS](#linux-os-1)
    - [macOS\*](#macos-1)
- [Building an application tied to a specific CPU](#building-an-application-tied-to-a-specific-cpu)
- [Intel IPP Custom Library Tool](#intel-ipp-custom-library-tool)
- [How to Contribute](#how-to-contribute)
- [See Also](#see-also)
- [Legal Information](#legal-information)


Overview
=======================================================

Product description
--------------------
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

Branches description
--------------------
- `develop` - snapshots of the library under active development.
Contains code that may not be fully functional and that Intel may substantially modify in development of a production version.
- `ipp_crypto_<release>` - source code of the official production release `<release>`.

License
-------

Intel IPP Cryptography is licensed under Apache License 2.0.

Online Documentation
--------------------

You can find the latest Intel IPP Cryptography documentation on
the [Intel(R) Integrated Performance Primitives
Documentation](https://software.intel.com/en-us/intel-ipp/documentation) web
page.

System Requirements to Build Intel(R) IPP Cryptography
=======================================================

The list below contains the system requirements necessary to build Intel
IPP Cryptography. We tested the build process of Intel IPP Cryptography
only on the operating systems and tools listed below:

Common Requirements for All Supported Operating Systems
-----------------

-   CMake 3.15

-   Python 2.7.15

Windows\* OS
-----------------

-   Windows Server\* 2016

### C/C++\* Compilers
- Intel(R) C++ Compiler 19.0 Update 4 for Windows\* OS

-   Microsoft Visual C++ Compiler\* version 19.16
    provided by Microsoft Visual Studio\* 2017 version 15.9

### Assembly Compilers
-   Microsoft Macro Assembler 14

Linux\* OS
-----------------

-   Red Hat\* Enterprise Linux\* 7

### C/C++\* Compilers
-   Intel(R) C++ Compiler 19.0 Update 4 for Linux\* OS

-   GCC 8.3

-   GCC 9.1

### Binary Tools
-   GNU binutils 2.32

### Android\* NDK Version:

-   Android NDK, Revision 10

macOS\*
-----------------

-   macOS\* 10.14

### C/C++\* Compilers
-   Intel(R) C++ Compiler 19.0 Update 4 for OS X\* OS

### Assembly Compilers
-   Yasm 1.2.2

Building from Source
=======================================================

Required Software
-----------------

-   C/C++ compiler (see [System Requirements](#system-requirements-to-build-intelr-ipp-cryptography))

-   Assembly compiler (see [System Requirements](#system-requirements-to-build-intelr-ipp-cryptography))

-   CMake (see [System Requirements](#system-requirements-to-build-intelr-ipp-cryptography))

-   Python (see [System Requirements](#system-requirements-to-build-intelr-ipp-cryptography))

-   Microsoft Visual Studio\* (Windows\* OS only)

-   Android NDK (only for cross-platform build for Android\* OS on Linux\* OS)

Build Steps
-----------------

Note that we tested only the build process defined in `CMakeLists.txt`
with the options described in [CMake Arguments](#cmake-arguments).

1.  Download and install all [Required Software](#required-software).

2.  Clone the source code from GitHub\* as follows:
    ```
    git clone --recursive <repo>
    ```
3.  Set the environment variables for one of the supported C/C++
    compilers.\
    For Intel(R) Compiler please refer to
    [Intel(R) C++ Compiler Developer Guide and Reference](https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference)\
    For MSVC* Compiler please refer to [Use the MSVC toolset from the command line](https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=vs-2017)

4.  Run CMake\* on the command line. Example CMake lines for different
    operating systems:

    **Windows\* OS**:

    For Intel(R) C++ Compiler:
    ```
    cmake CMakeLists.txt -Bbuild -G"Visual Studio 15 2017 Win64" -T"Intel C++ Compiler 19.0"
    ```
    For MSVC\* Compiler:
    ```
    cmake CMakeLists.txt -Bbuild -G"Visual Studio 15 2017 Win64"
    ```
    For Intel(R) C++ Compiler and Visual Studio\* 2019:
    ```
    cmake CMakeLists.txt -Bbuild -G"Visual Studio 16 2019" -T"Intel C++ Compiler 19.0" -Ax64
    ```
    For MSVC\* Compiler and Visual Studio\* 2019:
    ```
    cmake CMakeLists.txt -Bbuild -G"Visual Studio 16 2019" -Ax64
    ```

    **Linux\* OS**:

    For Intel(R) C++ Compiler:
    ```
    CC=icc CXX=icpc cmake CMakeLists.txt -Bbuild -DARCH=intel64
    ```
    For GCC:
    ```
    CC=gcc CXX=g++ cmake CMakeLists.txt -Bbuild -DARCH=intel64
    ```

    **macOS\***:

    For Intel(R) C++ Compiler:
    ```
    CC=icc CXX=icpc cmake CMakeLists.txt -Bbuild -DARCH=intel64 -DUSEYASM=<path to Yasm compiler>
    ```
    \
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

    Built libraries are located in the `<build_dir>/.build/<RELEASE|DEBUG>/lib` directory.

CMake Arguments
-----------------

### Common Arguments for All Supported Operating Systems

-   `-B<build-dir>` - defines the build directory. This is the directory
    where CMake puts the generated Microsoft Visual Studio\* solution or
    makefiles.

-   `-DARCH=<ia32|intel64>` - on Linux* OS and macOS*, defines the target architecture
    for the build of the Intel IPP Cryptography library. On Windows* OS, use `-G`/`-A`
    instead. See the description of the `-G`/`-A` option [below](#windows-os-1)
    for details.

-   `-DMERGED_BLD:BOOL=<on|off>` - optional. Defines the configuration
    of the Intel IPP Cryptography library to build:

    -   `-DMERGED_BLD:BOOL=on`: default configuration. Build of a dispatched
        static library with all available optimizations; build of a dispatched
        dynamic library with all available optimizations; generation of the single-CPU headers (for more details please refer to the [section](#building-an-application-tied-to-specific-cpu) below).

    -   `-DMERGED_BLD:BOOL=off`: build of one static library per
        optimization; build of one dynamic library per optimization.

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

### Windows\* OS

-   `-G"<tool-chain-generator>"` - defines the native build system CMake
    will generate from the input files. For example, `-G"Visual Studio
    15 2017"` will generate a solution for the Microsoft Visual Studio\*
    2017 IDE, `-G"Visual Studio 15 2017 Win64"` will generate a solution
    for the Microsoft Visual Studio\* 2017 IDE for the Intel(R) 64
    architecture.

-   `-A<x64|Win32>` - for Visual Studio\* 2019+, defines the target architecture
    for the build of the Intel IPP Cryptography library.

-   `-T<Compiler>` - defines the compiler for building, for example,
    `-T"Intel C++ Compiler 19.0"` defines Intel(R) Compiler 19.0 for
    building.

**Note:** Refer to CMake documentation for more information on these options.

### Linux\* OS

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

### macOS\*

-   `-DUSEYASM=<path to Yasm* assembly>` - defines the path to the
    Yasm\* assembly compiler.

Building an application tied to a specific CPU
=======================================================

The default build of the Intel(R) IPP Cryptography library (with `-DMERGED_BLD:BOOL=on` CMake option) provides the merged static library that contains multiple versions of each function optimized for different CPUs.
By default, each function is linked to the target application with its all CPU optimization versions. In case when an application or driver needs to be tied to a particular processor to reduce the footprint, it is also possible to link it to only one optimization layer of Intel(R) IPP Cryptography.

For this purpose, there are several CPU-specific headers (each targeted on specific CPU optimization) generated during the merged library build. They are located in the `<build_dir>/.build/<RELEASE|DEBUG>/include/autogen` directory.
To enable linking of processor-specific versions of the library functions, include the appropriate header from the directory above before the primary library header `ippcp.h`.

Please refer to the [article](https://software.intel.com/en-us/articles/understanding-cpu-optimized-code-used-in-intel-ipp) for more details about CPU identification codes used in the header suffixes.

It is important to ensure that both processor and operating system supports full capabilities of the target processor.

Intel IPP Custom Library Tool
=======================================================

With the Intel(R) IPP Custom Library Tool, you can build your own dynamic library containing only the Intel IPP Cryptography functionality that is necessary for your application.

The tool is located in `tools/ipp_custom_library_tool_python` directory.

Please refer to the [tool documentation](https://software.intel.com/en-us/ipp-dev-guide-using-custom-library-tool-for-intel-integrated-performance-primitives) for more information.

How to Contribute
=======================================================

We welcome community contributions to Intel IPP Cryptography. If you
have an idea how to improve the product, let us know about your proposal via
the [Intel IPP
Forum](https://software.intel.com/en-us/forums/intel-integrated-performance-primitives).

Intel IPP Cryptography is licensed under [Apache License, Version
2.0](http://www.apache.org/licenses/LICENSE-2.0). By
contributing to the project, you agree to the license and copyright
terms therein and release your contribution under these terms.


See Also
=======================================================

-   [Intel(R) Integrated Performance Primitives Product Page](https://software.intel.com/en-us/intel-ipp)

-   [Intel(R) IPP Forum](https://software.intel.com/en-us/forums/intel-integrated-performance-primitives)
