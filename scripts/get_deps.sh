#!/bin/bash

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)

mkdir -p $PRJ/{aux,.aux} && cd $PRJ/.aux
wget -nc https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
wget -nc https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2
wget -nc https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.bz2

for f in *.tar.gz; do tar -xvzf "$f"; done
for f in *.tar.bz2; do tar -xvjf "$f"; done
# mv ./*.tar.* $PRJ/.aux/

for d in */; do
    if [[ ! -d "$PRJ/aux/$d" ]]; then
        cp -r "$d" $PRJ/aux/
    fi
done

# mkdir -p $PRJ/aux/gcc
# mv $PRJ/aux/

# cd $PRJ/aux_pkg
# for f in *.tar.gz; do tar -xvzf "$f"; done
# for f in *.tar.bz2; do tar -xvjf "$f"; done

cd $PRJ/aux
git clone https://github.com/anosig/binutils-gdb.git --branch feature --depth=1
git clone https://github.com/anosig/gcc.git --branch feature --depth=1
# cd ./gcc && ./contrib/download_prerequisites