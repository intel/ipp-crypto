.. _build:

How to Build Intel® Integrated Performance Primitives Cryptography (Intel® IPP Cryptography) :raw-html-m2r:`<!-- omit in toc -->`
=====================================================================================================================================


* `Software Requirements <#software-requirements>`_

  * `Common <#common>`_
  * `Linux* OS <#linux-os>`_
  * `Windows* OS <#windows-os>`_
  * `macOS* <#macos>`_

* `Building Intel IPP Cryptography on Linux* OS <#building-intel-ipp-cryptography-on-linux-os>`_
* `Building Intel IPP Cryptography on Windows* OS <#building-intel-ipp-cryptography-on-windows-os>`_
* `Building Intel IPP Cryptography on macOS* <#building-intel-ipp-cryptography-on-macos>`_
* `CMake Build Options <#cmake-build-options>`_

  * `Common for all operating systems <#common-for-all-operating-systems>`_
  * `Windows* OS <#windows-os-1>`_
  * `Linux* OS <#linux-os-1>`_

* `CMake Commands FAQ <#cmake-commands-faq>`_

  * `How to build a 32-bit library? <#how-to-build-a-32-bit-library>`_
  * `How to build a 64-bit generic library without any CPU-specific optimizations? <#how-to-build-a-64-bit-generic-library-without-any-cpu-specific-optimizations>`_
  * `How to build two libraries with optimizations for Intel® Advanced Vector Extensions 2 and Intel® Advanced Vector Extensions 512 instruction sets? <#how-to-build-two-libraries-with-optimizations-for-intel%c2%ae-advanced-vector-extensions-2-and-intel%c2%ae-advanced-vector-extensions-512-instruction-sets>`_
  * `How to build a library to work in a kernel space? <#how-to-build-a-library-to-work-in-a-kernel-space>`_

* `Incorporating Intel IPP Cryptography sources into custom build system <#incorporating-intel%c2%ae-ipp-cryptography-sources-into-custom-build-system>`_

Software Requirements
---------------------

Common
^^^^^^


* `CMake* <https://cmake.org/download>`_ 3.15 or higher
* Python 2.7.15
* The Netwide Assembler (NASM) 2.15*

..

   **NOTE**\ : Until NASM 2.15 is officially released, please use `this <https://www.nasm.us/pub/nasm/snapshots/20191023/>`_ NASM snapshot.

   Linux* OS
   ^^^^^^^^^


   * `Common tools <#common-software-requirements>`_
   * Intel® C++ Compiler 19.0 Update 4 for Linux* OS
   * GCC 8.3
   * GCC 9.1
   * GNU binutils 2.32
     ### Windows* OS
   * `Common tools <#common-software-requirements>`_
   * Intel® C++ Compiler 19.0 Update 4 for Windows* OS
   * Microsoft Visual C++ Compiler* version 19.16 provided by Microsoft Visual Studio* 2017 version 15.9
     ### macOS*
   * `Common tools <#common-software-requirements>`_
   * Intel® C++ Compiler 19.0 Update 4 for macOS* 
     ## Building Intel IPP Cryptography on Linux* OS


The software was validated on:


* Red Hat* Enterprise Linux* 7

To build the Intel IPP Cryptography library on Linux* OS, complete the following steps: 


#. 
   Clone the source code from GitHub* as follows:

   .. code-block:: bash

       git clone --recursive https://github.com/intel/ipp-crypto

#. 
   Set the environment for one of the supported C/C++ compilers.

   *Example for Intel® Compiler:*

   .. code-block:: bash

       source /opt/intel/bin/compilervars.sh intel64

    For details, refer to the `Intel® C++ Compiler Developer Guide and Reference <https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference-specifying-the-location-of-compiler-components-with-compilervars>`_.

#. 
   Run CMake* in the command line.

    *Examples*\ :

    For Intel® C++ Compiler:

   .. code-block:: bash

       CC=icc CXX=icpc cmake CMakeLists.txt -B_build -DARCH=intel64

    For GCC:

   .. code-block:: bash

       CC=gcc CXX=g++ cmake CMakeLists.txt -B_build -DARCH=intel64

    For the complete list of supported CMake options, refer to the `CMake Build Options <#cmake-build-options>`_ section.

