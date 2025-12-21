#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../sources"

while read -r name url; do
    file="${url##*/}"
    if [[ ! -f "$file" ]]; then
        echo "Downloading $file"
        curl -L -O "$url"
    else
        echo "Using cached $file"
    fi
done < manifest.txt

sha256sum -c checksums.sha256
