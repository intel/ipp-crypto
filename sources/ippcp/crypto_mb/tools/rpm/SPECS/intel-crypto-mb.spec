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
%global major        1
%global minor        0
%global rev          1
%global fullversion  %{major}.%{minor}.%{rev}

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
ExclusiveArch:      x86_64
URL:                https://github.com/intel/ipp-crypto
Source0:            %{url}/archive/%{github_source_archive_name}.tar.gz#/%{rpm_name}-%{github_source_archive_name}.tar.gz
# This patch is temporary until soversion is fixed in upstream
Patch0:             0001-fix-for-soversion-in-ippcp2020u3.patch
BuildRequires:      coreutils
BuildRequires:      make
BuildRequires:      tar
BuildRequires:      cmake >= 3.10
BuildRequires:      openssl-devel >= 1.1.0
BuildRequires:      gcc-c++ >= 8.2

%description
A software crypto library optimized for Intel architecture for packet
processing applications.

It contains universal and OpenSSL compatible APIs for cryptography operations,
such as:
- RSA encryption and decryption;
- ECDHE, ECDSA with different curves.

For additional information please refer to:
%{url}/blob/ippcp_2020u3/sources/ippcp/crypto_mb/Readme.md


%package devel
Summary:            %{product_name} (Development Files)
License:            ASL 2.0
Requires:           %{name}%{?_isa} = %{version}-%{release}
ExclusiveArch:      x86_64

%description devel
A software crypto library optimized for Intel architecture for packet
processing applications.

It contains development libraries and header files.

For additional information please refer to:
%{url}/tree/ippcp_2020u3/sources/ippcp/crypto_mb


%prep
%autosetup -n ipp-crypto-%{github_source_archive_name} -p1

%build
cmake sources/ippcp/crypto_mb/CMakeLists.txt -B_build-crypto-mb
cd _build-crypto-mb
%make_build

%install
install -d %{buildroot}/%{_includedir}/crypto_mb
install -m 0644 -t %{buildroot}/%{_includedir}/crypto_mb sources/ippcp/crypto_mb/include/crypto_mb/*.h
install -d %{buildroot}/%{_libdir}
install -s -m 0755 _build-crypto-mb/bin/libcrypto_mb.so.%{fullversion} %{buildroot}/%{_libdir}
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

%files devel
%dir %{_includedir}/crypto_mb
%{_includedir}/crypto_mb/cpu_features.h
%{_includedir}/crypto_mb/defs.h
%{_includedir}/crypto_mb/ec_nistp256.h
%{_includedir}/crypto_mb/ec_nistp384.h
%{_includedir}/crypto_mb/rsa.h
%{_includedir}/crypto_mb/status.h
%{_includedir}/crypto_mb/version.h
%{_includedir}/crypto_mb/x25519.h
%{_libdir}/libcrypto_mb.so

%changelog

* Wed Oct 21 2020 Intel - 1.0.1-1
- Refactoring of crypto_mb library (API naming, directory structure changes, etc);
- Added ECDSA/ECDHE for the NIST P-256 curve;
- Added ECDSA/ECDHE for the NIST P-384 curve.
