#!/bin/bash
set -euo pipefail

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

for tarball in "$DIST_DIR"/*.tar.*; do
    name=$(basename "$tarball")
    echo "Extracting $name"
    tar -xf "$tarball" -C "$DIST_DIR"
done


# if [[ "$#" != "1" ]]; then
#     echo "dist_extract.sh: Invalid usage"
#     exit 0
# fi

# OUTPUT_DIR=$1
# mkdir -p "${OUTPUT_DIR}"

# for tarball in "$DIST_DIR"/*.tar.*; do
#     name=$(basename "$tarball")
#     echo "Extracting $name"
#     tar -xf "$tarball" -C "${OUTPUT_DIR}"
# done
