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

from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QWidget, QGridLayout, QLabel, QComboBox, QLineEdit, QPushButton, QCheckBox, \
    QListWidget, QFileDialog, QMessageBox, QRadioButton

from gui import settings

from tool import utils
from tool.core import generate_script
from tool.clt_compilers_and_flags import *


class ScriptsMenu(QWidget):
    def interface_check(function):
        def wrapper(self):
            function(self)
            try:
                self.on_block()
            except:
                return wrapper

        return wrapper

    def __init__(self):
        super().__init__()
        self.layout = QGridLayout()
        self.setLayout(self.layout)

        row_hight = 30
        margins = self.layout.contentsMargins()
        margins.setTop(row_hight)
        margins.setRight(20)
        self.layout.setContentsMargins(margins)

        # Initializing GUI elements
        self.settings_label = QLabel('Settings')
        self.platform_var_list = QComboBox()
        self.thread_var_list = QComboBox()

        self.intel64 = QCheckBox('Intel 64')
        self.IA32 = QCheckBox('IA32')
        self.TL = QCheckBox('Threading layer')
        self.omp = QRadioButton('OpenMP')
        self.tbb = QRadioButton('TBB')

        self.lib_name = QLineEdit()
        self.functions_list = QListWidget()
        self.save_build_script = QPushButton('Save build script')
        self.functions_names = []
        self.status_receiver = None

        self.lib_name.setPlaceholderText('Library name...')

        # Preparing elements by giving initial values and etc
        self.settings_label.setAlignment(Qt.AlignBottom)
        self.save_build_script.setDisabled(True)

        self.save_build_script.clicked.connect(self.on_save_build_script)
        self.IA32.clicked.connect(self.on_block)
        self.intel64.clicked.connect(self.on_block)
        self.TL.clicked.connect(self.set_tl)
        self.lib_name.textEdited.connect(self.on_block)
        self.platform_var_list.currentIndexChanged.connect(self.on_target_system_selection)

        # Setting all widgets in their places
        self.layout.addWidget(self.settings_label, 0, 0)

        self.layout.addWidget(self.TL, 1, 0)
        self.layout.addWidget(self.omp, 2, 0)
        self.layout.addWidget(self.tbb, 3, 0)

        self.layout.addWidget(self.intel64, 2, 1)
        self.layout.addWidget(self.IA32, 3, 1)
        self.layout.addWidget(self.platform_var_list, 2, 2, 1, 2)
        self.layout.addWidget(self.thread_var_list, 3, 2, 1, 2)

        self.layout.addWidget(self.lib_name, 4, 0, 1, 4)
        self.layout.addWidget(self.functions_list, 5, 0, 1, 4)
        self.layout.addWidget(self.save_build_script, 6, 0, 1, 4)

        self.settings_label.setFixedHeight(row_hight)
        self.TL.setFixedHeight(row_hight)
        self.platform_var_list.setFixedHeight(row_hight)
        self.thread_var_list.setFixedHeight(row_hight)

        self.__post_check()

    def set_configs(self, package):
        self.check_configs(package)

        self.TL.setChecked(settings.CONFIGS[package]['TL'])
        self.omp.setChecked(settings.CONFIGS[package]['OpenMP'])
        self.tbb.setChecked(settings.CONFIGS[package]['TBB'])
        self.set_tl()

        self.intel64.setChecked(settings.CONFIGS[package]['intel64'])
        self.IA32.setChecked(settings.CONFIGS[package]['IA32'])

        if self.intel64.isEnabled():
            if not self.intel64.isChecked() and not self.IA32.isChecked():
                self.intel64.setChecked(True)
        elif self.IA32.isEnabled():
            self.IA32.setChecked(True)

        self.thread_var_list.setCurrentText(utils.MULTI_THREADED) if settings.CONFIGS[package]['Multi-threaded'] \
            else self.thread_var_list.setCurrentText(utils.SINGLE_THREADED)

        self.functions_names = settings.CONFIGS[package]['functions_list']

    def check_configs(self, package):
        self.intel64_libs_path = self.parent.source.path_to_libs[package][utils.INTEL64]
        self.ia32_libs_path = self.parent.source.path_to_libs[package][utils.IA32]

        if self.intel64_libs_path:
            self.intel64.setEnabled(True)
        else:
            settings.CONFIGS[package]['intel64'] = False
            self.intel64.setDisabled(True)

        if self.ia32_libs_path:
            self.IA32.setEnabled(True)
        else:
            settings.CONFIGS[package]['IA32'] = False
            self.IA32.setDisabled(True)

        if self.check_dir('tl'):
            self.TL.setEnabled(True)
        else:
            settings.CONFIGS[package]['TL'] = False
            self.TL.setDisabled(True)

        self.thread_var_list.clear()
        if self.check_dir('threaded'):
            self.thread_var_list.addItems([utils.SINGLE_THREADED,
                                           utils.MULTI_THREADED])
        else:
            self.thread_var_list.addItem(utils.SINGLE_THREADED)
            settings.CONFIGS[package]['Multi-threaded'] = False

    def check_dir(self, dir):
        return os.path.exists(os.path.join(self.intel64_libs_path, dir)) or \
                os.path.exists(os.path.join(self.ia32_libs_path, dir))

    def get_configs(self, package):
        if self.TL.isEnabled():
            settings.CONFIGS[package]['TL'] = self.TL.isChecked()

        if settings.CONFIGS[package]['TL']:
            settings.CONFIGS[package]['OpenMP'] = self.omp.isChecked()
            settings.CONFIGS[package]['TBB'] = self.tbb.isChecked()

        settings.CONFIGS[package]['intel64'] = self.intel64.isChecked()
        settings.CONFIGS[package]['IA32'] = self.IA32.isChecked()

        settings.CONFIGS[package]['Multi-threaded'] = (self.thread_var_list.currentText() == utils.MULTI_THREADED)

        settings.CONFIGS[package]['functions_list'] = self.functions_names

    def set_status_output(self, status_receiver):
        self.status_receiver = status_receiver

    def __get_interface_state(self):
        return {settings.PACKAGE: self.parent.source.ipp.isEnabled() or self.parent.source.ippcp.isEnabled(),
                settings.PLATFORM: self.IA32.isChecked() or self.intel64.isChecked(),
                settings.LIB_NAME: bool(self.lib_name.text()),
                settings.FUNCTIONS: bool(self.functions_names),
                settings.ANDK: not ((not bool(utils.ANDROID_NDK_PATH))
                           and self.platform_var_list.currentText() == utils.ANDROID)
                }

    def on_item_selected(self, item):
        self.functions_list.setCurrentItem(item)

    def on_block(self):
        autobuild_requrements = settings.AUTOBUILD_BUTTON_RULES
        script_requrements = settings.SCRIPT_BUTTON_GENERATOR_RULES
        interface_state = self.__get_interface_state()
        if autobuild_requrements == interface_state:
            self.parent.set_auto_build_disabled(False)
            self.status_receiver.showMessage("Ready to build custom library")
        else:
            self.parent.set_auto_build_disabled(True)
            differences = dict(autobuild_requrements.items() - interface_state.items())
            self.status_receiver.showMessage("Set " + sorted(differences, key=len)[0])

        if script_requrements == {i: interface_state.get(i)
                                  for i in script_requrements.keys()}:
            self.save_build_script.setDisabled(False)
        else:
            self.save_build_script.setDisabled(True)

    def set_tl(self):
        if self.TL.isEnabled():
            self.set_threading_layer_enabled(self.TL.isChecked())
            self.parent.source.tl_selected = self.TL.isChecked()
        else:
            self.set_threading_layer_enabled(False)
            self.parent.source.tl_selected = False

        if self.parent.source.ipp.isChecked():
            self.parent.source.show_menu(utils.IPP)

        if not self.omp.isChecked() and not self.tbb.isChecked():
            if self.omp.isEnabled():
                self.omp.setChecked(True)
            elif self.tbb.isEnabled():
                self.tbb.setChecked(True)

    def set_threading_layer_enabled(self, bool):
        self.omp.setEnabled(bool) if self.check_dir(os.path.join('tl', 'openmp')) else self.omp.setDisabled(True)
        self.tbb.setEnabled(bool) if self.check_dir(os.path.join('tl', 'tbb')) else self.tbb.setDisabled(True)

    def on_save_build_script(self):
        library_path = QFileDialog.getExistingDirectory(self, 'Select a folder')
        if library_path == '':
            return
        host_system = utils.HOST_SYSTEM
        target_system = self.platform_var_list.currentText()
        functions = self.functions_names
        library_name = self.lib_name.text()
        threading = self.thread_var_list.currentText() == 'Multi-threaded'
        threading_layer_type = self.parent.get_treading_layer_type()

        if self.parent.source.ipp.isChecked():
            package = utils.IPP
            root = utils.IPPROOT
        else:
            package = utils.IPPCP
            root = utils.IPPCRYPTOROOT

        os.environ[root] = settings.CONFIGS[package]['Path']

        if self.IA32.isChecked():
            generate_script(package,
                            host_system,
                            target_system,
                            functions,
                            library_path,
                            library_name,
                            utils.IA32,
                            threading,
                            threading_layer_type, )
        if self.intel64.isChecked():
            generate_script(package,
                            host_system,
                            target_system,
                            functions,
                            library_path,
                            library_name,
                            utils.INTEL64,
                            threading,
                            threading_layer_type)
        QMessageBox.about(self, 'Success', 'Generation completed!')

    @interface_check
    def on_target_system_selection(self):
        system = self.platform_var_list.currentText()
        if utils.ONLY_THREADABLE[system]:
            self.thread_var_list.setCurrentIndex(1)
            self.thread_var_list.setDisabled(True)
        else:
            self.thread_var_list.setDisabled(False)

        if not utils.SUPPORTED_ARCHITECTURES[system][utils.IA32]:
            self.IA32.setCheckState(Qt.Unchecked)
            self.IA32.setDisabled(True)
        else:
            self.IA32.setDisabled(False)
        if not utils.SUPPORTED_ARCHITECTURES[system][utils.INTEL64]:
            self.intel64.setCheckState(Qt.Unchecked)
            self.intel64.setDisabled(True)
        else:
            self.intel64.setDisabled(False)

    def add_items(self, items):
        """
        Sorts and adds items to list view

        :param items: list of strings
        """
        self.functions_list.clear()

        if items:
            items.sort()
            self.functions_list.addItems(items)
            self.functions_list.setCurrentItem(self.functions_list.item(0))

        self.functions_list.repaint()

    def add_item(self, function):
        """
        Adds new function to required list

        :param domain: domain of function
        :param function: name if function
        """
        self.functions_names.append(function)
        self.add_items(self.functions_names)

    def remove_item(self):
        """
        Removes function from required list
        """
        if self.functions_list.currentItem() is None:
            return None
        lib = self.functions_list.currentItem().text()
        self.functions_names.remove(lib)
        self.add_items(self.functions_names)
        return lib

    def __post_check(self):
        """
        Fills platforms combo box according to host system
        """
        if utils.HOST_SYSTEM == utils.LINUX:
            self.platform_var_list.addItem(utils.LINUX)
        elif utils.HOST_SYSTEM == utils.MACOSX:
            self.platform_var_list.addItem(utils.MACOSX)
        elif utils.HOST_SYSTEM == utils.WINDOWS:
            self.platform_var_list.addItem(utils.WINDOWS)
