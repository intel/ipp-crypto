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

project("apps" CXX)

# Algorithm tests

set(VFY_IFMA_RSA_MB_TARGET "vfy_ifma_rsa_mb")
add_executable(${VFY_IFMA_RSA_MB_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_ifma_rsa_mb.c") 
set_target_properties(${VFY_IFMA_RSA_MB_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS} ${AVX512_CFLAGS}" 
                                                            COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}"
                                                            LINKER_LANGUAGE CXX)
target_link_libraries(${VFY_IFMA_RSA_MB_TARGET}             "${IFMA_LIB_TARGET}"
                                                            OpenSSL::Crypto  
                                                            "dl" 
                                                            "pthread")


set(VFY_IFMA_CP_RSA_MB_TARGET "vfy_ifma_cp_rsa_mb")
add_executable(${VFY_IFMA_CP_RSA_MB_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_ifma_cp_rsa_mb.c")
set_target_properties(${VFY_IFMA_CP_RSA_MB_TARGET} PROPERTIES   COMPILE_FLAGS "${LINK_FLAGS}"
                                                                COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
target_link_libraries(${VFY_IFMA_CP_RSA_MB_TARGET}              "${IFMA_LIB_TARGET}" 
                                                                OpenSSL::Crypto 
                                                                "dl" 
                                                                "pthread")
                                                    