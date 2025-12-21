# #!/bin/bash

# HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# PRJ=$(cd $HERE/../ && pwd)

# mkdir -p $PRJ/{aux,.aux} && cd $PRJ/.aux
# wget -nc https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
# wget -nc https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.gz
# wget -nc https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2
# wget -nc https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
# wget -nc https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.bz2

# for f in *.tar.gz; do tar -xvzf "$f"; done
# for f in *.tar.bz2; do tar -xvjf "$f"; done
# # mv ./*.tar.* $PRJ/.aux/

# for d in */; do
#     if [[ ! -d "$PRJ/aux/$d" ]]; then
#         cp -r "$d" $PRJ/aux/
#     fi
# done


# # cd $PRJ/aux_pkg
# # for f in *.tar.gz; do tar -xvzf "$f"; done
# # for f in *.tar.bz2; do tar -xvjf "$f"; done
# #!/usr/bin/env bash
# set -euo pipefail

# cd "$(dirname "$0")/../sources"

# while read -r name url; do
#     file="${url##*/}"
#     if [[ ! -f "$file" ]]; then
#         echo "Downloading $file"
#         curl -L -O "$url"
#     else
#         echo "Using cached $file"
#     fi
# done < manifest.txt

# sha256sum -c checksums.sha256
