#===============================================================================
# Copyright 2019-2020 Intel Corporation
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

# generate
set(PATH_TO_GENERATION_SCRIPTS "${CMAKE_CURRENT_SOURCE_DIR}/scripts/codegen")

if(IFMA_IPPCP_BUILD)
    set(IFMA_GEN_SRC_DIR "${CMAKE_BINARY_DIR}/sources/ippcp/ifma_rsa_mb/gen")
else()
    set(IFMA_GEN_SRC_DIR "${CMAKE_BINARY_DIR}/src/gen")
    set(GENERATE_COMMANDS
        # RSA-1K
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x10_diagonal_mb8 10 5"
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x20_diagonal_mb8 20 5"
        # RSA-2K
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x40_diagonal_mb8 40 5"
        # RSA-3K
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x60_diagonal_mb8 60 5"
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x30_diagonal_mb8 30 5"
        # RSA-4K
        "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS5x52x79_diagonal_mb8 79 5"
    )

endif()

set(TEMPLATE_FILE "${PATH_TO_GENERATION_SCRIPTS}/ifma52_mb8_template.c")
set(GENERATE_COMMANDS ${GENERATE_COMMANDS}
    # RSA-1K
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x10_diagonal_mb8 10 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x10_mb8 10"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x20_diagonal_mb8 20 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x20_mb8 20"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_extract_amm52_mb8.py ifma_extract_amm52x20_mb8 20 5"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_extract_amm52_mb8.py ifma_extract_amm52x20_mb8 20 5"
    # RSA-2K
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x40_diagonal_mb8 40 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x40_mb8 40"
    # RSA-3K
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x60_diagonal_mb8 60 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x60_mb8 60"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x30_diagonal_mb8 30 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x30_mb8 30"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x30_mb8 30"
    # RSA-4K
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_ams52_diagonal_mb8.py AMS52x79_diagonal_mb8 79 1"
    "${PATH_TO_GENERATION_SCRIPTS}/ifma_amm52_mb8.py ifma_amm52x79_mb8 79"
)



message(STATUS "Generating code with python scripts...")
file(MAKE_DIRECTORY "${IFMA_GEN_SRC_DIR}")
foreach(COMM ${GENERATE_COMMANDS})
    string(REPLACE " " ";" COMM ${COMM}) # string to list
    list(GET COMM 1 OUT_FILENAME) # output file name
    list(INSERT COMM 1 "${TEMPLATE_FILE}") # insert the template file as the first argument to the script

    execute_process(COMMAND ${Python_EXECUTABLE} ${COMM}
        RESULT_VARIABLE RESULT
        OUTPUT_FILE "${IFMA_GEN_SRC_DIR}/${OUT_FILENAME}.c"
    )

    if (RESULT)
        message(FATAL_ERROR "Code generation failed at ${OUT_FILENAME}.c with\n${RESULT}")
    endif()
endforeach()
message(STATUS "Code generation complete")
