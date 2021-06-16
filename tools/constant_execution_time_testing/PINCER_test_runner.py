#===============================================================================
# Copyright 2019-2021 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#===============================================================================

import sys

if sys.version_info < (3,7):
  print("Required python version is 3.7 or greater")
  sys.exit(1)

import argparse
import subprocess
import re
import os
import zipfile
import logging
import platform

PATH_TO_TOOLS   = '/nfs/inn/proj/ipp/mirror/tool/ippcp'
TEST_DATA_DIR   = '{}/develop/data'.format(PATH_TO_TOOLS)

# Structure of tools directory
PIN_TOOL_TMPL     = '{}/pin-3.7-97619-g0d0c92f4f-gcc-linux/pin'
PINCER_LIB_TMPL   = '{}/PINCER/obj-{}/FuncTraceTool.so'
OBJDUMP_TMPL      = '{}/objdump'

def create_archive(trace_folder):
  archive_folder = zipfile.ZipFile('{}.zip'.format(trace_folder), 'w')
  for dirname, subdirs, files in os.walk(trace_folder):
    for filename in files:
      full_filename = os.path.join(dirname, filename)
      archive_folder.write(full_filename, full_filename.replace(PINCER_TRACE_DIR,""), compress_type = zipfile.ZIP_DEFLATED)
  archive_folder.close()

def delete_folder(trace_folder):
  for root, dirs, files in os.walk(trace_folder, topdown=False):
    for name in files:
      os.remove(os.path.join(root, name))
    for name in dirs:
      os.rmdir(os.path.join(root, name))
  os.rmdir(trace_folder)

def arg_check(parser, check_function, return_function, argument, error_message):
  if not check_function(argument):
    raise parser.error(error_message)
  return return_function(argument) if return_function else argument

def check_tools(tools_dir):
  return os.path.isdir(tools_dir)                          and \
         os.path.isfile(PIN_TOOL_TMPL.format(tools_dir))   and \
         os.path.isfile(OBJDUMP_TMPL.format(tools_dir))

# Parse command-line arguments
parser = argparse.ArgumentParser()
parser._action_groups.pop()
optional = parser.add_argument_group('optional arguments')
optional.add_argument('-arch', '--target_architecture', action='store', help='specify target architecture intel64/ia32 (default value is intel64)', default="intel64", choices=['intel64', 'ia32'])
optional.add_argument('-T', '--target_optimization', action='store', help='specify target optimization (if the key is not specified then all available on target machine features are enabled)', default = "")
optional.add_argument('-t', '--test_list', action='store', help='specify test list to be processed divided by comma (substrings are ok)', default = "")
optional.add_argument('--tools_dir', action='store', help='path to PIN and PINCER tools directories', default=PATH_TO_TOOLS,
                      type=lambda arg: arg_check(parser, check_tools, os.path.abspath, arg, '\nThe tools directory \'{}\' structure check is failed!'.format(arg)))
optional.add_argument('--exec', dest='test_executable', action='store', help='path to executable', default="./pin_ippcp_mrg_compl_st",
                      type=lambda arg: arg_check(parser, os.path.isfile, os.path.abspath, arg, '\nThe test executable file \'{}\' does not exist!'.format(arg)))
optional.add_argument('--output_dir', action='store', help='results storage path', default="./", type=os.path.abspath)
optional.add_argument('--test_data_dir', action='store', help='path to the test data', default=TEST_DATA_DIR,
                      type=lambda arg: arg_check(parser, os.path.isdir, os.path.abspath, arg, '\nThe test data directory \'{}\' does not exist!'.format(arg)))
optional.add_argument('--debug', action='store_true', help='turn on debug mode: do not delete traces, add disassembling data')
optional.add_argument('--input_seed', action='store_true',
                       help='run with a specific seed value. The seed value can be taken either from TS formatted pin_ippcp_mrg_compl_st.ini file that shall reside along with the binary or, if no .ini file is found, from the keyboard input')
optional.add_argument('--ignore_exclusions', action='store_true', help='ignore ExclusionList.txt file that reside along with the binary. It is also possible to ignore the exclusion of some tests by marking them \'#\' in ExclusionList.txt')

args = parser.parse_args()

OPTIMIZATION     = args.target_optimization
ARCH             = args.target_architecture
TEST_EXECUTABLE  = args.test_executable
OUTPUT_DIR       = args.output_dir
DEBUG_MODE       = args.debug
TEST_DATA_DIR    = args.test_data_dir
SPEC_TESTS       = args.test_list.split(",") if args.test_list else []
PATH_TO_TOOLS    = args.tools_dir
INPUT_SEED       = args.input_seed
IGNORE_EXCLUSIONS = args.ignore_exclusions

