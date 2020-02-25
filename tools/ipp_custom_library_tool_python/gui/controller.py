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
from PyQt5.QtWidgets import QWidget, QPushButton, QVBoxLayout
import tool.utils


class Controller(QWidget):
    def buttons_toggle(function):
        def wrapper(self):
            function(self)
            self.receiver.on_block()

        return wrapper

    def __init__(self, source, receiver):
        super().__init__()

        self.to_right = QPushButton('>>')
        self.to_left = QPushButton('<<')
        self.source = source
        self.receiver = receiver
        self.source.parent = self
        self.receiver.parent = self
        self.libraries_mapping = {}

        self.to_right.pressed.connect(self.on_right_press)
        self.to_left.pressed.connect(self.on_left_press)

        v_box = QVBoxLayout()
        v_box.addStretch(1)
        v_box.addWidget(self.to_right)
        v_box.addWidget(self.to_left)

        self.setLayout(v_box)

        receiver.set_configs(tool.utils.IPP) if source.ipp.isChecked()\
            else receiver.set_configs(tool.utils.IPPCP)

        receiver.on_block()

    @buttons_toggle
    def on_right_press(self):
        if self.source.selected_libraries_list.currentItem():
            function_name = self.source.selected_libraries_list.currentItem().text()
            self.source.remove_item(function_name)
            if function_name is None:
                return
            self.receiver.add_item(function_name)

    @buttons_toggle
    def on_left_press(self):
        library = self.receiver.remove_item()
        if library is None:
            return
        self.source.add_item(library)

    def get_library_information(self):
        """
        Collecting all user-specified information about future dynamic library into dictionary

        :return: dictionary with all available information about future dynamic library
        """
        return {
            'functions': self.receiver.functions_names,
            'host_system': tool.utils.HOST_SYSTEM,
            'target_system': self.receiver.platform_var_list.currentText(),
            'library_name': self.receiver.lib_name.text(),
            'threading': self.receiver.thread_var_list.currentText(),
            'ia32': self.receiver.IA32.isChecked(),
            'intel64': self.receiver.intel64.isChecked(),
            'threading_layer_type': self.get_treading_layer_type()
        }

    def set_auto_build_disabled(self, bool):
        """
        Sets auto_build button to disabled or enabled state according to given parameter

        :param bool: sets auto_build button to disabled state if True and to enabled state in the opposite case
        """
        self.source.auto_build_button.setDisabled(bool)

    def set_disabled(self, bool):
        self.source.setDisabled(bool)
        self.receiver.setDisabled(bool)
        self.setDisabled(bool)

    def get_treading_layer_type(self):
        threading_layer_type = tool.utils.ThreadingLayerType.NONE
        if not set(self.source.threaded_functions).isdisjoint(self.receiver.functions_names):
            if self.receiver.omp.isChecked():
                threading_layer_type = tool.utils.ThreadingLayerType.OPENMP
            if self.receiver.tbb.isChecked():
                threading_layer_type = tool.utils.ThreadingLayerType.TBB
        return threading_layer_type
