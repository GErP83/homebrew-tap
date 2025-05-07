#!/bin/bash
# Usage: ./build-rpm.sh <VERSION>

set -e

VERSION="$1"
NAME="toucan"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <VERSION>"
  exit 1
fi

TARBALL="${NAME}-${VERSION}.tar.gz"
TOPDIR="$HOME/rpmbuild"
BIN_DIR=".build/release"

echo "📦 Building RPM for $NAME version $VERSION"
swift build -c release

mkdir -p "$TOPDIR"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
WORKDIR=$(mktemp -d)
trap rm -rf "$WORKDIR" EXIT

APP_ROOT="$WORKDIR/${NAME}-${VERSION}/usr/lib/$NAME"
mkdir -p "$APP_ROOT"

EXECUTABLES=$(find -L "$BIN_DIR" -type f -perm -111)
if [ -z "$EXECUTABLES" ]; then
  echo "❌ No executables found in $BIN_DIR"
  exit 1
fi

for BIN in $EXECUTABLES; do
  BASENAME=$(basename "$BIN")
  cp "$BIN" "$APP_ROOT/$BASENAME"
  chmod +x "$APP_ROOT/$BASENAME"
  echo "✅ Added $BASENAME"
done

tar -czf "$TOPDIR/SOURCES/$TARBALL" -C "$WORKDIR" "${NAME}-${VERSION}"

cp "packaging/${NAME}.spec" "$TOPDIR/SPECS/"
rpmbuild -ba "$TOPDIR/SPECS/${NAME}.spec" \
  --define "ver $VERSION"

echo "🎉 RPM built. Files:"
find "$TOPDIR/RPMS" -type f -name "*.rpm"