# Generate paths to the required tools
PIN_TOOL      = PIN_TOOL_TMPL.format(PATH_TO_TOOLS)
PINCER_LIB    = PINCER_LIB_TMPL.format(PATH_TO_TOOLS, ARCH)
OBJDUMP       = OBJDUMP_TMPL.format(PATH_TO_TOOLS)

# Check the structure of PINCER library directory
if not os.path.isfile(PINCER_LIB):
  raise FileNotFoundError('\nThe PINCER library \'{}\' check is failed!'.format(PINCER_LIB))

# Add PINCER directory to the load path to grab 'post_process' module
sys.path.append(os.path.abspath(os.path.join(PATH_TO_TOOLS, 'PINCER')))
import post_process

PINCER_LOG       = os.path.join(OUTPUT_DIR, 'PINCER.log')
PINCER_TRACE_DIR = os.path.join(OUTPUT_DIR, 'PINCER_traces')

if os.path.exists(PINCER_LOG): os.remove(PINCER_LOG)
if os.path.exists(PINCER_TRACE_DIR): delete_folder(PINCER_TRACE_DIR)

os.makedirs(OUTPUT_DIR, exist_ok=True)
     
# Set up logging
logFormatter   = logging.Formatter("%(message)s")
rootLogger     = logging.getLogger()
fileHandler    = logging.FileHandler(PINCER_LOG)
consoleHandler = logging.StreamHandler()
fileHandler.setFormatter(logFormatter)
rootLogger.addHandler(fileHandler)
rootLogger.addHandler(consoleHandler)
rootLogger.setLevel(logging.DEBUG)
consoleHandler.setFormatter(logFormatter)

def get_disasm_data():
  retcode         = subprocess.Popen([OBJDUMP, '-D', TEST_EXECUTABLE], stdout=subprocess.PIPE, shell=False)
  (dis_out, err)  = retcode.communicate()
  dis_out         = dis_out.decode().split("\n")
  func_dict = {}
  instr_dict = {}
  for line in dis_out:
    func_match  = re.search(r'^0*([0-9a-f]+) (<.*>):', line)
    instr_match = re.search(r'^ +([0-9a-f]+):(.+)', line)
    
    if func_match:
      func_dict[func_match.group(1)] = func_match.group(2)
    if instr_match:
      instr_dict[instr_match.group(1)] = instr_match.group(2)
  return func_dict, instr_dict

def apply_disasm_to_traces(trace_folder):
  diff_ip = []
  folders = ["iptrace", "memtrace"]
  for fld in folders:
    for root, dirs, files in os.walk(os.path.join(trace_folder, fld)):
      for name in files:
        trace_file = os.path.join(root, name)
        with open(trace_file, 'r') as f:
          pin_trace = f.read().split("\n")
        pin_trace_with_asm = []
        for line in pin_trace:
          if ":" in line:
            line      = line.split(": ")
            pin_key   = line[1]
            instr_key = (line[1].split("."))[0]

            func_in_dict  = func_dict.get(instr_key)
            inctr_in_dict = instr_dict.get(instr_key)

            if func_in_dict:
              pin_trace_with_asm.append("\n{}\n".format(func_in_dict))

            if not inctr_in_dict:
              diff_ip.append("{} in {} ".format(instr_key, trace_file))
              continue

            pin_trace_with_asm.append('{}{}'.format(pin_key,inctr_in_dict))

        pin_trace_with_asm = "\n".join(pin_trace_with_asm)
        with open(trace_file, 'w') as f:
          f.write(pin_trace_with_asm)
  return diff_ip
  
def teardown(status, folder=None, archive=True, delete=True, disasm=False):
  if folder:
    if disasm or DEBUG_MODE:
      diff_ip = apply_disasm_to_traces(folder)
      for ip in diff_ip:
        rootLogger.info("|-WARNING\n {} - no such ip in disassembled code\n".format(ip))
    if archive and not DEBUG_MODE: create_archive(folder)
    if delete and not DEBUG_MODE: delete_folder(folder)
  rootLogger.info("|-{}\n".format(status))

# Get list of tests and corresponding function names for PINCER testing.
# Test name must start with 'pin_' and function name must start with 'ipps' to be captured
retcode    = subprocess.Popen([TEST_EXECUTABLE, '-e'], stdout=subprocess.PIPE, shell=False)
(out, err) = retcode.communicate()
out        = out.decode().split('\n')

# List of tuples: [(test_name, func_name)]
test_list = []
for line in out:
   matched = re.match(r'^.*(pin_\S+).*(ipps\S+|mbx\S+).*$', line)
   if matched:
       test_list.append(matched.groups())

