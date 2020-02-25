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
from subprocess import call  # nosec

import tool.utils
from tool.generators import EXPORT_GENERATORS, GENERATORS


def generate_script(package,
                    system_host,
                    system_target,
                    functions_list,
                    library_path,
                    library_name,
                    architecture,
                    multi_threaded,
                    threading_layer_type,
                    sub_command=''):
    """
    Generates build script according to given parameters

    :param package: Intel® Integrated Performance Primitives/Intel® Integrated Performance Primitives Cryptography package
    :param system_host: name of host system
    :param system_target: name of target system
    :param functions_list: list of functions that are to be in dynamic library
    :param library_path: path to directory where script has to appear
    :param library_name: name of dynamic library
    :param architecture: name of target architecture
    :param multi_threaded: use multi-threaded libraries if set to True
    :param sub_command: command that is going to be executed before building and linking
    """
    if not os.path.exists(library_path):
        os.makedirs(library_path)

    with open(os.path.join(library_path, tool.utils.MAIN_FILE), 'w') as main_file:
        main_file.write(tool.utils.MAIN_FILES[system_target].format(package=package.lower()))

    with open(os.path.join(library_path, tool.utils.EXPORT_FILES[system_target]), 'w') as export_file:
        EXPORT_GENERATORS[system_target](export_file, functions_list)

    with open(os.path.join(library_path, tool.utils.BUILD_SCRIPT[architecture][system_host]), 'w') as build_script:
        build_script.write(GENERATORS[system_host][system_target](package,
                                                                  library_path,
                                                                  library_name,
                                                                  architecture,
                                                                  multi_threaded=multi_threaded,
                                                                  threading_layer_type=threading_layer_type,
                                                                  sub_command=sub_command))
    os.chmod(os.path.join(library_path, tool.utils.BUILD_SCRIPT[architecture][system_host]), 0o745)


def build(package,
          system_host,
          system_target,
          functions_list,
          library_path,
          library_name,
          architecture,
          multi_threaded,
          package_path,
          threading_layer_type):
    """
    Builds dynamic library according to given parameters

    :param omp: should be True if there is need in support of TL implemented with OpenMP
    :param system_host: name of host system
    :param system_target: name of target system
    :param functions_list: list of functions that are to be in dynamic library
    :param library_path: path to directory where script has to appear
    :param library_name: name of dynamic library
    :param architecture: name of target architecture
    :param multi_threaded: use multi-threaded libraries if set to True
    :param package_path: path to compilers_and_libraries directory
    :return: True if build was successful and False in the opposite case
    """

    generate_script(package,
                    system_host,
                    system_target,
                    functions_list,
                    library_path,
                    library_name,
                    architecture,
                    multi_threaded,
                    threading_layer_type=threading_layer_type,
                    sub_command=tool.utils.BUILD_COMMANDS[system_host][system_target](package_path, architecture)
                    )
    script_path = os.path.join(library_path, tool.utils.BUILD_SCRIPT[architecture][system_host])
    call([script_path])  # nosec
    os.remove(os.path.join(library_path, tool.utils.MAIN_FILE))
    os.remove(os.path.join(library_path, tool.utils.BUILD_SCRIPT[architecture][system_host]))
    os.remove(os.path.join(library_path, tool.utils.EXPORT_FILES[system_target]))

    return os.path.exists(os.path.join(library_path,
                                       architecture,
                                       tool.utils.LIBRARIES_PREFIX[system_target]
                                       + library_name
                                       + tool.utils.LIBRARIES_EXTENSIONS[system_target]))