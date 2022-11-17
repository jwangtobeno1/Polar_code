TOPNAME = light
NXDC_FILES = constr/light.nxdc
VCDNAME = simx
INC_PATH ?=
#verilator_cflags 有可能要加--trace(generate waveforms)
VERILATOR = verilator
SIMFLAGS = --trace
# -MMD Makefile need
VERILATOR_CFLAGS += -MMD --build -cc \
				 -O3 --x-assign fast --x-initial fast --noassert

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)

default: $(BIN)
	
$(shell mkdir -p $(BUILD_DIR))

## project source
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")

## rules for NVBoard
# include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
## c++ compiler arguments for makefile
CFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""
LDFLAGS += -lSDL2 -lSDL2_image

$(BIN): $(VSRCS) $(CSRCS)# $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		-top $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

sim: $(VSRCS) $(CSRCS)
	$(call git_commit, "sim RTL")
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(SIMFLAGS) $(VERILATOR_CFLAGS) \
		-top $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

##因为第二条命令是test在第一条命令的基础上运行，故应把这两条命令写在一行上，用分号分隔
run:
	cd build; ./$(TOPNAME) 

gtk:
	gtkwave $(OBJ_DIR)/$(VCDNAME).vcd


clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean run

include ../Makefile
