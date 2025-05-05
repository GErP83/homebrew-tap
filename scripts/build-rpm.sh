#!/bin/bash
# Usage: ./build-rpm.sh <NAME> <VERSION>

set -e

NAME="$1"
VERSION="$2"
TARBALL="${NAME}-${VERSION}.tar.gz"
TOPDIR="$HOME/rpmbuild"

if [ -z "$NAME" ] || [ -z "$VERSION" ]; then
  echo "Usage: $0 <NAME> <VERSION>"
  exit 1
fi

echo "==> RPM Build Script"
echo "Package: $NAME"
echo "Version: $VERSION"

echo "==> Setting up RPM directories"
mkdir -p "$TOPDIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

WORKDIR=$(mktemp -d)
cp -R . "$WORKDIR/${NAME}-${VERSION}"
rm -rf "$WORKDIR/${NAME}-${VERSION}/.git" "$WORKDIR/${NAME}-${VERSION}/.build"

echo "==> Creating source tarball"
tar -czf "$TOPDIR/SOURCES/$TARBALL" -C "$WORKDIR" "${NAME}-${VERSION}"

echo "==> Copying spec file"
cp "packaging/${NAME}.spec" "$TOPDIR/SPECS/"

echo "==> Running rpmbuild"
rpmbuild -ba "$TOPDIR/SPECS/${NAME}.spec"

echo "==> Cleaning up temp"
rm -rf "$WORKDIR"

echo "==> RPM built successfully"