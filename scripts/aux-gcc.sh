#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX=$PRJ/aux


# Cross compiler
# ------------------------------------------------------------------------------
cd "${PRJ}/thirdparty"
mkdir -p cross && cd cross

wget https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.gz
wget https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.gz

tar -xvzf binutils-2.45.1.tar.gz
tar -xvzf gcc-15.2.0.tar.gz
# ------------------------------------------------------------------------------
