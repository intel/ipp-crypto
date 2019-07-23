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
import copy

from PyQt5.QtWidgets import QWidget, QGridLayout, QComboBox, QLineEdit, QPushButton, QListWidget, QFileDialog, \
    QMessageBox, QRadioButton

import tool.core
from tool import utils

from gui.parse_headers import *
from gui import settings


class FunctionsMenu(QWidget):
    def __init__(self):
        super().__init__()
        self.layout = QGridLayout()
        self.setLayout(self.layout)

        row_hight = 30
        margins = self.layout.contentsMargins()
        margins.setTop(2*row_hight + self.layout.spacing())
        margins.setLeft(20)
        self.layout.setContentsMargins(margins)

        # Initializing GUI elements
        self.ipp = QRadioButton()
        self.ippcp = QRadioButton()

        self.select_ipp = QPushButton('Select package')
        self.select_ippcp = QPushButton('Select package')
        self.select_ipp.package = utils.IPP
        self.select_ippcp.package = utils.IPPCP

        self.lib_var_list = QComboBox(self)
        self.search = QLineEdit(self)
        self.selected_libraries_list = QListWidget(self)
        self.auto_build_button = QPushButton('Autobuild')

        self.current_functions_list = {}

        # Preparing elements by giving initial values, etc
        self.ipp.setText('IPP ver. None')
        self.ippcp.setText('IPP Cryptography ver. None')
        self.search.setPlaceholderText('Search...')

        self.ipp.setDisabled(True)
        self.ippcp.setDisabled(True)
        self.auto_build_button.setDisabled(True)

        self.lib_var_list.activated[str].connect(self.on_theme_selected)
        self.search.textEdited.connect(self.on_search)
        self.selected_libraries_list.itemClicked.connect(self.on_item_selected)
        self.auto_build_button.clicked.connect(self.on_build_pressed)
        self.select_ipp.clicked.connect(self.on_select)
        self.select_ippcp.clicked.connect(self.on_select)
        self.ipp.toggled.connect(self.on_switch)

        # Setting all widgets in their places
        self.layout.addWidget(self.ipp, 0, 0, 1, 3)
        self.layout.addWidget(self.ippcp, 1, 0, 1, 3)

        self.layout.addWidget(self.select_ipp, 0, 3)
        self.layout.addWidget(self.select_ippcp, 1, 3)

        self.layout.addWidget(self.lib_var_list, 2, 0, 1, 4)
        self.layout.addWidget(self.search, 3, 0, 1, 4)
        self.layout.addWidget(self.selected_libraries_list, 4, 0, 1, 4)
        self.layout.addWidget(self.auto_build_button, 5, 0, 1, 4)

        self.select_ipp.setFixedHeight(row_hight)
        self.select_ippcp.setFixedHeight(row_hight)
        self.lib_var_list.setFixedHeight(row_hight)

        path_to_package = self.get_path_to_package()
        if path_to_package:
            package = utils.IPPCP if re.compile('.*ippcp.*').match(path_to_package) else utils.IPP
            self.set_package(package, path_to_package)
            self.init_menu()

    def init_menu(self):
        self.ipp.toggled.disconnect(self.on_switch)
        self.tl_selected = False

        if self.ipp.isEnabled():
            package = utils.IPP
            self.init_functions(utils.IPP, settings.CONFIGS[utils.IPP]['Path'])
            self.ipp.setChecked(True)

        if self.ippcp.isEnabled():
            self.init_functions(utils.IPPCP, settings.CONFIGS[utils.IPPCP]['Path'])
            if not self.ipp.isEnabled():
                package = utils.IPPCP
                self.ippcp.setChecked(True)

        self.show_menu(package)
        self.ipp.toggled.connect(self.on_switch)

    def set_package(self, package, path):
        if self.check_package(package, path):
            settings.CONFIGS[package]['Path'] = path
            if package == utils.IPP:
                self.ipp.setText('IPP ver. ' + self.get_version(path))
                self.ipp.setEnabled(True)
            else:
                self.ippcp.setText('IPP Cryptography ver. ' + self.get_version(path))
                self.ippcp.setEnabled(True)
            return True
        elif path:
            if package == utils.IPP:
                QMessageBox.information(self, 'ERROR!',
                                        'Incorrect Intel® Integrated Performance Primitives package path!')
            else:
                QMessageBox.information(self, 'ERROR!',
                                        'Incorrect Intel® Integrated Performance Primitives Cryptography package path!')

            return False

    def check_package(self, package, path):
        if not self.check_batch(package, path):
            return False

        if os.path.exists(os.path.join(path, 'include')):
            for header in os.listdir(os.path.join(path, 'include')):
                if get_mode_and_domain(header):
                    break
        else:
            return False

        lib_ia32_path = os.path.join(path, 'lib', 'ia32_' + utils.HOST_SYSTEM.lower()[:3])
        if utils.HOST_SYSTEM != MACOSX:
            lib_intel64_path = os.path.join(path, 'lib', 'intel64_' + utils.HOST_SYSTEM.lower()[:3])
        else:
            lib_intel64_path = os.path.join(path, 'lib')

        return True if self.check_libs(lib_ia32_path) or \
                       self.check_libs(lib_intel64_path) else False

    def check_batch(self, package, path):
        return os.path.exists(os.path.join(path, 'bin', package.lower() + 'vars' + BATCH_EXTENSIONS[utils.HOST_SYSTEM]))

    def check_libs(self, path):
        if os.path.exists(path):
            for lib in os.listdir(path):
                if STATIC_LIBRARIES_EXTENSIONS[utils.HOST_SYSTEM] in lib:
                    return True
        return False

    def on_select(self):
        package = self.sender().package
        while True:
            path = QFileDialog.getExistingDirectory(self, 'Select ' + package + ' package')
            if not path:
                return

            if self.set_package(package, path):
                break

        self.init_functions(package, path)

        if package == utils.IPP:
            if not self.ipp.isChecked() and not self.ippcp.isChecked():
                self.ipp.toggled.disconnect(self.on_switch)
                self.ipp.setChecked(True)
                self.ipp.toggled.connect(self.on_switch)
        else:
            if not self.ipp.isChecked() and not self.ippcp.isChecked():
                self.ippcp.setChecked(True)

        for config in settings.CONFIGS[package].keys():
            if config != 'Path' and config != 'functions_list':
                settings.CONFIGS[package][config] = False
        settings.CONFIGS[package]['functions_list'].clear()

        if package == utils.IPP and self.ipp.isChecked() or \
                package == utils.IPPCP and self.ippcp.isChecked():
            self.parent.receiver.set_configs(package)
            self.parent.receiver.functions_names.clear()
            self.parent.receiver.functions_list.clear()
            self.show_menu(package)

        self.parent.receiver.on_block()

    def on_switch(self):
        if self.ipp.isChecked():
            package = utils.IPP
            self.parent.receiver.get_configs(utils.IPPCP)
        else:
            package = utils.IPPCP
            self.parent.receiver.get_configs(utils.IPP)

        self.parent.receiver.set_configs(package)
        self.show_menu(package)
        self.parent.receiver.add_items(self.parent.receiver.functions_names)
        self.parent.receiver.on_block()

    def on_theme_selected(self, text):
        self.add_items(self.current_functions_list.get(text))
        self.on_search(self.search.text())

    def on_search(self, search_request):
        if self.current_functions_list:
            self.add_items([entry for entry in self.current_functions_list.get(self.lib_var_list.currentText())
                            if search_request.upper() in entry.upper()])

    def on_item_selected(self, item):
        self.selected_libraries_list.setCurrentItem(item)

    def on_build_pressed(self):
        information = self.parent.get_library_information()
        library_path = QFileDialog.getExistingDirectory(self, 'Select a folder')
        if library_path == '':
            return
        success = False
        self.parent.set_disabled(True)
        QMessageBox.information(self, 'Build', 'Building will start after this window is closed. '
                                               'Please wait until process is done.')

        package = utils.IPP if self.ipp.isChecked() else utils.IPPCP

        os.environ[package + 'ROOT'] = settings.CONFIGS[package]['Path']
        self.get_path_to_cnl(settings.CONFIGS[package]['Path'])

        if information['ia32']:
            success = tool.core.build(
                package,
                information['host_system'],
                information['target_system'],
                information['functions'],
                library_path,
                information['library_name'],
                tool.utils.IA32,
                information['threading'] == 'Multi-threaded',
                tool.utils.COMPILERS_AND_LIBRARIES_PATH,
                threading_layer_type=information['threading_layer_type']
            )
        if information['intel64']:
            success = tool.core.build(
                package,
                information['host_system'],
                information['target_system'],
                information['functions'],
                library_path,
                information['library_name'],
                tool.utils.INTEL64,
                information['threading'] == 'Multi-threaded',
                tool.utils.COMPILERS_AND_LIBRARIES_PATH,
                threading_layer_type=information['threading_layer_type']
            )
        self.parent.set_disabled(False)
        QMessageBox.information(self, 'Success' if success else 'Failure',
                                'Build completed!' if success else 'Build failed!')

    def add_items(self, items):
        """
        Sorts and adds items to list view
        :param items: list of strings
        """
        self.selected_libraries_list.clear()

        if items:
            items.sort()
            self.selected_libraries_list.addItems(items)
            self.selected_libraries_list.setCurrentItem(self.selected_libraries_list.item(0))

        self.selected_libraries_list.repaint()

    def add_item(self, function_name):
        """
        Adds function to left list

        :param function_name:
        """
        self.operation(list.append, function_name)
        self.add_items(self.current_functions_list.get(self.lib_var_list.currentText()))
        self.on_search(self.search.text())

    def remove_item(self, item):
        """
        Removes item from left list
        """
        if item is None:
            return None

        self.operation(list.remove, item)
        self.add_items(self.current_functions_list.get(self.lib_var_list.currentText()))
        self.on_search(self.search.text())

    def operation(self, action, function_name):
        for mode in FUNCTIONS_LIST.keys():
            for domain in FUNCTIONS_LIST[mode].keys():
                if function_name in FUNCTIONS_LIST[mode][domain]:
                    action(self.functions_list[mode][domain], function_name)
                    return

    def init_func_list(self):
        """
        Taking all domains and their functions
        """
        self.lib_var_list.clear()
        self.lib_var_list.addItems([entry for entry in self.current_functions_list.keys()])

    def init_functions(self, package, path):
        if package == utils.IPP:
            FUNCTIONS_LIST['Classical IPP'].clear()
            FUNCTIONS_LIST['IPP TL'].clear()
        else:
            FUNCTIONS_LIST['IPP Cryptography'].clear()

        get_functions_from_headers(path)
        self.functions_list = copy.deepcopy(FUNCTIONS_LIST)
        self.threaded_functions = [item for sublist in self.functions_list['IPP TL'].values() for item in
                                   sublist]
    def show_menu(self, package):
        if package == utils.IPP:
            if not self.tl_selected:
                self.current_functions_list = self.functions_list['Classical IPP']
            else:
                self.current_functions_list = self.functions_list['IPP TL']
        else:
            self.current_functions_list = self.functions_list['IPP Cryptography']

        self.init_func_list()
        self.add_items(self.current_functions_list.get(self.lib_var_list.currentText()))

    def get_path_to_package(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))

        if re.compile(utils.PATH_TO_PACKAGE_REGULAR_EXPRESSION).match(dir_path):
            return re.match(utils.PATH_TO_PACKAGE_REGULAR_EXPRESSION, dir_path).group('path')
        else:
            return ''

    def get_version(self, path):
        if re.compile(utils.VERSION_REGULAR_EXPRESSION).match(path):
            return re.match(utils.VERSION_REGULAR_EXPRESSION, path).group('ver')
        else:
            return 'None'

    def get_path_to_cnl(self, path):
        if re.compile(utils.PATH_TO_CNL_REGULAR_EXPRESSION).match(path):
            utils.COMPILERS_AND_LIBRARIES_PATH = re.match(utils.PATH_TO_CNL_REGULAR_EXPRESSION, path).group('cnl')
