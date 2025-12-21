#!/bin/bash

set -e

if [ -z "$TARGET" ]; then
    echo "Invalid usage: TARGET not set"
    exit 1
elif [ -z "$PREFIX" ]; then
    echo "Invalid usage: PREFIX not set"
    exit 1
fi

makePretty()
{
    dir=$1;
    dir=$(cd $dir && pwd);
    echo $dir;
}

touchAndMakePretty()
{
    dir=$1; mkdir -p $dir;
    dir=$(cd $dir && pwd);
    echo $dir;
}

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh
REPO_PARENT=$(makePretty "$REPO_ROOT/../")
BUILD_DIR=$(touchAndMakePretty "$REPO_PARENT/anos-build/$TARGET")
echo "REPO_PARENT=$REPO_PARENT"
echo "BUILD_DIR=$BUILD_DIR"

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

mkdir -p "$BUILD_DIR"
echo "-----------------------------"
echo "| TARGET  $TARGET"
echo "| BUILD   $BUILD_DIR"
echo "| PREFIX  $PREFIX"
echo "-----------------------------"

getRelative()
{
    base=$1; stem=$2;
    echo $(realpath --relative-to="$base" "$stem");
}

getBuildDest()
{
    dir=$(getRelative "$REPO_PARENT" "$1")
    echo $(touchAndMakePretty "$BUILD_DIR/$dir")
}

mkdist()
{
    name=$1; shift;

    source=$DIST_DIR/$name; cd $(getBuildDest "$source")
    $source/configure --prefix="$PREFIX" $@

    make -j$(nproc)
    make -j$(nproc) install
}

mksubmod()
{
    name=$1; shift;

    source=$SUBMOD_DIR/$name; cd $(getBuildDest "$source");
    $source/configure --prefix="$PREFIX" $@

    echo "source=$source"
    echo "dest=$dest"
    exit 0

    make -j$(nproc)
    make install
}

build_binutils_gcc()
{
    mksubmod binutils --target=$TARGET --with-sysroot --disable-nls --disable-werror

    source=$SUBMOD_DIR/gcc; cd $(getBuildDest "$source");
    $source/configure \
        --prefix="$PREFIX" \
        --target=$TARGET \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers \
        --disable-hosted-libstdcxx \
        --with-gmp="$PREFIX" \
        --with-mpc="$PREFIX" \
        --with-mpfr="$PREFIX"

    make -j$(nproc) all-gcc all-target-libgcc all-target-libstdc++-v3 
    make -j$(nproc) install-gcc install-target-libgcc install-target-libstdc++-v3
}


build_limine()
{
    cd $SUBMOD_DIR/limine

    if [[ ! -f "configure" ]]; then
        ./bootstrap
    fi

    ./configure \
        TOOLCHAIN_FOR_TARGET=x86_64-anos- \
        --prefix=$HOME/devel/anos_opt/x86_64-elf \
        --enable-bios-cd=yes --enable-bios-pxe=yes --enable-bios=yes \
        --enable-uefi-x86-64=yes --enable-uefi-cd

    make -j$(nproc)
    make install

    # mkdir -p $AUX_BUILD/include/limine
    # cp ./limine-protocol/{include/*,LICENSE,*.md} $AUX_BUILD/include/limine/
}



# mkdist autoconf --target=$TARGET
# mkdist automake --target=$TARGET

if [[ "$TARGET" == "x86_64-anos" ]]; then

    # mkdist gmp
    # mkdist mpc --target=$TARGET
    # mkdist mpfr --target=$TARGET
    build_binutils_gcc
    # build_limine

    # mksubmod limine TOOLCHAIN_FOR_TARGET=$TARGET- \
    #     --enable-bios-cd=yes --enable-bios-pxe=yes --enable-bios=yes \
    #     --enable-uefi-x86-64=yes --enable-uefi-cd
fi

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
