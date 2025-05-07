#!/bin/bash

set -e

VERSION="$1"
NAME="toucan"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <VERSION>"
  exit 1
fi

TARBALL="${NAME}-${VERSION}.tar.gz"
TOPDIR="$HOME/rpmbuild"

echo "📦 Building RPM for $NAME version $VERSION"

# Ensure RPM build directories exist
mkdir -p "$TOPDIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# Build Swift project
swift build -c release

# Stage binaries in usr/local/bin inside the source tree
APP_ROOT="$WORKDIR/${NAME}-${VERSION}/usr/local/bin"
mkdir -p "$APP_ROOT"

EXECUTABLES=$(find -L .build/release -type f -perm -111)
if [ -z "$EXECUTABLES" ]; then
  echo "❌ No executables found"
  exit 1
fi

for BIN in $EXECUTABLES; do
  cp "$BIN" "$APP_ROOT/"
  chmod +x "$APP_ROOT/$(basename "$BIN")"
  echo "✅ Added $(basename "$BIN")"
done

# Optionally copy docs
cp -f README.md LICENSE "$WORKDIR/${NAME}-${VERSION}/" 2>/dev/null || echo "ℹ️ Skipping docs (optional)"

# Create tarball for RPM
tar -czf "$TOPDIR/SOURCES/$TARBALL" -C "$WORKDIR" "${NAME}-${VERSION}"

# Copy static spec file
cp "packaging/${NAME}.spec" "$TOPDIR/SPECS/"

# Build RPM
rpmbuild -ba "$TOPDIR/SPECS/${NAME}.spec"

# Copy built RPM to release folder
FINAL_RPM=$(find "$TOPDIR/RPMS" -type f -name "*.rpm" | head -n1)
RELEASE_PATH="release/${NAME}-${VERSION}.x86_64.rpm"
mkdir -p release
cp "$FINAL_RPM" "$RELEASE_PATH"

echo "🎉 RPM created: $RELEASE_PATH"