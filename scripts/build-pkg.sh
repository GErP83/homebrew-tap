#!/bin/bash
set -e

NAME=$1
VERSION=$2

echo "📦 Creating .pkg for $NAME version $VERSION"

# Paths
ROOT_DIR=$(pwd)
PKGROOT="$ROOT_DIR/pkg-root"
RELEASE_DIR="$ROOT_DIR/release"
PKGFILE="$RELEASE_DIR/${NAME}-${VERSION}.pkg"

# Prepare install root
mkdir -p "$PKGROOT/usr/local/bin"

# TODO replace testify here
cp ".build/release/testify" "$PKGROOT/usr/local/bin/"

# Create release dir if needed
mkdir -p "$RELEASE_DIR"

# Build the package
pkgbuild \
  --identifier "com.example.${NAME}" \
  --version "$VERSION" \
  --install-location /usr/local/bin \
  --root "$PKGROOT" \
  "$PKGFILE"

echo "✅ Package created at: $PKGFILE"