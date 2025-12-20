CFLAGS := -g -O2 -pipe
CPPFLAGS :=
NASMFLAGS := -g

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

override CFLAGS += \
    -std=c99 \
    $(C_CXX_FLAGS)

override CXXFLAGS += \
    -std=c++17 \
    -fno-exceptions -fno-rtti \
    -MMD -MP \
    $(C_CXX_FLAGS)

override CPPFLAGS := \
    -I $(AUX_DIR)/include \
	-D __kernel_arch__=${__kernel_arch__} \
    $(CPPFLAGS) -MMD -MP

override NASMFLAGS := \
    -f elf64 \
    $(patsubst -g,-g -F dwarf,$(NASMFLAGS)) \
    -Wall
