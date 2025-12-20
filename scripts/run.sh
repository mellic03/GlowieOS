#!/bin/bash

build_type=""

# Loop through all arguments until none are left
while [[ "$1" != "" ]]; do
    case "$1" in
        --debug )
            build_type="debug"
            shift
            ;;
        --release )
            build_type="release"
            shift
            ;;
        * )
            # Default case for invalid arguments
            echo "Error: Invalid argument $1"
            exit 1
            ;;
    esac
done

if [[ "$build_type" == "" ]]; then
    echo "ERROR: Must specify --debug or --release"
    exit 0
fi


THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
ROOT_DIR=$(cd $THIS_DIR/../ && pwd)
BUILD_DIR="${ROOT_DIR}/build/${build_type}"

# https://wiki.osdev.org/QEMU

# qemu-img create -f raw ./output/disk1.img 4G

# qemu-system-x86_64 \
#     -m 4G \
#     -smp 4 \
#     -cdrom ./output/CringeOS.iso \
#     -serial stdio

qemu-system-x86_64 \
    -m 4G -smp 1 \
    -cdrom "${BUILD_DIR}/glowie.iso" \
    -serial stdio
    # -device ati-vga,model=rage128p \
    # -display gtk,gl=on
    # -device vmware-svga \
    # -device virtio-gpu-gl-pci \
    # -device virtio-vga-gl \
    # -device virtio-gpu-gl-pci \
    # -drive format=qcow2,file=/home/seagate-8tb/disk0.img \