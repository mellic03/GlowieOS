#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX_SRC=$PRJ/aux
AUX_BUILD=$PRJ/build-aux

# mkdir -p $AUX_SRC $AUX_BUILD/{bin,include,share}

opt_all=1
opt_limine=0
opt_glm=0
opt_binutils=0
opt_gcc=0

# Loop through all arguments until none are left
while [[ "$1" != "" ]]; do
    case "$1" in
        --clean )
            rm -rf $AUX_BUILD
            shift
            ;;
        --all )
            opt_all=1
            opt_limine=0
            opt_glm=0
            opt_binutils=0
            opt_gcc=0
            shift $#
            ;;
        --limine )
            opt_limine=1
            opt_all=0
            shift
            ;;
        --glm )
            opt_glm=1
            opt_all=0
            shift
            ;;
        --binutils )
            opt_binutils=1
            opt_all=0
            shift
            ;;
        --gcc )
            opt_gcc=1
            opt_all=0
            shift
            ;;
        * )
            # Default case for invalid arguments
            echo "Error: Invalid argument $1"
            exit 0
            ;;
    esac
done

mkdir -p $AUX_BUILD/{bin,include,share}


aux_limine()
{
    LIMINE_SRC="${AUX_SRC}/limine-10.5.0"

    if [[ ! -d "$LIMINE_SRC" ]]; then
        git clone \
            https://github.com/limine-bootloader/limine.git \
            --branch=v10.5.0 \
            --depth=8 \
            "${LIMINE_SRC}"
    fi

    cd $LIMINE_SRC

    if [[ ! -f "configure" ]]; then
        ./bootstrap
    fi

    ./configure \
        TOOLCHAIN_FOR_TARGET=x86_64-linux-gnu- \
        --prefix=$AUX_BUILD --exec-prefix=$AUX_BUILD \
        --enable-bios-cd=yes --enable-bios-pxe=yes --enable-bios=yes \
        --enable-uefi-x86-64=yes --enable-uefi-cd
    make -j4 && make install

    mkdir -p $AUX_BUILD/include/limine
    cp ./limine-protocol/{include/*,LICENSE,*.md} $AUX_BUILD/include/limine/
}

aux_glm()
{
    GLM_SRC="${AUX_SRC}/glm"
    if [[ ! -d "$GLM_SRC" ]]; then
        git clone \
            https://github.com/g-truc/glm.git \
            --branch=use-cxx17 \
            "${GLM_SRC}"
    fi
    cp -R "${GLM_SRC}/glm" $AUX_BUILD/include/
}

aux_binutils()
{
    BINUTILS_SRC="${AUX_SRC}/binutils-2.45.1"
    cd $AUX_SRC
    if [[ ! -f "binutils-2.45.1.tar.gz" ]]; then
        wget https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.gz
    fi
    if [[ ! -d "binutils-2.45.1" ]]; then
        tar -xvzf binutils-2.45.1.tar.gz
    fi

    cd "$BINUTILS_SRC"
}

aux_gcc()
{
    GCC_SRC="${AUX_SRC}/gcc-15.2.0"
    cd $AUX_SRC
    if [[ ! -f "gcc-15.2.0.tar.gz" ]]; then
        wget https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.gz
    fi
    if [[ ! -d "gcc-15.2.0" ]]; then
        tar -xvzf gcc-15.2.0.tar.gz
    fi

    cd "$GCC_SRC"
}


if [[ "$opt_all" == "1" ]]; then
    aux_limine; aux_glm; aux_binutils; aux_gcc
    exit 0
fi
if [[ "$opt_limine" == "1" ]]; then
    aux_limine
fi
if [[ "$opt_glm" == "1" ]]; then
    aux_glm
fi
if [[ "$opt_binutils" == "1" ]]; then
    aux_binutils
fi
if [[ "$opt_gcc" == "1" ]]; then
    aux_gcc
fi

