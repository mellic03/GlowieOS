#!/bin/bash

export SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export REPO_ROOT=$(cd ${SCRIPT_DIR}/../ && pwd)
export BUILD_ROOT=${REPO_ROOT}/build
export DIST_DIR=${REPO_ROOT}/dist
export PATCH_DIR=${REPO_ROOT}/patches

mkdir -p "$BUILD_ROOT/dist"
