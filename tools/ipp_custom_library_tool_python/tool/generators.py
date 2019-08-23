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
from tool import utils
from tool.clt_compilers_and_flags import *


def generate_windows_for_windows(package,
                                 library_path,
                                 library_name,
                                 architecture,
                                 multi_threaded=False,
                                 threading_layer_type=ThreadingLayerType.NONE,
                                 sub_command=''):
    """
    Generates script for building Windows DLL on Windows

    :param tbb: should be True if we are building with TL support implemented with TBB
    :param openmp: should be True if we are building with TL support implemented with OpenMP
    :param library_path: path to directory where script has to appear
    :param library_name: name of dynamic library
    :param libraries_list: list of libraries that are to be linked
    :param architecture: name of target architecture
    :param multi_threaded: use multi-threaded libraries if set to True
    :param sub_command: command that is going to be executed before building and linking
    :return: String that represents script
    """
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[WINDOWS][architecture]
    omp_flag = (' /openmp' if threading_layer_type == ThreadingLayerType.OPENMP else '')
    cmp_args = COMPILERS_FLAGS[WINDOWS][architecture] + omp_flag
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.obj')
    linker = LINKERS[WINDOWS][architecture]
    link_args = LINKER_FLAGS[WINDOWS][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[WINDOWS])
    library_file = os.path.join(destination, library_name)
    libraries = get_libraries_list(package,
                                   WINDOWS,
                                   WINDOWS,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    exp_libs = EXP_LIBS[WINDOWS][threading_layer_type]
    if multi_threaded and threading_layer_type!=ThreadingLayerType.OPENMP:
        exp_libs += EXP_LIBS[WINDOWS][ThreadingLayerType.OPENMP]

    return GENERATOR_FORMAT[WINDOWS][WINDOWS].format(threading=threading,
                                                     architecture=architecture,
                                                     destination=destination,
                                                     sub_command=sub_command,
                                                     compiler=compiler,
                                                     cmp_args=cmp_args,
                                                     package=package,
                                                     main_file=main_file,
                                                     main_object=main_object,
                                                     linker=linker,
                                                     linker_args=link_args,
                                                     export_file=export_file,
                                                     library_file=library_file,
                                                     libraries=libraries,
                                                     exp_libs=exp_libs)

def generate_android_for_windows(package,
                                 library_path,
                                 library_name,
                                 architecture,
                                 multi_threaded=False,
                                 threading_layer_type=ThreadingLayerType.NONE,
                                 sub_command=''):
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[ANDROID][architecture]
    cmp_args = COMPILERS_FLAGS[ANDROID][architecture]
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.o')
    linker = LINKERS[ANDROID][architecture]
    linker_args = LINKER_FLAGS[ANDROID][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[ANDROID])
    library_file = os.path.join(destination, 'lib' + library_name)
    libraries = get_libraries_list(package,
                                   WINDOWS,
                                   ANDROID,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    sys_libs_path = SYS_LIBS_PATH[ANDROID][architecture]
    sys_libs_path = sys_libs_path.replace('$ANDROID_SYSROOT',
                                          '%ANDROID_SYSROOT%')
    sys_libs_path = os.path.normpath(sys_libs_path)

    return GENERATOR_FORMAT[WINDOWS][ANDROID].format(threading=threading,
                                                     destination=destination,
                                                     architecture=architecture,
                                                     sub_command=sub_command,
                                                     compiler=compiler,
                                                     cmp_args=cmp_args,
                                                     package=package,
                                                     main_file=main_file,
                                                     main_object=main_object,
                                                     linker=linker,
                                                     linker_args=linker_args,
                                                     export_file=export_file,
                                                     library_file=library_file,
                                                     libraries=libraries,
                                                     sys_libs_path=sys_libs_path)


def generate_linux_for_linux(package,
                             library_path,
                             library_name,
                             architecture,
                             multi_threaded=False,
                             threading_layer_type=ThreadingLayerType.NONE,
                             sub_command=''):
    """
    Generates script for building Linux Shared Object on Linux

    :param library_path: path to directory where script has to appear
    :param library_name: name of dynamic library
    :param libraries_list: list of libraries where specified functions are located
    :param architecture: name of target architecture
    :param multi_threaded: use multi-threaded libraries if set to True
    :param sub_command: command that is going to be executed before building and linking
    :return: String that represents script
    """
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[LINUX][architecture]
    gcc_args = COMPILERS_FLAGS[LINUX][architecture]
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.o')
    linker = LINKERS[LINUX][architecture]
    ld_args = LINKER_FLAGS[LINUX][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[LINUX])
    library_file = os.path.join(destination, 'lib' + library_name)
    libraries = get_libraries_list(package,
                                   LINUX,
                                   LINUX,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    sys_libs_path = SYS_LIBS_PATH[LINUX][architecture]
    compiler_libs_path = COMPILER_LIBS_PATH[LINUX][architecture].format(package=package)
    exp_libs = EXP_LIBS[LINUX][threading_layer_type]
    if multi_threaded and threading_layer_type!=ThreadingLayerType.OPENMP:
        exp_libs += EXP_LIBS[LINUX][ThreadingLayerType.OPENMP]

    return GENERATOR_FORMAT[LINUX][LINUX].format(threading=threading,
                                                 architecture=architecture,
                                                 destination=destination,
                                                 sub_command=sub_command,
                                                 compiler=compiler,
                                                 gcc_args=gcc_args,
                                                 package=package,
                                                 main_file=main_file,
                                                 main_object=main_object,
                                                 linker=linker,
                                                 ld_args=ld_args,
                                                 export_file=export_file,
                                                 library_file=library_file,
                                                 libraries=libraries,
                                                 sys_libs_path=sys_libs_path,
                                                 compiler_libs_path=compiler_libs_path,
                                                 exp_libs=exp_libs)


def generate_android_for_linux(package,
                               library_path,
                               library_name,
                               architecture,
                               multi_threaded=False,
                               threading_layer_type=ThreadingLayerType.NONE,
                               sub_command=''):
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[ANDROID][architecture]
    compiler_args = COMPILERS_FLAGS[ANDROID][architecture]
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.o')
    linker = LINKERS[ANDROID][architecture]
    linker_args = LINKER_FLAGS[ANDROID][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[ANDROID])
    library_file = os.path.join(destination, 'lib' + library_name)
    libraries = get_libraries_list(package,
                                   LINUX,
                                   ANDROID,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    sys_libs_path = SYS_LIBS_PATH[ANDROID][architecture]

    return GENERATOR_FORMAT[LINUX][ANDROID].format(threading=threading,
                                                   destination=destination,
                                                   architecture=architecture,
                                                   sub_command=sub_command,
                                                   compiler=compiler,
                                                   cmp_args=compiler_args,
                                                   package=package,
                                                   main_file=main_file,
                                                   main_object=main_object,
                                                   linker=linker,
                                                   linker_args=linker_args,
                                                   export_file=export_file,
                                                   library_file=library_file,
                                                   libraries=libraries,
                                                   sys_libs_path=sys_libs_path)


def generate_macosx_for_macosx(package,
                               library_path,
                               library_name,
                               architecture,
                               multi_threaded=False,
                               threading_layer_type=ThreadingLayerType.NONE,
                               sub_command=''):
    """
    Generates script for building MacOSX DY on MacOSX

    :param library_path: path to directory where script has to appear
    :param library_name: name of dynamic library
    :param libraries_list: list of libraries where specified functions are located
    :param architecture: name of target architecture
    :param multi_threaded: use multi-threaded libraries if set to True
    :param sub_command: command that is going to be executed before building and linking
    :return: String that represents script
    """
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[MACOSX][architecture]
    clang_args = COMPILERS_FLAGS[MACOSX][architecture]
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.o')
    linker = LINKERS[MACOSX][architecture]
    linker_args = LINKER_FLAGS[MACOSX][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[MACOSX])
    library_file = os.path.join(destination, 'lib' + library_name)
    libraries = get_libraries_list(package,
                                   MACOSX,
                                   MACOSX,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    compiler_lib_path = COMPILER_LIBS_PATH[MACOSX][architecture].format(package=package)
    exp_libs = EXP_LIBS[MACOSX][threading_layer_type]
    if multi_threaded and threading_layer_type != ThreadingLayerType.OPENMP:
        exp_libs += EXP_LIBS[MACOSX][ThreadingLayerType.OPENMP]

    if threading_layer_type == ThreadingLayerType.TBB:
        exp_libs += utils.TBB_EXP_LIB

    return GENERATOR_FORMAT[MACOSX][MACOSX].format(threading=threading,
                                                   architecture=architecture,
                                                   destination=destination,
                                                   sub_command=sub_command,
                                                   compiler=compiler,
                                                   clang_args=clang_args,
                                                   package=package,
                                                   main_file=main_file,
                                                   main_object=main_object,
                                                   linker=linker,
                                                   linker_args=linker_args,
                                                   export_file=export_file,
                                                   library_name=library_name,
                                                   library_file=library_file,
                                                   libraries=libraries,
                                                   compiler_lib_path=compiler_lib_path,
                                                   exp_libs=exp_libs)


def generate_android_for_macosx(package,
                                library_path,
                                library_name,
                                architecture,
                                multi_threaded=False,
                                threading_layer_type=ThreadingLayerType.NONE,
                                sub_command=''):
    threading = 'multi-threaded' if multi_threaded else 'single-threaded'
    destination = os.path.join(library_path, architecture)
    compiler = COMPILERS[ANDROID][architecture]
    cmp_args = COMPILERS_FLAGS[ANDROID][architecture]
    main_file = os.path.join(library_path, MAIN_FILE)
    main_object = os.path.join(destination, 'main.o')
    linker = LINKERS[ANDROID][architecture]
    linker_args = LINKER_FLAGS[ANDROID][architecture]
    export_file = os.path.join(library_path, EXPORT_FILES[ANDROID])
    library_file = os.path.join(destination, 'lib' + library_name)
    libraries = get_libraries_list(package,
                                   MACOSX,
                                   ANDROID,
                                   architecture,
                                   threading_layer_type,
                                   multi_threaded)
    sys_libs_path = SYS_LIBS_PATH[ANDROID][architecture]

    return GENERATOR_FORMAT[MACOSX][ANDROID].format(threading=threading,
                                                    architecture=architecture,
                                                    destination=destination,
                                                    sub_command=sub_command,
                                                    compiler=compiler,
                                                    cmp_args=cmp_args,
                                                    package=package,
                                                    main_file=main_file,
                                                    main_object=main_object,
                                                    linker=linker,
                                                    linker_args=linker_args,
                                                    export_file=export_file,
                                                    library_file=library_file,
                                                    libraries=libraries,
                                                    sys_libs_path=sys_libs_path)


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
                      '        global:\n' \
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


def create_android_export_file(export_file, functions_list):
    """
    Creates Android export file

    :param export_file: object that is returned by open function
    :param functions_list: list of functions for dynamic library
    """
    create_linux_export_file(export_file, functions_list)


def list_to_arguments(libraries_list, package, host_system):
    family = WINDOWS if host_system == WINDOWS else UNIX

    path_to_library = OS_FAMILY[family][ENV_PREFIX] \
                      + package + 'ROOT' + OS_FAMILY[family][ENV_POSTFIX] \
                      + OS_FAMILY[family][DIR_SEPARATOR] \
                      + 'lib' + OS_FAMILY[family][DIR_SEPARATOR]

    return ' '.join(['"' + path_to_library + library + '"'
                     for library in libraries_list
                     if os.path.exists(os.path.join(path_to_library.replace(OS_FAMILY[family][ENV_PREFIX] +
                                                                            package + 'ROOT' +
                                                                            OS_FAMILY[family][ENV_POSTFIX],
                                                                            os.environ[package + 'ROOT']),
                                                    library))])


def get_libraries_list(package, host_system, target_system, architecture, threading_type, multithreaded):
    if os.path.exists(os.path.join(os.environ[package + 'ROOT'], 'lib', architecture)):
        arch_dir = architecture
    else:
        arch_dir = architecture + '_' + target_system.lower()[:3]
    libraries_list = list()
    if threading_type != ThreadingLayerType.NONE:
        threaded_with = 'tbb' if threading_type == ThreadingLayerType.TBB else 'openmp'
        libraries_list += [library.format(arch_dir,
                                          threaded_with)
                           for library in LIBRARIES_LIST[host_system]
                           [target_system]
                           [package]
                           [THREADING_LAYER]]
    thread_mode = MULTI_THREADED if multithreaded else SINGLE_THREADED

    libraries_list += [library.format(arch_dir)
                       for library in LIBRARIES_LIST[host_system]
                       [target_system]
                       [package]
                       [thread_mode]]
    return list_to_arguments(libraries_list, package, host_system)


GENERATORS = {
    WINDOWS: {
        WINDOWS: generate_windows_for_windows,
        ANDROID: generate_android_for_windows
    },
    LINUX  : {
        LINUX  : generate_linux_for_linux,
        ANDROID: generate_android_for_linux
    },
    MACOSX : {
        MACOSX : generate_macosx_for_macosx,
        ANDROID: generate_android_for_macosx
    }
}

EXPORT_GENERATORS = {
    WINDOWS: create_windows_export_file,
    LINUX  : create_linux_export_file,
    MACOSX : create_macosx_export_file,
    ANDROID: create_android_export_file
}
