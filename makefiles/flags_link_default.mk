LDFLAGS :=

override LD_SCRIPT := $(KNL_DIR)/linker-${TOOLCHAIN_PREFIX}.ld

override LDFLAGS += \
    -m elf_x86_64 -nostdlib -static \
    -z max-page-size=0x1000 --gc-sections \
    -T $(LD_SCRIPT)
