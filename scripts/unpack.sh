#!/usr/bin/env bash
set -euo pipefail

PKG_DIR="$(pwd)/sources"
BUILD_DIR="$(pwd)/build"
# BUILD_DIR="$(pwd)/build/packages"

mkdir -p "$BUILD_DIR"

for tarball in "$PKG_DIR"/*.tar.*; do
    name=$(basename "$tarball")
    echo "Extracting $name"
    tar -xf "$tarball" -C "$BUILD_DIR"
done
