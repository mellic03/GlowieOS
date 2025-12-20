#!/bin/bash

set -e

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX_SRC=$PRJ/aux
AUX_BUILD=$PRJ/build-aux

aux_binutils()
{
    cd $AUX_SRC
    if [[ ! -f "binutils-gdb" ]]; then
        git clone https://github.com/mellic03/binutils-gdb.git \
            --branch osdev/binutils-feature \
            --depth=1
    fi
}

# aux_gdb()
# {
#     GDB_SRC="${AUX_SRC}/gdb-17.1"
#     cd $AUX_SRC
#     if [[ ! -f "gdb-17.1.tar.gz" ]]; then
#         wget https://ftp.gnu.org/gnu/gdb/gdb-17.1.tar.gz
#     fi
#     if [[ ! -d "gdb-17.1" ]]; then
#         tar -xvzf gdb-17.1.tar.gz
#     fi
# }

aux_gcc()
{
    GCC_SRC="${AUX_SRC}/gcc"
    # cd $AUX_SRC
    # if [[ ! -f "gcc-15.2.0.tar.gz" ]]; then
    #     wget https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.gz
    # fi
    # if [[ ! -d "gcc-15.2.0" ]]; then
    #     tar -xvzf gcc-15.2.0.tar.gz
    # fi

    # echo -e \
    #     "MULTILIB_OPTIONS += mno-red-zone\nMULTILIB_DIRNAMES += no-red-zone" \
    #     > ${GCC_SRC}/gcc/config/i386/t-x86_64-elf

    # # By default this new configuration will not be used by GCC unless it's
    # # explicitly told to. Open gcc/config.gcc in your favorite editor and
    # # search for case block like this:
    # # x86_64-*-elf*)
    # #     tm_file="${tm_file} i386/unix.h i386/att.h elfos.h newlib-stdint.h i386/i386elf.h i386/x86-64.h"
    # #     ;;

    # # This is the target configuration used when creating a GCC Cross-Compiler
    # # for x86_64-elf. Modify it to include the new multilib configuration:
    # # x86_64-*-elf*)
    # #     tmake_file="${tmake_file} i386/t-x86_64-elf" # include the new multilib configuration
    # #     tm_file="${tm_file} i386/unix.h i386/att.h elfos.h newlib-stdint.h i386/i386elf.h i386/x86-64.h"
    # #     ;;

    # cd "$GCC_SRC"
    # ./contrib/download_prerequisites
}


opt_binutils=0
opt_gdb=0
opt_gcc=0

while [[ "$1" != "" ]]; do
    case "$1" in
        --clean )
            rm -rf $AUX_BUILD
            shift
            ;;
        --all )
            opt_binutils=1
            opt_gdb=1
            opt_gcc=1
            shift $#
            ;;
        --binutils )
            opt_binutils=1
            shift
            ;;
        --gdb )
            opt_gdb=1
            shift
            ;;
        --gcc )
            opt_gcc=1
            shift
            ;;
        * )
            # Default case for invalid arguments
            echo "Error: Invalid argument $1"
            exit 0
            ;;
    esac
done

mkdir -p $AUX_BUILD/{bin,include,share}

if [[ "$opt_binutils" == "1" ]]; then
    aux_binutils
fi

if [[ "$opt_gdb" == "1" ]]; then
    aux_gdb
fi

if [[ "$opt_gcc" == "1" ]]; then
    aux_gcc
fi
