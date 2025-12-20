#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX="${PRJ}/aux"
BUILD="${PRJ}/build"

export PREFIX="${PRJ}/install"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

build_binutils()
{
    mkdir -p $BUILD/binutils && cd $BUILD/binutils

    ${AUX}/binutils-gdb/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --with-sysroot \
        --disable-nls \
        --disable-werror

    make -j$(nproc)
    make install
}

build_gcc()
{
    mkdir -p $BUILD/gcc && cd $BUILD/gcc

    # The $PREFIX/bin dir _must_ be in the PATH. We did that above.
    which -- $TARGET-as || echo $TARGET-as is not in the PATH

    ${AUX}/gcc-15.2.0/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers \
        --disable-hosted-libstdcxx

    # make all-gcc -j$(nproc)
    # make all-target-libgcc -j$(nproc)
    # make all-target-libstdc++-v3 -j$(nproc)
    # make install-gcc -j$(nproc)
    # make install-target-libgcc -j$(nproc)
    # make install-target-libstdc++-v3 -j$(nproc)
}

build_binutils
# build_gcc

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'