#!/bin/bash
set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX="${PRJ}/aux" && mkdir -p $AUX
BUILD="${PRJ}/build/aux/${TARGET}" && mkdir -p $BUILD


build_package()
{
    opt_target="x86_64-elf"
    while [[ "$1" != "" ]]; do
        case "$1" in
            --target )
                opt_target=$2
                shift
                shift
                ;;
            * )
                echo "Error: Invalid argument $1"
                exit 1
                ;;
        esac
    done

    PKG_NAME=$1

    echo -e "\n---------------- CONFIGURE $TARGET/$PKG_NAME ----------------"
    mkdir -p $BUILD/$PKG_NAME && cd $BUILD/$PKG_NAME
    ${AUX}/$PKG_NAME/configure --target=$TARGET --prefix="$PREFIX"

    echo -e "\n---------------- BUILD $TARGET/$PKG_NAME ---------------------"
    make -j$(nproc)

    echo -e "\n---------------- INSTALL $TARGET/$PKG_NAME -------------------"
    make install
}

build_package autoconf-2.69
build_package automake-1.15.1
build_package gmp-6.2.1
build_package mpc-1.2.1
build_package mpfr-4.1.0
