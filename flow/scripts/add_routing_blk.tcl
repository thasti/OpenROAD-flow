###################################################
# Create Routing Blockages around Macros for GF14 #
# Created by Minsoo Kim (mik226@eng.ucsd.edu)     #
###################################################
set db [::ord::get_db]
set block [[$db getChip] getBlock]
set tech [$db getTech]

set layer_M2 [$tech findLayer M2]
set layer_M3 [$tech findLayer M3]
set layer_C4 [$tech findLayer C4]

set numTrack 5

set allInsts [$block getInsts]

set cnt 0

foreach inst $allInsts {
  set master [$inst getMaster]
  set name [$master getName]

  if {[string match "*gf14*" $name]||[string match "IN12LP*" $name]} {
    set bbox [$inst getBBox]
    set loc_lx [$bbox xMin]
    set loc_ly [$bbox yMin]
    set loc_ux [$bbox xMax]
    set loc_uy [$bbox yMax]

    foreach layer [$tech getLayers] {
      if {[$layer getType] != "ROUTING"} {
        continue
      }

      set name [$layer getName]
      if {$name == "M2" || $name == "M3"} {
        set lx [expr $loc_lx - (128*$numTrack)]
        set ly [expr $loc_ly - (128*$numTrack)]
        set ux [expr $loc_ux + (128*$numTrack)]
        set uy [expr $loc_uy + (128*$numTrack)]
      } elseif {$name == "C4"} {
        set lx $loc_lx
        set ly [expr $loc_ly - (160*$numTrack)]
        set ux $loc_ux
        set uy [expr $loc_uy + (160*$numTrack)]
      } else {
        set lx $loc_lx
        set ly $loc_ly
        set ux $loc_ux
        set uy $loc_uy
      }
      odb::dbObstruction_create $block $layer $lx $ly $ux $uy

      incr cnt
    }
  }
}

if {$cnt != 0} {
  puts "\[INFO\] created $cnt routing blockages over macros"
}
