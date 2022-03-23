"""
Copyright (C) 2022 Intel Corporation

SPDX-License-Identifier: MIT
"""
HOST_SYSTEM = ''

WINDOWS = 'Windows'
LINUX = 'Linux'
MACOSX = 'MacOSX'

TEMPORARY_FOLDER = './tmp'

INTEL64 = 'intel64'
IA32 = 'ia32'

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

EXPORT_FILES = {
    WINDOWS: 'export.def',
    LINUX: 'export.def',
    MACOSX: 'export.lib-export'
}

LIBRARIES_EXTENSIONS = {
    WINDOWS: '.dll',
    LINUX: '.so',
    MACOSX: '.dy'
}

LIBRARIES_PREFIX = {
    WINDOWS: '',
    LINUX: 'lib',
    MACOSX: 'lib'
}
