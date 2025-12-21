#!/bin/bash
set -e

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
if [[ ! "$opt_target"=="" ]]; then
    TARGET=$opt_target
else
    TARGET="x86_64-elf"
fi

PREFIX=""
if [[ ! "$opt_prefix"=="" ]]; then
    PREFIX=$opt_prefix
else
    PREFIX="${REPO_DIR}/build/${TARGET}"
fi
mkdir -p "${PREFIX}"

export TARGET
export PREFIX
export PATH="$PREFIX/bin:$PATH"


mkpkg()
{
    pkgdir=""

    if [[ "$1" == "--pkg-name" ]]; then
        pkgdir=$BUILD_DIR/dist/$2
    elif [[ "$1" == "--pkg-path" ]]; then
        pkgdir=$2
    else
        echo "build.sh/mkpkg: Invalid usage"
        exit 0
    fi
    shift
    shift

    echo -e "\n------------------------ CONFIGURE $pkgdir"
    echo -e "TARGET=${TARGET}\nPREFIX=${PREFIX}\n"

    cd $pkgdir
    ./configure --prefix="$PREFIX" $@

    echo -e "\n------------------------ BUILD $pkgdir"
    make -j$(nproc)

    echo -e "\n------------------------ INSTALL $pkgdir"
    make install

    echo -e "\n------------------------ FINISHED $pkgdir"
    echo ""
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

mkpkg --pkg-name autoconf-2.69 --target=$TARGET
mkpkg --pkg-name automake-1.15.1 --target=$TARGET
mkpkg --pkg-name gmp-6.2.1
mkpkg --pkg-name mpc-1.2.1 --target=$TARGET
mkpkg --pkg-name mpfr-4.1.0 --target=$TARGET

mkpkg --pkg-path $REPO_DIR/../binutils-gdb --target=$TARGET \
      --with-sysroot --disable-nls --disable-werror
# mkpkg gcc --target=$TARGET --disable-nls --enable-languages=c,c++ --without-headers --disable-hosted-libstdcxx

# find $TOOLCHAIN_PREFIX/lib -name 'libgcc.a'
