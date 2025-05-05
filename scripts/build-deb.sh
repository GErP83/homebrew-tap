#!/bin/bash
# Usage: ./build-deb.sh <NAME> <VERSION>

set -e

NAME="$1"
VERSION="$2"
ARCH="amd64"
BUILD_DIR="build-deb"
PKG_ROOT="$BUILD_DIR/${NAME}_${VERSION}"
INSTALL_PREFIX="/usr/lib/$NAME"

if [ -z "$NAME" ] || [ -z "$VERSION" ]; then
  echo "Usage: $0 <NAME> <VERSION>"
  exit 1
fi

echo "==> Building Swift library"
swift build -c release

echo "==> Creating package structure"
rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/DEBIAN"
mkdir -p "$PKG_ROOT$INSTALL_PREFIX"

echo "==> Copying build artifacts"
cp -r .build/release/* "$PKG_ROOT$INSTALL_PREFIX"

echo "==> Creating control file"
cat > "$PKG_ROOT/DEBIAN/control" <<EOF
Package: $NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: Your Name <you@example.com>
Description: $NAME - Swift library
Section: libs
Priority: optional
EOF

echo "==> Building .deb package"
dpkg-deb --build "$PKG_ROOT"

echo "==> Done: $(realpath "$PKG_ROOT.deb")"