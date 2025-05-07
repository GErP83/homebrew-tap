#!/bin/bash

set -e

VERSION="$1"
NAME="toucan"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <VERSION>"
  exit 1
fi

ARCH="amd64"
BUILD_DIR="build-deb"
PKG_ROOT="$BUILD_DIR/${NAME}_${VERSION}"
INSTALL_PREFIX="/usr/lib/$NAME"
BIN_DIR=".build/release"

echo "📦 Building .deb for $NAME version $VERSION"

swift build -c release

EXECUTABLES=$(find -L "$BIN_DIR" -type f -perm -111)
if [ -z "$EXECUTABLES" ]; then
  echo "❌ No executable binaries found in $BIN_DIR"
  exit 1
fi

rm -rf "$PKG_ROOT"
mkdir -p "$PKG_ROOT/DEBIAN"
mkdir -p "$PKG_ROOT$INSTALL_PREFIX"

for BIN in $EXECUTABLES; do
  BASENAME=$(basename "$BIN")
  cp "$BIN" "$PKG_ROOT$INSTALL_PREFIX/$BASENAME"
  chmod +x "$PKG_ROOT$INSTALL_PREFIX/$BASENAME"
  echo "✅ Added $BASENAME"
done

cat > "$PKG_ROOT/DEBIAN/control" <<EOF
Package: $NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: Your Name <info@binarybirds.com>
Description: $NAME - Swift CLI tools
Section: utils
Priority: optional
EOF

dpkg-deb --build "$PKG_ROOT"
FINAL_DEB="${BUILD_DIR}/${NAME}-${VERSION}.deb"
mv "$PKG_ROOT.deb" "$FINAL_DEB"
echo "🎉 Package created at: $FINAL_DEB"