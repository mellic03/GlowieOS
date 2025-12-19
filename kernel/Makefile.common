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

TOOLCHAIN_PREFIX := x86_64-linux-gnu
CC   = $(TOOLCHAIN_PREFIX)-gcc
CCPP = $(TOOLCHAIN_PREFIX)-g++
AS   = $(TOOLCHAIN_PREFIX)-as
LD   = $(TOOLCHAIN_PREFIX)-ld

override ROOT_DIR   := ${GLOWIE_ROOT_DIR}
override KNL_DIR    := ${GLOWIE_ROOT_DIR}/kernel
override SRC_DIR    := $(KNL_DIR)/src
override INC_DIR    := $(KNL_DIR)/include
override LD_SCRIPT  := $(KNL_DIR)/linker-$(TOOLCHAIN_PREFIX).ld

override BUILD_DIR  := ${GLOWIE_BUILD_DIR}
override OBJ_DIR    := $(BUILD_DIR)/obj
override BIN_DIR    := $(BUILD_DIR)/bin
override ISO_DIR    := $(BUILD_DIR)/iso_root
override LIMINE_DIR := $(ROOT_DIR)/thirdparty/limine

override INITRD     := $(ISO_DIR)/initrd.tar.gz
override GLOWIE_ELF := $(ISO_DIR)/glowie.elf
override GLOWIE_ISO := $(BUILD_DIR)/glowie.iso

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


# Use "find" to glob all *.c, *.cpp, *.S, and *.asm files in the tree and obtain the
# object and header dependency file names.
override SRCFILES := $(shell find -L $(KNL_DIR)/src -type f 2>/dev/null | LC_ALL=C sort)
override CFILES := $(filter %.c,$(SRCFILES))
override CXXFILES := $(filter %.cpp,$(SRCFILES))
override ASFILES := $(filter %.S,$(SRCFILES))
override NASMFILES := $(filter %.asm,$(SRCFILES))
override OBJECTS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.o) $(CXXFILES:.cpp=.cpp.o) $(ASFILES:.S=.S.o) $(NASMFILES:.asm=.asm.o))
override HEADER_DEPS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.d) $(CXXFILES:.cpp=.cpp.d) $(ASFILES:.S=.S.d))

# Default target. This must come first, before header dependencies.
.PHONY: all
all: $(GLOWIE_ISO)

# Include header dependencies.
-include $(HEADER_DEPS)

$(GLOWIE_ISO): $(INITRD) $(GLOWIE_ELF)
	@echo "Copying limine binaries..."
	mkdir -p $(ISO_DIR)/boot $(ISO_DIR)/EFI/BOOT
	cp  $(KNL_DIR)/limine.conf \
		$(LIMINE_DIR)/limine-bios.sys \
		$(LIMINE_DIR)/limine-bios-cd.bin \
		$(LIMINE_DIR)/limine-uefi-cd.bin \
		$(ISO_DIR)/boot/
	cp  $(LIMINE_DIR)/BOOTX64.EFI \
		$(LIMINE_DIR)/BOOTIA32.EFI \
		$(ISO_DIR)/EFI/BOOT/
	@echo "Copied limine binaries"
	@echo "Generating ISO image..."
	xorriso \
		-as mkisofs -R -r -J \
		-b boot/limine-bios-cd.bin -no-emul-boot \
		-boot-load-size 4 -boot-info-table \
		-hfsplus -apm-block-size 2048 \
		--efi-boot boot/limine-uefi-cd.bin -efi-boot-part \
		--efi-boot-image --protective-msdos-label \
		$(ISO_DIR) -o $(GLOWIE_ISO)
	$(LIMINE_DIR)/limine bios-install $(GLOWIE_ISO)
	@echo "Generated ISO image"

$(INITRD):
	mkdir -p $(ISO_DIR)
	@echo "Creating initrd..."
	tar -czf $(ISO_DIR)/initrd.tar.gz -C $(ROOT_DIR)/kernel/sysroot .
	@echo "Created initrd"

$(GLOWIE_ELF): $(LD_SCRIPT) $(OBJECTS)
	mkdir -p "$(dir $@)"
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

# Compilation rules for *.c files.
$(OBJ_DIR)/%.c.o: %.c
	mkdir -p "$(dir $@)"
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

# Compilation rules for *.cpp files.
$(OBJ_DIR)/%.cpp.o: %.cpp
	mkdir -p "$(dir $@)"
	$(CCPP) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

# Compilation rules for *.S files.
$(OBJ_DIR)/%.S.o: %.S
	mkdir -p "$(dir $@)"
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

# Compilation rules for *.asm (nasm) files.
$(OBJ_DIR)/%.asm.o: %.asm
	mkdir -p "$(dir $@)"
	nasm $(NASMFLAGS) $< -o $@
