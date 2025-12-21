#!/bin/bash

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
PRJ=$(cd $HERE/../ && pwd)
AUX=$HERE/../aux

cd $PRJ/aux

rm -rf old && mkdir -p old
cp -R {gmp,mpc,mpfr}-*/ old

names=("gmp-6.2.1" "mpc-1.2.1" "mpfr-4.1.0")
for name in "${names[@]}"; do
    echo "diff -ruN old/$name gcc/$name > $name.patch"
    diff -ruN old/$name gcc/$name > $name.patch
done

rm $PRJ/patches/*
mv *.patch $PRJ/patches/
rm -rf old

# diff -ruN cgg/gmp-6.2.1 gcc/gmp-6.2.1 > gmp-6.2.1.patch
# diff -ruN cgg/mpc-1.2.1 gcc/mpc-1.2.1 > mpc-1.2.1.patch
# diff -ruN cgg/mpfr-4.1.0 gcc/mpfr-4.1.0 > mpfr-4.1.0.patch
# mv ./*.patch $PRJ/patches/

# rm -rf cgg
