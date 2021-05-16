
oo::class create Console {

  constructor {} {

    variable currentOption 0
    variable options {none feed light game medicine bathroom meter discipline}

    # off, on, dark, foodmenu, lightmenu
    variable state off

    variable menuOption 0

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
    variable menuOption
    variable state
    global foodMenuScreens
    global lightMenuScreens
    variable tamagotchi

    if {$state=="on"||$state=="dark"} {

      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill yellow }
      set currentOption [expr {($currentOption+1)%8}]
      set opt [lindex $options $currentOption]
      if {$opt != "none"} { .can itemconfigure  $opt -fill black }
      my showCurrentOption

    } elseif {$state=="foodmenu"} {

      my toggleMenuOption
      puts $menuOption
      my updateScreen [lindex $foodMenuScreens $menuOption]

    } elseif {$state=="lightmenu"} {

      my toggleMenuOption
      puts $menuOption
      my updateScreen [lindex $lightMenuScreens $menuOption]

    } elseif {$state=="meter"} {
      $tamagotchi toggleMeter
    }

  }

  method toggleMenuOption {} {
    variable menuOption
    set menuOption [expr {$menuOption==0 ? 1 : 0}]
  }

  # Middle button
  method execute {} {

    global foodMenuScreens
    global lightMenuScreens
    variable currentOption
    variable options
    variable state
    variable menuOption
    variable tamagotchi

    set opt [lindex $options $currentOption]

    puts "Executing $opt"

    if {$state=="on"||$state=="dark"} {

      switch $opt {

        feed {
          set state foodmenu
          my updateScreen [lindex $foodMenuScreens 0]
        }

        light {
          set state lightmenu
          my updateScreen [lindex $lightMenuScreens 0]
        }

        medicine {
          $tamagotchi medicine
        }

        bathroom {
          $tamagotchi bathroom
        }

        meter {
          set state meter
          $tamagotchi meter
        }

        default {
          #
        }

      }
    } elseif {$state=="lightmenu"} {

      if {$menuOption==0} {
        set state "on"
      } else {
        set state "dark"
        my blackScreen
      }

    } elseif {$state=="foodmenu"} {
      $tamagotchi eat $menuOption
      set state "on"
    }

    set menuOption 0

  }

  # Right button
  method cancel {} {

    variable state
    variable tamagotchi

    puts "Cancel"

    if {$state=="foodmenu" || $state=="lightmenu"} {
      set state on
    } elseif {$state=="meter"} {
      set state on
      $tamagotchi normal
    }

  }

  method update {} {

    variable state
    variable tamagotchi

    if {$state!="off"} { $tamagotchi update }
    if {$state=="on"||$state=="meter"} { my updateScreen [$tamagotchi getImage] }

  }

  method blackScreen {} {
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        .can itemconfigure "$i-$j" -fill black -outline black
      }
    }
  }

  method updateScreen { scr } {
    for {set i 0} {$i < 16} {incr i} {
      for {set j 0} {$j < 32} {incr j} {
        if {"$i $j" in $scr} {
          .can itemconfigure "$i-$j" -fill black -outline black
        } else {
          .can itemconfigure "$i-$j" -fill white -outline white
        }
      }
    }
  }

  method paper {} {
    variable state "on"
    variable tamagotchi [Tamagotchi new]
  }

}

