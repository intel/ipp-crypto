############################################################################
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
############################################################################

# Versions numbers
%global major        0
%global minor        5
%global rev          3
%global fullversion  %{major}.%{minor}.%{rev}

%global github_repo_url              https://github.com/intel/ipp-crypto
%global github_source_archive_name   ippcp_2020u3

%global rpm_name         intel-ipp-crypto-mb
%global product_name     Intel(R) IPP Cryptography multi-buffer library

# disable producing debuginfo for this package
%global debug_package %{nil}

Summary:            %{product_name}
Name:               %{rpm_name}
Release:            1%{?dist}
Version:            %{fullversion}
License:            ASL 2.0
Group:              Development/Tools
ExclusiveArch:      x86_64
Source0:            %{github_repo_url}/archive/%{github_source_archive_name}.zip#/%{rpm_name}-%{github_source_archive_name}.zip
URL:                %{github_repo_url}
BuildRequires:      cmake >= 3.10
BuildRequires:      openssl >= 1.1.0
BuildRequires:      gcc >= 8.2

%description
%{product_name}

For additional information please refer to:
%{github_repo_url}/blob/develop/sources/ippcp/crypto_mb

%package -n %{rpm_name}-devel
Summary:            %{product_name} (Development Files)
License:            ASL 2.0
Requires:           %{name}%{?_isa} = %{version}-%{release}
Group:              Development/Tools
ExclusiveArch:      x86_64

%description -n %{rpm_name}-devel
%{product_name} (Development Files)

For additional information please refer to:
%{github_repo_url}/blob/develop/sources/ippcp/crypto_mb

%prep
%setup -n ipp-crypto-%{github_source_archive_name}

%build
cmake sources/ippcp/crypto_mb/CMakeLists.txt -B_build-crypto-mb -DCMAKE_STATIC_ENABLE=1
cd _build-crypto-mb
%make_build

%install
rm -rf %{buildroot}
install -d %{buildroot}/%{_includedir}/crypto_mb
install -d %{buildroot}/%{_includedir}/internal/common
install -d %{buildroot}/%{_includedir}/internal/rsa
install -m 0644 -t %{buildroot}/%{_includedir}/crypto_mb sources/ippcp/crypto_mb/include/crypto_mb/*.h
install -m 0644 -t %{buildroot}/%{_includedir}/internal/common sources/ippcp/crypto_mb/include/internal/common/*.h
install -m 0644 -t %{buildroot}/%{_includedir}/internal/rsa sources/ippcp/crypto_mb/include/internal/rsa/*.h
install -d %{buildroot}/%{_libdir}
install -s -m 0755 -T _build-crypto-mb/bin/libcrypto_mb.so %{buildroot}/%{_libdir}/libcrypto_mb.so.%{fullversion}
cd %{buildroot}/%{_libdir}
ln -s libcrypto_mb.so.%{fullversion} libcrypto_mb.so.%{major}
ln -s libcrypto_mb.so.%{fullversion} libcrypto_mb.so

%if 0%{?rhel} && 0%{?rhel} < 8
%ldconfig_scriptlets
%endif

%files
%license LICENSE
%doc sources/ippcp/crypto_mb/Readme.md
%{_libdir}/libcrypto_mb.so.%{fullversion}
%{_libdir}/libcrypto_mb.so.%{major}

%files -n %{rpm_name}-devel
%dir %{_includedir}/crypto_mb
%{_includedir}/crypto_mb/defs.h
%{_includedir}/crypto_mb/x25519.h
%{_includedir}/crypto_mb/status.h
%{_includedir}/crypto_mb/cpu_features.h
%{_includedir}/crypto_mb/rsa.h
%{_includedir}/internal/rsa/ifma_div_104_by_52.h
%{_includedir}/internal/rsa/ifma_rsa_arith.h
%{_includedir}/internal/rsa/ifma_rsa_layer_cp.h
%{_includedir}/internal/rsa/ifma_rsa_method.h
%{_includedir}/internal/rsa/ifma_rsa_layer_ssl.h
%{_includedir}/internal/common/ifma_math.h
%{_includedir}/internal/common/ifma_defs.h
%{_includedir}/internal/common/ifma_cvt52.h
%{_libdir}/libcrypto_mb.so
