#!/bin/bash

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $HERE/../aux

wget -nc https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
wget -nc https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.bz2
wget -nc https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz
wget -nc https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.bz2

tar -xvzf automake-1.15.1.tar.gz -C automake --strip-components=1
tar -xvzf autoconf-2.69.tar.gz -C autoconf --strip-components=1
tar -xvjf gmp-6.2.1.tar.bz2
tar -xvzf mpc-1.2.1.tar.gz
tar -xvjf mpfr-4.1.0.tar.bz2
