#!/bin/bash

HERE=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source $HERE/script/env.sh

echo "HERE=$HERE"
echo "SUBMOD_DIR=$SUBMOD_DIR"
echo "DIST_DIR=$DIST_DIR"
echo "PATCH_DIR=$PATCH_DIR"

ls -l $DIST_DIR
