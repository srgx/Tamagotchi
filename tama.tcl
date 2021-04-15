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
    variable babyScreens
    variable frame 0

    variable screen

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
  
  method createBabyScreens {} {
  
    variable babyScreens

    set baseTop { {9 12} {9 13} {9 14} {9 15}
                  {10 11} {10 13} {10 14} {10 16}
                  {11 11} {11 12} {11 13} {11 14} {11 15} {11 16}
                  {12 11} {12 12} {12 15} {12 16}
                  {13 11} {13 12} {13 13} {13 14} {13 15} {13 16}
                  {14 12} {14 13} {14 14} {14 15} }

    set baseBot { {13 12} {13 13} {13 14} {13 15}
                  {14 11} {14 13} {14 14} {14 16}
                  {15 10} {15 11} {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} }


    lappend babyScreens $baseTop
    lappend babyScreens [movePositions 2 $baseTop]
    lappend babyScreens [movePositions 4 $baseTop]
    lappend babyScreens [movePositions 6 $baseTop]
    lappend babyScreens [movePositions 6 $baseBot]
    lappend babyScreens [movePositions 8 $baseBot]
    lappend babyScreens [movePositions 6 $baseBot]
    lappend babyScreens [movePositions 4 $baseTop]
    lappend babyScreens [movePositions 2 $baseTop]
    lappend babyScreens $baseTop
    lappend babyScreens [movePositions -2 $baseTop]
    lappend babyScreens [movePositions -2 $baseBot]
    lappend babyScreens [movePositions -4 $baseBot]
    lappend babyScreens [movePositions -6 $baseBot]
    lappend babyScreens [movePositions -6 $baseTop]
    lappend babyScreens [movePositions -4 $baseTop]
    lappend babyScreens [movePositions -2 $baseTop]

  }
  
  method createEggscreens {} {
  
    variable eggScreens

    set a { {5 14} {5 15} {5 16} {5 17}
            {6 13} {6 15} {6 16} {6 17} {6 18}
            {7 12} {7 15} {7 16} {7 18} {7 19}
            {8 12} {8 14} {8 15} {8 16} {8 19}
            {9 11} {9 12} {9 13} {9 14} {9 15} {9 16} {9 17} {9 18} {9 19} {9 20}
            {10 11} {10 12} {10 13} {10 14} {10 17} {10 18} {10 19} {10 20}
            {11 11} {11 12} {11 13} {11 14} {11 17} {11 20}
            {12 11} {12 14} {12 15} {12 16} {12 17} {12 19} {12 20}
            {13 12} {13 15} {13 16} {13 17} {13 18} {13 19}
            {14 13} {14 14} {14 15} {14 18}
            {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} {15 18} {15 19} }

    set b {
            {5 14} {5 15} {5 16} {5 17}
            {6 13} {6 16} {6 17} {6 18}
            {7 12} {7 15} {7 16} {7 18} {7 19}
            {8 12} {8 13} {8 14} {8 15} {8 16} {8 19}
            {9 11} {9 12} {9 13} {9 14} {9 15} {9 16} {9 17} {9 19} {9 20}
            {10 11} {10 12} {10 13} {10 14} {10 17} {10 18} {10 19} {10 20}
            {11 11} {11 13} {11 14} {11 17} {11 20}
            {12 11} {12 14} {12 15} {12 16} {12 17} {12 19} {12 20}
            {13 12} {13 14} {13 15} {13 16} {13 17} {13 18} {13 19}
            {14 13} {14 14} {14 15} {14 18}
            {15 12} {15 13} {15 14} {15 15} {15 16} {15 17} {15 18} {15 19} }

    lappend eggScreens $a
    lappend eggScreens $b
    
  }
  
  method update {} {
  
    variable totalTime
    variable age
    variable screen
    variable frame
  
    set cPhase [my phase]
    
    switch $cPhase {
    
      egg {
      
        puts Egg
      
        variable eggScreens

        set screen [lindex $eggScreens $frame]
        
        if {0==$frame} {
          set frame 1
        } else {
          set frame 0
        }

      }
      
      baby {
      
        puts Baby
        
        variable babyScreens
        variable babyState
        
        set screen [lindex $babyScreens $frame]

        incr frame
        if {$frame >= [llength $babyScreens]} { set frame 0 }
        
      }
      
      child {
        puts Child
      }
      
    }
    
    incr totalTime
    
    if {$totalTime == 10} { incr age }

  }

  method getImage {} {
    variable screen
    return $screen
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
      $tamagotchi update
      my updateScreen $tamagotchi
    }
    
  }
  
  method updateScreen { tamagotchi } {

    set screen [$tamagotchi getImage]
    
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {

        if {"$i $j" in $screen} {
          .can itemconfigure "$i-$j" -fill black -outline black
        } else {
          .can itemconfigure "$i-$j" -fill white -outline white
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

proc movePositions {n lst} {
  set res {}
  foreach element $lst {
    lappend res "[lindex $element 0] [expr {[lindex $element 1]+$n}]"
  }
  return $res
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
