#!/bin/bash

OG_PATH="$PATH"

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${HERE}/env.sh

export PATH="/home/michael/devel/anos_opt/cross/x86_64-elf/bin:$PATH"

cd $SUBMOD_DIR/binutils/ld
/home/michael/devel/anos_opt/cross/x86_64-elf/bin/automake

cd $SUBMOD_DIR/gcc/libstdc++-v3
/home/michael/devel/anos_opt/cross/x86_64-elf/bin/autoconf

export PATH="$OG_PATH"
