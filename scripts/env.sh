#!/bin/bash

export SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export REPO_DIR=$(cd ${SCRIPT_DIR}/../ && pwd)
export BUILD_DIR=${REPO_DIR}/build
export DIST_DIR=${REPO_DIR}/dist
export PATCH_DIR=${REPO_DIR}/patches

mkdir -p "$BUILD_DIR/dist"
