#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

opt_prefix=""
opt_target=""

while [[ "$1" != "" ]]; do
    case "$1" in
        --prefix )
            opt_prefix=$2
            shift
            shift
            ;;
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

TARGET=""
if [[ "$opt_target" != "" ]]; then
    TARGET=$opt_target
else
    TARGET="x86_64-elf"
fi

PREFIX=""
if [[ "$opt_prefix" != "" ]]; then
    PREFIX=$opt_prefix
else
    PREFIX="${REPO_ROOT}/build/${TARGET}"
fi
BUILD_DIR="${BUILD_ROOT}/dist/${TARGET}"
mkdir -vp "${PREFIX}" "${BUILD_DIR}"

echo -e "\n\nTARGET=$TARGET\nPREFIX=$PREFIX\nBUILD_DIR=$BUILD_DIR\n\n"


export TARGET
export PREFIX
export PATH="$PREFIX/bin:$PATH"

mkpkg()
{
    pkgname=""
    pkgbuild=""
    if [[ "$1" == "--pkg-name" ]]; then
        pkgname=$2
        pkgbuild=$BUILD_DIR/$pkgname
        mkdir -vp $pkgbuild
        shift; shift
    else
        echo "build.sh/mkpkg: Invalid usage"
        exit 0
    fi

    cd $pkgbuild
    $DIST_DIR/$pkgname/configure --prefix="$PREFIX" $@
    make -j$(nproc)
    make install
}

mkrepo()
{
    repo_stem=""
    repo_name=""

    if [[ "$1" == "--stem" ]]; then
        repo_stem=$2; shift; shift;
    else
        echo "build.sh/mkpkg: Invalid usage"; exit 0
    fi

    if [[ "$1" == "--name" ]]; then
        repo_name=$2; shift; shift;
    else
        echo "build.sh/mkrepo: Invalid usage"; exit 0
    fi
    mkdir -vp $BUILD_DIR/$repo_name

    cd $BUILD_DIR/$repo_name
    $repo_stem/$repo_name/configure --prefix="$PREFIX" $@
    make -j$(nproc)
    make install
}

build_binutils()
{
    mkdir -p $BUILD_DIR/binutils-gdb && cd $BUILD_DIR/binutils-gdb

    /home/michael/devel/binutils-gdb/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --with-sysroot \
        --disable-nls \
        --disable-werror

    make -j$(nproc)
    make install
}

# build_gcc()
# {
#     cd $AUX
#     if [[ ! -d "gcc" ]]; then
#         git clone https://github.com/anosig/gcc.git \
#             --branch feature --depth=1
#         cd ./gcc && ./contrib/download_prerequisites
#     fi
#     mkdir -p $BUILD/gcc && cd $BUILD/gcc
#     which -- $TARGET-as || echo $TARGET-as is not in the PATH

#     ${AUX}/gcc/configure \
#         --target=$TARGET \
#         --prefix="$PREFIX" \
#         --disable-nls \
#         --enable-languages=c,c++ \
#         --without-headers \
#         --disable-hosted-libstdcxx

#     make all-gcc all-target-libgcc all-target-libstdc++-v3 -j$(nproc)
#     make install-gcc install-target-libgcc install-target-libstdc++-v3
# }

mkpkg --pkg-name autoconf-2.69 --target=$TARGET
mkpkg --pkg-name automake-1.15.1 --target=$TARGET

build_binutils

# mkrepo --stem $REPO_ROOT/../ --name binutils-gdb --target=$TARGET --with-sysroot --disable-nls --disable-werror
# mkpkg gcc --target=$TARGET --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
