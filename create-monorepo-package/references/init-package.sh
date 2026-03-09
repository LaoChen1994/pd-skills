#!/bin/bash

# Simple script to initialize a new package from templates
# Usage: ./init-package.sh <package-name>

PKG_NAME=$1

if [ -z "$PKG_NAME" ]; then
  echo "Usage: $0 <package-name>"
  exit 1
fi

DEST_DIR="../../packages/$PKG_NAME"

echo "Initializing package: $PKG_NAME in $DEST_DIR"

mkdir -p "$DEST_DIR/src"

# Copy templates and replace placeholders
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sed "s/\${package-name}/$PKG_NAME/g" "$SCRIPT_DIR/package.json.tmpl" > "$DEST_DIR/package.json"
cp "$SCRIPT_DIR/rollup.config.ts.tmpl" "$DEST_DIR/rollup.config.ts"
cp "$SCRIPT_DIR/tsconfig.json.tmpl" "$DEST_DIR/tsconfig.json"

# Create entry file
echo "export * from './index';" > "$DEST_DIR/src/index.ts"

echo "Done. Please remember to update root package.json and tsconfig.base.json as per SKILL.md."
