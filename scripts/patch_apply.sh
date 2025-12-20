#!/bin/bash

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $HERE/../aux

patch -p1 --dry-run < gmp-6.2.1.patch
patch -p1 --dry-run < mpc-1.2.1.patch
patch -p1 --dry-run < mpfr-4.1.0.patch
