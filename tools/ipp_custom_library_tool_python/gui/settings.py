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
from tool.utils import IPP, IPPCP

PACKAGE = 'package...'
PLATFORM = 'architecture...'
LIB_NAME = 'library name...'
FUNCTIONS = 'any function... '
ANDK = 'Android NDK...'

AUTOBUILD_BUTTON_RULES = {
    PACKAGE: True,
    PLATFORM: True,
    LIB_NAME: True,
    FUNCTIONS: True,
    ANDK: True
}

SCRIPT_BUTTON_GENERATOR_RULES = {
    PACKAGE: True,
    PLATFORM: True,
    LIB_NAME: True,
    FUNCTIONS: True
}

CONFIGS = {
    IPP: {
        'Path': '',
        'TL': False,
        'OpenMP': False,
        'TBB': False,
        'intel64': False,
        'IA32': False,
        'Multi-threaded': False,
        'functions_list': []
    },
    IPPCP: {
        'Path': '',
        'TL': False,
        'OpenMP': False,
        'TBB': False,
        'intel64': False,
        'IA32': False,
        'Multi-threaded': False,
        'functions_list': []
    }
}
