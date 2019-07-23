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
import json
import os

from PyQt5.QtCore import Qt, QEvent
from PyQt5.QtGui import QIcon, QStatusTipEvent
from PyQt5.QtWidgets import QWidget, QGridLayout, QMainWindow, QFileDialog, QPushButton

from tool import utils
from gui import settings

from gui.controller import Controller
from gui.functions_menu import FunctionsMenu
from gui.scripts_menu import ScriptsMenu


class MainWidget(QWidget):
    def __init__(self, statusBar):
        super().__init__()
        self.initUI(statusBar)

    def initUI(self, statusbar):
        self.layout = QGridLayout()
        self.setLayout(self.layout)

        self.layout.setHorizontalSpacing(0)
        self.layout.setContentsMargins(0, 0, 0, 0)

        self.project_file = ''

        self.function_menu = FunctionsMenu()
        self.scripts_menu = ScriptsMenu()
        self.scripts_menu.set_status_output(statusbar)
        self.controller = Controller(self.function_menu, self.scripts_menu)

        self.setMinimumHeight(700)
        self.setMinimumWidth(1000)

        self.open = QPushButton('Open project')
        self.save = QPushButton('Save project')
        self.save_as = QPushButton('Save project as...')

        self.save_as.pressed.connect(self.on_save_as)
        self.save.pressed.connect(self.on_save)
        self.open.pressed.connect(self.on_open)

        self.layout.addWidget(self.open, 0, 0)
        self.layout.addWidget(self.save, 0, 1)
        self.layout.addWidget(self.save_as, 0, 2)

        self.layout.addWidget(self.function_menu, 1, 0, 1, 4)
        self.layout.addWidget(self.controller, 1, 4, Qt.AlignCenter)
        self.layout.addWidget(self.scripts_menu, 1, 5)

        self.layout.setColumnStretch(0, 1)
        self.layout.setColumnStretch(1, 1)
        self.layout.setColumnStretch(2, 1)
        self.layout.setColumnStretch(3, 1)
        self.layout.setColumnStretch(4, 0)
        self.layout.setColumnStretch(5, 4)

    def on_open(self):
        file_path, _ = QFileDialog.getOpenFileName(self)
        if not file_path:
            return
        self.project_file = file_path

        with open(self.project_file, 'r') as project_file:
            configs = json.load(project_file)

            for package in settings.CONFIGS.keys():
                for config in settings.CONFIGS[package].keys():
                    settings.CONFIGS[package][config] = configs[package][config]

        self.function_menu.ipp.setDisabled(True)
        self.function_menu.ippcp.setDisabled(True)

        self.function_menu.set_package(utils.IPP, settings.CONFIGS[utils.IPP]['Path'])
        self.function_menu.set_package(utils.IPPCP, settings.CONFIGS[utils.IPPCP]['Path'])

        self.function_menu.init_menu()

        package = ''
        if self.function_menu.ipp.isChecked():
            package = utils.IPP
        elif self.function_menu.ippcp.isChecked():
            package = utils.IPPCP

        if package:
            self.scripts_menu.set_configs(package)
            self.scripts_menu.functions_names = settings.CONFIGS[package]['functions_list']

        for function in settings.CONFIGS[utils.IPP]['functions_list']:
            self.function_menu.remove_item(function)

        for function in settings.CONFIGS[utils.IPPCP]['functions_list']:
            self.function_menu.remove_item(function)

        self.scripts_menu.add_items(self.scripts_menu.functions_names)
        self.scripts_menu.on_block()

    def on_save(self):
        self.scripts_menu.get_configs(utils.IPP) if self.function_menu.ipp.isChecked() \
            else self.scripts_menu.get_configs(utils.IPPCP)

        if self.project_file == '':
            return self.on_save_as()
        with open(self.project_file, 'w') as project:
            json.dump(settings.CONFIGS, project)

    def on_save_as(self):
        self.scripts_menu.get_configs(utils.IPP) if self.function_menu.ipp.isChecked() \
            else self.scripts_menu.get_configs(utils.IPPCP)

        file_path, _ = os.path.splitext(QFileDialog.getSaveFileName(self)[0])
        with open(file_path + utils.PROJECT_EXTENSION, 'w') as project:
            json.dump(settings.CONFIGS, project)
            self.project_file = file_path + utils.PROJECT_EXTENSION


class MainAppWindow(QMainWindow):
    def __init__(self):
        super(MainAppWindow, self).__init__()
        self.setWindowIcon(QIcon('icon.ico'))
        self.setCentralWidget(MainWidget(self.statusBar()))
        self.setWindowTitle('Intel® Integrated Performance Primitives Custom Library Tool')
        self.show()

    def event(self, e):
        if e.type() == QEvent.StatusTip:
            if e.tip() == '':
                e = QStatusTipEvent('Set package...')
        return super().event(e)
