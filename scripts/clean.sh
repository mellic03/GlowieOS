#!/bin/bash
set -euo pipefail

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

rm -rf $BUILD_ROOT/*

cd $DIST_DIR
rm -rf *.tar.* */ 
rm -rf */ 
