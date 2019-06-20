# This is a Makefile snippet that is shared among the examples.
# Before including it, be sure to set HOST_SRCS and DEVICE_SRCS.
# You may also want to set HOST_TARGET and DEVICE_TARGET to the filenames for
# the output executables.
HOST_TARGET ?= host
DEVICE_TARGET ?= device.riscv


# Main targets.

.PHONY: all clean

all: $(DEVICE_TARGET) $(HOST_TARGET)

clean:
	rm -rf $(HOST_OBJS) $(DEVICE_OBJS_ALL) $(HOST_TARGET) $(DEVICE_TARGET) \
		$(CRT_LIB)


# Build host code with the "normal" compiler.

HOST_OBJS := $(HOST_SRCS:.c=.o)
HOST_CFLAGS := -std=c11 -lbsg_manycore_runtime
HOST_CC := cc

$(HOST_TARGET): $(HOST_OBJS)
	$(HOST_CC) $(HOST_CFLAGS) $^ -o $@

$(HOST_OBJS): %.o: %.c
	$(HOST_CC) $(HOST_CFLAGS) -c $< -o $@


# Include bsg_manycore Make infrastructure.

bsg_tiles_X := 2
bsg_tiles_Y := 2

BSG_MANYCORE_DIR := $(wildcard /home/centos/bsg_bladerunner/bsg_manycore_*)
include $(BSG_MANYCORE_DIR)/software/mk/Makefile.dimensions
include $(BSG_MANYCORE_DIR)/software/mk/Makefile.paths
include $(BSG_MANYCORE_DIR)/software/mk/Makefile.builddefs


# Build device binary.

DEVICE_OBJS := $(DEVICE_SRCS:.c=.o)
DEVICE_OBJS_ALL := $(DEVICE_OBJS) $(BSG_MANYCORE_LIB_OBJS)
CRT_LIB := crt.o

$(DEVICE_TARGET): $(DEVICE_OBJS_ALL) $(CRT_LIB)
	$(RISCV_LINK) $(RISCV_LINK_OPTS) -L. $(DEVICE_OBJS_ALL) -o $@

$(DEVICE_OBJS_ALL): %.o: %.c
	$(RISCV_GCC) $(RISCV_GCC_OPTS) $(OPT_LEVEL) $(spmd_defs) -c $< -o $@
