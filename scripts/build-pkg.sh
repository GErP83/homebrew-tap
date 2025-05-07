#!/bin/bash
set -e

VERSION="$1"
NAME="toucan"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <VERSION>"
  exit 1
fi

echo "📦 Creating .pkg for version $VERSION"

# Paths
ROOT_DIR=$(pwd)
PKGROOT="$ROOT_DIR/pkg-root"
RELEASE_DIR="$ROOT_DIR/release"
PKGFILE="$RELEASE_DIR/${NAME}-${VERSION}.pkg"
BIN_DIR=".build/release"

# Find executables
EXECUTABLES=$(find -L "$BIN_DIR" -type f -perm -111)

if [ -z "$EXECUTABLES" ]; then
  echo "❌ No executable binaries found in $BIN_DIR"
  exit 1
fi

# Prepare packaging structure
rm -rf "$PKGROOT"
mkdir -p "$PKGROOT/usr/local/bin"
mkdir -p "$RELEASE_DIR"

# Copy all executables and ensure they are executable
for BIN in $EXECUTABLES; do
  BASENAME=$(basename "$BIN")
  cp "$BIN" "$PKGROOT/usr/local/bin/$BASENAME"
  chmod +x "$PKGROOT/usr/local/bin/$BASENAME"
  echo "✅ Added $BASENAME"
done

# Build .pkg
pkgbuild \
  --identifier "com.binarybirds.${NAME}" \
  --version "$VERSION" \
  --install-location /usr/local/bin \
  --root "$PKGROOT" \
  "$PKGFILE"

echo "🎉 Package created at: $PKGFILE"