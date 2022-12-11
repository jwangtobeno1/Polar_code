TOPNAME = func_type3
VCDNAME = simx

VERILATOR = verilator
SIMFLAGS = --trace
VERILATOR_CFLAGS += -MMD --build -cc \
				-I./vsrc \
				 -O3 --x-assign fast --x-initial fast --noassert

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)
INC_PATH = $(OBJ_DIR)

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

## project source
VSRCS = $(shell find $(abspath ./vsrc) -maxdepth 1 -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -maxdepth 1 -name "*.c" -or -name "*.cc" -or -name "*.cpp")

# rules for verilator
INCFLAGS = $(addprefix -I , $(INC_PATH))
## c++ compiler arguments for makefile
CFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""

$(BIN): $(VSRCS) $(CSRCS)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		-top $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

sim: $(VSRCS) $(CSRCS)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(SIMFLAGS) $(VERILATOR_CFLAGS) \
		-top $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

##因为第二条命令是在第一条命令的基础上运行，故应把这两条命令写在一行上，用分号分隔
run:
	cd build; ./$(TOPNAME)

gtk:
	gtkwave $(OBJ_DIR)/$(VCDNAME).vcd


clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean run


