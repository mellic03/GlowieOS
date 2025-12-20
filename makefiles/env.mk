
ifndef GLOWIE_BUILD_TYPE
    $(error GLOWIE_BUILD_TYPE must be set (debug|release))
endif
ifndef TOOLCHAIN_PREFIX
    $(error TOOLCHAIN_PREFIX must be set (debug|release))
endif
ifndef __kernel_arch__
    $(error __kernel_arch__ must be set)
endif

ROOT_DIR  := ${GLOWIE_ROOT_DIR}
BUILD_DIR := $(ROOT_DIR)/build/${GLOWIE_BUILD_TYPE}
AUX_DIR   := $(ROOT_DIR)/build/aux
LIB_DIR   := $(ROOT_DIR)/lib
KNL_DIR   := $(ROOT_DIR)/kernel
OBJ_DIR   := $(BUILD_DIR)/obj
ISO_DIR   := $(BUILD_DIR)/iso_root

CC   = ${TOOLCHAIN_PREFIX}-gcc
CCPP = ${TOOLCHAIN_PREFIX}-g++
AS   = ${TOOLCHAIN_PREFIX}-as
LD   = ${TOOLCHAIN_PREFIX}-ld

