"""
Copyright 2019-2020 Intel Corporation.

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

import os
from enum import Enum

IPP = 'IPP'
IPPCP = 'IPPCP'
IPPROOT = 'IPPROOT'
IPPCRYPTOROOT = 'IPPCRYPTOROOT'
WINDOWS = 'Windows'
UNIX = 'Unix'
LINUX = 'Linux'
MACOSX = 'macOS'
ANDROID = 'Android'
TEMPORARY_FOLDER = './tmp'
MAIN_FILE = 'main.c'
LIB = 'lib'
INTEL64 = 'intel64'
IA32 = 'ia32'
PROJECT_EXTENSION = '.cltproj'
COMPILERS_AND_LIBRARIES_PATH = ''
ANDROID_NDK_PATH = ''
SINGLE_THREADED = 'Single-threaded'
MULTI_THREADED = 'Multi-threaded'
THREADING_LAYER = 'Threading layer'
HOST_SYSTEM = WINDOWS
PATH_TO_PACKAGE_REGULAR_EXPRESSION = '(?P<path>.*).tools'
VERSION_REGULAR_EXPRESSION = '.*VERSION_STR.*"(?P<ver>.*)".*'
PATH_TO_CNL_REGULAR_EXPRESSION = '(?P<cnl>.*compilers_and_libraries\w*)\W.*'
FUNCTION_NAME_REGULAR_EXPRESSION = 'IPPAPI\s*\(.*,\s*(?P<function_name>\S*)\s*,.*'
TBB_EXP_LIB = ' "$TBB_PATH/lib/libtbb.dylib"'


class ThreadingLayerType(Enum):
    NONE = 1
    OPENMP = 2
    TBB = 3


# Positions:
# 0 - architecture
# 1 - OpenMP/TBB
LIBRARIES_LIST = {
    WINDOWS: {
        WINDOWS: {
            IPP: {
                SINGLE_THREADED: [
                    '{0}\\ippccmt.lib',
                    '{0}\\ippchmt.lib',
                    '{0}\\ippcvmt.lib',
                    '{0}\\ippdcmt.lib',
                    '{0}\\ippemt.lib',
                    '{0}\\ippimt.lib',
                    '{0}\\ippsmt.lib',
                    '{0}\\ippcoremt.lib',
                    '{0}\\ippvmmt.lib',
                ],
                MULTI_THREADED: [
                    '{0}\\threaded\\ippccmt.lib',
                    '{0}\\threaded\\ippchmt.lib',
                    '{0}\\threaded\\ippcvmt.lib',
                    '{0}\\threaded\\ippdcmt.lib',
                    '{0}\\threaded\\ippemt.lib',
                    '{0}\\threaded\\ippimt.lib',
                    '{0}\\threaded\\ippsmt.lib',
                    '{0}\\threaded\\ippcoremt.lib',
                    '{0}\\threaded\\ippvmmt.lib',
                ],
                THREADING_LAYER: [
                    '{0}\\tl\\{1}\\ippccmt_tl.lib',
                    '{0}\\tl\\{1}\\ippimt_tl.lib',
                    '{0}\\tl\\{1}\\ippcoremt_tl.lib'
                ]
            },
            IPPCP: {
                SINGLE_THREADED: ['{0}\\ippcpmt.lib'],
                MULTI_THREADED: ['{0}\\threaded\\ippcpmt.lib'],
                THREADING_LAYER: []
            }
        },
        ANDROID: {
            IPP: {
                SINGLE_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                MULTI_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                THREADING_LAYER: []
            },
            IPPCP: {
                SINGLE_THREADED: ['{0}/libippcp.a'],
                MULTI_THREADED: ['{0}/libippcp.a'],
                THREADING_LAYER: []
            }
        }
    },
    LINUX: {
        LINUX: {
            IPP: {
                SINGLE_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                MULTI_THREADED: [
                    '{0}/threaded/libippcc.a',
                    '{0}/threaded/libippch.a',
                    '{0}/threaded/libippcv.a',
                    '{0}/threaded/libippdc.a',
                    '{0}/threaded/libippe.a',
                    '{0}/threaded/libippi.a',
                    '{0}/threaded/libipps.a',
                    '{0}/threaded/libippcore.a',
                    '{0}/threaded/libippvm.a'
                ],
                THREADING_LAYER: [
                    '{0}/tl/{1}/libippcc_tl.a',
                    '{0}/tl/{1}/libippi_tl.a',
                    '{0}/tl/{1}/libippcore_tl.a'
                ]
            },
            IPPCP: {
                SINGLE_THREADED: ['{0}/libippcp.a'],
                MULTI_THREADED: ['{0}/threaded/libippcp.a'],
                THREADING_LAYER: []
            }
        },
        ANDROID: {
            IPP: {
                SINGLE_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                MULTI_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                THREADING_LAYER: []
            },
            IPPCP: {
                SINGLE_THREADED: ['{0}/libippcp.a'],
                MULTI_THREADED: ['{0}/libippcp.a'],
                THREADING_LAYER: []
            }
        }
    },
    MACOSX: {
        # when macOS x32 will be available just add "{0}/" and all will be good
        MACOSX: {
            IPP: {
                SINGLE_THREADED: [
                    'libippcc.a',
                    'libippch.a',
                    'libippcv.a',
                    'libippdc.a',
                    'libippe.a',
                    'libippi.a',
                    'libipps.a',
                    'libippcore.a',
                    'libippvm.a'
                ],
                MULTI_THREADED: [
                    'threaded/libippcc.a',
                    'threaded/libippch.a',
                    'threaded/libippcv.a',
                    'threaded/libippdc.a',
                    'threaded/libippe.a',
                    'threaded/libippi.a',
                    'threaded/libipps.a',
                    'threaded/libippcore.a',
                    'threaded/libippvm.a'
                ],
                THREADING_LAYER: [
                    'tl/{1}/libippcc_tl.a',
                    'tl/{1}/libippi_tl.a',
                    'tl/{1}/libippcore_tl.a'
                ]
            },
            IPPCP: {
                SINGLE_THREADED: ['libippcp.a'],
                MULTI_THREADED: ['threaded/libippcp.a'],
                THREADING_LAYER: []
            }
        },
        ANDROID: {
            IPP: {
                SINGLE_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                MULTI_THREADED: [
                    '{0}/libippcc.a',
                    '{0}/libippch.a',
                    '{0}/libippcv.a',
                    '{0}/libippdc.a',
                    '{0}/libippe.a',
                    '{0}/libippi.a',
                    '{0}/libipps.a',
                    '{0}/libippcore.a',
                    '{0}/libippvm.a'
                ],
                THREADING_LAYER: []
            },
            IPPCP: {
                SINGLE_THREADED: ['{0}/libippcp.a'],
                MULTI_THREADED: ['{0}/libippcp.a'],
                THREADING_LAYER: []
            }
        }
    }
}

BUILD_SCRIPT = {
    INTEL64: {
        WINDOWS: 'intel64.bat',
        LINUX: 'intel64.sh',
        MACOSX: 'intel64.sh'
    },
    IA32: {
        WINDOWS: 'ia32.bat',
        LINUX: 'ia32.sh',
        MACOSX: 'ia32.sh'
    }
}

MAIN_FILES = {
    WINDOWS: "#include <Windows.h>\n"
             "#include \"{package}.h\"\n\n"
             "int WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)\n"
             "{{\n"
             "    switch (fdwReason)\n"
             "    {{\n"
             "    case DLL_PROCESS_ATTACH:\n"
             "        {package}Init(); break;\n"
             "    case DLL_THREAD_ATTACH: break;\n"
             "    case DLL_THREAD_DETACH: break;\n"
             "    case DLL_PROCESS_DETACH: break;\n"
             "    default: break;\n"
             "    }}\n"
             "    return 1;\n"
             "    UNREFERENCED_PARAMETER(hinstDLL);\n"
             "    UNREFERENCED_PARAMETER(lpvReserved);\n"
             "}}\n",
    LINUX: "#include \"{package}.h\"\n\n"
           "int _init(void)\n"
           "{{\n"
           "    {package}Init();\n"
           "    return 1;\n"
           "}}\n\n"
           "void _fini(void)\n"
           "{{\n"
           "}}\n",
    MACOSX: "#include \"{package}.h\"\n\n"
            "__attribute__((constructor)) void initializer( void )\n"
            "{{\n"
            "    static int initialized = 0;\n"
            "    if (!initialized)\n"
            "    {{\n"
            "        initialized = 1;\n"
            "    }}\n\n"
            "    {package}Init();\n"
            "    return;\n"
            "}}\n\n"
            "__attribute__((destructor)) void destructor()\n"
            "{{\n"
            "}}\n",
    ANDROID: "#include \"{package}.h\"\n\n"
             "int _init(void)\n"
             "{{\n"
             "    {package}Init();\n"
             "    return 1;\n"
             "}}\n\n"
             "void _fini(void)\n"
             "{{\n"
             "}}\n"
}

EXPORT_FILES = {
    WINDOWS: 'export.def',
    LINUX: 'export.def',
    MACOSX: 'export.lib-export',
    ANDROID: 'export.def'
}

BUILD_COMMANDS = {
    WINDOWS: {
        WINDOWS: lambda package_path, architecture: 'call "' + os.path.join(package_path,
                                                                            'windows',
                                                                            'bin',
                                                                            'compilervars.bat')
                                                    + '" ' + architecture + '\n',
        ANDROID: lambda package_path, architecture: 'call "' + os.path.join(package_path,
                                                                            'linux',
                                                                            'bin',
                                                                            'compilervars.bat')
                                                    + '" -arch ' + architecture
                                                    + ' -platform android\n'
                                                    + 'set ANDROID_GNU_X86_TOOLCHAIN='
                                                    + ANDROID_NDK_PATH + '\\toolchains\\x86'
                                                    + ('_64' if architecture == INTEL64 else '')
                                                    + '-4.9\\prebuilt\\windows-x86_64\n'
                                                    + 'set ANDROID_SYSROOT='
                                                    + ANDROID_NDK_PATH + '\\sysroot\n'
    },
    LINUX: {
        LINUX: lambda package_path, architecture: 'source "' + os.path.join(package_path,
                                                                            'linux',
                                                                            'bin',
                                                                            'compilervars.sh')
                                                  + '" -arch ' + architecture + '\n',
        ANDROID: lambda package_path, architecture: 'source "' + os.path.join(package_path,
                                                                              'linux',
                                                                              'bin',
                                                                              'compilervars.sh')
                                                    + '" -arch ' + architecture
                                                    + ' -platform android\n'
                                                    + 'export ANDROID_GNU_X86_TOOLCHAIN='
                                                    + ANDROID_NDK_PATH + '/toolchains/x86'
                                                    + ('_64' if architecture == INTEL64 else '')
                                                    + '-4.9/prebuilt/linux-x86_64\n'
                                                    + 'export ANDROID_SYSROOT='
                                                    + ANDROID_NDK_PATH + '/sysroot\n'
    },
    MACOSX: {
        MACOSX: lambda package_path, architecture: 'source "' + os.path.join(package_path,
                                                                             'mac',
                                                                             'bin',
                                                                             'compilervars.sh')
                                                   + '" -arch ' + architecture + '\n',
        ANDROID: lambda package_path, architecture: 'source "' + os.path.join(package_path,
                                                                              'mac',
                                                                              'bin',
                                                                              'compilervars.sh')
                                                    + '" -arch ' + architecture
                                                    + ' -platform android\n'
                                                    + 'export ANDROID_GNU_X86_TOOLCHAIN='
                                                    + ANDROID_NDK_PATH + '/toolchains/x86'
                                                    + ('_64' if architecture == INTEL64 else '')
                                                    + '-4.9/prebuilt/darwin-x86_64\n'
                                                    + 'export ANDROID_SYSROOT='
                                                    + ANDROID_NDK_PATH + '/sysroot\n'
    }
}

BATCH_EXTENSIONS = {
    WINDOWS: '.bat',
    LINUX: '.sh',
    MACOSX: '.sh'
}

LIBRARIES_EXTENSIONS = {
    WINDOWS: '.dll',
    LINUX: '.so',
    MACOSX: '.dylib',
    ANDROID: '.so'
}

STATIC_LIBRARIES_EXTENSIONS = {
    WINDOWS: 'mt.lib',
    LINUX: '.a',
    MACOSX: '.a',
    ANDROID: '.a'
}

LIBRARIES_PREFIX = {
    WINDOWS: '',
    LINUX: LIB,
    MACOSX: LIB,
    ANDROID: LIB
}

SUPPORTED_ARCHITECTURES = {
    WINDOWS: {
        INTEL64: True,
        IA32: True
    },
    LINUX: {
        INTEL64: True,
        IA32: True
    },
    ANDROID: {
        INTEL64: True,
        IA32: True
    },
    MACOSX: {
        INTEL64: True,
        IA32: False}
}
ONLY_THREADABLE = {
    WINDOWS: False,
    LINUX: False,
    ANDROID: True,
    MACOSX: False
}
