#!/bin/bash

OG_PATH="$PATH"
HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

export TARGET=x86_64-elf
export PREFIX="$HOME/devel/anos-cross/$TARGET"
export PATH="$PREFIX/bin:$OG_PATH"
$HERE/script/build.sh

export TARGET=x86_64-elf-anos
export PREFIX="$HOME/devel/anos-cross/$TARGET"
export PATH="$PREFIX/bin:$OG_PATH"
$HERE/script/build.sh

export PATH="$OG_PATH"
