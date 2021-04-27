
proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc movePositionsHorizontal {n lst} {
  set res {}
  foreach element $lst {
    lappend res "[lindex $element 0] [expr {[lindex $element 1]+$n}]"
  }
  return $res
}

proc movePositionsVertical {n lst} {
  set res {}
  foreach element $lst {
    lappend res "[expr {[lindex $element 0]+$n}] [lindex $element 1]"
  }
  return $res
}

proc loadImage {fileName} {
  set fp [open $fileName r]
  set fd [read $fp]
  close $fp

  set result {}
  for {set i 0} {$i < [llength $fd]} {incr i 2} {
    lappend result "[lindex $fd $i] [lindex $fd [expr {$i+1}]]"
  }

  return $result
}

proc click {x y} {

  global console

  .can create oval 450 110 500 160 -outline purple -fill purple
  .can create oval 520 130 570 180 -outline purple -fill blue
  .can create oval 590 110 640 160 -outline purple -fill green

  if {$x > 450 && $x < 500 && $y > 110 && $y < 160} {
    $console select
  } elseif {$x > 520 && $x < 570 && $y > 130 && $y < 180} {
    $console execute
  } elseif {$x > 590 && $x < 640 && $y > 110 && $y < 160} {
    $console cancel
  } else {
    $console paper
  }

}
