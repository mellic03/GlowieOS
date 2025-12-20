THIS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

SOURCES := $(shell find -L $(THIS_DIR)/src -type f 2>/dev/null | LC_ALL=C sort)
CFILES := $(filter %.c,$(SOURCES))
CXXFILES := $(filter %.cpp,$(SOURCES))
ASFILES := $(filter %.S,$(SOURCES))
NASMFILES := $(filter %.asm,$(SOURCES))
HEADER_DEPS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.d) $(CXXFILES:.cpp=.cpp.d) $(ASFILES:.S=.S.d))
OBJECTS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.o) $(CXXFILES:.cpp=.cpp.o) $(ASFILES:.S=.S.o) $(NASMFILES:.asm=.asm.o))

KERNEL_ELF := $(ISO_DIR)/glowie.elf

kernel.elf: $(KERNEL_ELF)
-include $(HEADER_DEPS)

include ${GLOWIE_ROOT_DIR}/makefiles/flags_compile_default.mk
include ${GLOWIE_ROOT_DIR}/makefiles/flags_link_default.mk
override CPPFLAGS += -I $(THIS_DIR)/include

$(KERNEL_ELF): $(OBJECTS)
	mkdir -p "$(dir $@)"
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@

