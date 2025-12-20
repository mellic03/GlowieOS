#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX="${PRJ}/aux" && mkdir -p $AUX
BUILD="${PRJ}/build" && mkdir -p $BUILD

export PREFIX="${PRJ}/install"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"


build_automake()
{   NAME=automake

    if [[ ! -d "$AUX/$NAME" ]]; then
        mkdir -p $AUX/$NAME
        wget https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.gz
        tar -xvzf automake-1.15.1.tar.gz -C $AUX/$NAME --strip-components=1
    fi

    mkdir -p $BUILD/$NAME && cd $BUILD/$NAME
    ${AUX}/$NAME/configure --prefix="$PREFIX"
    make -j$(nproc)
    make install
}

build_autoconf()
{   NAME=autoconf

    if [[ ! -d "$AUX/$NAME" ]]; then
        mkdir -p $AUX/$NAME
        wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
        tar -xvzf autoconf-2.69.tar.gz -C $AUX/$NAME --strip-components=1
    fi

    mkdir -p $BUILD/$NAME && cd $BUILD/$NAME
    ${AUX}/$NAME/configure --prefix="$PREFIX"
    make -j$(nproc)
    make install
}

build_binutils()
{
    cd $AUX
    if [[ ! -d "binutils-gdb" ]]; then
        git clone https://github.com/mellic03/binutils-gdb.git \
            --branch osdev/feature --depth=1
    fi
    mkdir -p $BUILD/binutils && cd $BUILD/binutils

    ${AUX}/binutils-gdb/configure \
        --target=x86_64-elf-glowie \
        --prefix="$PREFIX" \
        --with-sysroot="" \
        --disable-nls \
        --disable-werror

    make -j$(nproc)
    make install
}

build_gcc()
{
    cd $AUX
    if [[ ! -d "gcc" ]]; then
        git clone https://github.com/mellic03/gcc.git \
            --branch osdev/feature --depth=1
        cd ./gcc && ./contrib/download_prerequisites
    fi

    mkdir -p $BUILD/gcc && cd $BUILD/gcc
    which -- $TARGET-as || echo $TARGET-as is not in the PATH

    ${AUX}/gcc/configure \
        --target=x86_64-elf-glowie \
        --prefix="$PREFIX" \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers \
        --disable-hosted-libstdcxx

    make all-gcc -j$(nproc)
    make all-target-libgcc -j$(nproc)
    make all-target-libstdc++-v3 -j$(nproc)
    make install-gcc -j$(nproc)
    make install-target-libgcc -j$(nproc)
    make install-target-libstdc++-v3 -j$(nproc)
}


# build_automake
# build_autoconf
# build_binutils
build_gcc

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
