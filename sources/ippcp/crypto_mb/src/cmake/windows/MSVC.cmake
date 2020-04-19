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

# Compiler keys
# Tells the compiler to generate symbolic debugging information in the object file
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Z7")
# Optimization level = 3
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O2")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}")

# Optimisation dependent flags
set(AVX512_CFLAGS "${AVX512_CFLAGS} /arch:AVX512")
