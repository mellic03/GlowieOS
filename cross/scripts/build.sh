#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT=$(cd $HERE/../ && pwd)
AUX="${ROOT}/aux"
BUILD="${ROOT}/build-aux"

export PREFIX="${ROOT}/install"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $BUILD/{binutils,gcc};


build_binutils()
{
    mkdir -p $BUILD/binutils && cd $BUILD/binutils

    ${AUX}/binutils-2.45.1/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --with-sysroot \
        --disable-nls \
        --disable-werror

    make -j4
    make install
}

build_gdb()
{
    mkdir -p $BUILD/gdb && cd $BUILD/gdb

    ${AUX}/gdb-17.1/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --disable-werror

    make all-gdb -j4
    make install-gdb
}

build_gcc()
{
    mkdir -p $BUILD/gcc && cd $BUILD/gcc

    # The $PREFIX/bin dir _must_ be in the PATH. We did that above.
    which -- $TARGET-as || echo $TARGET-as is not in the PATH

    # ${AUX}/gcc-15.2.0/configure \
    #     --target=$TARGET \
    #     --prefix="$PREFIX" \
    #     --disable-nls \
    #     --enable-languages=c,c++ \
    #     --without-headers \
    #     --disable-hosted-libstdcxx

    # make all-gcc -j4
    # make all-target-libgcc -j4
    # make all-target-libstdc++-v3 -j4
    make install-gcc -j4
    make install-target-libgcc -j4
    make install-target-libstdc++-v3 -j4
}

# build_binutils
# build_gdb
# build_gcc

find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'