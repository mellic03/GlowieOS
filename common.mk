# Nuke built-in rules.
.SUFFIXES:

ifndef GLOWIE_BUILD_TYPE
    $(error GLOWIE_BUILD_TYPE must be set (debug|release))
endif

ifndef GLOWIE_BUILD_DIR
    $(error GLOWIE_BUILD_DIR must be set)
endif

ifndef GLOWIE_ARCH
    $(error GLOWIE_ARCH must be set)
endif

CC   = $(TOOLCHAIN_PREFIX)-gcc
CCPP = $(TOOLCHAIN_PREFIX)-g++
AS   = $(TOOLCHAIN_PREFIX)-as
LD   = $(TOOLCHAIN_PREFIX)-ld

ROOT_DIR   := ${GLOWIE_ROOT_DIR}
KNL_DIR    := ${GLOWIE_ROOT_DIR}/kernel
SRC_DIR    := $(KNL_DIR)/src
INC_DIR    := $(KNL_DIR)/include
LD_SCRIPT  := $(KNL_DIR)/linker-$(TOOLCHAIN_PREFIX).ld

BUILD_DIR  := ${GLOWIE_BUILD_DIR}
OBJ_DIR    := $(BUILD_DIR)/obj
BIN_DIR    := $(BUILD_DIR)/bin
ISO_DIR    := $(BUILD_DIR)/iso_root
LIMINE_DIR := $(ROOT_DIR)/thirdparty/limine

INITRD     := $(ISO_DIR)/initrd.tar.gz
GLOWIE_ELF := $(ISO_DIR)/glowie.elf
GLOWIE_ISO := $(BUILD_DIR)/glowie.iso

# User controllable C flags.
CFLAGS := -g -O2 -pipe

# User controllable C preprocessor flags. We set none by default.
CPPFLAGS :=

# User controllable nasm flags.
NASMFLAGS := -g

# User controllable linker flags. We set none by default.
LDFLAGS :=

C_CXX_FLAGS := \
    -Wall -Wextra \
    -ffreestanding -fno-stack-protector -fno-stack-check \
    -fno-lto -fno-PIC -ffunction-sections -fdata-sections \
    -m64 -march=x86-64 -mabi=sysv \
    -mno-80387 -mno-mmx -mno-sse -mno-sse2 -mno-red-zone \
    -mcmodel=kernel

ifeq ($(GLOWIE_BUILD_TYPE), debug)
    C_CXX_FLAGS += -O0 -g
else
    C_CXX_FLAGS += -O2
endif

# Internal C flags that should not be changed by the user.
override CFLAGS += \
    -std=gnu11 \
    $(C_CXX_FLAGS)

# Internal C++ flags that should not be changed by the user.
override CXXFLAGS += \
    -std=c++17 -fno-exceptions -fno-rtti -MMD -MP \
    $(C_CXX_FLAGS)

# Internal C preprocessor flags that should not be changed by the user.
override CPPFLAGS := \
    -I $(KNL_DIR)/include \
    -I $(ROOT_DIR)/thirdparty \
	-D GLOWIE_ARCH=${GLOWIE_ARCH} \
    $(CPPFLAGS) -MMD -MP

# Internal nasm flags that should not be changed by the user.
override NASMFLAGS := \
    -f elf64 \
    $(patsubst -g,-g -F dwarf,$(NASMFLAGS)) \
    -Wall

# Internal linker flags that should not be changed by the user.
override LDFLAGS += \
    -m elf_x86_64 -nostdlib -static \
    -z max-page-size=0x1000 --gc-sections \
    -T $(LD_SCRIPT)
