"""
Copyright 2019 Intel Corporation.

This software and the related documents are Intel copyrighted  materials,  and
your use of  them is  governed by the  express license  under which  they were
provided to you (License).  Unless the License provides otherwise, you may not
use, modify, copy, publish, distribute,  disclose or transmit this software or
the related documents without Intel's prior written permission.

This software and the related documents  are provided as  is,  with no express
or implied  warranties,  other  than those  that are  expressly stated  in the
License.

License:
http://software.intel.com/en-us/articles/intel-sample-source-code-license-agr
eement/
"""

from tool.utils import *

ENV_PREFIX = 'env_prefix'
ENV_POSTFIX = 'env_postfix'
DIR_SEPARATOR = 'separator'

OS_FAMILY = {
    WINDOWS: {
        ENV_PREFIX: '%',
        ENV_POSTFIX: '%',
        DIR_SEPARATOR: '\\'
    },
    UNIX: {
        ENV_PREFIX: '$',
        ENV_POSTFIX: '',
        DIR_SEPARATOR: '/'
    }
}

GENERATOR_FORMAT = {
    WINDOWS: {
        WINDOWS:  ':: Generates  {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + ':: Windows host, Windows target\n\n'
                  + 'if not exist "{destination}" '
                  + 'mkdir "{destination}"\n\n'
                  + '{sub_command}'
                  + '{compiler} {cmp_args} '
                  + '/I "%IPPROOT%\\include" "{main_file}" '
                  + '/Fo:"{main_object}"\n\n'
                  + '{linker} /DLL {linker_args} /VERBOSE:SAFESEH '
                  + '/DEF:"{export_file}" "{main_object}" '
                  + '/OUT:"{library_file}.dll" '
                  + '/IMPLIB:"{library_file}.lib" '
                  + '{libraries} '
                  + '{exp_libs}',

        ANDROID: ':: Generates {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + ':: Windows host, Android target\n\n'
                  + 'if not exist "{destination}" '
                  + 'mkdir "{destination}"\n\n'
                  + '{sub_command} '
                  + '"%%\\bin\\{compiler}" {cmp_args} '
                  + '-I"%IPPROOT%\\include" "{main_file}"  '
                  + '-o "{main_object}" \n\n'
                  + '"%ANDROID_GNU_X86_TOOLCHAIN%\\bin\\{linker}" {linker_args} '
                  + '-shared -z defs --sysroot="%ANDROID_SYSROOT%" '
                  + '-T "{export_file}" "{main_object}" '
                  + '-o "{library_file}.so" {libraries} '
                  + '-L "{sys_libs_path}" -lc -lm'
    },
    LINUX: {
        LINUX:    '#!/bin/bash\n'
                  + '# Generates {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + '# Linux host, Linux target\n\n'
                  + 'mkdir -p "{destination}"\n'
                  + '{sub_command}'
                  + '{compiler} {gcc_args} '
                  + '-I "${package}ROOT/include" "{main_file}" '
                  + '-o "{main_object}"\n'
                  + '{linker} -shared -z defs {ld_args} '
                  + '"{export_file}" "{main_object}" '
                  + '-o "{library_file}.so" {libraries} '
                  + '-L"{sys_libs_path}" -call_shared -lc -call_shared -lm '
                  + '-L"{compiler_libs_path}" -call_shared {exp_libs}',

        ANDROID:  '#!/usr/bin/env bash\n'
                  + '# Generates {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + '# Linux host, Android target\n\n'
                  + 'mkdir -p "{destination}"\n\n'
                  + '{sub_command}'
                  + '"$ANDROID_GNU_X86_TOOLCHAIN/bin/{compiler}" {cmp_args} '
                  + '-I "${package}ROOT/include" "{main_file}" '
                  + '-o "{main_object}"\n\n'
                  + '"$ANDROID_GNU_X86_TOOLCHAIN/bin/{linker}" {linker_args} '
                  + '-shared -z defs --sysroot="$ANDROID_SYSROOT" '
                  + '-T "{export_file}" "{main_object}" '
                  + '-o "{library_file}.so" {libraries} '
                  + '-L "{sys_libs_path}" -lc -lm'
    },
    MACOSX: {
        MACOSX:   '#!/bin/bash\n'
                  + '# Generates {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + '# MacOSX host, MacOSX target\n\n'
                  + 'mkdir -p "{destination}"\n\n'
                  + '{sub_command}'
                  + '{compiler} {clang_args} '
                  + '-I "${package}ROOT/include" "{main_file}" '
                  + '-o "{main_object}"\n\n'
                  + '{linker} {linker_args} '
                  + '-install_name @rpath/{library_name}.dylib '
                  + '-o "{library_file}.dylib" '
                  + '-exported_symbols_list "{export_file}" '
                  + '"{main_object}" {libraries} -lgcc_s.1 -lm '
                  + '-L"{compiler_lib_path}" {exp_libs}',

        ANDROID:  '# Generates {threading} dynamic library '
                  + 'for {architecture} architecture\n'
                  + '# macOSx host, Android target\n\n'
                  + 'mkdir -p "{destination}"\n\n'
                  + '{sub_command}'
                  + '"$ANDROID_GNU_X86_TOOLCHAIN/bin/{compiler}" {cmp_args} '
                  + '-I "${package}ROOT/include" "{main_file}" '
                  + '-o "{main_object}"\n\n'
                  + '"$ANDROID_GNU_X86_TOOLCHAIN/bin/{linker}" {linker_args} '
                  + '-shared -z defs --sysroot="$ANDROID_SYSROOT" '
                  + '-T "{export_file}" "{main_object}" '
                  + '-o "{library_file}.so" {libraries} '
                  + '-L "{sys_libs_path}" -lc -lm'
    }
}

