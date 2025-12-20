
ifndef GLOWIE_BUILD_TYPE
    $(error GLOWIE_BUILD_TYPE must be set (debug|release))
endif
ifndef GLOWIE_BUILD_DIR
    $(error GLOWIE_BUILD_DIR must be set)
endif
ifndef GLOWIE_ARCH
    $(error GLOWIE_ARCH must be set)
endif

TOOLCHAIN_PREFIX := x86_64-linux-gnu
ROOT_DIR  := ${GLOWIE_ROOT_DIR}
AUX_DIR   := $(ROOT_DIR)/aux
KNL_DIR   := $(ROOT_DIR)/kernel

BUILD_DIR := ${GLOWIE_BUILD_DIR}
OBJ_DIR   := $(BUILD_DIR)/obj
ISO_DIR   := $(BUILD_DIR)/iso_root

CC   = $(TOOLCHAIN_PREFIX)-gcc
CCPP = $(TOOLCHAIN_PREFIX)-g++
AS   = $(TOOLCHAIN_PREFIX)-as
LD   = $(TOOLCHAIN_PREFIX)-ld

