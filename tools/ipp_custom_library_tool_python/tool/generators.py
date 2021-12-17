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
from tool import utils
from tool.generators_utils import *


def main_file_generator():
    return MAIN_FILE[utils.HOST_SYSTEM].format(package_type=utils.CONFIGS[PACKAGE].type.lower())


def create_windows_export_file(export_file, functions_list):
    """
    Creates export file for Windows

    :param export_file: object that is returned by open function
    :param functions_list: list of functions for dynamic library
    """
    export_file.write('EXPORTS\n\n')
    export_file.writelines(map(lambda x: x + '\n', functions_list))


def create_linux_export_file(export_file, functions_list):
    """
    Creates Linux export file

    :param export_file:
    :param functions_list:
    :return:
    """
    export_file.writelines(map(lambda x: 'EXTERN(' + x + ')\n', functions_list))
    export_file.write('\nVERSION\n'
                      '{\n'
                      '    {\n'
                      '        global:\n'
                      + ''.join(
        map(lambda x: '        ' + x + ';\n', functions_list)) +
                      '        local:* ;\n'
                      '    };\n'
                      '}\n')


def create_macosx_export_file(export_file, functions_list):
    """
    Creates MacOSX export file

    :param export_file: object that is returned by open function
    :param functions_list: list of functions for dynamic library
    """
    export_file.writelines(map(lambda x: '_' + x + '\n', functions_list))


EXPORT_GENERATORS = {
    WINDOWS: create_windows_export_file,
    LINUX: create_linux_export_file,
    MACOSX: create_macosx_export_file
}


def custom_dispatcher_generator(function):
    package       = utils.CONFIGS[PACKAGE]
    arch          = utils.CONFIGS[ARCHITECTURE]
    include_lines = INCLUDE_STR.format(header_name=package.type.lower() + '.h')

    dispatcher = ''
    dispatcher += func_dispatcher_generator(arch, function)

    ippe = utils.DOMAINS[IPP]['ippe']
    if ippe in package.functions[IPP].keys() and \
            function in package.functions[IPP][ippe]:
        include_lines += INCLUDE_STR.format(header_name='ippe.h')

    if utils.CONFIGS[PREFIX]:
        include_lines += INCLUDE_STR.format(header_name=RENAME_HEADER_NAME)

    return CUSTOM_DISPATCHER_FILE.format(include_lines=include_lines,
                                         architecture=ARCHITECTURE_DEFINE[arch],
                                         features=FEATURES[arch],
                                         dispatcher=dispatcher)


def rename_header_generator(functions_list):
    content = ''
    for function in functions_list:
        content += RENAME_FORMAT.format(function=function,
                                        prefix=utils.CONFIGS[PREFIX])

    return content


def func_dispatcher_generator(arch, function):
    package_type = utils.CONFIGS[PACKAGE].type
    declarations = utils.CONFIGS[PACKAGE].declarations[function]
    ippfun = declarations.replace('IPPAPI', 'IPPFUN').replace(function, utils.CONFIGS[PREFIX] + function)

    args = utils.get_match(utils.FUNCTION_NAME_REGEX, declarations, 'args').split(',')
    args = [utils.get_match(utils.ARGUMENT_REGEX, arg, 'arg') for arg in args]
    args = ', '.join(args)

    ippapi = ''
    dispatching_scheme = ''
    for cpu in CPUID.keys():
        if cpu not in utils.CONFIGS[CUSTOM_CPU_SET]:
            continue

        cpuid    = CPUID[cpu]
        cpu_code = CPU[cpu][arch]

        function_with_cpu_code = cpu_code + '_' + function
        ippapi += declarations.replace(function, function_with_cpu_code) + '\n'

        dispatching_scheme += DISPATCHING_SCHEME_FORMAT.format(cpuid=cpuid,
                                                               function=function_with_cpu_code,
                                                               args=args)

    ret_type = utils.get_match(utils.FUNCTION_NAME_REGEX, declarations, 'ret_type')
    ret_value = get_dict_value(RETURN_VALUES, ret_type)

    dispatching_scheme += '        return ' + ret_value + ';\n'
    if not ret_value:
        dispatching_scheme = dispatching_scheme.replace('return', '')

    return FUNCTION_DISPATCHER.format(ippapi=ippapi,
                                      ippfun=ippfun,
                                      package_type=package_type.lower(),
                                      dispatching_scheme=dispatching_scheme)


def build_script_generator():
    """
    Generates script for building custom dynamic library
    :return: String that represents script
    """
    host    = utils.HOST_SYSTEM
    configs = utils.CONFIGS

    package     = configs[PACKAGE]
    output_path = configs[OUTPUT_PATH]

    arch   = configs[ARCHITECTURE]
    thread = configs[THREAD_MODE]
    tl     = configs[THREADING_LAYER]

    root_type = (IPPROOT if package.type == IPP else IPPCRYPTOROOT)

    if package.env_script:
        force_flag = ''
        if 'setvars' in package.env_script:
            force_flag = '--force'

        env_commands = CALL_ENV_SCRIPT_COMMAND[host].format(env_script=package.env_script,
                                                            arch=arch,
                                                            force_flag=force_flag)
    else:
        env_commands = SET_ENV_COMMAND[host].format(env_var=root_type,
                                                    path=package.root)
    if ADDITIONAL_ENV[host]:
        env_commands += '\n' + ADDITIONAL_ENV[host]

    compiler  = COMPILERS[host]

    cmp_flags = COMPILERS_FLAGS[host][arch]
    if tl == OPENMP and host == WINDOWS:
        cmp_flags += ' /openmp'

    c_files = MAIN_FILE_NAME
    if configs[utils.CUSTOM_CPU_SET]:
        c_files   += ' ' + os.path.join('custom_dispatcher', arch, '*.c')

    compile_command = COMPILE_COMMAND_FORMAT[host].format(compiler=compiler,
                                                           cmp_flags=cmp_flags,
                                                           root_type=root_type,
                                                           c_files=c_files)

    linker         = LINKERS[host]
    link_flags     = LINKER_FLAGS[host][arch]
    custom_library = LIB_PREFIX[host] + configs[CUSTOM_LIBRARY_NAME]
    export_file    = EXPORT_FILE[host]

    ipp_libraries = package.libraries[arch][thread]
    if tl:
        ipp_libraries = package.libraries[arch][tl] + ipp_libraries
    ipp_libraries = [lib.replace(package.root, ENV_VAR[host].format(env_var=root_type))
                     for lib in ipp_libraries]
    ipp_libraries = ' '.join('"{0}"'.format(lib) for lib in ipp_libraries)

    exp_libs = EXP_LIBS[host][thread]
    if tl and EXP_LIBS[host][tl] not in exp_libs:
        exp_libs += ' ' + EXP_LIBS[host][tl]

    sys_libs_path = SYS_LIBS_PATH[host][arch]

    link_command = LINK_COMMAND_FORMAT[host].format(linker=linker,
                                                    link_flags=link_flags,
                                                    custom_library=custom_library,
                                                    export_file=export_file,
                                                    ipp_libraries=ipp_libraries,
                                                    exp_libs=exp_libs,
                                                    sys_libs_path=sys_libs_path,)

    return BUILD_SCRIPT[host].format(architecture=arch,
                                     threading=thread.lower(),
                                     output_path=output_path,
                                     custom_library=custom_library,
                                     env_commands=env_commands,
                                     compile_command=compile_command,
                                     link_command=link_command)
