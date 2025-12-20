#!/bin/bash

set -e

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_DIR=$(cd $THIS_DIR/../ && pwd)
AUX_DIR=$ROOT_DIR/aux
rm -rf $AUX_DIR && mkdir -p $AUX_DIR/{bin,include,share}


# Limine
# ------------------------------------------------------------------------------
cd "${ROOT_DIR}/thirdparty"

if [[ ! -d "limine-10.5.0" ]]; then
    git clone https://github.com/limine-bootloader/limine.git \
        --branch=v10.5.0 --depth=8 \
        ./limine-10.5.0
fi

cd limine-10.5.0
./bootstrap
./configure \
    TOOLCHAIN_FOR_TARGET=x86_64-linux-gnu- \
    --prefix=$AUX_DIR --exec-prefix=$AUX_DIR \
    --enable-bios-cd=yes --enable-bios-pxe=yes --enable-bios=yes \
    --enable-uefi-x86-64=yes --enable-uefi-cd

make -j4 && make install
mkdir -p $AUX_DIR/include/limine
cp ./limine-protocol/{include/*,LICENSE,*.md} $AUX_DIR/include/limine/
# ------------------------------------------------------------------------------


# GLM
# ------------------------------------------------------------------------------
cd "${ROOT_DIR}/thirdparty"

if [[ ! -d "glm" ]]; then
    git clone https://github.com/g-truc/glm.git --branch=use-cxx17
fi

cp -R ./glm/glm $AUX_DIR/include/
# ------------------------------------------------------------------------------
