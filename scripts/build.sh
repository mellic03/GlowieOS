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
BUILD="${PRJ}/build/aux/${TARGET}" && mkdir -p $BUILD


build_automake()
{
    cd $AUX

    NAME=automake
    if [[ ! -d "$NAME" ]]; then
        mkdir -p $NAME
        wget https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.gz
        tar -xvzf automake-1.15.1.tar.gz -C $NAME --strip-components=1
    fi
    mkdir -p $BUILD/$NAME && cd $BUILD/$NAME

    ${AUX}/$NAME/configure \
        --target=$TARGET \
        --prefix="$PREFIX"

    make -j$(nproc)
    make install
}

build_autoconf()
{
    cd $AUX

    NAME=autoconf
    if [[ ! -d "$NAME" ]]; then
        mkdir -p $NAME
        wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
        tar -xvzf autoconf-2.69.tar.gz -C $NAME --strip-components=1
    fi
    mkdir -p $BUILD/$NAME && cd $BUILD/$NAME

    ${AUX}/$NAME/configure \
        --target=$TARGET \
        --prefix="$PREFIX"

    make -j$(nproc)
    make install
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


# build_automake
# build_autoconf
# build_binutils
# build_gcc

find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
