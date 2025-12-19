
override SRCFILES := $(shell find -L $(ROO )/src -type f 2>/dev/null | LC_ALL=C sort)
override CFILES := $(filter %.c,$(SRCFILES))
override CXXFILES := $(filter %.cpp,$(SRCFILES))
override ASFILES := $(filter %.S,$(SRCFILES))
override NASMFILES := $(filter %.asm,$(SRCFILES))
override OBJECTS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.o) $(CXXFILES:.cpp=.cpp.o) $(ASFILES:.S=.S.o) $(NASMFILES:.asm=.asm.o))
override HEADER_DEPS := $(addprefix $(OBJ_DIR)/,$(CFILES:.c=.c.d) $(CXXFILES:.cpp=.cpp.d) $(ASFILES:.S=.S.d))

thirdparty: thirdparty_limine

thirdparty_limine:
	make -C limine
