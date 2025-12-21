# #!/bin/bash

# THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
# source ${THIS_DIR}/env.sh

# opt_unlink=0

# while [[ "$1" != "" ]]; do
#     case "$1" in
#         --unlink )
#             opt_unlink=1
#             shift
#             ;;
#         * )
#             echo "Error: Invalid argument $1"
#             exit 1
#             ;;
#     esac
# done


# cd "${REPO_ROOT}/../gcc"

# if [[ "$opt_unlink" == "1" ]]; then
#     rm gmp mpc mpfr gettext isl
#     echo "dist_symlink.sh: Removed symlinks"
# else
#     ln -s ${BUILD_ROOT}/dist/gmp-6.2.1    gmp
#     ln -s ${BUILD_ROOT}/dist/mpc-1.2.1    mpc
#     ln -s ${BUILD_ROOT}/dist/mpfr-4.1.0   mpfr
#     ln -s ${BUILD_ROOT}/dist/gettext-0.22 gettext
#     ln -s ${BUILD_ROOT}/dist/isl-0.24     isl
#     echo "dist_symlink.sh: Placed symlinks"
# fi
