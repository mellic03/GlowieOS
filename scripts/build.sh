#!/bin/bash
set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX="${PRJ}/aux" && mkdir -p $AUX

opt_target="x86_64-elf"
while [[ "$1" != "" ]]; do
    case "$1" in
        --target )
            opt_target=$2
            shift
            shift
            ;;
        * )
            echo "Error: Invalid argument $1"
            exit 1
            ;;
    esac
done


export TARGET=$opt_target
export PREFIX="${PRJ}/build/${TARGET}-tools"
export PATH="$PREFIX/bin:$PATH"
BUILD="${PRJ}/build/aux/${TARGET}"
mkdir -p $BUILD

build_package()
{
    PKG_NAME=$1
    TGT_FLAG=--target=$TARGET

    if [[ "$2" == "--no-target" ]]; then
        TGT_FLAG=""
    fi

    echo -e "\n---------------- CONFIGURE $TARGET/$PKG_NAME ----------------"
    mkdir -p $BUILD/$PKG_NAME && cd $BUILD/$PKG_NAME
    ${AUX}/$PKG_NAME/configure $TGT_FLAG --prefix="$PREFIX"

    echo -e "\n---------------- BUILD $TARGET/$PKG_NAME ---------------------"
    make -j$(nproc)

    echo -e "\n---------------- INSTALL $TARGET/$PKG_NAME -------------------"
    make install

    echo -e "\n---------------- FINISHED $TARGET/$PKG_NAME ------------------\n"
}

build_binutils()
{
    cd $AUX
    if [[ ! -d "binutils-gdb" ]]; then
        git clone https://github.com/anosig/binutils-gdb.git \
            --branch feature --depth=1
    fi
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
    cd $AUX
    if [[ ! -d "gcc" ]]; then
        git clone https://github.com/anosig/gcc.git \
            --branch feature --depth=1
        cd ./gcc && ./contrib/download_prerequisites
    fi
    mkdir -p $BUILD/gcc && cd $BUILD/gcc
    which -- $TARGET-as || echo $TARGET-as is not in the PATH

    ${AUX}/gcc/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers \
        --disable-hosted-libstdcxx

    make all-gcc all-target-libgcc all-target-libstdc++-v3 -j$(nproc)
    make install-gcc install-target-libgcc install-target-libstdc++-v3
}

build_package autoconf
build_package automake
build_package gcc/gmp-6.2.1 --no-target
build_package gcc/mpc-1.2.1
build_package gcc/mpfr-4.1.0
# build_binutils
# build_gcc

find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
