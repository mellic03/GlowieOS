# set(KFLAGS_SSE_ON
#     -mfpmath=sse -msse -msse2 -msse3 -mno-sse4 -mno-avx -mno-avx2
#     -mno-80387 -mno-mmx -mno-3dnow
# )

# set(KFLAGS_SSE_OFF
#     -mgeneral-regs-only
# )

# set(KERNEL_LDSCRIPT_STATIC "${CMAKE_SOURCE_DIR}/kernel/linker.ld")
# set(KERNEL_LDSCRIPT_SHARED "${CMAKE_SOURCE_DIR}/kernel/linker-shared.ld")

set(FLAGS_C_CXX_COMMON
    -Wall
    -Wextra
    -ffreestanding
    -fno-stack-protector
    -fno-stack-check
    -fno-lto
    -fno-PIC
    -ffunction-sections
    -fdata-sections
    -m64
    -march=x86-64
    -mabi=sysv
    -mno-80387 -mno-mmx
    -mno-sse -mno-sse2
    -mno-red-zone
    -mcmodel=kernel
)

set(FLAGS_C
    -std=c99
    ${FLAGS_C_CXX_COMMON}
)

set(FLAGS_CXX
    -std=c++17
    -fno-exceptions
    -fno-rtti
    -MMD
    -MP
    ${FLAGS_C_CXX_COMMON}
)

set(FLAGS_CPP
    -I $(AUX_DIR)/include
	-D__kernel_arch__=${__kernel_arch__}
    -MMD
    -MP
    ${FLAGS_C_CXX_COMMON}
)

set(FLAGS_NASM
    -f elf64
    $(patsubst -g,-g -F dwarf,$(NASMFLAGS))
    -Wall
)

set(FLAGS_COMPILE_DEFAULT
    ${KFLAGS_COMPILE_COMMON}
    ${KFLAGS_SSE_OFF}
    -D__is_kernel -mcmodel=kernel -fno-PIC -fno-PIE
    ${KFLAGS_LINK_KERNEL}
)

set(FLAGS_LINK_DEFAULT
    -m elf_x86_64
    -nostdlib
    -static
    -z max-page-size=0x1000
    --gc-sections
    -T $(LD_SCRIPT)
)
