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

# Position Independent Execution (PIE)
set(LINK_FLAGS "${LINK_FLAGS} -Wl,-no-pie")

# Compiler keys
# Tells the compiler to emit debug information
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
# Tells the compiler to align functions and loops
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -falign-functions=32 -falign-loops=32")
# Optimization level = 3
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}")

# Suppress warnings from casts from a pointer to an integer type of a different size
set(AVX512_CFLAGS "-Wno-pointer-to-int-cast")

# Optimisation dependent flags
set(AVX512_CFLAGS "${AVX512_CFLAGS} -march=icelake-server -mavx512dq -mavx512ifma -mavx512f -mavx512vbmi2 -mavx512cd -mavx512bw -mbmi2")
