#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
export GLOWIE_ROOT_DIR=$(cd $THIS_DIR/../ && pwd)

opt_clean=""
opt_arch="x86_64"
opt_dbg=""
opt_rel=""

# Loop through all arguments until none are left
while [[ "$1" != "" ]]; do
    case "$1" in
        --clean )
            opt_clean="--clean"
            shift
            ;;
        --all )
            opt_dbg=1
            opt_rel=1
            shift
            ;;
        --arch )
            opt_arch=$2
            shift
            shift
            ;;
        --debug )
            opt_dbg=1
            shift
            ;;
        --release )
            opt_rel=1
            shift
            ;;
        * )
            # Default case for invalid arguments
            echo "Error: Invalid argument $1"
            exit 1
            ;;
    esac
done



glowie_build()
{
    build_clean=0
    build_type="release"

    # Loop through all arguments until none are left
    while [[ "$1" != "" ]]; do
        case "$1" in
            --clean )
                build_clean=1
                shift
                ;;
            --type )
                build_type=$2
                shift
                shift
                ;;
            * )
                # Default case for invalid arguments
                echo "Error: Invalid argument $1"
                exit 1
                ;;
        esac
    done

    export GLOWIE_BUILD_TYPE="${build_type}"
    export GLOWIE_BUILD_DIR="${GLOWIE_ROOT_DIR}/build-${GLOWIE_BUILD_TYPE}"
    export GLOWIE_ARCH="${opt_arch}"

    echo ""
    echo "------------------------ Building $build_type ------------------------"

    if [[ "$build_clean" == "1" ]]; then
        rm -rf $GLOWIE_BUILD_DIR
    fi

    make -C $GLOWIE_ROOT_DIR
}

if [[ ! -d "$GLOWIE_ROOT_DIR/aux" ]]; then
    $THIS_DIR/aux.sh
fi

if [[ "$opt_dbg" == "1" ]]; then
    glowie_build --type debug $opt_clean
fi

if [[ "$opt_rel" == "1" ]]; then
    glowie_build --type release $opt_clean
fi

