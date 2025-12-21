#!/bin/bash
set -e

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

PREFIX=""
TARGET="x86_64-elf"

while [[ "$1" != "" ]]; do
    case "$1" in
        --prefix )
            PREFIX=$2
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



PRJ_DIR=$(cd $HERE/../ && pwd)
PKG_DIR="${PRJ_DIR}/sources"

TARGET=$opt_target
PREFIX="${PRJ_DIR}/build/${TARGET}-tools"
PATH="$PREFIX/bin:$PATH"

BUILD_DIR="${PRJ_DIR}/build"
# BUILD_DIR="${BUILD_ROOT}/${TARGET}"

export TARGET
export PREFIX
export PATH


mkpkg()
{
    pkgname=$1
    shift
    cfgargs="$@"
    shift "$#"

    echo -e "\n---------------- CONFIGURE $TARGET/$pkgname ----------------"
    cd $BUILD_DIR/$pkgname
    ./configure --prefix="$PREFIX" $cfgargs

    echo -e "\n---------------- BUILD $TARGET/$pkgname ---------------------"
    make -j$(nproc)

    echo -e "\n---------------- INSTALL $TARGET/$pkgname -------------------"
    make install

    echo -e "\n---------------- FINISHED $TARGET/$pkgname ------------------\n"
}

# build_binutils()
# {
#     cd $AUX
#     if [[ ! -d "binutils-gdb" ]]; then
#         git clone https://github.com/anosig/binutils-gdb.git \
#             --branch feature --depth=1
#     fi
#     mkdir -p $BUILD/binutils && cd $BUILD/binutils

#     ${AUX}/binutils-gdb/configure \
#         --target=$TARGET \
#         --prefix="$PREFIX" \
#         --with-sysroot --disable-nls --disable-werror

#     make -j$(nproc)
#     make install
# }

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

mkpkg autoconf-2.69 --target=$TARGET
mkpkg automake-1.15.1 --target=$TARGET
mkpkg gmp-6.2.1
mkpkg mpc-1.2.1 --target=$TARGET
mkpkg mpfr-4.1.0 --target=$TARGET
# mkpkg binutils-gdb --target=$TARGET --with-sysroot --disable-nls --disable-werror
# mkpkg gcc --target=$TARGET --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
