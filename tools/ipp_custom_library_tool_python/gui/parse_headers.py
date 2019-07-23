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

import re
from os import listdir

from tool import utils
from tool.clt_compilers_and_flags import *

DOMAINS = {
    'IPP TL': {
        'ippcc_tl': 'Color conversion TL',
        'ippcore_tl': 'Core TL',
        'ippi_tl': 'Image processing TL'
    },
    'Classical IPP': {
        'ippcc': 'Color conversion',
        'ippch': 'String manipulations',
        'ippcore': 'Core',
        'ippcv': 'Computer vision',
        'ippdc': 'Data compression',
        'ippi': 'Image processing',
        'ipps': 'Signal processing',
    },
    'IPP Cryptography': {
        'ippcp': 'Cryptography'
    }
}
FUNCTIONS_LIST = {
    'Classical IPP': {},
    'IPP TL': {},
    'IPP Cryptography': {}
}


def get_functions_from_headers(path):
    include_dir = os.path.join(path, 'include')
    files = [file for file in listdir(include_dir) if '.h' in file]

    # Parsing headers
    for file in files:
        mode, domain = get_mode_and_domain(file)
        if domain:
            header = open(os.path.join(include_dir, file), 'r')
            lines = header.readlines()

            necessary_lines = [line for line in lines if
                               re.compile(utils.FUNCTION_NAME_REGULAR_EXPRESSION).match(line)]
            functions = [re.match(utils.FUNCTION_NAME_REGULAR_EXPRESSION, line).group('function_name')
                         for line in necessary_lines]

            for func in functions:
                if DOMAINS[mode][domain] not in FUNCTIONS_LIST[mode].keys():
                    FUNCTIONS_LIST[mode].update({DOMAINS[mode][domain]: []})
                FUNCTIONS_LIST[mode].get(DOMAINS[mode][domain]).append(func.replace(' ', ''))


def get_mode_and_domain(file):
    for mode in DOMAINS.keys():
        for domain in DOMAINS[mode].keys():
            if domain in file:
                return mode, domain
    return '', ''
