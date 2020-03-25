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

import sys
import os
from argparse import ArgumentParser
from sys import platform

import tool.utils
from tool.core import build, generate_script

if __name__ == '__main__':
    if platform == "linux" or platform == "linux2":
        tool.utils.HOST_SYSTEM = tool.utils.LINUX
    elif platform == "darwin":
        tool.utils.HOST_SYSTEM = tool.utils.MACOSX
    elif platform == "win32":
        tool.utils.HOST_SYSTEM = tool.utils.WINDOWS

    arguments_parser = ArgumentParser()
    arguments_parser.add_argument('-c', '--console',
                                  help='Turns on console version of tool',
                                  action='store_true')
    arguments_parser.add_argument('-cp', '--cryptography',
                                  help='Build DLL with Intel® Integrated Performance Primitives Cryptography '
                                       'functionalities',
                                  action='store_true')
    arguments_parser.add_argument('-f', '--function',
                                  help='Name of function that has to be in final dynamic library (appendable)',
                                  action='append')
    arguments_parser.add_argument('-ff', '--functions-file',
                                  help='Path to file with functions list of functions')
    arguments_parser.add_argument('-n', '--name',
                                  help='Name of final dynamic library')
    arguments_parser.add_argument('-p', '--path',
                                  help='Path to output directory')
    arguments_parser.add_argument('-ia32',
                                  help='All actions will be done for this architecture (may be used with flag -intel64)',
                                  action='store_true')
    arguments_parser.add_argument('-intel64',
                                  help='All actions will be done for this architecture (may be used with flag -ia32)',
                                  action='store_true')
    arguments_parser.add_argument('-mt', '--multi-threaded',
                                  help='Enables building of multi-threaded dynamic library',
                                  action='store_true')
    arguments_parser.add_argument('-g', '--generate',
                                  help='Enables just script generating without building',
                                  action='store_true')
    arguments_parser.add_argument('-ts', '--target-system',
                                  help='Specifies target system [' + tool.utils.HOST_SYSTEM + ']')
    arguments_parser.add_argument('-cnl',
                                  help='Path to compilers_and_libraries directory')
    arguments_parser.add_argument('-tbb',
                                  help='Set TBB as threading layer',
                                  action='store_true')
    arguments_parser.add_argument('-omp',
                                  help='Set OpenMP as threading layer',
                                  action='store_true'
                                  )
    args = arguments_parser.parse_args()

    if args.console:
        print('Intel® Integrated Performance Primitives Custom Library Tool console version is on...')
        mandatory_domains = ['ippi_tl', 'ippi', 'ipps', 'ippcore', 'ippvm']
        domains = set()
        functions = []

        if not args.cryptography:
            package = tool.utils.IPP
            root = tool.utils.IPPROOT
        else:
            package = tool.utils.IPPCP
            root = tool.utils.IPPCRYPTOROOT

        thread_mode = (tool.utils.MULTI_THREADED if args.multi_threaded else tool.utils.SINGLE_THREADED)
        threading_layer_type = tool.utils.ThreadingLayerType.NONE
        target_system = args.target_system if args.target_system else tool.utils.HOST_SYSTEM
        path = os.path.abspath(args.path)
        build_status = False

        if args.tbb:
            threading_layer_type = tool.utils.ThreadingLayerType.TBB
        if args.omp:
            threading_layer_type = tool.utils.ThreadingLayerType.OPENMP

        if not tool.utils.SUPPORTED_ARCHITECTURES[target_system][tool.utils.IA32] and args.ia32:
            print("Architecture x86 isn't supported, for chosen OS")
            exit(0)

        if not tool.utils.SUPPORTED_ARCHITECTURES[target_system][tool.utils.INTEL64] and args.intel64:
            print("Architecture x64 isn't supported, for chosen OS")
            exit(0)

        if not os.path.exists(path):
            os.makedirs(path)

        if args.functions_file:
            with open(args.functions_file, 'r') as functions_list:
                functions += map(lambda x: x.replace('\n', ''), functions_list.readlines())
        if args.function:
            functions += args.function

        if not os.getenv(root) or not os.path.exists(os.environ[root]):
            print('Please, set ' + root)
            exit()

        tool.utils.COMPILERS_AND_LIBRARIES_PATH = args.cnl

        if args.generate:
            if args.ia32:
                generate_script(package,
                                tool.utils.HOST_SYSTEM,
                                target_system,
                                functions,
                                path,
                                args.name,
                                tool.utils.IA32,
                                args.multi_threaded,
                                threading_layer_type)
            if args.intel64:
                generate_script(package,
                                tool.utils.HOST_SYSTEM,
                                target_system,
                                functions,
                                path,
                                args.name,
                                tool.utils.INTEL64,
                                args.multi_threaded,
                                threading_layer_type)
            print('Generation completed!')

        else:
            if args.ia32:
                build(package,
                      tool.utils.HOST_SYSTEM,
                      target_system,
                      functions,
                      path,
                      args.name,
                      tool.utils.IA32,
                      args.multi_threaded,
                      args.cnl,
                      threading_layer_type)
            if args.intel64:
                build(package,
                      tool.utils.HOST_SYSTEM,
                      target_system,
                      functions,
                      path,
                      args.name,
                      tool.utils.INTEL64,
                      args.multi_threaded,
                      args.cnl,
                      threading_layer_type)
    else:
        from PyQt5.QtWidgets import QApplication
        from gui.app import MainAppWindow

        app = QApplication(sys.argv)
        ex = MainAppWindow()
        sys.exit(app.exec_())
