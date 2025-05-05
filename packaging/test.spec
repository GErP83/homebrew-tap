Name:           test
Version:        1.0.0
Release:        1%{?dist}
Summary:        Sample Swift RPM

License:        MIT
URL:            https://example.com/test
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  swift-lang
Requires:       swift-lang

%description
Test Swift library packaged as RPM.

%prep
%setup -q

%build
swift build -c release

%install
mkdir -p %{buildroot}/usr/lib/%{name}
cp -r .build/release/*.swiftmodule %{buildroot}/usr/lib/%{name}/ || :

%files
/usr/lib/%{name}

%changelog
* Mon May 05 2025 Developer <dev@example.com> - 1.0.0-1
- Initial build