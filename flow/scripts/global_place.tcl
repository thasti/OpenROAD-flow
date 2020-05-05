if {![info exists standalone] || $standalone} {
  # Read lef
  read_lef $::env(TECH_LEF)
  read_lef $::env(SC_LEF)
  if {[info exist ::env(ADDITIONAL_LEFS)]} {
    foreach lef $::env(ADDITIONAL_LEFS) {
      read_lef $lef
    }
  }

  # Read liberty files
  foreach libFile $::env(LIB_FILES) {
    read_liberty $libFile
  }

  # Read design files
  read_def $::env(RESULTS_DIR)/2_floorplan.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}
#set_wire_rc -layer $::env(WIRE_RC_LAYER)
FastRoute::add_layer_adjustment 2 $::env(FR_23)
FastRoute::add_layer_adjustment 3 $::env(FR_23)
FastRoute::add_layer_adjustment 4 $::env(FR_OTHER) 
FastRoute::add_layer_adjustment 5 $::env(FR_OTHER)
FastRoute::add_layer_adjustment 6 $::env(FR_OTHER)
FastRoute::add_layer_adjustment 7 $::env(FR_OTHER)
FastRoute::add_layer_adjustment 8 $::env(FR_OTHER)
FastRoute::add_layer_adjustment 9 $::env(FR_OTHER)
FastRoute::add_layer_adjustment 10 $::env(FR_OTHER) 

FastRoute::set_max_layer $::env(MAX_ROUTING_LAYER)
FastRoute::set_unidirectional_routing true

if {$::env(DISABLE_ROUTABILITY) eq "1"} {
  puts "nonRD Mode"
  global_placement -density $::env(PLACE_DENSITY) \
    -pad_left $::env(REPLACE_PAD) -pad_right $::env(REPLACE_PAD) -disable_routability_driven
} else {
  global_placement -density $::env(PLACE_DENSITY) \
    -pad_left $::env(REPLACE_PAD) -pad_right $::env(REPLACE_PAD)
}

if {![info exists standalone] || $standalone} {
  write_def $::env(RESULTS_DIR)/3_1_place_gp.def
  exit
}

source /home/mgwoo/95_openroad/OpenROAD/src/replace/test/report_hpwl.tcl
