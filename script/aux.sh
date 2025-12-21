#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX_DIR=$PRJ/aux
# AUX_BUILD=$PRJ/build-aux

# mkdir -p $AUX_SRC $AUX_BUILD/{bin,include,share}

opt_all=1
opt_limine=0
opt_glm=0

# Loop through all arguments until none are left
while [[ "$1" != "" ]]; do
    case "$1" in
        --clean )
            rm -rf $PRJ/build
            shift
            ;;
        --all )
            opt_all=1
            opt_limine=0
            opt_glm=0
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
        * )
            # Default case for invalid arguments
            echo "Error: Invalid argument $1"
            exit 0
            ;;
    esac
done

# mkdir -p $AUX_BUILD/{bin,include,share}


aux_limine()
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


if [[ "$opt_all" == "1" ]]; then
    aux_limine; aux_glm;
    exit 0
fi
if [[ "$opt_limine" == "1" ]]; then
    aux_limine
fi
if [[ "$opt_glm" == "1" ]]; then
    aux_glm
fi

