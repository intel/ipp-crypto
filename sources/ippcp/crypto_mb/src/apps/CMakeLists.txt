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

# Algorithm tests. Verification is based on OpenSSL.
if (NOT OPENSSL_FOUND)
    find_package(OpenSSL 1.1.0 QUIET)
endif()

if (NOT OPENSSL_DISABLE)
    if (OPENSSL_FOUND)
        message(STATUS "Found OpenSSL version for algorithm tests building is ${OPENSSL_VERSION}")

       # Testing of functions with OpenSSL-based API.
        set(VFY_MBX_RSA_SSL_TARGET "vfy_mbx_rsa_ssl")
        add_executable(${VFY_MBX_RSA_SSL_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_rsa_ssl.c")
        set_target_properties(${VFY_MBX_RSA_SSL_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                                    COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_RSA_SSL_TARGET}             "${MB_LIB_TARGET}"
                                                                    OpenSSL::Crypto
                                                                    "${LINK_LIBRARIES}")

        set(VFY_MBX_RSA_TARGET "vfy_mbx_rsa")
        add_executable(${VFY_MBX_RSA_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_rsa.c")
        set_target_properties(${VFY_MBX_RSA_TARGET} PROPERTIES   COMPILE_FLAGS "${LINK_FLAGS}"
                                                                 COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_RSA_TARGET}              "${MB_LIB_TARGET}"
                                                                 OpenSSL::Crypto
                                                                 "${LINK_LIBRARIES}")

        set(VFY_MBX_X25519_TARGET "vfy_mbx_x25519")
        add_executable(${VFY_MBX_X25519_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_x25519.c")
        set_target_properties(${VFY_MBX_X25519_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                       COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_X25519_TARGET} "${MB_LIB_TARGET}"
                                                       OpenSSL::Crypto
                                                       "${LINK_LIBRARIES}")

        set(VFY_MBX_ECNISTP256_SSL_TARGET "vfy_mbx_ec_nistp256_ssl")
        add_executable(${VFY_MBX_ECNISTP256_SSL_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_ec_nistp256_ssl.c")
        set_target_properties(${VFY_MBX_ECNISTP256_SSL_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                               COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_ECNISTP256_SSL_TARGET}     "${MB_LIB_TARGET}"
                                                                    OpenSSL::Crypto
                                                                    "${LINK_LIBRARIES}")

        set(VFY_MBX_ECNISTP384_SSL_TARGET "vfy_mbx_ec_nistp384_ssl")
        add_executable(${VFY_MBX_ECNISTP384_SSL_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_ec_nistp384_ssl.c")
        set_target_properties(${VFY_MBX_ECNISTP384_SSL_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                               COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_ECNISTP384_SSL_TARGET}     "${MB_LIB_TARGET}"
                                                                   OpenSSL::Crypto
                                                                   "${LINK_LIBRARIES}")

        set(VFY_MBX_ECNISTP256_TARGET "vfy_mbx_ec_nistp256")
        add_executable(${VFY_MBX_ECNISTP256_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_ec_nistp256.c")
        set_target_properties(${VFY_MBX_ECNISTP256_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                           COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_ECNISTP256_TARGET}     "${MB_LIB_TARGET}"
                                                               OpenSSL::Crypto
                                                               "${LINK_LIBRARIES}")

        set(VFY_MBX_ECNISTP384_TARGET "vfy_mbx_ec_nistp384")
        add_executable(${VFY_MBX_ECNISTP384_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_ec_nistp384.c")
        set_target_properties(${VFY_MBX_ECNISTP384_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                           COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
        target_link_libraries(${VFY_MBX_ECNISTP384_TARGET}     "${MB_LIB_TARGET}"
                                                               OpenSSL::Crypto
                                                               "${LINK_LIBRARIES}")
    else()
        message(STATUS "Could NOT find suitable OpenSSL version, algorithm test vfy_mbx{_rsa/x25519/ec_nistp256/ec_nistp384} will not be built. Try to set the path to OpenSSL root folder in the system variable OPENSSL_ROOT_DIR")
    endif()
endif()

# CPU features tests
set(VFY_MBX_CPU_FEATURES_TARGET "vfy_mbx_cpu_features")
add_executable(${VFY_MBX_CPU_FEATURES_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/vfy_mbx_cpu_features.c")
set_target_properties(${VFY_MBX_CPU_FEATURES_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                     COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
target_link_libraries(${VFY_MBX_CPU_FEATURES_TARGET} ${MB_LIB_TARGET}
                                                     "${LINK_LIBRARIES}")

# Bad arguments tests
set(BA_MBX_RSA_TARGET "ba_mbx_rsa")
add_executable(${BA_MBX_RSA_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/ba_mbx_rsa.c")
set_target_properties(${BA_MBX_RSA_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                            COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
target_link_libraries(${BA_MBX_RSA_TARGET}                  ${MB_LIB_TARGET}
                                                            "${LINK_LIBRARIES}")

set(BA_MBX_X25519_TARGET "ba_mbx_x25519")
add_executable(${BA_MBX_X25519_TARGET} "${CMAKE_CURRENT_SOURCE_DIR}/ba_mbx_x25519.c")
set_target_properties(${BA_MBX_X25519_TARGET} PROPERTIES  COMPILE_FLAGS "${LINK_FLAGS}"
                                                            COMPILE_DEFINITIONS "${AVX512_LIBRARY_DEFINES}")
target_link_libraries(${BA_MBX_X25519_TARGET}               ${MB_LIB_TARGET}
                                                            "${LINK_LIBRARIES}")
