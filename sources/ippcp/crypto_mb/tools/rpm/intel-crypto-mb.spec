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
%global github_source_archive_name   develop

# disable producing debuginfo for this package
%global debug_package %{nil}

Summary:            Crypto Multi-buffer Library
Name:               intel-crypto-mb
Release:            1%{?dist}
Version:            %{fullversion}
License:            ASL 2.0
Group:              Development/Tools
ExclusiveArch:      x86_64
Source0:            %{github_repo_url}/archive/%{github_source_archive_name}.zip
URL:                %{github_repo_url}
BuildRequires:      cmake >= 3.10
BuildRequires:      openssl >= 1.1.0
BuildRequires:      gcc >= 8.2

%description
Crypto Multi-buffer Library optimized for Intel Architecture

For additional information please refer to:
%{github_repo_url}/blob/develop/sources/ippcp/crypto_mb

%package -n intel-crypto-mb-devel
Summary:            Crypto Multi-buffer Library
License:            BSD
Requires:           intel-crypto-mb >= %{fullversion}
Group:              Development/Tools
ExclusiveArch:      x86_64

%description -n intel-crypto-mb-devel
Crypto Multi-buffer Library optimized for Intel Architecture

For additional information please refer to:
%{github_repo_url}/blob/develop/sources/ippcp/crypto_mb

%prep
%setup -n ipp-crypto-%{github_source_archive_name}

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%build
cmake sources/ippcp/crypto_mb/CMakeLists.txt -B_build-crypto-mb -DCMAKE_STATIC_ENABLE=1
cd _build-crypto-mb
make %{?_smp_mflags}

%install
rm -rf "%{buildroot}"
# Install the license
install -d %{buildroot}/%{_licensedir}/%{name}-%{fullversion}
install -m 0644 LICENSE %{buildroot}/%{_licensedir}/%{name}-%{fullversion}
# Install headers
install -d %{buildroot}/%{_includedir}/crypto_mb/crypto_mb
install -d %{buildroot}/%{_includedir}/crypto_mb/internal/common
install -d %{buildroot}/%{_includedir}/crypto_mb/internal/rsa
install -m 0644 -t %{buildroot}/%{_includedir}/crypto_mb/crypto_mb sources/ippcp/crypto_mb/include/crypto_mb/*.h
install -m 0644 -t %{buildroot}/%{_includedir}/crypto_mb/internal/common sources/ippcp/crypto_mb/include/internal/common/*.h
install -m 0644 -t %{buildroot}/%{_includedir}/crypto_mb/internal/rsa sources/ippcp/crypto_mb/include/internal/rsa/*.h
# Install the library
install -d %{buildroot}/%{_libdir}
install -s -m 0755 -T _build-crypto-mb/bin/libcrypto_mb.so %{buildroot}/%{_libdir}/libcrypto_mb.so.%{fullversion}
cd %{buildroot}/%{_libdir}
ln -s libcrypto_mb.so.%{fullversion} libcrypto_mb.so.0
ln -s libcrypto_mb.so.%{fullversion} libcrypto_mb.so

%files
%license %{_licensedir}/%{name}-%{fullversion}/LICENSE
%doc sources/ippcp/crypto_mb/Readme.md
%{_libdir}/libcrypto_mb.so.%{fullversion}
%{_libdir}/libcrypto_mb.so.%{major}
%{_libdir}/libcrypto_mb.so

%files -n intel-crypto-mb-devel
%dir %{_includedir}/crypto_mb
%{_includedir}/crypto_mb/crypto_mb/defs.h
%{_includedir}/crypto_mb/crypto_mb/x25519.h
%{_includedir}/crypto_mb/crypto_mb/status.h
%{_includedir}/crypto_mb/crypto_mb/cpu_features.h
%{_includedir}/crypto_mb/crypto_mb/rsa.h
%{_includedir}/crypto_mb/internal/rsa/ifma_div_104_by_52.h
%{_includedir}/crypto_mb/internal/rsa/ifma_rsa_arith.h
%{_includedir}/crypto_mb/internal/rsa/ifma_rsa_layer_cp.h
%{_includedir}/crypto_mb/internal/rsa/ifma_rsa_method.h
%{_includedir}/crypto_mb/internal/rsa/ifma_rsa_layer_ssl.h
%{_includedir}/crypto_mb/internal/common/ifma_math.h
%{_includedir}/crypto_mb/internal/common/ifma_defs.h
%{_includedir}/crypto_mb/internal/common/ifma_cvt52.h