#. 
   Navigate to the build folder specified in the CMake command line and start the build:

   .. code-block:: bash

       cd _build
       make all

    You can find the built libraries in the ``<build_dir>/.build/<RELEASE|DEBUG>/lib`` directory.

Building Intel IPP Cryptography on Windows* OS
----------------------------------------------

The software was validated on:


* Windows Server* 2016

To build the Intel IPP Cryptography library on Windows* OS, complete the following steps:


#. 
   Clone the source code from GitHub* as follows:

   .. code-block:: bash

       git clone --recursive https://github.com/intel/ipp-crypto

#. 
   Set the environment variables for one of the supported C/C++ compilers.
    For Intel® Compiler instructions, refer to the `Intel® C++ Compiler Developer Guide and Reference <https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference>`_.
    For MSVC* Compiler, refer to `Use the MSVC toolset from the command line <https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=vs-2017>`_.

#. 
   Run CMake* in the command line.

    *Examples*\ :

    For Intel® C++ Compiler and Visual Studio* 2019:

   .. code-block:: bash

       cmake CMakeLists.txt -B_build -G"Visual Studio 16 2019" -T"Intel C++ Compiler 19.0" -Ax64

    For MSVC* Compiler and Visual Studio* 2019:

   .. code-block:: bash

       cmake CMakeLists.txt -B_build -G"Visual Studio 16 2019" -Ax64

    For the complete list of supported CMake options, please refer to the `CMake Build Options <#cmake-build-options>`_ section.

#. 
   Navigate to the build folder, specified in the CMake command line and start build either from Visual Studio* or in the command line.

    *Build from command line:*

   .. code-block:: bash

       cmake --build . --parallel 4 --target ALL_BUILD --config Release

    *Build from Visual Studio\*\ :\ *
    Open the Microsoft Visual Studio\* solution ``Intel(R) IPP Crypto.sln``\ , choose project (build target) from the Solution Explorer and run the build.

Building Intel IPP Cryptography on macOS*
-----------------------------------------

The software was validated on:


* macOS* 10.14

To build the Intel IPP Cryptography library on macOS*, complete the following steps:


#. 
   Clone the source code from GitHub* as follows:

   .. code-block:: bash

       git clone --recursive https://github.com/intel/ipp-crypto

#. 
   Set the environment variables for one of the supported C/C++ compilers.

   *Example for Intel® Compiler:*

   .. code-block:: bash

       source /opt/intel/bin/compilervars.sh intel64

    For details, refer to the `Intel® C++ Compiler Developer Guide and Reference <https://software.intel.com/en-us/cpp-compiler-developer-guide-and-reference-specifying-the-location-of-compiler-components-with-compilervars>`_

#. 
   Run CMake* in the command line.

    *Examples*\ :

    For Intel® C++ Compiler:

   .. code-block:: bash

       CC=icc CXX=icpc cmake CMakeLists.txt -B_build -DARCH=intel64

    For the complete list of supported CMake options, refer to the `CMake Build Options <#cmake-build-options>`_ section.

#. 
   Navigate to the build folder specified in the CMake command line and start the build:

   .. code-block:: bash

       cd _build
       make all

    You can find the built libraries in the ``<build_dir>/.build/<RELEASE|DEBUG>/lib`` directory.

CMake Build Options
-------------------

Common for all operating systems
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


* 
  ``-B<build-dir>`` - defines the build directory. This is the directory where CMake puts the generated Microsoft Visual Studio* solution or makefiles.

* 
  ``-DARCH=<ia32|intel64>`` - on Linux\ * OS and macOS*\ , defines the target architecture for the build of the Intel IPP Cryptography library.

  ..

     **NOTE:** On Windows* OS, use ``-G``\ /\ ``-A``  instead. See the description of these options `below <#windows-os-specific>`_.


* 
  ``-DMERGED_BLD:BOOL=<on|off>`` - optional. Defines the configuration of the Intel IPP Cryptography library to build:


  * 
    `-DMERGED_BLD:BOOL=on`: default configuration. It includes the following steps:


    * Build of a dispatched static library with all available optimizations
    * Build of a dispatched dynamic library with all available optimizations
    * Generation of the single-CPU headers (for details, refer to :ref:`this <overview>` section)

  * 
    ``-DMERGED_BLD:BOOL=off``\ : build of one static library per optimization; build of one dynamic library per optimization.

