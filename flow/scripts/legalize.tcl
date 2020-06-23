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
  read_def $::env(RESULTS_DIR)/3_3_place_repaired.def
  read_sdc $::env(RESULTS_DIR)/2_floorplan.sdc
}

set_placement_padding -global \
    -left $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT) \
    -right $::env(CELL_PAD_IN_SITES_DETAIL_PLACEMENT)
detailed_placement
optimize_mirroring
check_placement -verbose


# Set res and cap
if [file exists platforms/$::env(PLATFORM)/setRC.tcl] {
  source platforms/$::env(PLATFORM)/setRC.tcl
} elseif {[info exists ::env(WIRE_RC_RES)] && [info exists ::env(WIRE_RC_CAP)]} {
  set_wire_rc -res $::env(WIRE_RC_RES) -cap $::env(WIRE_RC_CAP)
} else {
  set_wire_rc -layer $::env(WIRE_RC_LAYER)
}

report_checks
report_tns
report_wns
report_check_types -max_slew -max_capacitance -max_fanout -violators
report_design_area
puts "post_dp_slew_vio: [llength [string trim [psn::transition_violations]]]"
puts "post_dp_cap_vio: [llength [string trim [psn::capacitance_violations]]]"
puts "post_dp_inst_count: [sta::network_leaf_instance_count]"
puts "post_dp_pin_count: [sta::network_leaf_pin_count]"


if {![info exists standalone] || $standalone} {
  # write output
  write_def $::env(RESULTS_DIR)/3_4_place_legalized.def
  exit
}
