export PLATFORM     = tsmc65lp

# export DESIGN_NAME ?= sparc_core
# export VERILOG_FILES ?= ./opdb/OPDB/modules/sparc_core/L1I_16384_4__L1D_8192_4/sparc_core.pickle.v

export DESIGN_NAME ?= dynamic_node_top_wrap
export VERILOG_FILES ?= ./opdb/OPDB/modules/dynamic_node/NETWORK_2dmesh/dynamic_node.pickle.v

override VERILOG_FILES += $(shell find ./opdb/memory/ -type f -name '*.v')
export SDC_FILE      = ./opdb/design.sdc

$(info $(VERILOG_FILES))
export ADDITIONAL_LEFS = $(shell find ./opdb/memory/ -type f -name '*.lef')
export ADDITIONAL_LIBS = $(shell find ./opdb/memory/ -type f -name '*.lib')
# export ADDITIONAL_GDS  = $(wildcard ./opdb/memory/gds/*.gds)


export RUN_MACRO_PLACEMENT ?= 1

# These values must be multiples of placement site
# Global override Floorplan
export CORE_UTILIZATION = 30
export CORE_ASPECT_RATIO = 1
export CORE_MARGIN = 4


export CLOCK_PERIOD = 5.600
export CLOCK_PORT   = clk

export PLACE_DENSITY = 0.50
