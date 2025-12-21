#!/bin/bash

OG_PATH="$PATH"

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${HERE}/env.sh

export PATH="/home/michael/devel/anos_opt/cross/x86_64-elf/bin:$PATH"

cd $SUBMODULE_DIR/binutils/ld
/home/michael/devel/anos_opt/cross/x86_64-elf/bin/automake

cd $SUBMODULE_DIR/gcc/libstdc++-v3
/home/michael/devel/anos_opt/cross/x86_64-elf/bin/autoconf

export PATH="$OG_PATH"
