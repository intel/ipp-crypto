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

import os
from subprocess import call  # nosec

from tool import utils
from tool.generators import main_file_generator, EXPORT_GENERATORS, build_script_generator, custom_dispatcher_generator, \
    rename_header_generator


def generate_script():
    """
    Generates build script
    """
    host        = utils.HOST_SYSTEM
    configs     = utils.CONFIGS

    package        = configs[utils.PACKAGE]
    functions_list = configs[utils.FUNCTIONS_LIST]
    output_path    = configs[utils.OUTPUT_PATH]

    if not os.path.exists(output_path):
        os.makedirs(output_path)

    with open(os.path.join(output_path, utils.MAIN_FILE_NAME), 'w') as main_file:
        main_file.write(main_file_generator())

    if configs[utils.CUSTOM_CPU_SET]:
        disp_folder = os.path.join(output_path, 'custom_dispatcher', configs[utils.ARCHITECTURE])
        if not os.path.exists(disp_folder):
            os.makedirs(disp_folder)

        functions_with_custom_disp = []
        for function in functions_list:
            if function not in package.functions_without_dispatcher:
                disp_file_path = os.path.join(disp_folder,
                                              utils.CUSTOM_DISPATCHER_FILE_NAME.format(function=function))
                functions_with_custom_disp.append(function)

                with open(disp_file_path, 'w') as disp_file:
                    disp_file.write(custom_dispatcher_generator(function))

        if configs[utils.PREFIX]:
            with open(os.path.join(disp_folder, utils.RENAME_HEADER_NAME), 'w') as rename_header:
                rename_header.write(rename_header_generator(functions_with_custom_disp))

    with open(os.path.join(output_path, utils.EXPORT_FILE[host]), 'w') as export_file:
        EXPORT_GENERATORS[host](export_file, functions_list)

    script_path = os.path.join(output_path, configs[utils.BUILD_SCRIPT_NAME])
    with open(script_path, 'w') as build_script:
        build_script.write(build_script_generator())
    os.chmod(script_path, 0o745)

    return os.path.exists(script_path)


def build():
    """
    Builds dynamic library

    :return: True if build was successful and False in the opposite case
    """
    success = generate_script()
    if not success:
        return False

    error = call([os.path.join(utils.CONFIGS[utils.OUTPUT_PATH],
                               utils.CONFIGS[utils.BUILD_SCRIPT_NAME])])
    return False if error else True
