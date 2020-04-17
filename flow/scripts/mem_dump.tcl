yosys -import

# Setup verilog include directories
set vIdirsArgs ""
if {[info exist ::env(VERILOG_INCLUDE_DIRS)]} {
  foreach dir $::env(VERILOG_INCLUDE_DIRS) {
    lappend vIdirsArgs "-I$dir"
  }
  set vIdirsArgs [join $vIdirsArgs]
}


# read verilog files
foreach file $::env(VERILOG_FILES) {
  read_verilog -sv {*}$vIdirsArgs $file
}


# Read blackbox stubs of standard cells. This allows for standard cell (or
# structural netlist) support in the input verilog
read_verilog $::env(BLACKBOX_V_FILE)

# Apply toplevel parameters (if exist)
if {[info exist ::env(VERILOG_TOP_PARAMS)]} {
  dict for {key value} $::env(VERILOG_TOP_PARAMS) {
    chparam -set $key $value $::env(DESIGN_NAME)
  }
}


# Read platform specific mapfile for OPENROAD_CLKGATE cells
if {[info exist ::env(CLKGATE_MAP_FILE)]} {
  read_verilog $::env(CLKGATE_MAP_FILE)
}

# Use hierarchy to automatically generate blackboxes for known memory macro.
# Pins are enumerated for proper mapping
if {[info exist ::env(BLACKBOX_MAP_TCL)]} {
  source $::env(BLACKBOX_MAP_TCL)
}

prep -top $::env(DESIGN_NAME) -flatten
memory_unpack
memory -nomap

select t:\$mem

json -o $::env(RESULTS_DIR)/mem.json
