#!/bin/bash

set -e

if [ -z "$TARGET" ]; then
    echo "Invalid usage: TARGET not set"
    exit 1
elif [ -z "$PREFIX" ]; then
    echo "Invalid usage: PREFIX not set"
    exit 1
fi

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh
BUILD_DIR="$REPO_ROOT/build/$TARGET"

while [[ "$1" != "" ]]; do
    case "$1" in
        --clean )
            rm -rf $BUILD_DIR/*
            $SCRIPT_DIR/dist_fetch.sh --clean
            shift
            ;;
        * )
            echo "Error: Invalid argument $1"
            exit 1
            ;;
    esac
done

mkdir -p "$BUILD_DIR" "$PREFIX"
echo "-----------------------------"
echo "| TARGET  $TARGET"
echo "| BUILD   $BUILD_DIR"
echo "| PREFIX  $PREFIX"
echo "-----------------------------"

mkdist()
{
    dist_name=$1
    shift

    dist_path=$DIST_DIR/$dist_name
    dist_build=$BUILD_DIR/dist/$dist_name

    mkdir -p $dist_build && cd $dist_build
    $dist_path/configure --prefix="$PREFIX" $@

    make -j$(nproc)
    make -j$(nproc) install
}

mksubmod()
{
    submod_name=$1
    shift

    submod_path=$SUBMODULE_DIR/$submod_name
    submod_build=$BUILD_DIR/submodule/$submod_name

    mkdir -p $submod_build && cd $submod_build
    $submod_path/configure --prefix="$PREFIX" $@

    make -j$(nproc)
    make -j$(nproc) install
}

build_gcc()
{
    which -- $TARGET-as || echo $TARGET-as is not in the PATH

    submod_name=$1
    shift

    submod_path=$SUBMODULE_DIR/$submod_name
    submod_build=$BUILD_DIR/submodule/$submod_name

    mkdir -p $submod_build && cd $submod_build
    $submod_path/configure --prefix="$PREFIX" $@

    make -j$(nproc) all-gcc all-target-libgcc all-target-libstdc++-v3 
    make -j$(nproc) install-gcc install-target-libgcc install-target-libstdc++-v3
}


mkdist autoconf --target=$TARGET
mkdist automake --target=$TARGET

if [[ "$TARGET" == "x86_64-anos" ]]; then

    mkdist gmp
    mkdist mpc --target=$TARGET
    mkdist mpfr --target=$TARGET

    mksubmod binutils \
        --target=$TARGET \
        --with-sysroot \
        --disable-nls \
        --disable-werror

    build_gcc gcc \
        --target=$TARGET \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers \
        --disable-hosted-libstdcxx \
        --with-gmp="/home/michael/devel/anos_opt/cross/x86_64-anos" \
        --with-mpc="/home/michael/devel/anos_opt/cross/x86_64-anos" \
        --with-mpfr="/home/michael/devel/anos_opt/cross/x86_64-anos"
fi

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
