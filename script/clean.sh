#!/bin/bash
set -euo pipefail

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
source ${THIS_DIR}/env.sh

rm -rf $REPO_ROOT/build/*
$THIS_DIR/dist_fetch.sh --clean
