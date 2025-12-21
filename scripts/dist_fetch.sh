#!/bin/bash

set -euo pipefail

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

cd ${DIST_DIR}
while read -r name url; do
    file="${url##*/}"
    if [[ ! -f "$file" ]]; then
        echo "Downloading $file"
        curl -L -O "$url"
    else
        echo "Using cached $file"
    fi
done < manifest.txt


if [[ "$#" == "1" ]]; then
    if [[ "$1" == "--checksum-regen" ]]; then
        sha256sum *.tar.* > checksum.sha256
    fi
else
    sha256sum -c checksum.sha256
fi