COMPILERS = {
    WINDOWS: {
        INTEL64: 'cl.exe',
        IA32: 'cl.exe'
    },
    LINUX: {
        INTEL64: 'g++',
        IA32: 'g++'
    },
    MACOSX: {
        INTEL64: 'clang',
        IA32: 'clang'
    },
    ANDROID: {
        INTEL64: 'x86_64-linux-android-gcc',
        IA32: 'i686-linux-android-gcc'
    }
}

LINKERS = {
    WINDOWS: {
        INTEL64: 'link.exe',
        IA32: 'link.exe'
    },
    LINUX: {
        INTEL64: 'ld',
        IA32: 'ld'
    },
    MACOSX: {
        INTEL64: 'libtool',
        IA32: 'libtool'
    },
    ANDROID: {
        INTEL64: 'x86_64-linux-android-ld',
        IA32: 'i686-linux-android-ld'
    }
}

COMPILERS_FLAGS = {
    WINDOWS: {
        INTEL64: '/c /MT /GS /sdl /O2',
        IA32:    '/c /MT /GS /SafeSEH /sdl /O2'
    },
    LINUX: {
        INTEL64: '-c -m64 -fPIC -fPIE -fstack-protector-strong '
                 + '-fstack-protector -O2 -D_FORTIFY_SOURCE=2 '
                 + '-Wformat -Wformat-security',
        IA32:    '-c -m32 -fPIC -fPIE -fstack-protector-strong '
                 + '-fstack-protector -O2 -D_FORTIFY_SOURCE=2 '
                 + '-Wformat -Wformat-security'
    },
    MACOSX: {
        INTEL64: '-c -m64',
        IA32:    '-c -m32'
    },
    ANDROID: {
        INTEL64: '-c -m64 -fPIC -fPIE -fstack-protector-strong '
                 + '-fstack-protector -O2 -D_FORTIFY_SOURCE=2 '
                 + '-Wformat -Wformat-security',
        IA32:    '-c -m32 -fPIC -fPIE -fstack-protector-strong '
                 + '-fstack-protector -O2 -D_FORTIFY_SOURCE=2 '
                 + '-Wformat -Wformat-security'
    }
}

LINKER_FLAGS = {
    WINDOWS: {
        INTEL64: '/MACHINE:X64 /NXCompat /DynamicBase ',
        IA32:    '/MACHINE:X86 /SafeSEH /NXCompat /DynamicBase'
    },
    LINUX: {
        INTEL64: '-z noexecstack -z relro -z now',
        IA32:    '-m elf_i386 -z noexecstack -z relro -z now'
    },
    MACOSX: {
        INTEL64: '-dynamic -noall_load -single_module '
                 + '-flat_namespace -headerpad_max_install_names '
                 + '-current_version 2017.0 -compatibility_version 2017.0 '
                 + '-macosx_version_min 10.11 -arch_only x86_64',
        IA32:    '-dynamic -noall_load -single_module '
                 + '-flat_namespace -headerpad_max_install_names '
                 + '-current_version 2017.0 -compatibility_version 2017.0 '
                 + ' -macosx_version_min 10.11 -arch_only i386'
    },
    ANDROID: {
        INTEL64: '-z noexecstack -z relro -z now',
        IA32:    '-m elf_i386 -z noexecstack -z relro -z now'
    }
}

SYS_LIBS_PATH = {
    WINDOWS: {
        INTEL64: '',
        IA32: '',
    },
    LINUX: {
        INTEL64: '$SYSROOT/lib64',
        IA32: '$SYSROOT/lib'
    },
    MACOSX: {
        INTEL64: '',
        IA32: ''
    },
    ANDROID: {
        INTEL64: '$ANDROID_SYSROOT/usr/lib/x86_64-linux-android/',
        IA32: '$ANDROID_SYSROOT/usr/lib/i686-linux-android/'
    }
}

EXP_LIBS = {
    WINDOWS: {
        ThreadingLayerType.NONE: '',
        ThreadingLayerType.OPENMP: 'libiomp5md.lib',
        ThreadingLayerType.TBB: ''
    },
    LINUX: {
        ThreadingLayerType.NONE: '',
        ThreadingLayerType.OPENMP: '-liomp5',
        ThreadingLayerType.TBB: '-lstdc++'
    },
    MACOSX:  {
        ThreadingLayerType.NONE: '',
        ThreadingLayerType.OPENMP: '-liomp5',
        ThreadingLayerType.TBB: ''
    },
    ANDROID: {
        ThreadingLayerType.NONE: '',
        ThreadingLayerType.OPENMP: '',
        ThreadingLayerType.TBB: ''
    },
}

COMPILER_LIBS_PATH = {
    WINDOWS: {
        INTEL64: '',
        IA32: ''
    },
    LINUX: {
        INTEL64: '${package}ROOT/../compiler/lib/intel64_lin',
        IA32: '${package}ROOT/../compiler/lib/ia32_lin'
    },
    MACOSX: {
        INTEL64: '${package}ROOT/../compiler/lib/',
        IA32: '${package}ROOT/../compiler/lib/'
    },
    ANDROID: {
        INTEL64: '',
        IA32: ''
    }
}





