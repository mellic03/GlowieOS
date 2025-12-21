#!/bin/bash
set -euo pipefail

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

for tarball in "$DIST_DIR"/*.tar.*; do
    name=$(basename "$tarball")
    echo "Extracting $name"
    tar -xf "$tarball" -C "$BUILD_DIR/dist"
done