# List of tests that shouldn't be tested. Tests marked with '#' in the .txt file or explicitly specified with the -t key are not excluded
# ExclusionList.txt placed next to the test executable
ExclusionListFile = os.path.join(os.path.split(TEST_EXECUTABLE)[0],'ExclusionList.txt')
exclusionList = []
if not IGNORE_EXCLUSIONS and os.path.isfile(ExclusionListFile):
  with open(ExclusionListFile, 'r') as f:
    exclusionList = list(filter(lambda t: '#' not in t, f.read().splitlines()))

# Reduce list of tests based on the command-line input and ExclusionList.txt file
if SPEC_TESTS:
  test_list = list(filter(lambda t: any(test_substr in t[0] for test_substr in SPEC_TESTS), test_list))
  exclusionList = list(filter(lambda t: not (t in SPEC_TESTS), exclusionList))
if exclusionList:
  test_list = list(filter(lambda t: not any(test_substr in t[0] for test_substr in exclusionList), test_list))

# Disassemble test binary only if we have something to test
if test_list:
    (func_dict, instr_dict) = get_disasm_data()

# Define the way to get the initial data for testing(seed):
# random generation, getting from an ini-file or input from the keyboard
inputSeedOptions = '-B'
if INPUT_SEED:
  inputSeedOptions = ''
  INI_FILE_DIR = os.path.join(os.path.dirname(TEST_EXECUTABLE), 'pin_ippcp_mrg_compl_st.ini')
  if os.path.exists(INI_FILE_DIR):
    inputSeedOptions = '-i{}'.format(INI_FILE_DIR)

# Possibility to run tests with all available on target machine features
optimizationOptions = ''
if OPTIMIZATION:
  optimizationOptions = '-T{}'.format(OPTIMIZATION.upper())
  OPTIMIZATION = ('_{}'.format(OPTIMIZATION)).upper()

CWD = os.getcwd()

# Run cpuInfo test to get available CPU features logged
retcode = subprocess.Popen([TEST_EXECUTABLE, "-o", "cpuinfo.log", "-t=tt__cpuInfo", optimizationOptions], stdout=subprocess.PIPE, shell=False)
retcode.communicate()

for (test, function) in test_list:
  rootLogger.info('-----------------------------------------------------------\n')
  rootLogger.info('Test:      {}\n'.format(test))
  rootLogger.info('Function:  {}\n'.format(function))
  if not inputSeedOptions: rootLogger.info('Enter seed: ')
  TRACE_DIR = os.path.join(PINCER_TRACE_DIR, '{}{}_{}'.format(ARCH, OPTIMIZATION.replace(',','_'), test))
  
  if not os.path.exists(TRACE_DIR): os.makedirs(TRACE_DIR)
  os.popen('cp cpuinfo.log {}/cpuinfo.log'.format(TRACE_DIR))
  os.chdir(TRACE_DIR)

  fun_suff = 'wrap_'
  if 'mbx_' in function:
    fun_suff = ''
  
  pincer_process = subprocess.Popen([PIN_TOOL, "-t", PINCER_LIB, "-f", '{}{}'.format(fun_suff,function), "--",
                                     TEST_EXECUTABLE, "-s", "summary.log", "-t=", test, optimizationOptions, inputSeedOptions, "-p{}".format(TEST_DATA_DIR)],
                                     stdout=subprocess.PIPE, shell=False)

  (out, err)     = pincer_process.communicate()
  out            = out.decode()
  return_code    = pincer_process.returncode

  # Write test executable output to a file
  with open('ts_result.txt', 'w') as f:
    f.write(out)
  
  if return_code:
    teardown("FATAL")
    print(out)
    sys.exit(1)

  # Check TS status
  TS_OK = re.search(r'\|.Number of tests\s+:\s+1.+\n\|.Successes\s+:\s+1', out) 
  if not TS_OK:
    teardown("ERR", folder=TRACE_DIR)
    os.chdir(CWD)
    continue

  # Check PINCER overall status
  with open('summary.out', 'r') as f:
    PIN_OK = "PASS" in f.read()
  if not PIN_OK:
    teardown("FAIL", folder=TRACE_DIR, disasm=True)
    os.chdir(CWD)
    continue

  # Run PINCER post-processing on generated traces and put the status in a file
  post_process.main(False, False, "result.txt")
  with open('result.txt', 'r') as f:
    POSTPROCESS_OK = "Addresses with tainted" not in f.read()
  if not POSTPROCESS_OK:
    teardown("FAIL", folder=TRACE_DIR, disasm=True)
    os.chdir(CWD)
    continue
  
  teardown("OK", folder=TRACE_DIR, archive=False, delete=True)
  os.chdir(CWD)