* 
  ``-DPLATFORM_LIST="<platform list>"`` - optional, works only if ``-DMERGED_BLD:BOOL=off`` is set. Sets target platforms for the code to be compiled. See the supported platforms list :ref:`here <overview>`.


  * 
    Example for Linux* OS and the IA-32 architecture:
      ``-DPLATFORM_LIST="m7;s8;p8;g9;h9"``

  * 
    Example for Linux* OS and the Intel® 64 architecture:
      ``-DPLATFORM_LIST="w7;n8;y8;e9;l9;n0;k0"``

Windows* OS
^^^^^^^^^^^


* 
  ``-G"<tool-chain-generator>"`` - defines the native build system CMake will generate from the input files.
  Refer to CMake `documentation <https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#visual-studio-generators>`_ for the Visual Studio* generators options.

* 
  ``-A<x64|Win32>`` - for Visual Studio* 2019+, defines the target architecture for the build of the Intel IPP Cryptography library.

* 
  ``-T<Compiler>`` - defines the compiler for building.
  For example, to use Intel® Compiler, specify ``-T"Intel C++ Compiler 19.0"``.

..

   **NOTE:** Refer to CMake `documentation <https://cmake.org/cmake/help/latest/manual/ccmake.1.html>`_ for more information on these options.


Linux* OS
^^^^^^^^^


* 
  ``-DNONPIC_LIB:BOOL=<off|on>`` - optional. Defines whether the built library is position-dependent or not.


  * 
    ``-DNONPIC_LIB:BOOL=off:`` default. Position-independent code.

  * 
    ``-DNONPIC_LIB:BOOL=on:`` position-dependent code.

CMake Commands FAQ
------------------

How to build a 32-bit library?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``cmake CMakeLists.txt -B_build -DARCH=ia32``

How to build a 64-bit generic library without any CPU-specific optimizations?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``cmake CMakeLists.txt -B_build -DARCH=intel64 -DMERGED_BLD:BOOL=off -DPLATFORM_LIST=mx``

How to build two libraries with optimizations for Intel® Advanced Vector Extensions 2 and Intel® Advanced Vector Extensions 512 instruction sets?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``cmake CMakeLists.txt -B_build -DARCH=intel64 -DMERGED_BLD:BOOL=off -DPLATFORM_LIST="l9;k0"``

How to build a library to work in a kernel space?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``cmake CMakeLists.txt -B_build -DARCH=intel64 -DNONPIC_LIB:BOOL=on``

Incorporating Intel® IPP Cryptography sources into custom build system
----------------------------------------------------------------------

You can include Intel IPP Cryptography sources into some arbitrary project's CMake build system and build them with it.

Here is the minimal working example:

.. code-block:: bash

   cmake_minimum_required(VERSION 3.14)

   project("test_proj")

   # `crypto` is the repository root folder of Intel IPP Cryptography
   add_subdirectory(crypto)
   include_directories(crypto/include)

   # 'main.cpp' is some arbitrary project's source file
   add_executable("test_proj" main.cpp)
   # `ippcp_s` is the target name of static library in the Intel IPP Cryptography build system.
   # This static library will be built automatically, when you build your project.
   target_link_libraries("test_proj" "ippcp_s")

Also you can use CMake module to find the Intel IPP Cryptography library installed on the system. The module location is ``examples/FindIPPCrypto.cmake`` and here is the example of its usage:

.. code-block:: bash

   find_package(IPPCrypto REQUIRED MODULE)

   if (NOT IPPCRYPTO_FOUND)
      message(FATAL_ERROR "No Intel IPP Cryptography library found on the system.")
   endif()

   # If Intel IPP Cryptography is found, the following variables will be defined:
   #     `IPPCRYPTO_LIBRARIES` - static library name
   #     `IPPCRYPTO_INCLUDE_DIRS` - path to Intel IPP Cryptography headers
   #     `IPPCRYPTO_ROOT_DIR` - library root dir (a folder with 'include' and 'lib' directories)
