#!/bin/bash

OG_PATH="$PATH"

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ANOS_OPT=$HOME/devel/anos_opt

# export TARGET=x86_64-elf
# export PREFIX="$ANOS_OPT/cross/$TARGET"
# export PATH="$PREFIX/bin:$OG_PATH"
# $HERE/script/build.sh

export TARGET=x86_64-anos
export PREFIX="$ANOS_OPT/cross/$TARGET"
export PATH="$PREFIX/bin:$OG_PATH"
$HERE/script/build.sh

export PATH="$OG_PATH"
