"""
Copyright 2018-2021 Intel Corporation.

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

ENV_VAR = {
    WINDOWS : '%{env_var}%',
    LINUX   : '${{{env_var}}}',
    MACOSX  : '${{{env_var}}}'
}

CALL_ENV_SCRIPT_COMMAND = {
    WINDOWS : 'call "{env_script}" {arch} {force_flag}',
    LINUX   : 'source "{env_script}" -arch {arch} {force_flag}',
    MACOSX  : 'source "{env_script}" -arch {arch} {force_flag}'
}

SET_ENV_COMMAND = {
    WINDOWS : 'set "{env_var}={path}"',
    LINUX   : 'export "{env_var}={path}"',
    MACOSX  : 'export "{env_var}={path}"'
}

ADDITIONAL_ENV = {
    WINDOWS : '',
    LINUX   : 'export LIBRARY_PATH=$LD_LIBRARY_PATH:$LIBRARY_PATH',
    MACOSX  : 'export LIBRARY_PATH=$DYLD_LIBRARY_PATH:$LIBRARY_PATH'
}

COMPILERS = {
    WINDOWS : 'cl.exe',
    LINUX   : 'g++',
    MACOSX  : 'clang'
}

LINKERS = {
    WINDOWS : 'link.exe',
    LINUX   : 'g++',
    MACOSX  : 'clang'
}

COMPILERS_FLAGS = {
    WINDOWS: {
        INTEL64 : '/c /MP /MT /GS /sdl /O2',
        IA32    : '/c /MP /MT /GS /sdl /O2'
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
        INTEL64 : '-c -m64',
        IA32    : '-c -m32'
    }
}

LINKER_FLAGS = {
    WINDOWS: {
        INTEL64 : '/MACHINE:X64 /NXCompat /DynamicBase ',
        IA32    : '/MACHINE:X86 /SafeSEH /NXCompat /DynamicBase'
    },
    LINUX: {
        INTEL64 : '-z noexecstack -z relro -z now',
        IA32    : '-m32 -z noexecstack -z relro -z now'
    },
    MACOSX: {
        INTEL64: '-dynamiclib -single_module '
                 + '-flat_namespace -headerpad_max_install_names '
                 + '-current_version 2017.0 -compatibility_version 2017.0',
        IA32:    '-dynamical -single_module '
                 + '-flat_namespace -headerpad_max_install_names '
                 + '-current_version 2017.0 -compatibility_version 2017.0'
    }
}

COMPILE_COMMAND_FORMAT = {
    WINDOWS: '{compiler} {cmp_flags} '
             '/I "%{root_type}%\\include" '
             '{c_files}',
    LINUX: '{compiler} {cmp_flags}'
           ' -I "${root_type}/include" '
           '{c_files}',
    MACOSX: '{compiler} {cmp_flags} '
            '-I "${root_type}/include" '
            '{c_files}'
}

LINK_COMMAND_FORMAT = {
    WINDOWS: '{linker} /DLL {link_flags} /VERBOSE:SAFESEH '
             '/DEF:"{export_file}" *.obj '
             '/OUT:"{custom_library}.dll" /IMPLIB:"{custom_library}.lib" '
             '{ipp_libraries} '
             '{exp_libs}',
    LINUX:   '{linker} -shared {link_flags} '
             '"{export_file}" *.o '
             '-o "{custom_library}.so" '
             '{ipp_libraries} '
             '-L"{sys_libs_path}" -lc -lm {exp_libs}',
    MACOSX:  '{linker} {link_flags} '
             '-install_name @rpath/{custom_library}.dylib '
             '-o "{custom_library}.dylib" '
             '-exported_symbols_list "{export_file}" *.o '
             '{ipp_libraries} '
             '-lgcc_s.1 -lm {exp_libs}'
}

SYS_LIBS_PATH = {
    WINDOWS: {
        INTEL64 : '',
        IA32    : '',
    },
    LINUX: {
        INTEL64 : '$SYSROOT/lib64',
        IA32    : '$SYSROOT/lib'
    },
    MACOSX: {
        INTEL64 : '',
        IA32    : ''
    }
}

EXP_LIBS = {
    WINDOWS: {
        SINGLE_THREADED : '',
        MULTI_THREADED  : 'libiomp5md.lib',
        TBB             : 'tbb.lib',
        OPENMP          : 'libiomp5md.lib'
    },
    LINUX: {
        SINGLE_THREADED : '',
        MULTI_THREADED  : '-liomp5',
        TBB             : '-ltbb',
        OPENMP          : '-liomp5'
    },
    MACOSX:  {
        SINGLE_THREADED : '',
        MULTI_THREADED  : '-liomp5',
        TBB             : '"${TBBROOT}/lib/libtbb.dylib"',
        OPENMP          : '-liomp5'
    }
}

MAIN_FILE = {
    WINDOWS: "#include <Windows.h>\n"
             "#include \"{package_type}.h\"\n\n"
             "int WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)\n"
             "{{\n"
             "    switch (fdwReason)\n"
             "    {{\n"
             "    case DLL_PROCESS_ATTACH:\n"
             "        {package_type}Init(); break;\n"
             "    case DLL_THREAD_ATTACH: break;\n"
             "    case DLL_THREAD_DETACH: break;\n"
             "    case DLL_PROCESS_DETACH: break;\n"
             "    default: break;\n"
             "    }}\n"
             "    return 1;\n"
             "    UNREFERENCED_PARAMETER(hinstDLL);\n"
             "    UNREFERENCED_PARAMETER(lpvReserved);\n"
             "}}\n",
    LINUX: "#include \"{package_type}.h\"\n\n"
           "int _init(void)\n"
           "{{\n"
           "    {package_type}Init();\n"
           "    return 1;\n"
           "}}\n\n"
           "void _fini(void)\n"
           "{{\n"
           "}}\n",
    MACOSX: "#include \"{package_type}.h\"\n\n"
            "__attribute__((constructor)) void initializer( void )\n"
            "{{\n"
            "    static int initialized = 0;\n"
            "    if (!initialized)\n"
            "    {{\n"
            "        initialized = 1;\n"
            "    }}\n\n"
            "    {package_type}Init();\n"
            "    return;\n"
            "}}\n\n"
            "__attribute__((destructor)) void destructor()\n"
            "{{\n"
            "}}\n"
}

CUSTOM_DISPATCHER_FILE = '{include_lines}\n'\
                         '#ifndef IPP_CALL\n' \
                         '#define IPP_CALL IPP_STDCALL\n' \
                         '#endif\n'\
                         '#define IPPFUN(type,name,arg) extern type IPP_CALL name arg\n\n'\
                         '#ifndef NULL\n'\
                         '#ifdef  __cplusplus\n'\
                         '#define NULL    0\n'\
                         '#else\n'\
                         '#define NULL    ((void *)0)\n'\
                         '#endif\n'\
                         '#endif\n\n'\
                         '{architecture}\n'\
                         '{features}\n'\
                         '#ifdef __cplusplus\n'\
                         'extern "C" {{\n'\
                         '#endif\n\n'\
                         '{dispatcher}'\
                         '#ifdef __cplusplus\n'\
                         '}}\n'\
                         '#endif\n\n'\
                         '#endif\n'

RENAME_FORMAT = '#define {function} {prefix}{function}'

INCLUDE_STR = '#include "{header_name}"\n'

ARCHITECTURE_DEFINE = {
    IA32    : '#if !defined (_M_AMD64) && !defined (__x86_64__)',
    INTEL64 : '#if defined (_M_AMD64) || defined (__x86_64__)'
}

FEATURES = {
    IA32: '',
    INTEL64: '\n#define AVX3I_FEATURES ( ippCPUID_SHA|ippCPUID_AVX512VBMI|'
             'ippCPUID_AVX512VBMI2|ippCPUID_AVX512IFMA|ippCPUID_AVX512GFNI|'
             'ippCPUID_AVX512VAES|ippCPUID_AVX512VCLMUL )\n'
             '#define AVX3X_FEATURES ( ippCPUID_AVX512F|ippCPUID_AVX512CD|'
             'ippCPUID_AVX512VL|ippCPUID_AVX512BW|ippCPUID_AVX512DQ )\n'
             '#define AVX3M_FEATURES ( ippCPUID_AVX512F|ippCPUID_AVX512CD|'
             'ippCPUID_AVX512PF|ippCPUID_AVX512ER )\n'
}

FUNCTION_DISPATCHER = '{ippapi}\n'\
                      '{ippfun}\n'\
                      '{{\n'\
                      '    Ipp64u _features;\n'\
                      '    _features = {package_type}GetEnabledCpuFeatures();\n\n'\
                      '{dispatching_scheme}'\
                      '}}\n\n'

DISPATCHING_SCHEME_FORMAT = '    if( {cpuid}  == ( _features & {cpuid}  )) {{\n'\
                            '        return {function}( {args} );\n'\
                            '    }} else \n'

RETURN_VALUES = {
    'IppStatus' : 'ippStsCpuNotSupportedErr',
    'IppiRect'  : '(IppiRect) { IPP_MIN_32S / 2, IPP_MIN_32S / 2, '
                               'IPP_MAX_32S, IPP_MAX_32S }',
    'void'      : '',
    'default'   : 'NULL'
}

BUILD_SCRIPT = {
    WINDOWS: ':: Generates {threading} dynamic library '
             + 'for {architecture} architecture\n'
             + '@echo off\n'
             + 'set "OUTPUT_PATH={output_path}"\n'
             + 'if not exist %OUTPUT_PATH% mkdir %OUTPUT_PATH%\n'
             + 'cd /d %OUTPUT_PATH%\n\n'
             + 'if exist "{custom_library}.dll" del "{custom_library}.dll"\n\n'
             + 'setlocal\n'
             + '{env_commands}\n'
             + '{compile_command}\n'
             + '{link_command}\n'
             + 'endlocal\n\n'
             + 'if %ERRORLEVEL%==0 (\n'
             + '    echo Build completed!\n'
             + '    del /s /q /f *.obj > nul\n'
             + '    exit /b 0\n'
             + ') else (\n'
             + '    echo Build failed!\n'
             + '    exit /b 1\n'
             + ')',
    LINUX: '#!/bin/bash\n'
           + '# Generates {threading} dynamic library '
           + 'for {architecture} architecture\n'
           + 'OUTPUT_PATH="{output_path}"\n'
           + 'mkdir -p $OUTPUT_PATH\n'
           + 'cd $OUTPUT_PATH\n\n'
           + 'rm -rf "{custom_library}.so"\n\n'
           + '{env_commands}\n'
           + '{compile_command}\n'
           + '{link_command}\n'
           + 'if [ $? == 0 ]; then\n'
           + '    echo Build completed!\n'
           + '    rm -rf *.o\n'
           + '    exit 0\n'
           + 'else\n'
           + '    echo Build failed!\n'
           + '    exit 1\n'
           + 'fi',
    MACOSX: '#!/bin/bash\n'
            + '# Generates {threading} dynamic library '
            + 'for {architecture} architecture\n'
            + 'OUTPUT_PATH="{output_path}"\n'
            + 'mkdir -p $OUTPUT_PATH\n'
            + 'cd $OUTPUT_PATH\n\n'
            + 'rm -rf "{custom_library}.dylib"\n\n'
            + '{env_commands}\n'
            + '{compile_command}\n'
            + '{link_command}\n\n'
            + 'if [ $? == 0 ]; then\n'
            + '    echo Build completed!\n'
            + '    rm -rf *.o\n'
            + '    exit 0\n'
            + 'else\n'
            + '    echo Build failed!\n'
            + '    exit 1\n'
            + 'fi'
}
