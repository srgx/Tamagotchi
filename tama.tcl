#!/usr/bin/wish

oo::class create Tamagotchi {

  constructor {} {
  
    variable age -1
    variable totalTime 0
    variable weight 5
    variable discipline 0
    variable hungry 1
    variable happy 1
    
    variable eggScreens
    variable eggState 0
    
    variable babyScreens
    variable babyState 0

    my createEggscreens
    my createBabyScreens
    
  }
  
  method weight {} {
    variable weight
    return $weight
  }
  
  method phase {} {
  
    variable age
    
    if {$age < 0} {
      return egg
    } elseif {$age < 1} {
      return baby
    } else {
      return child
    }
    
  }
  
  method getBaseScreen {} {
    set screen {}
  
    set row {}
    for {set i 0} {$i < 32} {incr i} {
      lappend row 0
    }
    
    for {set i 0} {$i < 16} {incr i} {
      lappend screen $row
    }
    
    return $screen
  }
  
  method createBabyScreens {} {
  
    variable babyScreens
    
    set screen [my getBaseScreen]
    
    lset screen {15 13} 1
    
    lappend babyScreens $screen
    
    lset screen {15 13} 0
    lset screen {15 15} 1
    
    lappend babyScreens $screen
    
  }
  
  method createEggscreens {} {
  
    variable eggScreens
    
    set screen [my getBaseScreen]
    
    lset screen {6 14} 1
    lset screen {7 14} 1
    lset screen {8 14} 1
    lset screen {9 14} 1
    lset screen {10 14} 1
    
    lappend eggScreens $screen
    
    lset screen {6 14} 0
    lset screen {7 14} 0
    lset screen {8 14} 0
    lset screen {9 14} 0
    lset screen {10 14} 0
    
    lset screen {8 12} 1
    lset screen {8 13} 1
    lset screen {8 14} 1
    lset screen {8 15} 1
    lset screen {8 16} 1
    
    lappend eggScreens $screen
    
  }
  
  method update {} {
  
    variable totalTime
    variable age
  
    set cPhase [my phase]
    
    set scr {}
    
    switch $cPhase {
    
      egg {
      
        puts Egg
      
        variable eggScreens
        variable eggState
        
        set scr [lindex $eggScreens $eggState]
        
        if {0==$eggState} {
          set eggState 1
        } else {
          set eggState 0
        }

      }
      
      baby {
      
        puts Baby
        
        variable babyScreens
        variable babyState
        
        set scr [lindex $babyScreens $babyState]
      
        if {0==$babyState} {
          set babyState 1
        } else {
          set babyState 0
        }
        
      }
      
      child {
        puts Child
      }
      
    }
    
    incr totalTime
    
    if {$totalTime == 5 || $totalTime == 20} {
      incr age
    }
    
    return $scr
  
    
  }
  
}

oo::class create Console {

  constructor {} {
  
    variable currentOption 0
    variable options {none feed light game medicine bathroom meter discipline}
    variable state 0
    my createCanvas
    
  }

  
  method createCanvas {} {
  
    canvas .can
    .can configure -width 854
    .can configure -height 480
    
    pack .can
    wm title . "Tama"
  
    set numRows 16
    set numCols 32
  
    set squareSize 12
    
    set xPos 40
    set yPos 70

    set a $xPos ; set b $yPos ; set c [expr {$squareSize+$a}] ; set d [expr {$squareSize+$yPos}]

    for {set i 0} {$i < $numRows} {incr i} {

      for {set j 0} {$j < $numCols} {incr j} {
        .can create rect $a $b $c $d -outline black -fill red -tags "$i-$j"
        set a [expr {$a+$squareSize}]
        set c [expr {$c+$squareSize}]
      }
      
      set a $xPos
      set c [expr {$squareSize+$a}]
      set b [expr {$b+$squareSize}]
      set d [expr {$d+$squareSize}]
      
    }
    
    # Control buttons
    .can create oval 450 110 500 160 -outline purple -fill purple
    .can create oval 520 130 570 180 -outline purple -fill blue
    .can create oval 590 110 640 160 -outline purple -fill green
    
    # Icons
    .can create oval 40 10 90 60 -outline purple -fill yellow -tag feed
    .can create oval 140 10 190 60 -outline purple -fill yellow -tag light
    .can create oval 240 10 290 60 -outline purple -fill yellow -tag game
    .can create oval 340 10 390 60 -outline purple -fill yellow -tag medicine
    
    .can create oval 40 270 90 320 -outline purple -fill yellow -tag bathroom
    .can create oval 140 270 190 320 -outline purple -fill yellow -tag meter
    .can create oval 240 270 290 320 -outline purple -fill yellow -tag discipline
    .can create oval 340 270 390 320 -outline purple -fill yellow -tag attention
    
    bind . <1> {click %x %y}
    
  }
  
  method showCurrentOption {} {
    variable currentOption
    variable options
    puts "Current option: [lindex $options $currentOption]"
  }
  
  # Left button
  method select {} {
    puts "Selecting"
    variable currentOption
    variable options
    set opt [lindex $options $currentOption]
    if {$opt != "none"} { .can itemconfigure  $opt -fill yellow }
    set currentOption [expr {($currentOption+1)%8}]
    set opt [lindex $options $currentOption]
    if {$opt != "none"} { .can itemconfigure  $opt -fill black }
    my showCurrentOption
  }
  
  # Middle button
  method execute {} {
    variable currentOption
    variable options
    puts "Executing [lindex $options $currentOption]"
  }
  
  # Right button
  method cancel {} {
    puts "Cancel"
  }
  
  method update {} {
  
    variable state
    variable tamagotchi
    
    if {1==$state} {
      set tamagotchiImage [$tamagotchi update]
      my updateScreen $tamagotchiImage
    }
    
  }
  
  method updateScreen { tamagotchiData } {
    
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        if {[lindex $tamagotchiData $i $j]==1} {
          .can itemconfigure "$i-$j" -fill black
        } else {
          .can itemconfigure "$i-$j" -fill white
        }
      }
    }
    
  }
  
  method paper {} {
  
    variable state 1
    variable tamagotchi [Tamagotchi new]
    
  }
  
}

proc every {ms body} {
  eval $body; after $ms [namespace code [info level 0]]
}

proc click {x y} {
  
  global console
  
  if {$x < 200} {
    $console select
  } elseif {$x < 400} {
    $console execute
  } elseif {$x < 600} {
    $console cancel
  } else {
    $console paper
  }

}

set console [Console new]

every 500 {
  global console
  $console update
}
