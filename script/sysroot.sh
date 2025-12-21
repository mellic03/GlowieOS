#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ_DIR=$(cd $THIS_DIR/../ && pwd)
SYSROOT_DIR=$PRJ_DIR/sysroot


cd $PRJ_DIR
rm -rf ./sysroot && mkdir ./sysroot/usr/{bin,include,lib,share}
cp -r ./kernel/include* ./sysroot/usr/include
cp -r ./lib/lib{c,c++}/include* ./sysroot/usr/include

