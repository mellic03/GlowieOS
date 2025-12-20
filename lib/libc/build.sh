#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export GLOWIE_ROOT_DIR=$(cd $THIS_DIR/../ && pwd)
export GLOWIE_ARCH="${opt_arch}"

rm -rf build && mkdir build

mktouch()
{
    mkdir -p "$(dirname "$1")"
    touch "$1"
}


find src -type f -print0 | while IFS= read -r -d '' file; do
    mkdir -p "build/obj/$(dirname "$file")"
    gcc -c $file -o "build/obj/${file}.o"
done

file_list=""
find build/obj -type f -print0 | while IFS= read -r -d '' file; do
    file_list="${file_list} ${file}"
done

mkdir -p build/lib
ar rcs build/lib/libc.a $file_list


