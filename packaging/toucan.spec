Name:           toucan
Version:        %{ver}
Release:        1
Summary:        SSG tools

License:        MIT
URL:            https://github.com/toucansites/toucan
Source0:        %{name}-%{version}.tar.gz

BuildArch:      x86_64

%description
Toucan is a static site generator written in Swift.

%prep
%setup -q

%build
echo "Skipping build; using precompiled binaries."

%install
mkdir -p %{buildroot}/usr/local/bin
cp -a usr/local/bin/* %{buildroot}/usr/local/bin/

%files
/usr/local/bin/*
%dir /usr/local/bin

#%license LICENSE
#%doc README.md

%changelog
* Mon May 05 2025 Developer <dev@example.com> - %{ver}.x86_64
- Initial precompiled multi-binary CLI package installed to /usr/local/bin